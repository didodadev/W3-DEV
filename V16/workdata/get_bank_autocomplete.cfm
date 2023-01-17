<cffunction name="get_bank_autocomplete" access="public" returnType="query" output="no">
	<cfargument name="keyword" required="yes" type="string">
	<cfargument name="maxrows" required="yes" type="string" default="">
	<cfif len(arguments.maxrows)>
		<cfquery name="get_bank" datasource="#dsn#" maxrows="#arguments.maxrows#">
			SELECT
				BANK_ID,
				BANK_NAME
			FROM
				SETUP_BANK_TYPES
			WHERE
				BANK_ID IS NOT NULL
				<cfif isDefined("arguments.keyword") and len(arguments.keyword)>
					AND BANK_NAME LIKE '%#arguments.keyword#%'
				</cfif>
		</cfquery>
	<cfelse>
		<cfquery name="get_bank" datasource="#dsn#">
			SELECT
				BANK_ID,
				BANK_NAME
			FROM
				SETUP_BANK_TYPES
			WHERE
				BANK_ID IS NOT NULL
				<cfif isDefined("arguments.keyword") and len(arguments.keyword)>
					AND BANK_NAME LIKE '%#arguments.keyword#%'
				</cfif>
		</cfquery>
	</cfif>
	<cfreturn get_bank>
</cffunction>

