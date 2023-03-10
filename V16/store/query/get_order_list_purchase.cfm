<cfquery name="GET_ORDER_LIST_1" datasource="#dsn3#">
	SELECT 
		ORDERS.ORDER_ID,
		ORDERS.CONSUMER_ID,
		ORDERS.PARTNER_ID,
		ORDERS.COMPANY_ID,
		ORDERS.ORDER_NUMBER,
		ORDERS.ORDER_CURRENCY,
		ORDERS.ORDER_HEAD,
		ORDERS.OTHER_MONEY,
		ORDERS.TAX,
		ORDERS.COMMETHOD_ID,
		ORDERS.GROSSTOTAL, 
		ORDERS.ORDER_CURRENCY, 
		ORDERS.RECORD_DATE, 
		ORDERS.DELIVERDATE, 
		ORDERS.RECORD_EMP, 
		ORDERS.PRIORITY_ID, 
		ORDERS.IS_PROCESSED, 
		ORDERS.IS_WORK, 
		ORDERS.DELIVER_DEPT_ID,
		EMP.EMPLOYEE_NAME, 
		EMP.EMPLOYEE_EMAIL, 
		EMP.EMPLOYEE_SURNAME,
		ORD.DEPARTMENT_ID AS DELIVER_DEPT,
		ORD.LOCATION_ID,
		ORR.ORDER_ROW_ID
	FROM 
		ORDERS,
		ORDER_ROW ORR,
		ORDER_ROW_DEPARTMENTS ORD,
		#dsn_alias#.EMPLOYEES AS EMP
	WHERE
		ORD.ORDER_ROW_ID= ORR.ORDER_ROW_ID AND
		ORDERS.ORDER_ID = ORR.ORDER_ID AND
		ORDERS.ORDER_STATUS = 1 AND
		(
			(
					( ORDER_CURRENCY = -6 OR ORDER_CURRENCY = -7) AND
					( ORD.IS_APPEAR = 0 OR  ORD.IS_APPEAR IS NULL ) AND	
					IS_PROCESSED = 1
			)
			OR
			( ORDERS.ORDER_CURRENCY = -6 AND ORDERS.IS_PROCESSED = 0 )
		)
		AND ORDERS.RECORD_EMP = EMP.EMPLOYEE_ID 
		AND	ORDERS.PURCHASE_SALES = 0 
		AND ORD.DEPARTMENT_ID IN (SELECT DEPARTMENT_ID FROM #dsn_alias#.DEPARTMENT WHERE BRANCH_ID = #ListGetAt(SESSION.EP.USER_LOCATION,2,"-")# )		
		<cfif isDefined("attributes.company_id") and len(attributes.company_id)>
		AND ORDERS.COMPANY_ID = #attributes.company_id#
		</cfif>
		<cfif isdefined("attributes.order_id_liste") and len(attributes.order_id_liste)>
		AND ORDERS.ORDER_ID NOT IN (#attributes.order_id_liste#)
		</cfif>
		<cfif len(attributes.department_id)>
			AND 
				(
					ORR.DELIVER_DEPT = #attributes.department_id# OR
					ORDERS.DELIVER_DEPT_ID = #attributes.department_id# OR
				 	ORD.DEPARTMENT_ID =#attributes.department_id#
				)
		</cfif>
		<cfif isDefined("attributes.keyword") and len(attributes.keyword)>
		AND
		(
			EMP.EMPLOYEE_NAME LIKE '%#attributes.keyword#%'
			OR EMP.EMPLOYEE_SURNAME LIKE '%#attributes.keyword#%'
			OR ORDERS.ORDER_NUMBER LIKE '%#attributes.keyword#%'
			
		)
		</cfif>
</cfquery>
<cfquery name="GET_ORDER_LIST" dbtype="query">
	SELECT 
		DISTINCT 
		ORDER_ID,ORDER_NUMBER,ORDER_CURRENCY,DELIVER_DEPT,
		DELIVERDATE,CONSUMER_ID,COMPANY_ID,PARTNER_ID,
		EMPLOYEE_NAME,EMPLOYEE_SURNAME, DELIVER_DEPT_ID,PRIORITY_ID 
	FROM
		GET_ORDER_LIST_1
	 GROUP BY 
		ORDER_ID,DELIVER_DEPT,ORDER_NUMBER,CONSUMER_ID,
		COMPANY_ID,PARTNER_ID,ORDER_CURRENCY,DELIVERDATE,EMPLOYEE_NAME,EMPLOYEE_SURNAME, DELIVER_DEPT_ID,PRIORITY_ID 
	ORDER BY ORDER_ID,DELIVER_DEPT
</cfquery>

