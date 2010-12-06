module Blacklight
  class TagcloudFacetField

    attr_accessor :facet_name, :value, :hits

    def initialize(facet_name, rsolr_ff)
      @facet_name = facet_name
      @value = rsolr_ff.value
      @hits = rsolr_ff.hits
    end

  end
end

