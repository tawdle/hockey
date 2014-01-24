App.Scoreboard.PreGameShowView = Backbone.View.extend({
  name: "PreGameShowView",

  initialize: function(options) {
    this.board = options.board;
    this.listenTo(this.model, "change:state", this.gameStateChanged);
    this.listenTo(this, "showing", this.start);
    this.listenTo(this, "hidden", this.stop);
    this.countDownMovie = this.$("#countdown video");
    this.countDownMovie[0].addEventListener("ended", this.startAnimation.bind(this));
    this.listenTo(this.board, "available", this.available);
    this.homeTeamLogo = App.game.get("home_team_logo");
    this.visitingTeamLogo = App.game.get("visiting_team_logo");
    this.preload([this.homeTeamLogo, this.visitingTeamLogo]);
    this.preload(App.players.map(function(player) { return player.get("photo_url"); }));

    AdobeEdge.bootstrapCallback(this.edgeLoadCallback.bind(this));
  },

  compId: "EDGE-3124127",

  shouldStart: function() {
    return !this.played && App.game.get("state") == "ready" && App.game.get("period") === 0;
  },

  edgeLoadCallback: function(compId) {
    if (compId == this.compId) {
      this.edgeLoaded = true;
      this.endTag();
    }
  },

  gameStateChanged: function() {
    if (this.shouldStart()) {
      this.board.show(this);
    }
  },

  available: function() {
    if (this.shouldStart()) {
      this.board.show(this);
    }
    return false;
  },

  preload: function(urls) {
    this.preloadedImages = this.preloadedImages || [];
    this.preloadedImages += _.map(urls, function(url) {
      var image = new Image();
      image.src = url;
      return image;
    });
  },

  start: function() {
    this.playing = true;
    this.countDownMovie.load();
    this.showTag();
  },

  stop: function() {
    this.playing  = false;
    try {
      this.countDownMovie[0].stop();
    } catch(e) {}
    try {
      this.stage().stop();
    } catch(e) {}
  },

  showTag: function() {
    if (this.playing) {
      this.$("#bigshot-tag").removeClass("fade").show().siblings().hide();
      this.waitingForLoad = true;
      this.endTag();
    }
  },

  endTag: function() {
    if (this.playing && this.waitingForLoad && this.edgeLoaded) {
      var self = this;
      setTimeout(function() {
        this.$("#bigshot-tag").addClass("fade-out");
        setTimeout(function() {
          self.showCountDown();
        }, 6000);
      }, 1000);
    }
  },

  showCountDown: function() {
    if (this.playing) {
      this.$("#countdown").show().siblings().hide();
      this.countDownMovie[0].currentTime = 0;
      this.countDownMovie[0].play();
    }
  },

  startAnimation: function() {
    if (this.playing) {
      this.setBackgroundImage("Visitor__logo", this.visitingTeamLogo);
      this.setBackgroundImage("Visitor_logo", this.visitingTeamLogo);
      this.setBackgroundImage("Visitor_Logo", this.visitingTeamLogo);
      this.setBackgroundImage("Visitor_logoCopy", this.visitingTeamLogo);
      this.setBackgroundImage("Visitor_logo_back", this.visitingTeamLogo);
      this.setBackgroundImage("Home_logo", this.homeTeamLogo);
      this.setBackgroundImage("Home_Logo", this.homeTeamLogo);
      this.setBackgroundImage("Home_logoCopy", this.homeTeamLogo);

      this.$("#pre-game-animation").show().siblings().hide();
      this.playFromLabel("LogoSAnimation", 15000, function() {
        this.playFromLabel("VisTakesOver", 5000, function() {
          this.cyclePlayerAnimations("visiting", function() {
            this.playFromLabel("TeamLogoLoop", 5000, function() {
              this.playFromLabel("HomeTakesOver", 7000, function() {
                this.cyclePlayerAnimations("home", function() {
                  this.setBackgroundImage("Visitor_Logo", this.homeTeamLogo); // sic
                  this.playFromLabel("TeamLogoLoop", 7000, function() {
                    this.$el.animate({ opacity: 0 }, 4000, function() {
                      this.board.finished(this);
                    }.bind(this));
                  });
                });
              });
            });
          });
        });
      });
    }
  },

  cyclePlayerAnimations: function(side, next, args) {
    var self = this;
    if (this.playing) {
      var teamId = App.game.get(side + "_team").id;
      var players = App.players.where({ team_id: teamId });

      var showNextPlayer = function() {
        var player = players.shift();
        if (player) {
          self.setContent("Jerser_Number", "#" + player.get("jersey_number"));
          self.setContent("Player_Name", player.get("name"));
          self.setBackgroundImage("Maxime_Leblond__74", player.get("photo_url"));
          self.playFromLabel("PlayerAnimation", 7000, showNextPlayer);
        } else {
          next.apply(self, args);
        }
      };
      showNextPlayer();
    }
  },

  setBackgroundImage: function(id, url) {
    this.$("#pre-game-animation_" + id).css("background", "url(" + url + ")");
  },

  setContent: function(id, html) {
    this.$("#pre-game-animation_" + id).html(html);
  },

  stage: function() {
    return AdobeEdge.getComposition(this.compId).getStage();
  },

  playFromLabel: function(label, duration, next, args) {
    if (this.playing) {
      console.log("playing from label " + label);
      var self = this;
      this.stage().play(label);
      setTimeout(function() { next.apply(self, args); }, duration);
    }
  }

});


