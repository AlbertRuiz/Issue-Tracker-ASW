class Issue < ApplicationRecord
	belongs_to :user, :class_name => 'User', optional: true
	belongs_to :user, :class_name => 'User', optional: true
	belongs_to :kind
	belongs_to :priority
	belongs_to :status
	has_many :comments
	has_many :votes
	has_many :watches
	has_attached_file :attachment
	do_not_validate_attachment_file_type :attachment
	validates :title, presence: true

	before_save :default_values
	def default_values
		self.status_id ||= 1
		self.spam ||= false
	end
end
