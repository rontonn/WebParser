class CreateAndroids < ActiveRecord::Migration
  def change
    create_table :androids do |t|
      t.integer :rank
      t.string :title
      t.string :downloads
      t.string :price
      t.text :comments

      t.timestamps
    end
  end
end
