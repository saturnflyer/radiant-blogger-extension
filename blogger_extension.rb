class BloggerExtension < Radiant::Extension
  version "1.0"
  description "Blogger Integration Extension"
  url "http://www.endpoint.com/"
  
  def activate
    Page.send :include, Blogger
  end
  
  def deactivate
  end
end
