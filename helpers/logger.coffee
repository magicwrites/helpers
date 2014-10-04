moment = require 'moment'
util = require 'util'
chalk = require 'chalk'
_ = require 'lodash'



exports.mute = null

exports.info = (message) ->
    parameters = _.flatten arguments
    parameters = parameters.slice 1

    if not _.isEmpty parameters then message = util.format message, parameters

    date = moment().format 'DD-MM-YYYY HH:mm:ss'
    prefix = date + ' - i'
    prefixStyled = chalk.blue prefix

    if exports.mute isnt 'info' and exports.mute isnt 'all' then console.info '%s - %s', prefixStyled, message
