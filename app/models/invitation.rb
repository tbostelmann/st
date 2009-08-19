class Invitation
  
  attr_accessor :title, :message, :friends
  attr_reader   :errors
  
  def initialize(args = nil)
    args.each{|key, value| self.send(key.to_s + "=", value)} if args
  end
  
  def email_list
    friends.split(/[ ,;]+/)
  end
  
  def is_valid?
    validate
    @errors.size == 0
  end
  
protected

  def validate
    @errors = []
    email_list.each{|email| validate_email(email)}
  end

  def validate_email(email)
    @errors << "\"#{email}\" is not a valid format" unless email =~ /^([^@\s]+)@((?:[-a-z0-9A-Z]+\.)+[a-zA-Z]{2,})$/
  end
  
end