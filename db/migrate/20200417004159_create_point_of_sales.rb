class CreatePointOfSales < ActiveRecord::Migration[5.2]
  def change
    create_table :point_of_sales do |t|
      t.string :trading_name, null: false
      t.string :owner_name, null: false
      t.string :document, null: false
      t.multi_polygon :coverage_area, null: false
      t.point :address, null: false

      t.timestamps null: false

      t.index :coverage_area, type: :spatial
    end
  end
end
