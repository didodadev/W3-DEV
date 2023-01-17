<cfquery name="get_asset_contract" datasource="#dsn#">
	SELECT 
		ASSET_ID,
		CONTRACT_HEAD,
		DETAIL,
		SUPPORT_COMPANY_ID,
		SUPPORT_AUTHORIZED_ID,
		SUPPORT_EMPLOYEE_ID,
		SUPPORT_START_DATE,
		SUPPORT_FINISH_DATE,
		SUPPORT_CAT_ID,
		USE_CERTIFICATE,
		USE_CERTIFICATE_SERVER_ID,
		RECORD_EMP,
		RECORD_DATE,
		UPDATE_EMP,
		UPDATE_DATE
	FROM
		ASSET_CARE_CONTRACT
	WHERE
		ASSET_ID = #url.asset_id# AND 
		ASSET_CARE_CONTRACT_ID = #url.asset_care_contract_id# 
</cfquery>
<cfsavecontent variable="img"><a href="<cfoutput>#request.self#?fuseaction=assetcare.popup_add_asset_contract&asset_id=#asset_id#</cfoutput>"><span class="icn-md icon-add" alt="<cf_get_lang_main no='170.Ekle'>" title="<cf_get_lang_main no='170.Ekle'>"></span></a></cfsavecontent>
<cf_box title="#getLang('assetcare',15)#" right_images="#img#">
    <cfform name="asset_contract" action="#request.self#?fuseaction=assetcare.emptypopup_upd_asset_contract" method="post" enctype="multipart/form-data">
        <input type="hidden" name="asset_id" id="asset_id" value="<cfoutput>#attributes.asset_id#</cfoutput>">  
        <input type="hidden" name="asset_care_contract_id"  id="asset_care_contract_id" value="<cfoutput>#attributes.asset_care_contract_id#</cfoutput>">
        <cf_box_elements vertical="1">
            <div class="form-group col col-4 col-md-4 col-sm-4 col-xs-12">
                <label><cf_get_lang_main no='68.Başlık'> *</label>
                <div><cfinput type="text" style="width:150;" name="contract_head" maxlength="100" value="#get_asset_contract.CONTRACT_HEAD#" required="yes" message="Başlık Girmelisiniz !"></div>
                
            </div>
            <div class="form-group col col-4 col-md-4 col-sm-4 col-xs-12">
                <label width="100"><cf_get_lang_main no='1655.Varlık'> *</label>
                <div>
                    <cfquery name="get_asset_name" datasource="#DSN#">
                        SELECT ASSETP FROM ASSET_P WHERE ASSETP_ID = #url.asset_id#
                    </cfquery>
                    <input type="text" name="asset_name" id="asset_name" value="<cfoutput>#get_asset_name.ASSETP#</cfoutput>" >
                </div>
            </div>
            <div class="form-group col col-4 col-md-4 col-sm-4 col-xs-12">
                <label><cf_get_lang no='56.Destek Firması'></label>
                <div class="input-group">
                    <cfif len(get_asset_contract.SUPPORT_COMPANY_ID)>
                    <input type="hidden" name="company_id"  id="company_id" value="<cfoutput>#get_asset_contract.SUPPORT_COMPANY_ID#</cfoutput>">
                    <input type="text" name="support_company_id" id="support_company_id" value="<cfoutput>#get_par_info(GET_ASSET_CONTRACT.SUPPORT_COMPANY_ID,1,0,0)#</cfoutput>"  readonly>
                    <cfelse>
                        <input type="hidden" name="company_id" id="company_id" value="">
                        <input type="text" name="support_company_id" id="support_company_id" value=""  readonly>
                    </cfif>
                    <span class="input-group-addon icon-add"class="icn-md icon-add" onClick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_pars&field_id=asset_contract.authorized_id&field_comp_name=asset_contract.support_company_id&field_name=asset_contract.support_authorized_id&field_comp_id=asset_contract.company_id&select_list=2,3,5,6','list');"></span>
                </div>
                
            </div>
            <div class="form-group col col-4 col-md-4 col-sm-4 col-xs-12">
                <label><cf_get_lang no='57.Destek Yetkili'></label>
                <div>
                    <cfif len(get_asset_contract.SUPPORT_AUTHORIZED_ID)>
                        <input type="hidden" name="authorized_id" id="authorized_id" value="<cfoutput>#get_asset_contract.SUPPORT_AUTHORIZED_ID#</cfoutput>">
                        <input type="text" name="support_authorized_id" id="support_authorized_id" value="<cfoutput>#get_par_info(get_asset_contract.SUPPORT_AUTHORIZED_ID,0,-1,0)#</cfoutput>"  readonly>
                    <cfelse>
                        <input type="hidden" name="authorized_id" id="authorized_id" value="">
                        <input type="text" name="support_authorized_id" id="support_authorized_id" value=""  readonly>
                    </cfif>
                </div>
            </div>
            <div class="form-group col col-4 col-md-4 col-sm-4 col-xs-12">
                <label><cf_get_lang no='58.Destek Çalışan'></label>
                <div class="input-group">
                    <cfif len(get_asset_contract.SUPPORT_EMPLOYEE_ID)>
                        <input type="hidden" name="employee_id" id="employee_id" value="<cfoutput>#get_asset_contract.SUPPORT_EMPLOYEE_ID#</cfoutput>">
                        <input type="text" name="employee" id="employee" value="<cfoutput>#get_emp_info(get_asset_contract.SUPPORT_EMPLOYEE_ID,1,0)#</cfoutput>"  readonly>
                    <cfelse>
                        <input type="hidden" name="employee_id" id="employee_id" value="">
                        <input type="text" name="employee" id="employee" value=""  readonly>
                    </cfif>
                    <span class="input-group-addon icon-add" onClick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_positions&field_id=asset_contract.employee_id&field_name=asset_contract.employee&select_list=1','list');"></span>
                </div>
            </div>
            <div class="form-group col col-4 col-md-4 col-sm-4 col-xs-12">
                <label><cf_get_lang no='59.Destek Başlangıç'></label>
                <div class="input-group">
                    <cfsavecontent variable="message"><cf_get_lang_main no='782.girilmesi zorunlu alan'>:<cf_get_lang no='59.Destek Başlangıç !'></cfsavecontent>
                    <cfif len(get_asset_contract.support_start_date)>
                        <cfinput type="text" name="support_start_date" validate="#validate_style#" maxlength="10" value="#dateformat(get_asset_contract.support_start_date,dateformat_style)#"  message="#message#">
                    <cfelse>
                        <cfinput type="text" name="support_start_date" validate="#validate_style#" maxlength="10" value=""  message="#message#">
                    </cfif>
                    <span class="input-group-addon"><cf_wrk_date_image date_field="support_start_date"></span>
                </div>
            </div>
            <div class="form-group col col-4 col-md-4 col-sm-4 col-xs-12">
                <label><cf_get_lang no='60.Destek Bitiş'></label>
                <div class="input-group">
                    <cfsavecontent variable="message"><cf_get_lang_main no='782.girilmesi zorunlu alan'>:<cf_get_lang no='60.Destek Bitiş !'></cfsavecontent>
                    <cfif len(get_asset_contract.support_finish_date)> 
                        <cfinput type="text" name="support_finish_date" validate="#validate_style#" maxlength="10" value="#dateformat(get_asset_contract.support_finish_date,dateformat_style)#"  message="#message#">
                    <cfelse>
                        <cfinput type="text" name="support_finish_date" validate="#validate_style#" maxlength="10" value=""  message="#message#">
                    </cfif>
                    <span class="input-group-addon"><cf_wrk_date_image date_field="support_finish_date"></span>
                </div>
            </div>
            <div class="form-group col col-4 col-md-4 col-sm-4 col-xs-12">
                <label><cf_get_lang no='62.Destek Kategorisi'></label>
                <div><cf_wrk_combo
                            name="support_cat"
                            query_name="GET_ASSET_TAKE_SUPPORT_CAT"
                            option_name="TAKE_SUP_CAT"
                            option_value="TAKE_SUP_CATID"
                            value="#get_asset_contract.support_cat_id#"
                            width="150">
                </div>
            </div>
            <div class="form-group col col-4 col-md-4 col-sm-4 col-xs-12">
                <label><cf_get_lang no='68.Destek Belgesi'></label>
                <div>
                    <input type="file" name="document" id="document">
                    <cfif len(get_asset_contract.use_certificate)>
                        <cf_get_server_file output_file="assetcare/#get_asset_contract.use_certificate#" output_server="#get_asset_contract.use_certificate_server_id#" output_type="2" small_image="images/asset.gif" image_link="1">
                    </cfif>
                </div>
            </div>
            <div class="form-group col col-4 col-md-4 col-sm-4 col-xs-12">
                <label><cf_get_lang_main no='217.Açıklama'></label>
                <textarea div name="detail" id="detail"><cfoutput>#get_asset_contract.DETAIL#</cfoutput></textarea>
            </div>
        <!--- <tr>
                <td colspan="2">
                    <cf_get_lang_main no='71.Kayıt'>: <cfoutput>#get_emp_info(get_asset_contract.record_emp,0,0)# - #dateformat(get_asset_contract.record_date,dateformat_style)#</cfoutput>
                    <cfif len(get_asset_contract.update_emp)>
                        <br/><cf_get_lang_main no='291.Güncelleme'>: <cfoutput>#get_emp_info(get_asset_contract.update_emp,0,0)# - #dateformat(get_asset_contract.update_date,dateformat_style)#</cfoutput>
                    </cfif>
                </td>
            </tr>--->
        </cf_box_elements>
        <cf_box_footer>
            <cf_record_info query_name="get_asset_contract">
            <cf_workcube_buttons is_upd='1' delete_page_url='#request.self#?fuseaction=assetcare.emptypopup_del_asset_care_contract&assetp_id=#url.asset_id#&contract_id=#url.asset_care_contract_id#'>
        </cf_box_footer>
    </cfform>
</cf_box>
