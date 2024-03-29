App.Marker.TeamBoxView = Backbone.View.extend({
  initialize: function(options, other) {
    this.side = options.side;
    this.teamId = options.teamId;
    this.penaltyViews = {
      "all"     : new App.Marker.PenaltiesView({teamId: this.teamId, collection: App.penalties, type: "all",     el: this.$("table.penalties.all")}),
      "current" : new App.Marker.PenaltiesView({teamId: this.teamId, collection: App.penalties, type: "current", el: this.$("table.penalties.current")}),
      "expired" : new App.Marker.PenaltiesView({teamId: this.teamId, collection: App.penalties, type: "expired", el: this.$("table.penalties.expired")}),
      "other"   : new App.Marker.PenaltiesView({teamId: this.teamId, collection: App.penalties, type: "other",   el: this.$("table.penalties.other")})
    };
    this.$(".penalties li a.current").click();
    this.goalEditor = new App.Marker.GoalEditor({teamId: this.teamId, el: this.$(".goal-editor")});
    this.goalsView = new App.Marker.GoalsView({teamId: this.teamId, el: this.$(".goals tbody")});
    this.playerEditor = new App.Marker.PlayerEditor({teamId: this.teamId, el: this.$(".player")});
    this.rosterEditor = new App.Marker.RosterEditor({teamId: this.teamId, el: this.$(".roster"), playerEditor: this.playerEditor});
    this.goalieChooser = new App.Marker.GoalieChooser({teamId: this.teamId, el: this.$(".goalie-chooser") });
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
    // Otherwise, when the update comes in asynchronously, it removes our model
    // from the collection as it doesn't recognize it as the same object.
    var self = this;
    var createdAt = (App.game.get("state") == "paused" && App.game.pausedAtDate) ? App.game.pausedAtDate : new Date();
    App.goals.create({ team_id: this.teamId, created_at: createdAt.toISOString() }, { wait: true, success: function(goal) { self.goalEditor.edit(goal); } });
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
    this.goalie.text(goalie ? goalie.get("name_and_number") : App.translations.goalie.pulled);
  }

});

