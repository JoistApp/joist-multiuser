# frozen_string_literal: true

Warden::Strategies.add(:password) do
  def valid?
    params["user"]["email"] || params["user"]["password"]
  end

  def authenticate!
    user = User.find_by(email: params["user"]["email"].downcase)

    #
    # valid_password? is provided by including Devise::Models::DatabaseAuthenticatable in User model
    #
    return success!(user) if user && user.valid_for_authentication? { user.valid_password?(params["user"]["password"]) }
    return fail!("For your security, your account has been locked for one hour.") if user&.locked_at

    fail!("Please check your username and password.")
  end
end
