
<cfcomponent>
    <cfset dsn=application.systemParam.systemParam().dsn>
    <cfset request.self = application.systemParam.systemParam().request.self />
    <cfset dateformat_style = ( isdefined("session.ep.dateformat_style") and len(session.ep.dateformat_style) ) ? session.ep.dateformat_style : 'dd/mm/yyyy'>
    <cffunction name="add_per_rot_form" access="public" returnType="any">
        <cfset attributes = arguments>
        <cf_get_lang_set module_name="hr">
        <cfset responseStruct = structNew()>
      <cftry>
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
                    E.EMPLOYEE_ID=<cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.emp_id#"> AND
                    E.EMPLOYEE_ID=EI.EMPLOYEE_ID AND
                    ED.EMPLOYEE_ID=EI.EMPLOYEE_ID
            </cfquery>
            <cfscript>
                //çalıştığı süre hesabı
                    if (len(get_emp_detail.group_startdate))
                    {
                        arguments.gun=datediff('d',get_emp_detail.group_startdate,now());
                        arguments.yil=arguments.gun\365;
                        if (arguments.gun mod 365 neq 0)
                        {
                            arguments.gun=arguments.gun-arguments.yil*365;
                            arguments.ay=arguments.gun\30;
                            if (arguments.gun mod 30 neq 0)
                                arguments.gun=arguments.gun-arguments.ay*30;
                            else
                                arguments.gun=0;
                        }else
                        {
                            arguments.gun=0;
                            arguments.ay=0;
                        }
                    }
                    arguments.training_level=get_emp_detail.last_school;
                    arguments.military_status=get_emp_detail.military_status;
            </cfscript>
            <cfquery name="add_per_rot_form" datasource="#dsn#">
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
                    <cfif isdefined("arguments.form_head")><cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.form_head#"><cfelse>NULL</cfif>,
                    <cfif isdefined("arguments.rise")><cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.rise#"><cfelse>0</cfif>,
                    <cfif isdefined("arguments.transfer")><cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.transfer#"><cfelse>0</cfif>,
                    <cfif isdefined("arguments.rotation")><cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.rotation#"><cfelse>0</cfif>,
                    <cfif isdefined("arguments.salary_change")><cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.salary_change#"><cfelse>0</cfif>,
                    <cfif isdefined("arguments.emp_id") and len(arguments.emp_id)><cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.emp_id#"><cfelse>NULL</cfif>,
                    <cfif isdefined("get_emp_detail.member_code")><cfqueryparam cfsqltype="cf_sql_varchar" value="#get_emp_detail.member_code#"><cfelse>NULL</cfif>,
                    <cfif isdefined("arguments.birth_date") and len(get_emp_detail.birth_date)><cfqueryparam cfsqltype="cf_sql_timestamp" value="#get_emp_detail.birth_date#"><cfelse>NULL</cfif>,
                    <cfif isdefined("arguments.birth_place") and len(get_emp_detail.birth_place)><cfqueryparam cfsqltype="cf_sql_varchar" value="#get_emp_detail.birth_place#"><cfelse>NULL</cfif>,
                    <cfif isdefined("arguments.GROUP_STARTDATE") and len(get_emp_detail.GROUP_STARTDATE)><cfqueryparam cfsqltype="cf_sql_timestamp" value="#get_emp_detail.GROUP_STARTDATE#"><cfelse>NULL</cfif>,
                    <cfif isdefined("arguments.training_level") and len(arguments.training_level)><cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.training_level#"><cfelse>NULL</cfif>,
                    <cfif isdefined("arguments.military_status") and len(get_emp_detail.military_status)><cfqueryparam cfsqltype="cf_sql_integer" value="#get_emp_detail.military_status#"><cfelse>NULL</cfif>,
                    <cfif isdefined("arguments.headquarters_exist_id") and len(arguments.headquarters_exist_id)><cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.headquarters_exist_id#"><cfelse>NULL</cfif>,
                    <cfif isdefined("arguments.headquarters_request_id") and len(arguments.headquarters_request_id)><cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.headquarters_request_id#"><cfelse>NULL</cfif>,
                    <cfif isdefined("arguments.company_exist_id") and len(arguments.company_exist_id)><cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.company_exist_id#"><cfelse>NULL</cfif>,
                    <cfif isdefined("arguments.company_request_id") and len(arguments.company_request_id)><cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.company_request_id#"><cfelse>NULL</cfif>,
                    <cfif isdefined("arguments.branch_exist_id") and len(arguments.branch_exist_id)><cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.branch_exist_id#"><cfelse>NULL</cfif>,
                    <cfif isdefined("arguments.branch_request_id") and len(arguments.branch_request_id)><cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.branch_request_id#"><cfelse>NULL</cfif>,
                    <cfif isdefined("arguments.department_exist_id") and len(arguments.department_exist_id)><cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.department_exist_id#"><cfelse>NULL</cfif>,
                    <cfif isdefined("arguments.department_request_id") and len(arguments.department_request_id)><cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.department_request_id#"><cfelse>NULL</cfif>,
                    <cfif isdefined("arguments.pos_code") and len(arguments.pos_code)><cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.pos_code#"><cfelse>NULL</cfif>,
                    <cfif isdefined("arguments.pos_request_id") and len(arguments.pos_request_id)><cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.pos_request_id#"><cfelse>NULL</cfif>,
                    <cfif isdefined("arguments.salary_exist") and len(arguments.salary_exist)><cfqueryparam cfsqltype="cf_sql_float" value="#arguments.salary_exist#"><cfelse>NULL</cfif>,
                    <cfif isdefined("arguments.salary_exist_money") and len(arguments.salary_exist_money)><cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.salary_exist_money#"><cfelse>NULL</cfif>,
                    <cfif isdefined("arguments.salary_request") and len(arguments.salary_request)><cfqueryparam cfsqltype="cf_sql_float" value="#arguments.salary_request#"><cfelse>NULL</cfif>,
                    <cfif isdefined("arguments.salary_request_money") and len(arguments.salary_request_money)><cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.salary_request_money#"><cfelse>NULL</cfif>,
                    <cfif isdefined("arguments.tool_exist") and len(arguments.tool_exist)><cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.tool_exist#"><cfelse>NULL</cfif>,
                    <cfif isdefined("arguments.tool_request") and len(arguments.tool_request)><cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.tool_request#"><cfelse>NULL</cfif>,
                    <cfif isdefined("arguments.tel_exist") and len(arguments.tel_exist)><cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.tel_exist#"><cfelse>NULL</cfif>,
                    <cfif isdefined("arguments.tel_request") and len(arguments.tel_request)><cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.tel_request#"><cfelse>NULL</cfif>,
                    <cfif isdefined("arguments.other_exist") and len(arguments.other_exist)><cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.other_exist#"><cfelse>NULL</cfif>,
                    <cfif isdefined("arguments.other_request") and len(arguments.other_request)><cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.other_request#"><cfelse>NULL</cfif>,
                    <cfif isdefined("arguments.move_amount") and len(arguments.move_amount)><cfqueryparam cfsqltype="cf_sql_float" value="#arguments.move_amount#"><cfelse>NULL</cfif>,
                    <cfif isdefined("arguments.move_amount_money") and len(arguments.move_amount_money)><cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.move_amount_money#"><cfelse>NULL</cfif>,
                    <cfif isdefined("arguments.move_date") and len(arguments.move_date)><cfqueryparam cfsqltype="cf_sql_timestamp" value="#arguments.move_date#"><cfelse>NULL</cfif>,
                    <cfif isdefined("arguments.detail") and len(arguments.detail)><cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.detail#"><cfelse>NULL</cfif>,
                    <cfif len(arguments.yil)><cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.yil#"><cfelse>NULL</cfif>,
                    <cfif len(arguments.ay)><cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.ay#"><cfelse>NULL</cfif>,
                    <cfif len(arguments.gun)><cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.gun#"><cfelse>NULL</cfif>,
                    <cfif isdefined("arguments.new_start_date") and len(arguments.new_start_date)><cfqueryparam cfsqltype="cf_sql_timestamp" value="#arguments.new_start_date#"><cfelse>NULL</cfif>,
                    <cfif isdefined("arguments.rotation_finish_date") and len(arguments.rotation_finish_date)><cfqueryparam cfsqltype="cf_sql_timestamp" value="#arguments.rotation_finish_date#"><cfelse>NULL</cfif>,
                    <cfif isdefined("arguments.process_stage") and len(arguments.process_stage)><cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.process_stage#"><cfelse>NULL</cfif>,
                    <cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">,
                    <cfqueryparam cfsqltype="cf_sql_varchar" value="#cgi.remote_addr#">,
                    <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.userid#">
                )
            </cfquery>
            <cfquery name="GET_MAX" datasource="#dsn#" maxrows="1">
                SELECT * FROM PERSONEL_ROTATION_FORM   
                ORDER BY 
                ROTATION_FORM_ID DESC
            </cfquery>
              <cfset attributes.is_upd = 0>
            <cfset responseStruct.message = "İşlem Başarılı">
            <cfset responseStruct.status = true>
            <cfset responseStruct.error = {}>
            <cfset responseStruct.identity = GET_MAX.ROTATION_FORM_ID>
            <cfcatch>
                <cfset responseStruct.message = "İşlem Hatalı">
                <cfset responseStruct.status = false>
                <cfset responseStruct.error = cfcatch>
            </cfcatch>
        </cftry>
        <cfreturn responseStruct>
    </cffunction>
    <cffunction name="GET_PER_FORM" access="public" returntype="any">
        <cfargument name="per_rot_id" default="">
        <cfquery name="GET_PER_FORM" datasource="#dsn#">
            SELECT
                PRF.*,
                EP.EMPLOYEE_NAME AS EMPNAME,
                EP.EMPLOYEE_SURNAME AS EMPSNAME,
                EP.POSITION_NAME AS POSNAME,
                EPOS.EMPLOYEE_NAME AS EMPNAME_R,
                EPOS.EMPLOYEE_SURNAME AS EMPSURNAME_R,
                EPOS.POSITION_NAME POSNAME_R,
                OC.COMP_ID AS COM_ID,
                OC.NICK_NAME AS NICK,
                OCOMP.COMP_ID AS COMPID,
                OCOMP.NICK_NAME AS COMPNAME,
                D.DEPARTMENT_ID AS DEP_ID,
                D.DEPARTMENT_HEAD AS DEP,
                DEP.DEPARTMENT_ID AS DEP_ID_,
                DEP.DEPARTMENT_HEAD AS DEP_,
                B.BRANCH_ID AS BRANCH_ID_1,
                B.BRANCH_NAME AS BRANCH_1,
                BR.BRANCH_ID AS BRANCH_ID_2,
                BR.BRANCH_NAME AS BRANCH_2,
                SHQ.HEADQUARTERS_ID AS H_ID, 
			    SHQ.NAME AS HNAME,
                SHR.HEADQUARTERS_ID AS R_ID,
			    SHR.NAME AS RNAME,
                E.MEMBER_CODE,
                E.EMPLOYEE_ID,
                EI.BIRTH_DATE,
                EI.BIRTH_PLACE,
                ED.MILITARY_STATUS,
                E.GROUP_STARTDATE,
                ED.LAST_SCHOOL,
                ES.M1,
                ES.MONEY
            FROM
                PERSONEL_ROTATION_FORM PRF
                LEFT JOIN EMPLOYEE_POSITIONS EP ON EP.POSITION_CODE= PRF.POS_CODE_EXIST
                LEFT JOIN EMPLOYEE_POSITIONS EPOS ON EPOS.POSITION_CODE= PRF.POS_CODE_REQUEST
                LEFT JOIN OUR_COMPANY OC ON OC.COMP_ID = PRF.COMPANY_EXIST
                LEFT JOIN OUR_COMPANY OCOMP ON OCOMP.COMP_ID = PRF.COMPANY_REQUEST
                LEFT JOIN DEPARTMENT D ON D.DEPARTMENT_ID = PRF.DEPARTMENT_EXIST
                LEFT JOIN DEPARTMENT DEP ON DEP.DEPARTMENT_ID = PRF.DEPARTMENT_REQUEST
                LEFT JOIN BRANCH B ON B.BRANCH_ID = PRF.BRANCH_EXIST
                LEFT JOIN BRANCH BR ON BR.BRANCH_ID = PRF.BRANCH_REQUEST
                LEFT JOIN SETUP_HEADQUARTERS SHQ ON SHQ.HEADQUARTERS_ID = PRF.HEADQUARTERS_EXIST
                LEFT JOIN SETUP_HEADQUARTERS SHR ON SHR.HEADQUARTERS_ID = PRF.HEADQUARTERS_REQUEST
                LEFT JOIN EMPLOYEES E ON E.EMPLOYEE_ID= PRF.EMPLOYEE_ID
                LEFT JOIN EMPLOYEES_IDENTY EI ON E.EMPLOYEE_ID=EI.EMPLOYEE_ID
                LEFT JOIN EMPLOYEES_DETAIL ED ON ED.EMPLOYEE_ID=EI.EMPLOYEE_ID
                LEFT JOIN EMPLOYEES_SALARY ES ON ES.EMPLOYEE_ID = PRF.EMPLOYEE_ID
            WHERE
                PRF.ROTATION_FORM_ID=<cfqueryparam cfsqltype="cf_sql_integer" value="#url.per_rot_id#">
        </cfquery>
        <cfreturn GET_PER_FORM>
    </cffunction>
    <cffunction  name="get" access="public">
        <cfargument  name="per_rot_id" default="">
         <cfreturn GET_PER_FORM(id=arguments.per_rot_id)> 
    </cffunction> 
    <cffunction  name="get_money" access="public">
        <cfquery name="get_money" datasource="#dsn#">
            SELECT
                SM.MONEY_ID, SM.MONEY FROM SETUP_MONEY SM WHERE SM.PERIOD_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.period_id#">
        </cfquery>
        <cfreturn get_money>
    </cffunction>
    <cffunction name="upd_per_rot_form"  access="public" returntype="any">
        <cfset attributes = arguments>
        <cfset responseStruct = structNew()>
        <cftry>
            <cfquery name="upd_per_rot_form" datasource="#dsn#">
                UPDATE
		            PERSONEL_ROTATION_FORM
	            SET            
                    ROTATION_FORM_HEAD=<cfif isdefined("arguments.form_head") and len(arguments.form_head)><cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.form_head#"><cfelse>NULL</cfif>,
                    IS_RISE=<cfif isdefined("arguments.rise")><cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.rise#"><cfelse>0</cfif>,
                    IS_TRANSFER=<cfif isdefined("arguments.transfer")><cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.transfer#"><cfelse>0</cfif>,
                    IS_ROTATION=<cfif isdefined("arguments.rotation")><cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.rotation#"><cfelse>0</cfif>,
                    IS_SALARY_CHANGE=<cfif isdefined("arguments.salary_change")><cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.salary_change#"><cfelse>0</cfif>,
                    EMPLOYEE_ID=<cfif isdefined("arguments.emp_id") and len(arguments.emp_id)><cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.emp_id#"><cfelse>NULL</cfif>,
                    EMP_BIRTH_CITY=<cfif isdefined("arguments.birth_place") and len(arguments.birth_place)><cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.birth_place#"><cfelse>NULL</cfif>,
                    WORK_STARTDATE=<cfif isDefined('arguments.start_work') and len(arguments.start_work)><cfqueryparam cfsqltype="cf_sql_timestamp" value="#arguments.start_work#"><cfelse>NULL</cfif>,
                    EMP_BIRTH_DATE=<cfif isDefined('arguments.emp_birth_date') and len(arguments.emp_birth_date)><cfqueryparam cfsqltype="cf_sql_timestamp" value="#arguments.emp_birth_date#"><cfelse>NULL</cfif>,
                    HEADQUARTERS_EXIST=<cfif isDefined('arguments.headquarters_exist_id') and len(arguments.headquarters_exist_id)><cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.headquarters_exist_id#"><cfelse>NULL</cfif>,
                    HEADQUARTERS_REQUEST=<cfif isDefined('arguments.headquarters_request_id') and len(arguments.headquarters_request_id)><cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.headquarters_request_id#"><cfelse>NULL</cfif>,
                    COMPANY_EXIST=<cfif isDefined('arguments.company_exist_id') and len(arguments.company_exist_id)><cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.company_exist_id#"><cfelse>NULL</cfif>,
                    COMPANY_REQUEST=<cfif isDefined('arguments.company_request_id') and len(arguments.company_request_id)><cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.company_request_id#"><cfelse>NULL</cfif>,
                    BRANCH_EXIST=<cfif isDefined('arguments.branch_exist_id') and len(arguments.branch_exist_id)><cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.branch_exist_id#"><cfelse>NULL</cfif>,
                    BRANCH_REQUEST=<cfif  isDefined('arguments.branch_request_id') and len(arguments.branch_request_id)><cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.branch_request_id#"><cfelse>NULL</cfif>,
                    DEPARTMENT_EXIST=<cfif isDefined('arguments.department_exist_id') and len(arguments.department_exist_id)><cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.department_exist_id#"><cfelse>NULL</cfif>,
                    DEPARTMENT_REQUEST=<cfif isDefined('arguments.department_request_id') and len(arguments.department_request_id)><cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.department_request_id#"><cfelse>NULL</cfif>,
                    POS_CODE_EXIST=<cfif isDefined('arguments.pos_code') and len(arguments.pos_code)><cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.pos_code#"><cfelse>NULL</cfif>,
                    POS_CODE_REQUEST=<cfif isDefined('arguments.pos_request_id') and len(arguments.pos_request_id)><cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.pos_request_id#"><cfelse>NULL</cfif>,
                    SALARY_EXIST=<cfif isDefined('arguments.salary_exist') and len(arguments.salary_exist)><cfqueryparam cfsqltype="cf_sql_float" value="#arguments.salary_exist#"><cfelse>NULL</cfif>,
                    SALARY_EXIST_MONEY=<cfif isDefined('arguments.salary_exist_money') and len(arguments.salary_exist_money)><cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.salary_exist_money#"><cfelse>NULL</cfif>,
                    SALARY_REQUEST=<cfif isDefined('arguments.salary_request') and len(arguments.salary_request)><cfqueryparam cfsqltype="cf_sql_float" value="#arguments.salary_request#"><cfelse>NULL</cfif>,
                    SALARY_REQUEST_MONEY=<cfif isDefined('arguments.salary_request_money') and len(arguments.salary_request_money)><cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.salary_request_money#"><cfelse>NULL</cfif>,
                    TOOL_EXIST=<cfif isDefined('arguments.tool_exist') and len(arguments.tool_exist)><cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.tool_exist#"><cfelse>NULL</cfif>,
                    TOOL_REQUEST=<cfif isDefined('arguments.tool_request') and len(arguments.tool_request)><cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.tool_request#"><cfelse>NULL</cfif>,
                    TEL_EXIST=<cfif isDefined('arguments.tel_exist') and len(arguments.tel_exist)><cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.tel_exist#"><cfelse>NULL</cfif>,
                    TEL_REQUEST=<cfif isDefined('arguments.tel_request') and len(arguments.tel_request)><cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.tel_request#"><cfelse>NULL</cfif>,
                    OTHER_EXIST=<cfif isDefined('arguments.other_exist') and len(arguments.other_exist)><cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.other_exist#"><cfelse>NULL</cfif>,
                    WORK_YEAR=<cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.yil#">,
                    WORK_MONTH=<cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.ay#">,
                    WORK_DAY=<cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.gun#">,
                    OTHER_REQUEST=<cfif isDefined('arguments.other_request') and len(arguments.other_request)><cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.other_request#"><cfelse>NULL</cfif>,
                    MOVE_AMOUNT=<cfif isDefined('arguments.move_amount') and len(arguments.move_amount)>#arguments.move_amount#<cfelse>NULL</cfif>,
                    MOVE_AMOUNT_MONEY=<cfif isDefined('arguments.move_amount_money') and len(arguments.move_amount_money)>'#arguments.move_amount_money#'<cfelse>NULL</cfif>,
                    MOVE_DATE=<cfif isDefined('arguments.move_date') and len(arguments.move_date)>#arguments.move_date#<cfelse>NULL</cfif>,
                    DETAIL=<cfif isDefined('arguments.detail') and len(arguments.detail)><cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.detail#"><cfelse>NULL</cfif>,
                    TRAINING_LEVEL=<cfif isDefined('arguments.training_level') and len(arguments.training_level)><cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.training_level#"><cfelse>NULL</cfif>,
                    NEW_START_DATE=<cfif isDefined("arguments.new_start_date") and len(arguments.new_start_date)><cfqueryparam cfsqltype="cf_sql_timestamp" value="#arguments.new_start_date#"><cfelse>NULL</cfif>,
                    ROTATION_FINISH_DATE=<cfif isDefined('arguments.rotation_finish_date') and len(arguments.rotation_finish_date)><cfqueryparam cfsqltype="cf_sql_timestamp" value="#arguments.rotation_finish_date#"><cfelse>NULL</cfif>,
                    FORM_STAGE=<cfif isDefined('arguments.process_stage') and len(arguments.process_stage)><cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.process_stage#"><cfelse>NULL</cfif>,
                    UPDATE_DATE=<cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">,
                    UPDATE_IP=<cfqueryparam cfsqltype="cf_sql_varchar" value="#cgi.remote_addr#">,
                    UPDATE_EMP=<cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.userid#">,
                    SICIL_NO=<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.member_code#">	
                WHERE
                    ROTATION_FORM_ID=<cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.per_rot_id#">
            </cfquery>
            <cfset attributes.fuseaction= arguments.fuseaction>
            <cf_workcube_process 
            is_upd='1' 
            old_process_line='#arguments.old_process_line#'
            process_stage='#arguments.process_stage#' 
            record_member='#session.ep.userid#' 
            record_date='#now()#' 
            action_table='PERSONEL_ROTATION_FORM'
            action_column='ROTATION_FORM_ID'
            action_id='#arguments.per_rot_id#'
            action_page='#request.self#?fuseaction=hr.list_personel_rotation_form&event=upd&per_rot_id=#arguments.per_rot_id#'
            warning_description = 'Terfi-Transfer-Rotasyon Talep Formu : Aşama Değişti'>
            <cfset responseStruct.message = "İşlem Başarılı">
            <cfset responseStruct.status = true>
            <cfset responseStruct.error = {}>
            <cfset responseStruct.identity = arguments.per_rot_id>
            <cfcatch>
                <cftransaction action="rollback">
                <cfset responseStruct.message = "İşlem Hatalı">
                <cfset responseStruct.status = false>
                <cfset responseStruct.error = cfcatch>
            </cfcatch>
        </cftry>
        <cfreturn responseStruct>
    </cffunction>
    <cffunction name="DEL">
        <cfset attributes = arguments>
        <cfset responseStruct = structNew()>
        <cftry>
            <cfquery name="DEL" datasource="#DSN#">
                DELETE FROM PERSONEL_ROTATION_FORM WHERE ROTATION_FORM_ID =<cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.per_rot_id#">
            </cfquery>
            <cfset responseStruct.message = "İşlem Başarılı">
            <cfset responseStruct.status = true>
            <cfset responseStruct.error = {}>
            <cfset responseStruct.identity = arguments.per_rot_id>
            <cfcatch>
                <cftransaction action="rollback">
                <cfset responseStruct.message = "İşlem Hatalı">
                <cfset responseStruct.status = false>
                <cfset responseStruct.error = cfcatch>
            </cfcatch>
        </cftry>
        <cfreturn responseStruct>
    </cffunction>
    <cffunction name="list_per_form" access="public" returntype="query">
        <cfset attributes = arguments>
        <cfquery name="list_per_form" datasource="#dsn#">
            SELECT
                ERF.*,
                EP.EMPLOYEE_NAME +' '+ EP.EMPLOYEE_SURNAME AS EXIST_NAME,
                #dsn#.Get_Dynamic_Language(EP.POSITION_ID,'#session.ep.language#','EMPLOYEE_POSITIONS','POSITION_NAME',NULL,NULL,EP.POSITION_NAME) AS EXIST_POS_NAME,
                EP2.EMPLOYEE_NAME +' '+ EP2.EMPLOYEE_SURNAME AS REQUEST_NAME,
                EP2.POSITION_NAME AS REQUEST_POS_NAME,
                PTR.STAGE
            FROM
                PERSONEL_ROTATION_FORM ERF
                LEFT JOIN EMPLOYEE_POSITIONS EP ON EP.POSITION_CODE = ERF.POS_CODE_EXIST
                LEFT JOIN EMPLOYEE_POSITIONS EP2 ON EP2.POSITION_CODE = ERF.POS_CODE_REQUEST
                LEFT JOIN PROCESS_TYPE_ROWS PTR ON PTR.PROCESS_ROW_ID = ERF.FORM_STAGE
            WHERE
                ERF.ROTATION_FORM_ID IS NOT NULL
                 <cfif isdefined("arguments.finishdate") and len(arguments.finishdate)>
                    AND ERF.RECORD_DATE <= #arguments.finishdate#
                </cfif>
                <cfif isdefined("arguments.startdate") and len(arguments.startdate)>
                    AND ERF.RECORD_DATE >= #arguments.startdate#
                </cfif> 
                <cfif isdefined("arguments.keyword") and len(arguments.keyword)>
                    AND  ERF.ROTATION_FORM_HEAD LIKE '#arguments.keyword#%' COLLATE SQL_Latin1_General_CP1_CI_AI 
                </cfif>
                <cfif isdefined ("arguments.form_type") and len (arguments.form_type)>
                    <cfif arguments.form_type eq 1>
                    AND ERF.IS_RISE =1
                    <cfelseif arguments.form_type eq 2>
                    AND ERF.IS_TRANSFER=1
                    <cfelseif arguments.form_type eq 3>
                    AND ERF.IS_ROTATION=1
                    <cfelseif arguments.form_type eq 4>
                    AND ERF.IS_SALARY_CHANGE=1
                    </cfif>
                </cfif>
            ORDER BY 
                ERF.RECORD_DATE DESC
        </cfquery>
        <cfreturn list_per_form>
    </cffunction>
</cfcomponent>