App.Marker.GoalView = Backbone.View.extend({
  initialize: function() {
    this.template = _.template($("#goal-view").html());
    this.listenTo(this.model, "change", this.render);
    this.listenTo(this.model, "remove", this.remove);
  },

  tagName: "tr",

  events: {
    "click a.edit" : "edit",
    "click a.delete" : "deleteGoal"
  },

  edit: function(e) {
    e.preventDefault();
    App.dispatcher.trigger("goal:edit", this.model);
  },

  deleteGoal: function(e) {
    e.preventDefault();
    if (confirm("Delete this goal?")) {
      this.model.destroy({ wait: true });
    }
  },

  render: function() {
    var jersey_numbers = this.model.get("player_ids").map(function(player_id) {
      return App.players.get(player_id).get("jersey_number");
    });

    var attrs = this.model.toJSON().goal;
    attrs.jersey_numbers = jersey_numbers;
    this.$el.html(this.template(attrs));
    return this;
  }
});


