class EveApi
  include HTTParty

  parser(
    Proc.new do |body, format|
      Crack::XML.parse(body)
    end
  )
end
