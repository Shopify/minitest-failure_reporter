require 'json'

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
          test_file_path: test_file,
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

      def has_failures?(test)
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
