App.Marker.ClockEditor = Backbone.View.extend({
  initialize: function() {
    this.minutes = this.$("#clock-minutes");
    this.seconds = this.$("#clock-seconds");
    this.cancelButton = this.$(".cancel");
    this.saveButton = this.$(".save");
    this.form = this.$("form");
  },

  events: {
    "click .cancel" : "close",
    "click .save:not(.disabled)" : "saveAndClose",
    "input input" : "updateSaveButton"
  },

  edit: function() {
    if (this.model.get("state") != "ready") {
      return;
    }

    this.initializeForm();
    this.$el.modal("show");
    this.minutes.focus();
  },

  close: function() {
    this.$el.modal("hide");
  },

  complete: function() {
    return !this.form[0].checkValidity || this.form[0].checkValidity();
  },

  updateSaveButton: function() {
    this.saveButton.toggleClass("disabled", !this.complete());
  },

  saveAndClose: function() {
    var self = this;
    var data = { game: { current_period_duration: Number(this.minutes.val()) * 60 + Number(this.seconds.val()) } };

    $.ajax({
      type: "PUT",
      url: this.model.url() + "/update_clock.json",
      data: data,
      success: function() {
        self.close();
      }
    });
  },

  initializeForm: function() {
    var time = this.model.get("clock").getTimeRemaining();
    this.minutes.val(Math.floor(time / 60)).attr("min", 1).attr("max", 59);
    this.seconds.val(time % 60).attr("min", 0).attr("max", 59);
  }


});
