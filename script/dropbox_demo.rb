require File.expand_path('../../config/environment', __FILE__)
require File.expand_path('../../vendor/dropbox_sdk/lib/dropbox_sdk.rb', __FILE__)

# Get your app key and secret from the Dropbox developer website
APP_KEY = 'ty6ns268utylw0q'
APP_SECRET = '465q1ig1n5h7ja2'

flow = DropboxOAuth2FlowNoRedirect.new(APP_KEY, APP_SECRET)
authorize_url = flow.start()

# Have the user sign in and authorize this app
puts '1. Go to: ' + authorize_url
puts '2. Click "Allow" (you might have to log in first)'
puts '3. Copy the authorization code'
print 'Enter the authorization code here: '
code = gets.strip

# This will fail if the user gave us an invalid authorization code
access_token, user_id = flow.finish(code)
puts "access_token: #{access_token}"

client = DropboxClient.new(access_token)
puts "linked account:", client.account_info().inspect
