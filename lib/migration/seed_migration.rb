class Migration::SeedMigration < Migration::BaseMigration

  def extend_create_table_block(table_name, options = {}, &block)
    ->(t) do

      yield t

    end
  end

end