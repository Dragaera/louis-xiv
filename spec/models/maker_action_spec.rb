require 'spec_helper'

RSpec.describe MakerAction do
  let(:action_simple) { create(:maker_action, 
                               :with_maker_keys, :with_maker_events,
                               maker_keys_count: 1, maker_events_count: 1,
                               name: 'Simple action') }

  let(:action_complex) { create(:maker_action,
                                :inactive,
                                :with_maker_keys, :with_maker_events,
                                maker_keys_count: 1, 
                                inactive_maker_keys_count: 1,
                                maker_events_count: 1, 
                                inactive_maker_events_count: 1,
                                name: 'Complex action') }

  describe '#save' do
    it 'should set the default value of #active' do
      expect(action_simple).to be_active
    end
  end

  describe '#valid?' do
    it 'should validate presence of #name' do
      action = build(:maker_action, :active, name: nil)
      expect(action).to_not be_valid

      action = build(:maker_action, :inactive, name: nil)
      expect(action).to_not be_valid

      action = build(:maker_action, :inactive, name: 'Test action')
      expect(action).to be_valid
    end
  end

  describe '#active_maker_keys' do
    it 'should return those which are active' do
      active_keys = action_complex.maker_keys_dataset.where(active: true)
      expect(action_complex.active_maker_keys).to match_array(active_keys)
    end
  end

  describe '#inactive_maker_keys' do
    it 'should return those which are inactive' do
      inactive_keys = action_complex.maker_keys_dataset.where(active: false)
      expect(action_complex.inactive_maker_keys).to match_array(inactive_keys)
    end
  end

  describe '#active_maker_events' do
    it 'should return those which are active' do
      active_events = action_complex.maker_events_dataset.where(active: true)
      expect(action_complex.active_maker_events).to match_array(active_events)
    end
  end

  describe '#inactive_maker_events' do
    it 'should return those which are inactive' do
      inactive_events = action_complex.maker_events_dataset.where(active: false)
      expect(action_complex.inactive_maker_events).to match_array(inactive_events)
    end
  end

  describe '::active' do
    it 'should return those which are active' do
      expect(MakerAction.active).to match_array([action_simple])
    end
  end

  describe '::inactive' do
    it 'should return those which are inactive' do
      expect(MakerAction.inactive).to match_array([action_complex])
    end
  end


end
