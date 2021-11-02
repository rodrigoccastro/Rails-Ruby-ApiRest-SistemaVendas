class CreateProductsales < ActiveRecord::Migration[6.1]
  def change
    create_table :productsales do |t|
      t.references :sale, null: false, foreign_key: true
      t.references :product, null: false, foreign_key: true
      t.float :value
      t.integer :quantity

      t.timestamps
    end
  end
end
