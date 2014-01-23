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
end
