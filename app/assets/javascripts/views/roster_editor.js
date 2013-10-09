App.RosterEditor = Backbone.View.extend({
  initialize: function() {
    this.dialog = this.$el;
    this.playerEditor = this.options.playerEditor;
    this.listenTo(this.playerEditor, "player:created", this.playerCreated);
    this.template = _.template($("#player-checkbox").html());
  },

  events: {
    "click a.cancel" : "close",
    "click a.save" : "saveAndClose",
    "click a.create" : "newPlayer",
    "ajax:success" : "ajaxSuccess",
    "ajax:error" : "ajaxError",
    "shown" : "attachHandlers"
  },

  edit: function() {
    this.dialog.modal({
      remote: this.dialog.attr("data-remote")
    });
  },

  close: function() {
    this.dialog.modal('hide');
  },

  saveAndClose: function() {
    this.$("form").submit();
  },

  newPlayer: function() {
    this.playerEditor.edit();
  },

  ajaxSuccess: function() {
    this.close();
  },

  ajaxError: function() {
    alert("ajaxError!");
  },

  playerCreated: function(player) {
    this.$(".players").append(this.template(player));
    this.attachHandlers();
  },

  toggleSelectVisibility: function(e) {
    var checked = $(this).is(":checked");
    console.log("check is " + checked);
    $("select", $(e.target).parents("tr")).css({visibility: (checked ? "visible" : "hidden")});
  },

  attachHandlers: function() {
    this.$(".players input[type=checkbox]").off("click", this.toggleSelectVisibility);
    this.$(".players input[type=checkbox]").on("click", this.toggleSelectVisibility);
  }
});

