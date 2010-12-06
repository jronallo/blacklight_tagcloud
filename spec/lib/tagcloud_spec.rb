require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe "Blacklight::Tagcloud" do

  describe 'default settings' do
    before(:all) do
      @tc = Blacklight::Tagcloud.new(:object => Blacklight::TagCloudTestClass.new)
    end

    it 'should get a solr response' do
      @tc.response.should be_a_kind_of(Hash)
    end

    it 'should get the facets' do
      @tc.facets.should be_a_kind_of(Array)
      @tc.facets.first.should be_a_kind_of(RSolr::Ext::Response::Facets::FacetField)
    end

    it 'should get all the facet values' do
      @tc.facet_values.length.should == 56
    end

    it 'should sort them lexically' do
      @tc.value_sorted_facet_values.first.value.should == '1941'
      @tc.value_sorted_facet_values[1].value.should == '1946'
      @tc.value_sorted_facet_values.last.value.should == 'Women'
      @tc.value_sorted_facet_values[-2].value.should == 'Urdu'
    end

    it 'should sort them by hit count' do
      @tc.hit_sorted_facet_values.first.hits.should == 1
      @tc.hit_sorted_facet_values.last.hits.should == 30
    end

    it 'should store a min_hits value' do
      @tc.min_hits = 1
    end

    it 'should store a max_hits value' do
      @tc.max_hits = 30
    end

    it 'should create an appropriate font size' do
      @tc.font_size(@tc.hit_sorted_facet_values.first).should == 90
      @tc.font_size(@tc.hit_sorted_facet_values.last).should == 250
    end

    it 'should have a num_of_ranges' do
      @tc.num_of_ranges.should == 5
    end

    it 'should give back ranges to match against' do
      @tc.ranges.should == [1..6, 7..12, 13..18, 19..24, 25..30]
    end

    it 'should create an appropriate range class for the range of hits it falls in' do
      @tc.range(@tc.hit_sorted_facet_values.first).should == 1
      @tc.range(@tc.hit_sorted_facet_values.last).should == 5
    end

    it 'should create a tagcloud' do
      @tc.tagcloud.should be_a_kind_of(String)
    end
  end

  describe 'Blacklight.config configured setup results' do
    before(:all) do
      Blacklight.config[:tagcloud] = {:"facet.field" => ['subject_topic_facet'],
        :"f.subject_topic_facet.facet.limit" => 7, :per_page => 1}
      @tc = Blacklight::Tagcloud.new(:object => Blacklight::TagCloudTestClass.new)
    end

    it 'should only have subject_topic_facet values' do
      @tc.facet_values.length.should == 7
    end
  end

  describe 'options parameters configured setup results' do
    before(:all) do
      @params = {:qt=>"search", :per_page=>10, "spellcheck.q"=>nil,
                    :"facet.field"=>["format", "pub_date", "subject_topic_facet",
                    "language_facet", "lc_1letter_facet", "subject_geo_facet",
                    "subject_era_facet"], :"f.subject_topic_facet.facet.limit"=>21}
      @tc = Blacklight::Tagcloud.new(:object => Blacklight::TagCloudTestClass.new,
        :min_font_size => 80, :max_font_size => 300, :num_of_ranges => 2,
        #solr params
        :params => @params
        )
    end

    it 'should create an appropriate font size' do
      @tc.font_size(@tc.hit_sorted_facet_values.first).should == 80
      @tc.font_size(@tc.hit_sorted_facet_values.last).should == 300
    end

    it 'should have a num_of_ranges' do
      @tc.num_of_ranges.should == 2
    end

    it 'should give back ranges to match against' do
      @tc.ranges.should == [1..15, 16..30]
    end

    describe "if a field list (:fl) is set" do
      before(:all) do
        @tc = Blacklight::Tagcloud.new(:object => Blacklight::TagCloudTestClass.new,
        :min_font_size => 80, :max_font_size => 300, :num_of_ranges => 2,
        #solr params
        :params => @params, :fl => [:subject_topic_facet]
        )
      end

      it 'should only display subject topics in the tag cloud' do
        @tc.facet_values.length.should == 21
      end
    end

  end



end

