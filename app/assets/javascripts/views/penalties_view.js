App.PenaltiesView = Backbone.CollectionView.extend({
  filters: {
    all: function(self) {
      return function(penalty) { return penalty.teamId() == self.teamId; };
    },
    current: function(self) {
      return function(penalty) {
          var state = penalty.get("state");
          return penalty.teamId() == self.teamId &&
            (state == "created" || state == "running" || state == "paused") &&
            penalty.get("minutes");
      };
    },
    expired: function(self) {
      return function(penalty) {
          var state = penalty.get("state");
          return penalty.teamId() == self.teamId &&
            (state == "completed" || state == "canceled") &&
            penalty.get("minutes");
      };
    },
    other: function(self) {
      return function(penalty) {
        var state = penalty.get("state");
        return penalty.teamId() == self.teamId &&
          (state == "created") &&
          !penalty.get("minutes");
      };
    }
  },


  initialize: function(options, other) {
    var self = this;
    var filter = null;
    this.teamId = options.teamId;
    this.tab = $("a[href=#" + this.el.parentNode.id + "]");
    this.count = $("span.count", this.tab);
    options.visibleModelsFilter = this.filters[options.type](self);
    options.modelView = App.PenaltyView;
    options.selectable = false;
    Backbone.CollectionView.prototype.initialize.apply(this, [options]);
    this.listenTo(App.game, "change:state", this.gameStateChanged);
    this.listenTo(App.penalties, "add", this.updateCount);
    this.listenTo(App.penalties, "remove", this.updateCount);
    this.listenTo(App.penalties, "change", this.updateCount);
    this.tab.on("show", function() { self.render(); });
    this.updateCount();
  },

  gameStateChanged: function() {
    if (this.$el.is(":visible") && App.game.get("state") == "playing") {
      this.render();
    }
  },

  updateCount: function() {
    var self = this;
    var count = this.collection.reduce(function(memo, penalty) { return self.options.visibleModelsFilter(penalty) ? memo + 1 : memo; }, 0);
    this.count.text(count ? " (" + count + ")" : "");
  }
});


