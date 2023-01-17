<cf_date tarih='attributes.insurance_start_date'>
<cf_date tarih='attributes.insurance_finish_date'>
<cfquery name="ADD_ASSET_INSURANCE" datasource="#DSN#">
	INSERT INTO
    	ASSET_P_INSURANCE
    (
        ASSETP_ID,
        INSURANCE_NAME_ID,
        POLICY_NO,
        INSURANCE_COMPANY,
        INSURANCE_START_DATE,
        INSURANCE_FINISH_DATE,
        DETAIL,
		INSURANCE_TOTAL,
        RECORD_DATE,
        RECORD_IP,
        RECORD_EMP
    )
	VALUES
    (
    	#attributes.assetp_id#,
        #attributes.insurance_name_id#,
        '#attributes.policy_no#',
        #attributes.company_id#,
	    <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.insurance_start_date#">,
        <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.insurance_finish_date#">,
        '#attributes.detail#',
		<cfqueryparam cfsqltype="cf_sql_float" value="#attributes.insurance_total#">,
        #now()#,
        '#CGI.REMOTE_ADDR#',
        #session.ep.userid#
    )
</cfquery>

<script type="text/javascript">
	location.href = document.referrer;
</script>
