this_dir = File.expand_path(File.dirname(__FILE__))
lib_dir = File.join(this_dir, 'lib')
$LOAD_PATH.unshift(lib_dir) unless $LOAD_PATH.include?(lib_dir)

require 'grpc'
require 'json'
require './lib/user_services_pb'

def main
  email = ARGV.size > 0 ?  ARGV[0] : ''
  hostname = ARGV.size > 1 ?  ARGV[1] : 'localhost:50051'
  stub = Users::Stub.new(hostname, :this_channel_is_insecure)
  begin
    response = stub.get_user(GetUserReqProto.new(email: email))
    p "User: #{response.user}"
  rescue GRPC::BadStatus => e
    abort "ERROR: #{e.message}"
  end
end

main