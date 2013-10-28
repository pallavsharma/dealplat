class CreateMarkerCategories < Migration::SeedMigration
  def change

    create_table :marker_categories do |t|
      t.string :name
      t.string :code
    end

  end
end
