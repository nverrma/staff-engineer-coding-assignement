# Users in Australia are complaining they still get some “over quota” errors from the API after their quota resets at the beginning of the month and after a few hours it resolves itself. A user provided the following access logs:

# This is a time zone issue, Time.now returns systems time, So that may be causing problem for the australian users.
# We can fix this issue by using Time.zone.now
class User < ApplicationRecord
	has_many :hits

	def count_hits
		start = Time.zone.now.beginning_of_month
		hits = hits.where('created_at > ?', start).count
		return hits
  end
end

class ApplicationController < ActionController::API
	before_filter :user_quota

	def user_quota
		render json: { error: 'over quota' } if current_user.count_hits >= 10000
  end
end