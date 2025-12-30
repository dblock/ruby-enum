# frozen_string_literal: true

require 'spec_helper'

module Case
  class Colors
    include Ruby::Enum
    include Ruby::Enum::Case

    define :RED, :red
    define :GREEN, :green
    define :BLUE, :blue
  end
end

RSpec.describe Ruby::Enum::Case do
  describe '.case' do
    context 'when all cases are defined' do
      subject { Case::Colors.case(Case::Colors::RED, cases) }

      let(:cases) do
        {
          [Case::Colors::RED, Case::Colors::GREEN] => -> { 'red or green' },
          Case::Colors::BLUE => -> { 'blue' }
        }
      end

      it { is_expected.to eq('red or green') }

      context 'when the value is nil' do
        subject { Case::Colors.case(nil, cases) }

        it { is_expected.to be_nil }
      end

      context 'when the value is empty' do
        subject { Case::Colors.case('', cases) }

        it { is_expected.to be_nil }
      end

      context 'when the value is the value of the enum' do
        subject { Case::Colors.case(:red, cases) }

        it { is_expected.to eq('red or green') }
      end

      context 'when the value is used inside the lambda' do
        subject { Case::Colors.case(Case::Colors::RED, cases) }

        let(:cases) do
          {
            [Case::Colors::RED, Case::Colors::GREEN] => ->(color) { "is #{color}" },
            Case::Colors::BLUE => -> { 'blue' }
          }
        end

        it { is_expected.to eq('is red') }
      end
    end

    context 'when there are mutliple matches' do
      subject do
        Case::Colors.case(
          Case::Colors::RED,
          {
            [Case::Colors::RED, Case::Colors::GREEN] => -> { 'red or green' },
            Case::Colors::RED => -> { 'red' },
            Case::Colors::BLUE => -> { 'blue' }
          }
        )
      end

      it { is_expected.to eq(['red or green', 'red']) }
    end

    context 'when not all cases are defined' do
      it 'raises an error' do
        expect do
          Case::Colors.case(
            Case::Colors::RED,
            { [Case::Colors::RED, Case::Colors::GREEN] => -> { 'red or green' } }
          )
        end.to raise_error(Ruby::Enum::Case::ClassMethods::NotAllCasesHandledError)
      end
    end

    context 'when not all cases are defined but :else is specified (default case)' do
      it 'does not raise an error' do
        expect do
          result = Case::Colors.case(
            Case::Colors::BLUE,
            {
              [Case::Colors::RED, Case::Colors::GREEN] => -> { 'red or green' },
              else: -> { 'blue' }
            }
          )

          expect(result).to eq('blue')
        end.not_to raise_error
      end
    end

    context 'when a superfluous case is defined' do
      it 'raises an error' do
        expect do
          Case::Colors.case(
            Case::Colors::RED,
            {
              [Case::Colors::RED, Case::Colors::GREEN] => -> { 'red or green' },
              Case::Colors::BLUE => -> { 'blue' },
              :something => -> { 'green' }
            }
          )
        end.to raise_error(Ruby::Enum::Case::ClassMethods::ValuesNotDefinedError)
      end
    end
  end
end
