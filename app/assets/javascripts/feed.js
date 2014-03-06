$(function() {
  $(".activity-feed").on("click", ".reply-link", function(e) {
    e.preventDefault();
    $(this).hide().parent().siblings("form").slideDown(function() { $(this).find("input[type=text]").focus(); });
  });

  $(".activity-feed").on("ajax:success", ".feed-item form", function(event, data, status, xhr) {
    $(data).appendTo($(this).parent().find(".replies")).hide().slideDown("fast").find("time").timeago();
    this.reset();
  });

  $(".activity-feed > form").on("ajax:success", function(event, data, status, xhr) {
    $(data).insertAfter($(this)).hide().slideDown("fast").find("time").timeago();
    this.reset();
  });
});
