class CreateArtigos < ActiveRecord::Migration[8.0]
  def change
    create_table :artigos do |t|
      t.string :titulo
      t.text :body
      t.json :metadata

      t.timestamps
    end
  end
end
