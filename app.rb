require_relative "time_formatter"
class App
  
  PROTOCOL = 'HTTP/1.1'
  HOST = 'localhost:9292'
  PATH = '/time'
  METHOD = 'GET'

  def call(env)
    if check_request(env)
      time = TimeFormatter.new(env)
      status = time.convert_format[:status]
      body = [time.convert_format[:body]]
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

  def headers
    { 'Content-type' => 'text/plain' }
  end
end
