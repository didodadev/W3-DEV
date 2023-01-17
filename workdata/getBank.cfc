<cfcomponent>
	<cfset dsn = application.systemParam.systemParam().dsn>
    <cffunction name="getCompenentFunction">
        <cfquery name="getBank_" datasource="#dsn#">
			SELECT
				BANK_ID,
				BANK_NAME,
				DETAIL
			FROM
				SETUP_BANK_TYPES
			WHERE
				BANK_ID IS NOT NULL
				<cfif isDefined("arguments.keyword") and len(arguments.keyword)>
					AND BANK_NAME LIKE '%#arguments.keyword#%'
				</cfif>
        </cfquery>
        <cfreturn getBank_>
    </cffunction>
</cfcomponent>

