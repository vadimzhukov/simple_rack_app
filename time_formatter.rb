require 'rack'

class TimeFormatter
  DATE_FORMAT = { 'year' => '%Y', 'month' => '%m', 'day' => '%d', 'hour' => '%H', 'minute' => '%M', 'second' => '%S' }

  def initialize(env)
    @env = env
  end

  def call
    query_str = Rack::Utils.unescape(@env['QUERY_STRING'])
    @params_key = query_str.split('=')[0]
    @params_values_array = query_str.split('=')[1].split(',')
  end

  def success?
    @params_key == 'format' && (@params_values_array & DATE_FORMAT.keys).count == @params_values_array.count
  end

  def current_time_string
    Time.now.strftime(format_time)
  end

  def invalid_string
    "Unknown time format: #{@params_values_array - DATE_FORMAT.keys}"
  end

  private

  def format_time
    @params_values_array.map { |i| i = DATE_FORMAT[i] }.join('-')
  end
end
