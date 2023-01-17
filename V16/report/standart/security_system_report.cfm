<cfparam name="attributes.module_id_control" default="7">
<cfinclude template="report_authority_control.cfm">
<cfparam name="attributes.position_cat_id" default="">
<cfparam name="attributes.employee_id" default="">
<cfparam name="attributes.employee" default="">
<cfparam name="attributes.keyword" default="">
<cfparam name="attributes.maxrows" default='#session.ep.maxrows#'>
<cfparam name="attributes.is_excel" default="">
<cfquery name="get_setup_position_cat" datasource="#DSN#">
	SELECT POSITION_CAT_ID,POSITION_CAT FROM SETUP_POSITION_CAT WHERE POSITION_CAT_STATUS = 1 ORDER BY POSITION_CAT
</cfquery>
<cfquery name="get_comp" datasource="#dsn#">
	SELECT COMP_ID,COMPANY_NAME FROM OUR_COMPANY
</cfquery>
<cfquery name="get_modules" datasource="#dsn#">
	SELECT MODULE_ID,MODULE_NAME FROM MODULES ORDER BY MODULE_NAME
</cfquery>
<cfif isdefined("attributes.form_submitted")>
	<cfquery name="get_authority_report" datasource="#dsn#">
		SELECT 
			EP.EMPLOYEE_ID,
			EP.POSITION_CODE,
			EP.EMPLOYEE_NAME,
			EP.EMPLOYEE_SURNAME,
			EP.USER_GROUP_ID,
			EP.LEVEL_ID,
			EP.POSITION_ID,
			OC.COMPANY_NAME,
			SPC.POSITION_CAT,
			SPC.POSITION_CAT_ID,
			EP.POSITION_NAME
		FROM 
			EMPLOYEE_POSITIONS EP, 
			OUR_COMPANY OC, 
			SETUP_POSITION_CAT SPC,
			BRANCH B,
			DEPARTMENT D
		WHERE
			EP.POSITION_STATUS = 1 AND
			EP.EMPLOYEE_ID IS NOT NULL AND
			EP.DEPARTMENT_ID = D.DEPARTMENT_ID AND
			D.BRANCH_ID = B.BRANCH_ID AND 
			B.COMPANY_ID = OC.COMP_ID AND
			EP.POSITION_CAT_ID = SPC.POSITION_CAT_ID
			<cfif len(attributes.employee_id) and len(attributes.employee)>
				AND EP.EMPLOYEE_ID = #attributes.employee_id#
			</cfif>
			<!--- <cfif isdefined('attributes.keyword') and len(attributes.keyword)>
				AND EP.EMPLOYEE_NAME + ' ' + EP.EMPLOYEE_SURNAME LIKE '%#attributes.keyword#%'
			</cfif> --->
			<cfif isdefined('attributes.position') and len(attributes.position)>
				AND SPC.POSITION_CAT_ID = #attributes.position#
			</cfif>
			<cfif isdefined('attributes.comp_id') and len(attributes.comp_id)>
				AND OC.COMP_ID = #attributes.comp_id#
			</cfif>
		ORDER BY
			EP.EMPLOYEE_NAME,
			EP.EMPLOYEE_SURNAME	
	</cfquery>
<cfelse>
	<cfset get_authority_report.recordcount = 0>
</cfif>
<cfparam name="attributes.page" default="1">
<cfparam name="attributes.totalrecords" default="#get_authority_report.recordcount#">
<cfset attributes.startrow=((attributes.page-1)*attributes.maxrows)+1>
<cfform name="form_securit_system_report" method="post" action="#request.self#?fuseaction=report.security_report">
<input type="hidden" name="form_submitted" id="form_submitted" value="1">
<cf_report_list_search title="#getLang('main',632)#">
    <cf_report_list_search_area>
        <div class="row">
            <div class="col col-12 col-xs-12">
                <div class="row formContent">
                    <div class="row" type="row">
                         <input type="hidden" name="form_submitted" id="form_submitted" value="1" />
                           <div class="col col-4 col-md-4 col-sm-6 col-xs-12" index="1" type="column" sort="true">
                                <div class="form-group">
                                    <label class="col col-12 col-xs-12"> <cf_get_lang_main no ='518.Kullanıcı'></label>
                                    <div class="col col-12 col-xs-12">
                                        <div class="input-group">                         
                                            <input type="hidden" name="employee_id" id="employee_id" value="<cfif isdefined('attributes.employee_id') and len(attributes.employee)><cfoutput>#attributes.employee_id#</cfoutput></cfif>">
                                            <input type="text" name="employee" id="employee" value="<cfif isdefined('attributes.employee') and len(attributes.employee)><cfoutput>#attributes.employee#</cfoutput></cfif>"  onfocus="AutoComplete_Create('employee','MEMBER_NAME','MEMBER_NAME','get_member_autocomplete','3','EMPLOYEE_ID','employee_id','','3','135');" autocomplete="off">
                                            <span class="input-group-addon btnPointer icon-ellipsis" onclick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_positions&field_emp_id=form_securit_system_report.employee_id&field_name=form_securit_system_report.employee&select_list=1','list');"></span>
                                        </div>    
                                    </div>
                                </div>    
                            </div>
                                <div class="col col-4 col-md-4 col-sm-6 col-xs-12" index="2" type="column" sort="true">
                                    <div class="form-group">
                                        <label class="col col-12 col-xs-12"> <cf_get_lang_main no='1592.Pozisyon Tipi'></label>
                                        <div class="col col-12 col-xs-12">
                                            <select name="position" id="position" style="width:200px;">
                                                    <option value=""><cf_get_lang_main no='322.Seçiniz'></option>
                                                <cfoutput query="get_setup_position_cat">
                                                    <option value="#position_cat_id#"<cfif isdefined("attributes.position") and attributes.position eq position_cat_id>selected</cfif>>#position_cat#</option>
                                                </cfoutput>
                                            </select>
                                        </div>
                                    </div>
                                </div>
                                <div class="col col-4 col-md-4 col-sm-6 col-xs-12" index="3" type="column" sort="true">
                                    <div class="form-group">
                                        <label class="col col-12 col-xs-12"> <cf_get_lang_main no='1734.Şirketler'></label>
                                        <div class="col col-12 col-xs-12">
                                            <select name="comp_id" id="comp_id" style="width:200px;">
                                                    <cfoutput query="get_comp">
                                                    <option value="#comp_id#"<cfif isdefined("attributes.comp_id") and attributes.comp_id eq comp_id>selected</cfif>>#company_name#</option>
                                                </cfoutput>
                                            </select>
                                        </div>                                        
                                    </div>
                                </div>
                     </div>
                </div>
                <div class="row ReportContentBorder">
                    <div class="ReportContentFooter">
                        <label><cf_get_lang_main no='446.Excel Getir'><input type="checkbox" name="is_excel" id="is_excel" value="1" <cfif attributes.is_excel eq 1>checked</cfif>></label> 
                        <cfsavecontent variable="message"><cf_get_lang_main no='125.Sayi_Hatasi_Mesaj'></cfsavecontent>
                        <cfinput type="text" name="maxrows" value="#attributes.maxrows#" required="yes" validate="integer" range="1,999" message="#message#" onKeyUp="isNumber(this)" maxlength="3" style="width:25px;">
                        <cf_wrk_report_search_button search_function='control()' button_type='1' is_excel='1'>
                    </div> 
                </div>
            </div>
        </div>
    </cf_report_list_search_area>    
</cf_report_list_search>

</cfform>
<cfif isdefined('attributes.is_excel') and attributes.is_excel eq 1>
    <cfset filename="security_system_report#dateformat(now(),'ddmmyyyy')#_#timeformat(now(),'HHMMl')#_#session.ep.userid#">
    <cfheader name="Expires" value="#Now()#">
    <cfcontent type="application/vnd.msexcel;charset=utf-16">
    <cfheader name="Content-Disposition" value="attachment; filename=#filename#.xls">
    <meta http-equiv="Content-Type" content="text/html; charset=utf-16">
    <cfset attributes.startrow=1>
	<cfset attributes.maxrows=get_authority_report.recordcount>
    
</cfif>
<cfif isdefined("attributes.form_submitted")>
<cf_report_list>
        <thead>
            <tr>
                <th><cf_get_lang_main no='75.No'></th>
                <th><cf_get_lang_main no='164.Çalışan'></th>
                <th><cf_get_lang_main no='1085.Pozisyon'></th>
                <th><cf_get_lang no ='1356.Yetki Grubu'>-<cf_get_lang no ='7.Modül'></th>
                <th width="200"><cf_get_lang_main no ='162.Şirket'></th>
                <th><cf_get_lang_main no ='41.Şube'></th>
                <th><cf_get_lang no ='1358.İşlem Kategorileri'></th>
                <th><cf_get_lang no ='1359.Süreç Aşama'></th>		
                <th><cf_get_lang no ='1360.Fiyat Yetkisi'></th>
                <th><cf_get_lang_main no='247.Satış Bölgesi'></th>
            </tr>
        </thead>
        <tbody>
            <cfif get_authority_report.recordcount>
              <cfoutput query="get_authority_report" maxrows="#attributes.maxrows#" startrow="#attributes.startrow#">
                <tr class="nohover" <cfif len(employee_name) or len(employee_surname)>title="#employee_name# #employee_surname#"</cfif>>
                    <td valign="top">#currentrow#</td>
                    <td valign="top" nowrap>#employee_name# #employee_surname# </td>
                    <td valign="top" nowrap>#position_cat#</td>
                    <td valign="top">
                        <cfif len(get_authority_report.user_group_id)>
                            <cfquery name="GET_USER_GROUP" datasource="#DSN#">
                                SELECT USER_GROUP_NAME, USER_GROUP_PERMISSIONS FROM USER_GROUP WHERE USER_GROUP_ID IN (SELECT USER_GROUP_ID FROM USER_GROUP_EMPLOYEE WHERE EMPLOYEE_ID =#get_authority_report.EMPLOYEE_ID# ) ORDER BY USER_GROUP_NAME,USER_GROUP_PERMISSIONS
                            </cfquery>
                             <cfloop query="GET_USER_GROUP">
                            <cfset level_id_ = get_user_group.user_group_permissions>
                            <b>#get_user_group.user_group_name#</b><br/>(<cfloop query="get_modules"><cfif (listlen(level_id_) gte module_id) and (listgetat(level_id_,module_id) eq 1)>#module_name#, </cfif></cfloop>)<br/><br/> </cfloop>
                        <cfelse>
                            <cfset level_id_ = level_id>
                            <cfloop query="get_modules">
                                <cfif (listlen(level_id_) gte module_id) and (listgetat(level_id_,module_id) eq 1)>
                                    #module_name#<br/>
                                </cfif>
                            </cfloop>
                        </cfif>
                    </td>
                    <td valign="top" nowrap>
                        <cfquery name="get_comp_report" datasource="#dsn#">
                            SELECT
                                COMPANY_NAME
                            FROM
                                OUR_COMPANY
                            WHERE
                                COMP_ID IN (	SELECT
                                                    OUR_COMPANY_ID
                                                FROM
                                                    SETUP_PERIOD SP,
                                                    EMPLOYEE_POSITION_PERIODS EPP
                                                WHERE
                                                    SP.OUR_COMPANY_ID = OUR_COMPANY.COMP_ID AND
                                                    EPP.PERIOD_ID = SP.PERIOD_ID AND
                                                    EPP.POSITION_ID = #get_authority_report.position_id#
                                                )
                            ORDER BY
                                COMPANY_NAME
                        </cfquery>
                        <cfloop query="get_comp_report">#get_comp_report.company_name#<br/></cfloop>
                    </td>
                    <td valign="top">
                        <cfquery name="get_branch" datasource="#dsn#">
                            SELECT BRANCH_NAME FROM BRANCH WHERE BRANCH_ID IN (SELECT BRANCH_ID FROM EMPLOYEE_POSITION_BRANCHES WHERE POSITION_CODE = #position_code#) ORDER BY BRANCH_NAME
                        </cfquery>
                        <cfloop query="get_branch">#get_branch.branch_name#,<br/></cfloop>
                    </td>
                    <td valign="top">
                        <cfquery name="get_process_cat" datasource="#dsn#">
                            SELECT 
                                SPC.PROCESS_CAT,
                                SPC.IS_ALL_USERS
                            FROM 
                                #dsn3_alias#.SETUP_PROCESS_CAT SPC,
                                #dsn3_alias#.SETUP_PROCESS_CAT_ROWS SPCR
                            WHERE 
                                SPC.PROCESS_CAT_ID = SPCR.PROCESS_CAT_ID AND
                                (
                                    SPCR.POSITION_CODE = #get_authority_report.position_code# OR
                                    SPCR.POSITION_CAT_ID = #get_authority_report.position_cat_id#
                                )
                            GROUP BY
                                SPC.PROCESS_CAT,
                                SPC.IS_ALL_USERS
                        </cfquery>
                        <cfloop query="get_process_cat">#get_process_cat.process_cat# <cfif IS_ALL_USERS eq 1><i>(<cf_get_lang dictionary_id='47833.All Employees'>)</i></cfif>,<br/></cfloop>
                    </td>
                    <td valign="top" nowrap>
                        <cfquery name="get_process_type" datasource="#dsn#">
                            SELECT
                                PT.PROCESS_ID,
                                PT.PROCESS_NAME,
                                PTR.STAGE,
                                PTR.IS_EMPLOYEE,
                                PTR.PROCESS_ROW_ID
                            FROM
                                PROCESS_TYPE PT,
                                PROCESS_TYPE_ROWS PTR
                            WHERE
                                PT.IS_ACTIVE = 1 AND
                                PT.FACTION IS NOT NULL AND
                                PT.PROCESS_ID = PTR.PROCESS_ID AND
                                <!--- Iliskili Sirket --->
                                PT.PROCESS_ID IN (SELECT PROCESS_ID FROM PROCESS_TYPE_OUR_COMPANY PTOC WHERE PTOC.PROCESS_ID = PT.PROCESS_ID AND PTOC.OUR_COMPANY_ID = #session.ep.company_id#) AND
                                (
                                    <!--- Tum Calisanlar --->
                                    IS_EMPLOYEE = 1 OR
                                    (
                                        ISNULL(IS_EMPLOYEE,0) = 0 AND
                                        <!--- Yetkili Pozisyonlar --->
                                        PTR.PROCESS_ROW_ID IN (	<!--- Yetkili Pozisyonlar Direkt Eklenenler --->
                                                                SELECT
                                                                    PTRP.PROCESS_ROW_ID
                                                                FROM
                                                                    PROCESS_TYPE_ROWS_POSID PTRP
                                                                WHERE
                                                                    PTRP.PROCESS_ROW_ID = PTR.PROCESS_ROW_ID AND
                                                                    PTRP.PRO_POSITION_ID = #get_authority_report.position_id#
                                                                    
                                                                UNION
                                                                <!--- Surec Grubu ile Eklenenler --->
                                                                SELECT
                                                                    PTRW.PROCESS_ROW_ID
                                                                FROM
                                                                    PROCESS_TYPE_ROWS_POSID PTRP,
                                                                    PROCESS_TYPE_ROWS_WORKGRUOP PTRW
                                                                WHERE
                                                                    PTRP.PROCESS_ROW_ID IS NULL AND
                                                                    PTRW.MAINWORKGROUP_ID IS NOT NULL AND
                                                                    PTRP.WORKGROUP_ID = PTRW.MAINWORKGROUP_ID AND
                                                                    PTRW.PROCESS_ROW_ID = PTR.PROCESS_ROW_ID AND
                                                                    PTRP.PRO_POSITION_ID = #get_authority_report.position_id#
                                                              )
                                    )
                                )
                            ORDER BY
                                PT.PROCESS_NAME,
                                PTR.LINE_NUMBER,
                                PTR.IS_EMPLOYEE
                        </cfquery>
                        <cfset process_id_list = ''>
                        <cfloop query="get_process_type">
                            <cfif not ListFind(process_id_list,process_id,',')>
                                <span><b><u>#process_name#</u></b></span>
                            <br/> <br/>
                               <span> &nbsp;&nbsp;&nbsp;&nbsp;#stage# <cfif is_employee eq 1><i>(<cf_get_lang dictionary_id='47833.All Employees'>)</i></cfif>
                                <cfset process_id_list = ListAppend(process_id_list,process_id,',')> </span>
                               
                            <cfelse>
                                &nbsp;&nbsp;&nbsp;&nbsp;#stage# <cfif is_employee eq 1><i>(<cf_get_lang dictionary_id='47833.All Employees'>)</i></cfif>
                            </cfif>
                           
                                <cfquery name="GET_CAU" datasource="#DSN#">
                                    SELECT 
                                        PROCESS_TYPE_ROWS_CAUID.CAU_POSITION_ID,
                                        PROCESS_TYPE_ROWS_CAUID.WORKGROUP_ID
                                    FROM 
                                        PROCESS_TYPE_ROWS_CAUID
                                    WHERE 
                                        PROCESS_TYPE_ROWS_CAUID.PROCESS_ROW_ID = #get_process_type.PROCESS_ROW_ID# AND
                                        PROCESS_TYPE_ROWS_CAUID.CAU_POSITION_ID = #get_authority_report.employee_id# 
                                </cfquery>
                                 <cfquery name="GET_INF" datasource="#DSN#">
                                    SELECT 
                                        PROCESS_TYPE_ROWS_INFID.INF_POSITION_ID,
                                        PROCESS_TYPE_ROWS_INFID.WORKGROUP_ID
                                    FROM 
                                        PROCESS_TYPE_ROWS_INFID
                                    WHERE 
                                        PROCESS_TYPE_ROWS_INFID.PROCESS_ROW_ID = #get_process_type.PROCESS_ROW_ID# AND
                                        PROCESS_TYPE_ROWS_INFID.INF_POSITION_ID = #get_authority_report.employee_id# 
                                </cfquery>
                                <span class="ui-stage" title="<cf_get_lang dictionary_id='61216.Maker'>" style="color:##0abb87; background-color: rgba(10,187,135,.1);">M</span>
                                <cfif GET_CAU.recordCount> &nbsp;<span class="ui-stage" title="<cf_get_lang dictionary_id='60116.Checker'>" style="color:##5d78ff; background-color: rgba(93,120,255,.1);">C</span></cfif>
                                <cfif GET_INF.recordCount>&nbsp;<span class="ui-stage" title="<cf_get_lang dictionary_id='34561.CC'>" style="color:##ffb822; background-color: rgba(255,184,34,.1);">CC</span> </cfif>
                            <br/><br/>
                        </cfloop> 
                    </td>	
                    <td valign="top">
                        <cfquery name="get_competitive" datasource="#dsn#">
                            SELECT 
                                PC.COMPETITIVE
                            FROM
                                #dsn3_alias#.PRODUCT_COMP PC,
                                #dsn3_alias#.PRODUCT_COMP_PERM PCP
                            WHERE
                                PC.COMPETITIVE_ID = PCP.COMPETITIVE_ID AND
                                PCP.POSITION_CODE = #get_authority_report.position_code#
                            ORDER BY
                                PC.COMPETITIVE
                        </cfquery>
                        <cfloop query="get_competitive">#get_competitive.competitive#</cfloop>
                    </td>
                    <td valign="top" nowrap>
                        <cfquery name="get_sales_zone" datasource="#dsn#"> 
                            SELECT 
                                SZ_NAME 
                            FROM 
                                SALES_ZONES
                            WHERE 
                                RESPONSIBLE_POSITION_CODE = #get_authority_report.position_code#
                            ORDER BY 
                                SZ_NAME
                        </cfquery>
                        <cfloop query="get_sales_zone">#get_sales_zone.sz_name#<br/></cfloop>
                    </td>
                </tr>
                </cfoutput>
            <cfelse>
                <tr>
                    <td colspan="10"><cfif isdefined("attributes.form_submitted")><cf_get_lang_main no='72.Kayıt Bulunamadı'> !<cfelse><cf_get_lang_main no='289.Filtre Ediniz '> !</cfif></td>
                </tr>
            </cfif>
        </tbody>
</cf_report_list>
</cfif>
<cfif attributes.totalrecords gt attributes.maxrows>
	<cfset adres='form_submitted=1'>
	<cfif isDefined("attributes.position") and len(attributes.position)>
		<cfset adres = adres&"&position="&attributes.position>
	</cfif>
	<cfif isDefined("attributes.comp_id") and len(attributes.comp_id)>
		<cfset adres = adres&"&company="&attributes.comp_id>
	</cfif>
	<cfif isdefined("attributes.keyword") and len(attributes.keyword)>
		<cfset adres= adres&"&keyword="&attributes.keyword>
	</cfif>
	<cf_paging
        page="#attributes.page#"
        maxrows="#attributes.maxrows#"
        totalrecords="#attributes.totalrecords#"
        startrow="#attributes.startrow#"
        adres="report.security_report&#adres#">	
</cfif>
<br/>
<!--- FBS 20090610 Leo istegi uzerine kaldirildi, sakincali ise bildiriniz geri alalim
<script type="text/javascript">	
document.getElementById('keyword').focus();
function kontrol()
{
	x = document.form_securit_system_report.position.selectedIndex;
	if(document.form_securit_system_report.keyword.value == "" && document.form_securit_system_report.position[x].value == "")
	{
		alert("Kullanıcı Yada Pozisyon Tipi Seçiniz !")
		return false;
	}	
	return true;		
}
</script> --->
<script>
    function control()
    {
		if(document.form_securit_system_report.is_excel.checked==false)
			{
				document.form_securit_system_report.action="<cfoutput>#request.self#</cfoutput>?fuseaction=report.security_report"
				return true;
			}
            else
				document.form_securit_system_report.action="<cfoutput>#request.self#?fuseaction=report.emptypopup_security_report</cfoutput>"
	}
</script>