<cfquery name="INSERT_CORP" datasource="#DSN#"> 
	INSERT INTO 
		SETUP_CORPORATIONS
    (
        CORPORATION_CODE,
        CORPORATION_NAME,
        CORPORATION_DETAIL,
        RECORD_IP,
        RECORD_DATE,
        RECORD_EMP
    ) 
    VALUES 
    (
        <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.corp_code#">,
        <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.corp_name#">,
        <cfif len(attributes.corp_detail)><cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.corp_detail#"><cfelse>NULL</cfif>,
        '#cgi.remote_addr#',
        #now()#,
        #session.ep.userid#
    )
</cfquery>
<script type="text/javascript">
	wrk_opener_reload();
	self.close();
</script>

