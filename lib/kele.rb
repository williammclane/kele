require 'httparty'

class Kele
  include HTTParty

  base_uri 'https://www.bloc.io/api/v1'

  def initialize(email, password)
    post_response = self.class.post('/sessions', body: {
        email: email,
        password: password
      })
    @user_auth_token = post_response['auth_token']
    raise "Invalid Email or Password. Try Again." if @user_auth_token.nil?

  end
  
  def get_me
    response = self.class.get('/users/me', headers: { "authorization" => @user_auth_token })
    @user = JSON.parse(response.body)
  end
end