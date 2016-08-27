require 'spec_helper'

RSpec.describe MakerKey do
  let(:key_foo) { create(:maker_key, key: 'foo') }
  let(:key_bar) { create(:maker_key, key: 'bar') }
  let(:key_baz) { create(:maker_key, :inactive, key: 'baz') }
  let(:key_bak) { create(:maker_key, :inactive, key: 'bak') }

  describe '#save' do
    it 'should set the default value of #active' do
      expect(key_foo).to be_active
    end

    it 'should set the default value of #name' do
      expect(key_foo.name).to eq 'foo'
    end
  end

  describe '#valid?' do
    it 'should validate presence of #key' do
      key = build(:maker_key, :active, key: nil)
      expect(key).to_not be_valid

      key = build(:maker_key, :inactive, key: nil)
      expect(key).to_not be_valid

      key = build(:maker_key, :active)
      expect(key).to be_valid
    end

    it 'should validate uniqueness of #key' do
      key_foo # lazily loaded by #let
      key = build(:maker_key, key: 'foo')
      expect(key).to_not be_valid

      key.key = 'foobar'
      expect(key).to be_valid
    end
  end

  describe '::active' do
    it 'should return active keys' do
      expect(MakerKey.active).to match_array([key_foo, key_bar])
    end
  end

  describe '::inactive' do
    it 'should return inactive keys' do
      expect(MakerKey.inactive).to match_array([key_baz, key_bak])
    end
  end
end
