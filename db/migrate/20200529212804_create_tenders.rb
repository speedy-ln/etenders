class CreateTenders < ActiveRecord::Migration[6.0]
  def change
    create_table :tenders do |t|
      t.string :category
      t.string :tender_description
      t.string :tender_number

      t.timestamp :date_published
      t.timestamp :closing_date
      t.timestamp :briefing_session

      t.timestamps
    end
  end
end
