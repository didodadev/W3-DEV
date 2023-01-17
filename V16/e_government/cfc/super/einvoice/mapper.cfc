<cfcomponent>

    <cffunction name="map_einvoice_alias" access="public">
        <cfargument name="xelement">

        <cfset result = {
            vkntckn: arguments.xelement.Identifier.XmlText,
            alias: arguments.xelement.documents.document.alias.name.XmlText,
            name: mid(arguments.xelement.Title.XmlText, 1, 250)
        }>
        <cfobject name="helper" type="component" component="V16.e_government.cfc.helper">

        <cftry>
            <cfset result.type = arguments.xelement.type.XmlText>
            <cfset result.firstcreationtime = helper.webtime2date( arguments.xelement.firstcreationtime.XmlText )>
            <cfset result.aliascreationtime = helper.webtime2date( arguments.xelement.documents.document.alias.CreationTime.XmlText )>
            <cfcatch>
                <cfdump var="#cfcatch#">
            </cfcatch>
        </cftry>
        
        <cfreturn result>
    </cffunction>

</cfcomponent>