class ChangePlayerMemberToUser < ActiveRecord::Migration
  def change
    rename_column :players, :member_id, :user_id
  end
end
