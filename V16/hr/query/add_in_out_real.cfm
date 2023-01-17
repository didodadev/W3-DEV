<cf_date tarih='attributes.startdate'>
	<cfif len(attributes.finishdate)>
		<cf_date tarih='attributes.finishdate'>
		<cfset fark_ = datediff("d",attributes.startdate,attributes.finishdate)>
	</cfif>

<cfif len(attributes.finishdate)>
	<cfquery name="control_" datasource="#dsn#">
		SELECT START_DATE FROM EMPLOYEES_IN_OUT_REAL WHERE START_DATE <= #attributes.finishdate# AND FINISH_DATE >= #attributes.startdate# AND EMPLOYEE_ID = #attributes.employee_id#
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
		SELECT START_DATE FROM EMPLOYEES_IN_OUT_REAL WHERE FINISH_DATE IS NULL AND EMPLOYEE_ID = #attributes.employee_id#
	</cfquery>
	<cfif control_.recordcount>
		<script type="text/javascript">
			alert("<cf_get_lang no ='1736.Bitiş Tarihi Olmayan 2 Giriş Yapamazsınız'>!");
			history.back();
		</script>
		<cfabort>
	</cfif>
</cfif>


<cfquery name="add_in_out_real" datasource="#dsn#">
	INSERT INTO
		EMPLOYEES_IN_OUT_REAL
		(
			EMPLOYEE_ID,
			BRANCH_NAME,
            BRANCH_ID,
			START_DATE,
			FINISH_DATE,
			WORKED_DAY,
			RECORD_EMP,
			RECORD_IP,
			RECORD_DATE
		)
	VALUES
		(
			#attributes.employee_id#,
			'#attributes.branch_name#',
            #attributes.branch_id#,
			#attributes.startdate#,
			<cfif len(attributes.finishdate)>#attributes.finishdate#<cfelse>NULL</cfif>,
			<cfif len(attributes.worked_day)>#attributes.worked_day#<cfelseif len(attributes.finishdate)>#fark_#<cfelse>NULL</cfif>,
			#session.ep.userid#,
			'#cgi.REMOTE_ADDR#',
			#now()#
		)
</cfquery>
<script type="text/javascript">
	opener.window.location.reload();
	window.close();
</script>
