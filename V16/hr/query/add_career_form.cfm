<cfset offer_date1='01/#attributes.offer_month1#/#attributes.offer_year1#'>
<cf_date tarih=offer_date1>
<cfset offer_date2='01/#attributes.offer_month2#/#attributes.offer_year2#'>
<cf_date tarih=offer_date2>
<cfset offer_date3='01/#attributes.offer_month3#/#attributes.offer_year3#'>
<cf_date tarih=offer_date3>

<CFTRANSACTION>
	<cfquery name="add_perf_form" datasource="#dsn#">
		INSERT INTO PERF_CAREER_FORM
			(
				MEET_FORM_ID,
				EMPLOYEE_ID,
				POSITION_FIT,
				APPOINTMENT_POTENTIAL,
				APPOINTMENT_POTENTIAL_DETAIL,
				OFFER_DATE1,
				WORK_CONTENT1,
				PROBLEM1,
				OFFER_DATE2,
				WORK_CONTENT2,
				PROBLEM2,
				OFFER_DATE3,
				WORK_CONTENT3,
				PROBLEM3,
				RECORD_DATE,
				RECORD_IP,
				RECORD_EMP
			)
			VALUES
			(
				#attributes.meet_form_id#,
				#attributes.employee_id#,
				'#attributes.position_fit#',
				#attributes.appointment_potential#,
				'#attributes.appointment_potential_detail#',
				<cfif len(offer_date1)>#offer_date1#<cfelse>NULL</cfif>,
				'#attributes.work_content1#',
				'#attributes.problem1#',
				<cfif len(offer_date2)>#offer_date2#<cfelse>NULL</cfif>,
				'#attributes.work_content2#',
				'#attributes.problem2#',
				<cfif len(offer_date3)>#offer_date3#<cfelse>NULL</cfif>,
				'#attributes.work_content3#',
				'#attributes.problem3#',
				#now()#,
				'#CGI.REMOTE_ADDR#',
				#session.ep.userid#
			)	
	</cfquery>
</CFTRANSACTION>
<script type="text/javascript">
	wrk_opener_reload();
	window.close();
</script>
