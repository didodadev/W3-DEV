<cfquery name="GET_UPD_PURCHASE" datasource="#DSN2#">
	SELECT
		SHIP_ID,
		SHIP_TYPE,
		COMPANY_ID,
		SHIP_NUMBER,
		COMMETHOD_ID,
		PROCESS_CAT,
		DELIVER_STORE_ID,
		LOCATION,
		DELIVER_COMP_ID,
		DELIVER_CONS_ID,
		CITY_ID,
		COUNTY_ID,
		COUNTRY_ID,
		SHIP_DETAIL,
		SHIP_DATE,
		ACTION_DATE,
		DELIVER_DATE,
		PARTNER_ID,
		CONSUMER_ID,
		EMPLOYEE_ID,
		REF_NO, 
		SHIP_METHOD,
		DELIVER_EMP,
		ADDRESS,
		SALE_EMP,
		CARD_PAYMETHOD_ID,
		DUE_DATE,
		SUBSCRIPTION_ID,
		RECORD_EMP,
		RECORD_DATE,
		UPDATE_EMP,
		IS_SHIP_IPTAL,
		OTHER_MONEY,
		SA_DISCOUNT,
		GENERAL_PROM_ID,
		FREE_PROM_ID,
		FREE_PROM_LIMIT,
		FREE_PROM_AMOUNT,
		FREE_PROM_COST,
		FREE_PROM_STOCK_ID,
		FREE_STOCK_PRICE,
		FREE_STOCK_MONEY,
		PAYMETHOD_ID,
		PROJECT_ID,
        PROJECT_ID_IN,
		DEPARTMENT_IN,
		LOCATION_IN,
		DELIVER_EMP_ID,
		DELIVER_PAR_ID,
		IS_WITH_SHIP,
		IS_DELIVERED,
		UPDATE_DATE,
		UPDATE_EMP,
        SHIP_ADDRESS_ID,
		SERVICE_ID,
		PROCESS_STAGE,
		ISNULL(IS_FROM_RETURN,0) IS_FROM_RETURN,
		DISPATCH_SHIP_ID,
		WORK_ID
	FROM 
		SHIP 
	WHERE
		SHIP_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.ship_id#">
 	<cfif session.ep.isBranchAuthorization>
		AND 
		(
		  <cfif (isDefined("attributes.cat") and len(attributes.cat) and listFind("73,74,75,76,77,80,81,82,84,761",listfirst(attributes.cat,'-'))) or not(isDefined("attributes.cat") and len(attributes.cat))>
			<!--- (SHIP.DEPARTMENT_IN IN (SELECT DEPARTMENT_ID FROM #dsn_alias#.DEPARTMENT WHERE BRANCH_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#listgetat(session.ep.user_location,2,'-')#">)) --->
			(SHIP.DEPARTMENT_IN IN (SELECT DEPARTMENT_ID FROM #dsn_alias#.DEPARTMENT WHERE BRANCH_ID IN (SELECT BRANCH_ID FROM #dsn_alias#.EMPLOYEE_POSITION_BRANCHES WHERE POSITION_CODE = #session.ep.position_code#)))
		  </cfif>
		  <cfif not(isDefined("attributes.cat") and len(attributes.cat))>
			OR
		  </cfif>
		  <cfif (isDefined("attributes.cat") and len(attributes.cat) and listFind("70,71,72,78,79,83,88",listfirst(attributes.cat,'-'))) or not(isDefined("attributes.cat") and len(attributes.cat))>
			(SHIP.DELIVER_STORE_ID IN (SELECT DEPARTMENT_ID FROM #dsn_alias#.DEPARTMENT WHERE BRANCH_ID IN (SELECT BRANCH_ID FROM #dsn_alias#.EMPLOYEE_POSITION_BRANCHES WHERE POSITION_CODE = #session.ep.position_code#)))
		  </cfif>
		)	
    </cfif>		
</cfquery>
<cfif get_upd_purchase.recordcount>
	<cfif get_upd_purchase.is_with_ship eq 1> <!--- faturadan olusturulmus irsaliye ise --->
		<cfquery name="GET_INV_SHIPS" datasource="#DSN2#">
			SELECT INVOICE_ID FROM INVOICE_SHIPS WHERE SHIP_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_upd_purchase.ship_id#"> AND SHIP_PERIOD_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.period_id#">
		</cfquery>
	</cfif>
	<cfquery name="GET_INTERNALDEMAND_RELATION" datasource="#DSN3#">
		SELECT DISTINCT INTERNALDEMAND_ID FROM INTERNALDEMAND_RELATION WHERE TO_SHIP_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_upd_purchase.ship_id#"> AND PERIOD_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.period_id#">
	</cfquery>
	<cfquery name="GET_ORDER" datasource="#DSN3#">
		SELECT ORDERS_SHIP.ORDER_ID,ORDERS.ORDER_DATE FROM ORDERS_SHIP,ORDERS WHERE ORDERS.ORDER_ID = ORDERS_SHIP.ORDER_ID AND SHIP_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_upd_purchase.ship_id#"> AND PERIOD_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.period_id#">
	</cfquery>
	<cfquery name="GET_ORDER_NUM" datasource="#DSN3#">
		SELECT
			ORDER_NUMBER,SUBSCRIPTION_ID
		FROM 
			ORDERS 
		WHERE 
		<cfif get_order.recordcount>
			ORDER_ID IN (#listsort(valuelist(get_order.order_id),"numeric","asc",",")#)
		<cfelse>
			ORDER_ID IS NULL
		</cfif>
	</cfquery>
	<!--- irsaliyeyle iliskili konsinye irsaliyelerin bilgileri alınıyor --->
	<cfinclude template="get_related_ship_detail.cfm">
</cfif>

