﻿(function ($, undefined) {
    var multiselectID = 0;
    var linkDefaults = {
        open: { class: "ui-multiselect-open", icon: '', title: "Open" },
        close: { class: "ui-multiselect-close", icon: '<span class="catalyst-close"></span>', title: "Kapat" },
        checkAll: { class: "ui-multiselect-all", icon: '<span class="catalyst-check"></span>', text: "", title: "Tümünü Seç" },
        uncheckAll: { class: "ui-multiselect-none", icon: '<span class="catalyst-trash"></span>', text: "", title: "Tümünü Kaldır" },
        flipAll: { class: "ui-multiselect-flip", icon: '<span class="ui-icon ui-icon-arrowrefresh-1-w"></span>', text: "Flip all", title: "Flip all" },
        collapse: { icon: '<span class="ui-icon ui-icon-minusthick"></span>', title: "Collapse" },
        expand: { icon: '<span class="ui-icon ui-icon-plusthick"></span>', title: "Expand" },
        collapseAll: { class: "ui-multiselect-collapseall", icon: '<span class="ui-icon ui-icon-minus"></span>', text: "Collapse all", title: "Collapse all" },
        expandAll: { class: "ui-multiselect-expandall", icon: '<span class="ui-icon ui-icon-plus"></span>', text: "Expand all", title: "Expand all" },
    };
    function insertImage(option, span) {
        var optionImageSrc = option.getAttribute("data-image-src");
        if (optionImageSrc) {
            var img = document.createElement("img");
            img.setAttribute("src", optionImageSrc);
            span.insertBefore(img, span.firstChild);
        }
    }
    function determineFontSize() {
        if (window.getComputedStyle) {
            return getComputedStyle(document.body).fontSize;
        }
        return "16px";
    }
    function getjQueryFromElement(elem) {
        if (!!elem.jquery) {
            return elem;
        }
        if (!!elem.nodeType) {
            return $(elem);
        }
        return $(elem).eq(0);
    }
    function parse2px(dimText, $elem, isHeight) {
        if (typeof dimText !== "string") {
            return { px: dimText, minimax: 0 };
        }
        var parts = dimText.match(/([<>])?=?\s*([.\d]+)\s*([eimnptx%]*)s?/i);
        var minimax = parts[1];
        var value = parseFloat(parts[2]);
        var unit = parts[3].toLowerCase();
        var pixels = -1;
        switch (unit) {
            case "pt":
            case "in":
            case "cm":
            case "mm":
                pixels = { pt: 4 / 3, in: 96, cm: 96 / 2.54, mm: 96 / 25.4 }[unit] * value;
                break;
            case "em":
                pixels = parseFloat(determineFontSize()) * value;
                break;
            case "%":
                if (!!$elem) {
                    if (typeof $elem === "string" || !$elem.jquery) {
                        $elem = $($elem);
                    }
                    pixels = (!!isHeight ? $elem.parent().height() : $elem.parent().width()) * (value / 100);
                }
                break;
            default:
                pixels = value;
        }
        return { px: pixels, minimax: minimax == ">" ? -1 : minimax == "<" ? 1 : 0 };
    }
    $.widget("ech.multiselect", {
        options: {
            buttonWidth: 225,
            menuWidth: null,
            menuHeight: 200,
            resizableMenu: false,
            appendTo: null,
            position: {},
            zIndex: null,
            classes: "",
            header: ["checkAll", "uncheckAll"],
            linkInfo: null,
            noneSelectedText: "Select options",
            selectedText: "# of # selected",
            selectedList: 0,
            selectedListSeparator: ", ",
            maxSelected: null,
            openEffect: null,
            closeEffect: null,
            autoOpen: false,
            htmlText: [],
            wrapText: ["button", "header", "options"],
            listbox: false,
            addInputNames: true,
            disableInputsOnToggle: true,
            groupsSelectable: true,
            groupsCollapsable: false,
            groupColumns: false,
        },
        _getAppendEl: function () {
            var elem = this.options.appendTo;
            if (elem) {
                elem = getjQueryFromElement(elem);
            }
            if (!elem || !elem[0]) {
                elem = this.element.closest(".ui-front, dialog");
            }
            if (!elem.length) {
                elem = $(document.body);
            }
            return elem;
        },
        _buildButton: function () {
            var wrapText = this.options.wrapText || [];
            var $button = (this.$button = $(document.createElement("button")))
                .addClass("ui-multiselect ui-widget ui-state-default ui-corner-all" + (wrapText.indexOf("button") > -1 ? "" : " ui-multiselect-nowrap") + (this.options.classes ? " " + this.options.classes : ""))
                .attr({ type: "button", title: this.element[0].title, tabIndex: this.element[0].tabIndex, id: this.element[0].id ? this.element[0].id + "_ms" : null })
                .prop("aria-haspopup", true)
                .html(this._linkHTML('<span class="{{class}}" title="{{title}}">{{icon}}</span>', "open"));
            this.$buttonlabel = $(document.createElement("span"))
                .html(this.options.noneSelectedText || $element[0].placeholder)
                .appendTo($button);
            return $button;
        },
        _buildHeaderHtml: function () {
            if (!this.options.header) {
                return "";
            }
            if (typeof this.options.header === "string") {
                return "<li>" + this.options.header + "</li>";
            }
            var headerLinksHTML = "";
            if (this.options.header.constructor == Array) {
                for (var x = 0; x < this.options.header.length; x++) {
                    var linkInfoKey = this.options.header[x];
                    if (linkInfoKey && linkInfoKey in this.linkInfo && !(this.options.maxSelected && linkInfoKey === "checkAll") && ["open", "close", "collapse", "expand"].indexOf(linkInfoKey) === -1) {
                        headerLinksHTML += this._linkHTML('<li><a class="{{class}}" title="{{title}}">{{icon}}<span>{{text}}</span></a></li>', linkInfoKey);
                    }
                }
            }
            return headerLinksHTML;
        },
        _create: function () {
            var $element = this.element;
            var options = this.options;
            this.linkInfo = $.extend(true, {}, linkDefaults, options.linkInfo || {});
            this._selectWidth = $element.outerWidth();
            $element.hide();
            options.htmlText = options.htmlText || [];
            var wrapText = (options.wrapText = options.wrapText || []);
            this.speed = $.fx.speeds._default;
            this._isOpen = false;
            this._namespaceID = this.eventNamespace;
            this.multiselectID = multiselectID++;
            this.$headerLinkContainer = $(document.createElement("ul"))
                .addClass("ui-helper-reset")
                .html(this._buildHeaderHtml() + (!options.listbox ? this._linkHTML('<li class="{{class}}"><a class="{{class}}" title="{{title}}">{{icon}}</a></li>', "close") : ""));
            
            var $header = (this.$header = $(document.createElement("div"))).addClass("ui-multiselect-header ui-widget-header ui-corner-all ui-helper-clearfix").append(this.$headerLinkContainer).prepend('<div class="title">Seçenekler</div>');
            var $checkboxes = (this.$checkboxes = $(document.createElement("ul"))).addClass("ui-multiselect-checkboxes ui-helper-reset" + (wrapText.indexOf("options") > -1 ? "" : " ui-multiselect-nowrap"));
            var $container_checkbox = $(document.createElement("div")).addClass("ui-multiselect-scroll").append($checkboxes);
            var $menu = (this.$menu = $(document.createElement("div")))
                .addClass(
                    "ui-multiselect-menu ui-widget ui-widget-content ui-corner-all" +
                        ($element[0].multiple ? "" : " ui-multiselect-single") +
                        (!options.listbox ? "" : " ui-multiselect-listbox") +
                        (this.options.classes ? " " + this.options.classes : "")
                )
                .append($header, $container_checkbox);
            if (!options.listbox) {
                var $button = this._buildButton();
                $button.insertAfter($element);
                var $appendEl = this._getAppendEl();
                $appendEl.append($menu);
                if (!options.zIndex && !$appendEl.hasClass("ui-front")) {
                    var $uiFront = this.element.closest(".ui-front, dialog");
                    options.zIndex = Math.max(($uiFront && parseInt($uiFront.css("z-index"), 10) + 1) || 0, ($appendEl && parseInt($appendEl.css("z-index"), 10) + 1) || 0);
                }
                if (options.zIndex) {
                    $menu.css("z-index", options.zIndex);
                }
                options.position = $.extend({ my: "left top", at: "left bottom", of: $button }, options.position || {});
            } else {
                $menu.insertAfter($element);
            }
            this._bindEvents();
            this.refresh(true);
        },
        _linkHTML: function (linkTemplate, linkID) {
            var self = this;
            return linkTemplate
                .replace(/{{(.*?)}}/gi, function (m, p1) {
                    return self.linkInfo[linkID][p1];
                })
                .replace("<span></span>", "");
        },
        _init: function () {
            var elSelect = this.element[0];
            if (this.options.header !== false) {
                this.$headerLinkContainer.find(".ui-multiselect-all, .ui-multiselect-none, .ui-multiselect-flip").toggle(!!elSelect.multiple);
            } else {
                this.$header.hide();
            }
            if (this.options.autoOpen && !this.options.listbox) {
                this.open();
            }
            if (elSelect.disabled) {
                this.disable();
            }
        },
        _makeOption: function (option) {
            var elSelect = this.element.get(0);
            var id = elSelect.id || this.multiselectID;
            var inputID = "ui-multiselect-" + this.multiselectID + "-" + (option.id || id + "-option-" + this.inputIdCounter++);
            var isMultiple = elSelect.multiple;
            var isDisabled = option.disabled;
            var isSelected = option.selected;
            var input = document.createElement("input");
            var inputAttribs = {
                type: isMultiple ? "checkbox" : "radio",
                id: inputID,
                title: option.title || null,
                value: option.value,
                name: this.options.addInputNames ? "multiselect_" + id : null,
                checked: isSelected ? "checked" : null,
                "aria-selected": isSelected ? "true" : null,
                disabled: isDisabled ? "disabled" : null,
                "aria-disabled": isDisabled ? "true" : null,
            };
            for (var name in inputAttribs) {
                if (inputAttribs[name] !== null) {
                    input.setAttribute(name, inputAttribs[name]);
                }
            }
            var optionAttribs = option.attributes;
            var len = optionAttribs.length;
            for (var x = 0; x < len; x++) {
                var attribute = optionAttribs[x];
                if (/^data\-.+/.test(attribute.name)) {
                    input.setAttribute(attribute.name, attribute.value);
                }
            }
            var span = document.createElement("span");
            if (this.htmlAllowedFor("options")) {
                span.innerHTML = option.innerHTML;
            } else {
                span.textContent = option.textContent;
            }
            insertImage(option, span);
            var label = document.createElement("label");
            label.setAttribute("for", inputID);
            if (option.title) {
                label.setAttribute("title", option.title);
            }
            label.className += (isDisabled ? " ui-state-disabled" : "") + (isSelected && !isMultiple ? " ui-state-active" : "") + " ui-corner-all";
            label.appendChild(input);
            label.appendChild(span);
            var item = document.createElement("li");
            item.className = (isDisabled ? "ui-multiselect-disabled " : "") + (option.className || "");
            item.appendChild(label);
            return item;
        },
        _buildOptionList: function () {
            var self = this;
            var list = [];
            this.inputIdCounter = 0;
            this.element.children().each(function () {
                var elem = this;
                if (elem.tagName.toUpperCase() === "OPTGROUP") {
                    var options = [];
                    $(elem)
                        .children()
                        .each(function () {
                            options.push(self._makeOption(this));
                        });
                    var $collapseButton = !!self.options.groupsCollapsable
                        ? $(document.createElement("button")).attr({ title: self.linkInfo.collapse.title }).addClass("ui-state-default ui-corner-all ui-multiselect-collapser").html(self.linkInfo.collapse.icon)
                        : null;
                    var $optGroupLabel = $(document.createElement("a"))
                        .addClass("ui-multiselect-grouplabel" + (self.options.groupsSelectable ? " ui-multiselect-selectable" : ""))
                        .html(elem.getAttribute("label"));
                    var $optionGroup = $(document.createElement("ul")).append(options);
                    var $optGroupItem = $(document.createElement("li"))
                        .addClass("ui-multiselect-optgroup" + (self.options.groupColumns ? " ui-multiselect-columns" : "") + (elem.className ? " " + elem.className : ""))
                        .append($collapseButton, $optGroupLabel, $optionGroup);
                    list.push($optGroupItem);
                } else {
                    list.push(self._makeOption(elem));
                }
            });
            this.$checkboxes.empty().append(list);
        },
        refresh: function (init) {
            var $element = this.element;
            if (this.options.header !== false) {
                this.$headerLinkContainer.find(".ui-multiselect-all, .ui-multiselect-none, .ui-multiselect-flip").toggle(!!$element[0].multiple);
            }
            this._buildOptionList();
            this._updateCache();
            if (!this.options.listbox) {
                this._setButtonWidth();
                this.update(true);
            } else {
                if (!this._isOpen) {
                    this.$menu.show();
                    this._isOpen = true;
                }
                this._setMenuWidth();
                this._setMenuHeight();
            }
            if (!init) {
                this._trigger("refresh");
            }
        },
        _updateCache: function () {
            this._savedButtonWidth = 0;
            this._savedMenuWidth = 0;
            this._savedMenuHeight = 0;
            this.$header = this.$menu.children(".ui-multiselect-header");
            this.$checkboxes = this.$menu.children(".ui-multiselect-checkboxes");
            this.$labels = this.$menu.find("label:not(.ui-multiselect-filter-label)");
            this.$inputs = this.$labels.children("input");
            if (this.element.is(':data("ech-multiselectfilter")')) {
                this.element.data("ech-multiselectfilter").updateCache(true);
            }
        },
        resync: function (skipDisabled) {
            var $inputs = this.$inputs;
            var $options = this.element.find("option");
            if ($inputs.length === $options.length) {
                var inputValues = {};
                $inputs.not(!!skipDisabled ? ":disabled" : "").each(function () {
                    inputValues[this.value] = this;
                });
                $options.not(!!skipDisabled ? ":disabled" : "").each(function () {
                    if (this.value in inputValues) {
                        inputValues[this.value].checked = this.selected;
                    }
                });
                this._trigger("resync");
                this.update();
            } else {
                this.refresh();
            }
        },
        update: function (isDefault) {
            if (!!this.options.listbox) {
                return;
            }
            var options = this.options;
            var selectedList = options.selectedList;
            var selectedText = options.selectedText;
            var $inputs = this.$inputs;
            var inputCount = $inputs.length;
            var $checked = $inputs.filter(":checked");
            var numChecked = $checked.length;
            var value;
            if (numChecked) {
                if (typeof selectedText === "function") {
                    value = selectedText.call(this, numChecked, inputCount, $checked.get());
                } else if (/\d/.test(selectedList) && selectedList > 0 && numChecked <= selectedList) {
                    value = $checked
                        .map(function () {
                            return $(this).next().text().replace(/\n$/, "");
                        })
                        .get()
                        .join(options.selectedListSeparator);
                } else {
                    value = selectedText.replace("#", numChecked).replace("#", inputCount);
                }
            } else {
                value = options.noneSelectedText;
            }
            this._setButtonValue(value, isDefault);
            if (options.wrapText.indexOf("button") === -1) {
                this._setButtonWidth(true);
            }
            if (this._isOpen && this._savedButtonHeight != this.$button.outerHeight(false)) {
                this.position();
            }
        },
        _setButtonValue: function (value, isDefault) {
            this.$buttonlabel[this.htmlAllowedFor("button") ? "html" : "text"](value);
            if (!!isDefault) {
                this.$button[0].defaultValue = value;
            }
        },
        _bindButtonEvents: function () {
            var self = this;
            var $button = this.$button;
            function buttonClickHandler() {
                self[self._isOpen ? "close" : "open"]();
                return false;
            }
            $button
                .on({
                    click: buttonClickHandler,
                    keydown: $.proxy(self._handleButtonKeyboardNav, self),
                    mouseenter: function () {
                        if (!this.classList.contains("ui-state-disabled")) {
                            this.classList.add("ui-state-hover");
                        }
                    },
                    mouseleave: function () {
                        this.classList.remove("ui-state-hover");
                    },
                    focus: function () {
                        if (!this.classList.contains("ui-state-disabled")) {
                            this.classList.add("ui-state-focus");
                        }
                    },
                    blur: function () {
                        this.classList.remove("ui-state-focus");
                    },
                })
                .find("span")
                .on("click.multiselect,click", buttonClickHandler);
        },
        _handleButtonKeyboardNav: function (e) {
            if (!this._isOpen && !this.element[0].multiple && (e.which === 38 || e.which === 40)) {
                var $inputs = this.$inputs;
                var index = $inputs.index($inputs.filter(":checked"));
                if (e.which === 38 && index) {
                    $inputs.eq(index - 1).trigger("click");
                } else if (e.which === 40 && index < $inputs.length - 1) {
                    $inputs.eq(index + 1).trigger("click");
                }
                return;
            }
            switch (e.which) {
                case 27:
                case 37:
                case 38:
                    this.close();
                    break;
                case 40:
                case 39:
                    this.open();
                    break;
            }
        },
        _bindCheckboxEvents: function () {
            var self = this;
            self.$checkboxes
                .on("click.multiselect", ".ui-multiselect-grouplabel", function (e) {
                    e.preventDefault();
                    if (!self.options.groupsSelectable) {
                        return false;
                    }
                    var $this = $(this);
                    var $inputs = $this.next("ul").children(":not(.ui-multiselect-excluded)").find("input").not(":disabled");
                    var nodes = $inputs.get();
                    var label = this.textContent;
                    if (self._trigger("beforeoptgrouptoggle", e, { inputs: nodes, label: label }) === false) {
                        return;
                    }
                    var maxSelected = self.options.maxSelected;
                    if (maxSelected && self.$inputs.filter(":checked").length + $inputs.length > maxSelected) {
                        return;
                    }
                    self._toggleChecked($inputs.filter(":checked").length !== $inputs.length, $inputs);
                    self._trigger("optgrouptoggle", e, { inputs: nodes, label: label, checked: nodes.length ? nodes[0].checked : null });
                })
                .on("click.multiselect", ".ui-multiselect-collapser", function (e) {
                    var $this = $(this);
                    var $parent = $this.parent();
                    var optgroupLabel = $parent.find(".ui-multiselect-grouplabel").first().html();
                    var linkInfo = self.linkInfo;
                    var collapsedClass = "ui-multiselect-collapsed";
                    var isCollapsed = $parent.hasClass(collapsedClass);
                    if (self._trigger("beforecollapsetoggle", e, { label: optgroupLabel, collapsed: isCollapsed }) === false) {
                        return;
                    }
                    $parent.toggleClass(collapsedClass);
                    $this.attr("title", isCollapsed ? linkInfo.collapse.title : linkInfo.expand.title).html(isCollapsed ? linkInfo.collapse.icon : linkInfo.expand.icon);
                    if (!self.options.listbox) {
                        self._setMenuHeight(true);
                    }
                    self._trigger("collapsetoggle", e, { label: optgroupLabel, collapsed: !isCollapsed });
                })
                .on("mouseenter.multiselect", ".ui-multiselect-collapser", function (e) {
                    this.classList.add("ui-state-hover");
                })
                .on("mouseleave.multiselect", ".ui-multiselect-collapser", function (e) {
                    this.classList.remove("ui-state-hover");
                })
                .on("mouseenter.multiselect", "label", function (e, param) {
                    if (!this.classList.contains("ui-state-disabled")) {
                        var checkboxes = self.$checkboxes[0];
                       /*  var scrollLeft = checkboxes.scrollLeft;
                        var scrollTop = checkboxes.scrollTop; */
                        var scrollX = window.pageXOffset;
                        var scrollY = window.pageYOffset;
                        self.$labels.removeClass("ui-state-hover");
                        $(this).addClass("ui-state-hover").find("input").focus();
                        if (!param || !param.allowScroll) {
                            /* checkboxes.scrollLeft = scrollLeft;
                            checkboxes.scrollTop = scrollTop; */
                            window.scrollTo(scrollX, scrollY);
                        }
                    }
                })
                .on("keydown.multiselect", "label", function (e) {
                    if (e.which === 82) {
                        return;
                    }
                    if (e.which > 111 && e.which < 124) {
                        return;
                    }
                    e.preventDefault();
                    switch (e.which) {
                        case 9:
                            if (e.shiftKey) {
                                self.$menu.find(".ui-state-hover").removeClass("ui-state-hover");
                                self.$header.find("li").last().find("a").focus();
                            } else {
                                self.close();
                            }
                            break;
                        case 27:
                            self.close();
                            break;
                        case 38:
                        case 40:
                        case 37:
                        case 39:
                            self._traverse(e.which, this);
                            break;
                        case 13:
                        case 32:
                            $(this).find("input")[0].click();
                            break;
                        case 65:
                            if (e.altKey) {
                                self.checkAll();
                            }
                            break;
                        case 70:
                            if (e.altKey) {
                                self.flipAll();
                            }
                            break;
                        case 85:
                            if (e.altKey) {
                                self.uncheckAll();
                            }
                            break;
                    }
                })
                .on("click.multiselect", "input", function (e) {
                    var input = this;
                    var $input = $(input);
                    var val = input.value;
                    var checked = input.checked;
                    var $element = self.element;
                    var $tags = $element.find("option");
                    var isMultiple = $element[0].multiple;
                    var $allInputs = self.$inputs;
                    var numChecked = $allInputs.filter(":checked").length;
                    var options = self.options;
                    var textFxn = self.htmlAllowedFor("options") ? "html" : "text";
                    var optionText = $input.parent().find("span")[textFxn]();
                    var maxSelected = options.maxSelected;
                    if (input.disabled || self._trigger("click", e, { value: val, text: optionText, checked: checked }) === false) {
                        e.preventDefault();
                        return;
                    }
                    if (maxSelected && checked && numChecked > maxSelected) {
                        if (self._trigger("maxselected", e, { labels: self.$labels, inputs: $allInputs }) !== false) {
                            self.buttonMessage("<center><b>LIMIT OF " + (numChecked - 1) + " REACHED!</b></center>");
                        }
                        input.checked = false;
                        e.preventDefault();
                        return false;
                    }
                    input.focus();
                    $input.prop("aria-selected", checked);
                    $tags.each(function () {
                        this.selected = this.value === val ? checked : isMultiple && this.selected;
                    });
                    if (!isMultiple) {
                        self.$labels.removeClass("ui-state-active");
                        $input.closest("label").toggleClass("ui-state-active", checked);
                        self.close();
                    }
                    $element.trigger("change");
                    setTimeout($.proxy(self.update, self), 10);
                });
        },
        _bindHeaderEvents: function () {
            var self = this;
            self.$header
                .on("click.multiselect", "a", function (e) {
                    var headerLinks = {
                        "ui-multiselect-close": "close",
                        "ui-multiselect-all": "checkAll",
                        "ui-multiselect-none": "uncheckAll",
                        "ui-multiselect-flip": "flipAll",
                        "ui-multiselect-collapseall": "collapseAll",
                        "ui-multiselect-expandall": "expandAll",
                    };
                    for (hdgClass in headerLinks) {
                        if (this.classList.contains(hdgClass)) {
                            self[headerLinks[hdgClass]]();
                            e.preventDefault();
                            return false;
                        }
                    }
                })
                .on("keydown.multiselect", "a", function (e) {
                    switch (e.which) {
                        case 27:
                            self.close();
                            break;
                        case 9:
                            var $target = $(e.target);
                            if ((e.shiftKey && !$target.parent().prev().length && !self.$header.find(".ui-multiselect-filter").length) || (!$target.parent().next().length && !self.$labels.length && !e.shiftKey)) {
                                self.close();
                                e.preventDefault();
                            }
                            break;
                    }
                });
        },
        _setResizable: function () {
            if (!this.options.resizableMenu || !("resizable" in $.ui)) {
                return;
            }
            this.$menu.show();
            this.$menu.resizable({
                containment: "parent",
                handles: "s",
                helper: "ui-multiselect-resize",
                stop: function (e, ui) {
                    ui.size.width = ui.originalSize.width;
                    $(this).outerWidth(ui.originalSize.width);
                    if (this._trigger("resize", e, ui) !== false) {
                        this.options.menuHeight = ui.size.height;
                    }
                    this._setMenuHeight(true);
                },
            });
            this.$menu.hide();
        },
        _bindEvents: function () {
            if (!this.options.listbox) {
                this._bindButtonEvents();
            }
            this._bindHeaderEvents();
            this._bindCheckboxEvents();
            this._setResizable();
            this.document.on(
                "mousedown" + this._namespaceID + " wheel" + this._namespaceID + " mousewheel" + this._namespaceID,
                function (event) {
                    var target = event.target;
                    if (this._isOpen && (!!this.$button ? target !== this.$button[0] && !$.contains(this.$button[0], target) : true) && target !== this.$menu[0] && !$.contains(this.$menu[0], target)) {
                        this.close();
                    }
                }.bind(this)
            );
            $(this.element[0].form).on(
                "reset" + this._namespaceID,
                function () {
                    setTimeout(this.refresh.bind(this), 10);
                }.bind(this)
            );
        },
        _setButtonWidth: function (recalc) {
            if (this._savedButtonWidth && !recalc) {
                return;
            }
            var width = this._selectWidth || this._getBCRWidth(this.element);
            var buttonWidth = this.options.buttonWidth || "";
            if (/\d/.test(buttonWidth)) {
                var parsed = parse2px(buttonWidth, this.element);
                var pixels = parsed.px;
                var minimax = parsed.minimax;
                width = minimax < 0 ? Math.max(width, pixels) : minimax > 0 ? Math.min(width, pixels) : pixels;
            } else {
                buttonWidth = buttonWidth.toLowerCase();
            }
            if (buttonWidth !== "auto") {
                this.$button.outerWidth(width);
            }
            this._savedButtonWidth = width;
        },
        _setMenuWidth: function (recalc) {
            if (this._savedMenuWidth && !recalc) {
                return;
            }
            var width = !!this.options.listbox ? this._selectWidth : this._savedButtonWidth || this._getBCRWidth(this.$button);
            var menuWidth = this.options.menuWidth || "";
            if (/\d/.test(menuWidth)) {
                var parsed = parse2px(menuWidth, this.element);
                var pixels = parsed.px;
                var minimax = parsed.minimax;
                width = minimax < 0 ? Math.max(width, pixels) : minimax > 0 ? Math.min(width, pixels) : pixels;
            } else {
                menuWidth = menuWidth.toLowerCase();
            }
            if (menuWidth !== "auto") {
                this.$menu.outerWidth(width);
                this._savedMenuWidth = width;
                return;
            }
            this.$menu.addClass("ui-multiselect-measure");
            var headerWidth = this.$header.outerWidth(true) + this._jqWidthFix(this.$header);
            var cbWidth = this.$checkboxes.outerWidth(true) + this._jqWidthFix(this.$checkboxes);
            this.$menu.removeClass("ui-multiselect-measure");
            var contentWidth = Math.max(this.options.wrapText.indexOf("header") > -1 ? 0 : headerWidth, cbWidth);
            this.$menu.width(contentWidth);
            this._savedMenuWidth = this.$menu.outerWidth(false);
        },
        _setMenuHeight: function (recalc) {
            var self = this;
            if (self._savedMenuHeight && !recalc) {
                return;
            }
            var maxHeight = $(window).height();
            var optionHeight = self.options.menuHeight || "";
            var useSelectSize = false;
            var elSelectSize = 4;
            if (/\d/.test(optionHeight)) {
                var $header = self.$header.filter(":visible");
                var headerHeight = $header.outerHeight(true);
                var menuBorderPaddingHt = this.$menu.outerHeight(false) - this.$menu.height();
                var cbBorderPaddingHt = this.$checkboxes.outerHeight(false) - this.$checkboxes.height();
                optionHeight = parse2px(optionHeight, self.element, true).px;
                maxHeight = Math.min(optionHeight, maxHeight) - headerHeight - menuBorderPaddingHt - cbBorderPaddingHt;
            } else if (optionHeight.toLowerCase() === "size") {
                useSelectSize = true;
                elSelectSize = self.element[0].size || elSelectSize;
            }
            var overflowSetting = "hidden";
            var itemCount = 0;
            var hoverAdjust = 4;
            var ulHeight = hoverAdjust;
            var ulTop = -1;
            self.$checkboxes
                .find("li:not(.ui-multiselect-optgroup),a")
                .filter(":visible")
                .each(function () {
                    if (ulTop < 0) {
                        ulTop = this.offsetTop;
                    }
                    ulHeight = this.offsetTop + this.offsetHeight - ulTop + hoverAdjust;
                    if ((useSelectSize && ++itemCount >= elSelectSize) || ulHeight > maxHeight) {
                        overflowSetting = "auto";
                        if (!useSelectSize) {
                            ulHeight = maxHeight;
                        }
                        return false;
                    }
                });
            self.$checkboxes.css("overflow", overflowSetting).height(ulHeight);
            self._savedMenuHeight = this.$menu.outerHeight(false);
        },
        _getBCRWidth: function (elem) {
            if (!elem || (!!elem.jquery && !elem[0])) {
                return null;
            }
            var domRect = !!elem.jquery ? elem[0].getBoundingClientRect() : elem.getBoundingClientRect();
            return domRect.right - domRect.left;
        },
        _jqWidthFix: function (elem) {
            if (!elem || (!!elem.jquery && !elem[0])) {
                return null;
            }
            return !!elem.jquery ? this._getBCRWidth(elem[0]) - elem.outerWidth(false) : this._getBCRWidth(elem) - $(elem).outerWidth(false);
        },
        _traverse: function (which, start) {
            var $start = $(start);
            var moveToLast = which === 38 || which === 37;
            var $next = $start.parent()[moveToLast ? "prevAll" : "nextAll"]("li:not(:disabled, .ui-multiselect-optgroup):visible").first();
            if (!$next.length) {
                $next = $start.parents(".ui-multiselect-optgroup")[moveToLast ? "prev" : "next"]();
            }
            if (!$next.length) {
                var $container = this.$checkboxes;
                $container.find("label").filter(":visible")[moveToLast ? "last" : "first"]().trigger("mouseover", { allowScroll: true });
                $container.scrollTop(moveToLast ? $container.height() : 0);
            } else {
                $next.find("label").filter(":visible")[moveToLast ? "last" : "first"]().trigger("mouseover", { allowScroll: true });
            }
        },
        _toggleState: function (prop, flag) {
            return function () {
                var state = flag === "!" ? !this[prop] : flag;
                if (!this.disabled) {
                    this[prop] = state;
                }
                if (state) {
                    this.setAttribute("aria-" + prop, true);
                } else {
                    this.removeAttribute("aria-" + prop);
                }
            };
        },
        _toggleChecked: function (flag, group, filteredInputs) {
            var self = this;
            var $element = self.element;
            var $inputs = group && group.length ? group : self.$inputs;
            if (filteredInputs) {
                $inputs = self._isOpen ? $inputs.closest("li").not(".ui-multiselect-excluded").find("input").not(":disabled") : $inputs.not(":disabled");
            }
            $inputs.each(self._toggleState("checked", flag));
            $inputs.eq(0).focus();
            self.update();
            var inputValues = {};
            $inputs.each(function () {
                inputValues[this.value] = true;
            });
            $element.find("option").each(function () {
                if (!this.disabled && inputValues[this.value]) {
                    self._toggleState("selected", flag).call(this);
                }
            });
            if ($inputs.length) {
                $element.trigger("change");
            }
        },
        _toggleDisabled: function (flag, groupID) {
            var disabledClass = "ui-state-disabled";
            if (this.$button) {
                this.$button.prop({ disabled: flag, "aria-disabled": flag })[flag ? "addClass" : "removeClass"](disabledClass);
            }
            if (this.options.disableInputsOnToggle) {
                var $inputs = typeof groupID === "undefined" ? this.$inputs : this._multiselectOptgroupFilter(groupID).find("input");
                var msDisabledClass = "ui-multiselect-disabled";
                if (flag) {
                    var matchedInputs = $inputs.filter(":enabled").get();
                    for (var x = 0, len = matchedInputs.length; x < len; x++) {
                        matchedInputs[x].setAttribute("disabled", "disabled");
                        matchedInputs[x].setAttribute("aria-disabled", "disabled");
                        matchedInputs[x].classList.add(msDisabledClass);
                        matchedInputs[x].parentNode.classList.add(disabledClass);
                    }
                } else {
                    var matchedInputs = $inputs.filter("." + msDisabledClass + ":disabled").get();
                    for (var x = 0, len = matchedInputs.length; x < len; x++) {
                        matchedInputs[x].removeAttribute("disabled");
                        matchedInputs[x].removeAttribute("aria-disabled");
                        matchedInputs[x].classList.remove(msDisabledClass);
                        matchedInputs[x].parentNode.classList.remove(disabledClass);
                    }
                }
            }
            var $select = typeof groupID === "undefined" ? this.element : this._nativeOptgroupFilter(groupID).find("option");
            $select.prop({ disabled: flag, "aria-disabled": flag });
        },
        open: function () {
            var $button = this.$button;
            if (this._trigger("beforeopen") === false || $button.hasClass("ui-state-disabled") || this._isOpen || !!this.options.listbox) {
                return;
            }
            var $menu = this.$menu;
            var $header = this.$header;
            var $labels = this.$labels;
            var $inputs = this.$inputs.filter(":checked:not(.ui-state-disabled)");
            var options = this.options;
            var effect = options.openEffect;
            var scrollX = window.pageXOffset;
            var scrollY = window.pageYOffset;
            this.$checkboxes.scrollTop(0);
            $menu.css("display", "block");
            this._setMenuWidth();
            this._setMenuHeight();
            this.position();
            if (!!effect) {
                $menu.css("display", "none");
                if (typeof effect == "string") {
                    $menu.show(effect, this.speed);
                } else if (typeof effect == "object" && effect.constructor == Array) {
                    $menu.show(effect[0], effect[1] || this.speed);
                } else if (typeof effect == "object" && effect.constructor == Object) {
                    $menu.show(effect);
                }
            }
            var filter = $header.find(".ui-multiselect-filter");
            if (filter.length) {
                filter.first().find("input").trigger("focus");
            } else if ($inputs.length) {
                $inputs.eq(0).trigger("focus").parent("label").eq(0).trigger("mouseover").trigger("mouseenter");
            } else if ($labels.length) {
                $labels.filter(":not(.ui-state-disabled)").eq(0).trigger("mouseover").trigger("mouseenter").find("input").trigger("focus");
            } else {
                $header.find("a").first().trigger("focus");
            }
            window.scrollTo(scrollX, scrollY);
            $button.addClass("ui-state-active");
            this._isOpen = true;
            this._trigger("open");
        },
        close: function () {
            if (this._trigger("beforeclose") === false || !!this.options.listbox) {
                return;
            }
            var $menu = this.$menu;
            var options = this.options;
            var effect = options.closeEffect;
            var $button = this.$button;
            if (!!effect) {
                if (typeof effect == "string") {
                    $menu.hide(effect, this.speed);
                } else if (typeof effect == "object" && effect.constructor == Array) {
                    $menu.hide(effect[0], effect[1] || this.speed);
                } else if (typeof effect == "object" && effect.constructor == Object) {
                    $menu.hide(effect);
                }
            } else {
                $menu.css("display", "none");
            }
            $button.removeClass("ui-state-active").trigger("blur").trigger("mouseleave");
            this.element.trigger("blur");
            this._isOpen = false;
            this._trigger("close");
            $button.trigger("focus");
        },
        position: function () {
            var $button = this.$button;
            this._savedButtonHeight = $button.outerHeight(false);
            if ($.ui && $.ui.position) {
                this.$menu.position(this.options.position);
            } else {
                var pos = {};
                pos.top = $button.offset().top + this._savedButtonHeight;
                pos.left = $button.offset().left;
                this.$menu.offset(pos);
            }
        },
        enable: function (groupID) {
            this._toggleDisabled(false, groupID);
        },
        disable: function (groupID) {
            this._toggleDisabled(true, groupID);
        },
        checkAll: function (groupID) {
            this._trigger("beforeCheckAll");
            if (this.options.maxSelected) {
                return;
            }
            if (typeof groupID === "undefined") {
                this._toggleChecked(true);
            } else {
                this._toggleChecked(true, this._multiselectOptgroupFilter(groupID).find("input"));
            }
            this._trigger("checkAll");
        },
        uncheckAll: function (groupID) {
            this._trigger("beforeUncheckAll");
            if (typeof groupID === "undefined") {
                this._toggleChecked(false);
            } else {
                this._toggleChecked(false, this._multiselectOptgroupFilter(groupID).find("input"));
            }
            if (!this.element[0].multiple && !this.$inputs.filter(":checked").length) {
                this.element[0].selectedIndex = -1;
            }
            this._trigger("uncheckAll");
        },
        flipAll: function (groupID) {
            this._trigger("beforeFlipAll");
            var gotID = typeof groupID !== "undefined";
            var maxSelected = this.options.maxSelected;
            var inputCount = this.$inputs.length;
            var checkedCount = this.$inputs.filter(":checked").length;
            var $filteredOptgroupInputs = gotID ? this._multiselectOptgroupFilter(groupID).find("input") : null;
            var gInputCount = gotID ? $filteredOptgroupInputs.length : 0;
            var gCheckedCount = gotID ? $filteredOptgroupInputs.filter(":checked").length : 0;
            if (!maxSelected || maxSelected >= (gotID ? checkedCount - gCheckedCount + gInputCount - gCheckedCount : inputCount - checkedCount)) {
                if (gotID) {
                    this._toggleChecked("!", $filteredOptgroupInputs);
                } else {
                    this._toggleChecked("!");
                }
                this._trigger("flipAll");
            } else {
                this.buttonMessage("<center><b>Flip All Not Permitted.</b></center>");
            }
        },
        collapseAll: function (groupID) {
            this._trigger("beforeCollapseAll");
            var $optgroups = typeof groupID === "undefined" ? this.$checkboxes.find(".ui-multiselect-optgroup") : this._multiselectOptgroupFilter(groupID);
            $optgroups.addClass("ui-multiselect-collapsed").children(".ui-multiselect-collapser").attr("title", this.linkInfo.expand.title).html(this.linkInfo.expand.icon);
            this._trigger("collapseAll");
        },
        expandAll: function (groupID) {
            this._trigger("beforeExpandAll");
            var $optgroups = typeof groupID === "undefined" ? this.$checkboxes.find(".ui-multiselect-optgroup") : this._multiselectOptgroupFilter(groupID);
            $optgroups.removeClass("ui-multiselect-collapsed").children(".ui-multiselect-collapser").attr("title", this.linkInfo.collapse.title).html(this.linkInfo.collapse.icon);
            this._trigger("expandAll");
        },
        buttonMessage: function (message) {
            var self = this;
            self.$buttonlabel.html(message);
            setTimeout(function () {
                self.update();
            }, 1e3);
        },
        getChecked: function () {
            return this.$inputs.filter(":checked");
        },
        getUnchecked: function () {
            return this.$inputs.filter(":not(:checked)");
        },
        destroy: function () {
            $.Widget.prototype.destroy.call(this);
            this.document.off(this._namespaceID);
            $(this.element[0].form).off(this._namespaceID);
            if (!this.options.listbox) {
                this.$button.remove();
            }
            this.$menu.remove();
            this.element.show();
            return this;
        },
        isOpen: function () {
            return this._isOpen;
        },
        widget: function () {
            return this.$menu;
        },
        getNamespaceID: function () {
            return this._namespaceID;
        },
        getButton: function () {
            return this.$button;
        },
        getMenu: function () {
            return this.$menu;
        },
        getLabels: function () {
            return this.$labels;
        },
        getCollapsed: function () {
            return this.$checkboxes.find(".ui-multiselect-collapsed");
        },
        value: function (newValue) {
            if (typeof newValue !== "undefined") {
                this.element.val(newValue);
                this.resync();
                return this.element;
            } else {
                return this.element.val();
            }
        },
        htmlAllowedFor: function (element) {
            return this.options.htmlText.indexOf(element) > -1;
        },
        addOption: function (attributes, text, groupID) {
            var self = this;
            var textFxn = self.htmlAllowedFor("options") ? "html" : "text";
            var $option = $(document.createElement("option")).attr(attributes)[textFxn](text);
            var optionNode = $option.get(0);
            if (typeof groupID === "undefined") {
                self.element.append($option);
                self.$checkboxes.append(self._makeOption(optionNode));
            } else {
                self._nativeOptgroupFilter(groupID).append($option);
                self._multiselectOptgroupFilter(groupID).append(self._makeOption(optionNode));
            }
            self._updateCache();
        },
        _nativeOptgroupFilter: function (groupID) {
            return this.element.children("OPTGROUP").filter(function (index) {
                return typeof groupID === "number" ? index === groupID : this.getAttribute("label") === groupID;
            });
        },
        _multiselectOptgroupFilter: function (groupID) {
            return this.$menu.find(".ui-multiselect-optgroup").filter(function (index) {
                return typeof groupID === "number" ? index === groupID : this.getElementsByClassName("ui-multiselect-grouplabel")[0].textContent === groupID;
            });
        },
        removeOption: function (value) {
            if (!value) {
                return;
            }
            this.element.find("option[value=" + value + "]").remove();
            this.$labels
                .find("input[value=" + value + "]")
                .parents("li")
                .remove();
            this._updateCache();
        },
        _setOption: function (key, value) {
            var $header = this.$header;
            var $menu = this.$menu;
            switch (key) {
                case "header":
                    if (typeof value === "boolean") {
                        $header.toggle(value);
                    } else if (typeof value === "string") {
                        this.$headerLinkContainer.children("li:not(:last-child)").remove();
                        this.$headerLinkContainer.prepend("<li>" + value + "</li>");
                    }
                    break;
                case "checkAllText":
                case "uncheckAllText":
                case "flipAllText":
                case "collapseAllText":
                case "expandAllText":
                    if (key !== "checkAllText" || !this.options.maxSelected) {
                        $header
                            .find("a." + this.linkInfo[key.replace("Text", "")]["class"] + " span")
                            .eq(-1)
                            .html(value);
                    }
                    break;
                case "checkAllIcon":
                case "uncheckAllIcon":
                case "flipAllIcon":
                case "collapseAllIcon":
                case "expandAllIcon":
                    if (key !== "checkAllIcon" || !this.options.maxSelected) {
                        $header
                            .find("a." + this.linkInfo[key.replace("Icon", "")]["class"] + " span")
                            .eq(0)
                            .replaceWith(value);
                    }
                    break;
                case "openIcon":
                    $menu.find("span.ui-multiselect-open").html(value);
                    break;
                case "closeIcon":
                    $menu.find("a.ui-multiselect-close").html(value);
                    break;
                case "buttonWidth":
                case "menuWidth":
                    this.options[key] = value;
                    this._setButtonWidth(true);
                    this._setMenuWidth(true);
                    break;
                case "menuHeight":
                    this.options[key] = value;
                    this._setMenuHeight(true);
                    break;
                case "selectedText":
                case "selectedList":
                case "maxSelected":
                case "noneSelectedText":
                case "selectedListSeparator":
                    this.options[key] = value;
                    this.update(true);
                    break;
                case "classes":
                    $menu.add(this.$button).removeClass(this.options.classes).addClass(value);
                    break;
                case "multiple":
                    var $element = this.element;
                    if (!!$element[0].multiple !== value) {
                        $menu.toggleClass("ui-multiselect-multiple", value).toggleClass("ui-multiselect-single", !value);
                        $element[0].multiple = value;
                        this.uncheckAll();
                        this.refresh();
                    }
                    break;
                case "position":
                    if (value !== null && !$.isEmptyObject(value)) {
                        this.options.position = value;
                    }
                    this.position();
                    break;
                case "zIndex":
                    this.options.zIndex = value;
                    this.$menu.css("z-index", value);
                    break;
                default:
                    this.options[key] = value;
            }
            $.Widget.prototype._setOption.apply(this, arguments);
        },
        _parse2px: parse2px,
    });
    if ($.ui && "dialog" in $.ui) {
        $.widget("ui.dialog", $.ui.dialog, {
            _allowInteraction: function (event) {
                if (this._super(event) || $(event.target).closest(".ui-multiselect-menu").length) {
                    return true;
                }
            },
        });
    }
})(jQuery);
(function ($) {
    var rEscape = /[\-\[\]{}()*+?.,\\\^$|#\s]/g;
    var filterRules = { contains: "{{term}}", beginsWith: "^{{term}}", endsWith: "{{term}}$", exactMatch: "^{{term}}$", containsNumber: "d", isNumeric: "^d+$", isNonNumeric: "^D+$" };
    var headerSelector = ".ui-multiselect-header";
    var hasFilterClass = "ui-multiselect-hasfilter";
    var filterClass = "ui-multiselect-filter";
    var optgroupClass = "ui-multiselect-optgroup";
    var groupLabelClass = "ui-multiselect-grouplabel";
    var hiddenClass = "ui-multiselect-excluded";
    function debounce(func, wait, immediate) {
        var timeout;
        return function () {
            var context = this;
            var args = arguments;
            var later = function () {
                timeout = null;
                if (!immediate) {
                    func.apply(context, args);
                }
            };
            var callNow = immediate && !timeout;
            clearTimeout(timeout);
            timeout = setTimeout(later, wait);
            if (callNow) {
                func.apply(context, args);
            }
        };
    }
    $.widget("ech.multiselectfilter", {
        options: { label: "Filter:", placeholder: "Enter keywords", filterRule: "contains", searchGroups: false, autoReset: false, width: null, debounceMS: 250 },
        _create: function () {
            var opts = this.options;
            var $element = this.element;
            this.instance = $element.data("ech-multiselect");
            this.$header = this.instance.$menu.find(headerSelector).addClass(hasFilterClass);
            this.$input = $(document.createElement("input"))
                .attr({ placeholder: opts.placeholder, type: "search" })
                .css({ width: typeof opts.width === "string" ? this.instance._parse2px(opts.width, this.$header).px + "px" : /\d/.test(opts.width) ? opts.width + "px" : null });
            this._bindInputEvents();
            if (this.options.autoReset) {
                $element.on("multiselectbeforeclose", $.proxy(this._reset, this));
            }
            var $label = $(document.createElement("label")).text(opts.label).append(this.$input).addClass("ui-multiselect-filter-label");
            this.$wrapper = $(document.createElement("div")).addClass(filterClass).append($label).prependTo(this.$header);
            if (!!this.instance._isOpen) {
                this.instance._setMenuHeight(true);
            }
            this.updateCache();
            var instance = this.instance;
            var filter = this.$input[0];
            instance._oldToggleChecked = instance._toggleChecked;
            instance._toggleChecked = function (flag, group) {
                instance._oldToggleChecked(flag, group, !!filter.value);
            };
        },
        _bindInputEvents: function () {
            this.$input.on({
                keydown: function (e) {
                    if (e.which === 13) {
                        e.preventDefault();
                    } else if (e.which === 27) {
                        $element.multiselect("close");
                        e.preventDefault();
                    } else if (e.which === 9 && e.shiftKey) {
                        $element.multiselect("close");
                        e.preventDefault();
                    } else if (e.altKey) {
                        switch (e.which) {
                            case 82:
                                e.preventDefault();
                                $(this).val("").trigger("input", "");
                                break;
                            case 65:
                                $element.multiselect("checkAll");
                                break;
                            case 85:
                                $element.multiselect("uncheckAll");
                                break;
                            case 70:
                                $element.multiselect("flipAll");
                                break;
                            case 76:
                                $element.multiselect("instance").$labels.first().trigger("mouseenter");
                                break;
                        }
                    }
                },
                input: $.proxy(debounce(this._handler, this.options.debounceMS), this),
                search: $.proxy(this._handler, this),
            });
        },
        _handler: function (e) {
            var term = this.$input[0].value.toLowerCase().replace(/^\s+|\s+$/g, "");
            var filterRule = this.options.filterRule || "contains";
            var regex = new RegExp((filterRules[filterRule] || filterRule).replace("{{term}}", term.replace(rEscape, "\\$&")), "i");
            var searchGroups = !!this.options.searchGroups;
            var $checkboxes = this.instance.$checkboxes;
            var cache = this.cache;
            this.$rows.toggleClass(hiddenClass, !!term);
            var filteredInputs = $checkboxes.children().map(function (x) {
                var elem = this;
                var $groupItems = $(elem);
                var groupShown = false;
                if (elem.classList.contains(optgroupClass)) {
                    var $groupItems = $groupItems.find("li");
                    if (searchGroups && regex.test(cache[x])) {
                        elem.classList.remove(hiddenClass);
                        $groupItems.removeClass(hiddenClass);
                        return $groupItems.find("input").get();
                    }
                }
                return $groupItems.map(function (y) {
                    if (regex.test(cache[x + "." + y])) {
                        if (!groupShown) {
                            elem.classList.remove(hiddenClass);
                            groupShown = true;
                        }
                        this.classList.remove(hiddenClass);
                        return this.getElementsByTagName("input")[0];
                    }
                    return null;
                });
            });
            if (term) {
                this._trigger("filter", e, filteredInputs);
            }
            if (!this.instance.options.listbox && this.instance._isOpen) {
                this.instance._setMenuHeight(true);
                this.instance.position();
            }
            return;
        },
        _reset: function () {
            this.$input.val("");
            var event = document.createEvent("Event");
            event.initEvent("reset", true, true);
            this.$input.get(0).dispatchEvent(event);
            this._handler(event);
        },
        updateCache: function (alsoRefresh) {
            var cache = {};
            this.instance.$checkboxes.children().each(function (x) {
                var $element = $(this);
                if (this.classList.contains(optgroupClass)) {
                    cache[x] = this.getElementsByClassName(groupLabelClass)[0].textContent;
                    $element = $element.find("li");
                }
                $element.each(function (y) {
                    cache[x + "." + y] = this.textContent;
                });
            });
            this.cache = cache;
            this.$rows = this.instance.$checkboxes.find("li");
            if (!!alsoRefresh) {
                this._handler();
            }
        },
        widget: function () {
            return this.$wrapper;
        },
        destroy: function () {
            $.Widget.prototype.destroy.call(this);
            this.$input.val("").trigger("keyup").off("keydown input search");
            this.instance.$menu.find(headerSelector).removeClass(hasFilterClass);
            this.$wrapper.remove();
        },
    });
})(jQuery);
