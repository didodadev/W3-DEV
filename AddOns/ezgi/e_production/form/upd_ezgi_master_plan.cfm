<cfparam name="paper_project_id" default="">
<cfparam name="attributes.start_date" default="">
<cfparam name="attributes.finish_date" default="">
<cfparam name="attributes.start_h" default="">
<cfparam name="attributes.finish_h" default="">
<cfparam name="attributes.start_m" default="">
<cfparam name="attributes.finish_m" default="">
<cfparam name="attributes.detail" default="">
<cfparam name="attributes.is_detail" default="">
<cfparam name="attributes.shift_id" default="">
<cfparam name="attributes.shift_name" default="">
<cfparam name="attributes.shift" default="">
<cfparam name="attributes.get_master_plan_process" default="">
<cfparam name="attributes.shift_employee_id" default="#session.ep.USERID#">
<cfparam name="attributes.master_plan_status" default="">
<cfquery name="get_default" datasource="#dsn3#">
	SELECT       
    	ISNULL(EMAD.POINT_METHOD,1) POINT_METHOD,
        EMAD.FABRIC_CAT,
        EMAD.CONTROL_METHOD
	FROM            
    	EZGI_MASTER_PLAN_DEFAULTS AS EMAD INNER JOIN
     	EZGI_MASTER_PLAN AS EMAP ON EMAD.SHIFT_ID = EMAP.MASTER_PLAN_CAT_ID
	WHERE        
    	EMAP.MASTER_PLAN_ID = #attributes.upd_id#
</cfquery>
<cfquery name="get_shift" datasource="#dsn3#">
	SELECT	
    	MASTER_PLAN_START_DATE,
		MASTER_PLAN_FINISH_DATE,
		MASTER_PLAN_CAT_ID, 
		MASTER_PLAN_NAME, 
		MASTER_PLAN_NUMBER, 
		MASTER_PLAN_DETAIL, 
		MASTER_PLAN_STATUS, 
		MASTER_PLAN_STAGE,
     	ISNULL(MASTER_PLAN_PROCESS,0) MASTER_PLAN_PROCESS,
		EMPLOYYEE_ID, 
		BRANCH_ID, 
		RECORD_EMP, 
		RECORD_IP, 
		RECORD_DATE, 
		IS_PROCESS, 
		MONEY,
		MASTER_PLAN_PROJECT_ID,
		GROSSTOTAL,
     	ISNULL((
            		SELECT     
                    	SUM(PLAN_POINT) PLAN_POINT
					FROM         
                    	EZGI_MASTER_ALT_PLAN
					WHERE     
                    	MASTER_PLAN_ID = EZGI_MASTER_PLAN.MASTER_PLAN_ID
      	),0) AS H_POINT,
        <cfif get_default.POINT_METHOD eq 1>
  			ISNULL((	
            		SELECT     
                        	SUM(PO.QUANTITY) AS P_POINT
						FROM         
                        	EZGI_MASTER_PLAN_RELATIONS AS EMPR INNER JOIN
                          	PRODUCTION_ORDERS AS PO ON EMPR.P_ORDER_ID = PO.P_ORDER_ID INNER JOIN
                          	EZGI_MASTER_ALT_PLAN AS EMAP ON EMPR.MASTER_ALT_PLAN_ID = EMAP.MASTER_ALT_PLAN_ID INNER JOIN
                          	EZGI_MASTER_PLAN_SABLON AS EMAS ON EMAP.PROCESS_ID = EMAS.PROCESS_ID
						WHERE     
                        	EMPR.MASTER_PLAN_ID = EZGI_MASTER_PLAN.MASTER_PLAN_ID AND 
                            EMAS.SIRA = 1 AND 
                            PO.IS_STAGE = 2
    		),0) AS G_POINT,
   			ISNULL((	
            		SELECT     
                        	SUM(PO.QUANTITY) AS P_POINT
						FROM         
                        	EZGI_MASTER_PLAN_RELATIONS AS EMPR INNER JOIN
                      		PRODUCTION_ORDERS AS PO ON EMPR.P_ORDER_ID = PO.P_ORDER_ID INNER JOIN
                      		EZGI_MASTER_ALT_PLAN AS EMAP ON EMPR.MASTER_ALT_PLAN_ID = EMAP.MASTER_ALT_PLAN_ID INNER JOIN
                      		EZGI_MASTER_PLAN_SABLON AS EMAS ON EMAP.PROCESS_ID = EMAS.PROCESS_ID
						WHERE     
                        	EMPR.MASTER_PLAN_ID = EZGI_MASTER_PLAN.MASTER_PLAN_ID AND 
                            EMAS.SIRA = 1
   			),0) AS T_POINT 
     	<cfelseif get_default.POINT_METHOD eq 2>         
        	ISNULL(
                	(	
            		SELECT     
                        	SUM(PO.QUANTITY * ISNULL(PTIP.PROPERTY2, 0)) AS P_POINT
						FROM         
                        	EZGI_MASTER_PLAN_RELATIONS AS EMPR INNER JOIN
                          	PRODUCTION_ORDERS AS PO ON EMPR.P_ORDER_ID = PO.P_ORDER_ID INNER JOIN
                          	EZGI_MASTER_ALT_PLAN AS EMAP ON EMPR.MASTER_ALT_PLAN_ID = EMAP.MASTER_ALT_PLAN_ID INNER JOIN
                          	EZGI_MASTER_PLAN_SABLON AS EMAS ON EMAP.PROCESS_ID = EMAS.PROCESS_ID LEFT OUTER JOIN
                          	PRODUCT_TREE_INFO_PLUS AS PTIP ON PO.STOCK_ID = PTIP.STOCK_ID
						WHERE     
                        	EMPR.MASTER_PLAN_ID = EZGI_MASTER_PLAN.MASTER_PLAN_ID AND 
                            EMAS.SIRA = 1 AND 
                            PO.IS_STAGE = 2
      				),0) AS G_POINT,
            ISNULL(
                	(	
            		SELECT     
                        	SUM(PO.QUANTITY * ISNULL(PTIP.PROPERTY2, 0)) AS P_POINT
						FROM         
                        	EZGI_MASTER_PLAN_RELATIONS AS EMPR INNER JOIN
                      		PRODUCTION_ORDERS AS PO ON EMPR.P_ORDER_ID = PO.P_ORDER_ID INNER JOIN
                      		EZGI_MASTER_ALT_PLAN AS EMAP ON EMPR.MASTER_ALT_PLAN_ID = EMAP.MASTER_ALT_PLAN_ID INNER JOIN
                      		EZGI_MASTER_PLAN_SABLON AS EMAS ON EMAP.PROCESS_ID = EMAS.PROCESS_ID LEFT OUTER JOIN
                      		PRODUCT_TREE_INFO_PLUS AS PTIP ON PO.STOCK_ID = PTIP.STOCK_ID
						WHERE     
                        	EMPR.MASTER_PLAN_ID = EZGI_MASTER_PLAN.MASTER_PLAN_ID AND 
                            EMAS.SIRA = 1
      		),0) AS T_POINT 
        </cfif>       
	FROM	
    	EZGI_MASTER_PLAN
	WHERE	
    	MASTER_PLAN_ID = #attributes.upd_id#
</cfquery>
<cfset attributes.start_date=get_shift.MASTER_PLAN_START_DATE>
<cfset attributes.finish_date=get_shift.MASTER_PLAN_FINISH_DATE>
<cfset shift_id=get_shift.MASTER_PLAN_CAT_ID>
<cfset shift_name=get_shift.MASTER_PLAN_NAME>
<cfset paper_number=get_shift.MASTER_PLAN_NUMBER>
<cfset detail=get_shift.MASTER_PLAN_DETAIL>
<cfset MASTER_PLAN_status=get_shift.MASTER_PLAN_STATUS>
<cfset process_stage=get_shift.MASTER_PLAN_STAGE>
<cfset shift_employee_id=get_shift.EMPLOYYEE_ID>
<cfset branch_id=get_shift.BRANCH_ID>
<cfset record_id=get_shift.RECORD_EMP>
<cfset record_time=get_shift.RECORD_DATE>
<cfset update_id=get_shift.RECORD_EMP>
<cfset update_time=get_shift.RECORD_DATE>
<cfset money=get_shift.MONEY>
<cfset paper_project_id=get_shift.MASTER_PLAN_PROJECT_ID>
<cfquery name="get_menu" datasource="#dsn3#">
    SELECT   	
    	*
    FROM       	
    	EZGI_MASTER_PLAN_SABLON
    WHERE     	
    	SHIFT_ID = #shift_id# AND 
        SIRA > 0
    ORDER BY	
    	SIRA	
</cfquery>
<cfquery name="get_ust_menu" datasource="#dsn3#">
	SELECT   	
    	*
    FROM       	
    	EZGI_MASTER_PLAN_SABLON
    WHERE     	
    	SHIFT_ID = #shift_id# AND 
        SIRA = 0
</cfquery>
<cfquery name="alt_plan_control" datasource="#dsn3#">
	SELECT     	
    	*
	FROM       	
    	EZGI_MASTER_ALT_PLAN
	WHERE     	
    	MASTER_PLAN_ID = #attributes.upd_id#
</cfquery>
<table border="0" width="98%" cellpadding="0" cellspacing="0" align="center">
	<tr>
    	<td colspan="2">
        	<table border="0" width="100%" align="center">
				<tr>
					<td class="headbold" height="35">&nbsp;&nbsp;<cf_get_lang_main no='3430.Üretim Master Planı Güncelle'></td>
					<td width="105" align="right">
                    	<a href="javascript://" onclick="windowopen('<cfoutput>#request.self#?fuseaction=#listgetat(attributes.fuseaction,1,'.')#.popup_ezgi_production_analist&master_plan_id=#upd_id#</cfoutput>','longpage');"><img src="/images/target_team.gif" border="0" title="<cf_get_lang_main no='3431.Üretim Sonuç Analizi'>"></a>&nbsp;
                    	<!---<a href="javascript://" onclick="windowopen('<cfoutput>#request.self#?fuseaction=#listgetat(attributes.fuseaction,1,'.')#.popup_display_ezgi_search_tedarik</cfoutput>','longpage');"><img src="/images/content_plus.gif" border="0" title="<cf_get_lang_main no='3432.Fason Tedarik Emri Arama'>"></a>--->
                    	<a href="javascript://" onclick="windowopen('<cfoutput>#request.self#?fuseaction=#listgetat(attributes.fuseaction,1,'.')#.popup_display_ezgi_search</cfoutput>','longpage');"><img src="/images/add_lesson.gif" border="0" title="<cf_get_lang_main no='3433.Emir Arama'>"></a>
						<!---<a href="javascript://" onclick="windowopen('<cfoutput>#request.self#?fuseaction=#listgetat(attributes.fuseaction,1,'.')#.popup_display_ezgi_prod_menu&type=1&master_plan_id=#upd_id#</cfoutput>','longpage');"><img src="/images/table.gif" border="0" title="<cf_get_lang_main no='3434.Koltuk Üretim Hızlı Bakış'>"></a>--->
                        <a href="javascript://" onclick="windowopen('<cfoutput>#request.self#?fuseaction=#listgetat(attributes.fuseaction,1,'.')#.popup_display_ezgi_prod_menu_moduler&type=1&master_plan_id=#upd_id#</cfoutput>','longpage');"><img src="/images/asset.gif" border="0" title="<cf_get_lang_main no='3435.Modüler Üretim Hızlı Bakış'>"></a>
                        <a href="<cfoutput>#request.self#</cfoutput>?fuseaction=prod.list_ezgi_master_plan"><img src="/images/refer.gif" border="0" title="<cfoutput>#getLang('main',3197)#</cfoutput>" ></a>
					</td>
				</tr>
			</table>
        </td>
	</tr>
	<tr>
		<td style="vertical-align:top">
			<cfoutput>
				<table width="98%" height="99%" cellpadding="2" cellspacing="1" class="color-border" align="center">
                    <tr>
                        <td valign="top" class="color-row">
                            <cfform name="add_shift" method="post" action="#request.self#?fuseaction=prod.emptypopup_upd_ezgi_master_plan">
                            <input type="hidden" name="upd_id" id="upd_id" value="#upd_id#">
                            <table>
                                <tr>
                                    <td width="90"><cf_get_lang_main no='3199.Master Plan Adı'>*</td>
                                    <td width="250">
                                        <input type="hidden" name="shift_id" id="shift_id" readonly="yes" value="<cfif isdefined("shift_id") and len(shift_id)>#shift_id#</cfif>">
                                        <input type="text" name="shift_name" id="shift_name" readonly="yes" value="<cfif isdefined("shift_name") and len(shift_name)>#shift_name#</cfif>" style="width:175px;" >
                                  </td>
                                    <td width="90"><cf_get_lang_main no='243.Baslama Tarihi'> *</td>
                                    <td width="250">
                                    <cfsavecontent variable="message"><cf_get_lang_main no ='1333.Baslama Tarihi Girmelisiniz'> !</cfsavecontent>
                                        <input required="Yes"  message="#message#" type="text" name="start_date" id="start_date"  validate="eurodate" style="width:75px;" value="#dateformat(attributes.start_date,'DD/MM/YYYY')#"  <cfif alt_plan_control.recordcount>readonly="yes"</cfif>> 
                                       <cf_wrk_date_image date_field="start_date">
                                        <select name="start_h" id="start_h">
                                        <cfloop from="0" to="23" index="i">
                                            <option value="#i#" <cfif isdefined('attributes.start_date') and timeformat(attributes.start_date,'HH') eq i> selected</cfif>><cfif i lt 10>0</cfif>#i#</option>
                                        </cfloop>
                                    </select>
                                    <select name="start_m" id="start_m">
                                        <cfloop from="0" to="59" index="i">
                                            <option value="#i#" <cfif isdefined('attributes.start_date') and timeformat(attributes.start_date,'MM') eq i> selected</cfif>><cfif i lt 10>0</cfif>#i#</option>
                                        </cfloop>
                                    </select>
                                    </td>
                                    <td>&nbsp;</td>
                                    <td><input type="checkbox" name="master_plan_status" <cfif master_plan_status eq 1>checked</cfif> value="1"><cf_get_lang_main no='81.Aktif'></td>
                                </tr>
                                <tr>
                                    <td><cf_get_lang_main no='3346.Planı Ekleyen'>*</td>
                                    <td><input type="hidden" name="shift_employee_id" id="shift_employee_id" readonly="yes" value="<cfif Len(shift_employee_id)>#shift_employee_id#</cfif>">
                                        <input type="text" name="shift_employee" id="shift_employee" value="<cfif Len(shift_employee_id)>#get_emp_info(shift_employee_id,0,0)#</cfif>" style="width:175px;" onFocus="AutoComplete_Create('shift_employee','MEMBER_NAME','MEMBER_NAME','get_member_autocomplete','3','EMPLOYEE_ID','shift_employee_id','','3','125');" autocomplete="off">
                                    
                                    </td>
                                    <td><cf_get_lang_main no='288.Bitis Tarihi'>*</td>
                                    <td>
                                    
                                    <cfsavecontent variable="message"><cf_get_lang_main no='327.Bitis Tarihi girmelisiniz'></cfsavecontent>
                                        <input required="Yes" message="#message#" type="text" name="finish_date" id="finish_date"  style="width:75px;" value="#dateformat(attributes.finish_date,'DD/MM/YYYY')#" <cfif alt_plan_control.recordcount>readonly="yes"</cfif>>
                                       <cf_wrk_date_image date_field="finish_date">
                                        <select name="finish_h" id="finish_h">
                                        <cfloop from="0" to="23" index="i">
                                            <option value="#i#" <cfif isdefined('attributes.finish_date') and timeformat(attributes.finish_date,'HH') eq i> selected</cfif>><cfif i lt 10>0</cfif>#i#</option>
                                        </cfloop>
                                    </select>
                                    <select name="finish_m" id="finish_m">
                                        <cfloop from="0" to="59" index="i">
                                            <option value="#i#"<cfif isdefined('attributes.finish_date') and timeformat(attributes.finish_date,'MM') eq i> selected</cfif>><cfif i lt 10>0</cfif>#i#</option>
                                        </cfloop>
                                    </select> 
                                    </td>
                                    <td><cf_get_lang_main no='4.Proje'></td>
                                    <td>
                                        <input type="hidden" name="project_id" id="project_id" value="#paper_project_id#">
                                        <input type="text" name="project_head" id="project_head" value="<cfif len(paper_project_id)>#GET_PROJECT_NAME(paper_project_id)#</cfif>" style="width:200px;"onFocus="AutoComplete_Create('project_head','PROJECT_ID,PROJECT_HEAD','PROJECT_HEAD','get_project','','PROJECT_ID','project_id','','3','135')"autocomplete="off">
                                <a href="javascript://" onClick="windowopen('#request.self#?fuseaction=objects.popup_list_projects&project_id=add_production_order.project_id&project_head=add_production_order.project_head','list');"><img src="/images/plus_list.gif" align="absmiddle" border="0"></a>					</tr>
                                <tr>
                                    <td><cf_get_lang_main no='468.Belge No'>*</td>
                                    <td>
                                        <input name="paper_number"  type="text"  value="#paper_number#" maxlength="15" style="width:80px;" />						</td>
                                    <td width="75"><cf_get_lang_main no='642.Süreç/Asama'></td>
                    <td width="160"><cf_workcube_process is_upd='0' select_value='#process_stage#' process_cat_width='125' is_detail='1'></td>
                                    <td valign="top"><cf_get_lang_main no='217.Açiklama'></td>
                                    <td rowspan="2"><textarea name="detail" id="detail" style="width:200px;height:50px;">#detail#</textarea></td>				
                                </tr>
                                <tr>
                                    <td><cfoutput>#getLang('ehesap',1326)#</cfoutput></td>
                                    <td>
                                        <select name="get_master_plan_process" style="width:90px">
                                            <option value="1" <cfif get_shift.MASTER_PLAN_PROCESS eq 1>selected</cfif>><cf_get_lang_main no='293.İşleniyor'></option>
                                            <option value="0" <cfif get_shift.MASTER_PLAN_PROCESS eq 0>selected</cfif>><cf_get_lang_main no='3436.İşlem Bitti'></option>
                                        </select>
                                    </td>
                                </tr>
                                <tr>				
                                    <td colspan="5" >
                                        <cfif len(record_id)>
                                            <cf_get_lang_main no='71.Kayit'>: <cfoutput>#get_emp_info(record_id,0,0)# - #dateFormat(record_time,'dd/mm/yyyy')# #timeformat(DateAdd('h',session.ep.time_zone, record_time),'HH:MM')#</cfoutput> 
                                        </cfif>
                                    </td>
                                    <td align="left" >&nbsp;&nbsp;&nbsp;&nbsp;<cfif alt_plan_control.recordcount><cf_workcube_buttons is_upd='1' add_function ='kontrol_shift_tree_info()'is_delete='0'><cfelse><cf_workcube_buttons is_upd='1' add_function ='kontrol_shift_tree_info()' is_delete='0'></cfif></td>
            
                                </tr>
							</table>
							</cfform>
							<cfset _ajax_str_ = "&upd=#upd_id#">
						</td>
					</tr>
        			<cfloop query="get_menu">
            			<tr>
            				<td bgcolor="##FFFFFF">&nbsp;</td>
            			</tr>
                        <tr class="color-row" height="80%">
                            <td valign="top">
                                <table  width="100%" height="99%" cellpadding="2" cellspacing="1"  align="center">
                                    <tr>
                                        <td>
                                            <cfsavecontent variable="message"><font color="black">#MENU_HEAD#</font></cfsavecontent>
                                            <cf_show_ajax page_style="off" table_align="left" title="#message#" tr_id="upd_id_#PROCESS_ID#" page_url="#request.self#?fuseaction=prod.popup_ajax_ezgi_sub_plan&islem_id=#PROCESS_ID##_ajax_str_#">
                                        </td>
                                    </tr>
                                </table>	
                            </td>
                        </tr>
					</cfloop>            
  				</table>
           	</cfoutput>	
		</td>
        <td width="230" valign="top">
              <!--- Varliklar --->
              <cf_get_workcube_asset asset_cat_id="-3" module_id='35' action_section='PRODUCT_TREE' action_id='#attributes.upd_id#'><br>
              <!--- Notlar --->
              <cf_get_workcube_note  company_id="#session.ep.company_id#" action_section='upd_id' action_id='#upd_id#'><br>
              <!--- İç Taleplar --->
              <cfinclude template="list_ezgi_ic_talep.cfm"><br>
              <!---Planlama Oranı--->
              <cfinclude template="master_plan_graph.cfm" ><br>
        </td> 
	</tr>
</table>
<script language="JavaScript">
function kontrol_shift_tree_info()
{
	if(document.getElementById('shift_id').value == "")
	{
		alert("<cf_get_lang_main no='3437.Lütfen Master Plan Adı Seçiniz'> !");
		return false;
	}
	if((document.getElementById('start_date').value != "") && (document.getElementById('finish_date').value != ""))
	return time_check(document.getElementById('start_date'), document.getElementById('start_h'), document.getElementById('start_m'), document.getElementById('finish_date'),  document.getElementById('finish_h'), document.getElementById('finish_m'), "<cf_get_lang_main no='3348.Başlama ve Bitiş Tarihlerini Kontrol Ediniz'> !");
	else
	{alert("<cf_get_lang_main no='3438.Lütfen Başlangıç ve Bitiş Tarihi Giriniz'>");return false;}
	return true;
}
</script>

