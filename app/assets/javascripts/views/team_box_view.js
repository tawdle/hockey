App.TeamBoxView = Backbone.View.extend({
  initialize: function(options, other) {
    this.teamId = this.options.teamId;
    this.penaltyEditor = new App.PenaltyEditor({teamId: this.teamId, el: this.$(".penalty-editor")});
    this.penaltiesView = new App.PenaltiesView({teamId: this.teamId, el: this.$(".penalties tbody")});
    this.goalEditor = new App.GoalEditor({teamId: this.teamId, el: this.$(".goal-editor")});
    this.goalsView = new App.GoalsView({teamId: this.teamId, el: this.$(".goals tbody")});
    this.playerEditor = new App.PlayerEditor({teamId: this.teamId, el: this.$(".player")});
    this.rosterEditor = new App.RosterEditor({teamId: this.teamId, el: this.$(".roster"), playerEditor: this.playerEditor});
    this.$(".disclosure i").addClass("icon-caret-right");
  },


  events: {
    "click a.add-penalty" : "addPenalty",
    "click a.add-goal" : "addGoal",
    "click a.edit-roster" : "editRoster",
    "click h3.disclosure" : "toggleDisclosure"
  },

  addGoal: function(e) {
    e.preventDefault();
    var goal = new App.Goal({team_id: this.teamId}, {collection: App.goals});
    this.goalEditor.edit(goal);
  },

  addPenalty: function(e) {
    e.preventDefault();
    var penalty = new App.Penalty({}, {collection: App.penalties});
    this.penaltyEditor.edit(penalty);
  },

  editRoster: function(e) {
    e.preventDefault();
    this.rosterEditor.edit();
  },

  toggleDisclosure: function(e) {
    $(e.target).next().slideToggle();
    $("i", e.target).toggleClass("icon-caret-right icon-caret-down");
  },

  render: function() {
  }

});

