window.App = window.App || {};

App.Game = Backbone.Model.extend({
  // The game subscribes the faye channel and holds on to references to all fo the subsidiary models.
  // When changes happen, it delegates to the relevant models to update them, and the views do their things.

  // We need to be supplied with the URI for the Faye server and the id of the game that we are.

  defaults: function() {
    return {
      id: null,
      state: "scheduled",
      clock: null,
      fayeURI: null
    };
  },

  models: function() {
    return {
      clock: App.Timer
    };
  },

  initialize: function() {
    this.faye = new Faye.Client(this.get("fayeURI"));
    this.faye.subscribe("/games/" + this.get("id"), function(message) {
      this.set(message);
    }.bind(this));
  },

  set: function(key, val, options) {
    var o, a, attrs;

    if (key === null) return this;
    if (typeof key === 'object') {
      attrs = key;
      options = val;
    } else {
      (attrs = {})[key] = val;
    }

    options = options || {};

    models = this.models();
    for (model in models) {
      a = attrs[model];
      if (a) {
        o = this.get(model);
        if (o) {
          o.set(a, options);
          delete attrs[model];
        } else {
          if (!(a instanceof Backbone.Model)) {
            this.set(model, new models[model](a));
            delete attrs[model];
          }
        }
      }
    }
    return Backbone.Model.prototype.set.apply(this, arguments);
  }
});
