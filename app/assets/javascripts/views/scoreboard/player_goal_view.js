App.Scoreboard.PlayerGoalView = Backbone.View.extend({
  name: "PlayerGoalView",

  initialize: function(options) {
    this.listenTo(this, "showing", this.start);
    this.listenTo(this, "hidden", this.stop);
    this.listenTo(App.goals, "add", this.goalAdded);
  },

  duration: 5000, // msec

  start: function() {
    var self = this;
    setTimeout(function() {
      self.trigger("finished", self);
    }, self.duration);
  },

  stop: function() {
    this.stopListening(this.goal);
  },

  goalAdded: function(goal) {
    this.goal = goal;
    this.listenToOnce(goal, "change:player_ids", this.goalCompleted);
    this.listenToOnce(goal, "remove", this.goalRemoved);
  },

  goalCompleted: function() {
    var player = App.players.get(this.goal.get("player_ids")[0]);
    var playerNameAndNumber = player.get("name_and_number");
    var photoUrl = player.get("photo_url");
    this.$(".player").html("<p>" + playerNameAndNumber + "</p><img src='" + photoUrl + "'></img>");
    this.board.show(this);
  },

  goalRemoved: function() {
    this.board.reset();
  }
});

