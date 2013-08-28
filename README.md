node-ndoutils
=============

Data Structure Wrapper, Uses mysql node driver as its dependency


### Using node-ndoutils
I will eventually publish this on npm, but for now, use NPM link

    $ git clone https://github.com/mikekunze/node-ndoutils.git
    $ cd node-ndoutils
    $ sudo npm link

With it linked, you can use it in your project:

    settings = 
      mysql:
        user: "node"
        pass: "password"
        host: "localhost"
        db:   "ndoutils"
        
    Ndoutils = require 'node-ndoutils'
    
    ndoutils = new Ndoutils(settings)
    

Next, connect the database.
    
    ndoutils.connect()
    
    
getServiceDetailsByHost is a prototype function of the Ndoutils class that pulls a multi-left-joined query
from the ndoutils database.  When you are done using the instance, be sure to close the db connection.

    ndoutils.getServiceDetailsByHost (err, hostsObj)->
      if err
        console.log err
      else
        console.log util.inspect(obj, false, depth=4)
        
      ndoutils.end()
      
The final datastructure looks something like this.  The "..." indicates a continuation:
```javascript
{
  hostname1: {
      current_state: 0
      services: [
          {
              service_current_state      : 0,
              host_current_state         : 0,
              host_display_name          : "hostname1",
              service_display_name       : "HTTPD",
              host_address               : "192.168.3.115",
              host_status_update_time    : "Tue Aug 20 2013 08:07:45 GMT-0500 (CDT)",
              host_output                : "PING OK - Packet loss = 0%, RTA = 0.05 ms",
              service_status_update_time : "Tue Aug 20 2013 08:08:25 GMT-0500 (CDT)",
              service_output             : "HTTP OK: HTTP/1.0 200 OK - 17119 bytes in 0.001 second response time",
          },
          {
              ...
          }
      ]
  },
  hostname2: {
      current_state: 0
      services: [...]
  },
  hostname3: {
      current_state: 0
      services: [...]
  },
  ...
}
```
