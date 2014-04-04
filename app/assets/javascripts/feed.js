$(function() {
  $(".activity-feed").on("click", ".reply-link", function(e) {
    e.preventDefault();
    $(this).hide().parent().siblings().find("form").slideDown(function() { $(this).find("input[type=text]").focus(); });
  });

  function renderShareButtons() {
    twttr.widgets.load();
    FB.XFBML.parse();
  }

  function cleanup(form) {
    form.reset();
    renderShareButtons();
  }

  $(".activity-feed").on("ajax:success", ".feed-item form", function(event, data, status, xhr) {
    $(data).appendTo($(this).parent().parent().find(".replies")).hide().slideDown("fast").find("time").timeago();
    cleanup(this);
  });

  $(".activity-feed > form").on("ajax:success", function(event, data, status, xhr) {
    $(data).insertAfter($(this)).hide().slideDown("fast").find("time").timeago();
    cleanup(this);
  });

  $(".activity-feed").on("ajax:success", ".more", function(event, data, status, xhr) {
    $(this).remove();
    $(".activity-feed").append(data);
    $(".activity-feed time").timeago();
    renderShareButtons();
  });
});
