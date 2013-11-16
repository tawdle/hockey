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
    options.visibleModelsFilter = this.filters[options.type](self);
    options.modelView = App.PenaltyView;
    options.selectable = false;
    Backbone.CollectionView.prototype.initialize.apply(this, [options]);
    this.listenTo(App.game, "change:state", this.gameStateChanged);
    $("a[href=#" + this.el.parentNode.id + "]").on("show", function() { self.render(); });
  },

  gameStateChanged: function() {
    if (this.$el.is(":visible") && App.game.get("state") == "playing") {
      this.render();
    }
  }
});


