<cffunction name="get_bankbranch_autocomplete" access="public" returnType="query" output="no">
	<cfargument name="keyword" required="yes" type="string">
	<cfargument name="maxrows" required="yes" type="string" default="">
	<cfargument name="bank_name" required="no" type="string" default="">
	<cfif len(arguments.maxrows)>
		<cfquery name="get_bank_branch" datasource="#dsn3#" maxrows="#arguments.maxrows#">
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
				<cfif isDefined("arguments.bank_name") and len(arguments.bank_name)>
					AND BANK_NAME LIKE '%#arguments.bank_name#%'
				</cfif>
		</cfquery>
	<cfelse>
		<cfquery name="get_bank_branch" datasource="#dsn3#">
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
				<cfif isDefined("arguments.bank_name") and len(arguments.bank_name)>
					AND BANK_NAME LIKE '%#arguments.bank_name#%'
				</cfif>
		</cfquery>
	</cfif>
	<cfreturn get_bank_branch>
</cffunction>

