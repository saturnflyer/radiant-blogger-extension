class CreateBloggerArticles < ActiveRecord::Migration
  def self.up
    create_table :blogger_articles do |t|
      t.string :title, :null => false
      t.string :url, :null => false
      t.text :content, :null => false
      t.datetime :date_published
    end
    add_index :blogger_articles, :url, :unique => true
  end

  def self.down
    drop_table :blogger_articles
  end
end
