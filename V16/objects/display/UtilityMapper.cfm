<cfparam name="attributes.fromwidget" default="">
<cfparam name="attributes.tofuse" default="">
<cfparam name="attributes.towidget" default="">

<cfif len(attributes.fromwidget)>
    <cfquery name="query_from_widget" datasource="#dsn#">
        SELECT WIDGET_FUSEACTION FROM WRK_WIDGET WHERE WIDGETID = <cfqueryparam cfsqltype='CF_SQL_INTEGER' value='#attributes.fromwidget#'>
    </cfquery>
    <cfif structKeyExists( application.objects, query_from_widget.WIDGET_FUSEACTION ) and len( application.objects[query_from_widget.WIDGET_FUSEACTION].LEGACY eq 2 )>
        <cfquery name="query_from_model" datasource="#dsn#">
            SELECT MODELJSON FROM WRK_MODEL WHERE MODEL_FUSEACTION = <cfqueryparam cfsqltype='CF_SQL_NVARCHAR' value='#query_from_widget.WIDGET_FUSEACTION#'>
        </cfquery>
        <cfscript>
            if ( query_from_model.recordCount ) {

                fromDomainModel = deserializeJSON(query_from_model.MODELJSON);
                fromMainStruct = fromDomainModel[ arrayFind( fromDomainModel, function( st ) {
                    return st.structType eq "Main";
                }) ];
                fromMainElements = arrayMap( fromMainStruct.listOfElements, function (elm) {
                    return elm.label;
                });
            }
        </cfscript>
    </cfif>
</cfif>
<cfif len(attributes.tofuse)>
    <cfif structKeyExists( application.objects, attributes.tofuse ) and len( application.objects[attributes.tofuse].LEGACY eq 2 )>
        <cfquery name="query_to_model" datasource="#dsn#">
            SELECT MODELJSON FROM WRK_MODEL WHERE MODEL_FUSEACTION = <cfqueryparam cfsqltype='CF_SQL_NVARCHAR' value='#attributes.tofuse#'>
        </cfquery>
        <cfscript>
            
            toDomainModel = deserializeJSON(query_to_model.MODELJSON);
            toMainStruct = toDomainModel[ arrayFind( toDomainModel, function( st ) {
                return st.structType eq "Main";
            }) ];
            toMainElements = arrayMap( toMainStruct.listOfElements, function (elm) {
                return elm.label;
            });
        </cfscript>
    </cfif>
</cfif>
<cfif len(attributes.towidget)>
    <cfquery name="query_to_widget" datasource="#dsn#">
        SELECT WIDGET_FUSEACTION FROM WRK_WIDGET WHERE WIDGETID = <cfqueryparam cfsqltype='CF_SQL_INTEGER' value='#attributes.towidget#'>
    </cfquery>
    <cfif structKeyExists( application.objects, query_to_widget.WIDGET_FUSEACTION ) and len( application.objects[query_to_widget.WIDGET_FUSEACTION].LEGACY eq 2 )>
        <cfquery name="query_to_model" datasource="#dsn#">
            SELECT MODELJSON FROM WRK_MODEL WHERE MODEL_FUSEACTION = <cfqueryparam cfsqltype='CF_SQL_NVARCHAR' value='#query_to_widget.WIDGET_FUSEACTION#'>
        </cfquery>
        <cfscript>
            if ( query_to_model.recordCount ) {

                toDomainModel = deserializeJSON(query_to_model.MODELJSON);
                toMainStruct = toDomainModel[ arrayFind( toDomainModel, function( st ) {
                    return st.structType eq "Main";
                }) ];
                toMainElements = arrayMap( toMainStruct.listOfElements, function (elm) {
                    return elm.label;
                });
            }
        </cfscript>
    </cfif>
</cfif>

<div class="dev-block m-x-2" id="app-mapping">
    <div class="dev-table">
        <div class="thead row">
            <div class="cell col col-4">
                Map To
            </div>
            <div class="cell col col-7">
                Map From
            </div>
            <div class="cell col col-1 text-right">
                <i class="fa fa-plus" data-bind="click: function() { self.addRow(); }"></i>
            </div>
        </div>
        <div class="tbody" data-bind="foreach: self.mapElements"> 
            <div class="row">
                
                <div class="cell col col-4">
                    <!-- ko if: self.hasToSelect() -->
                    <select data-bind="value: toitem, options: self.toElements"></select>
                    <!-- /ko -->
                    <!-- ko if: !self.hasFromSelect() -->
                    <input type="text" data-bind="value: toitem">
                    <!-- /ko -->
                </div>
                <div class="cell col col-3">
                    <select data-bind="value: fromtype">
                        <option value="model"><cf_get_lang dictionary_id='58225.Model'></option>
                        <option value="attributes"><cf_get_lang dictionary_id='60182.Attributes'></option>
                    </select>
                </div>
                <div class="cell col col-4">
                    <!-- ko if: $data.fromtype() == 'model' && self.hasFromSelect() -->
                    <select data-bind="value: fromitem, options: self.fromElements"></select>
                    <!-- /ko -->
                    <!-- ko if: $data.fromtype() == 'attributes' || ( $data.fromtype() == 'model' && !self.hasFromSelect() ) -->
                    <input type="text" data-bind="value: fromitem">
                    <!-- /ko -->
                </div>
                
                <div class="cell col col-1">
                    <i class="fa fa-minus" data-bind="click: function() { self.removeRow($data); }"></i>
                </div>
            </div>
        </div>
        <div class="tbody">
            <div class="cell col col-12 text-right">
                <button type="button" data-bind="click: setValue"><cf_get_lang dictionary_id='59031.Kaydet'></button>
            </div>
        </div>
    </div>
</div>

<script type="text/javascript">
    var appMapping = function (jq, ko) {
        var self = this;

        self.mapElements = ko.observableArray([]);

        self.hasToSelect = ko.computed(function() {
            return <cfoutput>#isDefined("toMainElements")?"true":"false"#</cfoutput>;
        });
        self.hasFromSelect = ko.computed(function() {
            return <cfoutput>#isDefined("fromMainElements")?"true":"false"#</cfoutput>;
        });

        self.fromElements = ko.observableArray( <cfoutput>#isDefined("fromMainElements") ? replace(serializeJSON( fromMainElements ), "//", "") : "[]"#</cfoutput> );
        self.toElements = ko.observableArray( <cfoutput>#isDefined("toMainElements") ? replace(serializeJSON( toMainElements ), "//", "") 
        : "[]"#</cfoutput> );


        self.addRow = function() {
            self.mapElements.push({ fromitem: ko.observable(""), toitem: ko.observable(""), fromtype: ko.observable("model") });
        };

        self.removeRow = function(row) {
            self.mapElements.remove(row);
        }

        self.setValue = function() {
            jsElements = ko.toJS(self.mapElements);
            jsMapElements = {};
            jsElements.forEach(element => {
                jsMapElements[element.toitem] = element.fromtype + '.' + element.fromitem;
            });
            window.opener.setFieldValue( jq.param( jsMapElements ) );
        }

        return {
            init: function() {
                ko.applyBindings(self, document.getElementById("app-mapping"));
            }
        };
    }(jQuery, ko);

    appMapping.init();
</script>