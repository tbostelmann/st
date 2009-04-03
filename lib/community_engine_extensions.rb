module ActsLikeSaver
  def ActsLikeSaver.append_features(someClass)
    def someClass.build_conditions_for_search(search)
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
  end
end