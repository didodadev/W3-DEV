/*
@license

dhtmlxGantt v.6.3.0 Professional
This software can be used only as part of dhtmlx.com site.
You are not allowed to use it on any other site

(c) XB Software Ltd.

*/
! function(t, e) {
    "object" == typeof exports && "object" == typeof module ? module.exports = e() : "function" == typeof define && define.amd ? define("dhtmlxgantt", [], e) : "object" == typeof exports ? exports.dhtmlxgantt = e() : t.dhtmlxgantt = e()
}(window, function() {
    return function(t) {
        var e = {};

        function i(n) {
            if (e[n]) return e[n].exports;
            var r = e[n] = {
                i: n,
                l: !1,
                exports: {}
            };
            return t[n].call(r.exports, r, r.exports, i), r.l = !0, r.exports
        }
        return i.m = t, i.c = e, i.d = function(t, e, n) {
            i.o(t, e) || Object.defineProperty(t, e, {
                enumerable: !0,
                get: n
            })
        }, i.r = function(t) {
            "undefined" != typeof Symbol && Symbol.toStringTag && Object.defineProperty(t, Symbol.toStringTag, {
                value: "Module"
            }), Object.defineProperty(t, "__esModule", {
                value: !0
            })
        }, i.t = function(t, e) {
            if (1 & e && (t = i(t)), 8 & e) return t;
            if (4 & e && "object" == typeof t && t && t.__esModule) return t;
            var n = Object.create(null);
            if (i.r(n), Object.defineProperty(n, "default", {
                    enumerable: !0,
                    value: t
                }), 2 & e && "string" != typeof t)
                for (var r in t) i.d(n, r, function(e) {
                    return t[e]
                }.bind(null, r));
            return n
        }, i.n = function(t) {
            var e = t && t.__esModule ? function() {
                return t.default
            } : function() {
                return t
            };
            return i.d(e, "a", e), e
        }, i.o = function(t, e) {
            return Object.prototype.hasOwnProperty.call(t, e)
        }, i.p = "/codebase/", i(i.s = 176)
    }([function(t, e, i) {
        var n, r = i(2);
        t.exports = {
            copy: function t(e) {
                var i, n;
                if (e && "object" == typeof e) switch (!0) {
                    case r.isDate(e):
                        n = new Date(e);
                        break;
                    case r.isArray(e):
                        for (n = new Array(e.length), i = 0; i < e.length; i++) n[i] = t(e[i]);
                        break;
                    case r.isStringObject(e):
                        n = new String(e);
                        break;
                    case r.isNumberObject(e):
                        n = new Number(e);
                        break;
                    case r.isBooleanObject(e):
                        n = new Boolean(e);
                        break;
                    default:
                        for (i in n = {}, e) Object.prototype.hasOwnProperty.apply(e, [i]) && (n[i] = t(e[i]))
                }
                return n || e
            },
            defined: function(t) {
                return void 0 !== t
            },
            mixin: function(t, e, i) {
                for (var n in e)(void 0 === t[n] || i) && (t[n] = e[n]);
                return t
            },
            uid: function() {
                return n || (n = (new Date).valueOf()), ++n
            },
            bind: function(t, e) {
                return t.bind ? t.bind(e) : function() {
                    return t.apply(e, arguments)
                }
            },
            event: function(t, e, i, n) {
                t.addEventListener ? t.addEventListener(e, i, void 0 !== n && n) : t.attachEvent && t.attachEvent("on" + e, i)
            },
            eventRemove: function(t, e, i, n) {
                t.removeEventListener ? t.removeEventListener(e, i, void 0 !== n && n) : t.detachEvent && t.detachEvent("on" + e, i)
            }
        }
    }, function(t, e) {
        function i(t) {
            var e = 0,
                i = 0,
                n = 0,
                r = 0;
            if (t.getBoundingClientRect) {
                var a = t.getBoundingClientRect(),
                    o = document.body,
                    s = document.documentElement || document.body.parentNode || document.body,
                    l = window.pageYOffset || s.scrollTop || o.scrollTop,
                    c = window.pageXOffset || s.scrollLeft || o.scrollLeft,
                    u = s.clientTop || o.clientTop || 0,
                    d = s.clientLeft || o.clientLeft || 0;
                e = a.top + l - u, i = a.left + c - d, n = document.body.offsetWidth - a.right, r = document.body.offsetHeight - a.bottom
            } else {
                for (; t;) e += parseInt(t.offsetTop, 10), i += parseInt(t.offsetLeft, 10), t = t.offsetParent;
                n = document.body.offsetWidth - t.offsetWidth - i, r = document.body.offsetHeight - t.offsetHeight - e
            }
            return {
                y: Math.round(e),
                x: Math.round(i),
                width: t.offsetWidth,
                height: t.offsetHeight,
                right: Math.round(n),
                bottom: Math.round(r)
            }
        }

        function n(t) {
            var e = !1,
                i = !1;
            if (window.getComputedStyle) {
                var n = window.getComputedStyle(t, null);
                e = n.display, i = n.visibility
            } else t.currentStyle && (e = t.currentStyle.display, i = t.currentStyle.visibility);
            return "none" != e && "hidden" != i
        }

        function r(t) {
            return !isNaN(t.getAttribute("tabindex")) && 1 * t.getAttribute("tabindex") >= 0
        }

        function a(t) {
            return !{
                a: !0,
                area: !0
            }[t.nodeName.loLowerCase()] || !!t.getAttribute("href")
        }

        function o(t) {
            return !{
                input: !0,
                select: !0,
                textarea: !0,
                button: !0,
                object: !0
            }[t.nodeName.toLowerCase()] || !t.hasAttribute("disabled")
        }

        function s(t) {
            if (!t) return "";
            var e = t.className || "";
            return e.baseVal && (e = e.baseVal), e.indexOf || (e = ""), u(e)
        }
        var l = document.createElement("div");

        function c(t) {
            return t.tagName ? t : (t = t || window.event).target || t.srcElement
        }

        function u(t) {
            return (String.prototype.trim || function() {
                return this.replace(/^\s+|\s+$/g, "")
            }).apply(t)
        }
        t.exports = {
            getNodePosition: i,
            getFocusableNodes: function(t) {
                for (var e = t.querySelectorAll(["a[href]", "area[href]", "input", "select", "textarea", "button", "iframe", "object", "embed", "[tabindex]", "[contenteditable]"].join(", ")), i = Array.prototype.slice.call(e, 0), s = 0; s < i.length; s++) {
                    var l = i[s];
                    (r(l) || o(l) || a(l)) && n(l) || (i.splice(s, 1), s--)
                }
                return i
            },
            getScrollSize: function() {
                var t = document.createElement("div");
                t.style.cssText = "visibility:hidden;position:absolute;left:-1000px;width:100px;padding:0px;margin:0px;height:110px;min-height:100px;overflow-y:scroll;", document.body.appendChild(t);
                var e = t.offsetWidth - t.clientWidth;
                return document.body.removeChild(t), e
            },
            getClassName: s,
            addClassName: function(t, e) {
                e && -1 === t.className.indexOf(e) && (t.className += " " + e)
            },
            removeClassName: function(t, e) {
                e = e.split(" ");
                for (var i = 0; i < e.length; i++) {
                    var n = new RegExp("\\s?\\b" + e[i] + "\\b(?![-_.])", "");
                    t.className = t.className.replace(n, "")
                }
            },
            insertNode: function(t, e) {
                l.innerHTML = e;
                var i = l.firstChild;
                return t.appendChild(i), i
            },
            removeNode: function(t) {
                t && t.parentNode && t.parentNode.removeChild(t)
            },
            getChildNodes: function(t, e) {
                for (var i = t.childNodes, n = i.length, r = [], a = 0; a < n; a++) {
                    var o = i[a];
                    o.className && -1 !== o.className.indexOf(e) && r.push(o)
                }
                return r
            },
            toNode: function(t) {
                return "string" == typeof t ? document.getElementById(t) || document.querySelector(t) || document.body : t || document.body
            },
            locateClassName: function(t, e, i) {
                var n = c(t),
                    r = "";
                for (void 0 === i && (i = !0); n;) {
                    if (r = s(n)) {
                        var a = r.indexOf(e);
                        if (a >= 0) {
                            if (!i) return n;
                            var o = 0 === a || !u(r.charAt(a - 1)),
                                l = a + e.length >= r.length || !u(r.charAt(a + e.length));
                            if (o && l) return n
                        }
                    }
                    n = n.parentNode
                }
                return null
            },
            locateAttribute: function(t, e) {
                if (e) {
                    for (var i = c(t); i;) {
                        if (i.getAttribute && i.getAttribute(e)) return i;
                        i = i.parentNode
                    }
                    return null
                }
            },
            getTargetNode: c,
            getRelativeEventPosition: function(t, e) {
                var n = document.documentElement,
                    r = i(e);
                return {
                    x: t.clientX + n.scrollLeft - n.clientLeft - r.x + e.scrollLeft,
                    y: t.clientY + n.scrollTop - n.clientTop - r.y + e.scrollTop
                }
            },
            isChildOf: function(t, e) {
                if (!t || !e) return !1;
                for (; t && t != e;) t = t.parentNode;
                return t === e
            },
            hasClass: function(t, e) {
                return "classList" in t ? t.classList.contains(e) : new RegExp("\\b" + e + "\\b").test(t.className)
            },
            closest: function(t, e) {
                if (t.closest) return t.closest(e);
                if (t.matches || t.msMatchesSelector || t.webkitMatchesSelector) {
                    var i = t;
                    if (!document.documentElement.contains(i)) return null;
                    do {
                        if ((i.matches || i.msMatchesSelector || i.webkitMatchesSelector).call(i, e)) return i;
                        i = i.parentElement || i.parentNode
                    } while (null !== i && 1 === i.nodeType);
                    return null
                }
                return console.error("Your browser is not supported"), null
            }
        }
    }, function(t, e) {
        var i = {
            second: 1,
            minute: 60,
            hour: 3600,
            day: 86400,
            week: 604800,
            month: 2592e3,
            quarter: 7776e3,
            year: 31536e3
        };

        function n(t, e) {
            var i = [];
            if (t.filter) return t.filter(e);
            for (var n = 0; n < t.length; n++) e(t[n], n) && (i[i.length] = t[n]);
            return i
        }
        t.exports = {
            getSecondsInUnit: function(t) {
                return i[t] || i.hour
            },
            forEach: function(t, e) {
                if (t.forEach) t.forEach(e);
                else
                    for (var i = t.slice(), n = 0; n < i.length; n++) e(i[n], n)
            },
            arrayMap: function(t, e) {
                if (t.map) return t.map(e);
                for (var i = t.slice(), n = [], r = 0; r < i.length; r++) n.push(e(i[r], r));
                return n
            },
            arrayFind: function(t, e) {
                if (t.find) return t.find(e);
                for (var i = 0; i < t.length; i++)
                    if (e(t[i], i)) return t[i]
            },
            arrayFilter: n,
            arrayDifference: function(t, e) {
                return n(t, function(t, i) {
                    return !e(t, i)
                })
            },
            arraySome: function(t, e) {
                if (0 === t.length) return !1;
                for (var i = 0; i < t.length; i++)
                    if (e(t[i], i, t)) return !0;
                return !1
            },
            hashToArray: function(t) {
                var e = [];
                for (var i in t) t.hasOwnProperty(i) && e.push(t[i]);
                return e
            },
            sortArrayOfHash: function(t, e, i) {
                var n = function(t, e) {
                    return t < e
                };
                t.sort(function(t, r) {
                    return t[e] === r[e] ? 0 : i ? n(t[e], r[e]) : n(r[e], t[e])
                })
            },
            throttle: function(t, e) {
                var i = !1;
                return function() {
                    i || (t.apply(null, arguments), i = !0, setTimeout(function() {
                        i = !1
                    }, e))
                }
            },
            isArray: function(t) {
                return Array.isArray ? Array.isArray(t) : t && void 0 !== t.length && t.pop && t.push
            },
            isDate: function(t) {
                return !(!t || "object" != typeof t || !(t.getFullYear && t.getMonth && t.getDate))
            },
            isStringObject: function(t) {
                return t && "object" == typeof t && "function String() { [native code] }" === Function.prototype.toString.call(t.constructor)
            },
            isNumberObject: function(t) {
                return t && "object" == typeof t && "function Number() { [native code] }" === Function.prototype.toString.call(t.constructor)
            },
            isBooleanObject: function(t) {
                return t && "object" == typeof t && "function Boolean() { [native code] }" === Function.prototype.toString.call(t.constructor)
            },
            delay: function(t, e) {
                var i, n = function() {
                    n.$cancelTimeout(), t.$pending = !0;
                    var r = Array.prototype.slice.call(arguments);
                    i = setTimeout(function() {
                        t.apply(this, r), n.$pending = !1
                    }, e)
                };
                return n.$pending = !1, n.$cancelTimeout = function() {
                    clearTimeout(i), t.$pending = !1
                }, n.$execute = function() {
                    t(), t.$cancelTimeout()
                }, n
            },
            objectKeys: function(t) {
                if (Object.keys) return Object.keys(t);
                var e, i = [];
                for (e in t) Object.prototype.hasOwnProperty.call(t, e) && i.push(e);
                return i
            },
            requestAnimationFrame: function(t) {
                var e = window;
                return (e.requestAnimationFrame || e.webkitRequestAnimationFrame || e.msRequestAnimationFrame || e.mozRequestAnimationFrame || e.oRequestAnimationFrame || function(t) {
                    setTimeout(t, 1e3 / 60)
                })(t)
            },
            isEventable: function(t) {
                return t.attachEvent && t.detachEvent
            }
        }
    }, function(t, e) {
        t.exports = function(t, e) {
            for (var i in e) e.hasOwnProperty(i) && (t[i] = e[i]);

            function n() {
                this.constructor = t
            }
            t.prototype = null === e ? Object.create(e) : (n.prototype = e.prototype, new n)
        }
    }, function(t, e) {
        var i = function() {
            this._connected = [], this._silent_mode = !1
        };
        i.prototype = {
            _silentStart: function() {
                this._silent_mode = !0
            },
            _silentEnd: function() {
                this._silent_mode = !1
            }
        };
        var n = function(t) {
            var e = [],
                i = function() {
                    for (var i = !0, n = 0; n < e.length; n++)
                        if (e[n]) {
                            var r = e[n].apply(t, arguments);
                            i = i && r
                        }
                    return i
                };
            return i.addEvent = function(t) {
                return "function" == typeof t && e.push(t) - 1
            }, i.removeEvent = function(t) {
                e[t] = null
            }, i
        };
        t.exports = function(t) {
            var e = new i;
            t.attachEvent = function(t, i, r) {
                return t = "ev_" + t.toLowerCase(), e[t] || (e[t] = n(r || this)), t + ":" + e[t].addEvent(i)
            }, t.attachAll = function(t, e) {
                this.attachEvent("listen_all", t, e)
            }, t.callEvent = function(t, i, n) {
                if (e._silent_mode) return !0;
                var r = "ev_" + t.toLowerCase();
                return e.ev_listen_all && e.ev_listen_all.apply(n || this, [t].concat(i)), !e[r] || e[r].apply(n || this, i)
            }, t.checkEvent = function(t) {
                return !!e["ev_" + t.toLowerCase()]
            }, t.detachEvent = function(t) {
                if (t) {
                    var i = t.split(":"),
                        n = i[0],
                        r = i[1];
                    e[n] && e[n].removeEvent(r)
                }
            }, t.detachAllEvents = function() {
                for (var t in e) 0 === t.indexOf("ev_") && delete e[t]
            }
        }
    }, function(t, e) {
        function i() {
            console.log("Method is not implemented.")
        }

        function n() {}
        n.prototype.render = i, n.prototype.set_value = i, n.prototype.get_value = i, n.prototype.focus = i, t.exports = function(t) {
            return n
        }
    }, function(t, e) {
        t.exports = function(t) {
            var e = function() {};
            return e.prototype = {
                show: function(t, e, i, n) {},
                hide: function() {},
                set_value: function(t, e, i, n) {
                    this.get_input(n).value = t
                },
                get_value: function(t, e, i) {
                    return this.get_input(i).value || ""
                },
                is_changed: function(t, e, i, n) {
                    var r = this.get_value(e, i, n);
                    return r && t && r.valueOf && t.valueOf ? r.valueOf() != t.valueOf() : r != t
                },
                is_valid: function(t, e, i, n) {
                    return !0
                },
                save: function(t, e, i) {},
                get_input: function(t) {
                    return t.querySelector("input")
                },
                focus: function(t) {
                    var e = this.get_input(t);
                    e && (e.focus && e.focus(), e.select && e.select())
                }
            }, e
        }
    }, function(t, e, i) {
        var n = i(0),
            r = i(4),
            a = i(1),
            o = function() {
                "use strict";

                function t(t, e, i, o) {
                    t && (this.$container = a.toNode(t), this.$parent = t), this.$config = n.mixin(e, {
                        headerHeight: 33
                    }), this.$gantt = o, this.$domEvents = o._createDomEventScope(), this.$id = e.id || "c" + n.uid(), this.$name = "cell", this.$factory = i, r(this)
                }
                return t.prototype.destructor = function() {
                    this.$parent = this.$container = this.$view = null, this.$gantt.$services.getService("mouseEvents").detach("click", "gantt_header_arrow", this._headerClickHandler), this.$domEvents.detachAll(), this.callEvent("onDestroy", []), this.detachAllEvents()
                }, t.prototype.cell = function(t) {
                    return null
                }, t.prototype.scrollTo = function(t, e) {
                    1 * t == t && (this.$view.scrollLeft = t), 1 * e == e && (this.$view.scrollTop = e)
                }, t.prototype.clear = function() {
                    this.getNode().innerHTML = "", this.getNode().className = "gantt_layout_content", this.getNode().style.padding = "0"
                }, t.prototype.resize = function(t) {
                    if (this.$parent) return this.$parent.resize(t);
                    !1 === t && (this.$preResize = !0);
                    var e = this.$container,
                        i = e.offsetWidth,
                        n = e.offsetHeight,
                        r = this.getSize();
                    e === document.body && (i = document.body.offsetWidth, n = document.body.offsetHeight), i < r.minWidth && (i = r.minWidth), i > r.maxWidth && (i = r.maxWidth), n < r.minHeight && (n = r.minHeight), n > r.maxHeight && (n = r.maxHeight), this.setSize(i, n), this.$preResize, this.$preResize = !1
                }, t.prototype.hide = function() {
                    this._hide(!0), this.resize()
                }, t.prototype.show = function(t) {
                    this._hide(!1), t && this.$parent && this.$parent.show(), this.resize()
                }, t.prototype._hide = function(t) {
                    if (!0 === t && this.$view.parentNode) this.$view.parentNode.removeChild(this.$view);
                    else if (!1 === t && !this.$view.parentNode) {
                        var e = this.$parent.cellIndex(this.$id);
                        this.$parent.moveView(this, e)
                    }
                    this.$config.hidden = t
                }, t.prototype.$toHTML = function(t, e) {
                    void 0 === t && (t = ""), e = [e || "", this.$config.css || ""].join(" ");
                    var i = this.$config,
                        n = "";
                    i.raw ? t = "string" == typeof i.raw ? i.raw : "" : (t || (t = "<div class='gantt_layout_content' " + (e ? " class='" + e + "' " : "") + " >" + (i.html || "") + "</div>"), i.header && (n = "<div class='gantt_layout_header'>" + (i.canCollapse ? "<div class='gantt_layout_header_arrow'></div>" : "") + "<div class='gantt_layout_header_content'>" + i.header + "</div></div>"));
                    return "<div class='gantt_layout_cell " + e + "' data-cell-id='" + this.$id + "'>" + n + t + "</div>"
                }, t.prototype.$fill = function(t, e) {
                    this.$view = t, this.$parent = e, this.init()
                }, t.prototype.getNode = function() {
                    return this.$view.querySelector("gantt_layout_cell") || this.$view
                }, t.prototype.init = function() {
                    var t = this;
                    this._headerClickHandler = function(e) {
                        a.locateAttribute(e, "data-cell-id") == t.$id && t.toggle()
                    }, this.$gantt.$services.getService("mouseEvents").delegate("click", "gantt_header_arrow", this._headerClickHandler), this.callEvent("onReady", [])
                }, t.prototype.toggle = function() {
                    this.$config.collapsed = !this.$config.collapsed, this.resize()
                }, t.prototype.getSize = function() {
                    var t = {
                        height: this.$config.height || 0,
                        width: this.$config.width || 0,
                        gravity: this.$config.gravity || 1,
                        minHeight: this.$config.minHeight || 0,
                        minWidth: this.$config.minWidth || 0,
                        maxHeight: this.$config.maxHeight || 1e5,
                        maxWidth: this.$config.maxWidth || 1e5
                    };
                    if (this.$config.collapsed) {
                        var e = "x" === this.$config.mode;
                        t[e ? "width" : "height"] = t[e ? "maxWidth" : "maxHeight"] = this.$config.headerHeight
                    }
                    return t
                }, t.prototype.getContentSize = function() {
                    var t = this.$lastSize.contentX;
                    t !== 1 * t && (t = this.$lastSize.width);
                    var e = this.$lastSize.contentY;
                    return e !== 1 * e && (e = this.$lastSize.height), {
                        width: t,
                        height: e
                    }
                }, t.prototype._getBorderSizes = function() {
                    var t = {
                        top: 0,
                        right: 0,
                        bottom: 0,
                        left: 0,
                        horizontal: 0,
                        vertical: 0
                    };
                    return this._currentBorders && (this._currentBorders[this._borders.left] && (t.left = 1, t.horizontal++), this._currentBorders[this._borders.right] && (t.right = 1, t.horizontal++), this._currentBorders[this._borders.top] && (t.top = 1, t.vertical++), this._currentBorders[this._borders.bottom] && (t.bottom = 1, t.vertical++)), t
                }, t.prototype.setSize = function(t, e) {
                    this.$view.style.width = t + "px", this.$view.style.height = e + "px";
                    var i = this._getBorderSizes(),
                        n = e - i.vertical,
                        r = t - i.horizontal;
                    this.$lastSize = {
                        x: t,
                        y: e,
                        contentX: r,
                        contentY: n
                    }, this.$config.header ? this._sizeHeader() : this._sizeContent()
                }, t.prototype._borders = {
                    left: "gantt_layout_cell_border_left",
                    right: "gantt_layout_cell_border_right",
                    top: "gantt_layout_cell_border_top",
                    bottom: "gantt_layout_cell_border_bottom"
                }, t.prototype._setBorders = function(t, e) {
                    e || (e = this);
                    var i = e.$view;
                    for (var n in this._borders) a.removeClassName(i, this._borders[n]);
                    "string" == typeof t && (t = [t]);
                    var r = {};
                    for (n = 0; n < t.length; n++) a.addClassName(i, t[n]), r[t[n]] = !0;
                    e._currentBorders = r
                }, t.prototype._sizeContent = function() {
                    var t = this.$view.childNodes[0];
                    t && "gantt_layout_content" == t.className && (t.style.height = this.$lastSize.contentY + "px")
                }, t.prototype._sizeHeader = function() {
                    var t = this.$lastSize;
                    t.contentY -= this.$config.headerHeight;
                    var e = this.$view.childNodes[0],
                        i = this.$view.childNodes[1],
                        n = "x" === this.$config.mode;
                    if (this.$config.collapsed)
                        if (i.style.display = "none", n) {
                            e.className = "gantt_layout_header collapsed_x", e.style.width = t.y + "px";
                            var r = Math.floor(t.y / 2 - t.x / 2);
                            e.style.transform = "rotate(90deg) translate(" + r + "px, " + r + "px)", i.style.display = "none"
                        } else e.className = "gantt_layout_header collapsed_y";
                    else e.className = n ? "gantt_layout_header" : "gantt_layout_header vertical", e.style.width = "auto", e.style.transform = "", i.style.display = "", i.style.height = t.contentY + "px";
                    e.style.height = this.$config.headerHeight + "px"
                }, t
            }();
        t.exports = o
    }, function(t, e) {
        var i = {
            isIE: navigator.userAgent.indexOf("MSIE") >= 0 || navigator.userAgent.indexOf("Trident") >= 0,
            isIE6: !window.XMLHttpRequest && navigator.userAgent.indexOf("MSIE") >= 0,
            isIE7: navigator.userAgent.indexOf("MSIE 7.0") >= 0 && navigator.userAgent.indexOf("Trident") < 0,
            isIE8: navigator.userAgent.indexOf("MSIE 8.0") >= 0 && navigator.userAgent.indexOf("Trident") >= 0,
            isOpera: navigator.userAgent.indexOf("Opera") >= 0,
            isChrome: navigator.userAgent.indexOf("Chrome") >= 0,
            isKHTML: navigator.userAgent.indexOf("Safari") >= 0 || navigator.userAgent.indexOf("Konqueror") >= 0,
            isFF: navigator.userAgent.indexOf("Firefox") >= 0,
            isIPad: navigator.userAgent.search(/iPad/gi) >= 0,
            isEdge: -1 != navigator.userAgent.indexOf("Edge")
        };
        t.exports = i
    }, , , function(t, e, i) {
        var n = i(2),
            r = {
                getHtmlSelect: function(t, e, i) {
                    var r = "",
                        o = this;
                    return t = t || [], n.forEach(t, function(t) {
                        var e = [{
                            key: "value",
                            value: t.key
                        }];
                        i == t.key && (e[e.length] = {
                            key: "selected",
                            value: "selected"
                        }), t.attributes && (e = e.concat(t.attributes)), r += o.getHtmlOption({
                            innerHTML: t.label
                        }, e)
                    }), a("select", {
                        innerHTML: r
                    }, e)
                },
                getHtmlOption: function(t, e) {
                    return a("option", t, e)
                },
                getHtmlButton: function(t, e) {
                    return a("button", t, e)
                },
                getHtmlDiv: function(t, e) {
                    return a("div", t, e)
                },
                getHtmlLabel: function(t, e) {
                    return a("label", t, e)
                },
                getHtmlInput: function(t) {
                    return "<input" + o(t || []) + ">"
                }
            };

        function a(t, e, i) {
            return e = e || [], "<" + t + o(i || []) + ">" + (e.innerHTML || "") + "</" + t + ">"
        }

        function o(t) {
            var e = "";
            return n.forEach(t, function(t) {
                e += " " + t.key + "='" + t.value + "'"
            }), e
        }
        t.exports = r
    }, function(t, e, i) {
        var n = i(3),
            r = i(11);
        t.exports = function(t) {
            var e = i(5)(t);

            function a() {
                return e.apply(this, arguments) || this
            }
            return n(a, e), a.prototype.render = function(t) {
                var e = "<div class='gantt_cal_ltext' style='height:" + ((t.height || "23") + "px") + ";'>";
                return e += r.getHtmlSelect(t.options, [{
                    key: "style",
                    value: "width:100%;"
                }]), e += "</div>"
            }, a.prototype.set_value = function(t, e, i, n) {
                var r = t.firstChild;
                !r._dhx_onchange && n.onchange && (r.onchange = n.onchange, r._dhx_onchange = !0), void 0 === e && (e = (r.options[0] || {}).value), r.value = e || ""
            }, a.prototype.get_value = function(t) {
                return t.firstChild.value
            }, a.prototype.focus = function(e) {
                var i = e.firstChild;
                t._focus(i, !0)
            }, a
        }
    }, function(t, e, i) {
        var n = i(0);
        t.exports = {
            createDropTargetObject: function(t) {
                var e = {
                    targetParent: null,
                    targetIndex: 0,
                    targetId: null,
                    child: !1,
                    nextSibling: !1,
                    prevSibling: !1
                };
                return t && n.mixin(e, t, !0), e
            },
            nextSiblingTarget: function(t, e, i) {
                var n = this.createDropTargetObject();
                return n.targetId = e, n.nextSibling = !0, n.targetParent = i.getParent(n.targetId), n.targetIndex = i.getBranchIndex(n.targetId), (i.getParent(t) != n.targetParent || n.targetIndex < i.getBranchIndex(t)) && (n.targetIndex += 1), n
            },
            prevSiblingTarget: function(t, e, i) {
                var n = this.createDropTargetObject();
                return n.targetId = e, n.prevSibling = !0, n.targetParent = i.getParent(n.targetId), n.targetIndex = i.getBranchIndex(n.targetId), i.getParent(t) == n.targetParent && n.targetIndex > i.getBranchIndex(t) && (n.targetIndex -= 1), n
            },
            firstChildTarget: function(t, e, i) {
                var n = this.createDropTargetObject();
                return n.targetId = e, n.targetParent = n.targetId, n.targetIndex = 0, n.child = !0, n
            },
            lastChildTarget: function(t, e, i) {
                var n = i.getChildren(e),
                    r = this.createDropTargetObject();
                return r.targetId = n[n.length - 1], r.targetParent = e, r.targetIndex = n.length, r.nextSibling = !0, r
            }
        }
    }, function(t, e) {
        t.exports = function(t, e) {
            if (!t.start_date || !t.end_date) return null;
            var i = e.posFromDate(t.start_date),
                n = e.posFromDate(t.end_date),
                r = Math.min(i, n) - 200,
                a = Math.max(i, n) + 200;
            return {
                top: e.getItemTop(t.id),
                height: e.getItemHeight(t.id),
                left: r,
                width: a - r
            }
        }
    }, function(t, e, i) {
        var n = i(2);

        function r(t) {
            if (t._delayRender && t._delayRender.$cancelTimeout(), t.$gantt) {
                var e = t.$gantt.$data.tasksStore,
                    i = t.$config.rowStore,
                    n = "_attached_" + i.$config.name;
                t[n] && (e.detachEvent(t[n]), t[n] = null), i.$attachedResourceViewHandler && (i.detachEvent(i.$attachedResourceViewHandler), i.$attachedResourceViewHandler = null)
            }
        }
        t.exports = function(t) {
            var e = t.prototype.init,
                i = t.prototype.destructor;
            return {
                init: function() {
                    e.apply(this, arguments), this._linkToTaskStore()
                },
                destructor: function() {
                    r(this), i.apply(this, arguments)
                },
                _linkToTaskStore: function() {
                    if (this.$config.rowStore && this.$gantt.$data.tasksStore) {
                        var t = this.$gantt.$data.tasksStore,
                            e = this.$config.rowStore;
                        r(this);
                        var i = this,
                            a = n.delay(function() {
                                i.$gantt.getState().lightbox ? a() : i.$config.rowStore.refresh()
                            }, 300);
                        this._delayRender = a;
                        var o = "_attached_" + e.$config.name;
                        i[o] || (i[o] = t.attachEvent("onStoreUpdated", a)), this.$gantt.attachEvent("onDestroy", function() {
                            return r(i), !0
                        }), e.$attachedResourceViewHandler || (e.$attachedResourceViewHandler = e.attachEvent("onBeforeStoreUpdate", function() {
                            if (i.$gantt.getState().lightbox) return !1;
                            a.$pending && a.$cancelTimeout(), i._updateNestedTasks()
                        }))
                    }
                },
                _updateNestedTasks: function() {
                    var t = this.$gantt,
                        e = t.getDatastore(t.config.resource_store);
                    if (e.$config.fetchTasks) {
                        var i = t.config.resource_property;
                        e.silent(function() {
                            var n = [],
                                r = {},
                                a = {};
                            for (var o in e.eachItem(function(o) {
                                    "task" != o.$role ? t.getTaskBy(i, o.id).forEach(function(i) {
                                        var a = t.copy(i);
                                        a.id = i.id + "_" + o.id, a.$task_id = i.id, a.$resource_id = o.id, a[e.$parentProperty] = o.id, a.$role = "task", n.push(a), r[a.id] = !0
                                    }) : a[o.id] = !0
                                }), a) r[o] || e.removeItem(o);
                            e.parse(n)
                        })
                    }
                }
            }
        }
    }, function(t, e) {
        t.exports = function(t) {
            var e = [];
            return {
                delegate: function(i, n, r, a) {
                    e.push([i, n, r, a]), t.$services.getService("mouseEvents").delegate(i, n, r, a)
                },
                destructor: function() {
                    for (var i = t.$services.getService("mouseEvents"), n = 0; n < e.length; n++) {
                        var r = e[n];
                        i.detach(r[0], r[1], r[2], r[3])
                    }
                    e = []
                }
            }
        }
    }, function(t, e, i) {
        var n = i(1),
            r = i(0),
            a = i(4),
            o = i(145),
            s = i(35),
            l = function(t, e, i, n) {
                this.$config = r.mixin({}, e || {}), this.$gantt = n, this.$parent = t, a(this), this.$state = {}, r.mixin(this, s())
            };
        l.prototype = {
            init: function(t) {
                var e = this.$gantt,
                    n = e._waiAria.gridAttrString(),
                    r = e._waiAria.gridDataAttrString();
                t.innerHTML = "<div class='gantt_grid' style='height:inherit;width:inherit;' " + n + "></div>", this.$grid = t.childNodes[0], this.$grid.innerHTML = "<div class='gantt_grid_scale' " + e._waiAria.gridScaleRowAttrString() + "></div><div class='gantt_grid_data' " + r + "></div>", this.$grid_scale = this.$grid.childNodes[0], this.$grid_data = this.$grid.childNodes[1];
                var a = this.$getConfig()[this.$config.bind + "_attribute"];
                if (!a && this.$config.bind && (a = this.$config.bind + "_id"), this.$config.item_attribute = a || null, !this.$config.layers) {
                    var s = this._createLayerConfig();
                    this.$config.layers = s
                }
                var l = o(e, this);
                l.init(), this._renderHeaderResizers = l.doOnRender, this._mouseDelegates = i(16)(e), this._addLayers(this.$gantt), this._initEvents(), this.callEvent("onReady", [])
            },
            _validateColumnWidth: function(t, e) {
                var i = t[e];
                if (i && "*" != i) {
                    var n = this.$gantt,
                        r = 1 * i;
                    isNaN(r) ? n.assert(!1, "Wrong " + e + " value of column " + t.name) : t[e] = r
                }
            },
            setSize: function(t, e) {
                this.$config.width = this.$state.width = t, this.$config.height = this.$state.height = e;
                for (var i, n = this.getGridColumns(), r = 0, a = 0, o = n.length; a < o; a++) this._validateColumnWidth(n[a], "min_width"), this._validateColumnWidth(n[a], "max_width"), this._validateColumnWidth(n[a], "width"), r += 1 * n[a].width;
                !isNaN(r) && this.$config.scrollable || (r = i = this._setColumnsWidth(t + 1)), this.$config.scrollable ? (this.$grid_scale.style.width = r + "px", this.$grid_data.style.width = r + "px") : (this.$grid_scale.style.width = "inherit", this.$grid_data.style.width = "inherit"), this.$config.width -= 1;
                var s = this.$getConfig();
                i !== t && (s.grid_width = i, this.$config.width = i - 1);
                var l = Math.max(this.$state.height - s.scale_height, 0);
                this.$grid_data.style.height = l + "px", this.refresh()
            },
            getSize: function() {
                var t = this.$getConfig(),
                    e = this.$config.rowStore,
                    i = e ? t.row_height * e.countVisible() : 0,
                    n = this._getGridWidth();
                return {
                    x: this.$state.width,
                    y: this.$state.height,
                    contentX: this.isVisible() ? n : 0,
                    contentY: this.isVisible() ? t.scale_height + i : 0,
                    scrollHeight: this.isVisible() ? i : 0,
                    scrollWidth: this.isVisible() ? n : 0
                }
            },
            _bindStore: function() {
                if (this.$config.bind) {
                    var t = this.$gantt.getDatastore(this.$config.bind);
                    if (this.$config.rowStore = t, t && !t._gridCacheAttached) {
                        var e = this;
                        t._gridCacheAttached = t.attachEvent("onBeforeFilter", function() {
                            e._resetTopPositionHeight()
                        })
                    }
                }
            },
            _unbindStore: function() {
                if (this.$config.bind) {
                    var t = this.$gantt.getDatastore(this.$config.bind);
                    t._gridCacheAttached && (t.detachEvent(t._gridCacheAttached), t._gridCacheAttached = !1)
                }
            },
            refresh: function() {
                this._bindStore(), this._resetTopPositionHeight(), this._initSmartRenderingPlaceholder(), this._calculateGridWidth(), this._renderGridHeader()
            },
            getViewPort: function() {
                var t = this.$config.scrollLeft || 0,
                    e = this.$config.scrollTop || 0,
                    i = this.$config.height || 0,
                    n = this.$config.width || 0;
                return {
                    y: e,
                    y_end: e + i,
                    x: t,
                    x_end: t + n,
                    height: i,
                    width: n
                }
            },
            scrollTo: function(t, e) {
                if (this.isVisible()) {
                    var i = !1;
                    this.$config.scrollTop = this.$config.scrollTop || 0, this.$config.scrollLeft = this.$config.scrollLeft || 0, 1 * t == t && (this.$config.scrollLeft = this.$state.scrollLeft = this.$grid.scrollLeft = t, i = !0), 1 * e == e && (this.$config.scrollTop = this.$state.scrollTop = this.$grid_data.scrollTop = e, i = !0), i && this.callEvent("onScroll", [this.$config.scrollLeft, this.$config.scrollTop])
                }
            },
            getColumnIndex: function(t) {
                for (var e = this.$getConfig().columns, i = 0; i < e.length; i++)
                    if (e[i].name == t) return i;
                return null
            },
            getColumn: function(t) {
                var e = this.getColumnIndex(t);
                return null === e ? null : this.$getConfig().columns[e]
            },
            getGridColumns: function() {
                return this.$getConfig().columns.slice()
            },
            isVisible: function() {
                return this.$parent && this.$parent.$config ? !this.$parent.$config.hidden : this.$grid.offsetWidth
            },
            getItemHeight: function() {
                return this.$getConfig().row_height
            },
            _createLayerConfig: function() {
                var t = this;
                return [{
                    renderer: this.$gantt.$ui.layers.gridLine(),
                    container: this.$grid_data,
                    filter: [function() {
                        return t.isVisible()
                    }]
                }]
            },
            _addLayers: function(t) {
                if (this.$config.bind) {
                    this._taskLayers = [];
                    var e = this,
                        i = this.$gantt.$services.getService("layers"),
                        n = i.getDataRender(this.$config.bind);
                    n || (n = i.createDataRender({
                        name: this.$config.bind,
                        defaultContainer: function() {
                            return e.$grid_data
                        }
                    }));
                    for (var r = this.$config.layers, a = 0; r && a < r.length; a++) {
                        var o = r[a];
                        o.view = this;
                        var s = n.addLayer(o);
                        this._taskLayers.push(s)
                    }
                    this._bindStore(), this._initSmartRenderingPlaceholder()
                }
            },
            _refreshPlaceholderOnStoreUpdate: function(t) {
                var e = this.$getConfig(),
                    i = this.$config.rowStore;
                if (i && null === t && this.isVisible() && e.smart_rendering) {
                    var n;
                    if (this.$config.scrollY) {
                        var r = this.$gantt.$ui.getView(this.$config.scrollY);
                        r && (n = r.getScrollState().scrollSize)
                    }
                    if (n || (n = i ? e.row_height * i.countVisible() : 0), n) {
                        this.$rowsPlaceholder && this.$rowsPlaceholder.parentNode && this.$rowsPlaceholder.parentNode.removeChild(this.$rowsPlaceholder);
                        var a = this.$rowsPlaceholder = document.createElement("div");
                        a.style.visibility = "hidden", a.style.height = n + "px", a.style.width = "1px", this.$grid_data.appendChild(a)
                    }
                }
            },
            _initSmartRenderingPlaceholder: function() {
                var t = this.$config.rowStore;
                t && (this._initSmartRenderingPlaceholder = function() {}, this._staticBgHandler = t.attachEvent("onStoreUpdated", r.bind(this._refreshPlaceholderOnStoreUpdate, this)))
            },
            _initEvents: function() {
                var t = this.$gantt;
                this._mouseDelegates.delegate("click", "gantt_close", t.bind(function(t, e, i) {
                    var r = this.$config.rowStore;
                    if (!r) return !0;
                    var a = n.locateAttribute(t, this.$config.item_attribute);
                    return a && r.close(a.getAttribute(this.$config.item_attribute)), !1
                }, this), this.$grid), this._mouseDelegates.delegate("click", "gantt_open", t.bind(function(t, e, i) {
                    var r = this.$config.rowStore;
                    if (!r) return !0;
                    var a = n.locateAttribute(t, this.$config.item_attribute);
                    return a && r.open(a.getAttribute(this.$config.item_attribute)), !1
                }, this), this.$grid)
            },
            _clearLayers: function(t) {
                var e = this.$gantt.$services.getService("layers").getDataRender(this.$config.bind);
                if (this._taskLayers)
                    for (var i = 0; i < this._taskLayers.length; i++) e.removeLayer(this._taskLayers[i]);
                this._taskLayers = []
            },
            _getColumnWidth: function(t, e, i) {
                var n = t.min_width || e.min_grid_column_width,
                    r = Math.max(i, n || 10);
                return t.max_width && (r = Math.min(r, t.max_width)), r
            },
            _getGridWidthLimits: function() {
                for (var t = this.$getConfig(), e = this.getGridColumns(), i = 0, n = 0, r = 0; r < e.length; r++) i += e[r].min_width ? e[r].min_width : t.min_grid_column_width, void 0 !== n && (n = e[r].max_width ? n + e[r].max_width : void 0);
                return [i, n]
            },
            _setColumnsWidth: function(t, e) {
                var i = this.$getConfig(),
                    n = this.getGridColumns(),
                    r = 0,
                    a = t;
                e = window.isNaN(e) ? -1 : e;
                for (var o = 0, s = n.length; o < s; o++) r += 1 * n[o].width;
                if (window.isNaN(r)) {
                    this._calculateGridWidth(), r = 0;
                    for (o = 0, s = n.length; o < s; o++) r += 1 * n[o].width
                }
                var l = a - r,
                    c = 0;
                for (o = 0; o < e + 1; o++) c += n[o].width;
                r -= c;
                for (o = e + 1; o < n.length; o++) {
                    var u = n[o],
                        d = Math.round(l * (u.width / r));
                    l < 0 ? u.min_width && u.width + d < u.min_width ? d = u.min_width - u.width : !u.min_width && i.min_grid_column_width && u.width + d < i.min_grid_column_width && (d = i.min_grid_column_width - u.width) : u.max_width && u.width + d > u.max_width && (d = u.max_width - u.width), r -= u.width, u.width += d, l -= d
                }
                for (var h = l > 0 ? 1 : -1; l > 0 && 1 === h || l < 0 && -1 === h;) {
                    var f = l;
                    for (o = e + 1; o < n.length; o++) {
                        var _;
                        if ((_ = n[o].width + h) == this._getColumnWidth(n[o], i, _) && (l -= h, n[o].width = _), !l) break
                    }
                    if (f == l) break
                }
                l && e > -1 && ((_ = n[e].width + l) == this._getColumnWidth(n[e], i, _) && (n[e].width = _));
                return this._getColsTotalWidth()
            },
            _getColsTotalWidth: function() {
                for (var t = this.getGridColumns(), e = 0, i = 0; i < t.length; i++) {
                    var n = parseFloat(t[i].width);
                    if (window.isNaN(n)) return !1;
                    e += n
                }
                return e
            },
            _calculateGridWidth: function() {
                for (var t = this.$getConfig(), e = this.getGridColumns(), i = 0, n = [], r = [], a = 0; a < e.length; a++) {
                    var o = parseFloat(e[a].width);
                    window.isNaN(o) && (o = t.min_grid_column_width || 10, n.push(a)), r[a] = o, i += o
                }
                var s = this._getGridWidth() + 1;
                if (t.autofit || n.length) {
                    var l = s - i;
                    if (t.autofit)
                        for (a = 0; a < r.length; a++) {
                            var c = Math.round(l / (r.length - a));
                            r[a] += c, (u = this._getColumnWidth(e[a], t, r[a])) != r[a] && (c = u - r[a], r[a] = u), l -= c
                        } else if (n.length)
                            for (a = 0; a < n.length; a++) {
                                c = Math.round(l / (n.length - a));
                                var u, d = n[a];
                                r[d] += c, (u = this._getColumnWidth(e[d], t, r[d])) != r[d] && (c = u - r[d], r[d] = u), l -= c
                            }
                        for (a = 0; a < r.length; a++) e[a].width = r[a]
                } else {
                    var h = s != i;
                    this.$config.width = i - 1, t.grid_width = i, h && this.$parent._setContentSize(this.$config.width, null)
                }
            },
            _renderGridHeader: function() {
                var t = this.$gantt,
                    e = this.$getConfig(),
                    i = this.$gantt.locale,
                    n = this.$gantt.templates,
                    r = this.getGridColumns();
                e.rtl && (r = r.reverse());
                for (var a = [], o = 0, s = i.labels, l = e.scale_height - 1, c = 0; c < r.length; c++) {
                    var u = c == r.length - 1,
                        d = r[c];
                    d.name || (d.name = t.uid() + "");
                    var h = 1 * d.width,
                        f = this._getGridWidth();
                    u && f > o + h && (d.width = h = f - o), o += h;
                    var _ = t._sort && d.name == t._sort.name ? "<div class='gantt_sort gantt_" + t._sort.direction + "'></div>" : "",
                        g = ["gantt_grid_head_cell", "gantt_grid_head_" + d.name, u ? "gantt_last_cell" : "", n.grid_header_class(d.name, d)].join(" "),
                        p = "width:" + (h - (u ? 1 : 0)) + "px;",
                        v = d.label || s["column_" + d.name] || s[d.name];
                    v = v || "";
                    var m = "<div class='" + g + "' style='" + p + "' " + t._waiAria.gridScaleCellAttrString(d, v) + " data-column-id='" + d.name + "' column_id='" + d.name + "'>" + v + _ + "</div>";
                    a.push(m)
                }
                this.$grid_scale.style.height = e.scale_height + "px", this.$grid_scale.style.lineHeight = l + "px", this.$grid_scale.innerHTML = a.join(""), this._renderHeaderResizers && this._renderHeaderResizers()
            },
            _getGridWidth: function() {
                return this.$config.width
            },
            destructor: function() {
                this._clearLayers(this.$gantt), this._mouseDelegates && (this._mouseDelegates.destructor(), this._mouseDelegates = null), this._unbindStore(), this.$grid = null, this.$grid_scale = null, this.$grid_data = null, this.$gantt = null, this.$config.rowStore && (this.$config.rowStore.detachEvent(this._staticBgHandler), this.$config.rowStore = null), this.callEvent("onDestroy", []), this.detachAllEvents()
            }
        }, t.exports = l
    }, function(t, e) {
        t.exports = function(t) {
            return t.config.smart_rendering && t._smart_render
        }
    }, function(t, e) {
        var i;
        i = function() {
            return this
        }();
        try {
            i = i || Function("return this")() || (0, eval)("this")
        } catch (t) {
            "object" == typeof window && (i = window)
        }
        t.exports = i
    }, , function(t, e, i) {}, function(t, e, i) {
        var n = i(0);
        t.exports = function t(e, i) {
            e = e || n.event, i = i || n.eventRemove;
            var r = [],
                a = {
                    attach: function(t, i, n, a) {
                        r.push({
                            element: t,
                            event: i,
                            callback: n,
                            capture: a
                        }), e(t, i, n, a)
                    },
                    detach: function(t, e, n, a) {
                        i(t, e, n, a);
                        for (var o = 0; o < r.length; o++) {
                            var s = r[o];
                            s.element === t && s.event === e && s.callback === n && s.capture === a && (r.splice(o, 1), o--)
                        }
                    },
                    detachAll: function() {
                        for (var t = r.slice(), e = 0; e < t.length; e++) {
                            var i = t[e];
                            a.detach(i.element, i.event, i.callback, i.capture), a.detach(i.element, i.event, i.callback, void 0), a.detach(i.element, i.event, i.callback, !1), a.detach(i.element, i.event, i.callback, !0)
                        }
                        r.splice(0, r.length)
                    },
                    extend: function() {
                        return t(this.event, this.eventRemove)
                    }
                };
            return window.scopes || (window.scopes = []), window.scopes.push(r), a
        }
    }, , , , function(t, e, i) {
        var n = i(0),
            r = i(2);

        function a(t, e, i, n, r) {
            return this.date = t, this.unit = e, this.task = i, this.id = n, this.calendar = r, this
        }

        function o(t, e, i, n, r, a) {
            return this.date = t, this.dir = e, this.unit = i, this.task = n, this.id = r, this.calendar = a, this
        }

        function s(t, e, i, n, r, a, o) {
            return this.start_date = t, this.duration = e, this.unit = i, this.step = n, this.task = r, this.id = a, this.calendar = o, this
        }

        function l(t, e, i, n) {
            return this.start_date = t, this.end_date = e, this.task = i, this.calendar = n, this.unit = null, this.step = null, this
        }
        t.exports = function(t) {
            return {
                getWorkHoursArguments: function() {
                    var t = arguments[0];
                    return t = r.isDate(t) ? {
                        date: t
                    } : n.mixin({}, t)
                },
                setWorkTimeArguments: function() {
                    return arguments[0]
                },
                unsetWorkTimeArguments: function() {
                    return arguments[0]
                },
                isWorkTimeArguments: function() {
                    var e, i = arguments[0];
                    return i instanceof a ? i : ((e = i.date ? new a(i.date, i.unit, i.task, null, i.calendar) : new a(arguments[0], arguments[1], arguments[2], null, arguments[3])).unit = e.unit || t.config.duration_unit, e)
                },
                getClosestWorkTimeArguments: function(e) {
                    var i, n = arguments[0];
                    return n instanceof o ? n : (i = r.isDate(n) ? new o(n) : new o(n.date, n.dir, n.unit, n.task, null, n.calendar), n.id && (i.task = n), i.dir = n.dir || "any", i.unit = n.unit || t.config.duration_unit, i)
                },
                _getStartEndConfig: function(e) {
                    var i, n = l;
                    return e instanceof n ? e : (r.isDate(e) ? i = new n(arguments[0], arguments[1], arguments[2], arguments[3]) : (i = new n(e.start_date, e.end_date, e.task), e.id && (i.task = e)), i.unit = i.unit || t.config.duration_unit, i.step = i.step || t.config.duration_step, i.start_date = i.start_date || i.start || i.date, i)
                },
                getDurationArguments: function(t, e, i, n) {
                    return this._getStartEndConfig.apply(this, arguments)
                },
                hasDurationArguments: function(t, e, i, n) {
                    return this._getStartEndConfig.apply(this, arguments)
                },
                calculateEndDateArguments: function(e, i, n, a) {
                    var o, l = arguments[0];
                    return l instanceof s ? l : (o = r.isDate(l) ? new s(arguments[0], arguments[1], arguments[2], void 0, arguments[3], void 0, arguments[4]) : new s(l.start_date, l.duration, l.unit, l.step, l.task, null, l.calendar), l.id && (o.task = l), o.unit = o.unit || t.config.duration_unit, o.step = o.step || t.config.duration_step, o)
                }
            }
        }
    }, function(t, e) {
        function i(t, e, i) {
            for (var n = 0; n < e.length; n++) t.isLinkExists(e[n]) && (i[e[n]] = t.getLink(e[n]))
        }

        function n(t, e, n) {
            i(t, e.$source, n), i(t, e.$target, n)
        }
        t.exports = {
            getSubtreeLinks: function(t, e) {
                var i = {};
                return t.isTaskExists(e) && n(t, t.getTask(e), i), t.eachTask(function(e) {
                    n(t, e, i)
                }, e), i
            },
            getSubtreeTasks: function(t, e) {
                var i = {};
                return t.eachTask(function(t) {
                    i[t.id] = t
                }, e), i
            }
        }
    }, function(t, e, i) {
        var n = i(37),
            r = i(36);

        function a(t) {
            var e = function(t) {
                    var e = new r(t).primaryScale(),
                        i = e.unit,
                        a = e.step;
                    if (t.config.scale_offset_minimal) {
                        var o = new n(t),
                            s = [o.primaryScale()].concat(o.getSubScales());
                        o.sortScales(s), i = s[s.length - 1].unit, a = s[s.length - 1].step || 1
                    }
                    return {
                        unit: i,
                        step: a
                    }
                }(t),
                i = e.unit,
                a = e.step,
                o = function(t, e) {
                    var i = {
                        start_date: null,
                        end_date: null
                    };
                    if (e.config.start_date && e.config.end_date) {
                        i.start_date = e.date[t + "_start"](new Date(e.config.start_date));
                        var n = new Date(e.config.end_date),
                            r = e.date[t + "_start"](new Date(n));
                        n = +n != +r ? e.date.add(r, 1, t) : r, i.end_date = n
                    }
                    return i
                }(i, t);
            o.start_date && o.end_date || ((o = function(t) {
                return t.getSubtaskDates()
            }(t)).start_date && o.end_date || (o = {
                start_date: new Date,
                end_date: new Date
            }), o.start_date = t.date[i + "_start"](o.start_date), o.start_date = t.calculateEndDate({
                start_date: t.date[i + "_start"](o.start_date),
                duration: -1,
                unit: i,
                step: a
            }), o.end_date = t.date[i + "_start"](o.end_date), o.end_date = t.calculateEndDate({
                start_date: o.end_date,
                duration: 2,
                unit: i,
                step: a
            })), t._min_date = o.start_date, t._max_date = o.end_date
        }
        t.exports = function(t) {
            a(t),
                function(t) {
                    if (t.config.fit_tasks) {
                        var e = +t._min_date,
                            i = +t._max_date;
                        if (+t._min_date != e || +t._max_date != i) return t.render(), t.callEvent("onScaleAdjusted", []), !0
                    }
                }(t)
        }
    }, function(t, e, i) {
        var n = i(30),
            r = i(0),
            a = i(31),
            o = function(t) {
                return a.apply(this, [t]), this._branches = {}, this.pull = {}, this.$initItem = t.initItem, this.$parentProperty = t.parentProperty || "parent", "function" != typeof t.rootId ? this.$getRootId = function(t) {
                    return function() {
                        return t
                    }
                }(t.rootId || 0) : this.$getRootId = t.rootId, this.$openInitially = t.openInitially, this.visibleOrder = n.$create(), this.fullOrder = n.$create(), this._searchVisibleOrder = {}, this._skip_refresh = !1, this._ganttConfig = null, t.getConfig && (this._ganttConfig = t.getConfig()), this.attachEvent("onFilterItem", function(t, e) {
                    var i = !1;
                    if (this._ganttConfig) i = this._ganttConfig.open_split_tasks;
                    var n = !0;
                    return this.eachParent(function(t) {
                        n = n && t.$open && (i || !this._isSplitItem(t))
                    }, e), !!n
                }), this
            };
        o.prototype = r.mixin({
            _buildTree: function(t) {
                for (var e = null, i = this.$getRootId(), n = 0, a = t.length; n < a; n++) e = t[n], this.setParent(e, this.getParent(e) || i);
                for (n = 0, a = t.length; n < a; n++) e = t[n], this._add_branch(e), e.$level = this.calculateItemLevel(e), r.defined(e.$open) || (e.$open = r.defined(e.open) ? e.open : this.$openInitially());
                this._updateOrder()
            },
            _isSplitItem: function(t) {
                return "split" == t.render && this.hasChild(t.id)
            },
            parse: function(t) {
                this.callEvent("onBeforeParse", [t]);
                var e = this._parseInner(t);
                this._buildTree(e), this.filter(), this.callEvent("onParse", [e])
            },
            _addItemInner: function(t, e) {
                var i = this.getParent(t);
                r.defined(i) || (i = this.$getRootId(), this.setParent(t, i));
                var n = this.getIndexById(i) + Math.min(Math.max(e, 0), this.visibleOrder.length);
                1 * n !== n && (n = void 0), a.prototype._addItemInner.call(this, t, n), this.setParent(t, i), t.hasOwnProperty("$rendered_parent") && this._move_branch(t, t.$rendered_parent), this._add_branch(t, e)
            },
            _changeIdInner: function(t, e) {
                var i = this.getChildren(t),
                    n = this._searchVisibleOrder[t];
                a.prototype._changeIdInner.call(this, t, e);
                var r = this.getParent(e);
                this._replace_branch_child(r, t, e);
                for (var o = 0; o < i.length; o++) this.setParent(this.getItem(i[o]), e);
                this._searchVisibleOrder[e] = n, delete this._branches[t]
            },
            _traverseBranches: function(t, e) {
                e = e || this.$getRootId();
                var i = this._branches[e];
                if (i)
                    for (var n = 0; n < i.length; n++) {
                        var r = i[n];
                        t.call(this, r), this._branches[r] && this._traverseBranches(t, r)
                    }
            },
            _updateOrder: function(t) {
                this.fullOrder = n.$create(), this._traverseBranches(function(t) {
                    this.fullOrder.push(t)
                }), t && a.prototype._updateOrder.call(this, t)
            },
            _removeItemInner: function(t) {
                var e = [];
                this.eachItem(function(t) {
                    e.push(t)
                }, t), e.push(this.getItem(t));
                for (var i = 0; i < e.length; i++) this._move_branch(e[i], this.getParent(e[i]), null), a.prototype._removeItemInner.call(this, e[i].id), this._move_branch(e[i], this.getParent(e[i]), null)
            },
            move: function(t, e, i) {
                var n = arguments[3];
                if (n) {
                    if (n === t) return;
                    i = this.getParent(n), e = this.getBranchIndex(n)
                }
                if (t != i) {
                    i = i || this.$getRootId();
                    var r = this.getItem(t),
                        a = this.getParent(r.id),
                        o = this.getChildren(i);
                    if (-1 == e && (e = o.length + 1), a == i)
                        if (this.getBranchIndex(t) == e) return;
                    if (!1 === this.callEvent("onBeforeItemMove", [t, i, e])) return !1;
                    this._replace_branch_child(a, t), (o = this.getChildren(i))[e] ? o = o.slice(0, e).concat([t]).concat(o.slice(e)) : o.push(t), this.setParent(r, i), this._branches[i] = o;
                    var s = this.calculateItemLevel(r) - r.$level;
                    r.$level += s, this.eachItem(function(t) {
                        t.$level += s
                    }, r.id, this), this._moveInner(this.getIndexById(t), this.getIndexById(i) + e), this.callEvent("onAfterItemMove", [t, i, e]), this.refresh()
                }
            },
            getBranchIndex: function(t) {
                for (var e = this.getChildren(this.getParent(t)), i = 0; i < e.length; i++)
                    if (e[i] == t) return i;
                return -1
            },
            hasChild: function(t) {
                return r.defined(this._branches[t]) && this._branches[t].length
            },
            getChildren: function(t) {
                return r.defined(this._branches[t]) ? this._branches[t] : n.$create()
            },
            isChildOf: function(t, e) {
                if (!this.exists(t)) return !1;
                if (e === this.$getRootId()) return !0;
                if (!this.hasChild(e)) return !1;
                var i = this.getItem(t),
                    n = this.getParent(t);
                if (this.getItem(e).$level >= i.$level) return !1;
                for (; i && this.exists(n);) {
                    if ((i = this.getItem(n)) && i.id == e) return !0;
                    n = this.getParent(i)
                }
                return !1
            },
            getSiblings: function(t) {
                if (!this.exists(t)) return n.$create();
                var e = this.getParent(t);
                return this.getChildren(e)
            },
            getNextSibling: function(t) {
                for (var e = this.getSiblings(t), i = 0, n = e.length; i < n; i++)
                    if (e[i] == t) return e[i + 1] || null;
                return null
            },
            getPrevSibling: function(t) {
                for (var e = this.getSiblings(t), i = 0, n = e.length; i < n; i++)
                    if (e[i] == t) return e[i - 1] || null;
                return null
            },
            getParent: function(t) {
                var e = null;
                return (e = void 0 !== t.id ? t : this.getItem(t)) ? e[this.$parentProperty] : this.$getRootId()
            },
            clearAll: function() {
                this._branches = {}, a.prototype.clearAll.call(this)
            },
            calculateItemLevel: function(t) {
                var e = 0;
                return this.eachParent(function() {
                    e++
                }, t), e
            },
            _setParentInner: function(t, e, i) {
                i || (t.hasOwnProperty("$rendered_parent") ? this._move_branch(t, t.$rendered_parent, e) : this._move_branch(t, t[this.$parentProperty], e))
            },
            setParent: function(t, e, i) {
                this._setParentInner(t, e, i), t[this.$parentProperty] = e
            },
            eachItem: function(t, e) {
                e = e || this.$getRootId();
                var i = this.getChildren(e);
                if (i)
                    for (var n = 0; n < i.length; n++) {
                        var r = this.pull[i[n]];
                        t.call(this, r), this.hasChild(r.id) && this.eachItem(t, r.id)
                    }
            },
            eachParent: function(t, e) {
                for (var i = {}, n = e, r = this.getParent(n); this.exists(r);) {
                    if (i[r]) throw new Error("Invalid tasks tree. Cyclic reference has been detected on task " + r);
                    i[r] = !0, n = this.getItem(r), t.call(this, n), r = this.getParent(n)
                }
            },
            _add_branch: function(t, e, i) {
                var r = void 0 === i ? this.getParent(t) : i;
                this.hasChild(r) || (this._branches[r] = n.$create());
                for (var a = this.getChildren(r), o = !1, s = 0, l = a.length; s < l; s++)
                    if (a[s] == t.id) {
                        o = !0;
                        break
                    }
                o || (1 * e == e ? a.splice(e, 0, t.id) : a.push(t.id), t.$rendered_parent = r)
            },
            _move_branch: function(t, e, i) {
                this._replace_branch_child(e, t.id), this.exists(i) || i == this.$getRootId() ? this._add_branch(t, void 0, i) : delete this._branches[t.id], t.$level = this.calculateItemLevel(t), this.eachItem(function(t) {
                    t.$level = this.calculateItemLevel(t)
                }, t.id)
            },
            _replace_branch_child: function(t, e, i) {
                var r = this.getChildren(t);
                if (r && void 0 !== t) {
                    for (var a = n.$create(), o = 0; o < r.length; o++) r[o] != e ? a.push(r[o]) : i && a.push(i);
                    this._branches[t] = a
                }
            },
            sort: function(t, e, i) {
                this.exists(i) || (i = this.$getRootId()), t || (t = "order");
                var n = "string" == typeof t ? function(e, i) {
                    return e[t] == i[t] ? 0 : e[t] > i[t] ? 1 : -1
                } : t;
                if (e) {
                    var r = n;
                    n = function(t, e) {
                        return r(e, t)
                    }
                }
                var a = this.getChildren(i);
                if (a) {
                    for (var o = [], s = a.length - 1; s >= 0; s--) o[s] = this.getItem(a[s]);
                    o.sort(n);
                    for (s = 0; s < o.length; s++) a[s] = o[s].id, this.sort(t, e, a[s])
                }
            },
            filter: function(t) {
                for (var e in this.pull) this.pull[e].$rendered_parent !== this.getParent(this.pull[e]) && this._move_branch(this.pull[e], this.pull[e].$rendered_parent, this.getParent(this.pull[e]));
                return a.prototype.filter.apply(this, arguments)
            },
            open: function(t) {
                this.exists(t) && (this.getItem(t).$open = !0, this.callEvent("onItemOpen", [t]))
            },
            close: function(t) {
                this.exists(t) && (this.getItem(t).$open = !1, this.callEvent("onItemClose", [t]))
            },
            destructor: function() {
                a.prototype.destructor.call(this), this._branches = null
            }
        }, a.prototype), t.exports = o
    }, function(t, e, i) {
        var n = i(0),
            r = {
                $create: function(t) {
                    return n.mixin(t || [], this)
                },
                $removeAt: function(t, e) {
                    t >= 0 && this.splice(t, e || 1)
                },
                $remove: function(t) {
                    this.$removeAt(this.$find(t))
                },
                $insertAt: function(t, e) {
                    if (e || 0 === e) {
                        var i = this.splice(e, this.length - e);
                        this[e] = t, this.push.apply(this, i)
                    } else this.push(t)
                },
                $find: function(t) {
                    for (var e = 0; e < this.length; e++)
                        if (t == this[e]) return e;
                    return -1
                },
                $each: function(t, e) {
                    for (var i = 0; i < this.length; i++) t.call(e || this, this[i])
                },
                $map: function(t, e) {
                    for (var i = 0; i < this.length; i++) this[i] = t.call(e || this, this[i]);
                    return this
                },
                $filter: function(t, e) {
                    for (var i = 0; i < this.length; i++) t.call(e || this, this[i]) || (this.splice(i, 1), i--);
                    return this
                }
            };
        t.exports = r
    }, function(t, e, i) {
        var n = i(30),
            r = i(0),
            a = i(4),
            o = function(t) {
                return this.pull = {}, this.$initItem = t.initItem, this.visibleOrder = n.$create(), this.fullOrder = n.$create(), this._skip_refresh = !1, this._filterRule = null, this._searchVisibleOrder = {}, this.$config = t, a(this), this
            };
        o.prototype = {
            _parseInner: function(t) {
                for (var e = null, i = [], n = 0, r = t.length; n < r; n++) e = t[n], this.$initItem && (e = this.$initItem(e)), this.callEvent("onItemLoading", [e]) && (this.pull.hasOwnProperty(e.id) || this.fullOrder.push(e.id), i.push(e), this.pull[e.id] = e);
                return i
            },
            parse: function(t) {
                this.callEvent("onBeforeParse", [t]);
                var e = this._parseInner(t);
                this.refresh(), this.callEvent("onParse", [e])
            },
            getItem: function(t) {
                return this.pull[t]
            },
            _updateOrder: function(t) {
                t.call(this.visibleOrder), t.call(this.fullOrder)
            },
            updateItem: function(t, e) {
                if (r.defined(e) || (e = this.getItem(t)), !this._skip_refresh && !1 === this.callEvent("onBeforeUpdate", [e.id, e])) return !1;
                this.pull[t] = e, this._skip_refresh || (this.callEvent("onAfterUpdate", [e.id, e]), this.callEvent("onStoreUpdated", [e.id, e, "update"]))
            },
            _removeItemInner: function(t) {
                this._updateOrder(function() {
                    this.$remove(t)
                }), delete this.pull[t]
            },
            removeItem: function(t) {
                var e = this.getItem(t);
                if (!this._skip_refresh && !1 === this.callEvent("onBeforeDelete", [e.id, e])) return !1;
                this._removeItemInner(t), this._skip_refresh || (this.filter(), this.callEvent("onAfterDelete", [e.id, e]), this.callEvent("onStoreUpdated", [e.id, e, "delete"]))
            },
            _addItemInner: function(t, e) {
                if (this.exists(t.id)) this.silent(function() {
                    this.updateItem(t.id, t)
                });
                else {
                    var i = this.visibleOrder,
                        n = i.length;
                    (!r.defined(e) || e < 0) && (e = n), e > n && (e = Math.min(i.length, e))
                }
                this.pull[t.id] = t, this._skip_refresh || this._updateOrder(function() {
                    -1 === this.$find(t.id) && this.$insertAt(t.id, e)
                }), this.filter()
            },
            isVisible: function(t) {
                return this.visibleOrder.$find(t) > -1
            },
            getVisibleItems: function() {
                return this.getIndexRange()
            },
            addItem: function(t, e) {
                return r.defined(t.id) || (t.id = r.uid()), this.$initItem && (t = this.$initItem(t)), !(!this._skip_refresh && !1 === this.callEvent("onBeforeAdd", [t.id, t])) && (this._addItemInner(t, e), this._skip_refresh || (this.callEvent("onAfterAdd", [t.id, t]), this.callEvent("onStoreUpdated", [t.id, t, "add"])), t.id)
            },
            _changeIdInner: function(t, e) {
                this.pull[t] && (this.pull[e] = this.pull[t]);
                var i = this._searchVisibleOrder[t];
                this.pull[e].id = e, this._updateOrder(function() {
                    this[this.$find(t)] = e
                }), this._searchVisibleOrder[e] = i, delete this._searchVisibleOrder[t], delete this.pull[t]
            },
            changeId: function(t, e) {
                this._changeIdInner(t, e), this.callEvent("onIdChange", [t, e])
            },
            exists: function(t) {
                return !!this.pull[t]
            },
            _moveInner: function(t, e) {
                var i = this.getIdByIndex(t);
                this._updateOrder(function() {
                    this.$removeAt(t), this.$insertAt(i, Math.min(this.length, e))
                })
            },
            move: function(t, e) {
                var i = this.getIdByIndex(t),
                    n = this.getItem(i);
                this._moveInner(t, e), this._skip_refresh || this.callEvent("onStoreUpdated", [n.id, n, "move"])
            },
            clearAll: function() {
                this.pull = {}, this.visibleOrder = n.$create(), this.fullOrder = n.$create(), this._skip_refresh || (this.callEvent("onClearAll", []), this.refresh())
            },
            silent: function(t, e) {
                this._skip_refresh = !0, t.call(e || this), this._skip_refresh = !1
            },
            arraysEqual: function(t, e) {
                if (t.length !== e.length) return !1;
                for (var i = 0; i < t.length; i++)
                    if (t[i] !== e[i]) return !1;
                return !0
            },
            refresh: function(t, e) {
                var i;
                if (!this._skip_refresh && (i = t ? [t, this.pull[t], "paint"] : [null, null, null], !1 !== this.callEvent("onBeforeStoreUpdate", i))) {
                    if (t) {
                        if (!e) {
                            var n = this.visibleOrder;
                            this.filter(), this.arraysEqual(n, this.visibleOrder) || (t = void 0)
                        }
                    } else this.filter();
                    i = t ? [t, this.pull[t], "paint"] : [null, null, null], this.callEvent("onStoreUpdated", i)
                }
            },
            count: function() {
                return this.fullOrder.length
            },
            countVisible: function() {
                return this.visibleOrder.length
            },
            sort: function(t) {},
            serialize: function() {},
            eachItem: function(t) {
                for (var e = 0; e < this.fullOrder.length; e++) {
                    var i = this.pull[this.fullOrder[e]];
                    t.call(this, i)
                }
            },
            filter: function(t) {
                this.callEvent("onBeforeFilter", []);
                var e = n.$create();
                this.eachItem(function(t) {
                    this.callEvent("onFilterItem", [t.id, t]) && e.push(t.id)
                }), this.visibleOrder = e, this._searchVisibleOrder = {};
                for (var i = 0; i < this.visibleOrder.length; i++) this._searchVisibleOrder[this.visibleOrder[i]] = i;
                this.callEvent("onFilter", [])
            },
            getIndexRange: function(t, e) {
                e = Math.min(e || 1 / 0, this.countVisible() - 1);
                for (var i = [], n = t || 0; n <= e; n++) i.push(this.getItem(this.visibleOrder[n]));
                return i
            },
            getItems: function() {
                var t = [];
                for (var e in this.pull) t.push(this.pull[e]);
                return t
            },
            getIdByIndex: function(t) {
                return this.visibleOrder[t]
            },
            getIndexById: function(t) {
                var e = this._searchVisibleOrder[t];
                return void 0 === e && (e = -1), e
            },
            _getNullIfUndefined: function(t) {
                return void 0 === t ? null : t
            },
            getFirst: function() {
                return this._getNullIfUndefined(this.visibleOrder[0])
            },
            getLast: function() {
                return this._getNullIfUndefined(this.visibleOrder[this.visibleOrder.length - 1])
            },
            getNext: function(t) {
                return this._getNullIfUndefined(this.visibleOrder[this.getIndexById(t) + 1])
            },
            getPrev: function(t) {
                return this._getNullIfUndefined(this.visibleOrder[this.getIndexById(t) - 1])
            },
            destructor: function() {
                this.detachAllEvents(), this.pull = null, this.$initItem = null, this.visibleOrder = null, this.fullOrder = null, this._skip_refresh = null, this._filterRule = null, this._searchVisibleOrder = null
            }
        }, t.exports = o
    }, function(t, e) {
        t.exports = function(t, e) {
            return {
                top: e.getItemTop(t.id),
                height: e.getItemHeight(t.id),
                left: 0,
                right: 1 / 0
            }
        }
    }, function(t, e) {
        t.exports = function(t) {
            function e(e, a) {
                if (!t._isAllowedUnscheduledTask(e) && t._isTaskInTimelineLimits(e)) {
                    var o = a.getItemPosition(e),
                        s = a.$getConfig(),
                        l = a.$getTemplates(),
                        c = a.getItemHeight(),
                        u = t.getTaskType(e.type),
                        d = Math.floor((t.config.row_height - c) / 2);
                    u == s.types.milestone && s.link_line_width > 1 && (d += 1), u == s.types.milestone && (o.left -= Math.round(c / 2), o.width = c);
                    var h = document.createElement("div"),
                        f = Math.round(o.width);
                    a.$config.item_attribute && h.setAttribute(a.$config.item_attribute, e.id), s.show_progress && u != s.types.milestone && function(e, i, n, r, a) {
                        var o = 1 * e.progress || 0;
                        n = Math.max(n - 2, 0);
                        var s = document.createElement("div"),
                            l = Math.round(n * o);
                        l = Math.min(n, l), e.progressColor && (s.style.backgroundColor = e.progressColor, s.style.opacity = 1), s.style.width = l + "px", s.className = "gantt_task_progress", s.innerHTML = a.progress_text(e.start_date, e.end_date, e), r.rtl && (s.style.position = "absolute", s.style.right = "0px");
                        var c = document.createElement("div");
                        if (c.className = "gantt_task_progress_wrapper", c.appendChild(s), i.appendChild(c), t.config.drag_progress && !t.isReadonly(e)) {
                            var u = document.createElement("div"),
                                d = l;
                            r.rtl && (d = n - l), u.style.left = d + "px", u.className = "gantt_task_progress_drag", s.appendChild(u), i.appendChild(u)
                        }
                    }(e, h, f, s, l);
                    var _ = function(e, i, n) {
                        var r = document.createElement("div");
                        return t.getTaskType(e.type) != t.config.types.milestone && (r.innerHTML = n.task_text(e.start_date, e.end_date, e)), r.className = "gantt_task_content", r
                    }(e, 0, l);
                    e.textColor && (_.style.color = e.textColor), h.appendChild(_);
                    var g = function(e, i, n, r) {
                        var a = r.$getConfig(),
                            o = [e];
                        i && o.push(i);
                        var s = t.getState(),
                            l = t.getTask(n);
                        if (t.getTaskType(l.type) == a.types.milestone ? o.push("gantt_milestone") : t.getTaskType(l.type) == a.types.project && o.push("gantt_project"), o.push("gantt_bar_" + t.getTaskType(l.type)), t.isSummaryTask(l) && o.push("gantt_dependent_task"), t.isSplitTask(l) && (a.open_split_tasks && !l.$open || !a.open_split_tasks) && o.push("gantt_split_parent"), a.select_task && t.isSelectedTask(n) && o.push("gantt_selected"), n == s.drag_id && (o.push("gantt_drag_" + s.drag_mode), s.touch_drag && o.push("gantt_touch_" + s.drag_mode)), s.link_source_id == n && o.push("gantt_link_source"), s.link_target_id == n && o.push("gantt_link_target"), a.highlight_critical_path && t.isCriticalTask && t.isCriticalTask(l) && o.push("gantt_critical_task"), s.link_landing_area && s.link_target_id && s.link_source_id && s.link_target_id != s.link_source_id) {
                            var c = s.link_source_id,
                                u = s.link_from_start,
                                d = s.link_to_start,
                                h = t.isLinkAllowed(c, n, u, d),
                                f = "";
                            f = h ? d ? "link_start_allow" : "link_finish_allow" : d ? "link_start_deny" : "link_finish_deny", o.push(f)
                        }
                        return o.join(" ")
                    }("gantt_task_line", l.task_class(e.start_date, e.end_date, e), e.id, a);
                    (e.color || e.progressColor || e.textColor) && (g += " gantt_task_inline_color"), h.className = g;
                    var p = ["left:" + o.left + "px", "top:" + (d + o.top) + "px", "height:" + c + "px", "line-height:" + Math.max(c < 30 ? c - 2 : c, 0) + "px", "width:" + f + "px"];
                    e.color && p.push("background-color:" + e.color), e.textColor && p.push("color:" + e.textColor), h.style.cssText = p.join(";");
                    var v = function(t, e, r) {
                        var a = "gantt_left " + n(!e.rtl, t);
                        return i(t, r.leftside_text, a)
                    }(e, s, l);
                    v && h.appendChild(v), (v = function(t, e, r) {
                        var a = "gantt_right " + n(!!e.rtl, t);
                        return i(t, r.rightside_text, a)
                    }(e, s, l)) && h.appendChild(v), t._waiAria.setTaskBarAttr(e, h);
                    var m = t.getState();
                    return t.isReadonly(e) || (s.drag_resize && !t.isSummaryTask(e) && u != s.types.milestone && r(h, "gantt_task_drag", e, function(t) {
                        var e = document.createElement("div");
                        return e.className = t, e
                    }, s), s.drag_links && s.show_links && r(h, "gantt_link_control", e, function(t) {
                        var e = document.createElement("div");
                        e.className = t, e.style.cssText = ["height:" + c + "px", "line-height:" + c + "px"].join(";");
                        var i = document.createElement("div");
                        i.className = "gantt_link_point";
                        var n = !1;
                        return m.link_source_id && s.touch && (n = !0), i.style.display = n ? "block" : "", e.appendChild(i), e
                    }, s)), h
                }
            }

            function i(t, e, i) {
                if (!e) return null;
                var n = e(t.start_date, t.end_date, t);
                if (!n) return null;
                var r = document.createElement("div");
                return r.className = "gantt_side_content " + i, r.innerHTML = n, r
            }

            function n(e, i) {
                var n = function(e) {
                    return e ? {
                        $source: [t.config.links.start_to_start],
                        $target: [t.config.links.start_to_start, t.config.links.finish_to_start]
                    } : {
                        $source: [t.config.links.finish_to_start, t.config.links.finish_to_finish],
                        $target: [t.config.links.finish_to_finish]
                    }
                }(e);
                for (var r in n)
                    for (var a = i[r], o = 0; o < a.length; o++)
                        for (var s = t.getLink(a[o]), l = 0; l < n[r].length; l++)
                            if (s.type == n[r][l]) return "gantt_link_crossing";
                return ""
            }

            function r(e, i, n, r, a) {
                var o, s = t.getState(); + n.start_date >= +s.min_date && ((o = r([i, a.rtl ? "task_right" : "task_left", "task_start_date"].join(" "))).setAttribute("data-bind-property", "start_date"), e.appendChild(o)), +n.end_date <= +s.max_date && ((o = r([i, a.rtl ? "task_left" : "task_right", "task_end_date"].join(" "))).setAttribute("data-bind-property", "end_date"), e.appendChild(o))
            }
            return function(i, n) {
                var r = n.$getConfig().type_renderers[t.getTaskType(i.type)],
                    a = e;
                return r ? r.call(t, i, function(e) {
                    return a.call(t, e, n)
                }, n) : a.call(t, i, n)
            }
        }
    }, function(t, e, i) {
        var n = i(0),
            r = i(38),
            a = i(15),
            o = i(3),
            s = function(t) {
                function e(e, i, n, r) {
                    var a = t.apply(this, arguments) || this;
                    return a.$config.bindLinks = null, a
                }
                return o(e, t), n.mixin(e.prototype, {
                    init: function() {
                        void 0 === this.$config.bind && (this.$config.bind = this.$getConfig().resource_store), t.prototype.init.apply(this, arguments)
                    },
                    _createLayerConfig: function() {
                        var t = this,
                            e = function() {
                                return t.isVisible()
                            };
                        return {
                            tasks: [{
                                renderer: this.$gantt.$ui.layers.resourceRow(),
                                container: this.$task_bars,
                                filter: [e]
                            }, {
                                renderer: this.$gantt.$ui.layers.taskBg(),
                                container: this.$task_bg,
                                filter: [e]
                            }],
                            links: []
                        }
                    }
                }, !0), n.mixin(e.prototype, a(e), !0), e
            }(r);
        t.exports = s
    }, function(t, e) {
        t.exports = function() {
            var t = {};
            return {
                _resetTopPositionHeight: function() {
                    t = {}
                },
                getRowTop: function(t) {
                    return t * this.$getConfig().row_height
                },
                getItemTop: function(e) {
                    if (this.$config.rowStore) {
                        if (void 0 !== t[e]) return t[e];
                        var i = this.$config.rowStore;
                        if (!i) return 0;
                        var n = i.getIndexById(e);
                        if (-1 === n && i.getParent && i.exists(e)) {
                            var r = i.getParent(e);
                            if (i.exists(r)) {
                                var a = i.getItem(r);
                                if (this.$gantt.isSplitTask(a)) return this.getRowTop(i.getIndexById(a.id))
                            }
                        }
                        return t[e] = this.getRowTop(n), t[e]
                    }
                    return 0
                }
            }
        }
    }, function(t, e, i) {
        var n = i(0);
        t.exports = function(t) {
            var e = t.date,
                i = t.$services;
            return {
                getSum: function(t, e, i) {
                    void 0 === i && (i = t.length - 1), void 0 === e && (e = 0);
                    for (var n = 0, r = e; r <= i; r++) n += t[r];
                    return n
                },
                setSumWidth: function(t, e, i, n) {
                    var r = e.width;
                    void 0 === n && (n = r.length - 1), void 0 === i && (i = 0);
                    var a = n - i + 1;
                    if (!(i > r.length - 1 || a <= 0 || n > r.length - 1)) {
                        var o = t - this.getSum(r, i, n);
                        this.adjustSize(o, r, i, n), this.adjustSize(-o, r, n + 1), e.full_width = this.getSum(r)
                    }
                },
                splitSize: function(t, e) {
                    for (var i = [], n = 0; n < e; n++) i[n] = 0;
                    return this.adjustSize(t, i), i
                },
                adjustSize: function(t, e, i, n) {
                    i || (i = 0), void 0 === n && (n = e.length - 1);
                    for (var r = n - i + 1, a = this.getSum(e, i, n), o = i; o <= n; o++) {
                        var s = Math.floor(t * (a ? e[o] / a : 1 / r));
                        a -= e[o], t -= s, r--, e[o] += s
                    }
                    e[e.length - 1] += t
                },
                sortScales: function(t) {
                    function i(t, i) {
                        var n = new Date(1970, 0, 1);
                        return e.add(n, i, t) - n
                    }
                    t.sort(function(t, e) {
                        return i(t.unit, t.step) < i(e.unit, e.step) ? 1 : i(t.unit, t.step) > i(e.unit, e.step) ? -1 : 0
                    });
                    for (var n = 0; n < t.length; n++) t[n].index = n
                },
                _isLegacyMode: function(t) {
                    var e = t || i.config();
                    return e.scale_unit || e.date_scale || e.subscales
                },
                _prepareScaleObject: function(e) {
                    var i = e.format;
                    return i || (i = e.template || e.date || "%d %M"), "string" == typeof i && (i = t.date.date_to_str(i)), {
                        unit: e.unit || "day",
                        step: e.step || 1,
                        format: i,
                        css: e.css
                    }
                },
                primaryScale: function(t) {
                    var e, n = i.getService("templateLoader"),
                        r = this._isLegacyMode(t),
                        a = t || i.config();
                    if (r) n.initTemplate("date_scale", void 0, void 0, a, i.templates()), e = {
                        unit: i.config().scale_unit,
                        step: i.config().step,
                        template: i.templates().date_scale,
                        date: i.config().date_scale,
                        css: i.templates().scale_cell_class
                    };
                    else {
                        var o = a.scales[0];
                        e = {
                            unit: o.unit,
                            step: o.step,
                            template: o.template,
                            format: o.format,
                            date: o.date,
                            css: o.css || i.templates().scale_cell_class
                        }
                    }
                    return this._prepareScaleObject(e)
                },
                getSubScales: function(t) {
                    var e = this._isLegacyMode(t),
                        n = t || i.config();
                    return (e ? n.subscales || [] : n.scales.slice(1)).map(function(t) {
                        return this._prepareScaleObject(t)
                    }.bind(this))
                },
                prepareConfigs: function(t, e, i, n, r, a, o) {
                    for (var s = this.splitSize(n, t.length), l = i, c = [], u = t.length - 1; u >= 0; u--) {
                        var d = u == t.length - 1,
                            h = this.initScaleConfig(t[u], r, a);
                        d && this.processIgnores(h), this.initColSizes(h, e, l, s[u]), this.limitVisibleRange(h), d && (l = h.full_width), c.unshift(h)
                    }
                    for (u = 0; u < c.length - 1; u++) this.alineScaleColumns(c[c.length - 1], c[u]);
                    for (u = 0; u < c.length; u++) o && this.reverseScale(c[u]), this.setPosSettings(c[u]);
                    return c
                },
                reverseScale: function(t) {
                    t.width = t.width.reverse(), t.trace_x = t.trace_x.reverse();
                    var e = t.trace_indexes;
                    t.trace_indexes = {}, t.trace_index_transition = {}, t.rtl = !0;
                    for (var i = 0; i < t.trace_x.length; i++) t.trace_indexes[t.trace_x[i].valueOf()] = i, t.trace_index_transition[e[t.trace_x[i].valueOf()]] = i;
                    return t
                },
                setPosSettings: function(t) {
                    for (var e = 0, i = t.trace_x.length; e < i; e++) t.left.push((t.width[e - 1] || 0) + (t.left[e - 1] || 0))
                },
                _ignore_time_config: function(t, n) {
                    if (i.config().skip_off_time) {
                        for (var r = !0, a = t, o = 0; o < n.step; o++) o && (a = e.add(t, o, n.unit)), r = r && !this.isWorkTime(a, n.unit);
                        return r
                    }
                    return !1
                },
                processIgnores: function(t) {
                    t.ignore_x = {}, t.display_count = t.count
                },
                initColSizes: function(t, i, n, r) {
                    var a = n;
                    t.height = r;
                    var o = void 0 === t.display_count ? t.count : t.display_count;
                    o || (o = 1), t.col_width = Math.floor(a / o), i && t.col_width < i && (t.col_width = i, a = t.col_width * o), t.width = [];
                    for (var s = t.ignore_x || {}, l = 0; l < t.trace_x.length; l++)
                        if (s[t.trace_x[l].valueOf()] || t.display_count == t.count) t.width[l] = 0;
                        else {
                            var c = 1;
                            "month" == t.unit && (c = Math.round((e.add(t.trace_x[l], t.step, t.unit) - t.trace_x[l]) / 864e5)), t.width[l] = c
                        }
                    this.adjustSize(a - this.getSum(t.width), t.width), t.full_width = this.getSum(t.width)
                },
                initScaleConfig: function(t, e, i) {
                    var r = n.mixin({
                        count: 0,
                        col_width: 0,
                        full_width: 0,
                        height: 0,
                        width: [],
                        left: [],
                        trace_x: [],
                        trace_indexes: {},
                        min_date: new Date(e),
                        max_date: new Date(i)
                    }, t);
                    return this.eachColumn(t.unit, t.step, e, i, function(t) {
                        r.count++, r.trace_x.push(new Date(t)), r.trace_indexes[t.valueOf()] = r.trace_x.length - 1
                    }), r.trace_x_ascending = r.trace_x.slice(), r
                },
                iterateScales: function(t, e, i, n, r) {
                    for (var a = e.trace_x, o = t.trace_x, s = i || 0, l = n || o.length - 1, c = 0, u = 1; u < a.length; u++) {
                        var d = t.trace_indexes[+a[u]];
                        void 0 !== d && d <= l && (r && r.apply(this, [c, u, s, d]), s = d, c = u)
                    }
                },
                alineScaleColumns: function(t, e, i, n) {
                    this.iterateScales(t, e, i, n, function(i, n, r, a) {
                        var o = this.getSum(t.width, r, a - 1);
                        this.getSum(e.width, i, n - 1) != o && this.setSumWidth(o, e, i, n - 1)
                    })
                },
                eachColumn: function(i, n, r, a, o) {
                    var s = new Date(r),
                        l = new Date(a);
                    e[i + "_start"] && (s = e[i + "_start"](s));
                    var c = new Date(s);
                    for (+c >= +l && (l = e.add(c, n, i)); + c < +l;) {
                        o.call(this, new Date(c));
                        var u = c.getTimezoneOffset();
                        c = e.add(c, n, i), c = t._correct_dst_change(c, u, n, i), e[i + "_start"] && (c = e[i + "_start"](c))
                    }
                },
                limitVisibleRange: function(t) {
                    var i = t.trace_x,
                        n = t.width.length - 1,
                        r = 0;
                    if (+i[0] < +t.min_date && 0 != n) {
                        var a = Math.floor(t.width[0] * ((i[1] - t.min_date) / (i[1] - i[0])));
                        r += t.width[0] - a, t.width[0] = a, i[0] = new Date(t.min_date)
                    }
                    var o = i.length - 1,
                        s = i[o],
                        l = e.add(s, t.step, t.unit);
                    if (+l > +t.max_date && o > 0 && (a = t.width[o] - Math.floor(t.width[o] * ((l - t.max_date) / (l - s))), r += t.width[o] - a, t.width[o] = a), r) {
                        for (var c = this.getSum(t.width), u = 0, d = 0; d < t.width.length; d++) {
                            var h = Math.floor(r * (t.width[d] / c));
                            t.width[d] += h, u += h
                        }
                        this.adjustSize(r - u, t.width)
                    }
                }
            }
        }
    }, function(t, e, i) {
        var n = i(36);
        t.exports = function(t) {
            var e = new n(t);
            return e.processIgnores = function(e) {
                var i = e.count;
                if (e.ignore_x = {}, t.ignore_time || t.config.skip_off_time) {
                    var n = t.ignore_time || function() {
                        return !1
                    };
                    i = 0;
                    for (var r = 0; r < e.trace_x.length; r++) n.call(t, e.trace_x[r]) || this._ignore_time_config.call(t, e.trace_x[r], e) ? (e.ignore_x[e.trace_x[r].valueOf()] = !0, e.ignored_colls = !0) : i++
                }
                e.display_count = i
            }, e
        }
    }, function(t, e, i) {
        var n = i(37),
            r = i(4),
            a = i(0),
            o = i(35),
            s = i(146),
            l = function(t, e, i, s) {
                this.$config = a.mixin({}, e || {}), this.$scaleHelper = new n(s), this.$gantt = s, this._posFromDateCache = {}, this._timelineDragScroll = null, a.mixin(this, o()), r(this)
            };

        function c(t, e) {
            for (var i, n, r, a = 0, o = t.length - 1; a <= o;)
                if (n = +t[i = Math.floor((a + o) / 2)], r = +t[i - 1], n < e) a = i + 1;
                else {
                    if (!(n > e)) {
                        for (; + t[i] == +t[i + 1];) i++;
                        return i
                    }
                    if (!isNaN(r) && r < e) return i - 1;
                    o = i - 1
                }
            return t.length - 1
        }
        l.prototype = {
            init: function(t) {
                t.innerHTML += "<div class='gantt_task' style='width:inherit;height:inherit;'></div>", this.$task = t.childNodes[0], this.$task.innerHTML = "<div class='gantt_task_scale'></div><div class='gantt_data_area'></div>", this.$task_scale = this.$task.childNodes[0], this.$task_data = this.$task.childNodes[1], this.$task_data.innerHTML = "<div class='gantt_task_bg'></div><div class='gantt_links_area'></div><div class='gantt_bars_area'></div>", this.$task_bg = this.$task_data.childNodes[0], this.$task_links = this.$task_data.childNodes[1], this.$task_bars = this.$task_data.childNodes[2], this._tasks = {
                    col_width: 0,
                    width: [],
                    full_width: 0,
                    trace_x: [],
                    rendered: {}
                };
                var e = this.$getConfig(),
                    i = e[this.$config.bind + "_attribute"],
                    n = e[this.$config.bindLinks + "_attribute"];
                !i && this.$config.bind && (i = this.$config.bind + "_id"), !n && this.$config.bindLinks && (n = this.$config.bindLinks + "_id"), this.$config.item_attribute = i || null, this.$config.link_attribute = n || null;
                var r = this._createLayerConfig();
                this.$config.layers || (this.$config.layers = r.tasks), this.$config.linkLayers || (this.$config.linkLayers = r.links), this._attachLayers(this.$gantt), this.callEvent("onReady", []), this.$gantt.ext.dragTimeline && (this._timelineDragScroll = this.$gantt.ext.dragTimeline.create(), this._timelineDragScroll.attach(this))
            },
            setSize: function(t, e) {
                var i = this.$getConfig();
                if (1 * t === t && (this.$config.width = t), 1 * e === e) {
                    this.$config.height = e;
                    var n = Math.max(this.$config.height - i.scale_height);
                    this.$task_data.style.height = n + "px"
                }
                if (this.refresh(), this.$task_bg.style.backgroundImage = "", i.smart_rendering && this.$config.rowStore) {
                    var r = this.$config.rowStore;
                    this.$task_bg.style.height = i.row_height * r.countVisible() + "px"
                } else this.$task_bg.style.height = "";
                for (var a = this._tasks, o = this.$task_data.childNodes, s = 0, l = o.length; s < l; s++) {
                    var c = o[s];
                    c.hasAttribute("data-layer") && c.style && (c.style.width = a.full_width + "px")
                }
            },
            isVisible: function() {
                return this.$parent && this.$parent.$config ? !this.$parent.$config.hidden : this.$task.offsetWidth
            },
            getSize: function() {
                var t = this.$getConfig(),
                    e = this.$config.rowStore,
                    i = e ? t.row_height * e.countVisible() : 0,
                    n = this.isVisible() ? this._tasks.full_width : 0;
                return {
                    x: this.isVisible() ? this.$config.width : 0,
                    y: this.isVisible() ? this.$config.height : 0,
                    contentX: this.isVisible() ? n : 0,
                    contentY: this.isVisible() ? t.scale_height + i : 0,
                    scrollHeight: this.isVisible() ? i : 0,
                    scrollWidth: this.isVisible() ? n : 0
                }
            },
            scrollTo: function(t, e) {
                if (this.isVisible()) {
                    var i = !1;
                    this.$config.scrollTop = this.$config.scrollTop || 0, this.$config.scrollLeft = this.$config.scrollLeft || 0, 1 * e === e && (this.$config.scrollTop = e, this.$task_data.scrollTop = this.$config.scrollTop, i = !0), 1 * t === t && (this.$task.scrollLeft = t, this.$config.scrollLeft = this.$task.scrollLeft, this._refreshScales(), i = !0), i && this.callEvent("onScroll", [this.$config.scrollLeft, this.$config.scrollTop])
                }
            },
            _refreshScales: function() {
                if (this.isVisible() && this.$getConfig().smart_scales) {
                    var t = this.getViewPort(),
                        e = this._scales;
                    this.$task_scale.innerHTML = this._getScaleChunkHtml(e, t.x, t.x_end)
                }
            },
            getViewPort: function() {
                var t = this.$config.scrollLeft || 0,
                    e = this.$config.scrollTop || 0,
                    i = this.$config.height || 0,
                    n = this.$config.width || 0;
                return {
                    y: e,
                    y_end: e + i,
                    x: t,
                    x_end: t + n,
                    height: i,
                    width: n
                }
            },
            _createLayerConfig: function() {
                var t = this,
                    e = function() {
                        return t.isVisible()
                    };
                return {
                    tasks: [{
                        expose: !0,
                        renderer: this.$gantt.$ui.layers.taskBar(),
                        container: this.$task_bars,
                        filter: [e]
                    }, {
                        renderer: this.$gantt.$ui.layers.taskSplitBar(),
                        filter: [e],
                        container: this.$task_bars,
                        append: !0
                    }, {
                        renderer: this.$gantt.$ui.layers.taskBg(),
                        container: this.$task_bg,
                        filter: [e]
                    }],
                    links: [{
                        expose: !0,
                        renderer: this.$gantt.$ui.layers.link(),
                        container: this.$task_links,
                        filter: [e]
                    }]
                }
            },
            _attachLayers: function(t) {
                this._taskLayers = [], this._linkLayers = [];
                var e = this,
                    i = this.$gantt.$services.getService("layers");
                if (this.$config.bind) {
                    this._bindStore();
                    var n = i.getDataRender(this.$config.bind);
                    n || (n = i.createDataRender({
                        name: this.$config.bind,
                        defaultContainer: function() {
                            return e.$task_data
                        }
                    })), n.container = function() {
                        return e.$task_data
                    };
                    for (var r = this.$config.layers, a = 0; r && a < r.length; a++) {
                        "string" == typeof(c = r[a]) && (c = this.$gantt.$ui.layers[c]()), ("function" == typeof c || c && c.render && c.update) && (c = {
                            renderer: c
                        }), c.view = this;
                        var o = n.addLayer(c);
                        this._taskLayers.push(o), c.expose && (this._taskRenderer = n.getLayer(o))
                    }
                    this._initStaticBackgroundRender()
                }
                if (this.$config.bindLinks) {
                    e.$config.linkStore = e.$gantt.getDatastore(e.$config.bindLinks);
                    var s = i.getDataRender(this.$config.bindLinks);
                    s || (s = i.createDataRender({
                        name: this.$config.bindLinks,
                        defaultContainer: function() {
                            return e.$task_data
                        }
                    }));
                    var l = this.$config.linkLayers;
                    for (a = 0; l && a < l.length; a++) {
                        var c;
                        "string" == typeof c && (c = this.$gantt.$ui.layers[c]()), (c = l[a]).view = this;
                        var u = s.addLayer(c);
                        this._taskLayers.push(u), l[a].expose && (this._linkRenderer = s.getLayer(u))
                    }
                }
            },
            _initStaticBackgroundRender: function() {
                var t = this,
                    e = s.create(),
                    i = t.$config.rowStore;
                i && (this._staticBgHandler = i.attachEvent("onStoreUpdated", function(i, n, r) {
                    if (null === i && t.isVisible()) {
                        var a = t.$getConfig();
                        if (a.static_background) {
                            var o = t.$gantt.getDatastore(t.$config.bind),
                                s = t.$task_bg_static;
                            s || ((s = document.createElement("div")).className = "gantt_task_bg", t.$task_bg_static = s, t.$task_bg.nextSibling ? t.$task_data.insertBefore(s, t.$task_bg.nextSibling) : t.$task_data.appendChild(s)), o && e.render(s, a, t.getScale(), a.row_height * o.countVisible())
                        } else a.static_background && t.$task_bg_static && t.$task_bg_static.parentNode && t.$task_bg_static.parentNode.removeChild(t.$task_bg_static)
                    }
                }), this.attachEvent("onDestroy", function() {
                    e.destroy()
                }), this._initStaticBackgroundRender = function() {})
            },
            _clearLayers: function(t) {
                var e = this.$gantt.$services.getService("layers"),
                    i = e.getDataRender(this.$config.bind),
                    n = e.getDataRender(this.$config.bindLinks);
                if (this._taskLayers)
                    for (var r = 0; r < this._taskLayers.length; r++) i.removeLayer(this._taskLayers[r]);
                if (this._linkLayers)
                    for (r = 0; r < this._linkLayers.length; r++) n.removeLayer(this._linkLayers[r]);
                this._linkLayers = [], this._taskLayers = []
            },
            _render_tasks_scales: function() {
                var t = this.$getConfig(),
                    e = "",
                    i = 0,
                    n = 0,
                    r = this.$gantt.getState();
                if (this.isVisible()) {
                    var a = this.$scaleHelper,
                        o = this._getScales();
                    n = t.scale_height;
                    var s = this.$config.width;
                    "x" != t.autosize && "xy" != t.autosize || (s = Math.max(t.autosize_min_width, 0));
                    var l = a.prepareConfigs(o, t.min_column_width, s, n - 1, r.min_date, r.max_date, t.rtl),
                        c = this._tasks = l[l.length - 1];
                    this._scales = l, this._posFromDateCache = {}, e = this._getScaleChunkHtml(l, 0, this.$config.width), i = c.full_width + "px", n += "px"
                }
                this.$task_scale.style.height = n, this.$task_data.style.width = this.$task_scale.style.width = i, this.$task_scale.innerHTML = e
            },
            _getScaleChunkHtml: function(t, e, i) {
                for (var n = [], r = this.$gantt.$services.templates().scale_row_class, a = 0; a < t.length; a++) {
                    var o = "gantt_scale_line",
                        s = r(t[a]);
                    s && (o += " " + s), n.push('<div class="' + o + '" style="height:' + t[a].height + "px;position:relative;line-height:" + t[a].height + 'px">' + this._prepareScaleHtml(t[a], e, i) + "</div>")
                }
                return n.join("")
            },
            _prepareScaleHtml: function(t, e, i) {
                var n = this.$getConfig(),
                    r = this.$gantt.$services.templates(),
                    a = [],
                    o = null,
                    s = null,
                    l = t.format || t.template || t.date;
                "string" == typeof l && (l = this.$gantt.date.date_to_str(l));
                var u = 0,
                    d = t.count;
                !n.smart_scales || isNaN(e) || isNaN(i) || (u = c(t.left, e), d = c(t.left, i) + 1), s = t.css || function() {}, !t.css && n.inherit_scale_class && (s = r.scale_cell_class);
                for (var h = u; h < d && t.trace_x[h]; h++) {
                    o = new Date(t.trace_x[h]);
                    var f = l.call(this, o),
                        _ = t.width[h],
                        g = t.height,
                        p = t.left[h],
                        v = "",
                        m = "",
                        y = "";
                    if (_) {
                        v = "width:" + _ + "px;height:" + g + "px;" + (n.smart_scales ? "position:absolute;left:" + p + "px" : ""), y = "gantt_scale_cell" + (h == t.count - 1 ? " gantt_last_cell" : ""), (m = s.call(this, o)) && (y += " " + m);
                        var b = "<div class='" + y + "'" + this.$gantt._waiAria.getTimelineCellAttr(f) + " style='" + v + "'>" + f + "</div>";
                        a.push(b)
                    }
                }
                return a.join("")
            },
            dateFromPos: function(t) {
                var e = this._tasks;
                if (t < 0 || t > e.full_width || !e.full_width) return null;
                var i = c(this._tasks.left, t),
                    n = this._tasks.left[i],
                    r = e.width[i] || e.col_width,
                    a = 0;
                r && (a = (t - n) / r, e.rtl && (a = 1 - a));
                var o = 0;
                return a && (o = this._getColumnDuration(e, e.trace_x[i])), new Date(e.trace_x[i].valueOf() + Math.round(a * o))
            },
            posFromDate: function(t) {
                if (!this.isVisible()) return 0;
                if (!t) return 0;
                var e = String(t.valueOf());
                if (void 0 !== this._posFromDateCache[e]) return this._posFromDateCache[e];
                var i = this.columnIndexByDate(t);
                this.$gantt.assert(i >= 0, "Invalid day index");
                var n = Math.floor(i),
                    r = i % 1,
                    a = this._tasks.left[Math.min(n, this._tasks.width.length - 1)];
                n == this._tasks.width.length && (a += this._tasks.width[this._tasks.width.length - 1]), r && (n < this._tasks.width.length ? a += this._tasks.width[n] * (r % 1) : a += 1);
                var o = Math.round(a);
                return this._posFromDateCache[e] = o, Math.round(o)
            },
            _getNextVisibleColumn: function(t, e, i) {
                for (var n = +e[t], r = t; i[n];) n = +e[++r];
                return r
            },
            _getPrevVisibleColumn: function(t, e, i) {
                for (var n = +e[t], r = t; i[n];) n = +e[--r];
                return r
            },
            _getClosestVisibleColumn: function(t, e, i) {
                var n = this._getNextVisibleColumn(t, e, i);
                return e[n] || (n = this._getPrevVisibleColumn(t, e, i)), n
            },
            columnIndexByDate: function(t) {
                var e = new Date(t).valueOf(),
                    i = this._tasks.trace_x_ascending,
                    n = this._tasks.ignore_x,
                    r = this.$gantt.getState();
                if (e <= r.min_date) return this._tasks.rtl ? i.length : 0;
                if (e >= r.max_date) return this._tasks.rtl ? 0 : i.length;
                var a = c(i, e),
                    o = this._getClosestVisibleColumn(a, i, n),
                    s = i[o],
                    l = this._tasks.trace_index_transition;
                if (!s) return l ? l[0] : 0;
                var u = (t - i[o]) / this._getColumnDuration(this._tasks, i[o]);
                return l ? l[o] + (1 - u) : o + u
            },
            getItemPosition: function(t, e, i) {
                var n, r, a;
                return this._tasks.rtl ? (r = this.posFromDate(e || t.start_date), n = this.posFromDate(i || t.end_date)) : (n = this.posFromDate(e || t.start_date), r = this.posFromDate(i || t.end_date)), a = Math.max(r - n, 0), {
                    left: n,
                    top: this.getItemTop(t.id),
                    height: this.getItemHeight(),
                    width: a
                }
            },
            getItemHeight: function() {
                var t = this.$getConfig(),
                    e = t.task_height;
                if ("full" == e) {
                    var i = t.task_height_offset || 5;
                    e = t.row_height - i
                }
                return e = Math.min(e, t.row_height), Math.max(e, 0)
            },
            getScale: function() {
                return this._tasks
            },
            _getScales: function() {
                var t = this.$getConfig(),
                    e = this.$scaleHelper,
                    i = [e.primaryScale(t)].concat(e.getSubScales(t));
                return e.sortScales(i), i
            },
            _getColumnDuration: function(t, e) {
                return this.$gantt.date.add(e, t.step, t.unit) - e
            },
            _bindStore: function() {
                if (this.$config.bind) {
                    var t = this.$gantt.getDatastore(this.$config.bind);
                    if (this.$config.rowStore = t, t && !t._timelineCacheAttached) {
                        var e = this;
                        t._timelineCacheAttached = t.attachEvent("onBeforeFilter", function() {
                            e._resetTopPositionHeight()
                        })
                    }
                }
            },
            _unbindStore: function() {
                if (this.$config.bind) {
                    var t = this.$gantt.getDatastore(this.$config.bind);
                    t._timelineCacheAttached && (t.detachEvent(t._timelineCacheAttached), t._timelineCacheAttached = !1)
                }
            },
            refresh: function() {
                this._bindStore(), this.$config.bindLinks && (this.$config.linkStore = this.$gantt.getDatastore(this.$config.bindLinks)), this._resetTopPositionHeight(), this._initStaticBackgroundRender(), this._render_tasks_scales()
            },
            destructor: function() {
                var t = this.$gantt;
                this._clearLayers(t), this._unbindStore(), this.$task = null, this.$task_scale = null, this.$task_data = null, this.$task_bg = null, this.$task_links = null, this.$task_bars = null, this.$gantt = null, this.$config.rowStore && (this.$config.rowStore.detachEvent(this._staticBgHandler), this.$config.rowStore = null), this.$config.linkStore && (this.$config.linkStore = null), this._timelineDragScroll && (this._timelineDragScroll.destructor(), this._timelineDragScroll = null), this.callEvent("onDestroy", []), this.detachAllEvents()
            }
        }, t.exports = l
    }, function(t, e, i) {
        var n = i(3),
            r = i(1),
            a = function(t) {
                "use strict";

                function e(e, i, n) {
                    var r = t.apply(this, arguments) || this;
                    return e && (r.$root = !0), r._parseConfig(i), r.$name = "layout", r
                }
                return n(e, t), e.prototype.destructor = function() {
                    this.$container && this.$view && r.removeNode(this.$view);
                    for (var e = 0; e < this.$cells.length; e++) {
                        this.$cells[e].destructor()
                    }
                    this.$cells = [], t.prototype.destructor.call(this)
                }, e.prototype._resizeScrollbars = function(t, e) {
                    var i, n = !1,
                        r = [],
                        a = [];

                    function o(t) {
                        t.$parent.show(), n = !0, r.push(t)
                    }

                    function s(t) {
                        t.$parent.hide(), n = !0, a.push(t)
                    }
                    for (var l = 0; l < e.length; l++) t[(i = e[l]).$config.scroll] ? s(i) : i.shouldHide() ? s(i) : i.shouldShow() ? o(i) : i.isVisible() ? r.push(i) : a.push(i);
                    var c = {};
                    for (l = 0; l < r.length; l++) r[l].$config.group && (c[r[l].$config.group] = !0);
                    for (l = 0; l < a.length; l++)(i = a[l]).$config.group && c[i.$config.group] && o(i);
                    return n
                }, e.prototype._syncCellSizes = function(t, e) {
                    if (t) {
                        var i = {};
                        return this._eachChild(function(t) {
                            t.$config.group && "scrollbar" != t.$name && "resizer" != t.$name && (i[t.$config.group] || (i[t.$config.group] = []), i[t.$config.group].push(t))
                        }), i[t] && this._syncGroupSize(i[t], e), i[t]
                    }
                }, e.prototype._syncGroupSize = function(t, e) {
                    if (t.length)
                        for (var i = t[0].$parent._xLayout ? "width" : "height", n = t[0].$parent.getNextSibling(t[0].$id) ? 1 : -1, r = 0; r < t.length; r++) {
                            var a = t[r].getSize(),
                                o = n > 0 ? t[r].$parent.getNextSibling(t[r].$id) : t[r].$parent.getPrevSibling(t[r].$id);
                            "resizer" == o.$name && (o = n > 0 ? o.$parent.getNextSibling(o.$id) : o.$parent.getPrevSibling(o.$id));
                            var s = o.getSize();
                            if (o[i]) {
                                var l = a.gravity + s.gravity,
                                    c = a[i] + s[i],
                                    u = l / c;
                                t[r].$config.gravity = u * e, o.$config[i] = c - e, o.$config.gravity = l - u * e
                            } else t[r].$config[i] = e;
                            var d = this.$gantt.$ui.getView("grid");
                            d && t[r].$content === d && !d.$config.scrollable && (this.$gantt.config.grid_width = e)
                        }
                }, e.prototype.resize = function(e) {
                    var i = !1;
                    if (this.$root && !this._resizeInProgress && (this.callEvent("onBeforeResize", []), i = !0, this._resizeInProgress = !0), t.prototype.resize.call(this, !0), t.prototype.resize.call(this, !1), i) {
                        var n = [];
                        n = (n = (n = n.concat(this.getCellsByType("viewCell"))).concat(this.getCellsByType("viewLayout"))).concat(this.getCellsByType("hostCell"));
                        for (var r = this.getCellsByType("scroller"), a = 0; a < n.length; a++) n[a].$config.hidden || n[a].setContentSize();
                        var o = this._getAutosizeMode(this.$config.autosize),
                            s = this._resizeScrollbars(o, r);
                        if (this.$config.autosize && (this.autosize(this.$config.autosize), s = !0), s) {
                            this.resize();
                            for (a = 0; a < n.length; a++) n[a].$config.hidden || n[a].setContentSize()
                        }
                        this.callEvent("onResize", [])
                    }
                    i && (this._resizeInProgress = !1)
                }, e.prototype._eachChild = function(t, e) {
                    if (t(e = e || this), e.$cells)
                        for (var i = 0; i < e.$cells.length; i++) this._eachChild(t, e.$cells[i])
                }, e.prototype.isChild = function(t) {
                    var e = !1;
                    return this._eachChild(function(i) {
                        i !== t && i.$content !== t || (e = !0)
                    }), e
                }, e.prototype.getCellsByType = function(t) {
                    var i = [];
                    if (t === this.$name && i.push(this), this.$content && this.$content.$name == t && i.push(this.$content), this.$cells)
                        for (var n = 0; n < this.$cells.length; n++) {
                            var r = e.prototype.getCellsByType.call(this.$cells[n], t);
                            r.length && i.push.apply(i, r)
                        }
                    return i
                }, e.prototype.getNextSibling = function(t) {
                    var e = this.cellIndex(t);
                    return e >= 0 && this.$cells[e + 1] ? this.$cells[e + 1] : null
                }, e.prototype.getPrevSibling = function(t) {
                    var e = this.cellIndex(t);
                    return e >= 0 && this.$cells[e - 1] ? this.$cells[e - 1] : null
                }, e.prototype.cell = function(t) {
                    for (var e = 0; e < this.$cells.length; e++) {
                        var i = this.$cells[e];
                        if (i.$id === t) return i;
                        var n = i.cell(t);
                        if (n) return n
                    }
                }, e.prototype.cellIndex = function(t) {
                    for (var e = 0; e < this.$cells.length; e++)
                        if (this.$cells[e].$id === t) return e;
                    return -1
                }, e.prototype.moveView = function(t, e) {
                    if (this.$cells[e] !== t) return window.alert("Not implemented");
                    e += this.$config.header ? 1 : 0;
                    var i = this.$view;
                    e >= i.childNodes.length ? i.appendChild(t.$view) : i.insertBefore(t.$view, i.childNodes[e])
                }, e.prototype._parseConfig = function(t) {
                    this.$cells = [], this._xLayout = !t.rows;
                    for (var e = t.rows || t.cols || t.views, i = 0; i < e.length; i++) {
                        var n = e[i];
                        n.mode = this._xLayout ? "x" : "y";
                        var r = this.$factory.initUI(n, this);
                        r ? (r.$parent = this, this.$cells.push(r)) : (e.splice(i, 1), i--)
                    }
                }, e.prototype.getCells = function() {
                    return this.$cells
                }, e.prototype.render = function() {
                    var t = r.insertNode(this.$container, this.$toHTML());
                    this.$fill(t, null), this.callEvent("onReady", []), this.resize(), this.render = this.resize
                }, e.prototype.$fill = function(t, e) {
                    this.$view = t, this.$parent = e;
                    for (var i = r.getChildNodes(t, "gantt_layout_cell"), n = i.length - 1; n >= 0; n--) {
                        var a = this.$cells[n];
                        a.$fill(i[n], this), a.$config.hidden && a.$view.parentNode.removeChild(a.$view)
                    }
                }, e.prototype.$toHTML = function() {
                    for (var e = this._xLayout ? "x" : "y", i = [], n = 0; n < this.$cells.length; n++) i.push(this.$cells[n].$toHTML());
                    return t.prototype.$toHTML.call(this, i.join(""), (this.$root ? "gantt_layout_root " : "") + "gantt_layout gantt_layout_" + e)
                }, e.prototype.getContentSize = function(t) {
                    for (var e, i, n, r = 0, a = 0, o = 0; o < this.$cells.length; o++)(i = this.$cells[o]).$config.hidden || (e = i.getContentSize(t), "scrollbar" === i.$config.view && t[i.$config.scroll] && (e.height = 0, e.width = 0), i.$config.resizer && (this._xLayout ? e.height = 0 : e.width = 0), n = i._getBorderSizes(), this._xLayout ? (r += e.width + n.horizontal, a = Math.max(a, e.height + n.vertical)) : (r = Math.max(r, e.width + n.horizontal), a += e.height + n.vertical));
                    return r += (n = this._getBorderSizes()).horizontal, a += n.vertical, this.$root && (r += 1, a += 1), {
                        width: r,
                        height: a
                    }
                }, e.prototype._cleanElSize = function(t) {
                    return 1 * (t || "").toString().replace("px", "") || 0
                }, e.prototype._getBoxStyles = function(t) {
                    var e = null,
                        i = ["width", "height", "paddingTop", "paddingBottom", "paddingLeft", "paddingRight", "borderLeftWidth", "borderRightWidth", "borderTopWidth", "borderBottomWidth"],
                        n = {
                            boxSizing: "border-box" == (e = window.getComputedStyle ? window.getComputedStyle(t, null) : {
                                width: t.clientWidth,
                                height: t.clientHeight
                            }).boxSizing
                        };
                    e.MozBoxSizing && (n.boxSizing = "border-box" == e.MozBoxSizing);
                    for (var r = 0; r < i.length; r++) n[i[r]] = e[i[r]] ? this._cleanElSize(e[i[r]]) : 0;
                    var a = {
                        horPaddings: n.paddingLeft + n.paddingRight + n.borderLeftWidth + n.borderRightWidth,
                        vertPaddings: n.paddingTop + n.paddingBottom + n.borderTopWidth + n.borderBottomWidth,
                        borderBox: n.boxSizing,
                        innerWidth: n.width,
                        innerHeight: n.height,
                        outerWidth: n.width,
                        outerHeight: n.height
                    };
                    return a.borderBox ? (a.innerWidth -= a.horPaddings, a.innerHeight -= a.vertPaddings) : (a.outerWidth += a.horPaddings, a.outerHeight += a.vertPaddings), a
                }, e.prototype._getAutosizeMode = function(t) {
                    var e = {
                        x: !1,
                        y: !1
                    };
                    return "xy" === t ? e.x = e.y = !0 : "y" === t || !0 === t ? e.y = !0 : "x" === t && (e.x = !0), e
                }, e.prototype.autosize = function(t) {
                    var e = this._getAutosizeMode(t),
                        i = this._getBoxStyles(this.$container),
                        n = this.getContentSize(t),
                        r = this.$container;
                    e.x && (i.borderBox && (n.width += i.horPaddings), r.style.width = n.width + "px"), e.y && (i.borderBox && (n.height += i.vertPaddings), r.style.height = n.height + "px")
                }, e.prototype.getSize = function() {
                    this._sizes = [];
                    for (var e = 0, i = 0, n = 1e5, r = 0, a = 1e5, o = 0, s = 0; s < this.$cells.length; s++) {
                        var l = this._sizes[s] = this.$cells[s].getSize();
                        this.$cells[s].$config.hidden || (this._xLayout ? (!l.width && l.minWidth ? e += l.minWidth : e += l.width, n += l.maxWidth, i += l.minWidth, r = Math.max(r, l.height), a = Math.min(a, l.maxHeight), o = Math.max(o, l.minHeight)) : (!l.height && l.minHeight ? r += l.minHeight : r += l.height, a += l.maxHeight, o += l.minHeight, e = Math.max(e, l.width), n = Math.min(n, l.maxWidth), i = Math.max(i, l.minWidth)))
                    }
                    var c = t.prototype.getSize.call(this);
                    return c.maxWidth >= 1e5 && (c.maxWidth = n), c.maxHeight >= 1e5 && (c.maxHeight = a), c.minWidth = c.minWidth != c.minWidth ? 0 : c.minWidth, c.minHeight = c.minHeight != c.minHeight ? 0 : c.minHeight, this._xLayout ? (c.minWidth += this.$config.margin * this.$cells.length || 0, c.minWidth += 2 * this.$config.padding || 0, c.minHeight += 2 * this.$config.padding || 0) : (c.minHeight += this.$config.margin * this.$cells.length || 0, c.minHeight += 2 * this.$config.padding || 0), c
                }, e.prototype._calcFreeSpace = function(t, e, i) {
                    var n = i ? e.minWidth : e.minHeight,
                        r = e.maxWidth,
                        a = t;
                    return a ? (a > r && (a = r), a < n && (a = n), this._free -= a) : ((a = Math.floor(this._free / this._gravity * e.gravity)) > r && (a = r, this._free -= a, this._gravity -= e.gravity), a < n && (a = n, this._free -= a, this._gravity -= e.gravity)), a
                }, e.prototype._calcSize = function(t, e, i) {
                    var n = t,
                        r = i ? e.minWidth : e.minHeight,
                        a = i ? e.maxWidth : e.maxHeight;
                    return n || (n = Math.floor(this._free / this._gravity * e.gravity)), n > a && (n = a), n < r && (n = r), n
                }, e.prototype._configureBorders = function() {
                    this.$root && this._setBorders([this._borders.left, this._borders.top, this._borders.right, this._borders.bottom], this);
                    for (var t = this._xLayout ? this._borders.right : this._borders.bottom, e = this.$cells, i = e.length - 1, n = i; n >= 0; n--)
                        if (!e[n].$config.hidden) {
                            i = n;
                            break
                        }
                    for (n = 0; n < e.length; n++)
                        if (!e[n].$config.hidden) {
                            var r = n >= i,
                                a = "";
                            !r && e[n + 1] && "scrollbar" == e[n + 1].$config.view && (this._xLayout ? r = !0 : a = "gantt_layout_cell_border_transparent"), this._setBorders(r ? [] : [t, a], e[n])
                        }
                }, e.prototype._updateCellVisibility = function() {
                    for (var t, e = this._visibleCells || {}, i = !this._visibleCells, n = {}, r = 0; r < this._sizes.length; r++) t = this.$cells[r], !i && t.$config.hidden && e[t.$id] ? t._hide(!0) : t.$config.hidden || e[t.$id] || t._hide(!1), t.$config.hidden || (n[t.$id] = !0);
                    this._visibleCells = n
                }, e.prototype.setSize = function(e, i) {
                    this._configureBorders(), t.prototype.setSize.call(this, e, i), i = this.$lastSize.contentY, e = this.$lastSize.contentX;
                    var n, r, a = this.$config.padding || 0;
                    this.$view.style.padding = a + "px", this._gravity = 0, this._free = this._xLayout ? e : i, this._free -= 2 * a, this._updateCellVisibility();
                    for (var o = 0; o < this._sizes.length; o++)
                        if (!(n = this.$cells[o]).$config.hidden) {
                            var s = this.$config.margin || 0;
                            "resizer" != n.$name || s || (s = -1);
                            var l = n.$view,
                                c = this._xLayout ? "marginRight" : "marginBottom";
                            o !== this.$cells.length - 1 && (l.style[c] = s + "px", this._free -= s), r = this._sizes[o], this._xLayout ? r.width || (this._gravity += r.gravity) : r.height || (this._gravity += r.gravity)
                        }
                    for (o = 0; o < this._sizes.length; o++)
                        if (!(n = this.$cells[o]).$config.hidden) {
                            var u = (r = this._sizes[o]).width,
                                d = r.height;
                            this._xLayout ? this._calcFreeSpace(u, r, !0) : this._calcFreeSpace(d, r, !1)
                        }
                    for (o = 0; o < this.$cells.length; o++)
                        if (!(n = this.$cells[o]).$config.hidden) {
                            r = this._sizes[o];
                            var h = void 0,
                                f = void 0;
                            this._xLayout ? (h = this._calcSize(r.width, r, !0), f = i - 2 * a) : (h = e - 2 * a, f = this._calcSize(r.height, r, !1)), n.setSize(h, f)
                        }
                }, e
            }(i(7));
        t.exports = a
    }, function(t, e) {
        t.exports = function(t, e) {
            return {
                top: e.getItemTop(t.id),
                height: e.getItemHeight(t.id),
                left: 0,
                right: 1 / 0
            }
        }
    }, function(t, e) {
        var i, n, r = t.exports = {};

        function a() {
            throw new Error("setTimeout has not been defined")
        }

        function o() {
            throw new Error("clearTimeout has not been defined")
        }

        function s(t) {
            if (i === setTimeout) return setTimeout(t, 0);
            if ((i === a || !i) && setTimeout) return i = setTimeout, setTimeout(t, 0);
            try {
                return i(t, 0)
            } catch (e) {
                try {
                    return i.call(null, t, 0)
                } catch (e) {
                    return i.call(this, t, 0)
                }
            }
        }! function() {
            try {
                i = "function" == typeof setTimeout ? setTimeout : a
            } catch (t) {
                i = a
            }
            try {
                n = "function" == typeof clearTimeout ? clearTimeout : o
            } catch (t) {
                n = o
            }
        }();
        var l, c = [],
            u = !1,
            d = -1;

        function h() {
            u && l && (u = !1, l.length ? c = l.concat(c) : d = -1, c.length && f())
        }

        function f() {
            if (!u) {
                var t = s(h);
                u = !0;
                for (var e = c.length; e;) {
                    for (l = c, c = []; ++d < e;) l && l[d].run();
                    d = -1, e = c.length
                }
                l = null, u = !1,
                    function(t) {
                        if (n === clearTimeout) return clearTimeout(t);
                        if ((n === o || !n) && clearTimeout) return n = clearTimeout, clearTimeout(t);
                        try {
                            n(t)
                        } catch (e) {
                            try {
                                return n.call(null, t)
                            } catch (e) {
                                return n.call(this, t)
                            }
                        }
                    }(t)
            }
        }

        function _(t, e) {
            this.fun = t, this.array = e
        }

        function g() {}
        r.nextTick = function(t) {
            var e = new Array(arguments.length - 1);
            if (arguments.length > 1)
                for (var i = 1; i < arguments.length; i++) e[i - 1] = arguments[i];
            c.push(new _(t, e)), 1 !== c.length || u || s(f)
        }, _.prototype.run = function() {
            this.fun.apply(null, this.array)
        }, r.title = "browser", r.browser = !0, r.env = {}, r.argv = [], r.version = "", r.versions = {}, r.on = g, r.addListener = g, r.once = g, r.off = g, r.removeListener = g, r.removeAllListeners = g, r.emit = g, r.prependListener = g, r.prependOnceListener = g, r.listeners = function(t) {
            return []
        }, r.binding = function(t) {
            throw new Error("process.binding is not supported")
        }, r.cwd = function() {
            return "/"
        }, r.chdir = function(t) {
            throw new Error("process.chdir is not supported")
        }, r.umask = function() {
            return 0
        }
    }, function(t, e) {
        t.exports = function(t, e) {
            if (!e) return !0;
            if (t._on_timeout) return !1;
            var i = Math.ceil(1e3 / e);
            return i < 2 || (setTimeout(function() {
                delete t._on_timeout
            }, i), t._on_timeout = !0, !0)
        }
    }, function(t, e) {
        t.exports = function(t) {}
    }, function(t, e, i) {
        "use strict";
        Object.defineProperty(e, "__esModule", {
            value: !0
        }), e.default = function() {}
    }, function(t, e) {
        t.exports = function(t) {
            t.destructor = function() {
                for (var e in t.callEvent("onDestroy", []), this.clearAll(), this.$root && delete this.$root.gantt, this._eventRemoveAll(), this.$layout && this.$layout.destructor(), this.resetLightbox(), this._dp && this._dp.destructor && this._dp.destructor(), this.$services.destructor(), this.detachAllEvents(), this) 0 === e.indexOf("$") && delete this[e];
                t.$destroyed = !0
            }
        }
    }, function(t, e) {
        t.exports = function(t) {
            return function(e, i) {
                e || t.config.show_errors && !1 !== t.callEvent("onError", [i]) && t.message({
                    type: "error",
                    text: i,
                    expire: -1
                })
            }
        }
    }, function(t, e, i) {
        var n = i(1),
            r = i(2);
        t.exports = function(t) {
            var e = i(28);

            function a(t, e) {
                var i;
                t.event(e, "resize", function() {
                    clearTimeout(i), i = setTimeout(function() {
                        t.render()
                    }, 300)
                })
            }
            t.assert = i(46)(t), t.init = function(t, e, i) {
                e && i && (this.config.start_date = this._min_date = new Date(e), this.config.end_date = this._max_date = new Date(i)), this.date.init(), this.config.scroll_size || (this.config.scroll_size = n.getScrollSize() || 1), this.init = function(t) {
                    this.$container && this.$container.parentNode && (this.$container.parentNode.removeChild(this.$container), this.$container = null), this.$layout && this.$layout.clear(), this._reinit(t)
                }, this._reinit(t)
            }, t._reinit = function(i) {
                this.callEvent("onBeforeGanttReady", []), this._eventRemoveAll(), this.$mouseEvents.reset(), this.resetLightbox(), this._update_flags(), this.$services.getService("templateLoader").initTemplates(this), this._clearTaskLayers(), this._clearLinkLayers(), this.$layout && (this.$layout.destructor(), this.$ui.reset()), this.$root = n.toNode(i), this.$root && (this.$root.innerHTML = ""), this.$root.gantt = this, e(this), this.config.layout.id = "main", this.$layout = this.$ui.createView("layout", i, this.config.layout), this.$layout.attachEvent("onBeforeResize", function() {
                        for (var e = t.$services.getService("datastores"), i = 0; i < e.length; i++) t.getDatastore(e[i]).filter()
                    }), this.$layout.attachEvent("onResize", function() {
                        t.refreshData()
                    }), this.callEvent("onGanttLayoutReady", []), this.$layout.render(), t.$container = this.$layout.$container.firstChild,
                    function(t) {
                        "static" == window.getComputedStyle(t.$root).getPropertyValue("position") && (t.$root.style.position = "relative");
                        var e = document.createElement("iframe");
                        e.className = "gantt_container_resize_watcher", e.tabIndex = -1, t.$root.appendChild(e), e.contentWindow ? a(t, e.contentWindow) : (t.$root.removeChild(e), a(t, window))
                    }(t), this.callEvent("onTemplatesReady", []), this.$mouseEvents.reset(this.$root), this.callEvent("onGanttReady", []), this.render()
            }, t.$click = {
                buttons: {
                    edit: function(e) {
                        t.showLightbox(e)
                    },
                    delete: function(e) {
                        var i = t.locale.labels.confirm_deleting,
                            n = t.locale.labels.confirm_deleting_title;
                        t._dhtmlx_confirm(i, n, function() {
                            t.isTaskExists(e) ? (t.getTask(e).$new ? (t.silent(function() {
                                t.deleteTask(e, !0)
                            }), t.refreshData()) : t.deleteTask(e), t.hideLightbox()) : t.hideLightbox()
                        })
                    }
                }
            }, t.render = function() {
                this.callEvent("onBeforeGanttRender", []), !this.config.sort && this._sort && (this._sort = void 0);
                var i = this.getScrollState(),
                    n = i ? i.x : 0;
                this._getHorizontalScrollbar() && (n = this._getHorizontalScrollbar().$config.codeScrollLeft || n || 0);
                var r = null;
                if (n && (r = t.dateFromPos(n + this.config.task_scroll_offset)), e(this), this.$layout.$config.autosize = this.config.autosize, this.$layout.resize(), this.config.preserve_scroll && i && n) {
                    var a = t.getScrollState(); + r == +t.dateFromPos(a.x) && a.y == i.y || (r && this.showDate(r), i.y && t.scrollTo(void 0, i.y))
                }
                this.callEvent("onGanttRender", [])
            }, t.setSizes = t.render, t.locate = function(t) {
                var e = n.getTargetNode(t);
                if ((n.getClassName(e) || "").indexOf("gantt_task_cell") >= 0) return null;
                var i = arguments[1] || this.config.task_attribute,
                    r = n.locateAttribute(e, i);
                return r ? r.getAttribute(i) : null
            }, t._locate_css = function(t, e, i) {
                return n.locateClassName(t, e, i)
            }, t._locateHTML = function(t, e) {
                return n.locateAttribute(t, e || this.config.task_attribute)
            }, t.getTaskRowNode = function(t) {
                for (var e = this.$grid_data.childNodes, i = this.config.task_attribute, n = 0; n < e.length; n++) {
                    if (e[n].getAttribute)
                        if (e[n].getAttribute(i) == t) return e[n]
                }
                return null
            }, t.changeLightboxType = function(e) {
                if (this.getLightboxType() == e) return !0;
                t._silent_redraw_lightbox(e)
            }, t._get_link_type = function(e, i) {
                var n = null;
                return e && i ? n = t.config.links.start_to_start : !e && i ? n = t.config.links.finish_to_start : e || i ? e && !i && (n = t.config.links.start_to_finish) : n = t.config.links.finish_to_finish, n
            }, t.isLinkAllowed = function(t, e, i, n) {
                var r = null;
                if (!(r = "object" == typeof t ? t : {
                        source: t,
                        target: e,
                        type: this._get_link_type(i, n)
                    })) return !1;
                if (!(r.source && r.target && r.type)) return !1;
                if (r.source == r.target) return !1;
                var a = !0;
                return this.checkEvent("onLinkValidation") && (a = this.callEvent("onLinkValidation", [r])), a
            }, t._correct_dst_change = function(e, i, n, a) {
                var o = r.getSecondsInUnit(a) * n;
                if (o > 3600 && o < 86400) {
                    var s = e.getTimezoneOffset() - i;
                    s && (e = t.date.add(e, s, "minute"))
                }
                return e
            }, t.isSplitTask = function(e) {
                return t.assert(e && e instanceof Object, "Invalid argument <b>task</b>=" + e + " of gantt.isSplitTask. Task object was expected"), this.$data.tasksStore._isSplitItem(e)
            }, t._is_icon_open_click = function(t) {
                if (!t) return !1;
                var e = t.target || t.srcElement;
                if (!e || !e.className) return !1;
                var i = n.getClassName(e);
                return -1 !== i.indexOf("gantt_tree_icon") && (-1 !== i.indexOf("gantt_close") || -1 !== i.indexOf("gantt_open"))
            }
        }
    }, function(t, e) {
        t.exports = function(t) {
            t.locale = {
                date: {
                    month_full: ["January", "February", "March", "April", "May", "June", "July", "August", "September", "October", "November", "December"],
                    month_short: ["Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"],
                    day_full: ["Sunday", "Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday"],
                    day_short: ["Sun", "Mon", "Tue", "Wed", "Thu", "Fri", "Sat"]
                },
                labels: {
                    new_task: "New task",
                    icon_save: "Save",
                    icon_cancel: "Cancel",
                    icon_details: "Details",
                    icon_edit: "Edit",
                    icon_delete: "Delete",
                    confirm_closing: "",
                    confirm_deleting: "Task will be deleted permanently, are you sure?",
                    section_description: "Description",
                    section_time: "Time period",
                    section_type: "Type",
                    column_wbs: "WBS",
                    column_text: "Task name",
                    column_start_date: "Start time",
                    column_duration: "Duration",
                    column_add: "",
                    link: "Link",
                    confirm_link_deleting: "will be deleted",
                    link_start: " (start)",
                    link_end: " (end)",
                    type_task: "Task",
                    type_project: "Project",
                    type_milestone: "Milestone",
                    minutes: "Minutes",
                    hours: "Hours",
                    days: "Days",
                    weeks: "Week",
                    months: "Months",
                    years: "Years",
                    message_ok: "OK",
                    message_cancel: "Cancel",
                    section_constraint: "Constraint",
                    constraint_type: "Constraint type",
                    constraint_date: "Constraint date",
                    asap: "As Soon As Possible",
                    alap: "As Late As Possible",
                    snet: "Start No Earlier Than",
                    snlt: "Start No Later Than",
                    fnet: "Finish No Earlier Than",
                    fnlt: "Finish No Later Than",
                    mso: "Must Start On",
                    mfo: "Must Finish On",
                    resources_filter_placeholder: "type to filter",
                    resources_filter_label: "hide empty"
                }
            }
        }
    }, function(t, e) {
        t.exports = function(t) {
            function e() {
                var e;
                return t.$ui.getView("timeline") && (e = t.$ui.getView("timeline")._tasks_dnd), e
            }
            t.config.touch_drag = 500, t.config.touch = !0, t.config.touch_feedback = !0, t.config.touch_feedback_duration = 1, t._prevent_touch_scroll = !1, t._touch_feedback = function() {
                t.config.touch_feedback && navigator.vibrate && navigator.vibrate(t.config.touch_feedback_duration)
            }, t.attachEvent("onGanttReady", t.bind(function() {
                if ("force" != this.config.touch && (this.config.touch = this.config.touch && (-1 != navigator.userAgent.indexOf("Mobile") || -1 != navigator.userAgent.indexOf("iPad") || -1 != navigator.userAgent.indexOf("Android") || -1 != navigator.userAgent.indexOf("Touch"))), this.config.touch) {
                    var t = !0;
                    try {
                        document.createEvent("TouchEvent")
                    } catch (e) {
                        t = !1
                    }
                    t ? this._touch_events(["touchmove", "touchstart", "touchend"], function(t) {
                        return t.touches && t.touches.length > 1 ? null : t.touches[0] ? {
                            target: t.target,
                            pageX: t.touches[0].pageX,
                            pageY: t.touches[0].pageY,
                            clientX: t.touches[0].clientX,
                            clientY: t.touches[0].clientY
                        } : t
                    }, function() {
                        return !1
                    }) : window.navigator.pointerEnabled ? this._touch_events(["pointermove", "pointerdown", "pointerup"], function(t) {
                        return "mouse" == t.pointerType ? null : t
                    }, function(t) {
                        return !t || "mouse" == t.pointerType
                    }) : window.navigator.msPointerEnabled && this._touch_events(["MSPointerMove", "MSPointerDown", "MSPointerUp"], function(t) {
                        return t.pointerType == t.MSPOINTER_TYPE_MOUSE ? null : t
                    }, function(t) {
                        return !t || t.pointerType == t.MSPOINTER_TYPE_MOUSE
                    })
                }
            }, t));
            var i = [];
            t._touch_events = function(n, r, a) {
                for (var o, s = 0, l = !1, c = !1, u = null, d = null, h = null, f = 0; f < i.length; f++) t.eventRemove(i[f][0], i[f][1], i[f][2]);
                (i = []).push([t.$container, n[0], function(i) {
                    var n = e();
                    if (!a(i) && l) {
                        d && clearTimeout(d);
                        var h = r(i);
                        if (n && (n.drag.id || n.drag.start_drag)) return n.on_mouse_move(h), i.preventDefault && i.preventDefault(), i.cancelBubble = !0, !1;
                        if (!t._prevent_touch_scroll) {
                            if (h && u) {
                                var f = u.pageX - h.pageX,
                                    g = u.pageY - h.pageY;
                                if (!c && (Math.abs(f) > 5 || Math.abs(g) > 5) && (t._touch_scroll_active = c = !0, s = 0, o = t.getScrollState()), c) {
                                    t.scrollTo(o.x + f, o.y + g);
                                    var p = t.getScrollState();
                                    if (o.x != p.x && g > 2 * f || o.y != p.y && f > 2 * g) return _(i)
                                }
                            }
                            return _(i)
                        }
                        return !0
                    }
                }]), i.push([this.$container, "contextmenu", function(t) {
                    if (l) return _(t)
                }]), i.push([this.$container, n[1], function(i) {
                    if (!a(i))
                        if (i.touches && i.touches.length > 1) l = !1;
                        else {
                            u = r(i), t._locate_css(u, "gantt_hor_scroll") || t._locate_css(u, "gantt_ver_scroll") || (l = !0);
                            var n = e();
                            d = setTimeout(function() {
                                var e = t.locate(u);
                                n && e && !t._locate_css(u, "gantt_link_control") && !t._locate_css(u, "gantt_grid_data") && (n.on_mouse_down(u), n.drag && n.drag.start_drag && (! function(e) {
                                    var i = t._getTaskLayers(),
                                        n = t.getTask(e);
                                    if (n && t.isTaskVisible(e))
                                        for (var r = 0; r < i.length; r++)
                                            if ((n = i[r].rendered[e]) && n.getAttribute(t.config.task_attribute) && n.getAttribute(t.config.task_attribute) == e) {
                                                var a = n.cloneNode(!0);
                                                h = n, i[r].rendered[e] = a, n.style.display = "none", a.className += " gantt_drag_move ", n.parentNode.appendChild(a)
                                            }
                                }(e), n._start_dnd(u), t._touch_drag = !0, t.refreshTask(e), t._touch_feedback())), d = null
                            }, t.config.touch_drag)
                        }
                }]), i.push([this.$container, n[2], function(i) {
                    if (!a(i)) {
                        d && clearTimeout(d), t._touch_drag = !1, l = !1;
                        var n = r(i),
                            o = e();
                        if (o && o.on_mouse_up(n), h && (t.refreshTask(t.locate(h)), h.parentNode && (h.parentNode.removeChild(h), t._touch_feedback())), t._touch_scroll_active = l = c = !1, h = null, u && s) {
                            var f = new Date;
                            if (f - s < 500) t.$services.getService("mouseEvents").onDoubleClick(u), _(i);
                            else s = f
                        } else s = new Date
                    }
                }]);
                for (f = 0; f < i.length; f++) t.event(i[f][0], i[f][1], i[f][2]);

                function _(t) {
                    return t && t.preventDefault && t.preventDefault(), (t || event).cancelBubble = !0, !1
                }
            }
        }
    }, function(t, e) {
        t.exports = function(t) {
            t.skins.contrast_white = {
                config: {
                    grid_width: 360,
                    row_height: 35,
                    scale_height: 35,
                    link_line_width: 2,
                    link_arrow_size: 6,
                    lightbox_additional_height: 75
                },
                _second_column_width: 100,
                _third_column_width: 80
            }
        }
    }, function(t, e) {
        t.exports = function(t) {
            t.skins.contrast_black = {
                config: {
                    grid_width: 360,
                    row_height: 35,
                    scale_height: 35,
                    link_line_width: 2,
                    link_arrow_size: 6,
                    lightbox_additional_height: 75
                },
                _second_column_width: 100,
                _third_column_width: 80
            }
        }
    }, function(t, e) {
        t.exports = function(t) {
            t.skins.material = {
                config: {
                    grid_width: 411,
                    row_height: 34,
                    task_height_offset: 6,
                    scale_height: 36,
                    link_line_width: 2,
                    link_arrow_size: 6,
                    lightbox_additional_height: 80
                },
                _second_column_width: 110,
                _third_column_width: 75,
                _redefine_lightbox_buttons: {
                    buttons_left: ["dhx_delete_btn"],
                    buttons_right: ["dhx_save_btn", "dhx_cancel_btn"]
                }
            }, t.attachEvent("onAfterTaskDrag", function(e) {
                var i = t.getTaskNode(e);
                i && (i.className += " gantt_drag_animation", setTimeout(function() {
                    var t = i.className.indexOf(" gantt_drag_animation");
                    t > -1 && (i.className = i.className.slice(0, t))
                }, 200))
            })
        }
    }, function(t, e) {
        t.exports = function(t) {
            t.skins.broadway = {
                config: {
                    grid_width: 360,
                    row_height: 35,
                    scale_height: 35,
                    link_line_width: 1,
                    link_arrow_size: 7,
                    lightbox_additional_height: 86
                },
                _second_column_width: 90,
                _third_column_width: 80,
                _lightbox_template: "<div class='gantt_cal_ltitle'><span class='gantt_mark'>&nbsp;</span><span class='gantt_time'></span><span class='gantt_title'></span><div class='gantt_cancel_btn'></div></div><div class='gantt_cal_larea'></div>",
                _config_buttons_left: {},
                _config_buttons_right: {
                    gantt_delete_btn: "icon_delete",
                    gantt_save_btn: "icon_save"
                }
            }
        }
    }, function(t, e) {
        t.exports = function(t) {
            t.skins.terrace = {
                config: {
                    grid_width: 360,
                    row_height: 35,
                    scale_height: 35,
                    link_line_width: 2,
                    link_arrow_size: 6,
                    lightbox_additional_height: 75
                },
                _second_column_width: 90,
                _third_column_width: 70
            }
        }
    }, function(t, e) {
        t.exports = function(t) {
            t.skins.meadow = {
                config: {
                    grid_width: 350,
                    row_height: 27,
                    scale_height: 30,
                    link_line_width: 2,
                    link_arrow_size: 6,
                    lightbox_additional_height: 72
                },
                _second_column_width: 95,
                _third_column_width: 80
            }
        }
    }, function(t, e) {
        t.exports = function(t) {
            t.skins.skyblue = {
                config: {
                    grid_width: 350,
                    row_height: 27,
                    scale_height: 27,
                    link_line_width: 1,
                    link_arrow_size: 8,
                    lightbox_additional_height: 75
                },
                _second_column_width: 95,
                _third_column_width: 80
            }
        }
    }, function(t, e) {
        function i(t, e) {
            var i = e.skin;
            if (!i || t)
                for (var n = document.getElementsByTagName("link"), r = 0; r < n.length; r++) {
                    var a = n[r].href.match("dhtmlxgantt_([a-z_]+).css");
                    if (a && (e.skins[a[1]] || !i)) {
                        i = a[1];
                        break
                    }
                }
            e.skin = i || "terrace";
            var o = e.skins[e.skin] || e.skins.terrace;
            ! function(t, e, i) {
                for (var n in e)(void 0 === t[n] || i) && (t[n] = e[n])
            }(e.config, o.config, t);
            var s = e.getGridColumns();
            s[1] && !e.defined(s[1].width) && (s[1].width = o._second_column_width), s[2] && !e.defined(s[2].width) && (s[2].width = o._third_column_width);
            for (r = 0; r < s.length; r++) {
                var l = s[r];
                "add" == l.name && (l.width || (l.width = 44), e.defined(l.min_width) && e.defined(l.max_width) || (l.min_width = l.min_width || l.width, l.max_width = l.max_width || l.width), l.min_width && (l.min_width = +l.min_width), l.max_width && (l.max_width = +l.max_width), l.width && (l.width = +l.width, l.width = l.min_width && l.min_width > l.width ? l.min_width : l.width, l.width = l.max_width && l.max_width < l.width ? l.max_width : l.width))
            }
            o.config.task_height && (e.config.task_height = o.config.task_height || "full"), o._lightbox_template && (e._lightbox_template = o._lightbox_template), o._redefine_lightbox_buttons && (e.config.buttons_right = o._redefine_lightbox_buttons.buttons_right, e.config.buttons_left = o._redefine_lightbox_buttons.buttons_left), e.resetLightbox()
        }
        t.exports = function(t) {
            t.resetSkin || (t.resetSkin = function() {
                this.skin = "", i(!0, this)
            }, t.skins = {}, t.attachEvent("onGanttLayoutReady", function() {
                i(!1, this)
            }))
        }
    }, function(t, e) {
        t.exports = function(t) {
            function e() {
                return t._cached_functions.update_if_changed(t), t._cached_functions.active || t._cached_functions.activate(), !0
            }
            t._cached_functions = {
                cache: {},
                mode: !1,
                critical_path_mode: !1,
                wrap_methods: function(t, e) {
                    if (e._prefetch_originals)
                        for (var i in e._prefetch_originals) e[i] = e._prefetch_originals[i];
                    e._prefetch_originals = {};
                    for (i = 0; i < t.length; i++) this.prefetch(t[i], e)
                },
                prefetch: function(t, e) {
                    var i = e[t];
                    if (i) {
                        var n = this;
                        e._prefetch_originals[t] = i, e[t] = function() {
                            for (var e = new Array(arguments.length), r = 0, a = arguments.length; r < a; r++) e[r] = arguments[r];
                            if (n.active) {
                                var o = n.get_arguments_hash(Array.prototype.slice.call(e));
                                n.cache[t] || (n.cache[t] = {});
                                var s = n.cache[t];
                                if (n.has_cached_value(s, o)) return n.get_cached_value(s, o);
                                var l = i.apply(this, e);
                                return n.cache_value(s, o, l), l
                            }
                            return i.apply(this, e)
                        }
                    }
                    return i
                },
                cache_value: function(t, e, i) {
                    this.is_date(i) && (i = new Date(i)), t[e] = i
                },
                has_cached_value: function(t, e) {
                    return t.hasOwnProperty(e)
                },
                get_cached_value: function(t, e) {
                    var i = t[e];
                    return this.is_date(i) && (i = new Date(i)), i
                },
                is_date: function(t) {
                    return t && t.getUTCDate
                },
                get_arguments_hash: function(t) {
                    for (var e = [], i = 0; i < t.length; i++) e.push(this.stringify_argument(t[i]));
                    return "(" + e.join(";") + ")"
                },
                stringify_argument: function(t) {
                    return (t.id ? t.id : this.is_date(t) ? t.valueOf() : t) + ""
                },
                activate: function() {
                    this.clear(), this.active = !0
                },
                deactivate: function() {
                    this.clear(), this.active = !1
                },
                clear: function() {
                    this.cache = {}
                },
                setup: function(t) {
                    var e = [],
                        i = ["_isProjectEnd", "_getProjectEnd", "_getSlack"];
                    "auto" == this.mode ? t.config.highlight_critical_path && (e = i) : !0 === this.mode && (e = i), this.wrap_methods(e, t)
                },
                update_if_changed: function(t) {
                    (this.critical_path_mode != t.config.highlight_critical_path || this.mode !== t.config.optimize_render) && (this.critical_path_mode = t.config.highlight_critical_path, this.mode = t.config.optimize_render, this.setup(t))
                }
            }, t.attachEvent("onBeforeGanttRender", e), t.attachEvent("onBeforeDataRender", e), t.attachEvent("onBeforeSmartRender", function() {
                e()
            }), t.attachEvent("onBeforeParse", e), t.attachEvent("onDataRender", function() {
                t._cached_functions.deactivate()
            });
            var i = null;
            t.attachEvent("onSmartRender", function() {
                i && clearTimeout(i), i = setTimeout(function() {
                    t._cached_functions.deactivate()
                }, 1e3)
            }), t.attachEvent("onBeforeGanttReady", function() {
                return t._cached_functions.update_if_changed(t), !0
            })
        }
    }, function(t, e, i) {
        var n = i(3);
        t.exports = function(t) {
            var e = i(12)(t);

            function r() {
                return e.apply(this, arguments) || this
            }
            return n(r, e), r.prototype.render = function(i) {
                var n = t.config.types,
                    r = t.locale.labels,
                    a = [],
                    o = i.filter || function(t, e) {
                        return !n.placeholder || e !== n.placeholder
                    };
                for (var s in n) !1 == !o(s, n[s]) && a.push({
                    key: n[s],
                    label: r["type_" + s]
                });
                i.options = a;
                var l = i.onchange;
                return i.onchange = function() {
                    t.changeLightboxType(this.value), "function" == typeof l && l.apply(this, arguments)
                }, e.prototype.render.apply(this, arguments)
            }, r
        }
    }, function(t, e, i) {
        t.exports = function(t) {
            var e = i(59)(t);
            t.getTaskType = function(e) {
                var i = e;
                for (var n in e && "object" == typeof e && (i = e.type), this.config.types)
                    if (this.config.types[n] == i) return i;
                return t.config.types.task
            }, t.form_blocks.typeselect = new e
        }
    }, function(t, e) {
        t.exports = function(t) {
            t._extend_to_optional = function(e) {
                var i = e,
                    n = {
                        render: i.render,
                        focus: i.focus,
                        set_value: function(e, r, a, o) {
                            var s = t._resolve_default_mapping(o);
                            if (!a[s.start_date] || "start_date" == s.start_date && this._isAllowedUnscheduledTask(a)) {
                                n.disable(e, o);
                                var l = {};
                                for (var c in s) l[s[c]] = a[c];
                                return i.set_value.call(t, e, r, l, o)
                            }
                            return n.enable(e, o), i.set_value.call(t, e, r, a, o)
                        },
                        get_value: function(e, n, r) {
                            return r.disabled ? {
                                start_date: null
                            } : i.get_value.call(t, e, n, r)
                        },
                        update_block: function(e, i) {
                            if (t.callEvent("onSectionToggle", [t._lightbox_id, i]), e.style.display = i.disabled ? "none" : "block", i.button) {
                                var n = e.previousSibling.querySelector(".gantt_custom_button_label"),
                                    r = t.locale.labels,
                                    a = i.disabled ? r[i.name + "_enable_button"] : r[i.name + "_disable_button"];
                                n.innerHTML = a
                            }
                            t.resizeLightbox()
                        },
                        disable: function(t, e) {
                            e.disabled = !0, n.update_block(t, e)
                        },
                        enable: function(t, e) {
                            e.disabled = !1, n.update_block(t, e)
                        },
                        button_click: function(e, i, r, a) {
                            if (!1 !== t.callEvent("onSectionButton", [t._lightbox_id, r])) {
                                var o = t._get_typed_lightbox_config()[e];
                                o.disabled ? n.enable(a, o) : n.disable(a, o)
                            }
                        }
                    };
                return n
            }, t.form_blocks.duration_optional = t._extend_to_optional(t.form_blocks.duration), t.form_blocks.time_optional = t._extend_to_optional(t.form_blocks.time)
        }
    }, function(t, e, i) {
        var n = i(3),
            r = i(11);
        t.exports = function(t) {
            var e = i(5)(t);

            function a() {
                return e.apply(this, arguments) || this
            }

            function o(e) {
                return !e || e === t.config.constraint_types.ASAP || e === t.config.constraint_types.ALAP
            }

            function s(t, e) {
                for (var i = o(e), n = 0; n < t.length; n++) t[n].disabled = i
            }
            return n(a, e), a.prototype.render = function(e) {
                var i = (e.height || 30) + "px",
                    n = "<div class='gantt_cal_ltext gantt_section_" + e.name + "' style='height:" + i + ";'>",
                    a = [];
                for (var o in t.config.constraint_types) a.push({
                    key: t.config.constraint_types[o],
                    label: t.locale.labels[t.config.constraint_types[o]]
                });
                return e.options = e.options || a, n += "<span data-constraint-type-select>" + r.getHtmlSelect(e.options, [{
                    key: "data-type",
                    value: "constraint-type"
                }]) + "</span>", n += "<label data-constraint-time-select>" + (t.locale.labels.constraint_date || "Constraint date") + ": " + t.form_blocks.getTimePicker.call(this, e) + "</label>", n += "</div>"
            }, a.prototype.set_value = function(e, i, n, r) {
                var a = e.querySelector("[data-constraint-type-select] select"),
                    o = e.querySelectorAll("[data-constraint-time-select] select"),
                    l = r._time_format_order,
                    c = t._resolve_default_mapping(r);
                a._eventsInitialized || (a.addEventListener("change", function(t) {
                    s(o, t.target.value)
                }), a._eventsInitialized = !0);
                var u = n[c.constraint_date] || new Date;
                t.form_blocks._fill_lightbox_select(o, 0, u, l, r);
                var d = n[c.constraint_type] || t.getConstraintType(n);
                a.value = d, s(o, d)
            }, a.prototype.get_value = function(e, i, n) {
                var r = e.querySelector("[data-constraint-type-select] select"),
                    a = e.querySelectorAll("[data-constraint-time-select] select"),
                    s = r.value,
                    l = null;
                return o(s) || (l = t.form_blocks.getTimePickerValue(a, n)), {
                    constraint_type: s,
                    constraint_date: l
                }
            }, a.prototype.focus = function(e) {
                t._focus(e.querySelector("select"))
            }, a
        }
    }, function(t, e, i) {
        var n = i(2),
            r = i(1),
            a = i(11),
            o = i(3);
        t.exports = function(t) {
            var e = i(5)(t),
                s = {
                    resources: {},
                    resourcesValues: {},
                    filter: {},
                    eventsInitialized: {}
                };

            function l() {
                return e.apply(this, arguments) || this
            }

            function c(t) {
                return void 0 === t ? ".gantt_resource_amount_input" : "[data-checked='" + (t ? "true" : "false") + "'] .gantt_resource_amount_input"
            }

            function u(t) {
                return s.resources[t.id]
            }

            function d(t) {
                return s.filter[t.id]
            }
            return t.attachEvent("onAfterLightbox", function() {
                for (var t in s.filter) s.filter[t].checkbox.checked = !1, s.filter[t].input.value = "", s.filter[t].filterApplied = !1;
                s.resourcesValues = {}
            }), o(l, e), l.prototype.render = function(e) {
                var i, n = t.locale.labels.resources_filter_placeholder || e.filter_placeholder || "type to filter",
                    r = t.locale.labels.resources_filter_label || "hide empty";
                return i = "<div" + (isNaN(e.height) ? "" : " style='height: " + e.height + "px;'") + ">", i += "<div class='gantt_cal_ltext gantt_resources_filter'><input type='text' class='gantt_resources_filter_input' placeholder='" + n + "'> <label><input class='switch_unsetted' type='checkbox'><span class='matherial_checkbox_icon'></span>" + r + "</label></div>", i += "<div class='gantt_cal_ltext gantt_resources' data-name='" + e.name + "'></div>", i += "</div>"
            }, l.prototype.set_value = function(e, i, o, l) {
                var h, f = function(t, e) {
                        s.resources[e.id] || (s.resources[e.id] = t.querySelector(".gantt_resources"));
                        return s.resources[e.id]
                    }(e, l),
                    _ = "";
                ! function(t, e) {
                    if (!s.filter[e.id]) {
                        var i = t.querySelector(".gantt_resources_filter"),
                            n = i.querySelector(".gantt_resources_filter_input"),
                            r = i.querySelector(".switch_unsetted");
                        s.filter[e.id] = {
                            container: i,
                            input: n,
                            checkbox: r,
                            filterApplied: !1
                        }
                    }
                    s.filter[e.id]
                }(e, l),
                function(e, i, a, o) {
                    if (s.eventsInitialized[a.id]) return;
                    var l = function(r) {
                        var l, c, u, h, f, _ = i[a.map_to],
                            g = d(a);
                        f = g.checkbox, h = g.input, u = f.checked, c = function(t) {
                            return t.value.trim()
                        }(h), l = function(e, i, r, a) {
                            var o, l;
                            if (a) {
                                var c = i[e.map_to] || [];
                                if (n.isArray(c) || (c = [c]), 0 === (c = c.slice()).length) {
                                    for (var u in c = [], (l = t.copy(e)).options = [], s.resourcesValues[e.id]) c.push({
                                        resource_id: u,
                                        value: s.resourcesValues[e.id][u]
                                    });
                                    if (0 === c.length) return l
                                } else
                                    for (var u in s.resourcesValues[e.id]) {
                                        var d = n.arrayFind(c, function(t) {
                                            return t.id == u
                                        });
                                        d || c.push({
                                            resource_id: u,
                                            value: s.resourcesValues[e.id][u]
                                        })
                                    }
                                for (var h = {}, f = 0; f < c.length; f++) h[c[f].resource_id] = !0;
                                o = function(t) {
                                    if (h[String(t.key)] && ("" === r || t.label.toLowerCase().indexOf(r.toLowerCase()) >= 0)) return t
                                }
                            } else {
                                if ("" === r) return e;
                                o = function(t) {
                                    if (t.label.toLowerCase().indexOf(r.toLowerCase()) >= 0) return t
                                }
                            }
                            return (l = t.copy(e)).options = n.arrayFilter(l.options, o), l
                        }(a, i, c, u), g.filterApplied = !0, o.form_blocks.resources.set_value(e, _, i, l)
                    };

                    function h(e) {
                        var i, n, o = e.target;
                        if ("checkbox" === e.target.type) {
                            i = o.parentNode, (n = i.querySelector(c())).disabled = !o.checked;
                            var l = n.getAttribute("data-item-id"),
                                u = r.locateClassName(e, "gantt_resource_row"),
                                d = u.querySelector(".gantt_resource_amount_input");
                            if (u.setAttribute("data-checked", o.checked), o.checked) {
                                "select" === n.nodeName.toLowerCase() && t.callEvent("onResourcesSelectActivated", [{
                                    target: n
                                }]);
                                var h = l,
                                    _ = a.default_value;
                                a.options.forEach(function(t) {
                                    t.key == h && t.default_value && (_ = t.default_value)
                                }), d && !d.value && void 0 !== _ && (d.value = _, f(a, this)), d.select ? d.select() : d.focus && d.focus()
                            } else s.resourcesValues[a.id] && delete s.resourcesValues[a.id][l]
                        } else "text" !== e.target.type && "select" !== e.target.nodeName.toLowerCase() || (i = o.parentNode.parentNode, n = e.target, f(a, this))
                    }

                    function f(t, e) {
                        var i = c(),
                            n = e.querySelectorAll(i);
                        s.resourcesValues[t.id] = s.resourcesValues[t.id] || {};
                        for (var r = 0; r < n.length; r++) {
                            var a = n[r].getAttribute("data-item-id");
                            n[r].disabled ? delete s.resourcesValues[t.id][a] : s.resourcesValues[t.id][a] = n[r].value
                        }
                    }
                    l = n.throttle(l, 100), d(a).container.addEventListener("keyup", l), d(a).container.addEventListener("input", l, !0), d(a).container.addEventListener("change", l, !0), u(a).addEventListener("input", h), u(a).addEventListener("change", h), t.attachEvent("onResourcesSelectActivated", t.bind(h, u(a))), s.eventsInitialized[a.id] = !0
                }(e, o, l, this), n.forEach(l.options, function(t, e) {
                    l.unassigned_value != t.key && (h = function(t, e, i) {
                        var r = {};
                        if (e) {
                            var a;
                            n.isArray(e) ? a = n.arrayFind(e, function(t) {
                                return t.resource_id == i.key
                            }) : e.resource_id == i.key && (a = e), a && (r.value = a.value)
                        }
                        s.resourcesValues[t.id] && s.resourcesValues[t.id][i.key] && (r.value = s.resourcesValues[t.id][i.key]);
                        return r
                    }(l, i, t), _ += ["<label class='gantt_resource_row' data-item-id='" + t.key + "' data-checked=" + (h.value ? "true" : "false") + ">", "<input class='gantt_resource_toggle' type='checkbox'", h.value ? " checked='checked'" : "", "><div class='gantt_resource_cell gantt_resource_cell_checkbox'><span class='matherial_checkbox_icon'></span></div>", "<div class='gantt_resource_cell gantt_resource_cell_label'>", t.label, "</div>", "<div class='gantt_resource_cell gantt_resource_cell_value'>", function(t, e, i) {
                        var n, r = "";
                        if (!t) return;
                        n = [{
                            key: "data-item-id",
                            value: t.key
                        }, {
                            key: "class",
                            value: "gantt_resource_amount_input"
                        }], i && n.push({
                            key: "disabled",
                            value: "disabled"
                        });
                        t.options ? r += a.getHtmlSelect(t.options, n, e) : (n[n.length] = {
                            key: "value",
                            value: e || ""
                        }, r += a.getHtmlInput(n));
                        return r
                    }(t, h.value, !h.value), "</div>", "<div class='gantt_resource_cell gantt_resource_cell_unit'>", t.unit, "</div>", "</label>"].join(""))
                }), f.innerHTML = _, f.style.zoom = "1", f._offsetSizes = f.offsetHeight, f.style.zoom = "", t.resizeLightbox(), t._center_lightbox(t.getLightbox())
            }, l.prototype.get_value = function(t, e, i) {
                var r = u(i),
                    a = [],
                    o = c(!0),
                    l = c(!1),
                    h = d(i),
                    f = e[i.map_to] || [],
                    _ = {};
                h.filterApplied && f && f.length > 0 && n.forEach(f, function(t) {
                    _[String(t.resource_id)] = t
                });
                for (var g = r.querySelectorAll(o), p = r.querySelectorAll(l), v = 0; v < p.length; v++) delete _[p[v].getAttribute("data-item-id")];
                for (v = 0; v < g.length; v++) {
                    var m = g[v].getAttribute("data-item-id"),
                        y = g[v].value.trim();
                    "" !== y && "0" !== y && (delete _[m], a[a.length] = {
                        resource_id: m,
                        value: y
                    })
                }
                for (var b in _) s.resourcesValues[i.id] ? a[a.length] = s.resourcesValues[i.id][b] || _[b] : a[a.length] = _[b];
                return a
            }, l.prototype.focus = function(e) {
                t._focus(e.querySelector(".gantt_resources"))
            }, l
        }
    }, function(t, e, i) {
        var n = i(3);
        t.exports = function(t) {
            var e = i(12)(t);

            function r() {
                return e.apply(this, arguments) || this
            }

            function a(e, i) {
                var n = [],
                    r = [];
                i && (n = t.getTaskByTime(), e.allow_root && n.unshift({
                    id: t.config.root_id,
                    text: e.root_label || ""
                }), n = function(e, i, n) {
                    var r = i.filter || function() {
                        return !0
                    };
                    e = e.slice(0);
                    for (var a = 0; a < e.length; a++) {
                        var o = e[a];
                        (o.id == n || t.isChildOf(o.id, n) || !1 === r(o.id, o)) && (e.splice(a, 1), a--)
                    }
                    return e
                }(n, e, i), e.sort && n.sort(e.sort));
                for (var a = e.template || t.templates.task_text, o = 0; o < n.length; o++) {
                    var s = a.apply(t, [n[o].start_date, n[o].end_date, n[o]]);
                    void 0 === s && (s = ""), r.push({
                        key: n[o].id,
                        label: s
                    })
                }
                return e.options = r, e.map_to = e.map_to || "parent", t.form_blocks.select.render.apply(this, arguments)
            }
            return n(r, e), r.prototype.render = function(t) {
                return a(t, !1)
            }, r.prototype.set_value = function(e, i, n, r) {
                var o = document.createElement("div");
                o.innerHTML = a(r, n.id);
                var s = o.removeChild(o.firstChild);
                return e.onselect = null, e.parentNode.replaceChild(s, e), t.form_blocks.select.set_value.apply(t, [s, i, n, r])
            }, r
        }
    }, function(t, e, i) {
        "use strict";
        Object.defineProperty(e, "__esModule", {
            value: !0
        });
        var n = function() {
            return function() {
                var t = this;
                this.canParse = function(e) {
                    return !isNaN(t.parse(e))
                }, this.format = function(t) {
                    return String(t)
                }, this.parse = function(t) {
                    return parseInt(t, 10)
                }
            }
        }();
        e.DurationFormatterNumeric = n
    }, function(t, e, i) {
        var n = i(3),
            r = i(65).DurationFormatterNumeric;
        t.exports = function(t) {
            var e = i(5)(t);

            function a() {
                return e.apply(this, arguments) || this
            }

            function o(t) {
                return t.formatter || new r
            }

            function s(e, i) {
                var n = e.getElementsByTagName("select"),
                    r = i._time_format_order,
                    a = 0,
                    o = 0;
                if (t.defined(r[3])) {
                    var s = n[r[3]],
                        l = parseInt(s.value, 10);
                    isNaN(l) && s.hasAttribute("data-value") && (l = parseInt(s.getAttribute("data-value"), 10)), a = Math.floor(l / 60), o = l % 60
                }
                return new Date(n[r[2]].value, n[r[1]].value, n[r[0]].value, a, o)
            }

            function l(t, e) {
                var i = t.getElementsByTagName("input")[1];
                return (i = o(e).parse(i.value)) && !window.isNaN(i) || (i = 1), i < 0 && (i *= -1), i
            }
            return n(a, e), a.prototype.render = function(e) {
                var i = "<div class='gantt_time_selects'>" + t.form_blocks.getTimePicker.call(this, e) + "</div>",
                    n = " " + t.locale.labels[t.config.duration_unit + "s"] + " ",
                    r = e.single_date ? " style='display:none'" : "",
                    a = e.readonly ? " disabled='disabled'" : "",
                    o = t._waiAria.lightboxDurationInputAttrString(e),
                    s = "gantt_duration_value";
                e.formatter && (n = "", s += " gantt_duration_value_formatted");
                var l = "<div class='gantt_duration' " + r + "><input type='button' class='gantt_duration_dec' value='âˆ’'" + a + "><input type='text' value='5days' class='" + s + "'" + a + " " + o + "><input type='button' class='gantt_duration_inc' value='+'" + a + ">" + n + "<span></span></div>";
                return "<div style='height:" + (e.height || 30) + "px;padding-top:0px;font-size:inherit;' class='gantt_section_time'>" + i + " " + l + "</div>"
            }, a.prototype.set_value = function(e, i, n, r) {
                var a, c, u, d, h = e.getElementsByTagName("select"),
                    f = e.getElementsByTagName("input"),
                    _ = f[1],
                    g = [f[0], f[2]],
                    p = e.getElementsByTagName("span")[0],
                    v = r._time_format_order;

                function m() {
                    var i = s.call(t, e, r),
                        a = l.call(t, e, r),
                        o = t.calculateEndDate({
                            start_date: i,
                            duration: a,
                            task: n
                        }),
                        c = t.templates.task_end_date || t.templates.task_date;
                    p.innerHTML = c(o)
                }

                function y(t) {
                    var e = _.value;
                    e = o(r).parse(e), window.isNaN(e) && (e = 0), (e += t) < 1 && (e = 1), _.value = o(r).format(e), m()
                }
                g[0].onclick = t.bind(function() {
                    y(-1 * t.config.duration_step)
                }, this), g[1].onclick = t.bind(function() {
                    y(1 * t.config.duration_step)
                }, this), h[0].onchange = m, h[1].onchange = m, h[2].onchange = m, h[3] && (h[3].onchange = m), _.onkeydown = t.bind(function(e) {
                    var i;
                    return (i = (e = e || window.event).charCode || e.keyCode || e.which) == t.constants.KEY_CODES.DOWN ? (y(-1 * t.config.duration_step), !1) : i == t.constants.KEY_CODES.UP ? (y(1 * t.config.duration_step), !1) : void window.setTimeout(m, 1)
                }, this), _.onchange = t.bind(m, this), "string" == typeof(a = t._resolve_default_mapping(r)) && (a = {
                    start_date: a
                }), c = n[a.start_date] || new Date, u = n[a.end_date] || t.calculateEndDate({
                    start_date: c,
                    duration: 1,
                    task: n
                }), d = Math.round(n[a.duration]) || t.calculateDuration({
                    start_date: c,
                    end_date: u,
                    task: n
                }), d = o(r).format(d), t.form_blocks._fill_lightbox_select(h, 0, c, v, r), _.value = d, m()
            }, a.prototype.get_value = function(e, i, n) {
                var r = s(e, n),
                    a = l(e, n),
                    o = t.calculateEndDate({
                        start_date: r,
                        duration: a,
                        task: i
                    });
                return "string" == typeof t._resolve_default_mapping(n) ? r : {
                    start_date: r,
                    end_date: o,
                    duration: a
                }
            }, a.prototype.focus = function(e) {
                t._focus(e.getElementsByTagName("select")[0])
            }, a
        }
    }, function(t, e, i) {
        var n = i(3);
        t.exports = function(t) {
            var e = i(5)(t);

            function r() {
                return e.apply(this, arguments) || this
            }
            return n(r, e), r.prototype.render = function(t) {
                var e = "<div class='gantt_cal_ltext' style='height:" + ((t.height || "23") + "px") + ";'>";
                if (t.options && t.options.length)
                    for (var i = 0; i < t.options.length; i++) e += "<label><input type='radio' value='" + t.options[i].key + "' name='" + t.name + "'>" + t.options[i].label + "</label>";
                return e += "</div>"
            }, r.prototype.set_value = function(t, e, i, n) {
                var r;
                n.options && n.options.length && (r = t.querySelector("input[type=radio][value='" + e + "']") || t.querySelector("input[type=radio][value='" + n.default_value + "']")) && (!t._dhx_onchange && n.onchange && (t.onchange = n.onchange, t._dhx_onchange = !0), r.checked = !0)
            }, r.prototype.get_value = function(t, e) {
                var i = t.querySelector("input[type=radio]:checked");
                return i ? i.value : ""
            }, r.prototype.focus = function(e) {
                t._focus(e.querySelector("input[type=radio]"))
            }, r
        }
    }, function(t, e, i) {
        var n = i(2),
            r = i(3);
        t.exports = function(t) {
            var e = i(5)(t);

            function a() {
                return e.apply(this, arguments) || this
            }
            return r(a, e), a.prototype.render = function(t) {
                var e = "<div class='gantt_cal_ltext' style='height:" + ((t.height || "23") + "px") + ";'>";
                if (t.options && t.options.length)
                    for (var i = 0; i < t.options.length; i++) e += "<label><input type='checkbox' value='" + t.options[i].key + "' name='" + t.name + "'>" + t.options[i].label + "</label>";
                return e += "</div>"
            }, a.prototype.set_value = function(t, e, i, r) {
                var a = Array.prototype.slice.call(t.querySelectorAll("input[type=checkbox]"));
                !t._dhx_onchange && r.onchange && (t.onchange = r.onchange, t._dhx_onchange = !0), n.forEach(a, function(t) {
                    t.checked = !!e && e.indexOf(t.value) >= 0
                })
            }, a.prototype.get_value = function(t) {
                return n.arrayMap(Array.prototype.slice.call(t.querySelectorAll("input[type=checkbox]:checked")), function(t) {
                    return t.value
                })
            }, a.prototype.focus = function(e) {
                t._focus(e.querySelector("input[type=checkbox]"))
            }, a
        }
    }, function(t, e, i) {
        var n = i(3);
        t.exports = function(t) {
            var e = i(5)(t);

            function r() {
                return e.apply(this, arguments) || this
            }
            return n(r, e), r.prototype.render = function(e) {
                var i = t.form_blocks.getTimePicker.call(this, e),
                    n = "<div style='height:" + (e.height || 30) + "px;padding-top:0px;font-size:inherit;text-align:center;' class='gantt_section_time'>";
                return n += i, e.single_date ? (i = t.form_blocks.getTimePicker.call(this, e, !0), n += "<span></span>") : n += "<span style='font-weight:normal; font-size:10pt;'> &nbsp;&ndash;&nbsp; </span>", n += i, n += "</div>"
            }, r.prototype.set_value = function(e, i, n, r) {
                var a = r,
                    o = e.getElementsByTagName("select"),
                    s = r._time_format_order;
                if (a.auto_end_date)
                    for (var l = function() {
                            d = new Date(o[s[2]].value, o[s[1]].value, o[s[0]].value, 0, 0), h = t.calculateEndDate({
                                start_date: d,
                                duration: 1,
                                task: n
                            }), t.form_blocks._fill_lightbox_select(o, s.size, h, s, a)
                        }, c = 0; c < 4; c++) o[c].onchange = l;
                var u = t._resolve_default_mapping(r);
                "string" == typeof u && (u = {
                    start_date: u
                });
                var d = n[u.start_date] || new Date,
                    h = n[u.end_date] || t.calculateEndDate({
                        start_date: d,
                        duration: 1,
                        task: n
                    });
                t.form_blocks._fill_lightbox_select(o, 0, d, s, a), t.form_blocks._fill_lightbox_select(o, s.size, h, s, a)
            }, r.prototype.get_value = function(e, i, n) {
                var r, a = e.getElementsByTagName("select"),
                    o = n._time_format_order;
                return r = t.form_blocks.getTimePickerValue(a, n), "string" == typeof t._resolve_default_mapping(n) ? r : {
                    start_date: r,
                    end_date: function(e, i, r) {
                        var a = t.form_blocks.getTimePickerValue(e, n, i.size);
                        return a <= r ? t.date.add(r, t._get_timepicker_step(), "minute") : a
                    }(a, o, r)
                }
            }, r.prototype.focus = function(e) {
                t._focus(e.getElementsByTagName("select")[0])
            }, r
        }
    }, function(t, e, i) {
        var n = i(3);
        t.exports = function(t) {
            var e = i(5)(t);

            function r() {
                return e.apply(this, arguments) || this
            }
            return n(r, e), r.prototype.render = function(t) {
                return "<div class='gantt_cal_ltext' style='height:" + ((t.height || "130") + "px") + ";'><textarea></textarea></div>"
            }, r.prototype.set_value = function(e, i) {
                t.form_blocks.textarea._get_input(e).value = i || ""
            }, r.prototype.get_value = function(e) {
                return t.form_blocks.textarea._get_input(e).value
            }, r.prototype.focus = function(e) {
                var i = t.form_blocks.textarea._get_input(e);
                t._focus(i, !0)
            }, r.prototype._get_input = function(t) {
                return t.querySelector("textarea")
            }, r
        }
    }, function(t, e, i) {
        var n = i(3);
        t.exports = function(t) {
            var e = i(5)(t);

            function r() {
                return e.apply(this, arguments) || this
            }
            return n(r, e), r.prototype.render = function(t) {
                return "<div class='gantt_cal_ltext gantt_cal_template' style='height:" + ((t.height || "30") + "px") + ";'></div>"
            }, r.prototype.set_value = function(t, e) {
                t.innerHTML = e || ""
            }, r.prototype.get_value = function(t) {
                return t.innerHTML || ""
            }, r.prototype.focus = function() {}, r
        }
    }, function(t, e, i) {
        t.exports = function(t) {
            var e = i(1),
                n = i(2),
                r = i(71)(t),
                a = i(70)(t),
                o = i(69)(t),
                s = i(12)(t),
                l = i(68)(t),
                c = i(67)(t),
                u = i(66)(t),
                d = i(64)(t),
                h = i(63)(t),
                f = i(62)(t);

            function _(e, i) {
                var n, r, a = "";
                for (r = 0; r < e.length; r++) n = t.config._migrate_buttons[e[r]] ? t.config._migrate_buttons[e[r]] : e[r], a += "<div " + t._waiAria.lightboxButtonAttrString(n) + " class='gantt_btn_set gantt_left_btn_set " + n + "_set'" + (i ? " style='float:right;'" : "") + "><div dhx_button='1' data-dhx-button='1' class='" + n + "'></div><div>" + t.locale.labels[n] + "</div></div>";
                return a
            }

            function g(e, i, n) {
                var r, a, o, s, l, c, u = "";
                switch (n.timeFormat[i]) {
                    case "%Y":
                        for (e._time_format_order[2] = i, e._time_format_order.size++, e.year_range && (isNaN(e.year_range) ? e.year_range.push && (o = e.year_range[0], s = e.year_range[1]) : r = e.year_range), r = r || 10, a = a || Math.floor(r / 2), o = o || n.date.getFullYear() - a, s = s || o + r, l = o; l < s; l++) u += "<option value='" + l + "'>" + l + "</option>";
                        break;
                    case "%m":
                        for (e._time_format_order[1] = i, e._time_format_order.size++, l = 0; l < 12; l++) u += "<option value='" + l + "'>" + t.locale.date.month_full[l] + "</option>";
                        break;
                    case "%d":
                        for (e._time_format_order[0] = i, e._time_format_order.size++, l = 1; l < 32; l++) u += "<option value='" + l + "'>" + l + "</option>";
                        break;
                    case "%H:%i":
                        for (e._time_format_order[3] = i, e._time_format_order.size++, l = n.first, c = n.date.getDate(), e._time_values = []; l < n.last;) u += "<option value='" + l + "'>" + t.templates.time_picker(n.date) + "</option>", e._time_values.push(l), n.date.setTime(n.date.valueOf() + 60 * t._get_timepicker_step() * 1e3), l = 24 * (n.date.getDate() != c ? 1 : 0) * 60 + 60 * n.date.getHours() + n.date.getMinutes()
                }
                return u
            }
            t._lightbox_methods = {}, t._lightbox_template = "<div class='gantt_cal_ltitle'><span class='gantt_mark'>&nbsp;</span><span class='gantt_time'></span><span class='gantt_title'></span></div><div class='gantt_cal_larea'></div>", t.$services.getService("state").registerProvider("lightbox", function() {
                return {
                    lightbox: t._lightbox_id
                }
            }), t.showLightbox = function(e) {
                if (e && !t.isReadonly(this.getTask(e)) && this.callEvent("onBeforeLightbox", [e])) {
                    var i = this.getTask(e),
                        n = this.getLightbox(this.getTaskType(i.type));
                    this._center_lightbox(n), this.showCover(), this._fill_lightbox(e, n), this._waiAria.lightboxVisibleAttr(n), this.callEvent("onLightbox", [e])
                }
            }, t._get_timepicker_step = function() {
                if (this.config.round_dnd_dates) {
                    var e;
                    if (function(t) {
                            var e = t.$ui.getView("timeline");
                            return !(!e || !e.isVisible())
                        }(this)) {
                        var i = t.getScale();
                        e = n.getSecondsInUnit(i.unit) * i.step / 60
                    }
                    return (!e || e >= 1440) && (e = this.config.time_step), e
                }
                return this.config.time_step
            }, t.getLabel = function(t, e) {
                for (var i = this._get_typed_lightbox_config(), n = 0; n < i.length; n++)
                    if (i[n].map_to == t)
                        for (var r = i[n].options, a = 0; a < r.length; a++)
                            if (r[a].key == e) return r[a].label;
                return ""
            }, t.updateCollection = function(e, i) {
                i = i.slice(0);
                var n = t.serverList(e);
                if (!n) return !1;
                n.splice(0, n.length), n.push.apply(n, i || []), t.resetLightbox()
            }, t.getLightboxType = function() {
                return this.getTaskType(this._lightbox_type)
            }, t.getLightbox = function(e) {
                var i, n, r, a, o = "";
                return void 0 === e && (e = this.getLightboxType()), this._lightbox && this.getLightboxType() == this.getTaskType(e) || (this._lightbox_type = this.getTaskType(e), i = document.createElement("div"), o = "gantt_cal_light", n = this._is_lightbox_timepicker(), (t.config.wide_form || n) && (o += " gantt_cal_light_wide"), n && (t.config.wide_form = !0, o += " gantt_cal_light_full"), i.className = o, i.style.visibility = "hidden", r = this._lightbox_template, r += _(this.config.buttons_left), r += _(this.config.buttons_right, !0), i.innerHTML = r, t._waiAria.lightboxAttr(i), t.config.drag_lightbox && (i.firstChild.onmousedown = t._ready_to_dnd, i.firstChild.onselectstart = function() {
                    return !1
                }, i.firstChild.style.cursor = "pointer", t._init_dnd_events()), document.body.insertBefore(i, document.body.firstChild), this._lightbox = i, a = this._get_typed_lightbox_config(e), r = this._render_sections(a), i.querySelector("div.gantt_cal_larea").innerHTML = r, function(e) {
                    var i, n, r, a, o, s;
                    for (s = 0; s < e.length; s++) i = e[s], r = document.getElementById(i.id), i.id && r && (n = r.querySelector("label"), (a = r.nextSibling) && (o = a.querySelector("input, select, textarea")) && (o.id = o.id || "input_" + t.uid(), i.inputId = o.id, n.setAttribute("for", i.inputId)))
                }(a), this.resizeLightbox(), this._init_lightbox_events(this), i.style.display = "none", i.style.visibility = "visible"), this._lightbox
            }, t._render_sections = function(t) {
                for (var e = "", i = 0; i < t.length; i++) {
                    var n = this.form_blocks[t[i].type];
                    if (n) {
                        t[i].id = "area_" + this.uid();
                        var r = t[i].hidden ? " style='display:none'" : "",
                            a = "";
                        t[i].button && (a = "<div class='gantt_custom_button' data-index='" + i + "'><div class='gantt_custom_button_" + t[i].button + "'></div><div class='gantt_custom_button_label'>" + this.locale.labels["button_" + t[i].button] + "</div></div>"), this.config.wide_form && (e += "<div class='gantt_wrap_section' " + r + ">"), e += "<div id='" + t[i].id + "' class='gantt_cal_lsection'><label>" + a + this.locale.labels["section_" + t[i].name] + "</label></div>" + n.render.call(this, t[i]), e += "</div>"
                    }
                }
                return e
            }, t.resizeLightbox = function() {
                if (this._lightbox) {
                    var t = this._lightbox.childNodes[1];
                    t.style.height = "0px", t.style.height = t.scrollHeight + "px", this._lightbox.style.height = t.scrollHeight + this.config.lightbox_additional_height + "px", t.style.height = t.scrollHeight + "px"
                }
            }, t._center_lightbox = function(t) {
                if (t) {
                    t.style.display = "block";
                    var e = window.pageYOffset || document.body.scrollTop || document.documentElement.scrollTop,
                        i = window.pageXOffset || document.body.scrollLeft || document.documentElement.scrollLeft,
                        n = window.innerHeight || document.documentElement.clientHeight;
                    t.style.top = e ? Math.round(e + Math.max((n - t.offsetHeight) / 2, 0)) + "px" : Math.round(Math.max((n - t.offsetHeight) / 2, 0) + 9) + "px", document.documentElement.scrollWidth > document.body.offsetWidth ? t.style.left = Math.round(i + (document.body.offsetWidth - t.offsetWidth) / 2) + "px" : t.style.left = Math.round((document.body.offsetWidth - t.offsetWidth) / 2) + "px"
                }
            }, t.showCover = function() {
                if (!this._cover) {
                    this._cover = document.createElement("DIV"), this._cover.className = "gantt_cal_cover";
                    var t = void 0 !== document.height ? document.height : document.body.offsetHeight,
                        e = document.documentElement ? document.documentElement.scrollHeight : 0;
                    this._cover.style.height = Math.max(t, e) + "px", document.body.appendChild(this._cover)
                }
            }, t._init_lightbox_events = function() {
                t.lightbox_events = {}, t.lightbox_events.gantt_save_btn = function() {
                    t._save_lightbox()
                }, t.lightbox_events.gantt_delete_btn = function() {
                    t.callEvent("onLightboxDelete", [t._lightbox_id]) && (t.isTaskExists(t._lightbox_id) ? t.$click.buttons.delete(t._lightbox_id) : t.hideLightbox())
                }, t.lightbox_events.gantt_cancel_btn = function() {
                    t._cancel_lightbox()
                }, t.lightbox_events.default = function(i, n) {
                    if (n.getAttribute("data-dhx-button")) t.callEvent("onLightboxButton", [n.className, n, i]);
                    else {
                        var r, a, o = e.getClassName(n);
                        if (-1 != o.indexOf("gantt_custom_button"))
                            if (-1 != o.indexOf("gantt_custom_button_"))
                                for (r = n.parentNode.getAttribute("data-index"), a = n; a && -1 == e.getClassName(a).indexOf("gantt_cal_lsection");) a = a.parentNode;
                            else r = n.getAttribute("data-index"), a = n.parentNode, n = n.firstChild;
                        var s = t._get_typed_lightbox_config();
                        r && (r *= 1, t.form_blocks[s[1 * r].type].button_click(r, n, a, a.nextSibling))
                    }
                }, this.event(t.getLightbox(), "click", function(i) {
                    var n = (i = i || window.event).target ? i.target : i.srcElement,
                        r = e.getClassName(n);
                    return r || (n = n.previousSibling, r = e.getClassName(n)), n && r && 0 === r.indexOf("gantt_btn_set") && (n = n.firstChild, r = e.getClassName(n)), !(!n || !r) && (t.defined(t.lightbox_events[n.className]) ? t.lightbox_events[n.className] : t.lightbox_events.default)(i, n)
                }), t.getLightbox().onkeydown = function(i) {
                    var n = i || window.event,
                        r = i.target || i.srcElement,
                        a = e.getClassName(r).indexOf("gantt_btn_set") > -1;
                    switch ((i || n).keyCode) {
                        case t.constants.KEY_CODES.SPACE:
                            if ((i || n).shiftKey) return;
                            a && r.click && r.click();
                            break;
                        case t.keys.edit_save:
                            if ((i || n).shiftKey) return;
                            a && r.click ? r.click() : t._save_lightbox();
                            break;
                        case t.keys.edit_cancel:
                            t._cancel_lightbox()
                    }
                }
            }, t._cancel_lightbox = function() {
                var e = this.getLightboxValues();
                this.callEvent("onLightboxCancel", [this._lightbox_id, e.$new]), t.isTaskExists(e.id) && e.$new && this.silent(function() {
                    t.$data.tasksStore.removeItem(e.id), t._update_flags(e.id, null)
                }), this.refreshData(), this.hideLightbox()
            }, t._save_lightbox = function() {
                var t = this.getLightboxValues();
                this.callEvent("onLightboxSave", [this._lightbox_id, t, !!t.$new]) && (t.$new ? (delete t.$new, this.addTask(t, t.parent, this.getTaskIndex(t.id))) : this.isTaskExists(t.id) && (this.mixin(this.getTask(t.id), t, !0), this.refreshTask(t.id), this.updateTask(t.id)), this.refreshData(), this.hideLightbox())
            }, t._resolve_default_mapping = function(t) {
                var e = t.map_to;
                return !{
                    time: !0,
                    time_optional: !0,
                    duration: !0,
                    duration_optional: !0
                }[t.type] ? "constraint" === t.type && (t.map_to && "string" != typeof t.map_to || (e = {
                    constraint_type: "constraint_type",
                    constraint_date: "constraint_date"
                })) : "auto" == t.map_to ? e = {
                    start_date: "start_date",
                    end_date: "end_date",
                    duration: "duration"
                } : "string" == typeof t.map_to && (e = {
                    start_date: t.map_to
                }), e
            }, t.getLightboxValues = function() {
                var e = {};
                t.isTaskExists(this._lightbox_id) && (e = this.mixin({}, this.getTask(this._lightbox_id)));
                for (var i = this._get_typed_lightbox_config(), n = 0; n < i.length; n++) {
                    var r = document.getElementById(i[n].id);
                    r = r ? r.nextSibling : r;
                    var a = this.form_blocks[i[n].type];
                    if (a) {
                        var o = a.get_value.call(this, r, e, i[n]),
                            s = t._resolve_default_mapping(i[n]);
                        if ("string" == typeof s && "auto" != s) e[s] = o;
                        else if ("object" == typeof s)
                            for (var l in s) s[l] && (e[s[l]] = o[l])
                    }
                }
                return e
            }, t.hideLightbox = function() {
                var t = this.getLightbox();
                t && (t.style.display = "none"), this._waiAria.lightboxHiddenAttr(t), this._lightbox_id = null, this.hideCover(), this.callEvent("onAfterLightbox", [])
            }, t.hideCover = function() {
                this._cover && this._cover.parentNode.removeChild(this._cover), this._cover = null
            }, t.resetLightbox = function() {
                t._lightbox && !t._custom_lightbox && t._lightbox.parentNode.removeChild(t._lightbox), t._lightbox = null, t.hideCover()
            }, t._set_lightbox_values = function(e, i) {
                var n = e,
                    r = i.getElementsByTagName("span"),
                    a = [];
                t.templates.lightbox_header ? (a.push(""), a.push(t.templates.lightbox_header(n.start_date, n.end_date, n)), r[1].innerHTML = "", r[2].innerHTML = t.templates.lightbox_header(n.start_date, n.end_date, n)) : (a.push(this.templates.task_time(n.start_date, n.end_date, n)), a.push(String(this.templates.task_text(n.start_date, n.end_date, n) || "").substr(0, 70)), r[1].innerHTML = this.templates.task_time(n.start_date, n.end_date, n), r[2].innerHTML = String(this.templates.task_text(n.start_date, n.end_date, n) || "").substr(0, 70)), r[1].innerHTML = a[0], r[2].innerHTML = a[1], t._waiAria.lightboxHeader(i, a.join(" "));
                for (var o = this._get_typed_lightbox_config(this.getLightboxType()), s = 0; s < o.length; s++) {
                    var l = o[s];
                    if (this.form_blocks[l.type]) {
                        var c = document.getElementById(l.id).nextSibling,
                            u = this.form_blocks[l.type],
                            d = t._resolve_default_mapping(o[s]),
                            h = this.defined(n[d]) ? n[d] : l.default_value;
                        u.set_value.call(t, c, h, n, l), l.focus && u.focus.call(t, c)
                    }
                }
                e.id && (t._lightbox_id = e.id)
            }, t._fill_lightbox = function(t, e) {
                var i = this.getTask(t);
                this._set_lightbox_values(i, e)
            }, t.getLightboxSection = function(e) {
                for (var i = this._get_typed_lightbox_config(), n = 0; n < i.length && i[n].name != e; n++);
                var r = i[n];
                if (!r) return null;
                this._lightbox || this.getLightbox();
                var a = document.getElementById(r.id),
                    o = a.nextSibling,
                    s = {
                        section: r,
                        header: a,
                        node: o,
                        getValue: function(e) {
                            return t.form_blocks[r.type].get_value.call(t, o, e || {}, r)
                        },
                        setValue: function(e, i) {
                            return t.form_blocks[r.type].set_value.call(t, o, e, i || {}, r)
                        }
                    },
                    l = this._lightbox_methods["get_" + r.type + "_control"];
                return l ? l(s) : s
            }, t._lightbox_methods.get_template_control = function(t) {
                return t.control = t.node, t
            }, t._lightbox_methods.get_select_control = function(t) {
                return t.control = t.node.getElementsByTagName("select")[0], t
            }, t._lightbox_methods.get_textarea_control = function(t) {
                return t.control = t.node.getElementsByTagName("textarea")[0], t
            }, t._lightbox_methods.get_time_control = function(t) {
                return t.control = t.node.getElementsByTagName("select"), t
            }, t._init_dnd_events = function() {
                this.event(document.body, "mousemove", t._move_while_dnd), this.event(document.body, "mouseup", t._finish_dnd), t._init_dnd_events = function() {}
            }, t._move_while_dnd = function(e) {
                if (t._dnd_start_lb) {
                    document.gantt_unselectable || (document.body.className += " gantt_unselectable", document.gantt_unselectable = !0);
                    var i = t.getLightbox(),
                        n = e && e.target ? [e.pageX, e.pageY] : [event.clientX, event.clientY];
                    i.style.top = t._lb_start[1] + n[1] - t._dnd_start_lb[1] + "px", i.style.left = t._lb_start[0] + n[0] - t._dnd_start_lb[0] + "px"
                }
            }, t._ready_to_dnd = function(e) {
                var i = t.getLightbox();
                t._lb_start = [parseInt(i.style.left, 10), parseInt(i.style.top, 10)], t._dnd_start_lb = e && e.target ? [e.pageX, e.pageY] : [event.clientX, event.clientY]
            }, t._finish_dnd = function() {
                t._lb_start && (t._lb_start = t._dnd_start_lb = !1, document.body.className = document.body.className.replace(" gantt_unselectable", ""), document.gantt_unselectable = !1)
            }, t._focus = function(e, i) {
                if (e && e.focus)
                    if (t.config.touch);
                    else try {
                        i && e.select && e.select(), e.focus()
                    } catch (t) {}
            }, t.form_blocks = {
                getTimePicker: function(e, i) {
                    var r, a, o, s = "",
                        l = this.config,
                        c = {
                            first: 0,
                            last: 1440,
                            date: this.date.date_part(new Date(t._min_date.valueOf())),
                            timeFormat: function(e) {
                                var i, r, a;
                                if (e.time_format) return e.time_format;
                                a = ["%d", "%m", "%Y"], i = t.getScale(), r = i ? i.unit : t.config.duration_unit, n.getSecondsInUnit(r) < n.getSecondsInUnit("day") && a.push("%H:%i");
                                return a
                            }(e)
                        };
                    for (e._time_format_order = {
                            size: 0
                        }, t.config.limit_time_select && (c.first = 60 * l.first_hour, c.last = 60 * l.last_hour + 1, c.date.setHours(l.first_hour)), r = 0; r < c.timeFormat.length; r++) r > 0 && (s += " "), (a = g(e, r, c)) && (o = t._waiAria.lightboxSelectAttrString(c.timeFormat[r]), s += "<select " + (e.readonly ? "disabled='disabled'" : "") + (i ? " style='display:none' " : "") + o + ">" + a + "</select>");
                    return s
                },
                getTimePickerValue: function(e, i, n) {
                    var r, a = i._time_format_order,
                        o = t.defined(a[3]),
                        s = 0,
                        l = 0,
                        c = n || 0;
                    return o && (r = parseInt(e[a[3] + c].value, 10), s = Math.floor(r / 60), l = r % 60), new Date(e[a[2] + c].value, e[a[1] + c].value, e[a[0] + c].value, s, l)
                },
                _fill_lightbox_select: function(e, i, n, r) {
                    if (e[i + r[0]].value = n.getDate(), e[i + r[1]].value = n.getMonth(), e[i + r[2]].value = n.getFullYear(), t.defined(r[3])) {
                        var a = 60 * n.getHours() + n.getMinutes();
                        a = Math.round(a / t._get_timepicker_step()) * t._get_timepicker_step();
                        var o = e[i + r[3]];
                        o.value = a, o.setAttribute("data-value", a)
                    }
                },
                template: new r,
                textarea: new a,
                select: new s,
                time: new o,
                duration: new u,
                parent: new d,
                radio: new c,
                checkbox: new l,
                resources: new h,
                constraint: new f
            }, t._is_lightbox_timepicker = function() {
                for (var t = this._get_typed_lightbox_config(), e = 0; e < t.length; e++)
                    if ("time" == t[e].name && "time" == t[e].type) return !0;
                return !1
            }, t._dhtmlx_confirm = function(e, i, n, r) {
                if (!e) return n();
                var a = {
                    text: e
                };
                i && (a.title = i), r && (a.ok = r), n && (a.callback = function(t) {
                    t && n()
                }), t.confirm(a)
            }, t._get_typed_lightbox_config = function(e) {
                void 0 === e && (e = this.getLightboxType());
                var i = function(t) {
                    for (var e in this.config.types)
                        if (this.config.types[e] == t) return e;
                    return "task"
                }.call(this, e);
                return t.config.lightbox[i + "_sections"] ? t.config.lightbox[i + "_sections"] : t.config.lightbox.sections
            }, t._silent_redraw_lightbox = function(t) {
                var e = this.getLightboxType();
                if (this.getState().lightbox) {
                    var i = this.getState().lightbox,
                        n = this.getLightboxValues(),
                        r = this.copy(this.getTask(i));
                    this.resetLightbox();
                    var a = this.mixin(r, n, !0),
                        o = this.getLightbox(t || void 0);
                    this._center_lightbox(this.getLightbox()), this._set_lightbox_values(a, o), this.showCover()
                } else this.resetLightbox(), this.getLightbox(t || void 0);
                this.callEvent("onLightboxChange", [e, this.getLightboxType()])
            }
        }
    }, function(t, e, i) {
        "use strict";
        Object.defineProperty(e, "__esModule", {
            value: !0
        }), e.default = function() {}
    }, function(t, e, i) {
        var n = i(2);
        t.exports = function(t) {
            t.isUnscheduledTask = function(e) {
                return t.assert(e && e instanceof Object, "Invalid argument <b>task</b>=" + e + " of gantt.isUnscheduledTask. Task object was expected"), !!e.unscheduled || !e.start_date
            }, t._isAllowedUnscheduledTask = function(e) {
                return !(!e.unscheduled || !t.config.show_unscheduled)
            }, t._isTaskInTimelineLimits = function(t) {
                var e = t.start_date ? t.start_date.valueOf() : null,
                    i = t.end_date ? t.end_date.valueOf() : null;
                return !!(e && i && e <= this._max_date.valueOf() && i >= this._min_date.valueOf())
            }, t.isTaskVisible = function(t) {
                if (!this.isTaskExists(t)) return !1;
                var e = this.getTask(t);
                return !(!this._isAllowedUnscheduledTask(e) && !this._isTaskInTimelineLimits(e)) && !!(this.getGlobalTaskIndex(t) >= 0)
            }, t._getProjectEnd = function() {
                if (t.config.project_end) return t.config.project_end;
                var e = t.getTaskByTime();
                return (e = e.sort(function(t, e) {
                    return +t.end_date > +e.end_date ? 1 : -1
                })).length ? e[e.length - 1].end_date : null
            }, t._getProjectStart = function() {
                if (t.config.project_start) return t.config.project_start;
                if (t.config.start_date) return t.config.start_date;
                if (t.getState().min_date) return t.getState().min_date;
                var e = t.getTaskByTime();
                return (e = e.sort(function(t, e) {
                    return +t.start_date > +e.start_date ? 1 : -1
                })).length ? e[0].start_date : null
            }, t._defaultTaskDate = function(e, i) {
                var n = !(!i || i == t.config.root_id) && t.getTask(i),
                    r = null;
                if (n) r = t.config.schedule_from_end ? t.calculateEndDate({
                    start_date: n.end_date,
                    duration: -t.config.duration_step,
                    task: e
                }) : n.start_date;
                else if (t.config.schedule_from_end) r = t.calculateEndDate({
                    start_date: t._getProjectEnd(),
                    duration: -t.config.duration_step,
                    task: e
                });
                else {
                    var a = t.getTaskByIndex(0);
                    r = a ? a.start_date ? a.start_date : a.end_date ? t.calculateEndDate({
                        start_date: a.end_date,
                        duration: -t.config.duration_step,
                        task: e
                    }) : null : t.config.start_date || t.getState().min_date
                }
                return t.assert(r, "Invalid dates"), new Date(r)
            }, t._set_default_task_timing = function(e) {
                e.start_date = e.start_date || t._defaultTaskDate(e, t.getParent(e)), e.duration = e.duration || t.config.duration_step, e.end_date = e.end_date || t.calculateEndDate(e)
            }, t.createTask = function(e, i, n) {
                (e = e || {}, t.defined(e.id) || (e.id = t.uid()), e.start_date || (e.start_date = t._defaultTaskDate(e, i)), void 0 === e.text && (e.text = t.locale.labels.new_task), void 0 === e.duration && (e.duration = 1), this.isTaskExists(i)) && (this.setParent(e, i, !0), this.getTask(i).$open = !0);
                return this.callEvent("onTaskCreated", [e]) ? (this.config.details_on_create ? (e.$new = !0, this.silent(function() {
                    t.$data.tasksStore.addItem(e, n)
                }), this.selectTask(e.id), this.refreshData(), this.showLightbox(e.id)) : this.addTask(e, i, n) && (this.showTask(e.id), this.selectTask(e.id)), e.id) : null
            }, t._update_flags = function(e, i) {
                var n = t.$data.tasksStore;
                void 0 === e ? (this._lightbox_id = null, n.silent(function() {
                    n.unselect()
                }), this._tasks_dnd && this._tasks_dnd.drag && (this._tasks_dnd.drag.id = null)) : (this._lightbox_id == e && (this._lightbox_id = i), n.getSelectedId() == e && n.silent(function() {
                    n.unselect(e), n.select(i)
                }), this._tasks_dnd && this._tasks_dnd.drag && this._tasks_dnd.drag.id == e && (this._tasks_dnd.drag.id = i))
            }, t._get_task_timing_mode = function(t, e) {
                var i = this.getTaskType(t.type),
                    n = {
                        type: i,
                        $no_start: !1,
                        $no_end: !1
                    };
                return e || i != t.$rendered_type ? (i == this.config.types.project ? n.$no_end = n.$no_start = !0 : i != this.config.types.milestone && (n.$no_end = !(t.end_date || t.duration), n.$no_start = !t.start_date, this._isAllowedUnscheduledTask(t) && (n.$no_end = n.$no_start = !1)), n) : (n.$no_start = t.$no_start, n.$no_end = t.$no_end, n)
            }, t._init_task_timing = function(e) {
                var i = t._get_task_timing_mode(e, !0),
                    n = e.$rendered_type != i.type,
                    r = i.type;
                n && (e.$no_start = i.$no_start, e.$no_end = i.$no_end, e.$rendered_type = i.type), n && r != this.config.types.milestone && r == this.config.types.project && this._set_default_task_timing(e), r == this.config.types.milestone && (e.end_date = e.start_date), e.start_date && e.end_date && (e.duration = this.calculateDuration(e)), e.end_date || (e.end_date = e.start_date), e.duration = e.duration || 0
            }, t.isSummaryTask = function(e) {
                t.assert(e && e instanceof Object, "Invalid argument <b>task</b>=" + e + " of gantt.isSummaryTask. Task object was expected");
                var i = t._get_task_timing_mode(e);
                return !(!i.$no_end && !i.$no_start)
            }, t.resetProjectDates = function(t) {
                var e = this._get_task_timing_mode(t);
                if (e.$no_end || e.$no_start) {
                    var i = this.getSubtaskDates(t.id);
                    this._assign_project_dates(t, i.start_date, i.end_date)
                }
            }, t.getSubtaskDuration = function(e) {
                var i = 0,
                    n = void 0 !== e ? e : t.config.root_id;
                return this.eachTask(function(e) {
                    this.getTaskType(e.type) == t.config.types.project || this.isUnscheduledTask(e) || (i += e.duration)
                }, n), i
            }, t.getSubtaskDates = function(e) {
                var i = null,
                    n = null,
                    r = void 0 !== e ? e : t.config.root_id;
                return this.eachTask(function(e) {
                    this.getTaskType(e.type) == t.config.types.project || this.isUnscheduledTask(e) || (e.start_date && !e.$no_start && (!i || i > e.start_date.valueOf()) && (i = e.start_date.valueOf()), e.end_date && !e.$no_end && (!n || n < e.end_date.valueOf()) && (n = e.end_date.valueOf()))
                }, r), {
                    start_date: i ? new Date(i) : null,
                    end_date: n ? new Date(n) : null
                }
            }, t._assign_project_dates = function(t, e, i) {
                var n = this._get_task_timing_mode(t);
                n.$no_start && (t.start_date = e && e != 1 / 0 ? new Date(e) : this._defaultTaskDate(t, this.getParent(t))), n.$no_end && (t.end_date = i && i != -1 / 0 ? new Date(i) : this.calculateEndDate({
                    start_date: t.start_date,
                    duration: this.config.duration_step,
                    task: t
                })), (n.$no_start || n.$no_end) && this._init_task_timing(t)
            }, t._update_parents = function(e, i) {
                if (e) {
                    var n = this.getTask(e),
                        r = this.getParent(n),
                        a = this._get_task_timing_mode(n),
                        o = !0;
                    if (a.$no_start || a.$no_end) {
                        var s = n.start_date.valueOf(),
                            l = n.end_date.valueOf();
                        t.resetProjectDates(n), s == n.start_date.valueOf() && l == n.end_date.valueOf() && (o = !1), o && !i && this.refreshTask(n.id, !0)
                    }
                    o && r && this.isTaskExists(r) && this._update_parents(r, i)
                }
            }, t.roundDate = function(e) {
                var i = t.getScale();
                n.isDate(e) && (e = {
                    date: e,
                    unit: i ? i.unit : t.config.duration_unit,
                    step: i ? i.step : t.config.duration_step
                });
                var r, a, o, s = e.date,
                    l = e.step,
                    c = e.unit;
                if (!i) return s;
                if (c == i.unit && l == i.step && +s >= +i.min_date && +s <= +i.max_date) o = Math.floor(t.columnIndexByDate(s)), i.trace_x[o] || (o -= 1, i.rtl && (o = 0)), a = new Date(i.trace_x[o]), r = t.date.add(a, l, c);
                else {
                    for (o = Math.floor(t.columnIndexByDate(s)), r = t.date[c + "_start"](new Date(i.min_date)), i.trace_x[o] && (r = t.date[c + "_start"](i.trace_x[o])); + r < +s;) {
                        var u = (r = t.date[c + "_start"](t.date.add(r, l, c))).getTimezoneOffset();
                        r = t._correct_dst_change(r, u, r, c), t.date[c + "_start"] && (r = t.date[c + "_start"](r))
                    }
                    a = t.date.add(r, -1 * l, c)
                }
                return e.dir && "future" == e.dir ? r : e.dir && "past" == e.dir ? a : Math.abs(s - a) < Math.abs(r - s) ? a : r
            }, t.correctTaskWorkTime = function(e) {
                t.config.work_time && t.config.correct_work_time && (this.isWorkTime(e.start_date, void 0, e) ? this.isWorkTime(new Date(+e.end_date - 1), void 0, e) || (e.end_date = this.calculateEndDate(e)) : (e.start_date = this.getClosestWorkTime({
                    date: e.start_date,
                    dir: "future",
                    task: e
                }), e.end_date = this.calculateEndDate(e)))
            }, t.attachEvent("onBeforeTaskUpdate", function(e, i) {
                return t._init_task_timing(i), !0
            }), t.attachEvent("onBeforeTaskAdd", function(e, i) {
                return t._init_task_timing(i), !0
            })
        }
    }, function(t, e, i) {
        var n = i(0);
        t.exports = {
            create: function(t, e) {
                return {
                    getWorkHours: function(t) {
                        return e.getWorkHours(t)
                    },
                    setWorkTime: function(t) {
                        return e.setWorkTime(t)
                    },
                    unsetWorkTime: function(t) {
                        e.unsetWorkTime(t)
                    },
                    isWorkTime: function(t, i, n) {
                        return e.isWorkTime(t, i, n)
                    },
                    getClosestWorkTime: function(t) {
                        return e.getClosestWorkTime(t)
                    },
                    calculateDuration: function(t, i, n) {
                        return e.calculateDuration(t, i, n)
                    },
                    _hasDuration: function(t, i, n) {
                        return e.hasDuration(t, i, n)
                    },
                    calculateEndDate: function(t, i, n, r) {
                        return e.calculateEndDate(t, i, n, r)
                    },
                    createCalendar: n.bind(t.createCalendar, t),
                    addCalendar: n.bind(t.addCalendar, t),
                    getCalendar: n.bind(t.getCalendar, t),
                    getCalendars: n.bind(t.getCalendars, t),
                    getTaskCalendar: n.bind(t.getTaskCalendar, t),
                    deleteCalendar: n.bind(t.deleteCalendar, t)
                }
            }
        }
    }, function(t, e) {
        function i(t, e) {
            this.argumentsHelper = e, this.$gantt = t
        }
        i.prototype = {
            getWorkHours: function() {
                return [0, 24]
            },
            setWorkTime: function() {
                return !0
            },
            unsetWorkTime: function() {
                return !0
            },
            isWorkTime: function() {
                return !0
            },
            getClosestWorkTime: function(t) {
                return this.argumentsHelper.getClosestWorkTimeArguments.apply(this.argumentsHelper, arguments).date
            },
            calculateDuration: function() {
                var t = this.argumentsHelper.getDurationArguments.apply(this.argumentsHelper, arguments),
                    e = t.start_date,
                    i = t.end_date,
                    n = t.unit,
                    r = t.step;
                return this._calculateDuration(e, i, n, r)
            },
            _calculateDuration: function(t, e, i, n) {
                var r = this.$gantt.date,
                    a = {
                        week: 6048e5,
                        day: 864e5,
                        hour: 36e5,
                        minute: 6e4
                    },
                    o = 0;
                if (a[i]) o = Math.round((e - t) / (n * a[i]));
                else {
                    for (var s = new Date(t), l = new Date(e); s.valueOf() < l.valueOf();) o += 1, s = r.add(s, n, i);
                    s.valueOf() != e.valueOf() && (o += (l - s) / (r.add(s, n, i) - s))
                }
                return Math.round(o)
            },
            hasDuration: function() {
                var t = this.argumentsHelper.getDurationArguments.apply(this.argumentsHelper, arguments),
                    e = t.start_date,
                    i = t.end_date;
                return !!t.unit && (e = new Date(e), i = new Date(i), e.valueOf() < i.valueOf())
            },
            calculateEndDate: function() {
                var t = this.argumentsHelper.calculateEndDateArguments.apply(this.argumentsHelper, arguments),
                    e = t.start_date,
                    i = t.duration,
                    n = t.unit,
                    r = t.step;
                return this.$gantt.date.add(e, r * i, n)
            }
        }, t.exports = i
    }, function(t, e, i) {
        var n = i(26),
            r = i(76);

        function a(t) {
            this.$gantt = t.$gantt, this.argumentsHelper = n(this.$gantt), this.calendarManager = t, this.$disabledCalendar = new r(this.$gantt, this.argumentsHelper)
        }
        a.prototype = {
            _getCalendar: function(t) {
                var e;
                if (this.$gantt.$services.config().work_time) {
                    var i = this.calendarManager;
                    t.task ? e = i.getTaskCalendar(t.task) : t.id ? e = i.getTaskCalendar(t) : t.calendar && (e = t.calendar), e || (e = i.getTaskCalendar())
                } else e = this.$disabledCalendar;
                return e
            },
            getWorkHours: function(t) {
                return t = this.argumentsHelper.getWorkHoursArguments.apply(this.argumentsHelper, arguments), this._getCalendar(t).getWorkHours(t.date)
            },
            setWorkTime: function(t, e) {
                return t = this.argumentsHelper.setWorkTimeArguments.apply(this.argumentsHelper, arguments), e || (e = this.calendarManager.getCalendar()), e.setWorkTime(t)
            },
            unsetWorkTime: function(t, e) {
                return t = this.argumentsHelper.unsetWorkTimeArguments.apply(this.argumentsHelper, arguments), e || (e = this.calendarManager.getCalendar()), e.unsetWorkTime(t)
            },
            isWorkTime: function(t, e, i, n) {
                var r = this.argumentsHelper.isWorkTimeArguments.apply(this.argumentsHelper, arguments);
                return this._getCalendar(r).isWorkTime(r)
            },
            getClosestWorkTime: function(t) {
                return t = this.argumentsHelper.getClosestWorkTimeArguments.apply(this.argumentsHelper, arguments), this._getCalendar(t).getClosestWorkTime(t)
            },
            calculateDuration: function() {
                var t = this.argumentsHelper.getDurationArguments.apply(this.argumentsHelper, arguments);
                return this._getCalendar(t).calculateDuration(t)
            },
            hasDuration: function() {
                var t = this.argumentsHelper.hasDurationArguments.apply(this.argumentsHelper, arguments);
                return this._getCalendar(t).hasDuration(t)
            },
            calculateEndDate: function(t) {
                t = this.argumentsHelper.calculateEndDateArguments.apply(this.argumentsHelper, arguments);
                return this._getCalendar(t).calculateEndDate(t)
            }
        }, t.exports = a
    }, function(t, e, i) {
        "use strict";
        Object.defineProperty(e, "__esModule", {
            value: !0
        });
        var n = function() {
            function t() {
                this.clear()
            }
            return t.prototype.getItem = function(t, e) {
                var i = this._cache;
                if (i && i[t]) {
                    var n = i[t];
                    if (void 0 !== n[e]) return n[e]
                }
                return -1
            }, t.prototype.setItem = function(t, e, i) {
                if (t && e) {
                    var n = this._cache;
                    n && (n[t] || (n[t] = {}), n[t][e] = i)
                }
            }, t.prototype.clear = function() {
                this._cache = {}
            }, t
        }();
        e.WorkUnitsObjectCache = n
    }, function(t, e, i) {
        "use strict";
        Object.defineProperty(e, "__esModule", {
            value: !0
        });
        var n = function() {
            function t() {
                this.clear()
            }
            return t.prototype.getItem = function(t, e) {
                if (this._cache.has(t)) {
                    var i = this._cache.get(t);
                    if (i.has(e)) return i.get(e)
                }
                return -1
            }, t.prototype.setItem = function(t, e, i) {
                if (t && e) {
                    var n, r = this._cache;
                    r.has(t) ? n = r.get(t) : (n = new Map, r.set(t, n)), n.set(e, i)
                }
            }, t.prototype.clear = function() {
                this._cache = new Map
            }, t
        }();
        e.WorkUnitsMapCache = n
    }, function(t, e, i) {
        "use strict";
        Object.defineProperty(e, "__esModule", {
            value: !0
        });
        var n = i(79),
            r = i(78);
        e.createCacheObject = function() {
            return "undefined" != typeof Map ? new n.WorkUnitsMapCache : new r.WorkUnitsObjectCache
        }
    }, function(t, e, i) {
        var n = i(80),
            r = i(0);

        function a(t, e) {
            this.argumentsHelper = e, this.$gantt = t, this._workingUnitsCache = n.createCacheObject()
        }
        a.prototype = {
            units: ["year", "month", "week", "day", "hour", "minute"],
            _getUnitOrder: function(t) {
                for (var e = 0, i = this.units.length; e < i; e++)
                    if (this.units[e] == t) return e
            },
            _timestamp: function(t) {
                var e = null;
                return t.day || 0 === t.day ? e = t.day : t.date && (e = Date.UTC(t.date.getFullYear(), t.date.getMonth(), t.date.getDate())), e
            },
            _checkIfWorkingUnit: function(t, e, i) {
                return void 0 === i && (i = this._getUnitOrder(e)), void 0 === i || !(i && !this._isWorkTime(t, this.units[i - 1], i - 1)) && (!this["_is_work_" + e] || this["_is_work_" + e](t))
            },
            _is_work_day: function(t) {
                var e = this._getWorkHours(t);
                return e instanceof Array && e.length > 0
            },
            _is_work_hour: function(t) {
                for (var e = this._getWorkHours(t), i = t.getHours(), n = 0; n < e.length; n += 2) {
                    if (void 0 === e[n + 1]) return e[n] == i;
                    if (i >= e[n] && i < e[n + 1]) return !0
                }
                return !1
            },
            _internDatesPull: {},
            _nextDate: function(t, e, i) {
                return this.$gantt.date.add(t, i, e)
            },
            _getWorkUnitsBetweenGeneric: function(t, e, i, n) {
                var r = this.$gantt.date,
                    a = new Date(t),
                    o = new Date(e);
                n = n || 1;
                var s, l, c = 0,
                    u = null,
                    d = !1;
                (s = r[i + "_start"](new Date(a))).valueOf() != a.valueOf() && (d = !0);
                var h = !1;
                (l = r[i + "_start"](new Date(e))).valueOf() != e.valueOf() && (h = !0);
                for (var f = !1; a.valueOf() < o.valueOf();) f = (u = this._nextDate(a, i, n)).valueOf() > o.valueOf(), this._isWorkTime(a, i) && ((d || h && f) && (s = r[i + "_start"](new Date(a)), l = r.add(s, n, i)), d ? (d = !1, u = this._nextDate(s, i, n), c += (l.valueOf() - a.valueOf()) / (l.valueOf() - s.valueOf())) : h && f ? (h = !1, c += (o.valueOf() - a.valueOf()) / (l.valueOf() - s.valueOf())) : c++), a = u;
                return c
            },
            _getMinutesPerDay: function(t) {
                return 60 * this._getHoursPerDay(t)
            },
            _getHoursPerDay: function(t) {
                for (var e = this._getWorkHours(t), i = 0, n = 0; n < e.length; n += 2) i += e[n + 1] - e[n] || 0;
                return i
            },
            _getWorkUnitsForRange: function(t, e, i, n) {
                var a, o = 0,
                    s = new Date(t),
                    l = new Date(e);
                for (a = "minute" == i ? r.bind(this._getMinutesPerDay, this) : r.bind(this._getHoursPerDay, this); s.valueOf() < l.valueOf();) this._isWorkTime(s, "day") && (o += a(s)), s = this._nextDate(s, "day", 1);
                return o / n
            },
            _getWorkUnitsBetweenQuick: function(t, e, i, n) {
                var r = new Date(t),
                    a = new Date(e);
                n = n || 1;
                var o = new Date(r),
                    s = this.$gantt.date.add(this.$gantt.date.day_start(new Date(r)), 1, "day");
                if (a.valueOf() <= s.valueOf()) return this._getWorkUnitsBetweenGeneric(t, e, i, n);
                var l = this.$gantt.date.day_start(new Date(a)),
                    c = a,
                    u = this._getWorkUnitsBetweenGeneric(o, s, i, n),
                    d = this._getWorkUnitsBetweenGeneric(l, c, i, n);
                return u + this._getWorkUnitsForRange(s, l, i, n) + d
            },
            _getCalendar: function() {
                return this.worktime
            },
            _setCalendar: function(t) {
                this.worktime = t
            },
            _tryChangeCalendarSettings: function(t) {
                var e = JSON.stringify(this._getCalendar());
                return t(), !this._isEmptyCalendar(this._getCalendar()) || (this.$gantt.assert(!1, "Invalid calendar settings, no worktime available"), this._setCalendar(JSON.parse(e)), this._workingUnitsCache.clear(), !1)
            },
            _isEmptyCalendar: function(t) {
                var e = !1,
                    i = [],
                    n = !0;
                for (var r in t.dates) e |= !!t.dates[r], i.push(r);
                var a = [];
                for (r = 0; r < i.length; r++) i[r] < 10 && a.push(i[r]);
                a.sort();
                for (r = 0; r < 7; r++) a[r] != r && (n = !1);
                return n ? !e : !(e || t.hours)
            },
            getWorkHours: function() {
                var t = this.argumentsHelper.getWorkHoursArguments.apply(this.argumentsHelper, arguments);
                return this._getWorkHours(t.date)
            },
            _getWorkHours: function(t) {
                var e = this._timestamp({
                        date: t
                    }),
                    i = !0,
                    n = this._getCalendar();
                return void 0 !== n.dates[e] ? i = n.dates[e] : void 0 !== n.dates[t.getDay()] && (i = n.dates[t.getDay()]), !0 === i ? n.hours : i || []
            },
            setWorkTime: function(t) {
                return this._tryChangeCalendarSettings(r.bind(function() {
                    var e = void 0 === t.hours || t.hours,
                        i = this._timestamp(t);
                    null !== i ? this._getCalendar().dates[i] = e : this._getCalendar().hours = e, this._workingUnitsCache.clear()
                }, this))
            },
            unsetWorkTime: function(t) {
                return this._tryChangeCalendarSettings(r.bind(function() {
                    if (t) {
                        var e = this._timestamp(t);
                        null !== e && delete this._getCalendar().dates[e]
                    } else this.reset_calendar();
                    this._workingUnitsCache.clear()
                }, this))
            },
            _isWorkTime: function(t, e, i) {
                var n = String(t.valueOf()),
                    r = this._workingUnitsCache.getItem(e, n);
                return -1 == r && (r = this._checkIfWorkingUnit(t, e, i), this._workingUnitsCache.setItem(e, n, r)), r
            },
            isWorkTime: function() {
                var t = this.argumentsHelper.isWorkTimeArguments.apply(this.argumentsHelper, arguments);
                return this._isWorkTime(t.date, t.unit)
            },
            calculateDuration: function() {
                var t = this.argumentsHelper.getDurationArguments.apply(this.argumentsHelper, arguments);
                return !!t.unit && this._calculateDuration(t.start_date, t.end_date, t.unit, t.step)
            },
            _calculateDuration: function(t, e, i, n) {
                var r = 0;
                return r = "hour" == i || "minute" == i ? this._getWorkUnitsBetweenQuick(t, e, i, n) : this._getWorkUnitsBetweenGeneric(t, e, i, n), Math.round(r)
            },
            hasDuration: function() {
                var t = this.argumentsHelper.getDurationArguments.apply(this.argumentsHelper, arguments),
                    e = t.start_date,
                    i = t.end_date,
                    n = t.unit,
                    r = t.step;
                if (!n) return !1;
                var a = new Date(e),
                    o = new Date(i);
                for (r = r || 1; a.valueOf() < o.valueOf();) {
                    if (this._isWorkTime(a, n)) return !0;
                    a = this._nextDate(a, n, r)
                }
                return !1
            },
            calculateEndDate: function() {
                var t = this.argumentsHelper.calculateEndDateArguments.apply(this.argumentsHelper, arguments),
                    e = t.start_date,
                    i = t.duration,
                    n = t.unit,
                    r = t.step;
                if (!n) return !1;
                var a = t.duration >= 0 ? 1 : -1;
                return i = Math.abs(1 * i), this._calculateEndDate(e, i, n, r * a)
            },
            _calculateEndDate: function(t, e, i, n) {
                return !!i && (1 == n && "minute" == i ? this._calculateMinuteEndDate(t, e, n) : 1 == n && "hour" == i ? this._calculateHourEndDate(t, e, n) : this._addInterval(t, e, i, n, null).end)
            },
            _addInterval: function(t, e, i, n, r) {
                for (var a = 0, o = t; a < e && (!r || !r(o));) {
                    var s = this._nextDate(o, i, n);
                    this._isWorkTime(n > 0 ? new Date(s.valueOf() - 1) : new Date(s.valueOf() + 1), i) && a++, o = s
                }
                return {
                    end: o,
                    start: t,
                    added: a
                }
            },
            _calculateHourEndDate: function(t, e, i) {
                var n = new Date(t),
                    r = 0;
                i = i || 1, e = Math.abs(1 * e);
                var a = this._addInterval(n, e, "hour", i, function(t) {
                    return !(t.getHours() || t.getMinutes() || t.getSeconds() || t.getMilliseconds())
                });
                if (r = a.added, n = a.end, (c = e - r) && c > 24) {
                    for (var o = n; r < e;) {
                        var s = this._nextDate(o, "day", i);
                        if (s.setHours(0), s.setMinutes(0), s.setSeconds(0), this._isWorkTime(i > 0 ? new Date(s.valueOf() - 1) : new Date(s.valueOf() + 1), "day")) {
                            var l = this._getHoursPerDay(o);
                            if (r + l >= e) break;
                            r += l
                        }
                        o = s
                    }
                    n = o
                }
                if (r < e) {
                    var c = e - r;
                    n = (a = this._addInterval(n, c, "hour", i, null)).end
                }
                return n
            },
            _calculateMinuteEndDate: function(t, e, i) {
                var n = new Date(t),
                    r = 0;
                i = i || 1, e = Math.abs(1 * e);
                var a = this._addInterval(n, e, "minute", i, function(t) {
                    return !(t.getMinutes() || t.getSeconds() || t.getMilliseconds())
                });
                if (r = a.added, n = a.end, r < e) {
                    var o = e - r,
                        s = Math.floor(o / 60);
                    s && (n = this._calculateEndDate(n, s, "hour", i > 0 ? 1 : -1), r += 60 * s)
                }
                if (r < e) {
                    var l = e - r;
                    n = (a = this._addInterval(n, l, "minute", i, null)).end
                }
                return n
            },
            getClosestWorkTime: function() {
                var t = this.argumentsHelper.getClosestWorkTimeArguments.apply(this.argumentsHelper, arguments);
                return this._getClosestWorkTime(t.date, t.unit, t.dir)
            },
            _getClosestWorkTime: function(t, e, i) {
                var n = new Date(t);
                if (this._isWorkTime(n, e)) return n;
                if (n = this.$gantt.date[e + "_start"](n), "any" != i && i) n = "past" == i ? this._getClosestWorkTimePast(n, e) : this._getClosestWorkTimeFuture(n, e);
                else {
                    var r = this._getClosestWorkTimeFuture(n, e),
                        a = this._getClosestWorkTimePast(n, e);
                    n = Math.abs(r - t) <= Math.abs(t - a) ? r : a
                }
                return n
            },
            _getClosestWorkTimeFuture: function(t, e) {
                return this._getClosestWorkTimeGeneric(t, e, 1)
            },
            _getClosestWorkTimePast: function(t, e) {
                var i = this._getClosestWorkTimeGeneric(t, e, -1);
                return this.$gantt.date.add(i, 1, e)
            },
            _getClosestWorkTimeGeneric: function(t, e, i) {
                for (var n = this._getUnitOrder(e), r = this.units[n - 1], a = t, o = 0; !this._isWorkTime(a, e) && (!r || this._isWorkTime(a, r) || (a = i > 0 ? this._getClosestWorkTimeFuture(a, r) : this._getClosestWorkTimePast(a, r), !this._isWorkTime(a, e)));) {
                    if (++o > 3e3) return this.$gantt.assert(!1, "Invalid working time check"), !1;
                    var s = a.getTimezoneOffset();
                    a = this.$gantt.date.add(a, i, e), a = this.$gantt._correct_dst_change(a, s, i, e), this.$gantt.date[e + "_start"] && (a = this.$gantt.date[e + "_start"](a))
                }
                return a
            }
        }, t.exports = a
    }, function(t, e, i) {
        var n = i(0),
            r = i(26),
            a = i(81);

        function o(t) {
            this.$gantt = t, this._calendars = {}
        }
        o.prototype = {
            _calendars: {},
            _getDayHoursForMultiple: function(t, e) {
                for (var i = [], n = !0, r = 0, a = this.$gantt.date.day_start(new Date(e)), o = 0; o < 24; o++) t.reduce(function(t, e) {
                    return t && e._is_work_hour(a)
                }, !0) ? (n ? (i[r] = o, i[r + 1] = o + 1, r += 2) : i[r - 1] += 1, n = !1) : n || (n = !0), a = this.$gantt.date.add(a, 1, "hour");
                return i.length || (i = !1), i
            },
            mergeCalendars: function() {
                var t, e = this.createCalendar(),
                    i = [],
                    n = Array.prototype.slice.call(arguments, 0);
                e.worktime.hours = [0, 24], e.worktime.dates = {};
                var r = this.$gantt.date.day_start(new Date(2592e5));
                for (t = 0; t < 7; t++) i = this._getDayHoursForMultiple(n, r), e.worktime.dates[t] = i, r = this.$gantt.date.add(r, 1, "day");
                for (var a = 0; a < n.length; a++)
                    for (var o in n[a].worktime.dates) + o > 1e4 && (i = this._getDayHoursForMultiple(n, new Date(+o)), e.worktime.dates[o] = i);
                return e
            },
            _convertWorktimeSettings: function(t) {
                var e = t.days;
                if (e) {
                    t.dates = t.dates || {};
                    for (var i = 0; i < e.length; i++) t.dates[i] = e[i], e[i] instanceof Array || (t.dates[i] = !!e[i]);
                    delete t.days
                }
                return t
            },
            createCalendar: function(t) {
                var e;
                t || (t = {}), e = t.worktime ? n.copy(t.worktime) : n.copy(t);
                var i = n.copy(this.defaults.fulltime.worktime);
                n.mixin(e, i);
                var o = {
                        id: n.uid() + "",
                        worktime: this._convertWorktimeSettings(e)
                    },
                    s = new a(this.$gantt, r(this.$gantt));
                return n.mixin(s, o), s._tryChangeCalendarSettings(function() {}) ? s : null
            },
            getCalendar: function(t) {
                return t = t || "global", this.createDefaultCalendars(), this._calendars[t]
            },
            getCalendars: function() {
                var t = [];
                for (var e in this._calendars) t.push(this.getCalendar(e));
                return t
            },
            _getOwnCalendar: function(t) {
                var e = this.$gantt.config;
                if (t[e.calendar_property]) return this.getCalendar(t[e.calendar_property]);
                if (e.resource_calendars)
                    for (var i in e.resource_calendars) {
                        var n = e.resource_calendars[i];
                        if (t[i]) {
                            var r = n[t[i]];
                            if (r) return this.getCalendar(r)
                        }
                    }
                return null
            },
            getTaskCalendar: function(t) {
                if (!t) return this.getCalendar();
                var e = this._getOwnCalendar(t),
                    i = this.$gantt;
                if (!e && i.config.inherit_calendar && i.isTaskExists(t.parent)) {
                    var n = !1;
                    i.eachParent(function(t) {
                        n || i.isSummaryTask(t) && (e = this._getOwnCalendar(t)) && (n = !0)
                    }, t.id, this)
                }
                return e || this.getCalendar()
            },
            addCalendar: function(t) {
                if (!(t instanceof a)) {
                    var e = t.id;
                    (t = this.createCalendar(t)).id = e
                }
                var i = this.$gantt.config;
                return t.id = t.id || n.uid(), this._calendars[t.id] = t, i.worktimes || (i.worktimes = {}), i.worktimes[t.id] = t.worktime, t.id
            },
            deleteCalendar: function(t) {
                var e = this.$gantt.config;
                return !!t && (!!this._calendars[t] && (delete this._calendars[t], e.worktimes && e.worktimes[t] && delete e.worktimes[t], !0))
            },
            restoreConfigCalendars: function(t) {
                for (var e in t)
                    if (!this._calendars[e]) {
                        var i = t[e],
                            n = this.createCalendar(i);
                        n.id = e, this.addCalendar(n)
                    }
            },
            defaults: {
                global: {
                    id: "global",
                    worktime: {
                        hours: [8, 17],
                        days: [0, 1, 1, 1, 1, 1, 0]
                    }
                },
                fulltime: {
                    id: "fulltime",
                    worktime: {
                        hours: [0, 24],
                        days: [1, 1, 1, 1, 1, 1, 1]
                    }
                }
            },
            createDefaultCalendars: function() {
                var t = this.$gantt.config;
                this.restoreConfigCalendars(this.defaults), this.restoreConfigCalendars(t.worktimes)
            }
        }, t.exports = o
    }, function(t, e, i) {
        var n = i(82),
            r = i(77),
            a = i(75),
            o = i(0);
        t.exports = function(t) {
            var e = new n(t),
                i = new r(e),
                s = a.create(e, i);
            o.mixin(t, s)
        }
    }, function(t, e, i) {
        var n = i(2);
        t.exports = function(t) {
            function e(e) {
                throw t.assert(!1, "Can't parse data: incorrect value of gantt.parse or gantt.load method. Actual argument value: " + JSON.stringify(e)), new Error("Invalid argument for gantt.parse or gantt.load. An object or a JSON string of format https://docs.dhtmlx.com/gantt/desktop__supported_data_formats.html#json is expected. Actual argument value: " + JSON.stringify(e))
            }
            t.load = function(e, i, n) {
                this._load_url = e, this.assert(arguments.length, "Invalid load arguments");
                var r = "json",
                    a = null;
                return arguments.length >= 3 ? (r = i, a = n) : "string" == typeof arguments[1] ? r = arguments[1] : "function" == typeof arguments[1] && (a = arguments[1]), this._load_type = r, this.callEvent("onLoadStart", [e, r]), this.ajax.get(e, t.bind(function(t) {
                    this.on_load(t, r), this.callEvent("onLoadEnd", [e, r]), "function" == typeof a && a.call(this)
                }, this))
            }, t.parse = function(t, e) {
                this.on_load({
                    xmlDoc: {
                        responseText: t
                    }
                }, e)
            }, t.serialize = function(t) {
                return this[t = t || "json"].serialize()
            }, t.on_load = function(t, e) {
                if (t.xmlDoc && 404 === t.xmlDoc.status) this.assert(!1, "Failed to load the data from <a href='" + t.xmlDoc.responseURL + "' target='_blank'>" + t.xmlDoc.responseURL + "</a>, server returns 404");
                else {
                    this.callEvent("onBeforeParse", []), e || (e = "json"), this.assert(this[e], "Invalid data type:'" + e + "'");
                    var i = t.xmlDoc.responseText,
                        n = this[e].parse(i, t);
                    this._process_loading(n)
                }
            }, t._process_loading = function(t) {
                t.collections && this._load_collections(t.collections), this.$data.tasksStore.parse(t.data);
                var e = t.links || (t.collections ? t.collections.links : []);
                if (this.$data.linksStore.parse(e), this.callEvent("onParse", []), this.render(), this.config.initial_scroll) {
                    var i = this.getTaskByIndex(0),
                        n = i ? i.id : this.config.root_id;
                    this.isTaskExists(n) && this.showTask(n)
                }
            }, t._load_collections = function(t) {
                var e = !1;
                for (var i in t)
                    if (t.hasOwnProperty(i)) {
                        e = !0;
                        var n = t[i],
                            r = this.serverList[i];
                        if (!r) continue;
                        r.splice(0, r.length);
                        for (var a = 0; a < n.length; a++) {
                            var o = n[a],
                                s = this.copy(o);
                            for (var l in s.key = s.value, o)
                                if (o.hasOwnProperty(l)) {
                                    if ("value" == l || "label" == l) continue;
                                    s[l] = o[l]
                                }
                            r.push(s)
                        }
                    }
                e && this.callEvent("onOptionsLoad", [])
            }, t.attachEvent("onBeforeTaskDisplay", function(t, e) {
                return !e.$ignore
            }), t.json = {
                parse: function(i) {
                    if (i || e(i), "string" == typeof i)
                        if (window.JSON) try {
                            i = JSON.parse(i)
                        } catch (t) {
                            e(i)
                        } else t.assert(!1, "JSON is not supported");
                    return i.data || e(i), i.dhx_security && (t.security_key = i.dhx_security), i
                },
                serializeTask: function(t) {
                    return this._copyObject(t)
                },
                serializeLink: function(t) {
                    return this._copyLink(t)
                },
                _copyLink: function(t) {
                    var e = {};
                    for (var i in t) e[i] = t[i];
                    return e
                },
                _copyObject: function(e) {
                    var i = {};
                    for (var r in e) "$" != r.charAt(0) && (i[r] = e[r], n.isDate(i[r]) && (i[r] = t.templates.xml_format !== t.templates.formate_date ? t.templates.xml_format(i[r]) : t.templates.formate_date(i[r])));
                    return i
                },
                serialize: function() {
                    var e = [],
                        i = [];
                    t.eachTask(function(i) {
                        t.resetProjectDates(i), e.push(this.serializeTask(i))
                    }, t.config.root_id, this);
                    for (var n = t.getLinks(), r = 0; r < n.length; r++) i.push(this.serializeLink(n[r]));
                    return {
                        data: e,
                        links: i
                    }
                }
            }, t.xml = {
                _xmlNodeToJSON: function(t, e) {
                    for (var i = {}, n = 0; n < t.attributes.length; n++) i[t.attributes[n].name] = t.attributes[n].value;
                    if (!e) {
                        for (n = 0; n < t.childNodes.length; n++) {
                            var r = t.childNodes[n];
                            1 == r.nodeType && (i[r.tagName] = r.firstChild ? r.firstChild.nodeValue : "")
                        }
                        i.text || (i.text = t.firstChild ? t.firstChild.nodeValue : "")
                    }
                    return i
                },
                _getCollections: function(e) {
                    for (var i = {}, n = t.ajax.xpath("//coll_options", e), r = 0; r < n.length; r++)
                        for (var a = i[n[r].getAttribute("for")] = [], o = t.ajax.xpath(".//item", n[r]), s = 0; s < o.length; s++) {
                            for (var l = o[s].attributes, c = {
                                    key: o[s].getAttribute("value"),
                                    label: o[s].getAttribute("label")
                                }, u = 0; u < l.length; u++) {
                                var d = l[u];
                                "value" != d.nodeName && "label" != d.nodeName && (c[d.nodeName] = d.nodeValue)
                            }
                            a.push(c)
                        }
                    return i
                },
                _getXML: function(e, i, n) {
                    n = n || "data", i.getXMLTopNode || (i = t.ajax.parse(i));
                    var r = t.ajax.xmltop(n, i.xmlDoc);
                    r && r.tagName == n || function(e) {
                        throw t.assert(!1, "Can't parse data: incorrect value of gantt.parse or gantt.load method. Actual argument value: " + JSON.stringify(e)), new Error("Invalid argument for gantt.parse or gantt.load. An XML of format https://docs.dhtmlx.com/gantt/desktop__supported_data_formats.html#xmldhtmlxgantt20 is expected. Actual argument value: " + JSON.stringify(e))
                    }(e);
                    var a = r.getAttribute("dhx_security");
                    return a && (t.security_key = a), r
                },
                parse: function(e, i) {
                    i = this._getXML(e, i);
                    for (var n = {}, r = n.data = [], a = t.ajax.xpath("//task", i), o = 0; o < a.length; o++) r[o] = this._xmlNodeToJSON(a[o]);
                    return n.collections = this._getCollections(i), n
                },
                _copyLink: function(t) {
                    return "<item id='" + t.id + "' source='" + t.source + "' target='" + t.target + "' type='" + t.type + "' />"
                },
                _copyObject: function(t) {
                    return "<task id='" + t.id + "' parent='" + (t.parent || "") + "' start_date='" + t.start_date + "' duration='" + t.duration + "' open='" + !!t.open + "' progress='" + t.progress + "' end_date='" + t.end_date + "'><![CDATA[" + t.text + "]]></task>"
                },
                serialize: function() {
                    for (var e = [], i = [], n = t.json.serialize(), r = 0, a = n.data.length; r < a; r++) e.push(this._copyObject(n.data[r]));
                    for (r = 0, a = n.links.length; r < a; r++) i.push(this._copyLink(n.links[r]));
                    return "<data>" + e.join("") + "<coll_options for='links'>" + i.join("") + "</coll_options></data>"
                }
            }, t.oldxml = {
                parse: function(e, i) {
                    i = t.xml._getXML(e, i, "projects");
                    for (var n = {
                            collections: {
                                links: []
                            }
                        }, r = n.data = [], a = t.ajax.xpath("//task", i), o = 0; o < a.length; o++) {
                        r[o] = t.xml._xmlNodeToJSON(a[o]);
                        var s = a[o].parentNode;
                        "project" == s.tagName ? r[o].parent = "project-" + s.getAttribute("id") : r[o].parent = s.parentNode.getAttribute("id")
                    }
                    a = t.ajax.xpath("//project", i);
                    for (o = 0; o < a.length; o++) {
                        (l = t.xml._xmlNodeToJSON(a[o], !0)).id = "project-" + l.id, r.push(l)
                    }
                    for (o = 0; o < r.length; o++) {
                        var l;
                        (l = r[o]).start_date = l.startdate || l.est, l.end_date = l.enddate, l.text = l.name, l.duration = l.duration / 8, l.open = 1, l.duration || l.end_date || (l.duration = 1), l.predecessortasks && n.collections.links.push({
                            target: l.id,
                            source: l.predecessortasks,
                            type: t.config.links.finish_to_start
                        })
                    }
                    return n
                },
                serialize: function() {
                    t.message("Serialization to 'old XML' is not implemented")
                }
            }, t.serverList = function(t, e) {
                return e ? this.serverList[t] = e.slice(0) : this.serverList[t] || (this.serverList[t] = []), this.serverList[t]
            }
        }
    }, function(t, e) {
        t.exports = function(t) {
            t.isReadonly = function(t) {
                return (!t || !t[this.config.editable_property]) && (t && t[this.config.readonly_property] || this.config.readonly)
            }
        }
    }, function(t, e) {
        t.exports = function(t) {
            var e = new RegExp("<(?:.|\n)*?>", "gm"),
                i = new RegExp(" +", "gm");

            function n(t) {
                return (t + "").replace(e, " ").replace(i, " ")
            }
            var r = new RegExp("'", "gm");

            function a(t) {
                return (t + "").replace(r, "&#39;")
            }
            for (var o in t._waiAria = {
                    getAttributeString: function(t) {
                        var e = [" "];
                        for (var i in t) {
                            var r = a(n(t[i]));
                            e.push(i + "='" + r + "'")
                        }
                        return e.push(" "), e.join(" ")
                    },
                    getTimelineCellAttr: function(e) {
                        return t._waiAria.getAttributeString({
                            "aria-label": e
                        })
                    },
                    _taskCommonAttr: function(e, i) {
                        e.start_date && e.end_date && (i.setAttribute("aria-label", n(t.templates.tooltip_text(e.start_date, e.end_date, e))), t.isReadonly(e) && i.setAttribute("aria-readonly", !0), e.$dataprocessor_class && i.setAttribute("aria-busy", !0), i.setAttribute("aria-selected", t.isSelectedTask(e.id) ? "true" : "false"))
                    },
                    setTaskBarAttr: function(e, i) {
                        this._taskCommonAttr(e, i), !t.isReadonly(e) && t.config.drag_move && (e.id != t.getState().drag_id ? i.setAttribute("aria-grabbed", !1) : i.setAttribute("aria-grabbed", !0))
                    },
                    taskRowAttr: function(e, i) {
                        this._taskCommonAttr(e, i), !t.isReadonly(e) && t.config.order_branch && i.setAttribute("aria-grabbed", !1), i.setAttribute("role", "row"), i.setAttribute("aria-level", e.$level), t.hasChild(e.id) && i.setAttribute("aria-expanded", e.$open ? "true" : "false")
                    },
                    linkAttr: function(e, i) {
                        var r = t.config.links,
                            a = e.type == r.finish_to_start || e.type == r.start_to_start,
                            o = e.type == r.start_to_start || e.type == r.start_to_finish,
                            s = t.locale.labels.link + " " + t.templates.drag_link(e.source, o, e.target, a);
                        i.setAttribute("aria-label", n(s)), t.isReadonly(e) && i.setAttribute("aria-readonly", !0)
                    },
                    gridSeparatorAttr: function(t) {
                        t.setAttribute("role", "separator")
                    },
                    lightboxHiddenAttr: function(t) {
                        t.setAttribute("aria-hidden", "true")
                    },
                    lightboxVisibleAttr: function(t) {
                        t.setAttribute("aria-hidden", "false")
                    },
                    lightboxAttr: function(t) {
                        t.setAttribute("role", "dialog"), t.setAttribute("aria-hidden", "true"), t.firstChild.setAttribute("role", "heading")
                    },
                    lightboxButtonAttrString: function(e) {
                        return this.getAttributeString({
                            role: "button",
                            "aria-label": t.locale.labels[e],
                            tabindex: "0"
                        })
                    },
                    lightboxHeader: function(t, e) {
                        t.setAttribute("aria-label", e)
                    },
                    lightboxSelectAttrString: function(e) {
                        var i = "";
                        switch (e) {
                            case "%Y":
                                i = t.locale.labels.years;
                                break;
                            case "%m":
                                i = t.locale.labels.months;
                                break;
                            case "%d":
                                i = t.locale.labels.days;
                                break;
                            case "%H:%i":
                                i = t.locale.labels.hours + t.locale.labels.minutes
                        }
                        return t._waiAria.getAttributeString({
                            "aria-label": i
                        })
                    },
                    lightboxDurationInputAttrString: function(e) {
                        return this.getAttributeString({
                            "aria-label": t.locale.labels.column_duration,
                            "aria-valuemin": "0"
                        })
                    },
                    gridAttrString: function() {
                        return [" role='treegrid'", t.config.multiselect ? "aria-multiselectable='true'" : "aria-multiselectable='false'", " "].join(" ")
                    },
                    gridScaleRowAttrString: function() {
                        return "role='row'"
                    },
                    gridScaleCellAttrString: function(e, i) {
                        var n = "";
                        if ("add" == e.name) n = this.getAttributeString({
                            role: "button",
                            "aria-label": t.locale.labels.new_task
                        });
                        else {
                            var r = {
                                role: "columnheader",
                                "aria-label": i
                            };
                            t._sort && t._sort.name == e.name && ("asc" == t._sort.direction ? r["aria-sort"] = "ascending" : r["aria-sort"] = "descending"), n = this.getAttributeString(r)
                        }
                        return n
                    },
                    gridDataAttrString: function() {
                        return "role='rowgroup'"
                    },
                    gridCellAttrString: function(t, e) {
                        return this.getAttributeString({
                            role: "gridcell",
                            "aria-label": e
                        })
                    },
                    gridAddButtonAttrString: function(e) {
                        return this.getAttributeString({
                            role: "button",
                            "aria-label": t.locale.labels.new_task
                        })
                    },
                    messageButtonAttrString: function(t) {
                        return "tabindex='0' role='button' aria-label='" + t + "'"
                    },
                    messageInfoAttr: function(t) {
                        t.setAttribute("role", "alert")
                    },
                    messageModalAttr: function(t, e) {
                        t.setAttribute("role", "dialog"), e && t.setAttribute("aria-labelledby", e)
                    },
                    quickInfoAttr: function(t) {
                        t.setAttribute("role", "dialog")
                    },
                    quickInfoHeaderAttrString: function() {
                        return " role='heading' "
                    },
                    quickInfoHeader: function(t, e) {
                        t.setAttribute("aria-label", e)
                    },
                    quickInfoButtonAttrString: function(e) {
                        return t._waiAria.getAttributeString({
                            role: "button",
                            "aria-label": e,
                            tabindex: "0"
                        })
                    },
                    tooltipAttr: function(t) {
                        t.setAttribute("role", "tooltip")
                    },
                    tooltipVisibleAttr: function(t) {
                        t.setAttribute("aria-hidden", "false")
                    },
                    tooltipHiddenAttr: function(t) {
                        t.setAttribute("aria-hidden", "true")
                    }
                }, t._waiAria) t._waiAria[o] = function(e) {
                return function() {
                    return t.config.wai_aria_attributes ? e.apply(this, arguments) : ""
                }
            }(t._waiAria[o])
        }
    }, function(t, e) {
        t.exports = function(t) {
            t.getGridColumn = function(e) {
                for (var i = t.config.columns, n = 0; n < i.length; n++)
                    if (i[n].name == e) return i[n];
                return null
            }, t.getGridColumns = function() {
                return t.config.columns.slice()
            }
        }
    }, function(t, e, i) {
        var n = i(17);
        t.exports = function(t) {
            i(87)(t), n.prototype.getGridColumns = function() {
                for (var t = this.$getConfig().columns, e = [], i = 0; i < t.length; i++) t[i].hide || e.push(t[i]);
                return e
            }
        }
    }, function(t, e, i) {
        t.exports = function(t) {
            var e = i(29).prototype.hasChild;
            t.$data.tasksStore.hasChild = function(i) {
                return !!e.apply(this, arguments) || !!this.exists(i) && this.getItem(i)[t.config.branch_loading_property]
            }, t.attachEvent("onTaskOpened", function(e) {
                if (t.config.branch_loading && t._load_url && function(e) {
                        return !(!t.config.branch_loading || !t._load_url || t.getUserData(e, "was_rendered") || t.getChildren(e).length || !t.hasChild(e))
                    }(e)) {
                    var i = t._load_url,
                        n = (i = i.replace(/(\?|&)?parent_id=.+&?/, "")).indexOf("?") >= 0 ? "&" : "?",
                        r = t.getScrollState().y || 0;
                    t.load(i + n + "parent_id=" + encodeURIComponent(e), this._load_type, function() {
                        r && t.scrollTo(null, r)
                    }), t.setUserData(e, "was_rendered", !0)
                }
            })
        }
    }, function(t, e, i) {
        "use strict";
        Object.defineProperty(e, "__esModule", {
            value: !0
        });
        var n = i(8),
            r = i(4),
            a = ["ctrlKey", "altKey", "shiftKey", "metaKey"],
            o = [
                [{
                    unit: "month",
                    date: "%M",
                    step: 1
                }, {
                    unit: "day",
                    date: "%d",
                    step: 1
                }],
                [{
                    unit: "day",
                    date: "%d %M",
                    step: 1
                }],
                [{
                    unit: "day",
                    date: "%d %M",
                    step: 1
                }, {
                    unit: "hour",
                    date: "%H:00",
                    step: 8
                }],
                [{
                    unit: "day",
                    date: "%d %M",
                    step: 1
                }, {
                    unit: "hour",
                    date: "%H:00",
                    step: 1
                }]
            ],
            s = function() {
                function t(t) {
                    var e = this;
                    this.zoomIn = function() {
                        var t = e.getCurrentLevel() - 1;
                        t < 0 || e.setLevel(t)
                    }, this.zoomOut = function() {
                        var t = e.getCurrentLevel() + 1;
                        t > e._levels.length - 1 || e.setLevel(t)
                    }, this.getCurrentLevel = function() {
                        return e._activeLevelIndex
                    }, this.getLevels = function() {
                        return e._levels
                    }, this.setLevel = function(t) {
                        var i = e._getZoomIndexByName(t); - 1 === i && e.$gantt.assert(-1 !== i, "Invalid zoom level for gantt.ext.zoom.setLevel. " + t + " is not an expected value."), e._setLevel(i, 0)
                    }, this._getZoomIndexByName = function(t) {
                        var i = -1;
                        if ("string" == typeof t) {
                            if (!isNaN(Number(t)) && e._levels[Number(t)]) i = Number(t);
                            else
                                for (var n = 0; n < e._levels.length; n++)
                                    if (e._levels[n].name === t) {
                                        i = n;
                                        break
                                    }
                        } else i = t;
                        return i
                    }, this._getVisibleDate = function() {
                        var t = e.$gantt.getScrollState().x,
                            i = e.$gantt.$task.offsetWidth;
                        e._visibleDate = e.$gantt.dateFromPos(t + i / 2)
                    }, this._setLevel = function(t, i) {
                        e._activeLevelIndex = t;
                        var n = e.$gantt,
                            r = n.copy(e._levels[e._activeLevelIndex]),
                            a = n.copy(r);
                        if (delete a.name, n.mixin(n.config, a, !0), !!n.$root) {
                            if (i) {
                                var o = e.$gantt.dateFromPos(i + e.$gantt.getScrollState().x);
                                e.$gantt.render();
                                var s = e.$gantt.posFromDate(o);
                                e.$gantt.scrollTo(s - i)
                            } else {
                                var l = e.$gantt.$task.offsetWidth;
                                e._visibleDate || e._getVisibleDate();
                                var c = e._visibleDate;
                                e.$gantt.render();
                                s = e.$gantt.posFromDate(c);
                                e.$gantt.scrollTo(s - l / 2)
                            }
                            e.callEvent("onAfterZoom", [e._activeLevelIndex, r])
                        }
                    }, this._attachWheelEvent = function(t) {
                        var i, r = n.isFF ? "wheel" : "mousewheel";
                        (i = "function" == typeof t.element ? t.element() : t.element) && e._domEvents.attach(i, r, e.$gantt.bind(function(t) {
                            if (this._useKey) {
                                if (a.indexOf(this._useKey) < 0) return !1;
                                if (!t[this._useKey]) return !1
                            }
                            if ("function" == typeof this._handler) return this._handler.apply(this, [t]), !0
                        }, e))
                    }, this._defaultHandler = function(t) {
                        var i = e.$gantt.$task.getBoundingClientRect().x,
                            n = t.clientX - i,
                            r = !1;
                        (e.$gantt.env.isFF ? -40 * t.deltaY : t.wheelDelta) > 0 && (r = !0), t.preventDefault(), t.stopPropagation(), e._setScaleSettings(r, n)
                    }, this._setScaleDates = function() {
                        e._initialStartDate && e._initialEndDate && (e.$gantt.config.start_date = e._initialStartDate, e.$gantt.config.end_date = e._initialEndDate)
                    }, this.$gantt = t, this._domEvents = this.$gantt._createDomEventScope()
                }
                return t.prototype.init = function(t) {
                    var e = this;
                    this._initialStartDate = t.startDate, this._initialEndDate = t.endDate, this._activeLevelIndex = t.activeLevelIndex ? t.activeLevelIndex : 0, this._levels = this._mapScales(t.levels || o), this._handler = t.handler || this._defaultHandler, this._minColumnWidth = t.minColumnWidth || 60, this._maxColumnWidth = t.maxColumnWidth || 240, this._widthStep = t.widthStep || 3 / 8 * t.minColumnWidth, this._useKey = t.useKey, this._initialized || (r(this), this.$gantt.attachEvent("onGanttScroll", function() {
                        e._getVisibleDate()
                    })), this._domEvents.detachAll(), "wheel" === t.trigger && (this.$gantt.$root ? this._attachWheelEvent(t) : this.$gantt.attachEvent("onGanttReady", function() {
                        e._attachWheelEvent(t)
                    })), this._initialized = !0, this.setLevel(this._activeLevelIndex)
                }, t.prototype._mapScales = function(t) {
                    return t.map(function(t) {
                        return Array.isArray(t) ? {
                            scales: t
                        } : t
                    })
                }, t.prototype._setScaleSettings = function(t, e) {
                    t ? this._stepUp(e) : this._stepDown(e)
                }, t.prototype._stepUp = function(t) {
                    if (!(this._activeLevelIndex >= this._levels.length - 1)) {
                        var e = this._activeLevelIndex;
                        if (this._setScaleDates(), this._widthStep) {
                            var i = this.$gantt.config.min_column_width + this._widthStep;
                            i > this._maxColumnWidth && (i = this._minColumnWidth, e++), this.$gantt.config.min_column_width = i
                        } else e++;
                        this._setLevel(e, t)
                    }
                }, t.prototype._stepDown = function(t) {
                    if (!(this._activeLevelIndex < 1)) {
                        var e = this._activeLevelIndex;
                        if (this._setScaleDates(), this._widthStep) {
                            var i = this.$gantt.config.min_column_width - this._widthStep;
                            i < this._minColumnWidth && (i = this._maxColumnWidth, e--), this.$gantt.config.min_column_width = i
                        } else e--;
                        this._setLevel(e, t)
                    }
                }, t
            }();
        e.default = s
    }, function(t, e, i) {
        "use strict";
        Object.defineProperty(e, "__esModule", {
            value: !0
        });
        var n = function() {
            function t(t) {
                var e = this;
                this.format = function(t) {
                    var i = e._getFormattedLinkType(e._getLinkTypeName(t.type)),
                        n = e._getWBSCode(t.source),
                        r = e._getLagString(t.lag);
                    return t.type !== gantt.config.links.finish_to_start || t.lag ? "" + n + i + r : n
                }, this.canParse = function(t) {
                    return e._linkReg.test(t)
                }, this.parse = function(t) {
                    if (!e.canParse(t)) return null;
                    var i = e._linkReg.exec(t)[0].trim(),
                        n = t.replace(i, "").trim(),
                        r = e._findTypeFormat(i),
                        a = e._getLinkTypeNumber(r);
                    return {
                        id: void 0,
                        source: e._findSource(i) || null,
                        target: null,
                        type: a,
                        lag: e._parseLag(n)
                    }
                }, this._getLinkTypeName = function(t) {
                    var i = "";
                    for (i in e._config.labels)
                        if (gantt.config.links[i].toLowerCase() === t.toLowerCase()) break;
                    return i
                }, this._getLinkTypeNumber = function(t) {
                    var e = "";
                    for (e in gantt.config.links)
                        if (e.toLowerCase() === t.toLowerCase()) break;
                    return gantt.config.links[e]
                }, this._getFormattedLinkType = function(t) {
                    return e._config.labels[t] || ""
                }, this._getWBSCode = function(t) {
                    var e = gantt.getTask(t);
                    return gantt.getWBSCode(e)
                }, this._getLagString = function(t) {
                    if (!t) return "";
                    var i = e._config.durationFormatter.format(t);
                    return t < 0 ? i : "+" + i
                }, this._findTypeFormat = function(t) {
                    var i = t.replace(/[^a-zA-Z]/gi, ""),
                        n = "finish_to_start";
                    for (var r in e._config.labels) e._config.labels[r].toLowerCase() === i.toLowerCase() && (n = r);
                    return n
                }, this._findSource = function(t) {
                    var e = new RegExp("^[0-9.]+", "i");
                    if (e.exec(t)) {
                        var i = e.exec(t)[0],
                            n = gantt.getTaskByWBSCode(i);
                        if (n) return n.id
                    }
                    return null
                }, this._parseLag = function(t) {
                    return t ? e._config.durationFormatter.parse(t) : 0
                }, this._config = this._defaultSettings(t), this._linkReg = /^[0-9\.]+[a-zA-Z]*/
            }
            return t.prototype._defaultSettings = function(t) {
                void 0 === t && (t = null);
                var e = {
                    durationFormatter: gantt.ext.formatters.durationFormatter(),
                    labels: {
                        finish_to_finish: "FF",
                        finish_to_start: "FS",
                        start_to_start: "SS",
                        start_to_finish: "SF"
                    }
                };
                if (t && t.durationFormatter && (e.durationFormatter = t.durationFormatter), t && t.labels)
                    for (var i in t.labels) e.labels[i] = t.labels[i];
                return e
            }, t.create = function(e) {
                return void 0 === e && (e = null), new t(e)
            }, t
        }();
        e.LinkFormatter = n
    }, function(t, e, i) {
        "use strict";
        Object.defineProperty(e, "__esModule", {
            value: !0
        });
        var n = function() {
            function t(t) {
                void 0 === t && (t = null);
                var e = this;
                this.canParse = function(t) {
                    var i = "",
                        n = e._config.labels;
                    for (var r in n) {
                        var a = n[r];
                        i += a.full + "|" + a.plural + "|" + a.short + "|"
                    }
                    return new RegExp("^([+-]? *[0-9.]{1,}\\s*(" + i + ")\\s*)*$").test((t || "").trim())
                }, this.format = function(t) {
                    var i = e._config.store,
                        n = e._config.format,
                        r = e._config.short,
                        a = e.transferUnits[i].toMinutes(t),
                        o = n;
                    if (o && "auto" === o && (o = e._selectFormatForValue(a)), o || (o = "day"), "auto" === n && !t) return "";
                    for (var s = "", l = (o = Array.isArray(o) ? o : [o]).length - 1, c = 0; c < o.length; c++) {
                        var u = o[c],
                            d = e._getValueFromMinutes(a, u, c === l);
                        a -= e._getValueInMinutes(d, u), s += e._getLabelForConvert(d, u, r) + (c === l ? "" : " ")
                    }
                    return s
                }, this.parse = function(t) {
                    if (e.canParse(t)) {
                        for (var i = "", n = !1, r = !1, a = 0, o = (t = (t || "").trim()).length - 1, s = /^[+\-0-9\. ]$/, l = 0; l < t.length; l++) {
                            var c = t[l];
                            s.test(c) ? r = n : n = !0, (r || o === l) && (r || (i += c), a += e._getNumericValue(i), n = r = !1, i = ""), i += c
                        }
                        if (a) {
                            var u = e._config.store;
                            return Math.round(e.transferUnits[u].fromMinutes(Math.ceil(a)))
                        }
                    }
                    return null
                }, this._getValueInMinutes = function(t, i) {
                    return e.transferUnits[i] && e.transferUnits[i].toMinutes ? e.transferUnits[i].toMinutes(t) : 0
                }, this._getLabelForConvert = function(t, i, n) {
                    var r = e._config.labels[i];
                    return n ? "" + t + r.short : t + " " + (1 !== t ? r.plural : r.full)
                }, this._getValueFromMinutes = function(t, i, n) {
                    if (e.transferUnits[i] && e.transferUnits[i].fromMinutes) {
                        var r = e.transferUnits[i].fromMinutes(t);
                        return n ? parseFloat(r.toFixed(2)) : parseInt(r.toString(), 10)
                    }
                    return null
                }, this._isUnitName = function(t, e) {
                    return e = e.toLowerCase(), t.full.toLowerCase() === e || t.plural.toLowerCase() === e || t.short.toLowerCase() === e
                }, this._getUnitName = function(t) {
                    var i, n = e._config.labels,
                        r = !1;
                    for (i in n)
                        if (e._isUnitName(n[i], t)) {
                            r = !0;
                            break
                        }
                    return r ? i : e._config.enter
                }, this._config = this._defaultSettings(t), this.transferUnits = {
                    minute: {
                        toMinutes: function(t) {
                            return t
                        },
                        fromMinutes: function(t) {
                            return t
                        }
                    },
                    hour: {
                        toMinutes: function(t) {
                            return t * e._config.minutesPerHour
                        },
                        fromMinutes: function(t) {
                            return t / e._config.minutesPerHour
                        }
                    },
                    day: {
                        toMinutes: function(t) {
                            return t * e._config.minutesPerHour * e._config.hoursPerDay
                        },
                        fromMinutes: function(t) {
                            return t / (e._config.minutesPerHour * e._config.hoursPerDay)
                        }
                    },
                    week: {
                        toMinutes: function(t) {
                            return t * e._config.minutesPerHour * e._config.hoursPerWeek
                        },
                        fromMinutes: function(t) {
                            return t / (e._config.minutesPerHour * e._config.hoursPerWeek)
                        }
                    },
                    month: {
                        toMinutes: function(t) {
                            return t * e._config.minutesPerHour * e._config.hoursPerDay * e._config.daysPerMonth
                        },
                        fromMinutes: function(t) {
                            return t / (e._config.minutesPerHour * e._config.hoursPerDay * e._config.daysPerMonth)
                        }
                    },
                    year: {
                        toMinutes: function(t) {
                            return t * e._config.minutesPerHour * e._config.hoursPerDay * e._config.daysPerYear
                        },
                        fromMinutes: function(t) {
                            return t / (e._config.minutesPerHour * e._config.hoursPerDay * e._config.daysPerYear)
                        }
                    }
                }
            }
            return t.prototype._defaultSettings = function(t) {
                void 0 === t && (t = null);
                var e = {
                    enter: "day",
                    store: "hour",
                    format: "auto",
                    short: !1,
                    minutesPerHour: 60,
                    hoursPerDay: 8,
                    hoursPerWeek: 40,
                    daysPerMonth: 30,
                    daysPerYear: 365,
                    labels: {
                        minute: {
                            full: "minute",
                            plural: "minutes",
                            short: "min"
                        },
                        hour: {
                            full: "hour",
                            plural: "hours",
                            short: "h"
                        },
                        day: {
                            full: "day",
                            plural: "days",
                            short: "d"
                        },
                        week: {
                            full: "week",
                            plural: "weeks",
                            short: "wk"
                        },
                        month: {
                            full: "month",
                            plural: "month",
                            short: "mon"
                        },
                        year: {
                            full: "year",
                            plural: "years",
                            short: "y"
                        }
                    }
                };
                if (t) {
                    for (var i in t) void 0 !== t[i] && "labels" !== i && (e[i] = t[i]);
                    if (t.labels)
                        for (var i in t.labels) e.labels[i] = t.labels[i]
                }
                return e
            }, t.prototype._selectFormatForValue = function(t) {
                for (var e = ["year", "month", "day", "hour", "minute"], i = [], n = 0; n < e.length; n++) i[n] = Math.abs(this.transferUnits[e[n]].fromMinutes(t));
                for (n = 0; n < i.length; n++) {
                    if (!(i[n] < 1 && n < i.length - 1)) return e[n]
                }
                return "day"
            }, t.prototype._getNumericValue = function(t) {
                var e = parseFloat(t.replace(/ /g, "")) || 0,
                    i = this._getUnitName(t.replace(/[^a-zA-Z]/gi, ""));
                return e && i ? this._getValueInMinutes(e, i) : 0
            }, t.create = function(e) {
                return void 0 === e && (e = null), new t(e)
            }, t
        }();
        e.DurationFormatter = n
    }, function(t, e, i) {
        var n = i(92).DurationFormatter,
            r = i(91).LinkFormatter;
        t.exports = function(t) {
            t.ext.formatters = {
                durationFormatter: function(e) {
                    return e || (e = {}), e.store || (e.store = t.config.duration_unit), e.enter || (e.enter = t.config.duration_unit), n.create(e)
                },
                linkFormatter: r.create
            }
        }
    }, function(t, e) {
        t.exports = function(t) {
            function e(e) {
                return function() {
                    return !t.config.auto_types || t.getTaskType(t.config.types.project) != t.config.types.project || e.apply(this, arguments)
                }
            }

            function i(e) {
                t.batchUpdate(function() {
                    ! function e(i) {
                        ! function(e) {
                            e = e.id || e;
                            var i = t.getTask(e),
                                n = a(i);
                            !1 !== n && r(i, n)
                        }(i);
                        var n = t.getParent(i);
                        n != t.config.root_id && e(n)
                    }(e)
                })
            }
            var n;

            function r(e, i) {
                t.getState().group_mode || (e.type = i, t.updateTask(e.id))
            }

            function a(e) {
                var i = t.config.types,
                    n = t.hasChild(e.id),
                    r = t.getTaskType(e.type);
                return n && r === i.task ? i.project : !n && r === i.project && i.task
            }
            var o, s, l = !0;

            function c(e) {
                e != t.config.root_id && t.isTaskExists(e) && i(e)
            }
            t.attachEvent("onParse", e(function() {
                l = !1, t.batchUpdate(function() {
                    t.eachTask(function(t) {
                        var e = a(t);
                        !1 !== e && r(t, e)
                    })
                }), l = !0
            })), t.attachEvent("onAfterTaskAdd", e(function(t) {
                l && i(t)
            })), t.attachEvent("onAfterTaskUpdate", e(function(t) {
                l && i(t)
            })), t.attachEvent("onBeforeTaskDelete", e(function(e, i) {
                return n = t.getParent(e), !0
            })), t.attachEvent("onAfterTaskDelete", e(function(t, e) {
                c(n)
            })), t.attachEvent("onRowDragStart", e(function(e, i, n) {
                return o = t.getParent(e), !0
            })), t.attachEvent("onRowDragEnd", e(function(t, e) {
                c(o), i(t)
            })), t.attachEvent("onBeforeTaskMove", e(function(e, i, n) {
                return s = t.getParent(e), !0
            })), t.attachEvent("onAfterTaskMove", e(function(t, e, n) {
                document.querySelector(".gantt_drag_marker") || (c(s), i(t))
            }))
        }
    }, function(t, e) {
        t.exports = function(t) {
            function e(e) {
                return function() {
                    return !t.config.placeholder_task || e.apply(this, arguments)
                }
            }

            function i() {
                var e = t.getTaskBy("type", t.config.types.placeholder);
                if (!e.length || !t.isTaskExists(e[0].id)) {
                    var i = {
                        unscheduled: !0,
                        type: t.config.types.placeholder,
                        duration: 0,
                        text: t.locale.labels.new_task
                    };
                    if (!1 === t.callEvent("onTaskCreated", [i])) return;
                    t.addTask(i)
                }
            }

            function n(e) {
                var i = t.getTask(e);
                i.type == t.config.types.placeholder && (i.start_date && i.end_date && i.unscheduled && (i.unscheduled = !1), t.batchUpdate(function() {
                    var e = t.copy(i);
                    t.silent(function() {
                        t.deleteTask(i.id)
                    }), delete e["!nativeeditor_status"], e.type = t.config.types.task, e.id = t.uid(), t.addTask(e)
                }))
            }
            t.config.types.placeholder = "placeholder", t.attachEvent("onDataProcessorReady", e(function(i) {
                i && !i._silencedPlaceholder && (i._silencedPlaceholder = !0, i.attachEvent("onBeforeUpdate", e(function(e, n, r) {
                    return r.type != t.config.types.placeholder || (i.setUpdated(e, !1), !1)
                })))
            }));
            var r = !1;
            t.attachEvent("onGanttReady", function() {
                r || (r = !0, t.attachEvent("onAfterTaskUpdate", e(n)), t.attachEvent("onAfterTaskAdd", e(function(e, n) {
                    n.type != t.config.types.placeholder && (t.getTaskBy("type", t.config.types.placeholder).forEach(function(e) {
                        t.silent(function() {
                            t.isTaskExists(e.id) && t.deleteTask(e.id)
                        })
                    }), i())
                })), t.attachEvent("onParse", e(i)))
            }), t.attachEvent("onBeforeUndoStack", function(e) {
                for (var i = 0; i < e.commands.length; i++) {
                    var n = e.commands[i];
                    "task" === n.entity && n.value.type === t.config.types.placeholder && (e.commands.splice(i, 1), i--)
                }
                return !0
            })
        }
    }, function(t, e, i) {
        var n = i(2),
            r = i(32);

        function a(t) {
            var e = {};

            function i(e, i) {
                return "function" == typeof e ? function(e) {
                    var i = [];
                    return t.eachTask(function(t) {
                        e(t) && i.push(t)
                    }), i
                }(e) : n.isArray(i) ? s(e, i) : s(e, [i])
            }
            t.$data.tasksStore.attachEvent("onStoreUpdated", function() {
                e = {}
            });
            var a = String(Math.random());

            function o(t) {
                return null === t ? a + String(t) : String(t)
            }

            function s(i, r) {
                var a, s = r.join("_") + "_" + i,
                    l = {};
                return n.forEach(r, function(t) {
                    l[o(t)] = !0
                }), e[s] ? a = e[s] : (a = e[s] = [], t.eachTask(function(e) {
                    var r;
                    e.type != t.config.types.project && (i in e && (r = n.isArray(e[i]) ? e[i] : [e[i]], n.forEach(r, function(t) {
                        (l[o(t)] || t && l[o(t.resource_id)]) && a.push(e)
                    })))
                })), a
            }

            function l(n, r, a, o) {
                var s = n.id + "_" + r + "_" + a.unit + "_" + a.step;
                return e[s] ? e[s] : e[s] = function(e, n, r, a) {
                    p = "task" == e.$role ? [] : i(n, e.id);
                    for (var o = r.unit, s = r.step, l = {}, c = 0; c < p.length; c++)
                        for (var u = p[c], d = t.date[o + "_start"](new Date(u.start_date)); d < u.end_date;) {
                            var h = d;
                            if (d = t.date.add(d, s, o), t.isWorkTime({
                                    date: h,
                                    task: u,
                                    unit: o
                                })) {
                                var f = h.valueOf();
                                l[f] || (l[f] = []), l[f].push(u)
                            }
                        }
                    for (var _, g, p, v = [], m = a.$getConfig(), c = 0; c < r.trace_x.length; c++) _ = new Date(r.trace_x[c]), g = t.date.add(_, s, o), ((p = l[_.valueOf()] || []).length || m.resource_render_empty_cells) && v.push({
                        start_date: _,
                        end_date: g,
                        tasks: p
                    });
                    return v
                }(n, r, a, o)
            }

            function c(t, e, i, n) {
                var r = 100 * (1 - (1 * t || 0)),
                    a = n.posFromDate(e),
                    o = n.posFromDate(i),
                    s = document.createElement("div");
                return s.className = "gantt_histogram_hor_bar", s.style.top = r + "%", s.style.left = a + "px", s.style.width = o - a + 1 + "px", s
            }

            function u(t, e, i) {
                if (t === e) return null;
                var n = 1 - Math.max(t, e),
                    r = Math.abs(t - e),
                    a = document.createElement("div");
                return a.className = "gantt_histogram_vert_bar", a.style.top = 100 * n + "%", a.style.height = 100 * r + "%", a.style.left = i + "px", a
            }

            function d(t, e, i) {
                var n = e.width[t],
                    r = e.left[t] - n,
                    a = e.left[t] + n;
                return n > 0 && r <= i.x_end && a >= i.x
            }

            function h(e, i, n) {
                var r = t.config.resource_property,
                    a = [];
                if (t.getDatastore("task").exists(i)) {
                    var o = t.getTask(i);
                    a = o[r] || []
                }
                Array.isArray(a) || (a = [a]);
                for (var s = 0; s < a.length; s++) a[s].resource_id == e && n.push({
                    task_id: o.id,
                    resource_id: a[s].resource_id,
                    value: a[s].value
                })
            }
            return {
                renderLine: function() {
                    var t = {};

                    function e(t, e, i, n, r) {
                        var a = i.resource_cell_class(e.start_date, e.end_date, t, e.tasks),
                            o = i.resource_cell_value(e.start_date, e.end_date, t, e.tasks);
                        if (a || o) {
                            var s = r.getItemPosition(t, e.start_date, e.end_date),
                                l = document.createElement("div");
                            return l.className = ["gantt_resource_marker", a].join(" "), l.style.cssText = ["left:" + s.left + "px", "width:" + s.width + "px", "height:" + (n.row_height - 1) + "px", "line-height:" + (n.row_height - 1) + "px", "top:" + s.top + "px"].join(";"), o && (l.innerHTML = o), l
                        }
                        return null
                    }

                    function i(e, i) {
                        t[e] && t[e][i] && t[e][i].parentNode && t[e][i].parentNode.removeChild(t[e][i])
                    }
                    return {
                        render: function(i, n, r) {
                            var a = n.$getConfig(),
                                o = n.$getTemplates(),
                                s = n.getScale(),
                                c = l(i, a.resource_property, n.getScale(), n),
                                u = [];
                            t[i.id] = {};
                            for (var h = 0; h < c.length; h++) {
                                var f = c[h],
                                    _ = s.trace_indexes[f.start_date.valueOf()];
                                if (d(_, s, r)) {
                                    var g = e(i, f, o, a, n);
                                    g && (u.push(g), t[i.id][_] = g)
                                }
                            }
                            var p = null;
                            if (u.length)
                                for (p = document.createElement("div"), h = 0; h < u.length; h++) p.appendChild(u[h]);
                            return p
                        },
                        update: function(n, r, a, o) {
                            for (var s = a.$getConfig(), c = a.$getTemplates(), u = a.getScale(), h = l(n, s.resource_property, a.getScale(), a), f = 0; f < h.length; f++) {
                                var _ = h[f],
                                    g = u.trace_indexes[_.start_date.valueOf()];
                                if (d(g, u, o))
                                    if (t[n.id] && t[n.id][g]) t[n.id] && t[n.id][g] && !t[n.id][g].parentNode && r.appendChild(t[n.id][g]);
                                    else {
                                        var p = e(n, _, c, s, a);
                                        p && (r.appendChild(p), t[n.id][g] = p)
                                    } else i(n.id, g)
                            }
                        },
                        getRectangle: r
                    }
                },
                renderHistogram: function() {
                    var e = {},
                        i = {},
                        n = {};

                    function a(t, i) {
                        var n = e[t];
                        n && n[i] && n[i].parentNode && n[i].parentNode.removeChild(n[i])
                    }

                    function o(e, i, r, a, o, s, l) {
                        var h = n[e.id];
                        h && h.parentNode && h.parentNode.removeChild(h);
                        var f = function(e, i, n, r) {
                            for (var a = i.getScale(), o = document.createElement("div"), s = !!r, l = 0; l < a.trace_x.length; l++)
                                if (!s || d(l, a, r)) {
                                    var h = a.trace_x[l],
                                        f = a.trace_x[l + 1] || t.date.add(h, a.step, a.unit),
                                        _ = a.trace_x[l].valueOf(),
                                        g = Math.min(e[_] / n, 1) || 0;
                                    if (g < 0) return null;
                                    var p = Math.min(e[f.valueOf()] / n, 1) || 0,
                                        v = c(g, h, f, i);
                                    v && o.appendChild(v);
                                    var m = u(g, p, i.posFromDate(f));
                                    m && o.appendChild(m)
                                }
                            return o
                        }(r, o, s, l);
                        return f && (f.setAttribute("data-resource-id", e.id), f.style.position = "absolute", f.style.top = i.top + 1 + "px", f.style.height = a.row_height - 1 + "px", f.style.left = 0), f
                    }

                    function s(t, e, i, n, r, a) {
                        var o = r.histogram_cell_class(a.start_date, a.end_date, t, a.tasks),
                            s = r.histogram_cell_label(a.start_date, a.end_date, t, a.tasks),
                            l = r.histogram_cell_allocated(a.start_date, a.end_date, t, a.tasks);
                        if (o || s) {
                            var c = document.createElement("div");
                            return c.className = ["gantt_histogram_cell", o].join(" "), c.style.cssText = ["left:" + e.left + "px", "width:" + e.width + "px", "height:" + (n.row_height - 1) + "px", "line-height:" + (n.row_height - 1) + "px", "top:" + (e.top + 1) + "px"].join(";"), s && (s = "<div class='gantt_histogram_label'>" + s + "</div>"), l && (s = "<div class='gantt_histogram_fill' style='height:" + 100 * Math.min(l / i || 0, 1) + "%;'></div>" + s), s && (c.innerHTML = s), c
                        }
                        return null
                    }
                    return {
                        render: function(t, r, a) {
                            var c = r.$getConfig(),
                                u = r.$getTemplates(),
                                h = r.getScale(),
                                f = l(t, c.resource_property, h, r),
                                _ = [],
                                g = {},
                                p = t.capacity || r.$config.capacity || 24;
                            e[t.id] = {}, i[t.id] = null, n[t.id] = null;
                            for (var v = !!a, m = 0; m < f.length; m++) {
                                var y = f[m],
                                    b = h.trace_indexes[y.start_date.valueOf()];
                                if (!v || d(b, h, a)) {
                                    var k = u.histogram_cell_capacity(y.start_date, y.end_date, t, y.tasks);
                                    g[y.start_date.valueOf()] = k || 0;
                                    var w = r.getItemPosition(t, y.start_date, y.end_date),
                                        x = s(t, w, p, c, u, y);
                                    x && (_.push(x), e[t.id][b] = x)
                                }
                            }
                            var $ = null;
                            if (_.length) {
                                for ($ = document.createElement("div"), m = 0; m < _.length; m++) $.appendChild(_[m]);
                                var S = o(t, w, g, c, r, p, a);
                                S && ($.appendChild(S), n[t.id] = S), i[t.id] = $
                            }
                            return $
                        },
                        update: function(t, i, r, c) {
                            for (var u = r.$getConfig(), h = r.$getTemplates(), f = r.getScale(), _ = l(t, u.resource_property, f, r), g = t.capacity || r.$config.capacity || 24, p = {}, v = !!c, m = 0; m < _.length; m++) {
                                var y = _[m],
                                    b = f.trace_indexes[y.start_date.valueOf()],
                                    k = h.histogram_cell_capacity(y.start_date, y.end_date, t, y.tasks);
                                p[y.start_date.valueOf()] = k || 0;
                                var w = r.getItemPosition(t, y.start_date, y.end_date);
                                if (!v || d(b, f, c)) {
                                    var x = e[t.id];
                                    if (x && x[b]) x && x[b] && !x[b].parentNode && i.appendChild(x[b]);
                                    else {
                                        var $ = s(t, w, g, u, h, y);
                                        $ && (i.appendChild($), e[t.id][b] = $)
                                    }
                                } else a(t.id, b)
                            }
                            var S = o(t, w, p, u, r, g, c);
                            S && (i.appendChild(S), n[t.id] = S)
                        },
                        getRectangle: r
                    }
                },
                filterTasks: i,
                getResourceAssignments: function(e, i) {
                    var n = [],
                        r = t.config.resource_property;
                    return void 0 !== i ? h(e, i, n) : t.getTaskBy(r, e).forEach(function(t) {
                        h(e, t.id, n)
                    }), n
                }
            }
        }
        t.exports = function(t) {
            var e = a(t);
            t.getTaskBy = e.filterTasks, t.getResourceAssignments = e.getResourceAssignments, t.$ui.layers.resourceRow = e.renderLine, t.$ui.layers.resourceHistogram = e.renderHistogram, t.config.resource_property = "owner_id", t.config.resource_store = "resource", t.config.resource_render_empty_cells = !1, t.templates.histogram_cell_class = function(t, e, i, n) {}, t.templates.histogram_cell_label = function(t, e, i, n) {
                return n.length + "/3"
            }, t.templates.histogram_cell_allocated = function(t, e, i, n) {
                return n.length / 3
            }, t.templates.histogram_cell_capacity = function(t, e, i, n) {
                return 0
            }, t.templates.resource_cell_class = function(t, e, i, n) {
                return n.length <= 1 ? "gantt_resource_marker_ok" : "gantt_resource_marker_overtime"
            }, t.templates.resource_cell_value = function(t, e, i, n) {
                return 8 * n.length
            }
        }
    }, function(t, e) {
        window.dhtmlx && (window.dhtmlx.attaches || (window.dhtmlx.attaches = {}), window.dhtmlx.attaches.attachGantt = function(t, e, i) {
            var n = document.createElement("DIV");
            i = i || window.gantt, n.id = "gantt_" + i.uid(), n.style.width = "100%", n.style.height = "100%", n.cmp = "grid", document.body.appendChild(n), this.attachObject(n.id), this.dataType = "gantt", this.dataObj = i;
            var r = this.vs[this.av];
            r.grid = i, i.init(n.id, t, e), n.firstChild.style.border = "none", r.gridId = n.id, r.gridObj = n;
            return this.vs[this._viewRestore()].grid
        }), void 0 !== window.dhtmlXCellObject && (window.dhtmlXCellObject.prototype.attachGantt = function(t, e, i) {
            i = i || window.gantt;
            var n = document.createElement("DIV");
            return n.id = "gantt_" + i.uid(), n.style.width = "100%", n.style.height = "100%", n.cmp = "grid", document.body.appendChild(n), this.attachObject(n.id), this.dataType = "gantt", this.dataObj = i, i.init(n.id, t, e), n.firstChild.style.border = "none", n = null, this.callEvent("_onContentAttach", []), this.dataObj
        }), t.exports = null
    }, function(t, e) {
        window.jQuery && function(t) {
            var e = [];
            t.fn.dhx_gantt = function(i) {
                if ("string" != typeof(i = i || {})) {
                    var n = [];
                    return this.each(function() {
                        if (this && this.getAttribute)
                            if (this.gantt || window.gantt.$root == this) n.push("object" == typeof this.gantt ? this.gantt : window.gantt);
                            else {
                                var t = window.gantt.$container && window.Gantt ? window.Gantt.getGanttInstance() : window.gantt;
                                for (var e in i) "data" != e && (t.config[e] = i[e]);
                                t.init(this), i.data && t.parse(i.data), n.push(t)
                            }
                    }), 1 === n.length ? n[0] : n
                }
                if (e[i]) return e[i].apply(this, []);
                t.error("Method " + i + " does not exist on jQuery.dhx_gantt")
            }
        }(window.jQuery), t.exports = null
    }, function(t, e) {
        t.exports = function(t) {
            var e = function(t) {
                return {
                    _needRecalc: !0,
                    reset: function() {
                        this._needRecalc = !0
                    },
                    _isRecalcNeeded: function() {
                        return !this._isGroupSort() && this._needRecalc
                    },
                    _isGroupSort: function() {
                        return !!t.getState().group_mode
                    },
                    _getWBSCode: function(t) {
                        return t ? (this._isRecalcNeeded() && this._calcWBS(), t.$virtual ? "" : this._isGroupSort() ? t.$wbs || "" : (t.$wbs || (this.reset(), this._calcWBS()), t.$wbs)) : ""
                    },
                    _setWBSCode: function(t, e) {
                        t.$wbs = e
                    },
                    getWBSCode: function(t) {
                        return this._getWBSCode(t)
                    },
                    getByWBSCode: function(e) {
                        for (var i = e.split("."), n = t.config.root_id, r = 0; r < i.length; r++) {
                            var a = t.getChildren(n),
                                o = 1 * i[r] - 1;
                            if (!t.isTaskExists(a[o])) return null;
                            n = a[o]
                        }
                        return t.isTaskExists(n) ? t.getTask(n) : null
                    },
                    _calcWBS: function() {
                        if (this._isRecalcNeeded()) {
                            var e = !0;
                            t.eachTask(function(i) {
                                if (e) return e = !1, void this._setWBSCode(i, "1");
                                var n = t.getPrevSibling(i.id);
                                if (null !== n) {
                                    var r = t.getTask(n).$wbs;
                                    r && ((r = r.split("."))[r.length - 1]++, this._setWBSCode(i, r.join(".")))
                                } else {
                                    var a = t.getParent(i.id);
                                    this._setWBSCode(i, t.getTask(a).$wbs + ".1")
                                }
                            }, t.config.root_id, this), this._needRecalc = !1
                        }
                    }
                }
            }(t);

            function i() {
                return e.reset(), !0
            }
            t.getWBSCode = function(t) {
                return e.getWBSCode(t)
            }, t.getTaskByWBSCode = function(t) {
                return e.getByWBSCode(t)
            }, t.attachEvent("onAfterTaskMove", i), t.attachEvent("onBeforeParse", i), t.attachEvent("onAfterTaskDelete", i), t.attachEvent("onAfterTaskAdd", i), t.attachEvent("onAfterSort", i)
        }
    }, function(t, e) {
        function i(t) {
            var e = {},
                i = !1;

            function n(t, i) {
                i = "function" == typeof i ? i : function() {}, e[t] || (e[t] = this[t], this[t] = i)
            }

            function r(t) {
                e[t] && (this[t] = e[t], e[t] = null)
            }

            function a() {
                for (var t in e) r.call(this, t)
            }

            function o(t) {
                try {
                    t()
                } catch (t) {
                    window.console.error(t)
                }
            }
            return t.$services.getService("state").registerProvider("batchUpdate", function() {
                    return {
                        batch_update: i
                    }
                }, !1),
                function(t, e) {
                    if (i) o(t);
                    else {
                        var r, s = this._dp && "off" != this._dp.updateMode;
                        s && (r = this._dp.updateMode, this._dp.setUpdateMode("off"));
                        var l = {},
                            c = {
                                render: !0,
                                refreshData: !0,
                                refreshTask: !0,
                                refreshLink: !0,
                                resetProjectDates: function(t) {
                                    l[t.id] = t
                                }
                            };
                        for (var u in function(t) {
                                for (var e in t) n.call(this, e, t[e])
                            }.call(this, c), i = !0, this.callEvent("onBeforeBatchUpdate", []), o(t), this.callEvent("onAfterBatchUpdate", []), a.call(this), l) this.resetProjectDates(l[u]);
                        i = !1, e || this.render(), s && (this._dp.setUpdateMode(r), this._dp.setGanttMode("task"), this._dp.sendData(), this._dp.setGanttMode("link"), this._dp.sendData())
                    }
                }
        }
        t.exports = function(t) {
            t.batchUpdate = i(t)
        }
    }, function(t, e, i) {
        var n = i(1);
        t.exports = function(t) {
            var e = 50,
                i = 30,
                r = 10,
                a = 50,
                o = null,
                s = !1,
                l = null,
                c = {
                    started: !1
                },
                u = {};

            function d(e) {
                return e && n.isChildOf(e, t.$root) && e.offsetHeight
            }

            function h() {
                var e = !!document.querySelector(".gantt_drag_marker"),
                    i = !!document.querySelector(".gantt_drag_marker.gantt_grid_resize_area"),
                    n = !!document.querySelector(".gantt_link_direction"),
                    r = t.getState(),
                    a = r.autoscroll;
                return s = e && !i && !n, !(!r.drag_mode && !e || i) || a
            }

            function f(e) {
                if (l && (clearTimeout(l), l = null), e) {
                    var i = t.config.autoscroll_speed;
                    i && i < 10 && (i = 10), l = setTimeout(function() {
                        o = setInterval(p, i || a)
                    }, t.config.autoscroll_delay || r)
                }
            }

            function _(t) {
                t ? (f(!0), c.started || (c.x = u.x, c.y = u.y, c.started = !0)) : (o && (clearInterval(o), o = null), f(!1), c.started = !1)
            }

            function g(e) {
                var i = h();
                if (!o && !l || i || _(!1), !t.config.autoscroll || !i) return !1;
                u = {
                    x: e.clientX,
                    y: e.clientY
                }, !o && i && _(!0)
            }

            function p() {
                if (!h()) return _(!1), !1;
                var e = n.getNodePosition(d(t.$task) ? t.$task : d(t.$grid) ? t.$grid : t.$root),
                    r = u.x - e.x,
                    a = u.y - e.y,
                    o = s ? 0 : v(r, e.width, c.x - e.x),
                    l = v(a, e.height, c.y - e.y),
                    f = t.getScrollState(),
                    g = f.y,
                    p = f.inner_height,
                    m = f.height,
                    y = f.x,
                    b = f.inner_width,
                    k = f.width;
                l && !p ? l = 0 : l < 0 && !g ? l = 0 : l > 0 && g + p >= m + 2 && (l = 0), o && !b ? o = 0 : o < 0 && !y ? o = 0 : o > 0 && y + b >= k && (o = 0);
                var w = t.config.autoscroll_step;
                w && w < 2 && (w = 2), o *= w || i, l *= w || i, (o || l) && function(e, i) {
                    var n = t.getScrollState(),
                        r = null,
                        a = null;
                    e && (r = n.x + e, r = Math.min(n.width, r), r = Math.max(0, r));
                    i && (a = n.y + i, a = Math.min(n.height, a), a = Math.max(0, a));
                    t.scrollTo(r, a)
                }(o, l)
            }

            function v(t, i, n) {
                return t - e < 0 && t < n ? -1 : t > i - e && t > n ? 1 : 0
            }
            t.attachEvent("onGanttReady", function() {
                t.eventRemove(document.body, "mousemove", g), t.event(document.body, "mousemove", g)
            })
        }
    }, function(t, e, i) {
        t.exports = function(t) {
            t.ext || (t.ext = {});
            for (var e = [i(101), i(100), i(99), i(98), i(97), i(96), i(95), i(94), i(93)], n = 0; n < e.length; n++) e[n] && e[n](t);
            var r = i(90).default;
            t.ext.zoom = new r(t)
        }
    }, function(t, e, i) {
        "use strict";
        Object.defineProperty(e, "__esModule", {
            value: !0
        });
        var n = i(0),
            r = function() {
                function t() {
                    var t = this;
                    this.clear = function() {
                        t._storage = {}
                    }, this.storeItem = function(e) {
                        t._storage[e.id] = n.copy(e)
                    }, this.getStoredItem = function(e) {
                        return t._storage[e] || null
                    }, this._storage = {}
                }
                return t.create = function() {
                    return new t
                }, t
            }();
        e.default = r
    }, function(t, e, i) {
        "use strict";
        Object.defineProperty(e, "__esModule", {
            value: !0
        }), e.default = function(t, e) {
            t.getUserData = function(t, e) {
                return this.userdata || (this.userdata = {}), this.userdata[t] && this.userdata[t][e] ? this.userdata[t][e] : ""
            }, t.setUserData = function(t, e, i) {
                this.userdata || (this.userdata = {}), this.userdata[t] || (this.userdata[t] = {}), this.userdata[t][e] = i
            }, t._change_id = function(t, e) {
                "task" !== this._dp._ganttMode ? this.changeLinkId(t, e) : this.changeTaskId(t, e)
            }, t._row_style = function(e, i) {
                "task" === this._dp._ganttMode && t.isTaskExists(e) && (t.getTask(e).$dataprocessor_class = i, t.refreshTask(e))
            }, t._delete_task = function(t, e) {}, t._sendTaskOrder = function(t, e) {
                e.$drop_target && (this._dp.setGanttMode("task"), this.getTask(t).target = e.$drop_target, this._dp.setUpdated(t, !0, "order"), delete this.getTask(t).$drop_target)
            }, t.setDp = function() {
                this._dp = e
            }, t.setDp()
        }
    }, function(t, e, i) {
        "use strict";
        Object.defineProperty(e, "__esModule", {
            value: !0
        });
        var n = i(2),
            r = function() {
                function t(t, e) {
                    this.$gantt = t, this.$dp = e, this._dataProcessorHandlers = []
                }
                return t.prototype.attach = function() {
                    var t = this.$dp,
                        e = this.$gantt,
                        n = i(27),
                        r = {};

                    function a(i) {
                        for (var n = t.updatedRows.slice(), r = !1, a = 0; a < n.length && !t._in_progress[i]; a++) n[a] === i && ("inserted" === e.getUserData(i, "!nativeeditor_status") && (r = !0), t.setUpdated(i, !1));
                        return r
                    }
                    this._dataProcessorHandlers.push(e.attachEvent("onAfterTaskAdd", function(i, n) {
                        e.isTaskExists(i) && (t.setGanttMode("tasks"), t.setUpdated(i, !0, "inserted"))
                    })), this._dataProcessorHandlers.push(e.attachEvent("onAfterTaskUpdate", function(i, n) {
                        e.isTaskExists(i) && (t.setGanttMode("tasks"), t.setUpdated(i, !0), e._sendTaskOrder && e._sendTaskOrder(i, n))
                    })), this._dataProcessorHandlers.push(e.attachEvent("onBeforeTaskDelete", function(t, i) {
                        return !e.config.cascade_delete || (r[t] = {
                            tasks: n.getSubtreeTasks(e, t),
                            links: n.getSubtreeLinks(e, t)
                        }, !0)
                    })), this._dataProcessorHandlers.push(e.attachEvent("onAfterTaskDelete", function(i, n) {
                        if (t.setGanttMode("tasks"), !a(i)) {
                            if (e.config.cascade_delete && r[i]) {
                                var o = t.updateMode;
                                t.setUpdateMode("off");
                                var s = r[i];
                                for (var l in s.tasks) a(l) || (t.storeItem(s.tasks[l]), t.setUpdated(l, !0, "deleted"));
                                for (var l in t.setGanttMode("links"), s.links) a(l) || (t.storeItem(s.links[l]), t.setUpdated(l, !0, "deleted"));
                                r[i] = null, "off" !== o && t.sendAllData(), t.setGanttMode("tasks"), t.setUpdateMode(o)
                            }
                            t.storeItem(n), t.setUpdated(i, !0, "deleted"), "off" === t.updateMode || t._tSend || t.sendAllData()
                        }
                    })), this._dataProcessorHandlers.push(e.attachEvent("onAfterLinkUpdate", function(i, n) {
                        e.isLinkExists(i) && (t.setGanttMode("links"), t.setUpdated(i, !0))
                    })), this._dataProcessorHandlers.push(e.attachEvent("onAfterLinkAdd", function(i, n) {
                        e.isLinkExists(i) && (t.setGanttMode("links"), t.setUpdated(i, !0, "inserted"))
                    })), this._dataProcessorHandlers.push(e.attachEvent("onAfterLinkDelete", function(e, i) {
                        t.setGanttMode("links"), !a(e) && (t.storeItem(i), t.setUpdated(e, !0, "deleted"))
                    })), this._dataProcessorHandlers.push(e.attachEvent("onRowDragEnd", function(t, i) {
                        e._sendTaskOrder(t, e.getTask(t))
                    }));
                    var o = null,
                        s = null;
                    this._dataProcessorHandlers.push(e.attachEvent("onTaskIdChange", function(i, n) {
                        if (t._waitMode) {
                            var r = e.getChildren(n);
                            if (r.length) {
                                o = o || {};
                                for (var a = 0; a < r.length; a++) {
                                    var l = this.getTask(r[a]);
                                    o[l.id] = l
                                }
                            }
                            var c = function(t) {
                                var e = [];
                                return t.$source && (e = e.concat(t.$source)), t.$target && (e = e.concat(t.$target)), e
                            }(this.getTask(n));
                            if (c.length) {
                                s = s || {};
                                for (a = 0; a < c.length; a++) {
                                    var u = this.getLink(c[a]);
                                    s[u.id] = u
                                }
                            }
                        }
                    })), t.attachEvent("onAfterUpdateFinish", function() {
                        (o || s) && (e.batchUpdate(function() {
                            for (var t in o) e.updateTask(o[t].id);
                            for (var t in s) e.updateLink(s[t].id);
                            o = null, s = null
                        }), o ? e._dp.setGanttMode("tasks") : e._dp.setGanttMode("links"))
                    }), t.attachEvent("onBeforeDataSending", function() {
                        if ("CUSTOM" === this._tMode) return !0;
                        var t = this._serverProcessor;
                        if ("REST-JSON" === this._tMode || "REST" === this._tMode) {
                            var i = this._ganttMode;
                            t = t.substring(0, t.indexOf("?") > -1 ? t.indexOf("?") : t.length), this.serverProcessor = t + ("/" === t.slice(-1) ? "" : "/") + i
                        } else {
                            var n = this._ganttMode + "s";
                            this.serverProcessor = t + e.ajax.urlSeparator(t) + "gantt_mode=" + n
                        }
                        return !0
                    }), t.attachEvent("insertCallback", function(t, i, n, r) {
                        var a = t.data || e.xml._xmlNodeToJSON(t.firstChild),
                            o = {
                                add: e.addTask,
                                isExist: e.isTaskExists
                            };
                        "links" === r && (o.add = e.addLink, o.isExist = e.isLinkExists), o.isExist.call(e, i) || (a.id = i, o.add.call(e, a))
                    }), t.attachEvent("updateCallback", function(t, i) {
                        var n = t.data || e.xml._xmlNodeToJSON(t.firstChild);
                        if (e.isTaskExists(i)) {
                            var r = e.getTask(i);
                            for (var a in n) {
                                var o = n[a];
                                switch (a) {
                                    case "id":
                                        continue;
                                    case "start_date":
                                    case "end_date":
                                        o = e.templates.xml_date !== e.templates.parse_date ? e.templates.xml_date(o) : e.templates.parse_date(o);
                                        break;
                                    case "duration":
                                        r.end_date = e.calculateEndDate({
                                            start_date: r.start_date,
                                            duration: o,
                                            task: r
                                        })
                                }
                                r[a] = o
                            }
                            e.updateTask(i), e.refreshData()
                        }
                    }), t.attachEvent("deleteCallback", function(t, i, n, r) {
                        var a = {
                            delete: e.deleteTask,
                            isExist: e.isTaskExists
                        };
                        "links" === r && (a.delete = e.deleteLink, a.isExist = e.isLinkExists), a.isExist.call(e, i) && a.delete.call(e, i)
                    })
                }, t.prototype.detach = function() {
                    var t = this;
                    n.forEach(this._dataProcessorHandlers, function(e) {
                        t.$gantt.detachEvent(e)
                    }), this._dataProcessorHandlers = []
                }, t
            }();
        e.default = r
    }, function(t, e, i) {
        "use strict";
        Object.defineProperty(e, "__esModule", {
            value: !0
        });
        var n = i(4),
            r = i(2),
            a = i(0),
            o = i(105),
            s = i(104),
            l = i(103);
        e.createDataProcessor = function(t) {
            var e, i;
            t instanceof Function ? e = t : t.hasOwnProperty("router") ? e = t.router : t.hasOwnProperty("link") && t.hasOwnProperty("task") && (e = t), i = e ? "CUSTOM" : t.mode || "REST-JSON";
            var n = new c(t.url);
            return n.init(this), n.setTransactionMode({
                mode: i,
                router: e
            }, t.batchUpdate), n
        };
        var c = function() {
            function t(t) {
                this.serverProcessor = t, this.action_param = "!nativeeditor_status", this.object = null, this.updatedRows = [], this.autoUpdate = !0, this.updateMode = "cell", this._headers = null, this._payload = null, this._postDelim = "_", this._waitMode = 0, this._in_progress = {}, this._storage = l.default.create(), this._invalid = {}, this.messages = [], this.styles = {
                    updated: "font-weight:bold;",
                    inserted: "font-weight:bold;",
                    deleted: "text-decoration : line-through;",
                    invalid: "background-color:FFE0E0;",
                    invalid_cell: "border-bottom:2px solid red;",
                    error: "color:red;",
                    clear: "font-weight:normal;text-decoration:none;"
                }, this.enableUTFencoding(!0), n(this)
            }
            return t.prototype.setTransactionMode = function(t, e) {
                "object" == typeof t ? (this._tMode = t.mode || this._tMode, a.defined(t.headers) && (this._headers = t.headers), a.defined(t.payload) && (this._payload = t.payload)) : (this._tMode = t, this._tSend = e), "REST" === this._tMode && (this._tSend = !1, this._endnm = !0), "JSON" !== this._tMode && "REST-JSON" !== this._tMode || (this._tSend = !1, this._endnm = !0, this._serializeAsJson = !0, this._headers = this._headers || {}, this._headers["Content-type"] = "application/json"), "CUSTOM" === this._tMode && (this._tSend = !1, this._endnm = !0, this._router = t.router)
            }, t.prototype.escape = function(t) {
                return this._utf ? encodeURIComponent(t) : escape(t)
            }, t.prototype.enableUTFencoding = function(t) {
                this._utf = !!t
            }, t.prototype.setDataColumns = function(t) {
                this._columns = "string" == typeof t ? t.split(",") : t
            }, t.prototype.getSyncState = function() {
                return !this.updatedRows.length
            }, t.prototype.enableDataNames = function(t) {
                this._endnm = !!t
            }, t.prototype.enablePartialDataSend = function(t) {
                this._changed = !!t
            }, t.prototype.setUpdateMode = function(t, e) {
                this.autoUpdate = "cell" === t, this.updateMode = t, this.dnd = e
            }, t.prototype.ignore = function(t, e) {
                this._silent_mode = !0, t.call(e || window), this._silent_mode = !1
            }, t.prototype.setUpdated = function(t, e, i) {
                if (!this._silent_mode) {
                    var n = this.findRow(t);
                    i = i || "updated";
                    var r = this.$gantt.getUserData(t, this.action_param);
                    r && "updated" === i && (i = r), e ? (this.set_invalid(t, !1), this.updatedRows[n] = t, this.$gantt.setUserData(t, this.action_param, i), this._in_progress[t] && (this._in_progress[t] = "wait")) : this.is_invalid(t) || (this.updatedRows.splice(n, 1), this.$gantt.setUserData(t, this.action_param, "")), this.markRow(t, e, i), e && this.autoUpdate && this.sendData(t)
                }
            }, t.prototype.markRow = function(t, e, i) {
                var n = "",
                    r = this.is_invalid(t);
                if (r && (n = this.styles[r], e = !0), this.callEvent("onRowMark", [t, e, i, r]) && (n = this.styles[e ? i : "clear"] + n, this.$gantt[this._methods[0]](t, n), r && r.details)) {
                    n += this.styles[r + "_cell"];
                    for (var a = 0; a < r.details.length; a++) r.details[a] && this.$gantt[this._methods[1]](t, a, n)
                }
            }, t.prototype.getActionByState = function(t) {
                return "inserted" === t ? "create" : "updated" === t ? "update" : "deleted" === t ? "delete" : "update"
            }, t.prototype.getState = function(t) {
                return this.$gantt.getUserData(t, this.action_param)
            }, t.prototype.is_invalid = function(t) {
                return this._invalid[t]
            }, t.prototype.set_invalid = function(t, e, i) {
                i && (e = {
                    value: e,
                    details: i,
                    toString: function() {
                        return this.value.toString()
                    }
                }), this._invalid[t] = e
            }, t.prototype.checkBeforeUpdate = function(t) {
                return !0
            }, t.prototype.sendData = function(t) {
                return this.$gantt.editStop && this.$gantt.editStop(), void 0 === t || this._tSend ? this.sendAllData() : !this._in_progress[t] && (this.messages = [], !(!this.checkBeforeUpdate(t) && this.callEvent("onValidationError", [t, this.messages])) && void this._beforeSendData(this._getRowData(t), t))
            }, t.prototype.serialize = function(t, e) {
                if (this._serializeAsJson) return this._serializeAsJSON(t);
                if ("string" == typeof t) return t;
                if (void 0 !== e) return this.serialize_one(t, "");
                var i = [],
                    n = [];
                for (var r in t) t.hasOwnProperty(r) && (i.push(this.serialize_one(t[r], r + this._postDelim)), n.push(r));
                return i.push("ids=" + this.escape(n.join(","))), this.$gantt.security_key && i.push("dhx_security=" + this.$gantt.security_key), i.join("&")
            }, t.prototype.serialize_one = function(t, e) {
                if ("string" == typeof t) return t;
                var i = [],
                    n = "";
                for (var r in t)
                    if (t.hasOwnProperty(r)) {
                        if (("id" === r || r == this.action_param) && "REST" === this._tMode) continue;
                        n = "string" == typeof t[r] || "number" == typeof t[r] ? t[r] : JSON.stringify(t[r]), i.push(this.escape((e || "") + r) + "=" + this.escape(n))
                    }
                return i.join("&")
            }, t.prototype.sendAllData = function() {
                if (this.updatedRows.length) {
                    this.messages = [];
                    var t = !0;
                    if (this._forEachUpdatedRow(function(e) {
                            t = t && this.checkBeforeUpdate(e)
                        }), !t && !this.callEvent("onValidationError", ["", this.messages])) return !1;
                    this._tSend ? this._sendData(this._getAllData()) : this._forEachUpdatedRow(function(t) {
                        if (!this._in_progress[t]) {
                            if (this.is_invalid(t)) return;
                            this._beforeSendData(this._getRowData(t), t)
                        }
                    })
                }
            }, t.prototype.findRow = function(t) {
                var e = 0;
                for (e = 0; e < this.updatedRows.length && t != this.updatedRows[e]; e++);
                return e
            }, t.prototype.defineAction = function(t, e) {
                this._uActions || (this._uActions = {}), this._uActions[t] = e
            }, t.prototype.afterUpdateCallback = function(t, e, i, n, r) {
                if (this.$gantt) {
                    this.setGanttMode(r);
                    var a = t,
                        o = "error" !== i && "invalid" !== i;
                    if (o || this.set_invalid(t, i), this._uActions && this._uActions[i] && !this._uActions[i](n)) return delete this._in_progress[a];
                    "wait" !== this._in_progress[a] && this.setUpdated(t, !1);
                    var s = t;
                    switch (i) {
                        case "inserted":
                        case "insert":
                            e != t && (this.setUpdated(t, !1), this.$gantt[this._methods[2]](t, e), t = e);
                            break;
                        case "delete":
                        case "deleted":
                            return this.$gantt.setUserData(t, this.action_param, "true_deleted"), this.$gantt[this._methods[3]](t), delete this._in_progress[a], this.callEvent("onAfterUpdate", [t, i, e, n])
                    }
                    "wait" !== this._in_progress[a] ? (o && this.$gantt.setUserData(t, this.action_param, ""), delete this._in_progress[a]) : (delete this._in_progress[a], this.setUpdated(e, !0, this.$gantt.getUserData(t, this.action_param))), this.callEvent("onAfterUpdate", [s, i, e, n])
                }
            }, t.prototype.afterUpdate = function(t, e, i) {
                var n;
                n = 3 === arguments.length ? arguments[1] : arguments[4];
                var r = this.getGanttMode(),
                    a = n.filePath || n.url;
                r = "REST" !== this._tMode && "REST-JSON" !== this._tMode ? -1 !== a.indexOf("gantt_mode=links") ? "link" : "task" : a.indexOf("/link") > a.indexOf("/task") ? "link" : "task", this.setGanttMode(r);
                var o = this.$gantt.ajax;
                if (window.JSON) {
                    var s = void 0;
                    try {
                        s = JSON.parse(e.xmlDoc.responseText)
                    } catch (t) {
                        e.xmlDoc.responseText.length || (s = {})
                    }
                    if (s) {
                        var l = s.action || this.getState(i) || "updated",
                            c = s.sid || i[0],
                            u = s.tid || i[0];
                        return t.afterUpdateCallback(c, u, l, s, r), t.finalizeUpdate(), void this.setGanttMode(r)
                    }
                }
                var d = o.xmltop("data", e.xmlDoc);
                if (!d) return this.cleanUpdate(i);
                var h = o.xpath("//data/action", d);
                if (!h.length) return this.cleanUpdate(i);
                for (var f = 0; f < h.length; f++) {
                    var _ = h[f];
                    l = _.getAttribute("type"), c = _.getAttribute("sid"), u = _.getAttribute("tid");
                    t.afterUpdateCallback(c, u, l, _, r)
                }
                t.finalizeUpdate()
            }, t.prototype.cleanUpdate = function(t) {
                if (t)
                    for (var e = 0; e < t.length; e++) delete this._in_progress[t[e]]
            }, t.prototype.finalizeUpdate = function() {
                this._waitMode && this._waitMode--, this.callEvent("onAfterUpdateFinish", []), this.updatedRows.length || this.callEvent("onFullSync", [])
            }, t.prototype.init = function(t) {
                if (!this._initialized) {
                    this.$gantt = t, this.$gantt._dp_init && this.$gantt._dp_init(this), this._setDefaultTransactionMode(), this.styles = {
                        updated: "gantt_updated",
                        order: "gantt_updated",
                        inserted: "gantt_inserted",
                        deleted: "gantt_deleted",
                        invalid: "gantt_invalid",
                        error: "gantt_error",
                        clear: ""
                    }, this._methods = ["_row_style", "setCellTextStyle", "_change_id", "_delete_task"], s.default(this.$gantt, this);
                    var e = new o.default(this.$gantt, this);
                    e.attach(), this.attachEvent("onDestroy", function() {
                        delete this.setGanttMode, delete this._getRowData, delete this.$gantt._dp, delete this.$gantt._change_id, delete this.$gantt._row_style, delete this.$gantt._delete_task, delete this.$gantt._sendTaskOrder, delete this.$gantt, e.detach()
                    }), this.$gantt.callEvent("onDataProcessorReady", [this]), this._initialized = !0
                }
            }, t.prototype.setOnAfterUpdate = function(t) {
                this.attachEvent("onAfterUpdate", t)
            }, t.prototype.setOnBeforeUpdateHandler = function(t) {
                this.attachEvent("onBeforeDataSending", t)
            }, t.prototype.setAutoUpdate = function(t, e) {
                var i = this;
                t = t || 2e3, this._user = e || (new Date).valueOf(), this._needUpdate = !1, this._updateBusy = !1, this.attachEvent("onAfterUpdate", this.afterAutoUpdate), this.attachEvent("onFullSync", this.fullSync), window.setInterval(function() {
                    i.loadUpdate()
                }, t)
            }, t.prototype.afterAutoUpdate = function(t, e, i, n) {
                return "collision" !== e || (this._needUpdate = !0, !1)
            }, t.prototype.fullSync = function() {
                return this._needUpdate && (this._needUpdate = !1, this.loadUpdate()), !0
            }, t.prototype.getUpdates = function(t, e) {
                var i = this.$gantt.ajax;
                if (this._updateBusy) return !1;
                this._updateBusy = !0, i.get(t, e)
            }, t.prototype.loadUpdate = function() {
                var t = this,
                    e = this.$gantt.ajax,
                    i = this.$gantt.getUserData(0, "version"),
                    n = this.serverProcessor + e.urlSeparator(this.serverProcessor) + ["dhx_user=" + this._user, "dhx_version=" + i].join("&");
                n = n.replace("editing=true&", ""), this.getUpdates(n, function(i) {
                    var n = e.xpath("//userdata", i);
                    t.obj.setUserData(0, "version", t._getXmlNodeValue(n[0]));
                    var r = e.xpath("//update", i);
                    if (r.length) {
                        t._silent_mode = !0;
                        for (var a = 0; a < r.length; a++) {
                            var o = r[a].getAttribute("status"),
                                s = r[a].getAttribute("id"),
                                l = r[a].getAttribute("parent");
                            switch (o) {
                                case "inserted":
                                    t.callEvent("insertCallback", [r[a], s, l]);
                                    break;
                                case "updated":
                                    t.callEvent("updateCallback", [r[a], s, l]);
                                    break;
                                case "deleted":
                                    t.callEvent("deleteCallback", [r[a], s, l])
                            }
                        }
                        t._silent_mode = !1
                    }
                    t._updateBusy = !1
                })
            }, t.prototype.destructor = function() {
                this.callEvent("onDestroy", []), this.detachAllEvents(), this.updatedRows = [], this._in_progress = {}, this._invalid = {}, this._storage.clear(), this._storage = null, this._headers = null, this._payload = null, delete this._initialized
            }, t.prototype.setGanttMode = function(t) {
                "tasks" === t ? t = "task" : "links" === t && (t = "link");
                var e = this.modes || {},
                    i = this.getGanttMode();
                i && (e[i] = {
                    _in_progress: this._in_progress,
                    _invalid: this._invalid,
                    _storage: this._storage,
                    updatedRows: this.updatedRows
                });
                var n = e[t];
                n || (n = e[t] = {
                    _in_progress: {},
                    _invalid: {},
                    _storage: l.default.create(),
                    updatedRows: []
                }), this._in_progress = n._in_progress, this._invalid = n._invalid, this._storage = n._storage, this.updatedRows = n.updatedRows, this.modes = e, this._ganttMode = t
            }, t.prototype.getGanttMode = function() {
                return this._ganttMode
            }, t.prototype.storeItem = function(t) {
                this._storage.storeItem(t)
            }, t.prototype._beforeSendData = function(t, e) {
                if (!this.callEvent("onBeforeUpdate", [e, this.getState(e), t])) return !1;
                this._sendData(t, e)
            }, t.prototype._serializeAsJSON = function(t) {
                if ("string" == typeof t) return t;
                var e = a.copy(t);
                return "REST-JSON" === this._tMode && (delete e.id, delete e[this.action_param]), JSON.stringify(e)
            }, t.prototype._applyPayload = function(t) {
                var e = this.$gantt.ajax;
                if (this._payload)
                    for (var i in this._payload) t = t + e.urlSeparator(t) + this.escape(i) + "=" + this.escape(this._payload[i]);
                return t
            }, t.prototype._cleanupArgumentsBeforeSend = function(t) {
                var e;
                if (void 0 === t[this.action_param])
                    for (var i in e = {}, t) e[i] = this._cleanupArgumentsBeforeSend(t[i]);
                else e = this._cleanupItemBeforeSend(t);
                return e
            }, t.prototype._cleanupItemBeforeSend = function(t) {
                var e = null;
                return t && ("deleted" === t[this.action_param] ? ((e = {}).id = t.id, e[this.action_param] = t[this.action_param]) : e = t), e
            }, t.prototype._sendData = function(t, e) {
                var i = this;
                if (t) {
                    if (!this.callEvent("onBeforeDataSending", e ? [e, this.getState(e), t] : [null, null, t])) return !1;
                    e && (this._in_progress[e] = (new Date).valueOf());
                    var n = this.$gantt.ajax;
                    if ("CUSTOM" !== this._tMode) {
                        var r;
                        r = {
                            callback: function(n) {
                                var r = [];
                                if (e) r.push(e);
                                else if (t)
                                    for (var a in t) r.push(a);
                                return i.afterUpdate(i, n, r)
                            },
                            headers: this._headers
                        };
                        var a, o = this.serverProcessor + (this._user ? n.urlSeparator(this.serverProcessor) + ["dhx_user=" + this._user, "dhx_version=" + this.$gantt.getUserData(0, "version")].join("&") : ""),
                            s = this._applyPayload(o);
                        switch (this._tMode) {
                            case "GET":
                                a = this._cleanupArgumentsBeforeSend(t), r.url = s + n.urlSeparator(s) + this.serialize(a, e), r.method = "GET";
                                break;
                            case "POST":
                                a = this._cleanupArgumentsBeforeSend(t), r.url = s, r.method = "POST", r.data = this.serialize(a, e);
                                break;
                            case "JSON":
                                a = {};
                                var l = this._cleanupItemBeforeSend(t);
                                for (var c in l) c !== this.action_param && "id" !== c && "gr_id" !== c && (a[c] = l[c]);
                                r.url = s, r.method = "POST", r.data = JSON.stringify({
                                    id: e,
                                    action: t[this.action_param],
                                    data: a
                                });
                                break;
                            case "REST":
                            case "REST-JSON":
                                switch (s = o.replace(/(&|\?)editing=true/, ""), a = "", this.getState(e)) {
                                    case "inserted":
                                        r.method = "POST", r.data = this.serialize(t, e);
                                        break;
                                    case "deleted":
                                        r.method = "DELETE", s = s + ("/" === s.slice(-1) ? "" : "/") + e;
                                        break;
                                    default:
                                        r.method = "PUT", r.data = this.serialize(t, e), s = s + ("/" === s.slice(-1) ? "" : "/") + e
                                }
                                r.url = this._applyPayload(s)
                        }
                        return this._waitMode++, n.query(r)
                    }
                    var u = this.getState(e),
                        d = this.getActionByState(u),
                        h = this.getGanttMode(),
                        f = function(t) {
                            var n = u || "updated",
                                r = e,
                                a = e;
                            t && (n = t.action || u, r = t.sid || r, a = t.id || t.tid || a), i.afterUpdateCallback(r, a, n, t, h)
                        },
                        _ = void 0;
                    if (this._router instanceof Function) _ = this._router(h, d, t, e);
                    else if (this._router[h] instanceof Function) _ = this._router[h](d, t, e);
                    else switch (u) {
                        case "inserted":
                            _ = this._router[h].create(t);
                            break;
                        case "deleted":
                            _ = this._router[h].delete(e);
                            break;
                        default:
                            _ = this._router[h].update(t, e)
                    }
                    if (_) {
                        if (!_.then && void 0 === _.id && void 0 === _.tid) throw new Error("Incorrect router return value. A Promise or a response object is expected");
                        _.then ? _.then(f) : f(_)
                    } else f(null)
                }
            }, t.prototype._forEachUpdatedRow = function(t) {
                for (var e = this.updatedRows.slice(), i = 0; i < e.length; i++) {
                    var n = e[i];
                    this.$gantt.getUserData(n, this.action_param) && t.call(this, n)
                }
            }, t.prototype._setDefaultTransactionMode = function() {
                this.serverProcessor && (this.setTransactionMode("POST", !0), this.serverProcessor += (-1 !== this.serverProcessor.indexOf("?") ? "&" : "?") + "editing=true", this._serverProcessor = this.serverProcessor)
            }, t.prototype._getXmlNodeValue = function(t) {
                return t.firstChild ? t.firstChild.nodeValue : ""
            }, t.prototype._getAllData = function() {
                var t = {},
                    e = !1;
                return this._forEachUpdatedRow(function(i) {
                    if (!this._in_progress[i] && !this.is_invalid(i)) {
                        var n = this._getRowData(i);
                        this.callEvent("onBeforeUpdate", [i, this.getState(i), n]) && (t[i] = n, e = !0, this._in_progress[i] = (new Date).valueOf())
                    }
                }), e ? t : null
            }, t.prototype._prepareDataItem = function(t) {
                var e = {};
                for (var i in t)
                    if ("$" !== i.substr(0, 1)) {
                        var n = t[i];
                        r.isDate(n) ? e[i] = this.$gantt.templates.xml_format !== this.$gantt.templates.format_date ? this.$gantt.templates.xml_format(n) : this.$gantt.templates.format_date(n) : e[i] = null === n ? "" : n
                    }
                return e[this.action_param] = this.$gantt.getUserData(t.id, this.action_param), e
            }, t.prototype.getStoredItem = function(t) {
                return this._storage.getStoredItem(t)
            }, t.prototype._getRowData = function(t) {
                var e, i = this.$gantt;
                return "task" === this.getGanttMode() ? i.isTaskExists(t) && (e = this.$gantt.getTask(t)) : i.isLinkExists(t) && (e = this.$gantt.getLink(t)), e || (e = this.getStoredItem(t)), e || (e = {
                    id: t
                }), this._prepareDataItem(e)
            }, t
        }();
        e.DataProcessor = c
    }, function(t, e, i) {
        var n = i(106);
        t.exports = {
            DEPRECATED_api: function(t) {
                return new n.DataProcessor(t)
            },
            createDataProcessor: n.createDataProcessor,
            getDataProcessorModes: n.getAvailableModes
        }
    }, function(t, e) {
        t.exports = {
            bindDataStore: function(t, e) {
                var i = e.getDatastore(t),
                    n = function(t, e) {
                        var n = e.getLayers(),
                            r = i.getItem(t);
                        if (r && i.isVisible(t))
                            for (var a = 0; a < n.length; a++) n[a].render_item(r)
                    },
                    r = function(t) {
                        for (var e = t.getLayers(), n = 0; n < e.length; n++) e[n].clear();
                        var r = i.getVisibleItems();
                        for (n = 0; n < e.length; n++) e[n].render_items(r)
                    },
                    a = function(t) {
                        if (t.update_items) {
                            var e = i.getVisibleItems();
                            t.update_items(e)
                        }
                    };

                function o(t) {
                    return !!t.$services.getService("state").getState("batchUpdate").batch_update
                }
                i.attachEvent("onStoreUpdated", function(i, n, r) {
                    var o = e.$services.getService("layers").getDataRender(t);
                    o && (o.onUpdateRequest = function(t) {
                        a(t)
                    })
                }), i.attachEvent("onStoreUpdated", function(a, s, l) {
                    if (!o(e)) {
                        var c = e.$services.getService("layers").getDataRender(t);
                        c && (a && "move" != l && "delete" != l ? (i.callEvent("onBeforeRefreshItem", [s.id]), n(s.id, c), i.callEvent("onAfterRefreshItem", [s.id])) : (i.callEvent("onBeforeRefreshAll", []), r(c), i.callEvent("onAfterRefreshAll", [])))
                    }
                }), i.attachEvent("onItemOpen", function() {
                    e.render()
                }), i.attachEvent("onItemClose", function() {
                    e.render()
                }), i.attachEvent("onIdChange", function(r, a) {
                    if (i.callEvent("onBeforeIdChange", [r, a]), !o(e)) {
                        var s = e.$services.getService("layers").getDataRender(t);
                        ! function(t, e, i, n) {
                            for (var r = 0; r < t.length; r++) t[r].change_id(e, i)
                        }(s.getLayers(), r, a, i.getItem(a)), n(a, s)
                    }
                })
            }
        }
    }, function(t, e) {
        t.exports = function(t) {
            var e = null,
                i = t._removeItemInner;

            function n(t) {
                e = null, this.callEvent("onAfterUnselect", [t])
            }
            return t._removeItemInner = function(t) {
                return e == t && n.call(this, t), e && this.eachItem && this.eachItem(function(t) {
                    t.id == e && n.call(this, t.id)
                }, t), i.apply(this, arguments)
            }, t.attachEvent("onIdChange", function(e, i) {
                t.getSelectedId() == e && t.silent(function() {
                    t.unselect(e), t.select(i)
                })
            }), {
                select: function(t) {
                    if (t) {
                        if (e == t) return e;
                        if (!this._skip_refresh && !this.callEvent("onBeforeSelect", [t])) return !1;
                        this.unselect(), e = t, this._skip_refresh || (this.refresh(t), this.callEvent("onAfterSelect", [t]))
                    }
                    return e
                },
                getSelectedId: function() {
                    return e
                },
                isSelected: function(t) {
                    return t == e
                },
                unselect: function(t) {
                    (t = t || e) && (e = null, this._skip_refresh || (this.refresh(t), n.call(this, t)))
                }
            }
        }
    }, function(t, e, i) {
        var n = i(0);
        t.exports = function() {
            return {
                getLinkCount: function() {
                    return this.$data.linksStore.count()
                },
                getLink: function(t) {
                    return this.$data.linksStore.getItem(t)
                },
                getLinks: function() {
                    return this.$data.linksStore.getItems()
                },
                isLinkExists: function(t) {
                    return this.$data.linksStore.exists(t)
                },
                addLink: function(t) {
                    return this.$data.linksStore.addItem(t)
                },
                updateLink: function(t, e) {
                    n.defined(e) || (e = this.getLink(t)), this.$data.linksStore.updateItem(t, e)
                },
                deleteLink: function(t) {
                    return this.$data.linksStore.removeItem(t)
                },
                changeLinkId: function(t, e) {
                    return this.$data.linksStore.changeId(t, e)
                }
            }
        }
    }, function(t, e, i) {
        var n = i(0);
        t.exports = function() {
            return {
                getTask: function(t) {
                    this.assert(t, "Invalid argument for gantt.getTask");
                    var e = this.$data.tasksStore.getItem(t);
                    return this.assert(e, "Task not found id=" + t), e
                },
                getTaskByTime: function(t, e) {
                    var i = this.$data.tasksStore.getItems(),
                        n = [];
                    if (t || e) {
                        t = +t || -1 / 0, e = +e || 1 / 0;
                        for (var r = 0; r < i.length; r++) {
                            var a = i[r]; + a.start_date < e && +a.end_date > t && n.push(a)
                        }
                    } else n = i;
                    return n
                },
                isTaskExists: function(t) {
                    return !(!this.$data || !this.$data.tasksStore) && this.$data.tasksStore.exists(t)
                },
                updateTask: function(t, e) {
                    n.defined(e) || (e = this.getTask(t)), this.$data.tasksStore.updateItem(t, e), this.isTaskExists(t) && this.refreshTask(t)
                },
                addTask: function(t, e, i) {
                    return n.defined(t.id) || (t.id = n.uid()), n.defined(e) || (e = this.getParent(t) || 0), this.isTaskExists(e) || (e = this.config.root_id), this.setParent(t, e), this.$data.tasksStore.addItem(t, i, e)
                },
                deleteTask: function(t) {
                    return this.$data.tasksStore.removeItem(t)
                },
                getTaskCount: function() {
                    return this.$data.tasksStore.count()
                },
                getVisibleTaskCount: function() {
                    return this.$data.tasksStore.countVisible()
                },
                getTaskIndex: function(t) {
                    return this.$data.tasksStore.getBranchIndex(t)
                },
                getGlobalTaskIndex: function(t) {
                    return this.assert(t, "Invalid argument"), this.$data.tasksStore.getIndexById(t)
                },
                eachTask: function(t, e, i) {
                    return this.$data.tasksStore.eachItem(n.bind(t, i || this), e)
                },
                eachParent: function(t, e, i) {
                    return this.$data.tasksStore.eachParent(n.bind(t, i || this), e)
                },
                changeTaskId: function(t, e) {
                    this.$data.tasksStore.changeId(t, e);
                    var i = this.$data.tasksStore.getItem(e),
                        n = [];
                    i.$source && (n = n.concat(i.$source)), i.$target && (n = n.concat(i.$target));
                    for (var r = 0; r < n.length; r++) {
                        var a = this.getLink(n[r]);
                        a.source == t && (a.source = e), a.target == t && (a.target = e)
                    }
                },
                calculateTaskLevel: function(t) {
                    return this.$data.tasksStore.calculateItemLevel(t)
                },
                getNext: function(t) {
                    return this.$data.tasksStore.getNext(t)
                },
                getPrev: function(t) {
                    return this.$data.tasksStore.getPrev(t)
                },
                getParent: function(t) {
                    return this.$data.tasksStore.getParent(t)
                },
                setParent: function(t, e, i) {
                    return this.$data.tasksStore.setParent(t, e, i)
                },
                getSiblings: function(t) {
                    return this.$data.tasksStore.getSiblings(t).slice()
                },
                getNextSibling: function(t) {
                    return this.$data.tasksStore.getNextSibling(t)
                },
                getPrevSibling: function(t) {
                    return this.$data.tasksStore.getPrevSibling(t)
                },
                getTaskByIndex: function(t) {
                    var e = this.$data.tasksStore.getIdByIndex(t);
                    return this.isTaskExists(e) ? this.getTask(e) : null
                },
                getChildren: function(t) {
                    return this.hasChild(t) ? this.$data.tasksStore.getChildren(t).slice() : []
                },
                hasChild: function(t) {
                    return this.$data.tasksStore.hasChild(t)
                },
                open: function(t) {
                    this.$data.tasksStore.open(t)
                },
                close: function(t) {
                    this.$data.tasksStore.close(t)
                },
                moveTask: function(t, e, i) {
                    return this.$data.tasksStore.move.apply(this.$data.tasksStore, arguments)
                },
                sort: function(t, e, i, n) {
                    var r = !n;
                    this.$data.tasksStore.sort(t, e, i), this.callEvent("onAfterSort", [t, e, i]), r && this.render()
                }
            }
        }
    }, function(t, e, i) {
        var n = i(0),
            r = i(111),
            a = i(110),
            o = i(31),
            s = i(29),
            l = i(109),
            c = i(108);

        function u() {
            for (var t = this.$services.getService("datastores"), e = [], i = 0; i < t.length; i++) e.push(this.getDatastore(t[i]));
            return e
        }
        var d = function() {
            return {
                createDatastore: function(t) {
                    var e = "treedatastore" == (t.type || "").toLowerCase() ? s : o;
                    if (t) {
                        var i = this;
                        t.openInitially = function() {
                            return i.config.open_tree_initially
                        }
                    }
                    var n = new e(t);
                    if (this.mixin(n, l(n)), t.name) {
                        this.$services.dropService("datastore:" + t.name), this.$services.setService("datastore:" + t.name, function() {
                            return n
                        });
                        var r = this.$services.getService("datastores");
                        r ? r.indexOf(t.name) < 0 && r.push(t.name) : (r = [], this.$services.setService("datastores", function() {
                            return r
                        }), r.push(t.name)), c.bindDataStore(t.name, this)
                    }
                    return n
                },
                getDatastore: function(t) {
                    return this.$services.getService("datastore:" + t)
                },
                refreshData: function() {
                    var t = this.getScrollState();
                    this.callEvent("onBeforeDataRender", []);
                    for (var e = u.call(this), i = 0; i < e.length; i++) e[i].refresh();
                    (t.x || t.y) && this.scrollTo(t.x, t.y), this.callEvent("onDataRender", [])
                },
                isChildOf: function(t, e) {
                    return this.$data.tasksStore.isChildOf(t, e)
                },
                refreshTask: function(t, e) {
                    var i = this.getTask(t);
                    if (i && this.isTaskVisible(t)) {
                        if (this.$data.tasksStore.refresh(t, !!this.getState().drag_id), void 0 !== e && !e) return;
                        for (var n = 0; n < i.$source.length; n++) this.refreshLink(i.$source[n]);
                        for (n = 0; n < i.$target.length; n++) this.refreshLink(i.$target[n])
                    } else this.isTaskExists(t) && this.isTaskExists(this.getParent(t)) && this.refreshTask(this.getParent(t))
                },
                refreshLink: function(t) {
                    this.$data.linksStore.refresh(t, !!this.getState().drag_id)
                },
                silent: function(t) {
                    var e = this;
                    e.$data.tasksStore.silent(function() {
                        e.$data.linksStore.silent(function() {
                            t()
                        })
                    })
                },
                clearAll: function() {
                    for (var t = u.call(this), e = 0; e < t.length; e++) t[e].clearAll();
                    this._update_flags(), this.userdata = {}, this.callEvent("onClear", []), this.render()
                },
                _clear_data: function() {
                    this.$data.tasksStore.clearAll(), this.$data.linksStore.clearAll(), this._update_flags(), this.userdata = {}
                },
                selectTask: function(t) {
                    var e = this.$data.tasksStore;
                    return !!this.config.select_task && (t && e.select(t), e.getSelectedId())
                },
                unselectTask: function(t) {
                    this.$data.tasksStore.unselect(t)
                },
                isSelectedTask: function(t) {
                    return this.$data.tasksStore.isSelected(t)
                },
                getSelectedId: function() {
                    return this.$data.tasksStore.getSelectedId()
                }
            }
        };
        t.exports = {
            create: function() {
                var t = n.mixin({}, d());
                return n.mixin(t, r()), n.mixin(t, a()), t
            }
        }
    }, function(t, e, i) {
        var n = i(0),
            r = i(112),
            a = i(28);
        t.exports = function(t) {
            var e = r.create();
            n.mixin(t, e);
            var o = t.createDatastore({
                    name: "task",
                    type: "treeDatastore",
                    rootId: function() {
                        return t.config.root_id
                    },
                    initItem: n.bind(function(e) {
                        this.defined(e.id) || (e.id = this.uid()), e.start_date && (e.start_date = t.date.parseDate(e.start_date, "parse_date")), e.end_date && (e.end_date = t.date.parseDate(e.end_date, "parse_date"));
                        var i = null;
                        (e.duration || 0 === e.duration) && (e.duration = i = 1 * e.duration), i && (e.start_date && !e.end_date ? e.end_date = this.calculateEndDate(e) : !e.start_date && e.end_date && (e.start_date = this.calculateEndDate({
                            start_date: e.end_date,
                            duration: -e.duration,
                            task: e
                        }))), e.progress = Number(e.progress) || 0, this._isAllowedUnscheduledTask(e) && this._set_default_task_timing(e), this._init_task_timing(e), e.start_date && e.end_date && this.correctTaskWorkTime(e), e.$source = [], e.$target = [];
                        var r = this.$data.tasksStore.getItem(e.id);
                        return r && !n.defined(e.open) && (e.$open = r.$open), void 0 === e.parent && (e.parent = this.config.root_id), e
                    }, t),
                    getConfig: function() {
                        return t.config
                    }
                }),
                s = t.createDatastore({
                    name: "link",
                    initItem: n.bind(function(t) {
                        return this.defined(t.id) || (t.id = this.uid()), t
                    }, t)
                });

            function l(e) {
                var i = t.isTaskVisible(e);
                if (!i && t.isTaskExists(e)) {
                    var n = t.getParent(e);
                    t.isTaskExists(n) && t.isTaskVisible(n) && (n = t.getTask(n), t.isSplitTask(n) && (i = !0))
                }
                return i
            }

            function c(e) {
                if (t.isTaskExists(e.source)) {
                    var i = t.getTask(e.source);
                    i.$source = i.$source || [], i.$source.push(e.id)
                }
                if (t.isTaskExists(e.target)) {
                    var n = t.getTask(e.target);
                    n.$target = n.$target || [], n.$target.push(e.id)
                }
            }

            function u(e) {
                if (t.isTaskExists(e.source))
                    for (var i = t.getTask(e.source), n = 0; n < i.$source.length; n++)
                        if (i.$source[n] == e.id) {
                            i.$source.splice(n, 1);
                            break
                        }
                if (t.isTaskExists(e.target)) {
                    var r = t.getTask(e.target);
                    for (n = 0; n < r.$target.length; n++)
                        if (r.$target[n] == e.id) {
                            r.$target.splice(n, 1);
                            break
                        }
                }
            }

            function d() {
                for (var e = null, i = t.$data.tasksStore.getItems(), n = 0, r = i.length; n < r; n++)(e = i[n]).$source = [], e.$target = [];
                var a = t.$data.linksStore.getItems();
                for (n = 0, r = a.length; n < r; n++) c(a[n])
            }

            function h(t) {
                var e = t.source,
                    i = t.target;
                for (var n in t.events) ! function(t, n) {
                    e.attachEvent(t, function() {
                        return i.callEvent(n, Array.prototype.slice.call(arguments))
                    }, n)
                }(n, t.events[n])
            }
            t.attachEvent("onDestroy", function() {
                    o.destructor(), s.destructor()
                }), o.attachEvent("onBeforeRefreshAll", function() {
                    for (var e = o.getVisibleItems(), i = 0; i < e.length; i++) {
                        var n = e[i];
                        n.$index = i, t.resetProjectDates(n)
                    }
                }), o.attachEvent("onFilterItem", function(e, i) {
                    if (t.config.show_tasks_outside_timescale) return !0;
                    var n = null,
                        r = null;
                    if (t.config.start_date && t.config.end_date) {
                        if (t._isAllowedUnscheduledTask(i)) return !0;
                        if (n = t.config.start_date.valueOf(), r = t.config.end_date.valueOf(), +i.start_date > r || +i.end_date < +n) return !1
                    }
                    return !0
                }), o.attachEvent("onIdChange", function(e, i) {
                    t._update_flags(e, i)
                }), o.attachEvent("onAfterUpdate", function(e) {
                    if (t._update_parents(e), t.getState("batchUpdate").batch_update) return !0;
                    for (var i = o.getItem(e), n = 0; n < i.$source.length; n++) s.refresh(i.$source[n]);
                    for (n = 0; n < i.$target.length; n++) s.refresh(i.$target[n])
                }), o.attachEvent("onAfterItemMove", function(e, i, n) {
                    var r = t.getTask(e);
                    null !== this.getNextSibling(e) ? r.$drop_target = this.getNextSibling(e) : null !== this.getPrevSibling(e) ? r.$drop_target = "next:" + this.getPrevSibling(e) : r.$drop_target = "next:null"
                }), o.attachEvent("onStoreUpdated", function(e, i, n) {
                    if ("delete" == n && t._update_flags(e, null), !t.$services.getService("state").getState("batchUpdate").batch_update) {
                        if (t.config.fit_tasks && "paint" !== n) {
                            var r = t.getState();
                            a(t);
                            var o = t.getState();
                            if (+r.min_date != +o.min_date || +r.max_date != +o.max_date) return t.render(), t.callEvent("onScaleAdjusted", []), !0
                        }
                        "add" == n || "move" == n || "delete" == n ? t.$layout.resize() : e || s.refresh()
                    }
                }), s.attachEvent("onAfterAdd", function(t, e) {
                    c(e)
                }), s.attachEvent("onAfterUpdate", function(t, e) {
                    d()
                }), s.attachEvent("onAfterDelete", function(t, e) {
                    u(e)
                }), s.attachEvent("onBeforeIdChange", function(e, i) {
                    u(t.mixin({
                        id: e
                    }, t.$data.linksStore.getItem(i))), c(t.$data.linksStore.getItem(i))
                }), s.attachEvent("onFilterItem", function(e, i) {
                    if (!t.config.show_links) return !1;
                    var n = l(i.source),
                        r = l(i.target);
                    return !(!n || !r || t._isAllowedUnscheduledTask(t.getTask(i.source)) || t._isAllowedUnscheduledTask(t.getTask(i.target))) && t.callEvent("onBeforeLinkDisplay", [e, i])
                }),
                function() {
                    var e = i(27),
                        n = {};
                    t.attachEvent("onBeforeTaskDelete", function(i, r) {
                        return n[i] = e.getSubtreeLinks(t, i), !0
                    }), t.attachEvent("onAfterTaskDelete", function(e, i) {
                        n[e] && t.$data.linksStore.silent(function() {
                            for (var i in n[e]) t.$data.linksStore.removeItem(i), u(n[e][i]);
                            n[e] = null
                        })
                    })
                }(), t.attachEvent("onAfterLinkDelete", function(e, i) {
                    t.refreshTask(i.source), t.refreshTask(i.target)
                }), t.attachEvent("onParse", d), h({
                    source: s,
                    target: t,
                    events: {
                        onItemLoading: "onLinkLoading",
                        onBeforeAdd: "onBeforeLinkAdd",
                        onAfterAdd: "onAfterLinkAdd",
                        onBeforeUpdate: "onBeforeLinkUpdate",
                        onAfterUpdate: "onAfterLinkUpdate",
                        onBeforeDelete: "onBeforeLinkDelete",
                        onAfterDelete: "onAfterLinkDelete",
                        onIdChange: "onLinkIdChange"
                    }
                }), h({
                    source: o,
                    target: t,
                    events: {
                        onItemLoading: "onTaskLoading",
                        onBeforeAdd: "onBeforeTaskAdd",
                        onAfterAdd: "onAfterTaskAdd",
                        onBeforeUpdate: "onBeforeTaskUpdate",
                        onAfterUpdate: "onAfterTaskUpdate",
                        onBeforeDelete: "onBeforeTaskDelete",
                        onAfterDelete: "onAfterTaskDelete",
                        onIdChange: "onTaskIdChange",
                        onBeforeItemMove: "onBeforeTaskMove",
                        onAfterItemMove: "onAfterTaskMove",
                        onFilterItem: "onBeforeTaskDisplay",
                        onItemOpen: "onTaskOpened",
                        onItemClose: "onTaskClosed",
                        onBeforeSelect: "onBeforeTaskSelected",
                        onAfterSelect: "onTaskSelected",
                        onAfterUnselect: "onTaskUnselected"
                    }
                }), t.$data = {
                    tasksStore: o,
                    linksStore: s
                }
        }
    }, function(t, e) {
        t.exports = function() {
            function t(t) {
                return t.$ui.getView("timeline")
            }

            function e(t) {
                return t.$ui.getView("grid")
            }

            function i(t) {
                return t.$ui.getView("scrollVer")
            }

            function n(t) {
                return t.$ui.getView("scrollHor")
            }
            var r = "DEFAULT_VALUE";

            function a(t, e, i, n) {
                var a = t(this);
                return a && a.isVisible() ? a[e].apply(a, i) : n ? n() : r
            }
            return {
                getColumnIndex: function(t) {
                    var i = a.call(this, e, "getColumnIndex", [t]);
                    return i === r ? 0 : i
                },
                dateFromPos: function(e) {
                    var i = a.call(this, t, "dateFromPos", Array.prototype.slice.call(arguments));
                    return i === r ? this.getState().min_date : i
                },
                posFromDate: function(e) {
                    var i = a.call(this, t, "posFromDate", [e]);
                    return i === r ? 0 : i
                },
                getRowTop: function(i) {
                    var n = this,
                        o = a.call(n, t, "getRowTop", [i], function() {
                            return a.call(n, e, "getRowTop", [i])
                        });
                    return o === r ? 0 : o
                },
                getTaskTop: function(i) {
                    var n = this,
                        o = a.call(n, t, "getItemTop", [i], function() {
                            return a.call(n, e, "getItemTop", [i])
                        });
                    return o === r ? 0 : o
                },
                getTaskPosition: function(e, i, n) {
                    var o = a.call(this, t, "getItemPosition", [e, i, n]);
                    return o === r ? {
                        left: 0,
                        top: this.getTaskTop(e.id),
                        height: this.getTaskHeight(),
                        width: 0
                    } : o
                },
                getTaskHeight: function() {
                    var i = this,
                        n = a.call(i, t, "getItemHeight", [], function() {
                            return a.call(i, e, "getItemHeight", [])
                        });
                    return n === r ? 0 : n
                },
                columnIndexByDate: function(e) {
                    var i = a.call(this, t, "columnIndexByDate", [e]);
                    return i === r ? 0 : i
                },
                roundTaskDates: function() {
                    a.call(this, t, "roundTaskDates", [])
                },
                getScale: function() {
                    var e = a.call(this, t, "getScale", []);
                    return e === r ? null : e
                },
                getTaskNode: function(e) {
                    var i = t(this);
                    return i && i.isVisible() ? i._taskRenderer.rendered[e] : null
                },
                getLinkNode: function(e) {
                    var i = t(this);
                    return i.isVisible() ? i._linkRenderer.rendered[e] : null
                },
                scrollTo: function(t, e) {
                    var r = i(this),
                        a = n(this),
                        o = {
                            position: 0
                        },
                        s = {
                            position: 0
                        };
                    r && (s = r.getScrollState()), a && (o = a.getScrollState()), a && 1 * t == t && a.scroll(t), r && 1 * e == e && r.scroll(e);
                    var l = {
                            position: 0
                        },
                        c = {
                            position: 0
                        };
                    r && (l = r.getScrollState()), a && (c = a.getScrollState()), this.callEvent("onGanttScroll", [o.position, s.position, c.position, l.position])
                },
                showDate: function(t) {
                    var e = this.posFromDate(t),
                        i = Math.max(e - this.config.task_scroll_offset, 0);
                    this.scrollTo(i)
                },
                showTask: function(t) {
                    var e, i = this.getTaskPosition(this.getTask(t)),
                        n = Math.max(i.left - this.config.task_scroll_offset, 0),
                        r = this._scroll_state().y;
                    e = r ? i.top - (r - this.config.row_height) / 2 : i.top, this.scrollTo(n, e)
                },
                _scroll_state: function() {
                    var t = {
                            x: !1,
                            y: !1,
                            x_pos: 0,
                            y_pos: 0,
                            scroll_size: this.config.scroll_size + 1,
                            x_inner: 0,
                            y_inner: 0
                        },
                        e = i(this),
                        r = n(this);
                    if (r) {
                        var a = r.getScrollState();
                        a.visible && (t.x = a.size, t.x_inner = a.scrollSize), t.x_pos = a.position || 0
                    }
                    if (e) {
                        var o = e.getScrollState();
                        o.visible && (t.y = o.size, t.y_inner = o.scrollSize), t.y_pos = o.position || 0
                    }
                    return t
                },
                getScrollState: function() {
                    var t = this._scroll_state();
                    return {
                        x: t.x_pos,
                        y: t.y_pos,
                        inner_width: t.x,
                        inner_height: t.y,
                        width: t.x_inner,
                        height: t.y_inner
                    }
                }
            }
        }
    }, function(t, e) {
        t.exports = function(t) {}
    }, function(t, e, i) {
        var n = i(1),
            r = function(t) {
                return {
                    getVerticalScrollbar: function() {
                        return t.$ui.getView("scrollVer")
                    },
                    getHorizontalScrollbar: function() {
                        return t.$ui.getView("scrollHor")
                    },
                    _legacyGridResizerClass: function(t) {
                        for (var e = t.getCellsByType("resizer"), i = 0; i < e.length; i++) {
                            var n = e[i],
                                r = !1,
                                a = n.$parent.getPrevSibling(n.$id);
                            if (a && a.$config && "grid" === a.$config.id) r = !0;
                            else {
                                var o = n.$parent.getNextSibling(n.$id);
                                o && o.$config && "grid" === o.$config.id && (r = !0)
                            }
                            r && (n.$config.css = (n.$config.css ? n.$config.css + " " : "") + "gantt_grid_resize_wrap")
                        }
                    },
                    onCreated: function(e) {
                        var i = !0;
                        this._legacyGridResizerClass(e), e.attachEvent("onBeforeResize", function() {
                            var r = t.$ui.getView("timeline");
                            r && (r.$config.hidden = r.$parent.$config.hidden = !t.config.show_chart);
                            var a = t.$ui.getView("grid");
                            if (a) {
                                var o = t.config.show_grid;
                                if (i) {
                                    var s = a._getColsTotalWidth();
                                    !1 !== s && (t.config.grid_width = s), o = o && !!t.config.grid_width, t.config.show_grid = o
                                }
                                if (a.$config.hidden = a.$parent.$config.hidden = !o, !a.$config.hidden) {
                                    var l = a._getGridWidthLimits();
                                    if (l[0] && t.config.grid_width < l[0] && (t.config.grid_width = l[0]), l[1] && t.config.grid_width > l[1] && (t.config.grid_width = l[1]), r && t.config.show_chart)
                                        if (a.$config.width = t.config.grid_width - 1, i) a.$parent.$config.width = t.config.grid_width, a.$parent.$config.group && t.$layout._syncCellSizes(a.$parent.$config.group, a.$parent.$config.width);
                                        else if (r && !n.isChildOf(r.$task, e.$view)) {
                                        if (!a.$config.original_grid_width) {
                                            var c = t.skins[t.skin];
                                            c && c.config && c.config.grid_width ? a.$config.original_grid_width = c.config.grid_width : a.$config.original_grid_width = 0
                                        }
                                        t.config.grid_width = a.$config.original_grid_width, a.$parent.$config.width = t.config.grid_width
                                    } else a.$parent._setContentSize(a.$config.width, null), t.$layout._syncCellSizes(a.$parent.$config.group, t.config.grid_width);
                                    else r && n.isChildOf(r.$task, e.$view) && (a.$config.original_grid_width = t.config.grid_width), i || (a.$parent.$config.width = 0)
                                }
                                i = !1
                            }
                        }), this._initScrollStateEvents(e)
                    },
                    _initScrollStateEvents: function(e) {
                        t._getVerticalScrollbar = this.getVerticalScrollbar, t._getHorizontalScrollbar = this.getHorizontalScrollbar;
                        var i = this.getVerticalScrollbar(),
                            n = this.getHorizontalScrollbar();
                        i && i.attachEvent("onScroll", function(e, i, n) {
                            var r = t.getScrollState();
                            t.callEvent("onGanttScroll", [r.x, e, r.x, i])
                        }), n && n.attachEvent("onScroll", function(e, i, n) {
                            var r = t.getScrollState();
                            t.callEvent("onGanttScroll", [e, r.y, i, r.y])
                        }), e.attachEvent("onResize", function() {
                            i && !t.$scroll_ver && (t.$scroll_ver = i.$scroll_ver), n && !t.$scroll_hor && (t.$scroll_hor = n.$scroll_hor)
                        })
                    },
                    _findGridResizer: function(t, e) {
                        for (var i, n = t.getCellsByType("resizer"), r = !0, a = 0; a < n.length; a++) {
                            var o = n[a];
                            o._getSiblings();
                            var s = o._behind,
                                l = o._front;
                            if (s && s.$content === e || s.isChild && s.isChild(e)) {
                                i = o, r = !0;
                                break
                            }
                            if (l && l.$content === e || l.isChild && l.isChild(e)) {
                                i = o, r = !1;
                                break
                            }
                        }
                        return {
                            resizer: i,
                            gridFirst: r
                        }
                    },
                    onInitialized: function(e) {
                        var i = t.$ui.getView("grid"),
                            n = this._findGridResizer(e, i);
                        if (n.resizer) {
                            var r, a = n.gridFirst,
                                o = n.resizer;
                            o.attachEvent("onResizeStart", function(e, i) {
                                var n = t.$ui.getView("grid"),
                                    o = n ? n.$parent : null;
                                if (o) {
                                    var s = n._getGridWidthLimits();
                                    n.$config.scrollable || (o.$config.minWidth = s[0]), o.$config.maxWidth = s[1]
                                }
                                return r = a ? e : i, t.callEvent("onGridResizeStart", [r])
                            }), o.attachEvent("onResize", function(e, i) {
                                var n = a ? e : i;
                                return t.callEvent("onGridResize", [r, n])
                            }), o.attachEvent("onResizeEnd", function(e, i, n, r) {
                                var o = a ? e : i,
                                    s = a ? n : r,
                                    l = t.$ui.getView("grid"),
                                    c = l ? l.$parent : null;
                                c && (c.$config.minWidth = void 0);
                                var u = t.callEvent("onGridResizeEnd", [o, s]);
                                return u && (t.config.grid_width = s), u
                            })
                        }
                    },
                    onDestroyed: function(t) {}
                }
            };
        t.exports = r
    }, function(t, e, i) {
        var n = i(1),
            r = function(t, e) {
                var i, r, a, o, s, l = 10,
                    c = 18;

                function u() {
                    return {
                        link_source_id: o,
                        link_target_id: r,
                        link_from_start: s,
                        link_to_start: a,
                        link_landing_area: i
                    }
                }
                var d = e.$services,
                    h = d.getService("state"),
                    f = d.getService("dnd");
                h.registerProvider("linksDnD", u);
                var _ = new f(t.$task_bars, {
                    sensitivity: 0,
                    updates_per_second: 60
                });

                function g(i, n, r, a, o) {
                    var s = function(i, n, r) {
                            var a = n(i),
                                o = {
                                    x: a.left,
                                    y: a.top,
                                    width: a.width,
                                    height: a.height
                                };
                            r.rtl ? (o.xEnd = o.x, o.x = o.xEnd + o.width) : o.xEnd = o.x + o.width;
                            if (o.yEnd = o.y + o.height, e.getTaskType(i.type) == e.config.types.milestone) {
                                var s = function() {
                                    var e = t.getItemHeight();
                                    return Math.round(Math.sqrt(2 * e * e)) - 2
                                }();
                                o.x += (r.rtl ? 1 : -1) * (s / 2), o.xEnd += (r.rtl ? -1 : 1) * (s / 2), o.width = a.xEnd - a.x
                            }
                            return o
                        }(i, function(t) {
                            return e.getTaskPosition(t)
                        }, a),
                        l = {
                            x: s.x,
                            y: s.y
                        };
                    n || (l.x = s.xEnd), l.y += e.config.row_height / 2;
                    var c = function(t) {
                        return e.getTaskType(t.type) == e.config.types.milestone
                    }(i) && o ? 2 : 0;
                    return r = r || 0, a.rtl && (r *= -1), l.x += (n ? -1 : 1) * r - c, l
                }

                function p(t, i) {
                    var n = _.getPosition(t),
                        r = function(t) {
                            var e = 0,
                                i = 0;
                            return t && (e = t.offsetWidth || 0, i = t.offsetHeight || 0), {
                                width: e,
                                height: i
                            }
                        }(i),
                        a = function() {
                            var t = e.$root;
                            return {
                                right: t.offsetWidth,
                                bottom: t.offsetHeight
                            }
                        }(),
                        o = e.config.tooltip_offset_x || l,
                        s = e.config.tooltip_offset_y || l,
                        u = e.config.scroll_size || c,
                        d = {
                            y: n.y + s,
                            x: n.x + o,
                            bottom: n.y + r.height + s + u,
                            right: n.x + r.width + o + u
                        };
                    return d.bottom > a.bottom && (d.y = a.bottom - r.height - s), d.right > a.right && (d.x = a.right - r.width - o), d
                }

                function v(t) {
                    var i = u(),
                        n = ["gantt_link_tooltip"];
                    i.link_source_id && i.link_target_id && (e.isLinkAllowed(i.link_source_id, i.link_target_id, i.link_from_start, i.link_to_start) ? n.push("gantt_allowed_link") : n.push("gantt_invalid_link"));
                    var r = e.templates.drag_link_class(i.link_source_id, i.link_from_start, i.link_target_id, i.link_to_start);
                    r && n.push(r);
                    var a = "<div class='" + r + "'>" + e.templates.drag_link(i.link_source_id, i.link_from_start, i.link_target_id, i.link_to_start) + "</div>";
                    t.innerHTML = a
                }

                function m() {
                    o = s = r = null, a = !0
                }

                function y(i, n, r, a) {
                    var o = function() {
                            _._direction && _._direction.parentNode || (_._direction = document.createElement("div"), t.$task_links.appendChild(_._direction));
                            return _._direction
                        }(),
                        s = u(),
                        l = ["gantt_link_direction"];
                    e.templates.link_direction_class && l.push(e.templates.link_direction_class(s.link_source_id, s.link_from_start, s.link_target_id, s.link_to_start));
                    var c = Math.sqrt(Math.pow(r - i, 2) + Math.pow(a - n, 2));
                    if (c = Math.max(0, c - 3)) {
                        o.className = l.join(" ");
                        var d = (a - n) / (r - i),
                            h = Math.atan(d);
                        2 == b(i, r, n, a) ? h += Math.PI : 3 == b(i, r, n, a) && (h -= Math.PI);
                        var f = Math.sin(h),
                            g = Math.cos(h),
                            p = Math.round(n),
                            v = Math.round(i),
                            m = ["-webkit-transform: rotate(" + h + "rad)", "-moz-transform: rotate(" + h + "rad)", "-ms-transform: rotate(" + h + "rad)", "-o-transform: rotate(" + h + "rad)", "transform: rotate(" + h + "rad)", "width:" + Math.round(c) + "px"];
                        if (-1 != window.navigator.userAgent.indexOf("MSIE 8.0")) {
                            m.push('-ms-filter: "' + function(t, e) {
                                return "progid:DXImageTransform.Microsoft.Matrix(M11 = " + e + ",M12 = -" + t + ",M21 = " + t + ",M22 = " + e + ",SizingMethod = 'auto expand')"
                            }(f, g) + '"');
                            var y = Math.abs(Math.round(i - r)),
                                k = Math.abs(Math.round(a - n));
                            switch (b(i, r, n, a)) {
                                case 1:
                                    p -= k;
                                    break;
                                case 2:
                                    v -= y, p -= k;
                                    break;
                                case 3:
                                    v -= y
                            }
                        }
                        m.push("top:" + p + "px"), m.push("left:" + v + "px"), o.style.cssText = m.join(";")
                    }
                }

                function b(t, e, i, n) {
                    return e >= t ? n <= i ? 1 : 4 : n <= i ? 2 : 3
                }
                _.attachEvent("onBeforeDragStart", e.bind(function(i, r) {
                    var a = r.target || r.srcElement;
                    if (m(), e.getState().drag_id) return !1;
                    if (n.locateClassName(a, "gantt_link_point")) {
                        n.locateClassName(a, "task_start_date") && (s = !0);
                        var l = e.locate(r);
                        o = l;
                        var c = e.getTask(l);
                        if (e.isReadonly(c)) return m(), !1;
                        return this._dir_start = g(c, !!s, 0, t.$getConfig(), !0), !0
                    }
                    return !1
                }, this)), _.attachEvent("onAfterDragStart", e.bind(function(t, i) {
                    e.config.touch && e.refreshData(), v(_.config.marker)
                }, this)), _.attachEvent("onDragMove", e.bind(function(o, s) {
                    var l = _.config,
                        c = p(s, l.marker);
                    ! function(t, e) {
                        t.style.left = e.x + "px", t.style.top = e.y + "px"
                    }(l.marker, c);
                    var u = !!n.locateClassName(s, "gantt_link_control"),
                        d = r,
                        h = i,
                        f = a,
                        m = e.locate(s),
                        b = !0;
                    if (n.isChildOf(s.target || s.srcElement, e.$root) || (u = !1, m = null), u && (b = !n.locateClassName(s, "task_end_date"), u = !!m), r = m, i = u, a = b, u) {
                        var k = e.getTask(m),
                            w = t.$getConfig(),
                            x = n.locateClassName(s, "gantt_link_control"),
                            $ = 0;
                        x && ($ = Math.floor(x.offsetWidth / 2)), this._dir_end = g(k, !!a, $, w)
                    } else this._dir_end = n.getRelativeEventPosition(s, t.$task_data);
                    var S = !(h == u && d == m && f == b);
                    return S && (d && e.refreshTask(d, !1), m && e.refreshTask(m, !1)), S && v(l.marker), y(this._dir_start.x, this._dir_start.y, this._dir_end.x, this._dir_end.y), !0
                }, this)), _.attachEvent("onDragEnd", e.bind(function() {
                    var t = u();
                    if (t.link_source_id && t.link_target_id && t.link_source_id != t.link_target_id) {
                        var i = e._get_link_type(t.link_from_start, t.link_to_start),
                            n = {
                                source: t.link_source_id,
                                target: t.link_target_id,
                                type: i
                            };
                        n.type && e.isLinkAllowed(n) && e.callEvent("onLinkCreated", [n]) && e.addLink(n)
                    }
                    m(), e.config.touch ? e.refreshData() : (t.link_source_id && e.refreshTask(t.link_source_id, !1), t.link_target_id && e.refreshTask(t.link_target_id, !1)), _._direction && (_._direction.parentNode && _._direction.parentNode.removeChild(_._direction), _._direction = null)
                }, this)), e.attachEvent("onGanttRender", e.bind(function() {
                    _._direction && y(this._dir_start.x, this._dir_start.y, this._dir_end.x, this._dir_end.y)
                }, this))
            };
        t.exports = {
            createLinkDND: function() {
                return {
                    init: r
                }
            }
        }
    }, function(t, e, i) {
        var n = i(1),
            r = i(0),
            a = i(42),
            o = i(2);
        t.exports = {
            createTaskDND: function() {
                var t;
                return {
                    extend: function(e) {
                        e.roundTaskDates = function(e) {
                            t.round_task_dates(e)
                        }
                    },
                    init: function(e, i) {
                        return t = function(t, e) {
                            var i = e.$services;
                            return {
                                drag: null,
                                dragMultiple: {},
                                _events: {
                                    before_start: {},
                                    before_finish: {},
                                    after_finish: {}
                                },
                                _handlers: {},
                                init: function() {
                                    this._domEvents = e._createDomEventScope(), this.clear_drag_state();
                                    var t = e.config.drag_mode;
                                    this.set_actions(), i.getService("state").registerProvider("tasksDnd", r.bind(function() {
                                        return {
                                            drag_id: this.drag ? this.drag.id : void 0,
                                            drag_mode: this.drag ? this.drag.mode : void 0,
                                            drag_from_start: this.drag ? this.drag.left : void 0
                                        }
                                    }, this));
                                    var n = {
                                        before_start: "onBeforeTaskDrag",
                                        before_finish: "onBeforeTaskChanged",
                                        after_finish: "onAfterTaskDrag"
                                    };
                                    for (var a in this._events)
                                        for (var o in t) this._events[a][o] = n[a];
                                    this._handlers[t.move] = this._move, this._handlers[t.resize] = this._resize, this._handlers[t.progress] = this._resize_progress
                                },
                                set_actions: function() {
                                    var i = t.$task_data;
                                    this._domEvents.attach(i, "mousemove", e.bind(function(t) {
                                        this.on_mouse_move(t || event)
                                    }, this)), this._domEvents.attach(i, "mousedown", e.bind(function(t) {
                                        this.on_mouse_down(t || event)
                                    }, this)), this._domEvents.attach(e.$root, "mouseup", e.bind(function(t) {
                                        this.on_mouse_up(t || event)
                                    }, this))
                                },
                                clear_drag_state: function() {
                                    this.drag = {
                                        id: null,
                                        mode: null,
                                        pos: null,
                                        start_x: null,
                                        start_y: null,
                                        obj: null,
                                        left: null
                                    }, this.dragMultiple = {}
                                },
                                _resize: function(i, n, r) {
                                    var a = t.$getConfig(),
                                        o = this._drag_task_coords(i, r);
                                    r.left ? (i.start_date = e.dateFromPos(o.start + n), i.start_date || (i.start_date = new Date(e.getState().min_date))) : (i.end_date = e.dateFromPos(o.end + n), i.end_date || (i.end_date = new Date(e.getState().max_date))), i.end_date - i.start_date < a.min_duration && (r.left ? i.start_date = e.calculateEndDate({
                                        start_date: i.end_date,
                                        duration: -1,
                                        task: i
                                    }) : i.end_date = e.calculateEndDate({
                                        start_date: i.start_date,
                                        duration: 1,
                                        task: i
                                    })), e._init_task_timing(i)
                                },
                                _resize_progress: function(e, i, n) {
                                    var r = this._drag_task_coords(e, n),
                                        a = t.$getConfig().rtl ? r.start - n.pos.x : n.pos.x - r.start,
                                        o = Math.max(0, a);
                                    e.progress = Math.min(1, o / Math.abs(r.end - r.start))
                                },
                                _find_max_shift: function(t, i) {
                                    var n;
                                    for (var r in t) {
                                        var a = t[r],
                                            o = e.getTask(a.id),
                                            s = this._drag_task_coords(o, a),
                                            l = e.posFromDate(new Date(e.getState().min_date)),
                                            c = e.posFromDate(new Date(e.getState().max_date));
                                        if (s.end + i > c) {
                                            var u = c - s.end;
                                            (u < n || void 0 === n) && (n = u)
                                        } else if (s.start + i < l) {
                                            var d = l - s.start;
                                            (d > n || void 0 === n) && (n = d)
                                        }
                                    }
                                    return n
                                },
                                _move: function(t, i, n) {
                                    var r = this._drag_task_coords(t, n),
                                        a = e.dateFromPos(r.start + i),
                                        o = e.dateFromPos(r.end + i);
                                    a ? o ? (t.start_date = a, t.end_date = o) : (t.end_date = new Date(e.getState().max_date), t.start_date = e.dateFromPos(e.posFromDate(t.end_date) - (r.end - r.start))) : (t.start_date = new Date(e.getState().min_date), t.end_date = e.dateFromPos(e.posFromDate(t.start_date) + (r.end - r.start)))
                                },
                                _drag_task_coords: function(t, i) {
                                    return {
                                        start: i.obj_s_x = i.obj_s_x || e.posFromDate(t.start_date),
                                        end: i.obj_e_x = i.obj_e_x || e.posFromDate(t.end_date)
                                    }
                                },
                                _mouse_position_change: function(t, e) {
                                    var i = t.x - e.x,
                                        n = t.y - e.y;
                                    return Math.sqrt(i * i + n * n)
                                },
                                _is_number: function(t) {
                                    return !isNaN(parseFloat(t)) && isFinite(t)
                                },
                                on_mouse_move: function(t) {
                                    if (this.drag.start_drag) {
                                        var i = n.getRelativeEventPosition(t, e.$task_data),
                                            r = this.drag.start_drag.start_x,
                                            o = this.drag.start_drag.start_y;
                                        (Date.now() - this.drag.timestamp > 50 || this._is_number(r) && this._is_number(o) && this._mouse_position_change({
                                            x: r,
                                            y: o
                                        }, i) > 20) && this._start_dnd(t)
                                    }
                                    if (this.drag.mode) {
                                        if (!a(this, 40)) return;
                                        this._update_on_move(t)
                                    }
                                },
                                _update_item_on_move: function(t, i, n, r, a) {
                                    var o = e.getTask(i),
                                        s = e.mixin({}, o),
                                        l = e.mixin({}, o);
                                    this._handlers[n].apply(this, [l, t, r]), e.mixin(o, l, !0), e.callEvent("onTaskDrag", [o.id, n, l, s, a]), e.mixin(o, l, !0), e.refreshTask(i)
                                },
                                _update_on_move: function(i) {
                                    var a = this.drag,
                                        o = t.$getConfig();
                                    if (a.mode) {
                                        var s = n.getRelativeEventPosition(i, t.$task_data);
                                        if (a.pos && a.pos.x == s.x) return;
                                        a.pos = s;
                                        var l = e.dateFromPos(s.x);
                                        if (!l || isNaN(l.getTime())) return;
                                        var c = s.x - a.start_x,
                                            u = e.getTask(a.id);
                                        if (this._handlers[a.mode]) {
                                            if (a.mode === o.drag_mode.move) {
                                                var d = {};
                                                if (this._isMultiselect() && e.getSelectedTasks().indexOf(a.id) >= 0 && (d = this.dragMultiple), e.isSummaryTask(u) && e.config.drag_project) {
                                                    var h = {};
                                                    h[a.id] = r.copy(a), d = r.mixin(h, this.dragMultiple)
                                                }
                                                var f = this._find_max_shift(d, c);
                                                for (var _ in void 0 !== f && (c = f), this._update_item_on_move(c, a.id, a.mode, a, i), d) {
                                                    var g = d[_];
                                                    this._update_item_on_move(c, g.id, g.mode, g, i)
                                                }
                                            } else this._update_item_on_move(c, a.id, a.mode, a, i);
                                            e._update_parents(a.id)
                                        }
                                    }
                                },
                                on_mouse_down: function(i, r) {
                                    if (2 != i.button || void 0 === i.button) {
                                        var a = t.$getConfig(),
                                            o = e.locate(i),
                                            s = null;
                                        if (e.isTaskExists(o) && (s = e.getTask(o)), !e.isReadonly(s) && !this.drag.mode) {
                                            this.clear_drag_state(), r = r || i.target || i.srcElement;
                                            var l = n.getClassName(r),
                                                c = this._get_drag_mode(l, r);
                                            if (!l || !c) return r.parentNode ? this.on_mouse_down(i, r.parentNode) : void 0;
                                            if (c)
                                                if (c.mode && c.mode != a.drag_mode.ignore && a["drag_" + c.mode]) {
                                                    if (o = e.locate(r), s = e.copy(e.getTask(o) || {}), e.isReadonly(s)) return this.clear_drag_state(), !1;
                                                    if (e.isSummaryTask(s) && !a.drag_project && c.mode != a.drag_mode.progress) return void this.clear_drag_state();
                                                    c.id = o;
                                                    var u = n.getRelativeEventPosition(i, e.$task_data);
                                                    c.start_x = u.x, c.start_y = u.y, c.obj = s, this.drag.start_drag = c, this.drag.timestamp = Date.now()
                                                } else this.clear_drag_state();
                                            else if (e.checkEvent("onMouseDown") && e.callEvent("onMouseDown", [l.split(" ")[0]]) && r.parentNode) return this.on_mouse_down(i, r.parentNode)
                                        }
                                    }
                                },
                                _fix_dnd_scale_time: function(i, n) {
                                    var r = t.$getConfig(),
                                        a = e.getScale().unit,
                                        o = e.getScale().step;

                                    function s(i) {
                                        if (e.config.correct_work_time) {
                                            var n = t.$getConfig();
                                            e.isWorkTime(i.start_date, void 0, i) || (i.start_date = e.calculateEndDate({
                                                start_date: i.start_date,
                                                duration: -1,
                                                unit: n.duration_unit,
                                                task: i
                                            }))
                                        }
                                    }
                                    r.round_dnd_dates || (a = "minute", o = r.time_step), n.mode == r.drag_mode.resize ? n.left ? (i.start_date = e.roundDate({
                                        date: i.start_date,
                                        unit: a,
                                        step: o
                                    }), s(i)) : (i.end_date = e.roundDate({
                                        date: i.end_date,
                                        unit: a,
                                        step: o
                                    }), function(i) {
                                        if (e.config.correct_work_time) {
                                            var n = t.$getConfig();
                                            e.isWorkTime(new Date(i.end_date - 1), void 0, i) || (i.end_date = e.calculateEndDate({
                                                start_date: i.end_date,
                                                duration: 1,
                                                unit: n.duration_unit,
                                                task: i
                                            }))
                                        }
                                    }(i)) : n.mode == r.drag_mode.move && (i.start_date = e.roundDate({
                                        date: i.start_date,
                                        unit: a,
                                        step: o
                                    }), s(i), i.end_date = e.calculateEndDate(i))
                                },
                                _fix_working_times: function(i, n) {
                                    var r = t.$getConfig();
                                    (n = n || {
                                        mode: r.drag_mode.move
                                    }).mode == r.drag_mode.resize ? n.left ? i.start_date = e.getClosestWorkTime({
                                        date: i.start_date,
                                        dir: "future",
                                        task: i
                                    }) : i.end_date = e.getClosestWorkTime({
                                        date: i.end_date,
                                        dir: "past",
                                        task: i
                                    }) : n.mode == r.drag_mode.move && e.correctTaskWorkTime(i)
                                },
                                _finalize_mouse_up: function(t, i, n, r) {
                                    var a = e.getTask(t);
                                    if (i.work_time && i.correct_work_time && this._fix_working_times(a, n), this._fix_dnd_scale_time(a, n), this._fireEvent("before_finish", n.mode, [t, n.mode, e.copy(n.obj), r])) {
                                        var o = t;
                                        e._init_task_timing(a), this.clear_drag_state(), e.updateTask(a.id), this._fireEvent("after_finish", n.mode, [o, n.mode, r])
                                    } else this.clear_drag_state(), t == n.id && (n.obj._dhx_changed = !1, e.mixin(a, n.obj, !0)), e.refreshTask(a.id)
                                },
                                on_mouse_up: function(i) {
                                    var n = this.drag;
                                    if (n.mode && n.id) {
                                        var r = t.$getConfig(),
                                            a = e.getTask(n.id),
                                            o = this.dragMultiple;
                                        if (n.mode === r.drag_mode.move && (e.isSummaryTask(a) && r.drag_project || this._isMultiselect()))
                                            for (var s in o) this._finalize_mouse_up(o[s].id, r, o[s], i);
                                        this._finalize_mouse_up(n.id, r, n, i)
                                    }
                                    this.clear_drag_state()
                                },
                                _get_drag_mode: function(e, i) {
                                    var n = t.$getConfig().drag_mode,
                                        r = {
                                            mode: null,
                                            left: null
                                        };
                                    switch ((e || "").split(" ")[0]) {
                                        case "gantt_task_line":
                                        case "gantt_task_content":
                                            r.mode = n.move;
                                            break;
                                        case "gantt_task_drag":
                                            r.mode = n.resize;
                                            var a = i.getAttribute("data-bind-property");
                                            r.left = "start_date" == a;
                                            break;
                                        case "gantt_task_progress_drag":
                                            r.mode = n.progress;
                                            break;
                                        case "gantt_link_control":
                                        case "gantt_link_point":
                                            r.mode = n.ignore;
                                            break;
                                        default:
                                            r = null
                                    }
                                    return r
                                },
                                _start_dnd: function(i) {
                                    var n = this.drag = this.drag.start_drag;
                                    delete n.start_drag;
                                    var r = t.$getConfig(),
                                        a = n.id;
                                    if (r["drag_" + n.mode] && e.callEvent("onBeforeDrag", [a, n.mode, i]) && this._fireEvent("before_start", n.mode, [a, n.mode, i])) {
                                        delete n.start_drag;
                                        var s = e.getTask(a);
                                        if (e.isReadonly(s)) return void this.clear_drag_state();
                                        if (this._isMultiselect()) {
                                            var l = e.getSelectedTasks();
                                            l.indexOf(n.id) >= 0 && o.forEach(l, e.bind(function(t) {
                                                var i = e.getTask(t);
                                                e.isSummaryTask(i) && e.config.drag_project && n.mode == r.drag_mode.move && this._addSubtasksToDragMultiple(i.id), this.dragMultiple[t] = e.mixin({
                                                    id: i.id,
                                                    obj: e.copy(i)
                                                }, this.drag)
                                            }, this))
                                        }
                                        e.isSummaryTask(s) && e.config.drag_project && n.mode == r.drag_mode.move && this._addSubtasksToDragMultiple(s.id), e.callEvent("onTaskDragStart", [])
                                    } else this.clear_drag_state()
                                },
                                _fireEvent: function(t, i, n) {
                                    e.assert(this._events[t], "Invalid stage:{" + t + "}");
                                    var r = this._events[t][i];
                                    return e.assert(r, "Unknown after drop mode:{" + i + "}"), e.assert(n, "Invalid event arguments"), !e.checkEvent(r) || e.callEvent(r, n)
                                },
                                round_task_dates: function(e) {
                                    var i = this.drag,
                                        n = t.$getConfig();
                                    i || (i = {
                                        mode: n.drag_mode.move
                                    }), this._fix_dnd_scale_time(e, i)
                                },
                                destructor: function() {
                                    this._domEvents.detachAll()
                                },
                                _isMultiselect: function() {
                                    return e.config.drag_multiple && !!(e.getSelectedTasks && e.getSelectedTasks().length > 0)
                                },
                                _addSubtasksToDragMultiple: function(t) {
                                    e.eachTask(function(t) {
                                        this.dragMultiple[t.id] = e.mixin({
                                            id: t.id,
                                            obj: e.copy(t)
                                        }, this.drag)
                                    }, t, this)
                                }
                            }
                        }(e, i), e._tasks_dnd = t, t.init(i)
                    },
                    destructor: function() {
                        t && (t.destructor(), t = null)
                    }
                }
            }
        }
    }, function(t, e, i) {
        var n = i(0),
            r = i(118),
            a = i(117),
            o = i(1),
            s = function(t) {
                var e = t.$services;
                return {
                    onCreated: function(e) {
                        var o = e.$config;
                        o.bind = n.defined(o.bind) ? o.bind : "task", o.bindLinks = n.defined(o.bindLinks) ? o.bindLinks : "link", e._linksDnD = a.createLinkDND(), e._tasksDnD = r.createTaskDND(), e._tasksDnD.extend(e), this._mouseDelegates = i(16)(t)
                    },
                    onInitialized: function(e) {
                        this._attachDomEvents(t), this._attachStateProvider(t, e), e._tasksDnD.init(e, t), e._linksDnD.init(e, t), "timeline" == e.$config.id && this.extendDom(e)
                    },
                    onDestroyed: function(e) {
                        this._clearDomEvents(t), this._clearStateProvider(t), e._tasksDnD && e._tasksDnD.destructor()
                    },
                    extendDom: function(e) {
                        t.$task = e.$task, t.$task_scale = e.$task_scale, t.$task_data = e.$task_data, t.$task_bg = e.$task_bg, t.$task_links = e.$task_links, t.$task_bars = e.$task_bars
                    },
                    _clearDomEvents: function() {
                        this._mouseDelegates.destructor(), this._mouseDelegates = null
                    },
                    _attachDomEvents: function(t) {
                        function e(e, i) {
                            if (e && this.callEvent("onLinkDblClick", [e, i])) {
                                var n = this.getLink(e);
                                if (this.isReadonly(n)) return;
                                var r = this.locale.labels.link + " " + this.templates.link_description(this.getLink(e)) + " " + this.locale.labels.confirm_link_deleting;
                                window.setTimeout(function() {
                                    t._dhtmlx_confirm(r, "", function() {
                                        t.deleteLink(e)
                                    })
                                }, this.config.touch ? 300 : 1)
                            }
                        }
                        this._mouseDelegates.delegate("click", "gantt_task_link", t.bind(function(t, e) {
                            var i = this.locate(t, this.config.link_attribute);
                            i && this.callEvent("onLinkClick", [i, t])
                        }, t), this.$task), this._mouseDelegates.delegate("click", "gantt_scale_cell", t.bind(function(e, i) {
                            var n = o.getRelativeEventPosition(e, t.$task_data),
                                r = t.dateFromPos(n.x),
                                a = Math.floor(t.columnIndexByDate(r)),
                                s = t.getScale().trace_x[a];
                            t.callEvent("onScaleClick", [e, s])
                        }, t), this.$task), this._mouseDelegates.delegate("doubleclick", "gantt_task_link", t.bind(function(i, n, r) {
                            n = this.locate(i, t.config.link_attribute), e.call(this, n, i)
                        }, t), this.$task), this._mouseDelegates.delegate("doubleclick", "gantt_link_point", t.bind(function(t, i, n) {
                            i = this.locate(t);
                            var r = this.getTask(i),
                                a = null;
                            return n.parentNode && o.getClassName(n.parentNode) && (a = o.getClassName(n.parentNode).indexOf("_left") > -1 ? r.$target[0] : r.$source[0]), a && e.call(this, a, t), !1
                        }, t), this.$task)
                    },
                    _attachStateProvider: function(t, i) {
                        var n = i;
                        e.getService("state").registerProvider("tasksTimeline", function() {
                            return {
                                scale_unit: n._tasks ? n._tasks.unit : void 0,
                                scale_step: n._tasks ? n._tasks.step : void 0
                            }
                        })
                    },
                    _clearStateProvider: function() {
                        e.getService("state").unregisterProvider("tasksTimeline")
                    }
                }
            };
        t.exports = s
    }, function(t, e, i) {
        var n = i(1);

        function r(t, e) {
            var i = n.getNodePosition(e.$grid_data);
            return t.x += i.x - e.$grid.scrollLeft, t.y += i.y - e.$grid_data.scrollTop, t
        }
        t.exports = {
            removeLineHighlight: function(t) {
                t.markerLine && t.markerLine.parentNode && t.markerLine.parentNode.removeChild(t.markerLine), t.markerLine = null
            },
            highlightPosition: function(t, e, i) {
                var a = function(t, e) {
                    var i = n.getNodePosition(e.$grid_data),
                        r = n.getRelativeEventPosition(t, e.$grid_data),
                        a = e.$config.rowStore,
                        o = i.x,
                        s = r.y - 10,
                        l = e.$getConfig();
                    s < i.y && (s = i.y);
                    var c = a.countVisible() * l.row_height;
                    return s > i.y + c - l.row_height && (s = i.y + c - l.row_height), i.x = o, i.y = s, i
                }(t, i);
                e.marker.style.left = a.x + 9 + "px", e.marker.style.top = a.y + "px";
                var o = e.markerLine;
                o || ((o = document.createElement("div")).className = "gantt_drag_marker gantt_grid_dnd_marker", o.innerHTML = "<div class='gantt_grid_dnd_marker_line'></div>", o.style.pointerEvents = "none", document.body.appendChild(o), e.markerLine = o), t.child ? function(t, e, i) {
                    var n = t.targetParent,
                        a = r({
                            x: 0,
                            y: i.getItemTop(n)
                        }, i);
                    e.innerHTML = "<div class='gantt_grid_dnd_marker_folder'></div>", e.style.width = i.$grid_data.offsetWidth + "px", e.style.top = a.y + "px", e.style.left = a.x + "px", e.style.height = i.getItemHeight(n) + "px"
                }(t, o, i) : function(t, e, i) {
                    var n = function(t, e) {
                        var i = e.$config.rowStore,
                            n = {
                                x: 0,
                                y: 0
                            },
                            a = e.$grid_data.querySelector(".gantt_tree_indent"),
                            o = 15,
                            s = 0;
                        if (a && (o = a.offsetWidth), t.targetId !== i.$getRootId()) {
                            var l = e.getItemTop(t.targetId),
                                c = e.getItemHeight(t.targetId);
                            if (s = i.exists(t.targetId) ? i.calculateItemLevel(i.getItem(t.targetId)) : 0, t.prevSibling) n.y = l;
                            else if (t.nextSibling) {
                                var u = 0;
                                i.eachItem(function(t) {
                                    -1 !== i.getIndexById(t.id) && u++
                                }, t.targetId), n.y = l + c + u * c
                            } else n.y = l + c, s += 1
                        }
                        return n.x = 40 + s * o, n.width = Math.max(e.$grid_data.offsetWidth - n.x, 0), r(n, e)
                    }(t, i);
                    e.innerHTML = "<div class='gantt_grid_dnd_marker_line'></div>", e.style.left = n.x + "px", e.style.height = "4px", e.style.top = n.y - 2 + "px", e.style.width = n.width + "px"
                }(t, o, i)
            }
        }
    }, function(t, e, i) {
        var n = i(13);
        t.exports = function(t, e, i, r, a) {
            var o;
            if (e !== a.$getRootId()) o = i < .25 ? n.prevSiblingTarget(t, e, a) : !(i > .6) || a.hasChild(e) && a.getItem(e).$open ? n.firstChildTarget(t, e, a) : n.nextSiblingTarget(t, e, a);
            else {
                var s = a.$getRootId();
                o = a.hasChild(s) && r >= 0 ? n.lastChildTarget(t, s, a) : n.firstChildTarget(t, s, a)
            }
            return o
        }
    }, function(t, e, i) {
        var n = i(13);

        function r(t, e, i, r, a) {
            for (var o = e; r.exists(o);) {
                var s = r.calculateItemLevel(r.getItem(o));
                if ((s === i || s === i - 1) && r.getBranchIndex(o) > -1) break;
                o = a ? r.getPrev(o) : r.getNext(o)
            }
            return r.exists(o) ? r.calculateItemLevel(r.getItem(o)) === i ? a ? n.nextSiblingTarget(t, o, r) : n.prevSiblingTarget(t, o, r) : n.firstChildTarget(t, o, r) : null
        }

        function a(t, e, i, n) {
            return r(t, e, i, n, !0)
        }

        function o(t, e, i, n) {
            return r(t, e, i, n, !1)
        }
        t.exports = function(t, e, i, r, s, l) {
            var c;
            if (e !== s.$getRootId()) i < .5 ? s.calculateItemLevel(s.getItem(e)) === l ? c = s.getPrevSibling(e) ? n.nextSiblingTarget(t, s.getPrevSibling(e), s) : n.prevSiblingTarget(t, e, s) : (c = a(t, e, l, s)) && (c = o(t, e, l, s)) : s.calculateItemLevel(s.getItem(e)) === l ? c = n.nextSiblingTarget(t, e, s) : (c = o(t, e, l, s)) && (c = a(t, e, l, s));
            else {
                var u = s.$getRootId(),
                    d = s.getChildren(u);
                c = n.createDropTargetObject(), c = d.length && r >= 0 ? a(t, function(t) {
                    for (var e = t.getNext(); t.exists(e);) {
                        var i = t.getNext(e);
                        if (!t.exists(i)) return e;
                        e = i
                    }
                    return null
                }(s), l, s) : o(t, u, l, s)
            }
            return c
        }
    }, function(t, e, i) {
        var n = i(1),
            r = i(13),
            a = i(122),
            o = i(121),
            s = i(120);
        t.exports = {
            init: function(t, e) {
                var i = t.$services.getService("dnd");
                if (e.$config.bind && t.getDatastore(e.$config.bind)) {
                    var l = new i(e.$grid_data, {
                        updates_per_second: 60
                    });
                    t.defined(e.$getConfig().dnd_sensitivity) && (l.config.sensitivity = e.$getConfig().dnd_sensitivity), l.attachEvent("onBeforeDragStart", t.bind(function(i, r) {
                        var a = c(r);
                        if (!a) return !1;
                        if (t.hideQuickInfo && t._hideQuickInfo(), n.closest(r.target, ".gantt_grid_editor_placeholder")) return !1;
                        var o = a.getAttribute(e.$config.item_attribute),
                            s = e.$config.rowStore.getItem(o);
                        return !t.isReadonly(s) && (l.config.initial_open_state = s.$open, !!t.callEvent("onRowDragStart", [o, r.target || r.srcElement, r]) && void 0)
                    }, t)), l.attachEvent("onAfterDragStart", t.bind(function(t, i) {
                        var n = c(i);
                        l.config.marker.innerHTML = n.outerHTML;
                        var a = l.config.marker.firstChild;
                        a && (l.config.marker.style.opacity = .4, a.style.position = "static", a.style.pointerEvents = "none"), l.config.id = n.getAttribute(e.$config.item_attribute);
                        var o = e.$config.rowStore,
                            s = o.getItem(l.config.id);
                        l.config.level = o.calculateItemLevel(s), l.config.drop_target = r.createDropTargetObject({
                            targetParent: o.getParent(s.id),
                            targetIndex: o.getBranchIndex(s.id),
                            targetId: s.id,
                            nextSibling: !0
                        }), s.$open = !1, s.$transparent = !0, this.refreshData()
                    }, t)), l.attachEvent("onDragMove", t.bind(function(i, n) {
                        var a = u(n);
                        return a && !1 !== t.callEvent("onBeforeRowDragMove", [l.config.id, a.targetParent, a.targetIndex]) || (a = r.createDropTargetObject(l.config.drop_target)), s.highlightPosition(a, l.config, e), l.config.drop_target = a, this.callEvent("onRowDragMove", [l.config.id, a.targetParent, a.targetIndex]), !0
                    }, t)), l.attachEvent("onDragEnd", t.bind(function() {
                        var t = e.$config.rowStore,
                            i = t.getItem(l.config.id);
                        s.removeLineHighlight(l.config), i.$transparent = !1, i.$open = l.config.initial_open_state;
                        var n = l.config.drop_target;
                        !1 === this.callEvent("onBeforeRowDragEnd", [l.config.id, n.targetParent, n.targetIndex]) ? i.$drop_target = null : (t.move(l.config.id, n.targetIndex, n.targetParent), this.callEvent("onRowDragEnd", [l.config.id, n.targetParent, n.targetIndex])), t.refresh(i.id)
                    }, t))
                }

                function c(t) {
                    return n.locateAttribute(t, e.$config.item_attribute)
                }

                function u(t) {
                    var i = function(t) {
                            var i = n.getRelativeEventPosition(t, e.$grid_data).y,
                                r = e.$config.rowStore;
                            if ((i = i || 0) < 0) return r.$getRootId();
                            var a = Math.floor(i / e.getItemHeight());
                            return a > r.countVisible() - 1 ? r.$getRootId() : r.getIdByIndex(a)
                        }(t),
                        r = null,
                        s = e.$config.rowStore,
                        c = !e.$getConfig().order_branch_free,
                        u = n.getRelativeEventPosition(t, e.$grid_data).y;
                    return i !== s.$getRootId() && (r = (u - e.getItemTop(i)) / e.getItemHeight()), c ? a(l.config.id, i, r, u, s, l.config.level) : o(l.config.id, i, r, u, s)
                }
            }
        }
    }, function(t, e, i) {
        var n = i(1);
        t.exports = {
            init: function(t, e) {
                var i = t.$services.getService("dnd");
                if (e.$config.bind && t.getDatastore(e.$config.bind)) {
                    var r = new i(e.$grid_data, {
                        updates_per_second: 60
                    });
                    t.defined(e.$getConfig().dnd_sensitivity) && (r.config.sensitivity = e.$getConfig().dnd_sensitivity), r.attachEvent("onBeforeDragStart", t.bind(function(i, s) {
                        var l = a(s);
                        if (!l) return !1;
                        if (t.hideQuickInfo && t._hideQuickInfo(), n.closest(s.target, ".gantt_grid_editor_placeholder")) return !1;
                        var c = l.getAttribute(e.$config.item_attribute),
                            u = o().getItem(c);
                        return !t.isReadonly(u) && (r.config.initial_open_state = u.$open, !!t.callEvent("onRowDragStart", [c, s.target || s.srcElement, s]) && void 0)
                    }, t)), r.attachEvent("onAfterDragStart", t.bind(function(t, i) {
                        var n = a(i);
                        r.config.marker.innerHTML = n.outerHTML;
                        var s = r.config.marker.firstChild;
                        s && (s.style.position = "static"), r.config.id = n.getAttribute(e.$config.item_attribute);
                        var l = o(),
                            c = l.getItem(r.config.id);
                        r.config.index = l.getBranchIndex(r.config.id), r.config.parent = c.parent, c.$open = !1, c.$transparent = !0, this.refreshData()
                    }, t)), r.lastTaskOfLevel = function(t) {
                        for (var e = null, i = o().getItems(), n = 0, r = i.length; n < r; n++) i[n].$level == t && (e = i[n]);
                        return e ? e.id : null
                    }, r._getGridPos = t.bind(function(t) {
                        var i = n.getNodePosition(e.$grid_data),
                            r = o(),
                            a = i.x,
                            s = t.pos.y - 10,
                            l = e.$getConfig();
                        s < i.y && (s = i.y);
                        var c = r.countVisible() * l.row_height;
                        return s > i.y + c - l.row_height && (s = i.y + c - l.row_height), i.x = a, i.y = s, i
                    }, t), r._getTargetY = t.bind(function(t) {
                        var i = n.getNodePosition(e.$grid_data),
                            r = t.pageY - i.y + (e.$state.scrollTop || 0);
                        return r < 0 && (r = 0), r
                    }, t), r._getTaskByY = t.bind(function(t, i) {
                        var n = e.$getConfig(),
                            r = o();
                        t = t || 0;
                        var a = Math.floor(t / n.row_height);
                        return (a = i < a ? a - 1 : a) > r.countVisible() - 1 ? null : r.getIdByIndex(a)
                    }, t), r.attachEvent("onDragMove", t.bind(function(t, i) {
                        var n = r.config,
                            a = r._getGridPos(i),
                            s = e.$getConfig(),
                            l = o();
                        n.marker.style.left = a.x + 10 + "px", n.marker.style.top = a.y + "px";
                        var c = l.getItem(r.config.id),
                            u = r._getTargetY(i),
                            d = r._getTaskByY(u, l.getIndexById(c.id));

                        function h(t, e) {
                            return !l.isChildOf(f.id, e.id) && (t.$level == e.$level || s.order_branch_free)
                        }
                        if (l.exists(d) || (d = r.lastTaskOfLevel(s.order_branch_free ? c.$level : 0)) == r.config.id && (d = null), l.exists(d)) {
                            var f = l.getItem(d);
                            if (l.getIndexById(f.id) * s.row_height + s.row_height / 2 < u) {
                                var _ = l.getIndexById(f.id),
                                    g = l.getNext(f.id),
                                    p = l.getItem(g);
                                if (p) {
                                    if (p.id == c.id) return s.order_branch_free && l.isChildOf(c.id, f.id) && 1 == l.getChildren(f.id).length ? void l.move(c.id, l.getBranchIndex(f.id) + 1, l.getParent(f.id)) : void 0;
                                    f = p
                                } else if (g = l.getIdByIndex(_), h(p = l.getItem(g), c) && p.id != c.id) return void l.move(c.id, -1, l.getParent(p.id))
                            } else if (s.order_branch_free && f.id != c.id && h(f, c)) {
                                if (!l.hasChild(f.id)) return f.$open = !0, void l.move(c.id, -1, f.id);
                                if (l.getIndexById(f.id) || s.row_height / 3 < u) return
                            }
                            _ = l.getIndexById(f.id);
                            for (var v = l.getIdByIndex(_ - 1), m = l.getItem(v), y = 1;
                                (!m || m.id == f.id) && _ - y >= 0;) v = l.getIdByIndex(_ - y), m = l.getItem(v), y++;
                            if (c.id == f.id) return;
                            h(f, c) && c.id != f.id ? l.move(c.id, 0, 0, f.id) : f.$level != c.$level - 1 || l.getChildren(f.id).length ? m && h(m, c) && c.id != m.id && l.move(c.id, -1, l.getParent(m.id)) : l.move(c.id, 0, f.id)
                        }
                        return !0
                    }, t)), r.attachEvent("onDragEnd", t.bind(function() {
                        var t = o(),
                            e = t.getItem(r.config.id);
                        e.$transparent = !1, e.$open = r.config.initial_open_state, !1 === this.callEvent("onBeforeRowDragEnd", [r.config.id, r.config.parent, r.config.index]) ? (t.move(r.config.id, r.config.index, r.config.parent), e.$drop_target = null) : this.callEvent("onRowDragEnd", [r.config.id, e.$drop_target]), this.refreshData()
                    }, t))
                }

                function a(t) {
                    return n.locateAttribute(t, e.$config.item_attribute)
                }

                function o() {
                    return t.getDatastore(e.$config.bind)
                }
            }
        }
    }, function(t, e, i) {
        var n = i(0),
            r = i(124),
            a = i(123),
            o = function(t) {
                return {
                    onCreated: function(e) {
                        e.$config = n.mixin(e.$config, {
                            bind: "task"
                        }), "grid" == e.$config.id && (this.extendGantt(e), t.ext.inlineEditors = t.ext._inlineEditors.createEditors(e), t.ext.inlineEditors.init()), this._mouseDelegates = i(16)(t)
                    },
                    onInitialized: function(e) {
                        var i = e.$getConfig();
                        i.order_branch && ("marker" == i.order_branch ? a.init(e.$gantt, e) : r.init(e.$gantt, e)), this.initEvents(e, t), "grid" == e.$config.id && this.extendDom(e)
                    },
                    onDestroyed: function(e) {
                        "grid" == e.$config.id && t.ext.inlineEditors.destructor(), this.clearEvents(e, t)
                    },
                    initEvents: function(t, e) {
                        this._mouseDelegates.delegate("click", "gantt_row", e.bind(function(i, n, r) {
                            var a = t.$getConfig();
                            if (null !== n) {
                                var o = this.getTask(n);
                                a.scroll_on_click && !e._is_icon_open_click(i) && this.showDate(o.start_date), e.callEvent("onTaskRowClick", [n, r])
                            }
                        }, e), t.$grid), this._mouseDelegates.delegate("click", "gantt_grid_head_cell", e.bind(function(i, n, r) {
                            var a = r.getAttribute("data-column-id");
                            if (e.callEvent("onGridHeaderClick", [a, i])) {
                                var o = t.$getConfig();
                                if ("add" != a) {
                                    if (o.sort) {
                                        for (var s, l = a, c = 0; c < o.columns.length; c++)
                                            if (o.columns[c].name == a) {
                                                s = o.columns[c];
                                                break
                                            }
                                        if (s && void 0 !== s.sort && !0 !== s.sort && !(l = s.sort)) return;
                                        var u = this._sort && this._sort.direction && this._sort.name == a ? this._sort.direction : "desc";
                                        u = "desc" == u ? "asc" : "desc", this._sort = {
                                            name: a,
                                            direction: u
                                        }, this.sort(l, "desc" == u)
                                    }
                                } else e.$services.getService("mouseEvents").callHandler("click", "gantt_add", t.$grid, [i, o.root_id])
                            }
                        }, e), t.$grid), this._mouseDelegates.delegate("click", "gantt_add", e.bind(function(i, n, r) {
                            if (!t.$getConfig().readonly) return this.createTask({}, n || e.config.root_id), !1
                        }, e), t.$grid)
                    },
                    clearEvents: function(t, e) {
                        this._mouseDelegates.destructor(), this._mouseDelegates = null
                    },
                    extendDom: function(e) {
                        t.$grid = e.$grid, t.$grid_scale = e.$grid_scale, t.$grid_data = e.$grid_data
                    },
                    extendGantt: function(e) {
                        t.getGridColumns = t.bind(e.getGridColumns, e), e.attachEvent("onColumnResizeStart", function() {
                            return t.callEvent("onColumnResizeStart", arguments)
                        }), e.attachEvent("onColumnResize", function() {
                            return t.callEvent("onColumnResize", arguments)
                        }), e.attachEvent("onColumnResizeEnd", function() {
                            return t.callEvent("onColumnResizeEnd", arguments)
                        }), e.attachEvent("onColumnResizeComplete", function(e, i) {
                            t.config.grid_width = i
                        })
                    }
                }
            };
        t.exports = o
    }, function(t, e, i) {
        var n = i(2),
            r = i(40);
        t.exports = function(t) {
            return {
                render: function(e, i, r) {
                    var a = i.getGridColumns(),
                        o = i.$getConfig(),
                        s = i.$getTemplates(),
                        l = i.$config.rowStore;
                    o.rtl && (a = a.reverse());
                    for (var c = [], u = 0; u < a.length; u++) {
                        var d, h, f, _ = u == a.length - 1,
                            g = a[u];
                        "add" == g.name ? (h = "<div " + (b = t._waiAria.gridAddButtonAttrString(g)) + " class='gantt_add'></div>", f = "") : (h = g.template ? g.template(e) : e[g.name], n.isDate(h) && (h = s.date_grid(h, e, g.name)), null !== h && void 0 !== h || (h = ""), f = h, h = "<div class='gantt_tree_content'>" + h + "</div>");
                        var p = "gantt_cell" + (_ ? " gantt_last_cell" : ""),
                            v = [];
                        if (g.tree) {
                            for (var m = 0; m < e.$level; m++) v.push(s.grid_indent(e));
                            !l.hasChild(e.id) || t.isSplitTask(e) && !t.config.open_split_tasks ? (v.push(s.grid_blank(e)), v.push(s.grid_file(e))) : (v.push(s.grid_open(e)), v.push(s.grid_folder(e)))
                        }
                        var y = "width:" + (g.width - (_ ? 1 : 0)) + "px;";
                        this.defined(g.align) && (y += "text-align:" + g.align + ";");
                        var b = t._waiAria.gridCellAttrString(g, f);
                        v.push(h), o.rtl && (v = v.reverse()), d = "<div class='" + p + "' data-column-index='" + u + "' data-column-name='" + g.name + "' style='" + y + "' " + b + ">" + v.join("") + "</div>", c.push(d)
                    }
                    if (p = t.getGlobalTaskIndex(e.id) % 2 == 0 ? "" : " odd", p += e.$transparent ? " gantt_transparent" : "", p += e.$dataprocessor_class ? " " + e.$dataprocessor_class : "", s.grid_row_class) {
                        var k = s.grid_row_class.call(t, e.start_date, e.end_date, e);
                        k && (p += " " + k)
                    }
                    l.isSelected(e.id) && (p += " gantt_selected");
                    var w = document.createElement("div");
                    w.className = "gantt_row" + p + " gantt_row_" + t.getTaskType(e.type);
                    var x = i.getItemHeight();
                    return w.style.height = x + "px", w.style.lineHeight = x + "px", o.smart_rendering && (w.style.position = "absolute", w.style.left = "0px", w.style.top = i.getItemTop(e.id) + "px"), i.$config.item_attribute && w.setAttribute(i.$config.item_attribute, e.id), t._waiAria.taskRowAttr(e, w), w.innerHTML = c.join(""), w
                },
                update: null,
                getRectangle: r
            }
        }
    }, function(t, e, i) {
        var n = i(14);
        t.exports = function(t, e, i) {
            if (!i.isTaskExists(t.source)) return null;
            if (!i.isTaskExists(t.target)) return null;
            var r = n(i.getTask(t.source), e, i),
                a = n(i.getTask(t.target), e, i);
            if (!r || !a) return null;
            var o = Math.min(r.left, a.left) - 100,
                s = Math.max(r.left + r.width, a.left + a.width) + 100,
                l = Math.min(r.top, a.top) - 100;
            return {
                top: l,
                height: Math.min(r.top + r.height, a.top + a.height) + 100 - l,
                left: o,
                width: s - o
            }
        }
    }, function(t, e, i) {
        var n = i(127);
        t.exports = function(t) {
            var e = {
                    current_pos: null,
                    dirs: {
                        left: "left",
                        right: "right",
                        up: "up",
                        down: "down"
                    },
                    path: [],
                    clear: function() {
                        this.current_pos = null, this.path = []
                    },
                    point: function(e) {
                        this.current_pos = t.copy(e)
                    },
                    get_lines: function(t) {
                        this.clear(), this.point(t[0]);
                        for (var e = 1; e < t.length; e++) this.line_to(t[e]);
                        return this.get_path()
                    },
                    line_to: function(e) {
                        var i = t.copy(e),
                            n = this.current_pos,
                            r = this._get_line(n, i);
                        this.path.push(r), this.current_pos = i
                    },
                    get_path: function() {
                        return this.path
                    },
                    get_wrapper_sizes: function(t, e) {
                        var i, n = e.$getConfig(),
                            r = n.link_wrapper_width,
                            a = t.y + (n.row_height - r) / 2;
                        switch (t.direction) {
                            case this.dirs.left:
                                i = {
                                    top: a,
                                    height: r,
                                    lineHeight: r,
                                    left: t.x - t.size - r / 2,
                                    width: t.size + r
                                };
                                break;
                            case this.dirs.right:
                                i = {
                                    top: a,
                                    lineHeight: r,
                                    height: r,
                                    left: t.x - r / 2,
                                    width: t.size + r
                                };
                                break;
                            case this.dirs.up:
                                i = {
                                    top: a - t.size,
                                    lineHeight: t.size + r,
                                    height: t.size + r,
                                    left: t.x - r / 2,
                                    width: r
                                };
                                break;
                            case this.dirs.down:
                                i = {
                                    top: a,
                                    lineHeight: t.size + r,
                                    height: t.size + r,
                                    left: t.x - r / 2,
                                    width: r
                                }
                        }
                        return i
                    },
                    get_line_sizes: function(t, e) {
                        var i, n = e.$getConfig(),
                            r = n.link_line_width,
                            a = n.link_wrapper_width,
                            o = t.size + r;
                        switch (t.direction) {
                            case this.dirs.left:
                            case this.dirs.right:
                                i = {
                                    height: r,
                                    width: o,
                                    marginTop: (a - r) / 2,
                                    marginLeft: (a - r) / 2
                                };
                                break;
                            case this.dirs.up:
                            case this.dirs.down:
                                i = {
                                    height: o,
                                    width: r,
                                    marginTop: (a - r) / 2,
                                    marginLeft: (a - r) / 2
                                }
                        }
                        return i
                    },
                    render_line: function(t, e, i) {
                        var n = this.get_wrapper_sizes(t, i),
                            r = document.createElement("div");
                        r.style.cssText = ["top:" + n.top + "px", "left:" + n.left + "px", "height:" + n.height + "px", "width:" + n.width + "px"].join(";"), r.className = "gantt_line_wrapper";
                        var a = this.get_line_sizes(t, i),
                            o = document.createElement("div");
                        return o.style.cssText = ["height:" + a.height + "px", "width:" + a.width + "px", "margin-top:" + a.marginTop + "px", "margin-left:" + a.marginLeft + "px"].join(";"), o.className = "gantt_link_line_" + t.direction, r.appendChild(o), r
                    },
                    _get_line: function(t, e) {
                        var i = this.get_direction(t, e),
                            n = {
                                x: t.x,
                                y: t.y,
                                direction: this.get_direction(t, e)
                            };
                        return i == this.dirs.left || i == this.dirs.right ? n.size = Math.abs(t.x - e.x) : n.size = Math.abs(t.y - e.y), n
                    },
                    get_direction: function(t, e) {
                        return e.x < t.x ? this.dirs.left : e.x > t.x ? this.dirs.right : e.y > t.y ? this.dirs.down : this.dirs.up
                    }
                },
                i = {
                    path: [],
                    clear: function() {
                        this.path = []
                    },
                    current: function() {
                        return this.path[this.path.length - 1]
                    },
                    point: function(e) {
                        return e ? (this.path.push(t.copy(e)), e) : this.current()
                    },
                    point_to: function(i, n, r) {
                        r = r ? {
                            x: r.x,
                            y: r.y
                        } : t.copy(this.point());
                        var a = e.dirs;
                        switch (i) {
                            case a.left:
                                r.x -= n;
                                break;
                            case a.right:
                                r.x += n;
                                break;
                            case a.up:
                                r.y -= n;
                                break;
                            case a.down:
                                r.y += n
                        }
                        return this.point(r)
                    },
                    get_points: function(i, n) {
                        var r = this.get_endpoint(i, n),
                            a = t.config,
                            o = r.e_y - r.y,
                            s = r.e_x - r.x,
                            l = e.dirs;
                        this.clear(), this.point({
                            x: r.x,
                            y: r.y
                        });
                        var c = 2 * a.link_arrow_size,
                            u = this.get_line_type(i, n.$getConfig()),
                            d = r.e_x > r.x;
                        if (u.from_start && u.to_start) this.point_to(l.left, c), d ? (this.point_to(l.down, o), this.point_to(l.right, s)) : (this.point_to(l.right, s), this.point_to(l.down, o)), this.point_to(l.right, c);
                        else if (!u.from_start && u.to_start)
                            if (d = r.e_x > r.x + 2 * c, this.point_to(l.right, c), d) s -= c, this.point_to(l.down, o), this.point_to(l.right, s);
                            else {
                                s -= 2 * c;
                                var h = o > 0 ? 1 : -1;
                                this.point_to(l.down, h * (a.row_height / 2)), this.point_to(l.right, s), this.point_to(l.down, h * (Math.abs(o) - a.row_height / 2)), this.point_to(l.right, c)
                            } else u.from_start || u.to_start ? u.from_start && !u.to_start && (d = r.e_x > r.x - 2 * c, this.point_to(l.left, c), d ? (s += 2 * c, h = o > 0 ? 1 : -1, this.point_to(l.down, h * (a.row_height / 2)), this.point_to(l.right, s), this.point_to(l.down, h * (Math.abs(o) - a.row_height / 2)), this.point_to(l.left, c)) : (s += c, this.point_to(l.down, o), this.point_to(l.right, s))) : (this.point_to(l.right, c), d ? (this.point_to(l.right, s), this.point_to(l.down, o)) : (this.point_to(l.down, o), this.point_to(l.right, s)), this.point_to(l.left, c));
                        return this.path
                    },
                    get_line_type: function(e, i) {
                        var n = i.links,
                            r = !1,
                            a = !1;
                        return e.type == n.start_to_start ? r = a = !0 : e.type == n.finish_to_finish ? r = a = !1 : e.type == n.finish_to_start ? (r = !1, a = !0) : e.type == n.start_to_finish ? (r = !0, a = !1) : t.assert(!1, "Invalid link type"), i.rtl && (r = !r, a = !a), {
                            from_start: r,
                            to_start: a
                        }
                    },
                    get_endpoint: function(e, i) {
                        var n = i.$getConfig(),
                            a = this.get_line_type(e, n),
                            o = a.from_start,
                            s = a.to_start,
                            l = t.getTask(e.source),
                            c = t.getTask(e.target),
                            u = r(l, i),
                            d = r(c, i);
                        return {
                            x: o ? u.left : u.left + u.width,
                            e_x: s ? d.left : d.left + d.width,
                            y: u.top,
                            e_y: d.top
                        }
                    }
                };

            function r(e, i) {
                var n = i.$getConfig(),
                    r = i.getItemPosition(e);
                if (t.getTaskType(e.type) == n.types.milestone) {
                    var a = t.getTaskHeight(),
                        o = Math.sqrt(2 * a * a);
                    r.left -= o / 2, r.width = o
                }
                return r
            }
            return {
                render: function(n, r) {
                    var a = r.$getConfig(),
                        o = i.get_endpoint(n, r),
                        s = o.e_y - o.y;
                    if (!(o.e_x - o.x || s)) return null;
                    var l = i.get_points(n, r),
                        c = e.get_lines(l, r),
                        u = document.createElement("div"),
                        d = "gantt_task_link";
                    n.color && (d += " gantt_link_inline_color");
                    var h = t.templates.link_class ? t.templates.link_class(n) : "";
                    h && (d += " " + h), a.highlight_critical_path && t.isCriticalLink && t.isCriticalLink(n) && (d += " gantt_critical_link"), u.className = d, r.$config.link_attribute && u.setAttribute(r.$config.link_attribute, n.id);
                    for (var f = 0; f < c.length; f++) {
                        f == c.length - 1 && (c[f].size -= a.link_arrow_size);
                        var _ = e.render_line(c[f], c[f + 1], r);
                        n.color && (_.firstChild.style.backgroundColor = n.color), u.appendChild(_)
                    }
                    var g = c[c.length - 1].direction,
                        p = function(t, i, n) {
                            var r = n.$getConfig(),
                                a = document.createElement("div"),
                                o = t.y,
                                s = t.x,
                                l = r.link_arrow_size,
                                c = r.row_height,
                                u = "gantt_link_arrow gantt_link_arrow_" + i;
                            switch (i) {
                                case e.dirs.right:
                                    o -= (l - c) / 2, s -= l;
                                    break;
                                case e.dirs.left:
                                    o -= (l - c) / 2;
                                    break;
                                case e.dirs.up:
                                    s -= l;
                                    break;
                                case e.dirs.down:
                                    o += 2 * l, s -= l
                            }
                            return a.style.cssText = ["top:" + o + "px", "left:" + s + "px"].join(";"), a.className = u, a
                        }(l[l.length - 1], g, r);
                    return n.color && (p.style.borderColor = n.color), u.appendChild(p), t._waiAria.linkAttr(n, u), u
                },
                update: null,
                getRectangle: n
            }
        }
    }, function(t, e, i) {
        var n = i(32),
            r = i(18);

        function a(t, e, i) {
            for (var n = 0, r = t.left.length - 1, a = 0; a < t.left.length; a++) {
                var o = t.left[a];
                if (o < e && (n = a), o > i) {
                    r = a;
                    break
                }
            }
            return {
                start: n,
                end: r
            }
        }
        t.exports = function(t) {
            var e = {},
                i = {};

            function o(t, i) {
                return !(!e[t.id][i] || !e[t.id][i].parentNode)
            }

            function s(t, i) {
                e[t] && e[t][i] && e[t][i].parentNode && e[t][i].parentNode.removeChild(e[t][i])
            }

            function l(t) {
                var e, i = t.$getTemplates();
                return void 0 !== i.task_cell_class ? (e = i.task_cell_class, (console.warn || console.log)("gantt.templates.task_cell_class template is deprecated and will be removed soon. Please use gantt.templates.timeline_cell_class instead.")) : e = i.timeline_cell_class, e
            }

            function c(n, a, o, s, l, c, u) {
                var d = n.width[a],
                    h = "";
                if (function(e, i, n) {
                        var a = i.width[e];
                        if (a <= 0) return !1;
                        if (!t.config.smart_rendering || r(t)) return !0;
                        var o = i.left[e] - a,
                            s = i.left[e] + a;
                        return o <= n.x_end && s >= n.x
                    }(a, n, s)) {
                    var f = c(o, n.trace_x[a]);
                    if (u.static_background && (!u.static_background_cells || !f)) return null;
                    if (e[o.id][a]) return i[o.id][a] = a, e[o.id][a];
                    var _ = document.createElement("div");
                    return _.style.width = d + "px", h = "gantt_task_cell" + (a == l - 1 ? " gantt_last_cell" : ""), f && (h += " " + f), _.className = h, t.config.smart_rendering && (_.style.position = "absolute", _.style.left = n.left[a] + "px", e[o.id][a] = _, i[o.id][a] = a), _
                }
                return null
            }
            return {
                render: function(n, o, s) {
                    var u = o.$getConfig(),
                        d = o.$getTemplates(),
                        h = o.getScale(),
                        f = h.count;
                    if (u.static_background && !u.static_background_cells) return null;
                    var _, g = document.createElement("div"),
                        p = l(o);
                    if (_ = s && u.smart_rendering && !r(t) ? a(h, s.x, s.x_end) : {
                            start: 0,
                            end: f - 1
                        }, u.show_task_cells) {
                        e[n.id] = {}, i[n.id] = {};
                        for (var v = _.start; v <= _.end; v++) {
                            var m = c(h, v, n, s, f, p, u);
                            m && g.appendChild(m)
                        }
                    }
                    var y = t.getGlobalTaskIndex(n.id) % 2 != 0,
                        b = d.task_row_class(n.start_date, n.end_date, n),
                        k = "gantt_task_row" + (y ? " odd" : "") + (b ? " " + b : "");
                    return o.$config.rowStore.isSelected(n.id) && (k += " gantt_selected"), g.className = k, u.smart_rendering && (g.style.position = "absolute", g.style.top = o.getItemTop(n.id) + "px", g.style.width = "100%"), g.style.height = u.row_height + "px", o.$config.item_attribute && g.setAttribute(o.$config.item_attribute, n.id), g
                },
                update: function(t, n, r, u) {
                    var d = r.$getConfig(),
                        h = r.getScale(),
                        f = h.count,
                        _ = l(r);
                    if (d.show_task_cells) {
                        e[t.id] || (e[t.id] = {}), i[t.id] || (i[t.id] = {});
                        var g = a(h, u.x, u.x_end);
                        for (var p in i[t.id]) {
                            var v = i[t.id][p];
                            (Number(v) < g.start || Number(v) > g.end) && s(t.id, v)
                        }
                        i[t.id] = {};
                        for (var m = g.start; m <= g.end; m++) {
                            var y = c(h, m, t, u, f, _, d);
                            !y && o(t, m) ? s(t.id, m) : y && !y.parentNode && n.appendChild(y)
                        }
                    }
                },
                getRectangle: n
            }
        }
    }, function(t, e, i) {
        var n = i(14),
            r = i(33);
        t.exports = function(t) {
            var e = r(t);
            return {
                render: function(i, n) {
                    if (t.isSplitTask(i) && (t.config.open_split_tasks && !i.$open || !t.config.open_split_tasks)) {
                        for (var r = document.createElement("div"), a = t.getTaskPosition(i), o = t.getChildren(i.id), s = 0; s < o.length; s++) {
                            var l = t.getTask(o[s]),
                                c = e(l, n);
                            if (c) {
                                var u = Math.floor((t.config.row_height - a.height) / 2);
                                c.style.top = a.top + u + "px", c.className += " gantt_split_child", r.appendChild(c)
                            }
                        }
                        return r
                    }
                    return !1
                },
                update: null,
                getRectangle: n
            }
        }
    }, function(t, e, i) {
        var n = i(14),
            r = i(33);
        t.exports = function(t) {
            return {
                render: r(t),
                update: null,
                getRectangle: n
            }
        }
    }, function(t, e) {
        t.exports = function(t) {
            return function(e, i, n) {
                "keepDates" == n ? function(e, i) {
                    "duration" == i ? e.end_date = t.calculateEndDate(e) : "end_date" != i && "start_date" != i || (e.duration = t.calculateDuration(e))
                }(e, i) : "keepDuration" == n ? function(e, i) {
                    "end_date" == i ? e.start_date = t.calculateEndDate({
                        start_date: e.end_date,
                        duration: -e.duration,
                        task: e
                    }) : "start_date" != i && "duration" != i || (e.end_date = t.calculateEndDate(e))
                }(e, i) : function(e, i) {
                    "start_date" == i || "duration" == i ? e.end_date = t.calculateEndDate(e) : "end_date" == i && (e.duration = t.calculateDuration(e))
                }(e, i)
            }
        }
    }, function(t, e, i) {
        t.exports = function(t) {
            var e = i(6)(t),
                n = i(0);

            function r() {
                return e.apply(this, arguments) || this
            }

            function a(e) {
                return e.formatter || t.ext.formatters.durationFormatter()
            }
            return i(3)(r, e), n.mixin(r.prototype, {
                show: function(t, e, i, n) {
                    var r = "<div><input type='text' name='" + e.name + "'></div>";
                    n.innerHTML = r
                },
                set_value: function(t, e, i, n) {
                    this.get_input(n).value = a(i.editor).format(t)
                },
                get_value: function(t, e, i) {
                    return a(e.editor).parse(this.get_input(i).value || "")
                }
            }, !0), r
        }
    }, function(t, e, i) {
        t.exports = function(t) {
            var e = i(6)(t),
                n = i(0);

            function r() {
                return e.apply(this, arguments) || this
            }

            function a(e) {
                return e.formatter || t.ext.formatters.linkFormatter()
            }

            function o(t, e) {
                for (var i = (t || "").split(e.delimiter || ","), n = 0; n < i.length; n++) {
                    var r = i[n].trim();
                    r ? i[n] = r : (i.splice(n, 1), n--)
                }
                return i.sort(), i
            }

            function s(t, e, i) {
                for (var n = t.$target, r = [], o = 0; o < n.length; o++) {
                    var s = i.getLink(n[o]);
                    r.push(a(e).format(s))
                }
                return r.join((e.delimiter || ",") + " ")
            }

            function l(t) {
                return t.source + "_" + t.target + "_" + t.type + "_" + (t.lag || 0)
            }

            function c(e, i, n) {
                var r = function(e, i, n) {
                        var r = [];
                        return i.forEach(function(i) {
                            var o = a(n).parse(i);
                            o && (o.target = e, t.isLinkAllowed(o) && r.push(o))
                        }), r
                    }(e.id, i, n),
                    o = {};
                e.$target.forEach(function(e) {
                    var i = t.getLink(e);
                    o[l(i)] = i.id
                });
                var s = [];
                r.forEach(function(t) {
                    var e = l(t);
                    o[e] ? delete o[e] : s.push(t)
                });
                var c = [];
                for (var u in o) c.push(o[u]);
                return {
                    add: s,
                    remove: c
                }
            }
            return i(3)(r, e), n.mixin(r.prototype, {
                show: function(t, e, i, n) {
                    var r = "<div><input type='text' name='" + e.name + "'></div>";
                    n.innerHTML = r
                },
                hide: function() {},
                set_value: function(e, i, n, r) {
                    this.get_input(r).value = s(e, n.editor, t)
                },
                get_value: function(t, e, i) {
                    return o(this.get_input(i).value || "", e.editor)
                },
                save: function(e, i, n) {
                    var r = c(t.getTask(e), this.get_value(e, i, n), i.editor);
                    (r.add.length || r.remove.length) && t.batchUpdate(function() {
                        r.add.forEach(function(e) {
                            t.addLink(e)
                        }), r.remove.forEach(function(e) {
                            t.deleteLink(e)
                        }), t.autoSchedule && t.autoSchedule()
                    })
                },
                is_changed: function(e, i, n, r) {
                    var a = this.get_value(i, n, r),
                        l = o(s(e, n.editor, t), n.editor);
                    return a.join() !== l.join()
                }
            }, !0), r
        }
    }, function(t, e, i) {
        t.exports = function(t) {
            var e = i(6)(t),
                n = i(0),
                r = "%Y-%m-%d",
                a = null,
                o = null;

            function s() {
                return e.apply(this, arguments) || this
            }
            return i(3)(s, e), n.mixin(s.prototype, {
                show: function(e, i, n, s) {
                    a || (a = t.date.date_to_str(r)), o || (o = t.date.str_to_date(r));
                    var l = null,
                        c = null;
                    l = "function" == typeof n.min ? n.min(e, i) : n.min, c = "function" == typeof n.max ? n.max(e, i) : n.max;
                    var u = "<div style='width:140px'><input type='date' " + (l ? " min='" + a(l) + "' " : "") + (c ? " max='" + a(c) + "' " : "") + " name='" + i.name + "'></div>";
                    s.innerHTML = u
                },
                set_value: function(t, e, i, n) {
                    t && t.getFullYear ? this.get_input(n).value = a(t) : this.get_input(n).value = t
                },
                is_valid: function(t, e, i, n) {
                    return !(!t || isNaN(t.getTime()))
                },
                get_value: function(t, e, i) {
                    var n;
                    try {
                        n = o(this.get_input(i).value || "")
                    } catch (t) {
                        n = null
                    }
                    return n
                }
            }, !0), s
        }
    }, function(t, e, i) {
        t.exports = function(t) {
            var e = i(6)(t),
                n = i(0);

            function r() {
                return e.apply(this, arguments) || this
            }
            return i(3)(r, e), n.mixin(r.prototype, {
                show: function(t, e, i, n) {
                    for (var r = "<div><select name='" + e.name + "'>", a = [], o = i.options || [], s = 0; s < o.length; s++) a.push("<option value='" + i.options[s].key + "'>" + o[s].label + "</option>");
                    r += a.join("") + "</select></div>", n.innerHTML = r
                },
                get_input: function(t) {
                    return t.querySelector("select")
                }
            }, !0), r
        }
    }, function(t, e, i) {
        t.exports = function(t) {
            var e = i(6)(t),
                n = i(0);

            function r() {
                return e.apply(this, arguments) || this
            }
            return i(3)(r, e), n.mixin(r.prototype, {
                show: function(t, e, i, n) {
                    var r = "<div><input type='number' min='" + (i.min || 0) + "' max='" + (i.max || 100) + "' name='" + e.name + "'></div>";
                    n.innerHTML = r
                },
                get_value: function(t, e, i) {
                    return this.get_input(i).value || ""
                },
                is_valid: function(t, e, i, n) {
                    return !isNaN(parseInt(t, 10))
                }
            }, !0), r
        }
    }, function(t, e, i) {
        t.exports = function(t) {
            var e = i(6)(t),
                n = i(0);

            function r() {
                return e.apply(this, arguments) || this
            }
            return i(3)(r, e), n.mixin(r.prototype, {
                show: function(t, e, i, n) {
                    var r = "<div><input type='text' name='" + e.name + "'></div>";
                    n.innerHTML = r
                }
            }, !0), r
        }
    }, function(t, e) {
        t.exports = {
            init: function(t, e) {
                var i = t,
                    n = e.$gantt,
                    r = null,
                    a = n.ext.keyboardNavigation;
                a.attachEvent("onBeforeFocus", function(e) {
                    var n = t.locateCell(e);
                    if (clearTimeout(r), n) {
                        var a = n.columnName,
                            o = n.id,
                            s = i.getState();
                        if (i.isVisible() && s.id == o && s.columnName === a) return !1
                    }
                    return !0
                }), a.attachEvent("onFocus", function(e) {
                    var n = t.locateCell(e),
                        a = t.getState();
                    return clearTimeout(r), !n || n.id == a.id && n.columnName == a.columnName || i.isVisible() && i.save(), !0
                }), t.attachEvent("onHide", function() {
                    clearTimeout(r)
                }), a.attachEvent("onBlur", function() {
                    return r = setTimeout(function() {
                        i.save()
                    }), !0
                }), n.attachEvent("onTaskDblClick", function(e, i) {
                    var n = t.getState(),
                        r = t.locateCell(i.target);
                    return !r || !t.isVisible() || r.columnName != n.columnName
                }), n.attachEvent("onTaskClick", function(e, i) {
                    if (n._is_icon_open_click(i)) return !0;
                    var r = t.getState(),
                        a = t.locateCell(i.target);
                    return !a || !t.getEditorConfig(a.columnName) || (t.isVisible() && r.id == a.id && r.columnName == a.columnName || t.startEdit(a.id, a.columnName), !1)
                }), n.attachEvent("onEmptyClick", function() {
                    return i.save(), !0
                }), a.attachEvent("onKeyDown", function(e, r) {
                    var o = t.locateCell(r.target),
                        s = !!o && t.getEditorConfig(o.columnName),
                        l = t.getState(),
                        c = n.constants.KEY_CODES,
                        u = r.keyCode,
                        d = !1;
                    switch (u) {
                        case c.ENTER:
                            t.isVisible() ? (t.save(), r.preventDefault(), d = !0) : s && !(r.ctrlKey || r.metaKey || r.shiftKey) && (i.startEdit(o.id, o.columnName), r.preventDefault(), d = !0);
                            break;
                        case c.ESC:
                            t.isVisible() && (t.hide(), r.preventDefault(), d = !0);
                            break;
                        case c.UP:
                        case c.DOWN:
                            break;
                        case c.LEFT:
                        case c.RIGHT:
                            (s && t.isVisible() || "date" === l.editorType) && (d = !0);
                            break;
                        case c.SPACE:
                            t.isVisible() && (d = !0), s && !t.isVisible() && (i.startEdit(o.id, o.columnName), r.preventDefault(), d = !0);
                            break;
                        case c.DELETE:
                            s && !t.isVisible() ? (i.startEdit(o.id, o.columnName), d = !0) : s && t.isVisible() && (d = !0);
                            break;
                        case c.TAB:
                            if (t.isVisible()) {
                                r.shiftKey ? t.editPrevCell(!0) : t.editNextCell(!0);
                                var h = t.getState();
                                h.id && a.focus({
                                    type: "taskCell",
                                    id: h.id,
                                    column: h.columnName
                                }), r.preventDefault(), d = !0
                            }
                            break;
                        default:
                            if (t.isVisible()) d = !0;
                            else if (u >= 48 && u <= 57 || u > 95 && u < 112 || u >= 64 && u <= 91 || u > 185 && u < 193 || u > 218 && u < 223) {
                                var f = e.modifiers,
                                    _ = f.alt || f.ctrl || f.meta || f.shift;
                                f.alt || _ && a.getCommandHandler(e, "taskCell") || s && !t.isVisible() && (i.startEdit(o.id, o.columnName), d = !0)
                            }
                    }
                    return !d
                })
            },
            onShow: function(t, e, i) {},
            onHide: function(t, e, i) {
                i.$gantt.focus()
            },
            destroy: function() {}
        }
    }, function(t, e) {
        t.exports = {
            init: function(t, e) {
                var i = e.$gantt;
                i.attachEvent("onTaskClick", function(e, n) {
                    if (i._is_icon_open_click(n)) return !0;
                    var r = t.getState(),
                        a = t.locateCell(n.target);
                    return !a || !t.getEditorConfig(a.columnName) || (t.isVisible() && r.id == a.id && r.columnName == a.columnName || t.startEdit(a.id, a.columnName), !1)
                }), i.attachEvent("onEmptyClick", function() {
                    return t.isVisible() && t.isChanged() ? t.save() : t.hide(), !0
                }), i.attachEvent("onTaskDblClick", function(e, i) {
                    var n = t.getState(),
                        r = t.locateCell(i.target);
                    return !r || !t.isVisible() || r.columnName != n.columnName || (t.hide(), !1)
                })
            },
            onShow: function(t, e, i) {
                var n = i.$gantt;
                n.ext && n.ext.keyboardNavigation && n.ext.keyboardNavigation.attachEvent("onKeyDown", function(e, i) {
                    var r = n.constants.KEY_CODES,
                        a = !1;
                    switch (i.keyCode) {
                        case r.SPACE:
                            t.isVisible() && (a = !0)
                    }
                    return !a
                });
                e.onkeydown = function(e) {
                    e = e || window.event;
                    var i = n.constants.KEY_CODES;
                    if (!(e.defaultPrevented || e.shiftKey && e.keyCode != i.TAB)) {
                        var r = !0;
                        switch (e.keyCode) {
                            case n.keys.edit_save:
                                t.save();
                                break;
                            case n.keys.edit_cancel:
                                t.hide();
                                break;
                            case i.UP:
                            case i.DOWN:
                                t.isVisible() && (t.hide(), r = !1);
                                break;
                            case i.TAB:
                                e.shiftKey ? t.editPrevCell(!0) : t.editNextCell(!0);
                                break;
                            default:
                                r = !1
                        }
                        r && e.preventDefault()
                    }
                }
            },
            onHide: function() {},
            destroy: function() {}
        }
    }, function(t, e, i) {
        var n = i(140),
            r = i(139);
        t.exports = function(t) {
            var e = null;
            return {
                setMapping: function(t) {
                    e = t
                },
                getMapping: function() {
                    return e || (t.config.keyboard_navigation_cells ? r : n)
                }
            }
        }
    }, function(t, e, i) {
        var n = i(141),
            r = i(138),
            a = i(137),
            o = i(136),
            s = i(135),
            l = i(134),
            c = i(133),
            u = i(0),
            d = i(1),
            h = i(4),
            f = i(132);

        function _(t) {
            t.config.editor_types = {
                text: new(r(t)),
                number: new(a(t)),
                select: new(o(t)),
                date: new(s(t)),
                predecessor: new(l(t)),
                duration: new(c(t))
            }
        }
        t.exports = function(t) {
            var e = n(t),
                i = {};
            h(i);
            var r = {
                init: _,
                createEditors: function(n) {
                    function r(t, e) {
                        var i = function(t, e) {
                                for (var i = n.getItemTop(t), r = n.getItemHeight(t), a = n.getGridColumns(), o = 0, s = 0, l = 0; l < a.length; l++) {
                                    if (a[l].name == e) {
                                        s = a[l].width;
                                        break
                                    }
                                    o += a[l].width
                                }
                                return {
                                    top: i,
                                    left: o,
                                    height: r,
                                    width: s
                                }
                            }(t, e),
                            r = document.createElement("div");
                        r.className = "gantt_grid_editor_placeholder", r.setAttribute(n.$config.item_attribute, t), r.setAttribute("data-column-name", e);
                        var a = function(t, e) {
                            for (var i = t.getGridColumns(), n = 0; n < i.length; n++)
                                if (i[n].name == e) return n;
                            return 0
                        }(n, e);
                        return r.setAttribute("data-column-index", a), r.style.cssText = ["top:" + i.top + "px", "left:" + i.left + "px", "width:" + i.width + "px", "height:" + i.height + "px"].join(";"), r
                    }
                    var a = f(t),
                        o = [],
                        s = null,
                        l = {
                            _itemId: null,
                            _columnName: null,
                            _editor: null,
                            _editorType: null,
                            _placeholder: null,
                            locateCell: function(t) {
                                if (!d.isChildOf(t, n.$grid)) return null;
                                var e = d.locateAttribute(t, n.$config.item_attribute),
                                    i = d.locateAttribute(t, "data-column-name");
                                if (i) {
                                    var r = i.getAttribute("data-column-name");
                                    return {
                                        id: e.getAttribute(n.$config.item_attribute),
                                        columnName: r
                                    }
                                }
                                return null
                            },
                            getEditorConfig: function(t) {
                                return n.getColumn(t).editor
                            },
                            init: function() {
                                var t = e.getMapping();
                                t.init && t.init(this, n), s = n.$gantt.getDatastore(n.$config.bind);
                                var i = this;
                                o.push(s.attachEvent("onIdChange", function(t, e) {
                                    i._itemId == t && (i._itemId = e)
                                })), o.push(s.attachEvent("onStoreUpdated", function() {
                                    n.$gantt.getState("batchUpdate").batch_update || i.isVisible() && !s.isVisible(i._itemId) && i.hide()
                                })), this.init = function() {}
                            },
                            getState: function() {
                                return {
                                    editor: this._editor,
                                    editorType: this._editorType,
                                    placeholder: this._placeholder,
                                    id: this._itemId,
                                    columnName: this._columnName
                                }
                            },
                            startEdit: function(e, i) {
                                if (this.isVisible() && this.save(), s.exists(e)) {
                                    var n = {
                                        id: e,
                                        columnName: i
                                    };
                                    t.isReadonly(s.getItem(e)) ? this.callEvent("onEditPrevent", [n]) : !1 !== this.callEvent("onBeforeEditStart", [n]) ? (this.show(n.id, n.columnName), this.setValue(), this.callEvent("onEditStart", [n])) : this.callEvent("onEditPrevent", [n])
                                }
                            },
                            isVisible: function() {
                                return !(!this._editor || !d.isChildOf(this._placeholder, document.body))
                            },
                            show: function(t, i) {
                                this.isVisible() && this.save();
                                var a = {
                                        id: t,
                                        columnName: i
                                    },
                                    o = n.getColumn(a.columnName),
                                    s = this.getEditorConfig(o.name);
                                if (s) {
                                    var l = n.$getConfig().editor_types[s.type],
                                        c = r(a.id, a.columnName);
                                    n.$grid_data.appendChild(c), l.show(a.id, o, s, c), this._editor = l, this._placeholder = c, this._itemId = a.id, this._columnName = a.columnName, this._editorType = s.type;
                                    var u = e.getMapping();
                                    u.onShow && u.onShow(this, c, n)
                                }
                            },
                            setValue: function() {
                                var t = this.getState(),
                                    e = t.id,
                                    i = t.columnName,
                                    r = n.getColumn(i),
                                    a = s.getItem(e),
                                    o = this.getEditorConfig(i);
                                if (o) {
                                    var l = a[o.map_to];
                                    "auto" == o.map_to && (l = s.getItem(e)), this._editor.set_value(l, e, r, this._placeholder), this.focus()
                                }
                            },
                            focus: function() {
                                this._editor.focus(this._placeholder)
                            },
                            getValue: function() {
                                var t = n.getColumn(this._columnName);
                                return this._editor.get_value(this._itemId, t, this._placeholder)
                            },
                            _getItemValue: function() {
                                var e = this.getEditorConfig(this._columnName);
                                if (e) {
                                    var i = t.getTask(this._itemId)[e.map_to];
                                    return "auto" == e.map_to && (i = s.getItem(this._itemId)), i
                                }
                            },
                            isChanged: function() {
                                var t = n.getColumn(this._columnName),
                                    e = this._getItemValue();
                                return this._editor.is_changed(e, this._itemId, t, this._placeholder)
                            },
                            hide: function() {
                                if (this._itemId) {
                                    var t = this._itemId,
                                        i = this._columnName,
                                        r = e.getMapping();
                                    r.onHide && r.onHide(this, this._placeholder, n), this._itemId = null, this._columnName = null, this._editorType = null, this._placeholder && (this._editor && this._editor.hide(this._placeholder), this._editor = null, this._placeholder.parentNode && this._placeholder.parentNode.removeChild(this._placeholder), this._placeholder = null, this.callEvent("onEditEnd", [{
                                        id: t,
                                        columnName: i
                                    }]))
                                }
                            },
                            save: function() {
                                if (this.isVisible() && s.exists(this._itemId) && this.isChanged()) {
                                    var e = this._itemId,
                                        i = this._columnName;
                                    if (s.exists(e)) {
                                        var r = s.getItem(e),
                                            o = this.getEditorConfig(i),
                                            l = {
                                                id: e,
                                                columnName: i,
                                                newValue: this.getValue(),
                                                oldValue: this._getItemValue()
                                            };
                                        if (!1 !== this.callEvent("onBeforeSave", [l]) && this._editor.is_valid(l.newValue, l.id, l.columnName, this._placeholder)) {
                                            var c = o.map_to,
                                                u = l.newValue;
                                            "auto" != c ? (r[c] = u, a(r, c, t.config.inline_editors_date_processing), s.updateItem(e)) : this._editor.save(e, n.getColumn(i), this._placeholder), this.callEvent("onSave", [l])
                                        }
                                        this.hide()
                                    }
                                } else this.hide()
                            },
                            _findEditableCell: function(t, e) {
                                var i = t,
                                    r = n.getGridColumns()[i],
                                    a = r ? r.name : null;
                                if (a) {
                                    for (; a && !this.getEditorConfig(a);) a = this._findEditableCell(t + e, e);
                                    return a
                                }
                                return null
                            },
                            getNextCell: function(t) {
                                return this._findEditableCell(n.getColumnIndex(this._columnName) + t, t)
                            },
                            getFirstCell: function() {
                                return this._findEditableCell(0, 1)
                            },
                            getLastCell: function() {
                                return this._findEditableCell(n.getGridColumns().length - 1, -1)
                            },
                            editNextCell: function(t) {
                                var e = this.getNextCell(1);
                                if (e) {
                                    var i = this.getNextCell(1);
                                    i && this.getEditorConfig(i) && this.startEdit(this._itemId, i)
                                } else if (t && this.moveRow(1)) {
                                    var n = this.moveRow(1);
                                    (e = this.getFirstCell()) && this.getEditorConfig(e) && this.startEdit(n, e)
                                }
                            },
                            editPrevCell: function(t) {
                                var e = this.getNextCell(-1);
                                if (e) {
                                    var i = this.getNextCell(-1);
                                    i && this.getEditorConfig(i) && this.startEdit(this._itemId, i)
                                } else if (t && this.moveRow(-1)) {
                                    var n = this.moveRow(-1);
                                    (e = this.getLastCell()) && this.getEditorConfig(e) && this.startEdit(n, e)
                                }
                            },
                            moveRow: function(e) {
                                for (var i = e > 0 ? t.getNext : t.getPrev, n = (i = t.bind(i, t))(this._itemId); t.isTaskExists(n) && t.isReadonly(t.getTask(n));) n = i(n);
                                return n
                            },
                            editNextRow: function() {
                                var t = this.getNextCell(1);
                                t && this.startEdit(t, this._columnName)
                            },
                            editPrevRow: function() {
                                var t = this.getNextCell(-1);
                                t && this.startEdit(t, this._columnName)
                            },
                            destructor: function() {
                                o.forEach(function(t) {
                                    s.detachEvent(t)
                                }), s = null, this.hide(), this.detachAllEvents()
                            }
                        };
                    return u.mixin(l, e), u.mixin(l, i), l
                }
            };
            return u.mixin(r, e), u.mixin(r, i), r
        }
    }, function(t, e, i) {
        var n = i(0),
            r = i(34),
            a = i(15),
            o = i(3),
            s = function(t) {
                function e(e, i, n, r) {
                    var a = t.apply(this, arguments) || this;
                    return a.$config.bindLinks = null, a
                }
                return o(e, t), n.mixin(e.prototype, {
                    _createLayerConfig: function() {
                        var t = this,
                            e = function() {
                                return t.isVisible()
                            };
                        return {
                            tasks: [{
                                renderer: this.$gantt.$ui.layers.resourceHistogram(),
                                container: this.$task_bars,
                                filter: [e]
                            }, {
                                renderer: this.$gantt.$ui.layers.taskBg(),
                                container: this.$task_bg,
                                filter: [e]
                            }],
                            links: []
                        }
                    }
                }, !0), n.mixin(e.prototype, a(t), !0), e
            }(r);
        t.exports = s
    }, function(t, e, i) {
        var n = i(1),
            r = i(0),
            a = i(15),
            o = i(17),
            s = i(3),
            l = function(t) {
                function e(e, i, n, r) {
                    return t.apply(this, arguments) || this
                }
                return s(e, t), r.mixin(e.prototype, {
                    init: function() {
                        void 0 === this.$config.bind && (this.$config.bind = this.$getConfig().resource_store), t.prototype.init.apply(this, arguments)
                    },
                    _initEvents: function() {
                        var e = this.$gantt;
                        t.prototype._initEvents.apply(this, arguments), this._mouseDelegates.delegate("click", "gantt_row", e.bind(function(t, e, i) {
                            var r = this.$config.rowStore;
                            if (!r) return !0;
                            var a = n.locateAttribute(t, this.$config.item_attribute);
                            return a && r.select(a.getAttribute(this.$config.item_attribute)), !1
                        }, this), this.$grid)
                    }
                }, !0), r.mixin(e.prototype, a(e), !0), e
            }(o);
        t.exports = l
    }, function(t, e, i) {
        var n = i(1);
        t.exports = function(t, e) {
            var i = {
                column_before_start: t.bind(function(t, i, r) {
                    var a = e.$getConfig();
                    if (!n.locateAttribute(r, a.grid_resizer_column_attribute)) return !1;
                    var o = this.locate(r, a.grid_resizer_column_attribute),
                        s = e.getGridColumns()[o];
                    return !1 !== e.callEvent("onColumnResizeStart", [o, s]) && void 0
                }, t),
                column_after_start: t.bind(function(t, i, n) {
                    var r = e.$getConfig(),
                        a = this.locate(n, r.grid_resizer_column_attribute);
                    t.config.marker.innerHTML = "", t.config.marker.className += " gantt_grid_resize_area", t.config.marker.style.height = e.$grid.offsetHeight + "px", t.config.marker.style.top = "0px", t.config.drag_index = a
                }, t),
                column_drag_move: t.bind(function(i, r, a) {
                    var o = e.$getConfig(),
                        s = i.config,
                        l = e.getGridColumns(),
                        c = parseInt(s.drag_index, 10),
                        u = l[c],
                        d = n.getNodePosition(e.$grid_scale),
                        h = parseInt(s.marker.style.left, 10),
                        f = u.min_width ? u.min_width : o.min_grid_column_width,
                        _ = e.$grid_data.offsetWidth,
                        g = 0,
                        p = 0;
                    o.rtl ? h = d.x + d.width - 1 - h : h -= d.x - 1;
                    for (var v = 0; v < c; v++) f += l[v].width, g += l[v].width;
                    if (h < f && (h = f), o.keep_grid_width) {
                        var m = 0;
                        for (v = c + 1; v < l.length; v++) l[v].min_width ? _ -= l[v].min_width : o.min_grid_column_width && (_ -= o.min_grid_column_width), l[v].max_width && !1 !== m ? m += l[v].max_width : m = !1;
                        m && (f = e.$grid_data.offsetWidth - m), h < f && (h = f), h > _ && (h = _)
                    } else if (!e.$config.scrollable) {
                        var y = h,
                            b = 0;
                        for (v = c + 1; v < l.length; v++) b += l[v].width;
                        y + b > t.$container.offsetWidth && (h = t.$container.offsetWidth - b)
                    }
                    return s.left = h - 1, p = Math.abs(h - g), u.max_width && p > u.max_width && (p = u.max_width), o.rtl && (g = d.width - g + 2 - p), s.marker.style.top = d.y + "px", s.marker.style.left = d.x - 1 + g + "px", s.marker.style.width = p + "px", e.callEvent("onColumnResize", [c, l[c], p - 1]), !0
                }, t),
                column_drag_end: t.bind(function(i, n, r) {
                    for (var a = e.$getConfig(), o = e.getGridColumns(), s = 0, l = parseInt(i.config.drag_index, 10), c = o[l], u = 0; u < l; u++) s += o[u].width;
                    var d = c.min_width && i.config.left - s < c.min_width ? c.min_width : i.config.left - s;
                    if (c.max_width && c.max_width < d && (d = c.max_width), !1 !== e.callEvent("onColumnResizeEnd", [l, c, d]) && c.width != d) {
                        if (c.width = d, a.keep_grid_width) s = a.grid_width;
                        else {
                            u = l;
                            for (var h = o.length; u < h; u++) s += o[u].width
                        }
                        e.callEvent("onColumnResizeComplete", [o, e._setColumnsWidth(s, l)]), e.$config.scrollable || t.$layout._syncCellSizes(e.$config.group, a.grid_width), this.render()
                    }
                }, t)
            };
            return {
                init: function() {
                    var n = t.$services.getService("dnd"),
                        r = e.$getConfig(),
                        a = new n(e.$grid_scale, {
                            updates_per_second: 60
                        });
                    t.defined(r.dnd_sensitivity) && (a.config.sensitivity = r.dnd_sensitivity), a.attachEvent("onBeforeDragStart", function(t, e) {
                        return i.column_before_start(a, t, e)
                    }), a.attachEvent("onAfterDragStart", function(t, e) {
                        return i.column_after_start(a, t, e)
                    }), a.attachEvent("onDragMove", function(t, e) {
                        return i.column_drag_move(a, t, e)
                    }), a.attachEvent("onDragEnd", function(t, e) {
                        return i.column_drag_end(a, t, e)
                    })
                },
                doOnRender: function() {
                    for (var i = e.getGridColumns(), n = e.$getConfig(), r = 0, a = e.$config.width, o = n.scale_height, s = 0; s < i.length; s++) {
                        var l, c = i[s];
                        if (r += c.width, l = n.rtl ? a - r : r, c.resize) {
                            var u = document.createElement("div");
                            u.className = "gantt_grid_column_resize_wrap", u.style.top = "0px", u.style.height = o + "px", u.innerHTML = "<div class='gantt_grid_column_resize'></div>", u.setAttribute(n.grid_resizer_column_attribute, s), t._waiAria.gridSeparatorAttr(u), e.$grid_scale.appendChild(u), u.style.left = Math.max(0, l) + "px"
                        }
                    }
                }
            }
        }
    }, function(t, e, i) {
        var n = i(0),
            r = i(8),
            a = function(t, e) {
                var i = {},
                    n = "gantt-static-bg-styles-" + t.uid();

                function r(t) {
                    var e = /^rgba?\(([\d]{1,3}), *([\d]{1,3}), *([\d]{1,3}) *(,( *[\d.]+ *))?\)$/i.exec(t);
                    return e ? {
                        r: 1 * e[1],
                        g: 1 * e[2],
                        b: 1 * e[3],
                        a: 255 * e[5] || 255
                    } : null
                }

                function a(t) {
                    return i[t] || null
                }

                function o(t, e, i) {
                    return (t + "" + e + i.bottomBorderColor + i.rightBorderColor).replace(/[^\w\d]/g, "")
                }

                function s(t, e) {
                    i[t] = e
                }

                function l(t, e, i) {
                    var n = Math.floor(500 / t) || 1,
                        a = Math.floor(500 / e) || 1,
                        o = document.createElement("canvas");
                    o.height = e * a, o.width = t * n;
                    var s = o.getContext("2d");
                    return function(t, e, i, n, a, o) {
                        var s = a.createImageData(e * n, t * i);
                        s.imageSmoothingEnabled = !1;
                        for (var c = 1 * o.rightBorderWidth, u = r(o.rightBorderColor), d = 0, h = 0, f = 0, _ = 1; _ <= n; _++)
                            for (d = _ * e - 1, f = 0; f < c; f++)
                                for (h = 0; h < t * i; h++) l(d - f, h, u, s);
                        var g = 1 * o.bottomBorderWidth,
                            p = r(o.bottomBorderColor);
                        h = 0;
                        for (var v = 1; v <= i; v++)
                            for (h = v * t - 1, f = 0; f < g; f++)
                                for (d = 0; d < e * n; d++) l(d, h - f, p, s);
                        a.putImageData(s, 0, 0)
                    }(e, t, a, n, s, i), o.toDataURL();

                    function l(e, i, r, a) {
                        var o = 4 * (i * (t * n) + e);
                        a.data[o] = r.r, a.data[o + 1] = r.g, a.data[o + 2] = r.b, a.data[o + 3] = r.a
                    }
                }

                function c(t) {
                    return "gantt-static-bg-" + t
                }

                function u() {
                    var t = document.createElement("div");
                    t.className = "gantt_task_cell";
                    var e = document.createElement("div");
                    return e.className = "gantt_task_row", e.appendChild(t), e
                }
                return {
                    render: function(t, i, r, d) {
                        if (i.static_background && document.createElement("canvas").getContext) {
                            t.innerHTML = "";
                            var h = function(t, i, n, r) {
                                    var a, o, s = [],
                                        l = 0,
                                        c = n.width.filter(function(t) {
                                            return !!t
                                        }),
                                        u = 0,
                                        d = 1e5;
                                    if (e.isIE) {
                                        var h = navigator.appVersion || ""; - 1 == h.indexOf("Windows NT 6.2") && -1 == h.indexOf("Windows NT 6.1") && -1 == h.indexOf("Windows NT 6.0") || (d = 2e4)
                                    }
                                    for (var f = 0; f < c.length; f++) {
                                        var _ = c[f];
                                        if (_ != o && void 0 !== o || f == c.length - 1 || l > d) {
                                            for (var g = r, p = 0, v = Math.floor(d / i.row_height) * i.row_height, m = l; g > 0;) {
                                                var y = Math.min(g, v);
                                                g -= v, (a = document.createElement("div")).style.height = y + "px", a.style.position = "absolute", a.style.top = p + "px", a.style.left = u + "px", a.style.pointerEvents = "none", a.style.whiteSpace = "no-wrap", a.className = t[o || _], f == c.length - 1 && (m = _ + m - 1), a.style.width = m + "px", s.push(a), p += y
                                            }
                                            l = 0, u += m
                                        }
                                        _ && (l += _, o = _)
                                    }
                                    return s
                                }(function(t, e, i) {
                                    var r = {},
                                        u = function(t) {
                                            for (var e = t.width, i = {}, n = 0; n < e.length; n++) 1 * e[n] && (i[e[n]] = !0);
                                            return i
                                        }(i),
                                        d = e.row_height,
                                        h = "";
                                    for (var f in u) {
                                        var _ = 1 * f,
                                            g = o(_, d, t),
                                            p = a(g);
                                        if (!p) {
                                            var v = l(_, d, t);
                                            s(g, v), h += "." + c(g) + "{ background-image: url('" + v + "');}"
                                        }
                                        r[f] = c(g)
                                    }
                                    if (h) {
                                        var m = function() {
                                            var t = document.getElementById(n);
                                            return t || ((t = document.createElement("style")).id = n, document.body.appendChild(t)), t
                                        }();
                                        m.innerHTML += h
                                    }
                                    return r
                                }(function(t) {
                                    var e = u(),
                                        i = u();
                                    t.appendChild(e), t.appendChild(i);
                                    var n = e.firstChild,
                                        r = getComputedStyle(e),
                                        a = getComputedStyle(n),
                                        o = {
                                            bottomBorderWidth: r.getPropertyValue("border-bottom-width").replace("px", ""),
                                            rightBorderWidth: a.getPropertyValue("border-right-width").replace("px", ""),
                                            bottomBorderColor: r.getPropertyValue("border-bottom-color"),
                                            rightBorderColor: a.getPropertyValue("border-right-color")
                                        };
                                    return t.removeChild(e), t.removeChild(i), o
                                }(t), i, r), i, r, d),
                                f = document.createDocumentFragment();
                            h.forEach(function(t) {
                                f.appendChild(t)
                            }), t.appendChild(f)
                        }
                    },
                    destroy: function() {
                        var t = document.getElementById(n);
                        t && t.parentNode && t.parentNode.removeChild(t)
                    }
                }
            };
        t.exports = {
            create: function() {
                return a(n, r)
            }
        }
    }, function(t, e, i) {
        var n = i(3),
            r = i(1),
            a = i(0),
            o = i(8),
            s = function(t) {
                "use strict";
                var e = ["altKey", "shiftKey", "metaKey"];

                function i(e, i, n, r) {
                    var o = t.apply(this, arguments) || this;
                    this.$config = a.mixin(i, {
                        scroll: "x"
                    }), o._scrollHorizontalHandler = a.bind(o._scrollHorizontalHandler, o), o._scrollVerticalHandler = a.bind(o._scrollVerticalHandler, o), o._outerScrollVerticalHandler = a.bind(o._outerScrollVerticalHandler, o), o._outerScrollHorizontalHandler = a.bind(o._outerScrollHorizontalHandler, o), o._mouseWheelHandler = a.bind(o._mouseWheelHandler, o), this.$config.hidden = !0;
                    var s = r.config.scroll_size;
                    return r.env.isIE && (s += 1), this._isHorizontal() ? (o.$config.height = s, o.$parent.$config.height = s) : (o.$config.width = s, o.$parent.$config.width = s), this.$config.scrollPosition = 0, o.$name = "scroller", o
                }
                return n(i, t), i.prototype.init = function(t) {
                    t.innerHTML = this.$toHTML(), this.$view = t.firstChild, this.$view || this.init(), this._isVertical() ? this._initVertical() : this._initHorizontal(), this._initMouseWheel(), this._initLinkedViews()
                }, i.prototype.$toHTML = function() {
                    return "<div class='gantt_layout_cell " + (this._isHorizontal() ? "gantt_hor_scroll" : "gantt_ver_scroll") + "'><div style='" + (this._isHorizontal() ? "width:2000px" : "height:2000px") + "'></div></div>"
                }, i.prototype._getRootParent = function() {
                    for (var t = this.$parent; t && t.$parent;) t = t.$parent;
                    if (t) return t
                }, i.prototype._eachView = function() {
                    var t = [];
                    return function t(e, i) {
                        if (i.push(e), e.$cells)
                            for (var n = 0; n < e.$cells.length; n++) t(e.$cells[n], i)
                    }(this._getRootParent(), t), t
                }, i.prototype._getLinkedViews = function() {
                    for (var t = this._eachView(), e = [], i = 0; i < t.length; i++) t[i].$config && (this._isVertical() && t[i].$config.scrollY == this.$id || this._isHorizontal() && t[i].$config.scrollX == this.$id) && e.push(t[i]);
                    return e
                }, i.prototype._initHorizontal = function() {
                    this.$scroll_hor = this.$view, this.$domEvents.attach(this.$view, "scroll", this._scrollHorizontalHandler)
                }, i.prototype._initLinkedViews = function() {
                    for (var t = this._getLinkedViews(), e = this._isVertical() ? "gantt_layout_outer_scroll gantt_layout_outer_scroll_vertical" : "gantt_layout_outer_scroll gantt_layout_outer_scroll_horizontal", i = 0; i < t.length; i++) r.addClassName(t[i].$view || t[i].getNode(), e)
                }, i.prototype._initVertical = function() {
                    this.$scroll_ver = this.$view, this.$domEvents.attach(this.$view, "scroll", this._scrollVerticalHandler)
                }, i.prototype._updateLinkedViews = function() {}, i.prototype._initMouseWheel = function() {
                    o.isFF ? this.$domEvents.attach(this._getRootParent().$view, "wheel", this._mouseWheelHandler) : this.$domEvents.attach(this._getRootParent().$view, "mousewheel", this._mouseWheelHandler)
                }, i.prototype.scrollHorizontally = function(t) {
                    if (!this._scrolling) {
                        this._scrolling = !0, this.$scroll_hor.scrollLeft = t, this.$config.codeScrollLeft = t, t = this.$scroll_hor.scrollLeft;
                        for (var e = this._getLinkedViews(), i = 0; i < e.length; i++) e[i].scrollTo && e[i].scrollTo(t, void 0);
                        var n = this.$config.scrollPosition;
                        this.$config.scrollPosition = t, this.callEvent("onScroll", [n, t, this.$config.scroll]), this._scrolling = !1
                    }
                }, i.prototype.scrollVertically = function(t) {
                    if (!this._scrolling) {
                        this._scrolling = !0, this.$scroll_ver.scrollTop = t, t = this.$scroll_ver.scrollTop;
                        for (var e = this._getLinkedViews(), i = 0; i < e.length; i++) e[i].scrollTo && e[i].scrollTo(void 0, t);
                        var n = this.$config.scrollPosition;
                        this.$config.scrollPosition = t, this.callEvent("onScroll", [n, t, this.$config.scroll]), this._scrolling = !1
                    }
                }, i.prototype._isVertical = function() {
                    return "y" == this.$config.scroll
                }, i.prototype._isHorizontal = function() {
                    return "x" == this.$config.scroll
                }, i.prototype._scrollHorizontalHandler = function(t) {
                    if (!this._isVertical() && !this._scrolling) {
                        if (new Date - (this._wheel_time || 0) < 100) return !0;
                        if (!this.$gantt._touch_scroll_active) {
                            var e = this.$scroll_hor.scrollLeft;
                            this.scrollHorizontally(e), this._oldLeft = this.$scroll_hor.scrollLeft
                        }
                    }
                }, i.prototype._outerScrollHorizontalHandler = function(t) {
                    this._isVertical()
                }, i.prototype.show = function() {
                    this.$parent.show()
                }, i.prototype.hide = function() {
                    this.$parent.hide()
                }, i.prototype._getScrollSize = function() {
                    for (var t, e = 0, i = 0, n = this._isHorizontal(), r = this._getLinkedViews(), a = n ? "scrollWidth" : "scrollHeight", o = n ? "contentX" : "contentY", s = n ? "x" : "y", l = this._getScrollOffset(), c = 0; c < r.length; c++)
                        if ((t = r[c]) && t.$content && t.$content.getSize && !t.$config.hidden) {
                            var u, d = t.$content.getSize();
                            if (u = d.hasOwnProperty(a) ? d[a] : d[o], l) d[o] > d[s] && d[o] > e && u > d[s] - l + 2 && (e = u + (n ? 0 : 2), i = d[s]);
                            else {
                                var h = Math.max(d[o] - u, 0);
                                (u += h) > Math.max(d[s] - h, 0) && u > e && (e = u, i = d[s])
                            }
                        }
                    return {
                        outerScroll: i,
                        innerScroll: e
                    }
                }, i.prototype.scroll = function(t) {
                    this._isHorizontal() ? this.scrollHorizontally(t) : this.scrollVertically(t)
                }, i.prototype.getScrollState = function() {
                    return {
                        visible: this.isVisible(),
                        direction: this.$config.scroll,
                        size: this.$config.outerSize,
                        scrollSize: this.$config.scrollSize || 0,
                        position: this.$config.scrollPosition || 0
                    }
                }, i.prototype.setSize = function(e, i) {
                    t.prototype.setSize.apply(this, arguments);
                    var n = this._getScrollSize(),
                        r = (this._isVertical() ? i : e) - this._getScrollOffset() + (this._isHorizontal() ? 1 : 0);
                    n.innerScroll && r > n.outerScroll && (n.innerScroll += r - n.outerScroll), this.$config.scrollSize = n.innerScroll, this.$config.width = e, this.$config.height = i, this._setScrollSize(n.innerScroll)
                }, i.prototype.isVisible = function() {
                    return !(!this.$parent || !this.$parent.$view.parentNode)
                }, i.prototype.shouldShow = function() {
                    var t = this._getScrollSize();
                    return !(!t.innerScroll && this.$parent && this.$parent.$view.parentNode) && !(!t.innerScroll || this.$parent && this.$parent.$view.parentNode)
                }, i.prototype.shouldHide = function() {
                    return !(this._getScrollSize().innerScroll || !this.$parent || !this.$parent.$view.parentNode)
                }, i.prototype.toggleVisibility = function() {
                    this.shouldHide() ? this.hide() : this.shouldShow() && this.show()
                }, i.prototype._getScaleOffset = function(t) {
                    var e = 0;
                    return !t || "timeline" != t.$config.view && "grid" != t.$config.view || (e = t.$content.$getConfig().scale_height), e
                }, i.prototype._getScrollOffset = function() {
                    var t = 0;
                    if (this._isVertical()) {
                        var e = this.$parent.$parent;
                        t = Math.max(this._getScaleOffset(e.getPrevSibling(this.$parent.$id)), this._getScaleOffset(e.getNextSibling(this.$parent.$id)))
                    } else
                        for (var i = this._getLinkedViews(), n = 0; n < i.length; n++) {
                            var r = i[n].$parent.$cells,
                                a = r[r.length - 1];
                            if (a && "scrollbar" == a.$config.view && !1 === a.$config.hidden) {
                                t = a.$config.width;
                                break
                            }
                        }
                    return t || 0
                }, i.prototype._setScrollSize = function(t) {
                    var e = this._isHorizontal() ? "width" : "height",
                        i = this._isHorizontal() ? this.$scroll_hor : this.$scroll_ver,
                        n = this._getScrollOffset(),
                        a = i.firstChild;
                    n ? this._isVertical() ? (this.$config.outerSize = this.$config.height - n + 3, i.style.height = this.$config.outerSize + "px", i.style.top = n - 1 + "px", r.addClassName(i, this.$parent._borders.top), r.addClassName(i.parentNode, "gantt_task_vscroll")) : (this.$config.outerSize = this.$config.width - n + 1, i.style.width = this.$config.outerSize + "px") : (i.style.top = "auto", r.removeClassName(i, this.$parent._borders.top), r.removeClassName(i.parentNode, "gantt_task_vscroll"), this.$config.outerSize = this.$config.height), a.style[e] = t + "px"
                }, i.prototype._scrollVerticalHandler = function(t) {
                    if (!this._scrollHorizontalHandler() && !this._scrolling && !this.$gantt._touch_scroll_active) {
                        var e = this.$scroll_ver.scrollTop;
                        e != this._oldTop && (this.scrollVertically(e), this._oldTop = this.$scroll_ver.scrollTop)
                    }
                }, i.prototype._outerScrollVerticalHandler = function(t) {
                    this._scrollHorizontalHandler()
                }, i.prototype._checkWheelTarget = function(t) {
                    for (var e = this._getLinkedViews().concat(this), i = 0; i < e.length; i++) {
                        var n = e[i].$view;
                        if (r.isChildOf(t, n)) return !0
                    }
                    return !1
                }, i.prototype._mouseWheelHandler = function(t) {
                    var i = t.target || t.srcElement;
                    if (this._checkWheelTarget(i)) {
                        this._wheel_time = new Date;
                        var n = {},
                            r = o.isFF,
                            a = r ? -20 * t.deltaX : 2 * t.wheelDeltaX,
                            s = r ? -40 * t.deltaY : t.wheelDelta,
                            l = this.$gantt.config.horizontal_scroll_key;
                        if (!1 !== l && e.indexOf(l) >= 0 && (!t[l] || t.deltaX || t.wheelDeltaX || (a = 2 * s, s = 0)), a && Math.abs(a) > Math.abs(s)) {
                            if (this._isVertical()) return;
                            if (n.x) return !0;
                            if (!this.$scroll_hor || !this.$scroll_hor.offsetWidth) return !0;
                            var c = a / -40,
                                u = this._oldLeft,
                                d = u + 30 * c;
                            if (this.scrollHorizontally(d), this.$scroll_hor.scrollLeft = d, u == this.$scroll_hor.scrollLeft) return !0;
                            this._oldLeft = this.$scroll_hor.scrollLeft
                        } else {
                            if (this._isHorizontal()) return;
                            if (n.y) return !0;
                            if (!this.$scroll_ver || !this.$scroll_ver.offsetHeight) return !0;
                            c = s / -40;
                            void 0 === s && (c = t.detail);
                            var h = this._oldTop,
                                f = this.$scroll_ver.scrollTop + 30 * c;
                            if (this.scrollVertically(f), this.$scroll_ver.scrollTop = f, h == this.$scroll_ver.scrollTop) return !0;
                            this._oldTop = this.$scroll_ver.scrollTop
                        }
                        return t.preventDefault && t.preventDefault(), t.cancelBubble = !0, !1
                    }
                }, i
            }(i(7));
        t.exports = s
    }, function(t, e, i) {
        var n = i(3),
            r = i(1),
            a = i(0),
            o = i(7),
            s = function(t) {
                "use strict";

                function e(e, i, n) {
                    var r, a, o = t.apply(this, arguments) || this;
                    return o._moveHandler = function(t) {
                        o._moveResizer(o._resizer, t.pageX, t.pageY)
                    }, o._upHandler = function() {
                        var t = o._getNewSizes();
                        !1 !== o.callEvent("onResizeEnd", [r, a, t ? t.back : 0, t ? t.front : 0]) && o._setSizes(), o._setBackground(!1), o._clearResizer(), o._clearListeneres()
                    }, o._clearListeneres = function() {
                        this.$domEvents.detach(document, "mouseup", o._upHandler), this.$domEvents.detach(document, "mousemove", o._moveHandler), this.$domEvents.detach(document, "mousemove", o._startOnMove), this.$domEvents.detach(document, "mouseup", o._cancelDND)
                    }, o._callStartDNDEvent = function() {
                        if (this._xMode ? (r = this._behind.$config.width || this._behind.$view.offsetWidth, a = this._front.$config.width || this._front.$view.offsetWidth) : (r = this._behind.$config.height || this._behind.$view.offsetHeight, a = this._front.$config.height || this._front.$view.offsetHeight), !1 === o.callEvent("onResizeStart", [r, a])) return !1
                    }, o._startDND = function(t) {
                        if (!1 !== this._callStartDNDEvent()) {
                            var e = !1;
                            this._eachGroupItem(function(t) {
                                t._getSiblings(), !1 === t._callStartDNDEvent() && (e = !0)
                            }), e || (o._moveHandler(t), o.$domEvents.attach(document, "mousemove", o._moveHandler), o.$domEvents.attach(document, "mouseup", o._upHandler))
                        }
                    }, o._cancelDND = function() {
                        o._setBackground(!1), o._clearResizer(), o._clearListeneres()
                    }, o._startOnMove = function(t) {
                        o._isPosChanged(t) && (o._clearListeneres(), o._startDND(t))
                    }, o._downHandler = function(t) {
                        o._getSiblings(), o._behind.$config.collapsed || o._front.$config.collapsed || (o._setBackground(!0), o._resizer = o._setResizer(), o._positions = {
                            x: t.pageX,
                            y: t.pageY,
                            timestamp: Date.now()
                        }, o.$domEvents.attach(document, "mousemove", o._startOnMove), o.$domEvents.attach(document, "mouseup", o._cancelDND))
                    }, o.$name = "resizer", o
                }
                return n(e, t), e.prototype.init = function() {
                    t.prototype.init.call(this), this._xMode = "x" === this.$config.mode, this._xMode && !this.$config.width ? this.$config.width = this.$config.minWidth = 1 : this._xMode || this.$config.height || (this.$config.height = this.$config.minHeight = 1), this.$config.margin = -1, this.$domEvents.attach(this.$view, "mousedown", this._downHandler)
                }, e.prototype.$toHTML = function() {
                    var t = this.$config.mode,
                        e = this.$config.css || "";
                    return "<div class='gantt_layout_cell gantt_resizer gantt_resizer_" + t + "'><div class='gantt_layout_content gantt_resizer_" + t + (e ? " " + e : "") + "'></div></div>"
                }, e.prototype._clearResizer = function() {
                    this._resizer && (this._resizer.parentNode && this._resizer.parentNode.removeChild(this._resizer), this._resizer = null)
                }, e.prototype._isPosChanged = function(t) {
                    return !!this._positions && (Math.abs(this._positions.x - t.pageX) > 3 || Math.abs(this._positions.y - t.pageY) > 3 || Date.now() - this._positions.timestamp > 300)
                }, e.prototype._getSiblings = function() {
                    var t = this.$parent.getCells();
                    this.$config.prev && (this._behind = this.$factory.getView(this.$config.prev), this._behind instanceof o || (this._behind = this._behind.$parent)), this.$config.next && (this._front = this.$factory.getView(this.$config.next), this._front instanceof o || (this._front = this._behind.$parent));
                    for (var e = 0; e < t.length; e++) this === t[e] && (this._behind || (this._behind = t[e - 1]), this._front || (this._front = t[e + 1]))
                }, e.prototype._setBackground = function(t) {
                    var e = "gantt_resizing";
                    if (!t) return r.removeClassName(this._behind.$view, e), r.removeClassName(this._front.$view, e), void r.removeClassName(document.body, "gantt_noselect");
                    r.addClassName(this._behind.$view, e, !0), r.addClassName(this._front.$view, e, !0), r.addClassName(document.body, "gantt_noselect", !0)
                }, e.prototype._setResizer = function() {
                    var t = document.createElement("div");
                    return t.className = "gantt_resizer_stick", this.$view.appendChild(t), this.$view.style.overflow = "visible", t.style.height = this.$view.style.height, t
                }, e.prototype._getDirection = function(t, e) {
                    var i;
                    return (i = this._xMode ? t - this._positions.x : e - this._positions.y) ? i < 0 ? -1 : 1 : 0
                }, e.prototype._getResizePosition = function(t, e) {
                    var i, n, r, a, o;
                    this._xMode ? (i = t - this._positions.x, n = this._behind.$config.width || this._behind.$view.offsetWidth, a = this._front.$config.width || this._front.$view.offsetWidth, r = this._behind.$config.minWidth, o = this._front.$config.minWidth) : (i = e - this._positions.y, n = this._behind.$config.height || this._behind.$view.offsetHeight, a = this._front.$config.height || this._front.$view.offsetHeight, r = this._front.$config.minHeight, o = this._front.$config.minHeight);
                    var s, l, c = this._getDirection(t, e);
                    if (-1 === c) {
                        if (l = a - i, s = n - Math.abs(i), a - i > this._front.$config.maxWidth) return;
                        Math.abs(i) >= n && (i = -Math.abs(n - 2)), n - Math.abs(i) <= r && (i = -Math.abs(n - r))
                    } else l = a - Math.abs(i), s = n + i, n + i > this._behind.$config.maxWidth && (i = this._behind.$config.maxWidth - n), Math.abs(i) >= a && (i = a - 2), a - Math.abs(i) <= o && (i = Math.abs(a - o));
                    return -1 === c ? (l = a - i, s = n - Math.abs(i)) : (l = a - Math.abs(i), s = n + i), {
                        size: i,
                        newFrontSide: l,
                        newBehindSide: s
                    }
                }, e.prototype._getGroupName = function() {
                    return this._getSiblings(), this._front.$config.group || this._behind.$config.group
                }, e.prototype._eachGroupItem = function(t, e) {
                    for (var i = this.$factory.getView("main"), n = this._getGroupName(), r = i.getCellsByType("resizer"), a = 0; a < r.length; a++) r[a]._getGroupName() == n && r[a] != this && t.call(e || this, r[a])
                }, e.prototype._getGroupResizePosition = function(t, e) {
                    var i = this._getResizePosition(t, e);
                    if (!this._getGroupName()) return i;
                    var n, r = [i];
                    this._eachGroupItem(function(i) {
                        i._getSiblings();
                        var n = a.copy(this._positions);
                        this._xMode ? n.x += i._behind.$config.width - this._behind.$config.width : n.y += i._behind.$config.height - this._behind.$config.height, i._positions = n, r.push(i._getResizePosition(t, e))
                    });
                    for (var o = 0; o < r.length; o++) {
                        if (!r[o]) return;
                        void 0 === n ? n = r[o] : r[o].newBehindSide > n.newBehindSide && (n = r[o])
                    }
                    return n
                }, e.prototype._moveResizer = function(t, e, i) {
                    if (0 !== e) {
                        var n = this._getGroupResizePosition(e, i);
                        n && 1 !== Math.abs(n.size) && (this._xMode ? (t.style.left = n.size + "px", this._positions.nextX = n.size || 0) : (t.style.top = n.size + "px", this._positions.nextY = n.size || 0), this.callEvent("onResize", [n.newBehindSide, n.newFrontSide]))
                    }
                }, e.prototype._setGravity = function(t) {
                    var e = this._xMode ? "offsetWidth" : "offsetHeight",
                        i = this._xMode ? this._positions.nextX : this._positions.nextY,
                        n = this._front.$view[e],
                        r = this._behind.$view[e],
                        a = (n - i) / n * this._front.getSize().gravity,
                        o = (r + i) / r * this._behind.getSize().gravity;
                    "front" !== t && (this._front.$config.gravity = a), "behind" !== t && (this._behind.$config.gravity = o)
                }, e.prototype._getNewSizes = function() {
                    var t = this._xMode ? this._behind.$config.width : this._behind.$config.height,
                        e = this._xMode ? this._front.$config.width : this._front.$config.height,
                        i = this._xMode ? this._positions.nextX : this._positions.nextY;
                    return e || t ? {
                        front: e ? e - i || 1 : 0,
                        back: t ? t + i || 1 : 0
                    } : null
                }, e.prototype._assignNewSizes = function(t) {
                    this._getSiblings();
                    var e = this._xMode ? "width" : "height";
                    t ? (t.front ? this._front.$config[e] = t.front : this._setGravity("behind"), t.back ? this._behind.$config[e] = t.back : this._setGravity("front")) : this._setGravity()
                }, e.prototype._setSizes = function() {
                    this._resizer && this.$view.removeChild(this._resizer);
                    var t = this._getNewSizes();
                    if (this._positions.nextX || this._positions.nextY) {
                        this._assignNewSizes(t);
                        var e = this._xMode ? "width" : "height";
                        this._front.$config.group ? this.$gantt.$layout._syncCellSizes(this._front.$config.group, this._front.$config[e]) : this._behind.$config.group && this.$gantt.$layout._syncCellSizes(this._behind.$config.group, this._behind.$config[e]), this._getGroupName() ? this.$factory.getView("main").resize() : this.$parent.resize()
                    }
                }, e
            }(o);
        t.exports = s
    }, function(t, e, i) {
        var n = i(3),
            r = i(0),
            a = function(t) {
                "use strict";

                function e(e, i, n) {
                    var a = t.apply(this, arguments) || this;
                    if (i.view) {
                        i.id && (this.$id = r.uid());
                        var o = r.copy(i);
                        if (delete o.config, delete o.templates, this.$content = this.$factory.createView(i.view, this, o, this), !this.$content) return !1
                    }
                    return a.$name = "viewCell", a
                }
                return n(e, t), e.prototype.destructor = function() {
                    this.clear(), t.prototype.destructor.call(this)
                }, e.prototype.clear = function() {
                    if (this.$initialized = !1, this.$content) {
                        var e = this.$content.unload || this.$content.destructor;
                        e && e.call(this.$content)
                    }
                    t.prototype.clear.call(this)
                }, e.prototype.scrollTo = function(e, i) {
                    this.$content && this.$content.scrollTo ? this.$content.scrollTo(e, i) : t.prototype.scrollTo.call(this, e, i)
                }, e.prototype._setContentSize = function(t, e) {
                    var i = this._getBorderSizes();
                    if ("number" == typeof t) {
                        var n = t + i.horizontal;
                        this.$config.width = n
                    }
                    if ("number" == typeof e) {
                        var r = e + i.vertical;
                        this.$config.height = r
                    }
                }, e.prototype.setSize = function(e, i) {
                    if (t.prototype.setSize.call(this, e, i), !this.$preResize && this.$content && !this.$initialized) {
                        this.$initialized = !0;
                        var n = this.$view.childNodes[0],
                            r = this.$view.childNodes[1];
                        r || (r = n), this.$content.init(r)
                    }
                }, e.prototype.setContentSize = function() {
                    !this.$preResize && this.$content && this.$initialized && this.$content.setSize(this.$lastSize.contentX, this.$lastSize.contentY)
                }, e.prototype.getContentSize = function() {
                    var e = t.prototype.getContentSize.call(this);
                    if (this.$content && this.$initialized) {
                        var i = this.$content.getSize();
                        e.width = void 0 === i.contentX ? i.width : i.contentX, e.height = void 0 === i.contentY ? i.height : i.contentY
                    }
                    var n = this._getBorderSizes();
                    return e.width += n.horizontal, e.height += n.vertical, e
                }, e
            }(i(7));
        t.exports = a
    }, function(t, e, i) {
        var n = i(3),
            r = i(39),
            a = i(7),
            o = function(t) {
                "use strict";

                function e(e, i, n) {
                    for (var r = t.apply(this, arguments) || this, a = 0; a < r.$cells.length; a++) r.$cells[a].$config.hidden = 0 !== a;
                    return r.$cell = r.$cells[0], r.$name = "viewLayout", r
                }
                return n(e, t), e.prototype.cell = function(e) {
                    var i = t.prototype.cell.call(this, e);
                    return i.$view || this.$fill(null, this), i
                }, e.prototype.moveView = function(t) {
                    var e = this.$view;
                    this.$cell && (this.$cell.$config.hidden = !0, e.removeChild(this.$cell.$view)), this.$cell = t, e.appendChild(t.$view)
                }, e.prototype.setSize = function(t, e) {
                    a.prototype.setSize.call(this, t, e)
                }, e.prototype.setContentSize = function() {
                    var t = this.$lastSize;
                    this.$cell.setSize(t.contentX, t.contentY)
                }, e.prototype.getSize = function() {
                    var e = t.prototype.getSize.call(this);
                    if (this.$cell) {
                        var i = this.$cell.getSize();
                        if (this.$config.byMaxSize)
                            for (var n = 0; n < this.$cells.length; n++) {
                                var r = this.$cells[n].getSize();
                                for (var a in i) i[a] = Math.max(i[a], r[a])
                            }
                        for (var o in e) e[o] = e[o] || i[o];
                        e.gravity = Math.max(e.gravity, i.gravity)
                    }
                    return e
                }, e
            }(r);
        t.exports = o
    }, function(t, e) {
        t.exports = function(t, e) {
            return !!e && (!(e.left > t.x_end || e.left + e.width < t.x) && !(e.top > t.y_end || e.top + e.height < t.y))
        }
    }, function(t, e, i) {
        var n = i(151),
            r = i(18),
            a = i(40);
        t.exports = function(t) {
            var e = t.$services,
                i = {},
                o = {};

            function s(e) {
                var i = null;
                return "string" == typeof e.view ? i = t.$ui.getView(e.view) : e.view && (i = e.view), i
            }

            function l(l, c, u) {
                if (o[l]) return o[l];
                c.renderer || t.assert(!1, "Invalid renderer call");
                var d = null,
                    h = null,
                    f = null;
                "function" == typeof c.renderer ? (d = c.renderer, f = a) : (d = c.renderer.render, h = c.renderer.update, (f = c.renderer.getRectangle) || null === f || (f = a));
                var _ = c.filter;
                return u && u.setAttribute(e.config().layer_attribute, !0), o[l] = {
                    render_item: function(e, i, a) {
                        if (i = i || u, !_ || _(e)) {
                            var o = s(c),
                                l = a;
                            !l && o && o.$getConfig().smart_rendering && (l = o.getViewPort());
                            var h = null;
                            !r(t) && f && l ? n(l, f(e, o, t)) && (h = d.call(t, e, o, l)) : h = d.call(t, e, o, l), this.append(e, h, i)
                        } else this.remove_item(e.id)
                    },
                    clear: function(t) {
                        this.rendered = i[l] = {}, c.append || this.clear_container(t)
                    },
                    clear_container: function(t) {
                        (t = t || u) && (t.innerHTML = "")
                    },
                    render_items: function(t, e) {
                        e = e || u;
                        var i = document.createDocumentFragment();
                        this.clear(e);
                        var n = null,
                            r = s(c);
                        r && r.$getConfig().smart_rendering && (n = r.getViewPort());
                        for (var a = 0, o = t.length; a < o; a++) this.render_item(t[a], i, n);
                        e.appendChild(i, e)
                    },
                    update_items: function(e, i) {
                        var a = s(c);
                        if (a && a.$getConfig().smart_rendering && !r(t) && this.rendered && f) {
                            i = i || u;
                            var o = document.createDocumentFragment(),
                                l = null;
                            a && (l = a.getViewPort());
                            for (var d = 0, _ = e.length; d < _; d++) {
                                var g = e[d],
                                    p = this.rendered[g.id];
                                p && p.parentNode ? n(l, f(g, a, t)) ? (h && h.call(t, g, p, a, l), this.restore(g)) : this.hide(g.id) : this.render_item(e[d], o, l)
                            }
                            o.childNodes.length && i.appendChild(o, i)
                        }
                    },
                    append: function(t, e, i) {
                        e ? (this.rendered[t.id] && this.rendered[t.id].parentNode ? this.replace_item(t.id, e) : i.appendChild(e), this.rendered[t.id] = e) : this.rendered[t.id] && this.remove_item(t.id)
                    },
                    replace_item: function(t, e) {
                        var i = this.rendered[t];
                        i && i.parentNode && i.parentNode.replaceChild(e, i), this.rendered[t] = e
                    },
                    remove_item: function(t) {
                        this.hide(t), delete this.rendered[t]
                    },
                    hide: function(t) {
                        var e = this.rendered[t];
                        e && e.parentNode && e.parentNode.removeChild(e)
                    },
                    restore: function(t) {
                        var e = this.rendered[t.id];
                        e ? e.parentNode || this.append(t, e, u) : this.render_item(t, u)
                    },
                    change_id: function(t, e) {
                        this.rendered[e] = this.rendered[t], delete this.rendered[t]
                    },
                    rendered: i[l],
                    node: u,
                    destructor: function() {
                        this.clear(), delete o[l], delete i[l]
                    }
                }, o[l]
            }
            return {
                getRenderer: l,
                clearRenderers: function() {
                    for (var t in o) l(t).destructor()
                }
            }
        }
    }, function(t, e, i) {
        var n = i(152),
            r = i(0),
            a = i(1),
            o = i(18);

        function s(t) {
            return t instanceof Array || (t = Array.prototype.slice.call(arguments, 0)),
                function(e) {
                    for (var i = !0, n = 0, r = t.length; n < r; n++) {
                        var a = t[n];
                        a && (i = i && !1 !== a(e.id, e))
                    }
                    return i
                }
        }
        t.exports = function(t) {
            var e = n(t);
            return {
                createGroup: function(i, n, l, c) {
                    var u = {
                        tempCollection: [],
                        renderers: {},
                        container: i,
                        filters: [],
                        getLayers: function() {
                            this._add();
                            var t = [];
                            for (var e in this.renderers) t.push(this.renderers[e]);
                            return t
                        },
                        getLayer: function(t) {
                            return this.renderers[t]
                        },
                        _add: function(i) {
                            i && (i.id = i.id || r.uid(), this.tempCollection.push(i));
                            for (var o = this.container(), s = this.tempCollection, l = 0; l < s.length; l++)
                                if (i = s[l], this.container() || i && i.container && a.isChildOf(i.container, document.body)) {
                                    var u = i.container,
                                        d = i.id,
                                        h = i.topmost;
                                    if (!u.parentNode)
                                        if (h) o.appendChild(u);
                                        else {
                                            var f = n ? n() : o.firstChild;
                                            f ? o.insertBefore(u, f) : o.appendChild(u)
                                        }
                                    this.renderers[d] = e.getRenderer(d, i, u), c && c(i, t), this.tempCollection.splice(l, 1), l--
                                }
                        },
                        addLayer: function(e) {
                            if (e) {
                                "function" == typeof e && (e = {
                                    renderer: e
                                }), void 0 === e.filter ? e.filter = s(l || []) : e.filter instanceof Array && (e.filter.push(l), e.filter = s(e.filter)), e.container || (e.container = document.createElement("div"));
                                var i = this;
                                e.requestUpdate = function() {
                                    t.config.smart_rendering && !o(t) && i.renderers[e.id] && i.onUpdateRequest(i.renderers[e.id])
                                }
                            }
                            return this._add(e), e ? e.id : void 0
                        },
                        onUpdateRequest: function(t) {},
                        eachLayer: function(t) {
                            for (var e in this.renderers) t(this.renderers[e])
                        },
                        removeLayer: function(t) {
                            this.renderers[t] && (this.renderers[t].destructor(), delete this.renderers[t])
                        },
                        clear: function() {
                            for (var t in this.renderers) this.renderers[t].destructor();
                            this.renderers = {}
                        }
                    };
                    return t.attachEvent("onDestroy", function() {
                        u.clear(), u = null
                    }), u
                }
            }
        }
    }, function(t, e, i) {
        var n = i(153);

        function r(t, e) {
            if (t.view) {
                var i = t.view;
                "string" == typeof i && (i = e.$ui.getView(i)), i && i.attachEvent && i.attachEvent("onScroll", function() {
                    t.requestUpdate && t.requestUpdate()
                })
            }
        }
        t.exports = function(t) {
            var e = n(t);
            return {
                getDataRender: function(e) {
                    return t.$services.getService("layer:" + e) || null
                },
                createDataRender: function(i) {
                    var n = i.name,
                        a = i.defaultContainer,
                        o = i.defaultContainerSibling,
                        s = e.createGroup(a, o, function(t, e) {
                            if (!s.filters) return !0;
                            for (var i = 0; i < s.filters.length; i++)
                                if (!1 === s.filters[i](t, e)) return !1
                        }, r);
                    return t.$services.setService("layer:" + n, function() {
                        return s
                    }), t.attachEvent("onGanttReady", function() {
                        s.addLayer()
                    }), s
                },
                init: function() {
                    var e = this.createDataRender({
                            name: "task",
                            defaultContainer: function() {
                                return t.$task_data ? t.$task_data : t.$ui.getView("timeline") ? t.$ui.getView("timeline").$task_data : void 0
                            },
                            defaultContainerSibling: function() {
                                return t.$task_links ? t.$task_links : t.$ui.getView("timeline") ? t.$ui.getView("timeline").$task_links : void 0
                            },
                            filter: function(t) {}
                        }, t),
                        i = this.createDataRender({
                            name: "link",
                            defaultContainer: function() {
                                return t.$task_data ? t.$task_data : t.$ui.getView("timeline") ? t.$ui.getView("timeline").$task_data : void 0
                            }
                        }, t);
                    return {
                        addTaskLayer: function(t) {
                            return "function" == typeof t && (t = {
                                renderer: t
                            }), t.view = "timeline", e.addLayer(t)
                        },
                        _getTaskLayers: function() {
                            return e.getLayers()
                        },
                        removeTaskLayer: function(t) {
                            e.removeLayer(t)
                        },
                        _clearTaskLayers: function() {
                            e.clear()
                        },
                        addLinkLayer: function(t) {
                            return "function" == typeof t && (t = {
                                renderer: t
                            }), t.view = "timeline", i.addLayer(t)
                        },
                        _getLinkLayers: function() {
                            return i.getLayers()
                        },
                        removeLinkLayer: function(t) {
                            i.removeLayer(t)
                        },
                        _clearLinkLayers: function() {
                            i.clear()
                        }
                    }
                }
            }
        }
    }, function(t, e, i) {
        var n = function(t) {
            return function(e) {
                var i = {
                    click: {},
                    doubleclick: {},
                    contextMenu: {}
                };

                function n(t, e, n, r) {
                    i[t][e] || (i[t][e] = []), i[t][e].push({
                        handler: n,
                        root: r
                    })
                }

                function r(t) {
                    t = t || window.event;
                    var n = e.locate(t),
                        r = o(t, i.click),
                        a = !0;
                    if (null !== n ? a = !e.checkEvent("onTaskClick") || e.callEvent("onTaskClick", [n, t]) : e.callEvent("onEmptyClick", [t]), a) {
                        if (!s(r, t, n)) return;
                        n && e.getTask(n) && e.config.select_task && !e.config.multiselect && e.selectTask(n)
                    }
                }

                function a(t) {
                    var i = (t = t || window.event).target || t.srcElement,
                        n = e.locate(i),
                        r = e.locate(i, e.config.link_attribute),
                        a = !e.checkEvent("onContextMenu") || e.callEvent("onContextMenu", [n, r, t]);
                    return a || (t.preventDefault ? t.preventDefault() : t.returnValue = !1), a
                }

                function o(e, i) {
                    for (var n = e.target || e.srcElement, r = []; n;) {
                        var a = t.getClassName(n);
                        if (a) {
                            a = a.split(" ");
                            for (var o = 0; o < a.length; o++)
                                if (a[o] && i[a[o]])
                                    for (var s = i[a[o]], l = 0; l < s.length; l++) s[l].root && !t.isChildOf(n, s[l].root) || r.push(s[l].handler)
                        }
                        n = n.parentNode
                    }
                    return r
                }

                function s(t, i, n) {
                    for (var r = !0, a = 0; a < t.length; a++) {
                        var o = t[a].call(e, i, n, i.target || i.srcElement);
                        r = r && !(void 0 !== o && !0 !== o)
                    }
                    return r
                }

                function l(t) {
                    t = t || window.event;
                    var n = e.locate(t),
                        r = o(t, i.doubleclick),
                        a = !e.checkEvent("onTaskDblClick") || null === n || e.callEvent("onTaskDblClick", [n, t]);
                    if (a) {
                        if (!s(r, t, n)) return;
                        null !== n && e.getTask(n) && a && e.config.details_on_dblclick && e.showLightbox(n)
                    }
                }

                function c(t) {
                    if (e.checkEvent("onMouseMove")) {
                        var i = e.locate(t);
                        e._last_move_event = t, e.callEvent("onMouseMove", [i, t])
                    }
                }
                var u = e._createDomEventScope();

                function d(t) {
                    u.detachAll(), t && (u.attach(t, "click", r), u.attach(t, "dblclick", l), u.attach(t, "mousemove", c), u.attach(t, "contextmenu", a))
                }
                return {
                    reset: d,
                    global: function(t, e, i) {
                        n(t, e, i, null)
                    },
                    delegate: n,
                    detach: function(t, e, n, r) {
                        if (i[t] && i[t][e]) {
                            for (var a = i[t], o = a[e], s = 0; s < o.length; s++) o[s].root == r && (o.splice(s, 1), s--);
                            o.length || delete a[e]
                        }
                    },
                    callHandler: function(t, e, n, r) {
                        var a = i[t][e];
                        if (a)
                            for (var o = 0; o < a.length; o++)(n || a[o].root) && a[o].root !== n || a[o].handler.apply(this, r)
                    },
                    onDoubleClick: l,
                    onMouseMove: c,
                    onContextMenu: a,
                    onClick: r,
                    destructor: function() {
                        d(), i = null, u = null
                    }
                }
            }
        }(i(1));
        t.exports = {
            init: n
        }
    }, function(t, e, i) {
        var n = i(0);

        function r(t) {
            n.mixin(this, t, !0)
        }

        function a(t, e) {
            var i = this.$config[t];
            return i ? i instanceof r ? i : (r.prototype = e, this.$config[t] = new r(i), this.$config[t]) : e
        }
        t.exports = function(t, e) {
            n.mixin(t, function(t) {
                var e, i;
                return {
                    $getConfig: function() {
                        return e || (e = t ? t.$getConfig() : this.$gantt.config), this.$config.config ? a.call(this, "config", e) : e
                    },
                    $getTemplates: function() {
                        return i || (i = t ? t.$getTemplates() : this.$gantt.templates), this.$config.templates ? a.call(this, "templates", i) : i
                    }
                }
            }(e))
        }
    }, function(t, e, i) {
        var n = i(0),
            r = i(156);
        t.exports = {
            createFactory: function(t) {
                var e = {};
                var i = {};

                function a(a, o, s, l) {
                    var c = e[a];
                    if (!c || !c.create) return !1;
                    "resizer" != a || s.mode || (l.$config.cols ? s.mode = "x" : s.mode = "y"), "viewcell" != a || "scrollbar" != s.view || s.scroll || (l.$config.cols ? s.scroll = "y" : s.scroll = "x"), (s = n.copy(s)).id || i[s.view] || (s.id = s.view), s.id && !s.css && (s.css = s.id + "_cell");
                    var u = new c.create(o, s, this, t);
                    return c.configure && c.configure(u), r(u, l), u.$id || (u.$id = s.id || t.uid()), u.$parent || "object" != typeof o || (u.$parent = o), u.$config || (u.$config = s), i[u.$id] && (u.$id = t.uid()), i[u.$id] = u, u
                }
                return {
                    initUI: function(t, e) {
                        var i = "cell";
                        return t.view ? i = "viewcell" : t.resizer ? i = "resizer" : t.rows || t.cols ? i = "layout" : t.views && (i = "multiview"), a.call(this, i, null, t, e)
                    },
                    reset: function() {
                        i = {}
                    },
                    registerView: function(t, i, n) {
                        e[t] = {
                            create: i,
                            configure: n
                        }
                    },
                    createView: a,
                    getView: function(t) {
                        return i[t]
                    }
                }
            }
        }
    }, function(t, e, i) {
        var n = i(157),
            r = i(155),
            a = i(154),
            o = i(7),
            s = i(39),
            l = i(150),
            c = i(149),
            u = i(148),
            d = i(147),
            h = i(38),
            f = i(17),
            _ = i(144),
            g = i(34),
            p = i(143),
            v = i(142),
            m = i(131),
            y = i(130),
            b = i(129),
            k = i(128),
            w = i(126),
            x = i(125),
            $ = i(119),
            S = i(116);
        t.exports = {
            init: function(t) {
                function e(e, i) {
                    var n = i(t);
                    n.onCreated && n.onCreated(e), e.attachEvent("onReady", function() {
                        n.onInitialized && n.onInitialized(e)
                    }), e.attachEvent("onDestroy", function() {
                        n.onDestroyed && n.onDestroyed(e)
                    })
                }
                var i = n.createFactory(t);
                i.registerView("cell", o), i.registerView("resizer", u), i.registerView("scrollbar", d), i.registerView("layout", s, function(t) {
                    "main" === (t.$config ? t.$config.id : null) && e(t, S)
                }), i.registerView("viewcell", c), i.registerView("multiview", l), i.registerView("timeline", h, function(t) {
                    "timeline" !== (t.$config ? t.$config.id : null) && "task" != t.$config.bind || e(t, $)
                }), i.registerView("grid", f, function(t) {
                    "grid" !== (t.$config ? t.$config.id : null) && "task" != t.$config.bind || e(t, x)
                }), i.registerView("resourceGrid", _), i.registerView("resourceTimeline", g), i.registerView("resourceHistogram", p);
                var C = a(t),
                    T = v(t);
                return t.ext.inlineEditors = T, t.ext._inlineEditors = T, T.init(t), {
                    factory: i,
                    mouseEvents: r.init(t),
                    layersApi: C.init(),
                    render: {
                        gridLine: function() {
                            return w(t)
                        },
                        taskBg: function() {
                            return b(t)
                        },
                        taskBar: function() {
                            return m(t)
                        },
                        taskSplitBar: function() {
                            return y(t)
                        },
                        link: function() {
                            return k(t)
                        }
                    },
                    layersService: {
                        getDataRender: function(e) {
                            return C.getDataRender(e, t)
                        },
                        createDataRender: function(e) {
                            return C.createDataRender(e, t)
                        }
                    }
                }
            }
        }
    }, function(t, e, i) {
        var n = i(0),
            r = i(1);
        t.exports = function(t) {
            var e = "data-dhxbox",
                i = null;

            function a(t, e) {
                var n = t.callback;
                g.hide(t.box), i = t.box = null, n && n(e)
            }

            function o(t) {
                if (i) {
                    var e = (t = t || event).which || event.keyCode,
                        n = !1;
                    if (p.keyboard) {
                        if (13 == e || 32 == e) {
                            var o = t.target || t.srcElement;
                            r.getClassName(o).indexOf("gantt_popup_button") > -1 && o.click ? o.click() : (a(i, !0), n = !0)
                        }
                        27 == e && (a(i, !1), n = !0)
                    }
                    return n ? (t.preventDefault && t.preventDefault(), !(t.cancelBubble = !0)) : void 0
                }
            }

            function s(t) {
                s.cover || (s.cover = document.createElement("div"), s.cover.onkeydown = o, s.cover.className = "dhx_modal_cover", document.body.appendChild(s.cover)), s.cover.style.display = t ? "inline-block" : "none"
            }

            function l(e, i, n) {
                var r = t._waiAria.messageButtonAttrString(e),
                    a = i.toLowerCase().replace(/ /g, "_");
                return "<div " + r + " class='gantt_popup_button dhtmlx_popup_button " + ("gantt_" + a + "_button dhtmlx_" + a + "_button") + "' data-result='" + n + "' result='" + n + "' ><div>" + e + "</div></div>"
            }

            function c() {
                for (var t = [].slice.apply(arguments, [0]), e = 0; e < t.length; e++)
                    if (t[e]) return t[e]
            }

            function u(r, u, d) {
                var h = r.tagName ? r : function(r, o, s) {
                    var u = document.createElement("div"),
                        d = n.uid();
                    t._waiAria.messageModalAttr(u, d), u.className = " gantt_modal_box dhtmlx_modal_box gantt-" + r.type + " dhtmlx-" + r.type, u.setAttribute(e, 1);
                    var h = "";
                    if (r.width && (u.style.width = r.width), r.height && (u.style.height = r.height), r.title && (h += '<div class="gantt_popup_title dhtmlx_popup_title">' + r.title + "</div>"), h += '<div class="gantt_popup_text dhtmlx_popup_text" id="' + d + '"><span>' + (r.content ? "" : r.text) + '</span></div><div  class="gantt_popup_controls dhtmlx_popup_controls">', o && (h += l(c(r.ok, t.locale.labels.message_ok, "OK"), "ok", !0)), s && (h += l(c(r.cancel, t.locale.labels.message_cancel, "Cancel"), "cancel", !1)), r.buttons)
                        for (var f = 0; f < r.buttons.length; f++) {
                            var _ = r.buttons[f];
                            h += "object" == typeof _ ? l(_.label, _.css || "gantt_" + _.label.toLowerCase() + "_button dhtmlx_" + _.label.toLowerCase() + "_button", _.value || f) : l(_, _, f)
                        }
                    if (h += "</div>", u.innerHTML = h, r.content) {
                        var g = r.content;
                        "string" == typeof g && (g = document.getElementById(g)), "none" == g.style.display && (g.style.display = ""), u.childNodes[r.title ? 1 : 0].appendChild(g)
                    }
                    return u.onclick = function(t) {
                        var e = (t = t || event).target || t.srcElement;
                        if (e.className || (e = e.parentNode), "gantt_popup_button" == e.className.split(" ")[0]) {
                            var i = e.getAttribute("data-result");
                            a(r, i = "true" == i || "false" != i && i)
                        }
                    }, r.box = u, (o || s) && (i = r), u
                }(r, u, d);
                r.hidden || s(!0), document.body.appendChild(h);
                var f = Math.abs(Math.floor(((window.innerWidth || document.documentElement.offsetWidth) - h.offsetWidth) / 2)),
                    _ = Math.abs(Math.floor(((window.innerHeight || document.documentElement.offsetHeight) - h.offsetHeight) / 2));
                return "top" == r.position ? h.style.top = "-3px" : h.style.top = _ + "px", h.style.left = f + "px", h.onkeydown = o, g.focus(h), r.hidden && g.hide(h), t.callEvent("onMessagePopup", [h]), h
            }

            function d(t) {
                return u(t, !0, !1)
            }

            function h(t) {
                return u(t, !0, !0)
            }

            function f(t) {
                return u(t)
            }

            function _(t, e, i) {
                return "object" != typeof t && ("function" == typeof e && (i = e, e = ""), t = {
                    text: t,
                    type: e,
                    callback: i
                }), t
            }
            t.event(document, "keydown", o, !0);
            var g = function() {
                var t = _.apply(this, arguments);
                return t.type = t.type || "alert", f(t)
            };
            g.hide = function(i) {
                for (; i && i.getAttribute && !i.getAttribute(e);) i = i.parentNode;
                i && (i.parentNode.removeChild(i), s(!1), t.callEvent("onAfterMessagePopup", [i]))
            }, g.focus = function(t) {
                setTimeout(function() {
                    var e = r.getFocusableNodes(t);
                    e.length && e[0].focus && e[0].focus()
                }, 1)
            };
            var p = function(e, i, r, a) {
                switch ((e = function(t, e, i, r) {
                    return "object" != typeof t && (t = {
                        text: t,
                        type: e,
                        expire: i,
                        id: r
                    }), t.id = t.id || n.uid(), t.expire = t.expire || p.expire, t
                }.apply(this, arguments)).type = e.type || "info", e.type.split("-")[0]) {
                    case "alert":
                        return d(e);
                    case "confirm":
                        return h(e);
                    case "modalbox":
                        return f(e);
                    default:
                        return function(e) {
                            p.area || (p.area = document.createElement("div"), p.area.className = "gantt_message_area dhtmlx_message_area", p.area.style[p.position] = "5px", document.body.appendChild(p.area)), p.hide(e.id);
                            var i = document.createElement("div");
                            return i.innerHTML = "<div>" + e.text + "</div>", i.className = "gantt-info dhtmlx-info gantt-" + e.type + " dhtmlx-" + e.type, i.onclick = function() {
                                p.hide(e.id), e = null
                            }, t._waiAria.messageInfoAttr(i), "bottom" == p.position && p.area.firstChild ? p.area.insertBefore(i, p.area.firstChild) : p.area.appendChild(i), e.expire > 0 && (p.timers[e.id] = window.setTimeout(function() {
                                p.hide(e.id)
                            }, e.expire)), p.pull[e.id] = i, i = null, e.id
                        }(e)
                }
            };
            p.seed = (new Date).valueOf(), p.uid = n.uid, p.expire = 4e3, p.keyboard = !0, p.position = "top", p.pull = {}, p.timers = {}, p.hideAll = function() {
                for (var t in p.pull) p.hide(t)
            }, p.hide = function(t) {
                var e = p.pull[t];
                e && e.parentNode && (window.setTimeout(function() {
                    e.parentNode.removeChild(e), e = null
                }, 2e3), e.className += " hidden", p.timers[t] && window.clearTimeout(p.timers[t]), delete p.pull[t])
            };
            var v = [];
            return t.attachEvent("onMessagePopup", function(t) {
                v.push(t)
            }), t.attachEvent("onAfterMessagePopup", function(t) {
                for (var e = 0; e < v.length; e++) v[e] === t && (v.splice(e, 1), e--)
            }), t.attachEvent("onDestroy", function() {
                s.cover && s.cover.parentNode && s.cover.parentNode.removeChild(s.cover);
                for (var t = 0; t < v.length; t++) v[t].parentNode && v[t].parentNode.removeChild(v[t]);
                v = null, p.area && p.area.parentNode && p.area.parentNode.removeChild(p.area), p = null
            }), {
                alert: function() {
                    var t = _.apply(this, arguments);
                    return t.type = t.type || "confirm", d(t)
                },
                confirm: function() {
                    var t = _.apply(this, arguments);
                    return t.type = t.type || "alert", h(t)
                },
                message: p,
                modalbox: g
            }
        }
    }, function(t, e, i) {
        (function(t, e) {
            ! function(t, i) {
                "use strict";
                if (!t.setImmediate) {
                    var n, r = 1,
                        a = {},
                        o = !1,
                        s = t.document,
                        l = Object.getPrototypeOf && Object.getPrototypeOf(t);
                    l = l && l.setTimeout ? l : t, "[object process]" === {}.toString.call(t.process) ? n = function(t) {
                        e.nextTick(function() {
                            u(t)
                        })
                    } : function() {
                        if (t.postMessage && !t.importScripts) {
                            var e = !0,
                                i = t.onmessage;
                            return t.onmessage = function() {
                                e = !1
                            }, t.postMessage("", "*"), t.onmessage = i, e
                        }
                    }() ? function() {
                        var e = "setImmediate$" + Math.random() + "$",
                            i = function(i) {
                                i.source === t && "string" == typeof i.data && 0 === i.data.indexOf(e) && u(+i.data.slice(e.length))
                            };
                        t.addEventListener ? t.addEventListener("message", i, !1) : t.attachEvent("onmessage", i), n = function(i) {
                            t.postMessage(e + i, "*")
                        }
                    }() : t.MessageChannel ? function() {
                        var t = new MessageChannel;
                        t.port1.onmessage = function(t) {
                            u(t.data)
                        }, n = function(e) {
                            t.port2.postMessage(e)
                        }
                    }() : s && "onreadystatechange" in s.createElement("script") ? function() {
                        var t = s.documentElement;
                        n = function(e) {
                            var i = s.createElement("script");
                            i.onreadystatechange = function() {
                                u(e), i.onreadystatechange = null, t.removeChild(i), i = null
                            }, t.appendChild(i)
                        }
                    }() : n = function(t) {
                        setTimeout(u, 0, t)
                    }, l.setImmediate = function(t) {
                        "function" != typeof t && (t = new Function("" + t));
                        for (var e = new Array(arguments.length - 1), i = 0; i < e.length; i++) e[i] = arguments[i + 1];
                        var o = {
                            callback: t,
                            args: e
                        };
                        return a[r] = o, n(r), r++
                    }, l.clearImmediate = c
                }

                function c(t) {
                    delete a[t]
                }

                function u(t) {
                    if (o) setTimeout(u, 0, t);
                    else {
                        var e = a[t];
                        if (e) {
                            o = !0;
                            try {
                                ! function(t) {
                                    var e = t.callback,
                                        n = t.args;
                                    switch (n.length) {
                                        case 0:
                                            e();
                                            break;
                                        case 1:
                                            e(n[0]);
                                            break;
                                        case 2:
                                            e(n[0], n[1]);
                                            break;
                                        case 3:
                                            e(n[0], n[1], n[2]);
                                            break;
                                        default:
                                            e.apply(i, n)
                                    }
                                }(e)
                            } finally {
                                c(t), o = !1
                            }
                        }
                    }
                }
            }("undefined" == typeof self ? void 0 === t ? this : t : self)
        }).call(this, i(19), i(41))
    }, function(t, e, i) {
        (function(t) {
            var n = void 0 !== t && t || "undefined" != typeof self && self || window,
                r = Function.prototype.apply;

            function a(t, e) {
                this._id = t, this._clearFn = e
            }
            e.setTimeout = function() {
                return new a(r.call(setTimeout, n, arguments), clearTimeout)
            }, e.setInterval = function() {
                return new a(r.call(setInterval, n, arguments), clearInterval)
            }, e.clearTimeout = e.clearInterval = function(t) {
                t && t.close()
            }, a.prototype.unref = a.prototype.ref = function() {}, a.prototype.close = function() {
                this._clearFn.call(n, this._id)
            }, e.enroll = function(t, e) {
                clearTimeout(t._idleTimeoutId), t._idleTimeout = e
            }, e.unenroll = function(t) {
                clearTimeout(t._idleTimeoutId), t._idleTimeout = -1
            }, e._unrefActive = e.active = function(t) {
                clearTimeout(t._idleTimeoutId);
                var e = t._idleTimeout;
                e >= 0 && (t._idleTimeoutId = setTimeout(function() {
                    t._onTimeout && t._onTimeout()
                }, e))
            }, i(160), e.setImmediate = "undefined" != typeof self && self.setImmediate || void 0 !== t && t.setImmediate || this && this.setImmediate, e.clearImmediate = "undefined" != typeof self && self.clearImmediate || void 0 !== t && t.clearImmediate || this && this.clearImmediate
        }).call(this, i(19))
    }, function(t, e, i) {
        (function(e, i, n) {
            t.exports = function() {
                var t, r, a;
                return function t(e, i, n) {
                    function r(o, s) {
                        if (!i[o]) {
                            if (!e[o]) {
                                var l = "function" == typeof _dereq_ && _dereq_;
                                if (!s && l) return l(o, !0);
                                if (a) return a(o, !0);
                                var c = new Error("Cannot find module '" + o + "'");
                                throw c.code = "MODULE_NOT_FOUND", c
                            }
                            var u = i[o] = {
                                exports: {}
                            };
                            e[o][0].call(u.exports, function(t) {
                                var i = e[o][1][t];
                                return r(i || t)
                            }, u, u.exports, t, e, i, n)
                        }
                        return i[o].exports
                    }
                    for (var a = "function" == typeof _dereq_ && _dereq_, o = 0; o < n.length; o++) r(n[o]);
                    return r
                }({
                    1: [function(t, e, i) {
                        "use strict";
                        e.exports = function(t) {
                            var e = t._SomePromiseArray;

                            function i(t) {
                                var i = new e(t),
                                    n = i.promise();
                                return i.setHowMany(1), i.setUnwrap(), i.init(), n
                            }
                            t.any = function(t) {
                                return i(t)
                            }, t.prototype.any = function() {
                                return i(this)
                            }
                        }
                    }, {}],
                    2: [function(t, i, n) {
                        "use strict";
                        var r;
                        try {
                            throw new Error
                        } catch (t) {
                            r = t
                        }
                        var a = t("./schedule"),
                            o = t("./queue"),
                            s = t("./util");

                        function l() {
                            this._customScheduler = !1, this._isTickUsed = !1, this._lateQueue = new o(16), this._normalQueue = new o(16), this._haveDrainedQueues = !1, this._trampolineEnabled = !0;
                            var t = this;
                            this.drainQueues = function() {
                                t._drainQueues()
                            }, this._schedule = a
                        }

                        function c(t, e, i) {
                            this._lateQueue.push(t, e, i), this._queueTick()
                        }

                        function u(t, e, i) {
                            this._normalQueue.push(t, e, i), this._queueTick()
                        }

                        function d(t) {
                            this._normalQueue._pushOne(t), this._queueTick()
                        }

                        function h(t) {
                            for (; t.length() > 0;) f(t)
                        }

                        function f(t) {
                            var e = t.shift();
                            if ("function" != typeof e) e._settlePromises();
                            else {
                                var i = t.shift(),
                                    n = t.shift();
                                e.call(i, n)
                            }
                        }
                        l.prototype.setScheduler = function(t) {
                            var e = this._schedule;
                            return this._schedule = t, this._customScheduler = !0, e
                        }, l.prototype.hasCustomScheduler = function() {
                            return this._customScheduler
                        }, l.prototype.enableTrampoline = function() {
                            this._trampolineEnabled = !0
                        }, l.prototype.disableTrampolineIfNecessary = function() {
                            s.hasDevTools && (this._trampolineEnabled = !1)
                        }, l.prototype.haveItemsQueued = function() {
                            return this._isTickUsed || this._haveDrainedQueues
                        }, l.prototype.fatalError = function(t, i) {
                            i ? (e.stderr.write("Fatal " + (t instanceof Error ? t.stack : t) + "\n"), e.exit(2)) : this.throwLater(t)
                        }, l.prototype.throwLater = function(t, e) {
                            if (1 === arguments.length && (e = t, t = function() {
                                    throw e
                                }), "undefined" != typeof setTimeout) setTimeout(function() {
                                t(e)
                            }, 0);
                            else try {
                                this._schedule(function() {
                                    t(e)
                                })
                            } catch (t) {
                                throw new Error("No async scheduler available\n\n    See http://goo.gl/MqrFmX\n")
                            }
                        }, s.hasDevTools ? (l.prototype.invokeLater = function(t, e, i) {
                            this._trampolineEnabled ? c.call(this, t, e, i) : this._schedule(function() {
                                setTimeout(function() {
                                    t.call(e, i)
                                }, 100)
                            })
                        }, l.prototype.invoke = function(t, e, i) {
                            this._trampolineEnabled ? u.call(this, t, e, i) : this._schedule(function() {
                                t.call(e, i)
                            })
                        }, l.prototype.settlePromises = function(t) {
                            this._trampolineEnabled ? d.call(this, t) : this._schedule(function() {
                                t._settlePromises()
                            })
                        }) : (l.prototype.invokeLater = c, l.prototype.invoke = u, l.prototype.settlePromises = d), l.prototype._drainQueues = function() {
                            h(this._normalQueue), this._reset(), this._haveDrainedQueues = !0, h(this._lateQueue)
                        }, l.prototype._queueTick = function() {
                            this._isTickUsed || (this._isTickUsed = !0, this._schedule(this.drainQueues))
                        }, l.prototype._reset = function() {
                            this._isTickUsed = !1
                        }, i.exports = l, i.exports.firstLineError = r
                    }, {
                        "./queue": 26,
                        "./schedule": 29,
                        "./util": 36
                    }],
                    3: [function(t, e, i) {
                        "use strict";
                        e.exports = function(t, e, i, n) {
                            var r = !1,
                                a = function(t, e) {
                                    this._reject(e)
                                },
                                o = function(t, e) {
                                    e.promiseRejectionQueued = !0, e.bindingPromise._then(a, a, null, this, t)
                                },
                                s = function(t, e) {
                                    0 == (50397184 & this._bitField) && this._resolveCallback(e.target)
                                },
                                l = function(t, e) {
                                    e.promiseRejectionQueued || this._reject(t)
                                };
                            t.prototype.bind = function(a) {
                                r || (r = !0, t.prototype._propagateFrom = n.propagateFromFunction(), t.prototype._boundValue = n.boundValueFunction());
                                var c = i(a),
                                    u = new t(e);
                                u._propagateFrom(this, 1);
                                var d = this._target();
                                if (u._setBoundTo(c), c instanceof t) {
                                    var h = {
                                        promiseRejectionQueued: !1,
                                        promise: u,
                                        target: d,
                                        bindingPromise: c
                                    };
                                    d._then(e, o, void 0, u, h), c._then(s, l, void 0, u, h), u._setOnCancel(c)
                                } else u._resolveCallback(d);
                                return u
                            }, t.prototype._setBoundTo = function(t) {
                                void 0 !== t ? (this._bitField = 2097152 | this._bitField, this._boundTo = t) : this._bitField = -2097153 & this._bitField
                            }, t.prototype._isBound = function() {
                                return 2097152 == (2097152 & this._bitField)
                            }, t.bind = function(e, i) {
                                return t.resolve(i).bind(e)
                            }
                        }
                    }, {}],
                    4: [function(t, e, i) {
                        "use strict";
                        var n;
                        "undefined" != typeof Promise && (n = Promise);
                        var r = t("./promise")();
                        r.noConflict = function() {
                            try {
                                Promise === r && (Promise = n)
                            } catch (t) {}
                            return r
                        }, e.exports = r
                    }, {
                        "./promise": 22
                    }],
                    5: [function(t, e, i) {
                        "use strict";
                        var n = Object.create;
                        if (n) {
                            var r = n(null),
                                a = n(null);
                            r[" size"] = a[" size"] = 0
                        }
                        e.exports = function(e) {
                            var i = t("./util"),
                                n = i.canEvaluate;

                            function r(t) {
                                var n = this.pop(),
                                    r = function(t, n) {
                                        var r;
                                        if (null != t && (r = t[n]), "function" != typeof r) {
                                            var a = "Object " + i.classString(t) + " has no method '" + i.toString(n) + "'";
                                            throw new e.TypeError(a)
                                        }
                                        return r
                                    }(t, n);
                                return r.apply(t, this)
                            }

                            function a(t) {
                                return t[this]
                            }

                            function o(t) {
                                var e = +this;
                                return e < 0 && (e = Math.max(0, e + t.length)), t[e]
                            }
                            i.isIdentifier, e.prototype.call = function(t) {
                                var e = [].slice.call(arguments, 1);
                                return e.push(t), this._then(r, void 0, void 0, e, void 0)
                            }, e.prototype.get = function(t) {
                                var e, i = "number" == typeof t;
                                if (i) e = o;
                                else if (n) {
                                    var r = (void 0)(t);
                                    e = null !== r ? r : a
                                } else e = a;
                                return this._then(e, void 0, void 0, t, void 0)
                            }
                        }
                    }, {
                        "./util": 36
                    }],
                    6: [function(t, e, i) {
                        "use strict";
                        e.exports = function(e, i, n, r) {
                            var a = t("./util"),
                                o = a.tryCatch,
                                s = a.errorObj,
                                l = e._async;
                            e.prototype.break = e.prototype.cancel = function() {
                                if (!r.cancellation()) return this._warn("cancellation is disabled");
                                for (var t = this, e = t; t._isCancellable();) {
                                    if (!t._cancelBy(e)) {
                                        e._isFollowing() ? e._followee().cancel() : e._cancelBranched();
                                        break
                                    }
                                    var i = t._cancellationParent;
                                    if (null == i || !i._isCancellable()) {
                                        t._isFollowing() ? t._followee().cancel() : t._cancelBranched();
                                        break
                                    }
                                    t._isFollowing() && t._followee().cancel(), t._setWillBeCancelled(), e = t, t = i
                                }
                            }, e.prototype._branchHasCancelled = function() {
                                this._branchesRemainingToCancel--
                            }, e.prototype._enoughBranchesHaveCancelled = function() {
                                return void 0 === this._branchesRemainingToCancel || this._branchesRemainingToCancel <= 0
                            }, e.prototype._cancelBy = function(t) {
                                return t === this ? (this._branchesRemainingToCancel = 0, this._invokeOnCancel(), !0) : (this._branchHasCancelled(), !!this._enoughBranchesHaveCancelled() && (this._invokeOnCancel(), !0))
                            }, e.prototype._cancelBranched = function() {
                                this._enoughBranchesHaveCancelled() && this._cancel()
                            }, e.prototype._cancel = function() {
                                this._isCancellable() && (this._setCancelled(), l.invoke(this._cancelPromises, this, void 0))
                            }, e.prototype._cancelPromises = function() {
                                this._length() > 0 && this._settlePromises()
                            }, e.prototype._unsetOnCancel = function() {
                                this._onCancelField = void 0
                            }, e.prototype._isCancellable = function() {
                                return this.isPending() && !this._isCancelled()
                            }, e.prototype.isCancellable = function() {
                                return this.isPending() && !this.isCancelled()
                            }, e.prototype._doInvokeOnCancel = function(t, e) {
                                if (a.isArray(t))
                                    for (var i = 0; i < t.length; ++i) this._doInvokeOnCancel(t[i], e);
                                else if (void 0 !== t)
                                    if ("function" == typeof t) {
                                        if (!e) {
                                            var n = o(t).call(this._boundValue());
                                            n === s && (this._attachExtraTrace(n.e), l.throwLater(n.e))
                                        }
                                    } else t._resultCancelled(this)
                            }, e.prototype._invokeOnCancel = function() {
                                var t = this._onCancel();
                                this._unsetOnCancel(), l.invoke(this._doInvokeOnCancel, this, t)
                            }, e.prototype._invokeInternalOnCancel = function() {
                                this._isCancellable() && (this._doInvokeOnCancel(this._onCancel(), !0), this._unsetOnCancel())
                            }, e.prototype._resultCancelled = function() {
                                this.cancel()
                            }
                        }
                    }, {
                        "./util": 36
                    }],
                    7: [function(t, e, i) {
                        "use strict";
                        e.exports = function(e) {
                            var i = t("./util"),
                                n = t("./es5").keys,
                                r = i.tryCatch,
                                a = i.errorObj;
                            return function(t, o, s) {
                                return function(l) {
                                    var c = s._boundValue();
                                    t: for (var u = 0; u < t.length; ++u) {
                                        var d = t[u];
                                        if (d === Error || null != d && d.prototype instanceof Error) {
                                            if (l instanceof d) return r(o).call(c, l)
                                        } else if ("function" == typeof d) {
                                            var h = r(d).call(c, l);
                                            if (h === a) return h;
                                            if (h) return r(o).call(c, l)
                                        } else if (i.isObject(l)) {
                                            for (var f = n(d), _ = 0; _ < f.length; ++_) {
                                                var g = f[_];
                                                if (d[g] != l[g]) continue t
                                            }
                                            return r(o).call(c, l)
                                        }
                                    }
                                    return e
                                }
                            }
                        }
                    }, {
                        "./es5": 13,
                        "./util": 36
                    }],
                    8: [function(t, e, i) {
                        "use strict";
                        e.exports = function(t) {
                            var e = !1,
                                i = [];

                            function n() {
                                this._trace = new n.CapturedTrace(r())
                            }

                            function r() {
                                var t = i.length - 1;
                                if (t >= 0) return i[t]
                            }
                            return t.prototype._promiseCreated = function() {}, t.prototype._pushContext = function() {}, t.prototype._popContext = function() {
                                return null
                            }, t._peekContext = t.prototype._peekContext = function() {}, n.prototype._pushContext = function() {
                                void 0 !== this._trace && (this._trace._promiseCreated = null, i.push(this._trace))
                            }, n.prototype._popContext = function() {
                                if (void 0 !== this._trace) {
                                    var t = i.pop(),
                                        e = t._promiseCreated;
                                    return t._promiseCreated = null, e
                                }
                                return null
                            }, n.CapturedTrace = null, n.create = function() {
                                if (e) return new n
                            }, n.deactivateLongStackTraces = function() {}, n.activateLongStackTraces = function() {
                                var i = t.prototype._pushContext,
                                    a = t.prototype._popContext,
                                    o = t._peekContext,
                                    s = t.prototype._peekContext,
                                    l = t.prototype._promiseCreated;
                                n.deactivateLongStackTraces = function() {
                                    t.prototype._pushContext = i, t.prototype._popContext = a, t._peekContext = o, t.prototype._peekContext = s, t.prototype._promiseCreated = l, e = !1
                                }, e = !0, t.prototype._pushContext = n.prototype._pushContext, t.prototype._popContext = n.prototype._popContext, t._peekContext = t.prototype._peekContext = r, t.prototype._promiseCreated = function() {
                                    var t = this._peekContext();
                                    t && null == t._promiseCreated && (t._promiseCreated = this)
                                }
                            }, n
                        }
                    }, {}],
                    9: [function(t, i, n) {
                        "use strict";
                        i.exports = function(i, n) {
                            var r, a, o, s = i._getDomain,
                                l = i._async,
                                c = t("./errors").Warning,
                                u = t("./util"),
                                d = t("./es5"),
                                h = u.canAttachTrace,
                                f = /[\\\/]bluebird[\\\/]js[\\\/](release|debug|instrumented)/,
                                _ = /\((?:timers\.js):\d+:\d+\)/,
                                g = /[\/<\(](.+?):(\d+):(\d+)\)?\s*$/,
                                p = null,
                                v = null,
                                m = !1,
                                y = !(0 == u.env("BLUEBIRD_DEBUG")),
                                b = !(0 == u.env("BLUEBIRD_WARNINGS") || !y && !u.env("BLUEBIRD_WARNINGS")),
                                k = !(0 == u.env("BLUEBIRD_LONG_STACK_TRACES") || !y && !u.env("BLUEBIRD_LONG_STACK_TRACES")),
                                w = 0 != u.env("BLUEBIRD_W_FORGOTTEN_RETURN") && (b || !!u.env("BLUEBIRD_W_FORGOTTEN_RETURN"));
                            i.prototype.suppressUnhandledRejections = function() {
                                var t = this._target();
                                t._bitField = -1048577 & t._bitField | 524288
                            }, i.prototype._ensurePossibleRejectionHandled = function() {
                                if (0 == (524288 & this._bitField)) {
                                    this._setRejectionIsUnhandled();
                                    var t = this;
                                    setTimeout(function() {
                                        t._notifyUnhandledRejection()
                                    }, 1)
                                }
                            }, i.prototype._notifyUnhandledRejectionIsHandled = function() {
                                U("rejectionHandled", r, void 0, this)
                            }, i.prototype._setReturnedNonUndefined = function() {
                                this._bitField = 268435456 | this._bitField
                            }, i.prototype._returnedNonUndefined = function() {
                                return 0 != (268435456 & this._bitField)
                            }, i.prototype._notifyUnhandledRejection = function() {
                                if (this._isRejectionUnhandled()) {
                                    var t = this._settledValue();
                                    this._setUnhandledRejectionIsNotified(), U("unhandledRejection", a, t, this)
                                }
                            }, i.prototype._setUnhandledRejectionIsNotified = function() {
                                this._bitField = 262144 | this._bitField
                            }, i.prototype._unsetUnhandledRejectionIsNotified = function() {
                                this._bitField = -262145 & this._bitField
                            }, i.prototype._isUnhandledRejectionNotified = function() {
                                return (262144 & this._bitField) > 0
                            }, i.prototype._setRejectionIsUnhandled = function() {
                                this._bitField = 1048576 | this._bitField
                            }, i.prototype._unsetRejectionIsUnhandled = function() {
                                this._bitField = -1048577 & this._bitField, this._isUnhandledRejectionNotified() && (this._unsetUnhandledRejectionIsNotified(), this._notifyUnhandledRejectionIsHandled())
                            }, i.prototype._isRejectionUnhandled = function() {
                                return (1048576 & this._bitField) > 0
                            }, i.prototype._warn = function(t, e, i) {
                                return F(t, e, i || this)
                            }, i.onPossiblyUnhandledRejection = function(t) {
                                var e = s();
                                a = "function" == typeof t ? null === e ? t : u.domainBind(e, t) : void 0
                            }, i.onUnhandledRejectionHandled = function(t) {
                                var e = s();
                                r = "function" == typeof t ? null === e ? t : u.domainBind(e, t) : void 0
                            };
                            var x = function() {};
                            i.longStackTraces = function() {
                                if (l.haveItemsQueued() && !Z.longStackTraces) throw new Error("cannot enable long stack traces after promises have been created\n\n    See http://goo.gl/MqrFmX\n");
                                if (!Z.longStackTraces && q()) {
                                    var t = i.prototype._captureStackTrace,
                                        e = i.prototype._attachExtraTrace,
                                        r = i.prototype._dereferenceTrace;
                                    Z.longStackTraces = !0, x = function() {
                                        if (l.haveItemsQueued() && !Z.longStackTraces) throw new Error("cannot enable long stack traces after promises have been created\n\n    See http://goo.gl/MqrFmX\n");
                                        i.prototype._captureStackTrace = t, i.prototype._attachExtraTrace = e, i.prototype._dereferenceTrace = r, n.deactivateLongStackTraces(), l.enableTrampoline(), Z.longStackTraces = !1
                                    }, i.prototype._captureStackTrace = j, i.prototype._attachExtraTrace = H, i.prototype._dereferenceTrace = z, n.activateLongStackTraces(), l.disableTrampolineIfNecessary()
                                }
                            }, i.hasLongStackTraces = function() {
                                return Z.longStackTraces && q()
                            };
                            var $ = function() {
                                    try {
                                        if ("function" == typeof CustomEvent) {
                                            var t = new CustomEvent("CustomEvent");
                                            return u.global.dispatchEvent(t),
                                                function(t, e) {
                                                    var i = {
                                                        detail: e,
                                                        cancelable: !0
                                                    };
                                                    d.defineProperty(i, "promise", {
                                                        value: e.promise
                                                    }), d.defineProperty(i, "reason", {
                                                        value: e.reason
                                                    });
                                                    var n = new CustomEvent(t.toLowerCase(), i);
                                                    return !u.global.dispatchEvent(n)
                                                }
                                        }
                                        if ("function" == typeof Event) {
                                            var t = new Event("CustomEvent");
                                            return u.global.dispatchEvent(t),
                                                function(t, e) {
                                                    var i = new Event(t.toLowerCase(), {
                                                        cancelable: !0
                                                    });
                                                    return i.detail = e, d.defineProperty(i, "promise", {
                                                        value: e.promise
                                                    }), d.defineProperty(i, "reason", {
                                                        value: e.reason
                                                    }), !u.global.dispatchEvent(i)
                                                }
                                        }
                                        var t = document.createEvent("CustomEvent");
                                        return t.initCustomEvent("testingtheevent", !1, !0, {}), u.global.dispatchEvent(t),
                                            function(t, e) {
                                                var i = document.createEvent("CustomEvent");
                                                return i.initCustomEvent(t.toLowerCase(), !1, !0, e), !u.global.dispatchEvent(i)
                                            }
                                    } catch (t) {}
                                    return function() {
                                        return !1
                                    }
                                }(),
                                S = u.isNode ? function() {
                                    return e.emit.apply(e, arguments)
                                } : u.global ? function(t) {
                                    var e = "on" + t.toLowerCase(),
                                        i = u.global[e];
                                    return !!i && (i.apply(u.global, [].slice.call(arguments, 1)), !0)
                                } : function() {
                                    return !1
                                };

                            function C(t, e) {
                                return {
                                    promise: e
                                }
                            }
                            var T = {
                                    promiseCreated: C,
                                    promiseFulfilled: C,
                                    promiseRejected: C,
                                    promiseResolved: C,
                                    promiseCancelled: C,
                                    promiseChained: function(t, e, i) {
                                        return {
                                            promise: e,
                                            child: i
                                        }
                                    },
                                    warning: function(t, e) {
                                        return {
                                            warning: e
                                        }
                                    },
                                    unhandledRejection: function(t, e, i) {
                                        return {
                                            reason: e,
                                            promise: i
                                        }
                                    },
                                    rejectionHandled: C
                                },
                                E = function(t) {
                                    var e = !1;
                                    try {
                                        e = S.apply(null, arguments)
                                    } catch (t) {
                                        l.throwLater(t), e = !0
                                    }
                                    var i = !1;
                                    try {
                                        i = $(t, T[t].apply(null, arguments))
                                    } catch (t) {
                                        l.throwLater(t), i = !0
                                    }
                                    return i || e
                                };

                            function D() {
                                return !1
                            }

                            function I(t, e, i) {
                                var n = this;
                                try {
                                    t(e, i, function(t) {
                                        if ("function" != typeof t) throw new TypeError("onCancel must be a function, got: " + u.toString(t));
                                        n._attachCancellationCallback(t)
                                    })
                                } catch (t) {
                                    return t
                                }
                            }

                            function A(t) {
                                if (!this._isCancellable()) return this;
                                var e = this._onCancel();
                                void 0 !== e ? u.isArray(e) ? e.push(t) : this._setOnCancel([e, t]) : this._setOnCancel(t)
                            }

                            function M() {
                                return this._onCancelField
                            }

                            function P(t) {
                                this._onCancelField = t
                            }

                            function L() {
                                this._cancellationParent = void 0, this._onCancelField = void 0
                            }

                            function N(t, e) {
                                if (0 != (1 & e)) {
                                    this._cancellationParent = t;
                                    var i = t._branchesRemainingToCancel;
                                    void 0 === i && (i = 0), t._branchesRemainingToCancel = i + 1
                                }
                                0 != (2 & e) && t._isBound() && this._setBoundTo(t._boundTo)
                            }
                            i.config = function(t) {
                                if ("longStackTraces" in (t = Object(t)) && (t.longStackTraces ? i.longStackTraces() : !t.longStackTraces && i.hasLongStackTraces() && x()), "warnings" in t) {
                                    var e = t.warnings;
                                    Z.warnings = !!e, w = Z.warnings, u.isObject(e) && "wForgottenReturn" in e && (w = !!e.wForgottenReturn)
                                }
                                if ("cancellation" in t && t.cancellation && !Z.cancellation) {
                                    if (l.haveItemsQueued()) throw new Error("cannot enable cancellation after promises are in use");
                                    i.prototype._clearCancellationData = L, i.prototype._propagateFrom = N, i.prototype._onCancel = M, i.prototype._setOnCancel = P, i.prototype._attachCancellationCallback = A, i.prototype._execute = I, O = N, Z.cancellation = !0
                                }
                                return "monitoring" in t && (t.monitoring && !Z.monitoring ? (Z.monitoring = !0, i.prototype._fireEvent = E) : !t.monitoring && Z.monitoring && (Z.monitoring = !1, i.prototype._fireEvent = D)), i
                            }, i.prototype._fireEvent = D, i.prototype._execute = function(t, e, i) {
                                try {
                                    t(e, i)
                                } catch (t) {
                                    return t
                                }
                            }, i.prototype._onCancel = function() {}, i.prototype._setOnCancel = function(t) {}, i.prototype._attachCancellationCallback = function(t) {}, i.prototype._captureStackTrace = function() {}, i.prototype._attachExtraTrace = function() {}, i.prototype._dereferenceTrace = function() {}, i.prototype._clearCancellationData = function() {}, i.prototype._propagateFrom = function(t, e) {};
                            var O = function(t, e) {
                                0 != (2 & e) && t._isBound() && this._setBoundTo(t._boundTo)
                            };

                            function R() {
                                var t = this._boundTo;
                                return void 0 !== t && t instanceof i ? t.isFulfilled() ? t.value() : void 0 : t
                            }

                            function j() {
                                this._trace = new J(this._peekContext())
                            }

                            function H(t, e) {
                                if (h(t)) {
                                    var i = this._trace;
                                    if (void 0 !== i && e && (i = i._parent), void 0 !== i) i.attachExtraTrace(t);
                                    else if (!t.__stackCleaned__) {
                                        var n = V(t);
                                        u.notEnumerableProp(t, "stack", n.message + "\n" + n.stack.join("\n")), u.notEnumerableProp(t, "__stackCleaned__", !0)
                                    }
                                }
                            }

                            function z() {
                                this._trace = void 0
                            }

                            function F(t, e, n) {
                                if (Z.warnings) {
                                    var r, a = new c(t);
                                    if (e) n._attachExtraTrace(a);
                                    else if (Z.longStackTraces && (r = i._peekContext())) r.attachExtraTrace(a);
                                    else {
                                        var o = V(a);
                                        a.stack = o.message + "\n" + o.stack.join("\n")
                                    }
                                    E("warning", a) || W(a, "", !0)
                                }
                            }

                            function B(t) {
                                for (var e = [], i = 0; i < t.length; ++i) {
                                    var n = t[i],
                                        r = "    (No stack trace)" === n || p.test(n),
                                        a = r && Y(n);
                                    r && !a && (m && " " !== n.charAt(0) && (n = "    " + n), e.push(n))
                                }
                                return e
                            }

                            function V(t) {
                                var e = t.stack,
                                    i = t.toString();
                                return e = "string" == typeof e && e.length > 0 ? function(t) {
                                    for (var e = t.stack.replace(/\s+$/g, "").split("\n"), i = 0; i < e.length; ++i) {
                                        var n = e[i];
                                        if ("    (No stack trace)" === n || p.test(n)) break
                                    }
                                    return i > 0 && "SyntaxError" != t.name && (e = e.slice(i)), e
                                }(t) : ["    (No stack trace)"], {
                                    message: i,
                                    stack: "SyntaxError" == t.name ? e : B(e)
                                }
                            }

                            function W(t, e, i) {
                                if ("undefined" != typeof console) {
                                    var n;
                                    if (u.isObject(t)) {
                                        var r = t.stack;
                                        n = e + v(r, t)
                                    } else n = e + String(t);
                                    "function" == typeof o ? o(n, i) : "function" != typeof console.log && "object" != typeof console.log || console.log(n)
                                }
                            }

                            function U(t, e, i, n) {
                                var r = !1;
                                try {
                                    "function" == typeof e && (r = !0, "rejectionHandled" === t ? e(n) : e(i, n))
                                } catch (t) {
                                    l.throwLater(t)
                                }
                                "unhandledRejection" === t ? E(t, i, n) || r || W(i, "Unhandled rejection ") : E(t, n)
                            }

                            function G(t) {
                                var e;
                                if ("function" == typeof t) e = "[function " + (t.name || "anonymous") + "]";
                                else {
                                    if (e = t && "function" == typeof t.toString ? t.toString() : u.toString(t), /\[object [a-zA-Z0-9$_]+\]/.test(e)) try {
                                        var i = JSON.stringify(t);
                                        e = i
                                    } catch (t) {}
                                    0 === e.length && (e = "(empty array)")
                                }
                                return "(<" + function(t) {
                                    return t.length < 41 ? t : t.substr(0, 38) + "..."
                                }(e) + ">, no stack trace)"
                            }

                            function q() {
                                return "function" == typeof Q
                            }
                            var Y = function() {
                                    return !1
                                },
                                X = /[\/<\(]([^:\/]+):(\d+):(?:\d+)\)?\s*$/;

                            function K(t) {
                                var e = t.match(X);
                                if (e) return {
                                    fileName: e[1],
                                    line: parseInt(e[2], 10)
                                }
                            }

                            function J(t) {
                                this._parent = t, this._promisesCreated = 0;
                                var e = this._length = 1 + (void 0 === t ? 0 : t._length);
                                Q(this, J), e > 32 && this.uncycle()
                            }
                            u.inherits(J, Error), n.CapturedTrace = J, J.prototype.uncycle = function() {
                                var t = this._length;
                                if (!(t < 2)) {
                                    for (var e = [], i = {}, n = 0, r = this; void 0 !== r; ++n) e.push(r), r = r._parent;
                                    for (var n = (t = this._length = n) - 1; n >= 0; --n) {
                                        var a = e[n].stack;
                                        void 0 === i[a] && (i[a] = n)
                                    }
                                    for (var n = 0; n < t; ++n) {
                                        var o = e[n].stack,
                                            s = i[o];
                                        if (void 0 !== s && s !== n) {
                                            s > 0 && (e[s - 1]._parent = void 0, e[s - 1]._length = 1), e[n]._parent = void 0, e[n]._length = 1;
                                            var l = n > 0 ? e[n - 1] : this;
                                            s < t - 1 ? (l._parent = e[s + 1], l._parent.uncycle(), l._length = l._parent._length + 1) : (l._parent = void 0, l._length = 1);
                                            for (var c = l._length + 1, u = n - 2; u >= 0; --u) e[u]._length = c, c++;
                                            return
                                        }
                                    }
                                }
                            }, J.prototype.attachExtraTrace = function(t) {
                                if (!t.__stackCleaned__) {
                                    this.uncycle();
                                    for (var e = V(t), i = e.message, n = [e.stack], r = this; void 0 !== r;) n.push(B(r.stack.split("\n"))), r = r._parent;
                                    ! function(t) {
                                        for (var e = t[0], i = 1; i < t.length; ++i) {
                                            for (var n = t[i], r = e.length - 1, a = e[r], o = -1, s = n.length - 1; s >= 0; --s)
                                                if (n[s] === a) {
                                                    o = s;
                                                    break
                                                }
                                            for (var s = o; s >= 0; --s) {
                                                var l = n[s];
                                                if (e[r] !== l) break;
                                                e.pop(), r--
                                            }
                                            e = n
                                        }
                                    }(n),
                                    function(t) {
                                        for (var e = 0; e < t.length; ++e)(0 === t[e].length || e + 1 < t.length && t[e][0] === t[e + 1][0]) && (t.splice(e, 1), e--)
                                    }(n), u.notEnumerableProp(t, "stack", function(t, e) {
                                        for (var i = 0; i < e.length - 1; ++i) e[i].push("From previous event:"), e[i] = e[i].join("\n");
                                        return i < e.length && (e[i] = e[i].join("\n")), t + "\n" + e.join("\n")
                                    }(i, n)), u.notEnumerableProp(t, "__stackCleaned__", !0)
                                }
                            };
                            var Q = function() {
                                var t = /^\s*at\s*/,
                                    e = function(t, e) {
                                        return "string" == typeof t ? t : void 0 !== e.name && void 0 !== e.message ? e.toString() : G(e)
                                    };
                                if ("number" == typeof Error.stackTraceLimit && "function" == typeof Error.captureStackTrace) {
                                    Error.stackTraceLimit += 6, p = t, v = e;
                                    var i = Error.captureStackTrace;
                                    return Y = function(t) {
                                            return f.test(t)
                                        },
                                        function(t, e) {
                                            Error.stackTraceLimit += 6, i(t, e), Error.stackTraceLimit -= 6
                                        }
                                }
                                var n, r = new Error;
                                if ("string" == typeof r.stack && r.stack.split("\n")[0].indexOf("stackDetection@") >= 0) return p = /@/, v = e, m = !0,
                                    function(t) {
                                        t.stack = (new Error).stack
                                    };
                                try {
                                    throw new Error
                                } catch (t) {
                                    n = "stack" in t
                                }
                                return "stack" in r || !n || "number" != typeof Error.stackTraceLimit ? (v = function(t, e) {
                                    return "string" == typeof t ? t : "object" != typeof e && "function" != typeof e || void 0 === e.name || void 0 === e.message ? G(e) : e.toString()
                                }, null) : (p = t, v = e, function(t) {
                                    Error.stackTraceLimit += 6;
                                    try {
                                        throw new Error
                                    } catch (e) {
                                        t.stack = e.stack
                                    }
                                    Error.stackTraceLimit -= 6
                                })
                            }();
                            "undefined" != typeof console && void 0 !== console.warn && (o = function(t) {
                                console.warn(t)
                            }, u.isNode && e.stderr.isTTY ? o = function(t, e) {
                                var i = e ? "[33m" : "[31m";
                                console.warn(i + t + "[0m\n")
                            } : u.isNode || "string" != typeof(new Error).stack || (o = function(t, e) {
                                console.warn("%c" + t, e ? "color: darkorange" : "color: red")
                            }));
                            var Z = {
                                warnings: b,
                                longStackTraces: !1,
                                cancellation: !1,
                                monitoring: !1
                            };
                            return k && i.longStackTraces(), {
                                longStackTraces: function() {
                                    return Z.longStackTraces
                                },
                                warnings: function() {
                                    return Z.warnings
                                },
                                cancellation: function() {
                                    return Z.cancellation
                                },
                                monitoring: function() {
                                    return Z.monitoring
                                },
                                propagateFromFunction: function() {
                                    return O
                                },
                                boundValueFunction: function() {
                                    return R
                                },
                                checkForgottenReturns: function(t, e, i, n, r) {
                                    if (void 0 === t && null !== e && w) {
                                        if (void 0 !== r && r._returnedNonUndefined()) return;
                                        if (0 == (65535 & n._bitField)) return;
                                        i && (i += " ");
                                        var a = "",
                                            o = "";
                                        if (e._trace) {
                                            for (var s = e._trace.stack.split("\n"), l = B(s), c = l.length - 1; c >= 0; --c) {
                                                var u = l[c];
                                                if (!_.test(u)) {
                                                    var d = u.match(g);
                                                    d && (a = "at " + d[1] + ":" + d[2] + ":" + d[3] + " ");
                                                    break
                                                }
                                            }
                                            if (l.length > 0)
                                                for (var h = l[0], c = 0; c < s.length; ++c)
                                                    if (s[c] === h) {
                                                        c > 0 && (o = "\n" + s[c - 1]);
                                                        break
                                                    }
                                        }
                                        var f = "a promise was created in a " + i + "handler " + a + "but was not returned from it, see http://goo.gl/rRqMUw" + o;
                                        n._warn(f, !0, e)
                                    }
                                },
                                setBounds: function(t, e) {
                                    if (q()) {
                                        for (var i, n, r = t.stack.split("\n"), a = e.stack.split("\n"), o = -1, s = -1, l = 0; l < r.length; ++l) {
                                            var c = K(r[l]);
                                            if (c) {
                                                i = c.fileName, o = c.line;
                                                break
                                            }
                                        }
                                        for (var l = 0; l < a.length; ++l) {
                                            var c = K(a[l]);
                                            if (c) {
                                                n = c.fileName, s = c.line;
                                                break
                                            }
                                        }
                                        o < 0 || s < 0 || !i || !n || i !== n || o >= s || (Y = function(t) {
                                            if (f.test(t)) return !0;
                                            var e = K(t);
                                            return !!(e && e.fileName === i && o <= e.line && e.line <= s)
                                        })
                                    }
                                },
                                warn: F,
                                deprecated: function(t, e) {
                                    var i = t + " is deprecated and will be removed in a future version.";
                                    return e && (i += " Use " + e + " instead."), F(i)
                                },
                                CapturedTrace: J,
                                fireDomEvent: $,
                                fireGlobalEvent: S
                            }
                        }
                    }, {
                        "./errors": 12,
                        "./es5": 13,
                        "./util": 36
                    }],
                    10: [function(t, e, i) {
                        "use strict";
                        e.exports = function(t) {
                            function e() {
                                return this.value
                            }

                            function i() {
                                throw this.reason
                            }
                            t.prototype.return = t.prototype.thenReturn = function(i) {
                                return i instanceof t && i.suppressUnhandledRejections(), this._then(e, void 0, void 0, {
                                    value: i
                                }, void 0)
                            }, t.prototype.throw = t.prototype.thenThrow = function(t) {
                                return this._then(i, void 0, void 0, {
                                    reason: t
                                }, void 0)
                            }, t.prototype.catchThrow = function(t) {
                                if (arguments.length <= 1) return this._then(void 0, i, void 0, {
                                    reason: t
                                }, void 0);
                                var e = arguments[1];
                                return this.caught(t, function() {
                                    throw e
                                })
                            }, t.prototype.catchReturn = function(i) {
                                if (arguments.length <= 1) return i instanceof t && i.suppressUnhandledRejections(), this._then(void 0, e, void 0, {
                                    value: i
                                }, void 0);
                                var n = arguments[1];
                                return n instanceof t && n.suppressUnhandledRejections(), this.caught(i, function() {
                                    return n
                                })
                            }
                        }
                    }, {}],
                    11: [function(t, e, i) {
                        "use strict";
                        e.exports = function(t, e) {
                            var i = t.reduce,
                                n = t.all;

                            function r() {
                                return n(this)
                            }
                            t.prototype.each = function(t) {
                                return i(this, t, e, 0)._then(r, void 0, void 0, this, void 0)
                            }, t.prototype.mapSeries = function(t) {
                                return i(this, t, e, e)
                            }, t.each = function(t, n) {
                                return i(t, n, e, 0)._then(r, void 0, void 0, t, void 0)
                            }, t.mapSeries = function(t, n) {
                                return i(t, n, e, e)
                            }
                        }
                    }, {}],
                    12: [function(t, e, i) {
                        "use strict";
                        var n, r, a = t("./es5"),
                            o = a.freeze,
                            s = t("./util"),
                            l = s.inherits,
                            c = s.notEnumerableProp;

                        function u(t, e) {
                            function i(n) {
                                if (!(this instanceof i)) return new i(n);
                                c(this, "message", "string" == typeof n ? n : e), c(this, "name", t), Error.captureStackTrace ? Error.captureStackTrace(this, this.constructor) : Error.call(this)
                            }
                            return l(i, Error), i
                        }
                        var d = u("Warning", "warning"),
                            h = u("CancellationError", "cancellation error"),
                            f = u("TimeoutError", "timeout error"),
                            _ = u("AggregateError", "aggregate error");
                        try {
                            n = TypeError, r = RangeError
                        } catch (t) {
                            n = u("TypeError", "type error"), r = u("RangeError", "range error")
                        }
                        for (var g = "join pop push shift unshift slice filter forEach some every map indexOf lastIndexOf reduce reduceRight sort reverse".split(" "), p = 0; p < g.length; ++p) "function" == typeof Array.prototype[g[p]] && (_.prototype[g[p]] = Array.prototype[g[p]]);
                        a.defineProperty(_.prototype, "length", {
                            value: 0,
                            configurable: !1,
                            writable: !0,
                            enumerable: !0
                        }), _.prototype.isOperational = !0;
                        var v = 0;

                        function m(t) {
                            if (!(this instanceof m)) return new m(t);
                            c(this, "name", "OperationalError"), c(this, "message", t), this.cause = t, this.isOperational = !0, t instanceof Error ? (c(this, "message", t.message), c(this, "stack", t.stack)) : Error.captureStackTrace && Error.captureStackTrace(this, this.constructor)
                        }
                        _.prototype.toString = function() {
                            var t = Array(4 * v + 1).join(" "),
                                e = "\n" + t + "AggregateError of:\n";
                            v++, t = Array(4 * v + 1).join(" ");
                            for (var i = 0; i < this.length; ++i) {
                                for (var n = this[i] === this ? "[Circular AggregateError]" : this[i] + "", r = n.split("\n"), a = 0; a < r.length; ++a) r[a] = t + r[a];
                                n = r.join("\n"), e += n + "\n"
                            }
                            return v--, e
                        }, l(m, Error);
                        var y = Error.__BluebirdErrorTypes__;
                        y || (y = o({
                            CancellationError: h,
                            TimeoutError: f,
                            OperationalError: m,
                            RejectionError: m,
                            AggregateError: _
                        }), a.defineProperty(Error, "__BluebirdErrorTypes__", {
                            value: y,
                            writable: !1,
                            enumerable: !1,
                            configurable: !1
                        })), e.exports = {
                            Error: Error,
                            TypeError: n,
                            RangeError: r,
                            CancellationError: y.CancellationError,
                            OperationalError: y.OperationalError,
                            TimeoutError: y.TimeoutError,
                            AggregateError: y.AggregateError,
                            Warning: d
                        }
                    }, {
                        "./es5": 13,
                        "./util": 36
                    }],
                    13: [function(t, e, i) {
                        var n = function() {
                            "use strict";
                            return void 0 === this
                        }();
                        if (n) e.exports = {
                            freeze: Object.freeze,
                            defineProperty: Object.defineProperty,
                            getDescriptor: Object.getOwnPropertyDescriptor,
                            keys: Object.keys,
                            names: Object.getOwnPropertyNames,
                            getPrototypeOf: Object.getPrototypeOf,
                            isArray: Array.isArray,
                            isES5: n,
                            propertyIsWritable: function(t, e) {
                                var i = Object.getOwnPropertyDescriptor(t, e);
                                return !(i && !i.writable && !i.set)
                            }
                        };
                        else {
                            var r = {}.hasOwnProperty,
                                a = {}.toString,
                                o = {}.constructor.prototype,
                                s = function(t) {
                                    var e = [];
                                    for (var i in t) r.call(t, i) && e.push(i);
                                    return e
                                };
                            e.exports = {
                                isArray: function(t) {
                                    try {
                                        return "[object Array]" === a.call(t)
                                    } catch (t) {
                                        return !1
                                    }
                                },
                                keys: s,
                                names: s,
                                defineProperty: function(t, e, i) {
                                    return t[e] = i.value, t
                                },
                                getDescriptor: function(t, e) {
                                    return {
                                        value: t[e]
                                    }
                                },
                                freeze: function(t) {
                                    return t
                                },
                                getPrototypeOf: function(t) {
                                    try {
                                        return Object(t).constructor.prototype
                                    } catch (t) {
                                        return o
                                    }
                                },
                                isES5: n,
                                propertyIsWritable: function() {
                                    return !0
                                }
                            }
                        }
                    }, {}],
                    14: [function(t, e, i) {
                        "use strict";
                        e.exports = function(t, e) {
                            var i = t.map;
                            t.prototype.filter = function(t, n) {
                                return i(this, t, n, e)
                            }, t.filter = function(t, n, r) {
                                return i(t, n, r, e)
                            }
                        }
                    }, {}],
                    15: [function(t, e, i) {
                        "use strict";
                        e.exports = function(e, i, n) {
                            var r = t("./util"),
                                a = e.CancellationError,
                                o = r.errorObj,
                                s = t("./catch_filter")(n);

                            function l(t, e, i) {
                                this.promise = t, this.type = e, this.handler = i, this.called = !1, this.cancelPromise = null
                            }

                            function c(t) {
                                this.finallyHandler = t
                            }

                            function u(t, e) {
                                return null != t.cancelPromise && (arguments.length > 1 ? t.cancelPromise._reject(e) : t.cancelPromise._cancel(), t.cancelPromise = null, !0)
                            }

                            function d() {
                                return f.call(this, this.promise._target()._settledValue())
                            }

                            function h(t) {
                                if (!u(this, t)) return o.e = t, o
                            }

                            function f(t) {
                                var r = this.promise,
                                    s = this.handler;
                                if (!this.called) {
                                    this.called = !0;
                                    var l = this.isFinallyHandler() ? s.call(r._boundValue()) : s.call(r._boundValue(), t);
                                    if (l === n) return l;
                                    if (void 0 !== l) {
                                        r._setReturnedNonUndefined();
                                        var f = i(l, r);
                                        if (f instanceof e) {
                                            if (null != this.cancelPromise) {
                                                if (f._isCancelled()) {
                                                    var _ = new a("late cancellation observer");
                                                    return r._attachExtraTrace(_), o.e = _, o
                                                }
                                                f.isPending() && f._attachCancellationCallback(new c(this))
                                            }
                                            return f._then(d, h, void 0, this, void 0)
                                        }
                                    }
                                }
                                return r.isRejected() ? (u(this), o.e = t, o) : (u(this), t)
                            }
                            return l.prototype.isFinallyHandler = function() {
                                return 0 === this.type
                            }, c.prototype._resultCancelled = function() {
                                u(this.finallyHandler)
                            }, e.prototype._passThrough = function(t, e, i, n) {
                                return "function" != typeof t ? this.then() : this._then(i, n, void 0, new l(this, e, t), void 0)
                            }, e.prototype.lastly = e.prototype.finally = function(t) {
                                return this._passThrough(t, 0, f, f)
                            }, e.prototype.tap = function(t) {
                                return this._passThrough(t, 1, f)
                            }, e.prototype.tapCatch = function(t) {
                                var i = arguments.length;
                                if (1 === i) return this._passThrough(t, 1, void 0, f);
                                var n, a = new Array(i - 1),
                                    o = 0;
                                for (n = 0; n < i - 1; ++n) {
                                    var l = arguments[n];
                                    if (!r.isObject(l)) return e.reject(new TypeError("tapCatch statement predicate: expecting an object but got " + r.classString(l)));
                                    a[o++] = l
                                }
                                a.length = o;
                                var c = arguments[n];
                                return this._passThrough(s(a, c, this), 1, void 0, f)
                            }, l
                        }
                    }, {
                        "./catch_filter": 7,
                        "./util": 36
                    }],
                    16: [function(t, e, i) {
                        "use strict";
                        e.exports = function(e, i, n, r, a, o) {
                            var s = t("./errors"),
                                l = s.TypeError,
                                c = t("./util"),
                                u = c.errorObj,
                                d = c.tryCatch,
                                h = [];

                            function f(t, i, r, a) {
                                if (o.cancellation()) {
                                    var s = new e(n),
                                        l = this._finallyPromise = new e(n);
                                    this._promise = s.lastly(function() {
                                        return l
                                    }), s._captureStackTrace(), s._setOnCancel(this)
                                } else {
                                    var c = this._promise = new e(n);
                                    c._captureStackTrace()
                                }
                                this._stack = a, this._generatorFunction = t, this._receiver = i, this._generator = void 0, this._yieldHandlers = "function" == typeof r ? [r].concat(h) : h, this._yieldedPromise = null, this._cancellationPhase = !1
                            }
                            c.inherits(f, a), f.prototype._isResolved = function() {
                                return null === this._promise
                            }, f.prototype._cleanup = function() {
                                this._promise = this._generator = null, o.cancellation() && null !== this._finallyPromise && (this._finallyPromise._fulfill(), this._finallyPromise = null)
                            }, f.prototype._promiseCancelled = function() {
                                if (!this._isResolved()) {
                                    var t, i = void 0 !== this._generator.return;
                                    if (i) this._promise._pushContext(), t = d(this._generator.return).call(this._generator, void 0), this._promise._popContext();
                                    else {
                                        var n = new e.CancellationError("generator .return() sentinel");
                                        e.coroutine.returnSentinel = n, this._promise._attachExtraTrace(n), this._promise._pushContext(), t = d(this._generator.throw).call(this._generator, n), this._promise._popContext()
                                    }
                                    this._cancellationPhase = !0, this._yieldedPromise = null, this._continue(t)
                                }
                            }, f.prototype._promiseFulfilled = function(t) {
                                this._yieldedPromise = null, this._promise._pushContext();
                                var e = d(this._generator.next).call(this._generator, t);
                                this._promise._popContext(), this._continue(e)
                            }, f.prototype._promiseRejected = function(t) {
                                this._yieldedPromise = null, this._promise._attachExtraTrace(t), this._promise._pushContext();
                                var e = d(this._generator.throw).call(this._generator, t);
                                this._promise._popContext(), this._continue(e)
                            }, f.prototype._resultCancelled = function() {
                                if (this._yieldedPromise instanceof e) {
                                    var t = this._yieldedPromise;
                                    this._yieldedPromise = null, t.cancel()
                                }
                            }, f.prototype.promise = function() {
                                return this._promise
                            }, f.prototype._run = function() {
                                this._generator = this._generatorFunction.call(this._receiver), this._receiver = this._generatorFunction = void 0, this._promiseFulfilled(void 0)
                            }, f.prototype._continue = function(t) {
                                var i = this._promise;
                                if (t === u) return this._cleanup(), this._cancellationPhase ? i.cancel() : i._rejectCallback(t.e, !1);
                                var n = t.value;
                                if (!0 === t.done) return this._cleanup(), this._cancellationPhase ? i.cancel() : i._resolveCallback(n);
                                var a = r(n, this._promise);
                                if (a instanceof e || null !== (a = function(t, i, n) {
                                        for (var a = 0; a < i.length; ++a) {
                                            n._pushContext();
                                            var o = d(i[a])(t);
                                            if (n._popContext(), o === u) {
                                                n._pushContext();
                                                var s = e.reject(u.e);
                                                return n._popContext(), s
                                            }
                                            var l = r(o, n);
                                            if (l instanceof e) return l
                                        }
                                        return null
                                    }(a, this._yieldHandlers, this._promise))) {
                                    var o = (a = a._target())._bitField;
                                    0 == (50397184 & o) ? (this._yieldedPromise = a, a._proxy(this, null)) : 0 != (33554432 & o) ? e._async.invoke(this._promiseFulfilled, this, a._value()) : 0 != (16777216 & o) ? e._async.invoke(this._promiseRejected, this, a._reason()) : this._promiseCancelled()
                                } else this._promiseRejected(new l("A value %s was yielded that could not be treated as a promise\n\n    See http://goo.gl/MqrFmX\n\n".replace("%s", String(n)) + "From coroutine:\n" + this._stack.split("\n").slice(1, -7).join("\n")))
                            }, e.coroutine = function(t, e) {
                                if ("function" != typeof t) throw new l("generatorFunction must be a function\n\n    See http://goo.gl/MqrFmX\n");
                                var i = Object(e).yieldHandler,
                                    n = f,
                                    r = (new Error).stack;
                                return function() {
                                    var e = t.apply(this, arguments),
                                        a = new n(void 0, void 0, i, r),
                                        o = a.promise();
                                    return a._generator = e, a._promiseFulfilled(void 0), o
                                }
                            }, e.coroutine.addYieldHandler = function(t) {
                                if ("function" != typeof t) throw new l("expecting a function but got " + c.classString(t));
                                h.push(t)
                            }, e.spawn = function(t) {
                                if (o.deprecated("Promise.spawn()", "Promise.coroutine()"), "function" != typeof t) return i("generatorFunction must be a function\n\n    See http://goo.gl/MqrFmX\n");
                                var n = new f(t, this),
                                    r = n.promise();
                                return n._run(e.spawn), r
                            }
                        }
                    }, {
                        "./errors": 12,
                        "./util": 36
                    }],
                    17: [function(t, e, i) {
                        "use strict";
                        e.exports = function(e, i, n, r, a, o) {
                            var s = t("./util");
                            s.canEvaluate, s.tryCatch, s.errorObj, e.join = function() {
                                var t, e = arguments.length - 1;
                                e > 0 && "function" == typeof arguments[e] && (t = arguments[e]);
                                var n = [].slice.call(arguments);
                                t && n.pop();
                                var r = new i(n).promise();
                                return void 0 !== t ? r.spread(t) : r
                            }
                        }
                    }, {
                        "./util": 36
                    }],
                    18: [function(t, e, i) {
                        "use strict";
                        e.exports = function(e, i, n, r, a, o) {
                            var s = e._getDomain,
                                l = t("./util"),
                                c = l.tryCatch,
                                u = l.errorObj,
                                d = e._async;

                            function h(t, e, i, n) {
                                this.constructor$(t), this._promise._captureStackTrace();
                                var r = s();
                                this._callback = null === r ? e : l.domainBind(r, e), this._preservedValues = n === a ? new Array(this.length()) : null, this._limit = i, this._inFlight = 0, this._queue = [], d.invoke(this._asyncInit, this, void 0)
                            }

                            function f(t, i, r, a) {
                                if ("function" != typeof i) return n("expecting a function but got " + l.classString(i));
                                var o = 0;
                                if (void 0 !== r) {
                                    if ("object" != typeof r || null === r) return e.reject(new TypeError("options argument must be an object but it is " + l.classString(r)));
                                    if ("number" != typeof r.concurrency) return e.reject(new TypeError("'concurrency' must be a number but it is " + l.classString(r.concurrency)));
                                    o = r.concurrency
                                }
                                return o = "number" == typeof o && isFinite(o) && o >= 1 ? o : 0, new h(t, i, o, a).promise()
                            }
                            l.inherits(h, i), h.prototype._asyncInit = function() {
                                this._init$(void 0, -2)
                            }, h.prototype._init = function() {}, h.prototype._promiseFulfilled = function(t, i) {
                                var n = this._values,
                                    a = this.length(),
                                    s = this._preservedValues,
                                    l = this._limit;
                                if (i < 0) {
                                    if (n[i = -1 * i - 1] = t, l >= 1 && (this._inFlight--, this._drainQueue(), this._isResolved())) return !0
                                } else {
                                    if (l >= 1 && this._inFlight >= l) return n[i] = t, this._queue.push(i), !1;
                                    null !== s && (s[i] = t);
                                    var d = this._promise,
                                        h = this._callback,
                                        f = d._boundValue();
                                    d._pushContext();
                                    var _ = c(h).call(f, t, i, a),
                                        g = d._popContext();
                                    if (o.checkForgottenReturns(_, g, null !== s ? "Promise.filter" : "Promise.map", d), _ === u) return this._reject(_.e), !0;
                                    var p = r(_, this._promise);
                                    if (p instanceof e) {
                                        var v = (p = p._target())._bitField;
                                        if (0 == (50397184 & v)) return l >= 1 && this._inFlight++, n[i] = p, p._proxy(this, -1 * (i + 1)), !1;
                                        if (0 == (33554432 & v)) return 0 != (16777216 & v) ? (this._reject(p._reason()), !0) : (this._cancel(), !0);
                                        _ = p._value()
                                    }
                                    n[i] = _
                                }
                                var m = ++this._totalResolved;
                                return m >= a && (null !== s ? this._filter(n, s) : this._resolve(n), !0)
                            }, h.prototype._drainQueue = function() {
                                for (var t = this._queue, e = this._limit, i = this._values; t.length > 0 && this._inFlight < e;) {
                                    if (this._isResolved()) return;
                                    var n = t.pop();
                                    this._promiseFulfilled(i[n], n)
                                }
                            }, h.prototype._filter = function(t, e) {
                                for (var i = e.length, n = new Array(i), r = 0, a = 0; a < i; ++a) t[a] && (n[r++] = e[a]);
                                n.length = r, this._resolve(n)
                            }, h.prototype.preservedValues = function() {
                                return this._preservedValues
                            }, e.prototype.map = function(t, e) {
                                return f(this, t, e, null)
                            }, e.map = function(t, e, i, n) {
                                return f(t, e, i, n)
                            }
                        }
                    }, {
                        "./util": 36
                    }],
                    19: [function(t, e, i) {
                        "use strict";
                        e.exports = function(e, i, n, r, a) {
                            var o = t("./util"),
                                s = o.tryCatch;
                            e.method = function(t) {
                                if ("function" != typeof t) throw new e.TypeError("expecting a function but got " + o.classString(t));
                                return function() {
                                    var n = new e(i);
                                    n._captureStackTrace(), n._pushContext();
                                    var r = s(t).apply(this, arguments),
                                        o = n._popContext();
                                    return a.checkForgottenReturns(r, o, "Promise.method", n), n._resolveFromSyncValue(r), n
                                }
                            }, e.attempt = e.try = function(t) {
                                if ("function" != typeof t) return r("expecting a function but got " + o.classString(t));
                                var n, l = new e(i);
                                if (l._captureStackTrace(), l._pushContext(), arguments.length > 1) {
                                    a.deprecated("calling Promise.try with more than 1 argument");
                                    var c = arguments[1],
                                        u = arguments[2];
                                    n = o.isArray(c) ? s(t).apply(u, c) : s(t).call(u, c)
                                } else n = s(t)();
                                var d = l._popContext();
                                return a.checkForgottenReturns(n, d, "Promise.try", l), l._resolveFromSyncValue(n), l
                            }, e.prototype._resolveFromSyncValue = function(t) {
                                t === o.errorObj ? this._rejectCallback(t.e, !1) : this._resolveCallback(t, !0)
                            }
                        }
                    }, {
                        "./util": 36
                    }],
                    20: [function(t, e, i) {
                        "use strict";
                        var n = t("./util"),
                            r = n.maybeWrapAsError,
                            a = t("./errors"),
                            o = a.OperationalError,
                            s = t("./es5"),
                            l = /^(?:name|message|stack|cause)$/;

                        function c(t) {
                            var e;
                            if (function(t) {
                                    return t instanceof Error && s.getPrototypeOf(t) === Error.prototype
                                }(t)) {
                                (e = new o(t)).name = t.name, e.message = t.message, e.stack = t.stack;
                                for (var i = s.keys(t), r = 0; r < i.length; ++r) {
                                    var a = i[r];
                                    l.test(a) || (e[a] = t[a])
                                }
                                return e
                            }
                            return n.markAsOriginatingFromRejection(t), t
                        }
                        e.exports = function(t, e) {
                            return function(i, n) {
                                if (null !== t) {
                                    if (i) {
                                        var a = c(r(i));
                                        t._attachExtraTrace(a), t._reject(a)
                                    } else if (e) {
                                        var o = [].slice.call(arguments, 1);
                                        t._fulfill(o)
                                    } else t._fulfill(n);
                                    t = null
                                }
                            }
                        }
                    }, {
                        "./errors": 12,
                        "./es5": 13,
                        "./util": 36
                    }],
                    21: [function(t, e, i) {
                        "use strict";
                        e.exports = function(e) {
                            var i = t("./util"),
                                n = e._async,
                                r = i.tryCatch,
                                a = i.errorObj;

                            function o(t, e) {
                                if (!i.isArray(t)) return s.call(this, t, e);
                                var o = r(e).apply(this._boundValue(), [null].concat(t));
                                o === a && n.throwLater(o.e)
                            }

                            function s(t, e) {
                                var i = this._boundValue(),
                                    o = void 0 === t ? r(e).call(i, null) : r(e).call(i, null, t);
                                o === a && n.throwLater(o.e)
                            }

                            function l(t, e) {
                                if (!t) {
                                    var i = new Error(t + "");
                                    i.cause = t, t = i
                                }
                                var o = r(e).call(this._boundValue(), t);
                                o === a && n.throwLater(o.e)
                            }
                            e.prototype.asCallback = e.prototype.nodeify = function(t, e) {
                                if ("function" == typeof t) {
                                    var i = s;
                                    void 0 !== e && Object(e).spread && (i = o), this._then(i, l, void 0, this, t)
                                }
                                return this
                            }
                        }
                    }, {
                        "./util": 36
                    }],
                    22: [function(t, i, n) {
                        "use strict";
                        i.exports = function() {
                            var n = function() {
                                    return new _("circular promise resolution chain\n\n    See http://goo.gl/MqrFmX\n")
                                },
                                r = function() {
                                    return new D.PromiseInspection(this._target())
                                },
                                a = function(t) {
                                    return D.reject(new _(t))
                                };

                            function o() {}
                            var s, l = {},
                                c = t("./util");
                            s = c.isNode ? function() {
                                var t = e.domain;
                                return void 0 === t && (t = null), t
                            } : function() {
                                return null
                            }, c.notEnumerableProp(D, "_getDomain", s);
                            var u = t("./es5"),
                                d = t("./async"),
                                h = new d;
                            u.defineProperty(D, "_async", {
                                value: h
                            });
                            var f = t("./errors"),
                                _ = D.TypeError = f.TypeError;
                            D.RangeError = f.RangeError;
                            var g = D.CancellationError = f.CancellationError;
                            D.TimeoutError = f.TimeoutError, D.OperationalError = f.OperationalError, D.RejectionError = f.OperationalError, D.AggregateError = f.AggregateError;
                            var p = function() {},
                                v = {},
                                m = {},
                                y = t("./thenables")(D, p),
                                b = t("./promise_array")(D, p, y, a, o),
                                k = t("./context")(D),
                                w = k.create,
                                x = t("./debuggability")(D, k),
                                $ = (x.CapturedTrace, t("./finally")(D, y, m)),
                                S = t("./catch_filter")(m),
                                C = t("./nodeback"),
                                T = c.errorObj,
                                E = c.tryCatch;

                            function D(t) {
                                t !== p && function(t, e) {
                                    if (null == t || t.constructor !== D) throw new _("the promise constructor cannot be invoked directly\n\n    See http://goo.gl/MqrFmX\n");
                                    if ("function" != typeof e) throw new _("expecting a function but got " + c.classString(e))
                                }(this, t), this._bitField = 0, this._fulfillmentHandler0 = void 0, this._rejectionHandler0 = void 0, this._promise0 = void 0, this._receiver0 = void 0, this._resolveFromExecutor(t), this._promiseCreated(), this._fireEvent("promiseCreated", this)
                            }

                            function I(t) {
                                this.promise._resolveCallback(t)
                            }

                            function A(t) {
                                this.promise._rejectCallback(t, !1)
                            }

                            function M(t) {
                                var e = new D(p);
                                e._fulfillmentHandler0 = t, e._rejectionHandler0 = t, e._promise0 = t, e._receiver0 = t
                            }
                            return D.prototype.toString = function() {
                                return "[object Promise]"
                            }, D.prototype.caught = D.prototype.catch = function(t) {
                                var e = arguments.length;
                                if (e > 1) {
                                    var i, n = new Array(e - 1),
                                        r = 0;
                                    for (i = 0; i < e - 1; ++i) {
                                        var o = arguments[i];
                                        if (!c.isObject(o)) return a("Catch statement predicate: expecting an object but got " + c.classString(o));
                                        n[r++] = o
                                    }
                                    return n.length = r, t = arguments[i], this.then(void 0, S(n, t, this))
                                }
                                return this.then(void 0, t)
                            }, D.prototype.reflect = function() {
                                return this._then(r, r, void 0, this, void 0)
                            }, D.prototype.then = function(t, e) {
                                if (x.warnings() && arguments.length > 0 && "function" != typeof t && "function" != typeof e) {
                                    var i = ".then() only accepts functions but was passed: " + c.classString(t);
                                    arguments.length > 1 && (i += ", " + c.classString(e)), this._warn(i)
                                }
                                return this._then(t, e, void 0, void 0, void 0)
                            }, D.prototype.done = function(t, e) {
                                var i = this._then(t, e, void 0, void 0, void 0);
                                i._setIsFinal()
                            }, D.prototype.spread = function(t) {
                                return "function" != typeof t ? a("expecting a function but got " + c.classString(t)) : this.all()._then(t, void 0, void 0, v, void 0)
                            }, D.prototype.toJSON = function() {
                                var t = {
                                    isFulfilled: !1,
                                    isRejected: !1,
                                    fulfillmentValue: void 0,
                                    rejectionReason: void 0
                                };
                                return this.isFulfilled() ? (t.fulfillmentValue = this.value(), t.isFulfilled = !0) : this.isRejected() && (t.rejectionReason = this.reason(), t.isRejected = !0), t
                            }, D.prototype.all = function() {
                                return arguments.length > 0 && this._warn(".all() was passed arguments but it does not take any"), new b(this).promise()
                            }, D.prototype.error = function(t) {
                                return this.caught(c.originatesFromRejection, t)
                            }, D.getNewLibraryCopy = i.exports, D.is = function(t) {
                                return t instanceof D
                            }, D.fromNode = D.fromCallback = function(t) {
                                var e = new D(p);
                                e._captureStackTrace();
                                var i = arguments.length > 1 && !!Object(arguments[1]).multiArgs,
                                    n = E(t)(C(e, i));
                                return n === T && e._rejectCallback(n.e, !0), e._isFateSealed() || e._setAsyncGuaranteed(), e
                            }, D.all = function(t) {
                                return new b(t).promise()
                            }, D.cast = function(t) {
                                var e = y(t);
                                return e instanceof D || ((e = new D(p))._captureStackTrace(), e._setFulfilled(), e._rejectionHandler0 = t), e
                            }, D.resolve = D.fulfilled = D.cast, D.reject = D.rejected = function(t) {
                                var e = new D(p);
                                return e._captureStackTrace(), e._rejectCallback(t, !0), e
                            }, D.setScheduler = function(t) {
                                if ("function" != typeof t) throw new _("expecting a function but got " + c.classString(t));
                                return h.setScheduler(t)
                            }, D.prototype._then = function(t, e, i, n, r) {
                                var a = void 0 !== r,
                                    o = a ? r : new D(p),
                                    l = this._target(),
                                    u = l._bitField;
                                a || (o._propagateFrom(this, 3), o._captureStackTrace(), void 0 === n && 0 != (2097152 & this._bitField) && (n = 0 != (50397184 & u) ? this._boundValue() : l === this ? void 0 : this._boundTo), this._fireEvent("promiseChained", this, o));
                                var d = s();
                                if (0 != (50397184 & u)) {
                                    var f, _, v = l._settlePromiseCtx;
                                    0 != (33554432 & u) ? (_ = l._rejectionHandler0, f = t) : 0 != (16777216 & u) ? (_ = l._fulfillmentHandler0, f = e, l._unsetRejectionIsUnhandled()) : (v = l._settlePromiseLateCancellationObserver, _ = new g("late cancellation observer"), l._attachExtraTrace(_), f = e), h.invoke(v, l, {
                                        handler: null === d ? f : "function" == typeof f && c.domainBind(d, f),
                                        promise: o,
                                        receiver: n,
                                        value: _
                                    })
                                } else l._addCallbacks(t, e, o, n, d);
                                return o
                            }, D.prototype._length = function() {
                                return 65535 & this._bitField
                            }, D.prototype._isFateSealed = function() {
                                return 0 != (117506048 & this._bitField)
                            }, D.prototype._isFollowing = function() {
                                return 67108864 == (67108864 & this._bitField)
                            }, D.prototype._setLength = function(t) {
                                this._bitField = -65536 & this._bitField | 65535 & t
                            }, D.prototype._setFulfilled = function() {
                                this._bitField = 33554432 | this._bitField, this._fireEvent("promiseFulfilled", this)
                            }, D.prototype._setRejected = function() {
                                this._bitField = 16777216 | this._bitField, this._fireEvent("promiseRejected", this)
                            }, D.prototype._setFollowing = function() {
                                this._bitField = 67108864 | this._bitField, this._fireEvent("promiseResolved", this)
                            }, D.prototype._setIsFinal = function() {
                                this._bitField = 4194304 | this._bitField
                            }, D.prototype._isFinal = function() {
                                return (4194304 & this._bitField) > 0
                            }, D.prototype._unsetCancelled = function() {
                                this._bitField = -65537 & this._bitField
                            }, D.prototype._setCancelled = function() {
                                this._bitField = 65536 | this._bitField, this._fireEvent("promiseCancelled", this)
                            }, D.prototype._setWillBeCancelled = function() {
                                this._bitField = 8388608 | this._bitField
                            }, D.prototype._setAsyncGuaranteed = function() {
                                h.hasCustomScheduler() || (this._bitField = 134217728 | this._bitField)
                            }, D.prototype._receiverAt = function(t) {
                                var e = 0 === t ? this._receiver0 : this[4 * t - 4 + 3];
                                if (e !== l) return void 0 === e && this._isBound() ? this._boundValue() : e
                            }, D.prototype._promiseAt = function(t) {
                                return this[4 * t - 4 + 2]
                            }, D.prototype._fulfillmentHandlerAt = function(t) {
                                return this[4 * t - 4 + 0]
                            }, D.prototype._rejectionHandlerAt = function(t) {
                                return this[4 * t - 4 + 1]
                            }, D.prototype._boundValue = function() {}, D.prototype._migrateCallback0 = function(t) {
                                t._bitField;
                                var e = t._fulfillmentHandler0,
                                    i = t._rejectionHandler0,
                                    n = t._promise0,
                                    r = t._receiverAt(0);
                                void 0 === r && (r = l), this._addCallbacks(e, i, n, r, null)
                            }, D.prototype._migrateCallbackAt = function(t, e) {
                                var i = t._fulfillmentHandlerAt(e),
                                    n = t._rejectionHandlerAt(e),
                                    r = t._promiseAt(e),
                                    a = t._receiverAt(e);
                                void 0 === a && (a = l), this._addCallbacks(i, n, r, a, null)
                            }, D.prototype._addCallbacks = function(t, e, i, n, r) {
                                var a = this._length();
                                if (a >= 65531 && (a = 0, this._setLength(0)), 0 === a) this._promise0 = i, this._receiver0 = n, "function" == typeof t && (this._fulfillmentHandler0 = null === r ? t : c.domainBind(r, t)), "function" == typeof e && (this._rejectionHandler0 = null === r ? e : c.domainBind(r, e));
                                else {
                                    var o = 4 * a - 4;
                                    this[o + 2] = i, this[o + 3] = n, "function" == typeof t && (this[o + 0] = null === r ? t : c.domainBind(r, t)), "function" == typeof e && (this[o + 1] = null === r ? e : c.domainBind(r, e))
                                }
                                return this._setLength(a + 1), a
                            }, D.prototype._proxy = function(t, e) {
                                this._addCallbacks(void 0, void 0, e, t, null)
                            }, D.prototype._resolveCallback = function(t, e) {
                                if (0 == (117506048 & this._bitField)) {
                                    if (t === this) return this._rejectCallback(n(), !1);
                                    var i = y(t, this);
                                    if (!(i instanceof D)) return this._fulfill(t);
                                    e && this._propagateFrom(i, 2);
                                    var r = i._target();
                                    if (r !== this) {
                                        var a = r._bitField;
                                        if (0 == (50397184 & a)) {
                                            var o = this._length();
                                            o > 0 && r._migrateCallback0(this);
                                            for (var s = 1; s < o; ++s) r._migrateCallbackAt(this, s);
                                            this._setFollowing(), this._setLength(0), this._setFollowee(r)
                                        } else if (0 != (33554432 & a)) this._fulfill(r._value());
                                        else if (0 != (16777216 & a)) this._reject(r._reason());
                                        else {
                                            var l = new g("late cancellation observer");
                                            r._attachExtraTrace(l), this._reject(l)
                                        }
                                    } else this._reject(n())
                                }
                            }, D.prototype._rejectCallback = function(t, e, i) {
                                var n = c.ensureErrorObject(t),
                                    r = n === t;
                                if (!r && !i && x.warnings()) {
                                    var a = "a promise was rejected with a non-error: " + c.classString(t);
                                    this._warn(a, !0)
                                }
                                this._attachExtraTrace(n, !!e && r), this._reject(t)
                            }, D.prototype._resolveFromExecutor = function(t) {
                                if (t !== p) {
                                    var e = this;
                                    this._captureStackTrace(), this._pushContext();
                                    var i = !0,
                                        n = this._execute(t, function(t) {
                                            e._resolveCallback(t)
                                        }, function(t) {
                                            e._rejectCallback(t, i)
                                        });
                                    i = !1, this._popContext(), void 0 !== n && e._rejectCallback(n, !0)
                                }
                            }, D.prototype._settlePromiseFromHandler = function(t, e, i, n) {
                                var r = n._bitField;
                                if (0 == (65536 & r)) {
                                    var a;
                                    n._pushContext(), e === v ? i && "number" == typeof i.length ? a = E(t).apply(this._boundValue(), i) : (a = T).e = new _("cannot .spread() a non-array: " + c.classString(i)) : a = E(t).call(e, i);
                                    var o = n._popContext();
                                    0 == (65536 & (r = n._bitField)) && (a === m ? n._reject(i) : a === T ? n._rejectCallback(a.e, !1) : (x.checkForgottenReturns(a, o, "", n, this), n._resolveCallback(a)))
                                }
                            }, D.prototype._target = function() {
                                for (var t = this; t._isFollowing();) t = t._followee();
                                return t
                            }, D.prototype._followee = function() {
                                return this._rejectionHandler0
                            }, D.prototype._setFollowee = function(t) {
                                this._rejectionHandler0 = t
                            }, D.prototype._settlePromise = function(t, e, i, n) {
                                var a = t instanceof D,
                                    s = this._bitField,
                                    l = 0 != (134217728 & s);
                                0 != (65536 & s) ? (a && t._invokeInternalOnCancel(), i instanceof $ && i.isFinallyHandler() ? (i.cancelPromise = t, E(e).call(i, n) === T && t._reject(T.e)) : e === r ? t._fulfill(r.call(i)) : i instanceof o ? i._promiseCancelled(t) : a || t instanceof b ? t._cancel() : i.cancel()) : "function" == typeof e ? a ? (l && t._setAsyncGuaranteed(), this._settlePromiseFromHandler(e, i, n, t)) : e.call(i, n, t) : i instanceof o ? i._isResolved() || (0 != (33554432 & s) ? i._promiseFulfilled(n, t) : i._promiseRejected(n, t)) : a && (l && t._setAsyncGuaranteed(), 0 != (33554432 & s) ? t._fulfill(n) : t._reject(n))
                            }, D.prototype._settlePromiseLateCancellationObserver = function(t) {
                                var e = t.handler,
                                    i = t.promise,
                                    n = t.receiver,
                                    r = t.value;
                                "function" == typeof e ? i instanceof D ? this._settlePromiseFromHandler(e, n, r, i) : e.call(n, r, i) : i instanceof D && i._reject(r)
                            }, D.prototype._settlePromiseCtx = function(t) {
                                this._settlePromise(t.promise, t.handler, t.receiver, t.value)
                            }, D.prototype._settlePromise0 = function(t, e, i) {
                                var n = this._promise0,
                                    r = this._receiverAt(0);
                                this._promise0 = void 0, this._receiver0 = void 0, this._settlePromise(n, t, r, e)
                            }, D.prototype._clearCallbackDataAtIndex = function(t) {
                                var e = 4 * t - 4;
                                this[e + 2] = this[e + 3] = this[e + 0] = this[e + 1] = void 0
                            }, D.prototype._fulfill = function(t) {
                                var e = this._bitField;
                                if (!((117506048 & e) >>> 16)) {
                                    if (t === this) {
                                        var i = n();
                                        return this._attachExtraTrace(i), this._reject(i)
                                    }
                                    this._setFulfilled(), this._rejectionHandler0 = t, (65535 & e) > 0 && (0 != (134217728 & e) ? this._settlePromises() : h.settlePromises(this), this._dereferenceTrace())
                                }
                            }, D.prototype._reject = function(t) {
                                var e = this._bitField;
                                if (!((117506048 & e) >>> 16)) {
                                    if (this._setRejected(), this._fulfillmentHandler0 = t, this._isFinal()) return h.fatalError(t, c.isNode);
                                    (65535 & e) > 0 ? h.settlePromises(this) : this._ensurePossibleRejectionHandled()
                                }
                            }, D.prototype._fulfillPromises = function(t, e) {
                                for (var i = 1; i < t; i++) {
                                    var n = this._fulfillmentHandlerAt(i),
                                        r = this._promiseAt(i),
                                        a = this._receiverAt(i);
                                    this._clearCallbackDataAtIndex(i), this._settlePromise(r, n, a, e)
                                }
                            }, D.prototype._rejectPromises = function(t, e) {
                                for (var i = 1; i < t; i++) {
                                    var n = this._rejectionHandlerAt(i),
                                        r = this._promiseAt(i),
                                        a = this._receiverAt(i);
                                    this._clearCallbackDataAtIndex(i), this._settlePromise(r, n, a, e)
                                }
                            }, D.prototype._settlePromises = function() {
                                var t = this._bitField,
                                    e = 65535 & t;
                                if (e > 0) {
                                    if (0 != (16842752 & t)) {
                                        var i = this._fulfillmentHandler0;
                                        this._settlePromise0(this._rejectionHandler0, i, t), this._rejectPromises(e, i)
                                    } else {
                                        var n = this._rejectionHandler0;
                                        this._settlePromise0(this._fulfillmentHandler0, n, t), this._fulfillPromises(e, n)
                                    }
                                    this._setLength(0)
                                }
                                this._clearCancellationData()
                            }, D.prototype._settledValue = function() {
                                var t = this._bitField;
                                return 0 != (33554432 & t) ? this._rejectionHandler0 : 0 != (16777216 & t) ? this._fulfillmentHandler0 : void 0
                            }, D.defer = D.pending = function() {
                                x.deprecated("Promise.defer", "new Promise");
                                var t = new D(p);
                                return {
                                    promise: t,
                                    resolve: I,
                                    reject: A
                                }
                            }, c.notEnumerableProp(D, "_makeSelfResolutionError", n), t("./method")(D, p, y, a, x), t("./bind")(D, p, y, x), t("./cancel")(D, b, a, x), t("./direct_resolve")(D), t("./synchronous_inspection")(D), t("./join")(D, b, y, p, h, s), D.Promise = D, D.version = "3.5.4", t("./map.js")(D, b, a, y, p, x), t("./call_get.js")(D), t("./using.js")(D, a, y, w, p, x), t("./timers.js")(D, p, x), t("./generators.js")(D, a, p, y, o, x), t("./nodeify.js")(D), t("./promisify.js")(D, p), t("./props.js")(D, b, y, a), t("./race.js")(D, p, y, a), t("./reduce.js")(D, b, a, y, p, x), t("./settle.js")(D, b, x), t("./some.js")(D, b, a), t("./filter.js")(D, p), t("./each.js")(D, p), t("./any.js")(D), c.toFastProperties(D), c.toFastProperties(D.prototype), M({
                                a: 1
                            }), M({
                                b: 2
                            }), M({
                                c: 3
                            }), M(1), M(function() {}), M(void 0), M(!1), M(new D(p)), x.setBounds(d.firstLineError, c.lastLineError), D
                        }
                    }, {
                        "./any.js": 1,
                        "./async": 2,
                        "./bind": 3,
                        "./call_get.js": 5,
                        "./cancel": 6,
                        "./catch_filter": 7,
                        "./context": 8,
                        "./debuggability": 9,
                        "./direct_resolve": 10,
                        "./each.js": 11,
                        "./errors": 12,
                        "./es5": 13,
                        "./filter.js": 14,
                        "./finally": 15,
                        "./generators.js": 16,
                        "./join": 17,
                        "./map.js": 18,
                        "./method": 19,
                        "./nodeback": 20,
                        "./nodeify.js": 21,
                        "./promise_array": 23,
                        "./promisify.js": 24,
                        "./props.js": 25,
                        "./race.js": 27,
                        "./reduce.js": 28,
                        "./settle.js": 30,
                        "./some.js": 31,
                        "./synchronous_inspection": 32,
                        "./thenables": 33,
                        "./timers.js": 34,
                        "./using.js": 35,
                        "./util": 36
                    }],
                    23: [function(t, e, i) {
                        "use strict";
                        e.exports = function(e, i, n, r, a) {
                            var o = t("./util");

                            function s(t) {
                                var n = this._promise = new e(i);
                                t instanceof e && n._propagateFrom(t, 3), n._setOnCancel(this), this._values = t, this._length = 0, this._totalResolved = 0, this._init(void 0, -2)
                            }
                            return o.isArray, o.inherits(s, a), s.prototype.length = function() {
                                return this._length
                            }, s.prototype.promise = function() {
                                return this._promise
                            }, s.prototype._init = function t(i, a) {
                                var s = n(this._values, this._promise);
                                if (s instanceof e) {
                                    var l = (s = s._target())._bitField;
                                    if (this._values = s, 0 == (50397184 & l)) return this._promise._setAsyncGuaranteed(), s._then(t, this._reject, void 0, this, a);
                                    if (0 == (33554432 & l)) return 0 != (16777216 & l) ? this._reject(s._reason()) : this._cancel();
                                    s = s._value()
                                }
                                if (null !== (s = o.asArray(s))) 0 !== s.length ? this._iterate(s) : -5 === a ? this._resolveEmptyArray() : this._resolve(function(t) {
                                    switch (t) {
                                        case -2:
                                            return [];
                                        case -3:
                                            return {};
                                        case -6:
                                            return new Map
                                    }
                                }(a));
                                else {
                                    var c = r("expecting an array or an iterable object but got " + o.classString(s)).reason();
                                    this._promise._rejectCallback(c, !1)
                                }
                            }, s.prototype._iterate = function(t) {
                                var i = this.getActualLength(t.length);
                                this._length = i, this._values = this.shouldCopyValues() ? new Array(i) : this._values;
                                for (var r = this._promise, a = !1, o = null, s = 0; s < i; ++s) {
                                    var l = n(t[s], r);
                                    l instanceof e ? (l = l._target(), o = l._bitField) : o = null, a ? null !== o && l.suppressUnhandledRejections() : null !== o ? 0 == (50397184 & o) ? (l._proxy(this, s), this._values[s] = l) : a = 0 != (33554432 & o) ? this._promiseFulfilled(l._value(), s) : 0 != (16777216 & o) ? this._promiseRejected(l._reason(), s) : this._promiseCancelled(s) : a = this._promiseFulfilled(l, s)
                                }
                                a || r._setAsyncGuaranteed()
                            }, s.prototype._isResolved = function() {
                                return null === this._values
                            }, s.prototype._resolve = function(t) {
                                this._values = null, this._promise._fulfill(t)
                            }, s.prototype._cancel = function() {
                                !this._isResolved() && this._promise._isCancellable() && (this._values = null, this._promise._cancel())
                            }, s.prototype._reject = function(t) {
                                this._values = null, this._promise._rejectCallback(t, !1)
                            }, s.prototype._promiseFulfilled = function(t, e) {
                                this._values[e] = t;
                                var i = ++this._totalResolved;
                                return i >= this._length && (this._resolve(this._values), !0)
                            }, s.prototype._promiseCancelled = function() {
                                return this._cancel(), !0
                            }, s.prototype._promiseRejected = function(t) {
                                return this._totalResolved++, this._reject(t), !0
                            }, s.prototype._resultCancelled = function() {
                                if (!this._isResolved()) {
                                    var t = this._values;
                                    if (this._cancel(), t instanceof e) t.cancel();
                                    else
                                        for (var i = 0; i < t.length; ++i) t[i] instanceof e && t[i].cancel()
                                }
                            }, s.prototype.shouldCopyValues = function() {
                                return !0
                            }, s.prototype.getActualLength = function(t) {
                                return t
                            }, s
                        }
                    }, {
                        "./util": 36
                    }],
                    24: [function(t, e, i) {
                        "use strict";
                        e.exports = function(e, i) {
                            var n = {},
                                r = t("./util"),
                                a = t("./nodeback"),
                                o = r.withAppended,
                                s = r.maybeWrapAsError,
                                l = r.canEvaluate,
                                c = t("./errors").TypeError,
                                u = {
                                    __isPromisified__: !0
                                },
                                d = new RegExp("^(?:" + ["arity", "length", "name", "arguments", "caller", "callee", "prototype", "__isPromisified__"].join("|") + ")$"),
                                h = function(t) {
                                    return r.isIdentifier(t) && "_" !== t.charAt(0) && "constructor" !== t
                                };

                            function f(t) {
                                return !d.test(t)
                            }

                            function _(t) {
                                try {
                                    return !0 === t.__isPromisified__
                                } catch (t) {
                                    return !1
                                }
                            }

                            function g(t, e, i) {
                                var n = r.getDataPropertyOrDefault(t, e + i, u);
                                return !!n && _(n)
                            }

                            function p(t, e, i, n) {
                                for (var a = r.inheritedDataKeys(t), o = [], s = 0; s < a.length; ++s) {
                                    var l = a[s],
                                        u = t[l],
                                        d = n === h || h(l, u, t);
                                    "function" != typeof u || _(u) || g(t, l, e) || !n(l, u, t, d) || o.push(l, u)
                                }
                                return function(t, e, i) {
                                    for (var n = 0; n < t.length; n += 2) {
                                        var r = t[n];
                                        if (i.test(r))
                                            for (var a = r.replace(i, ""), o = 0; o < t.length; o += 2)
                                                if (t[o] === a) throw new c("Cannot promisify an API that has normal methods with '%s'-suffix\n\n    See http://goo.gl/MqrFmX\n".replace("%s", e))
                                    }
                                }(o, e, i), o
                            }
                            var v = function(t) {
                                    return t.replace(/([$])/, "\\$")
                                },
                                m = l ? void 0 : function(t, l, c, u, d, h) {
                                    var f = function() {
                                            return this
                                        }(),
                                        _ = t;

                                    function g() {
                                        var r = l;
                                        l === n && (r = this);
                                        var c = new e(i);
                                        c._captureStackTrace();
                                        var u = "string" == typeof _ && this !== f ? this[_] : t,
                                            d = a(c, h);
                                        try {
                                            u.apply(r, o(arguments, d))
                                        } catch (t) {
                                            c._rejectCallback(s(t), !0, !0)
                                        }
                                        return c._isFateSealed() || c._setAsyncGuaranteed(), c
                                    }
                                    return "string" == typeof _ && (t = u), r.notEnumerableProp(g, "__isPromisified__", !0), g
                                };

                            function y(t, e, i, a, o) {
                                for (var s = new RegExp(v(e) + "$"), l = p(t, e, s, i), c = 0, u = l.length; c < u; c += 2) {
                                    var d = l[c],
                                        h = l[c + 1],
                                        f = d + e;
                                    if (a === m) t[f] = m(d, n, d, h, e, o);
                                    else {
                                        var _ = a(h, function() {
                                            return m(d, n, d, h, e, o)
                                        });
                                        r.notEnumerableProp(_, "__isPromisified__", !0), t[f] = _
                                    }
                                }
                                return r.toFastProperties(t), t
                            }
                            e.promisify = function(t, e) {
                                if ("function" != typeof t) throw new c("expecting a function but got " + r.classString(t));
                                if (_(t)) return t;
                                var i = void 0 === (e = Object(e)).context ? n : e.context,
                                    a = !!e.multiArgs,
                                    o = function(t, e, i) {
                                        return m(t, e, void 0, t, null, i)
                                    }(t, i, a);
                                return r.copyDescriptors(t, o, f), o
                            }, e.promisifyAll = function(t, e) {
                                if ("function" != typeof t && "object" != typeof t) throw new c("the target of promisifyAll must be an object or a function\n\n    See http://goo.gl/MqrFmX\n");
                                var i = !!(e = Object(e)).multiArgs,
                                    n = e.suffix;
                                "string" != typeof n && (n = "Async");
                                var a = e.filter;
                                "function" != typeof a && (a = h);
                                var o = e.promisifier;
                                if ("function" != typeof o && (o = m), !r.isIdentifier(n)) throw new RangeError("suffix must be a valid identifier\n\n    See http://goo.gl/MqrFmX\n");
                                for (var s = r.inheritedDataKeys(t), l = 0; l < s.length; ++l) {
                                    var u = t[s[l]];
                                    "constructor" !== s[l] && r.isClass(u) && (y(u.prototype, n, a, o, i), y(u, n, a, o, i))
                                }
                                return y(t, n, a, o, i)
                            }
                        }
                    }, {
                        "./errors": 12,
                        "./nodeback": 20,
                        "./util": 36
                    }],
                    25: [function(t, e, i) {
                        "use strict";
                        e.exports = function(e, i, n, r) {
                            var a, o = t("./util"),
                                s = o.isObject,
                                l = t("./es5");
                            "function" == typeof Map && (a = Map);
                            var c = function() {
                                var t = 0,
                                    e = 0;

                                function i(i, n) {
                                    this[t] = i, this[t + e] = n, t++
                                }
                                return function(n) {
                                    e = n.size, t = 0;
                                    var r = new Array(2 * n.size);
                                    return n.forEach(i, r), r
                                }
                            }();

                            function u(t) {
                                var e, i = !1;
                                if (void 0 !== a && t instanceof a) e = c(t), i = !0;
                                else {
                                    var n = l.keys(t),
                                        r = n.length;
                                    e = new Array(2 * r);
                                    for (var o = 0; o < r; ++o) {
                                        var s = n[o];
                                        e[o] = t[s], e[o + r] = s
                                    }
                                }
                                this.constructor$(e), this._isMap = i, this._init$(void 0, i ? -6 : -3)
                            }

                            function d(t) {
                                var i, a = n(t);
                                return s(a) ? (i = a instanceof e ? a._then(e.props, void 0, void 0, void 0, void 0) : new u(a).promise(), a instanceof e && i._propagateFrom(a, 2), i) : r("cannot await properties of a non-object\n\n    See http://goo.gl/MqrFmX\n")
                            }
                            o.inherits(u, i), u.prototype._init = function() {}, u.prototype._promiseFulfilled = function(t, e) {
                                this._values[e] = t;
                                var i = ++this._totalResolved;
                                if (i >= this._length) {
                                    var n;
                                    if (this._isMap) n = function(t) {
                                        for (var e = new a, i = t.length / 2 | 0, n = 0; n < i; ++n) {
                                            var r = t[i + n],
                                                o = t[n];
                                            e.set(r, o)
                                        }
                                        return e
                                    }(this._values);
                                    else {
                                        n = {};
                                        for (var r = this.length(), o = 0, s = this.length(); o < s; ++o) n[this._values[o + r]] = this._values[o]
                                    }
                                    return this._resolve(n), !0
                                }
                                return !1
                            }, u.prototype.shouldCopyValues = function() {
                                return !1
                            }, u.prototype.getActualLength = function(t) {
                                return t >> 1
                            }, e.prototype.props = function() {
                                return d(this)
                            }, e.props = function(t) {
                                return d(t)
                            }
                        }
                    }, {
                        "./es5": 13,
                        "./util": 36
                    }],
                    26: [function(t, e, i) {
                        "use strict";

                        function n(t) {
                            this._capacity = t, this._length = 0, this._front = 0
                        }
                        n.prototype._willBeOverCapacity = function(t) {
                            return this._capacity < t
                        }, n.prototype._pushOne = function(t) {
                            var e = this.length();
                            this._checkCapacity(e + 1);
                            var i = this._front + e & this._capacity - 1;
                            this[i] = t, this._length = e + 1
                        }, n.prototype.push = function(t, e, i) {
                            var n = this.length() + 3;
                            if (this._willBeOverCapacity(n)) return this._pushOne(t), this._pushOne(e), void this._pushOne(i);
                            var r = this._front + n - 3;
                            this._checkCapacity(n);
                            var a = this._capacity - 1;
                            this[r + 0 & a] = t, this[r + 1 & a] = e, this[r + 2 & a] = i, this._length = n
                        }, n.prototype.shift = function() {
                            var t = this._front,
                                e = this[t];
                            return this[t] = void 0, this._front = t + 1 & this._capacity - 1, this._length--, e
                        }, n.prototype.length = function() {
                            return this._length
                        }, n.prototype._checkCapacity = function(t) {
                            this._capacity < t && this._resizeTo(this._capacity << 1)
                        }, n.prototype._resizeTo = function(t) {
                            var e = this._capacity;
                            this._capacity = t;
                            var i = this._front,
                                n = this._length,
                                r = i + n & e - 1;
                            ! function(t, e, i, n, r) {
                                for (var a = 0; a < r; ++a) i[a + n] = t[a + e], t[a + e] = void 0
                            }(this, 0, this, e, r)
                        }, e.exports = n
                    }, {}],
                    27: [function(t, e, i) {
                        "use strict";
                        e.exports = function(e, i, n, r) {
                            var a = t("./util"),
                                o = function(t) {
                                    return t.then(function(e) {
                                        return s(e, t)
                                    })
                                };

                            function s(t, s) {
                                var l = n(t);
                                if (l instanceof e) return o(l);
                                if (null === (t = a.asArray(t))) return r("expecting an array or an iterable object but got " + a.classString(t));
                                var c = new e(i);
                                void 0 !== s && c._propagateFrom(s, 3);
                                for (var u = c._fulfill, d = c._reject, h = 0, f = t.length; h < f; ++h) {
                                    var _ = t[h];
                                    (void 0 !== _ || h in t) && e.cast(_)._then(u, d, void 0, c, null)
                                }
                                return c
                            }
                            e.race = function(t) {
                                return s(t, void 0)
                            }, e.prototype.race = function() {
                                return s(this, void 0)
                            }
                        }
                    }, {
                        "./util": 36
                    }],
                    28: [function(t, e, i) {
                        "use strict";
                        e.exports = function(e, i, n, r, a, o) {
                            var s = e._getDomain,
                                l = t("./util"),
                                c = l.tryCatch;

                            function u(t, i, n, r) {
                                this.constructor$(t);
                                var o = s();
                                this._fn = null === o ? i : l.domainBind(o, i), void 0 !== n && (n = e.resolve(n))._attachCancellationCallback(this), this._initialValue = n, this._currentCancellable = null, this._eachValues = r === a ? Array(this._length) : 0 === r ? null : void 0, this._promise._captureStackTrace(), this._init$(void 0, -5)
                            }

                            function d(t, e) {
                                this.isFulfilled() ? e._resolve(t) : e._reject(t)
                            }

                            function h(t, e, i, r) {
                                if ("function" != typeof e) return n("expecting a function but got " + l.classString(e));
                                var a = new u(t, e, i, r);
                                return a.promise()
                            }

                            function f(t) {
                                this.accum = t, this.array._gotAccum(t);
                                var i = r(this.value, this.array._promise);
                                return i instanceof e ? (this.array._currentCancellable = i, i._then(_, void 0, void 0, this, void 0)) : _.call(this, i)
                            }

                            function _(t) {
                                var i, n = this.array,
                                    r = n._promise,
                                    a = c(n._fn);
                                r._pushContext(), (i = void 0 !== n._eachValues ? a.call(r._boundValue(), t, this.index, this.length) : a.call(r._boundValue(), this.accum, t, this.index, this.length)) instanceof e && (n._currentCancellable = i);
                                var s = r._popContext();
                                return o.checkForgottenReturns(i, s, void 0 !== n._eachValues ? "Promise.each" : "Promise.reduce", r), i
                            }
                            l.inherits(u, i), u.prototype._gotAccum = function(t) {
                                void 0 !== this._eachValues && null !== this._eachValues && t !== a && this._eachValues.push(t)
                            }, u.prototype._eachComplete = function(t) {
                                return null !== this._eachValues && this._eachValues.push(t), this._eachValues
                            }, u.prototype._init = function() {}, u.prototype._resolveEmptyArray = function() {
                                this._resolve(void 0 !== this._eachValues ? this._eachValues : this._initialValue)
                            }, u.prototype.shouldCopyValues = function() {
                                return !1
                            }, u.prototype._resolve = function(t) {
                                this._promise._resolveCallback(t), this._values = null
                            }, u.prototype._resultCancelled = function(t) {
                                if (t === this._initialValue) return this._cancel();
                                this._isResolved() || (this._resultCancelled$(), this._currentCancellable instanceof e && this._currentCancellable.cancel(), this._initialValue instanceof e && this._initialValue.cancel())
                            }, u.prototype._iterate = function(t) {
                                var i, n;
                                this._values = t;
                                var r = t.length;
                                if (void 0 !== this._initialValue ? (i = this._initialValue, n = 0) : (i = e.resolve(t[0]), n = 1), this._currentCancellable = i, !i.isRejected())
                                    for (; n < r; ++n) {
                                        var a = {
                                            accum: null,
                                            value: t[n],
                                            index: n,
                                            length: r,
                                            array: this
                                        };
                                        i = i._then(f, void 0, void 0, a, void 0)
                                    }
                                void 0 !== this._eachValues && (i = i._then(this._eachComplete, void 0, void 0, this, void 0)), i._then(d, d, void 0, i, this)
                            }, e.prototype.reduce = function(t, e) {
                                return h(this, t, e, null)
                            }, e.reduce = function(t, e, i, n) {
                                return h(t, e, i, n)
                            }
                        }
                    }, {
                        "./util": 36
                    }],
                    29: [function(t, r, a) {
                        "use strict";
                        var o, s = t("./util"),
                            l = s.getNativePromise();
                        if (s.isNode && "undefined" == typeof MutationObserver) {
                            var c = i.setImmediate,
                                u = e.nextTick;
                            o = s.isRecentNode ? function(t) {
                                c.call(i, t)
                            } : function(t) {
                                u.call(e, t)
                            }
                        } else if ("function" == typeof l && "function" == typeof l.resolve) {
                            var d = l.resolve();
                            o = function(t) {
                                d.then(t)
                            }
                        } else o = "undefined" == typeof MutationObserver || "undefined" != typeof window && window.navigator && (window.navigator.standalone || window.cordova) ? void 0 !== n ? function(t) {
                            n(t)
                        } : "undefined" != typeof setTimeout ? function(t) {
                            setTimeout(t, 0)
                        } : function() {
                            throw new Error("No async scheduler available\n\n    See http://goo.gl/MqrFmX\n")
                        } : function() {
                            var t = document.createElement("div"),
                                e = {
                                    attributes: !0
                                },
                                i = !1,
                                n = document.createElement("div"),
                                r = new MutationObserver(function() {
                                    t.classList.toggle("foo"), i = !1
                                });
                            return r.observe(n, e),
                                function(r) {
                                    var a = new MutationObserver(function() {
                                        a.disconnect(), r()
                                    });
                                    a.observe(t, e), i || (i = !0, n.classList.toggle("foo"))
                                }
                        }();
                        r.exports = o
                    }, {
                        "./util": 36
                    }],
                    30: [function(t, e, i) {
                        "use strict";
                        e.exports = function(e, i, n) {
                            var r = e.PromiseInspection,
                                a = t("./util");

                            function o(t) {
                                this.constructor$(t)
                            }
                            a.inherits(o, i), o.prototype._promiseResolved = function(t, e) {
                                this._values[t] = e;
                                var i = ++this._totalResolved;
                                return i >= this._length && (this._resolve(this._values), !0)
                            }, o.prototype._promiseFulfilled = function(t, e) {
                                var i = new r;
                                return i._bitField = 33554432, i._settledValueField = t, this._promiseResolved(e, i)
                            }, o.prototype._promiseRejected = function(t, e) {
                                var i = new r;
                                return i._bitField = 16777216, i._settledValueField = t, this._promiseResolved(e, i)
                            }, e.settle = function(t) {
                                return n.deprecated(".settle()", ".reflect()"), new o(t).promise()
                            }, e.prototype.settle = function() {
                                return e.settle(this)
                            }
                        }
                    }, {
                        "./util": 36
                    }],
                    31: [function(t, e, i) {
                        "use strict";
                        e.exports = function(e, i, n) {
                            var r = t("./util"),
                                a = t("./errors").RangeError,
                                o = t("./errors").AggregateError,
                                s = r.isArray,
                                l = {};

                            function c(t) {
                                this.constructor$(t), this._howMany = 0, this._unwrap = !1, this._initialized = !1
                            }

                            function u(t, e) {
                                if ((0 | e) !== e || e < 0) return n("expecting a positive integer\n\n    See http://goo.gl/MqrFmX\n");
                                var i = new c(t),
                                    r = i.promise();
                                return i.setHowMany(e), i.init(), r
                            }
                            r.inherits(c, i), c.prototype._init = function() {
                                if (this._initialized)
                                    if (0 !== this._howMany) {
                                        this._init$(void 0, -5);
                                        var t = s(this._values);
                                        !this._isResolved() && t && this._howMany > this._canPossiblyFulfill() && this._reject(this._getRangeError(this.length()))
                                    } else this._resolve([])
                            }, c.prototype.init = function() {
                                this._initialized = !0, this._init()
                            }, c.prototype.setUnwrap = function() {
                                this._unwrap = !0
                            }, c.prototype.howMany = function() {
                                return this._howMany
                            }, c.prototype.setHowMany = function(t) {
                                this._howMany = t
                            }, c.prototype._promiseFulfilled = function(t) {
                                return this._addFulfilled(t), this._fulfilled() === this.howMany() && (this._values.length = this.howMany(), 1 === this.howMany() && this._unwrap ? this._resolve(this._values[0]) : this._resolve(this._values), !0)
                            }, c.prototype._promiseRejected = function(t) {
                                return this._addRejected(t), this._checkOutcome()
                            }, c.prototype._promiseCancelled = function() {
                                return this._values instanceof e || null == this._values ? this._cancel() : (this._addRejected(l), this._checkOutcome())
                            }, c.prototype._checkOutcome = function() {
                                if (this.howMany() > this._canPossiblyFulfill()) {
                                    for (var t = new o, e = this.length(); e < this._values.length; ++e) this._values[e] !== l && t.push(this._values[e]);
                                    return t.length > 0 ? this._reject(t) : this._cancel(), !0
                                }
                                return !1
                            }, c.prototype._fulfilled = function() {
                                return this._totalResolved
                            }, c.prototype._rejected = function() {
                                return this._values.length - this.length()
                            }, c.prototype._addRejected = function(t) {
                                this._values.push(t)
                            }, c.prototype._addFulfilled = function(t) {
                                this._values[this._totalResolved++] = t
                            }, c.prototype._canPossiblyFulfill = function() {
                                return this.length() - this._rejected()
                            }, c.prototype._getRangeError = function(t) {
                                var e = "Input array must contain at least " + this._howMany + " items but contains only " + t + " items";
                                return new a(e)
                            }, c.prototype._resolveEmptyArray = function() {
                                this._reject(this._getRangeError(0))
                            }, e.some = function(t, e) {
                                return u(t, e)
                            }, e.prototype.some = function(t) {
                                return u(this, t)
                            }, e._SomePromiseArray = c
                        }
                    }, {
                        "./errors": 12,
                        "./util": 36
                    }],
                    32: [function(t, e, i) {
                        "use strict";
                        e.exports = function(t) {
                            function e(t) {
                                void 0 !== t ? (t = t._target(), this._bitField = t._bitField, this._settledValueField = t._isFateSealed() ? t._settledValue() : void 0) : (this._bitField = 0, this._settledValueField = void 0)
                            }
                            e.prototype._settledValue = function() {
                                return this._settledValueField
                            };
                            var i = e.prototype.value = function() {
                                    if (!this.isFulfilled()) throw new TypeError("cannot get fulfillment value of a non-fulfilled promise\n\n    See http://goo.gl/MqrFmX\n");
                                    return this._settledValue()
                                },
                                n = e.prototype.error = e.prototype.reason = function() {
                                    if (!this.isRejected()) throw new TypeError("cannot get rejection reason of a non-rejected promise\n\n    See http://goo.gl/MqrFmX\n");
                                    return this._settledValue()
                                },
                                r = e.prototype.isFulfilled = function() {
                                    return 0 != (33554432 & this._bitField)
                                },
                                a = e.prototype.isRejected = function() {
                                    return 0 != (16777216 & this._bitField)
                                },
                                o = e.prototype.isPending = function() {
                                    return 0 == (50397184 & this._bitField)
                                },
                                s = e.prototype.isResolved = function() {
                                    return 0 != (50331648 & this._bitField)
                                };
                            e.prototype.isCancelled = function() {
                                return 0 != (8454144 & this._bitField)
                            }, t.prototype.__isCancelled = function() {
                                return 65536 == (65536 & this._bitField)
                            }, t.prototype._isCancelled = function() {
                                return this._target().__isCancelled()
                            }, t.prototype.isCancelled = function() {
                                return 0 != (8454144 & this._target()._bitField)
                            }, t.prototype.isPending = function() {
                                return o.call(this._target())
                            }, t.prototype.isRejected = function() {
                                return a.call(this._target())
                            }, t.prototype.isFulfilled = function() {
                                return r.call(this._target())
                            }, t.prototype.isResolved = function() {
                                return s.call(this._target())
                            }, t.prototype.value = function() {
                                return i.call(this._target())
                            }, t.prototype.reason = function() {
                                var t = this._target();
                                return t._unsetRejectionIsUnhandled(), n.call(t)
                            }, t.prototype._value = function() {
                                return this._settledValue()
                            }, t.prototype._reason = function() {
                                return this._unsetRejectionIsUnhandled(), this._settledValue()
                            }, t.PromiseInspection = e
                        }
                    }, {}],
                    33: [function(t, e, i) {
                        "use strict";
                        e.exports = function(e, i) {
                            var n = t("./util"),
                                r = n.errorObj,
                                a = n.isObject,
                                o = {}.hasOwnProperty;
                            return function(t, s) {
                                if (a(t)) {
                                    if (t instanceof e) return t;
                                    var l = function(t) {
                                        try {
                                            return function(t) {
                                                return t.then
                                            }(t)
                                        } catch (t) {
                                            return r.e = t, r
                                        }
                                    }(t);
                                    if (l === r) {
                                        s && s._pushContext();
                                        var c = e.reject(l.e);
                                        return s && s._popContext(), c
                                    }
                                    if ("function" == typeof l) {
                                        if (function(t) {
                                                try {
                                                    return o.call(t, "_promise0")
                                                } catch (t) {
                                                    return !1
                                                }
                                            }(t)) {
                                            var c = new e(i);
                                            return t._then(c._fulfill, c._reject, void 0, c, null), c
                                        }
                                        return function(t, a, o) {
                                            var s = new e(i),
                                                l = s;
                                            o && o._pushContext(), s._captureStackTrace(), o && o._popContext();
                                            var c = !0,
                                                u = n.tryCatch(a).call(t, function(t) {
                                                    s && (s._resolveCallback(t), s = null)
                                                }, function(t) {
                                                    s && (s._rejectCallback(t, c, !0), s = null)
                                                });
                                            return c = !1, s && u === r && (s._rejectCallback(u.e, !0, !0), s = null), l
                                        }(t, l, s)
                                    }
                                }
                                return t
                            }
                        }
                    }, {
                        "./util": 36
                    }],
                    34: [function(t, e, i) {
                        "use strict";
                        e.exports = function(e, i, n) {
                            var r = t("./util"),
                                a = e.TimeoutError;

                            function o(t) {
                                this.handle = t
                            }
                            o.prototype._resultCancelled = function() {
                                clearTimeout(this.handle)
                            };
                            var s = function(t) {
                                    return l(+this).thenReturn(t)
                                },
                                l = e.delay = function(t, r) {
                                    var a, l;
                                    return void 0 !== r ? (a = e.resolve(r)._then(s, null, null, t, void 0), n.cancellation() && r instanceof e && a._setOnCancel(r)) : (a = new e(i), l = setTimeout(function() {
                                        a._fulfill()
                                    }, +t), n.cancellation() && a._setOnCancel(new o(l)), a._captureStackTrace()), a._setAsyncGuaranteed(), a
                                };

                            function c(t) {
                                return clearTimeout(this.handle), t
                            }

                            function u(t) {
                                throw clearTimeout(this.handle), t
                            }
                            e.prototype.delay = function(t) {
                                return l(t, this)
                            }, e.prototype.timeout = function(t, e) {
                                var i, s;
                                t = +t;
                                var l = new o(setTimeout(function() {
                                    i.isPending() && function(t, e, i) {
                                        var n;
                                        n = "string" != typeof e ? e instanceof Error ? e : new a("operation timed out") : new a(e), r.markAsOriginatingFromRejection(n), t._attachExtraTrace(n), t._reject(n), null != i && i.cancel()
                                    }(i, e, s)
                                }, t));
                                return n.cancellation() ? (s = this.then(), (i = s._then(c, u, void 0, l, void 0))._setOnCancel(l)) : i = this._then(c, u, void 0, l, void 0), i
                            }
                        }
                    }, {
                        "./util": 36
                    }],
                    35: [function(t, e, i) {
                        "use strict";
                        e.exports = function(e, i, n, r, a, o) {
                            var s = t("./util"),
                                l = t("./errors").TypeError,
                                c = t("./util").inherits,
                                u = s.errorObj,
                                d = s.tryCatch,
                                h = {};

                            function f(t) {
                                setTimeout(function() {
                                    throw t
                                }, 0)
                            }

                            function _(t, i) {
                                var r = 0,
                                    o = t.length,
                                    s = new e(a);
                                return function a() {
                                    if (r >= o) return s._fulfill();
                                    var l = function(t) {
                                        var e = n(t);
                                        return e !== t && "function" == typeof t._isDisposable && "function" == typeof t._getDisposer && t._isDisposable() && e._setDisposable(t._getDisposer()), e
                                    }(t[r++]);
                                    if (l instanceof e && l._isDisposable()) {
                                        try {
                                            l = n(l._getDisposer().tryDispose(i), t.promise)
                                        } catch (t) {
                                            return f(t)
                                        }
                                        if (l instanceof e) return l._then(a, f, null, null, null)
                                    }
                                    a()
                                }(), s
                            }

                            function g(t, e, i) {
                                this._data = t, this._promise = e, this._context = i
                            }

                            function p(t, e, i) {
                                this.constructor$(t, e, i)
                            }

                            function v(t) {
                                return g.isDisposer(t) ? (this.resources[this.index]._setDisposable(t), t.promise()) : t
                            }

                            function m(t) {
                                this.length = t, this.promise = null, this[t - 1] = null
                            }
                            g.prototype.data = function() {
                                return this._data
                            }, g.prototype.promise = function() {
                                return this._promise
                            }, g.prototype.resource = function() {
                                return this.promise().isFulfilled() ? this.promise().value() : h
                            }, g.prototype.tryDispose = function(t) {
                                var e = this.resource(),
                                    i = this._context;
                                void 0 !== i && i._pushContext();
                                var n = e !== h ? this.doDispose(e, t) : null;
                                return void 0 !== i && i._popContext(), this._promise._unsetDisposable(), this._data = null, n
                            }, g.isDisposer = function(t) {
                                return null != t && "function" == typeof t.resource && "function" == typeof t.tryDispose
                            }, c(p, g), p.prototype.doDispose = function(t, e) {
                                var i = this.data();
                                return i.call(t, t, e)
                            }, m.prototype._resultCancelled = function() {
                                for (var t = this.length, i = 0; i < t; ++i) {
                                    var n = this[i];
                                    n instanceof e && n.cancel()
                                }
                            }, e.using = function() {
                                var t = arguments.length;
                                if (t < 2) return i("you must pass at least 2 arguments to Promise.using");
                                var r, a = arguments[t - 1];
                                if ("function" != typeof a) return i("expecting a function but got " + s.classString(a));
                                var l = !0;
                                2 === t && Array.isArray(arguments[0]) ? (r = arguments[0], t = r.length, l = !1) : (r = arguments, t--);
                                for (var c = new m(t), h = 0; h < t; ++h) {
                                    var f = r[h];
                                    if (g.isDisposer(f)) {
                                        var p = f;
                                        (f = f.promise())._setDisposable(p)
                                    } else {
                                        var y = n(f);
                                        y instanceof e && (f = y._then(v, null, null, {
                                            resources: c,
                                            index: h
                                        }, void 0))
                                    }
                                    c[h] = f
                                }
                                for (var b = new Array(c.length), h = 0; h < b.length; ++h) b[h] = e.resolve(c[h]).reflect();
                                var k = e.all(b).then(function(t) {
                                        for (var e = 0; e < t.length; ++e) {
                                            var i = t[e];
                                            if (i.isRejected()) return u.e = i.error(), u;
                                            if (!i.isFulfilled()) return void k.cancel();
                                            t[e] = i.value()
                                        }
                                        w._pushContext(), a = d(a);
                                        var n = l ? a.apply(void 0, t) : a(t),
                                            r = w._popContext();
                                        return o.checkForgottenReturns(n, r, "Promise.using", w), n
                                    }),
                                    w = k.lastly(function() {
                                        var t = new e.PromiseInspection(k);
                                        return _(c, t)
                                    });
                                return c.promise = w, w._setOnCancel(c), w
                            }, e.prototype._setDisposable = function(t) {
                                this._bitField = 131072 | this._bitField, this._disposer = t
                            }, e.prototype._isDisposable = function() {
                                return (131072 & this._bitField) > 0
                            }, e.prototype._getDisposer = function() {
                                return this._disposer
                            }, e.prototype._unsetDisposable = function() {
                                this._bitField = -131073 & this._bitField, this._disposer = void 0
                            }, e.prototype.disposer = function(t) {
                                if ("function" == typeof t) return new p(t, this, r());
                                throw new l
                            }
                        }
                    }, {
                        "./errors": 12,
                        "./util": 36
                    }],
                    36: [function(t, n, r) {
                        "use strict";
                        var a = t("./es5"),
                            o = "undefined" == typeof navigator,
                            s = {
                                e: {}
                            },
                            l, c = "undefined" != typeof self ? self : "undefined" != typeof window ? window : void 0 !== i ? i : void 0 !== this ? this : null;

                        function u() {
                            try {
                                var t = l;
                                return l = null, t.apply(this, arguments)
                            } catch (t) {
                                return s.e = t, s
                            }
                        }

                        function d(t) {
                            return l = t, u
                        }
                        var h = function(t, e) {
                            var i = {}.hasOwnProperty;

                            function n() {
                                for (var n in this.constructor = t, this.constructor$ = e, e.prototype) i.call(e.prototype, n) && "$" !== n.charAt(n.length - 1) && (this[n + "$"] = e.prototype[n])
                            }
                            return n.prototype = e.prototype, t.prototype = new n, t.prototype
                        };

                        function f(t) {
                            return null == t || !0 === t || !1 === t || "string" == typeof t || "number" == typeof t
                        }

                        function _(t) {
                            return "function" == typeof t || "object" == typeof t && null !== t
                        }

                        function g(t) {
                            return f(t) ? new Error(T(t)) : t
                        }

                        function p(t, e) {
                            var i, n = t.length,
                                r = new Array(n + 1);
                            for (i = 0; i < n; ++i) r[i] = t[i];
                            return r[i] = e, r
                        }

                        function v(t, e, i) {
                            if (!a.isES5) return {}.hasOwnProperty.call(t, e) ? t[e] : void 0;
                            var n = Object.getOwnPropertyDescriptor(t, e);
                            return null != n ? null == n.get && null == n.set ? n.value : i : void 0
                        }

                        function m(t, e, i) {
                            if (f(t)) return t;
                            var n = {
                                value: i,
                                configurable: !0,
                                enumerable: !1,
                                writable: !0
                            };
                            return a.defineProperty(t, e, n), t
                        }

                        function y(t) {
                            throw t
                        }
                        var b = function() {
                                var t = [Array.prototype, Object.prototype, Function.prototype],
                                    e = function(e) {
                                        for (var i = 0; i < t.length; ++i)
                                            if (t[i] === e) return !0;
                                        return !1
                                    };
                                if (a.isES5) {
                                    var i = Object.getOwnPropertyNames;
                                    return function(t) {
                                        for (var n = [], r = Object.create(null); null != t && !e(t);) {
                                            var o;
                                            try {
                                                o = i(t)
                                            } catch (t) {
                                                return n
                                            }
                                            for (var s = 0; s < o.length; ++s) {
                                                var l = o[s];
                                                if (!r[l]) {
                                                    r[l] = !0;
                                                    var c = Object.getOwnPropertyDescriptor(t, l);
                                                    null != c && null == c.get && null == c.set && n.push(l)
                                                }
                                            }
                                            t = a.getPrototypeOf(t)
                                        }
                                        return n
                                    }
                                }
                                var n = {}.hasOwnProperty;
                                return function(i) {
                                    if (e(i)) return [];
                                    var r = [];
                                    t: for (var a in i)
                                        if (n.call(i, a)) r.push(a);
                                        else {
                                            for (var o = 0; o < t.length; ++o)
                                                if (n.call(t[o], a)) continue t;
                                            r.push(a)
                                        }
                                    return r
                                }
                            }(),
                            k = /this\s*\.\s*\S+\s*=/;

                        function w(t) {
                            try {
                                if ("function" == typeof t) {
                                    var e = a.names(t.prototype),
                                        i = a.isES5 && e.length > 1,
                                        n = e.length > 0 && !(1 === e.length && "constructor" === e[0]),
                                        r = k.test(t + "") && a.names(t).length > 0;
                                    if (i || n || r) return !0
                                }
                                return !1
                            } catch (t) {
                                return !1
                            }
                        }

                        function x(t) {
                            function e() {}
                            e.prototype = t;
                            var i = new e;

                            function n() {
                                return typeof i.foo
                            }
                            return n(), n(), t
                        }
                        var $ = /^[a-z$_][a-z$_0-9]*$/i;

                        function S(t) {
                            return $.test(t)
                        }

                        function C(t, e, i) {
                            for (var n = new Array(t), r = 0; r < t; ++r) n[r] = e + r + i;
                            return n
                        }

                        function T(t) {
                            try {
                                return t + ""
                            } catch (t) {
                                return "[no string representation]"
                            }
                        }

                        function E(t) {
                            return t instanceof Error || null !== t && "object" == typeof t && "string" == typeof t.message && "string" == typeof t.name
                        }

                        function D(t) {
                            try {
                                m(t, "isOperational", !0)
                            } catch (t) {}
                        }

                        function I(t) {
                            return null != t && (t instanceof Error.__BluebirdErrorTypes__.OperationalError || !0 === t.isOperational)
                        }

                        function A(t) {
                            return E(t) && a.propertyIsWritable(t, "stack")
                        }
                        var M = "stack" in new Error ? function(t) {
                            return A(t) ? t : new Error(T(t))
                        } : function(t) {
                            if (A(t)) return t;
                            try {
                                throw new Error(T(t))
                            } catch (t) {
                                return t
                            }
                        };

                        function P(t) {
                            return {}.toString.call(t)
                        }

                        function L(t, e, i) {
                            for (var n = a.names(t), r = 0; r < n.length; ++r) {
                                var o = n[r];
                                if (i(o)) try {
                                    a.defineProperty(e, o, a.getDescriptor(t, o))
                                } catch (t) {}
                            }
                        }
                        var N = function(t) {
                            return a.isArray(t) ? t : null
                        };
                        if ("undefined" != typeof Symbol && Symbol.iterator) {
                            var O = "function" == typeof Array.from ? function(t) {
                                return Array.from(t)
                            } : function(t) {
                                for (var e, i = [], n = t[Symbol.iterator](); !(e = n.next()).done;) i.push(e.value);
                                return i
                            };
                            N = function(t) {
                                return a.isArray(t) ? t : null != t && "function" == typeof t[Symbol.iterator] ? O(t) : null
                            }
                        }
                        var R = void 0 !== e && "[object process]" === P(e).toLowerCase(),
                            j = void 0 !== e && void 0 !== e.env;

                        function H(t) {
                            return j ? e.env[t] : void 0
                        }

                        function z() {
                            if ("function" == typeof Promise) try {
                                var t = new Promise(function() {});
                                if ("[object Promise]" === {}.toString.call(t)) return Promise
                            } catch (t) {}
                        }

                        function F(t, e) {
                            return t.bind(e)
                        }
                        var B = {
                            isClass: w,
                            isIdentifier: S,
                            inheritedDataKeys: b,
                            getDataPropertyOrDefault: v,
                            thrower: y,
                            isArray: a.isArray,
                            asArray: N,
                            notEnumerableProp: m,
                            isPrimitive: f,
                            isObject: _,
                            isError: E,
                            canEvaluate: o,
                            errorObj: s,
                            tryCatch: d,
                            inherits: h,
                            withAppended: p,
                            maybeWrapAsError: g,
                            toFastProperties: x,
                            filledRange: C,
                            toString: T,
                            canAttachTrace: A,
                            ensureErrorObject: M,
                            originatesFromRejection: I,
                            markAsOriginatingFromRejection: D,
                            classString: P,
                            copyDescriptors: L,
                            hasDevTools: "undefined" != typeof chrome && chrome && "function" == typeof chrome.loadTimes,
                            isNode: R,
                            hasEnvVariables: j,
                            env: H,
                            global: c,
                            getNativePromise: z,
                            domainBind: F
                        };
                        B.isRecentNode = B.isNode && function() {
                            var t;
                            return e.versions && e.versions.node ? t = e.versions.node.split(".").map(Number) : e.version && (t = e.version.split(".").map(Number)), 0 === t[0] && t[1] > 10 || t[0] > 0
                        }(), B.isNode && B.toFastProperties(e);
                        try {
                            throw new Error
                        } catch (t) {
                            B.lastLineError = t
                        }
                        n.exports = B
                    }, {
                        "./es5": 13
                    }]
                }, {}, [4])(4)
            }(), "undefined" != typeof window && null !== window ? window.P = window.Promise : "undefined" != typeof self && null !== self && (self.P = self.Promise)
        }).call(this, i(41), i(19), i(161).setImmediate)
    }, function(t, e, i) {
        t.exports = i(162)
    }, function(t, e, i) {
        var n = i(0);
        t.exports = function() {
            var t = {};
            return {
                getState: function(e) {
                    if (e) return t[e].method();
                    var i = {};
                    for (var r in t) t[r].internal || n.mixin(i, t[r].method(), !0);
                    return i
                },
                registerProvider: function(e, i, n) {
                    t[e] = {
                        method: i,
                        internal: n
                    }
                },
                unregisterProvider: function(e) {
                    delete t[e]
                }
            }
        }
    }, function(t, e) {
        t.exports = function(t) {
            var e = {};

            function i(i, n, r) {
                r = r || i;
                var a = t.config,
                    o = t.templates;
                t.config[i] && e[r] != a[i] && (n && o[r] || (o[r] = t.date.date_to_str(a[i]), e[r] = a[i]))
            }
            return {
                initTemplates: function() {
                    var e = t.locale.labels;
                    e.gantt_save_btn = e.icon_save, e.gantt_cancel_btn = e.icon_cancel, e.gantt_delete_btn = e.icon_delete;
                    var n = t.date,
                        r = n.date_to_str,
                        a = t.config,
                        o = r(a.xml_date || a.date_format, a.server_utc),
                        s = n.str_to_date(a.xml_date || a.date_format, a.server_utc);
                    i("date_scale", !0, void 0, t.config, t.templates), i("date_grid", !0, "grid_date_format", t.config, t.templates), i("task_date", !0, void 0, t.config, t.templates), t.mixin(t.templates, {
                        xml_format: o,
                        format_date: o,
                        xml_date: s,
                        parse_date: s,
                        progress_text: function(t, e, i) {
                            return ""
                        },
                        grid_header_class: function(t, e) {
                            return ""
                        },
                        task_text: function(t, e, i) {
                            return i.text
                        },
                        task_class: function(t, e, i) {
                            return ""
                        },
                        task_end_date: function(e) {
                            return t.templates.task_date(e)
                        },
                        grid_row_class: function(t, e, i) {
                            return ""
                        },
                        task_row_class: function(t, e, i) {
                            return ""
                        },
                        timeline_cell_class: function(t, e) {
                            return ""
                        },
                        scale_cell_class: function(t) {
                            return ""
                        },
                        scale_row_class: function(t) {
                            return ""
                        },
                        grid_indent: function(t) {
                            return "<div class='gantt_tree_indent'></div>"
                        },
                        grid_folder: function(t) {
                            return "<div class='gantt_tree_icon gantt_folder_" + (t.$open ? "open" : "closed") + "'></div>"
                        },
                        grid_file: function(t) {
                            return "<div class='gantt_tree_icon gantt_file'></div>"
                        },
                        grid_open: function(t) {
                            return "<div class='gantt_tree_icon gantt_" + (t.$open ? "close" : "open") + "'></div>"
                        },
                        grid_blank: function(t) {
                            return "<div class='gantt_tree_icon gantt_blank'></div>"
                        },
                        date_grid: function(e, i, n) {
                            return i && t.isUnscheduledTask(i) && t.config.show_unscheduled ? t.templates.task_unscheduled_time(i) : t.templates.grid_date_format(e, n)
                        },
                        task_time: function(e, i, n) {
                            return t.isUnscheduledTask(n) && t.config.show_unscheduled ? t.templates.task_unscheduled_time(n) : t.templates.task_date(e) + " - " + t.templates.task_end_date(i)
                        },
                        task_unscheduled_time: function(t) {
                            return ""
                        },
                        time_picker: r(a.time_picker),
                        link_class: function(t) {
                            return ""
                        },
                        link_description: function(e) {
                            var i = t.getTask(e.source),
                                n = t.getTask(e.target);
                            return "<b>" + i.text + "</b> &ndash;  <b>" + n.text + "</b>"
                        },
                        drag_link: function(e, i, n, r) {
                            e = t.getTask(e);
                            var a = t.locale.labels,
                                o = "<b>" + e.text + "</b> " + (i ? a.link_start : a.link_end) + "<br/>";
                            return n && (o += "<b> " + (n = t.getTask(n)).text + "</b> " + (r ? a.link_start : a.link_end) + "<br/>"), o
                        },
                        drag_link_class: function(e, i, n, r) {
                            var a = "";
                            return e && n && (a = " " + (t.isLinkAllowed(e, n, i, r) ? "gantt_link_allow" : "gantt_link_deny")), "gantt_link_tooltip" + a
                        },
                        tooltip_date_format: n.date_to_str("%Y-%m-%d"),
                        tooltip_text: function(e, i, n) {
                            return "<b>Task:</b> " + n.text + "<br/><b>Start date:</b> " + t.templates.tooltip_date_format(e) + "<br/><b>End date:</b> " + t.templates.tooltip_date_format(i)
                        }
                    })
                },
                initTemplate: i
            }
        }
    }, function(t, e, i) {
        var n = i(4),
            r = i(0),
            a = i(42);
        t.exports = function(t) {
            function e(t) {
                return {
                    target: t.target || t.srcElement,
                    pageX: t.pageX,
                    pageY: t.pageY,
                    clientX: t.clientX,
                    clientY: t.clientY,
                    metaKey: t.metaKey,
                    shiftKey: t.shiftKey,
                    ctrlKey: t.ctrlKey,
                    altKey: t.altKey
                }
            }

            function i(i, a) {
                this._obj = i, this._settings = a || {}, n(this);
                var o = this.getInputMethods();
                this._drag_start_timer = null, t.attachEvent("onGanttScroll", r.bind(function(t, e) {
                    this.clearDragTimer()
                }, this));
                for (var s = 0; s < o.length; s++) r.bind(function(n) {
                    t.event(i, n.down, r.bind(function(a) {
                        n.accessor(a) && (this._settings.original_target = e(a), t.config.touch ? (this.clearDragTimer(), this._drag_start_timer = setTimeout(r.bind(function() {
                            this.dragStart(i, a, n)
                        }, this), t.config.touch_drag)) : this.dragStart(i, a, n))
                    }, this)), t.event(document.body, n.up, r.bind(function(t) {
                        n.accessor(t) && this.clearDragTimer()
                    }, this))
                }, this)(o[s])
            }
            return i.prototype = {
                traceDragEvents: function(e, i) {
                    var n = r.bind(function(t) {
                        return this.dragMove(e, t, i.accessor)
                    }, this);
                    r.bind(function(t) {
                        return this.dragScroll(e, t)
                    }, this);
                    var o = r.bind(function(t) {
                            if (!this.config.started || !r.defined(this.config.updates_per_second) || a(this, this.config.updates_per_second)) {
                                var e = n(t);
                                return e && (t && t.preventDefault && t.preventDefault(), t.cancelBubble = !0), e
                            }
                        }, this),
                        s = r.bind(function(n) {
                            return t.eventRemove(document.body, i.move, o), t.eventRemove(document.body, i.up, s), this.dragEnd(e)
                        }, this);
                    t.event(document.body, i.move, o), t.event(document.body, i.up, s)
                },
                checkPositionChange: function(t) {
                    var e = t.x - this.config.pos.x,
                        i = t.y - this.config.pos.y;
                    return Math.sqrt(Math.pow(Math.abs(e), 2) + Math.pow(Math.abs(i), 2)) > this.config.sensitivity
                },
                initDnDMarker: function() {
                    var t = this.config.marker = document.createElement("div");
                    t.className = "gantt_drag_marker", t.innerHTML = "Dragging object", document.body.appendChild(t)
                },
                backupEventTarget: function(i, n) {
                    if (t.config.touch) {
                        var r = n(i),
                            a = r.target || r.srcElement,
                            o = a.cloneNode(!0);
                        this.config.original_target = e(r), this.config.original_target.target = o, this.config.backup_element = a, a.parentNode.appendChild(o), a.style.display = "none", document.body.appendChild(a)
                    }
                },
                getInputMethods: function() {
                    var e = [];
                    if (e.push({
                            move: "mousemove",
                            down: "mousedown",
                            up: "mouseup",
                            accessor: function(t) {
                                return t
                            }
                        }), t.config.touch) {
                        var i = !0;
                        try {
                            document.createEvent("TouchEvent")
                        } catch (t) {
                            i = !1
                        }
                        i ? e.push({
                            move: "touchmove",
                            down: "touchstart",
                            up: "touchend",
                            accessor: function(t) {
                                return t.touches && t.touches.length > 1 ? null : t.touches[0] ? {
                                    target: document.elementFromPoint(t.touches[0].clientX, t.touches[0].clientY),
                                    pageX: t.touches[0].pageX,
                                    pageY: t.touches[0].pageY,
                                    clientX: t.touches[0].clientX,
                                    clientY: t.touches[0].clientY
                                } : t
                            }
                        }) : window.navigator.pointerEnabled ? e.push({
                            move: "pointermove",
                            down: "pointerdown",
                            up: "pointerup",
                            accessor: function(t) {
                                return "mouse" == t.pointerType ? null : t
                            }
                        }) : window.navigator.msPointerEnabled && e.push({
                            move: "MSPointerMove",
                            down: "MSPointerDown",
                            up: "MSPointerUp",
                            accessor: function(t) {
                                return t.pointerType == t.MSPOINTER_TYPE_MOUSE ? null : t
                            }
                        })
                    }
                    return e
                },
                clearDragTimer: function() {
                    this._drag_start_timer && (clearTimeout(this._drag_start_timer), this._drag_start_timer = null)
                },
                dragStart: function(e, i, n) {
                    this.config && this.config.started || (this.config = {
                        obj: e,
                        marker: null,
                        started: !1,
                        pos: this.getPosition(i),
                        sensitivity: 4
                    }, this._settings && r.mixin(this.config, this._settings, !0), this.traceDragEvents(e, n), t._prevent_touch_scroll = !0, document.body.className += " gantt_noselect", t.config.touch && this.dragMove(e, i, n.accessor))
                },
                dragMove: function(e, i, n) {
                    var r = n(i);
                    if (!r) return !1;
                    if (!this.config.marker && !this.config.started) {
                        var a = this.getPosition(r);
                        if (t.config.touch || this.checkPositionChange(a)) {
                            if (this.config.started = !0, this.config.ignore = !1, !1 === this.callEvent("onBeforeDragStart", [e, this.config.original_target])) return this.config.ignore = !0, !1;
                            this.backupEventTarget(i, n), this.initDnDMarker(), t._touch_feedback(), this.callEvent("onAfterDragStart", [e, this.config.original_target])
                        } else this.config.ignore = !0
                    }
                    return !this.config.ignore && (r.pos = this.getPosition(r), this.config.marker.style.left = r.pos.x + "px", this.config.marker.style.top = r.pos.y + "px", this.callEvent("onDragMove", [e, r]), !0)
                },
                dragEnd: function(e) {
                    var i = this.config.backup_element;
                    i && i.parentNode && i.parentNode.removeChild(i), t._prevent_touch_scroll = !1, this.config.marker && (this.config.marker.parentNode.removeChild(this.config.marker), this.config.marker = null, this.callEvent("onDragEnd", [])), this.config.started = !1, document.body.className = document.body.className.replace(" gantt_noselect", "")
                },
                getPosition: function(t) {
                    var e = 0,
                        i = 0;
                    return (t = t || window.event).pageX || t.pageY ? (e = t.pageX, i = t.pageY) : (t.clientX || t.clientY) && (e = t.clientX + document.body.scrollLeft + document.documentElement.scrollLeft, i = t.clientY + document.body.scrollTop + document.documentElement.scrollTop), {
                        x: e,
                        y: i
                    }
                }
            }, i
        }
    }, function(t, e) {
        t.exports = function(t) {
            var e = {
                init: function() {
                    for (var e = t.locale, i = e.date.month_short, n = e.date.month_short_hash = {}, r = 0; r < i.length; r++) n[i[r]] = r;
                    for (i = e.date.month_full, n = e.date.month_full_hash = {}, r = 0; r < i.length; r++) n[i[r]] = r
                },
                date_part: function(t) {
                    var e = new Date(t);
                    return t.setHours(0), this.hour_start(t), t.getHours() && (t.getDate() < e.getDate() || t.getMonth() < e.getMonth() || t.getFullYear() < e.getFullYear()) && t.setTime(t.getTime() + 36e5 * (24 - t.getHours())), t
                },
                time_part: function(t) {
                    return (t.valueOf() / 1e3 - 60 * t.getTimezoneOffset()) % 86400
                },
                week_start: function(e) {
                    var i = e.getDay();
                    return t.config.start_on_monday && (0 === i ? i = 6 : i--), this.date_part(this.add(e, -1 * i, "day"))
                },
                month_start: function(t) {
                    return t.setDate(1), this.date_part(t)
                },
                quarter_start: function(t) {
                    this.month_start(t);
                    var e, i = t.getMonth();
                    return e = i >= 9 ? 9 : i >= 6 ? 6 : i >= 3 ? 3 : 0, t.setMonth(e), t
                },
                year_start: function(t) {
                    return t.setMonth(0), this.month_start(t)
                },
                day_start: function(t) {
                    return this.date_part(t)
                },
                hour_start: function(t) {
                    return t.getMinutes() && t.setMinutes(0), this.minute_start(t), t
                },
                minute_start: function(t) {
                    return t.getSeconds() && t.setSeconds(0), t.getMilliseconds() && t.setMilliseconds(0), t
                },
                _add_days: function(t, e) {
                    var i = new Date(t.valueOf());
                    return i.setDate(i.getDate() + e), e >= 0 && !t.getHours() && i.getHours() && (i.getDate() <= t.getDate() || i.getMonth() < t.getMonth() || i.getFullYear() < t.getFullYear()) && i.setTime(i.getTime() + 36e5 * (24 - i.getHours())), i
                },
                add: function(t, e, i) {
                    var n = new Date(t.valueOf());
                    switch (i) {
                        case "day":
                            n = this._add_days(n, e);
                            break;
                        case "week":
                            n = this._add_days(n, 7 * e);
                            break;
                        case "month":
                            n.setMonth(n.getMonth() + e);
                            break;
                        case "year":
                            n.setYear(n.getFullYear() + e);
                            break;
                        case "hour":
                            n.setTime(n.getTime() + 60 * e * 60 * 1e3);
                            break;
                        case "minute":
                            n.setTime(n.getTime() + 60 * e * 1e3);
                            break;
                        default:
                            return this["add_" + i](t, e, i)
                    }
                    return n
                },
                add_quarter: function(t, e) {
                    return this.add(t, 3 * e, "month")
                },
                to_fixed: function(t) {
                    return t < 10 ? "0" + t : t
                },
                copy: function(t) {
                    return new Date(t.valueOf())
                },
                date_to_str: function(i, n) {
                    i = i.replace(/%[a-zA-Z]/g, function(t) {
                        switch (t) {
                            case "%d":
                                return '"+to_fixed(date.getDate())+"';
                            case "%m":
                                return '"+to_fixed((date.getMonth()+1))+"';
                            case "%j":
                                return '"+date.getDate()+"';
                            case "%n":
                                return '"+(date.getMonth()+1)+"';
                            case "%y":
                                return '"+to_fixed(date.getFullYear()%100)+"';
                            case "%Y":
                                return '"+date.getFullYear()+"';
                            case "%D":
                                return '"+locale.date.day_short[date.getDay()]+"';
                            case "%l":
                                return '"+locale.date.day_full[date.getDay()]+"';
                            case "%M":
                                return '"+locale.date.month_short[date.getMonth()]+"';
                            case "%F":
                                return '"+locale.date.month_full[date.getMonth()]+"';
                            case "%h":
                                return '"+to_fixed((date.getHours()+11)%12+1)+"';
                            case "%g":
                                return '"+((date.getHours()+11)%12+1)+"';
                            case "%G":
                                return '"+date.getHours()+"';
                            case "%H":
                                return '"+to_fixed(date.getHours())+"';
                            case "%i":
                                return '"+to_fixed(date.getMinutes())+"';
                            case "%a":
                                return '"+(date.getHours()>11?"pm":"am")+"';
                            case "%A":
                                return '"+(date.getHours()>11?"PM":"AM")+"';
                            case "%s":
                                return '"+to_fixed(date.getSeconds())+"';
                            case "%W":
                                return '"+to_fixed(getISOWeek(date))+"';
                            case "%w":
                                return '"+to_fixed(getWeek(date))+"';
                            default:
                                return t
                        }
                    }), n && (i = i.replace(/date\.get/g, "date.getUTC"));
                    var r = new Function("date", "to_fixed", "locale", "getISOWeek", "getWeek", 'return "' + i + '";');
                    return function(i) {
                        return r(i, e.to_fixed, t.locale, e.getISOWeek, e.getWeek)
                    }
                },
                str_to_date: function(e, i) {
                    for (var n = "var temp=date.match(/[a-zA-Z]+|[0-9]+/g);", r = e.match(/%[a-zA-Z]/g), a = 0; a < r.length; a++) switch (r[a]) {
                        case "%j":
                        case "%d":
                            n += "set[2]=temp[" + a + "]||1;";
                            break;
                        case "%n":
                        case "%m":
                            n += "set[1]=(temp[" + a + "]||1)-1;";
                            break;
                        case "%y":
                            n += "set[0]=temp[" + a + "]*1+(temp[" + a + "]>50?1900:2000);";
                            break;
                        case "%g":
                        case "%G":
                        case "%h":
                        case "%H":
                            n += "set[3]=temp[" + a + "]||0;";
                            break;
                        case "%i":
                            n += "set[4]=temp[" + a + "]||0;";
                            break;
                        case "%Y":
                            n += "set[0]=temp[" + a + "]||0;";
                            break;
                        case "%a":
                        case "%A":
                            n += "set[3]=set[3]%12+((temp[" + a + "]||'').toLowerCase()=='am'?0:12);";
                            break;
                        case "%s":
                            n += "set[5]=temp[" + a + "]||0;";
                            break;
                        case "%M":
                            n += "set[1]=locale.date.month_short_hash[temp[" + a + "]]||0;";
                            break;
                        case "%F":
                            n += "set[1]=locale.date.month_full_hash[temp[" + a + "]]||0;"
                    }
                    var o = "set[0],set[1],set[2],set[3],set[4],set[5]";
                    i && (o = " Date.UTC(" + o + ")");
                    var s = new Function("date", "locale", "var set=[0,0,1,0,0,0]; " + n + " return new Date(" + o + ");");
                    return function(e) {
                        return s(e, t.locale)
                    }
                },
                getISOWeek: function(e) {
                    return t.date._getWeekNumber(e, !0)
                },
                _getWeekNumber: function(t, e) {
                    if (!t) return !1;
                    var i = t.getDay();
                    e && 0 === i && (i = 7);
                    var n = new Date(t.valueOf());
                    n.setDate(t.getDate() + (4 - i));
                    var r = n.getFullYear(),
                        a = Math.round((n.getTime() - new Date(r, 0, 1).getTime()) / 864e5);
                    return 1 + Math.floor(a / 7)
                },
                getWeek: function(e) {
                    return t.date._getWeekNumber(e, t.config.start_on_monday)
                },
                getUTCISOWeek: function(e) {
                    return t.date.getISOWeek(e)
                },
                convert_to_utc: function(t) {
                    return new Date(t.getUTCFullYear(), t.getUTCMonth(), t.getUTCDate(), t.getUTCHours(), t.getUTCMinutes(), t.getUTCSeconds())
                },
                parseDate: function(e, i) {
                    return e && !e.getFullYear && ("function" != typeof i && ("string" == typeof i ? "parse_date" === i ? (i = t.templates.parse_date, t.defined(t.templates.xml_date) && t.templates.parse_date !== t.templates.xml_date && (i = t.templates.xml_date)) : i = t.defined(t.templates[i]) ? t.templates[i] : t.date.str_to_date(i) : i = t.templates.xml_date !== t.templates.parse_date ? t.templates.xml_date : t.templates.parse_date), e = e ? i(e) : null), e
                }
            };
            return e
        }
    }, function(t, e, i) {
        "use strict";
        Object.defineProperty(e, "__esModule", {
            value: !0
        }), e.default = function(t) {
            if ("string" == typeof t || "number" == typeof t) return t;
            var e = "";
            for (var i in t) {
                var n = "";
                t.hasOwnProperty(i) && (n = i + "=" + (n = "string" == typeof t[i] ? encodeURIComponent(t[i]) : "number" == typeof t[i] ? t[i] : encodeURIComponent(JSON.stringify(t[i]))), e.length && (n = "&" + n), e += n)
            }
            return e
        }
    }, function(t, e, i) {
        var n = i(8),
            r = i(168).default;

        function a(t, e) {
            var i = {
                method: t
            };
            if (0 === e.length) throw new Error("Arguments list of query is wrong.");
            if (1 === e.length) return "string" == typeof e[0] ? (i.url = e[0], i.async = !0) : (i.url = e[0].url, i.async = e[0].async || !0, i.callback = e[0].callback, i.headers = e[0].headers), e[0].data ? "string" != typeof e[0].data ? i.data = r(e[0].data) : i.data = e[0].data : i.data = "", i;
            switch (i.url = e[0], t) {
                case "GET":
                case "DELETE":
                    i.callback = e[1], i.headers = e[2];
                    break;
                case "POST":
                case "PUT":
                    e[1] ? "string" != typeof e[1] ? i.data = r(e[1]) : i.data = e[1] : i.data = "", i.callback = e[2], i.headers = e[3]
            }
            return i
        }
        t.exports = function(t) {
            return {
                cache: !0,
                method: "get",
                parse: function(t) {
                    return "string" != typeof t ? t : (t = t.replace(/^[\s]+/, ""), window.DOMParser && !n.isIE ? e = (new window.DOMParser).parseFromString(t, "text/xml") : window.ActiveXObject !== window.undefined && ((e = new window.ActiveXObject("Microsoft.XMLDOM")).async = "false", e.loadXML(t)), e);
                    var e
                },
                xmltop: function(e, i, n) {
                    if (void 0 === i.status || i.status < 400) {
                        var r = i.responseXML ? i.responseXML || i : this.parse(i.responseText || i);
                        if (r && null !== r.documentElement && !r.getElementsByTagName("parsererror").length) return r.getElementsByTagName(e)[0]
                    }
                    return -1 !== n && t.callEvent("onLoadXMLError", ["Incorrect XML", arguments[1], n]), document.createElement("DIV")
                },
                xpath: function(t, e) {
                    if (e.nodeName || (e = e.responseXML || e), n.isIE) return e.selectNodes(t) || [];
                    for (var i, r = [], a = (e.ownerDocument || e).evaluate(t, e, null, XPathResult.ANY_TYPE, null); i = a.iterateNext();) r.push(i);
                    return r
                },
                query: function(t) {
                    return this._call(t.method || "GET", t.url, t.data || "", t.async || !0, t.callback, t.headers)
                },
                get: function(t, e, i) {
                    var n = a("GET", arguments);
                    return this.query(n)
                },
                getSync: function(t, e) {
                    var i = a("GET", arguments);
                    return i.async = !1, this.query(i)
                },
                put: function(t, e, i, n) {
                    var r = a("PUT", arguments);
                    return this.query(r)
                },
                del: function(t, e, i) {
                    var n = a("DELETE", arguments);
                    return this.query(n)
                },
                post: function(t, e, i, n) {
                    1 == arguments.length ? e = "" : 2 != arguments.length || "function" != typeof e && "function" != typeof window[e] || (e, e = "");
                    var r = a("POST", arguments);
                    return this.query(r)
                },
                postSync: function(t, e, i) {
                    e = null === e ? "" : String(e);
                    var n = a("POST", arguments);
                    return n.async = !1, this.query(n)
                },
                _call: function(e, i, r, a, o, s) {
                    return new t.Promise(function(l, c) {
                        var u = window.XMLHttpRequest && !n.isIE ? new XMLHttpRequest : new window.ActiveXObject("Microsoft.XMLHTTP"),
                            d = null !== navigator.userAgent.match(/AppleWebKit/) && null !== navigator.userAgent.match(/Qt/) && null !== navigator.userAgent.match(/Safari/);
                        if (a && (u.onreadystatechange = function() {
                                if (4 == u.readyState || d && 3 == u.readyState) {
                                    if ((200 != u.status || "" === u.responseText) && !t.callEvent("onAjaxError", [u])) return;
                                    window.setTimeout(function() {
                                        "function" == typeof o && o.apply(window, [{
                                            xmlDoc: u,
                                            filePath: i
                                        }]), l(u), "function" == typeof o && (o = null, u = null)
                                    }, 0)
                                }
                            }), "GET" != e || this.cache || (i += (i.indexOf("?") >= 0 ? "&" : "?") + "dhxr" + (new Date).getTime() + "=1"), u.open(e, i, a), s)
                            for (var h in s) u.setRequestHeader(h, s[h]);
                        else "POST" == e.toUpperCase() || "PUT" == e || "DELETE" == e ? u.setRequestHeader("Content-Type", "application/x-www-form-urlencoded") : "GET" == e && (r = null);
                        if (u.setRequestHeader("X-Requested-With", "XMLHttpRequest"), u.send(r), !a) return {
                            xmlDoc: u,
                            filePath: i
                        }
                    })
                },
                urlSeparator: function(t) {
                    return -1 != t.indexOf("?") ? "&" : "?"
                }
            }
        }
    }, function(t, e, i) {
        "use strict";
        Object.defineProperty(e, "__esModule", {
            value: !0
        }), t.exports = function() {
            return {
                layout: {
                    css: "gantt_container",
                    rows: [{
                        cols: [{
                            view: "grid",
                            scrollX: "scrollHor",
                            scrollY: "scrollVer"
                        }, {
                            resizer: !0,
                            width: 1
                        }, {
                            view: "timeline",
                            scrollX: "scrollHor",
                            scrollY: "scrollVer"
                        }, {
                            view: "scrollbar",
                            id: "scrollVer"
                        }]
                    }, {
                        view: "scrollbar",
                        id: "scrollHor",
                        height: 20
                    }]
                },
                links: {
                    finish_to_start: "0",
                    start_to_start: "1",
                    finish_to_finish: "2",
                    start_to_finish: "3"
                },
                types: {
                    task: "task",
                    project: "project",
                    milestone: "milestone"
                },
                auto_types: !1,
                duration_unit: "day",
                work_time: !1,
                correct_work_time: !1,
                skip_off_time: !1,
                cascade_delete: !0,
                autosize: !1,
                autosize_min_width: 0,
                autoscroll: !0,
                autoscroll_speed: 30,
                show_links: !0,
                show_task_cells: !0,
                static_background: !1,
                static_background_cells: !0,
                branch_loading: !1,
                branch_loading_property: "$has_child",
                show_loading: !1,
                show_chart: !0,
                show_grid: !0,
                min_duration: 36e5,
                date_format: "%d-%m-%Y %H:%i",
                xml_date: void 0,
                start_on_monday: !0,
                server_utc: !1,
                show_progress: !0,
                fit_tasks: !1,
                select_task: !0,
                scroll_on_click: !0,
                smart_rendering: !0,
                preserve_scroll: !0,
                readonly: !1,
                date_grid: "%Y-%m-%d",
                drag_links: !0,
                drag_progress: !0,
                drag_resize: !0,
                drag_project: !1,
                drag_move: !0,
                drag_mode: {
                    resize: "resize",
                    progress: "progress",
                    move: "move",
                    ignore: "ignore"
                },
                round_dnd_dates: !0,
                link_wrapper_width: 20,
                root_id: 0,
                autofit: !1,
                columns: [{
                    name: "text",
                    tree: !0,
                    width: "*",
                    resize: !0
                }, {
                    name: "start_date",
                    align: "center",
                    resize: !0
                }, {
                    name: "duration",
                    align: "center"
                }, {
                    name: "add",
                    width: 44
                }],
                scale_offset_minimal: !0,
                inherit_scale_class: !1,
                scales: [{
                    unit: "day",
                    step: 1,
                    date: "%d %M"
                }],
                time_step: 60,
                duration_step: 1,
                task_date: "%d %F %Y",
                time_picker: "%H:%i",
                task_attribute: "task_id",
                link_attribute: "link_id",
                layer_attribute: "data-layer",
                buttons_left: ["gantt_save_btn", "gantt_cancel_btn"],
                _migrate_buttons: {
                    dhx_save_btn: "gantt_save_btn",
                    dhx_cancel_btn: "gantt_cancel_btn",
                    dhx_delete_btn: "gantt_delete_btn"
                },
                buttons_right: ["gantt_delete_btn"],
                lightbox: {
                    sections: [{
                        name: "description",
                        height: 70,
                        map_to: "text",
                        type: "textarea",
                        focus: !0
                    }, {
                        name: "time",
                        type: "duration",
                        map_to: "auto"
                    }],
                    project_sections: [{
                        name: "description",
                        height: 70,
                        map_to: "text",
                        type: "textarea",
                        focus: !0
                    }, {
                        name: "type",
                        type: "typeselect",
                        map_to: "type"
                    }, {
                        name: "time",
                        type: "duration",
                        readonly: !0,
                        map_to: "auto"
                    }],
                    milestone_sections: [{
                        name: "description",
                        height: 70,
                        map_to: "text",
                        type: "textarea",
                        focus: !0
                    }, {
                        name: "type",
                        type: "typeselect",
                        map_to: "type"
                    }, {
                        name: "time",
                        type: "duration",
                        single_date: !0,
                        map_to: "auto"
                    }]
                },
                drag_lightbox: !0,
                sort: !1,
                details_on_create: !0,
                details_on_dblclick: !0,
                initial_scroll: !0,
                task_scroll_offset: 100,
                order_branch: !1,
                order_branch_free: !1,
                task_height: "full",
                min_column_width: 70,
                min_grid_column_width: 70,
                grid_resizer_column_attribute: "column_index",
                grid_resizer_attribute: "grid_resizer",
                keep_grid_width: !1,
                grid_resize: !1,
                show_tasks_outside_timescale: !1,
                show_unscheduled: !0,
                readonly_property: "readonly",
                editable_property: "editable",
                calendar_property: "calendar_id",
                resource_calendars: {},
                inherit_calendar: !1,
                type_renderers: {},
                open_tree_initially: !1,
                optimize_render: !0,
                prevent_default_scroll: !1,
                show_errors: !0,
                wai_aria_attributes: !0,
                smart_scales: !0,
                rtl: !1,
                placeholder_task: !1,
                horizontal_scroll_key: "shiftKey",
                drag_timeline: {
                    useKey: void 0,
                    ignore: ".gantt_task_line, .gantt_task_link"
                },
                drag_multiple: !0
            }
        }
    }, function(t, e) {
        t.exports = function() {
            var t = {};
            return {
                services: {
                    config: "config",
                    templates: "templates",
                    locale: "locale"
                },
                setService: function(e, i) {
                    t[e] = i
                },
                getService: function(e) {
                    return t[e] ? t[e]() : null
                },
                dropService: function(e) {
                    t[e] && delete t[e]
                },
                config: function() {
                    return this.getService("config")
                },
                templates: function() {
                    return this.getService("templates")
                },
                locale: function() {
                    return this.getService("locale")
                },
                destructor: function() {
                    for (var e in t)
                        if (t[e]) {
                            var i = t[e];
                            i && i.destructor && i.destructor()
                        }
                    t = null
                }
            }
        }
    }, function(t, e) {
        t.exports = function(t) {
            t.$inject = function(t) {
                return t(this.$services)
            }
        }
    }, function(t, e) {
        t.exports = {
            KEY_CODES: {
                UP: 38,
                DOWN: 40,
                LEFT: 37,
                RIGHT: 39,
                SPACE: 32,
                ENTER: 13,
                DELETE: 46,
                ESC: 27,
                TAB: 9
            }
        }
    }, function(t, e, i) {
        i(21), t.exports = function() {
            var t = new function() {
                this.constants = i(173), this.version = "6.3.0", this.license = "site", this.templates = {}, this.ext = {}, this.keys = {
                    edit_save: this.constants.KEY_CODES.ENTER,
                    edit_cancel: this.constants.KEY_CODES.ESC
                }
            };
            i(172)(t), t.$services = t.$inject(i(171)), t.config = t.$inject(i(170)), t.ajax = i(169)(t), t.date = i(167)(t);
            var e = i(166)(t);
            t.$services.setService("dnd", function() {
                return e
            }), t.$services.setService("config", function() {
                return t.config
            }), t.$services.setService("date", function() {
                return t.date
            }), t.$services.setService("locale", function() {
                return t.locale
            }), t.$services.setService("templates", function() {
                return t.templates
            });
            var n = i(165)(t);
            t.$services.setService("templateLoader", function() {
                return n
            }), i(4)(t);
            var r = new(i(164));
            r.registerProvider("global", function() {
                var e = {
                    min_date: t._min_date,
                    max_date: t._max_date,
                    selected_task: null
                };
                return t.$data && t.$data.tasksStore && (e.selected_task = t.$data.tasksStore.getSelectedId()), e
            }), t.getState = r.getState, t.$services.setService("state", function() {
                return r
            });
            var a = i(0);
            a.mixin(t, a), t.Promise = i(163), t.env = i(8);
            var o = i(1);
            t.utils = {
                dom: {
                    getNodePosition: o.getNodePosition,
                    getRelativeEventPosition: o.getRelativeEventPosition,
                    isChildOf: o.isChildOf,
                    hasClass: o.hasClass,
                    closest: o.closest
                }
            };
            var s = i(22)();
            t.event = s.attach, t.eventRemove = s.detach, t._eventRemoveAll = s.detachAll, t._createDomEventScope = s.extend, a.mixin(t, i(159)(t));
            var l = i(158).init(t);
            t.$ui = l.factory, t.$ui.layers = l.render, t.$mouseEvents = l.mouseEvents, t.$services.setService("mouseEvents", function() {
                return t.$mouseEvents
            }), t.mixin(t, l.layersApi), i(115)(t), t.$services.setService("layers", function() {
                return l.layersService
            });
            var c = i(114);
            t.mixin(t, c()), i(113)(t);
            var u = i(107);
            return t.dataProcessor = u.DEPRECATED_api, t.createDataProcessor = u.createDataProcessor, i(102)(t), i(89)(t), i(88)(t), i(86)(t), i(85)(t), i(84)(t), i(83)(t), i(74)(t), i(73).default(t), i(72)(t), i(61)(t), i(60)(t), i(58)(t), i(57)(t), i(56)(t), i(55)(t), i(54)(t), i(53)(t), i(52)(t), i(51)(t), i(50)(t), i(49)(t), i(48)(t), i(47)(t), i(45)(t), i(44).default(t), t
        }
    }, function(t, e, i) {
        var n = {
            _seed: 0,
            plugin: function(t) {
                this._ganttPlugin.push(t), t(window.gantt)
            },
            _ganttPlugin: [],
            getGanttInstance: function() {
                for (var t = i(174)(), e = 0; e < n._ganttPlugin.length; e++) n._ganttPlugin[e](t);
                return t._internal_id = n._seed++, n.$syncFactory && n.$syncFactory(t), i(43)(t), t
            }
        };
        t.exports = n
    }, function(t, e, i) {
        "use strict";
        Object.defineProperty(e, "__esModule", {
            value: !0
        });
        var n = i(175);
        e.Gantt = n;
        var r = window;
        r.Gantt = n;
        var a = r.gantt = n.getGanttInstance();
        e.gantt = a, n.plugin(function(t) {
            var e = ["href", "location", ".", "indexOf", "error", "This version of Gantt is not intended for using outside of dhtmlx.com", "message", "random", "floor"]; - 1 == document[e[1]][e[0]][e[3]](e[2]) && setTimeout(function() {
                t[e[6]]({
                    type: e[4],
                    text: e[5],
                    expire: -1
                })
            }, Math[e[8]](5e3 * Math[e[7]]()) + 1e3)
        }), e.default = a
    }])
});