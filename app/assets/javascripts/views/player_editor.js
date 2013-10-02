App.PlayerEditor = Backbone.View.extend({
  initialize: function() {
    this.dialog = this.$el;
  },

  events: {
    "click a.cancel" : "close",
    "click a.create" : "saveAndClose",
    "ajax:success" : "ajaxSuccess",
    "ajax:error" : "ajaxError"
  },

  edit: function() {
    this.dialog.modal({
      remote: this.dialog.attr("data-remote")
    });
    if (this.$("form")[0]) this.$("form")[0].reset();
  },

  close: function() {
    this.dialog.modal('hide');
  },

  saveAndClose: function() {
    this.$("form").submit();
  },

  ajaxSuccess: function(event, data, status, xhr) {
    this.trigger("player:created", data);
    this.close();
  },

  ajaxError: function() {
    alert("ajaxError!");
  }
});

