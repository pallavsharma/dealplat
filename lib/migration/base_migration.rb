# note: use one of BaseMigration child classes as parent for instantiated migrations in db/migrate
# note: keep using the chosen class as base class for all future migrations of the entity (including change table migrations etc.)
class Migration::BaseMigration < ActiveRecord::Migration

  BASE_MIGRATION_CHILDREN_NAMES = %w(Migration::TableMigration Migration::SeedMigration)

  def self.inherited(child_class)
    super
    unless BASE_MIGRATION_CHILDREN_NAMES.include?(child_class.name) || (child_class.ancestors.map(&:name) & BASE_MIGRATION_CHILDREN_NAMES).any?
      raise "#{child_class.name} mistakenly inherits from BaseMigration - use one of BaseMigration child classes as parent for #{child_class.name}\n"
    end
  end

  def extend_create_table_block(table_name, options = {}, &block)
    ->(t) {
      # add before-block columns in derived classes
      yield t
      # add after-block columns in derived classes
    }
  end

  def create_table(table_name, options = {}, &block)
    extended_block = extend_create_table_block(table_name, options, &block)
    ActiveRecord::Migration::create_table(table_name, options, &extended_block)
  end

end
