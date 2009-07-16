# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.

class ApplicationController < ActionController::Base
  include ExceptionNotifiable
  helper :all # include all helpers, all the time
  filter_parameter_logging :password #prevent logging of password param
  # See ActionController::RequestForgeryProtection for details
  # Uncomment the :secret if you're not using the cookie session store
  protect_from_forgery # :secret => 'e3a2381ed3c0a1d9a991691d41eb753b'

  # Scrub sensitive parameters from your log
  # filter_parameter_logging :password

#do not log routing errors, unknown actions
#this keeps the log file size from growing unnecessarily
#EXCEPTIONS_NOT_LOGGED = ['ActionController::UnknownAction',
#                         'ActionController::RoutingError']
#protected
#  def log_error(exc)
#    super unless EXCEPTIONS_NOT_LOGGED.include?(exc.class.name)
#  end


  # --------------------------------------------------------------------------
  # create a customized rescue_action_in_public style handler 

  PRODUCTION_LIKE_ENVIRONMENTS = [ 'production', 'demo' ]

  def rescue_action ( exception )
    if PRODUCTION_LIKE_ENVIRONMENTS.include?(RAILS_ENV)
      # show only a pretty error page
      render :template => "common/general_error.html.erb" and return false
    else
      # show the normal stacktrace to aid in debugging
      super exception 
    end

    deliverer = self.class.exception_data
    data = case deliverer
      when nil then {}
      when Symbol then send(deliverer)
      when Proc then deliverer.call(self)
    end

    ExceptionNotifier.deliver_exception_notification(exception, self,
      request, data)

    return false
  end

  # --------------------------------------------------------------------------
  # overide the base action to add logging set handy vars
  def process(request, response, method = :perform_action, *arguments)
    @method_name="#{request.symbolized_path_parameters[:controller].capitalize}.#{request.symbolized_path_parameters[:action]}"
    @request_guid = ActiveSupport::SecureRandom.base64(32)
    logger.prefix = @request_guid
    super
  end

  def perform_action
    logger.debug{"start: #{@method_name}"}
    logger.debug{"session: #{session.inspect}"}
    super
    logger.debug{"end: #{@method_name}"}
  end
  # --------------------------------------------------------------------------



end
