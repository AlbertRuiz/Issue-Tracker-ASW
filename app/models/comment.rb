class Comment < ApplicationRecord
  belongs_to :user
  belongs_to :issue

  validates :user_id, presence: true
  validates :issue_id, presence: true
  validates :description, presence: true

  before_save :default_values
  def default_values
    self.spam ||= false
  end
end
