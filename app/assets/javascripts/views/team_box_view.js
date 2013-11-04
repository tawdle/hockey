App.TeamBoxView = Backbone.View.extend({
  initialize: function(options, other) {
    this.teamId = this.options.teamId;
    this.penaltyEditor = new App.PenaltyEditor({teamId: this.teamId, el: this.$(".penalty-editor")});
    this.penaltiesView = new App.PenaltiesView({teamId: this.teamId, el: this.$(".penalties tbody")});
    this.goalEditor = new App.GoalEditor({teamId: this.teamId, el: this.$(".goal-editor")});
    this.goalsView = new App.GoalsView({teamId: this.teamId, el: this.$(".goals tbody")});
    this.playerEditor = new App.PlayerEditor({teamId: this.teamId, el: this.$(".player")});
    this.rosterEditor = new App.RosterEditor({teamId: this.teamId, el: this.$(".roster"), playerEditor: this.playerEditor});
    this.goalieChooser = new App.GoalieChooser({teamId: this.teamId, el: this.$(".goalie-chooser") });
    this.$(".disclosure i").addClass("icon-caret-right");
  },


  events: {
    "click a.add-penalty" : "addPenalty",
    "click a.add-goal" : "addGoal",
    "click a.edit-roster" : "editRoster",
    "click a.choose-goalie" : "chooseGoalie",
    "click h3.disclosure" : "toggleDisclosure"
  },

  addGoal: function(e) {
    e.preventDefault();
    // We wait here because we need the server's id for this new goal.
    // Otherwise, when the update comes in asynchronsously, it removes our model
    // from the collection as it doesn't recognize it as the same object.
    var goal = App.goals.create({ team_id: this.teamId }, { wait: true });
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

  chooseGoalie: function(e) {
    e.preventDefault();
    this.goalieChooser.choose();
  },

  toggleDisclosure: function(e) {
    $(e.target).next().slideToggle();
    $("i", e.target).toggleClass("icon-caret-right icon-caret-down");
  },

  render: function() {
  }

});

