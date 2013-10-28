class CreateMarkers < Migration::TableMigration
  def change
    create_table :markers do |t|
      t.references :user
      t.references :marker_category
      t.string :title
      t.text :description
      t.float :latitude
      t.float :longitude

    end
  end
end
