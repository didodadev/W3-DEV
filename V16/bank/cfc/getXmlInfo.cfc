<cfcomponent>
    <cfset dsn = application.systemParam.systemParam().dsn>
	<cffunction name="getXmlInfo" returntype="any">
        <cfargument name="fuseaction" type="string" required="yes">
        <cfargument name="property" type="string" required="yes">
        <cfquery name="get_xml_control" datasource="#dsn#">
            SELECT 
                PROPERTY_VALUE
            FROM
                FUSEACTION_PROPERTY
            WHERE
                OUR_COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.company_id#"> AND
                FUSEACTION_NAME = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.fuseaction#"> AND
                PROPERTY_NAME = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.property#">
        </cfquery> 
        <cfreturn get_xml_control>
    </cffunction>
</cfcomponent>

