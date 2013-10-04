App.PenaltyView = Backbone.View.extend({
  initialize: function() {
    this.template = _.template($("#penalty-view").html());
    this.listenTo(this.model, "change", this.render);
    this.listenTo(this.model, "destroy", this.remove);
  },

  tagName: "tr",

  events: {
    "click a.edit" : "edit",
    "click a.delete" : "deletePenalty",
    "click a.start" : "start"
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

  start: function(e) {
    e.preventDefault();
    this.model.save({action: "start"});
  },

  render: function() {
    this.$el.html(this.template(this.model.toJSON().penalty));
    this.$el.addClass(this.model.get("state"));

    var timer = this.model.get("timer");
    if (timer) {
      this.timerView = new App.TimerView({el: this.$(".timer"), model: timer, showTimeRemaining: true});
    }
    return this;
  }
});


