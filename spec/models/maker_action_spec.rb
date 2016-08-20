require 'spec_helper'

RSpec.describe MakerAction do
  before(:each) do
    @key1 = MakerKey.create(key: 'key1', active: true)
    @key2 = MakerKey.create(key: 'key2', active: false)
    @key3 = MakerKey.create(key: 'key3', active: true)

    @event1 = MakerEvent.create(event: 'event1', active: true)
    @event2 = MakerEvent.create(event: 'event2', active: false)

    @action1 = MakerAction.create(maker_key_id: @key1.id, maker_event_id: @event1.id)

    @action2 = MakerAction.create(maker_key_id: @key1.id, maker_event_id: @event2.id)
    @action3 = MakerAction.create(maker_key_id: @key2.id, maker_event_id: @event1.id)

    @action4 = MakerAction.create(maker_key_id: @key3.id, maker_event_id: @event1.id, active: false)
  end

  describe '#save' do
    it 'should set the default value of #active' do
      expect(@action1).to be_active
    end
  end

  describe '#valid?' do
    it 'should validate presence of #maker_event' do
      action = MakerAction.new(maker_key_id: @key2.id)
      expect(action).to_not be_valid

      action.maker_event_id = @event2.id
      expect(action).to be_valid
    end

    it 'should validate presence of #maker_key' do
      action = MakerAction.new(maker_event_id: @event2.id)
      expect(action).to_not be_valid

      action.maker_key_id = @key2.id
      expect(action).to be_valid
    end

    it 'should validate uniqueness of [#maker_event, #maker_key]' do
      action = MakerAction.new(maker_key_id: @key1.id, maker_event_id: @event2.id)
      expect(action).to_not be_valid

      action.maker_key_id = @key2.id
      expect(action).to be_valid
    end
  end

  describe '::active' do
    it 'should return those which are active, including their keys and events' do
      expect(MakerAction.active).to match_array([@action1])
    end
  end

  describe '::inactive' do
    it 'should return those which are inactive' do
      expect(MakerAction.inactive).to include(@action4)
    end

    it 'should return those with an inactive event' do
      expect(MakerAction.inactive).to include(@action2)
    end

    it 'should return those with an inactive key' do
      expect(MakerAction.inactive).to include(@action3)
    end
  end


end
