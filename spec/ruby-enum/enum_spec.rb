require 'spec_helper'

class Colors
  include Ruby::Enum

  define :RED, 'red'
  define :GREEN, 'green'
end

describe Ruby::Enum do
  it 'returns an enum value' do
    expect(Colors::RED).to eq 'red'
    expect(Colors::GREEN).to eq 'green'
  end
  it 'raises UninitializedConstantError on an invalid constant' do
    expect { Colors::ANYTHING }.to raise_error Ruby::Enum::Errors::UninitializedConstantError, /The constant Colors::ANYTHING has not been defined./
  end
  context '#each' do
    it 'iterates over constants' do
      keys = []
      enum_keys = []
      enum_values = []
      Colors.each do |key, enum|
        keys << key
        enum_keys << enum.key
        enum_values << enum.value
      end
      expect(keys).to eq [:RED, :GREEN]
      expect(enum_keys).to eq [:RED, :GREEN]
      expect(enum_values).to eq %w(red green)
    end
  end
  context '#map' do
    it 'maps constants' do
      key_key_values = Colors.map do |key, enum|
        [key, enum.key, enum.value]
      end
      expect(key_key_values.count).to eq 2
      expect(key_key_values[0]).to eq [:RED, :RED, 'red']
      expect(key_key_values[1]).to eq [:GREEN, :GREEN, 'green']
    end
  end
  context '#parse' do
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
  context '#key?' do
    it 'returns true for valid keys' do
      Colors.keys.each do |key|
        expect(Colors.key?(key)).to eq(true)
      end
    end
    it 'returns false for invalid keys' do
      expect(Colors.key?(:NOT_A_KEY)).to eq(false)
    end
  end
  context '#value' do
    it 'returns string values for keys' do
      Colors.each do |key, enum|
        expect(Colors.value(key)).to eq(enum.value)
      end
    end
    it 'returns nil for an invalid key' do
      expect(Colors.value(:NOT_A_KEY)).to be_nil
    end
  end
  context '#value?' do
    it 'returns true for valid values' do
      Colors.values.each do |value|
        expect(Colors.value?(value)).to eq(true)
      end
    end
    it 'returns false for invalid values' do
      expect(Colors.value?('I am not a value')).to eq(false)
    end
  end
  context '#key' do
    it 'returns enum instances for values' do
      Colors.each do |_, enum|
        expect(Colors.key(enum.value)).to eq(enum.key)
      end
    end
    it 'returns nil for an invalid value' do
      expect(Colors.key('invalid')).to be_nil
    end
  end
  context '#keys' do
    it 'returns keys' do
      expect(Colors.keys).to eq([:RED, :GREEN])
    end
  end
  context '#values' do
    it 'returns values' do
      expect(Colors.values).to eq(%w(red green))
    end
  end
  context '#to_h' do
    it 'returns a hash of key:values' do
      expect(Colors.to_h).to eq(RED: 'red', GREEN: 'green')
    end
  end
end
