<cfcomponent>

    <cfproperty name="event_data" type="string">
    <cfproperty name="event_type" type="string">
    <cfproperty name="event_status" type="string">
    <cfproperty name="depends" type="array" access="public">
    <cfproperty name="boxcode" type="array" access="public">

    <cfset dsn = application.systemParam.systemParam().dsn>
    <cfset _crlf = "">

    <cffunction name="init" returntype="any">
        <cfargument name="event_data">
        <cfargument name="event_type">
        <cfargument name="event_status">
        <cfset this.event_data = arguments.event_data>
        <cfset this.event_type = arguments.event_type>
        <cfset this.event_status = lCase( arguments.event_status )>
        <cfset this.depends = arrayNew( 1 )>
        <cfset this.widgetcode = "">
        <cfreturn this>
    </cffunction>

    <cfset object_resolver = "">
    <cffunction name="getScopedFsoBuilder">
        <cfif not isObject( object_resolver )>
            <cfobject name="object_resolver" type="component" component="WDO.catalogs.objectResolver">
            <cfset object_resolver.init()>
        </cfif>
        <cfset result = object_resolver.resolveByRequest( "WDO.catalogs.packagebuilder.fsobuilder" )>
        <cfreturn result>
    </cffunction>

    <cffunction name="generate" returntype="string">

        <cfscript>
            // code string container
            code = "";
            try {
                // struct
                estruct = deserializeJSON( this.event_data );
                
                // box factory that neither master nor ajax widget
                boxfactory = new WDO.catalogs.builders.packagebuilder.boxfactory();

                //fix estruct.masterWidget id
                estruct.masterWidget = iif( isDefined( "estruct.masterWidget" ), "estruct.masterWidget", de( 0 ) );

                // get rows
                for ( erow in estruct.lofRows ) {
                    
                    code = code & "<" & 'div class="row">' & crlf();

                    // get columns
                    for ( ecol in erow.listOfCols ) {
                        
                        code = code & "<" & 'div class="col col-#ecol.colsize#">' & crlf();

                        // get widgets
                        for ( ewidget in ecol.listOfWidgets ) {

                            // temporary escape
                            //if ( estruct.masterWidget neq ewidget.id ) continue;

                            // create box code builder from factory
                            boxbuilder = boxfactory.create( ewidget, estruct.masterWidget );

                            // generate widget code
                            code = code & boxbuilder.generate() & crlf();

                        }

                        code = code & '</div>' & crlf();
                    }

                    code = code & '</div>' & crlf();
                }

                

            } catch (any err) {
                //writeDump(err);abort;
            }
        </cfscript>

        <cfreturn code>
        
    </cffunction>

    

    

    <!--- helpers --->

    <cffunction name="underscored_fuseaction">
        <cfargument name="fuseaction" type="string">

        <cfset result = replace( arguments.fuseaction, ".", "_" )>
        <cfreturn result>
    </cffunction>

    <cffunction name="crlf" access="public" returntype="string">
        <cfscript>
            if (len(_crlf) eq 0)
            {
                _crlf = CreateObject("java", "java.lang.System").getProperty("line.separator");
            }
        </cfscript>
        <cfreturn _crlf>
    </cffunction>

</cfcomponent>