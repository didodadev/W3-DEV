<cfparam name="attributes.is_active" default="1">
<cfparam name="attributes.is_type" default="1">
<cfquery name="GET_COMPANY_RELATED" datasource="#DSN#">
	SELECT
		COMPANY_BRANCH_RELATED.BRANCH_ID,
		COMPANY_BRANCH_RELATED.RELATED_ID,
		COMPANY_BRANCH_RELATED.CUSTOMER_TYPE_ID,
		COMPANY_BRANCH_RELATED.TARGET_CUSTOMER_TYPE_ID,
		COMPANY_BRANCH_RELATED.MAIN_LOCATION_CAT_ID,
		COMPANY_BRANCH_RELATED.ENDORSEMENT_CAT_ID,
		COMPANY_BRANCH_RELATED.PROFITABILITY_CAT_ID,
		COMPANY_BRANCH_RELATED.RISK_CAT_ID,
		COMPANY_BRANCH_RELATED.SPECIAL_STATE_CAT_ID,		
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
		EMPLOYEE_POSITION_BRANCHES.DEPARTMENT_ID IS NULL AND        
		BRANCH.COMPANY_ID = OUR_COMPANY.COMP_ID AND 
		ZONE.ZONE_ID = BRANCH.ZONE_ID 
	ORDER BY 
		OUR_COMPANY.COMPANY_NAME, 
		BRANCH.BRANCH_NAME
</cfquery>
<cfset branch_list_ = valuelist(get_com_branch_.branch_id, ',')>
<cfsavecontent variable="title"><cf_get_lang no='1048.Kategori Bilgileri'></cfsavecontent>
<cf_box title="#title#">
	<cfform name="seacrh_form" action="" method="post">
		<cf_box_search>
            <input type="hidden" name="frame_fuseaction" id="frame_fuseaction" value="<cfif isdefined("attributes.frame_fuseaction") and len(attributes.frame_fuseaction)><cfoutput>#attributes.frame_fuseaction#</cfoutput></cfif>">
            
			<div class="form-group">
				<select name="is_active" id="is_active">
					<option value="1" <cfif attributes.is_active eq 1>selected</cfif>>Aktif</option>
					<option value="0" <cfif attributes.is_active eq 0>selected</cfif>>Pasif</option>
				</select>
			</div>
			<div class="form-group">
				<select name="is_type" id="is_type">
					<option value="1" <cfif attributes.is_type eq 1>selected</cfif>>Cari</option>
					<option value="0" <cfif attributes.is_type eq 0>selected</cfif>>Potansiyel</option>
				</select>
			</div>
			<div class="form-group">
            	<cf_wrk_search_button search_function='hepsini_sec()' button_type="4">
			</div>
		</cf_box_search>
    </cfform>

		<cfif get_company_related.recordcount>
			<cfset customer_type_id_list = ''>
			<cfset main_location_cat_id_list = ''>
			<cfset endorsement_cat_id_list = ''>
			<cfset profitability_cat_id_list = ''>
			<cfset risk_cat_id_list = ''>
			<cfset special_state_cat_id_list = ''>
			
			<cfoutput query="get_company_related">
				<cfif len(customer_type_id) and not listfind(customer_type_id_list,customer_type_id)>
					<cfset customer_type_id_list=listappend(customer_type_id_list,customer_type_id)>
				</cfif>
				<cfif len(target_customer_type_id) and not listfind(customer_type_id_list,target_customer_type_id)>
					<cfset customer_type_id_list=listappend(customer_type_id_list,target_customer_type_id)>
				</cfif>	
				<cfif len(main_location_cat_id) and not listfind(main_location_cat_id_list,main_location_cat_id)>
					<cfset main_location_cat_id_list=listappend(main_location_cat_id_list,main_location_cat_id)>
				</cfif>
				<cfif len(endorsement_cat_id) and not listfind(endorsement_cat_id_list,endorsement_cat_id)>
					<cfset endorsement_cat_id_list=listappend(endorsement_cat_id_list,endorsement_cat_id)>
				</cfif>
				<cfif len(profitability_cat_id) and not listfind(profitability_cat_id_list,profitability_cat_id)>
					<cfset profitability_cat_id_list=listappend(profitability_cat_id_list,profitability_cat_id)>
				</cfif>
				<cfif len(risk_cat_id) and not listfind(risk_cat_id_list,risk_cat_id)>
					<cfset risk_cat_id_list=listappend(risk_cat_id_list,risk_cat_id)>
				</cfif>	
				<cfif len(special_state_cat_id) and not listfind(special_state_cat_id_list,special_state_cat_id)>
					<cfset special_state_cat_id_list=listappend(special_state_cat_id_list,special_state_cat_id)>
				</cfif>								
			</cfoutput>		
			<cfif len(customer_type_id_list)>
				<cfquery name="GET_CUSTOMER_TYPE" datasource="#DSN#">
					SELECT CUSTOMER_TYPE_ID,CUSTOMER_TYPE FROM SETUP_CUSTOMER_TYPE WHERE CUSTOMER_TYPE_ID IN (#customer_type_id_list#) ORDER BY CUSTOMER_TYPE_ID
				</cfquery>
				<cfset customer_type_list = listsort(listdeleteduplicates(valuelist(get_customer_type.customer_type_id,',')),'numeric','ASC',',')>
			</cfif>
			<cfif len(main_location_cat_id_list)>
				<cfquery name="GET_MAIN_LOCATION_CAT" datasource="#DSN#">
					SELECT MAIN_LOCATION_CAT_ID,MAIN_LOCATION_CAT FROM SETUP_MAIN_LOCATION_CAT WHERE MAIN_LOCATION_CAT_ID IN (#main_location_cat_id_list#) ORDER BY MAIN_LOCATION_CAT_ID
				</cfquery>
				<cfset main_location_cat_list = listsort(listdeleteduplicates(valuelist(get_main_location_cat.main_location_cat_id,',')),'numeric','ASC',',')>
			</cfif>
			<cfif len(endorsement_cat_id_list)>
				<cfquery name="GET_ENDORSEMENT_CAT" datasource="#DSN#">
					SELECT ENDORSEMENT_CAT_ID,ENDORSEMENT_CAT FROM SETUP_ENDORSEMENT_CAT WHERE ENDORSEMENT_CAT_ID IN (#endorsement_cat_id_list#) ORDER BY ENDORSEMENT_CAT_ID
				</cfquery>
				<cfset endorsement_cat_list = listsort(listdeleteduplicates(valuelist(get_endorsement_cat.endorsement_cat_id,',')),'numeric','ASC',',')>
			</cfif>
			<cfif len(profitability_cat_id_list)>
				<cfquery name="GET_PROFITABILITY_CAT" datasource="#DSN#">
					SELECT PROFITABILITY_CAT_ID,PROFITABILITY_CAT FROM SETUP_PROFITABILITY_CAT WHERE PROFITABILITY_CAT_ID IN (#profitability_cat_id_list#) ORDER BY PROFITABILITY_CAT_ID
				</cfquery>
				<cfset profitability_cat_list = listsort(listdeleteduplicates(valuelist(get_profitability_cat.profitability_cat_id,',')),'numeric','ASC',',')>
			</cfif>		
			<cfif len(risk_cat_id_list)>
				<cfquery name="GET_RISK_CAT" datasource="#DSN#">
					SELECT RISK_CAT_ID,RISK_CAT FROM SETUP_RISK_CAT WHERE RISK_CAT_ID IN (#risk_cat_id_list#) ORDER BY RISK_CAT_ID
				</cfquery>
				<cfset risk_cat_list = listsort(listdeleteduplicates(valuelist(get_risk_cat.risk_cat_id,',')),'numeric','ASC',',')>
			</cfif>
			<cfif len(special_state_cat_id_list)>
				<cfquery name="GET_SPECIAL_STATE_CAT" datasource="#DSN#">
					SELECT SPECIAL_STATE_CAT_ID,SPECIAL_STATE_CAT FROM SETUP_SPECIAL_STATE_CAT WHERE SPECIAL_STATE_CAT_ID IN (#special_state_cat_id_list#) ORDER BY SPECIAL_STATE_CAT_ID
				</cfquery>
				<cfset special_state_cat = listsort(listdeleteduplicates(valuelist(get_special_state_cat.special_state_cat_id,',')),'numeric','ASC',',')>
			</cfif>
        <cfoutput query="get_company_related">				
          <cf_flat_list>
			<thead>
				<tr>
					<th colspan="6" class="txtbold">#company_name# / #branch_name#</th>
					<th width="15"  style="text-align:right;">
					  <cfif listfind(branch_list_, branch_id, ',') neq 0>
						  <a href="javascript://" onClick="windowopen('#request.self#?fuseaction=crm.popup_upd_company_branch_contract&cpid=#attributes.cpid#&related_id=#related_id#&our_company_id=#comp_id#','list');"><i class="fa fa-pencil"></i></a>
					  </cfif>
				  </th>
			  </tr>
			</thead>
            
            <tr class="color-row">
              <td class="txtboldblue" width="135"><cf_get_lang no='1049.Mevcut Müşteri Tipi'></td>
              <td width="100"><cfif len(customer_type_id)>#get_customer_type.customer_type[listfind(customer_type_list,customer_type_id,',')]#</cfif></td>
              <td class="txtboldblue" width="150"><cf_get_lang no='1050.Hedeflenen Müşteri Tipi'></td>
              <td width="100"><cfif len(target_customer_type_id)>#get_customer_type.customer_type[listfind(customer_type_list,target_customer_type_id,',')]#</cfif></td>
              <td class="txtboldblue" width="135"><cf_get_lang no='1051.Ana Konum Kategorisi'></td>
              <td width="100"><cfif len(main_location_cat_id)>#get_main_location_cat.main_location_cat[listfind(main_location_cat_list,main_location_cat_id,',')]#</cfif></td>
            </tr>
            <tr class="color-row">
              <td class="txtboldblue" width="135"><cf_get_lang no='1052.Ciro Kategorisi'></td>
              <td width="100"><cfif len(endorsement_cat_id)>#get_endorsement_cat.endorsement_cat[listfind(endorsement_cat_list,endorsement_cat_id,',')]#</cfif></td>
              <td class="txtboldblue" width="150"><cf_get_lang no='1053.Karlılık Kategorisi'></td>
              <td width="100"><cfif len(profitability_cat_id)>#get_profitability_cat.profitability_cat[listfind(profitability_cat_list,profitability_cat_id,',')]#</cfif></td>
              <td class="txtboldblue" width="135"><cf_get_lang no='1054.Risk Kategorisi'></td>
              <td width="100"><cfif len(risk_cat_id)>#get_risk_cat.risk_cat[listfind(risk_cat_list,risk_cat_id,',')]#</cfif></td>
            </tr>
            <tr class="color-row">
              <td class="txtboldblue" width="135"><cf_get_lang no='1055.Özel Durum Kategorisi'></td>
              <td width="100"><cfif len(special_state_cat_id)>#get_special_state_cat.special_state_cat[listfind(special_state_cat_id_list,special_state_cat_id,',')]#</cfif></td>
              <td class="txtboldblue" width="150"></td>
              <td width="100"></td>
              <td class="txtboldblue" width="135"></td>
              <td width="100">&nbsp;</td>
            </tr>
		</cf_flat_list>
        </cfoutput>
      </cfif>
	</cf_box>
<cfif isdefined("attributes.is_open_popup") and len(attributes.is_open_popup)>
	<cfquery name="GET_STORE" datasource="#dsn#">
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
