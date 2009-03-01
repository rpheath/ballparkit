class UpdatePublicUrlsForNewDomain < ActiveRecord::Migration
  def self.up
    Estimate.all.each do |e|
      Ballpark::UrlShortener.new(e, 'ballparkitapp.com', :force => true).process
    end
  end

  def self.down
  end
end
