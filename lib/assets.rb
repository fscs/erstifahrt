require 'sinatra/base'

module Erstifahrt
  class Assets < Sinatra::Base
    set :public_folder, 'assets/dist/'

    get '*', provides: 'html' do
      send_file File.join settings.public_folder, 'index.html'
    end
  end
end
