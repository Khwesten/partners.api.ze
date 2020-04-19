class MakeDocumentUnique < ActiveRecord::Migration[5.2]
  def change
    add_index :point_of_sales, :document, unique: true
  end
end
