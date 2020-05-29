module Scrappers
  class EtendersTreasury
    include ActionView::Helpers::SanitizeHelper

    SITE_URL = "https://etenders.treasury.gov.za/content/advertised-tenders"

    def self.call
      new.call
    end

    def call
      scraper
    end

    private
      def scraper
        fetch_tender_listings
          .then { |listings| extract_table_rows(listings) }
          # .then { |urls| fetch_bursary_pages(urls) }
          # .then { |pages| extract_bursary_objects(pages) }
          # .then { |b_objects| save_bursary_objects(b_objects) }
      end

      def fetch_tender_listings
        get_page(SITE_URL)
      end

      def extract_table_rows(listings)
        listings.css('div.view-content table.views-table.cols-6 tbody tr').each do |row|
          row.children.map(&:text).map(&:strip)
        end
      end

      def get_page(url)
        Nokogiri::HTML(HTTParty.get(url))
      end

  end
end