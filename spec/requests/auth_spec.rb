require 'swagger_helper'

RSpec.describe 'Auth API', type: :request do
  path '/register' do
    post('register user') do
      tags 'Auth'
      consumes 'application/json'
      parameter name: :user, in: :body, schema: {
        type: :object,
        properties: {
          user: {
            type: :object,
            properties: {
              name: { type: :string },
              email: { type: :string },
              password: { type: :string },
              password_confirmation: { type: :string }
            },
            required: [ 'name', 'email', 'password', 'password_confirmation' ]
          }
        }
      }
      response(201, 'created') do
        let(:user) { { user: { name: 'Test', email: 'test@example.com', password: 'password', password_confirmation: 'password' } } }
        run_test!
      end
      response(422, 'unprocessable entity') do
        let(:user) { { user: { name: '', email: '', password: '', password_confirmation: '' } } }
        run_test!
      end
    end
  end

  path '/login' do
    post('login user') do
      tags 'Auth'
      consumes 'application/json'
      parameter name: :email, in: :query, type: :string, required: true
      parameter name: :password, in: :query, type: :string, required: true
      response(200, 'ok') do
        let(:email) { 'test@example.com' }
        let(:password) { 'password' }

        before do
          # Create the user first
          User.create!(name: 'Test User', email: 'test@example.com', password: 'password', password_confirmation: 'password')
        end

        run_test!
      end
      response(401, 'unauthorized') do
        let(:email) { 'wrong@example.com' }
        let(:password) { 'wrong' }
        run_test!
      end
    end
  end
end
