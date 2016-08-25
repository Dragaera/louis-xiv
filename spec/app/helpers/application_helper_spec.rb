require 'spec_helper'

RSpec.describe "LouisXiv::App::ApplicationHelper" do
  let(:helpers){ Class.new }
  before { helpers.extend LouisXiv::App::ApplicationHelper }
  subject { helpers }

  describe '::to_bool' do
    context 'when given a known input string' do
      it 'should convert "1" to true' do
        expect(subject.to_bool('1')).to be true
      end

      it 'should convert "yes", "on" and "true" to true' do
        %w(yes on true).each do |value|
          expect(subject.to_bool(value)).to be true
        end
      end

      it 'should convert "0" to false' do
        expect(subject.to_bool('0')).to be false
      end

      it 'should convert "no", "off" and "false" to false' do
        %w(no off false).each do |value|
          expect(subject.to_bool(value)).to be false
        end
      end
    end

    context "when given a known input integer" do
      it 'should convert 1 to true' do
        expect(subject.to_bool(1)).to be true
      end

      it 'should convert 0 to false' do
        expect(subject.to_bool(0)).to be false
      end
    end

    context 'when given an unknown value' do
      it 'should raise an ArgumentError' do
        ['John', 'foo', -27, 156].each do |value|
          expect { subject.to_bool(value) }.to raise_error(ArgumentError)
        end
      end
    end
  end

  describe '::to_int' do
    it 'should convert an array of string-representations to integers' do
      input = %w(1 7 42 823)
      expect(subject.to_int(input)).to match_array([1, 7, 42, 823])
    end

    context 'in non-strict mode' do
      it 'should discard those where conversion failed' do
        input = %w(5 as 2z 3)
        expect(subject.to_int(input, strict: false)).to match_array([5, 3])
      end
    end

    context 'in strict mode' do
      it 'should raise an ArgumentError when conversion fails' do
        input = %w(5 as 2z 3)
        expect { subject.to_int(input) }.to raise_error(ArgumentError)
      end
    end
  end

  pending '::pp_form_errors'
end
