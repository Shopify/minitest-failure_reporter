require "test_helper"

require 'minitest/failure_reporter_reporter'

require 'stringio'
require 'time'

class Minitest::FailureReporterTest < Minitest::Test
  def test_that_it_has_a_version_number
    refute_nil ::Minitest::FailureReporter::VERSION
  end

  def test_no_tests_generates_an_empty_suite
    reporter = create_reporter

    reporter.report

    assert_equal '[]', reporter.output.strip
  end

  def test_formats_each_result_with_a_formatter
    reporter = create_reporter
    10.times.map do |i|
      result = create_test_result("test_name#{i}")
      if i % 2 == 0
        result.failures << create_error(Minitest::Skip)
      end
      reporter.record result
      result
    end

    reporter.report

    assert_equal 5, JSON.parse(reporter.output).count
  end

  # foo

  def test_all_tests_generate_testcase_tag
    test = create_test_result
    test.failures << create_error(Minitest::Skip)
    reporter = create_reporter

    result = reporter.format(test)

    assert_equal(test.name, result[:test_name])
  end

  private

  def create_error(klass)
    fail klass, "A #{klass} failure"
  rescue klass => e
    e
  end

  def create_test_result(name = 'ATestClass')
    test = Class.new Minitest::Test do
      # define_method 'class' do
      #   self
      # end
    end.new 'test_method_name'
    test.time = a_number
    test.assertions = a_number
    Minitest::Result.from(test)
  end

  def a_number
    rand(100)
  end

  def create_reporter(options = {})
    io = StringIO.new ''
    reporter = Minitest::FailureReporter::Reporter.new io, options
    def reporter.output
      @io.string
    end
    reporter.start
    reporter
  end
end
