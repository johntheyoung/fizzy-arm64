class CreateWatches < ActiveRecord::Migration[8.1]
  def change
    create_table :watches do |t|
      t.references :user, null: false, foreign_key: true
      t.references :bubble, null: false, foreign_key: true
      t.boolean :watching, null: false, default: true

      t.timestamps
    end
  end
end
