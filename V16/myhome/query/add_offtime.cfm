<!--- Yükleme klasörü yoksa oluşturuyor. --->
<cfif Not directoryExists('#upload_folder##dir_seperator#hr#dir_seperator#offtime')>
	<cfdirectory action="create" directory="#upload_folder##dir_seperator#hr#dir_seperator#offtime">
</cfif>
<!--- Seçilen kategori için belge ekleme zorunluysa, ekleme işlemini yapıyor. --->
<cfif isDefined("attributes.doc_req") and attributes.doc_req eq 1>
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
<cf_date tarih="attributes.startdate">
<cfset attributes.startdate = date_add("h", start_clock-session.ep.time_zone, attributes.startdate)>
<cfset attributes.startdate = date_add("n", start_minute, attributes.startdate)>
<cf_date tarih="attributes.finishdate">
<cfset attributes.finishdate = date_add("h", finish_clock-session.ep.time_zone, attributes.finishdate)>
<cfset attributes.finishdate = date_add("n", finish_minute, attributes.finishdate)>
<cf_date tarih="attributes.work_startdate">
<cfset attributes.work_startdate = date_add("h", work_start_clock-session.ep.time_zone, attributes.work_startdate)>
<cfset attributes.work_startdate = date_add("n", work_start_minute, attributes.work_startdate)>
<cfset izin_startdate_ = date_add("h", session.ep.time_zone, attributes.startdate)>
<cfset izin_finishdate_ = date_add("h", session.ep.time_zone, attributes.finishdate)>

<cfquery name="get_offtime_cat_puantaj" datasource="#dsn#">
	SELECT ISNULL(IS_PUANTAJ_OFF,0) AS IS_PUANTAJ_OFF,IS_PERMISSION_TYPE,WEEKING_WORKING_DAY ,MAX_PERMISSION_TIME FROM SETUP_OFFTIME WHERE OFFTIMECAT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#offtimecat_id#">
</cfquery>
<cfif get_offtime_cat_puantaj.IS_PERMISSION_TYPE eq 2><!--- gün cinsindense --->
	<cfscript>
		day_total_ = 0;
		used_izin_gun = 0;
		temp_finishdate = CreateDateTime(year(attributes.finishdate),month(attributes.finishdate),day(attributes.finishdate),0,0,0);
		temp_startdate = CreateDateTime(year(attributes.startdate),month(attributes.startdate),day(attributes.startdate),0,0,0);
		total_izin_ = fix(temp_finishdate-temp_startdate)+1;
		izin_startdate_ = date_add("h", session.ep.time_zone, attributes.startdate);
		izin_finishdate_ = date_add("h", session.ep.time_zone, attributes.finishdate);
		if (get_offtime_cat_puantaj.WEEKING_WORKING_DAY eq 5)
			day_total_ = day_total_;
		else if (get_offtime_cat_puantaj.WEEKING_WORKING_DAY eq 6)
			{
				for (mck_=0; mck_ lt total_izin_; mck_=mck_+1)
					{
						temp_izin_gunu_ = date_add("d",mck_,izin_startdate_);
						if (dayofweek(temp_izin_gunu_) eq 1)
							day_total_ = day_total_ + 1;
					}
			}	
		else if (get_offtime_cat_puantaj.WEEKING_WORKING_DAY eq 7)
			{
				for (mck_=0; mck_ lt total_izin_; mck_=mck_+1)
					{
						temp_izin_gunu_ = date_add("d",mck_,izin_startdate_);
						if (dayofweek(temp_izin_gunu_) eq 7)
							day_total_ = day_total_ + 2;
					}									
			}						
		used_izin_gun = used_izin_gun + total_izin_ - day_total_;
	</cfscript>
	<cfif used_izin_gun gt get_offtime_cat_puantaj.MAX_PERMISSION_TIME>
		<cfset kalan_izin_ = used_izin_gun-get_offtime_cat_puantaj.MAX_PERMISSION_TIME>
		<script type="text/javascript">
			alert("İzin Limitini (<cfoutput>#get_offtime_cat_puantaj.MAX_PERMISSION_TIME#</cfoutput> gün) Aştınız!");
		</script>
	</cfif>
<cfelseif get_offtime_cat_puantaj.IS_PERMISSION_TYPE eq 3><!--- yıl cinsindense --->
	<cfset temp_finishdate = CreateDateTime(year(attributes.finishdate),month(attributes.finishdate),day(attributes.finishdate),0,0,0)>
	<cfset temp_startdate = CreateDateTime(year(attributes.startdate),month(attributes.startdate),day(attributes.startdate),0,0,0)>						
	<cfset 	used_izin_gun = fix(temp_finishdate-temp_startdate)/360>
	<cfif used_izin_gun gt get_offtime_cat_puantaj.MAX_PERMISSION_TIME>
		<cfset kalan_izin_ = used_izin_gun-get_offtime_cat_puantaj.MAX_PERMISSION_TIME>
		<script type="text/javascript">
		 	kalan_izin_1 = (Math.floor(<cfoutput>#kalan_izin_#</cfoutput>)-1);
			/* alert("İzin Limitini" + kalan_izin_1 + " yıl Aştınız!"); */
			alert("İzin Limitini (<cfoutput>#get_offtime_cat_puantaj.MAX_PERMISSION_TIME#</cfoutput> yıl) Aştınız!");
		</script>
	</cfif>
<cfelseif get_offtime_cat_puantaj.IS_PERMISSION_TYPE eq 1><!--- saaat/dk cinsindense --->
	<cfscript>
		izin_startdate_ = date_add("h", session.ep.time_zone, attributes.startdate);
		izin_finishdate_ = date_add("h", session.ep.time_zone, attributes.finishdate);
		izin_start_hour = 	timeformat(izin_startdate_,timeformat_style);
		izin_finish_hour = timeformat(izin_finishdate_,timeformat_style);
		used_izin_gun = datediff("n",izin_start_hour,izin_finish_hour);
		used_izin_gun = used_izin_gun/60;
	</cfscript>
	<cfif used_izin_gun gt get_offtime_cat_puantaj.MAX_PERMISSION_TIME>
		<script type="text/javascript">
			alert("İzin Limitini (<cfoutput>#get_offtime_cat_puantaj.MAX_PERMISSION_TIME#</cfoutput> saat) Aştınız!");
		</script>
	</cfif>
</cfif>
<cfquery name="get_other_offtimes" datasource="#dsn#">
	SELECT
		*
	FROM
		OFFTIME
	WHERE
		EMPLOYEE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.employee_id#"> AND
		<cfif len(attributes.in_out_id)>
			IN_OUT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.in_out_id#"> AND
		</cfif>
		(VALID = 1 OR VALID IS NULL) AND
		(
			(STARTDATE BETWEEN <cfqueryparam cfsqltype="cf_sql_timestamp" value="#createodbcdatetime(attributes.startdate)#"> AND <cfqueryparam cfsqltype="cf_sql_timestamp" value="#createodbcdatetime(attributes.finishdate)#">) OR
			(FINISHDATE BETWEEN <cfqueryparam cfsqltype="cf_sql_timestamp" value="#createodbcdatetime(attributes.startdate)#"> AND <cfqueryparam cfsqltype="cf_sql_timestamp" value="#createodbcdatetime(attributes.finishdate)#">) OR
			(STARTDATE <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#createodbcdatetime(attributes.startdate)#"> AND FINISHDATE >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#createodbcdatetime(attributes.finishdate)#">)
		)
		AND IS_PUANTAJ_OFF = 0
</cfquery>

<cfif get_other_offtimes.RecordCount>
	<script type="text/javascript">
		alert('Çalışanın aynı tarihlerle çakışan onaylanmış bir izni var!');
		history.back();
	</script>
	<cfabort>
</cfif>
<cflock name="#CREATEUUID()#" timeout="20">
	<cftransaction>
		<cfquery name="add_offtime" datasource="#dsn#" result="MAX_ID">
			INSERT INTO
				OFFTIME
			(
				IS_PUANTAJ_OFF,
				RECORD_IP,
				RECORD_EMP,
				RECORD_DATE,
				EMPLOYEE_ID,
				IN_OUT_ID,
				OFFTIMECAT_ID,
				SUB_OFFTIMECAT_ID,
				STARTDATE,
				FINISHDATE,
				WORK_STARTDATE,
				TOTAL_HOURS,
				<cfif len(form.tel_code)>TEL_CODE,</cfif>	
				<cfif len(form.tel_no)>TEL_NO,</cfif>
				<cfif len(form.address)>ADDRESS,</cfif>
				DETAIL,
				SHORT_WORKING_RATE,
				FIRST_WEEK_CALCULATION,
				<!----
				VALIDATOR_POSITION_CODE_1,
				VALIDATOR_POSITION_CODE_2,
				--->
				OFFTIME_STAGE,
				FILE_NAME
			)
			VALUES
			(
				#get_offtime_cat_puantaj.is_puantaj_off#,
				'#cgi.remote_addr#',
				#session.ep.userid#,
				#now()#,
				#employee_id#,
				<cfif len(attributes.in_out_id)>#attributes.in_out_id#<cfelse>NULL</cfif>,
				#offtimecat_id#,
				<cfif isdefined("attributes.SUB_OFFTIMECAT_ID") and len(attributes.SUB_OFFTIMECAT_ID)><cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.sub_offtimecat_id#"><cfelse>0</cfif>,
				#attributes.startdate#,
				#attributes.finishdate#,
				#attributes.work_startdate#,
				0,
				<cfif len(form.tel_code)>'#form.tel_code#',</cfif>
				<cfif len(form.tel_no)>'#tel_no#',</cfif>
				<cfif len(form.address)>'#address#',</cfif>
				'#detail#',
				<cfif isdefined("attributes.short_working_rate") and len(attributes.short_working_rate)><cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.short_working_rate#"><cfelse>NULL</cfif>,
				<cfif isdefined("attributes.first_week_calculation") and len(attributes.first_week_calculation)><cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.first_week_calculation#"><cfelse>NULL</cfif>,
				<!----
				#validator_position_code_1#,
				<cfif len(validator_position_code_2)>#validator_position_code_2#<cfelse>NULL</cfif>,
				--->
				#attributes.process_stage#,
				<cfif isDefined("attributes.doc_req") and attributes.doc_req eq 1>
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#file_name#.#cffile.serverfileext#">
				<cfelse>
					NULL
				</cfif>
			)
		</cfquery>
		<cfquery name="get_employee_mail" datasource="#dsn#">
			SELECT EMPLOYEE_EMAIL,EMPLOYEE_NAME,EMPLOYEE_SURNAME FROM EMPLOYEES WHERE EMPLOYEE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.employee_id#">
		</cfquery>
	
		<cfif isDefined("attributes.in_out_id") and len(attributes.in_out_id)>
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
					start_hour : hour(izin_startdate_),
					finish_hour : hour(izin_finishdate_),
					start_min : start_minute,
					finish_min : finish_minute
				)>
			</cfloop>
		</cfif>
	</cftransaction>
</cflock>

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
	action_page='#request.self#?fuseaction=myhome.my_offtimes&event=upd&offtime_id=#contentEncryptingandDecodingAES(isEncode:1,content:MAX_ID.IDENTITYCOL,accountKey:"wrk")#' 
	warning_description="#getLang('','İzin',58575)#: #MAX_ID.IDENTITYCOL# - #get_employee_mail.EMPLOYEE_NAME# #get_employee_mail.EMPLOYEE_SURNAME#">
<script type="text/javascript">
	window.location.href="<cfoutput>#request.self#?fuseaction=myhome.my_offtimes&event=upd&offtime_id=#contentEncryptingandDecodingAES(isEncode:1,content:MAX_ID.IDENTITYCOL,accountKey:'wrk')#</cfoutput>";
</script>