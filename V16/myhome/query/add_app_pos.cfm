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
<cfquery name="add_app_pos" datasource="#dsn#">
	INSERT INTO
		EMPLOYEES_APP_POS
		(
			EMPAPP_ID,
			NOTICE_ID,
			POSITION_ID,
			POSITION_CAT_ID,
			APP_DATE,
			COMPANY_ID,
			OUR_COMPANY_ID,
			DEPARTMENT_ID,
			BRANCH_ID,
			SALARY_WANTED,
			SALARY_WANTED_MONEY,
			STARTDATE_IF_ACCEPTED,
			APP_POS_STATUS,
			DETAIL,
			COMMETHOD_ID,
			IS_INTERNAL,
			RECORD_DATE,
			RECORD_EMP,
			RECORD_IP
		)
		VALUES(
			#attributes.empapp_id#,
			#attributes.notice_id#,
			<cfif len(get_notice.POSITION_ID)>#get_notice.POSITION_ID#,<cfelse>NULL,</cfif>
			<cfif len(get_notice.POSITION_CAT_ID)>#get_notice.POSITION_CAT_ID#,<cfelse>NULL,</cfif>
			#CreateODBCDateTime(now())#,
			<cfif len(get_notice.COMPANY_ID)>#get_notice.COMPANY_ID#,<cfelse>NULL,</cfif>
			<cfif len(get_notice.OUR_COMPANY_ID)>#get_notice.OUR_COMPANY_ID#,<cfelse>NULL,</cfif>
			<cfif len(get_notice.DEPARTMENT_ID)>#get_notice.DEPARTMENT_ID#,<cfelse>NULL,</cfif>
			<cfif len(get_notice.BRANCH_ID)>#get_notice.BRANCH_ID#,<cfelse>NULL,</cfif>
			<cfif len(attributes.salary_wanted)>#attributes.salary_wanted#<cfelse>NULL</cfif>,
			'#attributes.salary_wanted_money#',
			#attributes.startdate_if_accepted#,
			'1',
			'#attributes.detail_app#',
			6,
			1,
			#NOW()#,
			#session.ep.userid#,
			'#CGI.REMOTE_ADDR#'
		)
</cfquery>
<script type="text/javascript">
	alert("<cf_get_lang no ='1211.Başvurunuz Kaydedilmiştir Başvurularım Bölümünden Takip Edebilirsiniz'>");
	window.close();
	opener.window.close();
</script>
