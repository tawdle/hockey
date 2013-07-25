$(function() {
  $("#choose-period select").change(function(event) {
    if ($(this).val()) {
      $("#choose-team").slideDown();
    } else {
      $("#choose-team, #choose-player, #choose-assist").slideUp();
      $("#choose-team input[type=radio]").prop("checked", false);
    }
  });

  $("#choose-team input[type=radio]").change(function(event) {
    if ($(this).val()) {
      var team = $("#" + event.target.id).attr("data-team");
      var selects = $("select#player-id, select#assisting-player-id");
      selects.empty();
      selects.append("<option></option>");
     $.each(mygs.goals.players[team], function(index, player) {
        selects.append("<option value='" + player[0] + "'>" + player[1] + "</option>");
      });
      $("#choose-player").slideDown();
      $("#choose-assist").slideUp();
    } else {
      $("#choose-player, #choose-assist").slideUp();
    }
  });
  $("select#player-id").change(function(event) {
    if ($(this).val()) {
      $("#choose-assist").slideDown();
      $("form#new_goal input[type=submit]").removeAttr("disabled");
    } else {
      $("#choose-assist").slideUp();
      $("form#new_goal input[type=submit]").attr("disabled", "disabled");
    }
  });
});
