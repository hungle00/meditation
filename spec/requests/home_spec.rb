require 'swagger_helper'

RSpec.describe 'Home API', type: :request do
  path '/home' do
    get 'List all thread posts' do
      tags 'Home'
      produces 'application/json'
      parameter name: :page, in: :query, type: :integer, required: false, description: 'Page number'
      parameter name: :per_page, in: :query, type: :integer, required: false, description: 'Items per page'

      response '200', 'thread posts retrieved' do
        schema type: :object,
               properties: {
                 thread_posts: {
                   type: :array,
                   items: {
                     type: :object,
                     properties: {
                       id: { type: :integer },
                       title: { type: :string },
                       content: { type: :string },
                       user_id: { type: :integer },
                       created_at: { type: :string, format: 'date-time' },
                       updated_at: { type: :string, format: 'date-time' },
                       comments_count: { type: :integer },
                       user: {
                         type: :object,
                         properties: {
                           id: { type: :integer },
                           name: { type: :string }
                         }
                       }
                     }
                   }
                 },
                 current_page: { type: :integer },
                 total_pages: { type: :integer },
                 total_count: { type: :integer }
               }

        let(:user) { create(:user) }
        let!(:thread_post) { create(:thread_post, user: user) }
        let!(:comment) { create(:comment, thread_post: thread_post, user: user) }

        run_test!
      end
    end
  end
end
