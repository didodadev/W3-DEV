<cf_get_lang_set module_name="myhome">
<cfif (isdefined("attributes.event") and attributes.event is 'list') or not isdefined("attributes.event")>
	<cfif isdefined("attributes.is_form_submitted")>
        <cfinclude template="../myhome/query/get_payment_lists.cfm">
    <cfelse>
        <cfset get_requests.recordcount=0>
        <cfset get_other_requests.recordcount=0>
        <cfset get_reserve_requests.recordcount=0>
        <cfset get_reserve_other_requests.recordcount=0>
        <cfset get_info_requests.recordcount=0>
    </cfif>
    <cfparam name="attributes.status" default="">
    <cfparam name="attributes.keyword" default="">
    <cfparam name="attributes.page" default="1">
    <cfparam name="attributes.maxrows" default='#session.ep.maxrows#'>
    <cfset url_str="keyword=#attributes.keyword#&status=#attributes.status#">
    
    <cfparam name="attributes.totalrecords" default="#get_requests.recordcount#">
    <cfset attributes.startrow=((attributes.page-1)*attributes.maxrows)+1>
<cfelseif isdefined("attributes.event") and attributes.event is 'add'>
	<cf_xml_page_edit fuseact="myhome.form_add_payment_request">
    <cfquery name="GET_PRIORITY" datasource="#DSN#">
        SELECT PRIORITY_ID,PRIORITY FROM SETUP_PRIORITY ORDER BY PRIORITY
    </cfquery>
    <cfquery name="PAY_METHODS" datasource="#DSN#">
        SELECT 
            SP.PAYMETHOD_ID,
            SP.PAYMETHOD 
        FROM 
            SETUP_PAYMETHOD SP,
            SETUP_PAYMETHOD_OUR_COMPANY SPOC
        WHERE 
            SP.PAYMETHOD_STATUS = 1
            AND SP.PAYMETHOD_ID = SPOC.PAYMETHOD_ID 
            AND SPOC.OUR_COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.company_id#">
    </cfquery>
    <cfquery name="GET_POSITION_DETAIL" datasource="#DSN#">
        SELECT UPPER_POSITION_CODE, UPPER_POSITION_CODE2 FROM EMPLOYEE_POSITIONS WHERE EMPLOYEE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.userid#"> AND IS_MASTER = 1
    </cfquery>
    <cfquery name="GET_REQUEST_STAGE" datasource="#DSN#">
        SELECT
            PTR.STAGE,
            PTR.PROCESS_ROW_ID 
        FROM
            PROCESS_TYPE_ROWS PTR,
            PROCESS_TYPE_OUR_COMPANY PTO,
            PROCESS_TYPE PT
        WHERE
            PT.IS_ACTIVE = 1 AND
            PT.PROCESS_ID = PTR.PROCESS_ID AND
            PT.PROCESS_ID = PTO.PROCESS_ID AND
            PTO.OUR_COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.company_id#"> AND
            PT.FACTION LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%myhome.form_add_payment_request%">
        ORDER BY 
            PTR.LINE_NUMBER
    </cfquery>
    <!--- akış parametresinde belirtilen avans tutar limitine gore alınabilecek max avans degeri hesaplanır --->
    <cfquery name="get_salary" datasource="#dsn#">
        SELECT 
            M#month(now())# SALARY,
            SALARY_TYPE
        FROM
            EMPLOYEES_SALARY ES,
            EMPLOYEES_IN_OUT EIO
        WHERE
            ES.IN_OUT_ID = EIO.IN_OUT_ID AND
            ES.EMPLOYEE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.userid#"> AND 
            ES.PERIOD_YEAR = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.period_year#"> 
            AND
            (
                (EIO.FINISH_DATE IS NULL AND EIO.START_DATE < <cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">)
                OR
                EIO.FINISH_DATE >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">
            )
    </cfquery>
    <cfquery name="get_in_out" datasource="#dsn#" maxrows="1">
        SELECT PUANTAJ_GROUP_IDS,BRANCH_ID FROM EMPLOYEES_IN_OUT WHERE EMPLOYEE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.userid#"> AND FINISH_DATE IS NULL ORDER BY START_DATE DESC
    </cfquery>
    <cfif get_in_out.recordcount>
        <cfset attributes.branch_id = get_in_out.branch_id>
        <cfif len(get_in_out.puantaj_group_ids)>
            <cfset attributes.group_id = "#get_in_out.puantaj_group_ids#,">
        </cfif>
    </cfif>
    <cfset attributes.sal_year = year(now())>
    <cfset attributes.sal_mon = month(now())>
    <cfinclude template="../hr/ehesap/query/get_program_parameter.cfm">
    <cfquery name="get_demand_type" datasource="#dsn#">
        SELECT * FROM SETUP_PAYMENT_INTERRUPTION WHERE ISNULL(IS_DEMAND,0) = 1
    </cfquery>
    <!--- gunluk-saatlik-aylık --->
    <cfif len(get_program_parameters.LIMIT_PAYMENT_REQUEST) and get_salary.recordcount>
        <cfquery name="get_monthly_work_hours" datasource="#dsn#">
            SELECT SSK_MONTHLY_WORK_HOURS FROM OUR_COMPANY_HOURS WHERE OUR_COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.company_id#">
        </cfquery>
        <cfif get_salary.salary_type eq 0>
            <cfset max_payment_request = get_salary.salary*get_program_parameters.LIMIT_PAYMENT_REQUEST/100*get_monthly_work_hours.SSK_MONTHLY_WORK_HOURS>
        <cfelseif get_salary.salary_type eq 1>
            <cfset max_payment_request = get_salary.salary*get_program_parameters.LIMIT_PAYMENT_REQUEST/100*30>
        <cfelse>
            <cfset max_payment_request = (get_salary.salary*get_program_parameters.LIMIT_PAYMENT_REQUEST)/100>
        </cfif>
    <cfelse>
        <cfset max_payment_request = 9999>
    </cfif>
    <cfquery name="get_last_payment_request" datasource="#dsn#">
        SELECT SUM(AMOUNT) AS TOTAL_AMOUNT FROM CORRESPONDENCE_PAYMENT WHERE TO_EMPLOYEE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.userid#"> AND YEAR(RECORD_DATE) = YEAR(GETDATE()) AND MONTH(RECORD_DATE) = MONTH(GETDATE()) AND (STATUS IS NULL OR STATUS = 1)
    </cfquery>
    <cfif get_last_payment_request.recordcount and get_last_payment_request.TOTAL_AMOUNT gt 0>
        <cfset max_payment_request = max_payment_request-get_last_payment_request.TOTAL_AMOUNT>
    </cfif>
    <!--- akış parametresinde belirtilen avans tutar limitine gore alınabilecek max avans degeri hesaplanır --->
    <cfif not get_request_stage.recordcount>
        <script type="text/javascript">
            alert('Avans Süreçleri Tanımlı Değil!');
            history.back();
        </script>
        <cfabort>
    </cfif>
    <cfquery name="GET_MONEYS" datasource="#DSN#">
        SELECT MONEY_ID,MONEY FROM SETUP_MONEY WHERE PERIOD_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.period_id#">
    </cfquery>
<cfelseif isdefined("attributes.event") and attributes.event is 'upd'>
    <cf_xml_page_edit fuseact="myhome.form_add_payment_request">
    <cfif fusebox.circuit eq 'myhome'>
        <cfset attributes.id = contentEncryptingandDecodingAES(isEncode:0,content:attributes.id,accountKey:'wrk')>
    </cfif>
    <cfquery name="GET_PRIORITY" datasource="#DSN#">
        SELECT PRIORITY_ID,PRIORITY FROM SETUP_PRIORITY
    </cfquery>
    <cfquery name="PAY_METHODS" datasource="#DSN#">
        SELECT 
            SP.PAYMETHOD_ID,
            SP.PAYMETHOD 
        FROM 
            SETUP_PAYMETHOD SP,
            SETUP_PAYMETHOD_OUR_COMPANY SPOC
        WHERE 
            SP.PAYMETHOD_STATUS = 1
            AND SP.PAYMETHOD_ID = SPOC.PAYMETHOD_ID 
            AND SPOC.OUR_COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.company_id#">
    </cfquery>
    <cfquery name="GET_MONEYS" datasource="#DSN#">
        SELECT MONEY_ID, MONEY FROM SETUP_MONEY WHERE PERIOD_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.period_id#"> 
    </cfquery>
    <cfquery name="GET_PAYMENT_REQUEST" datasource="#DSN#">
        SELECT * FROM CORRESPONDENCE_PAYMENT WHERE ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.id#"> 
    </cfquery>
    <cfif fuseaction contains "popup">
        <cfset is_popup=1>
    <cfelse>
        <cfset is_popup=0>
    </cfif>
    <cfquery name="get_salary" datasource="#dsn#">
        SELECT 
            M#month(now())# SALARY,
            SALARY_TYPE,
            EIO.IN_OUT_ID,
            EIO.PUANTAJ_GROUP_IDS,
            EIO.BRANCH_ID
        FROM
            EMPLOYEES_SALARY ES,
            EMPLOYEES_IN_OUT EIO
        WHERE
            ES.IN_OUT_ID = EIO.IN_OUT_ID AND
            ES.EMPLOYEE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.userid#"> AND 
            ES.PERIOD_YEAR = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.period_year#">
            AND
            (
                (EIO.FINISH_DATE IS NULL AND EIO.START_DATE < <cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">)
                OR
                (
                EIO.FINISH_DATE >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">
                )
            )
    </cfquery>
    <cfset attributes.sal_year = year(now())>
    <cfset attributes.sal_mon = month(now())>
    <cfif get_salary.recordcount>
        <cfset branch_id = get_salary.branch_id>
        <cfif len(get_salary.PUANTAJ_GROUP_IDS)>
            <cfset attributes.group_id = "#get_salary.PUANTAJ_GROUP_IDS#,">
        </cfif>
    </cfif>
    <cfset not_kontrol_parameter = 1>
    <cfinclude template="../hr/ehesap/query/get_program_parameter.cfm">
    <cfquery name="get_demand_type" datasource="#dsn#">
        SELECT * FROM SETUP_PAYMENT_INTERRUPTION WHERE ISNULL(IS_DEMAND,0) = 1
    </cfquery>
    <!--- gunluk-saatlik-aylık --->
    <cfif len(get_program_parameters.LIMIT_PAYMENT_REQUEST) and get_salary.recordcount>
        <cfquery name="get_monthly_work_hours" datasource="#dsn#">
            SELECT SSK_MONTHLY_WORK_HOURS FROM OUR_COMPANY_HOURS WHERE OUR_COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.company_id#">
        </cfquery>
        <cfif get_salary.salary_type eq 0>
            <cfset max_payment_request = get_salary.salary*get_program_parameters.LIMIT_PAYMENT_REQUEST/100*get_monthly_work_hours.SSK_MONTHLY_WORK_HOURS>
        <cfelseif get_salary.salary_type eq 1>
            <cfset max_payment_request = get_salary.salary*get_program_parameters.LIMIT_PAYMENT_REQUEST/100*30>
        <cfelse>
            <cfset max_payment_request = (get_salary.salary*get_program_parameters.LIMIT_PAYMENT_REQUEST)/100>
        </cfif>
    <cfelse>
        <cfset max_payment_request = 9999>
    </cfif>
    <cfquery name="get_last_payment_request" datasource="#dsn#">
        SELECT SUM(AMOUNT) AS TOTAL_AMOUNT FROM CORRESPONDENCE_PAYMENT WHERE ID <> <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.id#"> AND TO_EMPLOYEE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.userid#"> AND YEAR(RECORD_DATE) = YEAR(GETDATE()) AND MONTH(RECORD_DATE) = MONTH(GETDATE()) AND (STATUS IS NULL OR STATUS = 1)
    </cfquery>
    <cfif get_last_payment_request.recordcount and get_last_payment_request.TOTAL_AMOUNT gt 0>
        <cfset max_payment_request = max_payment_request-get_last_payment_request.TOTAL_AMOUNT>
    </cfif>
    
    <cfset emp_name="">
	<cfif len(get_payment_request.cc_emp) and isnumeric(get_payment_request.cc_emp)>
        <cfset EMP_ID=get_payment_request.cc_emp>
        <cfset emp_name= get_emp_info(EMP_ID,0,0)>
    </cfif>
<cfelseif isdefined("attributes.event") and attributes.event is 'upd_valid'>
	<cfif fusebox.circuit eq 'myhome'>
        <cfset attributes.id = contentEncryptingandDecodingAES(isEncode:0,content:attributes.id,accountKey:'wrk')>
    </cfif>
    <cfquery name="get_payment_request" datasource="#dsn#">
        SELECT 
            ID, 
            PROCESS_STAGE, 
            CC_EMP, 
            SUBJECT, 
            DUEDATE, 
            TO_EMPLOYEE_ID, 
            AMOUNT, 
            MONEY, 
            DETAIL, 
            STATUS, 
            VALID_EMP, 
            PERIOD_ID, 
            VALID_1, 
            VALIDATOR_POSITION_CODE_1, 
            VALID_EMPLOYEE_ID_1, 
            VALID_2, 
            VALIDATOR_POSITION_CODE_2,
            VALID_EMPLOYEE_ID_2, 
            VALID_1_DETAIL, 
            VALID_2_DETAIL, 
            ACTION_ID, 
            RECORD_EMP, 
            RECORD_DATE, 
            UPDATE_EMP, 
            UPDATE_DATE,
            DEMAND_TYPE
        FROM 
            CORRESPONDENCE_PAYMENT 
            <cfif isdefined('attributes.id')> 
                WHERE 
                ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.id#">
            </cfif>
    </cfquery>
    <cfquery name="get_emp_pos" datasource="#dsn#">
        SELECT POSITION_CODE FROM EMPLOYEE_POSITIONS WHERE EMPLOYEE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.userid#">
    </cfquery>
    <cfset pos_code_list = valuelist(get_emp_pos.position_code)>
    <!---İzinde olan kişilerin vekalet bilgileri alınıypr --->
    <cfquery name="Get_Offtime_Valid" datasource="#dsn#">
        SELECT
            O.EMPLOYEE_ID,
            EP.POSITION_CODE
        FROM
            OFFTIME O,
            EMPLOYEE_POSITIONS EP
        WHERE
            O.EMPLOYEE_ID = EP.EMPLOYEE_ID AND
            O.VALID = 1 AND
            #Now()# BETWEEN O.STARTDATE AND O.FINISHDATE
    </cfquery>
    <cfif Get_Offtime_Valid.recordcount>
        <cfset Now_Offtime_PosCode = ValueList(Get_Offtime_Valid.Position_Code)>
        <cfquery name="Get_StandBy_Position1" datasource="#dsn#"><!--- Asil Kisi Izinli ise ve 1.Yedek Izinli Degilse --->
            SELECT POSITION_CODE, CANDIDATE_POS_1 FROM EMPLOYEE_POSITIONS_STANDBY WHERE POSITION_CODE IN (<cfqueryparam cfsqltype="cf_sql_integer" list="true" value="#now_offtime_poscode#">) AND CANDIDATE_POS_1 IN (<cfqueryparam cfsqltype="cf_sql_integer" list="true" value="#pos_code_list#">)
        </cfquery>
        <cfoutput query="Get_StandBy_Position1">
            <cfset pos_code_list = ListAppend(pos_code_list,ValueList(Get_StandBy_Position1.Position_Code))>
        </cfoutput>
        <cfquery name="Get_StandBy_Position2" datasource="#dsn#"><!--- Asil Kisi, 1.Yedek Izinli ise ve 2.Yedek Izinli Degilse --->
            SELECT POSITION_CODE, CANDIDATE_POS_1, CANDIDATE_POS_2 FROM EMPLOYEE_POSITIONS_STANDBY WHERE POSITION_CODE IN (<cfqueryparam cfsqltype="cf_sql_integer" list="true" value="#now_offtime_poscode#">) AND CANDIDATE_POS_1 IN (<cfqueryparam cfsqltype="cf_sql_integer" list="true" value="#now_offtime_poscode#">) AND CANDIDATE_POS_2 IN (<cfqueryparam cfsqltype="cf_sql_integer" list="true" value="#pos_code_list#">)
        </cfquery>
        <cfoutput query="Get_StandBy_Position2">
            <cfset pos_code_list = ListAppend(pos_code_list,ValueList(Get_StandBy_Position2.Position_Code))>
        </cfoutput>
        <cfquery name="Get_StandBy_Position3" datasource="#dsn#"><!--- Asil Kisi, 1.Yedek,2.Yedek Izinli ise ve 3.Yedek Izinli Degilse --->
            SELECT POSITION_CODE, CANDIDATE_POS_1, CANDIDATE_POS_2 FROM EMPLOYEE_POSITIONS_STANDBY WHERE POSITION_CODE IN (<cfqueryparam cfsqltype="cf_sql_integer" list="true" value="#now_offtime_poscode#">) AND CANDIDATE_POS_1 IN (<cfqueryparam cfsqltype="cf_sql_integer" list="true" value="#now_offtime_poscode#">) AND CANDIDATE_POS_2 IN (<cfqueryparam cfsqltype="cf_sql_integer" list="true" value="#now_offtime_poscode#">) AND CANDIDATE_POS_3 IN (<cfqueryparam cfsqltype="cf_sql_integer" list="true" value="#pos_code_list#">)
        </cfquery>
        <cfoutput query="Get_StandBy_Position3">
            <cfset pos_code_list = ListAppend(pos_code_list,ValueList(Get_StandBy_Position3.Position_Code))>
        </cfoutput>
    </cfif>
    <cfif len(get_payment_request.demand_type)>
        <cfquery name="get_demand_type" datasource="#dsn#">
            SELECT COMMENT_PAY FROM SETUP_PAYMENT_INTERRUPTION WHERE ISNULL(IS_DEMAND,0) = 1 AND ODKES_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_payment_request.demand_type#">
        </cfquery>
   	</cfif>
    <cfset emp_name="">
	<cfif len(get_payment_request.CC_EMP) and isnumeric(get_payment_request.CC_EMP)>
        <cfset EMP_ID=get_payment_request.CC_EMP>
        <cfset emp_name= get_emp_info(get_payment_request.CC_EMP,0,0)>
    </cfif>
    <cfif len(get_payment_request.validator_position_code_1)>
		<cfset pos_temp_1 = "#get_emp_info(session.ep.position_code,1,0)#">
    <cfelse>
        <cfset pos_temp_1 = "">
    </cfif> 
    <cfif len(get_payment_request.validator_position_code_1)>
        <cfset pos_temp_1_ = "#get_emp_info(get_payment_request.validator_position_code_1,1,0)#">
    <cfelse>
        <cfset pos_temp_1_ = "">
    </cfif>
    <cfif len(get_payment_request.validator_position_code_2)>
		<cfset pos_temp_2 = "#get_emp_info(session.ep.position_code,1,0)#">
    <cfelse>
        <cfset pos_temp_2 = "">
    </cfif> 
    <cfif len(get_payment_request.validator_position_code_2)>
        <cfset pos_temp_2_ = "#get_emp_info(get_payment_request.validator_position_code_2,1,0)#">
    <cfelse>
        <cfset pos_temp_2_ = "">
    </cfif>
<cfelseif isdefined("attributes.event") and attributes.event is 'add_inst'>
    <cf_xml_page_edit fuseact="myhome.welcome">
    <cfparam name="attributes.sal_mon" default="1"> 
    <cfsavecontent variable="ay1"><cf_get_lang_main no='180.Ocak'></cfsavecontent>
    <cfsavecontent variable="ay2"><cf_get_lang_main no='181.Şubat'></cfsavecontent>
    <cfsavecontent variable="ay3"><cf_get_lang_main no='182.Mart'></cfsavecontent>
    <cfsavecontent variable="ay4"><cf_get_lang_main no='183.Nisan'></cfsavecontent>
    <cfsavecontent variable="ay5"><cf_get_lang_main no='184.Mayıs'></cfsavecontent>
    <cfsavecontent variable="ay6"><cf_get_lang_main no='185.Haziran'></cfsavecontent>
    <cfsavecontent variable="ay7"><cf_get_lang_main no='186.Temmuz'></cfsavecontent>
    <cfsavecontent variable="ay8"><cf_get_lang_main no='187.Ağustos'></cfsavecontent>
    <cfsavecontent variable="ay9"><cf_get_lang_main no='188.Eylül'></cfsavecontent>
    <cfsavecontent variable="ay10"><cf_get_lang_main no='189.Ekim'></cfsavecontent>
    <cfsavecontent variable="ay11"><cf_get_lang_main no='190.Kasım'></cfsavecontent>
    <cfsavecontent variable="ay12"><cf_get_lang_main no='191.Aralık'></cfsavecontent>
    <cfset ay_list = "#ay1#,#ay2#,#ay3#,#ay4#,#ay5#,#ay6#,#ay7#,#ay8#,#ay9#,#ay10#,#ay11#,#ay12#">
    
    <cfquery name="get_in_out" datasource="#dsn#">
        SELECT IN_OUT_ID FROM EMPLOYEES_IN_OUT WHERE EMPLOYEE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.userid#">
    </cfquery>
    <cfquery name="GET_POSITION_DETAIL" datasource="#dsn#">
        SELECT
            UPPER_POSITION_CODE,
            UPPER_POSITION_CODE2
        FROM
            EMPLOYEE_POSITIONS
        WHERE
            IS_MASTER = 1 AND
            EMPLOYEE_POSITIONS.EMPLOYEE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.userid#">
    </cfquery>
<cfelseif isdefined("attributes.event") and attributes.event is 'upd_other'>
	<cfif fusebox.circuit eq 'myhome'>
        <cfset attributes.id = contentEncryptingandDecodingAES(isEncode:0,content:attributes.id,accountKey:'wrk')>
    </cfif>
    <cfquery name="get_payment_request" datasource="#DSN#">
        SELECT * FROM SALARYPARAM_GET_REQUESTS WHERE SPGR_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.id#">
    </cfquery>
<cfelseif isdefined("attributes.event") and attributes.event is 'upd_other_valid'>  
	<cfif fusebox.circuit eq 'myhome'>
        <cfset attributes.id = contentEncryptingandDecodingAES(isEncode:0,content:attributes.id,accountKey:'wrk')>
    </cfif>
    <cfquery name="get_payment_request" datasource="#DSN#">
        SELECT 
            SPGR_ID, 
            AMOUNT_GET, 
            START_SAL_MON, 
            EMPLOYEE_ID, 
            DETAIL, 
            TAKSIT_NUMBER, 
            VALIDATOR_POSITION_CODE,
            VALID_EMP, 
            IS_VALID, 
            RECORD_DATE, 
            RECORD_IP, 
            RECORD_EMP, 
            UPDATE_DATE, 
            UPDATE_IP, 
            UPDATE_EMP, 
            VALID_1, 
            VALIDATOR_POSITION_CODE_1, 
            VALID_EMPLOYEE_ID_1, 
            VALIDDATE_1, 
            VALID_2, 
            VALIDATOR_POSITION_CODE_2, 
            VALID_EMPLOYEE_ID_2, 
            VALIDDATE_2 
        FROM 
            SALARYPARAM_GET_REQUESTS 
        WHERE 
            SPGR_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.id#">
    </cfquery>
    <cfquery name="GET_REQUEST_STAGE" datasource="#DSN#">
        SELECT
            PTR.STAGE,
            PTR.PROCESS_ROW_ID 
        FROM
            PROCESS_TYPE_ROWS PTR,
            PROCESS_TYPE_OUR_COMPANY PTO,
            PROCESS_TYPE PT
        WHERE
            PT.IS_ACTIVE = 1 AND
            PT.PROCESS_ID = PTR.PROCESS_ID AND
            PT.PROCESS_ID = PTO.PROCESS_ID AND
            PTO.OUR_COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.company_id#"> AND
            PT.FACTION LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%myhome.popupform_upd_other_payment_request_valid%">
        ORDER BY 
            PTR.LINE_NUMBER
    </cfquery>
    <cfif len(get_payment_request.validator_position_code_1)>
		<cfset pos_temp_1 = "#get_emp_info(get_payment_request.validator_position_code_1,1,0)#">
    <cfelse>
         <cfset pos_temp_1 = "">
    </cfif>
    <cfif len(get_payment_request.validator_position_code_2)>
		 <cfset pos_temp_2 = "#get_emp_info(get_payment_request.validator_position_code_2,1,0)#">
      <cfelse>
         <cfset pos_temp_2 = "">
      </cfif> 
</cfif>
<script type="text/javascript">
	<cfif (isdefined("attributes.event") and attributes.event is 'list') or not isdefined("attributes.event")>
		$(document).ready(function(){
			document.getElementById('keyword').focus();
		});
	<cfelseif isdefined("attributes.event") and attributes.event is 'add'>
		function change_upper_pos_codes()
		{
			var emp_upper_pos_code = wrk_query('SELECT UPPER_POSITION_CODE,UPPER_POSITION_CODE2,POSITION_CODE FROM EMPLOYEE_POSITIONS WHERE POSITION_CODE = '+document.form_add_payment_request.pos_code.value,'dsn');
			var emp_upper_pos_name = wrk_query('SELECT E.EMPLOYEE_NAME FROM EMPLOYEE_POSITIONS EP,EMPLOYEES E WHERE E.EMPLOYEE_ID = EP.EMPLOYEE_ID AND EP.POSITION_CODE = '+emp_upper_pos_code.UPPER_POSITION_CODE,'dsn');
			var emp_upper_pos_surname = wrk_query('SELECT E.EMPLOYEE_SURNAME FROM EMPLOYEE_POSITIONS EP,EMPLOYEES E WHERE E.EMPLOYEE_ID = EP.EMPLOYEE_ID AND EP.POSITION_CODE = '+emp_upper_pos_code.UPPER_POSITION_CODE,'dsn');
			var emp_upper_pos_name2 = wrk_query('SELECT E.EMPLOYEE_NAME  FROM EMPLOYEE_POSITIONS EP,EMPLOYEES E WHERE E.EMPLOYEE_ID = EP.EMPLOYEE_ID AND EP.POSITION_CODE = '+emp_upper_pos_code.UPPER_POSITION_CODE2,'dsn');
			var emp_upper_pos_surname2 = wrk_query('SELECT E.EMPLOYEE_SURNAME  FROM EMPLOYEE_POSITIONS EP,EMPLOYEES E WHERE E.EMPLOYEE_ID = EP.EMPLOYEE_ID AND EP.POSITION_CODE = '+emp_upper_pos_code.UPPER_POSITION_CODE2,'dsn');
			//akış parametresinde belirtilen avans tutar limitine gore alınabilecek max avans degeri hesaplanır
			var todayDate = new Date();
			var month_ = todayDate.getMonth()+1;
			var get_salary_ = wrk_query('SELECT M'+month_+' SALARY,SALARY_TYPE,BRANCH_ID,PUANTAJ_GROUP_IDS FROM EMPLOYEES_SALARY ES,EMPLOYEES_IN_OUT EIO WHERE ES.IN_OUT_ID = EIO.IN_OUT_ID AND ES.PERIOD_YEAR = <cfoutput>#session.ep.period_year#</cfoutput> AND ((EIO.FINISH_DATE IS NULL AND EIO.START_DATE < GETDATE()) OR (EIO.FINISH_DATE >= GETDATE())) AND EIO.EMPLOYEE_ID='+document.form_add_payment_request.emp_id.value,'dsn');
			var get_monthly_work_hours_ = wrk_query('SELECT SSK_MONTHLY_WORK_HOURS FROM OUR_COMPANY_HOURS  WHERE OUR_COMPANY_ID = <cfoutput>#session.ep.company_id#</cfoutput>','dsn');
			var get_last_payment_request_ = wrk_query('SELECT SUM(AMOUNT) AS TOTAL_AMOUNT FROM CORRESPONDENCE_PAYMENT WHERE TO_EMPLOYEE_ID = '+ document.getElementById('emp_id').value +' AND YEAR(RECORD_DATE) = YEAR(GETDATE()) AND MONTH(RECORD_DATE) = MONTH(GETDATE()) AND (STATUS IS NULL OR STATUS = 1)','dsn');
			var last_payment_request = 0;
			if(get_last_payment_request_.recordcount && get_last_payment_request_.TOTAL_AMOUNT > 0)
			{
				last_payment_request =  get_last_payment_request_.TOTAL_AMOUNT;
			}
			if(get_salary_.recordcount)
			{	
				var branch_id_ = get_salary_.BRANCH_ID;
				var group_id_ = get_salary_.PUANTAJ_GROUP_IDS+',';
				var sql = "SELECT LIMIT_PAYMENT_REQUEST,PARAMETER_ID FROM SETUP_PROGRAM_PARAMETERS  WHERE GETDATE() BETWEEN STARTDATE AND FINISHDATE AND ','+BRANCH_IDS+',' LIKE '%,"+branch_id_+",%' AND ";
				sql = sql+"(";
				if(group_id_ != '')
				{
					for(var jj=1;jj <= list_len(group_id_)-1;jj++)
					{
						if(list_len(group_id_)-1 != jj)
						{sql = sql+" ','+GROUP_IDS+',' LIKE '%,"+list_getat(group_id_,jj,',')+",%' OR ";}
						else
						{sql = sql+"','+GROUP_IDS+',' LIKE '%,"+list_getat(group_id_,jj,',')+",%'";}
					}
				}
				else
				{
					sql = sql+" GROUP_IDS IS NULL";	
				}
				sql=sql+")";
				var get_program_parameters_ = wrk_query(sql,'dsn');
				if(get_program_parameters_.recordcount > 1)
				{
					alert("Çalışanın akış parametresi birden fazla olamaz kontrol ediniz");
					return false;
				}
				if(get_program_parameters_.LIMIT_PAYMENT_REQUEST)
				{
					if(get_salary_.SALARY_TYPE == 0)
					{
						var max_payment_request_ = get_salary_.SALARY*get_program_parameters_.LIMIT_PAYMENT_REQUEST/100*get_monthly_work_hours_.SSK_MONTHLY_WORK_HOURS;
						document.getElementById('max_payment_request').value = max_payment_request_-last_payment_request;
					}
					else if(get_salary_.SALARY_TYPE == 1)
					{
						var max_payment_request_ = get_salary_.SALARY*get_program_parameters_.LIMIT_PAYMENT_REQUEST/100*30;
						document.getElementById('max_payment_request').value = max_payment_request_-last_payment_request;
					}
					else if(get_salary_.SALARY_TYPE == 2)
					{
						var max_payment_request_ = (get_salary_.SALARY*get_program_parameters_.LIMIT_PAYMENT_REQUEST)/100;
						document.getElementById('max_payment_request').value = max_payment_request_-last_payment_request;
					}
				}
			}
			else
			{
				var max_payment_request_ = 9999;
				document.getElementById('max_payment_request').value = max_payment_request_-last_payment_request;
			}
			//akış parametresinde belirtilen avans tutar limitine gore alınabilecek max avans degeri hesaplanır
			if(<cfoutput>#session.ep.position_code#</cfoutput> != document.form_add_payment_request.pos_code.value)
			{
				if(emp_upper_pos_code.UPPER_POSITION_CODE)
					document.getElementById('validator_pos_code').value = emp_upper_pos_code.UPPER_POSITION_CODE;
				else
					document.getElementById('validator_pos_code').value = '';
				if(emp_upper_pos_name.EMPLOYEE_NAME)
					document.getElementById('valid_name').value = emp_upper_pos_name.EMPLOYEE_NAME;
				else
					document.getElementById('valid_name').value = '';
				if(emp_upper_pos_surname.EMPLOYEE_SURNAME)
					document.getElementById('valid_name').value += ' ' + emp_upper_pos_surname.EMPLOYEE_SURNAME;
				else
					document.getElementById('valid_name').value = '';
				if(emp_upper_pos_code.UPPER_POSITION_CODE2)
					document.getElementById('validator_pos_code2').value = emp_upper_pos_code.UPPER_POSITION_CODE2;
				else
					document.getElementById('validator_pos_code2').value = '';
				if(emp_upper_pos_name2.EMPLOYEE_NAME)
					document.getElementById('valid_name2').value = emp_upper_pos_name2.EMPLOYEE_NAME;
				else
					document.getElementById('valid_name2').value = '';
				if(emp_upper_pos_surname2.EMPLOYEE_SURNAME)
					document.getElementById('valid_name2').value += ' ' + emp_upper_pos_surname2.EMPLOYEE_SURNAME;
				else
					document.getElementById('valid_name2').value = '';
			}
		}
		function unformat_fields()
		{
			form_add_payment_request.amount.value = filterNum(form_add_payment_request.amount.value);
			if(parseInt(document.getElementById('amount').value) > parseInt(document.getElementById('max_payment_request').value))
			{
				alert('Talep edilen avans max ' + document.getElementById('max_payment_request').value + ' olabilir!');
				return false;
			}
			x = (250 - form_add_payment_request.detail.value.length);
			if ( x < 0 )
			{ 
				alert ("<cf_get_lang_main no ='217.Açıklama'>"+ ((-1) * x) +"<cf_get_lang_main no='1741.Karakter Uzun'>");
				return false;
			}
			//form_add_payment_request.max_payment_request.value = filterNum(form_add_payment_request.max_payment_request.value);
			x = document.getElementById('demand_type').selectedIndex;
			if(document.form_add_payment_request.demand_type[x].value == -1)
			{
				alert("Avans tipi seçiniz");
				return false;
			}
			return process_cat_control();
		}
	<cfelseif isdefined("attributes.event") and attributes.event is 'upd'>
		function unformat_fields()
		{
			x = (250 - form_upd_payment_request.detail.value.length);
			if ( x < 0 )
			{ 
				alert ("<cf_get_lang_main no ='217.Açıklama'>"+ ((-1) * x) +" <cf_get_lang_main no='1741.Karakter Uzun'>");
				return false;
			}
			form_upd_payment_request.amount.value = filterNum(form_upd_payment_request.amount.value);
			return process_cat_control();
		}
		function delete_action()
		{
			window.location.href="<cfoutput>#request.self#?fuseaction=myhome.del_payment_request&id=#attributes.id#</cfoutput>";
		}
	<cfelseif isdefined("attributes.event") and attributes.event is 'add_inst'>
		function change_upper_pos_codes()
		{
			var emp_upper_pos_code = wrk_query('SELECT UPPER_POSITION_CODE,UPPER_POSITION_CODE2,POSITION_CODE FROM EMPLOYEE_POSITIONS WHERE EMPLOYEE_ID = '+document.add_request.employee_id.value,'dsn');
			var emp_upper_pos_name = wrk_query('SELECT E.EMPLOYEE_NAME FROM EMPLOYEE_POSITIONS EP,EMPLOYEES E WHERE E.EMPLOYEE_ID = EP.EMPLOYEE_ID AND EP.POSITION_CODE = '+emp_upper_pos_code.UPPER_POSITION_CODE,'dsn');
			var emp_upper_pos_surname = wrk_query('SELECT E.EMPLOYEE_SURNAME FROM EMPLOYEE_POSITIONS EP,EMPLOYEES E WHERE E.EMPLOYEE_ID = EP.EMPLOYEE_ID AND EP.POSITION_CODE = '+emp_upper_pos_code.UPPER_POSITION_CODE,'dsn');
			var emp_upper_pos_name2 = wrk_query('SELECT E.EMPLOYEE_NAME  FROM EMPLOYEE_POSITIONS EP,EMPLOYEES E WHERE E.EMPLOYEE_ID = EP.EMPLOYEE_ID AND EP.POSITION_CODE = '+emp_upper_pos_code.UPPER_POSITION_CODE2,'dsn');
			var emp_upper_pos_surname2 = wrk_query('SELECT E.EMPLOYEE_SURNAME  FROM EMPLOYEE_POSITIONS EP,EMPLOYEES E WHERE E.EMPLOYEE_ID = EP.EMPLOYEE_ID AND EP.POSITION_CODE = '+emp_upper_pos_code.UPPER_POSITION_CODE2,'dsn');
		
			if(<cfoutput>#session.ep.userid#</cfoutput> != document.add_request.employee_id.value)
			{
				if(emp_upper_pos_code.UPPER_POSITION_CODE)
					document.getElementById('validator_pos_code').value = emp_upper_pos_code.UPPER_POSITION_CODE;
				else
					document.getElementById('validator_pos_code').value = '';
				if(emp_upper_pos_name.EMPLOYEE_NAME)
					document.getElementById('valid_name').value = emp_upper_pos_name.EMPLOYEE_NAME;
				else
					document.getElementById('valid_name').value = '';
				if(emp_upper_pos_surname.EMPLOYEE_SURNAME)
					document.getElementById('valid_name').value += ' ' + emp_upper_pos_surname.EMPLOYEE_SURNAME;
				else
					document.getElementById('valid_name').value = '';
				if(emp_upper_pos_code.UPPER_POSITION_CODE2)
					document.getElementById('validator_pos_code2').value = emp_upper_pos_code.UPPER_POSITION_CODE2;
				else
					document.getElementById('validator_pos_code2').value = '';
				if(emp_upper_pos_name2.EMPLOYEE_NAME)
					document.getElementById('valid_name2').value = emp_upper_pos_name2.EMPLOYEE_NAME;
				else
					document.getElementById('valid_name2').value = '';
				if(emp_upper_pos_surname2.EMPLOYEE_SURNAME)
					document.getElementById('valid_name2').value += ' ' + emp_upper_pos_surname2.EMPLOYEE_SURNAME;
				else
					document.getElementById('valid_name2').value = '';
			}
		}
		
		function add_row(from_salary, show, comment_pay, period_pay, method_pay, term, start_sal_mon, end_sal_mon, amount_pay, calc_days,odkes_id)
		{
			document.add_request.odkes_id.value=odkes_id;
			document.add_request.from_salary.value=from_salary;
			document.add_request.show.value=show;
			document.add_request.comment_get.value=comment_pay;
			document.add_request.periyod_get.value=period_pay;
			document.add_request.method_get.value=method_pay;
			document.add_request.term.value=term;
			document.add_request.start_sal_mon.value=start_sal_mon;
			document.add_request.end_sal_mon.value=end_sal_mon;
			document.add_request.toplam_tutar.value=amount_pay;
			document.add_request.amount_get0.value=amount_pay;
			document.add_request.calc_days.value=calc_days;
			return true;
		}
		function tutar_göster(number)
		{
			if (document.add_request.comment_get.value == '')
			{
				alert("<cf_get_lang no ='1094.Avans Tipi Seçiniz'>!");
				document.add_request.ins_period.selectedIndex=0;
				return false;
			}	
			fiyat= document.add_request.toplam_tutar.value;
			fiyat = filterNum(fiyat);
			taksit_sayisi = number + 1;
			taksit= fiyat / taksit_sayisi;
			taksit =  commaSplit(taksit);
			for (i=0;i<=number;i++)
			{
				eleman = eval('tutar'+i);
				eleman.style.display = '';
				deger = eval("document.add_request.amount_get"+i);
				deger.value = taksit;
			}
			for (i=number+1;i<36;i++)
			{
				eleman = eval('tutar'+i);
				eleman.style.display = 'none';
			}
		}
		function hesapla()
		{
			fiyat= document.add_request.toplam_tutar.value;
			fiyat = filterNum(fiyat);
			taksit_sayisi = document.add_request.ins_period.value;
			taksit= fiyat / taksit_sayisi;
			taksit =  commaSplit(taksit);
			for (i=0;i<=(document.add_request.ins_period.value-1);i++)
			{
				
				deger = eval("document.add_request.amount_get"+i);
				deger.value = taksit;
			}
		}
		function kontrol()
		{
			if (document.add_request.comment_get.value =="")
				{
					alert("<cf_get_lang no ='1094.Avans Tipi Seçiniz'>!");
					return false;
				}
			if (document.add_request.toplam_tutar.value == "")
				{
					alert("<cf_get_lang_main no='1738.Lutfen Tutar Giriniz'>");
					return false;
				}
			return true;
		}
		function unformat_fields()
		{
			if(document.add_request.comment_get.value == '')
			{
				alert("<cf_get_lang no ='1094.Avans Tipi Seçiniz'>!");
				return false;
			}
			for(r=0;r<=(add_request.ins_period.value-1);r++)
			{
				eval('add_request.amount_get' + r).value = filterNum(eval('add_request.amount_get' + r).value,4);
			}
			add_request.toplam_tutar.value =  filterNum(add_request.toplam_tutar.value,4);
			return true;
		}
	<cfelseif isdefined("attributes.event") and attributes.event is 'upd_other'>
		function unformatFields()
		{
			form_upd_payment_request.AMOUNT_GET.value = filterNum(form_upd_payment_request.AMOUNT_GET.value);
			return true;
		}
		function kontrol()
		{
			if (form_upd_payment_request.AMOUNT_GET.value =='' || form_upd_payment_request.AMOUNT_GET.value ==0)
				{
					alert("Tutar Giriniz");
					return false;		
				}
		return true;
		}
	</cfif>
</script>
<cfscript>
	// Switch //
	WOStruct = StructNew();
	WOStruct['#attributes.fuseaction#'] = structNew();
	WOStruct['#attributes.fuseaction#']['default'] = 'list';
	
	if(not isdefined('attributes.event'))
		attributes.event = WOStruct['#attributes.fuseaction#']['default'];
	
	WOStruct['#attributes.fuseaction#']['list'] = structNew();
	WOStruct['#attributes.fuseaction#']['list']['window'] = 'normal';
	WOStruct['#attributes.fuseaction#']['list']['fuseaction'] = 'myhome.my_payment_request';
	WOStruct['#attributes.fuseaction#']['list']['filePath'] = 'myhome/display/list_payment_request.cfm';

	WOStruct['#attributes.fuseaction#']['add'] = structNew();
	WOStruct['#attributes.fuseaction#']['add']['window'] = 'normal';
	WOStruct['#attributes.fuseaction#']['add']['fuseaction'] = 'myhome.form_add_payment_request';
	WOStruct['#attributes.fuseaction#']['add']['filePath'] = 'myhome/form/add_payment_request.cfm';
	WOStruct['#attributes.fuseaction#']['add']['queryPath'] = 'myhome/query/add_payment_request.cfm';
	WOStruct['#attributes.fuseaction#']['add']['nextEvent'] = 'myhome.my_payment_request';
	
	WOStruct['#attributes.fuseaction#']['upd'] = structNew();
	WOStruct['#attributes.fuseaction#']['upd']['window'] = 'popup';
	WOStruct['#attributes.fuseaction#']['upd']['fuseaction'] = 'myhome.popupform_upd_payment_request';
	WOStruct['#attributes.fuseaction#']['upd']['filePath'] = 'myhome/form/upd_payment_request.cfm';
	WOStruct['#attributes.fuseaction#']['upd']['queryPath'] = 'myhome/query/upd_payment_request.cfm';
	WOStruct['#attributes.fuseaction#']['upd']['nextEvent'] = 'myhome.my_payment_request';
	WOStruct['#attributes.fuseaction#']['upd']['parameters'] = 'id=##attributes.id##';
	WOStruct['#attributes.fuseaction#']['upd']['Identity'] = '##attributes.id##';
	

	if(isdefined("attributes.event") and attributes.event is 'upd')
	{
		WOStruct['#attributes.fuseaction#']['del'] = structNew();
		WOStruct['#attributes.fuseaction#']['del']['window'] = 'emptypopup';
		WOStruct['#attributes.fuseaction#']['del']['fuseaction'] = 'myhome.del_payment_request&id=#attributes.id#';
		WOStruct['#attributes.fuseaction#']['del']['filePath'] = 'myhome/query/del_payment_request.cfm';
		WOStruct['#attributes.fuseaction#']['del']['queryPath'] = 'myhome/query/del_payment_request.cfm';
		WOStruct['#attributes.fuseaction#']['del']['nextEvent'] = 'myhome.my_payment_request';
	}	
	
	WOStruct['#attributes.fuseaction#']['upd_valid'] = structNew();
	WOStruct['#attributes.fuseaction#']['upd_valid']['window'] = 'popup';
	WOStruct['#attributes.fuseaction#']['upd_valid']['fuseaction'] = 'myhome.popupform_upd_payment_request_valid';
	WOStruct['#attributes.fuseaction#']['upd_valid']['filePath'] = 'myhome/form/upd_payment_request_valid.cfm';
	WOStruct['#attributes.fuseaction#']['upd_valid']['queryPath'] = 'myhome/query/upd_payment_request_valid.cfm';
	WOStruct['#attributes.fuseaction#']['upd_valid']['nextEvent'] = 'myhome.my_payment_request';
	WOStruct['#attributes.fuseaction#']['upd_valid']['parameters'] = 'id=##attributes.id##';
	WOStruct['#attributes.fuseaction#']['upd_valid']['Identity'] = '##attributes.id##';
	
	WOStruct['#attributes.fuseaction#']['add_inst'] = structNew();
	WOStruct['#attributes.fuseaction#']['add_inst']['window'] = 'normal';
	WOStruct['#attributes.fuseaction#']['add_inst']['fuseaction'] = 'myhome.form_add_inst_request';
	WOStruct['#attributes.fuseaction#']['add_inst']['filePath'] = 'myhome/form/form_add_inst_request.cfm';
	WOStruct['#attributes.fuseaction#']['add_inst']['queryPath'] = 'myhome/query/add_instution_request.cfm';
	WOStruct['#attributes.fuseaction#']['add_inst']['nextEvent'] = 'myhome.my_payment_request';
	
	WOStruct['#attributes.fuseaction#']['upd_other'] = structNew();
	WOStruct['#attributes.fuseaction#']['upd_other']['window'] = 'popup';
	WOStruct['#attributes.fuseaction#']['upd_other']['fuseaction'] = 'myhome.popupform_upd_other_payment_request';
	WOStruct['#attributes.fuseaction#']['upd_other']['filePath'] = 'myhome/form/upd_other_payment_request.cfm';
	WOStruct['#attributes.fuseaction#']['upd_other']['queryPath'] = 'myhome/query/upd_other_payment_request.cfm';
	WOStruct['#attributes.fuseaction#']['upd_other']['nextEvent'] = 'myhome.my_payment_request';
	WOStruct['#attributes.fuseaction#']['upd_other']['parameters'] = 'id=##attributes.id##';
	WOStruct['#attributes.fuseaction#']['upd_other']['Identity'] = '##attributes.id##';

	WOStruct['#attributes.fuseaction#']['upd_other_valid'] = structNew();
	WOStruct['#attributes.fuseaction#']['upd_other_valid']['window'] = 'popup';
	WOStruct['#attributes.fuseaction#']['upd_other_valid']['fuseaction'] = 'myhome.popupform_upd_other_payment_request_valid';
	WOStruct['#attributes.fuseaction#']['upd_other_valid']['filePath'] = 'myhome/form/upd_other_payment_request_valid.cfm';
	WOStruct['#attributes.fuseaction#']['upd_other_valid']['queryPath'] = 'myhome/query/upd_other_payment_request_valid.cfm';
	WOStruct['#attributes.fuseaction#']['upd_other_valid']['nextEvent'] = 'myhome.my_payment_request';
	WOStruct['#attributes.fuseaction#']['upd_other_valid']['parameters'] = 'id=##attributes.id##';
	WOStruct['#attributes.fuseaction#']['upd_other_valid']['Identity'] = '##attributes.id##';
	/*
	if(isdefined("attributes.event") and attributes.event is 'upd')
	{
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd'] = structNew();
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'] = structNew();
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][0]['text'] = '#lang_array_main.item[1040]#';
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][0]['onClick'] = "windowopen('#request.self#?fuseaction=account.popup_list_card_rows&action_id=#attributes.fis_id#&process_cat=upd_invent.old_process_type.value','page','add_process')";
		if(session.ep.our_company_info.guaranty_followup)
		{
			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][1]['text'] = '#lang_array_main.item[305]#-#lang_array_main.item[306]#';
			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][1]['onClick'] = "windowopen('#request.self#?fuseaction=stock.list_serial_operations&is_filtre=1&belge_no=#get_fis_det.fis_number#&process_cat_id=#get_fis_det.fis_type#&process_id=#attributes.fis_id#','page','add_process')";
		}
		
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['icons'] = structNew();
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['icons']['add']['text'] = 'Ekle';
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['icons']['add']['href'] = "#request.self#?fuseaction=invent.add_invent_stock_fis";
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['icons']['add']['target'] = "_blank";
		tabMenuData = SerializeJSON(tabMenuStruct['#attributes.fuseaction#']['tabMenus']);
	}*/
</cfscript>
