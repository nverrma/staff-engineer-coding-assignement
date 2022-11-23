# Requests to Acme's API are timing out after 15 seconds. After some investigation in production, they've identified that the `User#count_hits` method's response time is around 500ms and is called 50 times per second (on average).


# We can use counter cache to get count of the associated data. But counter cache doesn't provide a way to count associated data with a condition. But we can achieve this through gem 'counter culture',
# So I added gem counter_culture in the Gemfile.
# Added a column hits_count in the User table.
# It'll eleminate the use of the method, we can get user's hit count by "user.hits_count".

class User < ApplicationRecord
	has_many :hits
end

class Hit < ApplicationRecord
	belongs_to :user
  counter_culture :user, column_name: proc {|model| model.created_at > Time.now.beginning_of_month ? 'hits_count' : nil }
end

class ApplicationController < ActionController::API
	before_filter :user_quota

	def user_quota
		render json: { error: 'over quota' } if current_user.hits_count >= 10000
  end
end