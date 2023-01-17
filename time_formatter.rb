require "rack"

class TimeFormatter
  ALLOWED_PARAMS = %w[year month day hour minute second]
  DATE_FORMAT = { year: '%Y', month: '%m', day: '%d', hour: '%H', minute: '%M', second: '%S' }

  def initialize(env)
    @env = env
    query_str = Rack::Utils.unescape(@env['QUERY_STRING'])
    @params_key = query_str.split('=')[0]
    @params_values_array = query_str.split('=')[1].split(',')
  end

  def current_time_formatted(delimeter)
    Time.nowformat(delimeter)
  end

  def unknown_time_format
    "Unknown time format: #{params_values_array - ALLOWED_PARAMS}"
  end


  def time_format_correct?
    @params_key == 'format' && (params_values_array & ALLOWED_PARAMS).count == params_values_array.count
  end

  def format(delimeter)
    @params_values_array.map { |i| i = DATE_FORMAT[i.to_sym] }.join(delimeter)
  end

end
