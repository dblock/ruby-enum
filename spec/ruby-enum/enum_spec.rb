# frozen_string_literal: true

require 'spec_helper'

describe Ruby::Enum do
  class Colors
    include Ruby::Enum

    define :RED, 'red'
    define :GREEN, 'green'
  end

  class FirstSubclass < Colors
    define :ORANGE, 'orange'
  end

  class SecondSubclass < FirstSubclass
    define :PINK, 'pink'
  end
  it 'returns an enum value' do
    expect(Colors::RED).to eq 'red'
    expect(Colors::GREEN).to eq 'green'
  end

  context 'when the i18n gem is loaded' do
    it 'raises UninitializedConstantError on an invalid constant' do
      expect do
        Colors::ANYTHING
      end.to raise_error Ruby::Enum::Errors::UninitializedConstantError, /The constant Colors::ANYTHING has not been defined./
    end
  end

  context 'when the i18n gem is not loaded' do
    before do
      allow(described_class).to receive(:i18n).and_return(Ruby::Enum::I18nMock)
    end

    it 'raises UninitializedConstantError on an invalid constant' do
      expect do
        Colors::ANYTHING
      end.to raise_error Ruby::Enum::Errors::UninitializedConstantError, /ruby.enum.errors.messages.uninitialized_constant.summary/
    end
  end

  describe '#each' do
    it 'iterates over constants' do
      keys = []
      enum_keys = []
      enum_values = []
      Colors.each do |key, enum|
        keys << key
        enum_keys << enum.key
        enum_values << enum.value
      end
      expect(keys).to eq %i[RED GREEN]
      expect(enum_keys).to eq %i[RED GREEN]
      expect(enum_values).to eq %w[red green]
    end
  end

  describe '#map' do
    it 'maps constants' do
      key_key_values = Colors.map do |key, enum|
        [key, enum.key, enum.value]
      end
      expect(key_key_values.count).to eq 2
      expect(key_key_values[0]).to eq [:RED, :RED, 'red']
      expect(key_key_values[1]).to eq [:GREEN, :GREEN, 'green']
    end
  end

  describe '#parse' do
    it 'parses exact value' do
      expect(Colors.parse('red')).to eq(Colors::RED)
    end

    it 'is case-insensitive' do
      expect(Colors.parse('ReD')).to eq(Colors::RED)
    end

    it 'returns nil for a null value' do
      expect(Colors.parse(nil)).to be_nil
    end

    it 'returns nil for an invalid value' do
      expect(Colors.parse('invalid')).to be_nil
    end
  end

  describe '#key?' do
    it 'returns true for valid keys accessed directly' do
      Colors.keys.each do |key| # rubocop:disable Style/HashEachMethods
        expect(Colors.key?(key)).to be(true)
      end
    end

    it 'returns true for valid keys accessed via each_keys' do
      Colors.each_key do |key|
        expect(Colors.key?(key)).to be(true)
      end
    end

    it 'returns false for invalid keys' do
      expect(Colors.key?(:NOT_A_KEY)).to be(false)
    end
  end

  describe '#value' do
    it 'returns string values for keys' do
      Colors.each do |key, enum|
        expect(Colors.value(key)).to eq(enum.value)
      end
    end

    it 'returns nil for an invalid key' do
      expect(Colors.value(:NOT_A_KEY)).to be_nil
    end
  end

  describe '#value?' do
    it 'returns true for valid values accessed directly' do
      Colors.values.each do |value| # rubocop:disable Style/HashEachMethods
        expect(Colors.value?(value)).to be(true)
      end
    end

    it 'returns true for valid values accessed via each_value' do
      Colors.each_value do |value|
        expect(Colors.value?(value)).to be(true)
      end
    end

    it 'returns false for invalid values' do
      expect(Colors.value?('I am not a value')).to be(false)
    end
  end

  describe '#key' do
    it 'returns enum instances for values' do
      Colors.each do |_, enum| # rubocop:disable Style/HashEachMethods
        expect(Colors.key(enum.value)).to eq(enum.key)
      end
    end

    it 'returns nil for an invalid value' do
      expect(Colors.key('invalid')).to be_nil
    end
  end

  describe '#keys' do
    it 'returns keys' do
      expect(Colors.keys).to eq(%i[RED GREEN])
    end
  end

  describe '#values' do
    it 'returns values' do
      expect(Colors.values).to eq(%w[red green])
    end
  end

  describe '#to_h' do
    it 'returns a hash of key:values' do
      expect(Colors.to_h).to eq(RED: 'red', GREEN: 'green')
    end
  end

  context 'when a duplicate key is used' do
    context 'when the i18n gem is loaded' do
      it 'raises DuplicateKeyError' do
        expect do
          Colors.class_eval do
            define :RED, 'some'
          end
        end.to raise_error Ruby::Enum::Errors::DuplicateKeyError, /The constant Colors::RED has already been defined./
      end
    end

    context 'when the i18n gem is not loaded' do
      before do
        allow(described_class).to receive(:i18n).and_return(Ruby::Enum::I18nMock)
      end

      it 'raises DuplicateKeyError' do
        expect do
          Colors.class_eval do
            define :RED, 'some'
          end
        end.to raise_error Ruby::Enum::Errors::DuplicateKeyError, /ruby.enum.errors.messages.duplicate_key.message/
      end
    end
  end

  context 'when a duplicate value is used' do
    context 'when the i18n gem is loaded' do
      it 'raises a DuplicateValueError' do
        expect do
          Colors.class_eval do
            define :Other, 'red'
          end
        end.to raise_error Ruby::Enum::Errors::DuplicateValueError, /The value red has already been defined./
      end
    end

    context 'when the i18n gem is not loaded' do
      before do
        allow(described_class).to receive(:i18n).and_return(Ruby::Enum::I18nMock)
      end

      it 'raises a DuplicateValueError' do
        expect do
          Colors.class_eval do
            define :Other, 'red'
          end
        end.to raise_error Ruby::Enum::Errors::DuplicateValueError, /ruby.enum.errors.messages.duplicate_value.summary/
      end
    end
  end

  describe 'Given a class that has not defined any enums' do
    class EmptyEnums
      include Ruby::Enum
    end
    it do
      expect { EmptyEnums::ORANGE }.to raise_error Ruby::Enum::Errors::UninitializedConstantError
    end
  end

  context 'when a constant is redefined in a global namespace' do
    before do
      RED = 'black'
    end

    it { expect(Colors::RED).to eq 'red' }
  end

  describe 'Subclass behavior' do
    it 'contains the enums defined in the parent class' do
      expect(FirstSubclass::GREEN).to eq 'green'
      expect(FirstSubclass::RED).to eq 'red'
    end

    it 'contains its own enums' do
      expect(FirstSubclass::ORANGE).to eq 'orange'
    end

    it 'parent class should not have enums defined in child classes' do
      expect { Colors::ORANGE }.to raise_error Ruby::Enum::Errors::UninitializedConstantError
    end

    context 'when defining a 2 level depth subclass' do
      it 'contains its own enums and all the enums defined in the parent classes' do
        expect(SecondSubclass::RED).to eq 'red'
        expect(SecondSubclass::GREEN).to eq 'green'
        expect(SecondSubclass::ORANGE).to eq 'orange'
        expect(SecondSubclass::PINK).to eq 'pink'
      end

      describe '#values' do
        it 'contains the values from all of the parent classes' do
          expect(SecondSubclass.values).to eq(%w[red green orange pink])
        end
      end
    end

    describe '#values' do
      it 'contains the values from the parent class' do
        expect(FirstSubclass.values).to eq(%w[red green orange])
      end
    end
  end

  describe 'default value' do
    class Default
      include Ruby::Enum

      define :KEY
    end

    it 'equals the key' do
      expect(Default::KEY).to eq(:KEY)
    end
  end

  describe 'non constant definitions' do
    class States
      include Ruby::Enum

      define :created, 'Created'
      define :published, 'Published'
      define :undefined
    end

    it 'behaves like an enum' do
      expect(States.created).to eq 'Created'
      expect(States.published).to eq 'Published'
      expect(States.undefined).to eq :undefined

      expect(States.key?(:created)).to be true
      expect(States.key('Created')).to eq :created

      expect(States.value?('Created')).to be true
      expect(States.value(:created)).to eq 'Created'

      expect(States.key?(:undefined)).to be true
      expect(States.key(:undefined)).to eq :undefined

      expect(States.value?(:undefined)).to be true
      expect(States.value(:undefined)).to eq :undefined
    end
  end
end
