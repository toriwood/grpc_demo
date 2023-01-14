this_dir = File.expand_path(File.dirname(__FILE__))
lib_dir = File.join(this_dir, 'lib')
$LOAD_PATH.unshift(lib_dir) unless $LOAD_PATH.include?(lib_dir)

require 'grpc'
require './users/get_user_command'
require './lib/user_services_pb'

# UserServer is simple server that implements the Users service.
class UserServer < Users::Service
  # get_user implements the GetUser rpc method.
  def get_user(get_user_req, _unused_call)
    user = Users::GetUserCommand.get_user(get_user_req.email)
    if user
      GetUserRespProto.new(
        user: {
          id: user[:id],
          name: user[:name],
          email: user[:email]
        }
      )
    else
      raise GRPC::BadStatus.new(GRPC::Core::StatusCodes::NOT_FOUND, "User not found")
    end
  end
end

# main starts an RpcServer that receives requests to UserServer at the sample
# server port.
def main
  s = GRPC::RpcServer.new
  s.add_http2_port('0.0.0.0:50051', :this_port_is_insecure)
  s.handle(UserServer)
  # Runs the server with SIGHUP, SIGINT and SIGTERM signal handlers to
  #   gracefully shutdown.
  # User could also choose to run server via call to run_till_terminated
  s.run_till_terminated_or_interrupted([1, 'int', 'SIGTERM'])
end

main