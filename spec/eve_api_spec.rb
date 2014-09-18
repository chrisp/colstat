require 'rspec'
specdir = File.expand_path(File.dirname(__FILE__))
require "#{specdir}/spec_helper"

describe EveApi do
  describe '#new' do
    it 'should initialize data required to access api' do
      capsuleer_id = '98678321'
      key_id = '2195212'
      vcode = 'B5rqp2zXfr6BoBOm9i4mkK5BqiYc2M2Taugi2Jeew2txbRS6lsZI1xYtVY1NLWaX'

      eve_api = EveApi.new(capsuleer_id, key_id, vcode)
      eve_api.capsuleer_id = capsuleer_id
      eve_api.key_id = key_id
      eve_api.vcode = vcode
    end 
  end
end
