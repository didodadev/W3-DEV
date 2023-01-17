<cfquery name="get_emp_detail" datasource="#dsn#">
	SELECT
		E.EMPLOYEE_ID,
		E.MEMBER_CODE,
		EI.BIRTH_DATE,
		EI.BIRTH_PLACE,
		ED.MILITARY_STATUS,
		E.GROUP_STARTDATE,
		ED.LAST_SCHOOL
	FROM
		EMPLOYEES E,
		EMPLOYEES_IDENTY EI,
		EMPLOYEES_DETAIL ED
	WHERE
		E.EMPLOYEE_ID=#attributes.emp_id# AND
		E.EMPLOYEE_ID=EI.EMPLOYEE_ID AND
		ED.EMPLOYEE_ID=EI.EMPLOYEE_ID
</cfquery>
<cfset attributes.yil=0>
<cfset attributes.ay=0>
<cfset attributes.gun=0>
<cfif get_emp_detail.recordcount>
	<cfscript>
	//çalıştığı süre hesabı
		if (len(get_emp_detail.group_startdate))
		{
			attributes.gun=datediff('d',get_emp_detail.group_startdate,now());
			attributes.yil=attributes.gun\365;
			if (attributes.gun mod 365 neq 0)
			{
				attributes.gun=attributes.gun-attributes.yil*365;
				attributes.ay=attributes.gun\30;
				if (attributes.gun mod 30 neq 0)
					attributes.gun=attributes.gun-attributes.ay*30;
				else
					attributes.gun=0;
			}else
			{
				attributes.gun=0;
				attributes.ay=0;
			}
		}
		attributes.training_level=get_emp_detail.last_school;
		attributes.military_status=get_emp_detail.military_status;
	</cfscript>
	
<!--- kişinin hergangi bir inout kaydının maaşı geliyor--->
	<cfif not len(attributes.salary_exist)>
		<cfquery name="get_salary" datasource="#dsn#" maxrows="1">
			SELECT 
				SALARY
			FROM
				EMPLOYEES_IN_OUT
			WHERE
				EMPLOYEE_ID=#get_emp_detail.employee_id#
		</cfquery>
		<cfset attributes.salary_exist=get_salary.salary>
	</cfif>
</cfif>

<cfif len(get_emp_detail.birth_date)>
	<cfset attributes.birth_date=dateformat(get_emp_detail.birth_date,dateformat_style)>
	<CF_DATE tarih="attributes.birth_date">
<cfelse>
	<cfset attributes.birth_date="">
</cfif>
<cfif len(attributes.new_start_date)>
	<CF_DATE tarih="attributes.new_start_date">
<cfelse>
	<cfset attributes.new_start_date="">
</cfif>
<cfif len(attributes.rotation_finish_date)>
	<CF_DATE tarih="attributes.rotation_finish_date">
<cfelse>
	<cfset attributes.rotation_finish_date="">
</cfif>
<cfif len(attributes.move_date)>
	<CF_DATE tarih="attributes.move_date">
<cfelse>
	<cfset attributes.move_date="">
</cfif>

<cfif len(get_emp_detail.group_startdate)>
	<cfset start_date=dateformat(get_emp_detail.group_startdate,dateformat_style)>
	<CF_DATE tarih="start_date">
<cfelse>
	<cfset start_date="">
</cfif>

<cfquery name="add_per_rot_form" datasource="#dsn#">
	UPDATE
		PERSONEL_ROTATION_FORM
	SET            
		ROTATION_FORM_HEAD='#attributes.form_head#',
		IS_RISE=<cfif isdefined("attributes.rise")>#attributes.rise#<cfelse>0</cfif>,
		IS_TRANSFER=<cfif isdefined("attributes.transfer")>#attributes.transfer#<cfelse>0</cfif>,
		IS_ROTATION=<cfif isdefined("attributes.rotation")>#attributes.rotation#<cfelse>0</cfif>,
		IS_SALARY_CHANGE=<cfif isdefined("attributes.salary_change")>#attributes.salary_change#<cfelse>0</cfif>,
		EMPLOYEE_ID=<cfif len(attributes.emp_id)>#attributes.emp_id#<cfelse>NULL</cfif>,
		SICIL_NO='#get_emp_detail.member_code#',
		EMP_BIRTH_DATE=<cfif len(attributes.birth_date)>#attributes.birth_date#<cfelse>NULL</cfif>,
		EMP_BIRTH_CITY='#get_emp_detail.birth_place#',
		WORK_STARTDATE=<cfif len(start_date)>#start_date#<cfelse>NULL</cfif>,
		TRAINING_LEVEL=<cfif len(get_emp_detail.last_school)>#get_emp_detail.last_school#<cfelse>NULL</cfif>,
		MILITARY_STATUS=<cfif len(get_emp_detail.military_status)>#get_emp_detail.military_status#<cfelse>NULL</cfif>,
		HEADQUARTERS_EXIST=<cfif len(attributes.headquarters_exist_id)>#attributes.headquarters_exist_id#<cfelse>NULL</cfif>,
		HEADQUARTERS_REQUEST=<cfif len(attributes.headquarters_request_id)>#attributes.headquarters_request_id#<cfelse>NULL</cfif>,
		COMPANY_EXIST=<cfif len(attributes.company_exist_id)>#attributes.company_exist_id#<cfelse>NULL</cfif>,
		COMPANY_REQUEST=<cfif len(attributes.company_request_id)>#attributes.company_request_id#<cfelse>NULL</cfif>,
		BRANCH_EXIST=<cfif len(attributes.branch_exist_id)>#attributes.branch_exist_id#<cfelse>NULL</cfif>,
		BRANCH_REQUEST=<cfif len(attributes.branch_request_id)>#attributes.branch_request_id#<cfelse>NULL</cfif>,
		DEPARTMENT_EXIST=<cfif len(attributes.department_exist_id)>#attributes.department_exist_id#<cfelse>NULL</cfif>,
		DEPARTMENT_REQUEST=<cfif len(attributes.department_request_id)>#attributes.department_request_id#<cfelse>NULL</cfif>,
		POS_CODE_EXIST=<cfif len(attributes.pos_code)>#attributes.pos_code#<cfelse>NULL</cfif>,
		POS_CODE_REQUEST=<cfif len(attributes.pos_request_id)>#attributes.pos_request_id#<cfelse>NULL</cfif>,
		SALARY_EXIST=<cfif len(attributes.salary_exist)>#attributes.salary_exist#<cfelse>NULL</cfif>,
		SALARY_EXIST_MONEY=<cfif len(attributes.salary_exist_money)>'#attributes.salary_exist_money#'<cfelse>NULL</cfif>,
		SALARY_REQUEST=<cfif len(attributes.salary_request)>#attributes.salary_request#<cfelse>NULL</cfif>,
		SALARY_REQUEST_MONEY=<cfif len(attributes.salary_request_money)>'#attributes.salary_request_money#'<cfelse>NULL</cfif>,
		TOOL_EXIST='#attributes.tool_exist#',
		TOOL_REQUEST='#attributes.tool_request#',
		TEL_EXIST='#attributes.tel_exist#',
		TEL_REQUEST='#attributes.tel_request#',
		OTHER_EXIST='#attributes.other_exist#',
		OTHER_REQUEST='#attributes.other_request#',
		MOVE_AMOUNT=<cfif len(attributes.move_amount)>#attributes.move_amount#<cfelse>NULL</cfif>,
		MOVE_AMOUNT_MONEY=<cfif len(attributes.move_amount)>'#attributes.move_amount_money#'<cfelse>NULL</cfif>,
		MOVE_DATE=<cfif len(attributes.move_date)>#attributes.move_date#<cfelse>NULL</cfif>,
		DETAIL='#attributes.detail#',
		WORK_YEAR=#attributes.yil#,
		WORK_MONTH=#attributes.ay#,
		WORK_DAY=#attributes.gun#,
		NEW_START_DATE=<cfif len(attributes.new_start_date)>#attributes.new_start_date#<cfelse>NULL</cfif>,
		ROTATION_FINISH_DATE=<cfif len(attributes.rotation_finish_date)>#attributes.rotation_finish_date#<cfelse>NULL</cfif>,
		FORM_STAGE=<cfif len(attributes.process_stage)>#attributes.process_stage#<cfelse>NULL</cfif>,
		UPDATE_DATE=#now()#,
		UPDATE_IP='#cgi.REMOTE_ADDR#',
		UPDATE_EMP=#session.ep.userid#		
	WHERE
		ROTATION_FORM_ID=#attributes.per_rot_id#
</cfquery>
<cf_workcube_process 
	is_upd='1' 
	old_process_line='#attributes.old_process_line#'
	process_stage='#attributes.process_stage#' 
	record_member='#session.ep.userid#' 
	record_date='#now()#' 
	action_table='PERSONEL_ROTATION_FORM'
	action_column='ROTATION_FORM_ID'
	action_id='#attributes.per_rot_id#'
	action_page='#request.self#?fuseaction=correspondence.upd_personel_rotation_form&per_rot_id=#attributes.per_rot_id#' 
	warning_description = 'Terfi-Transfer-Rotasyon Talep Formu : Aşama Değişti'>
<cflocation url="#request.self#?fuseaction=correspondence.upd_personel_rotation_form&per_rot_id=#attributes.per_rot_id#" addtoken="no">﻿
