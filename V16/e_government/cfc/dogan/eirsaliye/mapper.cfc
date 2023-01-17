<cfcomponent>

    <cffunction name="map_eshipment_alias" access="public">
        <cfargument name="xelement">

        <cfset result = {
            vkntckn: arguments.xelement.identifier.XmlText,
            alias: arguments.xelement.alias.XmlText,
            name: mid(arguments.xelement.title.XmlText, 1, 250)
        }>
        <cfobject name="helper" type="component" component="V16.e_government.cfc.helper">

        <cftry>
            <cfif isDefined("arguments.xelement.type")>
                <cfset result.type = arguments.xelement.type.XmlText>
            </cfif>
            <cfif isDefined("arguments.xelement.register_time")>
                <cfset result.registertime = helper.webtime2date( arguments.xelement.register_time.XmlText )>
            </cfif>
            <cfif isDefined("arguments.xelement.first_creation_time")>
                <cfset result.first_creation_time = helper.webtime2date( arguments.xelement.first_creation_time.XmlText )>
            </cfif>
            <cfif isDefined("arguments.xelement.alias_creation_time")>
                <cfset result.alias_creation_time = helper.webtime2date( arguments.xelement.alias_creation_time.XmlText )>
            </cfif>
            <cfcatch>
                <cfdump var="#cfcatch#">
            </cfcatch>
        </cftry>
        
        <cfreturn result>
    </cffunction>

</cfcomponent>