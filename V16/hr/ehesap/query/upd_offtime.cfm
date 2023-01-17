<cfif not (isDefined("attributes.ex_doc_name") and len(attributes.ex_doc_name) ) and isdefined("template_file") and len(template_file)>
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
<cfelse>
	<cfset file_name = attributes.ex_doc_name>
</cfif>
<cf_get_lang_set module_name="ehesap">
<cfset attributes.OFFTIME_CAT_ID = attributes.OFFTIMECAT_ID>
<cf_date tarih="attributes.startdate">
<cfset attributes.startdate = date_add("h", start_clock-session.ep.time_zone, attributes.startdate)>
<cfset attributes.startdate = date_add("n", start_minute, attributes.startdate)>
<cf_date tarih="attributes.finishdate">
<cfset attributes.finishdate = date_add("h", finish_clock-session.ep.time_zone, attributes.finishdate)>
<cfset attributes.finishdate = date_add("n", finish_minute, attributes.finishdate)>

<cfquery name="get_offtime" datasource="#dsn#">
	SELECT
		*
	FROM
		OFFTIME
	WHERE
		OFFTIME_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#offtime_id#">
</cfquery>
<cfif isdefined("attributes.valid") and attributes.valid eq 1>
	<!--- İLGİLİ ÇALIŞANIN İLGİLİ İZİN TARİHLERİNE RASLAYAN ve ONAYLANMIŞ BAŞKA BİR İZNİ VAR MI?  --->
	<cfquery name="get_other_offtimes" datasource="#dsn#">
		SELECT
			*
		FROM
			OFFTIME 
			INNER JOIN SETUP_OFFTIME ON SETUP_OFFTIME.OFFTIMECAT_ID = OFFTIME.OFFTIMECAT_ID
		WHERE
			 OFFTIME.EMPLOYEE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_offtime.EMPLOYEE_ID#"> AND
			<cfif len(attributes.in_out_id)>
                 OFFTIME.IN_OUT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.in_out_id#"> AND
            </cfif>
            OFFTIME.OFFTIME_ID <> <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.offtime_id#"> AND
			VALID = 1 AND
			SETUP_OFFTIME.EBILDIRGE_TYPE_ID <> 18 AND
			(
				( OFFTIME.STARTDATE BETWEEN <cfqueryparam cfsqltype="cf_sql_timestamp" value="#createodbcdatetime(attributes.startdate)#"> AND <cfqueryparam cfsqltype="cf_sql_timestamp" value="#createodbcdatetime(attributes.finishdate)#">) OR
				( OFFTIME.FINISHDATE BETWEEN <cfqueryparam cfsqltype="cf_sql_timestamp" value="#createodbcdatetime(attributes.startdate)#"> AND <cfqueryparam cfsqltype="cf_sql_timestamp" value="#createodbcdatetime(attributes.finishdate)#">) OR
				( OFFTIME.STARTDATE <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#createodbcdatetime(attributes.startdate)#"> AND  OFFTIME.FINISHDATE >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#createodbcdatetime(attributes.finishdate)#">)
			)
	</cfquery>
	
	<cfif get_other_offtimes.RecordCount>
		<script type="text/javascript">
			alert('Çalışanın aynı tarihlerle çakışan onaylanmış bir izni var!');
			history.back();
		</script>
		<cfabort>
	</cfif>
</cfif>

<cf_date tarih="attributes.work_startdate">
<cfset attributes.work_startdate = date_add("h", work_start_clock-session.ep.time_zone, attributes.work_startdate)>
<cfset attributes.work_startdate = date_add("n", work_start_minute, attributes.work_startdate)>
<cfif len(attributes.offtime_deserve_date) and isdate(attributes.offtime_deserve_date)>
	<cf_date tarih="attributes.offtime_deserve_date">
</cfif>

<cfquery name="GET_OFFTIME_CAT" datasource="#dsn#">
	SELECT IS_YEARLY,EBILDIRGE_TYPE_ID,OFFTIMECAT FROM SETUP_OFFTIME WHERE OFFTIMECAT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.OFFTIMECAT_ID#">
</cfquery>

<cfif GET_OFFTIME_CAT.IS_YEARLY eq 1>
	<cfif datediff("d",attributes.startdate,attributes.finishdate) gt 30>
		<script type="text/javascript">
			alert('30 Günden Fazla Yıllık İzin Girdiniz!');
		</script>
	</cfif>
</cfif>
<cf_get_lang_set module_name="myhome"><!--- sayfanin en altinda kapanisi var --->
<cfif isDefined("attributes.validator_position_code") and Len(attributes.validator_position_code)>
	<!--- Uyarilacaklardaki kisiye Mail Gonderme Islemi- Onceki Ile Ayni Ise Her Guncellemede Mail Gondermesine Gerek Yok --->
	<cfquery name="Get_Val_Pos_Code" datasource="#dsn#">
		SELECT ISNULL(VALIDATOR_POSITION_CODE,0) VALIDATOR_POSITION_CODE FROM OFFTIME WHERE OFFTIME_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.offtime_id#">
	</cfquery>
	<cfif Len(Get_Val_Pos_Code.Validator_Position_Code) and Get_Val_Pos_Code.Validator_Position_Code neq attributes.validator_position_code>
		<cfsavecontent variable="message"><cf_get_lang no='1590.İzin Talep Onayı'></cfsavecontent>	
		<cfquery name="get_validate_mail" datasource="#dsn#">
			SELECT EMPLOYEE_EMAIL,EMPLOYEE_NAME,EMPLOYEE_SURNAME,UPPER_POSITION_CODE,UPPER_POSITION_CODE2 FROM EMPLOYEE_POSITIONS WHERE POSITION_CODE = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.validator_position_code#">
		</cfquery>
		<cfif len(get_validate_mail.employee_email)>
			<cfmail to="#get_validate_mail.employee_email#" from="#session.ep.company#<#session.ep.company_email#>" subject="#message#" type="html">
				<cf_get_lang_main no='1368.Sayın'> #get_validate_mail.employee_name# #get_validate_mail.employee_surname#,
				<br/><br/>
				<strong>#get_emp_info(attributes.employee_id,0,0)#</strong> adlı kişi #dateformat(attributes.startdate,dateformat_style)# - #dateformat(attributes.finishdate,dateformat_style)# tarihleri arasında izin talebinde bulunmuştur!<br/><br/>
				<a href="#employee_domain##request.self#?fuseaction=myhome.my_offtimes_approve" target="_blank"><cf_get_lang no='1591.İzin Takip Ekranı'></a> <br/><br/>
				<cf_get_lang no='1586.Lütfen İşlemi Kontrol Ediniz!...'>
				<br/><br/>
				<cf_get_lang no='1587.Herhangi Bir Sorunla Karşılaşmanız Durumunda Lütfen İnsan Kaynakları Direktörlüğüne Başvurunuz.'><br/><br/>
			</cfmail>
		</cfif>
	</cfif>	
</cfif>
<cfif NOT LEN(get_offtime.VALIDDATE) AND len(get_offtime.VALIDATOR_POSITION_CODE_1) and get_offtime.VALID_1 eq 1 AND ((len(get_offtime.VALIDATOR_POSITION_CODE_2) and get_offtime.VALID_2 eq 1) OR NOT len(get_offtime.VALIDATOR_POSITION_CODE_2))>
	<cfquery name="get_hr_email" datasource="#dsn#">
		SELECT EMAIL FROM OUR_COMPANY_INFO WHERE COMP_ID = #session.ep.company_id#
	</cfquery>
	<cfif get_hr_email.recordcount and len(get_hr_email.email)>
		<cfquery name="Get_Val_Pos_Code" datasource="#dsn#">
			SELECT EMPLOYEE_NAME,EMPLOYEE_SURNAME FROM OFFTIME JOIN EMPLOYEE_POSITIONS EP ON EP.POSITION_CODE = OFFTIME.VALIDATOR_POSITION_CODE_1 WHERE OFFTIME_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.offtime_id#">
		</cfquery>	
		<cfmail to="#get_hr_email.email#" from="#session.ep.company#<#session.ep.company_email#>" subject="Message" type="html">
		İK Departmanı’nın dikkatine…
		<strong>#get_emp_info(attributes.employee_id,0,0)#</strong> adlı personele ait izin talebi  amiri 
		<strong>#Get_Val_Pos_Code.EMPLOYEE_NAME# #Get_Val_Pos_Code.EMPLOYEE_SURNAME#</strong> tarafından onaylanmıştır. 
		
		Bilginize sunulur
		İlgili kayıta erişmek için <a href="#employee_domain##request.self#?fuseaction=ehesap.offtimes" target="_blank">tıklayınız</a>
		</cfmail>
	</cfif> 
</cfif>
<cf_get_lang_set module_name="#lcase(listgetat(attributes.fuseaction,1,'.'))#"><!--- sayfanin en ustunde acilisi var --->
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
<!---  calisanin amirlerini getirir(cc alani icin kullanildi)--->
<cfset cc_pos_code_list = ''>
<cfset cc_emp_id_list  = ''>
<cfif attributes.is_view_agenda eq 1 and len(attributes.x_event_catid)>
	<cfquery name="get_upper_pos_code" datasource="#dsn#">
		SELECT UPPER_POSITION_CODE,UPPER_POSITION_CODE2 FROM EMPLOYEE_POSITIONS WHERE EMPLOYEE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_offtime.EMPLOYEE_ID#">
	</cfquery>
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
<!---  calisanin amirlerini getirir(cc alani icin kullanildi)
<cfif not GET_PROCESS_STAGE.recordcount>
	<script type="text/javascript">
		alert('Olay Süreçleri Tanımlı Olmadığı İçin Kayıt Yapılamadı!');
		history.back();
	</script>
	<cfabort>
</cfif>--->
<cfquery name="add_offtime" datasource="#dsn#">
	UPDATE 
		OFFTIME
	SET
		IN_OUT_ID = <cfif len(attributes.in_out_id)><cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.in_out_id#">,<cfelse>NULL,</cfif><!--- GET_OFFTIME_CAT.EBILDIRGE_TYPE_ID is '06' and --->
		IS_PUANTAJ_OFF = <cfif isdefined("attributes.is_puantaj_off")>1<cfelse>0</cfif>,
		EMPLOYEE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.EMPLOYEE_ID#">,
		OFFTIMECAT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.OFFTIMECAT_ID#">,
		SUB_OFFTIMECAT_ID = <cfif isdefined("attributes.SUB_OFFTIMECAT_ID") and len(attributes.SUB_OFFTIMECAT_ID)><cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.SUB_OFFTIMECAT_ID#"><cfelse>0</cfif>,
		DESERVE_DATE = <cfif len(attributes.offtime_deserve_date) and isdate(attributes.offtime_deserve_date)><cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.offtime_deserve_date#"><cfelse>NULL</cfif>,
		STARTDATE = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.startdate#">,
		FINISHDATE = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.finishdate#">,
		WORK_STARTDATE = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.work_startdate#">,
		TOTAL_HOURS = 0,
		TEL_CODE = <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.TEL_CODE#">,
		TEL_NO = <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.TEL_NO#">,
		ADDRESS = <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.ADDRESS#">,
		DETAIL= <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.DETAIL#">,
		IS_PLAN = 0,
		<cfif isdefined("attributes.valid") and len(attributes.valid)>
			VALID_EMPLOYEE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#SESSION.EP.USERID#">,
			VALIDDATE = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#NOW()#">,
			VALID = <cfqueryparam cfsqltype="cf_sql_bit" value="#attributes.valid#">,
		</cfif>
		<cfif isdefined("attributes.VALIDATOR_POSITION_CODE") and len(attributes.VALIDATOR_POSITION_CODE)>
			VALIDATOR_POSITION_CODE = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.VALIDATOR_POSITION_CODE#">,
		</cfif>
		OFFTIME_STAGE =<cfif isdefined("attributes.process_stage") and len(attributes.process_stage)><cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.process_stage#"><cfelse>NULL</cfif>,
		UPDATE_IP = <cfqueryparam cfsqltype="cf_sql_varchar" value="#CGI.REMOTE_ADDR#">,
		UPDATE_EMP = <cfqueryparam cfsqltype="cf_sql_integer" value="#SESSION.EP.USERID#">,
		UPDATE_DATE = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#NOW()#">,
		SHORT_WORKING_RATE = <cfif isdefined("attributes.short_working_rate") and len(attributes.short_working_rate)><cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.short_working_rate#"><cfelse>NULL</cfif>,
		SHORT_WORKING_HOURS = <cfif isdefined("attributes.short_working_hours") and len(attributes.short_working_hours)><cfqueryparam cfsqltype="cf_sql_float" value="#attributes.short_working_hours#"><cfelse>NULL</cfif>,
		FIRST_WEEK_CALCULATION = <cfif isdefined("attributes.first_week_calculation") and len(attributes.first_week_calculation)><cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.first_week_calculation#"><cfelse>NULL</cfif>,
		<cfif not( isDefined("attributes.ex_doc_name") and len(attributes.ex_doc_name)) and isdefined("template_file") and len(template_file)>
			FILE_NAME = <cfqueryparam cfsqltype="cf_sql_varchar" value="#file_name#.#cffile.serverfileext#">
		<cfelse>
			FILE_NAME = <cfqueryparam cfsqltype="cf_sql_varchar" value="#file_name#">
		</cfif>
	WHERE
		OFFTIME_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.offtime_id#">
</cfquery>
<cfquery name="getEmpName" datasource="#dsn#">
	SELECT EMPLOYEE_NAME+' '+EMPLOYEE_SURNAME AS EMPLOYEE FROM EMPLOYEES WHERE EMPLOYEE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.employee_id#">
</cfquery>
<cfset attributes.actionId = attributes.offtime_id>
<cf_workcube_process 
	is_upd='1' 
	data_source='#dsn#' 
	old_process_line='#attributes.old_process_line#'
	process_stage='#attributes.process_stage#' 
	record_member='#session.ep.userid#'
	record_date='#now()#' 
	action_table='OFFTIME'
	action_column='OFFTIME_ID'
	action_id='#attributes.offtime_id#' 
	action_page='#request.self#?fuseaction=ehesap.offtimes&event=upd&offtime_id=#attributes.offtime_id#' 
	warning_description='İzin  : #attributes.offtime_id# - #getEmpName.EMPLOYEE#'>

<cfquery name="valid_control" datasource="#dsn#">
	SELECT
		VALID
	FROM
		OFFTIME
	WHERE
		OFFTIME_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.offtime_id#">
</cfquery>
<cfquery name="get_event" datasource="#dsn#">
	SELECT EVENT_ID FROM EVENT WHERE OFFTIME_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.offtime_id#">
</cfquery>
<cfif ( (isdefined("attributes.valid") and attributes.valid eq 1) or (valid_control.VALID eq 1) ) and attributes.is_view_agenda eq 1 and len(attributes.x_event_catid) and not get_event.recordcount>
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
				<cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.offtime_id#">,
				<cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.x_event_catid#">,<!--- izin --->
				<cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.startdate#">,
				<cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.finishdate#">,
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.employee_name#-#GET_OFFTIME_CAT.offtimecat#">,
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.employee_name# #dateformat(attributes.startdate,dateformat_style)# #timeformat(date_add('h',session.ep.time_zone,attributes.startdate),timeformat_style)# - #dateformat(attributes.finishdate,dateformat_style)# #timeformat(date_add('h',session.ep.time_zone,attributes.finishdate),timeformat_style)# tarihleri arasında izinlidir.">,
				<cfqueryparam cfsqltype="cf_sql_varchar" value=",#attributes.employee_id#,">,
				<cfqueryparam cfsqltype="cf_sql_varchar" value=",#cc_emp_id_list#,">,
				1,
				<cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.position_code#">,
				<cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.userid#">,
				<cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">,
				1,
				<cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">,
				<cfqueryparam cfsqltype="cf_sql_integer" value="#SESSION.EP.USERID#">,
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#cgi.remote_addr#">,
				<cfqueryparam cfsqltype="cf_sql_integer" value="#GET_PROCESS_STAGE.PROCESS_ROW_ID#">	
			)
	</cfquery>
<cfelseif get_event.recordcount and len(attributes.x_event_catid)>
	<cfquery name="upd_event" datasource="#dsn#">
		UPDATE 
			EVENT
		SET
			EVENTCAT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.x_event_catid#">,<!--- izin --->
			STARTDATE = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.startdate#">,
			FINISHDATE = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.finishdate#">,
			EVENT_HEAD = <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.employee_name#-#GET_OFFTIME_CAT.offtimecat#">,
			EVENT_DETAIL = <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.employee_name# #dateformat(attributes.startdate,dateformat_style)# #timeformat(date_add('h',session.ep.time_zone,attributes.startdate),timeformat_style)# - #dateformat(attributes.finishdate,dateformat_style)# #timeformat(date_add('h',session.ep.time_zone,attributes.finishdate),timeformat_style)# tarihleri arasında izinlidir.">,
			EVENT_TO_POS = <cfqueryparam cfsqltype="cf_sql_varchar" value=",#attributes.employee_id#,">,
			EVENT_CC_POS = <cfqueryparam cfsqltype="cf_sql_varchar" value=",#cc_emp_id_list#,">,
			VALID = 1,
			VALIDATOR_POSITION_CODE = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.position_code#">,
			VALID_EMP = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.userid#">,
			VALID_DATE = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">,
			VIEW_TO_ALL = 1,
			RECORD_DATE = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">,
			RECORD_EMP = <cfqueryparam cfsqltype="cf_sql_integer" value="#SESSION.EP.USERID#">,
			RECORD_IP = <cfqueryparam cfsqltype="cf_sql_varchar" value="#cgi.remote_addr#">,
			EVENT_STAGE = <cfqueryparam cfsqltype="cf_sql_integer" value="#GET_PROCESS_STAGE.PROCESS_ROW_ID#">
		WHERE
			OFFTIME_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.offtime_id#">
	</cfquery>
</cfif>

<!---  pdks kayıt  --->
<cfif isDefined("attributes.in_out_id") and len(attributes.in_out_id)>
	<cfset pdks_working_inout_cmp = createObject("component","V16.hr.ehesap.cfc.pdks_working_inout")>
	<cfquery name="GET_BRANCH_ID" datasource="#dsn#">
		SELECT
			BRANCH_ID
		FROM
			EMPLOYEES_IN_OUT
		WHERE
			IN_OUT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.in_out_id#">
	</cfquery>
	<cfset izin_startdate_ = date_add("h", session.ep.time_zone, attributes.startdate)>
	<cfset izin_finishdate_ = date_add("h", session.ep.time_zone, attributes.finishdate)>
	<cfloop index="index" from="#attributes.startdate#" to="#attributes.finishdate#" step="#CreateTimeSpan(1,0,0,0)#">
		<cfset add_pdks_day = pdks_working_inout_cmp.add_pdks_day(
			employee_id : attributes.employee_id,
			in_out_id : attributes.in_out_id,
			branch_id : GET_BRANCH_ID.branch_id,
			sal_year : year(createodbcdatetime(index)),
			sal_mon : month(createodbcdatetime(index)),
			day_ : day(createodbcdatetime(index)),
			offtimecat_id : attributes.offtimecat_id,
			start_hour : hour(izin_startdate_),
			finish_hour : hour(izin_finishdate_),
			start_min : start_minute,
			finish_min : finish_minute
		)>
	</cfloop>
</cfif>

<script type="text/javascript">
	window.location.href = '<cfoutput>#request.self#?fuseaction=ehesap.offtimes&event=upd&offtime_id=#attributes.offtime_id#</cfoutput>';
</script>
<cf_get_lang_set module_name="#fusebox.circuit#">
