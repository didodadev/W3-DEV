<cfif len(start_date)><cf_date tarih = 'attributes.start_date'></cfif>
<cfif len(finish_date)><cf_date tarih = 'attributes.finish_date'></cfif>

<cfquery name="add_km_kontrol" datasource="#dsn#">
	INSERT INTO
		ASSET_P_KM_CONTROL
	(
		ASSETP_ID,
		KM_START,
		KM_FINISH,
		START_DATE,
		FINISH_DATE,
	 	EMPLOYEE_ID,
	 	PARTNER_ID,
	 	DETAIL,
		RECORD_EMP,
		RECORD_IP,
		RECORD_DATE
	)
	VALUES
	(
		#attributes.assetp_id#,
		<cfif len(start_km)>#start_km#,<cfelse>NULL,</cfif>
		<cfif len(finish_km)>#finish_km#,<cfelse>NULL,</cfif>
		<cfif len(attributes.start_date)>#attributes.start_date#,<cfelse>NULL,</cfif>
		<cfif len(attributes.finish_date)>#attributes.finish_date#,<cfelse>NULL,</cfif>
		<cfif len(EMPLOYEE_ID)>#EMPLOYEE_ID#,<cfelse>NULL,</cfif>
		<cfif len(PARTNER_ID)>#PARTNER_ID#,<cfelse>NULL,</cfif>
		<cfif len(detail)>'#detail#',<cfelse>NULL,</cfif>
		#SESSION.EP.USERID#,
		'#CGI.REMOTE_ADDR#',
		#NOW()#
	)
</cfquery>
<cfif isdefined("attributes.is_detail") and attributes.is_detail neq 1>
<script type="text/javascript">
	window.parent.kaza_liste.location.reload();
	window.parent.addform.location.href='<cfoutput>#request.self#?fuseaction=assetcare.popup_add_km_control_detail</cfoutput>&iframe=1';
</script>
<cfelse>
<script type="text/javascript">
	wrk_opener_reload(); 
	self.close();
</script>
</cfif>
