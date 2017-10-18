module Roadmap
  def get_roadmap(roadmap_id)
    response = self.class.get('/roadmaps/' + roadmap_id.to_s, headers: { "authorization" => @user_auth_token })
    @roadmap = JSON.parse(response.body)
  end

  def get_checkpoint(checkpoint_id)
    response = self.class.get('/checkpoints/' + checkpoint_id.to_s, headers: { "authorization" => @user_auth_token })
    @checkpoints = JSON.parse(response.body)
  end
end