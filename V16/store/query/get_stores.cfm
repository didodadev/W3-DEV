<cfquery name="STORES" datasource="#DSN#">
	SELECT
		DEPARTMENT.DEPARTMENT_ID,
		DEPARTMENT.DEPARTMENT_HEAD,
		DEPARTMENT.IS_STORE
	FROM
		DEPARTMENT,
		BRANCH
	WHERE 
		DEPARTMENT.IS_STORE <> 2 AND
		DEPARTMENT.DEPARTMENT_STATUS = 1 AND
		DEPARTMENT.BRANCH_ID = BRANCH.BRANCH_ID AND
		BRANCH.BRANCH_ID = #listgetat(session.ep.user_location, 2, '-')#
	<cfif isDefined("get_offer_detail.deliver_place") and len(get_offer_detail.deliver_place)>
		AND DEPARTMENT.DEPARTMENT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_offer_detail.deliver_place#">
	 </cfif>
	  <cfif isDefined("get_order_detail.ship_address") and len(get_order_detail.ship_address) and isnumeric(get_order_detail.ship_address)>
		AND DEPARTMENT.DEPARTMENT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_order_detail.ship_address#">
	  </cfif>
</cfquery>
