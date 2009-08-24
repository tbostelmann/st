class Invitation
  
  attr_accessor :title, :message, :friends, :limit
  attr_reader   :errors
  
  def initialize(args = nil)
    args.each{|key, value| self.send(key.to_s + "=", value)} if args
    @title   = "" unless @title
    @message = "" unless @message
    @friends = "" unless @friends
    @limit   = 10 unless @limit
  end
  
  def emails
    if @cached_emails == nil
      @cached_emails = @friends.split(/[,;\r\n]+/).collect(&:strip).uniq
    end
    @cached_emails
  end
  
  def is_valid?
    if @errors == nil
      validate
    end
    @errors.size == 0
  end
  
protected

  def validate
    @errors = []
    emails.each{|email| validate_email(email)}
    validate_minimum
    validate_limit
  end
  
  # This validates using the standard email validation we've used throughout, but it
  # also allows this condition "Doogie Browser <doogieb@foobar.com>", i.e. the address
  # embedded in < > with freeform text as a friendly name. This should allow for easy
  # exporting of names from a variety of email programs without burdening users with
  # cleanup tasks before importing them into our invitation form.
  
  # You should *not* use this validator to *store* any addresses, only use the tighter
  # version of validation for that (or process after). These emails are intended to
  # immediately be used to queue up invitations, so the decision is to favor the user.

  ADDRESS_PORTION       = "([^@\s]+)@((?:[-a-z0-9A-Z]+\.)+[a-zA-Z]{2,})".freeze

  # Currently the only chars not allowed in friendly format are:
  # []\ These are regex character class control chars - hard to get into string escaped (I haven't figured out how)
  # `'" Various quotes can't be part of friendly name and are hard to get into string escaped
  # | Pipe appears to be unacceptable to emailers - they'll split the name in two at a pipe char
  # ,; These are our list separator charactrs

  # Everything else appears acceptable
  
  FRIENDLY_FORMAT_BEGIN = "[-A-Za-z0-9.:!?_#={}~@$%^&*() \t]*<".freeze
  FRIENDLY_FORMAT_END   = ">".freeze

  def validate_email(email)
    @errors << "\"#{email}\" is not a valid email address" unless \
      email =~ /^#{ADDRESS_PORTION}$|^#{FRIENDLY_FORMAT_BEGIN}#{ADDRESS_PORTION}#{FRIENDLY_FORMAT_END}$/
  end
  
  def validate_minimum
    @errors << "At least one email address must be provided" unless emails.size > 0
  end
  
  def validate_limit
    @errors << "No more than #{limit} email addresses may be provided" unless emails.size <= @limit
  end
  
end