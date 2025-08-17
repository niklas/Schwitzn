require 'bundler/setup'

require 'parslet'
require 'active_support/core_ext/class/attribute'

$LOAD_PATH.push File.expand_path('..', __FILE__)
require 'distance'
require 'duration'
require 'comment'
require 'bike_entry'
require 'parser'
require 'make_graph'
