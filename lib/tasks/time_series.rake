namespace :time_series  do
  desc "Run time series merge"
  task :merge, [:source, :destination, :file_extension] do |t, args|
    TimeSeriesMerge::Runner.new(args).run
  end
end