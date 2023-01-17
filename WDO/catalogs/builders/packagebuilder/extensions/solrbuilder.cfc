<cfcomponent>

    <cfset dsn = application.systemParam.systemParam().dsn>
    <cfset _crlf = "">

    <cffunction name="generate_data">
        <cfargument name="fuseaction">
        <cfargument name="event">
        <cfargument name="model">

        <cfquery name="widget_query" datasource="#dsn#">
            SELECT WIDGET_STRUCTURE FROM WRK_WIDGET
            WHERE WIDGET_FUSEACTION = <cfqueryparam cfsqltype='CF_SQL_NVARCHAR' value='#arguments.fuseaction#'>
            AND WIDGET_EVENT_TYPE = 'list'
        </cfquery>

        <cfscript>
            key_element_index = arrayFind( model.listOfElements, function( elm ) {
                return elm.isKey eq 1;
            });
            if (key_element_index eq 0) return "";
            key_element = model.listOfElements[key_element_index];
            
            widget = deserializeJSON(widget_query.WIDGET_STRUCTURE);
            if (not isDefined("widget.search.keyword")) return "";
            if ( arrayLen(widget.search.keyword) eq 0 ) return "";
            keyword_elements = arrayMap(widget.search.keyword, function(elm) {
                return elm.label;
            });

            code = '<c' & 'fset ' & model.name & '_row = ' & underscore_fuseaction( arguments.fuseaction ) & '_component.' & model.name & '_get(' & model.name & '_ref)>' & crlf();
            code = code & '<c' & 'ftry>' & crlf();
            code = code & '<c' & 'fcollection collection="'& underscore_fuseaction(arguments.fuseaction) &'_collection" action="create" engine="solr">' & crlf();
            code = code & '<c' & 'fcatch></cfcatch>' & crlf();
            code = code & '</c' & 'ftry>' & crlf();
            code = code & '<c' & 'ftry>' & crlf();
            code = code & '<c' & 'findex action="update" collection="' & underscore_fuseaction(arguments.fuseaction) & '_collection" query="' & model.name & '_row" type="custom" key="' & key_element.label & '" body="' & arrayToList(keyword_elements) & '">' & crlf();
            code = code & '<c' & 'fcatch></cfcatch>' & crlf();
            code = code & '</c' & 'ftry>' & crlf();

        </cfscript>
        <cfreturn code>
    </cffunction>


    <!--- helpers --->
    <cffunction name="underscore_fuseaction">
        <cfargument name="fuseaction" type="string">
        <cfreturn replace( arguments.fuseaction, ".", "_" )>
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