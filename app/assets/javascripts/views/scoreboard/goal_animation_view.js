App.Scoreboard.GoalAnimationView = Backbone.View.extend({
  initialize: function(options) {
    this.listenTo(this, "showing", this.start);
    this.listenTo(this, "hidden", this.stop);
    this.sound = new Audio("/assets/edge/Medias/Dallas_Stars_Horn.mp3");
  },

  start: function(goal) {
    var side = App.game.homeOrVisting(goal.get("team_id"));
    var logoSrc = $("." + side + "-team .logo img").attr("src");
    $("#Stage_Logo_AiglesALPHA").css("background-image", "url(" + logoSrc + ")");
    this.stage().play("Loop");
    this.sound.volume = 0;
    this.sound.currentTime = 0;
    this.sound.play();
    $(this.sound).animate( { volume: 1 }, 10); // avoid glitch on restart
  },

  stop: function() {
    var self = this;
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


