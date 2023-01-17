<cfif isdefined("attributes.amir_valid_1") and attributes.amir_valid_1 eq -1><!---onaylar iptal edildi ise--->
	<cfquery name="upd_perf_stage" datasource="#dsn#">
		UPDATE PERF_MEET_FORM SET
			EMPLOYEE_ID = #attributes.employee_id#,
			FIRST_BOSS_VALID =NULL,
			FIRST_BOSS_VALID_DATE=NULL,
			SECOND_BOSS_VALID = NULL,
			SECOND_BOSS_VALID_DATE=NULL,
			THIRD_BOSS_VALID =NULL,
			THIRD_BOSS_VALID_DATE=NULL,
			FOURTH_BOSS_VALID =NULL,
			FOURTH_BOSS_VALID_DATE=NULL,
			FIFTH_BOSS_VALID =NULL,
			FIFTH_BOSS_VALID_DATE=NULL,
			SIXTH_BOSS_VALID =NULL,
			SIXTH_BOSS_VALID_DATE=NULL,
			UPDATE_DATE = #now()#,
			UPDATE_IP = '#CGI.REMOTE_ADDR#',
			UPDATE_EMP = #session.ep.userid#
		WHERE
			FORM_ID = #attributes.form_id#
	</cfquery>
<cfelse>

	<cfif isdefined("attributes.start_date") and isdate(attributes.start_date)>
		<cf_date tarih='attributes.start_date'>
	</cfif>
	<cfif isdefined("attributes.finish_date") and isdate(attributes.finish_date)>
		<cf_date tarih='attributes.finish_date'>
	</cfif>
	<cfif isdefined("attributes.start_date") and isdefined("attributes.finish_date")>
		<cfquery name="check_form" datasource="#dsn#">
			SELECT
				FORM_ID
			FROM
				PERF_MEET_FORM
			WHERE
				EMPLOYEE_ID = #attributes.employee_id# AND
				FORM_ID <> #attributes.form_id# AND
				(
				(START_DATE <= #attributes.start_date# AND
				FINISH_DATE >= #attributes.start_date#)
				 OR
				(START_DATE <= #attributes.finish_date# AND
				FINISH_DATE >= #attributes.finish_date#)
				)
		</cfquery>
		<cfif check_form.recordcount>
			<script type="text/javascript">
				alert("<cf_get_lang no ='1738.Seçtiğiniz Kişi İçin Bu Tarihler Arasında Doldurulmuş Bir Form Var'> !");
				history.back();
			</script>
			<cfabort>
		</cfif>
	</cfif>
	<cfscript>
	//amirlerden aradan biri silindi ise altındakileri yukarı doğru kaydırıyor
	for(i=1;i lte 5;i=i+1)
	{
		//onaylandi ise posizyondaki calisan degismis olabilecigi icin session.ep.useridsi onay verdigi amir emp_id si olarak yaziyor
		if(isdefined('attributes.amir_valid_#i#') and evaluate('attributes.amir_valid_#i#') eq 1)
			'attributes.amir_id_#i#'=session.ep.userid;
		
		if(isdefined('attributes.amir_name_#i#') and not len(evaluate('attributes.amir_name_#i#')))
		{
			'attributes.amir_id_#i#'='';
			'attributes.amir_code_#i#'='';
			'attributes.amir_name_#i#'='';
			if(isdefined('attributes.amir_valid_#i#'))'attributes.amir_valid_#i#'='';
			for(j=i+1;j lte 5;j=j+1){
				if(len(evaluate('attributes.amir_name_#j#')))
				{
					'attributes.amir_id_#i#'=evaluate('attributes.amir_id_#j#');
					'attributes.amir_code_#i#'=evaluate('attributes.amir_code_#j#');
					'attributes.amir_name_#i#'=evaluate('attributes.amir_name_#j#');
					if(isdefined('attributes.amir_valid_#j#'))'attributes.amir_valid_#i#'=evaluate('attributes.amir_valid_#j#');
					'attributes.amir_id_#j#'='';
					'attributes.amir_code_#j#'='';
					'attributes.amir_name_#j#'='';
					if(isdefined('attributes.amir_valid_#j#'))'attributes.amir_valid_#j#'='';
					break;
				}
			}
		}
	}
	</cfscript>	
	<CFTRANSACTION>
		<cfquery name="upd_perf" datasource="#dsn#">
			UPDATE PERF_MEET_FORM SET
				EMPLOYEE_ID = #attributes.employee_id#,
			<cfif isdefined("attributes.amir_name_1")>
				<cfif len(attributes.amir_name_1) and isdefined("attributes.amir_id_1") and len(attributes.amir_id_1)>FIRST_BOSS_ID = #attributes.amir_id_1#,<cfelse>FIRST_BOSS_ID = NULL,</cfif>
				<cfif len(attributes.amir_name_1) and isdefined("attributes.amir_code_1") and len(attributes.amir_code_1)>FIRST_BOSS_CODE = #attributes.amir_code_1#,<cfelse>FIRST_BOSS_CODE = NULL,</cfif>
				FIRST_BOSS_VALID = <cfif isdefined("attributes.amir_valid_1") and len(attributes.amir_valid_1)>1<cfelse>NULL</cfif>,
				<cfif isdefined("attributes.amir_valid_1") and attributes.amir_valid_1 neq 2>FIRST_BOSS_VALID_DATE=<cfif len(attributes.amir_valid_1)>#NOW()#<cfelse>NULL</cfif>,</cfif>
			</cfif>
			<cfif isdefined("attributes.amir_name_2")>
				<cfif len(attributes.amir_name_2) and isdefined("attributes.amir_id_2") and len(attributes.amir_id_2)>SECOND_BOSS_ID = #attributes.amir_id_2#,<cfelse>SECOND_BOSS_ID = NULL,</cfif>
				<cfif len(attributes.amir_name_2) and isdefined("attributes.amir_code_2") and len(attributes.amir_code_2)>SECOND_BOSS_CODE = #attributes.amir_code_2#,<cfelse>SECOND_BOSS_CODE = NULL,</cfif>
				SECOND_BOSS_VALID = <cfif isdefined("attributes.amir_valid_2") and len(attributes.amir_valid_2)>1<cfelse>NULL</cfif>,
				<cfif isdefined("attributes.amir_valid_2") and attributes.amir_valid_2 neq 2>SECOND_BOSS_VALID_DATE=<cfif len(attributes.amir_valid_2)>#NOW()#<cfelse>NULL</cfif>,</cfif>
			</cfif>
			<cfif isdefined("attributes.amir_name_3")>
				<cfif len(attributes.amir_name_3) and isdefined("attributes.amir_id_3") and len(attributes.amir_id_3)>THIRD_BOSS_ID = #attributes.amir_id_3#,<cfelse>THIRD_BOSS_ID = NULL,</cfif>
				<cfif len(attributes.amir_name_3) and isdefined("attributes.amir_code_3") and len(attributes.amir_code_3)>THIRD_BOSS_CODE = #attributes.amir_code_3#,<cfelse>THIRD_BOSS_CODE = NULL,</cfif>
				THIRD_BOSS_VALID = <cfif isdefined("attributes.amir_valid_3") and len(attributes.amir_valid_3)>1<cfelse>NULL</cfif>,
				<cfif isdefined("attributes.amir_valid_3") and attributes.amir_valid_3 neq 2>THIRD_BOSS_VALID_DATE=<cfif len(attributes.amir_valid_3)>#NOW()#<cfelse>NULL</cfif>,</cfif>
			</cfif>
			<cfif isdefined("attributes.amir_name_4")>
				<cfif len(attributes.amir_name_4) and isdefined("attributes.amir_id_4") and len(attributes.amir_id_4)>FOURTH_BOSS_ID = #attributes.amir_id_4#,<cfelse>FOURTH_BOSS_ID = NULL,</cfif>
				<cfif len(attributes.amir_name_4) and isdefined("attributes.amir_code_4") and len(attributes.amir_code_4)>FOURTH_BOSS_CODE = #attributes.amir_code_4#,<cfelse>FOURTH_BOSS_CODE = NULL,</cfif>
				FOURTH_BOSS_VALID = <cfif isdefined("attributes.amir_valid_4") and len(attributes.amir_valid_4)>1<cfelse>NULL</cfif>,
				<cfif isdefined("attributes.amir_valid_4") and attributes.amir_valid_4 neq 2>FOURTH_BOSS_VALID_DATE=<cfif len(attributes.amir_valid_4)>#NOW()#<cfelse>NULL</cfif>,</cfif>
			</cfif>
			<cfif isdefined("attributes.amir_name_5")>
				<cfif len(attributes.amir_name_5) and isdefined("attributes.amir_id_5") and len(attributes.amir_id_5)>FIFTH_BOSS_ID = #attributes.amir_id_5#,<cfelse>FIFTH_BOSS_ID =NULL,</cfif>
				<cfif len(attributes.amir_name_5) and isdefined("attributes.amir_code_5") and len(attributes.amir_code_5)>FIFTH_BOSS_CODE = #attributes.amir_code_5#,<cfelse>FIFTH_BOSS_CODE =NULL,</cfif>
				FIFTH_BOSS_VALID = <cfif isdefined("attributes.amir_valid_5") and len(attributes.amir_valid_5)>1<cfelse>NULL</cfif>,
				<cfif isdefined("attributes.amir_valid_5") and attributes.amir_valid_5 neq 2>FIFTH_BOSS_VALID_DATE=<cfif len(attributes.amir_valid_5)>#NOW()#<cfelse>NULL</cfif>,</cfif>
			</cfif>
								
				<cfif isdefined("attributes.start_date")>START_DATE = #attributes.start_date#,</cfif>
				<cfif isdefined("attributes.finish_date")>FINISH_DATE = #attributes.finish_date#,</cfif>
				<cfif isdefined("attributes.emp_comment")>EMPLOYEES_COMMENT = '#attributes.emp_comment#',</cfif>
				<cfif isdefined("attributes.boss_comment_1")>FIRST_BOSS_COMMENT_1 = '#attributes.boss_comment_1#',</cfif>
				<cfif isdefined("attributes.boss_comment_2")>FIRST_BOSS_COMMENT_2 = '#attributes.boss_comment_2#',</cfif>
				<cfif isdefined("attributes.boss_comment_3")>FIRST_BOSS_COMMENT_3 = '#attributes.boss_comment_3#',</cfif>
				<cfif isdefined("attributes.boss_comment_4")>FIRST_BOSS_COMMENT_4 = '#attributes.boss_comment_4#',</cfif>
				<cfif isdefined("attributes.boss_comment_5")>FIRST_BOSS_COMMENT_5 = '#attributes.boss_comment_5#',</cfif>
				UPDATE_DATE = #now()#,
				UPDATE_IP = '#CGI.REMOTE_ADDR#',
				UPDATE_EMP = #session.ep.userid#
			WHERE
				FORM_ID = #attributes.form_id#
		</cfquery>
	</CFTRANSACTION>
</cfif>
<!--- <script type="text/javascript">
	wrk_opener_reload();
	//window.close();
</script> --->
<cflocation url="#request.self#?fuseaction=hr.popup_upd_perf_meet_form&form_id=#attributes.form_id#" addtoken="no">
