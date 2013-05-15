require 'spec_helper'

class Colors
  include Ruby::Enum

  define :RED, "red"
  define :GREEN, "green"
end

describe Ruby::Enum do
  it "returns an enum value" do
    Colors::RED.should eq "red"
    Colors::GREEN.should eq "green"
  end
  it "breaks on error" do
    expect { Colors::ANYTHING }.to raise_error Ruby::Enum::Errors::UninitializedConstantError
  end
  context "parse" do
    it "parses exact value" do
      Colors.parse("red").should == Colors::RED
    end
    it "is case-insensitive" do
      Colors.parse("ReD").should == Colors::RED
    end
    it "returns nil for a null value" do
      Colors.parse(nil).should be_nil
    end
    it "returns nil for an invalid value" do
      Colors.parse("invalid").should be_nil
    end
  end
end
