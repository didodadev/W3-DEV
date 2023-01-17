<!---
    File :          holistic_compositor_ajax.cfm
    Author :        Halit Yurttaş <halityurttas@gmail.com>
    Date :          25.02.2019
    Description :   Holistik nocode ajax çağrıları için kompozitor katmanı oluşturur
    Notes :         
--->
<cfparam name="attributes.widget" default="">
<cfparam name="attributes.submited" default="">

<cfif len( attributes.widget ) eq 0>
    Sistematik bir hata oluştu! Lütfen widget belirtiniz.
    <cfabort>
</cfif>

<cfquery name="query_widgets" datasource="#dsn#">
    SELECT * FROM WRK_WIDGET WHERE WIDGETID = <cfqueryparam cfsqltype='CF_SQL_INTEGER' value='#attributes.widget#'>
</cfquery>
<cfquery name="query_events" datasource="#dsn#">
    SELECT * FROM WRK_EVENTS WHERE EVENT_FUSEACTION = '#query_widgets.WIDGET_FUSEACTION#' AND EVENT_TYPE = '#query_widgets.WIDGET_EVENT_TYPE#' 
</cfquery>
<cfset event_data = deserializeJSON( query_events.EVENT_STRUCTURE )>
<cfset event_widget = find_event_widget( event_data, attributes.uniqid )>
<cfset set_widget_props( event_widget )>
<cfif len( attributes.submited ) and (query_widgets.WIDGET_EVENT_TYPE eq "add" or query_widgets.WIDGET_EVENT_TYPE eq "upd")>
    <cfinclude template="../NoCode/#underscored_fuseaction(query_widgets.WIDGET_FUSEACTION)#/#query_widgets.WIDGET_STATUS#/#query_widgets.WIDGET_EVENT_TYPE#/widgetdata.cfm">
<cfelse>
    <div data-post="ajax">
        <cfinclude template="../NoCode/#underscored_fuseaction(query_widgets.WIDGET_FUSEACTION)#/#query_widgets.WIDGET_STATUS#/#query_widgets.WIDGET_EVENT_TYPE#/widget.cfm">
    </div>
</cfif>

<!--- functions --->

<cffunction name="find_event_widget">
    <cfargument name="event_data">
    <cfargument name="uniqid">

    <cfscript>
        widgets = arrayReduce( arguments.event_data.lofRows, function( racc, row ) {
            racc = racc?:[];
            widgets = arrayReduce( row.listOfCols, function( cacc, col ) {
                cacc = cacc?:[];
                widgets = arrayReduce( col.listOfWidgets, function( wacc, widget ) {
                    wacc = wacc?:[];
                    arrayAppend( wacc, widget );
                    return wacc;
                }, []);
                arrayAppend( cacc, widgets, 1 );
                return cacc;
            }, []);
            arrayAppend( racc, widgets, 1 );
            return racc;
        }, []);

        event_widget = widgets[ arrayFind( widgets, function( elm ) {
            return elm.uniqid eq uniqid;
        }) ];
    </cfscript>
    <cfreturn event_widget>
</cffunction>

<cffunction name="set_widget_props">
    <cfargument name="event_widget">

    <cfif arrayLen(event_widget.props)>
        <cfloop array="#event_widget.props#" index="p">
            <cfset attributes[p.label] = evaluate(p.valuedata)>
        </cfloop>
    </cfif>
</cffunction>

<cffunction name="underscored_fuseaction">
    <cfargument name="fuseaction" type="string">
    <cfset result = replace( arguments.fuseaction, ".", "_" )>
    <cfreturn result>
</cffunction>