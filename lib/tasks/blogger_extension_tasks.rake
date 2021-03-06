require 'open-uri'
require 'rexml/document'

namespace :blogger do
  desc "Runs the migration of the Blogger extension"
  task :migrate => :environment do
    require 'radiant/extension_migrator'
    if ENV["VERSION"]
      BloggerExtension.migrator.migrate(ENV["VERSION"].to_i)
    else
      BloggerExtension.migrator.migrate
    end
  end
  
  desc "Copies public assets of the Blogger to the instance public/ directory."
  task :update => :environment do
    is_svn_or_dir = proc {|path| path =~ /\.svn/ || File.directory?(path) }
    puts "Copying assets from BloggerExtension"
    Dir[BloggerExtension.root + "/public/**/*"].reject(&is_svn_or_dir).each do |file|
      path = file.sub(BloggerExtension.root, '')
      directory = File.dirname(path)
      mkdir_p RAILS_ROOT + directory, :verbose => false
      cp file, RAILS_ROOT + path, :verbose => false
    end
  end

  desc "Imports blog articles from blogger"
  task :import_articles => :environment do
    BloggerArticle.delete(BloggerArticle.find(:all))
    stream = ENV['RSS_FEED']
    data = open(stream, 'User-Agent' => 'Ruby-Wget').read
    doc = REXML::Document.new(data)
    doc.root.each_element('//item') do |item|
      article = BloggerArticle.create(
        :title => item.elements["title"].text,
        :url => item.elements["link"].text,
        :content => item.elements["description"].text.gsub(/<\/?[^>]*>/, ""),
        :date_published => item.elements["pubDate"].text
      )   
    end 
  end 
end
