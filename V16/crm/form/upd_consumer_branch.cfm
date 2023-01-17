<cfparam name="attributes.is_active" default="1">
<cfparam name="attributes.is_type" default="1">
<cfquery name="GET_COMPANY_RELATED" datasource="#DSN#">
	SELECT DISTINCT
		COMPANY_BRANCH_RELATED.IS_MERKEZ,
		COMPANY_BRANCH_RELATED.IS_SELECT,
		COMPANY_BRANCH_RELATED.RELATED_ID,
		COMPANY_BRANCH_RELATED.CARIHESAPKOD, 
		COMPANY_BRANCH_RELATED.MUSTERIDURUM,
		COMPANY_BRANCH_RELATED.DEPOT_KM,
		COMPANY_BRANCH_RELATED.OUR_COMPANY_ID,
		COMPANY_BRANCH_RELATED.DEPOT_DAK,
		COMPANY_BRANCH_RELATED.MUHASEBEKOD,
		COMPANY_BRANCH_RELATED.SALES_DIRECTOR,
		COMPANY_BRANCH_RELATED.TEL_SALE_PREID,
		COMPANY_BRANCH_RELATED.PLASIYER_ID,
		COMPANY_BRANCH_RELATED.OPEN_DATE,
		COMPANY_BRANCH_RELATED.DEPO_STATUS,
		COMPANY_BRANCH_RELATED.CLOSE_DATE, 
		COMPANY_BRANCH_RELATED.RECORD_EMP,
		COMPANY_BRANCH_RELATED.RECORD_DATE,
		COMPANY_BRANCH_RELATED.UPDATE_EMP,
		COMPANY_BRANCH_RELATED.UPDATE_DATE,
		COMPANY_BRANCH_RELATED.RELATION_START,
		COMPANY_BRANCH_RELATED.RELATION_STATUS,
		COMPANY_BRANCH_RELATED.BRANCH_ID,
		COMPANY_BRANCH_RELATED.IS_CLOSED,
		COMPANY_BRANCH_RELATED.IS_CONTRACT_REQUIRED,
		BRANCH.BRANCH_NAME, 
		OUR_COMPANY.NICK_NAME, 
		OUR_COMPANY.COMPANY_NAME,
		OUR_COMPANY.COMP_ID, 
		COMPANY_BOYUT_DEPO_KOD.BOYUT_KODU
	FROM 
		COMPANY_BRANCH_RELATED, 
		BRANCH, 
		OUR_COMPANY, 
		COMPANY_BOYUT_DEPO_KOD, 
		EMPLOYEE_POSITION_BRANCHES
	WHERE 
		COMPANY_BRANCH_RELATED.MUSTERIDURUM IS NOT NULL AND
		COMPANY_BRANCH_RELATED.COMPANY_ID = #attributes.cpid# AND 
		BRANCH.BRANCH_ID = COMPANY_BRANCH_RELATED.BRANCH_ID AND 
		OUR_COMPANY.COMP_ID = BRANCH.COMPANY_ID AND 
		--COMPANY_BRANCH_RELATED.OUR_COMPANY_ID = OUR_COMPANY.COMP_ID AND
		COMPANY_BOYUT_DEPO_KOD.W_KODU = BRANCH.BRANCH_ID AND 
		EMPLOYEE_POSITION_BRANCHES.BRANCH_ID = BRANCH.BRANCH_ID AND
		EMPLOYEE_POSITION_BRANCHES.POSITION_CODE = #session.ep.position_code#
	<cfif attributes.is_active eq 1>
		AND COMPANY_BRANCH_RELATED.MUSTERIDURUM NOT IN (1,2) 
	<cfelse>
		AND COMPANY_BRANCH_RELATED.MUSTERIDURUM IN (1,2)
	</cfif>
		<cfif len(attributes.is_type)>AND COMPANY_BRANCH_RELATED.IS_SELECT = #attributes.is_type#</cfif>
	ORDER BY 
		COMPANY_BRANCH_RELATED.BRANCH_ID
</cfquery>
<cfquery name="GET_COM_BRANCH_" datasource="#DSN#">
	SELECT 
		OUR_COMPANY.COMP_ID, 
		OUR_COMPANY.COMPANY_NAME, 
		BRANCH.BRANCH_NAME, 
		BRANCH.BRANCH_ID, 
		ZONE.ZONE_NAME 
	FROM 
		BRANCH, 
		OUR_COMPANY, 
		ZONE, 
		EMPLOYEE_POSITION_BRANCHES 
	WHERE 
		EMPLOYEE_POSITION_BRANCHES.POSITION_CODE = #session.ep.position_code# AND 
		EMPLOYEE_POSITION_BRANCHES.BRANCH_ID = BRANCH.BRANCH_ID AND 
		BRANCH.COMPANY_ID = OUR_COMPANY.COMP_ID AND 
		ZONE.ZONE_ID = BRANCH.ZONE_ID 
	ORDER BY 
		OUR_COMPANY.COMPANY_NAME, 
		BRANCH.BRANCH_NAME
</cfquery>
<cfset branch_list_ = valuelist(get_com_branch_.branch_id, ',')>
<cf_box title="#getLang('','Çalıştığı Şubeler','51697')#">

	<cfform name="seacrh_form" action="" method="post">
		<cf_box_search>
			<input type="hidden" name="frame_fuseaction"  id="frame_fuseaction" value="<cfif isdefined("attributes.frame_fuseaction") and len(attributes.frame_fuseaction)><cfoutput>#attributes.frame_fuseaction#</cfoutput></cfif>">
			
			<div class="form-group">
				<select name="is_active" id="is_active">
					<option value="1" <cfif attributes.is_active eq 1>selected</cfif>><cf_get_lang_main no="81.Aktif"></option>
					<option value="0" <cfif attributes.is_active eq 0>selected</cfif>><cf_get_lang_main no="82.Pasif"></option>
				</select>
			</div>
			<div class="form-group">
				<select name="is_type" id="is_type">
					<option value="1" <cfif attributes.is_type eq 1>selected</cfif>><cf_get_lang_main no="649.Cari"></option>
					<option value="0" <cfif attributes.is_type eq 0>selected</cfif>><cf_get_lang_main no="165.Potansiyel"></option>
				</select>
			</div>
			<div class="form-group">
				<cf_wrk_search_button search_function='hepsini_sec()' button_type="4">
			</div>
			<div class="form-group">
				<a class="ui-btn ui-btn-gray" href="javascript://" onClick="openBoxDraggable('<cfoutput>#request.self#?fuseaction=crm.popup_add_company_workbranch&cpid=#attributes.cpid#</cfoutput>');"><i class="fa fa-plus" title="<cf_get_lang no='318.Şube Ekle'>"></i></a>
			</div>
		</cf_box_search>

	</cfform>
</cf_box>
<cf_box>
<cfif get_company_related.recordcount>
	<cfoutput query="get_company_related">
		<!--- <cfif len(get_company_related.our_company_id)> --->
		<cfquery name="GET_CREDIT" datasource="#DSN#">
			SELECT TOTAL_RISK_LIMIT, MONEY FROM COMPANY_CREDIT WHERE BRANCH_ID = #get_company_related.related_id#
		</cfquery>
		<cfif get_credit.recordcount>
			<cfscript>
				total_risk_limit_value = get_credit.total_risk_limit;
				money_value = get_credit.money;
			</cfscript>
		<cfelse>
			<cfscript>
				total_risk_limit_value = 0;
				money_value = session.ep.money;
			</cfscript>
		</cfif>
		<cf_flat_list>
			<thead>
				<tr>
					<th colspan="5">#company_name# / #branch_name#</th>
					<th width="65"  nowrap="nowrap" style="text-align:right;">
						<cfif listfind(branch_list_, branch_id, ',') neq 0>
							<a href="javascript://" onClick="windowopen('#request.self#?fuseaction=crm.popup_upd_company_workbranch&cpid=#attributes.cpid#&related_id=#related_id#&our_company_id=#comp_id#','list');"><i class="fa fa-pencil" title="<cf_get_lang_main no='52.Güncelle'>"></i></a>
							<a href="javascript://" onClick="windowopen('#request.self#?fuseaction=crm.popup_add_company_period_note&cpid=#attributes.cpid#&related_id=#related_id#','small');"><i class="catalyst-note" border="0" title="Şube Notu"></i></a>
							<a href="javascript://" onclick="windowopen('#request.self#?fuseaction=crm.popup_member_branch_history&related_id=#get_company_related.related_id#','medium','popup_member_branch_history');"><i class="fa fa-history" title="<cf_get_lang_main no='61.Tarihçe'>" border="0"></i></a>
						</cfif>
					</th>
				</tr>
			</thead>
			<tr>
				<td class="bold" width="100"><cf_get_lang_main no='642.Sürec-Asama'></td>
				<td width="150">
					<cfif len(get_company_related.depo_status)>
						<cfquery name="get_" datasource="#DSN#">
							SELECT DISTINCT
								PROCESS_TYPE_ROWS.PROCESS_ROW_ID,
								PROCESS_TYPE_ROWS.STAGE,
								PROCESS_TYPE_ROWS.LINE_NUMBER
							FROM
								PROCESS_TYPE_ROWS
							WHERE
								PROCESS_TYPE_ROWS.PROCESS_ROW_ID = #get_company_related.depo_status#
						</cfquery>
					#get_.stage#
					</cfif>
				</td>
				<td class="bold" width="110"><cf_get_lang no='102.Bölge Satış Müdürü'></td>
				<td width="200">#get_emp_info(sales_director,1,1)#</td>
				<td class="bold"><cf_get_lang no='229.İlişki Başlangıcı'></td>
				<td width="100">
					<cfif len(relation_start)>
						<cfquery name="GET_RESOURCE" datasource="#DSN#">
							SELECT RESOURCE FROM COMPANY_PARTNER_RESOURCE WHERE RESOURCE_ID = #relation_start#
						</cfquery>
						#get_resource.resource#
					</cfif>
				</td>
			</tr>
			<tr>
				<td class="bold"><cf_get_lang no='226.Cari Hesap Kodu'></td>
				<td>#carihesapkod#</td>
				<td class="bold"><cf_get_lang no='101.Plasiyer'></td>
				<td>#get_emp_info(plasiyer_id,1,1)#</td>
				<td class="bold"><cf_get_lang no='230.Şube ile İlişkileri'></td>
				<td>
					<cfif len(relation_status)>
						<cfquery name="GET_RELATION" datasource="#DSN#">
							SELECT PARTNER_RELATION_ID, PARTNER_RELATION FROM SETUP_PARTNER_RELATION WHERE PARTNER_RELATION_ID = #relation_status#
						</cfquery>
						#get_relation.partner_relation#
					</cfif>
				</td>
			</tr>
			<tr>
				<td class="bold"><cf_get_lang_main no='1399.Muhasebe Kodu'></td>
				<td>#muhasebekod#</td>
				<td class="bold"><cf_get_lang no='430.Tel Satış Görevlisi'></td>
				<td>#get_emp_info(tel_sale_preid,1,1)#</td>
				<td class="bold"><cf_get_lang no='236.Şube Açılış Tarihi'></td>
				<td>#dateformat(open_date,'dd/mm/yyyy')#</td>
			</tr>
			<tr>
				<td class="bold"><cf_get_lang_main no='482.Statü'></td>
				<td>
					<cfif len(musteridurum)>
						<cfquery name="GET_COMPANY_STATUS" datasource="#DSN#">
							SELECT TR_NAME FROM SETUP_MEMBERSHIP_STAGES WHERE TR_ID = #musteridurum#
						</cfquery>
						#get_company_status.tr_name#
					</cfif>
				</td>
				<td class="bold"><cf_get_lang no='293.Uzaklık'></td>
				<td>#depot_km# <cfif len(depot_km)><cf_get_lang no='316.km'></cfif>
					#depot_dak# <cfif len(depot_km)><cf_get_lang_main no='715.Dakika'></cfif>
				</td>
				<td class="bold"><cf_get_lang no='317.Şube Kapanış Tarihi'></td>
				<td>#dateformat(close_date,'dd/mm/yyyy')#</td>
			</tr>
			<tr>
				<td class="bold"><cf_get_lang no="135.Risk Limit"></td>
				<td>#tlformat(total_risk_limit_value)# #session.ep.money#</td>
				<td colspan="4">		
					<cfif is_merkez eq 1><cfif not listfindnocase(denied_pages,'crm.emptypopup_add_change_ismerkez')><a href="#request.self#?fuseaction=crm.emptypopup_add_change_ismerkez&related_id=#related_id#&cpid=#attributes.cpid#"><img src="images/b_ok.gif" align="absmiddle" border="0" title="İptal Et"></a>&nbsp;<cf_get_lang no="21.İptal Et"></cfif></cfif>
					<cfif is_closed eq 0><cfif not listfindnocase(denied_pages,'crm.popup_add_change_is_closed')><a href="javascript://" onClick="windowopen('#request.self#?fuseaction=crm.popup_add_change_is_closed&related_id=#related_id#&cpid=#attributes.cpid#&is_closed=1','small');"><img src="images/c_ok.gif" align="absmiddle" border="0" title="Kapatma"></a>&nbsp;<cf_get_lang no="798.Kapatma"></cfif></cfif>
					<cfif is_closed eq 1><cfif not listfindnocase(denied_pages,'crm.emptypopup_add_change_is_closed')><a href="#request.self#?fuseaction=crm.emptypopup_add_change_is_closed&related_id=#related_id#&cpid=#attributes.cpid#&is_closed=0"><img src="images/b_ok.gif" align="absmiddle" border="0" title="Kapat"></a>&nbsp;<cf_get_lang_main no="141.Anlaşma Bilgisi Zorunlu"></cfif></cfif>
					<cfif is_contract_required eq 0><cfif not listfindnocase(denied_pages,'crm.emptypopup_add_change_contract_required')><a href="#request.self#?fuseaction=crm.emptypopup_add_change_contract_required&related_id=#related_id#&cpid=#attributes.cpid#&is_contract_required=1"><img src="images/c_ok.gif" align="absmiddle" border="0" title="Zorunlu"></a>&nbsp;<cf_get_lang no="24.Anlaşma Bilgisi Zorunlu"></cfif></cfif>
				</td>
			</tr>
		</cf_flat_list>
		<div class="ui-info-bottom flex-end">
			<cf_record_info query_name="GET_COMPANY_RELATED">
		</div>
	</cfoutput>
</cfif>
</cf_box>
<cfif isdefined("attributes.is_open_popup") and len(attributes.is_open_popup)>
	<cfquery name="GET_STORE" datasource="#DSN#">
		SELECT OUR_COMPANY_ID FROM COMPANY_BRANCH_RELATED WHERE RELATED_ID = #attributes.related_id#
	</cfquery>
	<script type="text/javascript">
		windowopen('<cfoutput>#request.self#?fuseaction=crm.popup_upd_company_workbranch&cpid=#attributes.cpid#&related_id=#related_id#&our_company_id=#get_store.our_company_id#</cfoutput>','list');
	</script>
	<cfset attributes.is_open_popup=''>
</cfif>
<script type="text/javascript">
function hepsini_sec()
{
	return true;
}
</script>