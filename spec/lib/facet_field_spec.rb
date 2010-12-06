require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe "Blacklight::TagcloudFacetField" do
  before(:all) do
    rsolr_facet_field = RSolr::Ext::Response::Facets::FacetItem.new('test facet value', 1)
    @facet_name = 'test_facet'
    @ff = Blacklight::TagcloudFacetField.new(@facet_name, rsolr_facet_field)
  end

  it 'should be able to create a facet field' do
    @ff.should be_a_kind_of(Blacklight::TagcloudFacetField)
  end

  it 'should have a facet name' do
    @ff.facet_name.should == @facet_name
  end

  it 'should have a facet value' do
    @ff.value.should == 'test facet value'
  end

  it 'should have hits' do
    @ff.hits.should == 1
  end

end

