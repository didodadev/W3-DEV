<cfquery name="GET_ORDER_LIST" datasource="#dsn3#" cachedwithin="#fusebox.general_cached_time#">
	SELECT DISTINCT
		O.ORDER_NUMBER,
		O.ORDER_HEAD,
		O.PARTNER_ID,
		O.COMPANY_ID,
		O.CONSUMER_ID,
		O.RECORD_EMP,
		O.PRIORITY_ID,
		O.ORDER_ZONE,
		O.PURCHASE_SALES,
		O.RECORD_DATE,
		O.DELIVERDATE,
		O.ORDER_CURRENCY,
		ORR.DELIVER_DEPT,
		ORR.ORDER_ID
	FROM 
		ORDERS O,
		ORDER_ROW ORR
	WHERE 
		ORR.ORDER_ID = O.ORDER_ID 
		AND	ORDER_STATUS = 1 
		AND O.PURCHASE_SALES=1
		<cfif isdefined("attributes.department_id") and len(attributes.department_id)>
			AND 
			(
				ORR.DELIVER_DEPT = #attributes.department_id#  
				OR
				O.DELIVER_DEPT_ID=#attributes.department_id#
			)
		</cfif>	
		<cfif isdefined("attributes.order_id_liste") and len(attributes.order_id_liste)>
			AND O.ORDER_ID NOT IN (#attributes.order_id_liste#)
		</cfif>
		<cfif isdefined("attributes.company_id") and len(attributes.company_id)>
			AND O.COMPANY_ID=#attributes.company_id#
		</cfif>
		<cfif isDefined("attributes.keyword") and len(attributes.keyword)>
		AND
			(
				O.ORDER_NUMBER LIKE '%#attributes.keyword#%' OR	O.ORDER_HEAD LIKE '%#attributes.keyword#%'
			)
		</cfif>
	AND 
		(	
			(
				(O.ORDER_CURRENCY = -6 OR O.ORDER_CURRENCY = -7)
				AND	O.IS_PROCESSED = 1 
			)
		OR
			(
				O.ORDER_CURRENCY = -6 
				AND	O.IS_PROCESSED = 0
			)
		)
	 ORDER BY ORR.ORDER_ID,ORR.DELIVER_DEPT
</cfquery>
