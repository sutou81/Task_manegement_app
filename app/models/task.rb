class Task < ApplicationRecord
  belongs_to :user
  validates :user_id,  presence: true
  validates :name,  presence: true
  validates :description, presence: true,length: { minimum: 6 }
end
