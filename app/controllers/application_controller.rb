class ApplicationController < ActionController::Base
end

DOMAIN
def default_url_options
{ host: ENV[“DOMAIN”] || “localhost:3000” }
end
