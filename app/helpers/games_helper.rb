module GamesHelper
  def checklist_item(method, text, link)
    if @game.send(method)
      "<li><i class='icon-check text-success'></i> #{ link_to text, link }".html_safe
    else
      "<li><span class='text-error' style='margin-left: 0px; margin-right: 2px;'>&#10006;</span> <b>#{ link_to text, link }</b>".html_safe
    end
  end
end
