# frozen_string_literal: true

require 'spec_helper'

describe Ruby::Enum do
  it 'is an alias for RubyEnum::Enum and warns on inclusion' do
    expect do
      class DeprecatedColor
        include Ruby::Enum

        define :RED, 'red'
      end
    end.to output(/DEPRECATION.*Ruby::Enum.*RubyEnum::Enum/).to_stderr

    expect(DeprecatedColor::RED).to eq('red')
    expect(DeprecatedColor.ancestors).to include(RubyEnum::Enum)
  end

  it 'exposes Ruby::Enum::Case as an alias for RubyEnum::Enum::Case and warns on inclusion' do
    expect do
      class DeprecatedCaseColor
        include Ruby::Enum
        include Ruby::Enum::Case

        define :RED, 'red'
      end
    end.to output(/DEPRECATION.*Ruby::Enum::Case.*RubyEnum::Enum::Case/).to_stderr

    expect(DeprecatedCaseColor.ancestors).to include(RubyEnum::Enum::Case)
  end

  it 'exposes Ruby::Enum::Errors as an alias for RubyEnum::Enum::Errors' do
    expect(Ruby::Enum::Errors).to equal(RubyEnum::Enum::Errors)
  end
end
