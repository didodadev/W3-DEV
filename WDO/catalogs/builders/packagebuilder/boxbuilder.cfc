<cfcomponent hint="Embeded box builder">

    <cfproperty name="widget" type="any">
    <cfproperty name="depends" type="array">

    <cfset _crlf = "">

    <cffunction name="init">
        <cfargument name="widget">
        <cfset this.widget = arguments.widget>
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

    <cffunction name="generate">

        <cfscript>

            code = "<c" & 'f_box ' & build_attr( this.widget.data.box ) & '>' & crlf();
            widgetbuilder = new WDO.catalogs.builders.packagebuilder.widgetbuilder( this.widget );

            
            code = code & "<c" & 'finclude template="widget.cfm">' & crlf();
            code = code & "</c" & 'f_box>'; 

            widgetbuilder.generate();
            
        </cfscript>
        <cfreturn code>
    </cffunction>

    <!--- helpers --->

    <!--- attribute builder --->
    <cffunction name="build_attr">
        <cfargument name="box" type="any">
        
        <cfset languageGenerator = createObject( "component", "WDO.catalogs.builders.widgetbuilder.designgenerators.languagegenerator" )>
        <cfset attrs = arrayNew(1)>
        <cfloop array="#structKeyArray(arguments.box)#" index="key">
            <cfif key eq "title" and len(arguments.box[key])>
                <cfset arrayAppend( attrs, '#key#="' & languageGenerator.generate( arguments.box[key] ) & '"' )>
            <cfelseif arguments.box[key] eq "false">
                <cfset arrayAppend( attrs, '#key#="0"', 1 )>
            <cfelseif arguments.box[key] eq "true">
                <cfset arrayAppend( attrs, '#key#="1"', 1 )>
            <cfelseif len( arguments.box[key] )>
                <cfset arrayAppend( attrs, '#key#="#arguments.box[key]#"', 1 )>
            </cfif>
        </cfloop>
        <cfreturn arrayToList( attrs, " " )>
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