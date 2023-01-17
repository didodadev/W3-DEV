<cfquery name="stores" datasource="#dsn#">
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
		<cfif isDefined('session.ep.company_id')>
			BRANCH.COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.company_id#">
		<cfelseif isDefined('session.pp.our_company_id')>
			BRANCH.COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.pp.our_company_id#">
		</cfif>
		<cfif session.ep.isBranchAuthorization>
            AND BRANCH.BRANCH_ID = #listgetat(session.ep.user_location, 2, '-')#
        </cfif>
        <cfif isDefined("get_offer_detail.deliver_place") and len(get_offer_detail.deliver_place)>
            AND DEPARTMENT.DEPARTMENT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_offer_detail.deliver_place#">
        </cfif>
        <cfif isDefined("get_order_detail.ship_address") and len(get_order_detail.ship_address) and isnumeric(get_order_detail.ship_address)>
            AND DEPARTMENT.DEPARTMENT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_order_detail.ship_address#">
        </cfif>
        <cfif isdefined('store_list') and len(store_list)>
            AND DEPARTMENT.DEPARTMENT_ID IN (#store_list#)
        </cfif>
	ORDER BY
		DEPARTMENT.DEPARTMENT_HEAD
</cfquery>
