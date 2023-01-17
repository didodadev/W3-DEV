<cfquery name="insert_stages" datasource="#dsn#"> 
	INSERT 
	INTO SETUP_MEMBERSHIP_STAGES
	(
	  TR_NAME, 
	  TR_DETAIL,
	  RECORD_DATE,
	  RECORD_EMP,
	  RECORD_IP
	) 
	  VALUES 
	(
	  <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.tr_name#">,
	  <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.tr_detail#">,
	   #now()#,
	   #session.ep.userid#,
	  '#cgi.REMOTE_ADDR#'
	 )
</cfquery>
<script type="text/javascript">
	window.location='<cfoutput>#request.self#?fuseaction=crm.list_membership_stages</cfoutput>';
</script>
