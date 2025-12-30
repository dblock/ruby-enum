# frozen_string_literal: true

require 'spec_helper'

module I18n
  class Colors
    include Ruby::Enum

    define :RED, 'red'
    define :GREEN, 'green'
  end
end

describe Ruby::Enum do
  context 'when the i18n gem is not loaded' do
    it 'raises UninitializedConstantError on an invalid constant' do
      expect do
        I18n::Colors::ANYTHING
      end.to raise_error Ruby::Enum::Errors::UninitializedConstantError, /ruby.enum.errors.messages.uninitialized_constant.summary/
    end

    context 'when a duplicate key is used' do
      before do
        allow(described_class).to receive(:i18n).and_return(Ruby::Enum::I18nMock)
      end

      it 'raises DuplicateKeyError' do
        expect do
          I18n::Colors.class_eval do
            define :RED, 'some'
          end
        end.to raise_error Ruby::Enum::Errors::DuplicateKeyError, /ruby.enum.errors.messages.duplicate_key.message/
      end
    end

    context 'when a duplicate value is used' do
      before do
        allow(described_class).to receive(:i18n).and_return(Ruby::Enum::I18nMock)
      end

      it 'raises a DuplicateValueError' do
        expect do
          I18n::Colors.class_eval do
            define :Other, 'red'
          end
        end.to raise_error Ruby::Enum::Errors::DuplicateValueError, /ruby.enum.errors.messages.duplicate_value.summary/
      end
    end
  end
end
