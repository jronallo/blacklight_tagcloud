module ApplicationHelper
  def tagcloud(opts={})
    Blacklight::Tagcloud.new(opts.merge(:object => self)).tagcloud
  end


end

