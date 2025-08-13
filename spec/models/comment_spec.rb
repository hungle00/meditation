require 'rails_helper'

RSpec.describe Comment, type: :model do
  describe 'validations' do
    it { should validate_presence_of(:content) }
    it { should belong_to(:thread_post) }
    it { should belong_to(:user) }
  end

  describe 'associations' do
    it { should have_many(:subcomments).dependent(:destroy) }
    it { should have_many(:votes).dependent(:destroy) }
    it { should belong_to(:parent).optional }
  end

  describe 'nested comments' do
    let(:thread_post) { create(:thread_post) }
    let(:user) { create(:user) }
    let(:parent_comment) { create(:comment, thread_post: thread_post, user: user) }

    it 'can have subcomments' do
      subcomment = create(:comment, thread_post: thread_post, user: user, parent: parent_comment)
      expect(parent_comment.subcomments).to include(subcomment)
      expect(subcomment.parent).to eq(parent_comment)
    end

    it 'can have multiple levels of nesting' do
      subcomment = create(:comment, thread_post: thread_post, user: user, parent: parent_comment)
      sub_subcomment = create(:comment, thread_post: thread_post, user: user, parent: subcomment)

      expect(parent_comment.subcomments).to include(subcomment)
      expect(subcomment.subcomments).to include(sub_subcomment)
    end
  end

  describe 'votes' do
    let(:comment) { create(:comment) }
    let(:user) { create(:user) }

    it 'can receive votes' do
      vote = create(:vote, votable: comment, voter: user)
      expect(comment.votes).to include(vote)
      expect(vote.votable).to eq(comment)
    end

    it 'can count votes' do
      3.times { create(:vote, votable: comment, voter: create(:user)) }
      expect(comment.votes.count).to eq(3)
    end
  end

  describe 'counter cache' do
    let(:thread_post) { create(:thread_post) }

    it 'increments comments_count on thread_post when comment is created' do
      expect {
        create(:comment, thread_post: thread_post)
      }.to change { thread_post.reload.comments_count }.by(1)
    end

    it 'decrements comments_count on thread_post when comment is destroyed' do
      comment = create(:comment, thread_post: thread_post)
      expect {
        comment.destroy
      }.to change { thread_post.reload.comments_count }.by(-1)
    end
  end
end
