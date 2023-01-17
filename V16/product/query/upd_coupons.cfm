<cfif isdefined("attributes.start_date") and isdate(attributes.start_date)><cf_date tarih = "attributes.start_date"></cfif>
<cfif isdefined("attributes.finish_date") and isdate(attributes.finish_date)><cf_date tarih = "attributes.finish_date"></cfif>
<cfquery name="UPD_COUPONS" datasource="#DSN3#">
	UPDATE
	   COUPONS
	SET
		COUPON_NO = <cfif len(attributes.coupon_no)>#attributes.coupon_no#<cfelse>NULL</cfif>,
		COUPON_NAME = <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.coupon_name#">,
		COUPON_DETAIL = <cfif len(attributes.coupon_detail)><cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.coupon_detail#"><cfelse>NULL</cfif>,
		<cfif len(attributes.barcod)>BARCOD = #attributes.barcod#,</cfif> 
		IS_ACTIVE = <cfif isdefined("attributes.is_active")>1<cfelse>0</cfif>,
		START_DATE = #attributes.start_date#,
		FINISH_DATE = #attributes.finish_date#,
		UPDATE_DATE = #now()#,
		UPDATE_EMP = #session.ep.userid#,
		UPDATE_IP = <cfqueryparam cfsqltype="cf_sql_varchar" value="#cgi.remote_addr#">,
		COUPON_TYPE = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.coupon_type#">
		,RATE = <cfif attributes.coupon_type eq 1 and len(attributes.discount_rate)><cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.discount_rate#"><cfelse>NULL</cfif>
		,MONEY = <cfif attributes.coupon_type eq 2 and len(attributes.coupon_amount)><cfqueryparam cfsqltype="cf_sql_money" value="#attributes.coupon_amount#"><cfelse>NULL</cfif>
		,CURRENCY = <cfif attributes.coupon_type eq 2><cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.currency#"><cfelse>NULL</cfif>
	WHERE 
		COUPON_ID = #attributes.coupon_id#
</cfquery>
<script>
	location.reload();
</script>