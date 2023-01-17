<cfsetting showdebugoutput="no">
<!--- bu sayfa firsat,service,callcenter service ve proje detaydan cagirilir... bu dosyaya bagli olarak copy_work.cfm ve del_work.cfm duzenlenmelidir --->
<cfparam name="attributes.workgroup_id" default="">
<cfparam name="attributes.priority_cat" default="">
<cfparam name="attributes.currency" default="">
<cfparam name="attributes.keyword" default="">
<cfparam name="attributes.startrow" default="1">
<cfparam name="attributes.maxrows" default='#session.ep.maxrows#'>
<cfparam name="attributes.work_status" default="1">
<cfparam name="attributes.ordertype" default="">
<cfparam name="attributes.work_milestones" default="0">
<cf_get_lang_set module_name="project"><!--- sayfanin en altinda kapanisi var --->
<cfquery name="GET_FUSEACTIONS" datasource="#DSN#">
	SELECT 
		MODUL,
		FUSEACTION,
        MODUL_SHORT_NAME
	FROM
		WRK_OBJECTS
	WHERE 
		WRK_OBJECTS_ID = #attributes.woid#
</cfquery>
<cfquery name="GET_WORKGROUPS" datasource="#DSN#">
	SELECT 
		WORKGROUP_ID,
		WORKGROUP_NAME
	FROM 
		WORK_GROUP
	WHERE
		STATUS = 1
		AND HIERARCHY IS NOT NULL
	ORDER BY 
		HIERARCHY
</cfquery>

<cfset temp_Error = 0>

<cftry>
    <cfquery name="GET_PRO_WORK" datasource="workcube_worknet">
        SELECT
            *
        FROM
        (
            SELECT
                CASE 
                    WHEN IS_MILESTONE = 1 THEN WORK_ID
                    WHEN IS_MILESTONE <> 1 THEN ISNULL(MILESTONE_WORK_ID,0)
                END AS NEW_WORK_ID,
                CASE 
                    WHEN IS_MILESTONE = 1 THEN 0
                    WHEN IS_MILESTONE <> 1 THEN 1
                END AS TYPE,
                PW.IS_MILESTONE,
                PW.MILESTONE_WORK_ID,
                PW.WORK_ID,
                PW.WORK_HEAD,
                PW.ESTIMATED_TIME,
                (SELECT PTR.STAGE FROM PROCESS_TYPE_ROWS PTR WHERE PTR.PROCESS_ROW_ID = PW.WORK_CURRENCY_ID) STAGE,
                (SELECT PWC.WORK_CAT FROM PRO_WORK_CAT PWC WHERE PWC.WORK_CAT_ID = PW.WORK_CAT_ID) WORK_CAT,
                PW.WORK_PRIORITY_ID,
                CASE 
                    WHEN PW.PROJECT_EMP_ID IS NOT NULL THEN (SELECT E.EMPLOYEE_NAME +' '+ E.EMPLOYEE_SURNAME FROM EMPLOYEES E WHERE E.EMPLOYEE_ID = PW.PROJECT_EMP_ID)
                    WHEN PW.OUTSRC_PARTNER_ID IS NOT NULL THEN (SELECT C2.NICKNAME+' - '+ CP2.COMPANY_PARTNER_NAME + ' ' + CP2.COMPANY_PARTNER_SURNAME NAME FROM COMPANY_PARTNER CP2,COMPANY C2 WHERE C2.COMPANY_ID = CP2.COMPANY_ID AND CP2.PARTNER_ID = PW.OUTSRC_PARTNER_ID)
                END AS EMPLOYEE,
                PW.TARGET_FINISH,
                PW.TARGET_START,
                PW.REAL_FINISH,
                PW.REAL_START,
                PW.TO_COMPLETE,
                PW.UPDATE_DATE,
                PW.RECORD_DATE,
                SP.PRIORITY,
                SP.COLOR,
                (SELECT PRO_MATERIAL.PRO_MATERIAL_ID FROM PRO_MATERIAL WHERE PRO_MATERIAL.WORK_ID = PW.WORK_ID) PRO_MATERIAL_ID
            FROM
                PRO_WORKS PW,
                SETUP_PRIORITY SP
            WHERE
                PW.WORK_PRIORITY_ID = SP.PRIORITY_ID AND
                PW.WORK_CIRCUIT = '#get_fuseactions.modul_short_name#' AND
                WORK_FUSEACTION = '#get_fuseactions.fuseaction#'
                <cfif len(attributes.keyword)>
                    AND PW.WORK_HEAD LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#attributes.keyword#%">
                </cfif>
                <cfif len(attributes.priority_cat)>
                    AND PW.WORK_PRIORITY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.priority_cat#">
                </cfif>
                <cfif len(attributes.workgroup_id)>
                    AND PW.WORKGROUP_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.workgroup_id#">
                </cfif>
                 <cfif isdefined("attributes.work_cat") and len(attributes.work_cat)>
                    AND PW.WORK_CAT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.work_cat#">
                </cfif>
                <cfif len(attributes.currency)>
                    AND PW.WORK_CURRENCY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.currency#">
                </cfif>
                <cfif attributes.work_status eq -1>
                    AND (PW.WORK_STATUS = 0 OR PW.IS_MILESTONE = 1)
                <cfelseif attributes.work_status eq 1>
                    AND (PW.WORK_STATUS = 1 OR PW.IS_MILESTONE = 1)
                </cfif>
                  )T1
            WHERE
                1=1 
                <cfif attributes.work_milestones eq 0>
                    AND IS_MILESTONE <> 1
                </cfif>
            ORDER BY	
                NEW_WORK_ID,
                TYPE
           <cfif isdefined("attributes.ordertype") and attributes.ordertype eq 1>
                ,WORK_ID DESC
           <cfelseif isdefined("attributes.ordertype") and attributes.ordertype eq 2>
                ,RECORD_DATE DESC
            <cfelseif isdefined("attributes.ordertype") and attributes.ordertype eq 3>
                ,TARGET_START DESC
            <cfelseif isdefined("attributes.ordertype") and attributes.ordertype eq 4>
                ,TARGET_START
            <cfelseif isdefined("attributes.ordertype") and attributes.ordertype eq 5>
                ,TARGET_FINISH DESC
            <cfelseif isdefined("attributes.ordertype") and attributes.ordertype eq 6>
                ,TARGET_FINISH
            <cfelseif isdefined("attributes.ordertype") and attributes.ordertype eq 7>
                ,WORK_HEAD
        </cfif>
    </cfquery>
    
    <cfset work_h_list = ''>
    <cfif get_pro_work.recordcount>
        <cfset work_h_list = valuelist(get_pro_work.WORK_ID)>
        <cfquery name="GET_HARCANAN_ZAMAN" datasource="workcube_worknet">
            SELECT
                SUM((ISNULL(TOTAL_TIME_HOUR,0)*60) + ISNULL(TOTAL_TIME_MINUTE,0)) AS HARCANAN_DAKIKA,
                WORK_ID
            FROM
                PRO_WORKS_HISTORY
            WHERE
                WORK_ID IN (#work_h_list#)
            GROUP BY
                WORK_ID
        </cfquery>
        <cfset work_h_list = listsort(listdeleteduplicates(valuelist(get_harcanan_zaman.WORK_ID,',')),'numeric','ASC',',')>

    </cfif>
    <cfquery name="GET_PROCURRENCY" datasource="workcube_worknet">
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
            PT.FACTION LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%project.works%">
    </cfquery>

    <cfquery name="GET_CATS" datasource="workcube_worknet">
        SELECT 
            PRIORITY_ID,
            PRIORITY 
        FROM 
            SETUP_PRIORITY
        ORDER BY
            PRIORITY
    </cfquery>
    <cfcatch>
    	<cfset get_pro_work.recordcount = 0>
        <cfset get_harcanan_zaman.recordcount = 0>
        <cfset get_procurrency.recordcount = 0>
        <cfset get_cats.recordcount = 0>
        <cfset temp_Error = 1>
        <tr>
            <td colspan="4">Worknet DB sinden Data Çekildiği İçin Hata Verebilir !</td>
        </tr>
    </cfcatch>
</cftry>  
  
<cfif temp_Error eq 0>
	<cfif isDefined("attributes.related_project_info")>
        <cfset this_div_id_ = attributes.project_id>
    <cfelseif isDefined("attributes.woid")>
        <cfset this_div_id_ = attributes.woid>
    <cfelseif isDefined("attributes.g_service_id")>
        <cfset this_div_id_ = attributes.g_service_id>
    <cfelseif isDefined("attributes.service_id")>
        <cfset this_div_id_ = attributes.service_id>
    <cfelseif isDefined("attributes.opp_id")>
        <cfset this_div_id_ = attributes.opp_id>
    <cfelseif isDefined("attributes.project_id")>
        <cfset this_div_id_ = attributes.project_id>
    </cfif>
    
    <div id="project_works_div_<cfoutput>#this_div_id_#</cfoutput>">
    <cfform name="works_#this_div_id_#" method="post" action="">
     <cf_ajax_list_search>
        <cf_ajax_list_search_area>
        <table>
            <tr>
                <td>	
                    <cf_get_lang_main no='48.Filtre'>
                    <cfif isDefined("attributes.related_project_info")>
                        <cfinput type="text" name="keyword" value="#attributes.keyword#" id="keyword" style="width:100px;" onKeyPress="if(event.keyCode==13 ) {loader_page(#attributes.project_id#); return false;}">
                    <cfelse>
                        <cfinput type="text" name="keyword" value="#attributes.keyword#" id="keyword" style="width:100px;" onKeyPress="if(event.keyCode==13 ) {loader_page(#this_div_id_#); return false;}">
                    </cfif>
                    <select name="currency" id="currency" style="width:120px; height:17px;">
                        <option value=""><cf_get_lang_main no='70.Asama'></option>
                       	<cfoutput query="get_procurrency">
                            <option value="#process_row_id#" <cfif attributes.currency eq process_row_id>selected</cfif>>#stage#</option>
                        </cfoutput>
                    </select>
                    <select name="workgroup_id" id="workgroup_id" style="width:150px;">				  
                        <option value=""><cf_get_lang_main no='728.İş Grubu'></option>
                        <cfoutput query="get_workgroups">
                            <option value="#workgroup_id#" <cfif isdefined("attributes.workgroup_id") and workgroup_id eq attributes.workgroup_id>selected</cfif>>#workgroup_name#</option>
                        </cfoutput>
                    </select>
                    <select name="priority_cat" id="priority_cat">
                        <option value=""><cf_get_lang_main no='73.Öncelik'></option>
                  	<cfoutput query="get_cats">
                        <option value="#priority_id#" <cfif attributes.priority_cat eq priority_id>selected</cfif>>#priority#</option>
                    </cfoutput>
                    </select>
                    <select name="ordertype" id="ordertype" style="width:170px;">
                        <option value="1">İş ve ID ye Göre Azalan</option>                     
                        <option value="2" <cfif isdefined("attributes.ordertype") and attributes.ordertype eq 2>selected</cfif>>Güncellemeye Göre Azalan</option>
                        <option value="3" <cfif isdefined("attributes.ordertype") and attributes.ordertype eq 3>selected</cfif>>Başlangıç Tarihine Göre Azalan</option>
                        <option value="4" <cfif isdefined("attributes.ordertype") and attributes.ordertype eq 4>selected</cfif>>Başlangıç Tarihine Göre Artan</option>
                        <option value="5" <cfif isdefined("attributes.ordertype") and attributes.ordertype eq 5>selected</cfif>>Bitiş Tarihine Göre Azalan</option>
                        <option value="6" <cfif isdefined("attributes.ordertype") and attributes.ordertype eq 6>selected</cfif>>Bitiş Tarihine Göre Artan</option>
                        <option value="7" <cfif isdefined("attributes.ordertype") and attributes.ordertype eq 7>selected</cfif>>İş Başlığına Göre Alfabetik</option>
                    </select>
                    <select name="work_milestones" id="work_milestones"  style="width:120px;">
                        <option value="1" <cfif attributes.work_milestones eq 1>selected</cfif>>Milestonelar Dahil</option>
                        <option value="0" <cfif attributes.work_milestones eq 0>selected</cfif>>Milestonlar Hariç </option>
                    </select>
                    <select name="work_status" id="work_status" style="width:60px;">
                        <option value="1" <cfif attributes.work_status eq 1>selected</cfif>><cf_get_lang_main no='81.Aktif'></option>
                        <option value="-1" <cfif attributes.work_status eq -1>selected</cfif>><cf_get_lang_main no='82.Pasif'></option>
                        <option value="0" <cfif attributes.work_status eq 0>selected</cfif>><cf_get_lang_main no='296.Tümü'></option>
                    </select>
                    <cfsavecontent variable="search"><cf_get_lang_main no ='153.Ara'></cfsavecontent>
                    <input type="button" value="Ara" onClick="loader_page(<cfif isDefined("attributes.related_project_info")><cfoutput>#attributes.project_id#</cfoutput><cfelse><cfoutput>#this_div_id_#</cfoutput></cfif>);">
                </td>
            </tr>
         </table>
        </cf_ajax_list_search_area>
     </cf_ajax_list_search>
     <cf_ajax_list>
        <thead>
           <tr>
                <th style="width:15px;"><cf_get_lang_main no='75.No'></th>
                <th><cf_get_lang no='93.İş'></th>
                <th width="110"><cf_get_lang_main no='157.Görevli'></th>
                <th width="40"><cf_get_lang_main no='73.Öncelik'></th>
                <th width="80"><cf_get_lang_main no='1457.Planlanan'></th>
                <th width="80"><cf_get_lang no='334.Gerçekleşen'> </th>
                <th width="50"><cf_get_lang_main no='70.Aşama'></th>
                <th width="50"><cf_get_lang_main no='74.Kategori'></th>
                <th width="60"><cf_get_lang no='95.Ongorulen süre'></th>
                <th width="60"><cf_get_lang no='8.harcanan süre'></th>
                <th style="width:25px;">%</th>
                <th style="width:15px;"></th>
                <cfif isdefined("attributes.ajax")>
                    <th style="width:15px;">
                        <!--- Kopyalama --->
                        <cfif isDefined("attributes.service_id")>
                            <cfif isDefined("attributes.related_project_info")>
                                <a href="javascript://" onClick="windowopen('<cfoutput>#request.self#?fuseaction=objects.popup_add_related_work&rel_work_id=works_#this_div_id_#.work_rela_id&relat_pro=works_#this_div_id_#.project_rela_id&related_service_id=#service_id#&call_function=loader_page(#attributes.project_id#)</cfoutput>','project');"><img src="/images/report_square2.gif"  border="0" title="İlişkili İş"></a>
                            <cfelse>
                                <a href="javascript://" onClick="windowopen('<cfoutput>#request.self#?fuseaction=objects.popup_add_related_work&rel_work_id=works_#this_div_id_#.work_rela_id&relat_pro=works_#this_div_id_#.project_rela_id&related_service_id=#service_id#&call_function=loader_page(#this_div_id_#)</cfoutput>','project');"><img src="/images/report_square2.gif"  border="0" title="İlişkili İş"></a>
                            </cfif>
                        </cfif>
                    </th>
                </cfif>
                <th style="width:15px">
                    <!--- Ekleme --->
                    <cfif not listfindnocase(denied_pages,'project.popup_add_work')>
                        <cfif isdefined("x_is_related_tree_cat") and x_is_related_tree_cat eq 1>
                            <a href="javascript://" class="tableyazi" onClick="tree_gonder(1,'');"><img src="/images/plus_list.gif" border="0" title="<cf_get_lang_main no='521.İş Ekle'>" /></a>
                        <cfelse><!--- FBS 20120222 project_id olarak degistirdim, sorun oluyordu, bu sekilde de sorun olursa bildirin duzeltelim <cfif isDefined("attributes.related_project_info")>&id=#attributes.project_id#<cfelseif isdefined("attributes.action_project_id") and len(attributes.action_project_id)>&id=#attributes.action_project_id#</cfif> --->
                            <a href="javascript://" onClick="windowopen('<cfoutput>#request.self#?fuseaction=project.popup_add_work<cfif isDefined("attributes.project_id")>&id=#attributes.project_id#</cfif>&work_fuse=#attributes.fuseaction#<cfif isDefined("attributes.g_service_id")>&g_service_id=#attributes.g_service_id#<cfelseif isDefined("attributes.service_id")>&service_id=#attributes.service_id#<cfelseif isDefined("attributes.opp_id")>&opp_id=#attributes.opp_id#<cfelseif isDefined("attributes.assetp_id")>&assetp_id=#attributes.assetp_id#</cfif></cfoutput>','wwide1');"> <img src="/images/plus_list.gif" border="0" title="<cf_get_lang_main no='521.İş Ekle'>"></a>
                        </cfif>
                    </cfif>
                </th>
            </tr>
        </thead>
        <tbody>
        <cfif get_pro_work.recordcount>
            <cfoutput query="GET_PRO_WORK" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#"> 
                <tr>
                    <td>#currentrow#</td>
                    <td>
                        <a href="javascript://" class="tableyazi" onClick="windowopen('#request.self#?fuseaction=project.popup_updwork&id=#work_id#','project')">
                            <cfif type eq 0>
                                <font color="CC0000"><b>(M) #work_head#</b></font>
                            <cfelse>
                                <cfif len(milestone_work_id) and attributes.work_milestones neq 0>&nbsp;&nbsp;&nbsp;&nbsp;</cfif>
                                <font color="#COLOR#">#work_head#</font>
                            </cfif>
                        </a>
                    </td>
                    <td>#employee#</td>
                    <cfif len(work_priority_id)>
                        <td><font color="#COLOR#">#priority#</font></td>
                    </cfif>
                    <cfif isdefined('target_finish') and len(target_finish)>
                        <cfset fdate_plan=date_add("h",session.ep.time_zone,target_finish)>
                    <cfelse>
                        <cfset fdate_plan=''>
                    </cfif>
                    <cfif isdefined('target_start') and len(target_start)>
                        <cfset sdate_plan=date_add("h",session.ep.time_zone,target_start)>
                    <cfelse>
                        <cfset sdate_plan = ''>
                    </cfif>
                    <td>
                    <cfif isdefined('sdate_plan') and len(sdate_plan)>
                        <font color="#COLOR#">#dateformat(sdate_plan,'dd/mm/yyyy')#,#timeformat(sdate_plan,'HH:mm')#</font>
                    </cfif>
                    <cfif isdefined('fdate_plan') and len(fdate_plan)>
                        <font color="#COLOR#">#dateformat(fdate_plan,'dd/mm/yyyy')#,#timeformat(fdate_plan,'HH:mm')#</font>
                    </cfif>
                    </td>
                    <cfif isdefined('REAL_FINISH') and len(REAL_FINISH)>
                        <cfset fdate=date_add("h",session.ep.time_zone,REAL_FINISH)>
                    <cfelse>
                        <cfset fdate=''>
                    </cfif>
                    <cfif isdefined('REAL_START') and len(REAL_START)>
                        <cfset sdate=date_add("h",session.ep.time_zone,REAL_START)>
                    <cfelse>
                        <cfset sdate = ''>
                    </cfif>
                    <td><cfif isdefined('sdate') and len(sdate)>
                        <font color="#COLOR#">#dateformat(sdate,'dd/mm/yyyy')#,#timeformat(sdate,'HH:mm')#</font>
                    </cfif>
                    <cfif isdefined('fdate') and len(fdate)>
                        <font color="#COLOR#">#dateformat(fdate,'dd/mm/yyyy')#,#timeformat(fdate,'HH:mm')#</font>
                    </cfif>
                    </td>
                    <td>#stage#</td>
                    <td>#work_cat#</td>
                    <td>
                        <cfif isdefined('estimated_time') and len(estimated_time)>
                            <cfset liste=estimated_time/60>
                            <cfset saat=listfirst(liste,'.')>
                            <cfset dak=estimated_time-saat*60>
                            #saat# saat #dak# dk
                        </cfif>
                    </td>
                    <td>
                        <cfif listfindnocase(work_h_list,work_id)>
                            <cfset harcanan_ = get_harcanan_zaman.HARCANAN_DAKIKA[listfind(work_h_list,work_id,',')]>
                            <cfset liste=harcanan_/60>
                            <cfset saat=listfirst(liste,'.')>
                            <cfset dak=harcanan_-saat*60>
                            #saat# saat #dak# dk
                        </cfif>
                    </td>
                    <td>
                    <!--- Yuzde --->
                        <div id="complate_ratio_div#WORK_ID#" ></div> <!---style="display:none"--->
                        <input type="text" name="is_complate#work_id#" onkeyup="isNumber(this);" id="complate_ratio#WORK_ID#" class="box" style="width:100%" maxlength="3" value="<cfif len(to_complete)>#to_complete#<cfelse>-</cfif>" onBlur="swaping(this.value,#WORK_ID#,is_complate#work_id#)">
                    </td>
                    <td><!--- Malzeme --->
                        <cfif not listfindnocase(denied_pages,'project.popup_add_project_material') and isDefined("attributes.related_project_info")>
                            <cfif len(pro_material_id)>
                                <a href="javascript://" onClick="windowopen('#request.self#?fuseaction=project.popup_upd_project_material&upd_id=#pro_material_id#','wide');"> <img src="/images/list_ship.gif" border="0" title="<cf_get_lang no ='206.Malzeme'>"></a>
                            <cfelse>
                                <a href="javascript://" onClick="windowopen('#request.self#?fuseaction=project.popup_add_project_material&project_id=#attributes.project_id#&work_id=#work_id#','wide');"> <img src="/images/list_ship.gif" border="0" title="<cf_get_lang no ='206.Malzeme'>"></a>
                            </cfif>
                        </cfif>
                    </td>
                    <cfif isdefined("attributes.ajax")>
                    <td><!--- Kopyalama ---><a href="javascript://" onClick="copy_work(#work_id#);"><img src="/images/copy_list.gif" border="0" title="<cf_get_lang_main no ='64.Kopyala'>"></a></td>
                    </cfif>
                    <td><!--- Ekleme---> 
                        <cfif isdefined("x_is_related_tree_cat") and x_is_related_tree_cat eq 1>
                            <a href="javascript://" class="tableyazi" onClick="tree_gonder(3,'#work_id#');"><img src="/images/plus_list.gif" border="0" title="<cf_get_lang_main no='521.İş Ekle'>"></a>
                        <cfelse>
                            <a href="javascript://" onClick="windowopen('#request.self#?fuseaction=project.popup_add_work<cfif isDefined("attributes.project_id") and Len(attributes.project_id)>&id=#attributes.project_id#</cfif>&work_id=#work_id#&work_fuse=#attributes.fuseaction#<cfif isDefined("attributes.g_service_id")>&g_service_id=#attributes.g_service_id#<cfelseif isDefined("attributes.service_id")>&service_id=#attributes.service_id#<cfelseif isDefined("attributes.opp_id")>&opp_id=#attributes.opp_id#</cfif>','wwide1');"><img src="/images/plus_list.gif" border="0" title="<cf_get_lang_main no='521.İş Ekle'>"></a>
                        </cfif>
                    </td>
                </tr>
            </cfoutput>
        <cfelse>
            <tr>
                <td colspan="16"><cf_get_lang_main no='72.Kayıt Yok'> !</td>
            </tr>
        </cfif>
        </tbody>
     </cf_ajax_list>
    </cfform>
    </div>
    <script type="text/javascript">
    function delete_work(work_id)
    {
        if(confirm('İş Silinecek!Emin misiniz!'))
        {
            div_id = 'complate_ratio_div'+work_id;
            //div_id = '_dsp_works_';
            var send_address = '<cfoutput>#request.self#?fuseaction=dev.emptypopup_delwork&fbx=#attributes.fbx#&woid=#attributes.woid#&work_id=</cfoutput>'+ work_id;
            AjaxPageLoad(send_address,div_id,1);
        }
        else
        {
            return false;
        }
    }
    
    function copy_work(work_id)
    {
        div_id = 'complate_ratio_div'+work_id;
        var send_address = '<cfoutput>#request.self#?fuseaction=dev.emptypopup_copy_work&fbx=#attributes.fbx#&woid=#attributes.woid#&work_id=</cfoutput>'+ work_id;
        AjaxPageLoad(send_address,div_id,1);
    }
    function change_stage(work_currency_id,work_id)
    {
        stage_div_id ='complate_ratio_div' +work_id;
        var send_address = '<cfoutput>#request.self#?fuseaction=dev.emptypopup_upd_work_currency&fbx=#attributes.fbx#<cfif isDefined("attributes.related_project_info")>&related_project_info=1</cfif><cfif isdefined("attributes.project_id")>&project_id=#attributes.project_id#</cfif><cfif isdefined("attributes.opp_id")>&opp_id=#attributes.opp_id#</cfif><cfif isdefined("attributes.service_id")>&service_id=#attributes.service_id#</cfif><cfif isdefined("attributes.g_service_id")>&g_service_id=#attributes.g_service_id#</cfif>&work_id=' + work_id + '&work_currency_id=</cfoutput>' + work_currency_id;
        AjaxPageLoad(send_address,stage_div_id ,1);
    }
        
    function swaping(deger,work_id)
    {
        if (deger <= 100)
        {
            div_id = 'complate_ratio_div'+work_id;
            if(document.getElementById('complate_ratio'+work_id) != undefined && document.getElementById('complate_ratio'+work_id).value.lenght != '')
            {	
                var send_address = '<cfoutput>#request.self#</cfoutput>?fuseaction=dev.emptypopup_ajax_work_ratio&work_id='+ work_id +'&deger='+deger;
                AjaxPageLoad(send_address,div_id,1);
            }
        }
        else if (deger > 100)
        {
            alert("<cf_get_lang no ='218.Tamamlanma Orani 100 den kucük bir rakam olmalidir'>");
            return false;
        }
    }
    function loader_page(_x_)
    {  
        AjaxPageLoad('<cfoutput>#request.self#?fuseaction=dev.emptypopup_ajax_project_works&fbx=#attributes.fbx#&woid=#attributes.woid#&currency='+document.getElementById('currency').value+'&keyword='+document.getElementById('keyword').value+'&priority_cat='+document.getElementById('priority_cat').value+'&ordertype='+document.getElementById('ordertype').value+'&work_status='+document.getElementById('work_status').value,'project_works_div_'+_x_+'</cfoutput>',1); 
        return false;
    }
    
    </script>
</cfif>
<cf_get_lang_set module_name="#lcase(listgetat(attributes.fuseaction,1,'.'))#"><!--- sayfanin en ustunde acilisi var --->
