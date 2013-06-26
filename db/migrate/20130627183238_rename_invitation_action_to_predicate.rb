class RenameInvitationActionToPredicate < ActiveRecord::Migration
  def change
    rename_column :invitations, :action, :predicate
  end
end
