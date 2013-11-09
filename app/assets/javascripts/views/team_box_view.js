App.TeamBoxView = Backbone.View.extend({
  initialize: function(options, other) {
    this.side = options.side;
    this.teamId = options.teamId;
    this.penaltiesView = new App.PenaltiesView({teamId: this.teamId, el: this.$(".penalties tbody")});
    this.goalEditor = new App.GoalEditor({teamId: this.teamId, el: this.$(".goal-editor")});
    this.goalsView = new App.GoalsView({teamId: this.teamId, el: this.$(".goals tbody")});
    this.playerEditor = new App.PlayerEditor({teamId: this.teamId, el: this.$(".player")});
    this.rosterEditor = new App.RosterEditor({teamId: this.teamId, el: this.$(".roster"), playerEditor: this.playerEditor});
    this.goalieChooser = new App.GoalieChooser({teamId: this.teamId, el: this.$(".goalie-chooser") });
    this.goalie = this.$(".goalie");
    this.$(".disclosure i").addClass("icon-caret-right");
    this.score = this.$(".score");
    this.listenTo(App.game, "change:" + this.side, this.render);
    this.render();
  },


  events: {
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
    var attrs = App.game.get(this.side);
    var goalie = attrs.goalie_id && App.players.get(attrs.goalie_id);
    this.score.text(attrs.score);
    this.goalie.text(goalie ? goalie.get("name_and_number") : "none");
  }

});

