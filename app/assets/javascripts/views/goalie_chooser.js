window.App = window.App || {};

App.GoalieChooser = Backbone.View.extend({
  initialize: function() {
    this.dialog = this.$el;
  },

  events: {
    "ajax:success" : "ajaxSuccess",
    "ajax:error" : "ajaxError",
    "click a.save" : "saveAndClose",
    "click a.cancel" : "cancel"
  },

  choose: function() {
    this.dialog.modal({
      remote: this.dialog.attr("data-remote")
    });
  },

  initializeForm: function() {
    this.$(".goalies").empty();
    _.each(App.players.where({team_id: this.options.teamId, role: "goalie"}), function(goalie) {
      this.$(".goalies").append(this.template(goalie));
    });
  },

  ajaxSuccess: function(event, data, status, xhr) {
    this.close();
  },

  ajaxError: function() {
    alert("ajaxError!");
  },

  saveAndClose: function(e) {
    e.preventDefault();
    this.$("form").submit();
  },

  cancel: function(e) {
    e.preventDefault();
    this.close();
  },

  close: function() {
    this.$el.modal('hide');
    this.$el.removeData('modal');
  }
});


