<cffunction name="get_additional_allowance" access="public" returnType="query" output="no">
	<cfargument name="comment_pay" required="yes" type="string">
	<cfquery name="get_additional_allowance" datasource="#DSN#">
		SELECT
			COMMENT_PAY,
            ODKES_ID
		FROM
			SETUP_PAYMENT_INTERRUPTION
		WHERE
			COMMENT_PAY LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.comment_pay#%">
	</cfquery>
	<cfreturn get_additional_allowance>
</cffunction> 
			