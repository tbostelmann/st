# require 'logger'
require 'time'

class MessageLogger < Logger

  attr_writer :prefix
    
  def format_message(severity, timestamp, progname, msg)
    msg.gsub!(/^\n+/, '')
    log_site = Kernel.caller(3).first
    log_site &&= log_site[log_site.rindex('/') + 1, log_site.size]
    "#{timestamp.utc.strftime("%Y-%m-%d %H:%M:%S %Z") } #{@prefix ? (@prefix + ' ') : ''}#{severity} [#{log_site}] #{msg}\n"
  end

  # TODO: why is this not in the super class ?
  def flush
    # super 
    # self.info "FLUSH_CALLED"
  end

  def initialize(progname, *args)
    @progname = progname
    super(*args)
  rescue Exception => e
    super(STDOUT)
    self.error "Failed to create ErrorLogger(#{args.join(', ')}) #{e.class}: #{e.message}"
  end

end
