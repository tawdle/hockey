class CreateSystemNames < ActiveRecord::Migration
  class SystemName < ActiveRecord::Base
    belongs_to :nameable, :polymorphic => true
    attr_accessible :name, :nameable_id, :nameable_type
  end

  class User < ActiveRecord::Base
    belongs_to :nameable, :polymorphic => true
  end

  class Mention < ActiveRecord::Base
    belongs_to :user
  end

  class Following < ActiveRecord::Base
    belongs_to :user
    belongs_to :target, :class_name => "User"
  end

  def up
    create_table :system_names do |t|
      t.string :name, :null => false
      t.references :nameable, :polymorphic => true, :null => false
    end

    # See http://stackoverflow.com/questions/7948501/case-insensitive-unique-index-in-rails-activerecord
    execute "CREATE UNIQUE INDEX index_system_names_on_lowercase_name
             ON system_names USING btree (lower(name));"

    add_index :system_names, [:nameable_id, :nameable_type], :unique => true

    # Copy over all the names and their back-references
    User.all.each do |user|
      nameable_id = user.nameable_id || user.id
      nameable_type = user.nameable_type || "User"
      SystemName.create!(:name => user.name, :nameable_id => nameable_id, :nameable_type => nameable_type)
    end

    # Move mentions
    add_column :mentions, :system_name_id, :integer
    add_index :mentions, :system_name_id

    Mention.all.each do |mention|
      mention.update_attribute(:system_name_id, SystemName.find_by_name(mention.user.name).id)
    end

    # Move Followings
    add_column :followings, :system_name_id, :integer
    add_index :followings, :system_name_id

    Following.all.each do |following|
      following.update_attribute(:system_name_id, SystemName.find_by_name!(following.target.name).id)
    end

    # And then delete stuff!
    User.where("nameable_id is not null").each do |user|
      user.destroy
    end

    remove_column :users, :nameable_id
    remove_column :users, :nameable_type
    remove_column :mentions, :user_id
    remove_column :followings, :target_id
  end
end
