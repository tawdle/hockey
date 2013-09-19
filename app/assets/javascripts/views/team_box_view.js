App.TeamBoxView = Backbone.View.extend({
  initialize: function(options, other) {
    this.teamId = Number(this.$el.attr("data-team-id"));
    this.penaltyEditor = new App.PenaltyEditor({teamId: this.teamId, el: this.$(".penalty-editor")});
    this.penaltiesView = new App.PenaltiesView({teamId: this.teamId, el: this.$(".penalties")});
    this.goalEditor = new App.GoalEditor({teamId: this.teamId, el: this.$(".goal-editor")});
  },

  events: {
    "click a.add-penalty" : "addPenalty",
    "click a.add-goal" : "addGoal"
  },

  addGoal: function(e) {
    e.preventDefault();
    var goal = App.goals.create({team_id: this.teamId});
    this.goalEditor.edit(goal);
  },

  addPenalty: function(e) {
    e.preventDefault();
    var penalty = new App.Penalty({}, {collection: App.penalties});
    this.penaltyEditor.edit(penalty);
  },

  render: function() {
    this.$(".penalty-editor").toggle(false);
  }

});

