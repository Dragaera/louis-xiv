require 'spec_helper'

RSpec.describe SolarLogTrigger do
  let(:trigger_simple) do
    create(:solar_log_trigger,
           :with_maker_actions,
           maker_actions_count: 2,
           name: 'Simple Trigger')
  end

  let(:trigger_complex) do 
    create(:solar_log_trigger,
           :inactive,
           :with_maker_actions,
           maker_actions_count: 2,
           inactive_maker_actions_count: 3,
           name: 'Complex Trigger')
  end

  describe '#save' do
    it 'should set the default value of #active' do
      expect(trigger_simple).to be_active
    end

    describe '#valid?' do
      it 'should validate presence of #name' do
        trigger = build(:solar_log_trigger, :active, name: nil)
        expect(trigger).to_not be_valid

        trigger = build(:solar_log_trigger, :inactive, name: nil)
        expect(trigger).to_not be_valid

        trigger = build(:solar_log_trigger, name: 'Test trigger')
        expect(trigger).to be_valid
      end

      it 'should validate presence of #condition' do
        trigger = build(:solar_log_trigger, :active, condition: nil)
        expect(trigger).to_not be_valid

        trigger = build(:solar_log_trigger, :inactive, condition: nil)
        expect(trigger).to_not be_valid

        trigger = build(:solar_log_trigger, condition: 'true')
        expect(trigger).to be_valid
      end
    end

    describe '#active_maker_actions' do
      it 'should return those which are active' do
        active_actions = trigger_complex.maker_actions_dataset.where(active: true)
        expect(trigger_complex.active_maker_actions)
          .to(match_array(active_actions))
      end
    end

    describe '#inactive_maker_actions' do
      it 'should return those which are inactive' do
        inactive_actions = trigger_complex.maker_actions_dataset.where(active: false)
        expect(trigger_complex.inactive_maker_actions)
          .to(match_array(inactive_actions))
      end
    end

    describe '::active' do
      it 'should return those which are active' do
        expect(SolarLogTrigger.active).to match_array([trigger_simple])
      end
    end

    describe '::inactive' do
      it 'should return those which are inactive' do
        expect(SolarLogTrigger.inactive).to match_array([trigger_complex])
      end
    end
  end
end
