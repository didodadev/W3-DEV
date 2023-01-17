<!---
File: BudgetTransferDemand.cfm
Author: Workcube - Melek KOCABEY <melekkocabey@workcube.com>
Date: 13.10.2020
Controller: WBO/controller/BudgetTransferDemandController.cfm
Description: Bütçe Aktarım Talepleri listeleme sayfası.
---->
<cf_xml_page_edit fuseact="budget.budget_transfer_demand">
<cfparam name="attributes.responsible_emp_id" default="">
<cfparam name="attributes.responsible_emp" default="">
<cfparam name="attributes.keyword" default="">

<cfset cmp = createObject("component", "V16.budget.cfc.BudgetTransferDemand" )>

<cfif isdefined("attributes.form_submitted")>
    <cfset BudgetDemandList = cmp.get_BudgetDemandList(
                                            keyword : "#iif(len(attributes.keyword), 'attributes.keyword', DE(''))#",
                                            responsible_emp_id : "#iif(len(attributes.responsible_emp_id), 'attributes.responsible_emp_id', DE(''))#",
                                            responsible_emp : "#iif(len(attributes.responsible_emp), 'attributes.responsible_emp', DE(''))#"
                                         )>
<cfelse> 
	<cfset BudgetDemandList.recordcount = 0>
</cfif>
<cfset attributes.responsible_emp_id = isdefined('x_to_position_code') and len(x_to_position_code) ? x_to_position_code : attributes.responsible_emp_id>
<cfset attributes.responsible_emp= isdefined('x_to_position_code') and len(x_to_position_code)  ? get_emp_info(x_to_position_code,1,0) : attributes.responsible_emp>
<cfparam name="attributes.totalrecords" default='#BudgetDemandList.recordcount#'>
<cfparam name="attributes.page" default='1'>
<cfparam name="attributes.maxrows" default='#session.ep.maxrows#'>
<cfset attributes.startrow=((attributes.page-1)*attributes.maxrows)+1>
<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
	<cf_box>
		<cfform name="list_demand"  method="post" action="#request.self#?fuseaction=#url.fuseaction#">
			<input name="form_submitted" id="form_submitted" type="hidden" value="1">
			<cf_box_search>
				<cfoutput>
					<div class="form-group" id="form_ul_keyword">
						<input type="text" name="keyword" id="keyword" maxlength="50" value="#attributes.keyword#" placeHolder="#getLang('','Filtre',57460)#">
					</div>
					<div class="form-group" id="item-responsible_emp">
						<div class="input-group">
							<input type="hidden" name="responsible_emp_id" id="responsible_emp_id" value="<cfif len(attributes.responsible_emp_id) and len(attributes.responsible_emp)><cfoutput>#attributes.responsible_emp_id#</cfoutput></cfif>">
							<input type="text" name="responsible_emp" id="responsible_emp" placeholder="<cf_get_lang dictionary_id='57544.Sorumlu'>" value="<cfif len(attributes.responsible_emp_id) and len(attributes.responsible_emp)><cfoutput>#attributes.responsible_emp#</cfoutput></cfif>" maxlength="255" onfocus="AutoComplete_Create('responsible_emp','MEMBER_NAME','MEMBER_NAME','get_member_autocomplete','3','POSITION_CODE','responsible_emp_id','','3','135');" autocomplete="off">
							<span class="input-group-addon icon-ellipsis btnPointer" onclick="openBoxDraggable('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_positions&field_code=list_demand.responsible_emp_id&field_name=list_demand.responsible_emp&select_list=1&is_form_submitted=1');" title="<cf_get_lang dictionary_id='57544.Sorumlu'>"></span>
						</div>
					</div>
					<div class="form-group small">
						<cfinput type="text" name="maxrows" value="#attributes.maxrows#" required="yes" onKeyUp="isNumber(this)" validate="integer" range="1,999" message="#getLang('','Kayıt Sayısı Hatalı',57537)#" maxlength="3">
					</div>
					<div class="form-group">
						<cf_wrk_search_button button_type="4">
					</div>
				</cfoutput>
			</cf_box_search>
		</cfform>
	</cf_box>
	<cf_box title="#getLang('','Bütçe Aktarım Talepleri',61327)#" uidrop="1" hide_table_column="1">
		<cf_grid_list>
			<thead>
				<tr>
					<th width="30"><cf_get_lang dictionary_id='58577.Sıra'></th>
					<th><cf_get_lang dictionary_id='30770.Talep No'></th>
					<th><cf_get_lang dictionary_id="30829.Talep Eden"></th>
					<th><cf_get_lang dictionary_id='57544.Sorumlu'></th>
					<th><cf_get_lang dictionary_id="58859.Süreç"></th>
					<th><cf_get_lang dictionary_id="30631.Tarih"></th>
					<!-- sil -->
					<th width="20" class="header_icn_none text-center"><a href="<cfoutput>#request.self#?fuseaction=#url.fuseaction#&event=add</cfoutput>"><i class="fa fa-plus" title="<cf_get_lang dictionary_id='57582.Ekle'>" alt="<cf_get_lang dictionary_id='57582.Ekle'>"></i></a></th>
					<!--- <th class="header_icn_none" style = "width:20px;"><a href="javascript://"><i class="fa fa-random"></i></a></th> --->
					<!-- sil -->
				</tr>
			</thead>
			<tbody>
				<cfif BudgetDemandList.recordcount>
					<cfoutput query="BudgetDemandList" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">
						<tr>
							<td>#currentrow#</td>
							<td><a href="#request.self#?fuseaction=#url.fuseaction#&event=upd&demand_id=#demand_id#">#demand_no#</a></td>
							<td>#DEMAND_EMPLOYEE_FULLNAME#</td>
							<td>#get_emp_info(RESPONSIBLE_EMP,1,0)#</td>
							<td>#stage#</td>
							<td>#dateformat(demand_date,dateformat_style)#</td>
							<!-- sil -->
							<td><a href="#request.self#?fuseaction=#url.fuseaction#&event=upd&demand_id=#demand_id#"><i class="fa fa-pencil" title="<cf_get_lang dictionary_id='57464.Güncelle'>" alt="<cf_get_lang dictionary_id='57464.Güncelle'>" aria-hidden="true"></i></a></td>
							<!--- <td><a href="#request.self#?fuseaction=budget.MagicBudgeterRun&demand_id=#demand_id#"><i class="fa fa-random" aria-hidden="true"></i></a></td> --->
							<!-- sil -->
						</tr>  
					</cfoutput>
				<cfelse>
					<tr>
						<td colspan="8"><cfif isdefined("attributes.form_submitted")><cf_get_lang dictionary_id='57484.Kayıt Bulunamadı'> !<cfelse><cf_get_lang  dictionary_id='57701.Filtre Ediniz '> !</cfif></td>
					</tr>
				</cfif>
			</tbody>
		</cf_grid_list>

		<cfset url_str = "">
		<cfif isdefined ("attributes.form_submitted") and len (attributes.form_submitted)>
			<cfset url_str = "#url_str#&form_submitted=#attributes.form_submitted#">
		</cfif>
		<cfif len(attributes.keyword)>
			<cfset url_str = "#url_str#&keyword=#attributes.keyword#">
		</cfif>
		<cfif len(attributes.responsible_emp_id)>
			<cfset url_str = "#url_str#&responsible_emp_id=#attributes.responsible_emp_id#">
		</cfif>
		<cfif len(attributes.responsible_emp)>
			<cfset url_str = "#url_str#&responsible_emp=#attributes.responsible_emp#">
		</cfif>
		<cf_paging 
			page="#attributes.page#"
			maxrows="#attributes.maxrows#"
			totalrecords="#attributes.totalrecords#"
			startrow="#attributes.startrow#"
			adres="#url.fuseaction##url_str#">
	</cf_box>
</div>