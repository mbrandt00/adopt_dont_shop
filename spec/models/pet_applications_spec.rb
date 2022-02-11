require 'rails_helper'

RSpec.describe PetApplication do
  context 'associations' do
    it {should belong_to(:application)}
    it {should belong_to(:pet)}
  end
end
