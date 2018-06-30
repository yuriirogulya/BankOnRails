require 'rails_helper'
require 'rspec_api_documentation/dsl'
require 'knock'

resource 'User' do
  header 'Accept', 'application/json'

  context 'Token' do
    post 'api/auth' do
      let!(:user) { create(:user, email: 'testmail@gmail.com', password: 'password') }
      with_options scope: :auth, required: true do
        parameter :email, 'Email'
        parameter :password, 'Password'
      end
      let(:email)    { user.email }
      let(:password) { user.password }
      response_field :jwt, 'JWT auth token'

      example_request 'Getting JWT for auth' do
        expect(response_body).not_to be_nil
        expect(status).to eq 201
        expect(response_body).to include('jwt')
      end
    end
  end

  context 'Getting all users' do
    get 'api/users' do
      let!(:user)   { create(:user, role: 'admin') }
      let!(:user2)  { create(:user) }
      let(:token)   { (Knock::AuthToken.new payload: { sub: user.id }).token }
      header 'Authorization', :token

      example_request 'with admin rights' do
        json = JSON.parse(response_body)
        expect(status).to eq 200
        expect(response_body).to include('users')
        expect(json['users'].count).to eq(User.count)
      end
    end

    get 'api/users' do
      let!(:user) { create(:user, role: 'user') }
      let(:token) { (Knock::AuthToken.new payload: { sub: user.id }).token }
      header 'Authorization', :token

      example 'without admin rights' do
        expect { do_request }.to raise_error(CanCan::AccessDenied)
      end
    end

    get 'api/users' do
      example_request 'without auth token' do
        expect(status).to eq 401
        expect(response_body).to be_empty
      end
    end
  end

  context 'Getting certain user' do
    get 'api/profile' do
      let!(:user) { create(:user) }
      let(:token) { (Knock::AuthToken.new payload: { sub: user.id }).token }
      header 'Authorization', :token

      example_request "by 'profile' link" do
        json = JSON.parse(response_body)
        expect(json['user']['username']).to eq user.username
        expect(json['user']['email']).to eq user.email
        expect(status).to eq 200
      end
    end

    get 'api/users/:user_id' do
      let!(:admin_user)    { create(:user, role: 'admin') }
      let!(:nonadmin_user) { create(:user) }
      let(:user_id)        { nonadmin_user.id }
      let(:token)          { (Knock::AuthToken.new payload:{ sub: admin_user.id }).token }
      header 'Authorization', :token

      example_request 'with admin role' do
        json = JSON.parse(response_body)
        expect(json['user']['username']).to eq nonadmin_user.username
        expect(json['user']['email']).to eq nonadmin_user.email
        expect(status).to eq 200
      end
    end

    get 'api/users/:user_id' do
      let!(:user)        { create(:user) }
      let!(:second_user) { create(:user) }
      let(:token)        { (Knock::AuthToken.new payload: { sub: user.id }).token }
      let(:user_id)      { second_user.id }
      header 'Authorization', :token

      example 'with user role' do
        expect { do_request }.to raise_error(CanCan::AccessDenied)
      end
    end
  end

  context 'Getting user create action request' do
    post 'api/users' do
      with_options scope: :user, required: true do
        parameter :username, 'Username'
        parameter :email, 'Email'
        parameter :password, 'Password'
        parameter :role, 'Permission role'
      end
      let(:email)    { 'testtest@gmail.com' }
      let(:username) { 'test' }
      let(:password) { 'testpassword' }
      let(:role)     { 'admin' }

      example_request 'when noone logged-in' do
        expect(User.where(username: username)).to exist
        expect(User.find_by(username: username).role).not_to eq('admin')
        expect(status).to eq 201
      end
    end

    post 'api/users' do
      with_options scope: :user, required: true do
        parameter :username, 'Username'
        parameter :email, 'Email'
        parameter :password, 'Password'
        parameter :role, 'Permission role'
      end

      let!(:admin_user) { create(:user, role: 'admin') }
      let(:token) { (Knock::AuthToken.new payload: { sub: admin_user.id }).token }
      let(:email) { 'username@gmail.com' }
      let(:username) { 'username' }
      let(:password) { 'password' }
      let(:role) { 'admin' }
      header 'Authorization', :token

      example 'with admin rights' do
        expect { do_request }.to change { User.count }.by(1)
        expect(User.where(username: username)).to exist
        expect(User.find_by(username: username).role).to eq('admin')
        expect(status).to eq 201
      end
    end

    post 'api/users' do
      with_options scope: :user, required: true do
        parameter :username, 'Username'
        parameter :password, 'Password'
      end
      let(:username) { 'usernametest' }
      let(:password) { 'password' }

      example 'with missed params' do
        expect { do_request }.to change { User.count }.by(0)
        json = JSON.parse(response_body)
        expect(User.where(username: username)).not_to exist
        expect(json['errors']).to be
        expect(status).to eq 500
      end
    end
  end

  context 'Getting update action request' do
    put 'api/users/:user_id' do
      let!(:admin_user) { create(:user, role: 'admin') }
      let!(:user) { create(:user, username: old_username) }
      let(:token) { (Knock::AuthToken.new payload: { sub: admin_user.id }).token }
      let(:new_username) { 'cool_username' }
      let(:old_username) { 'old_username' }
      header 'Authorization', :token

      with_options scope: :user, required: true do
        parameter :email, 'Email'
        parameter :username, 'Username'
        parameter :password, 'Password'
      end
      let(:user_id) { user.id }
      let(:username) { new_username }

      example_request 'for certain user by admin' do
        expect(User.where(username: old_username)).not_to exist
        expect(User.where(username: new_username)).to exist
        expect(status).to eq 200
        expect(response_body).not_to include('errors')
      end
    end

    put 'api/users/:user_id' do
      let!(:user) { create(:user, email: old_email) }
      let(:token) { (Knock::AuthToken.new payload: { sub: user.id }).token }
      let(:old_email) { 'old_email@gmail.com' }
      let(:new_email) { 'new_email@gmail.com' }
      header 'Authorization', :token

      with_options scope: :user, required: true do
        parameter :email, 'Email'
        parameter :username, 'Username'
        parameter :password, 'Password'
      end
      let(:user_id) { user.id }
      let(:email) { new_email }

      example_request 'for own profile' do
        expect(User.where(email: old_email)).not_to exist
        expect(User.where(email: new_email)).to exist
        expect(status).to eq 200
        expect(response_body).not_to include('errors')
      end
    end

    put 'api/users/:user_id' do
      let!(:user1) { create(:user) }
      let!(:user2) { create(:user, email: old_email) }
      let(:old_email) { 'old_email@gmail.com' }
      let(:new_email) { 'new_email@gmail.com' }
      let(:token) { (Knock::AuthToken.new payload: { sub: user1.id }).token }
      header 'Authorization', :token

      with_options scope: :user, required: true do
        parameter :email, 'Email'
        parameter :username, 'Username'
        parameter :password, 'Password'
      end
      let(:user_id) { user2.id }
      let(:email) { new_email }

      example 'for another user with no admin rights' do
        expect { do_request }.to raise_error(CanCan::AccessDenied)
        expect(User.where(email: old_email)).to exist
      end
    end
  end
end
