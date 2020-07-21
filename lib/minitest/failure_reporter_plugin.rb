require "minitest/failure_reporter/version"
require "minitest/failure_reporter_reporter"

module Minitest
  def self.plugin_failure_reporter_options(opts, options)
    opts.on '--failure-reporter', 'Generate a failure json report' do
      options[:failure_reporter] = true
    end
    opts.on '--failure-reporter-filename=OUT', 'Target output filename.'\
                                    ' Defaults to failure_file.json' do |out|
      options[:failure_reporter_filename] = out
    end
  end

  def self.plugin_failure_reporter_init(options)
    return unless options.delete :failure_reporter
    file_klass = options.delete(:file_klass) || File
    filename = options.delete(:failure_reporter_filename) || 'failure_file.json'
    io = file_klass.new(filename, 'w')
    reporter << FailureReporter::Reporter.new(io, options)
  end
end
