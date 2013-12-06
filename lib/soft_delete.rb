module SoftDelete
  extend ActiveSupport::Concern

  included do
    scope :without_deleted, where(:deleted_at => nil)
  end

  def destroy
    run_callbacks(:destroy) do
      delete
    end
  end

  def delete
    update_attribute(:deleted_at, Time.now)
  end
end
