require 'rails_helper'

RSpec.describe User, type: :model do
  describe 'validations' do
    it { should validate_presence_of(:name) }
    it { should validate_presence_of(:email) }
  end

  describe 'associations' do
    it { should have_many(:threads).class_name('ThreadPost').dependent(:destroy) }
    it { should have_many(:comments).dependent(:destroy) }
    it { should have_many(:votes).dependent(:destroy) }
  end

  describe 'password' do
    it 'has secure password' do
      user = User.new(name: 'Test User', email: 'test@example.com', password: 'password123')
      expect(user).to be_valid
      expect(user.password_digest).to be_present
    end

    it 'validates password confirmation' do
      user = User.new(name: 'Test User', email: 'test@example.com', password: 'password123', password_confirmation: 'different')
      expect(user).not_to be_valid
    end
  end

  describe 'instance methods' do
    let(:user) { create(:user) }

    it 'can create a thread post' do
      thread = user.threads.create(title: 'Test Thread', content: 'Test content')
      expect(thread).to be_valid
      expect(user.threads).to include(thread)
    end

    it 'can create a comment' do
      thread = create(:thread_post)
      comment = user.comments.create(thread_post: thread, content: 'Test comment')
      expect(comment).to be_valid
      expect(user.comments).to include(comment)
    end

    it 'can create a vote' do
      thread = create(:thread_post)
      vote = user.votes.create(votable: thread)
      expect(vote).to be_valid
      expect(user.votes).to include(vote)
    end
  end
end
