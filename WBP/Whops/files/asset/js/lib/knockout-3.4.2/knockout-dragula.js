(function (global, factory) {
    if (typeof define === 'function' && define.amd) {
      define(['exports', 'module', 'knockout', 'dragula'], factory);
    } else if (typeof exports !== 'undefined' && typeof module !== 'undefined') {
      factory(exports, module, require('knockout'), require('dragula'));
    } else {
      var mod = {
        exports: {}
      };
      factory(mod.exports, mod, global.ko, global.dragula);
      global.knockoutDragula = mod.exports;
    }
  })(this, function (exports, module, _knockout, _dragula) {
    'use strict';
  
    function _interopRequireDefault(obj) { return obj && obj.__esModule ? obj : { 'default': obj }; }
  
    var _ko = _interopRequireDefault(_knockout);
  
    var _dragula2 = _interopRequireDefault(_dragula);
  
    var FOREACH_OPTIONS_PROPERTIES = ['afterAdd', 'afterMove', 'afterRender', 'as', 'beforeRemove', 'moves'];
    var LIST_KEY = 'ko_dragula_list';
    var AFTER_DROP_KEY = 'ko_dragula_afterDrop';
    var AFTER_DELETE_KEY = 'ko_dragula_afterDelete';
    var MOVES_KEY = 'ko_dragula_moves';
  
    // Knockout shortcuts
    var unwrap = _ko['default'].unwrap;
    var setData = _ko['default'].utils.domData.set;
    var getData = _ko['default'].utils.domData.get;
    var foreachBinding = _ko['default'].bindingHandlers.foreach;
    var addDisposeCallback = _ko['default'].utils.domNodeDisposal.addDisposeCallback;
  
    var groups = [];
  
    function findGroup(name) {
      // For old browsers (without the need for a polyfill), otherwise it could be: return groups.find(group => group.name === name);
      for (var i = 0; i < groups.length; i++) {
        if (groups[i].name === name) {
          return groups[i];
        }
      }
    }
  
    function addGroup(name, drake) {
      var group = {
        name: name, drake: drake
      };
      groups.push(group);
      return group;
    }
  
    function addGroupWithOptions(name, options) {
      var drake = (0, _dragula2['default'])(options);
      registerEvents(drake);
      return addGroup(name, drake);
    }
  
    function registerEvents(drake) {
      drake.on('drop', onDrop);
      drake.on('remove', onRemove);
      drake.on('cancel', onCancel);
    }
  
    function removeContainer(group, container) {
      var index = group.drake.containers.indexOf(container);
      group.drake.containers.splice(index, 1);
  
      if (!group.drake.containers.length) {
        destroyGroup(group);
      }
    }
  
    function destroyGroup(group) {
      var index = groups.indexOf(group);
      groups.splice(index, 1);
      group.drake.destroy();
    }
  
    function createDrake(element, options) {
      var drake = (0, _dragula2['default'])([element], options);
      registerEvents(drake);
      return drake;
    }
  
    function onDrop(el, target, source) {
      var item = _ko['default'].dataFor(el);
      var context = _ko['default'].contextFor(el);
      var sourceItems = getData(source, LIST_KEY);
      var sourceIndex = sourceItems.indexOf(item);
      var targetItems = getData(target, LIST_KEY);
      var targetIndex = Array.prototype.indexOf.call(target.children, el); // For old browsers (without the need for a polyfill), otherwise it could be: Array.from(target.children).indexOf(el);

      target.removeChild(el);
      
      // Remove the element moved by dragula, let Knockout manage the DOM
      if (source.getAttribute("data-copy") !== "source") {
        sourceItems.splice(sourceIndex, 1);
      } else {
        if (source.childNodes.length >= sourceIndex) {
          source.insertBefore(el, source.childNodes[sourceIndex*3]);
        } else {
          source.appendChild(el);
        }
      }
      
      if (target.getAttribute("data-accept") !== "false" && source.getAttribute("data-dropgroup").indexOf(target.getAttribute("data-dropgroup")) >= 0) {
        targetItems.splice(targetIndex, 0, item);
      }
  
      var afterDrop = getData(target, AFTER_DROP_KEY);
      if (afterDrop) {
        afterDrop.call(context, item, sourceIndex, sourceItems, targetIndex, targetItems);
      }
    }
  
    function onRemove(el, container) {
      var item = _ko['default'].dataFor(el);
      var sourceItems = getData(container, LIST_KEY);
      var sourceIndex = sourceItems.indexOf(item);
      var context = _ko['default'].contextFor(el);
  
      sourceItems.splice(sourceIndex, 1);
  
      var afterDelete = getData(container, AFTER_DELETE_KEY);
      if (afterDelete) {
        afterDelete.call(context, item, sourceIndex, sourceItems);
      }
    }
  
    function onCancel(el, container) {
      var item = _ko['default'].dataFor(el);
      var sourceItems = getData(container, LIST_KEY);
      var sourceIndex = sourceItems.indexOf(item);
  
      // Remove the element added by dragula, let Knockout manage the DOM
      container.removeChild(el);
  
      // Remove and re-add the item to froce knockout to re-render it
      sourceItems.splice(sourceIndex, 1);
      sourceItems.splice(sourceIndex, 0, item);
    }
  
    _ko['default'].bindingHandlers.dragula = {
      init: function init(element, valueAccessor, allBindings, viewModel, bindingContext) {
        var options = unwrap(valueAccessor()) || {};
        var foreachOptions = makeForeachOptions(valueAccessor, options);
  
        setData(element, LIST_KEY, foreachOptions.data);
        setData(element, AFTER_DROP_KEY, options.afterDrop);
        setData(element, AFTER_DELETE_KEY, options.afterDelete);
        setData(element, MOVES_KEY, options.moves);
  
        foreachBinding.init(element, function () {
          return foreachOptions;
        }, allBindings, viewModel, bindingContext);
  
        if (options.group) {
          createOrUpdateDrakeGroup(element, options);
        } else {
          (function () {
            var drake = createDrake(element, options);
            addDisposeCallback(element, function () {
              return drake.destroy();
            });
          })();
        }
  
        return {
          controlsDescendantBindings: true
        };
      },
      update: function update(element, valueAccessor, allBindings, viewModel, bindingContext) {
        var options = unwrap(valueAccessor()) || {};
        var foreachOptions = makeForeachOptions(valueAccessor, options);
  
        setData(element, LIST_KEY, foreachOptions.data);
        setData(element, AFTER_DROP_KEY, options.afterDrop);
        setData(element, AFTER_DELETE_KEY, options.afterDelete);
        setData(element, MOVES_KEY, options.moves);
  
        foreachBinding.update(element, function () {
          return foreachOptions;
        }, allBindings, viewModel, bindingContext);
      }
    };
  
    function makeForeachOptions(valueAccessor, options) {
      var templateOptions = {
        data: options.data || valueAccessor()
      };
  
      FOREACH_OPTIONS_PROPERTIES.forEach(function (option) {
        if (options.hasOwnProperty(option)) {
          templateOptions[option] = options[option];
        }
      });
  
      return templateOptions;
    }
  
    function createOrUpdateDrakeGroup(container, options) {
      var group = findGroup(options.group);
      if (group) {
        group.drake.containers.push(container);
      } else {
        group = addGroup(options.group, createDrake(container, options));
      }
  
      addDisposeCallback(container, function () {
        return removeContainer(group, container);
      });
    }
  
    module.exports = {
      add: addGroup,
      options: addGroupWithOptions,
      find: findGroup,
      destroy: destroyGroup
    };
  });