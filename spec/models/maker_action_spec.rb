require 'spec_helper'

RSpec.describe MakerAction do
  let(:key_1) { MakerKey.create(key: 'key1', active: true) }
  let(:key_2) { MakerKey.create(key: 'key2', active: false) }

  let(:event_1) { MakerEvent.create(event: 'event1', active: true) }
  let(:event_2) { MakerEvent.create(event: 'event2', active: false) }

  let(:action_1) { MakerAction.create(name: 'Test action 1') }
  let(:action_2) { MakerAction.create(name: 'Test action 2', active: false) }

  before(:each) do
    action_1.add_maker_key(key_1)
    action_1.add_maker_event(event_1)

    action_2.add_maker_key(key_1)
    action_2.add_maker_key(key_2)
    action_2.add_maker_event(event_1)
    action_2.add_maker_event(event_2)
  end

  describe '#save' do
    it 'should set the default value of #active' do
      expect(action_1).to be_active
    end
  end

  describe '#valid?' do
    it 'should validate presence of #name' do
      action = MakerAction.new(active: true)
      expect(action).to_not be_valid
    end
  end

  describe '#active_maker_keys' do
    it 'should return those which are active' do
      expect(action_2.active_maker_keys).to match_array([key_1])
    end
  end

  describe '#inactive_maker_keys' do
    it 'should return those which are inactive' do
      expect(action_2.inactive_maker_keys).to match_array([key_2])
    end
  end

  describe '#active_maker_events' do
    it 'should return those which are active' do
      expect(action_2.active_maker_events).to match_array([event_1])
    end
  end

  describe '#inactive_maker_events' do
    it 'should return those which are inactive' do
      expect(action_2.inactive_maker_events).to match_array([event_2])
    end
  end
  
  describe '::active' do
    it 'should return those which are active' do
      expect(MakerAction.active).to match_array([action_1])
    end
  end

  describe '::inactive' do
    it 'should return those which are inactive' do
      expect(MakerAction.inactive).to match_array([action_2])
    end
  end


end
