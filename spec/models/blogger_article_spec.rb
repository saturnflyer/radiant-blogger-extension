require File.dirname(__FILE__) + '/../spec_helper'

describe BloggerArticle do
  before(:each) do
    @blogger_article = BloggerArticle.new
  end

  it "should be valid" do
    @blogger_article.should be_valid
  end
end
