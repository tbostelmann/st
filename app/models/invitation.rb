class Invitation
  
  attr_accessor :title, :message, :friends, :limit
  attr_reader   :errors
  
  def initialize(args = nil)
    @limit = 10
    args.each{|key, value| self.send(key.to_s + "=", value)} if args
  end
  
  def email_list
    if @email_list == nil
      @email_list = friends.strip.split(/[ ,;]+/)
    end
    @email_list
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
    email_list.each{|email| validate_email(email)}
    validate_limit
  end

  def validate_email(email)
    @errors << "\"#{email}\" is not a valid email address" unless email =~ /^([^@\s]+)@((?:[-a-z0-9A-Z]+\.)+[a-zA-Z]{2,})$/
  end
  
  def validate_limit
    @errors << "More than #{limit} email addresses where invited" unless email_list.size <= @limit
  end
  
end