<cfcomponent>
	<cffunction name="get_xml_det" access="public" returntype="query">
		<cfargument name="property" default="" type="string">
		<cfquery name="get_xml_fire" datasource="#this.dsn#">
            SELECT 
                PROPERTY_VALUE,
                PROPERTY_NAME
            FROM
                FUSEACTION_PROPERTY
            WHERE
                OUR_COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.company_id#"> AND
                FUSEACTION_NAME = <cfqueryparam cfsqltype="cf_sql_varchar" value="ehesap.popup_form_fire"> AND
                PROPERTY_NAME = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.property#">
		</cfquery>
		<cfreturn get_xml_fire>
	</cffunction>
</cfcomponent>
