require 'rails_helper'

RSpec.describe Vote, type: :model do
  describe 'validations' do
    it { should belong_to(:voter).class_name('User') }
    it { should belong_to(:votable) }
  end

  describe 'polymorphic associations' do
    let(:user) { create(:user) }
    let(:thread_post) { create(:thread_post) }
    let(:comment) { create(:comment) }

    it 'can vote on a thread post' do
      vote = create(:vote, votable: thread_post, voter: user)
      expect(vote.votable).to eq(thread_post)
      expect(vote.votable_type).to eq('ThreadPost')
      expect(thread_post.votes).to include(vote)
    end

    it 'can vote on a comment' do
      vote = create(:vote, votable: comment, voter: user)
      expect(vote.votable).to eq(comment)
      expect(vote.votable_type).to eq('Comment')
      expect(comment.votes).to include(vote)
    end
  end

  describe 'user associations' do
    let(:user) { create(:user) }
    let(:thread_post) { create(:thread_post) }

    it 'belongs to a voter (user)' do
      vote = create(:vote, votable: thread_post, voter: user)
      expect(vote.voter).to eq(user)
      expect(user.votes).to include(vote)
    end
  end

  describe 'uniqueness' do
    let(:user) { create(:user) }
    let(:thread_post) { create(:thread_post) }

    it 'allows one vote per user per votable' do
      create(:vote, votable: thread_post, voter: user)
      expect {
        create(:vote, votable: thread_post, voter: user)
      }.to raise_error(ActiveRecord::RecordInvalid)
    end

    it 'allows same user to vote on different votables' do
      comment = create(:comment)
      create(:vote, votable: thread_post, voter: user)
      expect {
        create(:vote, votable: comment, voter: user)
      }.not_to raise_error
    end
  end

  describe 'cascading deletes' do
    let(:user) { create(:user) }
    let(:thread_post) { create(:thread_post) }

    it 'deletes votes when user is deleted' do
      vote = create(:vote, votable: thread_post, voter: user)
      expect {
        user.destroy
      }.to change { Vote.count }.by(-1)
    end

    it 'deletes votes when thread post is deleted' do
      vote = create(:vote, votable: thread_post, voter: user)
      expect {
        thread_post.destroy
      }.to change { Vote.count }.by(-1)
    end

    it 'deletes votes when comment is deleted' do
      comment = create(:comment)
      vote = create(:vote, votable: comment, voter: user)
      expect {
        comment.destroy
      }.to change { Vote.count }.by(-1)
    end
  end
end
