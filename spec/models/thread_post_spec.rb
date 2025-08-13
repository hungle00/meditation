require 'rails_helper'

RSpec.describe ThreadPost, type: :model do
  describe 'validations' do
    it { should validate_presence_of(:title) }
    it { should validate_presence_of(:content) }
    it { should belong_to(:user) }
  end

  describe 'associations' do
    it { should have_many(:comments).dependent(:destroy) }
    it { should have_many(:votes).dependent(:destroy) }
  end

  describe 'scopes' do
    describe '.thread_with_comments' do
      let!(:thread_with_comments) { create(:thread_post) }
      let!(:comment) { create(:comment, thread_post: thread_with_comments) }
      let!(:thread_without_comments) { create(:thread_post) }

      it 'returns only threads with comments' do
        expect(ThreadPost.thread_with_comments).to include(thread_with_comments)
        expect(ThreadPost.thread_with_comments).not_to include(thread_without_comments)
      end
    end
  end

  describe 'class methods' do
    describe '.comments_by_thread' do
      let!(:thread1) { create(:thread_post) }
      let!(:thread2) { create(:thread_post) }

      it 'returns comments grouped by thread with counts and IDs' do
        # Create comments for thread1
        comment1 = create(:comment, thread_post: thread1)
        comment2 = create(:comment, thread_post: thread1)

        # Create comment for thread2
        comment3 = create(:comment, thread_post: thread2)

        result = ThreadPost.comments_by_thread

        expect(result[thread1.id]).to include(
          number_of_comments: 2,
          comment_ids: [ comment1.id, comment2.id ]
        )
        expect(result[thread2.id]).to include(
          number_of_comments: 1,
          comment_ids: [ comment3.id ]
        )
      end

      it 'excludes threads without comments' do
        thread_without_comments = create(:thread_post)

        result = ThreadPost.comments_by_thread
        expect(result.keys).not_to include(thread_without_comments.id)
      end
    end

    describe '.latest_comments_per_thread' do
      let!(:thread1) { create(:thread_post) }
      let!(:thread2) { create(:thread_post) }

      it 'returns latest 3 comments per thread' do
        # Create 4 comments for thread1 (should return latest 3)
        comment1 = create(:comment, thread_post: thread1)
        comment2 = create(:comment, thread_post: thread1)
        comment3 = create(:comment, thread_post: thread1)
        comment4 = create(:comment, thread_post: thread1)

        # Create 2 comments for thread2 (should return both)
        comment5 = create(:comment, thread_post: thread2)
        comment6 = create(:comment, thread_post: thread2)

        result = ThreadPost.latest_comments_per_thread

        # Should return latest 3 comments for thread1 (comment4, comment3, comment2)
        expect(result[thread1.id]).to eq([ comment4, comment3, comment2 ])

        # Should return both comments for thread2 (comment6, comment5)
        expect(result[thread2.id]).to eq([ comment6, comment5 ])
      end

      it 'returns empty array for threads without comments' do
        thread_without_comments = create(:thread_post)

        result = ThreadPost.latest_comments_per_thread

        expect(result[thread_without_comments.id]).to eq([])
      end
    end

    describe '.most_popular_comments_per_thread' do
      let!(:thread1) { create(:thread_post) }
      let!(:thread2) { create(:thread_post) }

      it 'returns top 3 most popular comments per thread' do
        # Create comments with different vote counts
        comment1 = create(:comment, thread_post: thread1)
        comment2 = create(:comment, thread_post: thread1)
        comment3 = create(:comment, thread_post: thread2)

        # Add 5 votes to comment1 (from different users)
        5.times { create(:vote, votable: comment1, voter: create(:user)) }
        # Add 3 votes to comment2 (from different users)
        3.times { create(:vote, votable: comment2, voter: create(:user)) }
        # Add 7 votes to comment3 (from different users)
        7.times { create(:vote, votable: comment3, voter: create(:user)) }

        result = ThreadPost.most_popular_comments_per_thread
        expect(result[thread1.id]).to include(comment1, comment2)
        expect(result[thread2.id]).to include(comment3)
      end
    end
  end
end
