<cfquery name="del_ld_company_records" datasource="#dsn#">
	DELETE FROM
		OUR_COMPANY_HOURS
	WHERE
		OUR_COMPANY_ID = #ATTRIBUTES.OUR_COMPANY_ID#
</cfquery>

<cfquery name="add_our_company_work_hours" datasource="#dsn#">
	INSERT INTO
		OUR_COMPANY_HOURS
		(
			OUR_COMPANY_ID,
			DAILY_WORK_HOURS,
			SATURDAY_WORK_HOURS,
			SSK_MONTHLY_WORK_HOURS,
			SSK_WORK_HOURS,
			WEEKLY_OFFDAY,
			SATURDAY_OFF,
            START_HOUR,
            START_MIN,
            END_HOUR,
            END_MIN,
			RECORD_DATE,
			RECORD_IP,
			RECORD_EMP,
			UPDATE_DATE,
			UPDATE_IP,
			UPDATE_EMP		
		)
		VALUES
		(
			#ATTRIBUTES.OUR_COMPANY_ID#,
			#ATTRIBUTES.DAILY_WORK_HOURS#,
			#ATTRIBUTES.SATURDAY_WORK_HOURS#,
			#ATTRIBUTES.SSK_MONTHLY_WORK_HOURS#,
			#ATTRIBUTES.SSK_WORK_HOURS#,
			#attributes.weekly_offday#, <!--- DB'de alanın tipi: tinyint, default değeri: 1 (Pazar) olarak belirlendi. --->
			<cfif isdefined("attributes.saturday_off")>1<cfelse>0</cfif>,
            #attributes.start_hour#,
            #attributes.start_min#,
            #attributes.end_hour#,
            #attributes.end_min#,
			#NOW()#,
			'#CGI.REMOTE_ADDR#',
			#SESSION.EP.USERID#,
			#NOW()#,
			'#CGI.REMOTE_ADDR#',
			#SESSION.EP.USERID#
		)
</cfquery>

<script type="text/javascript">
	window.location.href='<cfoutput>#request.self#?fuseaction=ehesap.hours</cfoutput>';
</script>
