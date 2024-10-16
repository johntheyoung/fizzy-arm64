class CreateViews < ActiveRecord::Migration[8.0]
  def change
    create_table :bucket_views do |t|
      t.references :creator, null: false
      t.references :bucket, null: false
      t.json :filters, default: {}, null: false

      t.timestamps
    end
  end
end
