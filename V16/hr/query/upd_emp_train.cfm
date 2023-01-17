<cfquery name="DETAIL_EXISTS" datasource="#DSN#">
	SELECT 
		EMPLOYEE_DETAIL_ID
	FROM 
		EMPLOYEES_DETAIL 
	WHERE 
		EMPLOYEE_ID = #attributes.EMPLOYEE_ID#
</cfquery>
<cfif detail_exists.recordcount>
	<cfquery name="upd_emp_det" datasource="#DSN#">
		UPDATE
			EMPLOYEES_DETAIL
		SET
			UPDATE_DATE = #now()#,
			UPDATE_IP = '#cgi.remote_addr#',
			UPDATE_EMP = #session.ep.userid#,
			LAST_SCHOOL=<cfif len(attributes.last_school)>#attributes.last_school#<cfelse>NULL</cfif>,
			EDU4_DIPLOMA_NO = <cfif len(attributes.edu4_diploma_no)>'#attributes.edu4_diploma_no#'<cfelse>NULL</cfif>
		WHERE
			EMPLOYEE_DETAIL_ID = #DETAIL_EXISTS.EMPLOYEE_DETAIL_ID#
	</cfquery>
<cfelse>
	<cfquery name="add_emp_det" datasource="#DSN#">
		INSERT INTO
			EMPLOYEES_DETAIL
			(
				EMPLOYEE_ID, 
				<cfif len(attributes.last_school)>LAST_SCHOOL,</cfif>
				<cfif len(attributes.edu4_diploma_no)>'#attributes.edu4_diploma_no#',</cfif>
				#now()#,
				'#cgi.REMOTE_ADDR#',
				#session.ep.userid#
			)
	</cfquery>
</cfif>
<cfquery name="delete_emp_cour" datasource="#dsn#">
	DELETE EMPLOYEES_COURSE WHERE EMPLOYEE_ID=#attributes.EMPLOYEE_ID#
</cfquery>
<!--- Eğitim Bilgileri --->
<cfloop from="1" to="#attributes.emp_ex_course#" index="z">
	<cfif isdefined('attributes.del_course_prog#z#') and  evaluate('attributes.del_course_prog#z#') eq 1><!--- silinmemiş ise.. --->
		<cfif len(evaluate('attributes.kurs1_yil#z#')) and len(evaluate('attributes.kurs1_#z#'))>
			<cfquery name="add_employees_course" datasource="#dsn#">
				INSERT INTO
					EMPLOYEES_COURSE
				(
					EMPLOYEE_ID,
					COURSE_SUBJECT,
					COURSE_EXPLANATION,
					COURSE_YEAR,
					COURSE_LOCATION,
					COURSE_PERIOD
				)
					VALUES
				( 
					#attributes.EMPLOYEE_ID#,
					'#wrk_eval('attributes.kurs1_#z#')#',
					'#wrk_eval('attributes.kurs1_exp#z#')#',
					{ts '#evaluate('attributes.kurs1_yil#z#')#-01-01 00:00:00'},
					<cfif len(wrk_eval('attributes.kurs1_yer#z#'))>'#wrk_eval('attributes.kurs1_yer#z#')#'<cfelse>NULL</cfif>,
					<cfif len(wrk_eval('attributes.kurs1_gun#z#'))>'#wrk_eval('attributes.kurs1_gun#z#')#'<cfelse>NULL</cfif>
			  	) 
			</cfquery>
		</cfif>
	</cfif>
</cfloop>
 
<!---  </cfif>  --->
<!--- Ekstra Kurs Bilgi --->
<!--- İş Tecrübeleri --->
<cfloop from="1" to="#attributes.row_count#" index="k">
	 <cfif isdefined("attributes.row_kontrol#k#") and evaluate("attributes.row_kontrol#k#")>
	 	<cfif len(evaluate('attributes.exp_start#k#'))>
			<cfset attributes.exp_start=evaluate('attributes.exp_start#k#')>
			<cf_date tarih="attributes.exp_start">
		<cfelse>
			<cfset attributes.exp_start="">
		</cfif>
		<cfif len(evaluate('attributes.exp_finish#k#'))>
			<cfset attributes.exp_finish=evaluate('attributes.exp_finish#k#')>
			<cf_date tarih="attributes.exp_finish">
		<cfelse>
			<cfset attributes.exp_finish="">
		</cfif>
		<cfif len(attributes.exp_start) gt 9 and len(attributes.exp_finish) gt 9>
		   <cfset attributes.exp_fark = datediff("d",attributes.exp_start,attributes.exp_finish)>
		 <cfelse>
			<cfset attributes.exp_fark="">
		</cfif>
	 	<cfif isDefined("attributes.empapp_row_id#k#") and len(evaluate("attributes.empapp_row_id#k#"))>
			<cfquery name="UPD_EMPLOYEES_APP_WORK_INFO" datasource="#DSN#">
				UPDATE
					EMPLOYEES_APP_WORK_INFO
				SET
					EXP = <cfif len(evaluate('attributes.exp_name#k#'))>'#wrk_eval('attributes.exp_name#k#')#'<cfelse>NULL</cfif>,
					EXP_POSITION = <cfif len(evaluate('attributes.exp_position#k#'))>'#wrk_eval('attributes.exp_position#k#')#'<cfelse>NULL</cfif>,
					EXP_START = <cfif len(attributes.exp_start)>#attributes.exp_start#<cfelse>NULL</cfif>,
					EXP_FINISH = <cfif len(attributes.exp_finish)>#attributes.exp_finish#<cfelse>NULL</cfif>,
					EXP_FARK = <cfif len(attributes.exp_fark)>#attributes.exp_fark#<cfelse>NULL</cfif>,
					EXP_REASON = <cfif len(evaluate('attributes.exp_reason#k#'))>'#Replace(evaluate('attributes.exp_reason#k#'),"'"," ","all")#'<cfelse>NULL</cfif>,
					EXP_EXTRA = <cfif len(evaluate('attributes.exp_extra#k#'))>'#Replace(evaluate('attributes.exp_extra#k#'),"'"," ","all")#'<cfelse>NULL</cfif>,
					EXP_TELCODE = <cfif len(evaluate('attributes.exp_telcode#k#'))>'#wrk_eval('attributes.exp_telcode#k#')#'<cfelse>NULL</cfif>,
					EXP_TEL = <cfif len(evaluate('attributes.exp_tel#k#'))>'#wrk_eval('attributes.exp_tel#k#')#'<cfelse>NULL</cfif>,
					EXP_SECTOR_CAT= <cfif len(evaluate('attributes.exp_sector_cat#k#'))>#evaluate('attributes.exp_sector_cat#k#')#<cfelse>NULL</cfif>,
					EXP_SALARY = <cfif len(evaluate('attributes.exp_salary#k#')) and evaluate('attributes.exp_salary#k#') gt 0>#evaluate('attributes.exp_salary#k#')#<cfelse>NULL</cfif>,
					EXP_EXTRA_SALARY = <cfif len(evaluate('attributes.exp_extra_salary#k#')) and evaluate('attributes.exp_extra_salary#k#') gt 0>'#wrk_eval('attributes.exp_extra_salary#k#')#'<cfelse>NULL</cfif>,
					EXP_WORK_TYPE_ID = <cfif len(evaluate('attributes.exp_work_type_id#k#')) and evaluate('attributes.exp_work_type_id#k#') gt 0>'#wrk_eval('attributes.exp_work_type_id#k#')#'<cfelse>NULL</cfif>,
					EXP_TASK_ID = <cfif len(evaluate('attributes.exp_task_id#k#'))>#evaluate('attributes.exp_task_id#k#')#<cfelse>NULL</cfif>,
					EMPLOYEE_ID = #attributes.EMPLOYEE_ID#,
					IS_CONT_WORK= <cfif isdefined("attributes.is_cont_work#k#") and evaluate('attributes.is_cont_work#k#') eq 1>1<cfelse>0</cfif>
				WHERE
					EMPAPP_ROW_ID = #evaluate("attributes.empapp_row_id#k#")#
			</cfquery>
		<cfelse>
			<cfquery name="ADD_EMPLOYEES_APP_WORK_INFO" datasource="#dsn#">
				INSERT INTO
					EMPLOYEES_APP_WORK_INFO
					(
					EMPLOYEE_ID,
					EXP,
					EXP_POSITION,
					EXP_START,
					EXP_FINISH,
					EXP_FARK,
					EXP_REASON,
					EXP_EXTRA,
					EXP_TELCODE,
					EXP_TEL,
					EXP_SECTOR_CAT,
					EXP_SALARY,
					EXP_EXTRA_SALARY,
					EXP_WORK_TYPE_ID,
					EXP_TASK_ID,
					IS_CONT_WORK
					)
				VALUES
					(
					#attributes.EMPLOYEE_ID#,
					<cfif len(evaluate('attributes.exp_name#k#'))>'#wrk_eval('attributes.exp_name#k#')#'<cfelse>NULL</cfif>,
					<cfif len(evaluate('attributes.exp_position#k#'))>'#wrk_eval('attributes.exp_position#k#')#'<cfelse>NULL</cfif>,
					<cfif len(attributes.exp_start)>#attributes.exp_start#<cfelse>NULL</cfif>,
					<cfif len(attributes.exp_finish)>#attributes.exp_finish#<cfelse>NULL</cfif>,
					<cfif len(attributes.exp_fark)>#attributes.exp_fark#<cfelse>NULL</cfif>,
					<cfif len(evaluate('attributes.exp_reason#k#'))>'#Replace(evaluate('attributes.exp_reason#k#'),"'"," ","all")#'<cfelse>NULL</cfif>,
					<cfif len(evaluate('attributes.exp_extra#k#'))>'#Replace(evaluate('attributes.exp_extra#k#'),"'"," ","all")#'<cfelse>NULL</cfif>,
					<cfif len(evaluate('attributes.exp_telcode#k#'))>'#wrk_eval('attributes.exp_telcode#k#')#'<cfelse>NULL</cfif>,
					<cfif len(evaluate('attributes.exp_tel#k#'))>'#wrk_eval('attributes.exp_tel#k#')#'<cfelse>NULL</cfif>,
					<cfif len(evaluate('attributes.exp_sector_cat#k#'))>#evaluate('attributes.exp_sector_cat#k#')#<cfelse>NULL</cfif>,
					<cfif len(evaluate('attributes.exp_salary#k#')) and evaluate('attributes.exp_salary#k#') gt 0>#evaluate('attributes.exp_salary#k#')#<cfelse>NULL</cfif>,
					<cfif len(evaluate('attributes.exp_extra_salary#k#')) and evaluate('attributes.exp_extra_salary#k#') gt 0>'#wrk_eval('attributes.exp_extra_salary#k#')#'<cfelse>NULL</cfif>,
					<cfif len(evaluate('attributes.exp_work_type_id#k#')) and evaluate('attributes.exp_work_type_id#k#') gt 0>'#wrk_eval('attributes.exp_work_type_id#k#')#'<cfelse>NULL</cfif>,
					<cfif len(evaluate('attributes.exp_task_id#k#'))>#evaluate('attributes.exp_task_id#k#')#<cfelse>NULL</cfif>,
					<cfif isdefined("attributes.is_cont_work#k#") and evaluate('attributes.is_cont_work#k#') eq 1>1<cfelse>0</cfif>
					)
			</cfquery>
		</cfif>
	 <cfelse>
	 	<cfif isDefined("attributes.empapp_row_id#k#") and len(evaluate("attributes.empapp_row_id#k#"))>
	 		<cfquery name="del_empapp_work_info" datasource="#dsn#">
				DELETE FROM
					EMPLOYEES_APP_WORK_INFO
				WHERE
					EMPAPP_ROW_ID = #evaluate("attributes.empapp_row_id#k#")#
			</cfquery>
		</cfif>
	 </cfif>
</cfloop>
<!--- İş Tecrübeleri --->

<!--- Eğitim Bilgileri --->
<cfloop from="1" to="#attributes.row_edu#" index="j">
	<cfif isdefined("attributes.row_kontrol_edu#j#") and evaluate("attributes.row_kontrol_edu#j#")>
	<cf_date tarih="attributes.edu_start#j#">
	<cf_date tarih="attributes.edu_finish#j#">
	<cfif isdefined("attributes.edu_high_part_id#j#") and  len(evaluate('attributes.edu_high_part_id#j#')) <!---and evaluate('attributes.edu_type#j#') eq 3--->>
		<cfset bolum_id = evaluate('attributes.edu_high_part_id#j#')>
	<cfelseif isdefined("attributes.edu_part_id#j#") and len(evaluate('attributes.edu_part_id#j#')) >
		<cfset bolum_id = evaluate('attributes.edu_part_id#j#')>
	<cfelse>
		<cfset bolum_id = -1>
	</cfif>	
		<cfif isDefined("attributes.empapp_edu_row_id#j#") and len(evaluate("attributes.empapp_edu_row_id#j#"))>
			<cfquery name="UPD_EMPLOYEES_APP_EDU_INFO" datasource="#DSN#">
					UPDATE
						EMPLOYEES_APP_EDU_INFO
					SET
						EDU_TYPE = #evaluate('attributes.edu_type#j#')#,
						EDU_ID = <cfif isdefined("attributes.edu_id#j#") and len(evaluate('attributes.edu_id#j#'))>#evaluate('attributes.edu_id#j#')#<cfelse>-1</cfif>,
						EDU_NAME = <cfif isdefined("attributes.edu_name#j#") and len(evaluate('attributes.edu_name#j#'))>'#wrk_eval('attributes.edu_name#j#')#'<cfelse>NULL</cfif>,
						EDU_PART_ID = <cfif isdefined("bolum_id") and len(bolum_id)>#bolum_id#<cfelse>NULL</cfif>,
						EDU_PART_NAME = <cfif isdefined("attributes.edu_part_name#j#") and len(evaluate('attributes.edu_part_name#j#'))>'#wrk_eval('attributes.edu_part_name#j#')#'<cfelse>NULL</cfif>,
						EDU_START = <cfif isdefined("attributes.edu_start#j#") and len(evaluate('attributes.edu_start#j#'))>#evaluate('attributes.edu_start#j#')#<cfelse>NULL</cfif>,
						EDU_FINISH = <cfif isdefined("attributes.edu_finish#j#") and len(evaluate('attributes.edu_finish#j#'))>#evaluate('attributes.edu_finish#j#')#<cfelse>NULL</cfif>,
						EDU_RANK = <cfif isdefined("attributes.edu_rank#j#") and len(evaluate('attributes.edu_rank#j#'))>'#wrk_eval('attributes.edu_rank#j#')#'<cfelse>NULL</cfif>,
						EMPLOYEE_ID = #attributes.employee_id#,
						IS_EDU_CONTINUE= <cfif isdefined("attributes.is_edu_continue#j#") and evaluate('attributes.is_edu_continue#j#') eq 1>1<cfelse>0</cfif>,
						EDUCATION_LANG = <cfif isdefined("attributes.edu_lang#j#") and len(evaluate('attributes.edu_lang#j#'))>'#wrk_eval('attributes.edu_lang#j#')#'<cfelse>NULL</cfif>,
						EDUCATION_TIME = <cfif isdefined("attributes.education_time#j#") and len(evaluate('attributes.education_time#j#'))>'#wrk_eval('attributes.education_time#j#')#'<cfelse>NULL</cfif>,
						EDU_LANG_RATE = <cfif isdefined("attributes.edu_lang_rate#j#") and len(evaluate('attributes.edu_lang_rate#j#'))>'#wrk_eval('attributes.edu_lang_rate#j#')#'<cfelse>NULL</cfif>
					WHERE
						EMPAPP_EDU_ROW_ID = #evaluate("attributes.empapp_edu_row_id#j#")#
			</cfquery>
		<cfelse>
			<cfquery name="ADD_EMPLOYEES_APP_EDU_INFO" datasource="#dsn#">
				INSERT INTO
					EMPLOYEES_APP_EDU_INFO
					(
					EMPLOYEE_ID,
					EDU_TYPE,
					EDU_ID,
					EDU_NAME,
					EDU_PART_ID,
					EDU_PART_NAME,
					EDU_START,
					EDU_FINISH,
					EDU_RANK,
					IS_EDU_CONTINUE,
					EDUCATION_LANG,
					EDUCATION_TIME,
					EDU_LANG_RATE
					)
					VALUES
					(
					#attributes.employee_id#,
					#evaluate('attributes.edu_type#j#')#,
					<cfif isdefined("attributes.edu_id#j#") and len(evaluate('attributes.edu_id#j#'))>#evaluate('attributes.edu_id#j#')#<cfelse>-1</cfif>,
					<cfif isdefined("attributes.edu_name#j#") and len(evaluate('attributes.edu_name#j#'))>'#wrk_eval('attributes.edu_name#j#')#'<cfelse>NULL</cfif>,
					<cfif isdefined("bolum_id") and len(bolum_id)>#bolum_id#<cfelse>NULL</cfif>,
					<cfif isdefined("attributes.edu_part_name#j#") and len(evaluate('attributes.edu_part_name#j#'))>'#wrk_eval('attributes.edu_part_name#j#')#'<cfelse>NULL</cfif>,
					<cfif isdefined("attributes.edu_start#j#") and len(evaluate('attributes.edu_start#j#'))>#evaluate('attributes.edu_start#j#')#<cfelse>NULL</cfif>,
					<cfif isdefined("attributes.edu_finish#j#") and len(evaluate('attributes.edu_finish#j#'))>#evaluate('attributes.edu_finish#j#')#<cfelse>NULL</cfif>,
					<cfif isdefined("attributes.edu_rank#j#") and len(evaluate('attributes.edu_rank#j#'))>'#wrk_eval('attributes.edu_rank#j#')#'<cfelse>NULL</cfif>,
					<cfif isdefined("attributes.is_edu_continue#j#") and evaluate('attributes.is_edu_continue#j#') eq 1>1<cfelse>0</cfif>,
					<cfif isdefined("attributes.edu_lang#j#") and len(evaluate('attributes.edu_lang#j#'))>'#wrk_eval('attributes.edu_lang#j#')#'<cfelse>NULL</cfif>,
					<cfif isdefined("attributes.education_time#j#") and len(evaluate('attributes.education_time#j#'))>'#wrk_eval('attributes.education_time#j#')#'<cfelse>NULL</cfif>,
					<cfif isdefined("attributes.edu_lang_rate#j#") and len(evaluate('attributes.edu_lang_rate#j#'))>'#wrk_eval('attributes.edu_lang_rate#j#')#'<cfelse>NULL</cfif>
					)
			</cfquery>
		</cfif>
	<cfelse>
		<cfif isDefined("attributes.empapp_edu_row_id#j#") and len(evaluate("attributes.empapp_edu_row_id#j#"))>
			<cfquery name="del_empapp_edu_info" datasource="#dsn#">
				DELETE FROM
					EMPLOYEES_APP_EDU_INFO
				WHERE
					EMPAPP_EDU_ROW_ID = #evaluate("attributes.empapp_edu_row_id#j#")#
			</cfquery>
		</cfif>
	</cfif>
</cfloop>
<!--- Eğitim Bilgileri--->
<!--- Yabancı dil bilgileri--->
<cfquery name="delete_lang" datasource="#dsn#">
	DELETE EMPLOYEES_APP_LANGUAGE WHERE EMPLOYEE_ID = #attributes.EMPLOYEE_ID#
</cfquery>	
<cfloop from="1" to="#attributes.add_lang_info#" index="m">
	<cfif isdefined('attributes.del_lang_info#m#') and  evaluate('attributes.del_lang_info#m#') eq 1><!--- silinmemiş ise.. --->
		<cfset attributes.paper_date=evaluate('attributes.paper_date#m#')>
		<cf_date tarih="attributes.paper_date">
		<cfset attributes.paper_finish_date=evaluate('attributes.paper_finish_date#m#')>
		<cf_date tarih="attributes.paper_finish_date">
		<cfquery name="add_lang" datasource="#dsn#">
			INSERT INTO
				EMPLOYEES_APP_LANGUAGE
			 (
				EMPLOYEE_ID,
				LANG_ID,
				LANG_SPEAK,
				LANG_WRITE,
				LANG_MEAN,
				LANG_WHERE,
				PAPER_NAME,
				PAPER_DATE,
				PAPER_FINISH_DATE,
				LANG_POINT,
				LANG_PAPER_NAME,
				RECORD_DATE,
				RECORD_EMP,
				RECORD_IP			
			)
			VALUES
			(
				#attributes.EMPLOYEE_ID#,
				'#wrk_eval('attributes.lang#m#')#',
				#wrk_eval('attributes.lang_speak#m#')#,
				#wrk_eval('attributes.lang_write#m#')#,
				#wrk_eval('attributes.lang_mean#m#')#,
				'#wrk_eval('attributes.lang_where#m#')#',
				<cfif isDefined('attributes.paper_name#m#') and len(evaluate('attributes.paper_name#m#'))>'#wrk_eval('attributes.paper_name#m#')#'<cfelse>NULL</cfif>,
				<cfif isDefined('attributes.paper_date') and len(attributes.paper_date)>#attributes.paper_date#<cfelse>NULL</cfif>,
				<cfif isDefined('attributes.paper_finish_date') and len(attributes.paper_finish_date)>#attributes.paper_finish_date#<cfelse>NULL</cfif>,
				<cfif isDefined('attributes.lang_point#m#') and len(evaluate('attributes.lang_point#m#'))>
				#wrk_eval('attributes.lang_point#m#')#<cfelse>NULL</cfif>,
				<cfif isDefined('attributes.lang_paper_name#m#') and len(evaluate('attributes.lang_paper_name#m#'))>'#wrk_eval('attributes.lang_paper_name#m#')#'<cfelse>NULL</cfif>,
				#now()#,
				#session.ep.userid#,
				'#cgi.REMOTE_ADDR#'
			)
		</cfquery>
	</cfif>
</cfloop>
<!--- //Yabancı dil bilgileri--->

<script type="text/javascript">
	/*wrk_opener_reload();*/
	<cfif not isdefined("attributes.draggable")>alert("dd");window.close();<cfelseif isdefined("attributes.draggable")>closeBoxDraggable( '<cfoutput>#attributes.modal_id#</cfoutput>' );</cfif>
</script>