<cfif len(attributes.STARTDATE_IF_ACCEPTED)>
	<cf_date tarih="attributes.STARTDATE_IF_ACCEPTED">
<cfelse>
	<cfset attributes.STARTDATE_IF_ACCEPTED = "NULL">
</cfif>
<cfquery name="get_notice" datasource="#dsn#">
	SELECT
		NOTICE_HEAD,
		POSITION_ID,
		POSITION_NAME,
		POSITION_CAT_ID,
		POSITION_CAT_NAME,
		COMPANY_ID,
		COMPANY,
		OUR_COMPANY_ID,
		DEPARTMENT_ID,
		BRANCH_ID
	FROM
		NOTICES
	WHERE
		NOTICE_ID=#attributes.notice_id#
</cfquery>
<cfquery name="upd_app_pos" datasource="#dsn#">
	UPDATE
		EMPLOYEES_APP_POS
	SET
		SALARY_WANTED=<cfif len(attributes.salary_wanted)>#attributes.salary_wanted#<cfelse>NULL</cfif>,
		SALARY_WANTED_MONEY='#attributes.salary_wanted_money#',
		STARTDATE_IF_ACCEPTED=#attributes.startdate_if_accepted#,
		DETAIL='#attributes.detail_app#',
		UPDATE_DATE = #NOW()#,
		UPDATE_EMP = #session.ep.userid#,
		UPDATE_IP = '#CGI.REMOTE_ADDR#'
	WHERE
		APP_POS_ID = #attributes.app_id#			
</cfquery>
<script type="text/javascript">
	wrk_opener_reload();
	window.close();
</script>
