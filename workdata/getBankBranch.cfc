<cfcomponent>
	<cfset dsn = application.systemParam.systemParam().dsn>
    <cffunction name="getCompenentFunction">
		<cfargument name="keyword" required="no" default="">
		<cfargument name="other_parameters" required="no" default="">
        <cfquery name="getBankBranch_" datasource="#dsn#_#session.ep.company_id#">
			SELECT
				BANK_BRANCH_NAME,
				BRANCH_CODE
			FROM
				BANK_BRANCH
			WHERE
				BANK_BRANCH_ID IS NOT NULL
				<cfif isDefined("arguments.keyword") and len(arguments.keyword)>
					AND BANK_BRANCH_NAME LIKE '%#arguments.keyword#%'
				</cfif>
				
				<cfif isDefined("arguments.other_parameters") and len(listgetat(arguments.other_parameters,2,'@'))>
					AND BANK_NAME LIKE '%#listgetat(arguments.other_parameters,2,'@')#%'
				</cfif>
        </cfquery>
        <cfreturn getBankBranch_>
    </cffunction>
</cfcomponent>

