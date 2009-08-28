class Crumb

  attr_reader :path
  attr_reader :path_key

  def initialize(path)
    @path     = path
    @path_key = path.gsub(/\/[0-9]+\Z/, '/[0-9]+')
  end
  
  def eql?(other)
    path.eql?(other.path) && path_key.eql?(other.path_key)
  end
  
  def friendly_name
    "#{URL_FRIENDLY_NAMES[@path_key] || @path_key}"
  end

end