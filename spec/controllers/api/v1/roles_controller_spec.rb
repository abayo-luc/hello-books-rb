require 'rails_helper'

RSpec.describe Api::V1::RolesController, type: :controller do
  it { should use_before_action(:authenticate_request) }
  it { should use_before_action(:check_super_admin) }
end
