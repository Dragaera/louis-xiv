require 'spec_helper'

RSpec.describe 'LouisXiv::App::DateTimeHelper' do
  let(:helpers) { Class.new }
  let(:date)    { DateTime.new(2016, 2, 1, 10, 11, 12) }
  before { helpers.extend LouisXiv::App::DateTimeHelper }
  subject { helpers }

  describe '#pretty_print_date' do
    it 'should return the date as d.m.Y H:M:S' do
      expect(subject.pretty_print_date(date)).to eq '01.02.2016 10:11:12'
    end

    it 'should contain an optional "... ago" string' do
      expect(subject).to receive(:time_ago_in_words).and_return('sometime')
      expect(subject.pretty_print_date(date, ago: true))
        .to(eq '01.02.2016 10:11:12 (sometime ago)')
    end

    it 'should return the alt-text if date is nil' do
      expect(subject.pretty_print_date(nil, alt: '(never)')).to eq '(never)'
    end
  end

  describe '#seconds_as_offset' do
    it 'should return the input seconds as an [+-]HHMM-formatted offset' do
      expect(subject.seconds_to_offset(60)).to eq '+0001'
      expect(subject.seconds_to_offset(7200)).to eq '+0200'
      expect(subject.seconds_to_offset(3660)).to eq '+0101'
    end

    it 'should handle negative offsets' do
      expect(subject.seconds_to_offset(-4020)).to eq '-0107'
    end
  end
end
