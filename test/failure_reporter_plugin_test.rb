require 'test_helper'

require 'minitest/failure_reporter_plugin'

class FailureReporterPluginTest < Minitest::Test
  def test_by_default_the_plugin_is_disabled
    opts = OptionParser.new
    options = {}

    Minitest.plugin_failure_reporter_options opts, options
    opts.parse('')

    assert_equal({}, options)
  end

  def test_setting_the_commandline_activates_the_plugin
    opts = OptionParser.new
    options = {}
    Minitest.plugin_failure_reporter_options opts, options
    opts.parse('--failure_reporter')

    assert_equal({ failure_reporter: true }, options)
  end

  def test_by_default_doesnt_include_the_repoter
    options = {}
    Minitest.reporter = []

    Minitest.plugin_failure_reporter_init(options)

    assert_equal [], Minitest.reporter
  end

  def test_when_enabled_adds_the_plugin_to_the_list_of_reporters
    options = { failure_reporter: true }
    Minitest.reporter = []

    Minitest.plugin_failure_reporter_init(options)

    assert_instance_of Minitest::FailureReporter::Reporter, Minitest.reporter[0]
  end

  def test_output_is_dumped_to_reportjson_by_default
    file_klass = Minitest::Mock.new
    options = { failure_reporter: true, file_klass: file_klass }
    Minitest.reporter = []

    file_klass.expect(:new, true, ['failure_file.json', 'w'])
    Minitest.plugin_failure_reporter_init(options)

    file_klass.verify
  end

  def test_output_is_dumped_to_specified_filename
    file_klass = Minitest::Mock.new
    options = { failure_reporter: true, failure_reporter_filename: 'somefile.json',
                file_klass: file_klass }
    Minitest.reporter = []

    file_klass.expect(:new, true, ['somefile.json', 'w'])
    Minitest.plugin_failure_reporter_init(options)

    file_klass.verify
  end

  def test_custom_filename_is_specified_by_a_flag
    opts = OptionParser.new
    options = {}

    Minitest.plugin_failure_reporter_options opts, options
    opts.parse('--failure_reporter-filename=somefile.json')

    assert_equal 'somefile.json', options[:failure_reporter_filename]
  end
end
