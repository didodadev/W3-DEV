<cfif not (isDefined("attributes.ex_doc_name") and len(attributes.ex_doc_name) ) and isdefined("template_file") and len(template_file) >
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
<cfif isdefined('attributes.startdate') and len(attributes.startdate)>
	<cf_date tarih="attributes.startdate">
	<cfset attributes.startdate = date_add("h", start_clock-session.ep.time_zone, attributes.startdate)>
	<cfset attributes.startdate = date_add("n", start_minute, attributes.startdate)>
</cfif>
<cfif isdefined('attributes.finishdate') and len(attributes.finishdate)>
	<cf_date tarih="attributes.finishdate">
	<cfset attributes.finishdate = date_add("h", finish_clock-session.ep.time_zone, attributes.finishdate)>
	<cfset attributes.finishdate = date_add("n", finish_minute, attributes.finishdate)>
</cfif>
<cfif isdefined('attributes.work_startdate')>
	<cf_date tarih="attributes.work_startdate">
	<cfset attributes.work_startdate = date_add("h", work_start_clock-session.ep.time_zone, attributes.work_startdate)>
	<cfset attributes.work_startdate = date_add("n", work_start_minute, attributes.work_startdate)>
</cfif>
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
<cfquery name="upd_offtime" datasource="#dsn#">
	UPDATE
		OFFTIME
	SET
		<cfif isdefined("valid") and len(valid)>
			EMP_VALID_ID = #SESSION.EP.USERID#,
			EMP_VALID_DATE = #NOW()#,
			EMP_VALID = #valid#, 
		</cfif>
		<cfif isdefined('attributes.offtimecat_id')>OFFTIMECAT_ID = #attributes.OFFTIMECAT_ID#,</cfif>
		SUB_OFFTIMECAT_ID = <cfif isdefined("attributes.SUB_OFFTIMECAT_ID") and len(attributes.SUB_OFFTIMECAT_ID)><cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.SUB_OFFTIMECAT_ID#"><cfelse>0</cfif>,
		<cfif isdefined('attributes.startdate')>STARTDATE = #attributes.startdate#,</cfif>
		<cfif isdefined('attributes.finishdate')>FINISHDATE = #attributes.finishdate#,</cfif>
		<cfif isdefined('attributes.work_startdate')>WORK_STARTDATE = #attributes.work_startdate#,</cfif>
		<cfif isdefined('FORM.TEL_CODE')>TEL_CODE = '#FORM.TEL_CODE#',</cfif>
		<cfif isdefined('FORM.TEL_NO')>TEL_NO = '#FORM.TEL_NO#',</cfif>
		<cfif isdefined('FORM.ADDRESS')>ADDRESS = '#FORM.ADDRESS#',</cfif>
		<cfif isdefined('FORM.DETAIL')>DETAIL= '#FORM.DETAIL#',</cfif>
		OFFTIME_STAGE = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.PROCESS_STAGE#"> ,
		UPDATE_IP = '#CGI.REMOTE_ADDR#',
		UPDATE_EMP = #SESSION.EP.USERID#,
		UPDATE_DATE = #NOW()#,
		<cfif not (isDefined("attributes.ex_doc_name") and len(attributes.ex_doc_name) ) and isdefined("template_file") and len(template_file)>
			FILE_NAME = <cfqueryparam cfsqltype="cf_sql_varchar" value="#file_name#.#cffile.serverfileext#">
		<cfelse>
			FILE_NAME = <cfqueryparam cfsqltype="cf_sql_varchar" value="#file_name#">
		</cfif>

	WHERE
		OFFTIME_ID = #OFFTIME_ID#
</cfquery>
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

<cfquery name="get_employee_mail" datasource="#dsn#">
	SELECT EMPLOYEE_EMAIL,EMPLOYEE_NAME,EMPLOYEE_SURNAME FROM EMPLOYEES WHERE EMPLOYEE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.employee_id#">
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
	action_id='#OFFTIME_ID#'
	action_page='#request.self#?fuseaction=myhome.my_offtimes&event=upd&offtime_id=#contentEncryptingandDecodingAES(isEncode:1,content:OFFTIME_ID,accountKey:"wrk")#' 
	warning_description="#getLang('','İzin',58575)#: #OFFTIME_ID# - #get_employee_mail.EMPLOYEE_NAME# #get_employee_mail.EMPLOYEE_SURNAME#">
<script type="text/javascript">
	window.location.href = "<cfoutput>#request.self#?fuseaction=myhome.my_offtimes&event=upd&offtime_id=#contentEncryptingandDecodingAES(isEncode:1,content:attributes.offtime_id,accountKey:'wrk')#</cfoutput>";
</script>
