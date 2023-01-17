<cf_date tarih='attributes.startdate'>
	<cfif len(attributes.finishdate)>
		<cf_date tarih='attributes.finishdate'>
		<cfset fark_ = datediff("d",attributes.startdate,attributes.finishdate)>
	</cfif>
	
<cfif len(attributes.finishdate)>
	<cfquery name="control_" datasource="#dsn#">
		SELECT START_DATE FROM EMPLOYEES_IN_OUT_REAL WHERE START_DATE <= #attributes.finishdate# AND FINISH_DATE >= #attributes.startdate# AND REAL_ID <> #attributes.real_id# AND EMPLOYEE_ID = #attributes.employee_id#
	</cfquery>
	<cfif control_.recordcount>
		<script type="text/javascript">
			alert("<cf_get_lang no ='1735.Aynı Tarihe 2 Giriş Yapamazsınız'>!");
			history.back();
		</script>
		<cfabort>
	</cfif>
<cfelse>
	<cfquery name="control_" datasource="#dsn#">
		SELECT START_DATE FROM EMPLOYEES_IN_OUT_REAL WHERE FINISH_DATE IS NULL AND REAL_ID <> #attributes.real_id# AND EMPLOYEE_ID = #attributes.employee_id#
	</cfquery>
	<cfif control_.recordcount>
		<script type="text/javascript">
			alert("<cf_get_lang no ='1736.Bitiş Tarihi Olmayan 2 Giriş Yapamazsınız'>!");
			history.back();
		</script>
		<cfabort>
	</cfif>
</cfif>

<cfquery name="upd_in_out_real" datasource="#dsn#">
	UPDATE
		EMPLOYEES_IN_OUT_REAL
	SET
		EMPLOYEE_ID = #attributes.employee_id#,
		BRANCH_NAME = '#attributes.branch_name#',
		BRANCH_ID = #attributes.branch_id#,
        START_DATE = #attributes.startdate#,
		FINISH_DATE = <cfif len(attributes.finishdate)>#attributes.finishdate#<cfelse>NULL</cfif>,
		WORKED_DAY = <cfif len(attributes.worked_day)>#attributes.worked_day#<cfelseif len(attributes.finishdate)>#fark_#<cfelse>NULL</cfif>,
		UPDATE_EMP = #session.ep.userid#,
		UPDATE_IP = '#cgi.REMOTE_ADDR#',
		UPDATE_DATE = #now()#
	WHERE
		REAL_ID = #attributes.real_id#
</cfquery>
<script type="text/javascript">
	opener.window.location.reload();
	window.close();
</script>
