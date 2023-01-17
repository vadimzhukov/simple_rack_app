require "rack"

class TimeFormatter
  ALLOWED_PARAMS = %w[year month day hour minute second]
  DATE_FORMAT = { year: '%Y', month: '%m', day: '%d', hour: '%H', minute: '%M', second: '%S' }

  def initialize(env)
    @env = env
  end

  def convert_format
    query_str = Rack::Utils.unescape(@env['QUERY_STRING'])
    params_key = query_str.split('=')[0]
    params_values_array = query_str.split('=')[1].split(',')
    if params_key == 'format' && (params_values_array & ALLOWED_PARAMS).count == params_values_array.count
      format_type = params_values_array.map { |i| i = DATE_FORMAT[i.to_sym] }.join('-')
      {status: 200, body: Time.now.strftime(format_type)}
    else
      {status: 400, body: "Unknown time format: #{params_values_array - ALLOWED_PARAMS}"}
    end
  end
end
