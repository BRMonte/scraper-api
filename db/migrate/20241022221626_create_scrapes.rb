class CreateScrapes < ActiveRecord::Migration[7.2]
  def change
    create_table :scrapes do |t|
      t.timestamps
    end
  end
end
