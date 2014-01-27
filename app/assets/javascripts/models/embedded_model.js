window.App = window.App || {};

App.EmbeddedModel = Backbone.Model.extend({
  // Inherit from EmbeddedModel to allow a model to instantiate
  // embedded models. To use it, declare a "models" hash that
  // has a key that identifies the incoming JSON key name,
  // and a value that corresponds to name of the Backbone model
  // to be instantiated.

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

    var models = this.models();
    for (var model in models) {
      a = attrs[model];
      if (a) {
        if (models[model] === undefined) {
          delete attrs[model];
        } else if (models[model] instanceof Backbone.Collection) {
          models[model].set(a);
          delete attrs[model];
        } else {
          if (!(a instanceof Backbone.Model)) {
            o = this.get(model);
            if (o) {
              o.set(a, options);
              delete attrs[model];
            } else {
              var nm = new models[model](a);
              this.set(model, nm);
              delete attrs[model];
            }
          } else {
            o = this.get(model);
            if (o) {
              o.set(a.attributes, options);
              delete attrs[model];
            }
          }
        }
      }
    }
    return Backbone.Model.prototype.set.call(this, attrs, options);
  }
});

