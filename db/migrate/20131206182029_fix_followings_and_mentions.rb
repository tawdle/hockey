class FixFollowingsAndMentions < ActiveRecord::Migration
  class Mention < ActiveRecord::Base
    belongs_to :system_name
  end

  class Following < ActiveRecord::Base
    belongs_to :system_name
  end

  def up
    [[:mentions, Mention, :mentionable_type, :mentionable_id],
     [:followings, Following, :followable_type, :followable_id]].each do |table, klass, type, id|
      add_column table, id, :integer
      add_column table, type, :string
      add_index table, [id, type]

      klass.find_each do |record|
        record.send("#{type}=", record.system_name.nameable_type)
        record.send("#{id}=", record.system_name.nameable_id)
        unless record.valid?
          puts "Validation failed: #{record.inspect}"
        end
        record.save!
      end

      remove_column table, :system_name_id
    end
  end

  def down
    [[:mentions, Mention, :mentionable_type, :mentionable_id],
     [:followings, Following, :followable_type, :followable_id]].each do |table, klass, type, id|
      add_column table, :system_name_id

      klass.find_each do |record|
        record.system_name_id = SystemName.where(:nameable_id => record.send(id), :nameable_type => record.send(type).first.try(:id))
        record.save!
      end
      remove_column table, id
      remove_column table, type
      add_index table, :system_name_id
    end
  end
end
