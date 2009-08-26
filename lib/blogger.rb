module Blogger
  include Radiant::Taggable

  tag 'blogger_articles' do |tag|
    limit = tag.attributes['limit'] ? tag.attributes['limit'].to_i : 10
    sort = tag.attributes['sort'] || 'date_published DESC'
    tag.locals.articles ||= BloggerArticle.find(:all, :limit => limit, :order => sort)
    tag.expand
  end

  tag 'blogger_articles:full' do |tag|
    tag.expand if tag.locals.articles.size > 0
  end

  tag 'blogger_articles:empty' do |tag|
    tag.expand if tag.locals.articles.size < 1
  end

  tag 'blogger_articles:each' do |tag|
    result = []
    tag.locals.articles.each do |a|
      tag.locals.article = a
      result << tag.expand
    end
    result
  end
  tag 'blogger_articles:each:blogger_article' do |tag|
    '<a href="' + tag.locals.article.url + '">' + tag.locals.article.title + '</a>'
  end

  tag 'news_blogger_articles' do |tag|
    if !tag.locals.articles
      articles = []
      blogger_limit = tag.attributes['blogger_limit'] ? tag.attributes['blogger_limit'].to_i : 5
      blogger_sort = tag.attributes['blogger_sort'] || 'date_published DESC'
      BloggerArticle.find(:all, :limit => blogger_limit, :order => blogger_sort).each do |article|
        articles << { 'timestamp' => article.date_published.strftime("%Y%m%d%H%M%S"), 'title' => article.title, 'url' => article.url }
      end
      news_limit = tag.attributes['news_limit'] ? tag.attributes['news_limit'].to_i : 5
      news_sort = tag.attributes['news_sort'] || 'published_at DESC'
      Page.find_all_by_parent_id(Page.find_by_slug('articles').id, :limit => news_limit, :order => news_sort).each do |article|
        articles << { 'timestamp' => article.published_at.strftime("%Y%m%d%H%M%S"), 'title' => article.title, 'url' => article.url }
      end
      tag.locals.articles = articles.sort_by { |a| a['timestamp'] }.reverse
    end
    tag.expand
  end

  tag 'news_blogger_articles:full' do |tag|
    tag.expand if tag.locals.articles.size > 0
  end

  tag 'news_blogger_articles:empty' do |tag|
    tag.expand if tag.locals.articles.size < 1
  end

  tag 'news_blogger_articles:each' do |tag|
    result = []
    tag.locals.articles.each do |a|
      tag.locals.article = a
      result << tag.expand
    end
    result
  end
  tag 'news_blogger_articles:each:news_blogger_article' do |tag|
    '<a href="' + tag.locals.article['url'] + '">' + tag.locals.article['title'] + '</a>'
  end
end
