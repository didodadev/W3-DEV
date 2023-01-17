<cf_xml_page_edit fuseact="myhome.list_extra_worktimes">
<cfparam name="attributes.sal_year" default="#session.ep.period_year#">
<cfparam name="attributes.sal_mon" default="#Month(now())#">
<cfparam name="attributes.page" default=1>
<cfparam name="attributes.maxrows" default='#session.ep.maxrows#'>
<cfparam name="attributes.is_excel" default="">
<cfset attributes.startrow=((attributes.page-1)*attributes.maxrows)+1>
<cfset branch_list = "">
<cfquery name="GET_BRANCHES" datasource="#DSN#">
    SELECT
        BRANCH_NAME,
        BRANCH_ID
    FROM
        BRANCH
    <cfif not session.ep.ehesap>
        WHERE BRANCH_ID IN (SELECT BRANCH_ID FROM EMPLOYEE_POSITION_BRANCHES WHERE EMPLOYEE_POSITION_BRANCHES.POSITION_CODE = #session.ep.position_code#)
    </cfif>
    ORDER BY
        BRANCH_NAME
</cfquery>
<cfform name="employee" method="post" action="">
<cfsavecontent variable="title"><cf_get_lang dictionary_id='40022.Toplu Fazla Mesai'></cfsavecontent>
<cf_report_list_search title="#title#">
<cf_report_list_search_area>
    <div class="row">
        <div class="col col-12 col-xs-12">
            <div class="row formContent">               
                    <input name="is_form_submitted" id="is_form_submitted" type="hidden" value="1">
                <div class="row" type="row">
                    <div class="col col-3 col-md-6 col-xs-12">
                        <div class="form-group">
                        <label class="col col-12"> <cf_get_lang dictionary_id='57453.Şube'>*</label>
                            <div class="col col-12">                      
                                <select name="branch_id" id="branch_id">
                                    <option value="" selected><cf_get_lang dictionary_id="57734.Seçiniz"></option>
                                    <cfoutput query="GET_BRANCHES">
                                    <option value="#branch_id#" <cfif isDefined('attributes.branch_id') and attributes.branch_id eq branch_id> selected</cfif>>#BRANCH_NAME#</option>
                                       <!--- <option value="#branch_id#"<cfif (isdefined("attributes.branch_id") and branch_id eq attributes.branch_id) or (not isdefined("attributes.branch_id") and currentrow eq 1)>selected</cfif>>#BRANCH_NAME#</option>--->
                                    </cfoutput>
                                </select>
                            </div>
                        </div>   
                            <div class="form-group">
                                <label class="col col-12"> <cf_get_lang dictionary_id='58724.Ay'>*</label>
                                <div class="col col-12">
                                    <select name="sal_mon" id="sal_mon">
                                    <option value="" selected><cf_get_lang dictionary_id="57734.Seçiniz"></option>
                                        <cfloop from="1" to="12" index="i">
                                            <cfoutput>
                                                <option value="#i#" <cfif isDefined('attributes.branch_id') and attributes.sal_mon eq i>selected</cfif>>#listgetat(ay_list(),i,',')#</option>
                                            </cfoutput>
                                        </cfloop>
                                    </select>
                                </div>
                            </div>
                    </div>        
                </div>
            </div>
            <div class="row ReportContentBorder">
				<div class="ReportContentFooter">
                    <label><cf_get_lang dictionary_id='57858.Excel Getir'><input type="checkbox" name="is_excel" id="is_excel" value="1" <cfif attributes.is_excel eq 1>checked</cfif>></label>
                    <cfsavecontent variable="message"><cf_get_lang dictionary_id='57537.Sayi_Hatasi_Mesaj'></cfsavecontent>
                    <cfinput type="text" name="maxrows" value="#attributes.maxrows#" required="yes" validate="integer" range="1,999" message="#message#" onKeyUp="isNumber(this)" maxlength="3" style="width:25px;">                    
                    <cf_wrk_report_search_button search_function="kontrol_extra_time()" button_type="1">
                </div>
            </div>
         </div>   
    </div>
</cf_report_list_search_area>
</cf_report_list_search>
</cfform> 
	<cfif isdefined('attributes.is_excel') and attributes.is_excel eq 1>
        <cfset filename = "#createuuid()#">
        <cfheader name="Expires" value="#Now()#">
        <cfcontent type="application/vnd.msexcel;charset=utf-8">
        <cfheader name="Content-Disposition" value="attachment; filename=#filename#.xls">
        <meta http-equiv="Content-Type" content="text/html; charset=utf-8">
    </cfif>
<cfif isdefined("attributes.is_form_submitted")>
	<cfset startdate = CreateDateTime(session.ep.period_year,attributes.sal_mon,01,00,00,00)>
    <cfset finishdate = dateadd("m",1,startdate)>
	<cfif get_module_user(3) eq 0><!--- İk yetkisi yoksa yetkili olduğu departmanları getirecek , isbak için include olarak kullanılıyor o yüzden eklendi sm20140414 --->
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
				<cfqueryparam cfsqltype="cf_sql_timestamp" value="#Now()#"> BETWEEN O.STARTDATE AND O.FINISHDATE
		</cfquery>
		<cfif Get_Offtime_Valid.recordcount>
			<cfset Now_Offtime_PosCode = ValueList(Get_Offtime_Valid.Position_Code)>
			<cfquery name="Get_StandBy_Position1" datasource="#dsn#"><!--- Asil Kisi Izinli ise ve 1.Yedek Izinli Degilse --->
				SELECT POSITION_CODE, CANDIDATE_POS_1 FROM EMPLOYEE_POSITIONS_STANDBY WHERE POSITION_CODE IN (#Now_Offtime_PosCode#) AND CANDIDATE_POS_1 IN(#pos_code_list#)
			</cfquery>
			<cfoutput query="Get_StandBy_Position1">
				<cfset pos_code_list = ListAppend(pos_code_list,ValueList(Get_StandBy_Position1.Position_Code))>
			</cfoutput>
			<cfquery name="Get_StandBy_Position2" datasource="#dsn#"><!--- Asil Kisi, 1.Yedek Izinli ise ve 2.Yedek Izinli Degilse --->
				SELECT POSITION_CODE, CANDIDATE_POS_1, CANDIDATE_POS_2 FROM EMPLOYEE_POSITIONS_STANDBY WHERE POSITION_CODE IN (#Now_Offtime_PosCode#) AND CANDIDATE_POS_2 IN(#pos_code_list#)
			</cfquery>
			<cfif Get_StandBy_Position2.RecordCount>
				<cfquery name="Get_StandBy_Position_Other_Offtime" datasource="#dsn#">
					SELECT POSITION_CODE, CANDIDATE_POS_1, CANDIDATE_POS_2 FROM EMPLOYEE_POSITIONS_STANDBY WHERE CANDIDATE_POS_1 IN (#Now_Offtime_PosCode#) AND CANDIDATE_POS_2 IN(#pos_code_list#)
				</cfquery>
				<cfoutput query="Get_StandBy_Position_Other_Offtime">
					<cfset pos_code_list = ListAppend(pos_code_list,ValueList(Get_StandBy_Position_Other_Offtime.Position_Code))>
				</cfoutput>
			</cfif>
			<cfquery name="Get_StandBy_Position3" datasource="#dsn#"><!--- Asil Kisi, 1.Yedek,2.Yedek Izinli ise ve 3.Yedek Izinli Degilse --->
				SELECT POSITION_CODE, CANDIDATE_POS_1, CANDIDATE_POS_2 FROM EMPLOYEE_POSITIONS_STANDBY WHERE POSITION_CODE IN (#Now_Offtime_PosCode#) AND CANDIDATE_POS_3 IN(#pos_code_list#)
			</cfquery>
			<cfif Get_StandBy_Position3.RecordCount>
				<cfquery name="Get_StandBy_Position_Other_Offtime" datasource="#dsn#">
					SELECT POSITION_CODE, CANDIDATE_POS_1, CANDIDATE_POS_2 FROM EMPLOYEE_POSITIONS_STANDBY WHERE CANDIDATE_POS_1 IN (#Now_Offtime_PosCode#) AND CANDIDATE_POS_2 IN (#Now_Offtime_PosCode#) AND CANDIDATE_POS_3 IN(#pos_code_list#)
				</cfquery>
				<cfoutput query="Get_StandBy_Position_Other_Offtime">
					<cfset pos_code_list = ListAppend(pos_code_list,ValueList(Get_StandBy_Position_Other_Offtime.Position_Code))>
				</cfoutput>
			</cfif>
		</cfif>
		<cfset dept_id_list = 0>
		<cfquery name="get_department" datasource="#dsn#">
			SELECT
				DEPARTMENT_ID,
				BRANCH_ID,
				DEPARTMENT_HEAD
			FROM
				DEPARTMENT
			WHERE
				BRANCH_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.branch_id#"> AND
				DEPARTMENT_STATUS = 1
				AND 
				(
					DEPARTMENT_ID = (SELECT DEPARTMENT_ID FROM EMPLOYEE_POSITIONS WHERE POSITION_CODE = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.position_code#">)
					OR
					ADMIN1_POSITION_CODE IN(#pos_code_list#)
					OR
					ADMIN2_POSITION_CODE IN(#pos_code_list#)
				)
			ORDER BY 
				DEPARTMENT_HEAD
		</cfquery>
		<cfif get_department.recordcount>
			<cfset dept_id_list = valuelist(get_department.department_id)>
		</cfif>
	</cfif>
    <cfquery name="get_dep" datasource="#dsn#">  
        SELECT 
            DEPARTMENT_HEAD,
            MAX(DEPARTMENT_ID) AS  DEPARTMENT_ID,
            MAX(COMPANY_ID) AS COMPANY_ID,
            SUM(TOPLAM_MESAI)AS TOPLAM_MESAI,
            SUM(GECE_MESAISI) AS GECE_MESAISI,
            MAX(VALIDDATE) AS  VALIDDATE,
            MAX(VALIDDATE_1) AS VALIDDATE_1,
            MAX(VALIDDATE_2) AS VALIDDATE_2,
            MAX(VALIDDATE_3) AS VALIDDATE_3,
            MAX(VALID) AS  VALID,
            MAX(VALID_1) AS VALID_1,
            MAX(VALID_2) AS VALID_2,
            MAX(VALID_3) AS VALID_3,
            MAX(SPECIAL_CODE) AS SPECIAL_CODE
        FROM 
        (
            SELECT
                EEW.SPECIAL_CODE,
                EEW.DAY_TYPE AS GUN_TIPI,
                convert(integer,EEW.VALID) as VALID,
                convert(integer,EEW.VALID_1) AS VALID_1,
                convert(integer,EEW.VALID_2) AS VALID_2,
                convert(integer,EEW.VALID_3) AS VALID_3,
                EEW.VALIDDATE,
                EEW.VALIDDATE_1,
                EEW.VALIDDATE_2,
                EEW.VALIDDATE_3,
                EI.DEPARTMENT_ID AS DEPARTMENT_ID,
                EI.BRANCH_ID,
                EEW.START_TIME,
                B.COMPANY_ID,
                EEW.END_TIME,
                CASE  WHEN EEW.DAY_TYPE = 3 THEN datediff(hour,START_TIME,END_TIME)END AS GECE_MESAISI,
                datediff(hour,START_TIME,END_TIME) AS TOPLAM_MESAI,
                D.DEPARTMENT_HEAD
             FROM 
                EMPLOYEES_EXT_WORKTIMES EEW,
                DEPARTMENT D,
                EMPLOYEES_IN_OUT EI,
                BRANCH B
            WHERE 
                EEW.IN_OUT_ID =  EI.IN_OUT_ID AND
                EI.BRANCH_ID = D.BRANCH_ID AND
                EI.BRANCH_ID = B.BRANCH_ID AND
                EI.BRANCH_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.branch_id#"> AND
                EI.DEPARTMENT_ID = D.DEPARTMENT_ID AND
                EEW.START_TIME >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#startdate#"> AND 
                EEW.END_TIME < <cfqueryparam cfsqltype="cf_sql_timestamp" value="#finishdate#"> AND
                EEW.SPECIAL_CODE IS NOT NULL
				<cfif isdefined("dept_id_list")>
					AND D.DEPARTMENT_ID IN(#dept_id_list#)
				</cfif>
        ) AS TABLO_1
        GROUP BY DEPARTMENT_HEAD
    </cfquery>
    <cfparam name="attributes.totalrecords" default="#get_dep.recordcount#">
    <cf_report_list>
        <!-- sil -->
        
            <thead>
                <tr>
                    <th><cf_get_lang dictionary_id="57572.Departman"></th>
                    <th><cf_get_lang dictionary_id='54126.Mesailer'> <cf_get_lang dictionary_id='58659.Toplamı'></th>
                    <th><cf_get_lang dictionary_id="40028.Gece Mesaisi"></th>
                    <th><cf_get_lang dictionary_id="57680.Genel Toplam"></th>
                    <th><cf_get_lang dictionary_id="35927.birinci Amir"></th>
                    <th><cf_get_lang dictionary_id="35921.ikinci Amir"></th>
                    <th><cf_get_lang dictionary_id="29511.Yönetici"></th>
                    <th><cf_get_lang dictionary_id="57444.İnsan Kaynakları"></th>
                </tr>
            </thead>
            <tbody>
                <cfif get_dep.recordcount>
                <cfoutput query="get_dep" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">
                            <tr>
                                <td><a class="tableyazi" href="#request.self#?fuseaction=myhome.list_extra_worktimes&is_form_submitted=1&branch_id=#attributes.branch_id#&department=#department_id#&sal_mon=#attributes.sal_mon#&comp_id=#company_id#">#department_head#</a></td>
                                <td>
                                    <cfif len(GECE_MESAISI)>
                                        #TOPLAM_MESAI-GECE_MESAISI#
                                    <cfelse>
                                        #TOPLAM_MESAI#
                                    </cfif>
                                </td>
                                <td>#GECE_MESAISI#</td>
                                <td>#TOPLAM_MESAI#</td>
                                <td>#dateformat(VALIDDATE_1,'dd.mm.yyyy')#</td>
                                <td>#dateformat(VALIDDATE_2,'dd.mm.yyyy')#</td>
                           
                        <cfform name="upd_rec" action="#request.self#?fuseaction=report.emptypopup_upd_extra_worktimes">
                            <cfinput type="hidden" name="sal_mon" value="#attributes.sal_mon#">
                            <cfinput type="hidden" name="branch_id" value="#attributes.branch_id#">
                            <cfinput type="hidden" name="special_code_" value="#special_code#">
                        <td>
                            <cfif len(VALIDDATE_3)>
                                #dateformat(VALIDDATE_3,'dd.mm.yyyy')#
                            <cfelseif len(x_manager_pos_code) and x_manager_pos_code eq session.ep.position_code and len(VALID_1) and len(VALID_2) and not len(VALID_3) and not len(VALID)>
                                <cfinput type="hidden" name="type1" value="1">
                                <!-- sil --><cf_workcube_buttons insert_info="Yönetici Onay" type_format='1' is_cancel = "0"><!-- sil -->
                            </cfif>
                        </td>
                        <td>
                            <cfif len(VALIDDATE)>
                                #dateformat(VALIDDATE,'dd.mm.yyyy')#
                            <cfelseif session.ep.ehesap and len(VALID_1) and len(VALID_2) and len(VALID_3) and not len(VALID)>
                                <cfinput type="hidden" name="type2" value="1">
                                <!-- sil --><cf_workcube_buttons insert_info="IK Onay" type_format='1' is_cancel = "0"><!-- sil -->
                            </cfif>
                        </td>
                        </cfform>
                 </tr>
                </cfoutput>
                <cfelse>
                    <tr>
                       <td colspan="14"><cf_get_lang dictionary_id="57484.Kayıt Yok">!</td>
                    </tr>
                </cfif>
            </tbody>
        
    </cf_report_list>
</cfif>

<cfif isdefined("attributes.is_form_submitted")>
	<cfset url_str = "">
    <cfif len(attributes.sal_mon)>
        <cfset url_str = "#url_str#&sal_mon=#attributes.sal_mon#">
    </cfif>
    <cfif len(attributes.branch_id)>
    	<cfset url_str = "#url_str#&branch_id=#attributes.branch_id#">
    </cfif>
    <cfif len(attributes.is_form_submitted)>
        <cfset url_str = "#url_str#&is_form_submitted=#attributes.is_form_submitted#">
    </cfif>
    <cf_paging 
        page="#attributes.page#" 
        maxrows="#attributes.maxrows#" 
        totalrecords="#attributes.totalrecords#" 
        startrow="#attributes.startrow#" 
        adres="report.extra_worktimes#url_str#">
</cfif>

<script type="text/javascript">
	function kontrol_extra_time()
	{   
		if(document.getElementById('branch_id').value == '')
		{
			alert('<cf_get_lang dictionary_id="58194.Zorunlu Alan"> : <cf_get_lang dictionary_id="57453.Şube">');
			return false;
		}
        if(document.getElementById('sal_mon').value == '')
		{
			alert('<cf_get_lang dictionary_id="48201.Ay Girmelisiniz">');
			return false;
		}	
        if(document.employee.is_excel.checked==false)
        {
            document.employee.action="<cfoutput>#request.self#</cfoutput>?fuseaction=report.extra_worktimes"
            return true;
        }
        else
            document.employee.action="<cfoutput>#request.self#?fuseaction=report.emptypopup_extra_worktimes</cfoutput>"
	}
</script>
