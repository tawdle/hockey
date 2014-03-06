$(function() {
  $(".reply-link").click(function(e) {
    e.preventDefault();
    $(this).hide().parent().siblings("form").slideDown();
  });
});
