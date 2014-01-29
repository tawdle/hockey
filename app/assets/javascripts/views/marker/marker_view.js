App.Marker.MarkerView = Backbone.View.extend({
  initialize: function() {
    this.gameStart = this.$("#game-start");
    this.gamePause = this.$("#game-pause");
    this.gameStop = this.$("#game-stop");
    this.gameActivate = this.$("#game-activate");
    this.gameStatus = this.$("#game-status");
    this.period = this.$("#game-period");
    this.gameClock = this.$("#game-clock");
    this.homeView = new App.Marker.TeamBoxView({ el: "#home-team", teamId: this.model.get("home_team").id, side: "home_team" });
    this.visitingView = new App.Marker.TeamBoxView({ el: "#visiting-team", teamId: this.model.get("visiting_team").id, side: "visiting_team" });
    this.penaltyEditor = new App.Marker.PenaltyEditor({el: this.$(".penalty-editor")});
    this.clockEditor = new App.Marker.ClockEditor({el: this.$(".clock-editor"), model: this.model });

    this.listenTo(this.model, "change", this.render);
    setInterval(function() { App.dispatcher.trigger("clockTick"); }.bind(this), 500);
    this.gameClockView = new App.TimerView({el: this.gameClock, model: App.game.get("clock"), showTimeRemaining: true});
    this.render();

    this.feedItemsView = new Backbone.CollectionView({
      el: "#feed-items",
      collection: App.feedItems,
      modelView: App.FeedItemView,
      emptyListCaption: "There are no activity feed items yet for this game."
    });
    this.feedItemsView.render();
    this.timerOnSound = new Audio("/assets/sounds/timer_on.wav");
    this.timerOffSound = new Audio("/assets/sounds/timer_off.wav");

    $(document).on("keypress", this.keyPressed.bind(this));
  },

  events: {
    "click #game-start" : "start",
    "click #game-pause" : "pause",
    "click #game-stop" : "stop",
    "click #game-activate" : "activate",
    "click #game-clock" : "adjustClock",
    "click a.add-penalty" : "addPenalty",
    "ajax:success #new_feed_user_post" : "clearMessageText",
    "click .swap" : "swapTeamBoxes"
  },

  start: function(e) {
    e.preventDefault();
    this.model.start();
    this.timerOnSound.play();
  },

  pause: function(e) {
    e.preventDefault();
    this.model.pause();
    this.timerOffSound.play();
  },

  stop: function(e) {
    e.preventDefault();
    if (confirm("End this game now?")) {
      this.model.stop();
    }
  },

  activate: function(e) {
    e.preventDefault();
    this.model.activate();
  },

  adjustClock: function(e) {
    e.preventDefault();
    this.clockEditor.edit();
  },

  addPenalty: function(e) {
    e.preventDefault();
    App.game.pause();
    var penalty = new App.Penalty({}, {collection: App.penalties});
    this.penaltyEditor.edit(penalty);
  },

  clearMessageText: function() {
    this.$("#feed_user_post_message").val("");
  },

  swapElements: function(elements) {
    var parent1, next1,
    parent2, next2;

    parent1 = elements[0].parentNode;
    next1   = elements[0].nextSibling;
    parent2 = elements[1].parentNode;
    next2   = elements[1].nextSibling;

    parent1.insertBefore(elements[1], next1);
    parent2.insertBefore(elements[0], next2);
  },

  swapTeamBoxes: function(e) {
    e.preventDefault();
    this.swapElements(this.$(".team-box"));
  },

  keyPressed: function(e) {
    if (e.which == 32) {
      var state = this.model.get("state");
      if (state == "ready" || state == "paused") {
        this.start(e);
        return false;
      } else if (state == "playing") {
        this.pause(e);
        return false;
      }
    }
    return true;
  },

  render: function() {
    var state = this.model.get("state"), period = this.model.get("period");
    this.gameStart.toggle(state == "ready" || state == "paused");
    this.gamePause.toggle(state == "playing");
    this.gameStop.toggle(((state == "playing" || state == "paused" || state == "active") && period >= 2) || (state == "ready" && period >= 3));
    this.gameActivate.toggle(state == "active");
    $("p[class=" + state + "]", this.gameStatus).toggle(true).siblings().toggle(false);

    this.period.text(this.model.get("period_text"));
    this.gameStatus.removeClass("active playing paused finished").addClass(state);
    this.gameClock.css( {cursor: state == "ready" ? "pointer" : "normal"});
  }
});
