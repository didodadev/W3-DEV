<cfparam name="attributes.op" default="list">
<cfparam name="attributes.columnChoice" default="1">
<!---
<cfobject name="databaseinfo" component="Utility.DatabaseInfo">
---->

<cfset datasourceInfo = replace(serializeJSON({
    '#DSN#': 'main',
    '#DSN3#': 'company',
    '#DSN2#': 'period',
    '#DSN1#': 'product'
}),'//','') />

<cfswitch expression="#attributes.op#">

    <!--- Table list --->
    <cfdefaultcase>
        <div id="divDB">
            <div id="divPageLoad"><?xml version="1.0" encoding="utf-8"?><svg width="32px" height="32px" xmlns="http://www.w3.org/2000/svg" viewBox="0 0 100 100" preserveAspectRatio="xMidYMid" class="uil-ring-alt"><rect x="0" y="0" width="100" height="100" fill="none" class="bk"></rect><circle cx="50" cy="50" r="40" stroke="rgba(255,255,255,0)" fill="none" stroke-width="10" stroke-linecap="round"></circle><circle cx="50" cy="50" r="40" stroke="#ff8a00" fill="none" stroke-width="6" stroke-linecap="round"><animate attributeName="stroke-dashoffset" dur="2s" repeatCount="indefinite" from="0" to="502"></animate><animate attributeName="stroke-dasharray" dur="2s" repeatCount="indefinite" values="150.6 100.4;1 250;150.6 100.4"></animate></circle></svg></div>
            <div>
            <cf_box_search>
                <div class="form-group large">
                    <input type="text" data-bind="value: searchkey, valueUpdate: 'input', executeOnEnter: search;" placeholder="<cfoutput>#getLang('','Table Name','59063')#</cfoutput>">
                </div>
                <div class="form-group medium">
                    <select data-bind="value: $root.searchScheme">
                        <option value="<cfoutput>#DSN#</cfoutput>"><cf_get_lang dictionary_id='60180.Ana Sema'></option>
                        <option value="<cfoutput>#DSN3#</cfoutput>"><cf_get_lang dictionary_id='57574.Sirket'></option>
                        <option value="<cfoutput>#DSN2#</cfoutput>"><cf_get_lang dictionary_id='58472.Donem'></option>
                        <option value="<cfoutput>#DSN1#</cfoutput>"><cf_get_lang dictionary_id='57657.Ürün'></option>
                        <option value="%"><cf_get_lang dictionary_id='57708.Tumu'></option>
                    </select>
                </div>
                    <div class="form-group">
                        <a href="#" data-bind="click: function() { search(true); }" class="ui-btn ui-btn-green"><i class="fa fa-search"></i></a>
                    </div>
                </div>
            </cf_box_search>
            <div class="col" data-bind="css: { 'col-6' : !listMode(), 'col-12' : listMode(), rightSeperator: !listMode() }">
                <cf_grid_list>
                    <thead>
                        <tr>
                            <th><cf_get_lang dictionary_id='59063.Table Name'></th>
                            <th><cf_get_lang dictionary_id='56727.Schema Name'></th>
                        </tr>
                    </thead>
                    <tbody data-bind="foreach: dataSeries">
                        <tr>
                            <td><a href="#" data-bind="text: name ,click: function() { setDetail(name, schema); }"></a></td>
                            <td><span data-bind="text: schema"></span></td>
                        </tr>
                    </tbody>
                </cf_grid_list>
                <ul class="pager" data-bind="foreach: pages">
                    <li><a href="#" data-bind="html: $data, click: function() { setpage($data); }"></a></li>
                </ul>
            </div>
            <div class="col col-6" data-bind="visible: !listMode()">
                <cf_grid_list>
                    <thead>
                        <tr>
                            <th><cf_get_lang dictionary_id='59061.Column Name'></th>
                            <th><cf_get_lang dictionary_id='59065.Data Type'></th>
                            <th><cf_get_lang dictionary_id='58909.Max'>. <cf_get_lang dictionary_id='36233.Length'></th>
                        </tr>
                    </thead>
                    <tbody data-bind="foreach: columnSeries">
                        <tr>
                            <cfif attributes.columnChoice eq 0> <!--- imp steps adımları için kolon adını taşınıyor. --->
                                <td><a href="##" data-bind="text: name, click: function() { getColumnName(name); }"></a> <i class="fa fa-question-circle" data-bind="attr : { title: desc }, visible: desc != null"></i></td>
                            <cfelse>
                                <td><a href="##" data-bind="text: name, click: function() { setValue($data); }"></a> <i class="fa fa-question-circle" data-bind="attr : { title: desc }, visible: desc != null"></i></td>
                            </cfif>
                            <td data-bind="text: type"></td>
                            <td data-bind="text: maxlen"></td>
                        </tr>
                    </tbody>
                </cf_grid_list>
            </div>
            <div class="col col-12">
                
            </div>
        </div>
        
        <style rel="stylesheet">
            ul.pager li {
                list-style-type: none;
                margin: 0;
                padding: 0px;
                display: block;
                float: left;
                border: 1px solid #dedede;
            }
            ul.pager li a {
                display: block;
                padding: 10px;
            }
            #divPageLoad {
                display: none;
                position: fixed;
                z-index: 144;
                top: calc(50% - 16px);
                left: calc(50% - 16px);
            }
            .rightSeperator {
                border-right: 1px solid #e7ecf1;
            }
        </style>
        <script type="text/javascript" src="/JS/assets/lib/knockout-3.4.2/knockout.js"></script>
        <script type="text/javascript">

        ko.bindingHandlers.executeOnEnter = {
            init: function (element, valueAccessor, allBindings, viewModel) {
                var callback = valueAccessor();
                $(element).keypress(function (event) {
                    var keyCode = (event.which ? event.which : event.keyCode);
                    if (keyCode === 13) {
                       callback.call(viewModel);
                       return false;
                    }
                    return true;
                });
            }
        };

        var datasourceInfo = JSON.parse('<cfoutput>#datasourceInfo#</cfoutput>');
        
        var appDB = function (ko, jq) {
            var self = this;

            self.listMode = ko.observable(true);
            
            self.createRow = function(data) {
                return {
                    name : data[2],
                    schema : data[1],
                    catalog : data[0],
                    type : data[3]
                }
            }

            self.dataSeries = ko.observableArray([]);
            self.searchkey = ko.observable("");
            self.searchScheme = ko.observable("<cfoutput>#DSN#</cfoutput>");

            self.search = function(reset = true) {
                if (reset) self.page(1);
                jq.ajax({
                    url :'Utility/DatabaseInfo.cfc?method=TableInfoAjaxWithPaging', data : {table_name : self.searchkey(), scheme_name: self.searchScheme(), page : self.page() - 1 }, 
		            async:true,
                    beforeSend : function() {
                        jq("#divPageLoad").css("display", "block");
                    },
		            success : function(res){
                        data = jq.parseJSON(res);
                        if (self.pageCount() != data.PAGECOUNT) {
                            self.pageCount(data.PAGECOUNT);
                            self.pagerBuilder();
                        }
                        self.dataSeries(data.TABLEINFO.DATA.map(function(row) {
                            return self.createRow(row);
                        }));
                    },
                    complete : function() {
                        jq("#divPageLoad").css("display", "none");
                    }
                });
            };

            self.pageCount = ko.observable(0);
            self.page = ko.observable(1);
            self.pages = ko.observableArray([]);
            self.pagerBuilder = function() {
                var pageTemplate = ["<"];
                if (self.page() > 2) {
                    pageTemplate.push(self.page() - 2);
                }
                if (self.page() > 1) {
                    pageTemplate.push(self.page() - 1);
                }
                pageTemplate.push("<b>" + self.page() + "</b>");
                if (self.page() < self.pageCount()) {
                    pageTemplate.push(self.page() + 1);                    
                }
                if (self.page() < self.pageCount() - 1) {
                    pageTemplate.push(self.page() + 2);
                }
                pageTemplate.push(">");
                self.pages(pageTemplate);
            }

            self.setpage = function(pageno) {
                var update = true;
                if (pageno === ">" && self.page() < self.pageCount()) {
                    self.page(self.page() + 1);
                } else if (pageno === "<" && self.page() > 1) {
                    self.page(self.page() - 1);
                } else if (!isNaN(pageno)) {
                    self.page(parseInt(pageno));
                } else {
                    update = false;
                }
                if (update) { 
                    self.search(false);
                    self.pagerBuilder();
                }
            }

            self.columnSeries = ko.observableArray([]);

            self.createColumn = function(row) {
                return {
                    name : row[0],
                    type : row[1],
                    maxlen : row[2],
                    desc : row[3],
                    schema : row[4]
                }
            }

            self.selectedTable = "";
            self.selectedScheme = "";

            self.setDetail = function(table, schema) {
                self.selectedTable = table;
                self.selectedScheme = schema;
                jq.ajax({
                    url :'Utility/DatabaseInfo.cfc?method=ColumnInfoAjax', data : {table_name : table, schema_name : schema }, 
		            async:true,
                    beforeSend : function() {
                        jq("#divPageLoad").css("display", "block");
                    },
		            success : function(res){
                        data = jq.parseJSON(res);
                        self.columnSeries(data.DATA.map(function(row) {
                            return self.createColumn(row);
                        }));
                        self.listMode(false);
                    },
                    complete : function() {
                        jq("#divPageLoad").css("display", "none");
                    }
                });
            }

            self.setValue = function(column) {
                window.opener.setFieldValue({ type: "db", scheme: self.selectedScheme, schemaType: datasourceInfo[selectedScheme], table: self.selectedTable, field: column.name, fieldType: column.type, value: "DB=>" + self.selectedTable + "." + column.name });
                window.close();
            }

            return {
                init: function() {
                    self.search();
                    ko.applyBindings(self, document.getElementById("divDB"));
                },
                setDetail: function(table) {
                    self.setDetail(table);
                }
            }
        }(ko, jQuery);
        appDB.init();
        </script>
    </cfdefaultcase>
</cfswitch>