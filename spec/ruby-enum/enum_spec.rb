require 'spec_helper'

class Colors
  include Ruby::Enum

  define :RED, 'red'
  define :GREEN, 'green'
end

describe Ruby::Enum do
  it 'returns an enum value' do
    Colors::RED.should eq 'red'
    Colors::GREEN.should eq 'green'
  end
  it 'raises UninitializedConstantError on an invalid constant' do
    expect { Colors::ANYTHING }.to raise_error Ruby::Enum::Errors::UninitializedConstantError
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
      keys.should eq [:RED, :GREEN]
      enum_keys.should eq [:RED, :GREEN]
      enum_values.should eq %w(red green)
    end
  end
  context '#map' do
    it 'maps constants' do
      key_key_values = Colors.map do |key, enum|
        [key, enum.key, enum.value]
      end
      key_key_values.count.should eq 2
      key_key_values[0].should eq [:RED, :RED, 'red']
      key_key_values[1].should eq [:GREEN, :GREEN, 'green']
    end
  end
  context '#parse' do
    it 'parses exact value' do
      Colors.parse('red').should == Colors::RED
    end
    it 'is case-insensitive' do
      Colors.parse('ReD').should == Colors::RED
    end
    it 'returns nil for a null value' do
      Colors.parse(nil).should be_nil
    end
    it 'returns nil for an invalid value' do
      Colors.parse('invalid').should be_nil
    end
  end
  context '#key?' do
    it 'returns true for valid keys' do
      Colors.keys.each do |key|
        Colors.key?(key).should == true
      end
    end
    it 'returns false for invalid keys' do
      Colors.key?(:NOT_A_KEY).should == false
    end
  end
  context '#value' do
    it 'returns string values for keys' do
      Colors.each do |key, enum|
        Colors.value(key).should == enum.value
      end
    end
    it 'returns nil for an invalid key' do
      Colors.value(:NOT_A_KEY).should be_nil
    end
  end
  context '#value?' do
    it 'returns true for valid values' do
      Colors.values.each do |value|
        Colors.value?(value).should == true
      end
    end
    it 'returns false for invalid values' do
      Colors.value?('I am not a value').should == false
    end
  end
  context '#key' do
    it 'returns enum instances for values' do
      Colors.each do |_, enum|
        Colors.key(enum.value).should == enum.key
      end
    end
    it 'returns nil for an invalid value' do
      Colors.key('invalid').should be_nil
    end
  end
  context '#keys' do
    it 'returns keys' do
      Colors.keys.should == [:RED, :GREEN]
    end
  end
  context '#values' do
    it 'returns values' do
      Colors.values.should == %w(red green)
    end
  end
  context '#to_h' do
    it 'returns a hash of key:values' do
      Colors.to_h.should == { RED: 'red', GREEN: 'green' }
    end
  end
end
