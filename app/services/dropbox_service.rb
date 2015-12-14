require_relative '../../vendor/dropbox_sdk/lib/dropbox_sdk.rb'

# Assume the access_token is available
class DropboxService < Delegator

  def initialize(access_token)
    super
    @delegate_sd_obj = DropboxClient.new(access_token)
  end

  def __getobj__
    @delegate_sd_obj # return object we are delegating to, required
  end

  def __setobj__(obj)
    @delegate_sd_obj = obj
  end

  # Example
  # @service.save_url(path, url)

end
