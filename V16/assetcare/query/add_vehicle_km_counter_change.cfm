<cf_date tarih='attributes.start_date'>
<cf_date tarih='attributes.finish_date'>
<cfquery name="GET_KM" datasource="#DSN#" maxrows="1">
	SELECT KM_FINISH,FINISH_DATE,KM_CONTROL_ID,DEPARTMENT_ID,EMPLOYEE_ID FROM ASSET_P_KM_CONTROL WHERE ASSETP_ID = #attributes.assetp_id# ORDER BY KM_CONTROL_ID DESC
</cfquery>

<cfquery name="ADD_KMS" datasource="#DSN#"> 
	INSERT INTO 
		ASSET_P_KM_CONTROL
	(
		ASSETP_ID,
		EMPLOYEE_ID,
		DEPARTMENT_ID,
		KM_START,
		KM_FINISH,
		START_DATE,
		FINISH_DATE,
		DETAIL,
		IS_OFFTIME,
		IS_COUNTER_CHANGE,
		RECORD_EMP,
		RECORD_IP,
		RECORD_DATE
	) 
	VALUES 
	(
		#attributes.assetp_id#,
		#get_km.employee_id#,
		#get_km.department_id#,
		<cfif len(attributes.pre_km)>#attributes.pre_km#<cfelse>0</cfif>,
		<cfif len(attributes.last_km)>#attributes.last_km#<cfelse>0</cfif>,
		<cfif len(attributes.start_date)>#attributes.start_date#<cfelse>NULL</cfif>,
		<cfif len(attributes.finish_date)>#attributes.finish_date#<cfelse>NULL</cfif>,
		'KM Sayaç Değişimi',
		0,
		1,
		#session.ep.userid#,
		'#cgi.remote_addr#',
		#now()#
	)
</cfquery>
<script type="text/javascript">
	wrk_opener_reload(); 
	self.close();
</script>
