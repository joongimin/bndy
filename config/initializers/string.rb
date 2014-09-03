class String
  def html
    self.gsub(/\r\n|\r|\n/, '<br>').html_safe
  end
end