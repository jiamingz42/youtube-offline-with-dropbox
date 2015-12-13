# Setup the Redis server URL

if ENV["REDISCLOUD_URL"]
  $redis = Resque.redis = Redis.new(:url => ENV["REDISCLOUD_URL"])
else
  $reids = Resque.redis = Redis.new
end

# Setup the status expiration time

Resque::Plugins::Status::Hash.expire_in = (24 * 60 * 60) # 24hrs in seconds
