require 'community_engine_extensions'
User.has_many :asset_development_cases
ActsLikeSaver.append_features(User)
