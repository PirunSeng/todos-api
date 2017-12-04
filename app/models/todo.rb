class Todo < ActiveRecord::Base
  has_many :items, dependent: :destroy

  validates :title, :created_by, presence: true
end
