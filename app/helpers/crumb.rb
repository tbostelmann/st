class Crumb

  # path is any path.
  attr_reader :path

  # path_key is a combo-regex and key configured in the url_friendly_names.yml. The key is
  # used for both matching against the bread crumb list (for finding existing paths in the
  # list) and as a key for the app-designer friendly name to replace the URL with in display.
  attr_reader :path_key

  def initialize(path)
    @path     = path
    @path_key = map_path_to_regex(@path)
  end
  
  def eql?(other)
    path.eql?(other.path) && path_key.eql?(other.path_key)
  end
  
  def friendly_name
    "#{URL_FRIENDLY_NAMES[@path_key] || @path_key}"
  end

protected

  def map_path_to_regex(path)
    URL_FRIENDLY_NAMES.each_key do |regex|
      return regex if path =~ /\A#{Regexp.new(regex)}\Z/
    end
    path
  end

end