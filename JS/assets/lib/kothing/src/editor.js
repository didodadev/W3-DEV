/*
 * kothing-editor.js
 * Copyright Kothing
 * MIT license.
 */
import core from "./lib/core";
import _Constructor from "./lib/constructor";
import _Context from "./lib/context";

export default {
  /**
   * @description Returns the create function with preset options.
   * If the options overlap, the options of the 'create' function take precedence.
   * @param {Json} options Initialization options
   * @returns {function}
   */
  init: function(init_options) {
    return {
      create: function(idOrElement, options) {
        return this.create(idOrElement, options, init_options);
      }.bind(this),
    };
  },

  /**
   * @description Create the kothing-editor
   * @param {String|Element} idOrElement textarea Id or textarea element
   * @param {Json} options user options
   * @returns {{save: save, getContext: getContext, getContent: getContent, setContent: setContent, appendContent: appendContent, disabled: disabled, enabled: enabled, show: show, hide: hide, destroy: destroy}}
   */
  create: function(idOrElement, options, _init_options) {
    if (typeof options !== "object") options = {};
    if (_init_options) {
      options = [_init_options, options].reduce(function(init, option) {
        Object.keys(option).forEach(function(key) {
          init[key] = option[key];
        });
        return init;
      }, {});
    }

    const element =
      typeof idOrElement === "string"
        ? document.getElementById(idOrElement)
        : idOrElement;

    if (!element) {
      if (typeof idOrElement === "string") {
        throw Error(
          '[KothingEditor.create.fail] The element for that id was not found (ID:"' +
            idOrElement +
            '")'
        );
      }

      throw Error(
        "[KothingEditor.create.fail] kothing-editor requires textarea's element or id value"
      );
    }

    const cons = _Constructor.init(element, options);

    if (
      cons.constructed._top.id &&
      document.getElementById(cons.constructed._top.id)
    ) {
      throw Error(
        '[KothingEditor.create.fail] The ID of the kothing-editor you are trying to create already exists (ID:"' +
          cons.constructed._top.id +
          '")'
      );
    }

    element.style.display = "none";
    cons.constructed._top.style.display = "block";

    /** Create to sibling node */
    if (typeof element.nextElementSibling === "object") {
      element.parentNode.insertBefore(
        cons.constructed._top,
        element.nextElementSibling
      );
    } else {
      element.parentNode.appendChild(cons.constructed._top);
    }

    return core(
      _Context(element, cons.constructed, cons.options),
      cons.pluginCallButtons,
      cons.plugins,
      cons.options.lang,
      options
    );
  },
};
