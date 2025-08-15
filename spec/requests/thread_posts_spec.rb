require 'swagger_helper'

RSpec.describe 'ThreadPosts API', type: :request do
  let(:user) { create(:user) }
  let(:jwt_token) { JWT.encode({ user_id: user.id }, Rails.application.credentials.secret_key_base) }

  path '/thread_posts' do
    get('list thread_posts') do
      tags 'ThreadPosts'
      produces 'application/json'
      response(200, 'successful') do
        run_test!
      end
    end

    post('create thread_post') do
      tags 'ThreadPosts'
      consumes 'application/json'
      security [ bearerAuth: [] ]
      parameter name: :thread_post, in: :body, schema: {
        type: :object,
        properties: {
          user_id: { type: :integer },
          title: { type: :string },
          content: { type: :string }
        },
        required: [ 'user_id', 'title', 'content' ]
      }
      response(201, 'created') do
        let(:Authorization) { "Bearer #{jwt_token}" }
        let(:thread_post) { { user_id: user.id, title: 'Sample', content: 'Sample content' } }
        run_test!
      end
    end
  end

  path '/thread_posts/{id}' do
    parameter name: :id, in: :path, type: :string, description: 'id'

    get('show thread_post') do
      tags 'ThreadPosts'
      produces 'application/json'
      response(200, 'successful') do
        let(:id) { create(:thread_post, user: user).id }
        run_test!
      end
    end

    put('update thread_post') do
      tags 'ThreadPosts'
      consumes 'application/json'
      security [ bearerAuth: [] ]
      parameter name: :thread_post, in: :body, schema: {
        type: :object,
        properties: {
          user_id: { type: :integer },
          title: { type: :string },
          content: { type: :string }
        },
        required: [ 'user_id', 'title', 'content' ]
      }
      response(200, 'successful') do
        let(:Authorization) { "Bearer #{jwt_token}" }
        let(:id) { create(:thread_post, user: user).id }
        let(:thread_post) { { user_id: user.id, title: 'Updated', content: 'Updated content' } }
        run_test!
      end
    end

    delete('delete thread_post') do
      tags 'ThreadPosts'
      security [ bearerAuth: [] ]
      response(204, 'no content') do
        let(:Authorization) { "Bearer #{jwt_token}" }
        let(:id) { create(:thread_post, user: user).id }
        run_test!
      end
    end
  end
end
