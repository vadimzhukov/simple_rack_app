class App
  ALLOWED_PARAMS = %w[year month day hour minute second]
  DATE_FORMAT = { year: '%Y', month: '%m', day: '%d', hour: '%H', minute: '%M', second: '%S' }
  PROTOCOL = 'HTTP/1.1'
  HOST = 'localhost:9292'
  PATH = '/time'
  METHOD = 'GET'

  def call(env)
    if check_request(env)
      status = set_status
      body = [request_convert(env)]
    else
      status = 404
      body = ['Bad request']
    end

    [status, headers, body]
  end

  private

  def check_request(env)
    check_protocol(env) && check_host(env) && check_path(env) && check_method(env)
  end

  def check_method(env)
    env['REQUEST_METHOD'] == METHOD
  end

  def check_path(env)
    env['PATH_INFO'] == PATH
  end

  def check_protocol(env)
    env['SERVER_PROTOCOL'] == PROTOCOL
  end

  def check_host(env)
    env['HTTP_HOST'] == HOST
  end

  def request_convert(env)
    query_str = Rack::Utils.unescape(env['QUERY_STRING'])
    params_key = query_str.split('=')[0]
    params_values_array = query_str.split('=')[1].split(',')
    if params_key == 'format' && (params_values_array & ALLOWED_PARAMS).count == params_values_array.count
      format_type = params_values_array.map { |i| i = DATE_FORMAT[i.to_sym] }.join('-')
      Time.now.strftime(format_type)
    else
      "Unknown time format: #{params_values_array - ALLOWED_PARAMS}"
    end
  end

  def set_status
    200
  end

  def headers
    { 'Content-type' => 'text/plain' }
  end
end
