<cfparam name="attributes.event" default="list">
<cfparam name="attributes.fuseaction" default="">
<cfparam name="attributes.version" default="default">

<cfquery name="query_event" datasource="#dsn#">
SELECT * FROM WRK_EVENTS WHERE EVENT_FUSEACTION = <cfqueryparam cfsqltype='CF_SQL_NVARCHAR' value='#attributes.fuseaction#'> AND EVENT_TYPE = <cfqueryparam cfsqltype='CF_SQL_NVARCHAR' value='#attributes.event#'> AND EVENT_VERSION = <cfqueryparam cfsqltype='CF_SQL_NVARCHAR' value='#attributes.version#'>
</cfquery>

<cfset event_data = deserializeJSON( query_event.EVENT_STRUCTURE )>
<cfif isDefined( "event_data.lofRows" )>

    <cfloop array="#event_data.lofRows#" index="event_row">
    <div class="row">

        <cfif isDefined( "event_row.listOfCols" )>
        <cfloop array="#event_row.listOfCols#" index="event_col">
        <div class="col col-<cfoutput>#event_col.colsize#</cfoutput>">
            
            <cfif isDefined( "event_col.listOfWidgets" )>
            <cfloop array="#event_col.listOfWidgets#" index="event_widget">
            <cfset query_widget = get_widget_data( event_widget.id )>
                <cfif query_widget.WIDGET_TOOL eq "nocode">
                <cfinclude template="../NoCode/#underscored_fuseaction(query_widget.WIDGET_FUSEACTION)#/#query_widget.WIDGET_STATUS#/#attributes.version#/#query_widget.WIDGET_EVENT_TYPE#/widget.cfm">
                <cfelse>
                    <cfif isDefined( "event_widget.props" )>
                    <cfloop array="#event_widget.props#" index="prop">
                        <cfset attributes[prop.label] = evaluate( prop.valuedata )>
                    </cfloop>
                    </cfif>
                    <cfinclude template="#replace(query_widget.WIDGET_FILE_PATH, "../", "../V16/")#">
                </cfif>
            </cfloop>
            </cfif>

        </div>
        </cfloop>
        </cfif>

    </div>
    </cfloop>
    <script type="text/javascript">
        jQuery(".pageBody").removeClass("hide");
       </script>
</cfif>

<!--- functions --->
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