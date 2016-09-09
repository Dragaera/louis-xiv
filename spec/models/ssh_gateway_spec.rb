require 'spec_helper'

RSpec.describe SSHGateway do
  let(:gateway_moria) { 
    create(:ssh_gateway,
           host: 'moria.internal',
           ssh_user: create(:ssh_user)
          )
  }

  describe '#save' do
    it 'should set the default value of #active' do
      expect(gateway_moria).to be_active
    end
  end

  describe '#valid?' do
    it 'should validate the presence of #host' do
      gateway = build(:ssh_gateway, host: nil, ssh_user: create(:ssh_user))
      expect(gateway).to_not be_valid

      gateway = build(:ssh_gateway, ssh_user: create(:ssh_user))
      expect(gateway).to be_valid
    end

    it 'should validate the presence of #user' do
      gateway = build(:ssh_gateway, ssh_user: nil)
      expect(gateway).to_not be_valid
    end
  end
end
