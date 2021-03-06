require 'prawn'
require 'sinatra/base'
require 'sinatra/json'

require_relative './config'
require_relative './api/models/student'
require_relative './api/models/trip'
require_relative './api/resources/student'
require_relative './api/resources/trip'

require_relative './api/authentication'
require_relative './api/mailer'

require_relative './api/sinatra/auth'

module Erstifahrt::Api
  class App < Sinatra::Base
    register Sinatra::Config

    helpers Sinatra::Auth

    helpers Sinatra::Mailer

    use Authentication

    app_config

    set :serializer, {
      Student: Erstifahrt::Api::Serializers::SerializableStudent,
      Trip: Erstifahrt::Api::Serializers::SerializableTrip
    }

    get '/trips' do
      trip = Trip.first
      json render_jsonapi trip, include: :students
    end

    get '/students' do
      protect!
      json render_jsonapi Student.all
    end

    get '/students/:id' do
      protect!
      student = Student.find(params[:id])
      json render_jsonapi student, include: :trip
    end

    patch '/students/:id' do
      protect!
      payload = JSON.parse(request.body.read)["data"]
      serialized = Deserializer::StudentDeserializer.call(payload)
      student = Student.find payload["id"]
      student.update! serialized

      json render_jsonapi student
    end

    post '/students' do
      payload = JSON.parse(request.body.read)["data"]
      serialized = Deserializer::StudentDeserializer.call(payload)
      student = Student.create! serialized
      welcome student
      jsonapi_student = render_jsonapi student
      jsonapi_student[:data][:id] = 'neuanmeldung'
      jsonapi_student[:data][:attributes].delete :registration_sheet_url
      json jsonapi_student
    end

    private

    def render_jsonapi model, options =  {}
      options[:class] ||= settings.serializer
      options[:expose] = { app: self }.merge(options[:expose] || {})
      renderer.render(model, options)
    end

    def renderer
      settings.renderer
    end
  end
end
