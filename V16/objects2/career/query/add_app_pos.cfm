<cfif not isdefined("session.cp.userid")>
	<cflocation url="#request.self#?fuseaction=objects2.kariyer_login" addtoken="no">
</cfif>
<cfif len(attributes.startdate_if_accepted)>
	<cf_date tarih="attributes.startdate_if_accepted">
<cfelse>
	<cfset attributes.startdate_if_accepted = "NULL">
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
		NOTICE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.notice_id#">
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
			RECORD_DATE
		)
		VALUES(
			#session.cp.userid#,
			#attributes.notice_id#,
			<cfif len(get_notice.POSITION_ID)>#get_notice.POSITION_ID#,<cfelse>NULL,</cfif>
			<cfif len(get_notice.POSITION_CAT_ID)>#get_notice.POSITION_CAT_ID#,<cfelse>NULL,</cfif>
			#NOW()#,
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
			#NOW()#
		)
</cfquery>

<cfquery name="GET_MAIL" datasource="#dsn#">
	SELECT EMAIL FROM EMPLOYEES_APP WHERE EMPAPP_ID= <cfqueryparam cfsqltype="cf_sql_integer" value="#session.cp.userid#">
</cfquery>
<cfquery name="get_info" datasource="#dsn#">
	SELECT EMAIL FROM OUR_COMPANY_INFO WHERE COMP_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.cp.our_company_id#">
</cfquery>
<cfmail to="#GET_MAIL.EMAIL#" from="#get_info.email#" subject="Başvurunuz Alınmıştır" type="html" charset="utf-8">

<head>
<title>Workcube | Şifre Hatırlatma</title>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<link href="http://www.workcube.com.tr/haberler/e-bulten/css/ebulten.css" rel="stylesheet" type="text/css">
</head>
<body> 
<table>
	<tr>
		<td>
			<cfquery name="CHECK" datasource="#DSN#">
			SELECT ASSET_FILE_NAME1,EMAIL FROM OUR_COMPANY WHERE <cfif isDefined("session.cp.our_company_id")>COMP_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.cp.our_company_id#"></cfif>
			</cfquery>
			<cfif len(CHECK.asset_file_name1)><cfoutput><img src="#user_domain##file_web_path#settings/#CHECK.asset_file_name1#" border="0" title="<cf_get_lang_main no='1225.Logo'>" alt="<cf_get_lang_main no='1225.Logo'>"/></cfoutput></cfif>
		</td>
	</tr>
	<tr>
		<td>İnsan Kaynakları İş Başvurunuz hakkında</td>
	</tr>
	<tr>
		<td>İlan: <cfoutput>#get_notice.notice_head#</cfoutput></td>
	</tr>
	<tr>
		<td><span>Sayın;</span><span> <cfoutput>#session.cp.name# #session.cp.surname#</cfoutput></span></td>
	</tr>
	<tr>
		<td>
			ilanına yaptığınız başvurunuz tarafımıza ulaşmıştır.
			Yaptığınız başvuruları ve cevaplarını / sonuçlarını üye sayfanızdaki ‘Başvurularım’ bölümünden takip edebilirsiniz.
			<br/>Şirketimize gösterdiğiniz ilgi için teşekkür ederiz.</p>
		</td>
	</tr>
	<tr>
		<td><cfif len(check.email)>#check.email#</cfif></td>
	</tr>
</table>		
</body>
</html>
</cfmail>
<script type="text/javascript">
	window.close();
	wrk_opener_reload();
</script>
