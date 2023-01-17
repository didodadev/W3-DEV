<cfquery name="GET_INVOICE_CONTROL_1" datasource="#DSN2#">
	SELECT
		INVOICE_CONTROL.*,
		INVOICE.INVOICE_DATE,
		INVOICE.INVOICE_ID,
		INVOICE.PURCHASE_SALES AS REAL_PURCHASE_SALES,
		INVOICE.INVENTORY_ID
	FROM
		INVOICE_CONTROL,
		INVOICE
	WHERE
		<cfif attributes.isbilled eq 1>
			IS_BILLED = #attributes.isbilled# AND
		<cfelseif attributes.isbilled eq 0>
			(
				IS_BILLED IS NULL OR
				IS_BILLED = 0
			)
			AND			
		</cfif>
		INVOICE.INVOICE_ID = INVOICE_CONTROL.INVOICE_ID
		<cfif len(attributes.keyword)>
			AND
			(
				INVOICE_CONTROL.INVOICE_NUMBER LIKE '%#attributes.keyword#%' OR 
				INVOICE.COMPANY_ID IN (SELECT COMPANY_ID FROM #dsn_alias#.COMPANY WHERE FULLNAME LIKE '#attributes.keyword#%')
			)
		</cfif>
		<cfif len(attributes.date1) and len(attributes.date2)>
			AND INVOICE.INVOICE_DATE >= #attributes.date1#  
			AND INVOICE.INVOICE_DATE <= #attributes.date2#
		</cfif>
		<cfif len(attributes.oby) and attributes.oby eq 1>
			ORDER BY INVOICE.INVOICE_DATE DESC
		<cfelseif len(attributes.oby) and attributes.oby eq 2>
			ORDER BY INVOICE.INVOICE_DATE
		<cfelseif len(attributes.oby) and attributes.oby eq 3>
			ORDER BY INVOICE_CONTROL.INVOICE_NUMBER DESC
		<cfelseif len(attributes.oby) and attributes.oby eq 4>
			ORDER BY INVOICE_CONTROL.INVOICE_NUMBER
		</cfif>
</cfquery>
<cfquery name="GET_INVOICE_CONTROL_2" datasource="#DSN2#">
	SELECT
		INVOICE_CONTROL.*,
		INVOICE_CONTROL.RETURN_DATE AS INVOICE_DATE,
		-1 AS INVOICE_ID,
		1 AS PURCHASE_SALES,
		-1 INVENTORY_ID
	FROM
		INVOICE_CONTROL
	WHERE
		INVOICE_ID IS  NULL  
		<cfif attributes.isbilled eq 1>
			AND IS_BILLED = #attributes.isbilled# 
		<cfelseif attributes.isbilled eq 0>
			AND
			(
				IS_BILLED IS NULL OR
				IS_BILLED = 0
			)
		</cfif>
		<cfif len(attributes.keyword)>
			AND
			(
				INVOICE_CONTROL.INVOICE_NUMBER LIKE '%#attributes.keyword#%' OR
				INVOICE_CONTROL.COMPANY_ID IN (SELECT COMPANY_ID FROM #dsn_alias#.COMPANY WHERE FULLNAME LIKE '#attributes.keyword#%')
			)
		</cfif>
		<cfif len(attributes.date1) and len(attributes.date2)>
			AND RETURN_DATE >= #attributes.date1#  
			AND RETURN_DATE <= #attributes.date2#
		</cfif>
</cfquery>

<cfquery name="GET_INVOICE_CONTROL" dbtype="query">
	SELECT * FROM GET_INVOICE_CONTROL_1
	UNION 
	SELECT * FROM GET_INVOICE_CONTROL_2	
</cfquery>
