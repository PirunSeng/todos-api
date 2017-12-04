class Item < ActiveRecord::Base
  belongs_to :todo

  validates :name, presence: true, uniqueness: { case_sensitive: false }
end
