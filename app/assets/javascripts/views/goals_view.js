window.App = window.App || {};

App.GoalsView = Backbone.View.extend({
  initialize: function(options, other) {
  },

  events: {
    "click a.add-goal" : "addGoal"
  },

  addGoal: function(e) {
    e.preventDefault();
    var team_id = $(e.currentTarget).attr("data-team-id");
    var goal = this.collection.create({team_id: team_id});
    var view = new App.GoalView({ model: goal });
    this.$(".goal-editor").hide().html(view.render().el).slideDown();
  },

  render: function() {
    this.$(".goal-editor").toggle(false);
  }
});

