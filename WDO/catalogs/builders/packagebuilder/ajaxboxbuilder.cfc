<cfcomponent hint="Ajax Box Builder">

    <cfproperty name="fsobuilder" type="any">
    <cfproperty name="widget" type="any">

    <cfset dsn = application.systemParam.systemParam().dsn>
    <cfset _crlf = "">

    <cffunction name="init">
        <cfargument name="widget">
        <cfset this.widget = arguments.widget>
        <cfreturn this>
    </cffunction>

    <cffunction name="generate">
        <cfscript>
            code = "<c" & 'f_box ' & build_attr( this.widget.data.box ) & '>' & crlf();
            code = code & "</c" & 'f_box>'; 
            
        </cfscript>
        
        <cfreturn code>
    </cffunction>


    <!--- helpers --->

    <!--- attribute builder --->
    <cffunction name="build_attr">
        <cfargument name="box" type="any">
        <cfscript>
            box.box_page = find_ajaxdata();
        </cfscript>
        <cfset attrs = arrayNew(1)>
        <cfloop array="#structKeyArray(arguments.box)#" index="key">
            <cfif arguments.box[key] eq "false">
                <cfset arrayAppend( attrs, '#key#="0"', 1 )>
            <cfelseif arguments.box[key] eq "true">
                <cfset arrayAppend( attrs, '#key#="1"', 1 )>
            <cfelseif len( arguments.box[key] )>
                <cfset arrayAppend( attrs, '#key#="#arguments.box[key]#"', 1 )>
            </cfif>
        </cfloop>
        
        <cfreturn arrayToList( attrs, " " )>
    </cffunction>

    <cffunction name="find_ajaxdata">
        <cfquery name="query_box_widget" datasource="#dsn#">
        SELECT * FROM WRK_WIDGET WHERE WIDGETID = <cfqueryparam cfsqltype='CF_SQL_INTEGER' value='#this.widget.id#'>
        </cfquery>
        <cfset ajaxurl = request.self & '?fuseaction=dev.popup_composer&isAjax=1&th=box&fuseact=' & query_box_widget.WIDGET_FUSEACTION & '&event=' & query_box_widget.WIDGET_EVENT_TYPE & '&st=' & query_box_widget.WIDGET_STATUS>
        <cfreturn ajaxurl>
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