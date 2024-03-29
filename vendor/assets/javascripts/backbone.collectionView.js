/*!
* Backbone.CollectionView, v0.6.1
* Copyright (c)2013 Rotunda Software, LLC.
* Distributed under MIT license
* http://github.com/rotundasoftware/backbone-collection-view
*/


(function(){
  var mDefaultModelViewConstructor = Backbone.View;

  var kDefaultReferenceBy = "model";

  var kAllowedOptions = [
    "collection", "modelView", "modelViewOptions", "itemTemplate", "emptyListCaption",
    "selectable", "clickToSelect", "selectableModelsFilter", "visibleModelsFilter",
    "selectMultiple", "clickToToggle", "processKeyEvents", "sortable", "sortableModelsFilter", "itemTemplateFunction"
  ];

  var kOptionsRequiringRerendering = [ "collection", "modelView", "modelViewOptions", "itemTemplate", "selectableModelsFilter", "sortableModelsFilter", "visibleModelsFilter", "itemTemplateFunction" ];

  var kStylesForEmptyListCaption = {
    "background" : "transparent",
    "border" : "none",
    "box-shadow" : "none"
  };

  Backbone.CollectionView = Backbone.View.extend({

    tagName : "ul",

    events : {
      "mousedown li, td" : "_listItem_onMousedown",
      "dblclick li, td" : "_listItem_onDoubleClick",
      "click" : "_listBackground_onClick",
      "click ul.collection-list, table.collection-list" : "_listBackground_onClick",
      "keydown" : "_onKeydown"
    },

    // only used if Backbone.Courier is available
    spawnMessages : {
      "focus" : "focus"
    },

    //only used if Backbone.Courier is available
    passMessages : { "*" : "." },

    initialize : function( options ){
      var _this = this;

      // default options
      options = _.extend( {}, {
        collection : null,
        modelView : this.modelView || null,
        modelViewOptions : {},
        itemTemplate : null,
        itemTemplateFunction : null,
        selectable : true,
        clickToSelect : true,
        selectableModelsFilter : null,
        visibleModelsFilter : null,
        sortableModelsFilter : null,
        selectMultiple : false,
        clickToToggle : false,
        processKeyEvents : true,
        sortable : false,
        emptyListCaption : null
      }, options );

      // add each of the white-listed options to the CollectionView object itself
      _.each( kAllowedOptions, function( option ) {
        _this[ option ] = options[option];
      } );

      if( ! this.collection ) this.collection = new Backbone.Collection();

      if( this._isBackboneCourierAvailable() ) {
        Backbone.Courier.add( this );
      }

      this.$el.data( "view", this ); // needed for connected sortable lists
      this.$el.addClass( "collection-list" );
      if( this.processKeyEvents )
        this.$el.attr( "tabindex", 0 ); // so we get keyboard events

      this.selectedItems = [];

      this._updateItemTemplate();

      if( ! _.isUndefined( this.collection ) && ! _.isNull( this.collection ) ) {
        this.listenTo( this.collection, "add", function() {
          this.render();
          if( this._isBackboneCourierAvailable() )
            this.spawn( "add" );
        } );

        this.listenTo( this.collection, "remove", function() {
          this.render();
          if( this._isBackboneCourierAvailable() )
            this.spawn( "remove" );
        } );

        this.listenTo( this.collection, "reset", function() {
          this.render();
          if( this._isBackboneCourierAvailable() )
            this.spawn( "reset" );
        } );
      }

      this.viewManager = new ChildViewContainer();

      //this.listenTo( this.collection, "change", function() { this.render(); this.spawn( "change" ); } ); // don't want changes to models bubbling up and triggering the list's render() function

      // note we do NOT call render here anymore, because if we inherit from this class we will likely call this
      // function using __super__ before the rest of the initialization logic for the decendent class. however, we may
      // override the render() function in that decendent class as well, and that will certainly expect all the initialization
      // to be done already. so we have to make sure to not jump the gun and start rending at this point.
      // this.render();
    },

    setOption : function( name, value ) {

      var _this = this;

      if( name === "collection" ) {
        this._setCollection( value );
      }
      else {
        if( _.contains( kAllowedOptions, name ) ) {

          switch( name ) {
            case "selectMultiple" :
              this[ name ] = value;
              if( !value && this.selectedItems.length > 1 )
                this.setSelectedModel( _.first( this.selectedItems ), { by : "cid" } );
              break;
            case "selectable" :
              if( !value && this.selectedItems.length > 0 )
                this.setSelectedModels( [] );
              this[ name ] = value;
              break;
            case "selectableModelsFilter" :
              this[ name ] = value;
              if( value && _.isFunction( value ) )
                this._validateSelection();
              break;
            case "itemTemplate" :
              this[ name ] = value;
              this._updateItemTemplate();
              break;
            case "processKeyEvents" :
              this[ name ] = value;
              if( value )  this.$el.attr( "tabindex", 0 ); // so we get keyboard events
              break;
            case "modelView" :
              this[ name ] = value;
              //need to remove all old view instances
              this.viewManager.each( function( view ) {
                _this.viewManager.remove( view );
              } );
              break;
            default :
              this[ name ] = value;
          }

          if( _.contains( kOptionsRequiringRerendering, name ) )  this.render();
        }
        else throw name + " is not an allowed option";
      }
    },

    getSelectedModel : function( options ) {
      return _.first( this.getSelectedModels( options ) );
    },

    getSelectedModels : function ( options ) {
      var _this = this;

      options = _.extend( {}, {
        by : kDefaultReferenceBy
      }, options );

      var referenceBy = options.by;
      var items = [];

      switch( referenceBy ) {
        case "id" :
          _.each( this.selectedItems, function ( item ) {
            items.push( _this.collection.get( item ).id );
          } );
          break;
        case "cid" :
          items = items.concat( this.selectedItems );
          break;
        case "offset" :
          var curLineNumber = 0;

          var itemElements;
          if( this._isRenderedAsTable() )
            itemElements = this.$el.find( "> tbody > [data-item-id]:visible" );
          else if( this._isRenderedAsList() )
            itemElements = this.$el.find( "> [data-item-id]:visible" );

          itemElements.each( function() {
            var thisItemEl = $( this );
            if( thisItemEl.is( ".selected" ) )
              items.push( curLineNumber );
            curLineNumber++;
          } );
          break;
        case "model" :
          _.each( this.selectedItems, function ( item ) {
            items.push( _this.collection.get( item ) );
          } );
          break;
        case "view" :
          _.each( this.selectedItems, function ( item ) {
            items.push( _this.viewManager.findByModel( _this.collection.get( item ) ) );
          } );
          break;
        default :
          throw "The referenceBy property was not properly set";
      }

      return items;

    },

    setSelectedModels : function( newSelectedItems, options ) {
      if( ! this.selectable ) throw "Attempt to set selected items on non-selectable list";
      if( ! _.isArray( newSelectedItems ) ) throw "Invalid parameter value";

      options = _.extend( {}, {
        silent : false,
        by : kDefaultReferenceBy
      }, options );

      var referenceBy = options.by;
      var newSelectedCids = [];

      switch( referenceBy ) {
        case "cid" :
          newSelectedCids = newSelectedItems;
          break;
        case "id" :
          this.collection.each( function( thisModel ) {
            if( _.contains( newSelectedItems, thisModel.id ) ) newSelectedCids.push( thisModel.cid );
          } );
          break;
        case "model" :
          newSelectedCids = _.pluck( newSelectedItems, "cid" );
          break;
        case "view" :
          _.each( newSelectedItems, function( item ) {
            newSelectedCids.push( item.model.cid );
          } );
          break;
        case "offset" :
          var curLineNumber = 0;
          var selectedItems = [];

          var itemElements;
          if( this._isRenderedAsTable() )
            itemElements = this.$el.find( "> tbody > [data-item-id]:visible" );
          else if( this._isRenderedAsList() )
            itemElements = this.$el.find( "> [data-item-id]:visible" );

          itemElements.each( function() {
            var thisItemEl = $( this );
            if( _.contains( newSelectedItems, curLineNumber ) )
              newSelectedCids.push( thisItemEl.attr( "data-item-id" ) );
            curLineNumber++;
          } );
          break;
        default :
          throw "The referenceBy property was not properly set";
      }

      var oldSelectedModels = this.getSelectedModels();
      var oldSelectedCids = _.clone( this.selectedItems );

      this.selectedItems = this._convertStringsToInts( newSelectedCids );
      this._validateSelection();

      var newSelectedModels = this.getSelectedModels();

      if( ! this._containSameElements( oldSelectedCids, this.selectedItems ) )
      {
        this._addSelectedClassToSelectedItems( oldSelectedCids );

        if( ! options.silent )
        {
          this.trigger( "selectionChanged", newSelectedModels, oldSelectedModels );
          if( this._isBackboneCourierAvailable() ) {
            this.spawn( "selectionChanged", {
              selectedModels : newSelectedModels,
              oldSelectedModels : oldSelectedModels
            } );
          }
        }

        this.updateDependentControls();
      }
    },

    setSelectedModel : function( newSelectedItem, options ) {
      if( _.isUndefined( newSelectedItem ) || _.isNull( newSelectedItem) )
        this.setSelectedModels( [], options );
      else
        this.setSelectedModels( [ newSelectedItem ], options );
    },

    render : function(){
      var _this = this;

      if( this.selectable ) this._saveSelection();

      var modelViewContainerEl;

      // If collection view element is a table and it has a tbody
      // within it, render the model views inside of the tbody
      if( this._isRenderedAsTable() ) {
        var tbodyChild = this.$el.find( "> tbody" );
        if( tbodyChild.length > 0 )
          modelViewContainerEl = tbodyChild;
      }

      if( _.isUndefined( modelViewContainerEl ) )
        modelViewContainerEl = this.$el;

      var oldViewManager = this.viewManager;
      this.viewManager = new ChildViewContainer();

      // detach each of our subviews that we have already created to represent models
      // in the collection. We are going to re-use the ones that represent models that
      // are still here, instead of creating new ones, so that we don't loose state
      // information in the views.
      oldViewManager.each( function( thisModelView ) {
        // to boost performance, only detach those views that will be sticking around.
        // we won't need the other ones later, so no need to detach them individually.
        if( _this.collection.get( thisModelView.model.cid ) )
          thisModelView.$el.detach();
      } );

      modelViewContainerEl.empty();

      this.collection.each( function( thisModel ) {
        var thisModelView;

        thisModelView = oldViewManager.findByModelCid( thisModel.cid );
        if( _.isUndefined( thisModelView ) ) {
          // if the model view was not already created on previous render,
          // then create and initialize it now.

          var modelViewOptions = this._getModelViewOptions( thisModel );
          thisModelView = this._createNewModelView( thisModel, modelViewOptions );

          thisModelView.collectionListView = _this;
          thisModelView.model = thisModel;
        }

        var thisModelViewWrapped = this._wrapModelView( thisModelView );
        modelViewContainerEl.append( thisModelViewWrapped );

        // we have to render the modelView after it has been put in context, as opposed to in the 
        // initialize function of the modelView, because some rendering might be dependent on
        // the modelView's context in the DOM tree. For example, if the modelView stretch()'s itself,
        // it must be in full context in the DOM tree or else the stretch will not behave as intended.
        var renderResult = thisModelView.render();

        // return false from the view's render function to hide this item
        if( renderResult === false )
          thisModelViewWrapped.hide();

        if( _.isFunction( this.visibleModelsFilter ) ) {
          var onlyChild = thisModelViewWrapped.children().length === 1;
          if( ! this.visibleModelsFilter( thisModel ) ) {
            if( onlyChild )
              thisModelViewWrapped.hide();
            else thisModelView.$el.hide();
          } else {
            if (onlyChild)
              thisModelViewWrapped.show();
            else
              thisModelView.$el.show();
          }
        }

        this.viewManager.add( thisModelView );
      }, this );

      if( this.sortable )
      {
        var sortableOptions = _.extend( {
          axis: "y",
          distance: 10,
          forcePlaceholderSize : true,
          start : _.bind( this._sortStart, this ),
          change : _.bind( this._sortChange, this ),
          stop : _.bind( this._sortStop, this ),
          receive : _.bind( this._receive, this )
        }, _.result( this, "sortableOptions" ) );

        if( this.sortableModelsFilter === null ) {
          if( _this._isRenderedAsTable() ) {
            sortableOptions.items = "> tbody > *";
          }
          else if( _this._isRenderedAsList() ) {
            sortableOptions.items = "> *";
          }
        }
        else if( _.isString( this.sortableModelsFilter ) ) {
          sortableOptions.items = this.sortableModelsFilter;
        }
        else if( _.isFunction( this.sortableModelsFilter ) ) {
          if( _this._isRenderedAsTable() ) {
            sortableOptions.items = "> tbody > tr:not(.not-sortable)";
          }
          else if( _this._isRenderedAsList() ) {
            sortableOptions.items = "> li:not(.not-sortable)";
          }
        }

        this.$el = this.$el.sortable( sortableOptions );
      }

      if( this.emptyListCaption ) {
        var visibleView = this.viewManager.find( function( view ) {
          return view.$el.is( ":visible" );
        } );

        if( _.isUndefined( visibleView ) ) {
          var emptyListString;

          if( _.isFunction( this.emptyListCaption ) )
            emptyListString = this.emptyListCaption();
          else
            emptyListString = this.emptyListCaption;

          var $emptyCaptionEl;
          var $varEl = $( "<var class='empty-list-caption'>" + emptyListString + "</var>" );

          //need to wrap the empty caption to make it fit the rendered list structure (either with an li or a tr td)
          if( this._isRenderedAsList() )
            $emptyListCaptionEl = $varEl.wrapAll( "<li class='not-sortable'></li>" ).parent().css( kStylesForEmptyListCaption );
          else
            $emptyListCaptionEl = $varEl.wrapAll( "<tr class='not-sortable'><td></td></tr>" ).parent().parent().css( kStylesForEmptyListCaption );

          this.$el.append( $emptyListCaptionEl );
        }
      }

      this.trigger( "render" );
      if( this._isBackboneCourierAvailable() )
        this.spawn( "render" );

      if( this.selectable ) {
        this._restoreSelection();
        this.updateDependentControls();
      }

      if( _.isFunction( this.onAfterRender ) )
        this.onAfterRender();
    },

    updateDependentControls : function() {
      this.trigger( "updateDependentControls", this.getSelectedModels() );
      if( this._isBackboneCourierAvailable() ) {
        this.spawn( "updateDependentControls", {
          selectedModels : this.getSelectedModels()
        } );
      }
    },

    _validateSelectionAndRender : function() {
      this._validateSelection();
      this.render();
    },

    _getClickedItemId : function( theEvent ) {
      var clickedItemId = null;

      // important to use currentTarget as opposed to target, since we could be bubbling
      // an event that took place within another collectionList
      var clickedItemEl = $( theEvent.currentTarget );
      if( clickedItemEl.closest( ".collection-list" ).get(0) !== this.$el.get(0) ) return;

      // determine which list item was clicked. If we clicked in the blank area
      // underneath all the elements, we want to know that too, since in this
      // case we will want to deselect all elements. so check to see if the clicked
      // DOM element is the list itself to find that out.
      var clickedItem = clickedItemEl.closest( "[data-item-id]" );
      if( clickedItem.length > 0 )
      {
        clickedItemId = clickedItem.attr('data-item-id');
        if( $.isNumeric( clickedItemId ) ) clickedItemId = parseInt( clickedItemId, 10 );
      }

      return clickedItemId;
    },

    _setCollection : function( newCollection ) {
      if( newCollection !== this.collection )
      {
        this.collection = newCollection;

        this.collection.bind( "add", this.render, this );
        this.collection.bind( "remove", this._validateSelectionAndRender, this );
        this.collection.bind( "reset", this._validateSelectionAndRender, this );
        //this.collection.bind( "change", this.render, this ); //don't want changes to models bubbling up to force re-render of entire list
      }

      this.render();
    },

    _updateItemTemplate : function() {
      var itemTemplateHtml;
      if( this.itemTemplate )
      {
        if( $( this.itemTemplate ).length === 0 )
          throw "Could not find item template from selector: " + this.itemTemplate;

        itemTemplateHtml = $( this.itemTemplate ).html();
      }
      else
        itemTemplateHtml = this.$( ".item-template" ).html();

      if( itemTemplateHtml ) this.itemTemplateFunction = _.template( itemTemplateHtml );

    },

    _validateSelection : function() {
      // note can't use the collection's proxy to underscore because "cid" ais not an attribute,
      // but an element of the model object itself.
      var modelReferenceIds = _.pluck( this.collection.models, "cid" );
      this.selectedItems = _.intersection( modelReferenceIds, this.selectedItems );

      if( _.isFunction( this.selectableModelsFilter ) )
      {
        this.selectedItems = _.filter( this.selectedItems, function( thisItemId ) {
          return this.selectableModelsFilter.call( this, this.collection.get( thisItemId ) );
        }, this );
      }
    },

    _saveSelection : function() {
      // save the current selection. use restoreSelection() to restore the selection to the state it was in the last time saveSelection() was called.
      if( ! this.selectable ) throw "Attempt to save selection on non-selectable list";
      this.savedSelection = {
        items : this.selectedItems,
        offset : this.getSelectedModel( { by : "offset" } )
      };
    },

    _restoreSelection : function() {
      if( ! this.savedSelection ) throw "Attempt to restore selection but no selection has been saved!";

      // reset selectedItems to empty so that we "redraw" all "selected" classes
      // when we set our new selection. We do this because it is likely that our
      // contents have been refreshed, and we have thus lost all old "selected" classes.
      this.setSelectedModels( [], { silent : true } );

      if( this.savedSelection.items.length > 0 )
      {
        // first try to restore the old selected items using their reference ids.
        this.setSelectedModels( this.savedSelection.items, { by : "cid", silent : true } );

        // all the items with the saved reference ids have been removed from the list.
        // ok. try to restore the selection based on the offset that used to be selected.
        // this is the expected behavior after a item is deleted from a list (i.e. select
        // the line that immediately follows the deleted line).
        if( this.selectedItems.length === 0 )
          this.setSelectedModel( this.savedSelection.offset, { by : "offset" } );

        // Trigger a selection changed if the previously selected items were not all found
        if (this.selectedItems.length !== this.savedSelection.items.length)
        {
          this.trigger( "selectionChanged", this.getSelectedModels(), [] );
          if( this._isBackboneCourierAvailable() ) {
            this.spawn( "selectionChanged", {
              selectedModels : this.selectedItems,
              oldSelectedModels : this.savedSelection.items
            } );
          }
        }
      }

      delete this.savedSelection;
    },

    _addSelectedClassToSelectedItems : function( oldItemsIdsWithSelectedClass ) {
      if( _.isUndefined( oldItemsIdsWithSelectedClass ) ) oldItemsIdsWithSelectedClass = [];

      // oldItemsIdsWithSelectedClass is used for optimization purposes only. If this info is supplied then we
      // only have to add / remove the "selected" class from those items that "selected" state has changed.

      var itemsIdsFromWhichSelectedClassNeedsToBeRemoved = oldItemsIdsWithSelectedClass;
      itemsIdsFromWhichSelectedClassNeedsToBeRemoved = _.without( itemsIdsFromWhichSelectedClassNeedsToBeRemoved, this.selectedItems );

      _.each( itemsIdsFromWhichSelectedClassNeedsToBeRemoved, function( thisItemId ) {
        this.$el.find( "[data-item-id=" + thisItemId + "]" ).removeClass( "selected" );
      }, this );

      var itemsIdsFromWhichSelectedClassNeedsToBeAdded = this.selectedItems;
      itemsIdsFromWhichSelectedClassNeedsToBeAdded = _.without( itemsIdsFromWhichSelectedClassNeedsToBeAdded, oldItemsIdsWithSelectedClass );

      _.each( itemsIdsFromWhichSelectedClassNeedsToBeAdded, function( thisItemId ) {
        this.$el.find( "[data-item-id=" + thisItemId + "]" ).addClass( "selected" );
      }, this );
    },

    _reorderCollectionBasedOnHTML : function() {
      var _this = this;

      this.$el.children().each( function() {
        var thisModelId = $( this ).attr( "data-item-id" );

        if( thisModelId )
        {
          // remove the current model and then add it back (at the end of the collection).
          // When we are done looping through all models, they will be in the correct order.
          var thisModel = _this.collection.get( thisModelId );
          if( thisModel )
          {
            _this.collection.remove( thisModel, { silent : true } );
            _this.collection.add( thisModel, { silent : true } );
          }
        }
      } );

      this.collection.trigger( "reorder" );

      if( this._isBackboneCourierAvailable() ) this.spawn( "reorder" );

    },

    _getModelViewConstructor : function( thisModel ) {
      return this.modelView || mDefaultModelViewConstructor;
    },

    _getModelViewOptions : function( thisModel ) {
      return _.extend( { model : thisModel }, this.modelViewOptions );
    },

    _createNewModelView : function( model, modelViewOptions ) {
      var modelViewConstructor = this._getModelViewConstructor( model );
      if( _.isUndefined( modelViewConstructor ) ) throw "Could not find modelView constructor for model";

      return new ( modelViewConstructor )( modelViewOptions );
    },

    _wrapModelView : function( modelView ) {
      var _this = this;

      // we use items client ids as opposed to real ids, since we may not have a representation
      // of these models on the server
      var wrappedModelView;

      if( this._isRenderedAsTable() ) {
        // if we are rendering the collection in a table, the template $el is a tr so we just need to set the data-item-id
        wrappedModelView = modelView.$el.attr( "data-item-id", modelView.model.cid );
      }
      else if( this._isRenderedAsList() ) {
        // if we are rendering the collection in a list, we need wrap each item in an <li></li> and set the data-item-id
        wrappedModelView = modelView.$el.wrapAll( "<li data-item-id='" + modelView.model.cid + "'></li>" ).parent();
      }

      if( _.isFunction( this.sortableModelsFilter ) )
        if( ! this.sortableModelsFilter.call( _this, modelView.model ) )
          wrappedModelView.addClass( "not-sortable" );

      if( _.isFunction( this.selectableModelsFilter ) )
        if( ! this.selectableModelsFilter.call( _this, modelView.model ) )
          wrappedModelView.addClass( "not-selectable" );

      return wrappedModelView;
    },

    _convertStringsToInts : function( theArray ) {
      return _.map( theArray, function( thisEl ) {
        if( ! _.isString( thisEl ) ) return thisEl;
        var thisElAsNumber = parseInt( thisEl, 10 );
        return( thisElAsNumber == thisEl ? thisElAsNumber : thisEl );
      } );
    },

    _containSameElements : function( arrayA, arrayB ) {
      if( arrayA.length != arrayB.length ) return false;
      var intersectionSize = _.intersection( arrayA, arrayB ).length;
      return intersectionSize == arrayA.length; // and must also equal arrayB.length, since arrayA.length == arrayB.length
    },

    _isRenderedAsTable : function() {
      return this.$el.prop('tagName').toLowerCase() === 'table';
    },


    _isRenderedAsList : function() {
      return ! this._isRenderedAsTable();
    },

    _charCodes : {
      upArrow : 38,
      downArrow : 40
    },

    _isBackboneCourierAvailable : function() {
      return !_.isUndefined( Backbone.Courier );
    },

    _sortStart : function( event, ui ) {
      var modelBeingSorted = this.collection.get( ui.item.attr( "data-item-id" ) );
      this.trigger( "sortStart", modelBeingSorted );
      if( this._isBackboneCourierAvailable() )
        this.spawn( "sortStart", { modelBeingSorted : modelBeingSorted } );
    },

    _sortChange : function( event, ui ) {
      var modelBeingSorted = this.collection.get( ui.item.attr( "data-item-id" ) );
      this.trigger( "sortChange", modelBeingSorted );
      if( this._isBackboneCourierAvailable() )
        this.spawn( "sortChange", { modelBeingSorted : modelBeingSorted } );
    },

    _sortStop : function( event, ui ) {
      var modelBeingSorted = this.collection.get( ui.item.attr( "data-item-id" ) );
      var newIndex = this.$el.children().index( ui.item );

      if( newIndex == -1 ) {
        // the element was removed from this list. can happen if this sortable is connected
        // to another sortable, and the item was dropped into the other sortable.
        this.collection.remove( modelBeingSorted );
      }

      this._reorderCollectionBasedOnHTML();
      this.updateDependentControls();
      this.trigger( "sortStop", modelBeingSorted, newIndex );
      if( this._isBackboneCourierAvailable() )
        this.spawn( "sortStop", { modelBeingSorted : modelBeingSorted, newIndex : newIndex } );
    },

    _receive : function( event, ui ) {
      var senderListEl = ui.sender;
      var senderCollectionListView = senderListEl.data( "view" );
      if( ! senderCollectionListView || ! senderCollectionListView.collection ) return;

      var newIndex = this.$el.children().index( ui.item );
      var modelReceived = senderCollectionListView.collection.get( ui.item.attr( "data-item-id" ) );
      this.collection.add( modelReceived, { at : newIndex } );
      modelReceived.collection = this.collection; // otherwise will not get properly set, since modelReceived.collection might already have a value.
      this.setSelectedModel( modelReceived );
    },

    _onKeydown : function( event ) {
      if( ! this.processKeyEvents ) return true;

      var trap = false;

      if( this.getSelectedModels( { by : "offset" } ).length == 1 )
      {
        // need to trap down and up arrows or else the browser
        // will end up scrolling a autoscroll div.

        var currentOffset = this.getSelectedModel( { by : "offset" } );
        if( event.which === this._charCodes.upArrow && currentOffset !== 0 )
        {
          this.setSelectedModel( currentOffset - 1, { by : "offset" } );
          trap = true;
        }
        else if( event.which === this._charCodes.downArrow && currentOffset !== this.collection.length - 1 )
        {
          this.setSelectedModel( currentOffset + 1, { by : "offset" } );
          trap = true;
        }
      }

      return ! trap;
    },

    _listItem_onMousedown : function( theEvent ) {
      if( ! this.selectable || ! this.clickToSelect ) return;

      var clickedItemId = this._getClickedItemId( theEvent );

      if( clickedItemId )
      {
        // Exit if an unselectable item was clicked
        if( _.isFunction( this.selectableModelsFilter ) &&
          ! this.selectableModelsFilter.call( this, this.collection.get( clickedItemId ) ) )
        {
          return;
        }

        // a selectable list item was clicked
        if( this.selectMultiple && theEvent.shiftKey )
        {
          var firstSelectedItemIndex = -1;

          if( this.selectedItems.length > 0 )
          {
            this.collection.find( function( thisItemModel ) {
              firstSelectedItemIndex++;

              // exit when we find our first selected element
              return _.contains( this.selectedItems, thisItemModel.cid );
            }, this );
          }

          var clickedItemIndex = -1;
          this.collection.find( function( thisItemModel ) {
            clickedItemIndex++;

            // exit when we find the clicked element
            return thisItemModel.cid == clickedItemId;
          }, this );

          var shiftKeyRootSelectedItemIndex = firstSelectedItemIndex == -1 ? clickedItemIndex : firstSelectedItemIndex;
          var minSelectedItemIndex = Math.min( clickedItemIndex, shiftKeyRootSelectedItemIndex );
          var maxSelectedItemIndex = Math.max( clickedItemIndex, shiftKeyRootSelectedItemIndex );

          var newSelectedItems = [];
          for( var thisIndex = minSelectedItemIndex; thisIndex <= maxSelectedItemIndex; thisIndex ++ )
            newSelectedItems.push( this.collection.at( thisIndex ).cid );
          this.setSelectedModels( newSelectedItems, { by : "cid" } );

          // shift clicking will usually highlight selectable text, which we do not want.
          // this is a cross browser (hopefully) snippet that deselects all text selection.
          if( document.selection && document.selection.empty )
            document.selection.empty();
          else if(window.getSelection) {
            var sel = window.getSelection();
            if( sel && sel.removeAllRanges )
              sel.removeAllRanges();
          }
        }
        else if( this.selectMultiple && ( this.clickToToggle || theEvent.metaKey ) )
        {
          if( _.contains( this.selectedItems, clickedItemId ) )
            this.setSelectedModels( _.without( this.selectedItems, clickedItemId ), { by : "cid" } );
          else this.setSelectedModels( _.union( this.selectedItems, clickedItemId ), { by : "cid" } );
        }
        else
          this.setSelectedModels( [ clickedItemId ], { by : "cid" } );
      }
      else
        // the blank area of the list was clicked
        this.setSelectedModels( [] );

    },

    _listItem_onDoubleClick : function( theEvent ) {
      var clickedItemId = this._getClickedItemId( theEvent );

      if( clickedItemId )
      {
        var clickedModel = this.collection.get( clickedItemId );
        this.trigger( "doubleClick", clickedModel );
        if( this._isBackboneCourierAvailable() )
          this.spawn( "doubleClick", { clickedModel : clickedModel } );
      }
    },

    _listBackground_onClick : function( theEvent ) {
      if( ! this.selectable ) return;
      if( ! $( theEvent.target ).is( ".collection-list" ) ) return;

      this.setSelectedModels( [] );
    }

  }, {
    setDefaultModelViewConstructor : function( theConstructor ) {
      mDefaultModelViewConstructor = theConstructor;
    }
  });


  // Backbone.BabySitter
  // -------------------
  // v0.0.6
  //
  // Copyright (c)2013 Derick Bailey, Muted Solutions, LLC.
  // Distributed under MIT license
  //
  // http://github.com/babysitterjs/backbone.babysitter

  // Backbone.ChildViewContainer
  // ---------------------------
  //
  // Provide a container to store, retrieve and
  // shut down child views.

  ChildViewContainer = (function(Backbone, _){
    
    // Container Constructor
    // ---------------------

    var Container = function(views){
      this._views = {};
      this._indexByModel = {};
      this._indexByCustom = {};
      this._updateLength();

      _.each(views, this.add, this);
    };

    // Container Methods
    // -----------------

    _.extend(Container.prototype, {

      // Add a view to this container. Stores the view
      // by `cid` and makes it searchable by the model
      // cid (and model itself). Optionally specify
      // a custom key to store an retrieve the view.
      add: function(view, customIndex){
        var viewCid = view.cid;

        // store the view
        this._views[viewCid] = view;

        // index it by model
        if (view.model){
          this._indexByModel[view.model.cid] = viewCid;
        }

        // index by custom
        if (customIndex){
          this._indexByCustom[customIndex] = viewCid;
        }

        this._updateLength();
      },

      // Find a view by the model that was attached to
      // it. Uses the model's `cid` to find it.
      findByModel: function(model){
        return this.findByModelCid(model.cid);
      },

      // Find a view by the `cid` of the model that was attached to
      // it. Uses the model's `cid` to find the view `cid` and
      // retrieve the view using it.
      findByModelCid: function(modelCid){
        var viewCid = this._indexByModel[modelCid];
        return this.findByCid(viewCid);
      },

      // Find a view by a custom indexer.
      findByCustom: function(index){
        var viewCid = this._indexByCustom[index];
        return this.findByCid(viewCid);
      },

      // Find by index. This is not guaranteed to be a
      // stable index.
      findByIndex: function(index){
        return _.values(this._views)[index];
      },

      // retrieve a view by it's `cid` directly
      findByCid: function(cid){
        return this._views[cid];
      },

      // Remove a view
      remove: function(view){
        var viewCid = view.cid;

        // delete model index
        if (view.model){
          delete this._indexByModel[view.model.cid];
        }

        // delete custom index
        _.any(this._indexByCustom, function(cid, key) {
          if (cid === viewCid) {
            delete this._indexByCustom[key];
            return true;
          }
        }, this);

        // remove the view from the container
        delete this._views[viewCid];

        // update the length
        this._updateLength();
      },

      // Call a method on every view in the container,
      // passing parameters to the call method one at a
      // time, like `function.call`.
      call: function(method){
        this.apply(method, _.tail(arguments));
      },

      // Apply a method on every view in the container,
      // passing parameters to the call method one at a
      // time, like `function.apply`.
      apply: function(method, args){
        _.each(this._views, function(view){
          if (_.isFunction(view[method])){
            view[method].apply(view, args || []);
          }
        });
      },

      // Update the `.length` attribute on this container
      _updateLength: function(){
        this.length = _.size(this._views);
      }
    });

    // Borrowing this code from Backbone.Collection:
    // http://backbonejs.org/docs/backbone.html#section-106
    //
    // Mix in methods from Underscore, for iteration, and other
    // collection related features.
    var methods = ['forEach', 'each', 'map', 'find', 'detect', 'filter', 
      'select', 'reject', 'every', 'all', 'some', 'any', 'include', 
      'contains', 'invoke', 'toArray', 'first', 'initial', 'rest', 
      'last', 'without', 'isEmpty', 'pluck'];

    _.each(methods, function(method) {
      Container.prototype[method] = function() {
        var views = _.values(this._views);
        var args = [views].concat(_.toArray(arguments));
        return _[method].apply(_, args);
      };
    });

    // return the public API
    return Container;
  })(Backbone, _);
})();
