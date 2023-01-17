<cf_xml_page_edit fuseact='ehesap.offtimes'>
<cfsetting showdebugoutput="no">
<!--- KAYITLI İZNİN TARİHLERİNİ GETİR --->
<cfquery name="get_offtime" datasource="#dsn#">
	SELECT OFFTIMECAT_ID, EMPLOYEE_ID,STARTDATE, FINISHDATE, DETAIL, OFFTIME_STAGE, IS_PUANTAJ_OFF,IN_OUT_ID FROM OFFTIME WHERE OFFTIME_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#offtime_id#">
</cfquery>
<cfquery name="GET_OFFTIME_CAT" datasource="#dsn#">
	SELECT OFFTIMECAT FROM SETUP_OFFTIME WHERE OFFTIMECAT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_offtime.offtimecat_id#">
</cfquery>
<!--- onaylanan izin icin ajanda kaydi olusturur --->
<cfif attributes.valid_type eq 1 and is_view_agenda eq 1 and len(x_event_catid)>
	<cfquery name="GET_PROCESS_STAGE" datasource="#DSN#" maxrows="1">
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
			PT.FACTION LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%agenda.form_add_event%">
	</cfquery>
	<cfquery name="get_emp_name" datasource="#dsn#">
		SELECT EMPLOYEE_NAME + ' ' + EMPLOYEE_SURNAME AS EMPLOYEE_NAME FROM EMPLOYEES WHERE EMPLOYEE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_offtime.employee_id#">
	</cfquery>
	<cfquery name="get_upper_pos_code" datasource="#dsn#">
		SELECT UPPER_POSITION_CODE,UPPER_POSITION_CODE2 FROM EMPLOYEE_POSITIONS WHERE EMPLOYEE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_offtime.employee_id#">
	</cfquery>
	<cfset cc_pos_code_list = ''>
	<cfset cc_emp_id_list  = ''>
	<cfif len(get_upper_pos_code.UPPER_POSITION_CODE)>
		<cfset cc_pos_code_list = listappend(cc_pos_code_list,get_upper_pos_code.UPPER_POSITION_CODE,',')>
	</cfif>
	<cfif len(get_upper_pos_code.UPPER_POSITION_CODE2)>
		<cfset cc_pos_code_list = listappend(cc_pos_code_list,get_upper_pos_code.UPPER_POSITION_CODE2,',')>
	</cfif>
	<cfif ListLen(cc_pos_code_list)>
		<cfquery name="get_upper_emp_id" datasource="#dsn#">
			SELECT	
				E.EMPLOYEE_ID 
			FROM 
				EMPLOYEES E,
				EMPLOYEE_POSITIONS EP
			WHERE 
				E.EMPLOYEE_ID = EP.EMPLOYEE_ID AND 
				EP.POSITION_CODE IN (#cc_pos_code_list#)
		</cfquery>
		<cfset cc_emp_id_list = listappend(cc_emp_id_list,valuelist(get_upper_emp_id.employee_id),',')>
	</cfif>
</cfif>
<!--- //onaylanan izin icin ajanda kaydi olusturur --->

<!--- İLGİLİ ÇALIŞANIN İLGİLİ İZİN TARİHLERİNE RASLAYAN ve ONAYLANMIŞ BAŞKA BİR İZNİ VAR MI?  --->
<cfif isdefined('attributes.valid_type') and len(attributes.valid_type)>
	<cfquery name="get_control_val" datasource="#dsn#">
		SELECT 
             PROPERTY_VALUE,
             PROPERTY_NAME
       FROM
             FUSEACTION_PROPERTY
    	WHERE
             OUR_COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.company_id#"> AND
             FUSEACTION_NAME = <cfqueryparam cfsqltype="cf_sql_varchar" value="ehesap.form_add_offtime_popup"> AND
             PROPERTY_NAME = <cfqueryparam cfsqltype="cf_sql_varchar" value="x_day_control">
	</cfquery>
    
	<cfif attributes.valid_type eq 1>
    	<cfif not (get_offtime.is_puantaj_off eq 1 and get_control_val.property_value eq 1)>
            <cfquery name="get_other_offtimes" datasource="#dsn#">
                SELECT
                    VALID, 
                    EMPLOYEE_ID, 
                    OFFTIME_ID, 
                    OFFTIMECAT_ID, 
                    VALIDATOR_POSITION_CODE, 
                    VALID_EMPLOYEE_ID, 
                    VALIDDATE, 
                    DETAIL, 
                    STARTDATE, 
                    FINISHDATE, 
                    WORK_STARTDATE, 
                    TEL_CODE, 
                    TEL_NO, 
                    ADDRESS, 
                    RECORD_DATE,
                    RECORD_EMP, 
                    RECORD_IP, 
                    UPDATE_DATE, 
                    UPDATE_EMP, 
                    UPDATE_IP, 
                    DESERVE_DATE, 
                    IS_PUANTAJ_OFF, 
                    VALID_1, 
                    VALIDATOR_POSITION_CODE_1, 
                    VALID_EMPLOYEE_ID_1, 
                    VALID_2, 
                    VALIDATOR_POSITION_CODE_2, 
                    VALIDDATE_2, 
                    IS_ADDED_OFFTIME, 
                    OFFTIME_STAGE, 
                    IN_OUT_ID
                FROM
                    OFFTIME
                WHERE
                    EMPLOYEE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_offtime.employee_id#"> AND
                    <cfif len(get_offtime.in_out_id)>
                        IN_OUT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_offtime.in_out_id#"> AND
                    </cfif>
                    VALID = <cfqueryparam cfsqltype="cf_sql_bit" value="1"> AND
                    OFFTIME_ID <> <cfqueryparam cfsqltype="cf_sql_integer" value="#offtime_id#"> AND
                    (
                        (STARTDATE BETWEEN #createodbcdatetime(get_offtime.STARTDATE)# AND #createodbcdatetime(get_offtime.FINISHDATE)#) OR
                        (FINISHDATE BETWEEN #createodbcdatetime(get_offtime.STARTDATE)# AND #createodbcdatetime(get_offtime.FINISHDATE)#) OR
                        (STARTDATE <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#createodbcdatetime(get_offtime.startdate)#"> AND FINISHDATE >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#createodbcdatetime(get_offtime.finishdate)#">)
                    )
                    <cfif get_control_val.property_value eq 1>
                        AND IS_PUANTAJ_OFF = <cfqueryparam cfsqltype="cf_sql_bit" value="0">
                    </cfif>
            </cfquery>
           
            <cfif get_other_offtimes.recordcount>
                <script type="text/javascript">alert("<cf_get_lang dictionary_id='41547.Çalışanın Aynı Tarihlerde Onaylı İzni Bulunmaktadır İzni Onaylayamazsınız!'>");</script>
                <cfabort>
            </cfif>
        </cfif>
	</cfif>
	
	<cfquery name="upd_offtime" datasource="#dsn#">
		UPDATE 
			OFFTIME
		SET
			VALID_EMPLOYEE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.userid#">,
			VALIDDATE = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">,
			VALID = <cfqueryparam cfsqltype="cf_sql_bit" value="#valid_type#">,
			IS_PLAN = 0
		WHERE
			OFFTIME_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#offtime_id#">
	</cfquery>
	<cfif attributes.valid_type eq 1 and is_view_agenda eq 1 and len(x_event_catid)>
		<cfquery name="add_event" datasource="#dsn#">
			INSERT INTO 
				EVENT
			   (
				   OFFTIME_ID,
				   EVENTCAT_ID,
				   STARTDATE,
				   FINISHDATE,
				   EVENT_HEAD,
				   EVENT_DETAIL,
				   EVENT_TO_POS,
				   EVENT_CC_POS,
				   VALID,
				   VALIDATOR_POSITION_CODE,
				   VALID_EMP,
				   VALID_DATE,
				   VIEW_TO_ALL,
				   RECORD_DATE,
				   RECORD_EMP,
				   RECORD_IP,
				   EVENT_STAGE
				)
			 VALUES
			   (
					<cfqueryparam cfsqltype="cf_sql_integer" value="#offtime_id#">,
					<cfqueryparam cfsqltype="cf_sql_integer" value="#x_event_catid#">,
					<cfqueryparam cfsqltype="cf_sql_timestamp" value="#createodbcdatetime(get_offtime.startdate)#">,
					<cfqueryparam cfsqltype="cf_sql_timestamp" value="#createodbcdatetime(get_offtime.finishdate)#">,
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#get_emp_name.employee_name#-#get_offtime_cat.offtimecat#">,
					'#get_emp_name.employee_name# #dateformat(get_offtime.startdate,dateformat_style)# #timeformat(date_add('h',session.ep.time_zone,get_offtime.startdate),timeformat_style)# - #dateformat(get_offtime.finishdate,dateformat_style)# #timeformat(date_add('h',session.ep.time_zone,get_offtime.finishdate),timeformat_style)# tarihleri arasında izinlidir.',
					<cfqueryparam cfsqltype="cf_sql_varchar" value=",#get_offtime.employee_id#,">,
					',#cc_emp_id_list#,',
					<cfqueryparam cfsqltype="cf_sql_bit" value="1">,
					<cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.position_code#">,
					<cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.userid#">,
					<cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">,
					<cfqueryparam cfsqltype="cf_sql_integer" value="1">,
					<cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">,
					<cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.userid#">,
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#cgi.remote_addr#">,
					<cfqueryparam cfsqltype="cf_sql_integer" value="#get_process_stage.process_row_id#">
					
			   )
		</cfquery>
	</cfif>
	<!--- //onaylanan izin icin ajanda kaydi olusturur --->
</cfif>
<cfif Len(get_offtime.Offtime_stage)>
<cf_workcube_process 
	is_upd='1' 
	data_source='#dsn#' 
	old_process_line='0'
	process_stage='#get_offtime.Offtime_stage#' 
	record_member='#session.ep.userid#'
	record_date='#now()#' 
	action_table='OFFTIME'
	action_column='OFFTIME_ID'
	action_id='#offtime_id#' 
	action_page='#request.self#?fuseaction=ehesap.offtimes&event=upd&offtime_id=#offtime_id#' 
	warning_description='İzin  : #offtime_id#'>
</cfif>
<cfquery name="get_employee_info" datasource="#dsn#">
	SELECT 
        EMPLOYEE_ID, 
        EMPLOYEE_NAME, 
        EMPLOYEE_SURNAME, 
        COMPANY_ID, 
        RECORD_DATE, 
        RECORD_EMP, 
        RECORD_IP, 
        UPDATE_DATE, 
        UPDATE_EMP, 
        UPDATE_IP, 
        IZIN_DAYS 
    FROM 
	    EMPLOYEES 
    WHERE 
    	EMPLOYEE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.userid#">
</cfquery>
<script type="text/javascript">
	<cfif isdefined('offtime_id') and valid_type eq 1>
		document.getElementById('valid_status_<cfoutput>#offtime_id#</cfoutput>').innerHTML = 'Onaylandı&nbsp;<cfoutput>#get_employee_info.employee_name#&nbsp;#get_employee_info.employee_surname#</cfoutput>';
	<cfelseif isdefined('offtime_id') and valid_type eq 0>
		document.getElementById('valid_status_<cfoutput>#offtime_id#</cfoutput>').innerHTML = 'Onaylanmadı&nbsp;<cfoutput>#get_employee_info.employee_name#&nbsp;#get_employee_info.employee_surname#</cfoutput>';
	</cfif>
		//document.getElementById('offtime_valid<cfoutput>#attributes.offtime_id#</cfoutput>').style.display = 'none';
</script>
