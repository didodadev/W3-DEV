<cfquery name="insert_ims_codes" datasource="#dsn#"> 
	INSERT INTO 
		SETUP_IMS_CODE
    (
        IMS_CODE,
        IMS_CODE_NAME,
        IMS_CODE_501,
        IMS_CODE_501_NAME,
        IMS_CODE_DESC,
        RECORD_IP,
        RECORD_DATE,
        RECORD_EMP
    ) 
    VALUES 
    (
        <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.ims_code#">,
        <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.ims_name#">,
        <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.ims_code_501#">,
        <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.ims_name_501#">,
        <cfif len(attributes.ims_desc)><cfqueryparam cfsqltype="cf_sql_varchar" value="#left(attributes.ims_desc,250)#"><cfelse>null</cfif>,
      	<cfqueryparam cfsqltype="cf_sql_varchar" value="#cgi.remote_addr#">,
        <cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">,
        <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.userid#">
    )
</cfquery>
<script type="text/javascript">
  <cfif isDefined("attributes.modal_id") and len(attributes.modal_id)>
		location.href = document.referrer;
	<cfelse>
		wrk_opener_reload();
		self.close();
	</cfif>
</script>

