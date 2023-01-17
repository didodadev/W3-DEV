<cfif isdefined("attributes.date1") and isdate(attributes.date1)><cf_date tarih = "attributes.date1"></cfif>
<cfif isdefined("attributes.date2") and isdate(attributes.date2)><cf_date tarih = "attributes.date2"></cfif>
<cfif isdefined("attributes.startdate") and isdate(attributes.startdate)><cf_date tarih = "attributes.startdate"></cfif>
<cfif isdefined("attributes.finishdate") and isdate(attributes.finishdate)>	<cf_date tarih = "attributes.finishdate"></cfif>
<cfquery name="GET_PAYMENT_ORDER" datasource="#DSN#">
	SELECT
		PO.*,
		SP.PAYMETHOD_ID,
		SP.PAYMETHOD,
		SP.DUE_DAY,
		SP.DUE_MONTH,
		SP.PAYMENT_VEHICLE
	FROM
		PAYMENT_ORDERS PO,
		SETUP_PAYMETHOD SP
	WHERE
		PO.PERIOD_ID = #session.ep.period_id#
		<cfif isdefined('attributes.id')>
			AND PO.RESULT_ID=#attributes.id#
		<cfelse>
			AND SP.PAYMETHOD_ID = PO.PAY_METHOD
		  <cfif isdefined("attributes.startdate") and isdate(attributes.startdate)>
			AND (PO.VALID_DATE >= #CreateODBCDateTime(attributes.startdate)#)
		  </cfif>
		  <cfif isdefined("attributes.finishdate") and isdate(attributes.finishdate)>
			AND (PO.VALID_DATE < #CreateODBCDateTime(DATEADD("d",1,attributes.finishdate))#)
		  </cfif>
		  <cfif isdefined("attributes.date1") and isdate(attributes.date1)>
			AND (PO.PAYMENT_DATE >= #attributes.date1#)
		  </cfif>
		  <cfif isdefined("attributes.date2") and isdate(attributes.date2)>
			AND (PO.PAYMENT_DATE <= #attributes.date2#)
		  </cfif>
		  <cfif isdefined('attributes.keyword') and len(attributes.keyword)>
			AND (PO.SUBJECT LIKE '%#attributes.keyword#%' OR PO.DETAIL LIKE '%#attributes.keyword#%')
		  </cfif>	
		  <cfif len(attributes.sub_pay_method)>
			AND SP.PAYMENT_VEHICLE = #attributes.sub_pay_method#
		  </cfif>
		  <cfif isdefined("attributes.pay_method_id") and len(attributes.pay_method_id)>
			AND SP.PAYMETHOD_ID = #attributes.pay_method_id#
		  </cfif>
		</cfif>		
	ORDER BY
		PO.PAYMENT_DATE DESC
</cfquery>
