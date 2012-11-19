class CreatePosts < ActiveRecord::Migration
  def change
    create_table :posts do |t|
      t.string :title
      t.text :raw_body
      t.text :rendered_body
      t.datetime :published_at
      t.integer :user_id
      
      # Columns for postable associations; stores information about the resource to which the post belongs
      t.references :postable, polymorphic: true

      t.timestamps
    end
  end
end
