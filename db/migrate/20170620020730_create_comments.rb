class CreateComments < ActiveRecord::Migration[5.1]
  def change
    create_table :comments do |t|
      t.references :post, index: true

      t.string :author
      t.string :comment

      t.timestamps
    end
  end
end
