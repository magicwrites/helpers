util = require 'util'
_ = require 'lodash'

environment = require './environment'



jsonize = (someObject) ->
    jsonizedObject = JSON.stringify someObject, null, 4

output = (level, message) ->
    switch level
        when 'info' then console.info 'info  : ' + message
        when 'error' then console.error 'error : ' + message



exports.info = (messageTemplate, var1, var2, var3) ->
    if environment.get() isnt 'test'
        var1 = if _.isObject var1 then jsonize var1 else var1
        var2 = if _.isObject var2 then jsonize var2 else var2
        var3 = if _.isObject var3 then jsonize var3 else var3

        if var3
            message = util.format messageTemplate, var1, var2, var3
            output 'info', message
            return null

        if var2
            message = util.format messageTemplate, var1, var2
            output 'info', message, var1, var2
            return null

        if var1
            message = util.format messageTemplate, var1
            output 'info', message, var1
            return null

        if messageTemplate
            output 'info', messageTemplate
            return null



exports.error = (error) ->
    output 'error', jsonize error
