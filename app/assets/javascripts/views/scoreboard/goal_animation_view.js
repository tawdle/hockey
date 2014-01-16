App.Scoreboard.GoalAnimationView = Backbone.View.extend({
  name: "GoalAnimationView",

  initialize: function(options) {
    this.listenTo(this, "showing", this.start);
    this.listenTo(this, "hidden", this.stop);
    this.listenTo(App.goals, "add", this.goalAdded);
    this.sound = new Audio("/assets/edge/Medias/Dallas_Stars_Horn.mp3");
  },

  goalAdded: function(goal) {
    this.goal = goal;

    var side = App.game.homeOrVisiting(goal.get("team_id"));
    var logoSrc = $("." + side + "-team .logo img").attr("src");
    $("#team-goal-animation_Logo_AiglesALPHA").css("background-image", "url(" + logoSrc + ")");

    this.board.show(this);
  },

  start: function() {
    var self = this;
    this.listenTo(this.goal, "remove", function() {
      self.board.reset();
    });

    this.stage().play("Loop");
    this.sound.volume = 0;
    this.sound.currentTime = 0;
    this.sound.play();
    $(this.sound).animate( { volume: 1 }, 10); // avoid glitch on restart
  },

  stop: function() {
    var self = this;
    this.stopListening(this.goal);

    this.stage().stop();
    $(this.sound).animate( { volume: 0 }, 750, function() {
      self.sound.pause();
      self.sound.currentTime = 0;
    });
  },

  stage: function() {
    return AdobeEdge.getComposition("EDGE-404308").getStage();
  }
});


