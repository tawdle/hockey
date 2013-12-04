App.Marker.PenaltiesView = Backbone.CollectionView.extend({
  filters: {
    all: function(self) {
      return function(penalty) { return penalty.get("team_id") == self.teamId; };
    },
    current: function(self) {
      return function(penalty) {
          var state = penalty.get("state");
          return penalty.get("team_id") == self.teamId &&
            (state == "created" || state == "running" || state == "paused") &&
            penalty.get("minutes");
      };
    },
    expired: function(self) {
      return function(penalty) {
          var state = penalty.get("state");
          return penalty.get("team_id") == self.teamId &&
            (state == "completed" || state == "canceled") &&
            penalty.get("minutes");
      };
    },
    other: function(self) {
      return function(penalty) {
        var state = penalty.get("state");
        return penalty.get("team_id") == self.teamId &&
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
    options.modelView = App.Marker.PenaltyView;
    options.selectable = false;
    Backbone.CollectionView.prototype.initialize.apply(this, [options]);
    this.listenTo(App.penalties, "add", this.updateCount);
    this.listenTo(App.penalties, "remove", this.updateCount);
    this.listenTo(App.penalties, "change", this.updateCount);
    this.listenTo(App.penalties, "change", this.renderIfVisible);
    this.tab.on("show", function() { self.render(); });
    this.updateCount();
  },

  renderIfVisible: function() {
    if (this.$el.is(":visible")) this.render();
  },

  updateCount: function() {
    var self = this;
    var count = this.collection.reduce(function(memo, penalty) { return self.options.visibleModelsFilter(penalty) ? memo + 1 : memo; }, 0);
    this.count.text(count || "");
  }
});


