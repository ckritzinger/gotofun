class Activity < ApplicationRecord
    validates :status, inclusion: {in: %w[PUBLIC PRIVATE]}
end
