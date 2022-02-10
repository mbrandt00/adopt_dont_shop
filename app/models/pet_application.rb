class PetApplication < ApplicationRecord
after_initialize :default_values

private
    def default_values
      self.application_status ||= "In Progress"
    end
end
