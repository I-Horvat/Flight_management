# == Schema Information
#
# Table name: users
#
#  id              :bigint           not null, primary key
#  email           :string           not null
#  first_name      :string           not null
#  last_name       :string
#  password_digest :string
#  role            :string
#  token           :string           not null
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#
# Indexes
#
#  index_users_on_email        (email) UNIQUE
#  index_users_on_lower_email  (lower((email)::text)) UNIQUE
#  index_users_on_token        (token) UNIQUE
#
RSpec.describe User, type: :model do
  let(:user) { FactoryBot.build(:user) }

  describe 'validations' do
    it { is_expected.to validate_presence_of(:email) }

    it { expect(user).to validate_uniqueness_of(:email).case_insensitive }

    it { is_expected.to allow_value('user@example.com').for(:email) }
    it { is_expected.not_to allow_value('invalid-email').for(:email) }

    it { is_expected.to validate_presence_of(:first_name) }
    it { is_expected.to validate_length_of(:first_name).is_at_least(2) }

    it 'is valid with valid attributes' do
      expect(user).to be_valid
    end
  end

  describe 'password change' do
    let(:user) { create(:user, password: 'old_password') }

    context 'with valid new password' do
      it 'changes the password' do
        expect do
          user.update(password: 'new_password')
        end.to(change { user.reload.password_digest })
      end
    end

    context 'with a blank new password' do
      it 'does not change the password' do
        expect do
          user.update(password: '')
        end.not_to(change { user.reload.password_digest })
      end
    end

    context 'with a nil password' do
      it 'does not change the password' do
        expect do
          user.update(password: nil)
        end.not_to(change { user.reload.password_digest })
      end
    end
  end
end
