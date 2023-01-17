<!---M.ER 20.02.2008
	 Masraf Merkezi
--->
<cffunction name="get_expence_center" access="public" returnType="query" output="no">
	<cfargument name="expence" required="yes" type="string">
		<cfquery name="_GET_EXPENSE_CENTER_" datasource="#dsn2#">
			SELECT EXPENSE_ID,EXPENSE_CODE,EXPENSE FROM EXPENSE_CENTER <cfif listgetat(attributes.fuseaction,1,'.') is 'store'>WHERE EXPENSE_BRANCH_ID = #ListGetAt(session.ep.user_location,2,"-")#</cfif> ORDER BY EXPENSE
		</cfquery>
	<cfreturn _GET_EXPENSE_CENTER_>
</cffunction>

