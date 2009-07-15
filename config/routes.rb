ActionController::Routing::Routes.draw do |map|
  # The priority is based upon order of creation: first created -> highest priority.

  # Sample of regular route:
  #   map.connect 'products/:id', :controller => 'catalog', :action => 'view'
  # Keep in mind you can assign values other than :controller and :action

  # Sample of named route:
  #   map.purchase 'products/:id/purchase', :controller => 'catalog', :action => 'purchase'
  # This route can be invoked with purchase_url(:id => product.id)

  # Sample resource route (maps HTTP verbs to controller actions automatically):
  #   map.resources :products

  # Sample resource route with options:
  #   map.resources :products, :member => { :short => :get, :toggle => :post }, :collection => { :sold => :get }

  # Sample resource route with sub-resources:
  #   map.resources :products, :has_many => [ :comments, :sales ], :has_one => :seller
  
  # Sample resource route with more complex sub-resources
  #   map.resources :products do |products|
  #     products.resources :comments
  #     products.resources :sales, :collection => { :recent => :get }
  #   end

  # Sample resource route within a namespace:
  #   map.namespace :admin do |admin|
  #     # Directs /admin/products/* to Admin::ProductsController (app/controllers/admin/products_controller.rb)
  #     admin.resources :products
  #   end

  # You can have the root of your site routed with map.root -- just remember to delete public/index.html.

  # See how all your routes lay out with "rake routes"

  # Re-route signup to the donors controller - signup is for donors only
  map.signup          '/signup',          :controller => 'donors', :action => 'new'
  map.signup_or_login '/signup_or_login', :controller => 'donors', :action => 'signup_or_login'
  
  # New base actions
  map.how_it_works    '/how_it_works',    :controller => 'base',   :action => 'how_it_works'
  map.do_more         '/do_more',         :controller => 'base',   :action => 'do_more'
  map.feedback        '/feedback',        :controller => 'base',   :action => 'feedback' 
  map.about_us        '/about_us',        :controller => 'base',   :action => 'about_us'
  map.terms_of_use    '/terms_of_use',    :controller => 'base',   :action => 'terms_of_use'
  map.privacy_policy  '/privacy_policy',  :controller => 'base',   :action => 'privacy_policy'
  # map.resources gives us RESTful routes to these models
  # Run rake routes to see the list (these will be the first listed)
  map.resources :savers
  map.resources :donors
  map.resources :organizations
  map.resources :donor_surveys
  
#  map.resources  :pledges
  map.new          '/pledges/new/:saver_id', :controller => 'pledges', :action => 'new'
  map.create       '/pledges/create',        :controller => 'pledges', :action => 'create'
  map.done         '/pledges/done',          :controller => 'pledges', :action => 'done'
  map.cancel       '/pledges/cancel',        :controller => 'pledges', :action => 'cancel'
  map.notify       '/pledges/notify',        :controller => 'pledges', :action => 'notify'
  map.signup_after '/signup/:pledge_id',     :controller => 'donors',  :action => 'new'

  # Any route ST app-specific should come before the community engine routes
  map.from_plugin :community_engine

  # Install the default routes as the lowest priority.
  # Note: These default routes make all actions in every controller accessible via GET requests. You should
  # consider removing the them or commenting them out if you're using named routes and resources.
  map.connect ':controller/:action/:id'
  map.connect ':controller/:action/:id.:format'
end
