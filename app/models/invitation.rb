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

  def validate_email(email)
    @errors << "\"#{email}\" is not a valid email address" unless email =~ /^([^@\s]+)@((?:[-a-z0-9A-Z]+\.)+[a-zA-Z]{2,})$/
  end
  
  def validate_minimum
    @errors << "At least one email address must be provided" unless emails.size > 0
  end
  
  def validate_limit
    @errors << "No more than #{limit} email addresses may be provided" unless emails.size <= @limit
  end
  
end