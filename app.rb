require_relative "time_formatter"
class App
  
  PROTOCOL = 'HTTP/1.1'
  PATH = '/time'
  METHOD = 'GET'

  def call(env)
    if check_request(env)
      time = TimeFormatter.new(env)
      if time.time_format_correct?
        status = 200
        body = [time.current_time_formatted("-")]
      else
        status = 400
        body = [time.unknown_time_format]
      end
    else
      status = 404
      body = ['Bad request']
    end
    
    response(status, headers, body) 
  end

  private

  def response(status, headers,body)
    [status, headers, body] 
  end

  def check_request(env)
    check_protocol(env) && check_path(env) && check_method(env)
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

  def headers
    { 'Content-type' => 'text/plain' }
  end
end
