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
          table_row = row.children.map(&:text).map(&:strip).reject(&:blank?)

          if table_row.count == 6
            Tender.create(
              category: table_row[0],
              tender_description: table_row[1],
              tender_number: table_row[2],
              date_published: DateTime.parse(table_row[3]),
              closing_date: DateTime.parse(table_row[4]),
              briefing_session: DateTime.parse(table_row[5])
            )
          end

        end
      end

      def get_page(url)
        Nokogiri::HTML(HTTParty.get(url))
      end

  end
end