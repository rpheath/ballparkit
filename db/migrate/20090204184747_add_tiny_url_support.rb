class AddTinyUrlSupport < ActiveRecord::Migration
  def self.up
    add_column :estimates, :short_url, :string
    
    Estimate.all.each do |e|
      Ballpark::UrlShortener.new(e, 'ballparkit.rpheath.com', :force => true).process
    end
  end

  def self.down
    remove_column :estimates, :short_url
  end
end
