<!---
File: BudgetTransferDemand.cfm
Author: Workcube - Melek KOCABEY <melekkocabey@workcube.com>
Date: 13.10.2020
Controller: WBO/controller/BudgetTransferDemandController.cfm
Description: Bütçe Aktarım Talepleri listeleme sayfası.
---->
<cf_xml_page_edit fuseact="myhome.budget_transfer_demand">
<cfparam name="attributes.keyword" default="">

<cfset cmp = createObject("component", "V16.budget.cfc.BudgetTransferDemand" )>

<cfif isdefined("attributes.form_submitted")>
    <cfset BudgetDemandList = cmp.get_BudgetDemandList(
                                            keyword : "#iif(len(attributes.keyword), 'attributes.keyword', DE(''))#",
                                            employee_id : #session.ep.userid#
                                         )>
<cfelse> 
	<cfset BudgetDemandList.recordcount = 0>
</cfif>

<cfparam name="attributes.totalrecords" default='#BudgetDemandList.recordcount#'>
<cfparam name="attributes.page" default='1'>
<cfparam name="attributes.maxrows" default='#session.ep.maxrows#'>
<cfset attributes.startrow=((attributes.page-1)*attributes.maxrows)+1>
<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
	<cfsavecontent variable="head"><cf_get_lang dictionary_id="61327.Bütçe Aktarım Talepleri"></cfsavecontent>
	<cf_box title="#head#" uidrop="1" hide_table_column="1" resize="0" collapsable="0">
		<cfform name="list_wizards"  method="post" action="#request.self#?fuseaction=#url.fuseaction#">
			<input name="form_submitted" id="form_submitted" type="hidden" value="1">
			<cf_box_search more="0">
				<cfoutput>
						<div class="form-group" id="form_ul_keyword">
							<input type="text" name="keyword" id="keyword" maxlength="50" value="#attributes.keyword#" placeHolder="<cf_get_lang_main no='48.Filtre'>">
						</div>
						<div class="form-group small">
							<cfsavecontent variable="message"><cf_get_lang_main no='125.Sayi_Hatasi_Mesaj'></cfsavecontent>
							<cfinput type="text" name="maxrows" value="#attributes.maxrows#" required="yes" onKeyUp="isNumber(this)" validate="integer" range="1,999" message="#message#" maxlength="3">
						</div>
						<div class="form-group">
							<cf_wrk_search_button button_type="4">
						</div>
				</cfoutput>
			</cf_box_search>
		</cfform>
		<cf_grid_list>
			<thead>
				<tr>
					<th width="30"><cf_get_lang dictionary_id='58577.Sıra'></th>
					<th><cf_get_lang dictionary_id='30770.Talep No'></th>
					<th><cf_get_lang dictionary_id="30829.Talep Eden"></th>
					<th><cf_get_lang dictionary_id="58859.Süreç"></th>
					<th><cf_get_lang dictionary_id="30631.Tarih"></th>
					<!-- sil -->
					<th class="header_icn_none" style = "width:20px;"><a href="<cfoutput>#request.self#?fuseaction=#url.fuseaction#&event=add</cfoutput>"><i class="fa fa-plus"></i></a></th>
					<!--- <th class="header_icn_none" style = "width:20px;"><a href="javascript://"><i class="fa fa-random"></i></a></th> --->
					<!-- sil -->
				</tr>
			</thead>
			<tbody>
				<cfif BudgetDemandList.recordcount>
					<cfoutput query="BudgetDemandList" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">
                        <tr>                            
                            <cfset demand_id_ = contentEncryptingandDecodingAES(isEncode:1,content:demand_id,accountKey:'wrk')>
							<td>#currentrow#</td>
							<td><a href="#request.self#?fuseaction=#url.fuseaction#&event=upd&demand_id=#demand_id_#">#demand_no#</a></td>
							<td>#DEMAND_EMPLOYEE_FULLNAME#</td>
							<td>#stage#</td>
							<td>#dateformat(demand_date,dateformat_style)#</td>
							<!-- sil -->
							<td><a href="#request.self#?fuseaction=#url.fuseaction#&event=upd&demand_id=#demand_id_#"><i class="fa fa-pencil" aria-hidden="true"></i></a></td>
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
		<cf_paging 
			page="#attributes.page#"
			maxrows="#attributes.maxrows#"
			totalrecords="#attributes.totalrecords#"
			startrow="#attributes.startrow#"
			adres="#url.fuseaction##url_str#">
	</cf_box>
</div>