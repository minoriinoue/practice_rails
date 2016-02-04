class Users::RegistrationsController < Devise::RegistrationsController
# before_filter :configure_sign_up_params, only: [:create]
# before_filter :configure_account_update_params, only: [:update]

  # GET /resource/sign_up
  def new
    # When shows new page, leave the boxes blank by
    # setting an empty User, User.new.
    @resource = User.new
  end

  # POST /resource
  def create
    # Since the parent class does not register :name, overrides the method.
    # user_params can be without @ since the scope is just in this method.
    # This method is written based on the error message.
    user_params = params.require(:user).permit(:name, :email, :password, :password_confirmation)
    # new just create an instance and does not save it in db.
    @resource = User.new(user_params)
    # save method returns true/false
    if @resource.save
      # new method makes the form blank.
      @resource = User.new
      render :new
    else
      # by not creating another instance like above, leave what the user
      # wrote in the boxes.
      render :new
    end

  end

  # GET /resource/edit
  # def edit
  #   super
  # end

  # PUT /resource
  # def update
  #   super
  # end

  # DELETE /resource
  # def destroy
  #   super
  # end

  # GET /resource/cancel
  # Forces the session data which is usually expired after sign
  # in to be expired now. This is useful if the user wants to
  # cancel oauth signing in/up in the middle of the process,
  # removing all OAuth session data.
  # def cancel
  #   super
  # end

  # protected

  # If you have extra params to permit, append them to the sanitizer.
  # def configure_sign_up_params
  #   devise_parameter_sanitizer.for(:sign_up) << :attribute
  # end

  # If you have extra params to permit, append them to the sanitizer.
  # def configure_account_update_params
  #   devise_parameter_sanitizer.for(:account_update) << :attribute
  # end

  # The path used after sign up.
  # def after_sign_up_path_for(resource)
  #   super(resource)
  # end

  # The path used after sign up for inactive accounts.
  # def after_inactive_sign_up_path_for(resource)
  #   super(resource)
  # end
end
