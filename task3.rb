# Acme identified that some users have been able to make API requests over the monthly limit.

# This is also an issue of timezone, As if a Time zone is ahead of the servers time zone, Then the user can get some extra hits on the API


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
