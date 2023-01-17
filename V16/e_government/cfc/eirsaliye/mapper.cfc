<cfcomponent>

    <cffunction name="map_eshipment_alias" access="public">
        <cfargument name="xelement">

        <cfset result = {
            vkntckn: arguments.xelement.vkntckn.XmlText,
            alias: arguments.xelement.alias.XmlText,
            name: mid(arguments.xelement.name.XmlText, 1, 250)
        }>
        <cfobject name="helper" type="component" component="V16.e_government.cfc.helper">

        <cftry>
            <cfif isDefined("arguments.xelement.type")>
                <cfset result.type = arguments.xelement.type.XmlText>
            </cfif>
            <cfif isDefined("arguments.xelement.registertime")>
                <cfset result.registertime = helper.webtime2date( arguments.xelement.registertime.XmlText )>
            </cfif>
            <cfif isDefined("arguments.xelement.firstcreationtime")>
                <cfset result.firstcreationtime = helper.webtime2date( arguments.xelement.firstcreationtime.XmlText )>
            </cfif>
            <cfif isDefined("arguments.xelement.aliascreationtime")>
                <cfset result.aliascreationtime = helper.webtime2date( arguments.xelement.aliascreationtime.XmlText )>
            </cfif>
            <cfcatch>
                <cfdump var="#cfcatch#">
            </cfcatch>
        </cftry>
        
        <cfreturn result>
    </cffunction>

</cfcomponent>