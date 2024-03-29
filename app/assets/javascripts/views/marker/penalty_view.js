App.Marker.PenaltyView = Backbone.View.extend({
  initialize: function() {
    this.template = _.template($("#penalty-view").html());
    this.listenTo(this.model, "change", this.render);
    this.listenTo(this.model, "remove", this.remove);
  },

  tagName: "tr",

  events: {
    "click a.edit" : "edit",
    "click a.delete" : "deletePenalty"
  },

  edit: function(e) {
    e.preventDefault();
    App.dispatcher.trigger("penalty:edit", this.model);
  },

  deletePenalty: function(e) {
    e.preventDefault();
    if (confirm("Delete this penalty?")) {
      this.model.destroy({ wait: true });
    }
  },

  render: function() {
    this.$el.html(this.template(this.model.toJSON().penalty));
    this.$el.removeClass().addClass(this.model.get("state"));

    if (this.timerView) this.timerView.remove();

    var timer = this.model.get("timer");
    if (timer) {
      this.timerView = new App.TimerView({el: this.$(".timer"), model: timer, showTimeRemaining: true});
    }
    return this;
  }
});


