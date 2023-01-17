<cfif isdate(attributes.start_date)>
	<cf_date tarih='attributes.start_date'>
</cfif>
<cfif isdate(attributes.finish_date)>
	<cf_date tarih='attributes.finish_date'>
</cfif>
<cfquery name="check_form" datasource="#dsn#">
	SELECT
		FORM_ID
	FROM
		PERF_MEET_FORM
	WHERE
		EMPLOYEE_ID = #attributes.employee_id# AND
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

<CFTRANSACTION>
<cfquery name="GET_AMIR_ALL" datasource="#dsn#">
	SELECT 
		POSITION_CODE,
		EMPLOYEE_ID,
		UPPER_POSITION_CODE
	FROM
		EMPLOYEE_POSITIONS
</cfquery>

<cfquery name="get_emp" dbtype="query">
	SELECT 
		POSITION_CODE,
		EMPLOYEE_ID,
		UPPER_POSITION_CODE
	FROM
		GET_AMIR_ALL
	WHERE
		POSITION_CODE=#attributes.position_code#
</cfquery>
<cfset amir_list="">
<cfset amir_pos_list="">
<cfloop from="1" to="6" index="i">
	<cfif not len(get_emp.UPPER_POSITION_CODE) or get_emp.UPPER_POSITION_CODE eq 0>
		<cfbreak>
	</cfif>
	<cfquery name="get_emp" dbtype="query">
		SELECT 
			POSITION_CODE,
			EMPLOYEE_ID,
			UPPER_POSITION_CODE
		FROM
			GET_AMIR_ALL
		WHERE
			POSITION_CODE=#get_emp.UPPER_POSITION_CODE#
	</cfquery>
	<cfif len(get_emp.EMPLOYEE_ID) and get_emp.EMPLOYEE_ID gt 0>
		<cfset amir_list=listappend(amir_list,get_emp.EMPLOYEE_ID,',')>
		<cfif len(get_emp.POSITION_CODE)>
			<cfset amir_pos_list=listappend(amir_pos_list,get_emp.POSITION_CODE,',')>
		<cfelse>
			<cfset amir_pos_list=listappend(amir_pos_list,0,',')>
		</cfif>
	</cfif>
</cfloop>
	<cfquery name="add_perf" datasource="#dsn#" result="MAX_ID">
		INSERT INTO PERF_MEET_FORM
			(
				EMPLOYEE_ID,
				EMP_POSITION_CODE,
				FIRST_BOSS_ID,
				FIRST_BOSS_CODE,
				SECOND_BOSS_ID,
				SECOND_BOSS_CODE,
				THIRD_BOSS_ID,
				THIRD_BOSS_CODE,
 				FOURTH_BOSS_ID,
				FOURTH_BOSS_CODE,
			 	FIFTH_BOSS_ID,
				FIFTH_BOSS_CODE,
				START_DATE,
				FINISH_DATE,
				EMPLOYEES_COMMENT,
				FIRST_BOSS_COMMENT_1,
				FIRST_BOSS_COMMENT_2,
				FIRST_BOSS_COMMENT_3,
				FIRST_BOSS_COMMENT_4,
				FIRST_BOSS_COMMENT_5,
				RECORD_DATE,
				RECORD_IP,
				RECORD_EMP
			)
			VALUES
			(
				#attributes.employee_id#,
				#attributes.position_code#,
				<cfif listlen(amir_list,',') gte 1>#listgetat(amir_list,1,',')#<cfelse>NULL</cfif>,
				<cfif listlen(amir_pos_list,',') gte 1 and listgetat(amir_pos_list,1,',') gt 0>#listgetat(amir_pos_list,1,',')#<cfelse>NULL</cfif>,
				<cfif listlen(amir_list,',') gte 2>#listgetat(amir_list,2,',')#<cfelse>NULL</cfif>,
				<cfif listlen(amir_pos_list,',') gte 2 and listgetat(amir_pos_list,2,',') gt 0>#listgetat(amir_pos_list,2,',')#<cfelse>NULL</cfif>,
				<cfif listlen(amir_list,',') gte 3>#listgetat(amir_list,3,',')#<cfelse>NULL</cfif>,
				<cfif listlen(amir_pos_list,',') gte 3 and listgetat(amir_pos_list,3,',') gt 0>#listgetat(amir_pos_list,3,',')#<cfelse>NULL</cfif>,
 				<cfif listlen(amir_list,',') gte 4>#listgetat(amir_list,4,',')#<cfelse>NULL</cfif>,
				<cfif listlen(amir_pos_list,',') gte 4 and listgetat(amir_pos_list,4,',') gt 0>#listgetat(amir_pos_list,4,',')#<cfelse>NULL</cfif>,
				<cfif listlen(amir_list,',') gte 5>#listgetat(amir_list,5,',')#<cfelse>NULL</cfif>,
				<cfif listlen(amir_pos_list,',') gte 5 and listgetat(amir_pos_list,5,',') gt 0>#listgetat(amir_pos_list,5,',')#<cfelse>NULL</cfif>,
				#attributes.start_date#,
				#attributes.finish_date#,
				'#attributes.emp_comment#',
				'#attributes.boss_comment_1#',
				'#attributes.boss_comment_2#',
				'#attributes.boss_comment_3#',
				'#attributes.boss_comment_4#',
				'#attributes.boss_comment_5#',
				#now()#,
				'#CGI.REMOTE_ADDR#',
				#session.ep.userid#
			)	
	</cfquery>
</CFTRANSACTION>
<!--- <script type="text/javascript">
	wrk_opener_reload();
	//window.close();
</script> --->
<cflocation url="#request.self#?fuseaction=hr.popup_upd_perf_meet_form&form_id=#MAX_ID.IDENTITYCOL#" addtoken="no">
