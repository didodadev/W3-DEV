<cf_date tarih='attributes.start_date'>
<cf_date tarih='attributes.finish_date'>
<cfquery name="ADD_KMS" datasource="#dsn#" result="MAX_ID"> 
	INSERT INTO 
		ASSET_P_KM_CONTROL
	(
		ASSETP_ID,
		EMPLOYEE_ID,
		DEPARTMENT_ID, 
		BRANCH_ID,
		KM_START,
		KM_FINISH,
		START_DATE,
		FINISH_DATE,
		DETAIL,
		IS_OFFTIME,
		RECORD_EMP,
		RECORD_DATE,
		RECORD_IP
		
	) 
	VALUES 
	(
		#attributes.assetp_id#,
		#attributes.employee_id#,
		#department_id#, 
		<cfif len(attributes.branch_id)>#attributes.branch_id#<cfelse>NULL</cfif>,
		<cfif len(attributes.pre_km)>#attributes.pre_km#<cfelse>0</cfif>,
		<cfif len(attributes.last_km)>#attributes.last_km#<cfelse>0</cfif>,
		<cfif len(attributes.start_date)>#attributes.start_date#<cfelse>NULL</cfif>,
		<cfif len(attributes.finish_date)>#attributes.finish_date#<cfelse>NULL</cfif>,
		<cfif len(attributes.detail)>'#attributes.detail#'<cfelse>NULL</cfif>,
		<cfif isDefined("attributes.is_offtime")>#attributes.is_offtime#<cfelse>0</cfif>,
		#session.ep.userid#,
		#now()#,
		'#cgi.remote_addr#'
		
	)
</cfquery>
<script type="text/javascript">
	 window.location.href='<cfoutput>#request.self#?fuseaction=assetcare.list_vehicles&event=upd_km&assetp_id=#attributes.assetp_id#&km_control_id=#MAX_ID.IDENTITYCOL#</cfoutput>';
</script>

