class Database
  constructor: (@settings)->
    @mysql = require 'mysql'

  connect: ()->
    mysql = @settings.mysql
    @connection = @mysql.createConnection
      host     : mysql.host
      user     : mysql.user
      password : mysql.pass
      database : mysql.db

    @connection.connect (err)->
      if err
        console.log err

      else
        console.log "Connected to MYSQL db: #{mysql.db}"

  end: ()->
    mysql = @settings.mysql
    console.log "Closing connection to MYSQL db: #{mysql.db}"
    @connection.end()


module.exports = Database