<cfcomponent>

    <cfproperty name="depends" type="array">
    <cfproperty name="filepath" type="string">
    <cfproperty name="event_status" type="string">
    
    <cfset dsn = application.systemParam.systemParam().dsn>

    <cffunction name="init">
        <cfset this.depends = arrayNew( 1 )>
        <cfobject name="object_resolver" type="component" component="WDO.catalogs.objectResolver">
        <cfset object_resolver.init()>
        <cfif not object_resolver.hasRegisteredInRequest( "WDO.catalogs.packagebuilder.fsobuilder" )>
            <cfset object_resolver.registerToRequest( "WDO.catalogs.packagebuilder.fsobuilder", this )>
        </cfif>
        <cfreturn this>
    </cffunction>

    <cffunction name="generate">
        <cfargument name="id" type="numeric">

        <!--- find events --->
        <cfquery name="query_events" datasource="#dsn#">
            SELECT E1.* FROM WRK_EVENTS E1 INNER JOIN WRK_EVENTS E2 ON E1.EVENT_FUSEACTION = E2.EVENT_FUSEACTION AND E1.EVENT_TOOL = 'nocode' AND E1.EVENT_VERSION = E2.EVENT_VERSION AND <cfqueryparam cfsqltype='CF_SQL_INTEGER' value='#arguments.id#'> = E2.EVENTID
        </cfquery>

        <cfset this.event_status = query_events.EVENT_STATUS>

        <!--- create required directories --->
        <cfscript>
            this.filepath = replace( getTemplatePath(), "index.cfm", "" ) & "\NoCode\" & replace( query_events.EVENT_FUSEACTION, ".", "_" );
            if ( not directoryExists( this.filepath ) ) 
            {
                directoryCreate( this.filepath );
            }

            this.filepath = this.filepath & "/" & query_events.EVENT_STATUS;
            if ( not directoryExists( this.filepath ) )
            {
                directoryCreate( this.filepath );
            }
        </cfscript>

        <!--- extract events --->
        <cfloop query="query_events">

            <!--- collect dependended components --->
            <cfset depends = arrayNew(1)>
            <!--- default template --->
            <cfset ecode = ''>    

            <cfscript>
                
                if ( not directoryExists( this.filepath & "/" & EVENT_TYPE ) ) {
                    directoryCreate( this.filepath & "/" & EVENT_TYPE );
                }

                layoutbuilder = new WDO.catalogs.builders.packagebuilder.layoutbuilder( EVENT_STRUCTURE, EVENT_TYPE, EVENT_STATUS );
                ecode = layoutbuilder.generate();

                arrayEach( layoutbuilder.depends, function( elm ) {
                    arrayAppend( this.depends, elm );
                } );

            </cfscript>

        </cfloop>

    </cffunction>

    <cffunction name="write_depended_component">
        <cfargument name="maction">
        <cfobject name="modelbuilder" type="component" component="WDO.catalogs.builders.packagebuilder.modelbuilder">
        <cfscript>
            component_code = modelbuilder.generate( arguments.maction );
            fileWrite( this.filepath & "/" & underscore_fuseaction( maction ) & ".cfc", component_code );
        </cfscript>
    </cffunction>

    <cffunction name="write_widget">
        <cfargument name="widget_code">
        <cfargument name="event_type">
        <cfargument name="event_version">
        <cfscript>
            fileWrite( this.filepath & "/" & arguments.event_type & "/widget.cfm", arguments.widget_code );
        </cfscript>

    </cffunction>

    <cffunction name="write_widget_data">
        <cfargument name="widget_code">
        <cfargument name="event_type">
        <cfargument name="event_version">
        
        <cfscript>
            fileWrite( this.filepath & "/" & arguments.event_type & "/widgetdata.cfm", arguments.widget_code );
        </cfscript>

    </cffunction>


    <!--- helpers --->

    <cffunction name="underscore_fuseaction">
        <cfargument name="fuseaction" type="string">

        <cfset result = replace( arguments.fuseaction, ".", "_" )>
        <cfreturn result>
    </cffunction>

</cfcomponent>