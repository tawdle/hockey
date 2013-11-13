App.PenaltiesView = Backbone.CollectionView.extend({
  initialize: function(options, other) {
    var self = this;
    var filter = null;
    this.teamId = options.teamId;
    switch (options.type) {
      case "all":
        filter = function(penalty) {
          return penalty.teamId() == self.teamId;
        };
        break;
      case "current":
        filter = function(penalty) {
          var state = penalty.get("state");
          return penalty.teamId() == self.teamId &&
            (state == "created" || state == "running" || state == "paused") &&
            (penalty.get("minutes") !== 0);
        };
        break;
      case "expired":
        filter = function(penalty) {
          var state = penalty.get("state");
          return penalty.teamId() == self.teamId &&
            (state == "completed" || state == "canceled") &&
            (penalty.get("minutes") !== 0);
        };
        break;
      case "other":
        filter = function(penalty) {
          var state = penalty.get("state");
          return penalty.teamId() == self.teamId &&
            (state == "created") &&
            (penalty.get("minutes") === 0);
        };
        break;
    }
    options.visibleModelsFilter = filter;
    options.modelView = App.PenaltyView;
    options.selectable = false;
    Backbone.CollectionView.prototype.initialize.apply(this, [options]);
    this.render();
  }
});


