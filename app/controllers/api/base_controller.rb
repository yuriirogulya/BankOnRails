module Api
  class BaseController < ActionController::API
    include Knock::Authenticable

    rescue_from ActiveRecord::RecordNotFound, with: :not_found
    rescue_from ActionController::ParameterMissing, with: :bad_request
    before_action :authenticate_user
    before_action :skip_session

    # JWT: Knock defines it's own current_user method unless one is already
    # defined. As controller class is cached between requests, this method
    # stays and interferes with a browser-originated requests which rely on
    # Devise's implementation of current_user. As we define the method here,
    # Knock does not reimplement it anymore but we have to do its thing
    # manually.
    def current_user
      if token
        @_current_user ||= begin
          Knock::AuthToken.new(token: token).entity_for(User)
        rescue
          nil
        end
      else
        super
      end
    end

    private

    # JWT: No need to try and load session as there is none in an API request
    def skip_session
      request.session_options[:skip] = true if token
    end

    # JWT: overriding Knock's method to manually trigger Devise's auth.
    # When there is no token we assume the request comes from the browser so
    # has a session (potentially with warden key) attached.
    def authenticate_entity(entity_name)
      if token
        super(entity_name)
      else
        current_user
      end
    end

    def not_found
      render json: { errors: 'Not found' }, status: :not_found
    end

    def bad_request
      render json: { errors: 'Something wrong' }, status: :bad_request
    end
  end
end