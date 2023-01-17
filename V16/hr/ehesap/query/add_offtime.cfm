<!--- Yükleme klasörü yoksa oluşturuyor. --->
<cfif Not directoryExists('#upload_folder##dir_seperator#hr#dir_seperator#offtime')>
	<cfdirectory action="create" directory="#upload_folder##dir_seperator#hr#dir_seperator#offtime">
</cfif>
<!--- Seçilen kategori için belge ekleme zorunluysa, ekleme işlemini yapıyor. --->
<cfif isdefined("template_file") and len(template_file)>
	<cftry>
		<cfset file_name = createUUID()>
		<cffile action="UPLOAD" nameconflict="MAKEUNIQUE" filefield="template_file" destination="#upload_folder#hr/offtime">
		<cffile action="rename" source="#upload_folder#hr/offtime#dir_seperator##cffile.serverfile#" destination="#upload_folder#hr/offtime#dir_seperator##file_name#.#cffile.serverfileext#">
		<cfcatch>
			<script type="text/javascript">
				alert("<cf_get_lang_main no='43.Dosyaniz Upload Edilemedi Lütfen Konrol Ediniz '>!");
				history.back();
			</script>
			<cfabort>
		</cfcatch>
	</cftry>
</cfif>
<cf_get_lang_set module_name="ehesap">
<cfset attributes.OFFTIME_CAT_ID = attributes.OFFTIMECAT_ID>
<cfinclude template="get_offtime_cat.cfm">
<cf_date tarih="attributes.startdate">
<cfset attributes.startdate = date_add("h", start_clock-session.ep.time_zone, attributes.startdate)>
<cfset attributes.startdate = date_add("n", start_minute, attributes.startdate)>
<cf_date tarih="attributes.finishdate">
<cfset attributes.finishdate = date_add("h", finish_clock-session.ep.time_zone, attributes.finishdate)>
<cfset attributes.finishdate = date_add("n", finish_minute, attributes.finishdate)>
<cf_date tarih="attributes.work_startdate">
<cfset attributes.work_startdate = date_add("h", work_start_clock-session.ep.time_zone, attributes.work_startdate)>
<cfset attributes.work_startdate = date_add("n", work_start_minute, attributes.work_startdate)>
<cfif len(attributes.offtime_deserve_date) and isdate(attributes.offtime_deserve_date)>
	<cf_date tarih="attributes.offtime_deserve_date">
</cfif>

<cfif isdefined("attributes.valid") and attributes.valid eq 1>
	<!--- İLGİLİ ÇALIŞANIN İLGİLİ İZİN TARİHLERİNE RASLAYAN ve ONAYLANMIŞ BAŞKA BİR İZNİ VAR MI?  --->
    <cfif not ((isdefined("attributes.is_puantaj_off")) and attributes.x_day_control eq 1)>
        <cfquery name="get_other_offtimes" datasource="#dsn#">
            SELECT
                *
            FROM
                OFFTIME
				INNER JOIN SETUP_OFFTIME ON SETUP_OFFTIME.OFFTIMECAT_ID = OFFTIME.OFFTIMECAT_ID
            WHERE
                OFFTIME.EMPLOYEE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#employee_id#"> AND
                <cfif len(attributes.in_out_id)>
                    OFFTIME.IN_OUT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.in_out_id#"> AND
                </cfif>
				OFFTIME.VALID = 1 AND
				SETUP_OFFTIME.EBILDIRGE_TYPE_ID <> 18 AND
                (
                    ( OFFTIME.STARTDATE BETWEEN <cfqueryparam cfsqltype="cf_sql_timestamp" value="#createodbcdatetime(attributes.startdate)#"> AND <cfqueryparam cfsqltype="cf_sql_timestamp" value="#createodbcdatetime(attributes.finishdate)#">) OR
                    ( OFFTIME.FINISHDATE BETWEEN <cfqueryparam cfsqltype="cf_sql_timestamp" value="#createodbcdatetime(attributes.startdate)#"> AND <cfqueryparam cfsqltype="cf_sql_timestamp" value="#createodbcdatetime(attributes.finishdate)#">) OR
                    ( OFFTIME.STARTDATE <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#createodbcdatetime(attributes.startdate)#"> AND  OFFTIME.FINISHDATE >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#createodbcdatetime(attributes.finishdate)#">)
                )
                <cfif attributes.x_day_control eq 1>
                    AND IS_PUANTAJ_OFF = 0
                </cfif>
        </cfquery>
        
        <cfif get_other_offtimes.RecordCount>
            <script type="text/javascript">
                alert('Çalışanın aynı tarihlerle çakışan onaylanmış bir izni var!');
                history.back();
            </script>
            <cfabort>
        </cfif>
    </cfif>
</cfif>

<cfquery name="GET_OFFTIME_CAT" datasource="#dsn#">
	SELECT IS_YEARLY,EBILDIRGE_TYPE_ID,OFFTIMECAT FROM SETUP_OFFTIME WHERE OFFTIMECAT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.offtimecat_id#">
</cfquery>

<cfif get_offtime_cat.is_yearly eq 1>
	<cfif datediff("d",attributes.startdate,attributes.finishdate) gt 30>
		<script type="text/javascript">
			alert('30 Günden Fazla Yıllık İzin Girdiniz!');
		</script>
	</cfif>
</cfif>

<cfquery name="add_offtime" datasource="#dsn#" result="MAX_ID">
	INSERT INTO
		OFFTIME
	(
		IN_OUT_ID,
		RECORD_IP,
		RECORD_EMP,
		RECORD_DATE,
		IS_PUANTAJ_OFF,
		EMPLOYEE_ID,
		OFFTIMECAT_ID,
		SUB_OFFTIMECAT_ID,
		DESERVE_DATE,
		STARTDATE,
		FINISHDATE,
		WORK_STARTDATE,
		TOTAL_HOURS,
		<cfif len(form.tel_code)>TEL_CODE,</cfif>
		<cfif len(form.tel_no)>TEL_NO,</cfif>
		<cfif len(form.address)>ADDRESS,</cfif>
	    <cfif isdefined("attributes.valid") and len(attributes.valid)>
			VALID_EMPLOYEE_ID,
			VALIDDATE,
			VALID,
		</cfif>
		DETAIL,
		SHORT_WORKING_RATE,
		SHORT_WORKING_HOURS,
        FIRST_WEEK_CALCULATION,
		OFFTIME_STAGE,
		FILE_NAME
	)
	VALUES
	(
		<cfif len(attributes.in_out_id)> <!---GET_OFFTIME_CAT.EBILDIRGE_TYPE_ID is '06' and --->
        	<cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.in_out_id#">,
        <cfelse>
        	NULL,
        </cfif>
		<cfqueryparam cfsqltype="cf_sql_varchar" value="#cgi.remote_addr#">,
		<cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.userid#">,
		<cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">,
		<cfif isdefined("attributes.is_puantaj_off")>1,<cfelse>0,</cfif>
		<cfqueryparam cfsqltype="cf_sql_integer" value="#employee_id#">,
		<cfqueryparam cfsqltype="cf_sql_integer" value="#offtimecat_id#">,
		<cfif isdefined("attributes.SUB_OFFTIMECAT_ID") and len(attributes.SUB_OFFTIMECAT_ID)><cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.sub_offtimecat_id#"><cfelse>0</cfif>,
		<cfif len(attributes.offtime_deserve_date) and isdate(attributes.offtime_deserve_date)><cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.offtime_deserve_date#">,<cfelse>NULL,</cfif>
		<cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.startdate#">,
		<cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.finishdate#">,
		<cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.work_startdate#">,
		0,
	 	<cfif len(form.tel_code)><cfqueryparam cfsqltype="cf_sql_varchar" value="#form.tel_code#">,</cfif>
	 	<cfif len(form.tel_no)><cfqueryparam cfsqltype="cf_sql_varchar" value="#tel_no#">,</cfif>
	 	<cfif len(form.address)><cfqueryparam cfsqltype="cf_sql_varchar" value="#address#">,</cfif>
	     <cfif isdefined("attributes.valid") and len(attributes.valid)>
	     	<cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.userid#">,
	        <cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">,
	        <cfqueryparam cfsqltype="cf_sql_bit" value="#attributes.valid#">,
	     </cfif>
		<cfif len(form.DETAIL)><cfqueryparam cfsqltype="cf_sql_varchar" value="#form.detail#"><cfelse>NULL</cfif>,
		<cfif isdefined("attributes.short_working_rate") and len(attributes.short_working_rate)><cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.short_working_rate#"><cfelse>NULL</cfif>,
		<cfif isdefined("attributes.short_working_hours") and len(attributes.short_working_hours)><cfqueryparam cfsqltype="cf_sql_float" value="#attributes.short_working_hours#"><cfelse>NULL</cfif>,
        <cfif isdefined("attributes.first_week_calculation") and len(attributes.first_week_calculation)><cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.first_week_calculation#"><cfelse>NULL</cfif>,
		<cfif isdefined('attributes.process_stage') and len(attributes.process_stage)><cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.process_stage#"><cfelse>NULL</cfif>,
		<cfif isdefined("template_file") and len(template_file)>
			<cfqueryparam cfsqltype="cf_sql_varchar" value="#file_name#.#cffile.serverfileext#">
		<cfelse>
			NULL
		</cfif>
		
	)
</cfquery>

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
<cfquery name="get_xml_agenda" datasource="#DSN#" maxrows="1">
	SELECT 
		PROPERTY_VALUE,
		PROPERTY_NAME
	FROM
		FUSEACTION_PROPERTY
	WHERE
		OUR_COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.company_id#"> AND
		FUSEACTION_NAME = <cfqueryparam cfsqltype="cf_sql_varchar" value="ehesap.offtimes"> AND
		PROPERTY_NAME = <cfqueryparam cfsqltype="cf_sql_varchar" value="is_view_agenda">
</cfquery>
<cfquery name="get_xml_eventcat" datasource="#DSN#" maxrows="1">
	SELECT 
		PROPERTY_VALUE,
		PROPERTY_NAME
	FROM
		FUSEACTION_PROPERTY
	WHERE
		OUR_COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.company_id#"> AND
		FUSEACTION_NAME = <cfqueryparam cfsqltype="cf_sql_varchar" value="ehesap.offtimes"> AND
		PROPERTY_NAME = <cfqueryparam cfsqltype="cf_sql_varchar" value="x_event_catid">
</cfquery>

<cfquery name="getEmpName" datasource="#dsn#">
	SELECT EMPLOYEE_NAME+' '+EMPLOYEE_SURNAME AS EMPLOYEE FROM EMPLOYEES WHERE EMPLOYEE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.employee_id#">
</cfquery>
<cf_workcube_process 
	is_upd='1' 
	data_source='#dsn#' 
	old_process_line='0'
	process_stage='#attributes.process_stage#' 
	record_member='#session.ep.userid#' 
	record_date='#now()#' 
	action_table='OFFTIME'
	action_column='OFFTIME_ID'
	action_id='#MAX_ID.IDENTITYCOL#'
	action_page='#request.self#?fuseaction=ehesap.offtimes&event=upd&offtime_id=#MAX_ID.IDENTITYCOL#'
	warning_description="#getLang('','İzin',58575)#: #MAX_ID.IDENTITYCOL# - #getEmpName.EMPLOYEE#">

<cfquery name="valid_control" datasource="#dsn#">
	SELECT
		VALID
	FROM
		OFFTIME
	WHERE
		OFFTIME_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#MAX_ID.IDENTITYCOL#">
</cfquery>
<cfif ( (isdefined("attributes.valid") and attributes.valid eq 1) or (valid_control.VALID eq 1) ) and get_xml_agenda.property_value eq 1 and len(get_xml_eventcat.property_value)>
	<!---  calisanin amirlerini getirir(cc alani icin kullanildi)--->
	<cfset cc_pos_code_list = ''>
	<cfset cc_emp_id_list  = ''>
	<cfquery name="get_upper_pos_code" datasource="#dsn#">
		SELECT UPPER_POSITION_CODE,UPPER_POSITION_CODE2 FROM EMPLOYEE_POSITIONS WHERE EMPLOYEE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.employee_id#">
	</cfquery>
	<cfif len(get_upper_pos_code.upper_position_code)>
		<cfset cc_pos_code_list = listappend(cc_pos_code_list,get_upper_pos_code.upper_position_code,',')>
	</cfif>
	<cfif len(get_upper_pos_code.upper_position_code2)>
		<cfset cc_pos_code_list = listappend(cc_pos_code_list,get_upper_pos_code.upper_position_code2,',')>
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
				EP.POSITION_CODE IN (<cfqueryparam cfsqltype="cf_sql_integer" list="true" value="#cc_pos_code_list#">)
		</cfquery>
		<cfset cc_emp_id_list = listappend(cc_emp_id_list,valuelist(get_upper_emp_id.employee_id),',')>
	</cfif>
	<!---  calisanin amirlerini getirir(cc alani icin kullanildi)--->
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
				<cfqueryparam cfsqltype="cf_sql_integer" value="#max_id.identitycol#">,
				<cfqueryparam cfsqltype="cf_sql_integer" value="#get_xml_eventcat.property_value#">,
				<cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.startdate#">,
				<cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.finishdate#">,
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.emp_name#-#get_offtime_cat.offtimecat#">,
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.emp_name# #dateformat(attributes.startdate,dateformat_style)# #timeformat(date_add('h',session.ep.time_zone,attributes.startdate),timeformat_style)# - #dateformat(attributes.finishdate,dateformat_style)# #timeformat(date_add('h',session.ep.time_zone,attributes.finishdate),timeformat_style)# tarihleri arasında izinlidir.">,
				<cfqueryparam cfsqltype="cf_sql_varchar" value=",#attributes.employee_id#,">,
				<cfqueryparam cfsqltype="cf_sql_varchar" value=",#cc_emp_id_list#,">,
				1,
				<cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.userid#">,
				<cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">,
				1,
				<cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">,
				<cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.userid#">,
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#cgi.remote_addr#">,
				<cfqueryparam cfsqltype="cf_sql_integer" value="#get_process_stage.process_row_id#">	
			)
	</cfquery>
</cfif>



<!---  pdks kayıt  --->
<cfset pdks_working_inout_cmp = createObject("component","V16.hr.ehesap.cfc.pdks_working_inout")>
<cfquery name="GET_BRANCH_ID" datasource="#dsn#">
	SELECT
		BRANCH_ID
	FROM
		EMPLOYEES_IN_OUT
	WHERE
		IN_OUT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.in_out_id#">
</cfquery>
<cfloop index="index" from="#attributes.startdate#" to="#attributes.finishdate#" step="#CreateTimeSpan(1,0,0,0)#">
	<cfset add_pdks_day = pdks_working_inout_cmp.add_pdks_day(
		employee_id : attributes.employee_id,
		in_out_id : attributes.in_out_id,
		branch_id : GET_BRANCH_ID.branch_id,
		sal_year : year(createodbcdatetime(index)),
		sal_mon : month(createodbcdatetime(index)),
		day_ : day(createodbcdatetime(index)),
		offtimecat_id : attributes.offtimecat_id,
		start_hour : hour(date_add('h',session.ep.time_zone,attributes.startdate)),
		finish_hour : hour(date_add('h',session.ep.time_zone,attributes.finishdate)),
		start_min : start_minute,
		finish_min : finish_minute
	)>
</cfloop>
<script type="text/javascript">
	window.location.href = '<cfoutput>#request.self#?fuseaction=ehesap.offtimes&event=upd&offtime_id=#MAX_ID.IDENTITYCOL#</cfoutput>';
</script>	
<cf_get_lang_set module_name="#fusebox.circuit#">
