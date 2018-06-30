require 'rails_helper'
require 'rspec_api_documentation/dsl'
require 'knock'

resource 'Account' do
  header 'Accept', 'application/json'

  context 'Getting all accounts' do
    get 'api/accounts' do
      let!(:user) { create(:user) }
      let!(:first_account) { create(:account, user: user) }
      let!(:second_account) { create(:account, user: user) }

      let(:token) { (Knock::AuthToken.new payload: { sub: user.id }).token }
      header 'Authorization', :token

      example_request 'for current user' do
        json = JSON.parse(response_body)
        expect(status).to eq 200
        expect(response_body).to include('accounts')
        expect(json['accounts'].count).to eq(Account.count)
      end
    end

    get 'api/users' do
      example_request 'without auth token' do
        expect(status).to eq 401
        expect(response_body).to be_empty
      end
    end
  end

  context 'Getting certain account' do
    get 'api/accounts/:account_id' do
      let!(:user) { create(:user) }
      let!(:account) { create(:account, user: user) }
      let(:account_id) { account.id }
      let(:token) { (Knock::AuthToken.new payload: { sub: user.id }).token }
      header 'Authorization', :token

      example_request 'that belongs to current user' do
        json = JSON.parse(response_body)
        expect(json['account']['currency']).to eq account.currency
        expect(json['account']['balance']).to eq account.balance
        expect(status).to eq 200
      end
    end

    get 'api/accounts/:account_id' do
      let!(:user) { create(:user) }
      let(:token) { (Knock::AuthToken.new payload: { sub: user.id }).token }
      let!(:second_user) { create(:user) }
      let!(:account) { create(:account, user: second_user) }
      let(:account_id) { account.id }
      header 'Authorization', :token

      example_request 'that not belongs to current user' do
        json = JSON.parse(response_body)
        expect(json['errors']).to eq 'Not found'
      end
    end
  end

  context 'Getting account create action request' do
    post 'api/accounts' do
      with_options scope: :account, required: true do
        parameter :currency, 'Account currency'
      end
      let(:currency) { 'UAH' }

      example 'when noone logged-in' do
        expect { do_request }.not_to(change { Account.count })
        expect(status).to eq 401
      end
    end

    post 'api/accounts' do
      with_options scope: :account, required: true do
        parameter :currency, 'Account currency'
      end

      let!(:user) { create(:user) }
      let(:token) { (Knock::AuthToken.new payload: { sub: user.id }).token }
      let(:currency) { 'UAH' }

      header 'Authorization', :token

      example 'when user logged-in' do
        expect { do_request }.to change { Account.count }.by(1)
        expect(Account.where(user: user.id)).to exist
        expect(status).to eq 201
      end
    end
  end

  context 'Getting destroy action request' do
    delete 'api/accounts/:account_id' do
      header 'Authorization', :token

      let!(:user) { create(:user) }
      let!(:account) { create(:account, user: user) }
      let(:token) { (Knock::AuthToken.new payload: { sub: user.id }).token }
      let(:account_id) { account.id }

      example 'for certain user account' do
        expect(Account.where(user: user.id)).to exist
        do_request
        expect(Account.where(user: user.id)).not_to exist
        expect(status).to eq 200
      end
    end
  end

  context 'Transactions' do
    post 'api/accounts/:account_id/transaction' do
      with_options scope: :transaction, required: true do
        parameter :amount, 'Transaction amount'
        parameter :operation, 'Transaction operation'
      end
      header 'Authorization', :token

      let!(:user) { create(:user) }
      let!(:account) { create(:account, balance: 100) }
      let(:token) { (Knock::AuthToken.new payload: { sub: user.id }).token }

      let(:account_id) { account.id }
      let(:amount) { 100 }
      let(:operation) { 'Deposit' }

      example 'Deposit' do
        expect(Account.find(account.id).balance).to eq 100
        do_request
        expect(Account.find(account.id).balance).to eq 200
        expect(status).to eq 200
      end
    end

    post 'api/accounts/:account_id/transaction' do
      with_options scope: :transaction, required: true do
        parameter :amount, 'Transaction amount'
        parameter :operation, 'Transaction operation'
      end
      header 'Authorization', :token

      let!(:user) { create(:user) }
      let!(:account) { create(:account, balance: 100) }
      let(:token) { (Knock::AuthToken.new payload: { sub: user.id }).token }

      let(:account_id) { account.id }
      let(:amount) { 100 }
      let(:operation) { 'Withdraw' }

      example 'Withdraw' do
        expect(Account.find(account.id).balance).to eq 100
        do_request
        expect(Account.find(account.id).balance).to eq 0
        expect(status).to eq 200
      end
    end
  end
end
