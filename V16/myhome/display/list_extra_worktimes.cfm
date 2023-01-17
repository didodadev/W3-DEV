<cf_xml_page_edit fuseact="myhome.list_extra_worktimes">
<cfset Cmp = createObject("component","CustomTags.cfc.get_workcube_process") />
<cfset Cmp.data_source = dsn />
<cfset Cmp.process_db = '#dsn_alias#.' />
<cfparam name="emp_id_list" default="">
<cfparam name="aydaki_gun_sayisi" default="">
<cfparam name="attributes.admin1_pos_code" default="">
<cfparam name="attributes.admin2_pos_code" default="">
<cfparam name="attributes.admin3_pos_code" default="">
<cfparam name="attributes.sal_mon" default="#month(now())#">
<cfparam name="attributes.sal_year" default="#year(now())#">
<cfquery name="get_emp_pos" datasource="#dsn#">
	SELECT POSITION_CODE FROM EMPLOYEE_POSITIONS WHERE EMPLOYEE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.userid#">
</cfquery>
<cfset pos_code_list = valuelist(get_emp_pos.position_code)>
<cfset branch_list = "">
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
<cfquery name="get_departments" datasource="#dsn#">
	SELECT
		DEPARTMENT_ID,
		BRANCH_ID
	FROM
		DEPARTMENT
	WHERE
		DEPARTMENT_STATUS = 1
		<cfif len(x_manager_pos_code) and x_manager_pos_code neq session.ep.position_code and not get_module_power_user(48)>
		AND 
		(
		DEPARTMENT_ID IN (SELECT DEPARTMENT_ID FROM EMPLOYEE_POSITIONS WHERE POSITION_CODE IN (<cfqueryparam cfsqltype="cf_sql_integer" list="true" value="#pos_code_list#">)) OR
		ADMIN1_POSITION_CODE IN (<cfqueryparam cfsqltype="cf_sql_integer" list="true" value="#pos_code_list#">) OR
		ADMIN2_POSITION_CODE IN (<cfqueryparam cfsqltype="cf_sql_integer" list="true" value="#pos_code_list#">)
		)
		</cfif>
</cfquery>
<cfif get_departments.recordcount>
	<cfset branch_list = valuelist(get_departments.BRANCH_ID)>
	<cfset dept_list = valuelist(get_departments.DEPARTMENT_ID)>
	
	<cfif isdefined('attributes.branch_id') and len(attributes.branch_id) and isdefined('attributes.department') and len(attributes.department) and not listfindnocase(dept_list,attributes.department)>
		<script>
			alert('<cf_get_lang dictionary_id="59945.Bu Departmanda Yetkili Değilsiniz">!');
			window.location.href='<cfoutput>#request.self#?fuseaction=myhome.list_extra_worktimes</cfoutput>';
		</script>
		<cfabort>
	</cfif>
	
	<cfquery name="GET_BRANCHES" datasource="#DSN#">
		SELECT
			BRANCH_NAME,
			BRANCH_ID
		FROM
			BRANCH
			<cfif session.ep.ehesap neq 1><!--- Üst düzey İK yetkisi yoksa sadece yetkili olduğu şubeleri listeler --->
				WHERE
				 BRANCH_ID IN (
								SELECT
									BRANCH_ID
								FROM
									EMPLOYEE_POSITION_BRANCHES
								WHERE
									POSITION_CODE = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.position_code#">
								)
			</cfif>	
		ORDER BY
			BRANCH_NAME
	</cfquery>
<cfelse>
	<cfset get_branches.recordcount = 0>
</cfif>
<table class="dph">
	<tr>
		<td class="detailhead"><cf_get_lang dictionary_id='30965.Toplu Fazla Mesailer'></td>
	</tr>
</table>
<cf_basket_form>
    <cfform name="employee" method="post" action="#request.self#?fuseaction=myhome.list_extra_worktimes">
		<div class="row form-inline">  
				<input name="is_form_submitted" id="is_form_submitted" type="hidden" value="1">
				<input type="hidden" name="admin3_pos_code" id="admin3_pos_code" value="<cfoutput>#x_manager_pos_code#</cfoutput>">
			<div class="form-group" id="item-branch_id">
                <div class="input-group x-24">	
					<select name="branch_id" id="branch_id" style="width:150px;" onchange="showDepartment();">
						<option value=""><cf_get_lang dictionary_id='57453.Şube'></option>
						<cfoutput query="GET_BRANCHES">
							<option value="#branch_id#"<cfif (isdefined("attributes.branch_id") and branch_id eq attributes.branch_id)>selected</cfif>>#BRANCH_NAME#</option>
							<cfif not isdefined("attributes.branch_id") and currentrow eq 1>
								<cfset attributes.branch_id = branch_id>
							</cfif>
						</cfoutput>
					</select>
                </div>
			</div>	
		<cfif not isDefined("attributes.report_id")><!---Isbak Ozel Rapordan Geliyor FBS 20130125--->
            <div class="form-group" id="item-department">
                <div class="input-group x-18">
					<div width="150" id="DEPARTMENT_PLACE">
						<select name="department" id="department" style="width:150px;">
							<cfif not isdefined("attributes.branch_id")>
								<option value=""><cf_get_lang dictionary_id='58836.Lutfen Departman Seciniz'></option>
							<cfelseif isdefined('attributes.branch_id') and len(attributes.branch_id)>
								<option value=""><cf_get_lang dictionary_id='58836.Lutfen Departman Seciniz'></option>
									<cfquery name="get_department" datasource="#dsn#">
										SELECT * FROM DEPARTMENT WHERE BRANCH_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.branch_id#"> AND DEPARTMENT_ID IN (<cfqueryparam cfsqltype="cf_sql_integer" list="true" value="#dept_list#">) ORDER BY DEPARTMENT_HEAD
									</cfquery>
									<cfoutput query="get_department">
										<option value="#department_id#"<cfif isdefined('attributes.department') and (department_id eq attributes.department)>selected</cfif>>#DEPARTMENT_HEAD#</option>
								</cfoutput>
							</cfif>
						</select>
            		</div>
    			</div>
			</div>	
        </cfif>
            <div class="form-group" id="item-sal_mon">
                <div class="input-group x-12">
                    <select name="sal_mon" id="sal_mon">
                        <cfloop from="1" to="12" index="i">
                            <cfoutput>
                                <option value="#i#" <cfif attributes.sal_mon eq i>selected</cfif>>#listgetat(ay_list(),i,',')#</option>
                            </cfoutput>
                        </cfloop>
                    </select>
                    <cfinput type="hidden" name="maxrows" value="#session.ep.maxrows#">
                </div>
			</div>	
            <div class="form-group" id="item-sal_year">
                <div class="input-group x-10">
                    <select name="sal_year" id="sal_year">
                        <cfloop from="#year(now())+2#" to="#year(now())-2#" index="i" step="-1">
                            <cfoutput>
                                <option value="#i#" <cfif attributes.sal_year eq i>selected</cfif>>#i#</option>
                            </cfoutput>
                        </cfloop>
                    </select>
                    <cfinput type="hidden" name="maxrows" value="#session.ep.maxrows#">
                </div>
			</div>	
            <div class="form-group">
				<cf_wrk_search_button search_function="kontrol_extra_time()">
            </div>
        </div>
    </cfform> 
</cf_basket_form>                                      
<cfif isdefined("attributes.is_form_submitted")>
<cfscript>
	last_month_1 = CreateDateTime(attributes.sal_year, attributes.sal_mon, 1,0,0,0);
	last_month_30 = CreateDateTime(attributes.sal_year, attributes.sal_mon, daysinmonth(last_month_1), 23,59,59);
	aydaki_gun_sayisi = daysinmonth(last_month_1);
	sal_mon_ = attributes.sal_mon;
	sal_year_ = attributes.sal_year;
</cfscript>
<cfquery name="get_comp" datasource="#dsn#">
    SELECT COMPANY_ID FROM BRANCH WHERE BRANCH_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.branch_id#">
</cfquery>
<cfset attributes.comp_id = get_comp.COMPANY_ID>
<cfquery name="GET_GENERAL_OFFTIMES" datasource="#dsn#">
	SELECT START_DATE,FINISH_DATE FROM SETUP_GENERAL_OFFTIMES
</cfquery>
<cfquery name="get_saturday_off" datasource="#dsn#">
    SELECT		
		OUR_COMPANY_HOURS.SATURDAY_OFF
	FROM
		OUR_COMPANY_HOURS,
		OUR_COMPANY
	WHERE
		OUR_COMPANY.COMP_ID = OUR_COMPANY_HOURS.OUR_COMPANY_ID
		AND OUR_COMPANY_HOURS.OUR_COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.comp_id#">
</cfquery>
<!--- bu ay içindeki genel tatiller --->
<cfscript>
offdays_day_list = '';
for (ggotrc = 1; ggotrc lte get_GENERAL_OFFTIMES.recordcount; ggotrc=ggotrc+1)
	for (ijklmn = 0; ijklmn lte datediff("d", get_GENERAL_OFFTIMES.start_date[ggotrc], get_GENERAL_OFFTIMES.FINISH_DATE[ggotrc]); ijklmn=ijklmn+1)
		{
		tempo_day = date_add("d", ijklmn, get_GENERAL_OFFTIMES.start_date[ggotrc]);
		offdays_day_list = listappend(offdays_day_list,'#dateformat(tempo_day,"ddmmyyyy")#');
		}
</cfscript>
<!--- // bu ay içindeki genel tatiller --->
	<cfset special_code_ = 'FM#attributes.branch_id#-#attributes.department#-#attributes.sal_year#-#attributes.sal_mon#'>
	<cfquery name="get_my_dep" datasource="#dsn#">
		SELECT 
			DEPARTMENT_ID
		FROM 
			EMPLOYEE_POSITIONS
		WHERE 
			EMPLOYEE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.userid#"> AND
			(
			DEPARTMENT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.department#"> <!--- kendisi bu departmanda ise --->
			OR #attributes.department#IN(SELECT EP.DEPARTMENT_ID FROM EMPLOYEE_POSITIONS EP,EMPLOYEE_POSITIONS_STANDBY EPS WHERE EP.POSITION_CODE = EPS.POSITION_CODE AND EPS.CANDIDATE_POS_1 = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.position_code#">)<!--- 1.yedek olduğu kişi bu departmanda ise --->
			OR #attributes.department# IN(SELECT EP.DEPARTMENT_ID FROM EMPLOYEE_POSITIONS EP,EMPLOYEE_POSITIONS_STANDBY EPS WHERE EP.POSITION_CODE = EPS.POSITION_CODE AND EPS.CANDIDATE_POS_2 = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.position_code#">)<!--- 2.yedek olduğu kişi bu departmanda ise --->
			)
	</cfquery>
	<cfquery name="get_department_positions" datasource="#DSN#">
		SELECT 
			E.EMPLOYEE_NAME,
			E.EMPLOYEE_SURNAME,
			E.EMPLOYEE_ID,
			D.DEPARTMENT_HEAD,
			D.DEPARTMENT_ID,
			B.BRANCH_NAME,
			B.BRANCH_ID,
			EIO.IN_OUT_ID,
			D.ADMIN1_POSITION_CODE,
			D.ADMIN2_POSITION_CODE
		FROM
			EMPLOYEES_IN_OUT EIO,
			EMPLOYEES E,
			DEPARTMENT D,
			BRANCH B
		WHERE
			(EIO.IS_PUANTAJ_OFF = 0 OR EIO.IS_PUANTAJ_OFF IS NULL) AND
			E.EMPLOYEE_ID = EIO.EMPLOYEE_ID AND
			EIO.DEPARTMENT_ID = D.DEPARTMENT_ID AND
			B.BRANCH_STATUS = 1 AND
			E.EMPLOYEE_STATUS = 1 AND
            E.EMPLOYEE_ID NOT IN(SELECT EMPLOYEE_ID FROM EMPLOYEE_POSITIONS WHERE POSITION_CODE = D.ADMIN1_POSITION_CODE) AND
            E.EMPLOYEE_ID NOT IN(SELECT EMPLOYEE_ID FROM EMPLOYEE_POSITIONS WHERE POSITION_CODE = D.ADMIN2_POSITION_CODE) AND
			D.BRANCH_ID = B.BRANCH_ID
				AND
				EIO.START_DATE <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#createodbcdatetime(last_month_30)#">
				AND
				(
					EIO.FINISH_DATE >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#createodbcdatetime(last_month_1)#"> OR EIO.FINISH_DATE IS NULL
				)
				AND D.DEPARTMENT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.department#">
				AND B.BRANCH_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.branch_id#"> 
		ORDER BY
			E.EMPLOYEE_NAME,
			E.EMPLOYEE_SURNAME
	</cfquery>
	<!--- satirlar doner --->
<cfform name="add_extra_worktimes" action="#request.self#?fuseaction=myhome.emptypopup_view_extra_worktimes">
<input type="hidden" name="veri_type" id="veri_type" value="<cfoutput>#x_select_mesai#</cfoutput>"> 
<input type="hidden" name="aydaki_gun_sayisi" id="aydaki_gun_sayisi" value="<cfoutput>#aydaki_gun_sayisi#</cfoutput>">
<input type="hidden" name="sal_mon" id="sal_mon" value="<cfoutput>#sal_mon_#</cfoutput>">
<input type="hidden" name="sal_year" id="sal_year" value="<cfoutput>#sal_year_#</cfoutput>">
<cfif len(get_department_positions.ADMIN1_POSITION_CODE)>
	<cfset pos1 = get_department_positions.ADMIN1_POSITION_CODE>
    <cfset name1 = get_emp_info(get_department_positions.ADMIN1_POSITION_CODE,1,0)>
    <cfset get_Real_Izin = Cmp.get_Real_Izin(
        position_code	: pos1,
        record_date	: now()
        ) />
     <cfif get_Real_Izin.recordcount>
        <cfset get_StandBys = Cmp.get_StandBys(
            position_code	: pos1
            ) />
        <cfset gercek_yaz = 0>
        <cfset yedek_1_yaz = 0>
        <cfset yedek_2_yaz = 0>
        <cfset yedek_3_yaz = 0>
            <cfif get_standbys.recordcount>
                <cfif len(get_standbys.candidate_pos_1)>
                    <cfset get_yedek_1 = Cmp.get_Yedek(
                        position_code	: get_standbys.candidate_pos_1
                        ) />
                    <cfset get_real_izin_1 = Cmp.get_Real_Izin(
                        position_code	: get_standbys.candidate_pos_1,
                        record_date		: now()
                        ) />
                    <cfif not get_real_izin_1.recordcount><cfset yedek_1_yaz = 1></cfif>
                </cfif>
                <cfif yedek_1_yaz eq 0 and len(get_standbys.candidate_pos_2)>
                    <cfset get_yedek_2 = Cmp.get_Yedek(
                        position_code	: get_standbys.candidate_pos_2
                        ) />
                    <cfset get_real_izin_2 = Cmp.get_Real_Izin(
                        position_code	: get_standbys.candidate_pos_2,
                        record_date		: now()
                        ) />
                    <cfif not get_real_izin_2.recordcount><cfset yedek_2_yaz = 1></cfif>
                </cfif>
                <cfif yedek_1_yaz eq 0 and yedek_2_yaz eq 0 and len(get_standbys.candidate_pos_3)>
                    <cfset get_yedek_3 = Cmp.get_Yedek(
                        position_code	: get_standbys.candidate_pos_3
                        ) />
                    <cfset get_real_izin_3 = Cmp.get_Real_Izin(
                        position_code	: get_standbys.candidate_pos_3,
                        record_date		: now()
                        ) />
                    <cfif not get_real_izin_3.recordcount><cfset yedek_3_yaz = 1></cfif>
                </cfif>
            <cfelse>
                <cfset gercek_yaz = 1>
            </cfif>
     <cfelse>
         <cfset gercek_yaz = 1>
     </cfif>
     
     <cfif gercek_yaz eq 1>
        <cfset pos1 = get_department_positions.ADMIN1_POSITION_CODE>
        <cfset name1 = get_emp_info(get_department_positions.ADMIN1_POSITION_CODE,1,0)>
    <cfelseif yedek_1_yaz eq 1>
        <cfset pos1 = get_yedek_1.POSITION_CODE>
        <cfset name1 = get_yedek_1.EMPLOYEE_NAME & ' ' & get_yedek_1.EMPLOYEE_SURNAME>
    <cfelseif yedek_2_yaz eq 1>
        <cfset pos1 = get_yedek_2.POSITION_CODE>
        <cfset name1 = get_yedek_2.EMPLOYEE_NAME & ' ' & get_yedek_2.EMPLOYEE_SURNAME>
    <cfelseif yedek_3_yaz eq 1>
        <cfset pos1 = get_yedek_3.POSITION_CODE>
        <cfset name1 = get_yedek_3.EMPLOYEE_NAME & ' ' & get_yedek_3.EMPLOYEE_SURNAME>
    </cfif>	
<cfelse>
    <cfset pos1 = "">
    <cfset name1 = "">
</cfif>

<cfif len(get_department_positions.ADMIN2_POSITION_CODE)>
    <cfset pos2 = get_department_positions.ADMIN2_POSITION_CODE>
    <cfset name2 = get_emp_info(get_department_positions.ADMIN2_POSITION_CODE,1,0)>
    <cfset get_Real_Izin = Cmp.get_Real_Izin(
        position_code	: pos2,
        record_date	: now()
        ) />
     <cfif get_Real_Izin.recordcount>
        <cfset get_StandBys = Cmp.get_StandBys(
            position_code	: pos2
            ) />
        <cfset gercek_yaz = 0>
        <cfset yedek_1_yaz = 0>
        <cfset yedek_2_yaz = 0>
        <cfset yedek_3_yaz = 0>
            <cfif get_standbys.recordcount>
                <cfif len(get_standbys.candidate_pos_1)>
                    <cfset get_yedek_1 = Cmp.get_Yedek(
                        position_code	: get_standbys.candidate_pos_1
                        ) />
                    <cfset get_real_izin_1 = Cmp.get_Real_Izin(
                        position_code	: get_standbys.candidate_pos_1,
                        record_date		: now()
                        ) />
                    <cfif not get_real_izin_1.recordcount><cfset yedek_1_yaz = 1></cfif>
                </cfif>
                <cfif yedek_1_yaz eq 0 and len(get_standbys.candidate_pos_2)>
                    <cfset get_yedek_2 = Cmp.get_Yedek(
                        position_code	: get_standbys.candidate_pos_2
                        ) />
                    <cfset get_real_izin_2 = Cmp.get_Real_Izin(
                        position_code	: get_standbys.candidate_pos_2,
                        record_date		: now()
                        ) />
                    <cfif not get_real_izin_2.recordcount><cfset yedek_2_yaz = 1></cfif>
                </cfif>
                <cfif yedek_1_yaz eq 0 and yedek_2_yaz eq 0 and len(get_standbys.candidate_pos_3)>
                    <cfset get_yedek_3 = Cmp.get_Yedek(
                        position_code	: get_standbys.candidate_pos_3
                        ) />
                    <cfset get_real_izin_3 = Cmp.get_Real_Izin(
                        position_code	: get_standbys.candidate_pos_3,
                        record_date		: now()
                        ) />
                    <cfif not get_real_izin_3.recordcount><cfset yedek_3_yaz = 1></cfif>
                </cfif>
            <cfelse>
                <cfset gercek_yaz = 1>
            </cfif>
     <cfelse>
         <cfset gercek_yaz = 1>
     </cfif>
     
     <cfif gercek_yaz eq 1>
        <cfset pos2 = get_department_positions.ADMIN2_POSITION_CODE>
        <cfset name2 = get_emp_info(get_department_positions.ADMIN2_POSITION_CODE,1,0)>
    <cfelseif yedek_1_yaz eq 1>
        <cfset pos2 = get_yedek_1.POSITION_CODE>
        <cfset name2 = get_yedek_1.EMPLOYEE_NAME & ' ' & get_yedek_1.EMPLOYEE_SURNAME>
    <cfelseif yedek_2_yaz eq 1>
        <cfset pos2 = get_yedek_2.POSITION_CODE>
        <cfset name2 = get_yedek_2.EMPLOYEE_NAME & ' ' & get_yedek_2.EMPLOYEE_SURNAME>
    <cfelseif yedek_3_yaz eq 1>
        <cfset pos2 = get_yedek_3.POSITION_CODE>
        <cfset name2 = get_yedek_3.EMPLOYEE_NAME & ' ' & get_yedek_3.EMPLOYEE_SURNAME>
    </cfif>	
<cfelse>
    <cfset pos2 = "">
    <cfset name2 = "">
</cfif>

<cfif len(x_manager_pos_code)>
    <cfset pos3 = x_manager_pos_code>
    <cfset name3 = get_emp_info(x_manager_pos_code,1,0)>
    <cfset get_Real_Izin = Cmp.get_Real_Izin(
        position_code	: pos3,
        record_date	: now()
        ) />
     <cfif get_Real_Izin.recordcount>
        <cfset get_StandBys = Cmp.get_StandBys(
            position_code	: pos3
            ) />
        <cfset gercek_yaz = 0>
        <cfset yedek_1_yaz = 0>
        <cfset yedek_2_yaz = 0>
        <cfset yedek_3_yaz = 0>
            <cfif get_standbys.recordcount>
                <cfif len(get_standbys.candidate_pos_1)>
                    <cfset get_yedek_1 = Cmp.get_Yedek(
                        position_code	: get_standbys.candidate_pos_1
                        ) />
                    <cfset get_real_izin_1 = Cmp.get_Real_Izin(
                        position_code	: get_standbys.candidate_pos_1,
                        record_date		: now()
                        ) />
                    <cfif not get_real_izin_1.recordcount><cfset yedek_1_yaz = 1></cfif>
                </cfif>
                <cfif yedek_1_yaz eq 0 and len(get_standbys.candidate_pos_2)>
                    <cfset get_yedek_2 = Cmp.get_Yedek(
                        position_code	: get_standbys.candidate_pos_2
                        ) />
                    <cfset get_real_izin_2 = Cmp.get_Real_Izin(
                        position_code	: get_standbys.candidate_pos_2,
                        record_date		: now()
                        ) />
                    <cfif not get_real_izin_2.recordcount><cfset yedek_2_yaz = 1></cfif>
                </cfif>
                <cfif yedek_1_yaz eq 0 and yedek_2_yaz eq 0 and len(get_standbys.candidate_pos_3)>
                    <cfset get_yedek_3 = Cmp.get_Yedek(
                        position_code	: get_standbys.candidate_pos_3
                        ) />
                    <cfset get_real_izin_3 = Cmp.get_Real_Izin(
                        position_code	: get_standbys.candidate_pos_3,
                        record_date		: now()
                        ) />
                    <cfif not get_real_izin_3.recordcount><cfset yedek_3_yaz = 1></cfif>
                </cfif>
            <cfelse>
                <cfset gercek_yaz = 1>
            </cfif>
     <cfelse>
         <cfset gercek_yaz = 1>
     </cfif>
     
    <cfif gercek_yaz eq 1>
        <cfset pos3 = x_manager_pos_code>
        <cfset name3 = get_emp_info(x_manager_pos_code,1,0)>
    <cfelseif yedek_1_yaz eq 1>
        <cfset pos3 = get_yedek_1.POSITION_CODE>
        <cfset name3 = get_yedek_1.EMPLOYEE_NAME & ' ' & get_yedek_1.EMPLOYEE_SURNAME>
    <cfelseif yedek_2_yaz eq 1>
        <cfset pos3 = get_yedek_2.POSITION_CODE>
        <cfset name3 = get_yedek_2.EMPLOYEE_NAME & ' ' & get_yedek_2.EMPLOYEE_SURNAME>
    <cfelseif yedek_3_yaz eq 1>
        <cfset pos3 = get_yedek_3.POSITION_CODE>
        <cfset name3 = get_yedek_3.EMPLOYEE_NAME & ' ' & get_yedek_3.EMPLOYEE_SURNAME>
    </cfif>	
<cfelse>
    <cfset pos3 = "">
    <cfset name3 = "">
</cfif>
<input type="hidden" name="admin1_pos_code" id="admin1_pos_code" value="<cfoutput>#pos1#</cfoutput>" />
<input type="hidden" name="admin2_pos_code" id="admin2_pos_code" value="<cfoutput>#pos2#</cfoutput>" />
<input type="hidden" name="admin3_pos_code" id="admin3_pos_code" value="<cfoutput>#pos3#</cfoutput>">
<input type="hidden" name="branch_id" id="branch_id" value="<cfoutput>#attributes.branch_id#</cfoutput>">
<input type="hidden" name="department" id="department" value="<cfoutput>#attributes.department#</cfoutput>">
<input type="hidden" name="comp_id" id="comp_id" value="<cfoutput>#attributes.comp_id#</cfoutput>" />
<cfquery name="get_cont_record" datasource="#dsn#">
    SELECT TOP 1 
        EEW.VALID,
        EEW.VALID_1,
        EEW.VALID_2,
        EEW.VALID_3,
        EEW.VALID_EMPLOYEE_ID_1,
        EEW.VALID_EMPLOYEE_ID_2,
        EEW.VALID_EMPLOYEE_ID_3,
        EEW.VALID_EMPLOYEE_ID,
        EEW.VALIDATOR_POSITION_CODE,
        EEW.VALIDATOR_POSITION_CODE_1,
        EEW.VALIDATOR_POSITION_CODE_2,
        EEW.VALIDATOR_POSITION_CODE_3,
        EIO.DEPARTMENT_ID
    FROM 
        EMPLOYEES_EXT_WORKTIMES EEW,
        EMPLOYEES_IN_OUT EIO
    WHERE 
        EIO.IN_OUT_ID = EEW.IN_OUT_ID AND
        MONTH(EEW.START_TIME) = <cfqueryparam cfsqltype="cf_sql_integer" value="#sal_mon_#"> AND 
        YEAR(EEW.START_TIME) = <cfqueryparam cfsqltype="cf_sql_integer" value="#sal_year_#"> AND
        EEW.SPECIAL_CODE = <cfqueryparam cfsqltype="cf_sql_varchar" value="#special_code_#">
</cfquery>
<cfset attributes.type = -1>
<cfif get_module_power_user(48) or (get_my_dep.recordcount eq 1 and not get_cont_record.recordcount) or (get_my_dep.recordcount eq 1 and get_cont_record.recordcount and not len(get_cont_record.VALID_1) and not len(get_cont_record.VALID_2) and not len(get_cont_record.VALID_3) and not len(get_cont_record.VALID))>
    <cfset attributes.type = 0>
</cfif>
<cfif get_cont_record.recordcount and listfind(pos_code_list,get_cont_record.VALIDATOR_POSITION_CODE_2) and len(get_cont_record.VALID_1) and not len(get_cont_record.VALID_2) and not len(get_cont_record.VALID_3) and not len(get_cont_record.VALID)>
    <cfset attributes.type = 2>
<cfelseif get_cont_record.recordcount and listfind(pos_code_list,get_cont_record.VALIDATOR_POSITION_CODE_3) and len(get_cont_record.VALID_1) and len(get_cont_record.VALID_2) and not len(get_cont_record.VALID_3) and not len(get_cont_record.VALID)>
    <cfset attributes.type = 3>
<cfelseif get_cont_record.recordcount and len(get_cont_record.VALID_1) and len(get_cont_record.VALID_2) and len(get_cont_record.VALID_3) and not len(get_cont_record.VALID) and get_module_power_user(48)>
    <cfset attributes.type = 4>
<cfelseif get_cont_record.recordcount and len(get_cont_record.VALID)>
	<cfset attributes.type = 5>
</cfif> 
<cfset attributes.deny_type = 0>
<cfif get_cont_record.recordcount and listfind(pos_code_list,get_cont_record.VALIDATOR_POSITION_CODE_1) and not len(get_cont_record.VALID_2) and not len(get_cont_record.VALID_3) and not len(get_cont_record.VALID)>
    <cfset attributes.deny_type = 1>
</cfif>                                             
<input type="hidden" name="type" id="type" value="<cfoutput>#attributes.type#</cfoutput>">
<cfif attributes.type eq 0 or get_cont_record.recordcount eq 0>
     <input type="hidden" name="is_add" id="is_add" value="1">
<cfelse>
     <input type="hidden" name="is_add" id="is_add" value="0">
</cfif>
<input type="hidden" name="is_del" id="is_del" value="0">
<cf_basket>
	<!-- sil -->
	 <table>
		<tr>
			<cfset cols = aydaki_gun_sayisi + 3>
			<td colspan="<cfoutput>#COLS#</cfoutput>">
				<table>
					<tr>
						<td colspan="3"><cf_get_lang dictionary_id='58472.Dönem'>: <cfoutput>#attributes.sal_year# #listgetat(ay_list(),attributes.sal_mon,',')#</cfoutput></td>
					</tr>
					<tr height="22">
						<td colspan="3" class="formbold"><cf_get_lang dictionary_id='55518.Onay Verecek Yöneticiler'></td>
					</tr>
					<tr>
						<td width="200" class="txtbold"><cf_get_lang dictionary_id='59946.Birinci Onaylayacak Amir'></td>
						<td width="120"><cfoutput>#get_emp_info(pos1,1,0)#</cfoutput></td>
						<td><cfif get_cont_record.recordcount and len(get_cont_record.valid_employee_id_1)><cf_get_lang dictionary_id='58699.Onaylandi'><cfelse><cf_get_lang dictionary_id='57615.Onay Bekliyor'></cfif></td>
					</tr>
					<tr>
						<td class="txtbold"><cf_get_lang dictionary_id='59947.İkinci Onaylayacak Amir'></td>
						<td width="120"><cfoutput>#get_emp_info(pos2,1,0)#</cfoutput></td>
						<td><cfif get_cont_record.recordcount and len(get_cont_record.valid_employee_id_2)><cf_get_lang dictionary_id='58699.Onaylandi'><cfelse><cf_get_lang dictionary_id='57615.Onay Bekliyor'></cfif></td>
					</tr>
					<tr>
						<td class="txtbold"><cf_get_lang dictionary_id='59948.Yönetici Amir'></td>
						<td><cfoutput>#name3#</cfoutput></td>
						<td><cfif get_cont_record.recordcount and len(get_cont_record.valid_employee_id_3)><cf_get_lang dictionary_id='58699.Onaylandi'><cfelse><cf_get_lang dictionary_id='57615.Onay Bekliyor'></cfif></td>
					</tr>
					<tr>
						<td class="txtbold"><cf_get_lang dictionary_id='57444.İnsan Kaynakları'></td>
						<td><cfif get_cont_record.recordcount and len(get_cont_record.valid_employee_id)><cfoutput>#get_emp_info(get_cont_record.valid_employee_id,0,0)#</cfoutput></cfif></td>
						<td><cfif get_cont_record.recordcount and len(get_cont_record.valid_employee_id)><cf_get_lang dictionary_id='58699.Onaylandi'><cfelse><cf_get_lang dictionary_id='57615.Onay Bekliyor'></cfif></td>
					</tr>
				 </table>
			</td>
		</tr>
	</table>
    <!-- sil -->
	 <cf_medium_list>
     <!-- sil -->
	 <table class="medium_list" cellpadding="0" cellspacing="1">
		<thead>
			<tr height="22">
				<th><cf_get_lang dictionary_id='57576.Çalisan'></th>
				<cfloop from="1" to="#aydaki_gun_sayisi#" index="ccc">
					<th><cfoutput>#ccc#</cfoutput></th>
				</cfloop>
				<th><cf_get_lang dictionary_id='40028.Gece Mesaisi'></th>
				<th><cf_get_lang dictionary_id='57492.Toplam'></th>
				<cfif attributes.type eq 4><th><cf_get_lang dictionary_id='59949.Reel Mesai'></th></cfif>
			</tr>
		  </thead>
		  <tbody>
			<cfset yatay_toplam_ = 0>
			<cfset dikey_toplam_ = 0>
			<cfset real_toplam_ = 0>
			<cfset gece_toplam_ = 0>
			<cfoutput query="get_department_positions">
				<cfset emp_id_list = listappend(emp_id_list,EMPLOYEE_ID)>
				<cfset in_out_id_ = in_out_id>
				<cfquery name="get_old_records" datasource="#dsn#">
					SELECT 
					<cfif x_select_mesai eq 0>
						datediff(minute,START_TIME,END_TIME) AS TOTAL,
					<cfelseif x_select_mesai eq 1>
						datediff(hour,START_TIME,END_TIME) AS TOTAL,
					</cfif>
						DAY(START_TIME) AS GUN
					FROM 
						EMPLOYEES_EXT_WORKTIMES 
					WHERE 
						DAY_TYPE <> 3 AND
						IN_OUT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#in_out_id_#"> AND 
						MONTH(START_TIME) = <cfqueryparam cfsqltype="cf_sql_integer" value="#sal_mon_#"> AND 
						YEAR(START_TIME) = <cfqueryparam cfsqltype="cf_sql_integer" value="#sal_year_#"> AND
						SPECIAL_CODE = <cfqueryparam cfsqltype="cf_sql_varchar" value="#special_code_#">
					  GROUP BY
						DAY(START_TIME),
						<cfif x_select_mesai eq 0>
						datediff(minute,START_TIME,END_TIME)
						 <cfelseif x_select_mesai eq 1>
						 datediff(hour,START_TIME,END_TIME)
						 </cfif>
				</cfquery>
				<cfquery name="get_real_records" datasource="#dsn#">
					SELECT 
					<cfif x_select_mesai eq 0>
						datediff(minute,START_TIME,END_TIME) AS TOTAL,
					<cfelseif x_select_mesai eq 1>
						datediff(hour,START_TIME,END_TIME) AS TOTAL,
					</cfif>
						DAY(START_TIME) AS GUN 
					FROM 

						EMPLOYEES_EXT_WORKTIMES 
					WHERE 
						IN_OUT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#in_out_id_#"> AND 
						MONTH(START_TIME) = <cfqueryparam cfsqltype="cf_sql_integer" value="#sal_mon_#"> AND 
						YEAR(START_TIME) = <cfqueryparam cfsqltype="cf_sql_integer" value="#sal_year_#"> AND
						SPECIAL_CODE IS NULL
				</cfquery>
				<cfquery name="get_gece_records" datasource="#dsn#">
					SELECT 
					<cfif x_select_mesai eq 0>
						SUM(datediff(minute,START_TIME,END_TIME)) AS TOTAL
					<cfelseif x_select_mesai eq 1>
						SUM(datediff(hour,START_TIME,END_TIME)) AS TOTAL
					</cfif>
					FROM 
						EMPLOYEES_EXT_WORKTIMES 
					WHERE 
						DAY_TYPE = 3 AND
						IN_OUT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#in_out_id_#"> AND 
						MONTH(START_TIME) = <cfqueryparam cfsqltype="cf_sql_integer" value="#sal_mon_#"> AND 
						YEAR(START_TIME) = <cfqueryparam cfsqltype="cf_sql_integer" value="#sal_year_#"> AND
						SPECIAL_CODE = <cfqueryparam cfsqltype="cf_sql_varchar" value="#special_code_#">
				</cfquery>
				<cfloop query="get_old_records">
					<cfset 'deger_#in_out_id_#_#GUN#' = TOTAL>
				</cfloop>
				<cfif get_real_records.recordcount and len(get_real_records.total)>
					<cfset real_ = get_real_records.TOTAL>
				<cfelse>
					<cfset real_ = 0>
				</cfif>
				<cfset real_toplam_ = real_toplam_ + real_>
				<cfif get_gece_records.recordcount and len(get_gece_records.TOTAL)>
					<cfset gece_deger_ = get_gece_records.TOTAL>
				<cfelse>
					<cfset gece_deger_ = 0>
				</cfif>
				<cfset gece_toplam_ = gece_toplam_ + gece_deger_>
				<input type="hidden" name="emp_id_out_list" id="emp_id_out_list" value="#in_out_id_#" />
				<tr>
					<td>#employee_name# #employee_surname#</td>
					<cfset satir_toplam_ = 0>
					<cfloop from="1" to="#aydaki_gun_sayisi#" index="ccc">
						<cfset to_day_ = dateformat(createdate(attributes.sal_year,attributes.sal_mon,ccc),'ddmmyyyy')>     
                        <cfset to_day2 = dateformat(createdate(attributes.sal_year,attributes.sal_mon,ccc))>                                       
						<cfif isdefined('deger_#in_out_id_#_#ccc#')>
							<cfset deger_ = evaluate('deger_#in_out_id_#_#ccc#')>
						<cfelse>
							<cfset deger_ = 0>
						</cfif>
						<cfif not isdefined('toplamlar_#ccc#')>
							<cfset 'toplamlar_#ccc#' = deger_>
						<cfelse>
							<cfset 'toplamlar_#ccc#' = evaluate('toplamlar_#ccc#') + deger_>
						</cfif>
						<cfif x_select_mesai eq 0>
							<cfset range_ = "0,1440">
							<cfset msg = "1440 dakikaya kadar deger girebilirsiniz!">
						<cfelseif x_select_mesai eq 1>
							 <cfset range_ = "0,24">
							 <cfset msg = "24 saate kadar deger girebilirsiniz!">
						</cfif>
						<td width="30" <cfif listlen(offdays_day_list) and listfindnocase(offdays_day_list,to_day_)>style="background-color:##66CCCC;"<cfelseif (dayofweek(to_day2) eq 1) or (get_saturday_off.saturday_off eq 1 and dayofweek(to_day2) eq 7)>style="background-color:##FF9B94;"</cfif>>
						<cfif attributes.type eq 0 or get_cont_record.recordcount eq 0>
							<input type="hidden" id="mesai_day_type_#in_out_id_#_#ccc#" name="mesai_day_type_#in_out_id_#_#ccc#" value="<cfif listlen(offdays_day_list) and listfindnocase(offdays_day_list,to_day_)>2<cfelseif listfindnocase('1,7',dayofweek(to_day2))>1<cfelse>0</cfif>" />
							<cfinput type="text" name="mesai_saat_#in_out_id_#_#ccc#" id="mesai_saat_#in_out_id_#_#ccc#" onFocus="get_first_value(this.value,#currentrow#,#ccc#)" value="#deger_#" onBlur="get_value(this.value,#currentrow#,#ccc#)" onkeyup="isNumber(this)" maxlength="3" message="#msg#" range="#range_#" validate="integer" style="width:30px;"/>
						<cfelse>
							<cfinput type="hidden" name="mesai_saat_#in_out_id_#_#ccc#" value="#deger_#"/>
							#deger_#
						</cfif>
						</td>
						<cfset satir_toplam_ = satir_toplam_ + deger_>
					</cfloop>
					<cfset satir_toplam_ = satir_toplam_ + gece_deger_>
					<td>
					<cfif attributes.type eq 0 or get_cont_record.recordcount eq 0>
						<cfinput type="text" name="gece_mesai_saat_#in_out_id#"  onBlur="get_value(this.value,#currentrow#)" onFocus="get_first_value(this.value,#currentrow#)" value="#gece_deger_#" onkeyup="isNumber(this)" maxlength="3" validate="integer" style="width:30px;"/>
					<cfelse>
						<cfinput type="hidden" name="gece_mesai_saat_#in_out_id#" value="#gece_deger_#" onkeyup="isNumber(this)" maxlength="3" validate="integer" style="width:30px;"/>
						#gece_deger_#
					</cfif>
					</td>
					<td><div id="satir_toplam_#currentrow#"><cfif get_cont_record.recordcount eq 0>0<cfelse>#satir_toplam_#</cfif></div></td>
					<cfif attributes.type eq 4><td>#real_#</td></cfif>
				</tr>
				<cfset dikey_toplam_ = dikey_toplam_ + satir_toplam_>
			 </cfoutput>
          </tbody>
          <tfoot>
			 <cfoutput>
				<tr>
					<td style="height:22px; text-align:left; padding:2px;" class="txtbold"><cf_get_lang dictionary_id='57492.Toplam'></td>
					<cfloop from="1" to="#aydaki_gun_sayisi#" index="ccc">
						<cfif isdefined('toplamlar_#ccc#')>
							<cfset deger_ = evaluate('toplamlar_#ccc#')>
						<cfelse>
							<cfset deger_ = 0>
						</cfif>
						<td width="30" style=" text-align:left; padding:2px;"><div id="gun_#ccc#"><cfif get_cont_record.recordcount eq 0>0<cfelse>#deger_#</cfif></div></td>
					</cfloop>
					<td style="text-align:left; padding:2px;"><div id="gece_mesai_"><cfif get_cont_record.recordcount eq 0>0<cfelse>#gece_toplam_#</cfif></div></td>
					<td style="text-align:left; padding:2px;"><div id="dikey_toplam_"><cfif get_cont_record.recordcount eq 0>0<cfelse>#dikey_toplam_#</cfif></div></td>
					<cfif attributes.type eq 4><td style="text-align:left;  padding:2px;">#real_toplam_#</td></cfif>
				 </tr>
			  </cfoutput>
           </tfoot>
           <!-- sil -->
         </cf_medium_list>
         <cf_basket_footer height="25">
                 <input type="hidden" name="emp_id_list" id="emp_id_list" value="<cfoutput>#emp_id_list#</cfoutput>">
				<cfif get_department_positions.recordcount>
					 <cfif attributes.type eq -1>
						<cf_get_lang dictionary_id='59945.Bu Departman Için Bu Asamada Yetkili Degilsiniz'>!
					<cfelse>
						<cfif attributes.type eq 0>
							<cfset value_ = "Kaydet">
						<cfelseif attributes.type eq 1>
							<cfset value_ = "1.Amir Onay">
						<cfelseif attributes.type eq 2>
							<cfset value_ = "2.Amir Onay">
						<cfelseif attributes.type eq 3>
							<cfset value_ = "Yönetici Onay">
						<cfelseif attributes.type eq 4>
							<cfset value_ = "IK Onay">
						</cfif>
                        <cfif attributes.type neq 5>
                            <cf_workcube_buttons insert_info="#value_#" type_format='1'>
                        </cfif>
                        <cfquery name="get_unvalids" datasource="#dsn#">
                        	SELECT	*
                        	FROM 
								EMPLOYEES_EXT_WORKTIMES 
							WHERE 
								VALID_1 IS NULL AND
								IN_OUT_ID IN (<cfqueryparam cfsqltype="cf_sql_integer" list="true" value="#valueList(get_department_positions.in_out_id)#">) AND 
								MONTH(START_TIME) = <cfqueryparam cfsqltype="cf_sql_integer" value="#sal_mon_#"> AND 
								YEAR(START_TIME) = <cfqueryparam cfsqltype="cf_sql_integer" value="#sal_year_#">
                        </cfquery>
						<cfif attributes.type eq 0 and attributes.deny_type neq 0 and get_unvalids.recordcount>
							<cfset value_ = "1.Amir Onay">
                            <cf_workcube_buttons insert_info="#value_#" type_format='1' is_cancel="0" add_function="send_deny()">
                        </cfif>
						<cfif get_module_power_user(48) and attributes.type neq 0><cf_workcube_buttons insert_info="Red" type_format='1' is_cancel="0" add_function="send_delete()"></cfif>
					</cfif>
				</cfif>
         </cf_basket_footer>
     </cf_basket>
 </cfform>
</cfif>
<script type="text/javascript">
	function get_first_value(deger_,row,col)
	{
		if(deger_ == '')
			deger_ = 0;
		my_temp_deger = deger_;
	}
	function get_value(deger,row_,col_)
	{
		if(deger == '')
			deger = 0;
		//satır toplam için
		if(arguments[2]!=null)
		{
			ilk_deger = parseInt(document.getElementById('satir_toplam_'+row_).innerHTML);
			var toplam = parseInt(deger) + parseInt(ilk_deger);
			toplam = parseInt(toplam) - parseInt(my_temp_deger);
			document.getElementById('satir_toplam_'+row_).innerHTML = toplam;
		}
		//genel toplam
		if(arguments[2]!=null)
		{
			var genel_toplam = parseInt(document.getElementById('dikey_toplam_').innerHTML);
			genel_toplam = parseInt(deger) + genel_toplam ;
			genel_toplam = parseInt(genel_toplam) - parseInt(my_temp_deger);
			document.getElementById('dikey_toplam_').innerHTML = genel_toplam;
		}
		//dikey toplam
		if(arguments[2]!=null)
		{
			ilk_dikey_deger = parseInt(document.getElementById('gun_'+col_).innerHTML);
			var toplam = parseInt(deger) + parseInt(ilk_dikey_deger);
			toplam = parseInt(toplam) - parseInt(my_temp_deger);
			document.getElementById('gun_'+col_).innerHTML = toplam;
		}
		//gece mesai toplam
		if(arguments[2]==null)
		{
			var gece_mesai = parseInt(document.getElementById('gece_mesai_').innerHTML);
			gece_mesai = parseInt(deger) + gece_mesai;
			gece_mesai = parseInt(gece_mesai) - parseInt(my_temp_deger);
			document.getElementById('gece_mesai_').innerHTML = gece_mesai;
		}
	}
	function send_delete()
	{
		document.add_extra_worktimes.is_del.value = '1';
	}
	function send_deny()
	{
		document.add_extra_worktimes.is_add.value = '0';
		document.add_extra_worktimes.type.value = '1';
	}
	function kontrol_extra_time()
	{
		if(document.getElementById('branch_id').value == '')
		{
			alert('<cf_get_lang dictionary_id="58579.Lütfen Şube Seçiniz">');
			return false;
		}	
		if(document.getElementById('department').value == '')
		{
			alert('<cf_get_lang dictionary_id="58836.Lütfen Departman Seçiniz">');
			return false;
			}
		return true;
	}
	function showDepartment(branch_id)	
	{
		if (arguments[0]==null)
			{
			var branch_id_ = document.getElementById('branch_id').value;
			}
		else
			{
			var branch_id_ = branch_id;
			}
		if (branch_id_ != "")
		{
			var send_address = "<cfoutput>#request.self#</cfoutput>?fuseaction=myhome.popup_ajax_list_hr&self_department_control=1&x_manager_pos_code=<cfoutput>#x_manager_pos_code#</cfoutput>&branch_id="+branch_id_;
			AjaxPageLoad(send_address,'DEPARTMENT_PLACE',1,'Iliskili Departmanlar');
		}
	}
</script>