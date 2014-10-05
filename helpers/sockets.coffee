http = require 'http'
express = require 'express'

socketio =
    server: require 'socket.io'
    client: require 'socket.io-client'



exports.getServer = (logger, port) ->
    if not port then port = logger else isLoggerProvided = yes
    
    application = express()
    server = http.Server application
    sockets = socketio.server server

    server.listen port, () ->
        if isLoggerProvided then logger.info 'listening on port *:%s', port

    exposed =
        instance: server
        sockets: sockets

exports.getClient = (logger, port, host = 'localhost', protocol = 'http') ->
    if not port then port = logger
    
    socket = socketio.client protocol + '://' + host + ':' + port
