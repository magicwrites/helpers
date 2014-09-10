_ = require 'lodash'



current = null;

environments = [
    'development'
    'publishment'
    'test'
]



exports.get = () ->
    starting = if _.contains environments, process.env.environment then process.env.environment else environments[0]
    current = current or starting

exports.set = (value) ->
    newEnvironment = if _.contains environments, value then value else environments[0]
    current = newEnvironment
