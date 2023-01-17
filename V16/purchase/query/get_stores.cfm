<cfif isdefined("GET_OFFER_DETAIL.DELIVER_PLACE") and len(get_offer_detail.deliver_place)>
	<cfquery name="GET_STORES" datasource="#DSN#">
		SELECT 
			D.DEPARTMENT_ID, 
			D.DEPARTMENT_HEAD,
			BRANCH_ID
		FROM 
			DEPARTMENT D 
		WHERE 
			D.DEPARTMENT_STATUS = 1 AND
			D.IS_STORE <> 2
		<cfif isDefined("GET_OFFER_DETAIL.DELIVER_PLACE") and len(GET_OFFER_DETAIL.DELIVER_PLACE)>
			AND D.DEPARTMENT_ID = #GET_OFFER_DETAIL.DELIVER_PLACE#
		</cfif>
		<cfif isDefined("GET_ORDER_DETAIL.SHIP_ADDRESS") AND len(GET_ORDER_DETAIL.SHIP_ADDRESS)>
			AND D.DEPARTMENT_ID = #GET_ORDER_DETAIL.SHIP_ADDRESS#
		</cfif>
	</cfquery>
<cfelseif isdefined("GET_ORDER_DETAIL.SHIP_ADDRESS") and len(get_order_detail.SHIP_ADDRESS)>
	<cfquery name="GET_STORES" datasource="#DSN#">
		SELECT 
			D.DEPARTMENT_ID, 
			D.DEPARTMENT_HEAD,
			BRANCH_ID
		FROM 
			DEPARTMENT D 
		WHERE 
			D.DEPARTMENT_STATUS = 1 AND
			D.IS_STORE <> 2
		<cfif isDefined("GET_ORDER_DETAIL.DELIVER_DEPT_ID") AND len(GET_ORDER_DETAIL.DELIVER_DEPT_ID)>
			AND D.DEPARTMENT_ID = #GET_ORDER_DETAIL.DELIVER_DEPT_ID#
		<cfelseif isDefined("GET_OFFER_DETAIL.DELIVER_PLACE") and len(GET_OFFER_DETAIL.DELIVER_PLACE)>
			AND D.DEPARTMENT_ID = #GET_OFFER_DETAIL.DELIVER_PLACE#
		</cfif>
	</cfquery>
<cfelse>
	<cfset get_stores.department_id = ''>
	<cfset get_stores.department_head = ''>
</cfif>
