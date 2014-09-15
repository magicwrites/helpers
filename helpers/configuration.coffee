_ = require 'lodash'

environment = require './environment'



configurations = {}

getFromFile = (modulePath, configurationPath) ->
    configuration = require modulePath + '/' + configurationPath + '/' + environment.get() + '.json'

exports.get = (module, modulePath, configurationPath) ->
    if not configurations[module] then configurations[module] = getFromFile modulePath, configurationPath
    configuration = configurations[module]

exports.set = (module, configuration) ->
    configurations[module] = configuration

