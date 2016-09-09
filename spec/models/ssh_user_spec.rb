require 'spec_helper'

RSpec.describe SSHUser do
  let(:user_john) { create(:ssh_user, user: 'John', password: 'beelzebeub') }

  describe '#save' do
    it 'should set the default value of #active' do
      expect(user_john).to be_active
    end
  end

  describe '#valid?' do
    it 'should validate presence of #user' do
      user = build(:ssh_user, user: nil, password: 'nope')
      expect(user).to_not be_valid

      user = build(:ssh_user, user: 'test', password: 'yes')
      expect(user).to be_valid
    end

    it 'should validate presence of either #password or #private_key' do
      user = build(:ssh_user, password: nil, private_key: nil)
      expect(user).to_not be_valid

      user = build(:ssh_user, password: 'testing testing 123', private_key: nil)
      expect(user).to be_valid

      user = build(:ssh_user, private_key: 'BEGIN RSA', password: nil)
      expect(user).to be_valid

      user = build(:ssh_user, password: 'sekkrit', private_key: 'BEGIN RSA')
      expect(user).to be_valid
    end
  end

  describe '#authentication_method' do
    it 'should return :passphrase if only a passphrase is set' do
      user = create(:ssh_user, private_key: nil)
      expect(user.authentication_method).to eq :passphrase
    end

    it 'should return :private_key if only a private key is set' do
      user = create(:ssh_user, password: nil)
      expect(user.authentication_method).to eq :private_key
    end

    it 'should return :private_key if both are set' do
      user = create(:ssh_user)
      expect(user.authentication_method).to eq :private_key
    end
  end

  describe '#password=' do
    it 'should remap the empty string to nil' do
      user = create(:ssh_user)
      user.password = ''
      expect(user.password).to be_nil
    end
  end

  describe '#private_key=' do
    it 'should remap the empty string to nil' do
      user = create(:ssh_user)
      user.private_key = ''
      expect(user.private_key).to be_nil
    end

    it 'should preserve linebreaks' do
      user = create(:ssh_user)
      user.private_key = "===RSA PRIVATE KEY===\nabcdefgh\n===END RSA==="
      user.save
      expect(user.private_key).to eq "===RSA PRIVATE KEY===\nabcdefgh\n===END RSA==="
    end
  end
end
