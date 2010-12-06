# BlacklightTagcloud

module Blacklight
  class Tagcloud
    include Blacklight::SolrHelper
#    include ActionController::UrlWriter
#    include ActionView::Helpers::UrlHelper

    # controller-like params to send to solr
    attr_accessor :params

    # Array of facets from the response which ought to be used to create the tag cloud
    # For instance this can limit the tag cloud to just one facet.
    attr_accessor :fl

    # parameters that can be sent in
    attr_accessor :response, :min_hits, :max_hits, :num_of_ranges

    # calculated values
    attr_reader  :facet_values, :value_sorted_facet_values,
      :hit_sorted_facet_values,  :ranges

    attr_reader :object

    def initialize(opts={})
      @object = opts[:object]
      @params = opts[:params] ||  {}
      @fl = opts[:fl] || []

      @response = opts[:response] || get_solr_response
      @facet_values = set_facet_values
      @value_sorted_facet_values = get_value_sorted_facet_values
      @hit_sorted_facet_values = get_hit_sorted_facet_values
      debugger
      @min_hits = hit_sorted_facet_values.first.hits
      @max_hits = hit_sorted_facet_values.last.hits

      #tag_cloud_opts = opts[:tagcloud] || {}
      @min_font_size = opts[:min_font_size] || 90
      @max_font_size = opts[:max_font_size] || 250
      @num_of_ranges = opts[:num_of_ranges] || 5

      @ranges = set_ranges
    end

    def get_solr_response
      if !@params.empty?
        full_params = solr_search_params.merge(@params)
      else
        config_params = Blacklight.config[:tagcloud] || {}
        full_params = solr_search_params.merge(config_params)
      end
      Blacklight.solr.find(full_params)
    end

    def facets
      @response.facets
    end

    def set_facet_values
      facets.map do |facet|
        #require 'ruby-debug'; debugger
        if @fl.blank? or @fl.include? facet.name.to_sym
          facet.items.map do |facet_item|
            Blacklight::TagcloudFacetField.new(facet.name,facet_item)
          end
        end
      end.flatten.compact
    end

    def get_value_sorted_facet_values
      facet_values.sort_by{|fv| fv.value}
    end

    def get_hit_sorted_facet_values
      facet_values.sort_by{|fv| fv.hits}
    end

    def tagcloud
      cloud = '<div class="blacklight_tagcloud">'
      value_sorted_facet_values.map do |ff|
        cloud << %Q| <span style="font-size:#{font_size(ff)}%" class="tagcloud#{range(ff)}">|
        cloud << @object.link_to(ff.value, @object.send(:catalog_index_path, {"f[#{ff.facet_name}][]" => ff.value}) )
        cloud << '</span> '
      end
      cloud << '</div>'
    end

    def range(facet_field)
      ranges.each_with_index do |range, index|
        return index + 1 if range.include? facet_field.hits
      end
    end

    def set_ranges
      #require 'ruby-debug'; debugger
      range_step = @max_hits / @num_of_ranges
      range_step = range_step == 0 ? 1 : range_step
      array_of_ranges = []
      full_range = @min_hits..@max_hits
      full_range.step(range_step) do |bottom|
        array_of_ranges << (bottom..(bottom + (range_step-1)))
      end
      array_of_ranges
    end

    # http://blogs.dekoh.com/dev/2007/10/29/choosing-a-good-font-size-variation-algorithm-for-your-tag-cloud/
    def font_size(facet_field)
      begin
        weight = (Math.log(facet_field.hits)-Math.log(@min_hits))/(Math.log(@max_hits)-Math.log(@min_hits))
        @min_font_size + ((@max_font_size-@min_font_size) * weight.to_f).round
      rescue
        @min_font_size
      end
    end


  end
end

