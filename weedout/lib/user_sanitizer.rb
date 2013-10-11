# http://blog.12spokes.com/web-design-development/adding-custom-fields-to-your-devise-user-model-in-rails-4/
class User::ParameterSanitizer < Devise::ParameterSanitizer
    private
    def account_update
        default_params.permit(:full_name, :signup_as_professor, :email, :password, :password_confirmation, :current_password)
    end

    def sign_up
        default_params.permit(:uni, :full_name, :signup_as_professor, :email, :password, :password_confirmation, :current_password)
    end
end