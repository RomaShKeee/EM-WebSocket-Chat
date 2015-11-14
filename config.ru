require 'middleman/rack'
require 'daemons'

Daemons.run('server.rb')
run Middleman.server
