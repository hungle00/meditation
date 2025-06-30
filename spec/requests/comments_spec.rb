require 'swagger_helper'

RSpec.describe 'Comments API', type: :request do
  path '/thread_posts/{thread_post_id}/comments' do
    parameter name: :thread_post_id, in: :path, type: :string, description: 'ThreadPost ID'

    get('list comments') do
      tags 'Comments'
      produces 'application/json'
      response(200, 'successful') do
        let(:thread_post_id) { '1' }
        run_test!
      end
    end

    post('create comment') do
      tags 'Comments'
      consumes 'application/json'
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
        let(:thread_post_id) { '1' }
        let(:comment) { { user_id: 1, content: 'Sample comment' } }
        run_test!
      end
    end
  end

  path '/thread_posts/{thread_post_id}/comments/{id}' do
    parameter name: :thread_post_id, in: :path, type: :string, description: 'ThreadPost ID'
    parameter name: :id, in: :path, type: :string, description: 'Comment ID'

    delete('delete comment') do
      tags 'Comments'
      response(204, 'no content') do
        let(:thread_post_id) { '1' }
        let(:id) { '1' }
        run_test!
      end
    end
  end
end
