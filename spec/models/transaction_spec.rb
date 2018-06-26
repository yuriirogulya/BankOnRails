require 'rails_helper'

RSpec.describe Transaction, type: :model do
  context 'scopes' do
    let!(:user1) { create(:user) }
    let!(:user2) { create(:user) }
    let!(:account1) { create(:account, user: user1) }
    let!(:account2) { create(:account, user: user2) }
    let!(:transaction1) { create(:transaction, account: account1) }
    let!(:transaction2) { create(:transaction, account: account2) }

    describe 'responds' do
      it 'should have all the scopes' do
        expect(Transaction).to respond_to(:by_user_id)
        expect(Transaction).to respond_to(:by_account_id)
      end
    end

    describe '.by_user_id' do
      it 'return transactions for certain user' do
        expect(Transaction.by_user_id(user1).count).to eq(1)
      end
    end

    describe '.by_account_id' do
      it 'return transactions for certain user account' do
        expect(Transaction.by_account_id(account2.id).count).to eq(1)
      end
    end
  end
end