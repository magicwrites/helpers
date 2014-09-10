_ = require 'lodash'

environment = require './environment'



exports.get = (directory) ->
    configuration = require directory + '/' + environment.get() + '.json'
