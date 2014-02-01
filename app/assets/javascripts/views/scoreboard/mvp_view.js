App.Scoreboard.MVPView = Backbone.View.extend({
  name: "MVPView",

  initialize: function(options) {
    this.board = options.board;
    this.listenTo(this, "showing", this.start);
    this.listenTo(this, "hidden", this.stop);
    this.listenTo(App.game, "change:visiting_team_mvp_id", this.visitingMVPChanged);
    this.listenTo(App.game, "change:home_team_mvp_id", this.homeMVPChanged);
    this.listenTo(App.game, "change:state", this.stateChanged);
  },

  duration: 30000,

  visitingMVPChanged: function() {
    console.log("showing vistiing mvp");
    this.showMVP(App.game.get("visiting_team_mvp_id"));
  },

  homeMVPChanged: function() {
    console.log("showing home mvp");
    this.showMVP(App.game.get("home_team_mvp_id"));
  },


  stateChanged: function() {
    this.board.finished(this);
  },

  showMVP: function(player_id) {
    var self = this;

    var player = App.players.get(player_id),
    name = player.get("name"),
    number = player.get("jersey_number"),
    photoUrl = player.get("photo_url");

    $("#mvp-animation_Player_Name").html(name);
    $("#mvp-animation_Maxime_Leblond__74Copy").css("background-image", "url(" + photoUrl + ")");
    $("#mvp-animation_Jerser_Number").html("#" + number);
    this.stage().play(0);
    this.board.show(self);
    if (this.timerId) clearTimeout(this.timerId);
    this.timerId = setTimeout(function() {
      self.timerId = null;
      self.board.finished(self);
    }, self.duration);
  },

  start: function() {
  },

  stop: function() {
    this.stage().stop();
  },

  stage: function() {
    return AdobeEdge.getComposition("EDGE-278437879").getStage();
  }

});


