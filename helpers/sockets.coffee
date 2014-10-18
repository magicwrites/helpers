express = require 'express'
http = require 'http'
util = require 'util'
q = require 'q'

socketio =
    server: require 'socket.io'
    client: require 'socket.io-client'



exports.getServer = (port, logger) ->
    deferred = q.defer()

    if logger then logger.info 'getting server sockets on port %s', port

    application = express()
    server = http.Server application
    sockets = socketio.server server

    exposed =
        instance: server
        sockets: exports.extend sockets

    server.listen port, () ->
        if logger then logger.info 'got server sockets established on port *:%s', port
        deferred.resolve exposed

    return deferred.promise



exports.getClient = (port, logger, host = 'localhost') ->
    if logger then logger.info 'getting socket client on port %s', port

    socket = socketio.client host + ':' + port

    socket.once 'connect', () ->
        if logger then logger.info 'got client socket established on port %s', port

    exposed =
        socket: exports.extend socket, logger



exports.extend = (emitter, logger) ->
    originalFunctions =
        emit: emitter.emit

    emitter.emit = (eventName, data) ->
        dataJsonized = if data then JSON.stringify data else 'no data'
        message = util.format 'emitted %s, %s', eventName, dataJsonized

        if logger then logger.info message
        originalFunctions.emit.apply emitter, arguments

    emitter.when = (defined) ->
        if not defined then throw new Error 'emitter.when is missing definition'
        if not defined.event then throw new Error 'emitter.when is missing tested event'
        if not defined.passes then throw new Error 'emitter.when is missing event data tester'
        if not defined.then then throw new Error 'emitter.when is missing callback function'

        emitter.once defined.event, (data) ->
            if defined.passes data then defined.then data else emitter.when defined

    emitter.upon = (defined) ->
        if not defined then throw new Error 'emitter.upon is missing definition'
        if not defined.event then throw new Error 'emitter.upon is missing request event'
        if not defined.perform then throw new Error 'emitter.upon is missing request performer method'
        if not defined.thenRespond then throw new Error 'emitter.upon is missing response event'

        emitter.on defined.event, (request) ->
            promiseOfAuthorization = if defined.withAuthorizer then defined.withAuthorizer request else { isAuthorized: yes }

            promiseOfPerforming = q
                .when promiseOfAuthorization
                .then (response) ->
                    promise = if response.isAuthorized then defined.perform request else throw new Error 'unauthorized'

            promiseOfResponse = q
                .when promiseOfPerforming
                .then (response) ->
                    emitter.emit defined.thenRespond, response
                .catch (error) ->
                    request.error = error.message
                    emitter.emit defined.thenRespond, request

    return emitter
