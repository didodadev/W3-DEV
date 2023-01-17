/*
jQWidgets v3.8.2 (2015-Aug)
Copyright (c) 2011-2015 jQWidgets.
License: http://jqwidgets.com/license/
*/
(function(a) {
    a.extend(a.jqx._jqxGrid.prototype, {
        _handledblclick: function(t, n) 
		{
            if (t.target == null) {
                return
            }
            if (n.disabled) {
                return
            }
            if (a(t.target).ischildof(this.columnsheader)) {
                return
            }
            var w;
            if (t.which) {
                w = (t.which == 3)
            } else {
                if (t.button) {
                    w = (t.button == 2)
                }
            }
            if (w) {
                return
            }
            var B;
            if (t.which) {
                B = (t.which == 2)
            } else {
                if (t.button) {
                    B = (t.button == 1)
                }
            }
            if (B) {
                return
            }
            var v = this.showheader ? this.columnsheader.height() + 2 : 0;
            var o = this._groupsheader() ? this.groupsheader.height() : 0;
            var A = this.showtoolbar ? this.toolbarheight : 0;
            o += A;
            var e = this.host.offset();
            var m = t.pageX - e.left;
            var l = t.pageY - v - e.top - o;
            var b = this._hittestrow(m, l);
            if (!b) {
                return
            }
            var h = b.row;
            var j = b.index;
            var q = t.target.className;
            var p = this.table[0].rows[j];
            if (p == null) {
                return
            }
            n.mousecaptured = true;
            n.mousecaptureposition = {
                left: t.pageX,
                top: t.pageY - o
            };
            var r = this.hScrollInstance;
            var s = r.value;
            var d = 0;
            var k = this.groupable ? this.groups.length : 0;
            for (var u = 0; u < p.cells.length; u++) {
                var f = parseInt(a(this.columnsrow[0].cells[u]).css("left"));
                var g = f - s;
                if (n.columns.records[u].pinned) {
                    g = f
                }
                var c = this._getcolumnat(u);
                if (c != null && c.hidden) {
                    continue
                }
                var z = g + a(this.columnsrow[0].cells[u]).width();
                if (z >= m && m >= g) {
                    d = u;
                    break
                }
            }
            if (h != null) {
                var c = this._getcolumnat(d);
                if (!(q.indexOf("jqx-grid-group-expand") != -1 || q.indexOf("jqx-grid-group-collapse") != -1)) {
                    if (h.boundindex != -1) {
                        n.begincelledit(n.getboundindex(h), c.datafield, c.defaulteditorvalue)
                    }
                }
            }
        },
        _getpreveditablecolumn: function(c) {
            var b = this;
            while (c > 0) {
                c--;
                var d = b.getcolumnat(c);
                if (!d) {
                    return null
                }
                if (!d.editable) {
                    continue
                }
                if (!d.hidden) {
                    return d
                }
            }
            return null
        },
        _getnexteditablecolumn: function(c) {
            var b = this;
            while (c < this.columns.records.length) {
                c++;
                var d = b.getcolumnat(c);
                if (!d) {
                    return null
                }
                if (!d.editable) {
                    continue
                }
                if (!d.hidden) {
                    return d
                }
            }
            return null
        },
        _handleeditkeydown: function(E, y) {
            if (y.handlekeyboardnavigation) {
                var q = y.handlekeyboardnavigation(E);
                if (q == true) {
                    return true
                }
            }
            var J = E.charCode ? E.charCode : E.keyCode ? E.keyCode : 0;
            if (y.showfilterrow && y.filterable) {
                if (this.filterrow) {
                    if (a(E.target).ischildof(this.filterrow)) {
                        return true
                    }
                }
            }
            if (y.pageable) {
                if (a(E.target).ischildof(this.pager)) {
                    return true
                }
            }
            if (this.showtoolbar) {
                if (a(E.target).ischildof(this.toolbar)) {
                    return true
                }
            }
            if (this.showeverpresentrow) {
                if (this.addnewrowtop) {
                    if (a(E.target).ischildof(this.addnewrowtop)) {
                        return true
                    }
                }
                if (this.addnewrowbottom) {
                    if (a(E.target).ischildof(this.addnewrowbottom)) {
                        return true
                    }
                }
            }
            if (this.showstatusbar) {
                if (a(E.target).ischildof(this.statusbar)) {
                    return true
                }
            }
            if (this.rowdetails) {
                if (a(E.target).ischildof(this.content.find("[role='rowgroup']"))) {
                    return true
                }
            }
            if (this.editcell) 
			{
                if (this.editmode === "selectedrow") {
                    if (J === 13) {
                        this.endrowedit(this.editcell.row, false)
                    } else {
                        if (J === 27) {
                            this.endrowedit(this.editcell.row, true)
                        }
                    }
                    if (J === 9) {
                        return false
                    }
                    return true
                }
                if (this.editcell.columntype == null || this.editcell.columntype == "textbox" || this.editcell.columntype == "numberinput" || this.editcell.columntype == "combobox" || this.editcell.columntype == "datetimeinput") {
                    if (J >= 33 && J <= 40 && y.selectionmode == "multiplecellsadvanced") 
					{
						var i = this.editcell.columntype == "textbox" || this.editcell.columntype == null ? this.editcell.editor : this.editcell.editor.find("input");
                        var K = y._selection(i);
                        var z = i.val().length;
                        if (K.length > 0 && this.editcell.columntype != "datetimeinput") {
                            y._cancelkeydown = true
                        }
                        if (K.start > 0 && J == 37) 
						{
                            y._cancelkeydown = true
                        }
                        if (K.start < z && J == 39 && this.editcell.columntype != "datetimeinput") 
						{
                            y._cancelkeydown = true
                        }
                        if (this.editcell.columntype == "datetimeinput" && J == 39) {
                            if (K.start + K.length < z) {
                                y._cancelkeydown = true
                            }
                        }
                    }
                } else {
                    if (this.editcell.columntype == "dropdownlist") {
                        if (J == 37 || J == 39 && y.selectionmode == "multiplecellsadvanced") {
                            y._cancelkeydown = false
                        }
                    } else {
                        if (this.selectionmode == "multiplecellsadvanced" && this.editcell.columntype != "textbox" && this.editcell.columntype != "numberinput") {
                            y._cancelkeydown = true
                        }
                    }
                }
                if (J == 32) {
                    if (y.editcell.columntype == "checkbox") {
                        var f = y.getcolumn(y.editcell.datafield);
                        if (f.editable) {
                            var o = !y.getcellvalue(y.editcell.row, y.editcell.column);
                            if (f.cellbeginedit) {
                                var b = f.cellbeginedit(y.editcell.row, f.datafield, f.columntype, !o);
                                if (b == false) {
                                    return false
                                }
                            }
                            var k = y.getrowdata(y.editcell.row);
                            y.setcellvalue(y.editcell.row, y.editcell.column, o, true);
                            y._raiseEvent(18, {
                                rowindex: y.editcell.row,
                                row: k,
                                datafield: y.editcell.column,
                                oldvalue: !o,
                                value: o,
                                columntype: "checkbox"
                            });
                            return false
                        }
                    }
                }
                if (J == 9) {
                    var h = this.editcell.row;
                    var w = this.editcell.column;
                    var n = w;
                    var B = y._getcolumnindex(w);
                    var v = false;
                    var d = y.getrowvisibleindex(h);
                    this.editchar = "";
                    var e = this.editcell.validated;
                    if (!this.editcell.validated) {
                        var e = this.endcelledit(this.editcell.row, this.editcell.column, false, true, false)
                    }
                    if (e != false) {
                        if (E.shiftKey) {
                            var f = y._getpreveditablecolumn(B);
                            if (f) {
                                w = f.datafield;
                                v = true;
                                if (y.selectionmode.indexOf("cell") != -1) {
                                    y.selectprevcell(h, n);
                                    y._oldselectedcell = y.selectedcell;
                                    setTimeout(function() {
                                        y.ensurecellvisible(d, w)
                                    }, 10)
                                }
                            } else {
                                var p = y._getlastvisiblecolumn();
                                v = true;
                                w = p.displayfield;
                                h--;
                                if (y.selectionmode.indexOf("cell") != -1) {
                                    y.clearselection();
                                    y.selectcell(h, w);
                                    y._oldselectedcell = y.selectedcell;
                                    setTimeout(function() {
                                        y.ensurecellvisible(d, w)
                                    }, 10)
                                }
                            }
                        } else {
                            var f = y._getnexteditablecolumn(B);
                            if (f) {
                                w = f.datafield;
                                v = true;
                                if (y.selectionmode.indexOf("cell") != -1) {
                                    y.selectnextcell(h, n);
                                    y._oldselectedcell = y.selectedcell;
                                    setTimeout(function() {
                                        y.ensurecellvisible(d, w)
                                    }, 10)
                                }
                            } else {
                                var I = y._getfirstvisiblecolumn();
                                v = true;
                                w = I.displayfield;
                                h++;
                                if (y.selectionmode.indexOf("cell") != -1) {
                                    y.clearselection();
                                    y.selectcell(h, w);
                                    y._oldselectedcell = y.selectedcell;
                                    setTimeout(function() {
                                        y.ensurecellvisible(d, w)
                                    }, 10)
                                }
                            }
                        }
                        if (v) {
                            y.begincelledit(h, w);
                            if (this.editcell != null && this.editcell.columntype == "checkbox") {
                                this._renderrows(this.virtualsizeinfo)
                            }
                        } else {
                            if (this.editcell != null) {
                                y.endcelledit(h, w, false);
                                this._renderrows(this.virtualsizeinfo)
                            }
                            return true
                        }
                    }
                    return false
                } else {
                    if (J == 13) {
                        var u = this.selectedcell;
                        if (u) {
                            var x = this.getrowvisibleindex(u.rowindex)
                        }
                        this.endcelledit(this.editcell.row, this.editcell.column, false, true);
                        if (this.selectionmode == "multiplecellsadvanced") 
						{
                            return false;
							var c = y.getselectedcell();
                            if (c != null) {
                                if (y.selectcell) {
                                    if (this.editcell == null) {
                                        if (c.rowindex + 1 < this.dataview.totalrecords) {
                                            if (this.sortcolumn != c.datafield) {
                                                var d = this.getrowvisibleindex(c.rowindex);
                                                var H = this.dataview.loadedrecords[d + 1];
                                                if (H) {
                                                    if (!this.pageable || (this.pageable && d + 1 < (this.dataview.pagenum + 1) * this.pagesize)) {
                                                        this.clearselection(false);
                                                        this.selectcell(this.getboundindex(H), c.datafield);
                                                        var c = this.getselectedcell();
                                                        this.ensurecellvisible(H.visibleindex, c.datafield)
                                                    }
                                                }
                                            } else {
                                                if (u != null) {
                                                    var G = this.dataview.loadedrecords[x + 1];
                                                    if (G) {
                                                        if (!this.pageable || (this.pageable && x + 1 < this.pagesize)) {
                                                            this.clearselection(false);
                                                            this.selectcell(this.getboundindex(G), c.datafield)
                                                        } else {
                                                            if (this.pageable && x + 1 >= this.pagesize) {
                                                                this.clearselection(false);
                                                                var G = this.dataview.loadedrecords[x];
                                                                this.selectcell(this.getboundindex(G), c.datafield)
                                                            }
                                                        }
                                                    }
                                                }
                                            }
                                        }
                                    }
                                }
                            }
                        }
                        return false
                    } else {
                        if (J == 27) {
                            this.endcelledit(this.editcell.row, this.editcell.column, true, true);
                            return false
                        }
                    }
                }
            } else {
                var A = false;
                if (J == 113) {
                    A = true
                }
                if (!E.ctrlKey && !E.altKey && !E.metaKey) {
                    if (J >= 48 && J <= 57) {
                        this.editchar = String.fromCharCode(J);
                        A = true
                    }
                    if (J >= 65 && J <= 90) {
                        this.editchar = String.fromCharCode(J);
                        var t = false;
                        if (E.shiftKey) {
                            t = E.shiftKey
                        } else {
                            if (E.modifiers) {
                                t = !!(E.modifiers & 4)
                            }
                        }
                        if (!t) {
                            this.editchar = this.editchar.toLowerCase()
                        }
                        A = true
                    } else {
                        if (J >= 96 && J <= 105) {
                            this.editchar = J - 96;
                            this.editchar = this.editchar.toString();
                            A = true
                        }
                    }
                    var s = a(".jqx-grid").length;
                    A = A && (s == 1 || (s > 1 && y.focused));
                    var l = a.data(document.body, "jqxgrid.edit");
                    if (l !== undefined && l !== "") {
                        if (J === 13 || A) {
                            if (l != y.element.id) {
                                return true
                            }
                        }
                    }
                }
                if (J == 13 || A) {
                    if (y.getselectedrowindex) {
                        var h = y.getselectedrowindex();
                        switch (y.selectionmode) {
                            case "singlerow":
                            case "multiplerows":
                            case "multiplerowsextended":
                                if (h >= 0) {
                                    var w = "";
                                    for (var C = 0; C < y.columns.records.length; C++) {
                                        var f = y.getcolumnat(C);
                                        if (f.editable) {
                                            w = f.datafield;
                                            break
                                        }
                                    }
                                    y.begincelledit(h, w)
                                }
                                break;
                            case "singlecell":
                            case "multiplecells":
                            case "multiplecellsextended":
                                var c = y.getselectedcell();
                                if (c != null) {
                                    var f = y._getcolumnbydatafield(c.datafield);
                                    if (f.columntype != "checkbox") {
                                        y.begincelledit(c.rowindex, c.datafield)
                                    }
                                }
                                break;
                            case "multiplecellsadvanced":
                                var c = y.getselectedcell();
                                if (c != null) {
                                    if (J == 13) {
                                        if (y.selectcell) {
                                            if (c.rowindex + 1 < y.dataview.totalrecords) {
                                                var d = this.getrowvisibleindex(c.rowindex);
                                                var H = this.dataview.loadedrecords[d + 1];
                                                if (H) {
                                                    this.clearselection(false);
                                                    this.selectcell(this.getboundindex(H), c.datafield);
                                                    var c = this.getselectedcell();
                                                    this.ensurecellvisible(H.visibleindex, c.datafield)
                                                }
                                            }
                                        }
                                    } else {
                                        if (y.editmode !== "selectedrow") {
                                            y.begincelledit(c.rowindex, c.datafield)
                                        }
                                    }
                                }
                                break
                        }
                        return false
                    }
                }
                if (J == 46) {
                    var g = y.getselectedcells();
                    if (y.selectionmode.indexOf("cell") == -1) {
                        if (y._getcellsforcopypaste) {
                            g = y._getcellsforcopypaste()
                        }
                    }
                    if (g != null && g.length > 0) {
                        for (var r = 0; r < g.length; r++) {
                            var c = g[r];
                            if (!c.datafield) {
                                continue
                            }
                            var f = y.getcolumn(c.datafield);
                            var F = y.getcellvalue(c.rowindex, c.datafield);
                            if (F !== "" && f.editable && y.enablekeyboarddelete) {
                                var j = null;
                                if (f.columntype == "checkbox") {
                                    if (!f.threestatecheckbox) {
                                        j = false
                                    }
                                }
                                if (f.cellbeginedit) {
                                    var b = f.cellbeginedit(c.rowindex, f.datafield, f.columntype, j);
                                    if (b == false) {
                                        return false
                                    }
                                }
                                var k = y.getrowdata(c.rowindex);
                                y._raiseEvent(17, {
                                    rowindex: c.rowindex,
                                    row: k,
                                    datafield: c.datafield,
                                    value: F
                                });
                                if (r == g.length - 1) {
                                    y.setcellvalue(c.rowindex, c.datafield, j, true);
                                    if (f.displayfield != f.datafield) {
                                        y.setcellvalue(c.rowindex, f.displayfield, j, true)
                                    }
                                } else {
                                    y.setcellvalue(c.rowindex, c.datafield, j, false);
                                    if (f.displayfield != f.datafield) {
                                        y.setcellvalue(c.rowindex, f.displayfield, j, true)
                                    }
                                }
                                if (f.cellendedit) {
                                    var D = f.cellendedit(c.rowindex, f.datafield, f.columntype, j)
                                }
                                y._raiseEvent(18, {
                                    rowindex: c.rowindex,
                                    row: k,
                                    datafield: c.datafield,
                                    oldvalue: F,
                                    value: j
                                })
                            }
                        }
                        this.dataview.updateview();
                        this._renderrows(this.virtualsizeinfo);
                        return false
                    }
                }
                if (J == 32) {
                    var c = y.getselectedcell();
                    if (c != null) {
                        var f = y.getcolumn(c.datafield);
                        if (f.columntype == "checkbox" && f.editable) {
                            var o = !y.getcellvalue(c.rowindex, c.datafield);
                            if (f.cellbeginedit) {
                                var b = f.cellbeginedit(c.rowindex, f.datafield, f.columntype, !o);
                                if (b == false) {
                                    return false
                                }
                            }
                            var k = y.getrowdata(c.rowindex);
                            y._raiseEvent(17, {
                                rowindex: c.rowindex,
                                row: k,
                                datafield: c.datafield,
                                value: !o,
                                columntype: "checkbox"
                            });
                            y.setcellvalue(c.rowindex, c.datafield, o, true);
                            y._raiseEvent(18, {
                                rowindex: c.rowindex,
                                row: k,
                                datafield: c.datafield,
                                oldvalue: !o,
                                value: o,
                                columntype: "checkbox"
                            });
                            return false
                        }
                    }
                }
            }
            return true
        },
        begincelledit: function(n, e, l, g, c) {
            var f = this.getcolumn(e);
            this._cellscache = new Array();
            if (e == null) {
                return
            }
            if (f.columntype == "number" || f.columntype == "button") {
                return
            }
            if (this.groupable) {
                if (this.groups.indexOf(e) >= 0) {
                    return
                }
                if (this.groups.indexOf(f.displayfield) >= 0) {
                    return
                }
            }
            if (this.editrow != undefined) {
                return
            }
            if (this.editcell) {
                if (this.editcell.row == n && this.editcell.column == e) {
                    return true
                }
                if (this.editmode === "selectedrow") {
                    if (this.editcell.row == n) {
                        return
                    }
                }
                var d = this.endcelledit(this.editcell.row, this.editcell.column, false, true, false);
                if (false == d) {
                    return
                }
            }
            var i = f.columntype == "checkbox" || f.columntype == "button";
            this.host.removeClass("jqx-disableselect");
            this.content.removeClass("jqx-disableselect");
            if (f.editable) {
                if (f.cellbeginedit) {
                    var k = this.getcell(n, e);
                    var m = f.cellbeginedit(n, e, f.columntype, k != null ? k.value : null);
                    if (m == false) {
                        return
                    }
                }
                var j = this.getrowvisibleindex(n);
                this.editcell = this.getcell(n, e);
                if (this.editcell) {
                    this.editcell.visiblerowindex = j;
                    if (!this.editcell.editing) {
                        if (!i) {
                            this.editcell.editing = true
                        }
                        this.editcell.columntype = f.columntype;
                        this.editcell.defaultvalue = l;
                        if (f.defaultvalue != undefined) {
                            this.editcell.defaultvalue = f.defaultvalue
                        }
                        this.editcell.init = true;
                        if (f.columntype != "checkbox" && this.editmode != "selectedrow") {
                            var h = this.getrowdata(n);
                            this._raiseEvent(17, {
                                rowindex: n,
                                row: h,
                                datafield: f.datafield,
                                value: this.editcell.value,
                                columntype: f.columntype
                            })
                        }
                        a.data(document.body, "jqxgrid.edit", this.element.id);
                        if (!i) {
                            var b = this.getrowvisibleindex(n);
                            if (g !== false) {
                                this.ensurecellvisible(b, f.datafield)
                            }
                            if (c !== false) {
                                this._renderrows(this.virtualsizeinfo)
                            }
                        }
                        if (this.editcell) {
                            this.editcell.init = false;
                            return true
                        }
                    }
                }
            } else {
                if (!this.editcell) {
                    return
                }
                this.editcell.editor = null;
                this.editcell.editing = false;
                if (c !== false) {
                    this._renderrows(this.virtualsizeinfo)
                }
                this.editcell = null
            }
        },
        getScrollTop: function() {
            if (this._py) {
                return pageYOffset
            }
            this._py = typeof pageYOffset != "undefined";
            if (this._py) {
                return pageYOffset
            } else {
                var c = document.body;
                var b = document.documentElement;
                b = (b.clientHeight) ? b : c;
                return b.scrollTop
            }
        },
        getScrollLeft: function() {
            if (typeof pageXOffset != "undefined") {
                return pageXOffset
            } else {
                var c = document.body;
                var b = document.documentElement;
                b = (b.clientHeight) ? b : c;
                return b.scrollLeft
            }
        },
        endcelledit: function(h, n, j, e, o) {
            if (h == undefined || n == undefined) {
                if (this.editcell) {
                    h = this.editcell.row;
                    n = this.editcell.column
                }
                if (j == undefined) {
                    j = true
                }
            }
            if (!this.editcell) {
                return
            }
            var d = this.getcolumn(n);
            var u = this;
            if (u.editmode === "selectedrow") {
                this.endrowedit(h, j);
                return
            }
            var t = function() {
                if (o != false) {
                    if (u.isTouchDevice()) {
                        return
                    }
                    if (!u.isNestedGrid) {
                        var v = u.getScrollTop();
                        var x = u.getScrollLeft();
                        try {
                            u.element.focus();
                            u.content.focus();
                            if (v != u.getScrollTop()) {
                                window.scrollTo(x, v)
                            }
                            setTimeout(function() {
                                u.element.focus();
                                u.content.focus();
                                if (v != u.getScrollTop()) {
                                    window.scrollTo(x, v)
                                }
                            }, 10)
                        } catch (w) {}
                    }
                }
            };
            if (d.columntype == "checkbox" || d.columntype == "button") {
                if (this.editcell) {
                    this.editcell.editor = null;
                    this.editcell.editing = false;
                    this.editcell = null
                }
                return true
            }
            var i = this._geteditorvalue(d);
            var g = function(w) {
                w._hidecelleditor();
                if (d.cellendedit) {
                    d.cellendedit(h, n, d.columntype, w.editcell.value, i)
                }
                w.editchar = null;
                if (d.displayfield != d.datafield) {
                    var v = w.getcellvalue(w.editcell.row, d.displayfield);
                    var x = w.editcell.value;
                    oldvalue = {
                        value: x,
                        label: v
                    }
                } else {
                    oldvalue = w.editcell.value
                }
                var y = w.getrowdata(h);
                w._raiseEvent(18, {
                    rowindex: h,
                    row: y,
                    datafield: n,
                    displayfield: d.displayfield,
                    oldvalue: i,
                    value: i,
                    columntype: d.columntype
                });
                w.editcell.editor = null;
                w.editcell.editing = false;
                w.editcell = null;
                if (e || e == undefined) {
                    w._renderrows(w.virtualsizeinfo)
                }
                t();
                if (!w.enablebrowserselection) {
                    w.host.addClass("jqx-disableselect");
                    w.content.addClass("jqx-disableselect")
                }
            };
            if (j) {
                g(this);
                return false
            }
            if (this.validationpopup) {
                this.validationpopup.hide();
                this.validationpopuparrow.hide()
            }
            if (d.cellvaluechanging) {
                var b = d.cellvaluechanging(h, n, d.columntype, this.editcell.value, i);
                if (b != undefined) {
                    i = b
                }
            }
            if (d.validation) {
                var c = this.getcell(h, n);
                try {
                    var p = d.validation(c, i);
                    var l = this.gridlocalization.validationstring;
                    if (p.message != undefined) {
                        l = p.message
                    }
                    var m = typeof p == "boolean" ? p : p.result;
                    if (!m) {
                        if (p.showmessage == undefined || p.showmessage == true) {
                            this._showvalidationpopup(h, n, l)
                        }
                        this.editcell.validated = false;
                        return false
                    }
                } catch (r) {
                    this._showvalidationpopup(h, n, this.gridlocalization.validationstring);
                    this.editcell.validated = false;
                    return false
                }
            }
            if (d.displayfield != d.datafield) {
                var k = this.getcellvalue(this.editcell.row, d.displayfield);
                var q = this.editcell.value;
                oldvalue = {
                    value: q,
                    label: k
                }
            } else {
                oldvalue = this.editcell.value
            }
            var f = this.getrowdata(h);
            if (d.cellendedit) {
                var s = d.cellendedit(h, n, d.columntype, this.editcell.value, i);
                if (s == false) {
                    this._raiseEvent(18, {
                        rowindex: h,
                        row: f,
                        datafield: n,
                        displayfield: d.displayfield,
                        oldvalue: oldvalue,
                        value: oldvalue,
                        columntype: d.columntype
                    });
                    g(this);
                    return false
                }
            }
            this._raiseEvent(18, {
                rowindex: h,
                row: f,
                datafield: n,
                displayfield: d.displayfield,
                oldvalue: oldvalue,
                value: i,
                columntype: d.columntype
            });
            this._hidecelleditor(false);
            if (this.editcell != undefined) {
                this.editcell.editor = null;
                this.editcell.editing = false
            }
            this.editcell = null;
            this.editchar = null;
            this.setcellvalue(h, n, i, e);
            if (!this.enablebrowserselection) {
                this.host.addClass("jqx-disableselect");
                this.content.addClass("jqx-disableselect")
            }
            if (!a.jqx.browser.msie) {
                t()
            }
            a.data(document.body, "jqxgrid.edit", "");
            return true
        },
        beginrowedit: function(e) {
            var d = this;
            var f = -1;
            d._oldselectedrow = e;
            this._cellscache = new Array();
            var c = false;
            if (this.editmode != "selectedrow") {
                c = true
            }
            if (c) {
                var b = this.editmode;
                this.editmode = "selectedrow"
            }
            a.each(this.columns.records, function(h, j) {
                if (d.editable && this.editable) {
                    var g = d.getcell(e, this.datafield);
                    d.begincelledit(e, this.datafield, null, false, false);
                    var i = d.getrowdata(e);
                    d._raiseEvent(17, {
                        rowindex: e,
                        row: i,
                        datafield: this.datafield,
                        value: g.value,
                        columntype: this.columntype
                    })
                }
            });
            if (d.editcell) {
                d.editcell.init = true
            }
            this._renderrows(this.virtualsizeinfo);
            if (c) {
                this.editmode = b
            }
        },
        endrowedit: function(k, o) {
            var D = this;
            if (!this.editcell) {
                return false
            }
            if (this.editcell.editor == undefined) {
                return false
            }
            var C = function() {
                if (focus != false) {
                    if (D.isTouchDevice()) {
                        return
                    }
                    if (!D.isNestedGrid) {
                        var i = D.getScrollTop();
                        var F = D.getScrollLeft();
                        try {
                            D.element.focus();
                            D.content.focus();
                            if (i != D.getScrollTop()) {
                                window.scrollTo(F, i)
                            }
                            setTimeout(function() {
                                D.element.focus();
                                D.content.focus();
                                if (i != D.getScrollTop()) {
                                    window.scrollTo(F, i)
                                }
                            }, 10)
                        } catch (E) {}
                    }
                }
            };
            var p = false;
            if (this.editmode != "selectedrow") {
                p = true
            }
            if (p) {
                var v = this.editmode;
                this.editmode = "selectedrow"
            }
            var h = false;
            var d = {};
            if (this.validationpopup) {
                this.validationpopup.hide();
                this.validationpopuparrow.hide()
            }
            for (var B = 0; B < this.columns.records.length; B++) {
                var e = this.columns.records[B];
                if (!e.editable) {
                    continue
                }
                if (e.hidden) {
                    continue
                }
                if (e.columntype == "checkbox") {
                    continue
                }
                var l = this._geteditorvalue(e);
                var g = function(F) {
                    F._hidecelleditor();
                    var E = F.getcellvalue(F.editcell.row, e.displayfield);
                    if (e.cellendedit) {
                        e.cellendedit(k, u, e.columntype, E, l)
                    }
                    F.editchar = null;
                    if (e.displayfield != e.datafield) {
                        var i = F.getcellvalue(F.editcell.row, e.displayfield);
                        var H = E;
                        n = {
                            value: H,
                            label: i
                        }
                    } else {
                        n = E
                    }
                    var G = F.getrowdata(k);
                    F._raiseEvent(18, {
                        rowindex: k,
                        row: G,
                        datafield: u,
                        displayfield: e.displayfield,
                        oldvalue: E,
                        value: E,
                        columntype: e.columntype
                    });
                    F.editcell.editing = false
                };
                if (o) {
                    g(this);
                    continue
                }
                if (e.cellvaluechanging) {
                    var n = this.getcellvalue(this.editcell.row, e.displayfield);
                    var b = e.cellvaluechanging(k, u, e.columntype, n, l);
                    if (b != undefined) {
                        l = b
                    }
                }
                var u = e.datafield;
                if (e.validation) {
                    var c = this.getcell(k, e.datafield);
                    try {
                        var w = e.validation(c, l);
                        var r = this.gridlocalization.validationstring;
                        if (w.message != undefined) {
                            r = w.message
                        }
                        var t = typeof w == "boolean" ? w : w.result;
                        if (!t) {
                            if (w.showmessage == undefined || w.showmessage == true) {
                                this._showvalidationpopup(k, u, r)
                            }
                            h = true;
                            this.editcell[e.datafield].validated = false;
                            continue
                        }
                    } catch (z) {
                        this._showvalidationpopup(k, u, this.gridlocalization.validationstring);
                        this.editcell[e.datafield].validated = false;
                        h = true;
                        continue
                    }
                }
                if (e.displayfield != e.datafield) {
                    var q = this.getcellvalue(this.editcell.row, e.displayfield);
                    var x = this.editcell.value;
                    n = {
                        value: x,
                        label: q
                    }
                } else {
                    n = this.getcellvalue(this.editcell.row, e.displayfield)
                }
                d[e.datafield] = {
                    newvalue: l,
                    oldvalue: n
                }
            }
            var y = {};
            var s = {};
            if (!h) {
                this._hidecelleditor(false);
                for (var B = 0; B < this.columns.records.length; B++) {
                    var e = this.columns.records[B];
                    var u = e.datafield;
                    if (e.hidden) {
                        continue
                    }
                    if (!e.editable) {
                        continue
                    }
                    var f = this.getrowdata(k);
                    if (e.columntype == "checkbox") {
                        var l = this.getcellvalue(k, e.displayfield);
                        this._raiseEvent(18, {
                            rowindex: k,
                            row: f,
                            datafield: e.datafield,
                            displayfield: e.displayfield,
                            oldvalue: l,
                            value: l,
                            columntype: e.columntype
                        });
                        continue
                    }
                    if (!d[e.datafield]) {
                        continue
                    }
                    var l = d[e.datafield].newvalue;
                    var n = d[e.datafield].oldvalue;
                    if (e.cellendedit) {
                        var A = e.cellendedit(k, u, e.columntype, n, l);
                        if (A == false) {
                            this._raiseEvent(18, {
                                rowindex: k,
                                row: f,
                                datafield: u,
                                displayfield: e.displayfield,
                                oldvalue: n,
                                value: n,
                                columntype: e.columntype
                            });
                            g(this);
                            continue
                        }
                    }
                    if (!this.source.updaterow) {
                        this._raiseEvent(18, {
                            rowindex: k,
                            row: f,
                            datafield: e.datafield,
                            displayfield: e.displayfield,
                            oldvalue: n,
                            value: l,
                            columntype: e.columntype
                        })
                    }
                    y[e.datafield] = l;
                    s[e.datafield] = n
                }
                var j = this.getrowid(k);
                var f = this.getrowdata(k);
                a.each(y, function(i, F) {
                    if (F && F.label != undefined) {
                        var E = D.getcolumn(i);
                        f[E.displayfield] = F.label;
                        f[E.datafield] = F.value
                    } else {
                        f[i] = F
                    }
                });
                if (!this.enablebrowserselection) {
                    this.host.addClass("jqx-disableselect");
                    this.content.addClass("jqx-disableselect")
                }
                a.data(document.body, "jqxgrid.edit", "");
                this.editcell = null;
                this.editchar = null;
                if (this.source.updaterow) {
                    var m = false;
                    var D = this;
                    var t = function(I) {
                        var G = D.source.updaterow;
                        D.source.updaterow = null;
                        if (false == I) {
                            a.each(s, function(i, K) {
                                if (K && K.label != undefined) {
                                    var J = D.getcolumn(i);
                                    f[J.displayfield] = K.label;
                                    f[J.datafield] = K.value
                                } else {
                                    f[i] = K
                                }
                            });
                            D.updaterow(j, f)
                        } else {
                            D.updaterow(j, f)
                        }
                        for (var F = 0; F < D.columns.records.length; F++) {
                            var H = D.columns.records[F];
                            var E = H.datafield;
                            D._raiseEvent(18, {
                                rowindex: k,
                                datafield: H.datafield,
                                row: f,
                                displayfield: H.displayfield,
                                oldvalue: s[H.datafield],
                                value: f[H.displayfield],
                                columntype: H.columntype
                            })
                        }
                        D.source.updaterow = G
                    };
                    try {
                        m = this.source.updaterow(j, f, t);
                        if (m == undefined) {
                            m = true
                        }
                    } catch (z) {
                        m = false;
                        return
                    }
                } else {
                    this.updaterow(j, f);
                    this._renderrows(this.virtualsizeinfo)
                }
            }
            if (p) {
                this.editmode = v
            }
            return h
        },
        _selection: function(b) {
            if ("selectionStart" in b[0]) {
                var g = b[0];
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
                var c = b[0].createTextRange();
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
        },
        _setSelection: function(e, b, d) {
            if ("selectionStart" in d[0]) {
                d[0].focus();
                d[0].setSelectionRange(e, b)
            } else {
                var c = d[0].createTextRange();
                c.collapse(true);
                c.moveEnd("character", b);
                c.moveStart("character", e);
                c.select()
            }
        },
        findRecordIndex: function(g, c, b) {
            var b = b;
            if (c) {
                var e = b.length;
                for (var h = 0; h < e; h++) {
                    var f = b[h];
                    var d = f.label;
                    if (g == d) {
                        return h
                    }
                }
            }
            return -1
        },
        _destroyeditors: function() {
            var b = this;
            if (!this.columns.records) {
                return
            }
            a.each(this.columns.records, function(f, j) {
                var c = a.trim(this.datafield).split(" ").join("");
                switch (this.columntype) {
                    case "dropdownlist":
                        var g = b.editors["dropdownlist_" + c];
                        if (g) {
                            g.jqxDropDownList("destroy");
                            b.editors["dropdownlist_" + c] = null
                        }
                        break;
                    case "combobox":
                        var k = b.editors["combobox_" + c];
                        if (k) {
                            k.jqxComboBox("destroy");
                            b.editors["combobox_" + c] = null
                        }
                        break;
                    case "datetimeinput":
                        var d = b.editors["datetimeinput_" + this.datafield];
                        if (d) {
                            d.jqxDateTimeInput("destroy");
                            b.editors["datetimeinput_" + c] = null
                        }
                        break;
                    case "numberinput":
                        var e = b.editors["numberinput_" + c];
                        if (e) {
                            e.jqxNumberInput("destroy");
                            b.editors["numberinput_" + c] = null
                        }
                        break;
                    case "custom":
                    case "template":
                        if (b.destroyeditor) {
                            if (b.editors["templateeditor_" + c]) {
                                b.destroyeditor(b.editors["templateeditor_" + c]);
                                b.editors["templateeditor_" + c] = null
                            }
                        }
                        if (b.destroyeditor) {
                            var m = b.getrows.length();
                            for (var l = 0; l < m; l++) {
                                if (b.editors["customeditor_" + c + "_" + l]) {
                                    b.destroyeditor(b.editors["customeditor_" + c + "_" + l], l);
                                    b.editors["customeditor_" + c + "_" + l] = null
                                }
                            }
                        }
                        break;
                    case "textbox":
                    default:
                        var h = b.editors["textboxeditor_" + c];
                        if (h) {
                            b.removeHandler(h, "keydown");
                            b.editors["textbox_" + c] = null
                        }
                        break
                }
            });
            b.editors = new Array()
        },
        _showcelleditor: function(q, G, n, K, w) {
            if (n == undefined) {
                return
            }
            if (this.editcell == null) {
                return
            }
            if (G.columntype == "checkbox" && G.editable) {
                return
            }
            if (w == undefined) {
                w = true
            }
            if (this.editmode == "selectedrow") {
                this.editchar = "";
                w = false
            }
            var E = G.datafield;
            var g = a(n);
            var s = this;
            var d = this.editcell.editor;
            var I = this.getcellvalue(q, E);
            var C = this.getcelltext(q, E);
            var j = this.hScrollInstance;
            var t = j.value;
            var i = parseInt(t);
            var J = this.columns.records.indexOf(G);
            this.editcell.element = n;
            if (this.editcell.validated == false) {
                var H = "";
                if (this.validationpopup) {
                    H = this.validationpopup.text()
                }
                this._showvalidationpopup(q, E, H)
            }
            var l = function(P) {
                if (s.hScrollInstance.isScrolling() || s.vScrollInstance.isScrolling()) {
                    return
                }
                if (!w) {
                    return
                }
                if (s.isTouchDevice()) {
                    return
                }
                if (P) {
                    P.focus()
                }
                if (s.gridcontent[0].scrollTop != 0) {
                    s.scrolltop(Math.abs(s.gridcontent[0].scrollTop));
                    s.gridcontent[0].scrollTop = 0
                }
                if (s.gridcontent[0].scrollLeft != 0) {
                    s.gridcontent[0].scrollLeft = 0
                }
            };
            switch (G.columntype) {
                case "numberinput":
                    if (this.host.jqxNumberInput) {
                        n.innerHTML = "";
                        var D = a.trim(G.datafield).split(" ").join("");
                        if (D.indexOf(".") != -1) {
                            D = D.replace(".", "")
                        }
                        var N = this.editors["numberinput_" + D];
                        d = N == undefined ? a("<div style='border-radius: 0px; -moz-border-radius: 0px; -webkit-border-radius: 0px; z-index: 99999; top: 0px; left: 0px; position: absolute;' id='numbereditor'></div>") : N;
                        d.show();
                        d.css("top", a(n).parent().position().top);
                        if (this.oldhscroll) {
                            d.css("left", -i + parseInt(a(n).position().left))
                        } else {
                            d.css("left", parseInt(a(n).position().left))
                        }
                        if (G.pinned) {
                            d.css("left", i + parseInt(a(n).position().left))
                        }
                        if (N == undefined) {
                            d.prependTo(this.table);
                            d[0].id = "numbereditor" + this.element.id + D;
                            var m = "";
                            var y = "left";
                            var M = 2;
                            if (G.cellsformat) {
                                if (G.cellsformat.indexOf("c") != -1) {
                                    m = this.gridlocalization.currencysymbol;
                                    y = this.gridlocalization.currencysymbolposition;
                                    if (y == "before") {
                                        y = "left"
                                    } else {
                                        y = "right"
                                    }
                                    if (G.cellsformat.length > 1) {
                                        M = parseInt(G.cellsformat.substring(1), 10)
                                    }
                                } else {
                                    if (G.cellsformat.indexOf("p") != -1) {
                                        m = this.gridlocalization.percentsymbol;
                                        y = "right";
                                        if (G.cellsformat.length > 1) {
                                            M = parseInt(G.cellsformat.substring(1), 10)
                                        }
                                    }
                                }
                            } else {
                                M = 0
                            }
                            d.jqxNumberInput({
                                decimalSeparator: this.gridlocalization.decimalseparator,
                                decimalDigits: M,
                                inputMode: "simple",
                                theme: this.theme,
                                rtl: this.rtl,
                                width: g.width() - 1,
                                height: g.height() - 1,
                                spinButtons: false,
                                symbol: m,
                                symbolPosition: y
                            });
                            this.editors["numberinput_" + D] = d;
                            if (G.createeditor) {
                                G.createeditor(q, I, d)
                            }
                        }
                        if (G._requirewidthupdate) {
                            d.jqxNumberInput({
                                width: g.width() - 2
                            })
                        }
                        if (K) {
                            if (I != "" && I != null) {
                                var O = I;
                                d.jqxNumberInput("setDecimal", O)
                            } else {
                                d.jqxNumberInput("setDecimal", 0)
                            }
                            if (this.editcell.defaultvalue != undefined) {
                                d.jqxNumberInput("setDecimal", this.editcell.defaultvalue)
                            }
                            if (this.editchar && this.editchar.length > 0) {
                                var o = parseInt(this.editchar);
                                if (!isNaN(o)) {
                                    d.jqxNumberInput("setDecimal", o)
                                }
                            }
                            if (w) {
                                setTimeout(function() {
                                    l(d.jqxNumberInput("numberInput"));
                                    d.jqxNumberInput("_setSelectionStart", 0);
                                    if (s.editchar) {
                                        if (G.cellsformat.length > 0) {
                                            d.jqxNumberInput("_setSelectionStart", 2)
                                        } else {
                                            d.jqxNumberInput("_setSelectionStart", 1)
                                        }
                                        s.editchar = null
                                    } else {
                                        var P = d.jqxNumberInput("spinButtons");
                                        if (P) {
                                            var Q = d.jqxNumberInput("numberInput").val();
                                            s._setSelection(d.jqxNumberInput("numberInput")[0], Q.length, Q.length)
                                        } else {
                                            var Q = d.jqxNumberInput("numberInput").val();
                                            s._setSelection(d.jqxNumberInput("numberInput")[0], 0, Q.length)
                                        }
                                    }
                                    d.jqxNumberInput("selectAll")
                                }, 10)
                            }
                        }
                    }
                    break;
				case "dropdownlist":
                    if (this.host.jqxDropDownList) {
                        n.innerHTML = "";
                        var D = a.trim(G.datafield).split(" ").join("");
                        var A = a.trim(G.displayfield).split(" ").join("");
                        if (D.indexOf(".") != -1) {
                            D = D.replace(".", "")
                        }
                        if (A.indexOf(".") != -1) {
                            A = A.replace(".", "")
                        }
                        var k = this.editors["dropdownlist_" + D];
                        d = k == undefined ? a("<div style='border-radius: 0px; -moz-border-radius: 0px; -webkit-border-radius: 0px; z-index: 99999; top: 0px; left: 0px; position: absolute;' id='dropdownlisteditor'></div>") : k;
                        d.css("top", a(n).parent().position().top);
                        if (this.oldhscroll) {
                            d.css("left", -i + parseInt(a(n).position().left))
                        } else {
                            d.css("left", parseInt(a(n).position().left))
                        }
                        if (G.pinned) {
                            d.css("left", i + parseInt(a(n).position().left))
                        }
                        if (k == undefined) {
                            d.prependTo(this.table);
                            d[0].id = "dropdownlisteditor" + this.element.id + D;
                            var f = this.source._source ? true : false;
                            var x = null;
                            if (!f) {
                                x = new a.jqx.dataAdapter(this.source, {
                                    autoBind: false,
                                    uniqueDataFields: [A],
                                    async: false,
                                    autoSort: true,
                                    autoSortField: A
                                })
                            } else {
                                var p = {
                                    localdata: this.source.records,
                                    datatype: this.source.datatype,
                                    async: false
                                };
                                x = new a.jqx.dataAdapter(p, {
                                    autoBind: false,
                                    async: false,
                                    uniqueDataFields: [A],
                                    autoSort: true,
                                    autoSortField: A
                                })
                            }
                            var u = !G.createeditor ? true : false;
                            d.jqxDropDownList({
                                enableBrowserBoundsDetection: true,
                                keyboardSelection: false,
                                source: x,
                                rtl: this.rtl,
                                autoDropDownHeight: u,
                                theme: this.theme,
                                width: g.width() - 2,
                                height: g.height() - 2,
                                displayMember: A,
                                valueMember: E
                            });
                            this.editors["dropdownlist_" + D] = d;
                            if (G.createeditor) {
                                G.createeditor(q, I, d)
                            }
                        }
                        if (G._requirewidthupdate) {
                            d.jqxDropDownList({
                                width: g.width() - 2
                            })
                        }
                        var c = d.jqxDropDownList("listBox").visibleItems;
                        if (!G.createeditor) {
                            if (c.length < 8) {
                                d.jqxDropDownList("autoDropDownHeight", true)
                            } else {
                                d.jqxDropDownList("autoDropDownHeight", false)
                            }
                        }
                        var I = this.getcellvalue(q, A);
                        var z = this.findRecordIndex(I, A, c);
                        if (K) {
                            if (I != "") {
                                d.jqxDropDownList("selectIndex", z, true)
                            } else {
                                d.jqxDropDownList("selectIndex", -1)
                            }
                        }
                        if (!this.editcell) {
                            return
                        }
                        if (this.editcell.defaultvalue != undefined) {
                            d.jqxDropDownList("selectIndex", this.editcell.defaultvalue, true)
                        }
                        if (w) {
                            d.jqxDropDownList("focus")
                        }
                    }
                    break;
                case "combobox":
                    if (this.host.jqxComboBox) {
                        n.innerHTML = "";
                        var D = a.trim(G.datafield).split(" ").join("");
                        var A = a.trim(G.displayfield).split(" ").join("");
                        if (D.indexOf(".") != -1) {
                            D = D.replace(".", "")
                        }
                        if (A.indexOf(".") != -1) {
                            A = A.replace(".", "")
                        }
                        var r = this.editors["combobox_" + D];
                        d = r == undefined ? a("<div style='border-radius: 0px; -moz-border-radius: 0px; -webkit-border-radius: 0px; z-index: 99999; top: 0px; left: 0px; position: absolute;' id='comboboxeditor'></div>") : r;
                        d.css("top", a(n).parent().position().top);
                        if (this.oldhscroll) {
                            d.css("left", -i + parseInt(a(n).position().left))
                        } else {
                            d.css("left", parseInt(a(n).position().left))
                        }
                        if (G.pinned) {
                            d.css("left", i + parseInt(a(n).position().left))
                        }
                        if (r == undefined) {
                            d.prependTo(this.table);
                            d[0].id = "comboboxeditor" + this.element.id + D;
                            var f = this.source._source ? true : false;
                            var x = null;
                            if (!f) {
                                x = new a.jqx.dataAdapter(this.source, {
                                    autoBind: false,
                                    uniqueDataFields: [A],
                                    async: false,
                                    autoSort: true,
                                    autoSortField: A
                                })
                            } else {
                                var p = {
                                    localdata: this.source.records,
                                    datatype: this.source.datatype,
                                    async: false
                                };
                                x = new a.jqx.dataAdapter(p, {
                                    autoBind: false,
                                    async: false,
                                    uniqueDataFields: [A],
                                    autoSort: true,
                                    autoSortField: A
                                })
                            }
                            var u = !G.createeditor ? true : false;
                            d.jqxComboBox({
                                enableBrowserBoundsDetection: true,
                                keyboardSelection: false,
                                source: x,
                                rtl: this.rtl,
                                autoDropDownHeight: u,
                                theme: this.theme,
                                width: g.width() - 2,
                                height: g.height() - 2,
                                displayMember: A,
                                valueMember: E
                            });
                            d.removeAttr("tabindex");
                            d.find("div").removeAttr("tabindex");
                            this.editors["combobox_" + D] = d;
                            if (G.createeditor) {
                                G.createeditor(q, I, d)
                            }
                        }
                        if (G._requirewidthupdate) {
                            d.jqxComboBox({
                                width: g.width() - 2
                            })
                        }
                        var c = d.jqxComboBox("listBox").visibleItems;
                        if (!G.createeditor) {
                            if (c.length < 8) {
                                d.jqxComboBox("autoDropDownHeight", true)
                            } else {
                                d.jqxComboBox("autoDropDownHeight", false)
                            }
                        }
                        var I = this.getcellvalue(q, A);
                        var z = this.findRecordIndex(I, A, c);
                        if (K) {
                            if (I != "") {
                                d.jqxComboBox("selectIndex", z, true);
                                d.jqxComboBox("val", I)
                            } else {
                                d.jqxComboBox("selectIndex", -1);
                                d.jqxComboBox("val", I)
                            }
                        }
                        if (!this.editcell) {
                            return
                        }
                        if (this.editcell.defaultvalue != undefined) {
                            d.jqxComboBox("selectIndex", this.editcell.defaultvalue, true)
                        }
                        if (this.editchar && this.editchar.length > 0) {
                            d.jqxComboBox("input").val(this.editchar)
                        }
                        if (w) {
                            setTimeout(function() {
                                l(d.jqxComboBox("input"));
                                if (d) {
                                    d.jqxComboBox("_setSelection", 0, 0);
                                    if (s.editchar) {
                                        d.jqxComboBox("_setSelection", 1, 1);
                                        s.editchar = null
                                    } else {
                                        if (d.jqxComboBox("input")) {
                                            var P = d.jqxComboBox("input").val();
                                            d.jqxComboBox("_setSelection", 0, P.length)
                                        }
                                    }
                                }
                            }, 10)
                        }
                    }
                    break;
                case "datetimeinput":
                    if (this.host.jqxDateTimeInput) {
                        n.innerHTML = "";
                        var D = a.trim(G.datafield).split(" ").join("");
                        if (D.indexOf(".") != -1) {
                            D = D.replace(".", "")
                        }
                        var v = this.editors["datetimeinput_" + D];
                        d = v == undefined ? a("<div style='border-radius: 0px; -moz-border-radius: 0px; -webkit-border-radius: 0px; z-index: 99999; top: 0px; left: 0px; position: absolute;' id='datetimeeditor'></div>") : v;
                        d.show();
                        d.css("top", a(n).parent().position().top);
                        if (this.oldhscroll) {
                            d.css("left", -i + parseInt(a(n).position().left))
                        } else {
                            d.css("left", parseInt(a(n).position().left))
                        }
                        if (G.pinned) {
                            d.css("left", i + parseInt(a(n).position().left))
                        }
                        if (v == undefined) {
                            d.prependTo(this.table);
                            d[0].id = "datetimeeditor" + this.element.id + D;
                            var F = {
                                calendar: this.gridlocalization
                            };
                            d.jqxDateTimeInput({
                                enableBrowserBoundsDetection: true,
                                localization: F,
                                _editor: true,
                                theme: this.theme,
                                rtl: this.rtl,
                                width: g.width(),
                                height: g.height(),
                                formatString: G.cellsformat
                            });
                            this.editors["datetimeinput_" + D] = d;
                            if (G.createeditor) {
                                G.createeditor(q, I, d)
                            }
                        }
                        if (G._requirewidthupdate) {
                            d.jqxDateTimeInput({
                                width: g.width() - 2
                            })
                        }
                        if (K) {
                            if (I != "" && I != null) {
                                var L = new Date(I);
                                if (L == "Invalid Date") {
                                    if (this.source.getvaluebytype) {
                                        L = this.source.getvaluebytype(I, {
                                            name: G.datafield,
                                            type: "date"
                                        })
                                    }
                                }
                                d.jqxDateTimeInput("setDate", L)
                            } else {
                                d.jqxDateTimeInput("setDate", null)
                            }
                            if (this.editcell.defaultvalue != undefined) {
                                d.jqxDateTimeInput("setDate", this.editcell.defaultvalue)
                            }
                        }
                        if (w) {
                            setTimeout(function() {
                                l(d.jqxDateTimeInput("dateTimeInput"))
                            }, 10)
                        }
                    }
                    break;
                case "custom":
                    n.innerHTML = "";
                    var D = a.trim(G.datafield).split(" ").join("");
                    if (D.indexOf(".") != -1) {
                        D = D.replace(".", "")
                    }
                    var B = this.editors["customeditor_" + D + "_" + q];
                    d = B == undefined ? a("<div style='overflow: hidden; border-radius: 0px; -moz-border-radius: 0px; -webkit-border-radius: 0px; z-index: 99999; top: 0px; left: 0px; position: absolute;' id='customeditor'></div>") : B;
                    d.show();
                    d.css("top", a(n).parent().position().top);
                    if (this.oldhscroll) {
                        d.css("left", -i + parseInt(a(n).position().left))
                    } else {
                        d.css("left", parseInt(a(n).position().left))
                    }
                    if (G.pinned) {
                        d.css("left", i + parseInt(a(n).position().left))
                    }
                    if (B == undefined) {
                        d.prependTo(this.table);
                        d[0].id = "customeditor" + this.element.id + D + "_" + q;
                        this.editors["customeditor_" + D + "_" + q] = d;
                        var b = g.width() - 1;
                        var e = g.height() - 1;
                        d.width(b);
                        d.height(e);
                        if (G.createeditor) {
                            G.createeditor(q, I, d, C, b, e, this.editchar)
                        }
                    }
                    if (G._requirewidthupdate) {
                        d.width(g.width() - 2)
                    }
                    break;
                case "template":
                    n.innerHTML = "";
                    var D = a.trim(G.datafield).split(" ").join("");
                    if (D.indexOf(".") != -1) {
                        D = D.replace(".", "")
                    }
                    var h = this.editors["templateeditor_" + D];
                    d = h == undefined ? a("<div style='overflow: hidden; border-radius: 0px; -moz-border-radius: 0px; -webkit-border-radius: 0px; z-index: 99999; top: 0px; left: 0px; position: absolute;' id='templateeditor'></div>") : h;
                    d.show();
                    d.css("top", a(n).parent().position().top);
                    if (this.oldhscroll) {
                        d.css("left", -i + parseInt(a(n).position().left))
                    } else {
                        d.css("left", parseInt(a(n).position().left))
                    }
                    if (G.pinned) {
                        d.css("left", i + parseInt(a(n).position().left))
                    }
                    if (h == undefined) {
                        d.prependTo(this.table);
                        d[0].id = "templateeditor" + this.element.id + D;
                        this.editors["templateeditor_" + D] = d;
                        var b = g.width() - 1;
                        var e = g.height() - 1;
                        d.width(b);
                        d.height(e);
                        if (G.createeditor) {
                            G.createeditor(q, I, d, C, b, e, this.editchar)
                        }
                    }
                    if (G._requirewidthupdate) {
                        d.width(g.width() - 2)
                    }
                    break;
                case "textbox":
                default:
                    n.innerHTML = "";
                    d = this.editors["textboxeditor_" + G.datafield] || a("<input autocomplete='off' autocorrect='off' autocapitalize='off' spellcheck='false' type='textbox' id='textboxeditor'/>");
                    d[0].id = "textboxeditor" + this.element.id + G.datafield;
                    d.appendTo(g);
                    if (this.rtl) {
                        d.css("direction", "rtl")
                    }
                    if (K || d[0].className == "") {
                        d.addClass(this.toThemeProperty("jqx-input"));
                        d.addClass(this.toThemeProperty("jqx-widget-content"));
                        if (this.editchar && this.editchar.length > 0) {
                            d.val(this.editchar)
                        } else {
                            if (G.cellsformat != "") {
                                I = this.getcelltext(q, E)
                            }
                            if (I == undefined) {
                                I = ""
                            }
                            d.val(I)
                        }
                        if (this.editcell.defaultvalue != undefined) {
                            d.val(this.editcell.defaultvalue)
                        }
                        d.width(g.width() + 1);
                        d.height(g.height() + 1);
                        if (G.createeditor) {
                            G.createeditor(q, I, d)
                        }
                        if (G.cellsformat != "") {
                            if (G.cellsformat.indexOf("p") != -1 || G.cellsformat.indexOf("c") != -1 || G.cellsformat.indexOf("n") != -1 || G.cellsformat.indexOf("f") != -1) {
                                if (!this.editors["textboxeditor_" + G.datafield]) {
                                    d.keydown(function(Q) {
                                        var W = Q.charCode ? Q.charCode : Q.keyCode ? Q.keyCode : 0;
                                        var T = String.fromCharCode(W);
                                        var U = parseInt(T);
                                        if (isNaN(U)) {

                                            return true
                                        }
                                        if (s._selection(d).length > 0) {
                                            return true
                                        }
                                        var S = "";
                                        var R = d.val();
                                        if (G.cellsformat.length > 1) {
                                            var V = parseInt(G.cellsformat.substring(1));
                                            if (isNaN(V)) {
                                                V = 0
                                            }
                                        } else {
                                            var V = 0
                                        }
                                        if (V > 0) {
                                            if (R.indexOf(s.gridlocalization.decimalseparator) != -1) {
                                                if (s._selection(d).start > R.indexOf(s.gridlocalization.decimalseparator)) {
                                                    return true
                                                }
                                            }
                                        }
                                        for (var X = 0; X < R.length - V; X++) {
                                            var P = R.substring(X, X + 1);
                                            if (P.match(/^[0-9]+$/) != null) {
                                                S += P
                                            }
                                        }
                                        if (S.length >= 11) {
                                            return false
                                        }
                                    })
                                }
                            }
                        }
                    }
                    this.editors["textboxeditor_" + G.datafield] = d;
                    if (K) {
                        if (w) {
                            setTimeout(function() {
                                l(d);
                                if (s.editchar) {
                                    s._setSelection(d[0], 1, 1);
                                    s.editchar = null
                                } else {
                                    s._setSelection(d[0], 0, d.val().length)
                                }
                            }, 25)
                        }
                    }
                    break
            }
            if (d) {
                d[0].style.zIndex = 1 + n.style.zIndex;
                if (a.jqx.browser.msie && a.jqx.browser.version < 8) {
                    d[0].style.zIndex = 1 + this.columns.records.length + n.style.zIndex
                }
                d.css("display", "block");
                this.editcell.editor = d;
                if (!this.editcell[E]) {
                    this.editcell[E] = {};
                    this.editcell[E].editor = d
                } else {
                    this.editcell[E].editor = d
                }
            }
            if (K) {
                if (G.initeditor) {
                    G.initeditor(q, I, d, C, this.editchar)
                }
            }
            if (s.isTouchDevice()) {
                return
            }
            setTimeout(function() {
                if (s.content) {
                    s.content[0].scrollTop = 0;
                    s.content[0].scrollLeft = 0
                }
                if (s.gridcontent) {
                    s.gridcontent[0].scrollLeft = 0;
                    s.gridcontent[0].scrollTop = 0
                }
            }, 10)
        },
        _setSelection: function(d, g, b) {
            try {
                if ("selectionStart" in d) {
                    d.setSelectionRange(g, b)
                } else {
                    var c = d.createTextRange();
                    c.collapse(true);
                    c.moveEnd("character", b);
                    c.moveStart("character", g);
                    c.select()
                }
            } catch (e) {
                var f = e
            }
        },
        _hideeditors: function() {
            if (this.editcells != null) {
                var b = this;
                for (var c in this.editcells) {
                    b.editcell = b.editcells[c];
                    b._hidecelleditor()
                }
            }
        },
        _hidecelleditor: function(b) {
            if (!this.editcell) {
                return
            }
            if (this.editmode === "selectedrow") {
                for (var c = 0; c < this.columns.records.length; c++) {
                    var e = this.columns.records[c];
                    if (this.editcell[e.datafield] && this.editcell[e.datafield].editor) {
                        this.editcell[e.datafield].editor.hide();
                        var d = this.editcell[e.datafield].editor;
                        switch (e.columntype) {
                            case "dropdownlist":
                                d.jqxDropDownList({
                                    closeDelay: 0
                                });
                                d.jqxDropDownList("hideListBox");
                                d.jqxDropDownList({
                                    closeDelay: 300
                                });
                                break;
                            case "combobox":
                                d.jqxComboBox({
                                    closeDelay: 0
                                });
                                d.jqxComboBox("hideListBox");
                                d.jqxComboBox({
                                    closeDelay: 300
                                });
                                break;
                            case "datetimeinput":
                                if (d.jqxDateTimeInput("isOpened")) {
                                    d.jqxDateTimeInput({
                                        closeDelay: 0
                                    });
                                    d.jqxDateTimeInput("hideCalendar");
                                    d.jqxDateTimeInput({
                                        closeDelay: 300
                                    })
                                }
                                break
                        }
                    }
                }
                if (this.validationpopup) {
                    this.validationpopup.hide();
                    this.validationpopuparrow.hide()
                }
                return
            }
            if (this.editcell.columntype == "checkbox") {
                return
            }
            if (this.editcell.editor) {
                this.editcell.editor.hide();
                switch (this.editcell.columntype) {
                    case "dropdownlist":
                        this.editcell.editor.jqxDropDownList({
                            closeDelay: 0
                        });
                        this.editcell.editor.jqxDropDownList("hideListBox");
                        this.editcell.editor.jqxDropDownList({
                            closeDelay: 300
                        });
                        break;
                    case "combobox":
                        this.editcell.editor.jqxComboBox({
                            closeDelay: 0
                        });
                        this.editcell.editor.jqxComboBox("hideListBox");
                        this.editcell.editor.jqxComboBox({
                            closeDelay: 300
                        });
                        break;
                    case "datetimeinput":
                        var f = this.editcell.editor;
                        if (f.jqxDateTimeInput("isOpened")) {
                            f.jqxDateTimeInput({
                                closeDelay: 0
                            });
                            f.jqxDateTimeInput("hideCalendar");
                            f.jqxDateTimeInput({
                                closeDelay: 300
                            })
                        }
                        break
                }
            }
            if (this.validationpopup) {
                this.validationpopup.hide();
                this.validationpopuparrow.hide()
            }
            if (!this.isNestedGrid) {
                if (b != false) {
                    this.element.focus()
                }
            }
        },
        _geteditorvalue: function(h) {
            var o = new String();
            if (!this.editcell) {
                return null
            }
            var l = this.editcell.editor;
            if (this.editmode == "selectedrow") {
                if (this.editcell[h.datafield]) {
                    var l = this.editcell[h.datafield].editor
                }
            }
            if (l) {
                switch (h.columntype) {
                    case "textbox":
                    default:
                        o = l.val();
                        if (h.cellsformat != "") {
                            var n = "string";
                            var e = this.source.datafields || ((this.source._source) ? this.source._source.datafields : null);
                            if (e) {
                                var p = "";
                                a.each(e, function() {
                                    if (this.name == h.displayfield) {
                                        if (this.type) {
                                            p = this.type
                                        }
                                        return false
                                    }
                                });
                                if (p) {
                                    n = p
                                }
                            }
                            var i = n === "number" || n === "float" || n === "int" || n === "integer";
                            var f = n === "date" || n === "time";
                            if (i || (n === "string" && (h.cellsformat.indexOf("p") != -1 || h.cellsformat.indexOf("c") != -1 || h.cellsformat.indexOf("n") != -1 || h.cellsformat.indexOf("f") != -1))) {
                                if (o === "" && h.nullable) {
                                    return ""
                                }
                                if (o.indexOf(this.gridlocalization.currencysymbol) > -1) {
                                    o = o.replace(this.gridlocalization.currencysymbol, "")
                                }
                                var m = function(w, u, v) {
                                    var s = w;
                                    if (u == v) {
                                        return w
                                    }
                                    var t = s.indexOf(u);
                                    while (t != -1) {
                                        s = s.replace(u, v);
                                        t = s.indexOf(u)
                                    }
                                    return s
                                };
                                var k = o;
                                k = new Number(k);
                                if (!isNaN(k)) {
                                    return k
                                }
                                o = m(o, this.gridlocalization.thousandsseparator, "");
                                o = o.replace(this.gridlocalization.decimalseparator, ".");
                                if (o.indexOf(this.gridlocalization.percentsymbol) > -1) {
                                    o = o.replace(this.gridlocalization.percentsymbol, "")
                                }
                                var d = "";
                                for (var r = 0; r < o.length; r++) {
                                    var b = o.substring(r, r + 1);
                                    if (b === "-") {
                                        d += "-"
                                    }
                                    if (b === ".") {
                                        d += "."
                                    }
                                    if (b.match(/^[0-9]+$/) != null) {
                                        d += b
                                    }
                                }
                                o = d;
                                o = o.replace(/ /g, "");
                                o = new Number(o);
                                if (isNaN(o)) {
                                    o = ""
                                }
                            }
                            if (f || (n === "string" && (h.cellsformat.indexOf("H") != -1 || h.cellsformat.indexOf("m") != -1 || h.cellsformat.indexOf("M") != -1 || h.cellsformat.indexOf("y") != -1 || h.cellsformat.indexOf("h") != -1 || h.cellsformat.indexOf("d") != -1))) {
                                if (o === "" && h.nullable) {
                                    return ""
                                }
                                var c = o;
                                o = new Date(o);
                                if (o == "Invalid Date" || o == null) {
                                    if (a.jqx.dataFormat) {
                                        o = a.jqx.dataFormat.tryparsedate(c, this.gridlocalization)
                                    }
                                    if (o == "Invalid Date" || o == null) {
                                        o = ""
                                    }
                                }
                            }
                        }
                        if (h.displayfield != h.datafield) {
                            o = {
                                label: o,
                                value: o
                            }
                        }
                        break;
                    case "checkbox":
                        if (l.jqxCheckBox) {
                            o = l.jqxCheckBox("checked")
                        }
                        break;
                    case "datetimeinput":
                        if (l.jqxDateTimeInput) {
                            l.jqxDateTimeInput({
                                isEditing: false
                            });
                            l.jqxDateTimeInput("_validateValue");
                            o = l.jqxDateTimeInput("getDate");
                            if (o == null) {
                                return null
                            }
                            o = new Date(o.toString());
                            if (h.displayfield != h.datafield) {
                                o = {
                                    label: o,
                                    value: o
                                }
                            }
                        }
                        break;
                    case "dropdownlist":
                        if (l.jqxDropDownList) {
                            var g = l.jqxDropDownList("selectedIndex");
                            var q = l.jqxDropDownList("listBox").getVisibleItem(g);
                            if (h.displayfield != h.datafield) {
                                if (q) {
                                    o = {
                                        label: q.label,
                                        value: q.value
                                    }
                                } else {
                                    o = ""
                                }
                            } else {
                                if (q) {
                                    o = q.label
                                } else {
                                    o = ""
                                }
                            }
                            if (o == null) {
                                o = ""
                            }
                        }
                        break;
                    case "combobox":
                        if (l.jqxComboBox) {
                            o = l.jqxComboBox("val");
                            if (h.displayfield != h.datafield) {
                                var q = l.jqxComboBox("getSelectedItem");
                                if (q != null) {
                                    o = {
                                        label: q.label,
                                        value: q.value
                                    }
                                }
                            }
                            if (o == null) {
                                o = ""
                            }
                        }
                        break;
                    case "numberinput":
                        if (l.jqxNumberInput) {
                            if (this.touchdevice) {
                                l.jqxNumberInput("_doTouchHandling")
                            }
                            var j = l.jqxNumberInput("getDecimal");
                            o = new Number(j);
                            o = parseFloat(o);
                            if (isNaN(o)) {
                                o = 0
                            }
                            if (h.displayfield != h.datafield) {
                                o = {
                                    label: o,
                                    value: o
                                }
                            }
                        }
                        break
                }
                if (h.geteditorvalue) {
                    if (this.editmode == "selectedrow") {
                        o = h.geteditorvalue(this.editcell.row, this.getcellvalue(this.editcell.row, h.datafield), l)
                    } else {
                        o = h.geteditorvalue(this.editcell.row, this.editcell.value, l)
                    }
                }
            }
            return o
        },
        hidevalidationpopups: function() {
            if (this.popups) {
                a.each(this.popups, function() {
                    this.validation.remove();
                    this.validationrow.remove()
                });
                this.popups = new Array()
            }
            if (this.validationpopup) {
                this.validationpopuparrow.hide();
                this.validationpopup.hide()
            }
        },
        showvalidationpopup: function(f, j, h) {
            if (h == undefined) {
                var h = this.gridlocalization.validationstring
            }
            var g = a("<div style='z-index: 99999; top: 0px; left: 0px; position: absolute;'></div>");
            var r = a("<div style='width: 20px; height: 20px; z-index: 999999; top: 0px; left: 0px; position: absolute;'></div>");
            g.html(h);
            r.addClass(this.toThemeProperty("jqx-grid-validation-arrow-up"));
            g.addClass(this.toThemeProperty("jqx-grid-validation"));
            g.addClass(this.toThemeProperty("jqx-rc-all"));
            g.prependTo(this.table);
            r.prependTo(this.table);
            var l = this.hScrollInstance;
            var n = l.value;
            var d = parseInt(n);
            var b = this.getcolumn(j).uielement;
            var p = null;
            for (var o = 0; o < this.hittestinfo.length; o++) {
                if (f === this.hittestinfo[o].row.visibleindex) {
                    p = this.hittestinfo[o]
                }
            }
            if (!p) {
                this.ensurerowvisible(f);
                var s = this;
                g.remove();
                r.remove();
                setTimeout(function() {
                    var v = null;
                    for (var u = 0; u < s.hittestinfo.length; u++) {
                        if (f === s.hittestinfo[u].row.visibleindex) {
                            v = s.hittestinfo[u]
                        }
                    }
                    if (v) {
                        s.showvalidationpopup(f, j, h)
                    }
                }, 25);
                return
            }
            var c = a(p.visualrow);
            g.css("top", parseInt(c.position().top) + 30 + "px");
            var k = parseInt(g.css("top"));
            r.css("top", k - 12);
            r.removeClass();
            r.addClass(this.toThemeProperty("jqx-grid-validation-arrow-up"));
            var q = false;
            if (k >= this._gettableheight()) {
                r.removeClass(this.toThemeProperty("jqx-grid-validation-arrow-up"));
                r.addClass(this.toThemeProperty("jqx-grid-validation-arrow-down"));
                k = parseInt(c.position().top) - this.rowsheight - 5;
                if (k < 0) {
                    k = 0;
                    this.validationpopuparrow.removeClass(this.toThemeProperty("jqx-grid-validation-arrow-down"));
                    q = true
                }
                g.css("top", k + "px");
                r.css("top", k + g.outerHeight() - 9)
            }
            var t = -d + parseInt(a(b).position().left);
            r.css("left", d + t + 30);
            var m = g.width();
            if (m + t > this.host.width() - 20) {
                var e = m + t - this.host.width() + 40;
                t -= e
            }
            if (!q) {
                g.css("left", d + t)
            } else {
                g.css("left", d + parseInt(a(b).position().left) - g.outerWidth())
            }
            g.show();
            r.show();
            if (!this.popups) {
                this.popups = new Array()
            }
            this.popups[this.popups.length] = {
                validation: g,
                validationrow: r
            }
        },
        _showvalidationpopup: function(p, e, q) {
            var c = this.editcell;
            var k = this.editcell.editor;
            if (this.editmode == "selectedrow") {
                var c = this.editcell[e];
                if (c && c.editor) {
                    k = c.editor;
                    c.element = k
                }
            }
            if (!k) {
                return
            }
            if (this.validationpopup && a.jqx.isHidden(this.validationpopup)) {
                if (this.validationpopup.remove) {
                    this.validationpopup.remove();
                    this.validationpopuparrow.remove()
                }
                this.validationpopup = null;
                this.validationpopuparrow = null;
                if (e === undefined && q === undefined && this.editors && this.editors.length === 0) {
                    return
                }
            }
            if (!this.validationpopup) {
                var n = a("<div style='z-index: 99999; top: 0px; left: 0px; position: absolute;'></div>");
                var m = a("<div style='width: 20px; height: 20px; z-index: 999999; top: 0px; left: 0px; position: absolute;'></div>");
                n.html(q);
                m.addClass(this.toThemeProperty("jqx-grid-validation-arrow-up"));
                n.addClass(this.toThemeProperty("jqx-grid-validation"));
                n.addClass(this.toThemeProperty("jqx-rc-all"));
                n.prependTo(this.table);
                m.prependTo(this.table);
                this.validationpopup = n;
                this.validationpopuparrow = m
            } else {
                this.validationpopup.html(q)
            }
            var h = this.hScrollInstance;
            var j = h.value;
            var g = parseInt(j);
            if (this.editmode == "selectedrow") {
                if (this.visiblerows && this.visiblerows[this.editcell.visiblerowindex]) {
                    this.validationpopup.css("top", this.visiblerows[this.editcell.visiblerowindex].top + (this.rowsheight + 5) + "px")
                } else {
                    this.validationpopup.css("top", parseInt(a(c.editor).position().top) + (this.rowsheight + 5) + "px")
                }
            } else {
                this.validationpopup.css("top", parseInt(a(c.element).parent().position().top) + (this.rowsheight + 5) + "px")
            }
            var b = parseInt(this.validationpopup.css("top"));
            this.validationpopuparrow.css("top", b - 11);
            this.validationpopuparrow.removeClass();
            this.validationpopuparrow.addClass(this.toThemeProperty("jqx-grid-validation-arrow-up"));
            var o = this._gettableheight();
            var f = false;
            if (b >= o) {
                this.validationpopuparrow.removeClass(this.toThemeProperty("jqx-grid-validation-arrow-up"));
                this.validationpopuparrow.addClass(this.toThemeProperty("jqx-grid-validation-arrow-down"));
                b = parseInt(a(c.element).parent().position().top) - this.rowsheight - 5;
                if (this.editmode == "selectedrow") {
                    if (this.visiblerows && this.visiblerows[this.editcell.visiblerowindex]) {
                        b = this.visiblerows[this.editcell.visiblerowindex].top - this.rowsheight - 5
                    } else {
                        b = parseInt(a(c.editor).position().top) - this.rowsheight - 5
                    }
                }
                if (b < 0) {
                    b = 0;
                    this.validationpopuparrow.removeClass(this.toThemeProperty("jqx-grid-validation-arrow-down"));
                    f = true
                }
                this.validationpopup.css("top", b + "px");
                this.validationpopuparrow.css("top", b + this.validationpopup.outerHeight() - 9)
            }
            var l = -g + parseInt(a(c.element).position().left);
            this.validationpopuparrow.css("left", g + l + 30);
            var d = this.validationpopup.width();
            if (d + l > this.host.width() - 20) {
                var i = d + l - this.host.width() + 40;
                l -= i
            }
            if (!f) {
                this.validationpopup.css("left", g + l)
            } else {
                this.validationpopup.css("left", g + parseInt(a(c.element).position().left) - this.validationpopup.outerWidth())
            }
            if (this.editcell.editor.css("display") == "none") {
                this.validationpopup.hide();
                this.validationpopuparrow.hide()
            } else {
                this.validationpopup.show();
                this.validationpopuparrow.show()
            }
        }
    })
})(jqxBaseFramework);