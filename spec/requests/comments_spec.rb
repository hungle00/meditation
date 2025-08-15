require 'swagger_helper'

RSpec.describe 'Comments API', type: :request do
  let(:user) { create(:user) }
  let(:thread_post) { create(:thread_post, user: user) }
  let(:jwt_token) { JWT.encode({ user_id: user.id }, Rails.application.credentials.secret_key_base) }

  path '/thread_posts/{thread_post_id}/comments' do
    parameter name: :thread_post_id, in: :path, type: :string, description: 'ThreadPost ID'

    get('list comments') do
      tags 'Comments'
      produces 'application/json'
      response(200, 'successful') do
        let(:thread_post_id) { thread_post.id }
        run_test!
      end
    end

    post('create comment') do
      tags 'Comments'
      consumes 'application/json'
      security [ bearerAuth: [] ]
      parameter name: :comment, in: :body, schema: {
        type: :object,
        properties: {
          user_id: { type: :integer },
          content: { type: :string },
          parent_id: { type: :integer, nullable: true }
        },
        required: [ 'user_id', 'content' ]
      }
      response(201, 'created') do
        let(:Authorization) { "Bearer #{jwt_token}" }
        let(:thread_post_id) { thread_post.id }
        let(:comment) { { user_id: user.id, content: 'Sample comment' } }
        run_test!
      end
    end
  end

  path '/thread_posts/{thread_post_id}/comments/{id}' do
    parameter name: :thread_post_id, in: :path, type: :string, description: 'ThreadPost ID'
    parameter name: :id, in: :path, type: :string, description: 'Comment ID'

    delete('delete comment') do
      tags 'Comments'
      security [ bearerAuth: [] ]
      response(204, 'no content') do
        let(:Authorization) { "Bearer #{jwt_token}" }
        let(:thread_post_id) { thread_post.id }
        let(:id) { create(:comment, thread_post: thread_post, user: user).id }
        run_test!
      end
    end
  end
end
