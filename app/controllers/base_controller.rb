class BaseController < ApplicationController
  def site_index    
    User.has_many :asset_development_cases
    @posts = Post.find_recent(:limit => 20)
    @fsaver = Array.new(User.find(:all, :limit=>1, :conditions => {:saver => true}))
    @rss_title = "#{AppConfig.community_name} "+:recent_posts.l
    @rss_url = rss_url
    respond_to do |format|
      format.html { get_additional_homepage_data }
      format.rss do
        render_rss_feed_for(@posts, { :feed => {:title => "#{AppConfig.community_name} "+:recent_posts.l, :link => recent_url},
                              :item => {:title => :title,
                                        :link =>  Proc.new {|post| user_post_url(post.user, post)},
                                         :description => :post,
                                         :pub_date => :published_at}
          })
      end
    end
  end
end
