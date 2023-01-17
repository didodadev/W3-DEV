<cfif isdefined("attributes.start_date") and isdate(attributes.start_date) and isdefined("attributes.finish_date") and isdate(attributes.finish_date)>
	<cf_date tarih = "attributes.start_date">
	<cf_date tarih = "attributes.finish_date">
</cfif>
<cfquery name="GET_ORDER_LIST" datasource="#DSN#">
	SELECT 
		<cfif isdefined("attributes.product_id")>
		DISTINCT
		</cfif>
		O.ORDER_ID,
		O.ORDER_NUMBER, 
		O.ORDER_CURRENCY, 
		O.ORDER_DATE, 
		O.ORDER_HEAD,
		O.VALID_EMP,
		O.VALIDDATE,
		O.VALIDATOR_POSITION_CODE,
		C.FULLNAME,
		C.NICKNAME,
		C.COMPANY_ID, 
		O.PARTNER_ID,
		E.EMPLOYEE_NAME,
		E.EMPLOYEE_SURNAME,
		E.EMPLOYEE_EMAIL,
		O.RECORD_EMP AS EMP   
	FROM 
		#dsn3_alias#.ORDERS O, 
		COMPANY C, 
		EMPLOYEES E
		<cfif isdefined("attributes.product_id")>
		,#dsn3_alias#.ORDER_ROW ORR
		</cfif>				
	WHERE 
		C.COMPANY_ID = O.COMPANY_ID 
		AND
		(
			(O.PURCHASE_SALES = 0 AND O.ORDER_ZONE = 0 )
		)
		AND E.EMPLOYEE_ID = O.RECORD_EMP
	<cfif isdefined("currency_id") and len(currency_id)>
		AND O.ORDER_CURRENCY = #CURRENCY_ID#
	</cfif>
	<cfif isdefined("attributes.department_id") and (attributes.department_id neq 0)>
		AND O.DELIVER_DEPT_ID = #attributes.department_id#
	</cfif>
	<cfif isdefined("attributes.start_date") and isdate(attributes.start_date) and isdefined("attributes.finish_date") and isdate(attributes.finish_date)>
		AND 
		(
		O.ORDER_DATE > #DATEADD("d",-1,attributes.start_date)#
		AND 
		O.ORDER_DATE < #DATEADD("d",1,attributes.finish_date)#
		)
	</cfif>
	<cfif isdefined("order_status") and len(order_status)>
		AND O.ORDER_STATUS = #Attributes.order_status#
	</cfif>
	<cfif isdefined("attributes.product_id")>
		AND ORR.ORDER_ID = O.ORDER_ID
		AND ORR.PRODUCT_ID = #attributes.product_id#
	</cfif>				
	<cfif isdefined("attributes.employee") and len(attributes.employee)>
		AND 
		 (
			E.EMPLOYEE_NAME LIKE '#attributes.employee#%'
		 	OR
			E.EMPLOYEE_SURNAME LIKE '#attributes.employee#%'
		 )
	</cfif>
	<cfif isdefined("attributes.keyword") and len(attributes.keyword)>
		AND
		(
				CAST ( O.ORDER_ID AS NVARCHAR(20) )	 LIKE '%#attributes.keyword#%'
			OR 
				O.ORDER_HEAD LIKE '%#attributes.keyword#%'
			OR
				C.FULLNAME LIKE '%#attributes.keyword#%'
			OR
				C.NICKNAME LIKE '%#attributes.keyword#%'
		)
	</cfif>
	<cfif isdefined("attributes.company_id") and isdefined("attributes.ismyhome")>
	   AND C.COMPANY_ID = #attributes.company_id#
	</cfif>
	<!---
	ORDER BY ORDER_ID DESC
	--->
	<cfif isDefined('attributes.oby') and attributes.oby eq 2>
		ORDER BY O.ORDER_DATE
	<cfelse>
		ORDER BY O.ORDER_DATE DESC
	</cfif>
	</cfquery>
<!--- <cfif isdefined("attributes.start_date") and isdate(attributes.start_date) and isdefined("attributes.finish_date") and isdate(attributes.finish_date)>
	<cf_date tarih = "attributes.start_date">
	<cf_date tarih = "attributes.finish_date">
</cfif>
<cfquery name="GET_ORDER_LIST" datasource="#DSN#">
	SELECT 
		<cfif isdefined("attributes.product_id")>
		DISTINCT
		</cfif>
		O.ORDER_ID,
		O.ORDER_NUMBER, 
		O.ORDER_CURRENCY, 
		O.RECORD_DATE, 
		O.ORDER_HEAD,
		O.VALID_EMP,
		O.VALIDDATE,
		O.VALIDATOR_POSITION_CODE,
		C.FULLNAME,
		C.NICKNAME,
		C.COMPANY_ID, 
		O.PARTNER_ID,
		E.EMPLOYEE_NAME,
		E.EMPLOYEE_SURNAME,
		E.EMPLOYEE_EMAIL,
		O.RECORD_EMP AS EMP   
	FROM 
		#dsn3_alias#.ORDERS O, 
		COMPANY C, 
		EMPLOYEES E
		<cfif isdefined("attributes.product_id")>
		,#dsn3_alias#.ORDER_ROW ORR
		</cfif>				
	WHERE 
		C.COMPANY_ID = O.COMPANY_ID 
		AND
		(
			(O.PURCHASE_SALES = 0 AND O.ORDER_ZONE = 0 )
		)
		AND E.EMPLOYEE_ID = O.RECORD_EMP
	<cfif isdefined("currency_id") and len(currency_id)>
		AND O.ORDER_CURRENCY = #CURRENCY_ID#
	</cfif>
	<cfif isdefined("attributes.department_id") and (attributes.department_id neq 0)>
		AND O.DELIVER_DEPT_ID = #attributes.department_id#
	</cfif>
	<cfif isdefined("attributes.start_date") and isdate(attributes.start_date) and isdefined("attributes.finish_date") and isdate(attributes.finish_date)>
		AND 
		(
		O.RECORD_DATE > #DATEADD("d",-1,attributes.start_date)#
		AND 
		O.RECORD_DATE < #DATEADD("d",1,attributes.finish_date)#
		)
	</cfif>
	<cfif isdefined("order_status") and len(order_status)>
		AND O.ORDER_STATUS = #Attributes.order_status#
	</cfif>
	<cfif isdefined("attributes.product_id")>
		AND ORR.ORDER_ID = O.ORDER_ID
		AND ORR.PRODUCT_ID = #attributes.product_id#
	</cfif>				
	<cfif isdefined("attributes.employee") and len(attributes.employee)>
		AND 
		 (
			E.EMPLOYEE_NAME LIKE '#attributes.employee#%'
		 	OR
			E.EMPLOYEE_SURNAME LIKE '#attributes.employee#%'
		 )
	</cfif>
	<cfif isdefined("attributes.keyword") and len(attributes.keyword)>
		AND
		(
				CAST ( O.ORDER_ID AS NVARCHAR(20) )	 LIKE '%#attributes.keyword#%'
			OR 
				O.ORDER_HEAD LIKE '%#attributes.keyword#%'
			OR
				C.FULLNAME LIKE '%#attributes.keyword#%'
			OR
				C.NICKNAME LIKE '%#attributes.keyword#%'
		)
	</cfif>
	<cfif isdefined("attributes.company_id") and isdefined("attributes.ismyhome")>
	   AND C.COMPANY_ID = #attributes.company_id#
	</cfif>
	<!---
	ORDER BY ORDER_ID DESC
	--->
	<cfif isDefined('attributes.oby') and attributes.oby eq 2>
		ORDER BY O.RECORD_DATE
	<cfelse>
		ORDER BY O.RECORD_DATE DESC
	</cfif>
	</cfquery> --->
