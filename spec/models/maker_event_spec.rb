require 'spec_helper'

RSpec.describe MakerEvent do
  let(:event_foo) { create(:maker_event, event: 'foo') }
  let(:event_bar) { create(:maker_event, event: 'bar') }
  let(:event_baz) { create(:maker_event, :inactive, event: 'baz') }
  let(:event_bak) { create(:maker_event, :inactive, event: 'bak') }

  describe '#save' do
    it 'should set the default value of #active' do
      expect(event_foo).to be_active
    end

    it 'should set the default value of #name' do
      expect(event_foo.name).to eq 'foo'
    end
  end

  describe '#valid?' do
    it 'should validate presence of #event' do
      event = build(:maker_event, event: nil)
      expect(event).to_not be_valid

      event = build(:maker_event, :inactive, event: nil)
      expect(event).to_not be_valid

      event = build(:maker_event, event: 'test event')
      expect(event).to be_valid
    end

    it 'should validate uniqueness of #event' do
      event_foo # lazily loaded by #let
      event = build(:maker_event, event: 'foo')
      expect(event).to_not be_valid

      event.event = 'asdf'
      expect(event).to be_valid
    end
  end

  describe '::active' do
    it 'should return active events' do
      expect(MakerEvent.active).to match_array([event_foo, event_bar])
    end
  end

  describe '::inactive' do
    it 'should return inactive events' do
      expect(MakerEvent.inactive).to match_array([event_baz, event_bak])
    end
  end
end
