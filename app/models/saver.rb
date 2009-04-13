# == Schema Information
# Schema version: 20090408231608
#
# Table name: users
#
#  id                        :integer(4)      not null, primary key
#  login                     :string(255)
#  email                     :string(255)
#  description               :text
#  avatar_id                 :integer(4)
#  crypted_password          :string(40)
#  salt                      :string(40)
#  created_at                :datetime
#  updated_at                :datetime
#  remember_token            :string(255)
#  remember_token_expires_at :datetime
#  stylesheet                :text
#  view_count                :integer(4)      default(0)
#  vendor                    :boolean(1)
#  activation_code           :string(40)
#  activated_at              :datetime
#  state_id                  :integer(4)
#  metro_area_id             :integer(4)
#  login_slug                :string(255)
#  notify_comments           :boolean(1)      default(TRUE)
#  notify_friend_requests    :boolean(1)      default(TRUE)
#  notify_community_news     :boolean(1)      default(TRUE)
#  country_id                :integer(4)
#  featured_writer           :boolean(1)
#  last_login_at             :datetime
#  zip                       :string(255)
#  birthday                  :date
#  gender                    :string(255)
#  profile_public            :boolean(1)      default(TRUE)
#  activities_count          :integer(4)      default(0)
#  sb_posts_count            :integer(4)      default(0)
#  sb_last_seen_at           :datetime
#  role_id                   :integer(4)
#  saver                     :boolean(1)
#

class Saver < User
  def self.build_conditions_for_search(search)
    cond = Caboose::EZ::Condition.new

    cond.append ['activated_at IS NOT NULL ']
    cond.saver == true
    if search['country_id'] && !(search['metro_area_id'] || search['state_id'])
      cond.append ['country_id = ?', search['country_id'].to_s]
    end
    if search['state_id'] && !search['metro_area_id']
      cond.append ['state_id = ?', search['state_id'].to_s]
    end
    if search['metro_area_id']
      cond.append ['metro_area_id = ?', search['metro_area_id'].to_s]
    end
    if search['login']
      cond.login =~ "%#{search['login']}%"
    end
    if search['vendor']
      cond.vendor == true
    end
    if search['description']
      cond.description =~ "%#{search['description']}%"
    end
    cond
  end

  def self.find_country_and_state_from_search_params(search)
    country = Country.find(search['country_id']) if !search['country_id'].blank?
    state = State.find(search['state_id']) if !search['state_id'].blank?
    metro_area = MetroArea.find(search['metro_area_id']) if !search['metro_area_id'].blank?
    asset_type = AssetType.find(search['asset_type_id']) if !search['asset_type_id'].blank?

    if metro_area && metro_area.country
      country ||= metro_area.country
      state ||= metro_area.state
      search['country_id'] = metro_area.country.id if metro_area.country
      search['state_id'] = metro_area.state.id if metro_area.state
    end
    search['asset_type_id'] = asset_type.id if asset_type

    states = country ? country.states.sort_by{|s| s.name} : []
    if states.any?
      metro_areas = state ? state.metro_areas.all(:order => "name") : []
    else
      metro_areas = country ? country.metro_areas : []
    end

    return [metro_areas, states, asset_type]
  end

  def self.paginated_users_conditions_with_search(params)
    search = prepare_params_for_search(params)

    metro_areas, states, asset_types = find_country_and_state_from_search_params(search)

    cond = build_conditions_for_search(search)
    return cond, search, metro_areas, states, asset_types
  end
end
