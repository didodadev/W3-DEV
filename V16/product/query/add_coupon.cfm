<cfif len(attributes.start_date)><cf_date tarih = "attributes.start_date"></cfif>
<cfif len(attributes.finish_date)><cf_date tarih = "attributes.finish_date"></cfif>
<cfquery name="ADD_COUPON" datasource="#DSN3#">
	INSERT INTO 
		COUPONS 
	(
		COUPON_NAME,
		<cfif len(attributes.coupon_no)>COUPON_NO,</cfif>
		<cfif len(attributes.coupon_detail)>COUPON_DETAIL,</cfif>
		<cfif len(attributes.barcod)>BARCOD,</cfif>
		IS_ACTIVE,
		START_DATE,
		FINISH_DATE,
		RECORD_DATE,
		RECORD_EMP,
		RECORD_IP,
		COUPON_TYPE,
		RATE,
		MONEY,
		CURRENCY
	)
	VALUES	
	(
		<cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.coupon_name#">,
		<cfif len(attributes.coupon_no)>#attributes.coupon_no#,</cfif>
		<cfif len(attributes.coupon_detail)><cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.coupon_detail#">,</cfif>
		<cfif len(attributes.barcod)>#attributes.barcod#,</cfif>
		<cfif isdefined("attributes.is_active")>1<cfelse>0</cfif>,
		#attributes.start_date#,
		#attributes.finish_date#,
		#now()#,
		#session.ep.userid#,
		<cfqueryparam cfsqltype="cf_sql_varchar" value="#cgi.remote_addr#">,
		<cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.coupon_type#">,
		<cfif attributes.coupon_type eq 1 and len(attributes.discount_rate)><cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.discount_rate#"><cfelse>NULL</cfif>,
		<cfif attributes.coupon_type eq 2 and len(attributes.coupon_amount)><cfqueryparam cfsqltype="cf_sql_money" value="#attributes.coupon_amount#"><cfelse>NULL</cfif>,
		<cfif attributes.coupon_type eq 2><cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.currency#"><cfelse>NULL</cfif>
	)
</cfquery>
<script>
	location.href = document.referrer;
</script>