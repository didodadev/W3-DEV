<cf_xml_page_edit fuseact="myhome.welcome">
<cfif not  isdefined("attributes.to_day") or not len(attributes.to_day)>
	<cfset attributes.to_day = now()>
</cfif>

<cfif isdefined("x_control_ims") and x_control_ims eq 1 and session.ep.our_company_info.sales_zone_followup eq 1>
	<cfinclude template="../../member/query/get_ims_control.cfm">
</cfif>

<cfset get_fuseaction_property = createObject("component","V16.objects.cfc.fuseaction_properties")>
<cfset GET_XmlCurrencyId = get_fuseaction_property.get_fuseaction_property(
company_id : session.ep.company_id,
fuseaction_name : 'stock.list_command',
property_name : 'xml_order_currency_id'
)>
<cfquery name="GET_ORDER_LIST" datasource="#dsn#">
	SELECT 
		ORDERS.PURCHASE_SALES,
		ORDERS.ORDER_ID,
		ORDERS.CONSUMER_ID,
		ORDERS.PARTNER_ID,
		ORDERS.ORDER_NUMBER,
		ORDERS.ORDER_CURRENCY,
		ORDERS.ORDER_HEAD,
		ORDERS.OTHER_MONEY,
		ORDERS.TAX,
		ORDERS.COMMETHOD_ID,
		ORDERS.GROSSTOTAL, 
        ORDERS.NETTOTAL, 
        ORDERS.OTHER_MONEY_VALUE,
        ORDERS.OTHER_MONEY,
		ORDERS.ORDER_CURRENCY, 
		ORDERS.RECORD_DATE, 
		ORDERS.DELIVERDATE, 
		ORDERS.RECORD_EMP, 
		ORDERS.PRIORITY_ID, 
		ORDERS.IS_PROCESSED, 
		ORDERS.IS_WORK, 
		ORDERS.ORDER_DATE, 
        ORDERS.DELIVER_DEPT_ID,
        ORDERS.LOCATION_ID,
		EMPLOYEES.EMPLOYEE_NAME, 
		EMPLOYEES.EMPLOYEE_EMAIL, 
		EMPLOYEES.EMPLOYEE_SURNAME,
        STOCKS_LOCATION.COMMENT,
        DEPARTMENT.DEPARTMENT_HEAD
	FROM 
		EMPLOYEES,
		#dsn3_alias#.ORDERS ORDERS 
        LEFT JOIN STOCKS_LOCATION ON STOCKS_LOCATION.DEPARTMENT_ID = ORDERS.DELIVER_DEPT_ID AND STOCKS_LOCATION.LOCATION_ID = ORDERS.LOCATION_ID
        LEFT JOIN DEPARTMENT ON DEPARTMENT.DEPARTMENT_ID = STOCKS_LOCATION.DEPARTMENT_ID
	WHERE 
		ORDERS.ORDER_STATUS = 1 AND 
		<!--- ORDERS.ORDER_CURRENCY=8 AND --->
		ORDERS.RECORD_EMP = EMPLOYEES.EMPLOYEE_ID AND
		<!--- ORDERS.IS_PROCESSED = 0 AND --->
        ORDERS.ORDER_ID IN (SELECT ORR.ORDER_ID FROM #dsn3_alias#.ORDER_ROW ORR WHERE ORR.ORDER_ROW_CURRENCY IN  (
			<cfqueryparam cfsqltype="cf_sql_integer" value="-6,-7" list="yes">
			<cfif ListLen(GET_XmlCurrencyId.PROPERTY_VALUE)><!--- Belirtilen Onaylanmış Sipariş Aşamalarına Ait Urunler Xmle Bagli Olarak Gelsin --->
				,<cfqueryparam cfsqltype="cf_sql_integer" value="#valueList(GET_XmlCurrencyId.PROPERTY_VALUE)#" list="yes">
			</cfif>
				)) AND
		(
			(
				ORDERS.ORDER_DATE < <cfqueryparam cfsqltype="cf_sql_timestamp" value="#DATEADD('D',1,attributes.TO_DAY)#"> AND 
				ORDERS.ORDER_DATE > <cfqueryparam cfsqltype="cf_sql_timestamp" value="#DATEADD('D',-1,attributes.TO_DAY)#">
			)
			OR 
			ORDERS.ORDER_DATE <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.TO_DAY#">
		)
		<cfif isdefined("x_control_ims") and x_control_ims eq 1 and session.ep.our_company_info.sales_zone_followup eq 1>
			AND
				(
				(ORDERS.CONSUMER_ID IS NULL AND ORDERS.COMPANY_ID IS NULL) 
				OR (ORDERS.COMPANY_ID IN (#PreserveSingleQuotes(my_ims_comp_list)#))
				OR (ORDERS.CONSUMER_ID IN (#PreserveSingleQuotes(my_ims_cons_list)#))
				)
		</cfif>
	ORDER BY 
		ORDERS.RECORD_DATE DESC
</cfquery>