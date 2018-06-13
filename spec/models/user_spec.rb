require 'rails_helper'

RSpec.describe User, type: :model do
  it { should have_many(:questions) }
  it { should have_many(:answers) }

  describe "#author_of?(resource)" do
    let(:user1) { create(:user) }
    let(:user2) { create(:user) }
    let(:question) { create(:question, user: user1) }

    it "user is an author of question" do
      expect(user1).to be_author_of(question)
    end
    it "user is not an author of question" do
      expect(user2).to_not be_author_of(question)
    end
  end

  describe '.find_for_oauth' do
    let!(:user) { create(:user) }
    let(:auth) { OmniAuth::AuthHash.new(provider: 'vkontakte', uid: '123456') }

    context 'user already was authorized' do
      it 'returns the user' do
        user.authorizations.create(provider: 'vkontakte', uid: '123456')
        expect(User.find_for_oauth(auth)).to eq user
      end
    end

    context 'user was not authorized' do
      context 'user already exists' do
        let(:auth) { OmniAuth::AuthHash.new(provider: 'vkontakte',
                                            uid: '123456',
                                            info: { email: user.email }
                                            ) }

        it 'does not creates new user' do
          expect { User.find_for_oauth(auth) }.to_not change(User, :count)
        end

        it 'creates authorization for user' do
          expect { User.find_for_oauth(auth) }.to change(user.authorizations, :count).by(1)
        end

        it 'creates authorization with provider and uid' do
          authorization = User.find_for_oauth(auth).authorizations.first

          expect(authorization.provider).to eq auth.provider
          expect(authorization.uid).to eq auth.uid
        end

        it 'returns the user' do
          expect(User.find_for_oauth(auth)).to eq user
        end
      end

      context 'user does not exist' do
        let(:auth) { OmniAuth::AuthHash.new(provider: 'vkontakte',
                                            uid: '123456',
                                            info: { email: 'new@user.com' }
                                            ) }

        it 'creates new user' do
          expect { User.find_for_oauth(auth) }.to change(User, :count).by(1)
        end

        it 'returns new user' do
          expect(User.find_for_oauth(auth)).to be_a(User)
        end

        it "fills user's email" do
          user = User.find_for_oauth(auth)
          expect(user.email).to eq auth.info.email
        end

        it 'creates authorization for user' do
          user = User.find_for_oauth(auth)
          expect(user.authorizations).to_not be_empty
        end

        it 'creates authorization with provider and uid' do
          authorization = User.find_for_oauth(auth).authorizations.first

          expect(authorization.provider).to eq auth.provider
          expect(authorization.uid).to eq auth.uid
        end
      end
    end
  end

  describe '#email_temp?' do
    let(:user) { create(:user) }
    let(:temp_user) { create(:user, email: 'user@email.temp') }

    it 'has a real email' do
      expect(user.email_temp?).to be_falsey
    end

    it 'has a temp email' do
      expect(temp_user.email_temp?).to be_truthy
    end
  end

  describe '#admin?' do
    let(:user) { create(:user) }
    let(:admin) { create(:admin) }

    it 'returns true for Admin' do
      expect(admin.admin?).to be_truthy
    end

    it 'returns false for User' do
      expect(user.admin?).to be_falsey
    end
  end

  describe '.send_daily_digest' do
    let(:users) { create_list(:user, 2) }

    it 'should send daily digest to all users' do
      users.each { |user| expect(DailyMailer).to receive(:digest).with(user).and_call_original }

      User.send_daily_digest
    end
  end
end
