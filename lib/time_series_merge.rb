require "active_support/all"

RAILS_ENV = ENV['RAILS_ENV'] || 'development'
GEM_ROOT = File.join(File.dirname(__FILE__), '../')
LOGFILE_PATH = File.join(GEM_ROOT, 'log', "#{RAILS_ENV}.log")
LOGGER = ActiveSupport::TaggedLogging.new(Logger.new(LOGFILE_PATH))

module TimeSeriesMerge

end

require "time_series_merge/version"
require "time_series_merge/pipe"
require "time_series_merge/action/base"
require "time_series_merge/action/merge"
require "time_series_merge/action/sort"
require "time_series_merge/action/group"
require "time_series_merge/runner"
