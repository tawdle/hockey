App.Scoreboard.PreGameShowView = Backbone.View.extend({
  name: "PreGameShowView",

  initialize: function() {
    this.listenTo(App.game, "change:state", this.gameStateChanged);
    this.listenTo(this, "showing", this.start);
    this.listenTo(this, "hidden", this.stop);
    this.countDownMovie = this.$("#countdown video");
    this.countDownMovie[0].addEventListener("ended", this.showFightingLogos.bind(this));
    this.listenTo(this, "added", this.added);
  },

  added: function(board) {
    board.enqueue(this); // XXX: For testing
  },

  gameStateChanged: function(game, state) {
    if (state == "ready" && game.get("period") === 0) {
      this.board.enqueue(this);
    }
  },

  start: function() {
    this.countDownMovie.load();
    this.showTag();
  },

  showTag: function() {
    this.$("#bigshot-tag").removeClass("fade").show().siblings().hide();
    var self = this;
    setTimeout(function() {
      this.$("#bigshot-tag").addClass("fade");
      setTimeout(function() {
        self.showCountDown();
      }, 2000);
    }, 5000);
  },

  showCountDown: function() {
    this.$("#countdown").show().siblings().hide();
    this.countDownMovie[0].currentTime = 0;
    this.countDownMovie[0].play();
  },

  showFightingLogos: function() {
    // We're done for now
    this.trigger("finished", this);
  }
});


