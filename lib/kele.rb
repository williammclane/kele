require 'httparty'
require './lib/roadmap' 

class Kele
  include HTTParty
  include Roadmap 

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
  
  def get_mentor_availability(mentor_id)
    response = self.class.get('/mentors/' + mentor_id.to_s + '/student_availability', headers: { "authorization" => @user_auth_token })
    body = JSON.parse(response.body)
    mentor_availability = []
    body.each { |time_slot| mentor_availability << time_slot if time_slot['booked'] == nil }
  end
  
  def get_messages(page = nil)
    if page != nil
      response = self.class.get("/message_threads", body: {"page": page}, headers: { "authorization" => @user_auth_token })
    else
      response = self.class.get("/message_threads", headers: { "authorization" => @user_auth_token })
    end

    @message_threads = JSON.parse response.body
  end

  def create_message(sender, recipient_id, subject, stripped_text)
    response = self.class.post('/messages',
    body: {
      "sender": sender,
      "recipient_id": recipient_id,
      "subject": subject,
      "stripped-text": stripped_text
    },
    headers: { "authorization" => @user_auth_token })
  end
end