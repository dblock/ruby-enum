# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Ruby::Enum::Case do
  test_enum =
    Class.new do
      include Ruby::Enum
      include Ruby::Enum::Case

      define :RED, :red
      define :GREEN, :green
      define :BLUE, :blue
    end

  describe '.case' do
    context 'when all cases are defined' do
      subject { test_enum.case(test_enum::RED, cases) }

      let(:cases) do
        {
          [test_enum::RED, test_enum::GREEN] => -> { 'red or green' },
          test_enum::BLUE => -> { 'blue' }
        }
      end

      it { is_expected.to eq('red or green') }

      context 'when the value is nil' do
        subject { test_enum.case(nil, cases) }

        it { is_expected.to be_nil }
      end

      context 'when the value is empty' do
        subject { test_enum.case('', cases) }

        it { is_expected.to be_nil }
      end

      context 'when the value is the value of the enum' do
        subject { test_enum.case(:red, cases) }

        it { is_expected.to eq('red or green') }
      end

      context 'when the value is used inside the lambda' do
        subject { test_enum.case(test_enum::RED, cases) }

        let(:cases) do
          {
            [test_enum::RED, test_enum::GREEN] => ->(color) { "is #{color}" },
            test_enum::BLUE => -> { 'blue' }
          }
        end

        it { is_expected.to eq('is red') }
      end
    end

    context 'when there are mutliple matches' do
      subject do
        test_enum.case(
          test_enum::RED,
          {
            [test_enum::RED, test_enum::GREEN] => -> { 'red or green' },
            test_enum::RED => -> { 'red' },
            test_enum::BLUE => -> { 'blue' }
          }
        )
      end

      it { is_expected.to eq(['red or green', 'red']) }
    end

    context 'when not all cases are defined' do
      it 'raises an error' do
        expect do
          test_enum.case(
            test_enum::RED,
            { [test_enum::RED, test_enum::GREEN] => -> { 'red or green' } }
          )
        end.to raise_error(Ruby::Enum::Case::ClassMethods::NotAllCasesHandledError)
      end
    end

    context 'when not all cases are defined but :else is specified (default case)' do
      it 'does not raise an error' do
        expect do
          result = test_enum.case(
            test_enum::BLUE,
            {
              [test_enum::RED, test_enum::GREEN] => -> { 'red or green' },
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
          test_enum.case(
            test_enum::RED,
            {
              [test_enum::RED, test_enum::GREEN] => -> { 'red or green' },
              test_enum::BLUE => -> { 'blue' },
              :something => -> { 'green' }
            }
          )
        end.to raise_error(Ruby::Enum::Case::ClassMethods::ValuesNotDefinedError)
      end
    end
  end
end
