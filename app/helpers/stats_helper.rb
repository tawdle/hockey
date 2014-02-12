module StatsHelper
  def format_header(methods, scope)
    ("<thead><tr>" +
      methods.map {|method| "<th class=\"#{method}\">#{I18n.t(method, :scope => scope)}" }.join("\n") +
    "</tr></thead>").html_safe
  end

  def format_row(obj, methods, &block)
    ("<tr>" +
      methods.map {|method| format_datum(obj, method, &block) }.join +
    "</tr>").html_safe
  end

  def format_datum(obj, method, &block)
    if obj.respond_to?(method)
      "<td class=\"#{method}\">#{format_number(obj.send(method))}</td>"
    else
      "<td class=\"#{method}\">#{block.call(method, obj)}</td>"
    end
  end

  def format_number(num)
    if num.respond_to?(:nan?) && num.nan?
      "-"
    elsif num == 0
      "-"
    else
      num.to_s
    end
  end
end

