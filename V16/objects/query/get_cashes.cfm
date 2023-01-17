<cfset session_base = session_base?:session.ep />
<cfquery name="GET_CASHES" datasource="#DSN2#">
	SELECT DISTINCT
		CASH.CASH_ID,
		CASH.CASH_NAME,
		CASH.CASH_ACC_CODE,
		CASH.CASH_CODE,
		CASH.BRANCH_ID,		
		CASH.CASH_CURRENCY_ID,		
		CASH.CASH_EMP_ID
	FROM
		CASH
		<cfif isDefined("attributes.branch_id") and len(attributes.branch_id)>
		,#dsn_alias#.BRANCH BRANCH
		</cfif>
		<cfif attributes.fuseaction contains 'invoice.whops'>
		,#dsn3#.POS_EQUIPMENT AS PE
		</cfif>
	WHERE
		CASH_ACC_CODE IS NOT NULL 
	<cfif isdefined("cash_status")>
		AND CASH_STATUS = 1
	</cfif>
	<cfif isDefined("attributes.branch_id") and len(attributes.branch_id)>
		AND CASH.BRANCH_ID = BRANCH.BRANCH_ID
		AND CASH.BRANCH_ID = #attributes.BRANCH_ID#
	</cfif>
	<cfif attributes.fuseaction contains 'invoice.whops'>
		AND CASH.IS_WHOPS = 1
		AND CASH.BRANCH_ID = PE.BRANCH_ID
	</cfif>
	<cfif session_base.isBranchAuthorization and (attributes.fuseaction contains "detail_invoice_retail" or attributes.fuseaction contains "add_bill_retail")>
		AND CASH.BRANCH_ID = #ListGetAt(session_base.user_location,2,"-")#
	</cfif>
	ORDER BY 
		CASH_CURRENCY_ID
</cfquery>
