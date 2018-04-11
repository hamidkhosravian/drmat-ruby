class ApplicationRecord < ActiveRecord::Base
  self.abstract_class = true
  scope :newer, -> { order(id: :desc) }
end
