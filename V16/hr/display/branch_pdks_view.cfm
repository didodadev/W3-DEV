<cfsetting showdebugoutput="no">
<cfscript>
	last_month_1 = CreateDateTime(session.ep.period_year, attributes.sal_mon,1,0,0,0);
	last_month_30 = CreateDateTime(session.ep.period_year, attributes.sal_mon,daysinmonth(last_month_1),23,59,59);
	resmi_tatil_gunleri = '';
</cfscript>
<cfquery name="GET_CALENDER_OFFTIMES_" datasource="#DSN#">
	SELECT
		START_DATE,
		FINISH_DATE,
		OFFTIME_NAME
	FROM 
		SETUP_GENERAL_OFFTIMES
	ORDER BY
		START_DATE
</cfquery>

<cfif GET_CALENDER_OFFTIMES_.recordcount>	
	<cfoutput query="GET_CALENDER_OFFTIMES_">
		<cfset off_name_ = OFFTIME_NAME>
		<cfset day_count = DateDiff("d",GET_CALENDER_OFFTIMES_.START_DATE,GET_CALENDER_OFFTIMES_.FINISH_DATE) + 1>
			<cfloop index="k" from="1" to="#day_count#">
				<cfset current_day = date_add("d", k-1, GET_CALENDER_OFFTIMES_.START_DATE)>
				<cfif not (year(now()) eq year(current_day) and month(now()) eq month(current_day) and day(now()) eq day(current_day))>
					<cfset resmi_tatil_gunleri = listappend(resmi_tatil_gunleri,"#dateformat(current_day,'yyyymmdd')#")>
				</cfif>
			</cfloop>
	</cfoutput>
</cfif>
<cfinclude template="../query/get_emp_codes.cfm">
<cfset aydaki_gun_sayisi = daysinmonth(createdate(session.ep.period_year,attributes.sal_mon,01))>
<cfquery name="GET_SSK_EMPLOYEES" datasource="#DSN#">
	SELECT
		EMPLOYEES_IN_OUT.IS_PUANTAJ_OFF,
		EMPLOYEES_IN_OUT.IN_OUT_ID,
		EMPLOYEES_IN_OUT.EMPLOYEE_ID,
		EMPLOYEES_IN_OUT.POSITION_CODE,
		EMPLOYEES_IN_OUT.START_DATE,
		EMPLOYEES_IN_OUT.FINISH_DATE,
		EMPLOYEES_IN_OUT.VALID,
		EMPLOYEES_IN_OUT.POSITION_CODE,
		EMPLOYEES.EMPLOYEE_NAME,
		EMPLOYEES.EMPLOYEE_SURNAME,
		EMPLOYEES_IDENTY.TC_IDENTY_NO,
		EMPLOYEES_IN_OUT.SOCIALSECURITY_NO,
		BRANCH.BRANCH_ID,
		BRANCH.COMPANY_ID
	FROM 
		EMPLOYEES_IN_OUT,
		EMPLOYEES_IDENTY,
		BRANCH,
		EMPLOYEES
	WHERE
		<cfif isdefined("attributes.func_id") and len(attributes.func_id)>
			EMPLOYEES.EMPLOYEE_ID IN (SELECT EMPLOYEE_ID FROM EMPLOYEE_POSITIONS WHERE FUNC_ID = #attributes.func_id#) AND
		</cfif>
		BRANCH.BRANCH_STATUS = 1 AND
		EMPLOYEES.EMPLOYEE_STATUS = 1 AND
		BRANCH.SSK_OFFICE = '#listgetat(attributes.SSK_OFFICE,1,'-')#' AND
		BRANCH.SSK_NO = '#listgetat(attributes.SSK_OFFICE,2,'-')#' AND
		EMPLOYEES.EMPLOYEE_ID = EMPLOYEES_IDENTY.EMPLOYEE_ID AND
		EMPLOYEES.EMPLOYEE_ID = EMPLOYEES_IN_OUT.EMPLOYEE_ID
	<cfif not session.ep.ehesap>
		AND BRANCH.BRANCH_ID IN (SELECT BRANCH_ID FROM EMPLOYEE_POSITION_BRANCHES WHERE EMPLOYEE_POSITION_BRANCHES.POSITION_CODE = #session.ep.position_code# AND EMPLOYEE_POSITION_BRANCHES.DEPARTMENT_ID IS NULL)
	</cfif>
		AND
		EMPLOYEES_IN_OUT.START_DATE <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#createdate(session.ep.period_year,attributes.sal_mon,daysinmonth(createdate(session.ep.period_year,attributes.sal_mon,1)))#">
		AND
		(
			(EMPLOYEES_IN_OUT.FINISH_DATE >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#createdate(session.ep.period_year,attributes.sal_mon,1)#">)
			OR
			EMPLOYEES_IN_OUT.FINISH_DATE IS NULL
		)
		AND BRANCH.BRANCH_ID = EMPLOYEES_IN_OUT.BRANCH_ID
		<cfif fusebox.dynamic_hierarchy>
				<cfloop list="#emp_code_list#" delimiters="+" index="code_i">
					<cfif database_type is "MSSQL">
						AND 
						('.' + EMPLOYEES.DYNAMIC_HIERARCHY + '.' + EMPLOYEES.DYNAMIC_HIERARCHY_ADD + '.') LIKE '%.#code_i#.%'
					<cfelseif database_type is "DB2">
						AND 
						('.' || EMPLOYEES.DYNAMIC_HIERARCHY || '.' || EMPLOYEES.DYNAMIC_HIERARCHY_ADD || '.') LIKE '%.#code_i#.%'
					</cfif>
				</cfloop>
		<cfelse>
				<cfloop list="#emp_code_list#" delimiters="+" index="code_i">
						AND
						(
							('.' + EMPLOYEES.HIERARCHY + '.') LIKE '%.#code_i#.%' OR
							('.' + EMPLOYEES.OZEL_KOD + '.') LIKE '%.#code_i#.%' OR
							('.' + EMPLOYEES.OZEL_KOD2 + '.') LIKE '%.#code_i#.%'
						)
				</cfloop>
		</cfif>
	ORDER BY
		EMPLOYEES.EMPLOYEE_NAME,
		EMPLOYEES.EMPLOYEE_SURNAME,
		EMPLOYEES_IN_OUT.IN_OUT_ID ASC
</cfquery>

<cfif not GET_SSK_EMPLOYEES.RecordCount>
    <script>alert("<cf_get_lang dictionary_id='33572.Çalışan bulunamadı'>!");</script>
    <cfabort>
</cfif>

<cfquery name="get_all_izin" datasource="#dsn#">
	SELECT 
		OFFTIME.STARTDATE,
		OFFTIME.FINISHDATE,
		OFFTIME.EMPLOYEE_ID,
		CASE
			WHEN OFFTIME.IN_OUT_ID IS NOT NULL THEN OFFTIME.IN_OUT_ID
			WHEN OFFTIME.IN_OUT_ID IS NULL THEN (SELECT TOP 1 IN_OUT_ID FROM EMPLOYEES_IN_OUT EIO WHERE EIO.EMPLOYEE_ID = OFFTIME.EMPLOYEE_ID AND EIO.BRANCH_ID = #GET_SSK_EMPLOYEES.BRANCH_ID# AND EIO.START_DATE <= #DATEADD('h',-session.ep.time_zone,last_month_30)# AND (EIO.FINISH_DATE IS NULL OR EIO.FINISH_DATE > #DATEADD('h',-session.ep.time_zone,last_month_1)#))
		END
			AS THIS_IN_OUT,
		OFFTIME.STARTDATE,
		SETUP_OFFTIME.IS_PAID,
		SETUP_OFFTIME.IS_YEARLY,
		SETUP_OFFTIME.EBILDIRGE_TYPE_ID,
		SETUP_OFFTIME.SIRKET_GUN
	FROM 
		OFFTIME
		INNER JOIN SETUP_OFFTIME ON OFFTIME.OFFTIMECAT_ID = SETUP_OFFTIME.OFFTIMECAT_ID
	WHERE 
		OFFTIME.STARTDATE <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#last_month_30#"> AND
		OFFTIME.FINISHDATE > <cfqueryparam cfsqltype="cf_sql_timestamp" value="#last_month_1#"> AND
		OFFTIME.EMPLOYEE_ID IN (#valuelist(GET_SSK_EMPLOYEES.employee_id)#)
</cfquery>


<cfoutput query="get_all_izin">
	<cfscript>
		if (IS_PAID eq 1 and EBILDIRGE_TYPE_ID neq 1 and (is_yearly eq 0 or not len(is_yearly)) and (SIRKET_GUN eq 0 or not len(SIRKET_GUN)))
			type_ = 'i';
		else if (is_yearly eq 1)
			type_ = 'y';
		else if (EBILDIRGE_TYPE_ID eq 15)
			type_ = 'd';
		else if (SIRKET_GUN gt 0)
			type_ = 'r2';
		else if (EBILDIRGE_TYPE_ID eq 1 and (SIRKET_GUN eq 0 or SIRKET_GUN is 'NULL'))
			type_ = 'r';
		else if (EBILDIRGE_TYPE_ID eq 7)
			type_ = 'p';
		else
			type_ = 'u';
		total_izin_ = datediff('d',get_all_izin.startdate,get_all_izin.finishdate)+1;
		izin_startdate_ = date_add("h", session.ep.time_zone, get_all_izin.startdate); 
		izin_finishdate_ = date_add("h", session.ep.time_zone, get_all_izin.finishdate);
		for (mck_=0; mck_ lt total_izin_; mck_=mck_+1)
		{
			temp_izin_gunu_ = date_add("d",mck_,izin_startdate_);
			'calisan_durum_#day(temp_izin_gunu_)#_#THIS_IN_OUT#' = type_;
		}
	</cfscript>
</cfoutput>

<cfquery name="get_offday_info" datasource="#dsn#">
	SELECT WEEKLY_OFFDAY FROM OUR_COMPANY_HOURS WHERE OUR_COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_ssk_employees.company_id#">
</cfquery>
<cfif get_offday_info.recordcount and len(get_offday_info.WEEKLY_OFFDAY)>
	<cfset this_weekly_day_ = get_offday_info.WEEKLY_OFFDAY>
<cfelse>
	<cfset this_weekly_day_ = 1>
</cfif>

<cfquery name="get_all_ins" datasource="#dsn#">
	SELECT * FROM EMPLOYEE_DAILY_IN_OUT WHERE START_DATE >= #last_month_1# AND START_DATE <= #last_month_30# AND ISNULL(FROM_HOURLY_ADDFARE,0) = 0
</cfquery>
<cfoutput query="get_all_ins">
	<cfif IS_WEEK_REST_DAY eq 0>
		<cfset 'calisan_durum_#day(START_DATE)#_#in_out_id#' = 2>
	<cfelseif isDefined("is_puantaj_off") and is_puantaj_off eq 1>
		<cfset 'calisan_durum_#day(START_DATE)#_#in_out_id#' = 'yg'>
	<cfelseif IS_WEEK_REST_DAY eq 1>
    	<cfset 'calisan_durum_#day(START_DATE)#_#in_out_id#' = 3>
    <cfelse>
		<cfset 'calisan_durum_#day(START_DATE)#_#in_out_id#' = 1>
	</cfif>
</cfoutput>
<cfform name="branch_pdks" action="#request.self#?fuseaction=hr.emptypopup_branch_pdks_add" method="post">
	<cf_box_elements>
		<div class="col col-12 col-xs-12">
	<div class="form-group">
		<label class="col col-1">0: <cf_get_lang dictionary_id='64197.İşe gelmedi'></label>
		<label class="col col-1">1: <cf_get_lang dictionary_id='64198.Çalıştığı gün'></label>
		<label class="col col-1"><cf_get_lang dictionary_id='64199.YG: Yarım gün çalışma'></label>
		<label class="col col-1"><cf_get_lang dictionary_id='64200.R: Raporlu'></label>
		<label class="col col-1"><cf_get_lang dictionary_id='64201.İ: Ücretli izin'></label>
		<label class="col col-1"><cf_get_lang dictionary_id='64202.Y: Yıllık izin'></label>
		<label class="col col-1"><cf_get_lang dictionary_id='64203.Ü: Ücretsiz izin'></label>
		<label class="col col-1"><cf_get_lang dictionary_id='64204.D: Devamsız'></label>
		<label class="col col-1"><cf_get_lang dictionary_id='64205.P: Puantaj izni'></label>
		<label class="col col-1"><cf_get_lang dictionary_id='64206.HT: Hafta tatili'></label>
		<label class="col col-1"><cf_get_lang dictionary_id='64207.GT: Genel tatili'></label>
		<label class="col col-1"><cf_get_lang dictionary_id='64208.RT: Resmi tatil'></label>
	</div>
	</div>
	</cf_box_elements>
	<cf_grid_list>
		<input type="hidden" value="<cfoutput>#attributes.SAL_MON##SESSION.EP.PERIOD_YEAR##attributes.SSK_OFFICE##attributes.func_id#</cfoutput>" name="special_code" id="special_code">
		<input type="hidden" value="<cfoutput>#GET_SSK_EMPLOYEES.recordcount#</cfoutput>" name="kayit_sayisi" id="kayit_sayisi">
		<input type="hidden" value="<cfoutput>#attributes.SAL_MON#</cfoutput>" name="sal_mon" id="sal_mon">
		<input type="hidden" value="<cfoutput>#SESSION.EP.PERIOD_YEAR#</cfoutput>" name="sal_year" id="sal_year">
		<input type="hidden" value="<cfoutput>#aydaki_gun_sayisi#</cfoutput>" name="gun_sayisi" id="gun_sayisi">
		<thead>
			<tr>
				<th><cf_get_lang dictionary_id="57576.Çalışan"></th>
				<th><cf_get_lang dictionary_id='39937.SSK No'></th>
				<th><cf_get_lang dictionary_id="58025.TC Kimlik No"></th>
				<cfloop from="1" to="#aydaki_gun_sayisi#" index="ccc">
					<th><cfoutput>#ccc#</cfoutput></th>
				</cfloop>
				<th width="20"  class="header_icn_none text-center">
					<cfif GET_SSK_EMPLOYEES.recordcount>
						<input type="checkbox" name="allSelectDemand" id="allSelectDemand" onclick="wrk_select_all('allSelectDemand','print_pdks_id');">
					</cfif>
				</th>
			</tr>
		</thead>
		<tbody>
			<cfif GET_SSK_EMPLOYEES.recordcount>
				<input type="hidden" value="<cfoutput>#GET_SSK_EMPLOYEES.branch_id#</cfoutput>" name="branch_id" id="branch_id">
				<input type="hidden" value="<cfoutput>#attributes.func_id#</cfoutput>" name="func_id" id="func_id">
				<cfoutput query="GET_SSK_EMPLOYEES">
					<input type="hidden" value="#in_out_id#" name="in_out_id_#currentrow#" id="in_out_id_#currentrow#">
					<input type="hidden" value="#employee_id#" name="employee_id_#currentrow#" id="employee_id_#currentrow#">
					<cfscript>
						last_month_1 = CreateDateTime(session.ep.period_year,attributes.sal_mon, 1,0,0,0);
						last_month_30 = CreateDateTime(session.ep.period_year, attributes.sal_mon, daysinmonth(last_month_1), 23,59,59);
						if (datediff("h",last_month_1,GET_SSK_EMPLOYEES.start_date) gte 0)
							last_month_1 = GET_SSK_EMPLOYEES.start_date;
						last_month_1 = date_add("d",0,last_month_1);
						if (len(GET_SSK_EMPLOYEES.finish_date) and datediff("d",GET_SSK_EMPLOYEES.finish_date,last_month_30) gt 0)
							last_month_30 = CreateDateTime(year(GET_SSK_EMPLOYEES.finish_date),month(GET_SSK_EMPLOYEES.finish_date),day(GET_SSK_EMPLOYEES.finish_date), 23,59,59);
					</cfscript>
					<tr>
						<td nowrap="nowrap">#employee_name# #employee_surname#</td>
						<td nowrap="nowrap">#socialsecurity_no#</td>
						<td nowrap="nowrap">#tc_identy_no#</td>
						<cfquery name="get_record_emp_" dbtype="query">
							SELECT * FROM get_all_ins WHERE EMPLOYEE_ID = #employee_id#
						</cfquery>
						<cfloop from="1" to="#aydaki_gun_sayisi#" index="ccc">
							<cfset to_day_ = createdate(session.ep.period_year,attributes.sal_mon,ccc)>
							<cfset day_ = "#session.ep.period_year#">
							<cfif attributes.sal_mon gte 10>
								<cfset day_ = "#day_##attributes.sal_mon#">
							<cfelse>
								<cfset day_ = "#day_#0#attributes.sal_mon#">
							</cfif>
							<cfif ccc gte 10>
								<cfset day_ = "#day_##ccc#">
							<cfelse>
								<cfset day_ = "#day_#0#ccc#">
							</cfif>
							<td <cfif listfindnocase(resmi_tatil_gunleri,day_)>class="color-header"</cfif> width="20" align="center" title="#EMPLOYEE_NAME# #EMPLOYEE_SURNAME# (#tc_identy_no#) Ay-Gün : #listgetat(ay_list(),attributes.SAL_MON)#-#ccc#">
								<cfif day(last_month_1) lte ccc and day(last_month_30) gte ccc>
								<select name="day_#in_out_id#_#ccc#" id="day_#in_out_id#_#ccc#">
									<option value="0" <cfif get_record_emp_.recordcount and not isdefined("calisan_durum_#ccc#_#in_out_id#")>selected</cfif>>0</option>
									<option value="1" <cfif (isdefined("calisan_durum_#ccc#_#in_out_id#") and evaluate("calisan_durum_#ccc#_#in_out_id#") is '1') or (not get_record_emp_.recordcount and not isdefined("calisan_durum_#ccc#_#in_out_id#"))>selected</cfif>>1</option>
									<option value="yg" <cfif isdefined("calisan_durum_#ccc#_#in_out_id#") and evaluate("calisan_durum_#ccc#_#in_out_id#") is 'yg'>selected</cfif>>YG</option>
									<option value="r2" <cfif isdefined("calisan_durum_#ccc#_#in_out_id#") and evaluate("calisan_durum_#ccc#_#in_out_id#") is 'r2'>selected</cfif>>R2</option>
									<option value="r" <cfif isdefined("calisan_durum_#ccc#_#in_out_id#") and evaluate("calisan_durum_#ccc#_#in_out_id#") is 'r'>selected</cfif>>R</option>
									<option value="i" <cfif isdefined("calisan_durum_#ccc#_#in_out_id#") and evaluate("calisan_durum_#ccc#_#in_out_id#") is 'i'>selected</cfif>>İ</option>
									<option value="y" <cfif isdefined("calisan_durum_#ccc#_#in_out_id#") and evaluate("calisan_durum_#ccc#_#in_out_id#") is 'y'>selected</cfif>>Y</option>
									<option value="u" <cfif isdefined("calisan_durum_#ccc#_#in_out_id#") and evaluate("calisan_durum_#ccc#_#in_out_id#") is 'u'>selected</cfif>>Ü</option>
									<option value="d" <cfif isdefined("calisan_durum_#ccc#_#in_out_id#") and evaluate("calisan_durum_#ccc#_#in_out_id#") is 'd'>selected</cfif>>D</option>
									<option value="p" <cfif isdefined("calisan_durum_#ccc#_#in_out_id#") and evaluate("calisan_durum_#ccc#_#in_out_id#") is 'p'>selected</cfif>>P</option>
									<option value="2" <cfif (isdefined("calisan_durum_#ccc#_#in_out_id#") and evaluate("calisan_durum_#ccc#_#in_out_id#") is '2') or (not isdefined("calisan_durum_#ccc#_#in_out_id#") and dayofweek(to_day_) eq this_weekly_day_)>selected</cfif>>HT</option>
									<option value="3" <cfif isdefined("calisan_durum_#ccc#_#in_out_id#") and evaluate("calisan_durum_#ccc#_#in_out_id#") is '3' or listfindnocase(resmi_tatil_gunleri,day_)>selected</cfif>>GT</option>
								</select>
								<cfelse>
									0
								<input type="hidden" value="0" name="day_#in_out_id#_#ccc#" id="day_#in_out_id#_#ccc#">
								</cfif>
							</td>
						</cfloop>
						<td class="text-center"><input type="checkbox" name="print_pdks_id" id="print_pdks_id"  value="#employee_id#,#attributes.sal_mon#,#attributes.ssk_office#"></td>
						<!-- sil -->		
						</tr>
				</cfoutput>
			<cfelse>
				<tr>
					<td colspan="50"><cf_get_lang dictionary_id="58486.Kayıt Bulunamadı">!</td>
				</tr>
			</cfif>
		</tbody>
	</cf_grid_list>
	<div class="ui-info-bottom flex-end">
		<cf_workcube_buttons is_upd='0'>
	</div>
</cfform>
<script type="text/javascript">
 function send_emp_info(emp_id)
 {
		adres = '<cfoutput>#request.self#?fuseaction=objects.popup_print_files&print_type=533&</cfoutput>';
		adres +='&ssk_office_all_='+document.employee.ssk_office.value;
		adres +='&employee_id='+emp_id;
		adres +='&ssk_office_='+list_getat(document.employee.ssk_office.value,1,'-');
		adres +='&sal_mon_='+document.employee.sal_mon.value;
		adres +='&id='+list_getat(document.employee.ssk_office.value,2,'-');	
		windowopen(adres,'page');
	
 }

function renkDegistir(eleman)
{
	if(eleman.bgColor=="#ffffff")
		eleman.bgColor = 'cccccc';
	else
		eleman.bgColor = 'ffffff';
}
</script>
