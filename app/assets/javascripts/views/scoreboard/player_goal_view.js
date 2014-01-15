App.Scoreboard.PlayerGoalView = Backbone.View.extend({
  name: "PlayerGoalView",

  initialize: function(options) {
    this.listenTo(this, "showing", this.start);
    this.listenTo(this, "hidden", this.stop);
    this.listenTo(App.goals, "add", this.goalAdded);
  },

  duration: 10000, // msec

  start: function() {
    this.stage().play(0);

    var self = this;
    setTimeout(function() {
      self.trigger("finished", self);
    }, self.duration);
  },

  stop: function() {
    this.stopListening(this.goal);
    this.stage().stop();
  },

  goalAdded: function(goal) {
    this.goal = goal;
    this.listenToOnce(goal, "change:player_ids", this.goalCompleted);
    this.listenToOnce(goal, "remove", this.goalRemoved);
  },

  goalCompleted: function() {
    var player = App.players.get(this.goal.get("player_ids")[0]);
    var name = player.get("name");
    var number = player.get("jersey_number");
    var photoUrl = player.get("photo_url");
    console.log("setting name to " + name);
    $("#player-goal-animation_Player_Name").html(name);
    $("#player-goal-animation_Maxime_Leblond__74Copy").css("background-image", "url(" + photoUrl + ")");
    this.board.show(this);
  },

  goalRemoved: function() {
    this.board.reset();
  },

  stage: function() {
    return AdobeEdge.getComposition("EDGE-278437879").getStage();
  }

});

