<cf_get_lang_set module_name="ehesap">
<cfif (isdefined("attributes.event") and attributes.event is 'list') or not isdefined("attributes.event")>
	<cf_xml_page_edit fuseact='ehesap.offtimes'>
	<cfparam name="attributes.izin_type" default="0">
	<cfparam name="attributes.branch_id" default="">
	<cfparam name="attributes.department" default="">
	<cfparam name="attributes.keyword" default="">
	<cfparam name="attributes.hierarchy" default="">
	<cfparam name="attributes.off_validate" default="0">
	<cfparam name="attributes.startdate" default="#dateformat((date_add('m',-1,CreateDate(year(now()),month(now()),1))))#">
	<cfparam name="attributes.finishdate" default="#dateformat((Createdate(year(CreateDate(year(now()),month(now()),1)),month(CreateDate(year(now()),month(now()),1)),DaysInMonth(CreateDate(year(now()),month(now()),1)))),'dd/mm/yyyy')#"> 
	<cfparam name="attributes.page" default="1">
	<cfparam name="attributes.maxrows" default="#session.ep.maxrows#">
	<cfscript>
		url_str = "";
		if (len(attributes.keyword))
			url_str = "#url_str#&keyword=#attributes.keyword#";
		if (len(attributes.hierarchy))
			url_str = "#url_str#&hierarchy=#attributes.hierarchy#";
		if (len(attributes.off_validate))
			url_str = "#url_str#&off_validate=#attributes.off_validate#";
		if (len(attributes.izin_type))
			url_str = "#url_str#&izin_type=#attributes.izin_type#";
		if (isdefined("attributes.startdate"))
			url_str = "#url_str#&startdate=#attributes.startdate#";
		if (isdefined("attributes.finishdate"))
			url_str = "#url_str#&finishdate=#attributes.finishdate#";
		if (isdefined("attributes.branch_id"))
			url_str = "#url_str#&branch_id=#attributes.branch_id#";
		if (isdefined("attributes.department"))
			url_str = "#url_str#&department=#attributes.department#";
		if (isdefined("attributes.offtimecat_id"))
			url_str = "#url_str#&offtimecat_id=#attributes.offtimecat_id#";
		if (isdefined("attributes.form_submit"))
			url_str = "#url_str#&form_submit=1";
		attributes.startrow=((attributes.page-1)*attributes.maxrows)+1;
	</cfscript>
	<cfif isdate(attributes.startdate)>
		<cf_date tarih="attributes.startdate">
	</cfif>
	<cfif isdate(attributes.finishdate)>
		<cf_date tarih="attributes.finishdate">
	</cfif>
	<!--- sorgu sirayi bozmayin  --->
	<cfinclude template="../hr/ehesap/query/get_our_comp_and_branchs.cfm">
	<cfif isdefined('attributes.form_submit')>
		<cfinclude template="../hr/ehesap/query/get_offtimes.cfm">
	<cfelse>
		<cfset get_offtimes.recordcount = 0>
	</cfif>
	<cfinclude template="../hr/ehesap/query/get_offtime_cats.cfm">
	<!--- sorgu sirayi bozmayin  --->
	<cfparam name="attributes.totalrecords" default='#get_offtimes.recordcount#'>
	<cfsavecontent variable="action_"><cfif fusebox.circuit is 'hr'>hr.list_offtimes<cfelse>ehesap.offtimes</cfif></cfsavecontent>
	<cfif isdefined('attributes.branch_id') and len(attributes.branch_id) and attributes.branch_id is not "all">
		<cfquery name="GET_DEPARTMENT" datasource="#DSN#">
			SELECT DEPARTMENT_ID,DEPARTMENT_HEAD FROM DEPARTMENT WHERE BRANCH_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.branch_id#"> AND DEPARTMENT_STATUS =1 AND IS_STORE <> 1 ORDER BY DEPARTMENT_HEAD
		</cfquery>
	</cfif>
	<cfif isdefined('x_show_total_offdays') and x_show_total_offdays eq 1>
		<cfquery name="GET_GENERAL_OFFTIMES" datasource="#dsn#">
			SELECT START_DATE,FINISH_DATE,IS_HALFOFFTIME FROM SETUP_GENERAL_OFFTIMES
		</cfquery>
		<cfset offday_list_ = ''>
		<cfset halfofftime_list = ''><!--- yarım gunluk izin kayıtları--->
        <cfset halfofftime_list2 = ''>
		<cfoutput query="GET_GENERAL_OFFTIMES">
			<cfscript>
				offday_gun = datediff('d',get_general_offtimes.start_date,get_general_offtimes.finish_date)+1;
				offday_startdate = date_add("h", session.ep.time_zone, get_general_offtimes.start_date); 
				offday_finishdate = date_add("h", session.ep.time_zone, get_general_offtimes.finish_date);
				for (mck=0; mck lt offday_gun; mck=mck+1)
				{
					temp_izin_gunu = date_add("d",mck,offday_startdate);
					daycode = '#dateformat(temp_izin_gunu,'dd/mm/yyyy')#';
					if(not listfindnocase(offday_list_,'#daycode#'))
					offday_list_ = listappend(offday_list_,'#daycode#');
					if(get_general_offtimes.is_halfofftime is 1 and dayofweek(temp_izin_gunu) neq 1) //pazar haricindeki yarım günlük izin günleri sayılsın
					{
						halfofftime_list = listappend(halfofftime_list,'#daycode#');
					}
				}
			</cfscript>
		</cfoutput>	
		<cfquery name="get_hours" datasource="#dsn#">
			SELECT		
				OUR_COMPANY_HOURS.WEEKLY_OFFDAY
			FROM
				OUR_COMPANY_HOURS
			WHERE
				OUR_COMPANY_HOURS.DAILY_WORK_HOURS > 0 AND
				OUR_COMPANY_HOURS.SSK_MONTHLY_WORK_HOURS > 0 AND
				OUR_COMPANY_HOURS.SSK_WORK_HOURS > 0 AND
				OUR_COMPANY_HOURS.OUR_COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.company_id#">
		</cfquery>
		
		<cfif len(get_hours.recordcount) and len(get_hours.weekly_offday)>
			<cfset this_week_rest_day_ = get_hours.weekly_offday>
		<cfelse>
			<cfset this_week_rest_day_ = 1>
		</cfif>
	</cfif>
	<cfif IsDefined('form_submit')>
		<!--- çalışma saati başlangıç ve bitişleri al--->
		<cfquery name="get_work_time" datasource="#dsn#">
			SELECT 
				PROPERTY_VALUE,
				PROPERTY_NAME
			FROM
				FUSEACTION_PROPERTY
			WHERE
				OUR_COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.company_id#"> AND
				FUSEACTION_NAME = 'ehesap.form_add_offtime_popup' AND
				(PROPERTY_NAME = 'start_hour_info' OR
				PROPERTY_NAME = 'start_min_info' OR
				PROPERTY_NAME = 'finish_hour_info' OR
				PROPERTY_NAME = 'finish_min_info'
				)	
		</cfquery>
		<cfif get_work_time.recordcount>
		<cfloop query="get_work_time">	
			<cfif property_name eq 'start_hour_info'>
				<cfset start_hour = property_value>
			<cfelseif property_name eq 'start_min_info'>
				<cfset start_min = property_value>
			<cfelseif property_name eq 'finish_hour_info'>
				<cfset finish_hour = property_value>
			<cfelseif property_name eq 'finish_min_info'>
				<cfset finish_min = property_value>
			</cfif>
		</cfloop>
		<cfelse>
			<cfset start_hour = '00'>
			<cfset start_min = '00'>
			<cfset finish_hour = '00'>
			<cfset finish_min = '00'>
		</cfif>
		<cfif get_offtimes.recordcount>
			<cfquery name="get_emp_group_ids" datasource="#dsn#">
				SELECT
					E.EMPLOYEE_ID,
					(SELECT TOP 1 PUANTAJ_GROUP_IDS FROM EMPLOYEES_IN_OUT WHERE EMPLOYEE_ID = E.EMPLOYEE_ID AND (FINISH_DATE IS NULL OR FINISH_DATE <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">) AND START_DATE <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#"> ORDER BY START_DATE DESC) AS PUANTAJ_GROUP_IDS
				FROM
					EMPLOYEES E
				WHERE
					E.EMPLOYEE_ID IN (<cfqueryparam cfsqltype="cf_sql_integer" list="true" value="#listremoveDuplicates(valuelist(get_offtimes.employee_id),',')#">) ORDER BY E.EMPLOYEE_ID
			</cfquery>
			<cfset employee_id_list = ''>
			<cfoutput query="get_offtimes" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">
                <cfif len(valid_employee_id) and not listfind(employee_id_list,valid_employee_id)>
            		<cfset employee_id_list=listappend(employee_id_list,valid_employee_id)>
                </cfif>
            </cfoutput>
            <cfif len(employee_id_list)>
				<cfset employee_id_list=listsort(employee_id_list,"numeric","ASC",",")>
                <cfquery name="get_emp_detail" datasource="#dsn#">
                    SELECT 
                        E.EMPLOYEE_NAME,
                        E.EMPLOYEE_SURNAME,
                        E.EMPLOYEE_ID,
                        EI.TC_IDENTY_NO
                    FROM
                        EMPLOYEES E
                        INNER JOIN EMPLOYEES_IDENTY EI ON E.EMPLOYEE_ID = EI.EMPLOYEE_ID
                    WHERE
                        E.EMPLOYEE_ID IN (<cfqueryparam cfsqltype="cf_sql_integer" list="true" value="#employee_id_list#">) ORDER BY E.EMPLOYEE_ID
                </cfquery>
            </cfif>
		</cfif>
	</cfif>
<cfelseif isdefined("attributes.event") and attributes.event is 'add'>
	<cf_xml_page_edit fuseact='ehesap.form_add_offtime_popup'>
	<cfquery name="GET_OFFTIME_CATS" datasource="#DSN#">
		SELECT OFFTIMECAT,OFFTIMECAT_ID,IS_PUANTAJ_OFF FROM SETUP_OFFTIME WHERE IS_ACTIVE = 1 ORDER BY OFFTIMECAT_ID
	</cfquery>
	<cfquery name="get_top_puantaj" dbtype="query" maxrows="1">
		SELECT IS_PUANTAJ_OFF FROM GET_OFFTIME_CATS ORDER BY OFFTIMECAT_ID
	</cfquery>
	<cfif isDefined("attributes.employee_id")>
		<cfinclude template="../hr/ehesap/query/get_hr_name.cfm">
		<cfquery name="get_in_out" datasource="#dsn#">
			SELECT MAX(IN_OUT_ID) AS IN_OUT_ID FROM EMPLOYEES_IN_OUT WHERE EMPLOYEE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.employee_id#">
        </cfquery>
	</cfif>
<cfelseif isdefined("attributes.event") and attributes.event is 'upd'>
	<cf_xml_page_edit fuseact='ehesap.form_add_offtime_popup'>
	<cfinclude template="../hr/ehesap/query/get_offtime.cfm">
	<cfset record_=date_add('h',session.ep.time_zone,get_offtime.record_date)>
	<cfset start_=date_add('h',session.ep.time_zone,get_offtime.startdate)>
	<cfset end_=date_add('h',session.ep.time_zone,get_offtime.finishdate)>
	<cfif len(get_offtime.work_startdate)>
		<cfset work_start_= date_add('h',session.ep.time_zone,get_offtime.work_startdate)>
	<cfelse>				
		<cfset work_start_= date_add('d',1,get_offtime.finishdate)>
		<cfset work_start_= date_add('h',session.ep.time_zone,work_start_)>
	</cfif>
	<cfquery name="GET_OFFTIME_CATS" datasource="#DSN#">
        SELECT 
        	OFFTIMECAT,OFFTIMECAT_ID,IS_PUANTAJ_OFF
        FROM 
        	SETUP_OFFTIME
        WHERE
        	IS_ACTIVE = 1
        UNION 
        SELECT
        	OFFTIMECAT,OFFTIMECAT_ID,IS_PUANTAJ_OFF
        FROM 
        	SETUP_OFFTIME 
        WHERE
        	OFFTIMECAT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_offtime.offtimecat_id#">
    </cfquery>
<cfelseif isdefined("attributes.event") and attributes.event is 'added'>
	<cfparam name="attributes.employee_id" default="">
	<cfparam name="attributes.employee" default="">
	<cfinclude template="../hr/ehesap/query/get_offtime_cats.cfm">
	<cfif len(attributes.employee_id)>
		<cfquery name="get_izins" datasource="#dsn#">
			SELECT DISTINCT
				OFFTIME.VALIDDATE, 
				OFFTIME.EMPLOYEE_ID, 
				OFFTIME.OFFTIME_ID, 
				OFFTIME.VALID_EMPLOYEE_ID, 
				OFFTIME.STARTDATE, 
				OFFTIME.FINISHDATE, 
				OFFTIME.TOTAL_HOURS, 
				SETUP_OFFTIME.OFFTIMECAT,
				EMPLOYEES.EMPLOYEE_NAME,
				EMPLOYEES.EMPLOYEE_SURNAME
			FROM 
				OFFTIME
				INNER JOIN SETUP_OFFTIME ON OFFTIME.OFFTIMECAT_ID = SETUP_OFFTIME.OFFTIMECAT_ID
				INNER JOIN EMPLOYEES ON OFFTIME.VALID_EMPLOYEE_ID = EMPLOYEES.EMPLOYEE_ID
			WHERE
				OFFTIME.EMPLOYEE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.employee_id#"> AND
				OFFTIME.IS_PUANTAJ_OFF = 1 AND
				OFFTIME.ADDED_OFFTIME_ID IS NULL
		</cfquery>
	</cfif>
<cfelseif isdefined("attributes.event") and attributes.event is 'add_plan'>
	<cfinclude template="../hr/ehesap/query/get_offtime_cats.cfm">
	<cfinclude template="../hr/ehesap/query/get_our_comp_and_branchs.cfm">
	<cfquery name="GET_PROCESS_STAGE" datasource="#DSN#">
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
			PT.FACTION LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%ehesap.form_add_offtime_popup,%">
		ORDER BY 
			PTR.LINE_NUMBER
	</cfquery>
	<cfif isdefined("attributes.branch_id") or isdefined("attributes.department") or isdefined("attributes.company_id")>
		<cfquery name="get_department_positions" datasource="#DSN#">
			SELECT 
				E.EMPLOYEE_NAME,
				E.EMPLOYEE_SURNAME,
				E.EMPLOYEE_ID,
				EIO.IN_OUT_ID,
				EIO.EMPLOYEE_ID,
				EIO.START_DATE,
				EIO.DEPARTMENT_ID,
				EIO.BRANCH_ID,
				OC.COMP_ID,
				D.DEPARTMENT_HEAD,
				D.DEPARTMENT_ID,
				D.BRANCH_ID,
				D.OUR_COMPANY_ID,
				B.BRANCH_NAME,
				B.BRANCH_ID,
				B.COMPANY_ID,
				EI.TC_IDENTY_NO,
				EI.EMPLOYEE_ID
			FROM
				EMPLOYEES_IN_OUT EIO
				INNER JOIN EMPLOYEES E ON E.EMPLOYEE_ID = EIO.EMPLOYEE_ID
				INNER JOIN EMPLOYEES_IDENTY EI ON E.EMPLOYEE_ID = EI.EMPLOYEE_ID
				INNER JOIN DEPARTMENT D ON EIO.DEPARTMENT_ID = D.DEPARTMENT_ID
				INNER JOIN BRANCH B ON D.BRANCH_ID = B.BRANCH_ID
				INNER JOIN OUR_COMPANY OC ON B.COMPANY_ID = OC.COMP_ID
			WHERE
				EIO.FINISH_DATE IS NULL 
				<cfif isdefined("attributes.company_id")>
					 AND OC.COMP_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.company_id#">
				</cfif>
				<cfif isdefined("attributes.department")>
					 AND D.DEPARTMENT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.department#">
				</cfif>
				<cfif isdefined("attributes.branch_id")>
					 AND B.BRANCH_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.branch_id#">
				</cfif>
			ORDER BY
				E.EMPLOYEE_NAME
		</cfquery>
	</cfif>
	<cfquery name="ALL_COMPANIES" datasource="#DSN#">
		SELECT COMP_ID,COMPANY_NAME FROM OUR_COMPANY ORDER BY COMPANY_NAME
	</cfquery>
	<cfif isdefined('attributes.branch_id') and len(attributes.branch_id)>
		<cfquery name="get_department" datasource="#dsn#">
            SELECT 
                DEPARTMENT_STATUS, 
                IS_STORE, 
                BRANCH_ID, 
                DEPARTMENT_ID, 
                DEPARTMENT_HEAD, 
                HIERARCHY, 
                RECORD_DATE, 
                RECORD_EMP, 
                RECORD_IP, 
                UPDATE_DATE, 
                UPDATE_EMP, 
                UPDATE_IP, 
                OUR_COMPANY_ID
            FROM 
                DEPARTMENT 
            WHERE 
                BRANCH_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.branch_id#"> AND DEPARTMENT_STATUS =1 AND IS_STORE <> 1 
            ORDER BY 
            	DEPARTMENT_HEAD
        </cfquery>
	</cfif>
</cfif>

<script type="text/javascript">
	<cfif (isdefined("attributes.event") and attributes.event is 'list') or not isdefined("attributes.event")>
		$(document).ready(function() {
			$('#keyword').focus();
		});
		function showDepartment(branch_id)	
		{
			var branch_id = $('#branch_id').val();
			if (branch_id != "")
			{
				var send_address = "<cfoutput>#request.self#</cfoutput>?fuseaction=hr.popup_ajax_list_hr&branch_id="+branch_id;
				AjaxPageLoad(send_address,'DEPARTMENT_PLACE',1,'<cf_get_lang no="1376.İlişkili Departmanlar">');
			}
		}
		function offtime_valid(valid_type_,offtime_id_)
		{
			div_id = 'offtime_valid'+offtime_id_;
			var send_address = '<cfoutput>#request.self#</cfoutput>?fuseaction=ehesap.emptypopup_ajax_offtime_valid&valid_type='+ valid_type_ +'&offtime_id='+offtime_id_;
			AjaxPageLoad(send_address,div_id,1);
		}
		function change_action()
		{
			filter_offtime.action='<cfoutput>#request.self#?fuseaction=ehesap.offtimes</cfoutput>';
			filter_offtime.target='';
			return true;
		}
		function send_pdf_print()
		{
			windowopen('','page','print_window');
			filter_offtime.action='<cfoutput>#request.self#?fuseaction=ehesap.popup_offtimes_pdf_print</cfoutput>';
			filter_offtime.target='print_window';
			filter_offtime.submit();
		}
		function change_action()
		{
			if( !date_check(document.all.filter_offtime.startdate, document.all.filter_offtime.finishdate, "<cf_get_lang_main no='1450.Başlangıç Tarihi Bitiş Tarihinden Büyük Olamaz'>!") )
				return false;
			else
				return true;
		}
	<cfelseif isdefined("attributes.event") and attributes.event is 'add'>
		function check()
		{
			if (document.getElementById('employee_id').value.length == 0)
			{
				alert("<cf_get_lang_main no='59.Eksik Veri'> : <cf_get_lang_main no='164.Çalışan'>");
				return false;
			}
			if ($('#offtimecat_id').val().length == 0)
			{
				alert("<cf_get_lang_main no='782.Zorunlu Alan'> : <cf_get_lang_main no='74.Kategori'>");
				return false;
			}
			if (document.getElementById('validator_position_code').value.length == 0)
			{
				alert("<cf_get_lang_main no='782.Zorunlu Alan'> : <cf_get_lang no='1049.Onaylayacak'>");
				return false;
			}
			
			if ((offtime_request.startdate.value.length != 0) && (offtime_request.finishdate.value.length != 0))
				if(!time_check(offtime_request.startdate,offtime_request.start_clock,offtime_request.start_minute,offtime_request.finishdate,offtime_request.finish_clock,offtime_request.finish_minute,"<cf_get_lang no ='1202.Başlangıç Tarihi Bitiş Tarihinden Küçük olmalıdır'> !")) return false;
			
			if ((offtime_request.work_startdate.value.length != 0) && (offtime_request.finishdate.value.length != 0))
			{
				tarih1_ = offtime_request.finishdate.value.substr(6,4) + offtime_request.finishdate.value.substr(3,2) + offtime_request.finishdate.value.substr(0,2);
				tarih2_ = offtime_request.work_startdate.value.substr(6,4) + offtime_request.work_startdate.value.substr(3,2) + offtime_request.work_startdate.value.substr(0,2);
				
				if (offtime_request.finish_clock.value.length < 2) saat1_ = '0' + offtime_request.finish_clock.value; else saat1_ = offtime_request.finish_clock.value;
				if (offtime_request.finish_minute.value.length < 2) dakika1_ = '0' + offtime_request.finish_minute.value; else dakika1_ = offtime_request.finish_minute.value;
				if (offtime_request.work_start_clock.value.length < 2) saat2_ = '0' + offtime_request.work_start_clock.value; else saat2_ = offtime_request.work_start_clock.value;
				if (offtime_request.work_start_minute.value.length < 2) dakika2_ = '0' + offtime_request.work_start_minute.value; else dakika2_ = offtime_request.work_start_minute.value;
			
				tarih1_ = tarih1_ + saat1_ + dakika1_;
				tarih2_ = tarih2_ + saat2_ + dakika2_;
				
				if (tarih1_ > tarih2_) 
				{
					alert("<cf_get_lang dictionary_id='54628.İşe Başlama Tarihi İzin Bitiş Tarihinden Küçük olmamalıdır'>");
					offtime_request.work_startdate.focus();
					return false;
				}
			}
			return process_cat_control();
		}
		function change_puantaj(i)
		{
			if(i == 1)
				$("#is_puantaj_off").attr("checked",true);
			else
				$("#is_puantaj_off").attr("checked",false);
		}
		
		function get_deserve_date()
		{
			emp_id = $('#employee_id').val();
			$.ajax({
				type:"post",
				url: "/V16/hr/cfc/get_deserve_date.cfc?method=get_date&employee_id="+emp_id,
				data: 'dd',
				cache:false,
				async: false,
				contentType: "text",
				success: function(dataread) {
					if (dataread)
						$('#offtime_deserve_date').val(dataread);
					else
						$('#offtime_deserve_date').val('');
				},
		        error: function(xhr, opt, err)
				{
					alert(err.toString());
				}
	        });
		}
		$(document).ready(function(){
			if ($("#emp_name").val().length > 0 && $("#employee_id").val().length)
				get_deserve_date();
				
			$("#emp_name").blur(function() {
				if ($("#emp_name").val().length > 0 && $("#employee_id").val().length)
					get_deserve_date();
			});
		});
	<cfelseif isdefined("attributes.event") and attributes.event is 'upd'>
		function check()
		{
			if (document.getElementById('employee_id').value.length == 0)
			{
				alert("<cf_get_lang_main no='59.Eksik Veri'> : <cf_get_lang_main no='164.Çalışan'>");
				return false;
			}
			if ($('#offtimecat_id').val().length == 0)
			{
				alert("<cf_get_lang_main no='59.Eksik Veri'> : <cf_get_lang_main no='74.Kategori'>");
				return false;
			}
			<cfif not len(get_offtime.valid)>
			if (document.getElementById('validator_position_code').value.length == 0)
			{
				alert("<cf_get_lang_main no='59.Eksik Veri'> : <cf_get_lang no='1049.Onaylayacak'>");
				return false;
			}
			</cfif>
			if ((offtime_request.startdate.value.length != 0) && (offtime_request.finishdate.value.length != 0))
				if(!time_check(offtime_request.startdate,offtime_request.start_clock,offtime_request.start_minute,offtime_request.finishdate,offtime_request.finish_clock,offtime_request.finish_minute,"<cf_get_lang no ='1202.Başlangıç Tarihi Bitiş Tarihinden Küçük olmalıdır'> !")) return false;
			
			if ((offtime_request.work_startdate.value.length != 0) && (offtime_request.finishdate.value.length != 0))
			{
			
				tarih1_ = offtime_request.finishdate.value.substr(6,4) + offtime_request.finishdate.value.substr(3,2) + offtime_request.finishdate.value.substr(0,2);
				tarih2_ = offtime_request.work_startdate.value.substr(6,4) + offtime_request.work_startdate.value.substr(3,2) + offtime_request.work_startdate.value.substr(0,2);
				
				if (offtime_request.finish_clock.value.length < 2) saat1_ = '0' + offtime_request.finish_clock.value; else saat1_ = offtime_request.finish_clock.value;
				if (offtime_request.finish_minute.value.length < 2) dakika1_ = '0' + offtime_request.finish_minute.value; else dakika1_ = offtime_request.finish_minute.value;
				if (offtime_request.work_start_clock.value.length < 2) saat2_ = '0' + offtime_request.work_start_clock.value; else saat2_ = offtime_request.work_start_clock.value;
				if (offtime_request.work_start_minute.value.length < 2) dakika2_ = '0' + offtime_request.work_start_minute.value; else dakika2_ = offtime_request.work_start_minute.value;
			
				tarih1_ = tarih1_ + saat1_ + dakika1_;
				tarih2_ = tarih2_ + saat2_ + dakika2_;
				
				if (tarih1_ > tarih2_) 
				{
					alert("<cf_get_lang dictionary_id='54628.İşe Başlama Tarihi İzin Bitiş Tarihinden Küçük olmamalıdır'>!");
					offtime_request.work_startdate.focus();
					return false;
				}
			}	
			return process_cat_control();
		}
		function change_puantaj(i)
		{
			if(i == 1)
				$("#is_puantaj_off").attr("checked",true);
			else
				$("#is_puantaj_off").attr("checked",false);
		}
	<cfelseif isdefined("attributes.event") and attributes.event is 'added'>
		function check()
		{
			error_ = 1;
			if(offtime_request.izin_ids.length != undefined)
			{
				for (i=0; i < offtime_request.izin_ids.length; i++)
				{
					if(offtime_request.izin_ids[i].checked==true)
					{
						error_ = 0;
					}						
				}
				if(error_==1)
				{
					alert("<cf_get_lang_main no='59.Eksik Veri'> : <cf_get_lang no ='1390.İlişkilendirilecek İzin'>");
					return false;
				}
			}
			else
			{
				if(!(offtime_request.izin_ids.checked==true))
				{
					alert("<cf_get_lang_main no='59.Eksik Veri'> : <cf_get_lang no ='1390.İlişkilendirilecek İzin'>");
					return false;
				}
			}
				
		
			if (offtime_request.employee_id.value.length == 0)
			{
				alert("<cf_get_lang_main no='59.Eksik Veri'> : <cf_get_lang_main no='164.Çalışan'>");
				return false;
			}
			
			if (offtime_request.validator_position_code.value.length == 0)
			{
				alert("<cf_get_lang_main no='59.Eksik Veri'> : <cf_get_lang no='1049.Onaylayacak'>");
				return false;
			}
			return true;	
		}
	<cfelseif isdefined("attributes.event") and attributes.event is 'add_plan'>
		function get_used_offtime(aa)
		{
			var emp_id_ = eval("document.add_offtime.employee_id" + aa + '.value');
			var emp_in_out_ = eval("document.add_offtime.employee_in_out_id" + aa + '.value');
			var send_address='<cfoutput>#request.self#</cfoutput>?fuseaction=ehesap.popup_ajax_get_offtime&emp_id='+emp_id_;
			send_address+='&emp_in_out='+emp_in_out_;
			send_address+='&type='+2; 
			send_address+='&active_row='+aa; 
			div_id_ = 'used_off' + aa;
			AjaxPageLoad(send_address,div_id_,1,'İzin günü hesaplanıyor');
		}
		<cfif isdefined("get_department_positions") and get_department_positions.recordcount>
			row_count=<cfoutput>#get_department_positions.recordcount#</cfoutput>;
		<cfelse>
			row_count=1;
		</cfif>
		
		function get_offtime_day(aa)
		{
			var start_ = eval("document.add_offtime.startdate"+ aa + ' .value');
			var finish_ = eval("document.add_offtime.finishdate"+ aa + ' .value'); 
			var send_address='<cfoutput>#request.self#</cfoutput>?fuseaction=ehesap.popup_ajax_get_offtime&start_date='+start_;
			send_address+='&finish_date='+finish_;
			send_address+='&type='+0; 
			send_address+='&active_row='+aa; 
			div_id_ = 'offtime' + aa;
			AjaxPageLoad(send_address,div_id_,1,'İzin günü hesaplanıyor');
		}
		
		function get_finishdate(aa)
		{		
			var off_day=eval('document.add_offtime.offtime_day'+ aa +'.value');
			var start_ = eval('document.add_offtime.startdate'+ aa + ' .value');
			var send_address='<cfoutput>#request.self#</cfoutput>?fuseaction=ehesap.popup_ajax_get_offtime&start_date='+start_;
			send_address+='&off_day='+off_day;
			send_address+='&type='+1;
			send_address+='&active_row='+aa;
			div_id_ = 'finish_time'+aa;
			AjaxPageLoad(send_address,div_id_,1,'İzin günü hesaplanıyor');
		}
		
		function calisan_popup_ac(sira_no)
		{
			windowopen('<cfoutput>#request.self#?fuseaction=hr.popup_list_emp_in_out</cfoutput>&field_in_out_id=add_offtime.employee_in_out_id'+ sira_no + '&field_emp_name=add_offtime.employee'+ sira_no + '&field_emp_id=add_offtime.employee_id'+ sira_no + '&field_branch_and_dep=add_offtime.department'+ sira_no + '&field_start_date=add_offtime.work_startdate'+ sira_no + '&field_tcno=add_offtime.tcno'+ sira_no,'list');
		}
		
		function get_offtime_calc()
		{
			for(var j=1;j<=row_count;j++)
			{
				var emp_id = eval("document.add_offtime.employee_id" + j + '.value');
				var emp_in_out_no = eval("document.add_offtime.employee_in_out_id" + j + '.value');
				var off_calc=eval(document.add_offtime.calc_offtime.value);
				if(off_calc<1 || off_calc>12)
				{
					alert("<cf_get_lang dictionary_id='54629.Lütfen 1-12 değerleri arası bir rakam giriniz!'>!");
				}
				else
				{
					var get_offtime_plan = wrk_safe_query('hr_offtime_plan','dsn',j,emp_in_out_no);
					if(get_offtime_plan.recordcount)
					{
						var tarih=date_format(get_offtime_plan.FINISHDATE);
						tarih = date_add("m",off_calc,tarih);
						var start = eval('document.add_offtime.startdate'+j);
						start.value=tarih;
					}
					else
					{
						var get_offtime_in_out = wrk_safe_query('hr_offtime_in_out','dsn',j,emp_in_out_no);
						if(get_offtime_in_out.recordcount)
						{
							var tarih=date_format(get_offtime_in_out.START_DATE);
							tarih = date_add("m",off_calc,tarih);
							var start = eval('document.add_offtime.startdate'+j);
							start.value=tarih;
						}
						else
							alert("<cf_get_lang dictionary_id='54631.Böyle bir kayıt yok'>");
					}
				}
			}
		}
		
		function showDepartment(branch_id)	
		{
			var branch_id = document.add_offtime.branch_id.value;
			if (branch_id != "")
			{
				var send_address = "<cfoutput>#request.self#</cfoutput>?fuseaction=hr.popup_ajax_list_hr&branch_id="+branch_id;
				AjaxPageLoad(send_address,'DEPARTMENT_PLACE',1,'İlişkili Departmanlar');
			}
			else
			{
				var myList = document.getElementById("department");
				myList.options.length = 0;
				var txtFld = document.createElement("option");
				txtFld.value='';
				txtFld.appendChild(document.createTextNode('<cf_get_lang_main no="160.Departman">'));
				myList.appendChild(txtFld);
			}
		}
		function showBranch(comp_id)	
		{
			var comp_id = document.getElementById('company_id').value;
			if (comp_id != "")
			{
				var send_address = "<cfoutput>#request.self#</cfoutput>?fuseaction=hr.popup_ajax_list_hr&comp_id="+comp_id;
				AjaxPageLoad(send_address,'BRANCH_PLACE',1,'<cf_get_lang no="684.İlişkili Şubeler">');
			}
			else
			{
				document.getElementById('branch_id').value = "";document.getElementById('department').value ="";
				var myList = document.getElementById("branch_id");
				myList.options.length = 0;
				var txtFld = document.createElement("option");
				txtFld.value='';
				txtFld.appendChild(document.createTextNode('<cf_get_lang_main no="41.Şube">'));
				myList.appendChild(txtFld);
			}
			//departman bilgileri sıfırla
			var send_address = "<cfoutput>#request.self#</cfoutput>?fuseaction=hr.popup_ajax_list_hr&branch_id=0";
			AjaxPageLoad(send_address,'DEPARTMENT_PLACE',1,'<cf_get_lang no="685.İlişkili Departmanlar">');
		}	
	
		function hepsi_startdate()
		{
			hepsi(row_count,'startdate');
		}
		function hepsi_finishdate()
		{
			hepsi(row_count,'finishdate');
		}
		function hepsi(satir,nesne)
		{
			deger=eval("document.add_offtime."+nesne+"0");
			
			for(var i=1;i<=satir;i++)
			{
				nesne_tarih=eval("document.add_offtime."+nesne+i);
				nesne_tarih.value=deger.value;
				if(nesne=='finishdate')
				{
					get_offtime_day(i);
				}
			}
		}
	
		function sil(sy)
		{
			var my_element=eval("add_offtime.row_kontrol_"+sy);
			my_element.value=0;
			var my_element=eval("my_row_"+sy);
			my_element.style.display="none";
		}
		
		function add_row()
		{
			row_count++;
			var newRow;
			var newCell;
			
			newRow = document.getElementById("link_table").insertRow(document.getElementById("link_table").rows.length);	
			newRow.setAttribute("name","my_row_" + row_count);
			newRow.setAttribute("id","my_row_" + row_count);		
			newRow.setAttribute("NAME","my_row_" + row_count);
			newRow.setAttribute("ID","my_row_" + row_count);		
						
			document.add_offtime.record_num.value=row_count;
			
			newCell = newRow.insertCell(newRow.cells.length);
			newCell.innerHTML = '<a style="cursor:pointer" onclick="sil(' + row_count + ');" ><img  src="images/delete_list.gif" border="0"></a>';	
			
			newCell = newRow.insertCell(newRow.cells.length);
			newCell.innerHTML = '<input type="hidden" value="" name="row_kontrol_' + row_count +'"><input type="hidden" value="" id="employee_id' + row_count +'"  name="employee_id' + row_count +'">';
			newCell.innerHTML += '<input type="hidden" value="" name="employee_in_out_id' + row_count +'"><input type="text" name="employee' + row_count +'" id="employee' + row_count +'" style="width:90px;" value="" onFocus="AutoComplete_Create(\'employee\' + row_count,\'FULLNAME\',\'FULLNAME,BRANCH_NAME\',\'get_in_outs_autocomplete\',\'\',\'EMPLOYEE_ID,IN_OUT_ID,BRANS_NAME_DEP_HEAD,TC_IDENTY_NO,START_DATE\',\'employee_id\' + row_count + \',employee_in_out_id\' + row_count + \',department\' + row_count + \',tcno\' + row_count + \',work_startdate\'+ row_count,\'add_offtime\',\'3\',\'225\');"> ';
			newCell.innerHTML += '<a href="javascript://" onClick="calisan_popup_ac(' + row_count + ');"> <img border="0" src="/images/plus_thin.gif" align="absbottom"></a>';
			
			newCell = newRow.insertCell(newRow.cells.length);
			newCell.innerHTML = '<input type="text" maxlength="11" style="width:80px;" name="tcno' + row_count +'">';		
			
			newCell = newRow.insertCell(newRow.cells.length);
			newCell.innerHTML = '<input name="department'+row_count+'" type="text" style="width:150px;" readonly value="">';
			
			newCell = newRow.insertCell(newRow.cells.length);
			newCell.setAttribute("id","work_startdate" + row_count + "_td");
			newCell.innerHTML = '<input type="text" name="work_startdate' + row_count +'" readonly="yes" class="text" maxlength="10" style="width:65px;" value=""> ';
			wrk_date_image('work_startdate' + row_count);
			
			newCell = newRow.insertCell(newRow.cells.length);
			newCell.setAttribute("id","startdate" + row_count + "_td");
			newCell.innerHTML = '<input type="text" name="startdate' + row_count +'" readonly="yes" class="text" maxlength="10" style="width:65px;" value=""> ';
			wrk_date_image('startdate' + row_count);
	
			newCell = newRow.insertCell(newRow.cells.length);
			newCell.innerHTML = '<select name="start_hour' + row_count + '"><option value="0">s</option><cfloop from="1" to="23" index="i"><cfoutput><option value="#i#"><cfif i lt 10>0</cfif>#i#</option></cfoutput></cfloop></select> <select name="start_min' + row_count + '"><option value="0">dk</option><cfloop from="1" to="59" index="i"><cfoutput><option value="#i#"><cfif i lt 10>0</cfif>#i#</option></cfoutput></cfloop></select>';
			
			newCell = newRow.insertCell(newRow.cells.length);
			newCell.setAttribute("id","finishdate" + row_count + "_td");
			newCell.setAttribute("name","finishdate" + row_count + "_td");
			newCell.innerHTML = '<div id="finish_time'+row_count+'">';
			newCell.innerHTML += '<cfif isdefined("attributes.off_day")><cf_date tarih="attributes.start_date"><cfset yeni_tarih=dateadd('d',attributes.off_day,attributes.start_date)><input type="text" name="finishdate'+ row_count +'" readonly="yes" style="width:65px;" value="<cfoutput>#yeni_tarih#</cfoutput>" maxlength="10"><cfelse><input type="text" name="finishdate'+ row_count +'" readonly="yes" style="width:65px;" value="" maxlength="10"></cfif> ';
			wrk_date_image('finishdate' + row_count,'get_offtime_day('+ row_count+')');
			newCell.innerHTML+= '</div>';
		
			newCell = newRow.insertCell(newRow.cells.length);
			newCell.innerHTML = '<select name="end_hour' + row_count + '"><option value="0">s</option><cfloop from="1" to="23" index="i"><cfoutput><option value="#i#"><cfif i lt 10>0</cfif>#i#</option></cfoutput></cfloop></select> <select name="end_min' + row_count + '"><option value="0">dk</option><cfloop from="1" to="59" index="i"><cfoutput><option value="#i#"><cfif i lt 10>0</cfif>#i#</option></cfoutput></cfloop></select>';
			
			newCell = newRow.insertCell(newRow.cells.length);
			newCell.innerHTML = '<input type="text" style="width:50px;" name="offtime_day' + row_count +'">';
			newCell.innerHTML = '<div id="offtime'+row_count+'"><cfif isdefined("attributes.start_date") and isdefined("attributes.finish_date")><cf_date tarih="attributes.start_date"><cf_date tarih="attributes.finish_date"><cfset diff=datediff('d',attributes.start_date,attributes.finish_date)><input type="text" name="offtime_day'+ row_count +'" value="<cfoutput>#diff#</cfoutput>" onblur="get_finishdate('+ row_count +');" style="width:50px;" />
			<cfelse><input type="text" name="offtime_day'+ row_count +'" value="" onblur="get_finishdate('+ row_count +');" style="width:50px;" /></cfif></div>';
			
			newCell = newRow.insertCell(newRow.cells.length);
			newCell.innerHTML = '<div id="used_off'+ row_count +'"><input type="text" value="" style="width:50px;" name="used_offtime' + row_count +'"> <input type="text" name="remain_offtimes' + row_count +'" value="" style="width:50px;"/> <a href="javascript://" onclick="get_used_offtime('+ row_count +')"><img src="images/reload_page.gif" align="absmiddle" /></a></div>';
			
			newCell = newRow.insertCell(newRow.cells.length);
			newCell.innerHTML = '<select style="width:100px;" name="offtimecat_id' + row_count + '"><cfoutput query="get_offtime_cats"><option value="#offtimecat_id#">#offtimecat#</option></cfoutput></select>';
		}
	
		function kontrol()
		{
			document.add_offtime.record_num.value=row_count;
			if(row_count == 0)
			{
				alert("<cf_get_lang no='1335.İzin planlama Girişi Yapmadınız'>!");
				return false;
			}
			
			for(var j=1;j<=row_count;j++)
			{
				if(eval('document.add_offtime.row_kontrol_'+j+'.value')==1)
				{
					var emp = eval('document.add_offtime.employee_id'+j+'.value');
					if(emp == '')
					{
						alert('<cf_get_lang_main no="59.Eksik Veri"> : <cf_get_lang_main no="164.Çalışan">');
						return false;
					}
				
					var start_tarih = eval('document.add_offtime.startdate'+j+'.value');
					if(start_tarih == '')
					{
						alert("<cf_get_lang_main no='59.Eksik Veri'> : <cf_get_lang_main no='641.Başlangıç Tarihi'>");
						return false;
					}
				
					var finish_tarih = eval('document.add_offtime.finishdate'+j+'.value');
					if(finish_tarih == '')
					{
						alert("<cf_get_lang_main no='59.Eksik Veri'> : <cf_get_lang_main no='288.Bitiş Tarihi'>");
						return false;
					}
				}
			}
			alert('ok');
			return true;
		}	
		function open_form_ajax()
		{	
			var adres_='<cfoutput>#request.self#?fuseaction=ehesap.offtimes&event=add_plan</cfoutput>';
			
			if(document.add_offtime.branch_id.value != '')
			{
				adres_ = adres_ + '&branch_id=' + document.add_offtime.branch_id.value;
			}
			if(document.add_offtime.department.value != '')
			{
				adres_ = adres_ + '&department=' + document.add_offtime.department.value;
			}
			if(document.add_offtime.company_id.value != '')
			{
				adres_ = adres_ + '&company_id=' + document.add_offtime.company_id.value;
			}
			window.location.href=adres_;
			return false;
	 	}
	</cfif>
</script>

<cfscript>
	WOStruct = StructNew();
	WOStruct['#attributes.fuseaction#'] = structNew();
	WOStruct['#attributes.fuseaction#']['default'] = 'list';
	if(not isdefined('attributes.event'))
		attributes.event = WOStruct['#attributes.fuseaction#']['default'];
	
	WOStruct['#attributes.fuseaction#']['list'] = structNew();
	WOStruct['#attributes.fuseaction#']['list']['window'] = 'normal';
	WOStruct['#attributes.fuseaction#']['list']['fuseaction'] = 'ehesap.offtimes';
	WOStruct['#attributes.fuseaction#']['list']['filePath'] = 'hr/ehesap/display/list_offtimes.cfm';
	
	WOStruct['#attributes.fuseaction#']['add'] = structNew();
	WOStruct['#attributes.fuseaction#']['add']['window'] = 'popup';
	WOStruct['#attributes.fuseaction#']['add']['fuseaction'] = 'ehesap.form_add_offtime_popup';
	WOStruct['#attributes.fuseaction#']['add']['filePath'] = 'hr/ehesap/form/add_offtime.cfm';
	WOStruct['#attributes.fuseaction#']['add']['queryPath'] = 'hr/ehesap/query/add_offtime.cfm';
	WOStruct['#attributes.fuseaction#']['add']['nextEvent'] = 'ehesap.offtimes&event=upd';
	
	WOStruct['#attributes.fuseaction#']['upd'] = structNew();
	WOStruct['#attributes.fuseaction#']['upd']['window'] = 'popup';
	WOStruct['#attributes.fuseaction#']['upd']['fuseaction'] = 'ehesap.form_upd_offtime_popup';
	WOStruct['#attributes.fuseaction#']['upd']['filePath'] = 'hr/ehesap/form/upd_offtime.cfm';
	WOStruct['#attributes.fuseaction#']['upd']['queryPath'] = 'hr/ehesap/query/upd_offtime.cfm';
	WOStruct['#attributes.fuseaction#']['upd']['nextEvent'] = 'ehesap.offtimes&event=upd';
	WOStruct['#attributes.fuseaction#']['upd']['parameters'] = 'offtime_id=##attributes.offtime_id##';
	WOStruct['#attributes.fuseaction#']['upd']['Identity'] = '##attributes.offtime_id##';
	
	WOStruct['#attributes.fuseaction#']['added'] = structNew();
	WOStruct['#attributes.fuseaction#']['added']['window'] = 'popup';
	WOStruct['#attributes.fuseaction#']['added']['fuseaction'] = 'ehesap.popup_add_added_offtimes';
	WOStruct['#attributes.fuseaction#']['added']['filePath'] = 'hr/ehesap/form/add_added_offtime.cfm';
	WOStruct['#attributes.fuseaction#']['added']['queryPath'] = 'hr/ehesap/query/add_added_offtime.cfm';
	WOStruct['#attributes.fuseaction#']['added']['nextEvent'] = 'ehesap.offtimes&event=upd';
	WOStruct['#attributes.fuseaction#']['added']['parameters'] = 'offtime_id=##attributes.offtime_id##';
	WOStruct['#attributes.fuseaction#']['added']['Identity'] = '#lang_array.item[1043]#';
	
	WOStruct['#attributes.fuseaction#']['add_plan'] = structNew();
	WOStruct['#attributes.fuseaction#']['add_plan']['window'] = 'popup';
	WOStruct['#attributes.fuseaction#']['add_plan']['fuseaction'] = 'ehesap.popup_add_offtime_plan';
	WOStruct['#attributes.fuseaction#']['add_plan']['filePath'] = 'hr/ehesap/form/add_offtime_plan.cfm';
	WOStruct['#attributes.fuseaction#']['add_plan']['queryPath'] = 'hr/ehesap/query/add_offtime_plan.cfm';
	WOStruct['#attributes.fuseaction#']['add_plan']['nextEvent'] = 'ehesap.offtimes&event=upd';
	WOStruct['#attributes.fuseaction#']['add_plan']['parameters'] = 'offtime_id=##attributes.offtime_id##';
	WOStruct['#attributes.fuseaction#']['add_plan']['Identity'] = '#lang_array.item[1332]#';
	
	if(not attributes.event is 'add')
	{
		WOStruct['#attributes.fuseaction#']['del'] = structNew();
		WOStruct['#attributes.fuseaction#']['del']['window'] = 'emptypopup';
		WOStruct['#attributes.fuseaction#']['del']['fuseaction'] = 'ehesap.emptypopup_del_offtime';
		WOStruct['#attributes.fuseaction#']['del']['filePath'] = 'hr/ehesap/query/del_offtime.cfm';
		WOStruct['#attributes.fuseaction#']['del']['queryPath'] = 'hr/ehesap/query/del_offtime.cfm';
		WOStruct['#attributes.fuseaction#']['del']['nextEvent'] = 'ehesap.offtimes';
	}
	
	if ((isdefined("attributes.event") and attributes.event is 'list') or not isdefined("attributes.event"))
	{
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['list'] = structNew();
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['list']['menus'] = structNew();
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['list']['menus'][0]['text'] = '#lang_array.item[1043]#';
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['list']['menus'][0]['onClick'] = "windowopen('#request.self#?fuseaction=ehesap.offtimes&event=added','list');";
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['list']['menus'][1]['text'] = 'İzin Çizelgesi';
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['list']['menus'][1]['href'] = "#request.self#?fuseaction=ehesap.offtime_graph";
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['list']['menus'][2]['text'] = '#lang_array.item[1318]#';
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['list']['menus'][2]['onClick'] = "windowopen('#request.self#?fuseaction=ehesap.offtimes&event=add_plan','longpage');";
		if (IsDefined('form_submit') and get_offtimes.recordcount)
		{
			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['list']['icons'] = structNew();
			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['list']['icons']['print']['text'] = '#lang_array.item[1044]#';
			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['list']['icons']['print']['onclick'] = "send_pdf_print();";
		}
		tabMenuData = SerializeJSON(tabMenuStruct['#attributes.fuseaction#']['tabMenus']);
	}
	else if (isdefined("attributes.event") and attributes.event is 'upd')
	{
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd'] = structNew();
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['icons'] = structNew();
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['icons']['print']['text'] = '#lang_array_main.item[62]#';
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['icons']['print']['onclick'] = "windowopen('#request.self#?fuseaction=objects.popup_print_files&iid=#attributes.offtime_id#&print_type=175','page');";
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['icons']['add']['text'] = '#lang_array_main.item[170]#';
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['icons']['add']['href'] = "#request.self#?fuseaction=ehesap.offtimes&event=add";
		tabMenuData = SerializeJSON(tabMenuStruct['#attributes.fuseaction#']['tabMenus']);
	}
	
	WOStruct['#attributes.fuseaction#']['extendedForm'] = structNew();
	WOStruct['#attributes.fuseaction#']['extendedForm']['controllerFileName'] = 'ehesapOfftimes.cfm';
	WOStruct['#attributes.fuseaction#']['extendedForm']['eventList'] = 'add,upd';
	WOStruct['#attributes.fuseaction#']['extendedForm']['tableName'] = 'OFFTIME';
	WOStruct['#attributes.fuseaction#']['extendedForm']['dataSourceName'] = 'main';
	WOStruct['#attributes.fuseaction#']['extendedForm']['settings'] = "['item-offtimecat_id','item-startdate','item-finishdate','item-work_startdate','item-validator_position']";

</cfscript>
