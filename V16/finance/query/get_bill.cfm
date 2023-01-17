<cfif not isdefined("attributes.to_day") or not  len(attributes.to_day)>
	<cfset attributes.to_day=now()>
</cfif>
<cfquery name="GET_BILL" datasource="#dsn2#">
	SELECT 
		INVOICE_ID,
		PURCHASE_SALES,
		INVOICE_NUMBER,
		INVOICE_DATE,
		NETTOTAL,
		COMPANY_ID,
		PARTNER_ID,
		INVENTORY_ID,
		CONSUMER_ID AS CON_ID
	FROM 
		INVOICE
	WHERE
		<cfif not attributes.PURCHASE>
			PURCHASE_SALES=0
		<cfelse>
			PURCHASE_SALES=1
		</cfif>
		AND RECORD_DATE <= #DATEADD("D",1,attributes.to_day)#
		AND RECORD_DATE >= #DATEADD("D",-1,attributes.to_day)#
		AND INVOICE_CAT NOT IN(67,69)
	ORDER BY 
		RECORD_DATE DESC
</cfquery>
