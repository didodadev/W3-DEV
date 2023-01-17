<cfsetting showdebugoutput="no">
<cf_get_lang_set module_name="project"><!--- sayfanin en altinda kapanisi var --->
<!--- bu sayfa firsat,service,callcenter,service ,proje ve fiziki varlık detaydan cagirilir... bu dosyaya bagli olarak copy_work.cfm ve del_work.cfm duzenlenmelidir --->
<cfparam name="attributes.priority_cat" default="">
<cfparam name="attributes.currency" default="">
<cfparam name="attributes.keyword_" default="">
<cfparam name="attributes.work_status" default="1">
<cfparam name="attributes.page" default="1">
<cfparam name="attributes.maxrows" default='#session.pp.maxrows#'>
<cfparam name="attributes.startrow" default="1">
<cfparam name="attributes.work_milestones" default="1">

<cfquery name="GET_PRO_WORK" datasource="#DSN#">
	SELECT
    	WORK_ID,
		TYPE,
		MILESTONE_WORK_ID,
		COLOR,
		WORK_HEAD,
        PROJECT_ID,
		EMPLOYEE,
		WORK_PRIORITY_ID,
		PRIORITY,
		STAGE,
		TO_COMPLETE,
        TARGET_FINISH,
        TARGET_START
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
            PW.PROJECT_ID,
            PW.ESTIMATED_TIME,
            (SELECT PTR.STAGE FROM PROCESS_TYPE_ROWS PTR WHERE PTR.PROCESS_ROW_ID= PW.WORK_CURRENCY_ID) STAGE,
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
            PW.WORK_PRIORITY_ID = SP.PRIORITY_ID
            <cfif isDefined('attributes.project_id') and len(attributes.project_id)>
            	AND PW.PROJECT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.project_id#">
			</cfif>
			<cfif len(attributes.keyword_)>
				AND 
				(
					<cfif isNumeric(attributes.keyword_)>
						PW.WORK_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.keyword_#"> OR 
					</cfif>
					PW.WORK_HEAD LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#attributes.keyword_#%">
				)
			</cfif>
			<cfif len(attributes.priority_cat)>
				AND PW.WORK_PRIORITY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.priority_cat#">
			</cfif>
			<cfif len(attributes.currency)>
				AND PW.WORK_CURRENCY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.currency#">
			</cfif>
            <cfif isDefined('attributes.service_id') and len(attributes.service_id)>
				AND PW.SERVICE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.service_id#">
			</cfif>
            <cfif isDefined('attributes.subscription_id') and len(attributes.subscription_id)>
				AND PW.SUBSCRIPTION_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.subscription_id#">
			</cfif>
			<cfif attributes.work_status eq -1>
				AND PW.WORK_STATUS = 0
			<cfelseif attributes.work_status eq 1>
				AND PW.WORK_STATUS = 1
			</cfif>
	)T1
	WHERE
		1=1 
		<cfif attributes.work_milestones eq 0>
			AND IS_MILESTONE <> 1
		</cfif>
	ORDER BY
		<cfif isdefined("attributes.ordertype") and attributes.ordertype eq 2>
			ISNULL(UPDATE_DATE,RECORD_DATE) DESC
		<cfelseif isdefined("attributes.ordertype") and attributes.ordertype eq 3>
			TARGET_START DESC
		<cfelseif isdefined("attributes.ordertype") and attributes.ordertype eq 4>
			TARGET_START
		<cfelseif isdefined("attributes.ordertype") and attributes.ordertype eq 5>
			TARGET_FINISH DESC
		<cfelseif isdefined("attributes.ordertype") and attributes.ordertype eq 6>
			TARGET_FINISH
		<cfelseif isdefined("attributes.ordertype") and attributes.ordertype eq 7>
			WORK_HEAD
		<cfelse>
			WORK_ID DESC
		</cfif>
</cfquery>
<cfparam name="attributes.totalrecords" default='#get_pro_work.recordcount#'> 

<cfset attributes.startrow=((attributes.page-1)*attributes.maxrows)+1>
<cfset work_h_list = ''>
<cfif get_pro_work.recordcount>
	<cfset work_h_list = valuelist(get_pro_work.work_id)>
	<cfquery name="GET_HARCANAN_ZAMAN" datasource="#DSN#">
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
	<cfset work_h_list = listsort(listdeleteduplicates(valuelist(get_harcanan_zaman.work_id,',')),'numeric','ASC',',')>
</cfif>
<cfif isdefined("session.pp.our_company_id")>
	<cfset my_our_comp_ = session.pp.our_company_id>
<cfelseif isdefined("session.ww.our_company_id")>
	<cfset my_our_comp_ = session.ww.our_company_id>
<cfelse>
	<cfset my_our_comp_ = session.ep.company_id>
</cfif>
<cfquery name="GET_PROCURRENCY" datasource="#DSN#">
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
		PTO.OUR_COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#my_our_comp_#"> AND
		PT.FACTION LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%project.works%">
	ORDER BY
		PTR.LINE_NUMBER
</cfquery>
<cfinclude template="../query/get_priority.cfm">
<cfif isDefined('attributes.project_id') and len(attributes.project_id)>
	<cfset this_div_id_ = attributes.project_id>
<cfelse>
	<cfset this_div_id_ = 1>
</cfif>


<div id="project_works_div_<cfoutput>#this_div_id_#</cfoutput>">
<table class="ajax_list" style="width:100%;">
    <tr style="height:25px;">
        <td colspan="16" style="text-align:right; height:25px;">	
            <cfform name="works_#this_div_id_#" method="post" action="">
            	<input type="hidden" name="is_submitted" id="is_submitted" value="1" />
				<cf_get_lang_main no='48.Filtre'>
				<cfif isDefined("attributes.related_project_info")>
					<cfif isDefined('attributes.project_id') and len(attributes.project_id)>
						<cfinput type="text" name="keyword_" id="keyword_" value="#attributes.keyword_#" style="width:100px;" onKeyPress="if(event.keyCode==13 ) {loader_page(#attributes.project_id#); return false;}">
                     <cfelse>
                     	<cfinput type="text" name="keyword_" id="keyword_" value="#attributes.keyword_#" style="width:100px;">
                     </cfif>
				<cfelse>
					<cfinput type="text" name="keyword_" id="keyword_" value="#attributes.keyword_#" style="width:100px;" onKeyPress="if(event.keyCode==13 ) {loader_page(#this_div_id_#); return false;}">
				</cfif>
				<select name="currency" id="currency" style="width:120px; height:17px;">
					<option value=""><cf_get_lang_main no='70.Asama'></option>
					<cfoutput query="get_procurrency">
						<option value="#process_row_id#" <cfif attributes.currency eq process_row_id>selected</cfif>>#stage#</option>
					</cfoutput>
				</select>
				<select name="priority_cat" id="priority_cat" style="width:120px;">
					<option value=""><cf_get_lang_main no='73.Öncelik'></option>
					<cfoutput query="get_cats">
						<option value="#priority_id#" <cfif attributes.priority_cat eq priority_id>selected</cfif>>#priority#</option>
					</cfoutput>
				</select>
				<select name="order_type" id="order_type" style="width:150px;">
					<option value="1" <cfif isdefined("attributes.ordertype") and attributes.ordertype eq 1>selected</cfif>>İş ID ye Göre Azalan</option>                     
					<option value="2" <cfif isdefined("attributes.ordertype") and attributes.ordertype eq 2>selected</cfif>>Güncellemeye Göre Azalan</option>
					<option value="3" <cfif isdefined("attributes.ordertype") and attributes.ordertype eq 3>selected</cfif>>Başlangıç Tarihine Göre Azalan</option>
					<option value="4" <cfif isdefined("attributes.ordertype") and attributes.ordertype eq 4>selected</cfif>>Başlangıç Tarihine Göre Artan</option>
					<option value="5" <cfif isdefined("attributes.ordertype") and attributes.ordertype eq 5>selected</cfif>>Bitiş Tarihine Göre Azalan</option>
					<option value="6" <cfif isdefined("attributes.ordertype") and attributes.ordertype eq 6>selected</cfif>>Bitiş Tarihine Göre Artan</option>
					<option value="7" <cfif isdefined("attributes.ordertype") and attributes.ordertype eq 7>selected</cfif>>İş Başlığına Göre Alfabetik</option>
				</select>
                <cfif isDefined('attributes.is_work_milestones') and attributes.is_work_milestones eq 1>
                    <select name="work_milestones" id="work_milestones" style="width:120px;">
                        <option value="1" <cfif attributes.work_milestones eq 1>selected="selected"</cfif>>Milestonelar Dahil</option>
                        <option value="0" <cfif attributes.work_milestones eq 0>selected="selected"</cfif>>Milestonlar Hariç</option>
                    </select>
                </cfif>
				<select name="work_status" id="work_status">
					<option value="1" <cfif attributes.work_status eq 1>selected="selected"</cfif>><cf_get_lang_main no='81.Aktif'></option>
					<option value="-1" <cfif attributes.work_status eq -1>selected="selected"</cfif>><cf_get_lang_main no='82.Pasif'></option>
					<option value="0" <cfif attributes.work_status eq 0>selected="selected"</cfif>><cf_get_lang_main no='296.Tümü'></option>
				</select>
                <cfsavecontent variable="message"><cf_get_lang_main no='125.Sayi_Hatasi_Mesaj'></cfsavecontent>
                <cfinput type="text" name="maxrows" id="maxrows" value="#attributes.maxrows#" required="yes" validate="integer" range="1,999" message="#message#" maxlength="3" style="width:25px;text-align:right;">
				<cfsavecontent variable="search"><cf_get_lang_main no ='153.Ara'></cfsavecontent>
				<input type="button" value="Ara"  name="project_submit_button" id="project_submit_button" onclick="loader_page2('<cfif isdefined("attributes.project_id") and len(attributes.project_id)><cfoutput>#attributes.project_id#</cfoutput></cfif>');">
            </cfform>
        </td>
    </tr>
    <tr class="color-header" style="height:22px;">
        <th class="form-title" style="width:15px;"><cf_get_lang_main no='75.No'></th>
        <th class="form-title"><cf_get_lang no='93.İş'></th>
        <th class="form-title" style="width:110px;"><cf_get_lang_main no='157.Görevli'></th>
        <th class="form-title" style="width:40px;"><cf_get_lang_main no='73.Öncelik'></th>
        <th class="form-title" style="width:80px;"><cf_get_lang_main no='1457.Planlanan'></th>
        <th class="form-title" style="width:80px;"><cf_get_lang no='334.Gerçekleşen'> </th>
        <th class="form-title" style="width:50px;"><cf_get_lang_main no='70.Aşama'></th>
        <!---<th style="width:60px;"><cf_get_lang no='95.Ongorulen süre'></th>
        <th style="width:60px;"><cf_get_lang no='8.harcanan süre'></th>
        <th style="width:25px;">%<!--- Yuzde ---></th>--->
        <th class="form-title" style="width:15px;"><!--- Malzeme ---></th>
        <cfif isdefined('attributes.is_rel_add_work') and (attributes.is_rel_add_work eq 2 or attributes.is_rel_add_work eq 3)><td style="width:15px;"><a href="javascript://" onclick="windowopen('<cfoutput>#request.self#?fuseaction=objects2.popup_addwork<cfif isDefined('attributes.project_id') and len(attributes.project_id)>&project_id=#attributes.project_id#</cfif><cfif isDefined('attributes.is_rel_stage_cat') and len(attributes.is_rel_stage_cat)>&is_rel_stage_cat=#attributes.is_rel_stage_cat#</cfif></cfoutput>','medium');"><img src="/images/plus_list.gif" border="0" title="Projeye İş Ekle"></a></td></cfif>
    </tr>	
	<cfif get_pro_work.recordcount>
		<cfoutput query="get_pro_work" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">
           <tr>
                <td>#currentrow#</td>
                <td>
                    <a href="javascript://" class="tableyazi" onclick="windowopen('#request.self#?fuseaction=objects2.popup_updwork&project_id=#project_id#&work_id=#encrypt(work_id,"WORKCUBE","BLOWFISH","Hex")#<cfif isdefined('attributes.is_file_upload_size')>&is_file_upload_size=#attributes.is_file_upload_size#</cfif><cfif isDefined('attributes.is_related_work') and len(attributes.is_related_work)>&is_related_work=#attributes.is_related_work#</cfif><cfif isDefined('attributes.is_real_dates') and len(attributes.is_real_dates)>&is_real_dates=#attributes.is_real_dates#</cfif><cfif isDefined('attributes.is_rel_stage_cat') and len(attributes.is_rel_stage_cat)>&is_rel_stage_cat=#attributes.is_rel_stage_cat#</cfif>','project');">
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
                    <cfset fdate_plan=date_add("h",session.pp.time_zone,target_finish)>
                <cfelse>
                    <cfset fdate_plan=''>
                </cfif>
                <cfif isdefined('target_start') and len(target_start)>
                    <cfset sdate_plan=date_add("h",session.pp.time_zone,target_start)>
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
                <cfif isdefined('real_finish') and len(real_finish)>
                    <cfset fdate=date_add("h",session.pp.time_zone,real_finish)>
                <cfelse>
                    <cfset fdate=''>
                </cfif>
                <cfif isdefined('real_start') and len(real_start)>
                    <cfset sdate=date_add("h",session.pp.time_zone,real_start)>
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
                <!---<td>
                    <cfif isdefined('estimated_time') and len(estimated_time)>
                        <cfset liste=estimated_time/60>
                        <cfset saat=listfirst(liste,'.')>
                        <cfset dak=estimated_time-saat*60>
                        #saat# saat #dak# dk
                    </cfif>
                </td>
                <td>
                    <cfif listfindnocase(work_h_list,work_id)>
                        <cfset harcanan_ = get_harcanan_zaman.harcanan_dakika[listfind(work_h_list,work_id,',')]>
                        <cfset liste=harcanan_/60>
                        <cfset saat=listfirst(liste,'.')>
                        <cfset dak=harcanan_-saat*60>
                        #saat# saat #dak# dk
                    </cfif>
                </td>
                <td>
                <!--- Yuzde --->
                    <div id="complate_ratio_div#work_id#" ></div> <!---style="display:none"--->
                    <input type="text" name="is_complate#work_id#" id="is_complate#work_id#" onkeyup="isNumber(this);" class="box" style="width:100%" maxlength="3" value="<cfif len(to_complete)>#to_complete#<cfelse>-</cfif>">
                </td>--->
                <td><!--- Malzeme --->
                    <cfif not listfindnocase(denied_pages,'project.popup_add_project_material') and isDefined("attributes.related_project_info")>
                        <cfif len(pro_material_id)>
                            <a href="javascript://" onclick="windowopen('#request.self#?fuseaction=project.popup_upd_project_material&upd_id=#pro_material_id#','wide');"> <img src="/images/list_ship.gif" border="0" title="<cf_get_lang no ='206.Malzeme'>"></a>
                        <cfelse>
                            <a href="javascript://" onclick="windowopen('#request.self#?fuseaction=project.popup_add_project_material&id=#project_id#&work_id=#work_id#','wide');"> <img src="/images/list_ship.gif" border="0" title="<cf_get_lang no ='206.Malzeme'>"></a>
                        </cfif>
                    </cfif>
                </td>
				<cfif isdefined('attributes.is_rel_add_work') and (attributes.is_rel_add_work eq 1 or attributes.is_rel_add_work eq 3)><td><a href="javascript://" onclick="windowopen('#request.self#?fuseaction=objects2.popup_addwork&project_id=#project_id#&work_id=#work_id#<cfif isDefined('attributes.is_rel_stage_cat') and len(attributes.is_rel_stage_cat)>&is_rel_stage_cat=#attributes.is_rel_stage_cat#</cfif>','medium');"><img src="/images/plus_list.gif" border="0" title="<cf_get_lang no ='5.İş Ekle'>"></a></td></cfif>
            </tr> 
        </cfoutput> 
	<cfelse>
		<tr>
			<td colspan="16"><cfif isDefined('attributes.is_submitted')><cf_get_lang_main no='72.Kayıt Yok'> !<cfelse>Filtre Ediniz!</cfif></td>
		</tr>
	</cfif>
</table>
<table style="width:100%;">
	<tr> 
		<td>
			<cfif attributes.totalrecords gt attributes.maxrows> 
                <table style="width:100%;">
                    <tr> 																																																							
                        <td>		
                        <cfset adres = "">
                        <cfset adres = "#adres#">
                        <cfif isdefined('attributes.project_id')>
                            <cfset adres = "#adres#&project_id=#attributes.project_id#">
                        </cfif>
                        <cfif isdefined('attributes.is_submitted')>
                            <cfset adres = "#adres#&is_submitted=1">
                        </cfif>
                        <cfif len(attributes.currency)>
                            <cfset adres = "#adres#&currency=#attributes.currency#"> 
                        </cfif>
                        <cfif len(attributes.priority_cat)>
                            <cfset adres = "#adres#&priority_cat=#attributes.priority_cat#">
                        </cfif>
                        <cfif len(attributes.startrow)>
                            <cfset adres = "#adres#&startrow=#attributes.startrow#">
                        </cfif>
                        <cfif len(attributes.maxrows)>
                            <cfset adres = "#adres#&maxrows=#attributes.maxrows#">
                        </cfif>
                        <cfif len(attributes.work_status)>
                            <cfset adres = "#adres#&work_status=#attributes.work_status#">
                        </cfif>
                        <cfif isdefined("attributes.process_stage") and len(attributes.process_stage)>
                            <cfset adres = "#adres#&process_stage=#attributes.process_stage#">
                        </cfif>
                        <cfif isdefined("attributes.status") and len(attributes.status)>
                            <cfset adres = "#adres#&status=#attributes.status#">
                        </cfif>
                        <cfif isdefined("attributes.ordertype") and len(attributes.ordertype)>
                            <cfset adres = "#adres#&ordertype=#attributes.ordertype#">
                        </cfif>
                        <cfif isdefined("attributes.work_milestones") and len(attributes.work_milestones)>
                            <cfset adres = "#adres#&work_milestones=#attributes.work_milestones#">
                        </cfif>
                        <cfif isdefined("attributes.is_work_milestones") and len(attributes.is_work_milestones)>
                            <cfset adres = "#adres#&is_work_milestones=#attributes.is_work_milestones#">
                        </cfif>
                        <cfif isdefined('attributes.is_add_work') and attributes.is_add_work eq 1>
                            <cfset adres = "#adres#&is_add_work=#attributes.is_add_work#">
                        </cfif>
                        <cfif isdefined('attributes.keyword_') and len(attributes.keyword_)>
                            <cfset adres = "#adres#&keyword_=#attributes.keyword_#">
                        </cfif>
                        <cfif isDefined('attributes.project_id')>
                        	<cf_pages page="#attributes.page#" 
                                maxrows="#attributes.maxrows#"
                                totalrecords="#get_pro_work.recordcount#"
                                startrow="#attributes.startrow#"
                                isAjax=true      
                                target="project_works_div_#attributes.project_id#"
                                adres="objects2.emptypopup_ajax_project_works#adres#">
                        </cfif>
						</td>
 			<!-- sil --><td style="text-align:right;"><cfoutput><cf_get_lang_main no='128.Toplam Kayıt'>:#attributes.totalrecords#&nbsp;-&nbsp;<cf_get_lang_main no='169.Sayfa'>:#attributes.page#/#lastpage#</cfoutput></td><!-- sil -->  
					</tr>
				</table>
			</cfif> 
		</td>
	</tr>
</table>
</div>
<script type="text/javascript">
	function loader_page2(_x_)
	{    
		adress_ = '<cfoutput>#request.self#?fuseaction=objects2.emptypopup_ajax_project_works&is_submitted=1<cfif isdefined("attributes.service_id")>&service_id=#attributes.service_id#</cfif><cfif isdefined("attributes.project_id")>&project_id=#attributes.project_id#</cfif></cfoutput>&currency='+document.getElementById('currency').value+'&keyword_='+document.getElementById('keyword_').value+'&priority_cat='+document.getElementById('priority_cat').value+'&work_status='+document.getElementById('work_status').value+'<cfif isDefined('attributes.is_work_milestones') and attributes.is_work_milestones eq 1>&work_milestones='+document.getElementById('work_milestones').value+'</cfif>&ordertype='+document.getElementById('order_type').value+'&maxrows='+document.getElementById('maxrows').value+'';
		AjaxPageLoad(adress_,'project_works_div_<cfoutput>#this_div_id_#</cfoutput>',1);
		return false;
		 //  'project_works_div_'+_x_+'
	}
	function loader_page()
	{
		document.getElementById('project_submit_button').click();
	}
</script> 
<cf_get_lang_set module_name="#lcase(listgetat(attributes.fuseaction,1,'.'))#"><!--- sayfanin en ustunde acilisi var ---> 
