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

  $(".activity-feed").on("click", ".email-share-link", function(event) {
    event.preventDefault();
    $(".shared-link.modal #shared_link_link_id").attr("value", $(this).attr("data-item-id"));
    $(".shared-link.modal .error-explanation").hide();
    $(".shared-link.modal form")[0].reset();
    $(".shared-link.modal").modal();
    $(".shared-link.modal #shared_link_email").focus();
  });

  $(".shared-link.modal form").on("ajax:error", function(event, xhr, status, error) {
    $(".shared-link.modal .errors").empty();
    $.each(xhr.responseJSON, function(i, error) {
      $(".shared-link.modal .errors").append("<li>" + error + "</li>");
    });
    $(".shared-link.modal .error-explanation").slideDown("fast");
  });

  $(".shared-link.modal form").on("ajax:success", function(event, data) {
    $(".shared-link.modal").modal("hide");
    $(".navbar-header").append('<div class="success-flash"><span>' + data.message + '</span></div>');
    setTimeout(function() {
      $(".success-flash").fadeOut("normal", function() { this.remove(); });
    }, 3000);
  });
});
