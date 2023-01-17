<cfquery name="get_emp_detail" datasource="#dsn#">
	SELECT
		E.MEMBER_CODE,
		E.EMPLOYEE_ID,
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
				M1,
				MONEY
			FROM
				EMPLOYEES_SALARY
			WHERE
				EMPLOYEE_ID=#get_emp_detail.employee_id#
			ORDER BY 
				SALARY_HISTORY_ID DESC
		</cfquery>
		<cfset attributes.salary_exist=get_salary.M1>
		<cfset attributes.salary_exist_money=get_salary.money>
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
<cfquery name="add_per_rot_form" datasource="#dsn#" result="MAX_ID">
	INSERT 	INTO
		PERSONEL_ROTATION_FORM
	(
		ROTATION_FORM_HEAD,
		IS_RISE,
		IS_TRANSFER,
		IS_ROTATION,
		IS_SALARY_CHANGE,
		EMPLOYEE_ID,
		SICIL_NO,
		EMP_BIRTH_DATE,
		EMP_BIRTH_CITY,
		WORK_STARTDATE,
		TRAINING_LEVEL,
		MILITARY_STATUS,
		
		HEADQUARTERS_EXIST,
		HEADQUARTERS_REQUEST,
		COMPANY_EXIST,
		COMPANY_REQUEST,
		BRANCH_EXIST,
		BRANCH_REQUEST,
		DEPARTMENT_EXIST,
		DEPARTMENT_REQUEST,
		
		POS_CODE_EXIST,
		POS_CODE_REQUEST,
		SALARY_EXIST,
		SALARY_EXIST_MONEY,
		SALARY_REQUEST,
		SALARY_REQUEST_MONEY,
		TOOL_EXIST,
		TOOL_REQUEST,
		TEL_EXIST,
		TEL_REQUEST,
		OTHER_EXIST,
		OTHER_REQUEST,
		
		MOVE_AMOUNT,
		MOVE_AMOUNT_MONEY,
		MOVE_DATE,
		DETAIL,
		WORK_YEAR,
		WORK_MONTH,
		WORK_DAY,
		NEW_START_DATE,
		ROTATION_FINISH_DATE,
		FORM_STAGE,
		RECORD_DATE,
		RECORD_IP,
		RECORD_EMP
	) VALUES
	(
		'#attributes.form_head#',
		<cfif isdefined("attributes.rise")>#attributes.rise#<cfelse>0</cfif>,
		<cfif isdefined("attributes.transfer")>#attributes.transfer#<cfelse>0</cfif>,
		<cfif isdefined("attributes.rotation")>#attributes.rotation#<cfelse>0</cfif>,
		<cfif isdefined("attributes.salary_change")>#attributes.salary_change#<cfelse>0</cfif>,
		<cfif len(attributes.emp_id)>#attributes.emp_id#<cfelse>NULL</cfif>,
		'#get_emp_detail.member_code#',
		<cfif len(attributes.birth_date)>#attributes.birth_date#<cfelse>NULL</cfif>,
		<cfif len(get_emp_detail.birth_place)>'#get_emp_detail.birth_place#'<cfelse>NULL</cfif>,
		<cfif len(start_date)>#start_date#<cfelse>NULL</cfif>,
		<cfif len(get_emp_detail.last_school)>#get_emp_detail.last_school#<cfelse>NULL</cfif>,
		<cfif len(get_emp_detail.military_status)>#get_emp_detail.military_status#<cfelse>NULL</cfif>,
		
		<cfif len(attributes.headquarters_exist_id)>#attributes.headquarters_exist_id#<cfelse>NULL</cfif>,
		<cfif len(attributes.headquarters_request_id)>#attributes.headquarters_request_id#<cfelse>NULL</cfif>,
		<cfif len(attributes.company_exist_id)>#attributes.company_exist_id#<cfelse>NULL</cfif>,
		<cfif len(attributes.company_request_id)>#attributes.company_request_id#<cfelse>NULL</cfif>,
		<cfif len(attributes.branch_exist_id)>#attributes.branch_exist_id#<cfelse>NULL</cfif>,
		<cfif len(attributes.branch_request_id)>#attributes.branch_request_id#<cfelse>NULL</cfif>,
		<cfif len(attributes.department_exist_id)>#attributes.department_exist_id#<cfelse>NULL</cfif>,
		<cfif len(attributes.department_request_id)>#attributes.department_request_id#<cfelse>NULL</cfif>,
		
		<cfif len(attributes.pos_code)>#attributes.pos_code#<cfelse>NULL</cfif>,
		<cfif len(attributes.pos_request_id)>#attributes.pos_request_id#<cfelse>NULL</cfif>,
		<cfif len(attributes.salary_exist)>#attributes.salary_exist#<cfelse>NULL</cfif>,
		<cfif len(attributes.salary_exist_money)>'#attributes.salary_exist_money#'<cfelse>NULL</cfif>,
		<cfif len(attributes.salary_request)>#attributes.salary_request#<cfelse>NULL</cfif>,
		<cfif len(attributes.salary_request_money)>'#attributes.salary_request_money#'<cfelse>NULL</cfif>,
		'#attributes.tool_exist#',
		'#attributes.tool_request#',
		'#attributes.tel_exist#',
		'#attributes.tel_request#',
		'#attributes.other_exist#',
		'#attributes.other_request#',
		
		<cfif len(attributes.move_amount)>#attributes.move_amount#<cfelse>NULL</cfif>,
		<cfif len(attributes.move_amount_money)>'#attributes.move_amount_money#'<cfelse>NULL</cfif>,
		<cfif len(attributes.move_date)>#attributes.move_date#<cfelse>NULL</cfif>,
		'#attributes.detail#',
		#attributes.yil#,
		#attributes.ay#,
		#attributes.gun#,
		<cfif len(attributes.new_start_date)>#attributes.new_start_date#<cfelse>NULL</cfif>,
		<cfif len(attributes.rotation_finish_date)>#attributes.rotation_finish_date#<cfelse>NULL</cfif>,
		<cfif len(attributes.process_stage)>#attributes.process_stage#<cfelse>NULL</cfif>,
		#now()#,
		'#cgi.REMOTE_ADDR#',
		#session.ep.userid#
	)
</cfquery>
<cf_workcube_process 
	is_upd='1' 
	process_stage='#attributes.process_stage#' 
	old_process_line='0'
	record_member='#session.ep.userid#' 
	record_date='#now()#' 
	action_table='PERSONEL_ROTATION_FORM'
	action_column='ROTATION_FORM_ID'
	action_id='#MAX_ID.IDENTITYCOL#'
	action_page='#request.self#?fuseaction=correspondence.upd_personel_rotation_form&per_rot_id=#MAX_ID.IDENTITYCOL#' 
	warning_description = 'Terfi-Transfer-Rotasyon Talep Formu : Yeni Kayıt'>
<cflocation url="#request.self#?fuseaction=correspondence.upd_personel_rotation_form&per_rot_id=#MAX_ID.IDENTITYCOL#" addtoken="no">
