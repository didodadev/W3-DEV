<cf_get_lang_set module_name="myhome">
<cfif (isdefined("attributes.event") and attributes.event is 'list') or not isdefined("attributes.event")>
	<cfif isdefined("attributes.employee_id") and len(attributes.employee_id)>
        <cfparam name="attributes.employee_id" default="#attributes.employee_id#">
    <cfelse>
        <cfparam name="attributes.employee_id" default="#session.ep.userid#">
    </cfif>
    <cfparam name="attributes.emp_name" default="get_emp_info(session.ep.userid,0,0)">
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
            <cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#"> BETWEEN O.STARTDATE AND O.FINISHDATE
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
    <cfset puantaj_gun_ = daysinmonth(now())>
    <cfset puantaj_start_ = CREATEODBCDATETIME(CREATEDATE(year(now()),month(now()),1))>
    <cfset puantaj_finish_ = CREATEODBCDATETIME(date_add("d",1,CREATEDATE(year(now()),month(now()),puantaj_gun_)))>
    <cfset gecen_ay_ = date_add("m",-1,puantaj_start_)>
    <cfif isdefined("attributes.startdate") and len(attributes.startdate)>
        <cf_date tarih="attributes.startdate">
    <cfelse>
        <cfparam name="attributes.startdate" default="">
    </cfif>
    <cfif isdefined("attributes.finishdate") and len(attributes.finishdate)>
        <cf_date tarih="attributes.finishdate">
    <cfelse>
        <cfparam name="attributes.finishdate" default="">
    </cfif>
    <cfquery name="get_ext_worktimes" datasource="#dsn#">
        SELECT
            EMPLOYEES_EXT_WORKTIMES.*,
            EMPLOYEES.EMPLOYEE_NAME,
            EMPLOYEES.EMPLOYEE_SURNAME,
            BRANCH.BRANCH_NAME
        FROM
            EMPLOYEES_EXT_WORKTIMES,
            EMPLOYEES,
            BRANCH,
    
            EMPLOYEES_IN_OUT
        WHERE
            EMPLOYEES.EMPLOYEE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.employee_id#"> AND
            EMPLOYEES.EMPLOYEE_ID = EMPLOYEES_IN_OUT.EMPLOYEE_ID
            AND EMPLOYEES_IN_OUT.EMPLOYEE_ID = EMPLOYEES_EXT_WORKTIMES.EMPLOYEE_ID
            AND EMPLOYEES_IN_OUT.IN_OUT_ID = EMPLOYEES_EXT_WORKTIMES.IN_OUT_ID
            AND EMPLOYEES_IN_OUT.BRANCH_ID = BRANCH.BRANCH_ID
            <cfif isdefined("attributes.startdate") and len(attributes.startdate) and isdefined("attributes.finishdate") and len(attributes.finishdate)>
                AND EMPLOYEES_EXT_WORKTIMES.START_TIME BETWEEN <cfqueryparam cfsqltype="cf_sql_date" value="#attributes.startdate#"> AND <cfqueryparam cfsqltype="cf_sql_date" value="#attributes.finishdate#">
            <cfelse>
                AND EMPLOYEES_EXT_WORKTIMES.START_TIME BETWEEN <cfqueryparam cfsqltype="cf_sql_timestamp" value="#gecen_ay_#"> AND <cfqueryparam cfsqltype="cf_sql_timestamp" value="#puantaj_finish_#"> 
            </cfif>
        ORDER BY
            EMPLOYEES_EXT_WORKTIMES.START_TIME DESC,
            EMPLOYEES_EXT_WORKTIMES.RECORD_DATE DESC,		
            EMPLOYEES.EMPLOYEE_NAME ASC,
            EMPLOYEES.EMPLOYEE_SURNAME ASC
    </cfquery>
    <cfquery name="get_other_ext_worktimes" datasource="#dsn#">
        SELECT
            EMPLOYEES_EXT_WORKTIMES.EWT_ID,
            EMPLOYEES_EXT_WORKTIMES.EMPLOYEE_ID,
            EMPLOYEES_EXT_WORKTIMES.START_TIME,
            EMPLOYEES_EXT_WORKTIMES.DAY_TYPE,
            EMPLOYEES_EXT_WORKTIMES.END_TIME,
            EMPLOYEES_EXT_WORKTIMES.RECORD_DATE,
            EMPLOYEES_EXT_WORKTIMES.VALIDATOR_POSITION_CODE_1,
            EMPLOYEES_EXT_WORKTIMES.VALIDATOR_POSITION_CODE_2,
            EMPLOYEES_EXT_WORKTIMES.VALID_EMPLOYEE_ID_1,
            EMPLOYEES_EXT_WORKTIMES.VALID_EMPLOYEE_ID_2,
            EMPLOYEES_EXT_WORKTIMES.VALID_1,
            EMPLOYEES_EXT_WORKTIMES.VALID_2,
            EMPLOYEES.EMPLOYEE_NAME,
            EMPLOYEES.EMPLOYEE_SURNAME,
            BRANCH.BRANCH_NAME
        FROM
            EMPLOYEES_EXT_WORKTIMES,
            EMPLOYEES,
            BRANCH,
            EMPLOYEES_IN_OUT
        WHERE
            ((EMPLOYEES_EXT_WORKTIMES.VALIDATOR_POSITION_CODE_1 IN (<cfqueryparam cfsqltype="cf_sql_integer" list="true" value="#pos_code_list#">) AND EMPLOYEES_EXT_WORKTIMES.VALID_1 IS NULL) OR
            (EMPLOYEES_EXT_WORKTIMES.VALIDATOR_POSITION_CODE_2 IN (<cfqueryparam cfsqltype="cf_sql_integer" list="true" value="#pos_code_list#">) AND EMPLOYEES_EXT_WORKTIMES.VALID_2 IS NULL AND
            EMPLOYEES_EXT_WORKTIMES.VALIDATOR_POSITION_CODE_1 IS NOT NULL AND EMPLOYEES_EXT_WORKTIMES.VALID_1 = 1))
            AND EMPLOYEES.EMPLOYEE_ID = EMPLOYEES_IN_OUT.EMPLOYEE_ID
            AND EMPLOYEES_IN_OUT.EMPLOYEE_ID = EMPLOYEES_EXT_WORKTIMES.EMPLOYEE_ID
            AND EMPLOYEES_IN_OUT.IN_OUT_ID = EMPLOYEES_EXT_WORKTIMES.IN_OUT_ID
            AND EMPLOYEES_IN_OUT.BRANCH_ID = BRANCH.BRANCH_ID
            AND EMPLOYEES_EXT_WORKTIMES.START_TIME BETWEEN <cfqueryparam cfsqltype="cf_sql_timestamp" value="#gecen_ay_#"> AND <cfqueryparam cfsqltype="cf_sql_timestamp" value="#puantaj_finish_#">
        ORDER BY
            EMPLOYEES_EXT_WORKTIMES.START_TIME DESC,
            EMPLOYEES_EXT_WORKTIMES.RECORD_DATE DESC,		
            EMPLOYEES.EMPLOYEE_NAME ASC,
            EMPLOYEES.EMPLOYEE_SURNAME ASC
    </cfquery>
    <cfquery name="get_position_code" datasource="#dsn#">
        SELECT POSITION_CODE FROM EMPLOYEE_POSITIONS WHERE EMPLOYEE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.employee_id#"> AND IS_MASTER = 1
    </cfquery>
      <cfif get_other_ext_worktimes.recordcount>
        <cfoutput query="get_other_ext_worktimes"> 
            <cfif fusebox.circuit eq 'myhome'>
                <cfset ewt_id_ = contentEncryptingandDecodingAES(isEncode:1,content:ewt_id,accountKey:'wrk')>
            <cfelse>
                <cfset ewt_id_ = ewt_id>
            </cfif>
        </cfoutput>
    </cfif>
<cfelseif isdefined("attributes.event") and attributes.event is 'add'>
    <cfscript>
        last_in_out_id = createObject("component","myhome.cfc.get_last_in_out");
        last_in_out_id.dsn = dsn;
        get_last_in_out = last_in_out_id.last_in_out
                        (
                            employee_id : session.ep.userid
                        );
    </cfscript>
<cfelseif isdefined("attributes.event") and attributes.event is 'upd_other'>
	<cfif fusebox.circuit eq 'myhome'>
    	<cfset attributes.ewt_id = contentEncryptingandDecodingAES(isEncode:0,content:attributes.ewt_id,accountKey:'wrk')>
    </cfif>
    <cfquery name="get_payment_request" datasource="#dsn#">
        SELECT
            *
        FROM
            EMPLOYEES_EXT_WORKTIMES	
        WHERE
            EWT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.ewt_id#">
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
		function showDepartment(branch_id)	
		{
			var branch_id = document.search.branch_id.value;
			if (branch_id != "")
			{
				var send_address = "<cfoutput>#request.self#</cfoutput>?fuseaction=hr.popup_ajax_list_hr&branch_id="+branch_id;
				AjaxPageLoad(send_address,'DEPARTMENT_PLACE',1,'İlişkili Departmanlar');
			}
		}
		function kontrol()
		{
			if(!date_check(document.list_ext_worktimes.startdate, document.list_ext_worktimes.finishdate, "<cf_get_lang_main no='1450.Başlangıç Tarihi Bitiş Tarihinden Büyük Olamaz!'>") )
				return false;
			else
				return true;
		}
	<cfelseif isdefined("attributes.event") and attributes.event is 'add'>	
		function check_()
		{
			if (document.getElementById('start_hour').selectedIndex > document.getElementById('end_hour').selectedIndex)
			{
				alert("<cf_get_lang no='648.Başlangıç Saati Bitiş saatinden büyük olamaz'> !");
				return false;
			}
			else if ((document.getElementById('start_hour').selectedIndex == document.getElementById('end_hour').selectedIndex) && (document.getElementById('start_min').selectedIndex >= document.getElementById('end_min').selectedIndex))
			{
				alert("<cf_get_lang no='649.Başlangıç Saati Bitiş saatinden büyük veya eşit olamaz'> !");
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
	
	WOStruct['#attributes.fuseaction#']['list'] = structNew();
	WOStruct['#attributes.fuseaction#']['default'] = 'list';
	WOStruct['#attributes.fuseaction#']['list']['window'] = 'normal';
	WOStruct['#attributes.fuseaction#']['list']['fuseaction'] = 'myhome.list_my_extra_times';
	WOStruct['#attributes.fuseaction#']['list']['filePath'] = 'myhome/display/list_my_extra_worktimes.cfm';	
	
	WOStruct['#attributes.fuseaction#']['add'] = structNew();
	WOStruct['#attributes.fuseaction#']['add']['window'] = 'popup';
	WOStruct['#attributes.fuseaction#']['add']['fuseaction'] = 'myhome.form_add_ext_worktime_popup';
	WOStruct['#attributes.fuseaction#']['add']['filePath'] = 'myhome/form/form_add_ext_worktime.cfm';
	WOStruct['#attributes.fuseaction#']['add']['queryPath'] = 'myhome/query/add_ext_worktime.cfm';
	WOStruct['#attributes.fuseaction#']['add']['nextEvent'] = 'myhome.list_my_extra_times';
	
	WOStruct['#attributes.fuseaction#']['upd_other'] = structNew();
	WOStruct['#attributes.fuseaction#']['upd_other']['window'] = 'popup';
	WOStruct['#attributes.fuseaction#']['upd_other']['fuseaction'] = 'myhome.popupform_upd_worktime_request_valid';
	WOStruct['#attributes.fuseaction#']['upd_other']['filePath'] = 'myhome/form/upd_worktime_request_valid.cfm';
</cfscript>
