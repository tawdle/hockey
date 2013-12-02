class AddMasterToTimers < ActiveRecord::Migration
  def up
    add_column :timers, :master_id, :integer
    add_column :timers, :last_started_at, :datetime

    Timer.all.each do |timer|
      if timer.owner.is_a?(Penalty) && timer.owner.game && timer.owner.game.clock
        timer.master_id = timer.owner.game.clock_id
        timer.save!
      end
    end
  end

  def down
    remove_column :timers, :master_id
  end
end
