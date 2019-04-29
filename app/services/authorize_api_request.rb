class AuthorizeApiRequest
  attr_accessor :headers, :token, :errors, :user

  def initialize(**params)
    assign_attributes(params)
  end

  def valid?
    auth = PdvAuthApi::V1::Auth.new(token: @token)

    if auth.validate
      @user = auth.user
      true
    else
      @errors = auth.errors
      false
    end
  end

  private

  def assign_attributes(params)
    @headers = params[:headers]

    return unless @headers['authorization'].present?

    @token = @headers['Authorization'].split(' ').last
  end
end
