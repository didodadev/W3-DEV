<cf_xml_page_edit fuseact="objects.popup_list_projects">
<cfset url_string = "">
<cfif isdefined("attributes.project_head")>
	<cfset url_string = "#url_string#&project_head=#attributes.project_head#">
</cfif>
<cfif isdefined("attributes.pro_employee_id")>
	<cfset url_string = "#url_string#&pro_employee_id=#attributes.pro_employee_id#">
</cfif>
<cfif isdefined("attributes.pro_employee")>
	<cfset url_string = "#url_string#&pro_employee=#attributes.pro_employee#">
</cfif>
<cfif isdefined("attributes.function_name")>
	<cfset url_string = "#url_string#&function_name=#attributes.function_name#">
</cfif>
<cfif isdefined("attributes.function_param")>
	<cfset url_string = "#url_string#&function_param=#attributes.function_param#">
</cfif>
<cfif isdefined("attributes.project_id")>
	<cfset url_string = "#url_string#&project_id=#project_id#">
</cfif>
<cfif isdefined("attributes.sdate")>
	<cfset url_string = "#url_string#&sdate=#sdate#">
</cfif>
<cfif isdefined("attributes.fdate")>
	<cfset url_string = "#url_string#&fdate=#fdate#">
</cfif>
<cfif isdefined("attributes.p_sdate")>
	<cfset url_string = "#url_string#&p_sdate=#p_sdate#">
</cfif>
<cfif isdefined("attributes.p_fdate")>
	<cfset url_string = "#url_string#&p_fdate=#p_fdate#">
</cfif>
<cfif isdefined("attributes.company_id")>
	<cfset url_string = "#url_string#&company_id=#company_id#">
</cfif>
<cfif isdefined("attributes.consumer_id")>
	<cfset url_string = "#url_string#&consumer_id=#consumer_id#">
</cfif>
<cfif isdefined("attributes.call_function")>
	<cfset url_string = "#url_string#&call_function=#call_function#">
</cfif>
<cfif isdefined("attributes.company_name")>
	<cfset url_string = "#url_string#&company_name=#company_name#">
</cfif>
<cfif isdefined("attributes.company_name2")>
	<cfset url_string = "#url_string#&company_name2=#company_name2#">
</cfif>
<cfif isdefined("attributes.partner_id")>
	<cfset url_string = "#url_string#&partner_id=#partner_id#">
</cfif>
<cfif isdefined("attributes.partner_name")>
	<cfset url_string = "#url_string#&partner_name=#partner_name#">
</cfif>
<cfif isdefined("attributes.workgroup_id")>
	<cfset url_string = "#url_string#&workgroup_id=#workgroup_id#">
</cfif>
<!--- proje baglanti odeme yontemi bilgileri --->
<cfif isdefined("attributes.paymethod")>
	<cfset url_string = "#url_string#&paymethod=#attributes.paymethod#">
</cfif>
<cfif isdefined("attributes.paymethod_id")>
	<cfset url_string = "#url_string#&paymethod_id=#attributes.paymethod_id#">
</cfif>
<cfif isdefined("attributes.card_paymethod_id")>
	<cfset url_string = "#url_string#&card_paymethod_id=#attributes.card_paymethod_id#">
</cfif>
<cfif isdefined("attributes.dueday")>
	<cfset url_string = "#url_string#&dueday=#attributes.dueday#">
</cfif>
<cfif isdefined("attributes.commission_rate")>
    <cfset url_string = "#url_string#&commission_rate=#attributes.commission_rate#">
</cfif>
<cfif isdefined("attributes.paymethod_vehicle")>
   <cfset url_string = "#url_string#&paymethod_vehicle=#attributes.paymethod_vehicle#">
</cfif>

<cfif isdefined("attributes.is_empty_project")>
	<cfset url_string = "#url_string#&is_empty_project=#is_empty_project#">
</cfif>
<cfif isdefined("session.joins_old")>
	<cfscript>
		structdelete(session,"joins_old");
	</cfscript>
</cfif>
<cfif isdefined("session.specs_old")>
	<cfscript>
		structdelete(session,"specs_old");
	</cfscript>
</cfif>
<cfif isdefined("attributes.multi")>
	<cfset url_string = "#url_string#&multi=1">
</cfif>

<cfparam name="attributes.is_form_submitted" default="0">
<cfparam name="attributes.keyword" default="">
<cfparam name="attributes.currency" default="">
<cfparam name="attributes.priority_cat" default="">
<cfparam name="attributes.project_cat" default="">
<cfquery name="GET_PROJECT_CAT" datasource="#DSN#">
	SELECT
	   DISTINCT 
	   SMC.MAIN_PROCESS_CAT_ID,
	   SMC.MAIN_PROCESS_CAT
	FROM 
	   SETUP_MAIN_PROCESS_CAT SMC,
	   SETUP_MAIN_PROCESS_CAT_ROWS SMR,
	   EMPLOYEE_POSITIONS
	WHERE
	   SMC.MAIN_PROCESS_CAT_ID=SMR.MAIN_PROCESS_CAT_ID AND
       (EMPLOYEE_POSITIONS.POSITION_CAT_ID=SMR.MAIN_POSITION_CAT_ID OR 
	   	EMPLOYEE_POSITIONS.POSITION_CODE=SMR.MAIN_POSITION_CODE)
</cfquery>
<cfif not isDefined("attributes.project_status") and xml_project_status eq 1>
	<cfparam name="attributes.project_status" default="1"><!--- Aktif projeler --->
</cfif>
<cfif isdefined("attributes.is_form_submitted")>
	<cfinclude template="../project/query/get_projects_list.cfm">
	<cfparam name="attributes.totalrecords" default="#get_projects.recordcount#">
<cfelse>
	<cfparam name="attributes.totalrecords" default="0">
</cfif>
<cfparam name="attributes.page" default=1>
<cfset attributes.startrow=((attributes.page-1)*attributes.maxrows)+1>
<cfform name="search" action="#request.self#?fuseaction=#attributes.fuseaction##url_string#" method="post">
	<input type="hidden" name="is_form_submitted" id="is_form_submitted" value="1">
    <table cellpadding="0" cellspacing="0" align="center" class="color-border" style="width:98%; height:35px;">
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
                <cfif isDefined('session.pp.userid')>
                    PTO.OUR_COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.pp.our_company_id#"> AND
                </cfif>
                PT.FACTION LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%objects.popup_list_projects%">
            ORDER BY
                PTR.LINE_NUMBER
        </cfquery>
        <cfinclude template="../../objects/query/get_priority.cfm">
		<tr>
            <td class="headbold">Projeler</td>
            <td>
                <table style="text-align:right;">
                    <tr>
                        <td><cf_get_lang_main no='48.Filtre'>
                            <cfinput type="text" name="keyword" style="width:90px;" value="#attributes.keyword#" maxlength="50">
                            <select name="project_cat" id="project_cat" style="width:160px;">
                                <option value=""><cf_get_lang_main no='74.Kategori Seçiniz'></option>
                                <cfoutput query="get_project_cat">
                                    <option value="#main_process_cat_id#"<cfif isdefined("attributes.project_cat") and (attributes.project_cat is main_process_cat_id)>selected</cfif>>#main_process_cat# 
                                </cfoutput>
                            </select>  
                            <select name="priority_cat" id="priority_cat" style="width:70px;">
                                <option value=""><cf_get_lang_main no='73.Öncelik'></option>
                                <cfoutput query="get_cats">
                                    <option value="#priority_id#"<cfif isDefined("attributes.priority_cat") and (attributes.priority_cat is priority_id)>selected</cfif>>#priority# 
                                </cfoutput>
                            </select>
                            <select name="currency" id="currency" style="width:85px;" class="formthin">
                                <option value="" selected><cf_get_lang_main no='70.Aşama'>
                                <cfoutput query="get_procurrency">
                                    <option value="#process_row_id#"<cfif isDefined("attributes.currency") and (attributes.currency eq process_row_id)>selected</cfif>>#stage#</option>
                                </cfoutput>
                            </select>
                            <cfif xml_project_status eq 1>
                            <select name="project_status" id="project_status" style="width:50px;" class="formthin">
                                <option value="0" <cfif isDefined("attributes.project_status") and (attributes.project_status eq 0)>selected</cfif>><cf_get_lang_main no='296.Tümü'>
                                <option value="1" <cfif isDefined("attributes.project_status") and (attributes.project_status eq 1)>selected</cfif>><cf_get_lang_main no='81.Aktif'></option>
                                <option value="-1" <cfif isDefined("attributes.project_status") and (attributes.project_status eq -1)>selected</cfif>><cf_get_lang_main no='82.Pasif'></option>
                            </select>
                            </cfif>
                            <cfsavecontent variable="message"><cf_get_lang_main no='125.Sayi_Hatasi_Mesaj'></cfsavecontent>
                            <cfinput type="text" name="maxrows" value="#attributes.maxrows#" required="yes" onKeyUp="isNumber(this)" validate="integer" range="1,999" message="#message#" maxlength="3" style="width:25px;">
                        </td>
                        <td>
                            <cf_wrk_search_button>
                         </td>
                    </tr>
            	</table>
            </td>
        </tr>
    </table>
</cfform>
<table border="0" align="center" cellpadding="0" cellspacing="0" style="width:98%;">
	<thead>
        <tr class="color-header" style="height:22px;">
            <th class="form-title"><cf_get_lang_main no='75.No'></th>
            <th class="form-title"><cf_get_lang_main no='4.Proje'></th>
            <th class="form-title"><cf_get_lang_main no='74.Kategori'></th>
            <th class="form-title"><cf_get_lang_main no='157.Görevli'></th>
            <th class="form-title"><cf_get_lang_main no='73.Öncelik'></th>
            <th class="form-title"><cf_get_lang_main no='89.Başlama'> </th>
            <th class="form-title"><cf_get_lang_main no='90.Bitiş'></th>
            <th class="form-title"><cf_get_lang_main no='70.Aşama'></th>
        </tr>
    </thead>
	<tbody>
		<cfif xml_show_without_project_choice>
			<tr class="color-row">
				<td height="20">&nbsp;</td>
				<td colspan="7"><a href="javascript://" onClick="add_pro(<cfif isdefined("attributes.is_empty_project")>'-1'<cfelse>''</cfif>,'','Projesiz','','','','','','','');" class="tableyazi"><cf_get_lang_main no='1047.Projesiz'></a> (<cf_get_lang no='363.Herhangi bir projeye dahil edilmeyen işler için'>)</td>
			</tr>
		</cfif>
		<cfif get_projects.recordcount>
			<cfset partner_list = "">
			<cfset company_list = "">
			<cfset consumer_list = "">
			<cfset outsrc_partner_list = "">
			<cfset project_emp_list = "">
			<cfset priority_list = "">
			<cfset project_stage_list = "">
			<cfset project_category_list = "">
			<cfoutput query="get_projects" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">
				<cfif len(partner_id) and not listfind(partner_list,partner_id)>
					<cfset partner_list=listappend(partner_list,partner_id)>
				</cfif>
				<cfif len(company_id) and not listfind(company_list,company_id)>
					<cfset company_list=listappend(company_list,company_id)>
				</cfif>
				<cfif len(consumer_id) and not listfind(consumer_list,consumer_id)>
					<cfset consumer_list=listappend(consumer_list,consumer_id)>
				</cfif>
				<cfif len(outsrc_partner_id) and not listfind(outsrc_partner_list,outsrc_partner_id)>
					<cfset outsrc_partner_list=listappend(outsrc_partner_list,outsrc_partner_id)>
				</cfif>
				<cfif len(project_emp_id) and not listfind(project_emp_list,project_emp_id)>
					<cfset project_emp_list=listappend(project_emp_list,project_emp_id)>
				</cfif>
				<cfif len(pro_priority_id) and not listfind(priority_list,pro_priority_id)>
					<cfset priority_list=listappend(priority_list,pro_priority_id)>
				</cfif>
				<cfif len(pro_currency_id) and not listfind(project_stage_list,pro_currency_id)>
					<cfset project_stage_list=listappend(project_stage_list,pro_currency_id)>
				</cfif>
				<cfif len(process_cat) and not listfind(project_category_list,process_cat)>
					<cfset project_category_list=listappend(project_category_list,process_cat)>
				</cfif>
			</cfoutput>
			<cfif len(partner_list)>
				<cfset partner_list=listsort(partner_list,"numeric","ASC",",")>
				<cfquery name="get_part" datasource="#dsn#">
					SELECT
						PARTNER_ID,
						<cfif (database_type is 'MSSQL')>
							COMPANY_PARTNER_NAME +' '+ COMPANY_PARTNER_SURNAME AS PARTNER_NAME
						<cfelseif (database_type is 'DB2')>
							COMPANY_PARTNER_NAME ||' '|| COMPANY_PARTNER_SURNAME AS PARTNER_NAME
						</cfif>
					FROM
						COMPANY_PARTNER
					WHERE
						PARTNER_ID IN (#partner_list#)
					ORDER BY
						PARTNER_ID
				</cfquery>
				<cfset partner_list = listsort(listdeleteduplicates(valuelist(get_part.partner_id,',')),'numeric','ASC',',')>
			</cfif>
			<cfif len(company_list)>
				<cfset company_list=listsort(company_list,"numeric","ASC",",")>
				<cfquery name="get_comp" datasource="#dsn#">
					SELECT COMPANY_ID, FULLNAME FROM COMPANY WHERE COMPANY_ID IN (#company_list#) ORDER BY COMPANY_ID
				</cfquery>
				<cfset company_list = listsort(listdeleteduplicates(valuelist(get_comp.company_id,',')),'numeric','ASC',',')>
			</cfif>
			<cfif len(consumer_list)>
				<cfset consumer_list=listsort(consumer_list,"numeric","ASC",",")>
				<cfquery name="GET_CONS" datasource="#DSN#">
					SELECT
						CONSUMER_ID,
						<cfif (database_type is 'MSSQL')>
							(CONSUMER_NAME +' '+ CONSUMER_SURNAME) AS COMPANY_NAME
						<cfelseif (database_type is 'DB2')>
							(CONSUMER_NAME ||' '|| CONSUMER_SURNAME) AS COMPANY_NAME
						</cfif>
					FROM
						CONSUMER
					WHERE
						CONSUMER_ID IN (#consumer_list#)
					ORDER BY
						CONSUMER_ID
				</cfquery>
				<cfset consumer_list = listsort(listdeleteduplicates(valuelist(get_cons.consumer_id,',')),'numeric','ASC',',')>
			</cfif>
			<cfif len(outsrc_partner_list)>
				<cfset outsrc_partner_list=listsort(outsrc_partner_list,"numeric","ASC",",")>
				<cfquery name="GET_COMPANY_PARTNERS" datasource="#DSN#">
					SELECT
						PARTNER_ID,
						COMPANY_PARTNER_NAME AS PARTNER_NAME,
						COMPANY_PARTNER_SURNAME AS PARTNER_SURNAME,
						COMPANY_PARTNER_EMAIL PARTNER_EMAIL
					FROM
						COMPANY_PARTNER
					WHERE
						PARTNER_ID  IN (#outsrc_partner_list#) 
					ORDER BY 
						PARTNER_ID
				</cfquery>
				<cfset outsrc_partner_list = listsort(listdeleteduplicates(valuelist(get_company_partners.partner_id,',')),'numeric','ASC',',')>
			</cfif>
			<cfif len(project_emp_list)>
				<cfset project_emp_list=listsort(project_emp_list,"numeric","ASC",",")>
				<cfquery name="GET_EMP" datasource="#DSN#">
					SELECT
						EMPLOYEE_ID,
						EMPLOYEE_NAME,
						EMPLOYEE_SURNAME,
						EMPLOYEE_EMAIL
					FROM
						EMPLOYEES
					WHERE
						EMPLOYEE_ID IN (#project_emp_list#)
					ORDER BY
						EMPLOYEE_ID
				</cfquery>
				<cfset project_emp_list = listsort(listdeleteduplicates(valuelist(get_emp.employee_id,',')),'numeric','ASC',',')>
			</cfif>
			<cfif len(priority_list)>
				<cfset priority_list=listsort(priority_list,"numeric","ASC",",")>
				<cfquery name="GET_PRIO" datasource="#DSN#">
					SELECT PRIORITY_ID,PRIORITY FROM SETUP_PRIORITY WHERE PRIORITY_ID IN (#priority_list#) ORDER BY PRIORITY_ID
				</cfquery>
				<cfset priority_list = listsort(listdeleteduplicates(valuelist(get_prio.priority_id,',')),'numeric','ASC',',')>
			</cfif>
			<cfif len(project_stage_list)>
				<cfset project_stage_list = listsort(project_stage_list,'numeric','ASC',',')>
				<cfquery name="GET_CURRENCY_NAME" datasource="#DSN#">
					SELECT PROCESS_ROW_ID,STAGE FROM PROCESS_TYPE_ROWS WHERE PROCESS_ROW_ID IN (#project_stage_list#) ORDER BY PROCESS_ROW_ID
				</cfquery>
				<cfset project_stage_list = listsort(listdeleteduplicates(valuelist(get_currency_name.process_row_id,',')),'numeric','ASC',',')>
			</cfif>
			<cfif len(project_category_list)>
				<cfset project_category_list = listsort(project_category_list,'numeric','ASC',',')>
				<cfquery name="GET_CATEGORY_NAME" datasource="#DSN#">
					SELECT MAIN_PROCESS_CAT_ID, MAIN_PROCESS_CAT FROM SETUP_MAIN_PROCESS_CAT WHERE MAIN_PROCESS_CAT_ID IN (#project_category_list#) ORDER BY MAIN_PROCESS_CAT_ID
				</cfquery>
				<cfset project_category_list = listsort(listdeleteduplicates(valuelist(get_category_name.main_process_cat_id,',')),'numeric','ASC',',')>
			</cfif>
		</cfif>
		<cfif get_projects.recordcount>
			<cfoutput query="get_projects" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">
				<cfif len(company_list)>
					<cfset company_name = get_comp.fullname[listfind(company_list,company_id,',')]>
				<cfelseif len(consumer_list)>
					<cfset company_name = get_cons.company_name[listfind(consumer_list,consumer_id,',')]>
				<cfelse>
					<cfset company_name = ''>
				</cfif>
				<cfif len(partner_list)>
					<cfset partner_name = get_part.partner_name[listfind(partner_list,partner_id,',')]>
				<cfelse>
					<cfset partner_name = ''>
				</cfif>
				<cfset sdate=dateformat(target_start,"dd/mm/yyyy")>
				<cfset fdate=dateformat(target_finish,"dd/mm/yyyy")>
				<cfset p_sdate=dateformat(target_start,"dd/mm/yyyy")>
				<cfset p_fdate=dateformat(target_finish,"dd/mm/yyyy")>
				<cfset project_head_ = replace(project_head,"'"," ","all")>
				<cfset project_head_ = replace(project_head_,'"','','all')>
				<cfset company_name_ = Replace(company_name,"'","","all")>
				<cfset partner_name_ = Replace(partner_name,"'","","all")>
				<tr>
					<td>#project_number#</td>
					<td><a href="javascript://" onClick="add_pro('#project_id#','#company_id#','#project_head_#','#sdate#','#fdate#','#p_sdate#','#p_fdate#','#consumer_id#','#company_name_#','#partner_id#','#partner_name_#','#workgroup_id#','#project_emp_id#','#pro_employee#','','<!---#PAYMETHOD_ID#--->','<!---#CARD_PAYMETHOD_ID#--->','<!---#PAYMENT_DUEDAY#--->','<!---#commission_rate#--->','<!---#PAYMENT_VEHICLE#--->')" class="tableyazi"><font color="#color#">#project_head#</font></a></td>
					<td><cfif len(project_category_list)>#get_category_name.main_process_cat[listfind(project_category_list,process_cat,',')]#</cfif></td>
					<td><cfif len(project_emp_list)>
							<a href="mailto:#get_emp.employee_email[listfind(project_emp_list,project_emp_id,',')]#" class="tableyazi"><font color="#color#">#get_emp.employee_name[listfind(project_emp_list,project_emp_id,',')]# #get_emp.employee_surname[listfind(project_emp_list,project_emp_id,',')]#</font></a>
						<cfelseif len(outsrc_partner_list)>
							<a href="mailto:#get_company_partners.partner_email[listfind(outsrc_partner_list,outsrc_partner_id,',')]#" class="tableyazi"><font color="#color#">#get_company_partners.partner_name[listfind(outsrc_partner_list,outsrc_partner_id,',')]# #get_company_partners.partner_surname[listfind(outsrc_partner_list,outsrc_partner_id,',')]#</font></a>
						</cfif>
					</td>
					<td><cfif len(priority_list)>
							<font color="#color#">#get_prio.priority[listfind(priority_list,pro_priority_id,',')]#</font>
						</cfif>
					</td>
					<td>#sdate#</td>
					<td>#fdate#</td>
					<td><font color="#color#">#get_currency_name.stage[listfind(project_stage_list,pro_currency_id,',')]#</font></td>
				</tr>
			</cfoutput>
		<cfelse>
			<tr>
				<td colspan="8">
					<cfif isdefined("attributes.is_form_submitted") and attributes.is_form_submitted eq 1><cf_get_lang_main no='72.Kayıt Yok'><cfelse><cf_get_lang_main no='289.Filtre Ediniz'></cfif>!</td>
			</tr>
		</cfif>
	</tbody>
<!---<cf_popup_box_footer>
	<cfif attributes.totalrecords gt attributes.maxrows>
		<cfif len(attributes.priority_cat)>
			<cfset url_string = "#url_string#&priority_cat=#priority_cat#">
		</cfif>
		<cfif len(attributes.project_cat)>
			<cfset url_string = "#url_string#&project_cat=#project_cat#">
		</cfif>
		<cfif isdefined("attributes.form_varmi")>
			<cfset url_string = "#url_string#&form_varmi=#attributes.form_varmi#" >
		</cfif>
		<cfif isdefined("attributes.project_status")>
			<cfset url_string = "#url_string#&project_status=#attributes.project_status#" >
		</cfif>
		<table cellpadding="0" cellspacing="0" border="0" align="center" width="99%" height="30">
			<tr>
				<td> 
					<cf_pages page="#attributes.page#"
						maxrows="#attributes.maxrows#"
						totalrecords="#attributes.totalrecords#"
						startrow="#attributes.startrow#"
						adres="objects.popup_list_projects&keyword=#attributes.keyword#&currency=#attributes.currency#&PRIORITY_CAT=#attributes.PRIORITY_CAT##url_string#">
				</td>
				<!-- sil -->
				<td style="text-align:right;"><cfoutput><cf_get_lang_main no='128.Toplam Kayıt'>:#get_projects.recordcount#&nbsp;-&nbsp;<cf_get_lang_main no='169.Sayfa'>:#attributes.page#/#lastpage#</cfoutput></td>
				<!-- sil -->
			</tr>
		</table>
	</cfif>
</cf_popup_box_footer> --->
<script type="text/javascript">
	document.getElementById('keyword').focus();
	<cfif not isdefined('attributes.is_form_submitted')>
		var str_prod_control=0;
		if(window.opener.document.form_basket!=undefined && opener.document.form_basket.basket_id!= undefined  && opener.document.form_basket.project_id!=undefined && opener.document.form_basket.project_id.value!='' && opener.document.form_basket.project_head!=undefined && opener.document.form_basket.project_head.value!='' )
		{
			if(window.opener.document.form_basket.product_id!=undefined && opener.document.form_basket.product_id.value!='' )
				str_prod_control=1;
			else if(window.opener.document.form_basket.product_id!=undefined && window.opener.document.form_basket.product_id.length > 1)
			{
				for(var bsk_row=0;bsk_row < opener.document.form_basket.product_id.length;bsk_row++)
				{
					if(window.opener.document.form_basket.product_id[bsk_row].value!='')
					{
						str_prod_control=1;
						break;
					}
				}
			}
			if(str_prod_control==1)
			{
				var get_basket_member_info = wrk_safe_query('obj_get_basket_project_info', 'dsn3', 0, window.opener.document.form_basket.basket_id.value);
				if(get_basket_member_info.recordcount)
				{
					alert("<cf_get_lang no='293.Belgede Satırlar Seçilmiş Proje Değiştiremezsiniz'>");
					window.close();
				}
			}
		}	
	</cfif>
	function add_pro(project_id,company_id,project_head,sdate,fdate,p_sdate,p_fdate,consumer_id,company_name,partner_id,partner_name,workgroup_id,pro_employee_id,pro_employee,paymethod,paymethod_id,card_paymethod_id,dueday,commission_rate,paymethod_vehicle)
	{  
		<cfif isdefined("attributes.project_id")>
			<cfset _project_id_ = ListGetAt(attributes.project_id,2,'.')><!--- Formu olmayan Sayfalara Değer Taşımak İçin Konuldu M.ER 01052008 --->
			if(window.opener.document.getElementById(<cfoutput>'#_project_id_#'</cfoutput>) != undefined)
				window.opener.document.getElementById(<cfoutput>'#_project_id_#'</cfoutput>).value = project_id;
			else	
			opener.<cfoutput>#project_id#</cfoutput>.value = project_id;
		</cfif>
		<cfif isdefined("attributes.company_id")>
			opener.<cfoutput>#company_id#</cfoutput>.value = company_id;
		</cfif>
		<cfif isdefined("attributes.pro_employee_id")><!--- addoptions icin eklendi --->
			opener.<cfoutput>#pro_employee_id#</cfoutput>.value = pro_employee_id;
		</cfif>
		<cfif isdefined("attributes.pro_employee")><!--- addoptions icin eklendi --->
			opener.<cfoutput>#pro_employee#</cfoutput>.value = pro_employee;
		</cfif>
		<cfif isdefined("attributes.sdate")>
			opener.<cfoutput>#sdate#</cfoutput>.value = sdate;
		</cfif>
		<cfif isdefined("attributes.fdate")>
			opener.<cfoutput>#fdate#</cfoutput>.value = fdate;
		</cfif>
		<cfif isdefined("attributes.p_sdate")>
			opener.<cfoutput>#p_sdate#</cfoutput>.value = p_sdate;
		</cfif>
		<cfif isdefined("attributes.p_fdate")>
			opener.<cfoutput>#p_fdate#</cfoutput>.value = p_fdate;
		</cfif>
		<cfif isdefined("attributes.consumer_id")>
			opener.<cfoutput>#consumer_id#</cfoutput>.value = consumer_id;
		</cfif>
		<cfif isdefined("attributes.call_function")>
			window.opener.<cfoutput>#attributes.call_function#</cfoutput>;
		</cfif>
		<cfif isdefined("attributes.company_name")>
			opener.<cfoutput>#company_name#</cfoutput>.value = company_name;
		</cfif>
		<cfif isdefined("attributes.company_name2")>
			opener.<cfoutput>#company_name2#</cfoutput>.value = company_name +' - '+ partner_name;
		</cfif>
		<cfif isdefined("attributes.partner_id")>
			opener.<cfoutput>#partner_id#</cfoutput>.value = partner_id;
		</cfif>
		<cfif isdefined("attributes.partner_name")>
			opener.<cfoutput>#partner_name#</cfoutput>.value = partner_name;
		</cfif>
		<cfif isdefined("attributes.workgroup_id")>
		opener.<cfoutput>#workgroup_id#</cfoutput>.value = workgroup_id;
		</cfif>
		
		// Proje bağlantıları ile ilişkili odeme yontemi bilgileri
		if(paymethod != '')
		{
			<cfif isdefined("attributes.paymethod")>
				opener.<cfoutput>#paymethod#</cfoutput>.value = paymethod;
			</cfif>
			<cfif isdefined("attributes.paymethod_id")>
				opener.<cfoutput>#paymethod_id#</cfoutput>.value = paymethod_id;
			</cfif>
			<cfif isdefined("attributes.card_paymethod_id")>
				opener.<cfoutput>#card_paymethod_id#</cfoutput>.value = card_paymethod_id;
			</cfif>
			<cfif isdefined("attributes.dueday")>
				opener.<cfoutput>#dueday#</cfoutput>.value = dueday;
			</cfif>
			<cfif isdefined("attributes.commission_rate")>
				opener.<cfoutput>#commission_rate#</cfoutput>.value = commission_rate;
			</cfif>
			<cfif isdefined("attributes.paymethod_vehicle")>
				opener.<cfoutput>#paymethod_vehicle#</cfoutput>.value = paymethod_vehicle;
			</cfif>
		}
		
		<cfif isdefined("attributes.project_head") and not isdefined("attributes.multi")>
			<cfset _project_head_ = ListGetAt(attributes.project_head,2,'.')><!--- Formu olmayan Sayfalara Değer Taşımak İçin Konuldu M.ER 01052008 --->
			if(window.opener.document.getElementById(<cfoutput>'#_project_head_#'</cfoutput>) != undefined)
			{
				window.opener.document.getElementById(<cfoutput>'#_project_head_#'</cfoutput>).value = project_head;
				window.opener.document.getElementById(<cfoutput>'#_project_head_#'</cfoutput>).focus();
			}	
			else
			{
				opener.<cfoutput>#project_head#</cfoutput>.value = project_head;
				opener.<cfoutput>#project_head#</cfoutput>.focus();
			}
		<cfelseif isdefined("attributes.project_head") and isdefined("attributes.multi")>
			x = opener.<cfoutput>#attributes.project_head#</cfoutput>.length;
			opener.<cfoutput>#attributes.project_head#</cfoutput>.length = parseInt(x + 1);
			opener. <cfoutput>#attributes.project_head#</cfoutput>.options[x].value = project_id;
			opener.<cfoutput>#attributes.project_head#</cfoutput>.options[x].text = project_head;
		</cfif>
		<cfif isdefined("attributes.function_name") and isdefined("attributes.function_param")>
			<cfoutput>opener.#function_name#(#attributes.function_param#);</cfoutput>
		<cfelseif isdefined("attributes.function_name")>
			opener.<cfoutput>#function_name#</cfoutput>();
		</cfif>
		if(typeof(opener.set_project_risk_limit) != 'undefined')  //basketteki toplamdaki  baglantı bakiye bilgisi icin eklendi
		{
			try{opener.set_project_risk_limit();}
				catch(e){};
		}
		<cfif isdefined("attributes.project_head") and not isdefined("attributes.multi")>
		window.close();
		</cfif>
	}

</script>
