App.Scoreboard.GoalAnimationView = Backbone.View.extend({
  name: "GoalAnimationView",

  initialize: function(options) {
    this.board = options.board;
    this.listenTo(this, "showing", this.start);
    this.listenTo(this, "hidden", this.stop);
    this.listenTo(App.goals, "add", this.goalAdded);
    this.home = {
      sound: new Audio("/assets/edge/Medias/Dallas_Stars_Horn.mp3"),
      logo: App.game.get("home_team_logo")
    };
    this.visiting = {
      sound: new Audio("/assets/edge/Medias/NY_Rangers_GH.mp3"),
      logo: App.game.get("visiting_team_logo")
    };
  },

  goalAdded: function(goal) {
    this.goal = goal;

    this.side = App.game.homeOrVisiting(goal.get("team_id"));
    $("#team-goal-animation_Logo_AiglesALPHA").css("background-image", "url(" + this[this.side].logo + ")");

    this.board.show(this);
  },

  start: function() {
    var self = this;
    this.listenToOnce(this.goal, "remove", function() {
      self.board.reset();
    });

    this.stage().play("Loop");
    this.board.playSound(this[this.side].sound);
  },

  stop: function() {
    this.stopListening(this.goal);
    this.stage().stop();
  },

  stage: function() {
    return AdobeEdge.getComposition("EDGE-404308").getStage();
  }
});


