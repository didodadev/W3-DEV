<cfif list_type eq 1>
	<cfset page_type = 1><!--- Onaylar --->
	<cfset header_ = "Onaylar">
	<cfset attributes.is_form_submitted = 1>
<cfelseif list_type eq 0>
	<cfset page_type = 2><!--- Uyarilar --->
	<cfset header_ = "Uyarılar">
	<cfset attributes.is_form_submitted = 1>
</cfif>
<cf_get_lang_set module_name="myhome">
<cfparam name="attributes.keyword" default="">
<cfparam name="attributes.list_type" default="#list_type#">
<cfparam name="attributes.process_type" default="">
<cfparam name="attributes.warning_isactive" default="1">
<cfparam name="attributes.warning_condition" default="1">
<cfparam name="attributes.employee_id" default="">
<cfparam name="attributes.position_code" default="">
<cfparam name="attributes.employee_name" default="">
<cfparam name="attributes.action_table" default="">
<cfset xml_confirm_control_buttons = 1>
<cfscript>
	url_str = "";
	if(len(attributes.keyword))
		url_str = "#url_str#&keyword=#attributes.keyword#";
	if(not isDefined('attributes.start_response_date'))
		attributes.start_response_date = date_add('d',-3,now());
	if(not isDefined('attributes.finish_response_date'))
		attributes.finish_response_date = date_add('h',23,now());
</cfscript>
<cfif isdefined("attributes.is_active_id")>
	<!--- Pasif Update islemi --->
	<cfquery name="UPD_PAGE_WARNING" datasource="#DSN#">
		UPDATE PAGE_WARNINGS SET IS_ACTIVE = 0 WHERE W_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.is_active_id#">
	</cfquery>
	<cfif isdefined("attributes.is_close")>
		<script type="text/javascript">
			window.close();
		</script>
	</cfif>
</cfif>
<cfif isDefined("attributes.is_form_submitted")>
	<cfinclude template="../query/get_warning.cfm">
<cfelse>
	<cfset get_warnings.recordcount = 0>
</cfif>
<cfparam name="attributes.page" default="1">
<cfparam name="attributes.maxrows" default="#session.pda.maxrows#">
<cfparam name="attributes.totalrecords" default="#get_warnings.recordcount#">	
<cfset attributes.startrow=((attributes.page-1)*attributes.maxrows)+1>
<table cellpadding="0" cellspacing="0" align="center" style="width:98%">
	<tr style="height:35px;">
		<td class="headbold"><cfif list_type eq 1>Onaylarım<cfelseif list_type eq 0>Uyarılarım</cfif></td>
	</tr>
</table>
<cf_big_list>
	<cfset colspan_ = '7'>
	<thead>
		<tr>
			<th><cf_get_lang_main no='1165.Sıra'></th>
			<th><cf_get_lang no='71.Talep'></th>
			<th><cf_get_lang no='72.Talep Eden'></th>
			<th><cf_get_lang_main no='250.Alan'></th>
			<cfif isdefined('xml_project_id') and xml_project_id eq 1>
				<th><cf_get_lang_main no='4.Proje'></th>
				<cfset colspan_ = colspan_ + 1>
			</cfif>
			<cfif isdefined('xml_our_company_id') and  xml_our_company_id eq 1>
				<th><cf_get_lang_main no='162.Şirket'> / <cf_get_lang_main no='1060.Dönem'></th>
				<cfset colspan_ = colspan_ + 1>
			</cfif>
			<th><cf_get_lang_main no='215.Kayıt Tarihi'></th>
			<th><cf_get_lang_main no='217.Açıklama'></th>
            <!-- sil -->
			<th width="15">&nbsp;</th>
			<cfif page_type eq 1 and xml_confirm_control_buttons eq 1>
				<th width="40">&nbsp;</th>
				<cfset colspan_ = colspan_ + 1>
			</cfif>
			<cfif Len(attributes.warning_isactive) and attributes.warning_isactive eq 1>
				<cfif page_type neq 3>
					<th width="15"><cfif get_warnings.recordcount><input type="checkbox" name="all_warnings" id="all_warnings" value="1" onClick="javascript:wrk_select_all('all_warnings','warning_ids');"></cfif></th>
					<cfset colspan_ = colspan_ + 1>
				</cfif>
			</cfif>
            <!-- sil -->
		</tr>
	</thead>
	<tbody>
		<cfif get_warnings.recordcount>
			<cfset employee_list = "">
			<cfset partner_list = "">
			<cfset consumer_list = "">
			<cfset position_code_list = "">
			<cfset period_list = "">
			<cfset our_company_list = "">
			<cfoutput query="get_warnings" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">
				<cfif len(record_emp) and not listfind(employee_list,record_emp)>
					<cfset employee_list=listappend(employee_list,record_emp)>
				</cfif>
				<cfif len(position_code) and not listfind(position_code_list,position_code)>
					<cfset position_code_list=listappend(position_code_list,position_code)>
				</cfif>
				<cfif len(record_par) and not listfind(partner_list,record_par)>
					<cfset partner_list=listappend(partner_list,record_par)>
				</cfif>
				<cfif len(record_con) and not listfind(consumer_list,record_con)>
					<cfset consumer_list=listappend(consumer_list,record_con)>
				</cfif>
				<cfif len(period_id) and not listfind(period_list,period_id)>
					<cfset period_list=listappend(period_list,period_id)>
				</cfif>
				<cfif len(our_company_id) and not listfind(our_company_list,our_company_id)>
					<cfset our_company_list=listappend(our_company_list,our_company_id)>
				</cfif>
			</cfoutput>
			<cfif len(employee_list)>
				<cfquery name="get_employees" datasource="#dsn#">
					SELECT EMPLOYEE_ID, EMPLOYEE_NAME, EMPLOYEE_SURNAME FROM EMPLOYEES WHERE EMPLOYEE_ID IN (#employee_list#) ORDER BY EMPLOYEE_ID
				</cfquery>
				<cfset employee_list = listsort(listdeleteduplicates(valuelist(get_employees.employee_id,',')),'numeric','ASC',',')>
			</cfif>
			<cfif len(partner_list)>
				<cfquery name="get_partners" datasource="#dsn#">
					SELECT PARTNER_ID, COMPANY_PARTNER_NAME, COMPANY_PARTNER_SURNAME FROM COMPANY_PARTNER WHERE PARTNER_ID IN (#partner_list#) ORDER BY PARTNER_ID
				</cfquery>
				<cfset partner_list = listsort(listdeleteduplicates(valuelist(get_partners.partner_id,',')),'numeric','ASC',',')>
			</cfif>
			<cfif len(consumer_list)>
				<cfquery name="get_consumers" datasource="#dsn#">
					SELECT CONSUMER_ID, CONSUMER_NAME, CONSUMER_SURNAME FROM CONSUMER WHERE CONSUMER_ID IN (#consumer_list#) ORDER BY CONSUMER_ID
				</cfquery>
				<cfset consumer_list = listsort(listdeleteduplicates(valuelist(get_consumers.consumer_id,',')),'numeric','ASC',',')>
			</cfif>
			<cfif len(position_code_list)>
				<cfquery name="get_positions" datasource="#dsn#">
					SELECT POSITION_CODE, EMPLOYEE_NAME, EMPLOYEE_SURNAME FROM EMPLOYEE_POSITIONS WHERE POSITION_CODE IN (#position_code_list#) ORDER BY POSITION_CODE
				</cfquery>
				<cfset position_code_list = listsort(listdeleteduplicates(valuelist(get_positions.position_code,',')),'numeric','ASC',',')>
			</cfif>
			<cfif len(period_list)>
				<cfquery name="get_period" datasource="#dsn#">
					SELECT PERIOD_ID, PERIOD FROM SETUP_PERIOD WHERE PERIOD_ID IN (#period_list#) ORDER BY PERIOD_ID
				</cfquery>
				<cfset period_list = listsort(listdeleteduplicates(valuelist(get_period.period_id,',')),'numeric','ASC',',')>
			</cfif>
			<cfif len(our_company_list)>
				<cfquery name="get_company" datasource="#dsn#">
					SELECT COMP_ID, COMPANY_NAME FROM OUR_COMPANY WHERE COMP_ID IN (#our_company_list#) ORDER BY COMP_ID
				</cfquery>
				<cfset our_company_list = listsort(listdeleteduplicates(valuelist(get_company.comp_id,',')),'numeric','ASC',',')>
			</cfif>
			<cfform name="upd_warnings_active" id="upd_warnings_active" action="#request.self#?fuseaction=pda.emptypopup_upd_list_warning" method="post">				
			<input type="hidden" name="fuseaction_" id="fuseaction_" value="<cfoutput>#attributes.fuseaction#</cfoutput>"><!--- Pasif Yap sayfasinda kullaniliyor --->
			<cfoutput query="get_warnings" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">
				<cfif find('popup',get_warnings.url_link)><cfset is_popup=1><cfelse><cfset is_popup=0></cfif><!---sayfa linki popup sa uyarıda açılacak sayfa popup açılıyor--->
					<tr>	
						<td>#currentrow#</td>
						<td><cfif type eq 0>
								<a href="##" onClick="warning_redirect('#user_domain##url_link#','#parent_id#','#is_popup#','#w_id#','#OUR_COMPANY_ID#','#PERIOD_ID#');" class="tableyazi">#warning_head#</a>
							<cfelse>
								#warning_head#
							</cfif>
						</td>
						<td><cfif len(record_emp)>
								#get_employees.employee_name[listfind(employee_list,record_emp,',')]# #get_employees.employee_surname[listfind(employee_list,record_emp,',')]#
							<cfelseif len(record_par)>
								#get_partners.company_partner_name[listfind(partner_list,record_par,',')]# #get_partners.company_partner_surname[listfind(partner_list,record_par,',')]#
							<cfelseif len(record_con)>
								#get_consumers.consumer_name[listfind(consumer_list,record_con,',')]# #get_consumers.consumer_surname[listfind(consumer_list,record_con,',')]#
							</cfif>
						</td>
						<td><cfif Len(position_code)>
								#get_positions.employee_name[listfind(position_code_list,position_code,',')]# #get_positions.employee_surname[listfind(position_code_list,position_code,',')]#
							</cfif>
						</td>
						<!--- satinalma siparisi-teklifi-talebi sayfalarindaki proje bilgisini getirir --->
						<cfif isdefined('xml_project_id') and xml_project_id eq 1>
							<cfif len(action_table) and len(action_column) and len(action_id) and listfind('ORDERS,OFFER,INTERNALDEMAND',action_table)>
								<cfquery name="get_project_name" datasource="#dsn3#">
									SELECT 
										PP.PROJECT_NUMBER,
										PP.PROJECT_HEAD
									FROM 
										#action_table# T LEFT JOIN #dsn_alias#.PRO_PROJECTS PP ON PP.PROJECT_ID = <cfif listfind('INTERNALDEMAND',action_table)>ISNULL(T.PROJECT_ID_OUT,T.PROJECT_ID)<cfelse>T.PROJECT_ID</cfif>
									WHERE 
										T.#action_column# = #action_id#
								</cfquery>
							</cfif>
							<td><cfif isdefined('get_project_name.project_number')>#get_project_name.project_number#</cfif><cfif isdefined('get_project_name.project_head') and len(get_project_name.project_head)> - #get_project_name.project_head#</cfif></td>
						</cfif>
						<!---// satinalma siparisi-teklifi-talebi sayfalarindaki proje bilgisini getirir --->
						<cfif isdefined('xml_our_company_id') and  xml_our_company_id eq 1>
							<td><cfif len(period_id)>
									#get_period.period[listfind(period_list,period_id,',')]#
								<cfelseif len(our_company_id)>
									#get_company.company_name[listfind(our_company_list,our_company_id,',')]#					
								</cfif>
							</td>
						</cfif>
						<td>#dateformat(date_add("h",session.pda.time_zone,record_date),"dd/mm/yyyy")# #timeformat(date_add("h",session.pda.time_zone,record_date),"HH:MM")#</td>
						<td title="#warning_description#"><cfif len(warning_description) lt 31>#warning_description#<cfelse>#Left(warning_description,31)#...</cfif></td>
			            <!-- sil -->
                        <td width="15">
							<cfif type eq 0>
								<a href="##" onClick="<cfif ((Len(OUR_COMPANY_ID) and  OUR_COMPANY_ID neq session.ep.company_id) or (Len(PERIOD_ID) and PERIOD_ID neq session.ep.period_id))>alert('Bulunduğunuz Dönem ve Şirket uyarıyı görmeniz için uygun değil');<cfelse><cfif attributes.fuseaction contains 'popup'>windowopen('#request.self#?fuseaction=myhome.popup_dsp_warning&warning_id=#w_id#<cfif page_type neq 1>&warning_is_active=0</cfif>','medium');<cfif is_popup eq 1>;windowopen('#user_domain##url_link#','page');<cfelse>opener.location.href = '#user_domain##url_link#';</cfif>window.location.href='#request.self#?fuseaction=myhome.popup_list_warning&is_active_id=#w_id#&is_close=1';<cfelse><cfif is_popup eq 1>windowopen('#user_domain##url_link#','page');<cfelse>window.location.href = '#user_domain##url_link#';</cfif></cfif></cfif>"><img src="/images/file.gif" title="<cf_get_lang no='73.İlgili Sayfa'>"></a>
							<cfelseif type neq 4>
								<a href="##" onClick="windowopen('#user_domain##url_link#','small');"><img src="/images/file.gif" title="<cf_get_lang no='73.İlgili Sayfa'>"></a>
							<cfelse>
								<a href="##" onClick="windowopen('#user_domain##url_link#','wide');"><img src="/images/file.gif" title="<cf_get_lang no='73.İlgili Sayfa'>"></a>
							</cfif>
						</td>
						<cfif page_type eq 1 and xml_confirm_control_buttons eq 1>
							<td><cfif not Len(confirm_result)>
								<cfsavecontent variable="message">Güncellemekte Olduğunuz Belge Sizi ve Şirketinizi Bağlayacak Konular İçerebilir.\nGüncellemek İstediğinize Emin Misiniz?</cfsavecontent>
								<cfif is_active eq 1 and type eq 0>
										<a href="javascript://" onclick="if (confirm('#message#')) {confirm_control(1,#w_id#);} else {return false}"><img src="/images/valid.gif" alt="<cf_get_lang_main no ='1063.Onayla'>"></a>
										<a href="javascript://" onclick="if (confirm('#message#')) {confirm_control(0,#w_id#);} else {return false}"><img src="/images/refusal.gif" alt="<cf_get_lang_main no='1049.Reddet'>"></a>
									</cfif>
								</cfif>
							</td>
						</cfif>
						<cfif attributes.warning_isactive eq 1 and page_type neq 3>
							<td><cfif type eq 0><input type="checkbox" name="warning_ids" id="warning_ids" value="#w_id#"></cfif></td>
						</cfif>
			            <!-- sil -->
					</tr>
			</cfoutput>
			<input type="hidden" name="valid_ids" id="valid_ids" value=""><input type="hidden" name="refusal_ids" id="refusal_ids" value=""><!--- Onay ve Redlerin Toplu Gonderimi Icin Eklendi --->
			</cfform>
			<cfif Len(attributes.warning_isactive) and attributes.warning_isactive eq 1>
			<tr>
				<td colspan="<cfoutput>#colspan_#</cfoutput>" style="text-align:right;">
					<cfif page_type eq 1 and xml_confirm_control_buttons eq 1>
						<input type="button" name="all_valid" id="all_valid" value="Onayla" onClick="confirm_control(1,'');">
						<input type="button" name="all_refusal" id="all_refusal" value="Reddet" onClick="confirm_control(0,'');">
					<cfelseif page_type neq 3>
						<input type="button" name="passive" id="passive" value="<cf_get_lang no='1608.Pasif Yap'>" onClick="uyari_kontrol();">
					</cfif>
				</td>
			</tr>
			</cfif>
		<cfelse>
			<tr> 
				<td colspan="<cfoutput>#colspan_#</cfoutput>"><cfif isdefined("attributes.is_form_submitted")><cf_get_lang_main no='72.Kayit Bulunamadi'><cfelse><cf_get_lang_main no='289. Filtre Ediniz'></cfif>!</td>
			</tr>
		</cfif>	
	</tbody>
</cf_big_list>
<cfscript>
	if(isdefined("attributes.keyword") and len(attributes.keyword))url_str = "#url_str#&keyword=#attributes.keyword#";
	if(isdefined("attributes.start_response_date") and len(attributes.start_response_date))url_str = "#url_str#&start_response_date=#dateformat(attributes.start_response_date,'dd/mm/yyyy')#";
	if(isdefined("attributes.finish_response_date") and len(attributes.finish_response_date))url_str = "#url_str#&finish_response_date=#dateformat(attributes.finish_response_date,'dd/mm/yyyy')#";
	if(isdefined("attributes.employee_name") and len(attributes.employee_name)) url_str='#url_str#&employee_id=#attributes.employee_id#&position_code=#attributes.position_code#&employee_name=#attributes.employee_name#';
	if(isdefined("attributes.is_form_submitted") and len(attributes.is_form_submitted)) url_str='#url_str#&is_form_submitted=#attributes.is_form_submitted#';
	if(isdefined("attributes.warning_condition") and len(attributes.warning_condition))url_str='#url_str#&warning_condition=#attributes.warning_condition#';
	if(isdefined("attributes.warning_isactive") and len(attributes.warning_isactive))url_str='#url_str#&warning_isactive=#attributes.warning_isactive#';
	if(isdefined("attributes.list_type") and len(attributes.list_type))url_str='#url_str#&list_type=#attributes.list_type#';
	if(isdefined("attributes.process_type") and len(attributes.process_type))url_str='#url_str#&process_type=#attributes.process_type#';
	if(isdefined("attributes.action_table") and len(attributes.action_table))url_str='#url_str#&action_table=#attributes.action_table#';
</cfscript>
<cf_paging
	page="#attributes.page#"
    maxrows="#attributes.maxrows#"
    totalrecords="#attributes.totalrecords#"
	startrow="#attributes.startrow#"
	adres="#fuseaction##url_str#">
<script type="text/javascript">
document.getElementById('keyword').focus();
function confirm_control(x,w)
{
	var check_list = "0";
	if(w == "")
	{
		for (i=0; i < document.getElementsByName("warning_ids").length; i++)
		{
			if(document.getElementsByName("warning_ids")[i].checked == true)
				check_list = check_list + "," + document.getElementsByName("warning_ids")[i].value;
		}
	}
	else
		check_list = w;
	
	document.getElementById("valid_ids").value = "";
	document.getElementById("refusal_ids").value = "";
	if(x == 1)
		document.getElementById("valid_ids").value = check_list;
	else
		document.getElementById("refusal_ids").value = check_list;
	
	document.getElementById("upd_warnings_active").submit();
	return false;
}
function uyari_kontrol()
{
	is_secili = 0;
	if(document.upd_warnings_active.warning_ids.length != undefined) /* n tane*/
	{	
		for (i=0; i < document.upd_warnings_active.warning_ids.length; i++)
		{
			if((document.upd_warnings_active.warning_ids[i].checked==true))
				is_secili = 1;
		}
	}
	else /* 1 tane*/
	{			
		if((document.upd_warnings_active.warning_ids.checked==true))
			is_secili = 1;
	}
	
	if(is_secili==0)
	{
		alert('Uyarı Seçmelisiniz!');
		return false;
	}
	else
	{
		document.upd_warnings_active.submit();
		return false;
	}
}
function warning_redirect(url,warning_id,is_popup,sub_w_id,comp_id,per_id)
{
	if((comp_id!='' && comp_id != <cfoutput>#session.pda.our_company_id#</cfoutput>) || (per_id!='' && per_id != <cfoutput>#session.pda.period_id#</cfoutput>))
	{
		alert("<cf_get_lang no ='959.Bulunduğunuz Dönem ve Şirket Uyarıyı Görmeniz İçin Uygun Değil'>!");
		return false;
	}
	<cfif attributes.fuseaction contains 'popup'>
		if(is_popup==1) 
			windowopen(url,'page'); 
		else 
			window.opener.location.href = url;
		window.location.href='<cfoutput>#request.self#?fuseaction=myhome.popup_list_warning&is_active_id=</cfoutput>' + warning_id +'&is_close=1';
	<cfelse>
		windowopen('<cfoutput>#request.self#?fuseaction=myhome.popup_dsp_warning&warning_id=</cfoutput>' + warning_id+'<cfif page_type neq 1>&warning_is_active=0</cfif>&sub_warning_id='+sub_w_id ,'medium');
		if(is_popup==1) 
			windowopen(url,'page'); 
		else 
			window.location.href = url;
	</cfif>
}
</script> 
<cf_get_lang_set module_name="#lcase(listgetat(attributes.fuseaction,1,'.'))#">
