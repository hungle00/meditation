require 'rails_helper'

RSpec.describe Saved, type: :model do
  describe 'validations' do
    it { should belong_to(:user) }
    it { should belong_to(:savable) }
  end

  describe 'polymorphic associations' do
    let(:user) { create(:user) }
    let(:thread_post) { create(:thread_post) }
    let(:comment) { create(:comment) }

    it 'can save a thread post' do
      saved = create(:saved, user: user, savable: thread_post)
      expect(saved.savable).to eq(thread_post)
      expect(saved.savable_type).to eq('ThreadPost')
      expect(thread_post.saveds).to include(saved)
    end

    it 'can save a comment' do
      saved = create(:saved, user: user, savable: comment)
      expect(saved.savable).to eq(comment)
      expect(saved.savable_type).to eq('Comment')
      expect(comment.saveds).to include(saved)
    end
  end

  describe 'uniqueness' do
    let(:user) { create(:user) }
    let(:thread_post) { create(:thread_post) }

    it 'allows one save per user per savable' do
      create(:saved, user: user, savable: thread_post)
      expect {
        create(:saved, user: user, savable: thread_post)
      }.to raise_error(ActiveRecord::RecordInvalid)
    end

    it 'allows same user to save different savables' do
      comment = create(:comment)
      create(:saved, user: user, savable: thread_post)
      expect {
        create(:saved, user: user, savable: comment)
      }.not_to raise_error
    end

    it 'allows different users to save the same savable' do
      other_user = create(:user)
      create(:saved, user: user, savable: thread_post)
      expect {
        create(:saved, user: other_user, savable: thread_post)
      }.not_to raise_error
    end
  end


  describe 'scopes and queries' do
    let(:user) { create(:user) }
    let(:thread_post) { create(:thread_post) }
    let(:comment) { create(:comment) }

    before do
      create(:saved, user: user, savable: thread_post)
      create(:saved, user: user, savable: comment)
    end

    it 'can find saved by savable type' do
      expect(user.saveds.where(savable_type: 'ThreadPost').count).to eq(1)
      expect(user.saveds.where(savable_type: 'Comment').count).to eq(1)
    end

    it 'can find all saved thread posts' do
      saved_thread_posts = user.saveds.where(savable_type: 'ThreadPost').map(&:savable)
      expect(saved_thread_posts).to include(thread_post)
    end

    it 'can find all saved comments' do
      saved_comments = user.saveds.where(savable_type: 'Comment').map(&:savable)
      expect(saved_comments).to include(comment)
    end
  end
end
