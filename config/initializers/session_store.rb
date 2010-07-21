# Be sure to restart your server when you modify this file.

# Your secret key for verifying cookie session data integrity.
# If you change this key, all old sessions will become invalid!
# Make sure the secret is at least 30 characters and all random, 
# no regular words or you'll be exposed to dictionary attacks.
ActionController::Base.session = {
  :key         => '_fosbury_session',
  :secret      => 'a72f47ca96bb594319501262404cab54941426ef3ab19f42128869f5ac0c12e7e23b6b48e0668d9ccff7e51e5440a31dc8afb9e72334179accd1037c9cc0fce3'
}

# Use the database for sessions instead of the cookie-based default,
# which shouldn't be used to store highly confidential information
# (create the session table with "rake db:sessions:create")
# ActionController::Base.session_store = :active_record_store
