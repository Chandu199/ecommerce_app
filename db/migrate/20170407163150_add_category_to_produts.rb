class AddCategoryToProduts < ActiveRecord::Migration
  def change
  	category = Category.create! name: "Not Available"
    add_reference :products, :category, index: true, foreign_key: true, default: category.id
  end
end
