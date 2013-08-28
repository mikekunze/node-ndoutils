class Ndoutils
  constructor: (@settings)->

    Database = require('./Database.coffee');
    @db = new Database(@settings)

  connect: ()->
    @db.connect()
    return @

  end: ()->
    @db.end()
    return @

  getServiceDetailsByHost: (cb)->
    self = this
    @getHosts (err, rows, fields)->
      if err
        console.log err
        return

      hosts = {}

      rows.forEach (row)->
        hosts[row.display_name] = {}
        hosts[row.display_name].current_state = row.current_state
        hosts[row.display_name].services = []

      self.getServiceDetails (err, rows, fields)->
        if err
          console.log err
          return

        if rows.length <= 0
          cb(null, {})
          return

        for id of rows
          hosts[rows[id].host_display_name].services.push rows[id]

        cb(null, hosts)

    return @

  getHosts: (cb)->
    query =  ""
    query += "SELECT h.display_name, hs.current_state "

    query += "FROM nagios_hosts h "
    query += "  left join nagios_hoststatus hs "

    query += "ON h.host_object_id = hs.host_object_id"

    @db.connection.query query, (err, rows, fields)->
      cb(err, rows, fields)

    return @

  getServices: (cb)->
    query = ""
    query += "SELECT nh.display_name as host_display_name, "
    query += "  nh.host_object_id, ns.service_id, nh.address, "
    query += "  ns.display_name as service_display_name "

    query += "FROM `nagios_services` as ns "
    query += "  left join nagios_hosts as nh "

    query += "ON ns.host_object_id = nh.host_object_id"

    @db.connection.query query, (err, rows, fields)->
      cb(err, rows, fields)

    return @

  getServiceDetails: (cb)->
    query = ""
    query += "SELECT "
    query += "  ss.current_state      as service_current_state,      "
    query += "  hs.current_state      as host_current_state,         "
    query += "  nh.display_name       as host_display_name,          "
    query += "  ns.display_name       as service_display_name,       "
    query += "  nh.address            as host_address,               "
    query += "  hs.status_update_time as host_status_update_time,    "
    query += "  hs.output             as host_output,                "
    query += "  ss.status_update_time as service_status_update_time, "
    query += "  ss.output             as service_output              "

    query += "FROM "
    query += "  nagios_services                as ns "
    query += "  LEFT JOIN nagios_hosts         as nh ON ns.host_object_id = nh.host_object_id       "
    query += "  LEFT JOIN nagios_hoststatus    as hs ON ns.host_object_id = hs.host_object_id       "
    query += "  LEFT JOIN nagios_servicestatus as ss ON ns.service_object_id = ss.service_object_id "

    @db.connection.query query, (err, rows, fields)->
      cb(err, rows, fields)

    return @




module.exports = Ndoutils