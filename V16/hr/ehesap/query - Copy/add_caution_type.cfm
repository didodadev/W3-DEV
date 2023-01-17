<cfquery name="add_caution_type" datasource="#dsn#">
	INSERT INTO
		SETUP_CAUTION_TYPE
	(
		CAUTION_TYPE,
		DETAIL,
		IS_ACTIVE,
		RECORD_EMP,
		RECORD_IP,
		RECORD_DATE
	)
	VALUES
	(
		'#caution_type#',
		'#DETAIL#',
		<cfif isdefined('attributes.is_active')>1<cfelse>0</cfif>,
		#SESSION.EP.USERID#,
		'#CGI.REMOTE_ADDR#',
		#NOW()#
	)
</cfquery>
<script type="text/javascript">
  wrk_opener_reload();
  window.close();
</script>
