App.RosterEditor = Backbone.View.extend({
  initialize: function() {
    this.dialog = this.$el;
  },

  events: {
    "click a.cancel" : "close",
    "click a.save" : "saveAndClose",
    "ajax:success" : "ajaxSuccess",
    "ajax:error" : "ajaxError"
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

  ajaxSuccess: function() {
    this.close();
    console.log(arguments);
  },

  ajaxError: function() {
    alert("ajaxError!");
  }
});

