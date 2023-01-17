<!---
    File :          holistic_compositor.cfm
    Author :        Halit Yurttaş <halityurttas@gmail.com>
    Date :          25.02.2019
    Description :   Holistik nocode için kompozitor katmanı
    Notes :         
--->
<cfparam name="attributes.event" default="list">
<cfparam name="attributes.fuseaction" default="">
<cfparam name="attributes.submited" default="">
<cfparam name="attributes.version" default="default">
<cfif attributes.event eq "dashboard">
<script type="text/javascript" src="/JS/Chart.min.js"></script>
</cfif>
<link rel="stylesheet" href="/css/assets/template/nocode/main.min.css">
<script>$( "section[class*='pageBody']" ).removeClass('hide').show( "slow" );</script>

<cfif len( attributes.fuseaction ) eq 0>
    Sistematik bir hata oluştu! Lütfen action belirtiniz.
    <cfabort>
</cfif>

<cfif len( attributes.submited )>
    <cfif attributes.event eq "add" or attributes.event eq "upd">
        <cfquery name="query_widgets" datasource="#dsn#">
            SELECT * FROM WRK_WIDGET WHERE WIDGET_FUSEACTION = <cfqueryparam cfsqltype='CF_SQL_NVARCHAR' value='#attributes.fuseaction#'> AND WIDGET_EVENT_TYPE = <cfqueryparam cfsqltype='CF_SQL_NVARCHAR' value='#attributes.event#'>
        </cfquery>
        <cfinclude template="../NoCode/#underscored_fuseaction(attributes.fuseaction)#/#query_widgets.WIDGET_STATUS#/#attributes.event#/widgetdata.cfm">
    </cfif>
</cfif>

<cfquery name="query_events" datasource="#dsn#">
    SELECT E1.* FROM WRK_EVENTS E1 WHERE E1.EVENT_FUSEACTION = <cfqueryparam cfsqltype='CF_SQL_NVARCHAR' value='#attributes.fuseaction#'> AND E1.EVENT_TYPE = <cfqueryparam cfsqltype='CF_SQL_NVARCHAR' value='#attributes.event#'>
</cfquery>

<cfset event_data = deserializeJSON( query_events.EVENT_STRUCTURE )>
<cfif isDefined( "event_data.lofRows" )>
    <div id="holisticLeftMenu" class="holistic-left-menu col col-2">
        <cf_box><ul class="ui-list"></ul></cf_box>
    </div>
    <cfset master_widget_codes = find_and_build_master_widget(event_data: event_data)>
    <div id="holisticBody" class="holistic-body col col-10">
        <cfloop array="#event_data.lofRows#" index="event_row">
            <div class="row">
                <cfif isDefined( "event_row.listOfCols" )>
                    <cfloop array="#event_row.listOfCols#" index="event_col">
                        <div class="col col-<cfoutput>#event_col.colsize#</cfoutput>">
                            <cfif isDefined( "event_col.listOfWidgets" )>
                            <cfloop array="#event_col.listOfWidgets#" index="event_widget">
                            <cfif isDefined( "event_data.masterWidget" ) and event_data.masterWidget eq event_widget.uniqid>
                                <cfoutput>#master_widget_codes#</cfoutput>
                            <cfelse>
                                <cfset build_nomaster_widget(event_widget)>
                            </cfif>
                            </cfloop>
                            </cfif>
                        </div>
                    </cfloop>
                </cfif>
            </div>
        </cfloop>
    </div>
</cfif>
<script type="text/javascript" src="/JS/assets/lib/ajaxform.min.js"></script>
<script type="text/javascript">
    function widgetpost( elm ) {
        if ( $( elm ).closest( "div[data-post]" ).data( "post" ) == "ajax" ) {
            if ( $( elm ).closest( "form" )[0].checkValidity() ) {
                $( elm ).closest( "form" ).ajaxSubmit({
                    success: function ( responseText, statusText, xhr, $form ) {
                        alert( responseText );
                    }
                });
            } else {
                setTimeout(() => {
                    $( elm ).closest( "form" )[0].reportValidity();
                }, 300);
            }
            return false;
        } else {
            return true;
        }
    }
</script>


<!--- functions --->
<cffunction name="find_and_build_master_widget">
    <cfargument name="event_data">

    <cfscript>
        widgets = arrayReduce( arguments.event_data.lofRows, function( racc, row ) {
            racc = structKeyExists(arguments, "racc")?arguments.racc:[];
            widgets = arrayReduce( row.listOfCols, function( cacc, col ) {
                cacc = structKeyExists(arguments, "cacc")?arguments.cacc:[];
                widgets = arrayReduce( col.listOfWidgets, function( wacc, widget ) {
                    wacc = structKeyExists(arguments, "wacc")?arguments.wacc:[];
                    arrayAppend( wacc, widget );
                    return wacc;
                }, []);
                arrayAppend( cacc, widgets, 1 );
                return cacc;
            }, []);
            arrayAppend( racc, widgets, 1 );
            return racc;
        }, []);

        master_widget = widgets[ arrayFind( widgets, function( elm ) {
            return elm.uniqid eq event_data.masterWidget;
        }) ];
    </cfscript>
    <cfsavecontent variable="retval">
        <cfset build_master_widget(event_widget: master_widget)>
    </cfsavecontent>
    <cfreturn retval>
</cffunction>

<cffunction name="build_master_widget">
    <cfargument name="event_widget">

    <div data-post="post">
        <cfset query_widget = get_widget_data( arguments.event_widget.id )>
        <cfif query_widget.WIDGET_TOOL eq "nocode">
            <cfset master_of_depends = deserializeJSON( query_widget.WIDGET_DEPENDS )>
            <cfif arrayLen(master_of_depends)>
                <cfset variables.master_of_struct = master_of_depends[1].DEPENDSTRUCT>
            </cfif>
            <cfif arrayLen(event_widget.props)>
                <cfloop array="#event_widget.props#" index="p">
                    <cfset attributes[p.label] = evaluate(p.valuedata)>
                </cfloop>
            </cfif>
            <cfif event_widget.event eq "list">
                <cfinclude template="../NoCode/#underscored_fuseaction(query_widget.WIDGET_FUSEACTION)#/#query_widget.WIDGET_STATUS#/#query_widget.WIDGET_EVENT_TYPE#/widget.cfm">
            <cfelse>
            <cf_box boxparams="#event_widget.data.box#">
                <cfinclude template="../NoCode/#underscored_fuseaction(query_widget.WIDGET_FUSEACTION)#/#query_widget.WIDGET_STATUS#/#query_widget.WIDGET_EVENT_TYPE#/widget.cfm">
            </cf_box>
            </cfif>
        <cfelse>
            <cf_box>
                <cfinclude template="../#query_widget.WIDGET_FILE_PATH#">
            </cf_box>
        </cfif>
    </div>
</cffunction>

<cffunction name="build_nomaster_widget">
    <cfargument name="event_widget">

    <cfif IsDefined("event_widget.customtag") and structCount(event_widget.customtag)>
        <cfset customTag = event_widget.customtag />
        <cfset customTagAttributes = structNew() />
        <cfif structCount(customTag.params)>
            <cfloop collection="#customTag.params#" item="item">
                <cfset structInsert(customTagAttributes, item, ( customTag.params[item] contains '##' ) ? evaluate(customTag.params[item]) : customTag.params[item]) />
            </cfloop>
        </cfif>
        <cfmodule template="../CustomTags/#customTag.path#" attributeCollection="#customTagAttributes#">
    <cfelse>
        <cfset query_widget = get_widget_data( arguments.event_widget.id )>
        <cfif query_widget.WIDGET_TOOL eq "nocode">
            <cfset param_values = "">
            <cfif isDefined( "event_widget.params" ) and len( event_widget.params )>
                <cfset params_array = arrayNew(1)>
                <cfloop list="#event_widget.params#" index="pidx">
                    <cfset current_param = pidx>
                    <cfif listFirst( listLast( current_param, "=" ), "." ) eq "model">
                        <cfset paramprefix = variables.master_of_struct & "_query">
                    <cfelseif listFirst( listLast( current_param, "=" ), "." ) eq "attributes">
                        <cfset paramprefix = "attributes">
                    </cfif>
                    <cfset result_param = listFirst(current_param, "=") & "=" & evaluate(paramprefix & "." & listLast( listLast(current_param, "="), "." ))>
                    <cfset arrayAppend( params_array, result_param )>
                </cfloop>
                <cfset param_values = arrayToList( params_array, "&" )>
            </cfif>
            <cf_box box_page="#request.self#?fuseaction=#query_widget.WIDGET_FUSEACTION#&event=#attributes.event#&widget=#query_widget.WIDGETID#&uniqid=#arguments.event_widget.uniqid#&md=holistic&#param_values#">
            </cf_box>
        <cfelse>
            <cf_box>
                <cfinclude template="../#query_widget.WIDGET_FILE_PATH#">
            </cf_box>
        </cfif>
    </cfif>
</cffunction>

<cffunction name="get_widget_data">
    <cfargument name="widget_id">
    <cfquery name="query_result" datasource="#dsn#">
    SELECT * FROM WRK_WIDGET WHERE WIDGETID = <cfqueryparam cfsqltype='CF_SQL_INTEGER' value='#arguments.widget_id#'>
    </cfquery>
    <cfreturn query_result>
</cffunction>

<cffunction name="underscored_fuseaction">
    <cfargument name="fuseaction" type="string">

    <cfset result = replace( arguments.fuseaction, ".", "_" )>
    <cfreturn result>
</cffunction>