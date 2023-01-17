<cfcomponent>
	<cfset dsn = application.systemParam.systemParam().dsn>
    <cffunction name="getCompCryptedFunction">
        <cfquery name="get_comp_crypted" datasource="#dsn#">
            SELECT ISNULL(IS_ENCRYPTED_SALARY,0) AS IS_ENCRYPTED_SALARY FROM OUR_COMPANY_INFO WHERE COMP_ID = #session.ep.company_id#
        </cfquery>
        <cfreturn get_comp_crypted>
    </cffunction>
</cfcomponent>

