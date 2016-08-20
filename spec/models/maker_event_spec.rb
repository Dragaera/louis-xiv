require 'spec_helper'

RSpec.describe MakerEvent do
  before(:each) do
    @event1 = MakerEvent.create(event: 'foo')
    @event2 = MakerEvent.create(event: 'bar')
    @event3 = MakerEvent.create(event: 'baz', active: false)
    @event4 = MakerEvent.create(event: 'bara', active: false)
  end

  describe '#save' do
    it 'should set the default value of #active' do
      expect(@event1).to be_active
    end

    it 'should set the default value of #name' do
      expect(@event1.name).to eq @event1.event
    end
  end

  describe '#valid?' do
    it 'should validate presence of #event' do
      event = MakerEvent.new()
      expect(event).to_not be_valid

      event.active = false
      expect(event).to_not be_valid

      event.event = 'asdf'
      expect(event).to be_valid
    end

    it 'should validate uniqueness of #event' do
      event = MakerEvent.new(event: 'foo')
      expect(event).to_not be_valid
      event.event = 'asdf'
      expect(event).to be_valid
    end
  end

  describe '::active' do
    it 'should return active events' do
      expect(MakerEvent.active).to match_array([@event1, @event2])
    end
  end

  describe '::inactive' do
    it 'should return inactive events' do
      expect(MakerEvent.inactive).to match_array([@event3, @event4])
    end
  end
end
