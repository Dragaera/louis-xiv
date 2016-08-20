require 'spec_helper'

RSpec.describe MakerKey do
  before(:each) do
    @key1 = MakerKey.create(key: 'key1', active: true)
    @key2 = MakerKey.create(key: 'key2', active: true)
    @key3 = MakerKey.create(key: 'key3', active: false)
    @key4 = MakerKey.create(key: 'key4', active: false)
  end

  describe '#save' do
    it 'should set the default value of #active' do
      key = MakerKey.create(key: 'asdf')
      expect(key).to be_active
    end

    it 'should set the default value of #name' do
      key = MakerKey.create(key: 'asdf')
      expect(key.name).to eq key.key
    end
  end

  describe '#valid?' do
    it 'should validate presence of #key' do
      key = MakerKey.new()
      expect(key).to_not be_valid

      key = MakerKey.new(active: false)
      expect(key).to_not be_valid

      key = MakerKey.new(key: 'asdf')
      expect(key).to be_valid
    end

    it 'should validate uniqueness of #key' do
      MakerKey.create(key: 'asdf')

      key = MakerKey.new(key: 'asdf')
      expect(key).to_not be_valid
      key.key = '1234'
      expect(key).to be_valid
    end
  end

  describe '::active' do
    it 'should return active keys' do
      expect(MakerKey.active).to match_array([@key1, @key2])
    end
  end

  describe '::inactive' do
    it 'should return inactive keys' do
      expect(MakerKey.inactive).to match_array([@key3, @key4])
    end
  end
end
