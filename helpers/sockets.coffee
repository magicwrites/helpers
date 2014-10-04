http = require 'http'
express = require 'express'

socketio =
    server: require 'socket.io'
    client: require 'socket.io-client'



exports.getServer = (logger, port) ->
    application = express()
    server = http.Server application
    sockets = socketio.server server

    server.listen port, () ->
        logger.info 'listening on port *:%s', port

    exposed =
        instance: server
        sockets: sockets

exports.getClient = (logger, port, host = 'localhost', protocol = 'http') ->
    socket = socketio.client protocol + '://' + host + ':' + port

    exposed =
        socket: socket
