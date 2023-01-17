<cfquery name="GET_CONTROL" datasource="#DSN#">
	SELECT COMPANY_BRANCH_CONTRACT_ID FROM COMPANY_BRANCH_CONTRACT WHERE RELATED_ID = #attributes.related_id#
</cfquery>

<cfquery name="GET_COMP" datasource="#DSN#">
	SELECT 
		COMPANY.FULLNAME,
		COMPANY.IMS_CODE_ID,
		COMPANY_PARTNER.COMPANY_PARTNER_NAME,
		COMPANY_PARTNER.COMPANY_PARTNER_SURNAME
	FROM
		COMPANY,
		COMPANY_PARTNER
	WHERE
		COMPANY.COMPANY_ID = #attributes.cpid# AND
		COMPANY.MANAGER_PARTNER_ID = COMPANY_PARTNER.PARTNER_ID
</cfquery>
<cfquery name="GET_RELATED" datasource="#DSN#">
	SELECT 
		*
	FROM 
		COMPANY_BRANCH_RELATED 
	WHERE 
		MUSTERIDURUM IS NOT NULL AND
		COMPANY_ID = #attributes.cpid# AND 
		RELATED_ID = #attributes.related_id#	
	ORDER BY 
		BRANCH_ID
</cfquery>
<cfquery name="GET_COM_BRANCH" datasource="#DSN#">
	SELECT 
		OUR_COMPANY.COMP_ID, 
		OUR_COMPANY.COMPANY_NAME, 
		BRANCH.BRANCH_NAME, 
		BRANCH.BRANCH_ID
	FROM 
		BRANCH, 
		OUR_COMPANY,
		EMPLOYEE_POSITION_BRANCHES
	WHERE 
		EMPLOYEE_POSITION_BRANCHES.POSITION_CODE = #session.ep.position_code# AND
		EMPLOYEE_POSITION_BRANCHES.BRANCH_ID = BRANCH.BRANCH_ID AND
		BRANCH.COMPANY_ID = OUR_COMPANY.COMP_ID AND
		BRANCH.BRANCH_ID = #get_related.branch_id#		
</cfquery>

<cfquery name="GET_CUSTOMER_TYPE" datasource="#DSN#">
	SELECT CUSTOMER_TYPE_ID,CUSTOMER_TYPE FROM SETUP_CUSTOMER_TYPE ORDER BY CUSTOMER_TYPE
</cfquery>
<cfquery name="GET_MAIN_LOCATION_CAT" datasource="#DSN#">
	SELECT MAIN_LOCATION_CAT_ID,MAIN_LOCATION_CAT FROM SETUP_MAIN_LOCATION_CAT ORDER BY MAIN_LOCATION_CAT
</cfquery>
<cfquery name="GET_ENDORSEMENT_CAT" datasource="#DSN#">
	SELECT ENDORSEMENT_CAT_ID,ENDORSEMENT_CAT FROM SETUP_ENDORSEMENT_CAT ORDER BY ENDORSEMENT_CAT
</cfquery>
<cfquery name="GET_PROFITABILITY_CAT" datasource="#DSN#">
	SELECT PROFITABILITY_CAT_ID,PROFITABILITY_CAT FROM SETUP_PROFITABILITY_CAT ORDER BY PROFITABILITY_CAT	
</cfquery>
<cfquery name="GET_RISK_CAT" datasource="#DSN#">
	SELECT RISK_CAT_ID,RISK_CAT FROM SETUP_RISK_CAT ORDER BY RISK_CAT
</cfquery>
<cfquery name="GET_SPECIAL_STATE_CAT" datasource="#DSN#">
	SELECT SPECIAL_STATE_CAT_ID,SPECIAL_STATE_CAT FROM SETUP_SPECIAL_STATE_CAT ORDER BY SPECIAL_STATE_CAT
</cfquery>
<cfsavecontent variable="title_">
    <cf_get_lang no='773.Anlaşma Bilgileri'> <cfoutput>#get_comp.fullname#</cfoutput>
    (<cf_get_lang no='601.Eczacı'> : <cfoutput>#get_comp.company_partner_name# #get_comp.company_partner_surname#</cfoutput>)
</cfsavecontent>
<cf_popup_box title="#title_#">
    <cfform name="form_upd_branch_contract" method="post" action="#request.self#?fuseaction=crm.emptypopup_upd_company_branch_contract">
    <input type="hidden" name="cpid" id="cpid" value="<cfoutput>#attributes.cpid#</cfoutput>">
    <input type="hidden" name="related_id" id="related_id" value="<cfoutput>#attributes.related_id#</cfoutput>">
    <input type="hidden" name="our_company_id" id="our_company_id" value="<cfoutput>#attributes.our_company_id#</cfoutput>">
    <input type="hidden" name="is_contract_req" id="is_contract_req" value="<cfoutput>#get_related.is_contract_required#</cfoutput>">
    <cfif len(get_related.update_date)>
        <input type="hidden" name="record_emp" id="record_emp" value="<cfoutput>#get_related.update_emp#</cfoutput>">
        <input type="hidden" name="record_ip" id="record_ip" value="<cfoutput>#get_related.update_ip#</cfoutput>">
        <input type="hidden" name="record_date" id="record_date" value="<cfoutput>#get_related.update_date#</cfoutput>">
    <cfelse>				
        <input type="hidden" name="record_emp" id="record_emp" value="<cfoutput>#get_related.record_emp#</cfoutput>">
        <input type="hidden" name="record_ip" id="record_ip" value="<cfoutput>#get_related.record_ip#</cfoutput>">
        <input type="hidden" name="record_date" id="record_date" value="<cfoutput>#get_related.record_date#</cfoutput>">
    </cfif>
    <table>
        <tr>
            <td width="135"><cf_get_lang_main no='41.Şube'></td>
            <td colspan="4">
                <cfoutput><b>#get_com_branch.company_name#/#get_com_branch.branch_name#</b></cfoutput>
            </td>
        </tr>					
        <tr>
            <td><cf_get_lang no="18.Müşterinin Mevcut Kategorisi"></td>
            <td width="160">
                <input type="hidden" name="old_customer_type" id="old_customer_type" value="<cfoutput><cfif len(get_related.customer_type_id)>#get_related.customer_type_id#</cfif></cfoutput>">
                <select name="customer_type" id="customer_type" style="width:150px;">
                    <option value=""><cf_get_lang_main no='322.Seçiniz'></option>
                    <cfoutput query="get_customer_type">
                        <option value="#customer_type_id#" <cfif customer_type_id eq get_related.customer_type_id>selected</cfif>>#customer_type#</option>
                    </cfoutput>
                </select>
            </td>
            <td></td>
            <td width="160"><cf_get_lang no="20.Müşterinin Hedeflenen Kategorisi"></td>
            <td>							
                <input type="hidden" name="old_target_customer_type" id="old_target_customer_type" value="<cfoutput><cfif len(get_related.target_customer_type_id)>#get_related.target_customer_type_id#</cfif></cfoutput>">
                    <select name="target_customer_type" id="target_customer_type" style="width:150px;">
                    <option value=""><cf_get_lang_main no='322.Seçiniz'></option>
                    <cfoutput query="get_customer_type">
                        <option value="#customer_type_id#" <cfif customer_type_id eq get_related.target_customer_type_id>selected</cfif>>#customer_type#</option>
                    </cfoutput>
                </select>						
            </td>						
        </tr>
        <tr>
            <td><cf_get_lang no="1051.Ana Konum Kategorisi"></td>
            <td>
                <input type="hidden" name="old_main_location_cat" id="old_main_location_cat" value="<cfoutput><cfif len(get_related.main_location_cat_id)>#get_related.main_location_cat_id#</cfif></cfoutput>">
                    <select name="main_location_cat" id="main_location_cat" style="width:150px;">
                    <option value=""><cf_get_lang_main no='322.Seçiniz'></option>
                    <cfoutput query="get_main_location_cat">
                        <option value="#main_location_cat_id#" <cfif main_location_cat_id eq get_related.main_location_cat_id>selected</cfif>>#main_location_cat#</option>
                    </cfoutput>
                </select>							
            </td>
            <td></td>
            <td><cf_get_lang no="1052.Ciro Kategorisi"></td>
            <td>
                <input type="hidden" name="old_endorsement_cat" id="old_endorsement_cat" value="<cfoutput><cfif len(get_related.endorsement_cat_id)>#get_related.endorsement_cat_id#</cfif></cfoutput>">
                    <select name="endorsement_cat" id="endorsement_cat" style="width:150px;">
                    <option value=""><cf_get_lang_main no='322.Seçiniz'></option>
                    <cfoutput query="get_endorsement_cat">
                        <option value="#endorsement_cat_id#" <cfif endorsement_cat_id eq get_related.endorsement_cat_id>selected</cfif>>#endorsement_cat#</option>
                    </cfoutput>
                </select>							
            </td>						
        </tr>
        <tr>
            <td><cf_get_lang no="1053.Karlılık Kategorisi"></td>
            <td>
                <input type="hidden" name="old_profitability_cat" id="old_profitability_cat" value="<cfoutput><cfif len(get_related.profitability_cat_id)>#get_related.profitability_cat_id#</cfif></cfoutput>">
                    <select name="profitability_cat" id="profitability_cat" style="width:150px;">
                    <option value=""><cf_get_lang_main no='322.Seçiniz'></option>
                    <cfoutput query="get_profitability_cat">
                        <option value="#profitability_cat_id#" <cfif profitability_cat_id eq get_related.profitability_cat_id>selected</cfif>>#profitability_cat#</option>
                    </cfoutput>
                </select>						
            </td>
            <td></td>
            <td><cf_get_lang no="1054.Risk Kategorisi"></td>
            <td>
                <input type="hidden" name="old_risk_cat" id="old_risk_cat" value="<cfoutput><cfif len(get_related.risk_cat_id)>#get_related.risk_cat_id#</cfif></cfoutput>">
                    <select name="risk_cat" id="risk_cat" style="width:150px;">
                    <option value=""><cf_get_lang_main no='322.Seçiniz'></option>
                    <cfoutput query="get_risk_cat">
                        <option value="#risk_cat_id#" <cfif risk_cat_id eq get_related.risk_cat_id>selected</cfif>>#risk_cat#</option>
                    </cfoutput>
                </select>						
            </td>						
        </tr>
        <tr>
            <td><cf_get_lang no="1055.Özel Durum Kategorisi"></td>
            <td>
                <input type="hidden" name="old_special_state_cat" id="old_special_state_cat" value="<cfoutput><cfif len(get_related.special_state_cat_id)>#get_related.special_state_cat_id#</cfif></cfoutput>">
                    <select name="special_state_cat" id="special_state_cat" style="width:150px;">
                    <option value=""><cf_get_lang_main no='322.Seçiniz'></option>
                    <cfoutput query="get_special_state_cat">
                        <option value="#special_state_cat_id#" <cfif special_state_cat_id eq get_related.special_state_cat_id>selected</cfif>>#special_state_cat#</option>
                    </cfoutput>
                </select>							
            </td>
            <td></td>
            <td></td>
            <td></td>						
        </tr>
      </table>				
      </cfform>
      <cf_popup_box_footer><cf_workcube_buttons is_upd='1' is_delete='0' add_function='kontrol()'></cf_popup_box_footer>
    </table>
</cf_popup_box>
<script type="text/javascript">
function kontrol()
{	
	//Ilgili subeye ait bir anlaşma kaydi var veya sube detayında anlasma bilgisi zorunlu
	<cfif get_control.recordcount or get_related.is_contract_required eq 1>
		x1 = document.form_upd_branch_contract.customer_type.selectedIndex;
		if (document.form_upd_branch_contract.customer_type[x1].value == "")
		{
			alert ("<cf_get_lang dictionary_id='33525.Lütfen Mevcut Müşteri Tipi Seçiniz'>!");
			return false;
		}
		
		x2 = document.form_upd_branch_contract.target_customer_type.selectedIndex;
		if (document.form_upd_branch_contract.target_customer_type[x2].value == "")
		{
			alert ("<cf_get_lang dictionary_id='33524.Lütfen Hedeflenen Müşteri Tipi Seçiniz'>!");
			return false;
		}

		x3 = document.form_upd_branch_contract.main_location_cat.selectedIndex;
		if (document.form_upd_branch_contract.main_location_cat[x3].value == "")
		{
			alert ("<cf_get_lang dictionary_id='33523.Lütfen Ana Konum Kategorisi Seçiniz'>!");
			return false;
		}

		x4 = document.form_upd_branch_contract.endorsement_cat.selectedIndex;
		if (document.form_upd_branch_contract.endorsement_cat[x4].value == "")
		{
			alert ("<cf_get_lang dictionary_id='33520.Lütfen Ciro Kategorisi Seçiniz'>!");
			return false;
		}

		x5 = document.form_upd_branch_contract.profitability_cat.selectedIndex;
		if (document.form_upd_branch_contract.profitability_cat[x5].value == "")
		{
			alert ("<cf_get_lang dictionary_id='33519.Lütfen Karlılık Kategorisi Seçiniz'>!");
			return false;
		}

		x6 = document.form_upd_branch_contract.risk_cat.selectedIndex;
		if (document.form_upd_branch_contract.risk_cat[x6].value == "")
		{
			alert ("<cf_get_lang dictionary_id='33518.Lütfen Risk Kategorisi Seçiniz'>!");
			return false;
		}

		x7 = document.form_upd_branch_contract.special_state_cat.selectedIndex;
		if (document.form_upd_branch_contract.special_state_cat[x7].value == "")
		{
			alert ("<cf_get_lang dictionary_id='33653.Lütfen Özel Durum Kategorisi Seçiniz'>!");
			return false;
		}
		return true;
	<cfelse>
		return true;
	</cfif>
}
</script>
