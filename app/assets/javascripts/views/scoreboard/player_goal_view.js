App.Scoreboard.PlayerGoalView = Backbone.View.extend({
  name: "PlayerGoalView",

  initialize: function(options) {
    this.board = options.board;
    this.listenTo(this, "showing", this.start);
    this.listenTo(this, "hidden", this.stop);
    this.listenTo(App.goals, "add", this.goalAdded);
  },

  duration: 7000, // msec

  start: function() {
    console.log("pgv: starting with primary = " + this.showPrimary);
    var index = -1;
    var playerIds = this.goal.get("player_ids");
    var self = this;

    function showNextPlayer() {
      index += 1;
      if (index >= (self.showPrimary ? 1 : playerIds.length)) {
        self.board.finished(self);
        self.showPrimary = false;
        return;
      }

      var player = App.players.get(playerIds[index]),
          name = player.get("name"),
          number = player.get("jersey_number"),
          photoUrl = player.get("photo_url");
      $("#player-goal-animation_Player_Name").html(name);
      $("#player-goal-animation_Maxime_Leblond__74Copy").css("background-image", "url(" + photoUrl + ")");
      $("#player-goal-animation_Jerser_Number").html("#" + number);
      console.log("pgv: showing for player " + player.id);
      self.stage().play(0);
      setTimeout(showNextPlayer, self.duration);
    }

    showNextPlayer();
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
    this.showPrimary = true;
    this.board.show(this);
  },

  goalRemoved: function() {
    this.board.reset();
  },

  stage: function() {
    return AdobeEdge.getComposition("EDGE-278437879").getStage();
  }

});

