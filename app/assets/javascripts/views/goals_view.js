window.App = window.App || {};

App.GoalsView = Backbone.View.extend({
  initialize: function(options, other) {
    this.teamId = options.teamId;
    this.listenTo(App.goals, "add", this.addOne);
    this.listenTo(App.goals, "reset", this.reset);
    this.listenTo(App.goals, "remove", this.showHideTable);
    this.reset();
  },

  addOne: function(goal) {
    if (goal.get("team_id") == this.teamId) {
      var view = new App.GoalView({model: goal});
      this.$el.append(view.render().el);
      this.showHideTable();
    }
  },

  addAll: function() {
    App.goals.each(this.addOne, this);
  },

  reset: function() {
    this.$el.empty();
    this.addAll();
    this.showHideTable();
  },

  showHideTable: function() {
    this.$el.parent().toggle(App.goals.where({team_id: this.teamId}).length > 0);
  },

  events: {
  }
});

