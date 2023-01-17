<cf_date tarih="attributes.insurance_start_date">
<cf_date tarih="attributes.insurance_finish_date">
<cfquery name="ADD_ASSET_INSURANCE" datasource="#DSN#">
	UPDATE
    	ASSET_P_INSURANCE
	SET
        INSURANCE_NAME_ID = #attributes.insurance_name_id#,
        POLICY_NO = '#attributes.policy_no#',
        INSURANCE_COMPANY = #attributes.company_id#,
        INSURANCE_START_DATE = #CreateOdbcDateTime(attributes.insurance_start_date)#,
        INSURANCE_FINISH_DATE = #CreateOdbcDateTime(attributes.insurance_finish_date)#,
        DETAIL = '#attributes.detail#',
		INSURANCE_TOTAL = <cfqueryparam cfsqltype="cf_sql_float" value="#attributes.insurance_total#">,
        UPDATE_DATE = #now()#,
        UPDATE_IP = '#cgi.remote_addr#',
        UPDATE_EMP = #session.ep.userid#
	WHERE
		INSURANCE_ID = #attributes.insurance_id#
</cfquery>
<script type="text/javascript">
	location.href = document.referrer;
</script>
