<cfquery name="add_prize_type" datasource="#dsn#">
  INSERT INTO
    SETUP_PRIZE_TYPE
	(
		PRIZE_TYPE,
		DETAIL,
		IS_ACTIVE,
		RECORD_DATE,
		RECORD_EMP,
		RECORD_IP
	)
	VALUES
	(
		'#prize_type#',
		'#DETAIL#',
		<cfif isdefined('attributes.is_active')>1<cfelse>0</cfif>,
		#NOW()#,
		#SESSION.EP.USERID#,
		'#CGI.REMOTE_ADDR#'
	)
</cfquery>
<script type="text/javascript">
	location.href = document.referrer;
</script>
