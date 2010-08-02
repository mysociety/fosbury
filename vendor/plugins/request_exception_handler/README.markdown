RequestExceptionHandler
=======================

Rails is not capable of calling Your exception handlers when an error occurs
during the parsing of request parameters (e.g. in case of invalid XML body).

This will hopefully change in Rails 3, but until then I've created this plugin
that monkey-patches request parameter parsing to allow more flexibility when
handling parsing errors. The plugin has been tested on 2.3.x, 2.2.3 and 2.1.x
but should work with any Rails 2.x version.


Install
=======

Installable as a plain-old rails plugin:

    ./script/plugin install git://github.com/kares/request_exception_handler.git

Example
=======

The plugin hooks into request parameter parsing and allows a request to be
constructed even if the params can not be parsed from the submited content.
A before filter is installed that checkes for a request exception and re-raises
it thus it seems to Rails that the exception comes from the application code and
is processed as all other "business" exceptions, You might skip this filter and
install Your own to handle such cases :

    class MyController < ApplicationController

      skip_before_filter :check_request_exception # filter the plugin installed

      # custom before filter use request_exception to detect occured errors
      before_filter :return_409_on_json_errors

      private

        def return_409_on_json_errors
          if re = request_exception && re.is_a?(ActiveSupport::JSON::ParseError)
            head 409
          else
            head 500
          end
        end

    end

Another option of how to modify the returned 500 status is to use exception
handlers the same way You're (hopefully) using them for Your own exceptions :

    class ApplicationController < ActionController::Base

      rescue_from 'REXML::ParseException' do |exception|
        render :text => exception.to_s, :status => 422
      end

    end

[http://blog.kares.org/search/label/request_exception_handler](http://blog.kares.org/search/label/request_exception_handler)
