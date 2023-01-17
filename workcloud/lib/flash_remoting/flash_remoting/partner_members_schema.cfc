<cfcomponent output="no" extends = "paramsControl">

    <cfset dsn = this.getdsn()>
    
    <!--- TEST --->
	<cffunction name="test" access="remote" returntype="string">
		<cfreturn "Company Partner Members Schema component is accessible.">
	</cffunction>
    
    <!--- GET LANGUAGE SET --->
    <cffunction name="getLangSet" access="remote" returntype="array" output="no">
    	<cfargument name="lang" type="string" required="yes">
        <cfargument name="numbers" type="string" required="yes">
    
    	<cfset lang_component = CreateObject("component", "language")>
		<cfreturn lang_component.getLanguageSet(arguments.lang, arguments.numbers)>
    </cffunction>
    
	<!--- GET MEMBERS --->
    <cffunction name="getMembers" access="remote" returntype="any" output="no">
    	<cfargument name="company_id" type="any" required="yes">
        
        <cfquery name="get_members" datasource="#dsn#">
        	SELECT
                PARTNER_ID AS id,
                HIERARCHY_PARTNER_ID AS relatedID,
                COMPANY_PARTNER_NAME + ' ' + COMPANY_PARTNER_SURNAME AS fullName,
                TITLE AS title,
                PHOTO AS photo
            FROM
                COMPANY_PARTNER
            WHERE
                COMPANY_ID = #arguments.company_id#
        </cfquery>
        
        <cfreturn get_members>
    </cffunction>
</cfcomponent>