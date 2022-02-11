require 'rails_helper'

RSpec.describe Pet, type: :model do
  describe 'relationships' do
    it { have_many :applications}
    it { have_many :pet_applications}
  end
end
