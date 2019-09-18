# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ApplicationController do
  describe 'before actions' do
    context 'skipped action' do
      it { should use_before_action(:authenticate_request) }
    end
  end
end
