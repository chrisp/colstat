class EveApi
  include HTTParty
  attr_accessor :capsuleer_id, :key_id, :vcode, :url, :response

  parser(
    Proc.new do |body, format|
      Crack::XML.parse(body)
    end
  )

  def initialize(cap_id, new_key_id, new_vcode, opts={})
    self.capsuleer_id = cap_id
    self.key_id = new_key_id
    self.vcode = new_vcode

    unless [capsuleer_id, key_id, vcode].all?
      raise ArgumentError.new('api keys required') 
    end
  end
end
