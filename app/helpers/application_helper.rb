module ApplicationHelper
  def json_for(target, options = {})
    options[:scope] ||= self
    options[:url_options] ||= url_options
    target.active_model_serializer.new(target, options).to_json
  end

  # Override translate method to avoid stupid return of hash
  # for null values.
  def t(key, *args)
    key.nil? || (key.is_a?(String) && key.to_s.ends_with?(".")) ? "" : super
  end

  def title(page_title)
    content_for(:title) { page_title }
  end

  def invitation_button(predicate, target, opts = {})
    if can? :create, Invitation.new(:target => target, :predicate => predicate)
      link_to opts[:label] || "Invite", new_invitation_path(:predicate => predicate, :target_id => target.to_param, :target_type => target.class.name, :back_to => opts[:back_to]), :class => "btn btn-default btn-sm"
    end
  end
end
