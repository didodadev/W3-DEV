<!--- 
	amac            : gelen expense_center_name parametresine göre EXPENSE_ID,EXPENSE bilgisini getirmek
	parametre adi   : expense_center_name
	kullanim        : get_expense_center('iletisim') 
	Yazan           : B.Kuz
	Tarih           : 20080422
	Not				: Gerekirse subelerde kullanimi farklilasabilir. Parametre gonderilmeli o zaman
 --->
<cffunction name="get_expense_center" access="public" returnType="query" output="no">
	<cfargument name="expense_center_name" required="yes" type="string">
	<cfargument name="maxrows" required="yes" type="string" default="-1">
    <cfargument name="is_store_module" required="no" type="string" default="0">
	<!--- <cfif len(arguments.maxrows)> --->
		<cfquery name="GET_EXPENSE_CENTER" datasource="#DSN2#" maxrows="#arguments.maxrows#">
			SELECT
				EXPENSE_ID,
				EXPENSE_CODE,
				EXPENSE
			FROM
				EXPENSE_CENTER
			WHERE
            	EXPENSE_ACTIVE=1 AND
				<cfif arguments.is_store_module eq 1>
                    (EXPENSE_BRANCH_ID = #ListGetAt(session.ep.user_location,2,"-")# OR EXPENSE_BRANCH_ID IS NULL) AND
                </cfif>
			(
				EXPENSE LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.expense_center_name#%"> OR
				EXPENSE_CODE LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.expense_center_name#%">
			)
			ORDER BY
				EXPENSE
		</cfquery>
	<!--- <cfelse>
		<cfquery name="GET_EXPENSE_CENTER" datasource="#DSN2#">
			SELECT
				EXPENSE_ID,
				EXPENSE_CODE,
				EXPENSE
			FROM
				EXPENSE_CENTER
			WHERE
			EXPENSE_ACTIVE=1 AND
			<cfif arguments.is_store_module eq 1>
                 EXPENSE_BRANCH_ID =#ListGetAt(session.ep.user_location,2,"-")# AND
            </cfif>
			(
				EXPENSE LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.expense_center_name#%"> OR
				EXPENSE_CODE LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.expense_center_name#%">
			)
			ORDER BY
				EXPENSE
		</cfquery>
	</cfif> --->
	<cfreturn get_expense_center>
</cffunction>
