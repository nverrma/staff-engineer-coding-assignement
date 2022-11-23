# Acme's development team has reported working with the code base is difficult due to accumulated technical debt and bad coding practices. They've asked the community to help them refactor the code so it's clean, readable, maintainable, and well-tested.

class User < ApplicationRecord
	has_many :hits

  scope :total_hits, -> { where('created_at > ?', Time.now.beginning_of_month) }
end

class ApplicationController < ActionController::API
	before_action :user_quota

	def user_quota
		render json: { error: 'over quota' } if current_user.total_hits.count >= 10000
  end
end