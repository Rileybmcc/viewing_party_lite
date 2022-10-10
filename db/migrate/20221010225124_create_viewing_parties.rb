class CreateViewingParties < ActiveRecord::Migration[5.2]
  def change
    create_table :viewing_parties do |t|
      t.string :movie_title
      t.time :start_time
      t.date :date
      t.integer :length
      t.timestamps
    end
  end
end
