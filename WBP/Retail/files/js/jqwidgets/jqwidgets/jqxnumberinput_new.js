/*
jQWidgets v3.8.2 (2015-Aug)
Copyright (c) 2011-2015 jQWidgets.
License: http://jqwidgets.com/license/
*/
(function(a) {
    a.jqx.jqxWidget("jqxNumberInput", "", {});
    a.extend(a.jqx._jqxNumberInput.prototype, {
        defineInstance: function() {
            var b = {
                value: null,
                decimal: 0,
                min: -99999999,
                max: 99999999,
                width: 200,
                validationMessage: "Invalid value",
                height: 25,
                textAlign: "right",
                readOnly: false,
                promptChar: "_",
                decimalDigits: 2,
                decimalSeparator: ".",
                groupSeparator: ",",
                groupSize: 3,
                symbol: "",
                symbolPosition: "left",
                digits: 8,
                negative: false,
                negativeSymbol: "-",
                disabled: false,
                inputMode: "advanced",
                spinButtons: false,
                spinButtonsWidth: 18,
                spinButtonsStep: 1,
                autoValidate: true,
                spinMode: "advanced",
                enableMouseWheel: true,
                touchMode: "auto",
                rtl: false,
                events: ["valueChanged", "textchanged", "mousedown", "mouseup", "keydown", "keyup", "keypress", "change"],
                aria: {
                    "aria-valuenow": {
                        name: "decimal",
                        type: "number"
                    },
                    "aria-valuemin": {
                        name: "min",
                        type: "number"
                    },
                    "aria-valuemax": {
                        name: "max",
                        type: "number"
                    },
                    "aria-disabled": {
                        name: "disabled",
                        type: "boolean"
                    }
                },
                invalidArgumentExceptions: ["invalid argument exception"]
            };
            a.extend(true, this, b);
            return b
        },
        createInstance: function(b) {
            var c = this.host.attr("value");
            if (c != undefined) {
                this.decimal = c
            }
            if (this.value != null) {
                this.decimal = this.value
            }
            this.render()
        },
        _doTouchHandling: function() {
            var e = this;
            var g = e.savedValue;
            if (!e.parsing) {
                e.parsing = true
            }
            if (e.parsing) {
                if (e.numberInput.val() && e.numberInput.val().indexOf("-") == 0) {
                    e.setvalue("negative", true)
                } else {
                    e.setvalue("negative", false)
                }
                var f = e.numberInput.val();
                for (var c = 0; c < f.length - 1; c++) {
                    var d = f.substring(c, c + 1);
                    if (isNaN(parseFloat(d)) && d != e.symbol && d != "%" && d != "$" && d != "." && d != "," && d != "-") {
                        e.numberInput[0].value = g;
                        e.parsing = false;
                        return
                    }
                }
                e.ValueString = e.GetValueString(e.numberInput.val(), e.decimalSeparator, e.decimalSeparator != "");
                e.ValueString = new Number(e.ValueString).toFixed(e.decimalDigits);
                e._parseDecimalInSimpleMode();
                e.decimal = e.ValueString;
                var b = e.getvalue("negative");
                if (b) {
                    e.decimal = "-" + e.ValueString
                }
                e.parsing = false
            }
        },
        render: function() {
            this.host.attr({
                role: "spinbutton"
            });
            this.host.attr("data-role", "input");
            a.jqx.aria(this);
            a.jqx.aria(this, "aria-multiline", false);
            var f = this;
            if (this.officeMode || (this.theme && this.theme.indexOf("office") != -1)) {
                if (this.spinButtonsWidth == 18) {
                    this.spinButtonsWidth = 15
                }
            }
            if (a.jqx.mobile.isTouchDevice() || this.touchMode === true) {
                this.inputMode = "textbox";
                this.spinMode = "simple"
            }
            if (this.decimalSeparator == "") {
                this.decimalSeparator = " "
            }
            this.host.addClass(this.toThemeProperty("jqx-input"));
            this.host.addClass(this.toThemeProperty("jqx-rc-all"));
            this.host.addClass(this.toThemeProperty("jqx-widget"));
            this.host.addClass(this.toThemeProperty("jqx-widget-content"));
            this.host.addClass(this.toThemeProperty("jqx-numberinput"));
            if (this.spinButtons) {
                this._spinButtons()
            } else {
                this.numberInput = a("<input autocomplete='off' type='textarea'/>").appendTo(this.host);
                this.numberInput.addClass(this.toThemeProperty("jqx-input-content"));
                this.numberInput.addClass(this.toThemeProperty("jqx-widget-content"))
            }
            var d = this.host.attr("name");
            if (d) {
                this.numberInput.attr("name", d)
            }
            if (this.host.attr("tabindex")) {
                this.numberInput.attr("tabindex", this.host.attr("tabindex"));
                this.host.removeAttr("tabindex")
            }
            if (a.jqx.mobile.isTouchDevice() || this.touchMode === true || this.inputMode == "textbox") {
                var f = this;
                f.savedValue = "";
                this.addHandler(this.numberInput, "focus", function() {
                    f.savedValue = f.numberInput[0].value
                });
                this.addHandler(this.numberInput, "change", function() {
                    f._doTouchHandling()
                })
            }
            var h = a.data(this.host[0], "jqxNumberInput");
            h.jqxNumberInput = this;
            var f = this;
            if (this.host.parents("form").length > 0) {
                this.addHandler(this.host.parents("form"), "reset", function() {
                    setTimeout(function() {
                        f.setDecimal(0)
                    }, 10)
                })
            }
            this.propertyChangeMap.disabled = function(n, q, o, r) {
                if (r) {
                    n.numberInput.addClass(c.toThemeProperty("jqx-input-disabled"));
                    n.numberInput.attr("disabled", true)
                } else {
                    n.host.removeClass(c.toThemeProperty("jqx-input-disabled"));
                    n.numberInput.attr("disabled", false)
                }
                if (n.spinButtons && n.host.jqxRepeatButton) {
                    n.upbutton.jqxRepeatButton({
                        disabled: r
                    });
                    n.downbutton.jqxRepeatButton({
                        disabled: r
                    })
                }
            };
            if (this.disabled) {
                this.numberInput.addClass(this.toThemeProperty("jqx-input-disabled"));
                this.numberInput.attr("disabled", true);
                this.host.addClass(this.toThemeProperty("jqx-fill-state-disabled"))
            }
            this.selectedText = "";
            this.decimalSeparatorPosition = -1;
            var l = this.element.id;
            var e = this.element;
            var c = this;
            this.oldValue = this._value();
            this.items = new Array();
            var g = this.value;
            var b = this.decimal;
            this._initializeLiterals();
            this._render();
            this.setDecimal(b);
            var f = this;
            setTimeout(function() {}, 100);
            this._addHandlers();
            a.jqx.utilities.resize(this.host, function() {
                f._render()
            })
        },
        refresh: function(b) {
            if (!b) {
                this._render()
            }
        },
        wheel: function(d, c) {
            if (!c.enableMouseWheel) {
                return
            }
            var e = 0;
            if (!d) {
                d = window.event
            }
            if (d.originalEvent && d.originalEvent.wheelDelta) {
                d.wheelDelta = d.originalEvent.wheelDelta
            }
            if (d.wheelDelta) {
                e = d.wheelDelta / 120
            } else {
                if (d.detail) {
                    e = -d.detail / 3
                }
            }
            if (e) {
                var b = c._handleDelta(e);
                if (d.preventDefault) {
                    d.preventDefault()
                }
                if (d.originalEvent != null) {
                    d.originalEvent.mouseHandled = true
                }
                if (d.stopPropagation != undefined) {
                    d.stopPropagation()
                }
                if (b) {
                    b = false;
                    d.returnValue = b;
                    return b
                } else {
                    return false
                }
            }
            if (d.preventDefault) {
                d.preventDefault()
            }
            d.returnValue = false
        },
        _handleDelta: function(b) {
            if (b < 0) {
                this.spinDown()
            } else {
                this.spinUp()
            }
            return true
        },
        _addHandlers: function() {
            var b = this;
            this.addHandler(this.numberInput, "paste", function(f) {
                var d = b._selection();
                f.preventDefault();
                if (f.originalEvent.clipboardData) {
                    content = (f.originalEvent || f).clipboardData.getData("text/plain")
                } else {
                    if (window.clipboardData) {
                        content = window.clipboardData.getData("Text")
                    }
                }
                this.selectedText = content;
                a.data(document.body, "jqxSelection", this.selectedText);
                if (b.inputMode != "simple") {
                    b._pasteSelectedText()
                } else {
                    b.val(content)
                }
                setTimeout(function() {
                    b._setSelectionStart(d.start)
                })
            });
            this.addHandler(this.numberInput, "mousedown", function(d) {
                return b._raiseEvent(2, d)
            });
            this._mousewheelfunc = this._mousewheelfunc || function(d) {
                if (!b.editcell) {
                    b.wheel(d, b);
                    return false
                }
            };
            this.removeHandler(this.host, "mousewheel", this._mousewheelfunc);
            this.addHandler(this.host, "mousewheel", this._mousewheelfunc);
            var c = "";
            this.addHandler(this.numberInput, "focus", function(d) {
                a.data(b.numberInput, "selectionstart", b._selection().start);
                b.host.addClass(b.toThemeProperty("jqx-fill-state-focus"));
                if (b.spincontainer) {
                    b.spincontainer.addClass(b.toThemeProperty("jqx-numberinput-focus"))
                }
                c = b.numberInput.val()
            });
            this.addHandler(this.numberInput, "blur", function(e) {
                if (b.inputMode == "simple") {
                    b._exitSimpleInputMode(e, b, false, c)
                }
                if (b.autoValidate) {
                    var f = parseFloat(b.decimal);
                    var d = b.getvalue("negative");
                    if (d && b.decimal > 0) {
                        f = -parseFloat(b.decimal)
                    }
                    if (f > b.max) {
                        b._disableSetSelection = true;
                        b.setDecimal(b.max);
                        b._disableSetSelection = false
                    }
                    if (f < b.min) {
                        b._disableSetSelection = true;
                        b.setDecimal(b.min);
                        b._disableSetSelection = false
                    }
                }
                b.host.removeClass(b.toThemeProperty("jqx-fill-state-focus"));
                if (b.spincontainer) {
                    b.spincontainer.removeClass(b.toThemeProperty("jqx-numberinput-focus"))
                }
                if (b.numberInput.val() != c) {
                    b._raiseEvent(7, e);
                    a.jqx.aria(b, "aria-valuenow", b.decimal);
                    b.element.value = b.decimal
                }
                return true
            });
            this.addHandler(this.numberInput, "mouseup", function(d) {
                return b._raiseEvent(3, d)
            });
            this.addHandler(this.numberInput, "keydown", function(d) {
                return b._raiseEvent(4, d)
            });
            this.addHandler(this.numberInput, "keyup", function(d) {
                return b._raiseEvent(5, d)
            });
            this.addHandler(this.numberInput, "keypress", function(d) {
                return b._raiseEvent(6, d)
            })
        },
        focus: function() {
            try {
                this.numberInput.focus()
            } catch (b) {}
        },
        _removeHandlers: function() {
            var b = this;
            this.removeHandler(this.numberInput, "mousedown");
            var c = a.jqx.mobile.isOperaMiniMobileBrowser();
            if (c) {
                this.removeHandler(a(document), "click." + this.element.id, b._exitSimpleInputMode, b)
            }
            this.removeHandler(this.numberInput, "paste");
            this.removeHandler(this.numberInput, "focus");
            this.removeHandler(this.numberInput, "blur");
            this.removeHandler(this.numberInput, "mouseup");
            this.removeHandler(this.numberInput, "keydown");
            this.removeHandler(this.numberInput, "keyup");
            this.removeHandler(this.numberInput, "keypress")
        },
        _spinButtons: function() {
            if (this.host.jqxRepeatButton) {
                if (!this.numberInput) {
                    this.numberInput = a("<input autocomplete='off' style='position: relative; float: left;' type='textarea'/>");
                    this.numberInput.appendTo(this.host);
                    this.numberInput.addClass(this.toThemeProperty("jqx-input-content"));
                    this.numberInput.addClass(this.toThemeProperty("jqx-widget-content"))
                } else {
                    this.numberInput.css("float", "left")
                }
                if (this.spincontainer) {
                    if (this.upbutton) {
                        this.upbutton.jqxRepeatButton("destroy")
                    }
                    if (this.downbutton) {
                        this.downbutton.jqxRepeatButton("destroy")
                    }
                    this.spincontainer.remove()
                }
                this.spincontainer = a('<div style="float: right; height: 100%; overflow: hidden; position: relative;"></div>');
                if (this.rtl) {
                    this.spincontainer.css("float", "right");
                    this.numberInput.css("float", "right");
                    this.spincontainer.css("left", "-1px")
                }
                this.host.append(this.spincontainer);
                this.upbutton = a('<div style="overflow: hidden; padding: 0px; margin-left: -1px; position: relative;"><div></div></div>');
                this.spincontainer.append(this.upbutton);
                this.upbutton.jqxRepeatButton({
                    overrideTheme: true,
                    disabled: this.disabled,
                    roundedCorners: "top-right"
                });
                this.downbutton = a('<div style="overflow: hidden; padding: 0px; margin-left: -1px; position: relative;"><div></div></div>');
                this.spincontainer.append(this.downbutton);
                this.downbutton.jqxRepeatButton({
                    overrideTheme: true,
                    disabled: this.disabled,
                    roundedCorners: "bottom-right"
                });
                var d = this;
                this.downbutton.addClass(this.toThemeProperty("jqx-fill-state-normal"));
                this.upbutton.addClass(this.toThemeProperty("jqx-fill-state-normal"));
                this.upbutton.addClass(this.toThemeProperty("jqx-rc-tr"));
                this.downbutton.addClass(this.toThemeProperty("jqx-rc-br"));
                this.addHandler(this.downbutton, "mouseup", function(e) {
                    if (!d.disabled) {
                        d.downbutton.removeClass(d.toThemeProperty("jqx-fill-state-pressed"));
                        d._downArrow.removeClass(d.toThemeProperty("jqx-icon-arrow-down-selected"))
                    }
                });
                this.addHandler(this.upbutton, "mouseup", function(e) {
                    if (!d.disabled) {
                        d.upbutton.removeClass(d.toThemeProperty("jqx-fill-state-pressed"));
                        d._upArrow.removeClass(d.toThemeProperty("jqx-icon-arrow-up-selected"))
                    }
                });
                this.removeHandler(a(document), "mouseup." + this.element.id);
                this.addHandler(a(document), "mouseup." + this.element.id, function(e) {
                    d.upbutton.removeClass(d.toThemeProperty("jqx-fill-state-pressed"));
                    d._upArrow.removeClass(d.toThemeProperty("jqx-icon-arrow-up-selected"));
                    d.downbutton.removeClass(d.toThemeProperty("jqx-fill-state-pressed"));
                    d._downArrow.removeClass(d.toThemeProperty("jqx-icon-arrow-down-selected"))
                });
                this.addHandler(this.downbutton, "mousedown", function(e) {
                    if (!d.disabled) {
                        if (a.jqx.browser.msie && a.jqx.browser.version < 9) {
                            d._inputSelection = d._selection()
                        }
                        d.downbutton.addClass(d.toThemeProperty("jqx-fill-state-pressed"));
                        d._downArrow.addClass(d.toThemeProperty("jqx-icon-arrow-down-selected"));
                        e.preventDefault();
                        e.stopPropagation();
                        return false
                    }
                });
                this.addHandler(this.upbutton, "mousedown", function(e) {
                    if (!d.disabled) {
                        if (a.jqx.browser.msie && a.jqx.browser.version < 9) {
                            d._inputSelection = d._selection()
                        }
                        d.upbutton.addClass(d.toThemeProperty("jqx-fill-state-pressed"));
                        d._upArrow.addClass(d.toThemeProperty("jqx-icon-arrow-up-selected"));
                        e.preventDefault();
                        e.stopPropagation();
                        return false
                    }
                });
                this.addHandler(this.upbutton, "mouseenter", function(e) {
                    d.upbutton.addClass(d.toThemeProperty("jqx-fill-state-hover"));
                    d._upArrow.addClass(d.toThemeProperty("jqx-icon-arrow-up-hover"))
                });
                this.addHandler(this.upbutton, "mouseleave", function(e) {
                    d.upbutton.removeClass(d.toThemeProperty("jqx-fill-state-hover"));
                    d._upArrow.removeClass(d.toThemeProperty("jqx-icon-arrow-up-hover"))
                });
                this.addHandler(this.downbutton, "mouseenter", function(e) {
                    d.downbutton.addClass(d.toThemeProperty("jqx-fill-state-hover"));
                    d._downArrow.addClass(d.toThemeProperty("jqx-icon-arrow-down-hover"))
                });
                this.addHandler(this.downbutton, "mouseleave", function(e) {
                    d.downbutton.removeClass(d.toThemeProperty("jqx-fill-state-hover"));
                    d._downArrow.removeClass(d.toThemeProperty("jqx-icon-arrow-down-hover"))
                });
                this.upbutton.css("border-width", "0px");
                this.downbutton.css("border-width", "0px");
                if (this.disabled) {
                    this.upbutton[0].disabled = true;
                    this.downbutton[0].disabled = true
                } else {
                    this.upbutton[0].disabled = false;
                    this.downbutton[0].disabled = false
                }
                this.spincontainer.addClass(this.toThemeProperty("jqx-input"));
                this.spincontainer.addClass(this.toThemeProperty("jqx-rc-r"));
                this.spincontainer.css("border-width", "0px");
                if (!this.rtl) {
                    this.spincontainer.css("border-left-width", "1px")
                } else {
                    this.spincontainer.css("border-right-width", "1px")
                }
                this._upArrow = this.upbutton.find("div");
                this._downArrow = this.downbutton.find("div");
                this._upArrow.addClass(this.toThemeProperty("jqx-icon-arrow-up"));
                this._downArrow.addClass(this.toThemeProperty("jqx-icon-arrow-down"));
                this._upArrow.addClass(this.toThemeProperty("jqx-input-icon"));
                this._downArrow.addClass(this.toThemeProperty("jqx-input-icon"));
                var d = this;
                this._upArrow.hover(function() {
                    if (!d.disabled) {
                        d._upArrow.addClass(d.toThemeProperty("jqx-icon-arrow-up-hover"))
                    }
                }, function() {
                    d._upArrow.removeClass(d.toThemeProperty("jqx-icon-arrow-up-hover"))
                });
                this._downArrow.hover(function() {
                    if (!d.disabled) {
                        d._downArrow.addClass(d.toThemeProperty("jqx-icon-arrow-down-hover"))
                    }
                }, function() {
                    d._downArrow.removeClass(d.toThemeProperty("jqx-icon-arrow-down-hover"))
                });
                var b = a.jqx.mobile.isTouchDevice();
                var c = "click";
                if (b) {
                    c = a.jqx.mobile.getTouchEventName("touchstart")
                }
                if (b) {
                    this.addHandler(this.downbutton, "click", function(e) {
                        d.spinDown()
                    });
                    this.addHandler(this.upbutton, "click", function(e) {
                        d.spinUp()
                    })
                }
                this.addHandler(this.downbutton, c, function(e) {
                    if (!b) {
                        if (d._selection().start == 0) {
                            d._setSelectionStart(d.numberInput.val().length)
                        }
                        if (a.jqx.browser.msie && a.jqx.browser.version < 9) {
                            d._setSelectionStart(d._inputSelection.start)
                        }
                    } else {
                        e.preventDefault();
                        e.stopPropagation()
                    }
                    d.spinDown();
                    return false
                });
                this.addHandler(this.upbutton, c, function(e) {
                    if (!b) {
                        if (d._selection().start == 0) {
                            d._setSelectionStart(d.numberInput.val().length)
                        }
                        if (a.jqx.browser.msie && a.jqx.browser.version < 9) {
                            d._setSelectionStart(d._inputSelection.start)
                        }
                    } else {
                        e.preventDefault();
                        e.stopPropagation()
                    }
                    d.spinUp();
                    return false
                })
            } else {
                throw new Error("jqxNumberInput: Missing reference to jqxbuttons.js.")
            }
        },
        spinDown: function() {
            var o = this;
            if (o.spinMode == "none") {
                return
            }
            if (this.decimal == null) {
                this.setDecimal(-1);
                return
            }
            var b = this.getvalue("negative");
            var t = b ? -1 : 0;
            if (a.jqx.mobile.isTouchDevice() || this.inputMode == "textbox") {
                o._doTouchHandling()
            }
            if (!o.disabled) {
                var r = this._selection();
                var q = this.decimal;
                var l = this.getDecimal();
                if (l < this.min) {
                    l = this.min;
                    this.setDecimal(this.min);
                    this._setSelectionStart(r.start);
                    this.spinDown();
                    return
                } else {
                    if (l > this.max) {
                        l = this.max;
                        this.setDecimal(this.max);
                        this._setSelectionStart(r.start);
                        this.spinDown();
                        return
                    }
                }
                if (o.spinButtonsStep < 0) {
                    o.spinButtonsStep = 1
                }
                var d = parseInt(o.decimal) - o.spinButtonsStep;
                d = d.toString().length;
                var f = t + d <= o.digits;
                if (o.spinMode != "advanced") {
                    if (l - o.spinButtonsStep >= o.min && f) {
                        var v = 1;
                        for (g = 0; g < o.decimalDigits; g++) {
                            v = v * 10
                        }
                        var e = (v * l) - (v * o.spinButtonsStep);
                        e = e / v;
                        e = this._parseDecimalValueToEditorValue(e);
                        o.setDecimal(e)
                    }
                } else {
                    var s = this._getspindecimal();
                    var n = this._getSeparatorPosition();
                    var l = parseFloat(s.decimal);
                    if (o.spinButtonsStep < 0) {
                        o.spinButtonsStep = 1
                    }
                    var d = parseInt(l) - o.spinButtonsStep;
                    d = d.toString().length;
                    var f = t + d <= o.digits;
                    var v = 1;
                    var c = s.decimal.indexOf(".");
                    if (c != -1) {
                        var h = s.decimal.length - c - 1;
                        var v = 1;
                        for (var g = 0; g < h; g++) {
                            v = v * 10
                        }
                        l -= new Number(o.spinButtonsStep / v);
                        l = l.toFixed(h);
                        var c = l.toString().indexOf(".");
                        if (c == -1) {
                            l = l.toString() + "."
                        }
                        var u = l.toString() + s.afterdecimal;
                        u = new Number(u);
                        u = u.toFixed(o.decimalDigits);
                        if (u >= o.min) {
                            u = this._parseDecimalValueToEditorValue(u);
                            o.setDecimal(u)
                        }
                    } else {
                        if (l - o.spinButtonsStep >= o.min && f) {
                            var e = (v * l) - (v * o.spinButtonsStep);
                            e = e / v;
                            var u = e.toString() + s.afterdecimal;
                            if (u >= o.min) {
                                u = this._parseDecimalValueToEditorValue(u);
                                o.setDecimal(u)
                            }
                        }
                    }
                }
                if (u == undefined || this.inputMode != "simple") {
                    this._setSelectionStart(r.start);
                    o.savedValue = o.numberInput[0].value;
                    if (a.jqx.mobile.isTouchDevice()) {
                        this._raiseEvent(0, {})
                    }
                    this._raiseEvent(7, {});
                    a.jqx.aria(self, "aria-valuenow", this.decimal);
                    return
                }
                u = this.decimal.toString();
                var b = this.getvalue("negative");
                if (t == 0 && b) {
                    this._setSelectionStart(r.start + 1)
                } else {
                    if ((u != undefined && (q == undefined || q.toString().length == u.length))) {
                        this._setSelectionStart(r.start)
                    } else {
                        if (b) {
                            this._setSelectionStart(r.start + 1)
                        } else {
                            this._setSelectionStart(r.start - 1)
                        }
                    }
                }
                if (a.jqx.mobile.isTouchDevice()) {
                    this._raiseEvent(0, {})
                }
                this._raiseEvent(7, {});
                a.jqx.aria(self, "aria-valuenow", this.decimal)
            }
        },
        _getspindecimal: function() {
            var q = this._selection();
            var r = "";
            var n = this._getSeparatorPosition();
            var t = this._getVisibleItems();
            var e = this._getHiddenPrefixCount();
            var s = this.numberInput.val();
            if (this.numberInput.val().length == q.start && q.length == 0) {
                this._setSelection(q.start, q.start + 1);
                q = this._selection()
            }
            var l = this.inputMode != "advanced";
            for (var c = 0; c < q.start; c++) {
                if (l) {
                    var o = s.substring(c, c + 1);
                    var h = (!isNaN(parseInt(o)));
                    if (h) {
                        r += o
                    }
                    if (o == this.decimalSeparator) {
                        r += o
                    }
                    continue
                }
                if (t[c].canEdit && t[c].character != this.promptChar) {
                    r += t[c].character
                } else {
                    if (!t[c].canEdit && this.decimalSeparatorPosition != -1 && t[c] == t[this.decimalSeparatorPosition - e]) {
                        if (r.length == 0) {
                            r = "0"
                        }
                        r += t[c].character
                    }
                }
            }
            var g = "";
            for (var c = q.start; c < t.length; c++) {
                if (l) {
                    var o = s.substring(c, c + 1);
                    var h = (!isNaN(parseInt(o)));
                    if (h) {
                        g += o
                    }
                    if (o == this.decimalSeparator) {
                        g += o
                    }
                    continue
                }
                if (t[c].canEdit && t[c].character != this.promptChar) {
                    g += t[c].character
                } else {
                    if (!t[c].canEdit && this.decimalSeparatorPosition != -1 && t[c] == t[this.decimalSeparatorPosition - e]) {
                        g += t[c].character
                    }
                }
            }
            var b = this.getvalue("negative");
            var f = b ? "-" + this._parseDecimalValue(r).toString() : this._parseDecimalValue(r).toString();
            return {
                decimal: f,
                afterdecimal: this._parseDecimalValue(g)
            }
        },
        _parseDecimalValue: function(c) {
            if (this.decimalSeparator != ".") {
                var d = c.toString().indexOf(this.decimalSeparator);
                if (d >= 0) {
                    var b = c.toString().substring(0, d) + "." + c.toString().substring(d + 1);
                    return b
                }
            }
            return c
        },
        _parseDecimalValueToEditorValue: function(c) {
            if (this.decimalSeparator != ".") {
                var d = c.toString().indexOf(".");
                if (d >= 0) {
                    var b = c.toString().substring(0, d) + this.decimalSeparator + c.toString().substring(d + 1);
                    return b
                }
            }
            return c
        },
        spinUp: function() {
            var q = this;
            if (q.spinMode == "none") {
                return
            }
            if (this.decimal == null) {
                this.setDecimal(1);
                return
            }
            if (a.jqx.mobile.isTouchDevice() || this.inputMode == "textbox") {
                q._doTouchHandling()
            }
            var b = this.getvalue("negative");
            var u = b ? -1 : 0;
            if (!q.disabled) {
                var s = this._selection();
                var r = q.decimal;
                var n = q.getDecimal();
                if (n < this.min) {
                    n = this.min;
                    this.setDecimal(this.min);
                    this._setSelectionStart(s.start);
                    this.spinUp();
                    return
                } else {
                    if (n > this.max) {
                        n = this.max;
                        this.setDecimal(this.max);
                        this._setSelectionStart(s.start);
                        this.spinUp();
                        return
                    }
                }
                if (q.spinButtonsStep < 0) {
                    q.spinButtonsStep = 1
                }
                var d = parseInt(q.decimal) + q.spinButtonsStep;
                d = d.toString().length;
                var g = u + d <= q.digits;
                if (q.spinMode != "advanced") {
                    if (n + q.spinButtonsStep <= q.max && g) {
                        var w = 1;
                        for (var l = 0; l < q.decimalDigits; l++) {
                            w = w * 10
                        }
                        var f = (w * n) + (w * q.spinButtonsStep);
                        f = f / w;
                        f = this._parseDecimalValueToEditorValue(f);
                        q.setDecimal(f)
                    }
                } else {
                    var t = this._getspindecimal();
                    var o = this._getSeparatorPosition();
                    var n = parseFloat(t.decimal);
                    if (q.spinButtonsStep < 0) {
                        q.spinButtonsStep = 1
                    }
                    var d = parseInt(n) + q.spinButtonsStep;
                    d = d.toString().length;
                    var g = u + d <= q.digits;
                    var w = 1;
                    var c = t.decimal.indexOf(".");
                    if (c != -1) {
                        var h = t.decimal.length - c - 1;
                        var w = 1;
                        for (var l = 0; l < h; l++) {
                            w = w * 10
                        }
                        n += new Number(q.spinButtonsStep / w);
                        n = n.toFixed(h);
                        var c = n.toString().indexOf(".");
                        if (c == -1) {
                            n = n.toString() + "."
                        }
                        var v = n.toString() + t.afterdecimal;
                        v = new Number(v);
                        v = v.toFixed(q.decimalDigits);
                        var e = new Number(v).toFixed(q.decimalDigits);
                        if (e <= q.max) {
                            v = this._parseDecimalValueToEditorValue(v);
                            q.setDecimal(v)
                        } else {
                            v = undefined
                        }
                    } else {
                        if (n + q.spinButtonsStep <= q.max && g) {
                            var f = (w * n) + (w * q.spinButtonsStep);
                            f = f / w;
                            var v = f.toString() + t.afterdecimal;
                            var e = new Number(v).toFixed(q.decimalDigits);
                            if (e <= q.max) {
                                v = this._parseDecimalValueToEditorValue(v);
                                if (b && v.indexOf("-") == -1) {
                                    if (t.decimal != "-0") {
                                        v = "-" + v
                                    }
                                }
                                q.setDecimal(v)
                            } else {
                                v = undefined
                            }
                        }
                    }
                }
                if (v == undefined || this.inputMode != "simple") {
                    this._setSelectionStart(s.start);
                    q.savedValue = q.numberInput[0].value;
                    if (a.jqx.mobile.isTouchDevice()) {
                        this._raiseEvent(0, {})
                    }
                    this._raiseEvent(7, {});
                    a.jqx.aria(self, "aria-valuenow", this.decimal);
                    return
                }
                v = this.decimal.toString();
                var b = this.getvalue("negative");
                if (u == -1 && !b) {
                    this._setSelectionStart(-1 + s.start)
                } else {
                    if ((v != undefined && (r == undefined || r.toString().length == v.length))) {
                        this._setSelectionStart(s.start)
                    } else {
                        if (b) {
                            this._setSelectionStart(s.start)
                        } else {
                            this._setSelectionStart(1 + s.start)
                        }
                    }
                }
                if (a.jqx.mobile.isTouchDevice()) {
                    this._raiseEvent(0, {})
                }
                this._raiseEvent(7, {});
                a.jqx.aria(self, "aria-valuenow", this.decimal)
            }
        },
        _exitSimpleInputMode: function(b, o, h, d) {
            if (o == undefined) {
                o = b.data
            }
            if (o == null) {
                return
            }
            if (h == undefined) {
                if (b.target != null && o.element != null) {
                    if ((b.target.id != undefined && b.target.id.toString().length > 0 && o.host.find("#" + b.target.id).length > 0) || b.target == o.element) {
                        return
                    }
                }
                var f = o.host.offset();
                var e = f.left;
                var g = f.top;
                var c = o.host.width();
                var n = o.host.height();
                var q = a(b.target).offset();
                if (q.left >= e && q.left <= e + c) {
                    if (q.top >= g && q.top <= g + n) {
                        return
                    }
                }
            }
            if (a.jqx.mobile.isOperaMiniBrowser()) {
                o.numberInput.attr("readonly", true)
            }
            if (o.disabled || o.readOnly) {
                return
            }
            var l = a.data(o.numberInput, "simpleInputMode");
            if (l == null) {
                return
            }
            a.data(o.numberInput, "simpleInputMode", null);
            this._parseDecimalInSimpleMode();
            return false
        },
        _getDecimalInSimpleMode: function() {
            var d = this.decimal;
            if (this.decimalSeparator != ".") {
                var b = d.toString().indexOf(this.decimalSeparator);
                if (b > 0) {
                    var c = d.toString().substring(0, b);
                    var d = c + "." + d.toString().substring(b + 1)
                }
            }
            return d
        },
        _parseDecimalInSimpleMode: function(d) {
            var o = this;
            var b = o.getvalue("negative");
            var e = this.ValueString;
            if (e == undefined) {
                e = this.GetValueString(this.numberInput.val(), this.decimalSeparator, this.decimalSeparator != "")
            }
            if (this.decimalSeparator != ".") {
                var g = e.toString().indexOf(".");
                if (g > 0) {
                    var f = e.toString().substring(0, g);
                    var c = f + this.decimalSeparator + e.toString().substring(g + 1);
                    e = c
                }
            }
            var h = b ? "-" : "";
            if (this.symbolPosition == "left") {
                h += this.symbol
            }
            var l = this.digits % this.groupSize;
            if (l == 0) {
                l = this.groupSize
            }
            var n = e.toString();
            if (n.indexOf("-") >= 0) {
                n = n.substring(n.indexOf("-") + 1)
            }
            h += n;
            if (this.symbolPosition == "right") {
                h += this.symbol
            }
            if (d != false) {
                o.numberInput.val(h)
            }
        },
        _enterSimpleInputMode: function(f, d) {
            if (d == undefined) {
                d = f.data
            }
            var e = this._selection();
            if (d == null) {
                return
            }
            var c = d.getvalue("negative");
            var b = d.decimal;
            if (c) {
                if (b > 0) {
                    b = -b
                }
            }
            d.numberInput.val(b);
            a.data(d.numberInput, "simpleInputMode", true);
            if (a.jqx.mobile.isOperaMiniBrowser()) {
                d.numberInput.attr("readonly", false)
            }
            this._parseDecimalInSimpleMode();
            this._setSelectionStart(e.start)
        },
        setvalue: function(b, c) {
            if (this[b] !== undefined) {
                if (b == "decimal") {
                    this._setDecimal(c)
                } else {
                    this[b] = c;
                    this.propertyChangedHandler(this, b, c, c)
                }
            }
        },
        getvalue: function(b) {
            if (b == "decimal") {
                if (this.negative != undefined && this.negative == true) {
                    return -Math.abs(this[b])
                }
            }
            if (b in this) {
                return this[b]
            }
            return null
        },
        _getString: function() {
            var c = "";
            for (var b = 0; b < this.items.length; b++) {
                var d = this.items[b].character;
                c += d
            }
            return c
        },
        _literal: function(d, b, c, e) {
            return {
                character: d,
                regex: b,
                canEdit: c,
                isSeparator: e
            }
        },
        _initializeLiterals: function() {
            if (this.inputMode == "textbox") {
                return
            }
            var h = 0;
            var e = this.negativeSymbol.length;
            for (var d = 0; d < e; d++) {
                var g = this.negativeSymbol.substring(d, d + 1);
                var n = "";
                var b = false;
                var o = null;
                if (this.negative) {
                    o = this._literal(g, n, b, false)
                } else {
                    o = this._literal("", n, b, false)
                }
                this.items[h] = o;
                h++
            }
            var c = this.symbol.length;
            if (this.symbolPosition == "left") {
                for (d = 0; d < c; d++) {
                    var g = this.symbol.substring(d, d + 1);
                    var n = "";
                    var b = false;
                    var o = this._literal(g, n, b, false);
                    this.items[h] = o;
                    h++
                }
            }
            var f = this.digits % this.groupSize;
            if (f == 0) {
                f = this.groupSize
            }
            for (var d = 0; d < this.digits; d++) {
                var g = this.promptChar;
                var n = "\\d";
                var b = true;
                var o = this._literal(g, n, b, false);
                this.items[h] = o;
                h++;
                if (d < this.digits - 1 && this.groupSeparator != undefined && this.groupSeparator.length > 0) {
                    f--;
                    if (f == 0) {
                        f = this.groupSize;
                        var l = this._literal(this.groupSeparator, "", false, false);
                        this.items[h] = l;
                        h++
                    }
                } else {
                    if (d == this.digits - 1) {
                        o.character = 0
                    }
                }
            }
            this.decimalSeparatorPosition = -1;
            if (this.decimalDigits != undefined && this.decimalDigits > 0) {
                var g = this.decimalSeparator;
                if (g.length == 0) {
                    g = "."
                }
                var o = this._literal(g, "", false, true);
                this.items[h] = o;
                this.decimalSeparatorPosition = h;
                h++;
                for (var d = 0; d < this.decimalDigits; d++) {
                    var r = 0;
                    var n = "\\d";
                    var q = this._literal(r, n, true, false);
                    this.items[h] = q;
                    h++
                }
            }
            if (this.symbolPosition == "right") {
                for (var d = 0; d < c; d++) {
                    var g = this.symbol.substring(d, d + 1);
                    var n = "";
                    var b = false;
                    var o = this._literal(g, n, b);
                    this.items[h] = o;
                    h++
                }
            }
        },
        _match: function(c, b) {
            var d = new RegExp(b, "i");
            return d.test(c)
        },
        _raiseEvent: function(r, d) {
            var o = this.events[r];
            var c = {};
            c.owner = this;
            if (this.host.css("display") == "none") {
                return true
            }
            var x = d.charCode ? d.charCode : d.keyCode ? d.keyCode : 0;
            var f = true;
            var h = this.readOnly;
            var v = this;
            if (r == 3 || r == 2) {
                if (!this.disabled) {
                    if (this.inputMode != "simple" && this.inputMode != "textbox") {
                        this._handleMouse(d)
                    } else {
                        return true
                    }
                }
            }
            if (r == 0) {
                var g = this.getvalue("decimal");
                if ((this.max < g) || (this.min > g)) {
                    this.host.addClass(this.toThemeProperty("jqx-input-invalid"))
                } else {
                    this.host.removeClass(this.toThemeProperty("jqx-input-invalid"));
                    this.host.addClass(this.toThemeProperty("jqx-input"));
                    this.host.addClass(this.toThemeProperty("jqx-rc-all"))
                }
            }
            var s = new a.Event(o);
            s.owner = this;
            c.value = this.getvalue("decimal");
            c.text = this.numberInput.val();
            s.args = c;
            if (o != undefined) {
                if (r != 4 && r != 5 && r != 6) {
                    f = this.host.trigger(s)
                }
            }
            var v = this;
            if (this.inputMode == "textbox") {
                return f
            }
            if (this.inputMode != "simple") {
                if (r == 4) {
                    if (h || this.disabled) {
                        return false
                    }
                    f = v._handleKeyDown(d, x)
                } else {
                    if (r == 5) {
                        if (h || this.disabled) {
                            f = false
                        }
                    } else {
                        if (r == 6) {
                            if (h || this.disabled) {
                                return false
                            }
                            f = v._handleKeyPress(d, x)
                        }
                    }
                }
            } else {
                if (r == 4 || r == 5 || r == 6) {
                    if (a.jqx.mobile.isTouchDevice() || this.touchMode === true) {
                        return true
                    }
                    if (h || this.disabled) {
                        return false
                    }
                    var w = String.fromCharCode(x);
                    var q = parseInt(w);
                    var t = true;
                    if (!d.ctrlKey && !d.shiftKey && !d.metaKey) {
                        if (x >= 65 && x <= 90) {
                            t = false
                        }
                    }
                    if (r == 6 && a.jqx.browser.opera != undefined) {
                        if (x == 8) {
                            return false
                        }
                    }
                    if (t) {
                        if (r == 4) {
                            t = v._handleSimpleKeyDown(d, x)
                        }
                        if (x == 189 || x == 45 || x == 109 || x == 173) {
                            var y = v._selection();
                            if (r == 4) {
                                var l = v.getvalue("negative");
                                if (l == false) {
                                    v.setvalue("negative", true)
                                } else {
                                    v.setvalue("negative", false)
                                }
                                v.decimal = v.ValueString;
                                v._parseDecimalInSimpleMode();
                                v._setSelectionStart(y.start);
                                t = false;
                                v._raiseEvent(0, v.value);
                                v._raiseEvent(1, v.numberInput.val())
                            }
                        }
                        var b = c.ctrlKey || c.metaKey;
                        if (!a.jqx.browser.msie) {
                            var u = d;
                            if ((b && x == 99) || (b && x == 67) || (b && x == 122) || (b && x == 90) || (b && x == 118) || (b && x == 86) || (u.shiftKey && x == 45)) {
                                if (a.jqx.browser.webkit || a.jqx.browser.chrome) {
                                    v._handleSimpleKeyDown(d, x)
                                }
                                if (x == 67) {
                                    return true
                                }
                                return false
                            }
                        }
                        if ((b && x == 97) || (b && x == 65)) {
                            return true
                        }
                        if (r == 6 && t) {
                            var n = this._isSpecialKey(x);
                            return n
                        }
                    }
                    return t
                }
            }
            return f
        },
        GetSelectionInValue: function(h, g, f, e) {
            var c = 0;
            for (i = 0; i < g.length; i++) {
                if (i >= h) {
                    break
                }
                var d = g.substring(i, i + 1);
                var b = (!isNaN(parseInt(d)));
                if (b || (e && g.substring(i, i + 1) == f)) {
                    c++
                }
            }
            return c
        },
        GetSelectionLengthInValue: function(g, h, f, e) {
            var c = 0;
            for (i = 0; i < f.length; i++) {
                if (i >= g + h) {
                    break
                }
                var d = f.substring(i, i + 1);
                var b = (!isNaN(parseInt(d)));
                if (h > 0 && i >= g && b || (i >= g && f[i].toString() == e)) {
                    c++
                }
            }
            return c
        },
        GetInsertTypeByPositionInValue: function(e, g, h, f) {
            var c = "before";
            var b = this.GetValueString(h, g, f);
            var d = this.GetDigitsToSeparator(0, b, g);
            if (e > d) {
                c = "after"
            }
            return c
        },
        RemoveRange: function(f, e, q, g, w, b) {
            var h = this.digits;
            var r = f;
            var x = e;
            var c = 0;
            var s = this.decimal;
            var B = this._selection();
            var q = this.numberInput.val();
            var g = this.decimalSeparator;
            var l = g != "";
            if (x == 0 && this.ValueString.length < this.decimalPossibleChars - 1) {
                return c
            }
            var y = this.GetSeparatorPositionInText(g, q);
            if (!w) {
                y = this.GetSeparatorPositionInText(g, q)
            }
            if (y < 0 && !l && q.length > 1) {
                y = q.length
            }
            if (y == -1) {
                y = q.length
            }
            var d = l ? 1 : 0;
            if (e < 2 && b == true) {
                var A = this.ValueString.length - this.decimalDigits - d;
                if ((A) == h && f + e < y) {
                    x++
                }
            }
            var n = "";
            for (var v = 0; v < q.length; v++) {
                if (v < r || v >= r + x) {
                    n += q.substring(v, v + 1);
                    continue
                } else {
                    var u = q.substring(v, v + 1);
                    if (u == g) {
                        n += g;
                        continue
                    } else {
                        var u = q.substring(v, v + 1);
                        if (this.symbol && this.symbol != "" && this.symbol.indexOf(u) >= 0) {
                            continue
                        }
                        if (v > y) {
                            n += "0";
                            continue
                        }
                    }
                }
                var u = q.substring(v, v + 1);
                var t = (!isNaN(parseInt(u)));
                if (t) {
                    c++
                }
            }
            if (n.length == 0) {
                n = "0"
            }
            if (w) {
                this.numberInput.val(n)
            } else {
                this.ValueString = n
            }
            var o = n.substring(0, 1);
            if (o == g && isNaN(parseInt(o))) {
                var z = "0" + n;
                n = z
            }
            this.ValueString = this.GetValueString(n, g, l);
            this.decimal = this.ValueString;
            this._parseDecimalInSimpleMode();
            this._setSelectionStart(r);
            return c
        },
        InsertDigit: function(v, B) {
            if (typeof this.digits != "number") {
                this.digits = parseInt(this.digits)
            }
            if (typeof this.decimalDigits != "number") {
                this.decimalDigits = parseInt(this.decimalDigits)
            }
            var l = 1 + this.digits;
            var C = this._selection();
            var q = this.getvalue("negative");
            var d = false;
            if (C.start == 0 && this.symbol != "" && this.symbolPosition == "left") {
                this._setSelectionStart(C.start + 1);
                C = this._selection();
                d = true
            }
            if ((q && d) || (q && !d && C.start == 0)) {
                this._setSelectionStart(C.start + 1);
                C = this._selection()
            }
            var z = this.numberInput.val().substring(C.start, C.start + 1);
            var s = this.numberInput.val();
            var g = this.decimalSeparator;
            var n = g != "" && this.decimalDigits > 0;
            if (z == this.symbol && this.symbolPosition == "right") {
                if (this.decimalDigits == 0) {
                    this.ValueString = this.GetValueString(s, g, n);
                    if (this.ValueString.length >= l) {
                        return
                    }
                } else {
                    return
                }
            }
            this.ValueString = this.GetValueString(s, g, n);
            if (this.ValueString == "") {
                this.ValueString = new Number(0).toFixed(this.decimalDigits)
            }
            var y = this.ValueString;
            if (this.decimalDigits > 0 && B >= y.length) {
                B = y.length - 1
            }
            var t = "";
            if (B < y.length) {
                t = y.substring(B, B + 1)
            }
            var h = false;
            var A = false;
            var e = this.GetInsertTypeByPositionInValue(B, g, s, n);
            if (e == "after") {
                h = true
            }
            var b = n ? 1 : 0;
            if (t != g && (this.ValueString.length - this.decimalDigits - b) >= l - 1) {
                h = true
            }
            if (t === "0" && this.ValueString.length === 1 && this.decimalDigits === 0) {
                h = true
            }
            var u = false;
            var w = n ? 1 : 0;
            if (!h && this.ValueString && this.ValueString.length >= this.digits + this.decimalDigits + w) {
                return
            }
            if (h && t != g) {
                if (u) {
                    B++
                }
                var r = y.substring(0, B);
                if (r.length == y.length) {
                    if (this.ValueString.length >= this.digits + this.decimalDigits + w) {
                        return
                    }
                }
                var x = v;
                var c = "";
                if (B + 1 < y.length) {
                    c = y.substring(B + 1)
                }
                var o = r + x + c;
                this.ValueString = o
            } else {
                var r = y.substring(0, B);
                var x = v;
                var c = y.substring(B);
                var o = r + x + c;
                if (y.substring(0, 1) == "0" && y.substring(1, 2) == g) {
                    o = x + y.substring(1);
                    if (t == g) {
                        this._setSelectionStart(C.start - 1);
                        C = this._selection()
                    }
                }
                this.ValueString = o
            }
            if (q) {
                this.decimal = -this.ValueString
            } else {
                this.decimal = this.ValueString
            }
            this._parseDecimalInSimpleMode();
            var f = C.start;
            f += 1;
            this._setSelectionStart(f);
            this.value = this.decimal;
            this._raiseEvent(0, this.value);
            this._raiseEvent(1, this.numberInput.val())
        },
        GetStringToSeparator: function(h, f, e) {
            var d = "";
            var b = f;
            var g = this.GetSeparatorPositionInText(f, h);
            var c = h.subString(0, g);
            d = this.GetValueString(c, f, e);
            return d
        },
        GetSeparatorPositionInText: function(c, d) {
            var b = -1;
            for (i = 0; i < d.length; i++) {
                if (d.substring(i, i + 1) == c) {
                    b = i;
                    break
                }
            }
            return b
        },
        GetValueString: function(h, g, f) {
            var d = "";
            for (var c = 0; c < h.length; c++) {
                var e = h.substring(c, c + 1);
                var b = (!isNaN(parseInt(e)));
                if (b) {
                    d += e
                }
                if (e == g) {
                    d += g
                }
            }
            return d
        },
        Backspace: function() {
            var d = this._selection();
            var e = this._selection();
            var f = this.numberInput.val();
            if (d.start == 0 && d.length == 0) {
                return
            }
            this.isBackSpace = true;
            var c = f.substring[d.start, d.start + 1];
            var b = (!isNaN(parseInt(c)));
            if (d.start > 0 && d.length == 0) {
                this._setSelectionStart(d.start - 1);
                var d = this._selection()
            }
            this.Delete();
            this._setSelectionStart(e.start - 1);
            this.isBackSpace = false
        },
        Delete: function(c) {
            var e = this._selection();
            var g = this.numberInput.val();
            if (e.start === 0 && g.substring(0, 1) == "-") {
                this.setvalue("negative", false);
                var e = this._selection();
                var g = this.numberInput.val()
            }
            var f = e.start;
            var h = e.length;
            h = Math.max(h, 1);
            this.ValueString = this.GetValueString(g, this.decimalSeparator, this.decimalSeparator != "");
            this.RemoveRange(e.start, h, this.ValueString, ".", false);
            var d = this.ValueString.substring(0, 1);
            var b = (!isNaN(parseInt(d)));
            if (!b) {
                this.ValueString = "0" + this.ValueString
            }
            this.decimal = this.ValueString;
            this._parseDecimalInSimpleMode();
            this._setSelectionStart(f);
            this.value = this.decimal;
            this._raiseEvent(0, this.value);
            this._raiseEvent(1, this.numberInput.val())
        },
        insertsimple: function(d) {
            var l = this._selection();
            var n = this.numberInput.val();
            if (l.start == n.length && this.decimal != null && this.decimalDigits > 0) {
                return
            }
            var b = this.decimal;
            var g = this.decimalSeparator;
            this.ValueString = this.GetValueString(n, g, g != "");
            var h = this.GetSelectionInValue(l.start, n, g, g != "");
            var e = this.GetSelectionLengthInValue(l.start, l.length, n, g);
            var f = this.GetDigitsToSeparator(0, this.ValueString, g);
            var c = false;
            if (this.decimalDigits > 0 && h >= this.ValueString.length) {
                h--
            }
            if (this.ValueString == "") {
                this.ValueString = new Number(0).toFixed(this.decimalDigits);
                this.InsertDigit(d, h, l);
                return
            }
            this.RemoveRange(l.start, e, this.ValueString, g, false, true);
            this.InsertDigit(d, h, l)
        },
        GetDigitsToSeparator: function(c, b, d) {
            if (d == undefined) {
                d = "."
            }
            if (b.indexOf(d) < 0) {
                return b.length
            }
            for (i = 0; i < b.length; i++) {
                if (b.substring(i, i + 1) == d) {
                    c = i;
                    break
                }
            }
            return c
        },
        _handleSimpleKeyDown: function(n, v) {
            var u = this._selection();
            var b = n.ctrlKey || n.metaKey;
            if ((v == 8 || v == 46) && b) {
                this.setDecimal(null);
                return false
            }
            if (u.start >= 0 && u.start < this.items.length) {
                var d = String.fromCharCode(v)
            }
            if (this.rtl && v == 37) 
			{
                var c = n.shiftKey;
                var g = c ? 1 : 0;
                if (c) {
                    this._setSelection(u.start + 1 - g, u.start + u.length + 1)
                } else {
                    this._setSelection(u.start + 1 - g, u.start + 1)
                }
                return false
            } else {
                if (this.rtl && v == 39) 
				{
                    var c = n.shiftKey;
                    var g = c ? 1 : 0;
                    if (c) {
                        this._setSelection(u.start - 1, u.length + g + u.start - 1)
                    } else {
                        this._setSelection(u.start - 1, u.start - 1)
                    }
                    return false
                }
            }
            if (v == 8) {
                this.Backspace();
                return false
            }
            if (v == 190 || v == 110) {
                var l = this.GetSeparatorPositionInText(this.decimalSeparator, this.numberInput.val());
                if (l != -1) {
                    this._setSelectionStart(l + 1)
                }
                return false
            }
            if (v == 188) {
                var t = this.numberInput.val();
                for (h = u.start; h < t.length; h++) {
                    if (t[h] == this.groupSeparator) {
                        this._setSelectionStart(1 + h);
                        break
                    }
                }
                return false
            }
            var b = n.ctrlKey || n.metaKey;
            if ((b && v == 99) || (b && v == 67)) {
                var u = this._selection();
                var w = "";
                var s = this.numberInput.val();
                if (u.start > 0 || u.length > 0) {
                    for (var h = u.start; h < u.end; h++) {
                        w += s.substring(h, h + 1)
                    }
                }
                a.data(document.body, "jqxSelection", w);
                if (a.jqx.browser.msie) {
                    window.clipboardData.setData("Text", w)
                } else {
                    var o = this;
                    var f = a('<textarea style="position: absolute; left: -1000px; top: -1000px;"/>');
                    f.val(w);
                    a("body").append(f);
                    f.select();
                    setTimeout(function() {
                        document.designMode = "off";
                        f.select();
                        f.remove();
                        o.focus()
                    }, 100)
                }
                this.savedText = w;
                return true
            }
            if ((b && v == 122) || (b && v == 90)) {
                return false
            }
            if ((b && v == 118) || (b && v == 86) || (n.shiftKey && v == 45)) {
                if (a.jqx.browser.msie && !this.savedText) {
                    this.savedText = window.clipboardData.getData("Text")
                }
                if (this.savedText != null && this.savedText.length > 0) {
                    this.val(this.savedText)
                } else {
                    this.val(a.data(document.body, "jqxSelection"))
                }
                return false
            }
            var d = String.fromCharCode(v);
            var q = parseInt(d);
            if (v >= 96 && v <= 105) {
                q = v - 96;
                v = v - 48
            }
            if (!isNaN(q)) {
                var o = this;
                this.insertsimple(q);
                return false
            }
            if (v == 46) {
                this.Delete();
                return false
            }
			/*
            if (v == 38) {
                //yukari
				//this.spinUp();
                return false
            } else {
                if (v == 40) {
					//asagi
                    //this.spinDown();
                    return false
                }
            }
			*/
            var r = this._isSpecialKey(v);
            if (!a.jqx.browser.mozilla) {
                return true
            }
            return r
        },
        _getEditRange: function() {
            var c = 0;
            var b = 0;
            for (i = 0; i < this.items.length; i++) {
                if (this.items[i].canEdit) {
                    c = i;
                    break
                }
            }
            for (i = this.items.length - 1; i >= 0; i--) {
                if (this.items[i].canEdit) {
                    b = i;
                    break
                }
            }
            return {
                start: c,
                end: b
            }
        },
        _getVisibleItems: function() {
            var b = new Array();
            var c = 0;
            for (i = 0; i < this.items.length; i++) {
                if (this.items[i].character.toString().length > 0) {
                    b[c] = this.items[i];
                    c++
                }
            }
            return b
        },
        _hasEmptyVisibleItems: function() {
            var b = this._getVisibleItems();
            for (i = 0; i < b.length; i++) {
                if (b[i].canEdit && b[i].character == this.promptChar) {
                    return true
                }
            }
            return false
        },
        _getFirstVisibleNonEmptyIndex: function() {
            var b = this._getVisibleItems();
            for (i = 0; i < b.length; i++) {
                if (b[i].canEdit && b[i].character != this.promptChar) {
                    return i
                }
            }
        },
        _handleMouse: function(f, b) {
            var d = this._selection();
            if (d.length <= 1) {
                var c = this._getFirstVisibleNonEmptyIndex();
                if (d.start < c) {
                    this._setSelectionStart(c)
                }
            }
        },
        _insertKey: function(l) {
            this.numberInput[0].focus();
            var d = String.fromCharCode(l);
            var e = parseInt(d);
            if (isNaN(e)) {
                return
            }
            var q = 0;
            for (i = 0; i < this.items.length; i++) {
                if (this.items[i].character.length == 0) {
                    q++
                }
            }
            var g = this._selection();
            var b = this;
            if (g.start >= 0 && g.start <= this.items.length) {
                var f = false;
                var h = this._getFirstVisibleNonEmptyIndex();
                if (g.start < h && g.length == 0) {
                    if (!isNaN(d) || d == " ") {
                        this._setSelectionStart(h);
                        g = this._selection()
                    }
                }
                var c = this._getFirstEditableItemIndex();
                var o = this._getLastEditableItemIndex();
                var n = this._getVisibleItems();
                a.each(n, function(x, B) {
                    if (g.start > x && x != n.length - 1) {
                        return
                    }
                    var E = n[x];
                    if (x > o) {
                        E = n[o]
                    }
                    if (isNaN(d) || d == " ") {
                        return
                    }
                    if (!E.canEdit) {
                        return
                    }
                    var A = b._getSeparatorPosition();
                    if (b._match(d, E.regex)) {
                        if (!f && g.length > 0) {
                            for (j = g.start + q; j < g.end + q; j++) {
                                if (b.items[j].canEdit) {
                                    if (j > A) {
                                        b.items[j].character = "0"
                                    } else {
                                        b.items[j].character = b.promptChar
                                    }
                                }
                            }
                            var D = b._getString();
                            f = true
                        }
                        var A = b._getSeparatorPosition();
                        var y = b._hasEmptyVisibleItems();
                        if (b.decimal == null) {
                            g.start = A - 1;
                            if (g.start < 0) {
                                g.start = 0
                            }
                            g.end = g.start
                        }
                        if (g.start <= A && y) {
                            var v = x;
                            if (b.decimalSeparatorPosition == -1 && g.start == A) {
                                v = x + 1
                            }
                            if (b.decimal == null) {
                                v = g.start
                            }
                            var u = "";
                            for (p = 0; p < v; p++) {
                                if (n[p].canEdit && n[p].character != b.promptChar) {
                                    u += n[p].character
                                }
                            }
                            u += d;
                            var w = b.decimal < 1 ? 1 : 0;
                            if (g.start == A && b.decimalSeparatorPosition != -1) {
                                u += b.decimalSeparator;
                                w = 0
                            }
                            for (p = v + w; p < n.length; p++) {
                                if (n[p].character == b.decimalSeparator && n[p].isSeparator) {
                                    u += n[p].character
                                } else {
                                    if (n[p].canEdit && n[p].character != b.promptChar) {
                                        u += n[p].character
                                    }
                                }
                            }
                            if (b.decimalSeparator != ".") {
                                u = b._parseDecimalValue(u)
                            }
                            u = parseFloat(u).toString();
                            u = new Number(u);
                            u = u.toFixed(b.decimalDigits);
                            if (b.decimalSeparator != ".") {
                                u = b._parseDecimalValueToEditorValue(u)
                            }
                            b.setvalue("decimal", u);
                            var D = b._getString();
                            if (g.end < A) {
                                b._setSelectionStart(g.end + w)
                            } else {
                                b._setSelectionStart(g.end)
                            }
                            if (g.length >= 1) {
                                b._setSelectionStart(g.end)
                            }
                            if (g.length == b.numberInput.val().length) {
                                var r = b._moveCaretToDecimalSeparator();
                                var C = b.decimalSeparatorPosition >= 0 ? 1 : 0;
                                b._setSelectionStart(r - C)
                            }
                        } else {
                            if (g.start < A || g.start > A) {
                                if (b.numberInput.val().length == g.start && b.decimalSeparatorPosition != -1) {
                                    return false
                                } else {
                                    if (b.numberInput.val().length == g.start && b.decimalSeparatorPosition == -1 && !y) {
                                        return false
                                    }
                                }
                                var u = "";
                                var s = false;
                                for (p = 0; p < x; p++) {
                                    if (n[p].canEdit && n[p].character != b.promptChar) {
                                        u += n[p].character
                                    }
                                    if (n[p].character == b.decimalSeparator && n[p].isSeparator) {
                                        u += n[p].character;
                                        s = true
                                    }
                                }
                                u += d;
                                var w = b.decimal < 1 ? 1 : 0;
                                if (!s && g.start == A - 1) {
                                    u += b.decimalSeparator;
                                    s = true
                                }
                                for (p = x + 1; p < n.length; p++) {
                                    if (!s && n[p].character == b.decimalSeparator && n[p].isSeparator) {
                                        u += n[p].character
                                    } else {
                                        if (n[p].canEdit && n[p].character != b.promptChar) {
                                            u += n[p].character
                                        }
                                    }
                                }
                                b.setvalue("decimal", u);
                                var D = b._getString();
                                if (b.decimalSeparatorPosition < 0 && E == n[o]) {
                                    b._setSelectionStart(x);
                                    return false
                                }
                                var z = D.indexOf(b.symbol);
                                var t = !b.getvalue("negative") ? 0 : 1;
                                if (z <= t) {
                                    z = D.length
                                }
                                if (g.start < z) {
                                    b._setSelectionStart(x + 1)
                                } else {
                                    b._setSelectionStart(x)
                                }
                                if (g.length >= 1) {}
                                if (g.length == b.numberInput.val().length) {
                                    var r = b._moveCaretToDecimalSeparator();
                                    b._setSelectionStart(r - 1)
                                }
                            }
                        }
                        return false
                    }
                })
            }
        },
        _handleKeyPress: function(h, d) {
            var f = this._selection();
            var b = this;
            var l = h.ctrlKey || h.metaKey;
            if ((l && d == 97) || (l && d == 65)) {
                return true
            }
            if (d == 8) {
                if (f.start > 0) {
                    b._setSelectionStart(f.start)
                }
                return false
            }
            if (d == 46) {
                if (f.start < this.items.length) {
                    b._setSelectionStart(f.start)
                }
                return false
            }
            if (!a.jqx.browser.mozilla) {
                if (d == 45 || d == 173 || d == 109 || d == 189) {
                    var c = this.getvalue("negative");
                    if (c == false) {
                        this.setvalue("negative", true)
                    } else {
                        this.setvalue("negative", false)
                    }
                }
            }
            if (a.jqx.browser.msie) {
                this._insertKey(d)
            }
            var g = this._isSpecialKey(d);
            return g
        },
        _deleteSelectedText: function() {
            var d = this._selection();
            var c = "";
            var f = this._getSeparatorPosition();
            var b = this._getVisibleItems();
            var e = this._getHiddenPrefixCount();
            if (this.numberInput.val().length == d.start && d.length == 0) {
                this._setSelection(d.start, d.start + 1);
                d = this._selection()
            }
            for (i = 0; i < d.start; i++) {
                if (b[i].canEdit && b[i].character != this.promptChar) {
                    c += b[i].character
                } else {
                    if (!b[i].canEdit && this.decimalSeparatorPosition != -1 && b[i] == b[this.decimalSeparatorPosition - e]) {
                        if (c.length == 0) {
                            c = "0"
                        }
                        c += b[i].character
                    }
                }
            }
            for (i = d.start; i < d.end; i++) {
                if (i > f && this.decimalSeparatorPosition != -1) {
                    if (b[i].canEdit && b[i].character != this.promptChar) {
                        c += "0"
                    }
                } else {
                    if (!b[i].canEdit && this.decimalSeparatorPosition != -1 && b[i] == b[this.decimalSeparatorPosition - e]) {
                        if (c.length == 0) {
                            c = "0"
                        }
                        c += b[i].character
                    }
                }
            }
            for (i = d.end; i < b.length; i++) {
                if (b[i].canEdit && b[i].character != this.promptChar) {
                    c += b[i].character
                } else {
                    if (!b[i].canEdit && this.decimalSeparatorPosition != -1 && b[i] == b[this.decimalSeparatorPosition - e]) {
                        if (c.length == 0) {
                            c = "0"
                        }
                        c += b[i].character
                    }
                }
            }
            this.setvalue("decimal", c);
            return d.length > 0
        },
        _restoreInitialState: function() {
            var b = parseInt(this.decimalDigits);
            if (b > 0) {
                b += 2
            }
            for (k = this.items.length - 1; k > this.items.length - 1 - b; k--) {
                if (this.items[k].canEdit && this.items[k].character == this.promptChar) {
                    this.items[k].character = 0
                }
            }
        },
        clear: function() {
            this.setDecimal(0)
        },
        clearDecimal: function() {
            if (this.inputMode == "textbox") {
                this.numberInput.val();
                return
            }
            for (var b = 0; b < this.items.length; b++) {
                if (this.items[b].canEdit) {
                    this.items[b].character = this.promptChar
                }
            }
            this._restoreInitialState()
        },
        _saveSelectedText: function() {
            var c = this._selection();
            var d = "";
            var b = this._getVisibleItems();
            if (c.start > 0 || c.length > 0) {
                for (i = c.start; i < c.end; i++) {
                    if (b[i].canEdit && b[i].character != this.promptChar) {
                        d += b[i].character
                    } else {
                        if (b[i].isSeparator) {
                            d += b[i].character
                        }
                    }
                }
            }
            if (a.jqx.browser.msie) {
                window.clipboardData.setData("Text", d)
            }
            return d
        },
        _pasteSelectedText: function() {
            var f = this._selection();
            var h = "";
            var c = 0;
            this.selectedText = a.data(document.body, "jqxSelection");
            if (window.clipboardData) {
                var d = window.clipboardData.getData("Text");
                if (d != this.selectedText && d.length > 0) {
                    this.selectedText = window.clipboardData.getData("Text");
                    if (this.selectedText == null || this.selectedText == undefined) {
                        return
                    }
                }
            }
            var e = f.start;
            var n = this._getVisibleItems();
            if (this.selectedText != null) {
                for (var l = 0; l < this.selectedText.length; l++) {
                    var b = parseInt(this.selectedText[l]);
                    if (!isNaN(b)) {
                        var g = 48 + b;
                        this._insertKey(g)
                    }
                }
            }
        },
        _getHiddenPrefixCount: function() {
            var b = 0;
            if (!this.negative) {
                b++
            }
            if (this.symbolPosition == "left") {
                for (i = 0; i < this.symbol.length; i++) {
                    if (this.symbol.substring(i, i + 1) == "") {
                        b++
                    }
                }
            }
            return b
        },
        _getEditableItem: function() {
            var b = this._selection();
            for (i = 0; i < this.items.length; i++) {
                if (i < b.start) {
                    if (this.items[i].canEdit && this.items[i].character != this.promptChar) {
                        return this.items[i]
                    }
                }
            }
            return null
        },
        _getEditableItems: function() {
            var c = new Array();
            var b = 0;
            for (i = 0; i < this.items.length; i++) {
                if (this.items[i].canEdit) {
                    c[b] = this.items[i];
                    b++
                }
            }
            return c
        },
        _getValidSelectionStart: function(b) {
            for (i = this.items.length - 1; i >= 0; i--) {
                if (this.items[i].canEdit && this.items[i].character != this.promptChar) {
                    return i
                }
            }
            return -1
        },
        _getEditableItemIndex: function(c) {
            var e = this._selection();
            var f = this._getHiddenPrefixCount();
            var b = this._getVisibleItems();
            var d = e.start;
            var g = -1;
            for (i = 0; i < d; i++) {
                if (i < b.length && b[i].canEdit) {
                    g = i + f
                }
            }
            if (g == -1 && e.length > 0) {
                d = e.end;
                for (i = 0; i < d; i++) {
                    if (i < b.length && b[i].canEdit) {
                        g = i + f;
                        break
                    }
                }
            }
            return g
        },
        _getEditableItemByIndex: function(b) {
            for (k = 0; k < this.items.length; k++) {
                if (k > b) {
                    if (this.items[k].canEdit && this.items[k].character != this.promptChar) {
                        return k
                    }
                }
            }
            return -1
        },
        _getFirstEditableItemIndex: function() {
            var b = this._getVisibleItems();
            for (m = 0; m < b.length; m++) {
                if (b[m].character != this.promptChar && b[m].canEdit && b[m].character != "0") {
                    return m
                }
            }
            return -1
        },
        _getLastEditableItemIndex: function() {
            var b = this._getVisibleItems();
            for (m = b.length - 1; m >= 0; m--) {
                if (b[m].character != this.promptChar && b[m].canEdit) {
                    return m
                }
            }
            return -1
        },
        _moveCaretToDecimalSeparator: function() {
            for (i = this.items.length - 1; i >= 0; i--) {
                if (this.items[i].character == this.decimalSeparator && this.items[i].isSeparator) {
                    if (!this.negative) {
                        this._setSelectionStart(i);
                        return i
                    } else {
                        this._setSelectionStart(i + 1);
                        return i
                    }
                    break
                }
            }
            return this.numberInput.val().length
        },
        _handleBackspace: function() {
            var g = this._selection();
            var h = this._getHiddenPrefixCount();
            var b = this._getEditableItemIndex() - h;
            var f = this._getFirstVisibleNonEmptyIndex();
            var c = false;
            if (this.negative) {
                c = true;
                if (f >= b + 1 || g.start == 0) {
                    this.setvalue("negative", false);
                    if (g.length == 0) {
                        this._setSelectionStart(g.start - 1);
                        var g = this._selection()
                    }
                }
            }
            if (b >= 0) {
                if (g.length == 0 && b != -1) {
                    this._setSelection(b, b + 1)
                }
                var l = g.start > this._getSeparatorPosition() + 1 && this.decimalSeparatorPosition > 0;
                if (l) {
                    g = this._selection()
                }
                var e = this._deleteSelectedText();
                if (g.length < 1 || l) {
                    this._setSelectionStart(g.start)
                } else {
                    if (g.length >= 1) {
                        this._setSelectionStart(g.end)
                    }
                }
                if (g.length == this.numberInput.val().length || c) {
                    var d = this._moveCaretToDecimalSeparator();
                    this._setSelectionStart(d - 1)
                }
            } else {
                this._setSelectionStart(g.start)
            }
        },
        _handleKeyDown: function(h, s) {
            var r = this._selection();
            var c = h.ctrlKey || h.metaKey;
            if ((s == 8 || s == 46) && c) {
                this.setDecimal(null);
                return false
            }
            if (this.rtl && s == 37) {
                var d = h.shiftKey;
                var g = d ? 1 : 0;
                if (d) {
                    this._setSelection(r.start + 1 - g, r.start + r.length + 1)
                } else {
                    this._setSelection(r.start + 1 - g, r.start + 1)
                }
                return false
            } else {
                if (this.rtl && s == 39) {
                    var d = h.shiftKey;
                    var g = d ? 1 : 0;
                    if (d) {
                        this._setSelection(r.start - 1, r.length + g + r.start - 1)
                    } else {
                        this._setSelection(r.start - 1, r.start - 1)
                    }
                    return false
                }
            }
            if ((c && s == 97) || (c && s == 65)) {
                return true
            }
            if ((c && s == 120) || (c && s == 88)) {
                this.selectedText = this._saveSelectedText(h);
                a.data(document.body, "jqxSelection", this.selectedText);
                this._handleBackspace();
                return false
            }
            if ((c && s == 99) || (c && s == 67)) {
                this.selectedText = this._saveSelectedText(h);
                a.data(document.body, "jqxSelection", this.selectedText);
                return false
            }
            if ((c && s == 122) || (c && s == 90)) {
                return false
            }
            if ((c && s == 118) || (c && s == 86) || (h.shiftKey && s == 45)) {
                this._pasteSelectedText();
                return false
            }
            if (r.start >= 0 && r.start < this.items.length) {
                var f = String.fromCharCode(s);
                var u = this.items[r.start]
            }
            if (s == 8) {
                this._handleBackspace();
                return false
            }
            if (s == 190 || s == 110) {
                this._moveCaretToDecimalSeparator();
                return false
            }
            if (s == 188) {
                var q = this.numberInput.val();
                for (i = r.start; i < q.length; i++) {
                    if (q[i] == this.groupSeparator) {
                        this._setSelectionStart(1 + i);
                        break
                    }
                }
                return false
            }
            if (a.jqx.browser.msie == null) {
                var f = String.fromCharCode(s);
                var n = parseInt(f);
                if (s >= 96 && s <= 105) {
                    n = s - 96;
                    s = s - 48
                }
                if (!isNaN(n)) {
                    var l = this;
                    l._insertKey(s);
                    return false
                }
            }
            if (s == 46) {
                var t = this._getVisibleItems();
                if (r.start < t.length) {
                    var g = t[r.start].canEdit == false ? 2 : 1;
                    if (r.start == 0) {
                        if (this.negative) {
                            this.setvalue("negative", false);
                            if (r.length == 0) {
                                this._setSelectionStart(0)
                            }
                            var r = this._selection();
                            if (r.length == 0) {
                                return false
                            }
                        }
                    }
                    if (r.length == 0) {
                        this._setSelection(r.start + g, r.start + g + r.length)
                    }
                    this._handleBackspace();
                    if (new Number(this.decimal) < 1 || r.start > this._getSeparatorPosition()) {
                        this._setSelectionStart(r.end + g)
                    } else {
                        if (r.start + 1 < this.decimalSeparatorPosition) {
                            this._setSelectionStart(r.end + g)
                        }
                    }
                }
                return false
            }
            if (s == 38) {
                //this.spinUp();
                return false
            } else {
                if (s == 40) {
                    //this.spinDown();
                    return false
                }
            }
            var o = this._isSpecialKey(s);
            if (a.jqx.browser.mozilla) {
                if (s == 45 || s == 173 || s == 109 || s == 189) {
                    var b = this.getvalue("negative");
                    if (b == false) {
                        this.setvalue("negative", true)
                    } else {
                        this.setvalue("negative", false)
                    }
                }
            }
            if (!a.jqx.browser.mozilla) {
                return true
            }
            return o
        },
        _isSpecialKey: function(b) {
            if (b != 8 && b != 9 && b != 13 && b != 35 && b != 36 && b != 37 && b != 38 && b != 39 && b != 40 && b != 27 && b != 46) {
                return false
            }
            return true
        },
        _selection: function() {
            try {
                if ("selectionStart" in this.numberInput[0]) {
                    var g = this.numberInput[0];
                    var h = g.selectionEnd - g.selectionStart;
                    return {
                        start: g.selectionStart,
                        end: g.selectionEnd,
                        length: h,
                        text: g.value
                    }
                } else {
                    var d = document.selection.createRange();
                    if (d == null) {
                        return {
                            start: 0,
                            end: g.value.length,
                            length: 0
                        }
                    }
                    var c = this.numberInput[0].createTextRange();
                    var f = c.duplicate();
                    c.moveToBookmark(d.getBookmark());
                    f.setEndPoint("EndToStart", c);
                    var h = d.text.length;
                    return {
                        start: f.text.length,
                        end: f.text.length + d.text.length,
                        length: h,
                        text: d.text
                    }
                }
            } catch (b) {
                return {
                    start: 0,
                    end: 0,
                    length: 0
                }
            }
        },
        selectAll: function() {
            var b = this.numberInput;
            setTimeout(function() {
                if ("selectionStart" in b[0]) {
                    b[0].focus();
                    b[0].setSelectionRange(0, b[0].value.length)
                } else {
                    var c = b[0].createTextRange();
                    c.collapse(true);
                    c.moveEnd("character", b[0].value.length);
                    c.moveStart("character", 0);
                    c.select()
                }
            }, 10)
        },
        _setSelection: function(f, b) {
            if (this._disableSetSelection == true) {
                return
            }
            var e = a.jqx.mobile.isTouchDevice();
            if (e || this.touchMode == true) {
                return
            }
            try {
                if ("selectionStart" in this.numberInput[0]) {
                    this.numberInput[0].focus();
                    this.numberInput[0].setSelectionRange(f, b)
                } else {
                    var c = this.numberInput[0].createTextRange();
                    c.collapse(true);
                    c.moveEnd("character", b);
                    c.moveStart("character", f);
                    c.select()
                }
            } catch (d) {}
        },
        _setSelectionStart: function(b) {
            this._setSelection(b, b);
            a.data(this.numberInput, "selectionstart", b)
        },
        resize: function(c, b) {
            this.width = c;
            this.height = b;
            this._render(false)
        },
        _render: function(f) {
            var c = parseInt(this.host.css("border-left-width"));
            var h = parseInt(this.host.css("border-left-width"));
            var g = parseInt(this.host.css("border-left-width"));
            var d = parseInt(this.host.css("border-left-width"));
            this.numberInput.css("padding-top", "0px");
            this.numberInput.css("padding-bottom", "0px");
            this.host.height(this.height);
            this.host.width(this.width);
            var e = this.host.width();
            var o = this.host.height();
            this.numberInput.css({
                "border-left-width": 0,
                "border-right-width": 0,
                "border-bottom-width": 0,
                "border-top-width": 0
            });
            this.numberInput.css("text-align", this.textAlign);
            var q = this.numberInput.css("font-size");
            this.numberInput.css("height", parseInt(q) + 4 + "px");
            this.numberInput.css("width", e - 2);
            var n = o - 2 * g - parseInt(q) - 2;
            if (isNaN(n)) {
                n = 0
            }
            if (n < 0) {
                n = 0
            }
            if (this.spinButtons && this.spincontainer) {
                e -= parseInt(this.spinButtonsWidth - 2);
                var l = a.jqx.mobile.isTouchDevice();
                if (!l && this.touchMode !== true) {
                    this.spincontainer.width(this.spinButtonsWidth);
                    this.upbutton.width(this.spinButtonsWidth + 2);
                    this.downbutton.width(this.spinButtonsWidth + 2);
                    this.upbutton.height("50%");
                    this.downbutton.height("50%");
                    this.spincontainer.width(this.spinButtonsWidth)
                } else {
                    this.spincontainer.width(2 * (this.spinButtonsWidth));
                    e -= this.spinButtonsWidth;
                    this.upbutton.height("100%");
                    this.downbutton.height("100%");
                    this.downbutton.css("float", "left");
                    this.upbutton.css("float", "right");
                    this.upbutton.width(this.spinButtonsWidth);
                    this.downbutton.width(1 + this.spinButtonsWidth)
                }
                this._upArrow.height("100%");
                this._downArrow.height("100%");
                this.numberInput.css("width", e - 6);
                this.numberInput.css("margin-right", "2px")
            }
            var b = n / 2;
            if (a.jqx.browser.msie && a.jqx.browser.version < 8) {
                b = n / 4
            }
            this.numberInput.css("padding-left", "0px");
            this.numberInput.css("padding-right", "0px");
            this.numberInput.css("padding-top", Math.round(b) + "px");
            this.numberInput.css("padding-bottom", Math.round(b) + "px");
            if (f == undefined || f == true) {
                this.numberInput.val(this._getString());
                if (this.inputMode != "advanced") {
                    this._parseDecimalInSimpleMode()
                }
            }
        },
        destroy: function() {
            this._removeHandlers();
            this.host.remove()
        },
        inputValue: function(b) {
            if (b === undefined) {
                return this._value()
            }
            this.propertyChangedHandler(this, "value", this._value, b);
            this._refreshValue();
            return this
        },
        _value: function() {
            var b = this.numberInput.val();
            return b
        },
        val: function(c) {
            if (c !== undefined && typeof c != "object" || c === null) {
                if (c === null) {
                    this.setDecimal(null);
                    return
                } else {
                    var f = c;
                    f = f.toString();
                    if (f.indexOf(this.symbol) > -1) {
                        f = f.replace(this.symbol, "")
                    }
                    var b = function(q, n, o) {
                        var h = q;
                        if (n == o) {
                            return q
                        }
                        var l = h.indexOf(n);
                        while (l != -1) {
                            h = h.replace(n, o);
                            l = h.indexOf(n)
                        }
                        return h
                    };
                    f = b(f, this.groupSeparator, "");
                    f = f.replace(this.decimalSeparator, ".");
                    var g = "";
                    for (var d = 0; d < f.length; d++) {
                        var e = f.substring(d, d + 1);
                        if (e === "-") {
                            g += "-"
                        }
                        if (e === ".") {
                            g += "."
                        }
                        if (e.match(/^[0-9]+$/) != null) {
                            g += e
                        }
                    }
                    f = g;
                    f = f.replace(/ /g, "");
                    f = new Number(f);
                    this.setDecimal(f)
                }
            } else {
                return this.getDecimal()
            }
        },
        getDecimal: function() {
            if (this.decimal == null) {
                return null
            }
            if (this.inputMode == "simple") {
                this._parseDecimalInSimpleMode(false);
                this.decimal = this._getDecimalInSimpleMode(this.decimal)
            }
            if (this.decimal == "") {
                return 0
            }
            var b = this.getvalue("negative");
            if (b && this.decimal > 0) {
                return -parseFloat(this.decimal)
            }
            return parseFloat(this.decimal)
        },
        setDecimal: function(e) {
            var b = e;
            if (this.decimalSeparator != ".") {
                if (e === null) {
                    this._setDecimal(e)
                } else {
                    var d = e;
                    if (typeof(e) != "number") {
                        e = e.toString();
                        var g = e.indexOf(".");
                        if (g != -1) {
                            var c = e.substring(0, g);
                            var f = e.substring(g + 1);
                            d = c + "." + f;
                            if (c.indexOf("-") != -1) {
                                c = c.substring(1)
                            }
                            if (this.inputMode != "advanced") {
                                e = c + "." + f
                            } else {
                                e = c + this.decimalSeparator + f
                            }
                        } else {
                            var g = e.indexOf(this.decimalSeparator);
                            if (g != -1) {
                                var c = e.substring(0, g);
                                var f = e.substring(g + 1);
                                d = c + "." + f;
                                if (c.indexOf("-") != -1) {
                                    c = c.substring(1)
                                }
                                if (this.inputMode != "advanced") {
                                    e = c + "." + f
                                } else {
                                    e = c + this.decimalSeparator + f
                                }
                            }
                        }
                    }
                    if (d < 0) {
                        this.setvalue("negative", true)
                    } else {
                        this.setvalue("negative", false)
                    }
                    this._setDecimal(e)
                }
            } else {
                if (e < 0) {
                    this.setvalue("negative", true)
                } else {
                    this.setvalue("negative", false)
                }
                if (e === null) {
                    this._setDecimal(e)
                } else {
                    this._setDecimal(Math.abs(e))
                }
            }
            if (b == null) {
                this.numberInput.val("")
            }
        },
        _setDecimal: function(r) {
            if (r == null) {
                this.decimal = null;
                this.value = null;
                this._refreshValue();
                this.decimal = null;
                this.value = null;
                return
            }
            if (r == null || r == undefined) {
                r = 0
            }
            if (r.toString().indexOf("e") != -1) {
                r = new Number(r).toFixed(this.decimalDigits).toString()
            }
            this.clearDecimal();
            var s = r.toString();
            var t = "";
            var b = "";
            var d = true;
            if (s.length == 0) {
                s = "0"
            }
            for (var g = 0; g < s.length; g++) {
                if (s.substring(g, g + 1) == this.decimalSeparator) {
                    d = false;
                    continue
                }
                if (d) {
                    t += s.substring(g, g + 1)
                } else {
                    b += s.substring(g, g + 1)
                }
            }
            if (t.length > 0) {
                t = parseFloat(t).toString()
            }
            var o = this.digits;
            if (o < t.length) {
                t = t.substr(0, o)
            }
            var f = 0;
            var q = this._getSeparatorPosition();
            var n = this._getHiddenPrefixCount();
            q = q + n;
            for (var g = q; g >= 0; g--) {
                if (g < this.items.length && this.items[g].canEdit) {
                    if (f < t.length) {
                        this.items[g].character = t.substring(t.length - f - 1, t.length - f);
                        f++
                    }
                }
            }
            f = 0;
            for (var g = q; g < this.items.length; g++) {
                if (this.items[g].canEdit) {
                    if (f < b.length) {
                        this.items[g].character = b.substring(f, f + 1);
                        f++
                    }
                }
            }
            this._refreshValue();
            if (this.decimalSeparator == ".") {
                this.ValueString = new Number(r).toFixed(this.decimalDigits)
            } else {
                var l = r.toString().indexOf(this.decimalSeparator);
                if (l > 0) {
                    var h = r.toString().substring(0, l);
                    var e = h + "." + r.toString().substring(l + 1);
                    this.ValueString = new Number(e).toFixed(this.decimalDigits)
                } else {
                    this.ValueString = new Number(r).toFixed(this.decimalDigits)
                }
            }
            if (this.inputMode != "advanced") {
                this._parseDecimalInSimpleMode();
                this._raiseEvent(1, this.ValueString)
            }
            if (this.inputMode == "textbox") {
                this.decimal = this.ValueString;
                var c = this.getvalue("negative");
                if (c) {
                    this.decimal = "-" + this.ValueString
                }
            }
            var r = this.val();
            if (r < this.min || r > this.max) {
                this.host.addClass("jqx-input-invalid")
            } else {
                this.host.removeClass("jqx-input-invalid")
            }
        },
        _getSeparatorPosition: function() {
            var b = this._getHiddenPrefixCount();
            if (this.decimalSeparatorPosition > 0) {
                return this.decimalSeparatorPosition - b
            }
            return this.items.length - b
        },
        _setTheme: function() {
            this.host.removeClass();
            this.host.addClass(this.toThemeProperty("jqx-input"));
            this.host.addClass(this.toThemeProperty("jqx-rc-all"));
            this.host.addClass(this.toThemeProperty("jqx-widget"));
            this.host.addClass(this.toThemeProperty("jqx-widget-content"));
            this.host.addClass(this.toThemeProperty("jqx-numberinput"));

            if (this.spinButtons) {
                this.downbutton.removeClass();
                this.upbutton.removeClass();
                this.downbutton.addClass(this.toThemeProperty("jqx-scrollbar-button-state-normal"));
                this.upbutton.addClass(this.toThemeProperty("jqx-scrollbar-button-state-normal"));
                this._upArrow.removeClass();
                this._downArrow.removeClass();
                this._upArrow.addClass(this.toThemeProperty("jqx-icon-arrow-up"));
                this._downArrow.addClass(this.toThemeProperty("jqx-icon-arrow-down"))
            }
            this.numberInput.removeClass();
            this.numberInput.addClass(this.toThemeProperty("jqx-input-content"))
        },
        propertyChangedHandler: function(c, d, g, f) {
            if (d == "digits" || d == "groupSize" || d == "decimalDigits") {
                if (f < 0) {
                    throw new Exception(this.invalidArgumentExceptions[0])
                }
            }
            if (d === "theme") {
                a.jqx.utilities.setTheme(g, f, c.host)
            }
            if (d == "digits") {
                if (f != g) {
                    c.digits = parseInt(f)
                }
            }
            if (d == "min" || d == "max") {
                a.jqx.aria(c, "aria-value" + d, f.toString());
                c._refreshValue()
            }
            if (d == "decimalDigits") {
                if (f != g) {
                    c.decimalDigits = parseInt(f)
                }
            }
            if (d == "decimalSeparator" || d == "digits" || d == "symbol" || d == "symbolPosition" || d == "groupSize" || d == "groupSeparator" || d == "decimalDigits" || d == "negativeSymbol") {
                var b = c.decimal;
                if (d == "decimalSeparator" && f == "") {
                    f = " "
                }
                if (g != f) {
                    var e = c._selection();
                    c.items = new Array();
                    c._initializeLiterals();
                    c.value = c._getString();
                    c._refreshValue();
                    c._setDecimal(b)
                }
            }
            if (d == "rtl") {
                if (c.rtl) {
                    if (c.spincontainer) {
                        c.spincontainer.css("float", "right");
                        c.spincontainer.css("border-right-width", "1px")
                    }
                    c.numberInput.css("float", "right")
                } else {
                    if (c.spincontainer) {
                        c.spincontainer.css("float", "right");
                        c.spincontainer.css("border-right-width", "1px")
                    }
                    c.numberInput.css("float", "left")
                }
            }
            if (d == "spinButtons") {
                if (c.spincontainer) {
                    if (!f) {
                        c.spincontainer.css("display", "none")
                    } else {
                        c.spincontainer.css("display", "block")
                    }
                    c._render()
                } else {
                    c._spinButtons()
                }
            }
            if (d === "touchMode") {
                c.inputMode = "textbox";
                c.spinMode = "simple";
                c.render()
            }
            if (d == "negative" && c.inputMode == "advanced") {
                var e = c._selection();
                var h = 0;
                if (f) {
                    c.items[0].character = c.negativeSymbol[0];
                    h = 1
                } else {
                    c.items[0].character = "";
                    h = -1
                }
                c._refreshValue();
                if (c.isInitialized) {
                    c._setSelection(e.start + h, e.end + h)
                }
            }
            if (d == "decimal") {
                c.value = f;
                c.setDecimal(f)
            }
            if (d === "value") {
                c.value = f;
                c.setDecimal(f);
                c._raiseEvent(1, f)
            }
            if (d == "textAlign") {
                c.textAlign = f;
                c._render()
            }
            if (d == "disabled") {
                c.numberInput.attr("disabled", f);
                if (c.disabled) {
                    c.host.addClass(c.toThemeProperty("jqx-fill-state-disabled"))
                } else {
                    c.host.removeClass(c.toThemeProperty("jqx-fill-state-disabled"))
                }
                a.jqx.aria(c, "aria-disabled", f.toString())
            }
            if (d == "readOnly") {
                c.readOnly = f
            }
            if (d == "promptChar") {
                for (i = 0; i < c.items.length; i++) {
                    if (c.items[i].character == c.promptChar) {
                        c.items[i].character = f
                    }
                }
                c.promptChar = f
            }
            if (d == "width") {
                c.width = f;
                c._render()
            } else {
                if (d == "height") {
                    c.height = f;
                    c._render()
                }
            }
        },
        _value: function() {
            var b = this.value;
            return b
        },
        _refreshValue: function() {
            var g = this.value;
            var b = 0;
            if (this.inputMode === "textbox") {
                return
            }
            this.value = this._getString();
            g = this.value;
            var f = "";
            for (var c = 0; c < this.items.length; c++) {
                var e = this.items[c];
                if (e.canEdit && e.character != this.promptChar) {
                    f += e.character
                }
                if (c == this.decimalSeparatorPosition) {
                    f += "."
                }
            }
            this.decimal = f;
            var d = false;
            if (this.oldValue !== g) {
                this.oldValue = g;
                this._raiseEvent(0, g);
                d = true
            }
            if (this.inputMode != "simple") {
                this.numberInput.val(g);
                if (d) {
                    this._raiseEvent(1, g)
                }
            }
            if (g == null) {
                this.numberInput.val("")
            }
        }
    })
})(jqxBaseFramework);