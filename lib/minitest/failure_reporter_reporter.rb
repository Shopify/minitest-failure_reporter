require 'json'
require 'pathname'

module Minitest
  module FailureReporter
    class Reporter
      def initialize(io, options)
        @io = io
        @results = []
        @options = options
      end

      def passed?
        true
      end

      def start; end

      def record(result)
        if has_failures?(result)
          @results << result
        end
      end

      def report
        failures = @results.map { |test| format(test) }.to_json
        @io.puts(failures)
      end

      def format(test)
        test_file, test_line = test.source_location
        {
          test_file_path: normalize_file_path(test_file),
          test_line: test_line,
          test_id: "#{test.klass}##{test.name}",
          test_name: test.name,
          test_suite: test.klass,
          error_class: test.failure.exception.class.name,
          error_message: full_error_message(test),
          output: full_error_message(test),
        }
      end

      private

      def normalize_file_path(file_path)
        project_root  = Pathname.new(Dir.pwd)
        Pathname.new(file_path).relative_path_from(project_root).to_s
      end

      def has_failures?(test)
        return false if test.skipped?

        !test.failures.empty? || test.error?
      end

      def full_error_message(test)
        [message(test), *backtrace(test)].join("\n")
      end

      def message(test)
        error = test.failure
        if error.is_a?(UnexpectedError)
          "#{error.exception.class}: #{error.exception.message}"
        else
          error.exception.message
        end
      end

      def backtrace(test)
        test.failure.backtrace.join("\n")
      end
    end
  end
end
