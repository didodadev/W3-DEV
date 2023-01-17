<cfinclude template="../query/get_titles.cfm">
<cfquery name="GET_ORGANIZATION_STEPS" datasource="#DSN#">
	SELECT 
		ORGANIZATION_STEP_ID,
		ORGANIZATION_STEP_NAME
	FROM
		SETUP_ORGANIZATION_STEPS
	ORDER BY
		ORGANIZATION_STEP_NAME
</cfquery>
<cfquery name="GET_UNITS" datasource="#DSN#">
	SELECT UNIT_ID,UNIT_NAME FROM SETUP_CV_UNIT WHERE IS_ACTIVE = 1 ORDER BY UNIT_NAME
</cfquery>
<cfif not (isdefined("attributes.isAjax") and len(attributes.isAjax))>
    <cf_catalystHeader>
</cfif>
<cfsavecontent variable="title"><cf_get_lang dictionary_id = "57779.Pozisyon tipleri"> : <cf_get_lang dictionary_id = "45697.Yeni Kayıt"></cfsavecontent>
<cf_box title="#title#" closable="0">
<cfform action="#request.self#?fuseaction=hr.emptypopup_add_position_cat" method="post" name="position">
    <cfif isdefined("attributes.isAjax") and len(attributes.isAjax)>
        <cfoutput>
            <input type="hidden" name="callAjax" id="callAjax" value = "1">
            <input type="hidden" name="branch_id" id="branch_id" value = "#attributes.branch_id#">
            <input type="hidden" name="branch" id="branch" value = "#attributes.branch#">
            <input type="hidden" name="comp_id" id="comp_id" value = "#attributes.comp_id#">
            <input type="hidden" name="department_id" id="department_id" value = "#attributes.department_id#">
            <input type="hidden" name="department" id="department" value = "#attributes.department#">
        </cfoutput>
    </cfif>
   
<!---     <cfif isDefined("attributes.isAjax") and attributes.isAjax eq 1><!--- Organizasyon Yönetimi sayfasından Ajax ile yüklendiyse --->
		<cf_box title="#title#" closable="0">
    </cfif> --->
                    <cf_box_elements>
                        <div class="col col-6 col-md-6 col-sm-6 col-xs-12" type="column" index="1" sort="true">
                            <div class="form-group" id="item-position_cat_status">
                                <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57756.Durum'></label>
                                <div class="col col-8 col-xs-12">
                                    <label><input type="checkbox" name="position_cat_status" id="position_cat_status" value="1" checked><cf_get_lang dictionary_id ='57493.Aktif'></label>
                                </div>
                            </div>
                            <div class="form-group" id="item-position_cat">
                                <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='58820.Başlık'> *</label>
                                <div class="col col-8 col-xs-12">
                                    <cfsavecontent variable="message"><cf_get_lang dictionary_id='58194.girilmesi zorunlu alan'>:<cf_get_lang dictionary_id='58820.Başlık'></cfsavecontent>
                                    <cfinput type="Text" name="position_cat" id="position_cat" value="" maxlength="100" required="Yes" message="#message#">
                                </div>
                            </div>
                            <div class="form-group" id="item-position_detail">
                                <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57629.Açıklama'></label>
                                <div class="col col-8 col-xs-12">
                                    <textarea name="position_detail" id="position_detail" style="width:200px;height:60px;"></textarea>
                                </div>
                            </div>
                            <div class="form-group" id="item-hierarchy">
                                <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57761.Hiyerarşi'></label>
                                <div class="col col-8 col-xs-12">
                                    <input type="text" name="hierarchy" id="hierarchy" maxlength="50" value="">
                                </div>
                            </div>
                            <div class="form-group" id="item-position_cat_upper_type">
                                <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id ='58572.Kullanım'></label>
                                <div class="col col-8 col-xs-12">
                                    <label><input type="checkbox" name="position_cat_upper_type" id="position_cat_upper_type" value="1"><cf_get_lang dictionary_id ='58573.Merkez'></label>
                                    <label><input type="checkbox" name="position_cat_type" id="position_cat_type" value="1"><cf_get_lang dictionary_id ='57453.Şube'></label>
                                </div>
                            </div>
                            <div class="form-group" id="item-title_id">
                                <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57571.Ünvan'></label>
                                <div class="col col-8 col-xs-12">
                                    <select name="title_id" id="title_id">
                                    <option value=""><cf_get_lang dictionary_id='57734.Seçiniz'></option>
                                    <cfoutput query="titles"> 
                                        <option value="#title_id#">#title#</option> 
                                    </cfoutput>
                                    </select>
                                </div>
                            </div>
                            <div class="form-group" id="item-ORGANIZATION_STEP_ID">
                                <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='58710.Kademe'></label>
                                <div class="col col-8 col-xs-12">
                                    <select name="ORGANIZATION_STEP_ID" id="ORGANIZATION_STEP_ID">
                                        <option value=""><cf_get_lang dictionary_id='57734.Seçiniz'></option>
                                        <cfoutput query="get_organization_steps">
                                            <option value="#organization_step_id#">#organization_step_name#</option>
                                        </cfoutput>
                                    </select>
                                </div>
                            </div>
                            <div class="form-group" id="item-collar_type">
                                <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='56063.Yaka Tipi'></label>
                                <div class="col col-8 col-xs-12">
                                    <select name="collar_type" id="collar_type">
                                        <option value=""><cf_get_lang dictionary_id='57734.Seçiniz'></option>
                                        <option value="1"><cf_get_lang dictionary_id='56065.Mavi Yaka'></option> 
                                        <option value="2"><cf_get_lang dictionary_id='56066.Beyaz Yaka'></option>
                                    </select>
                                </div>
                            </div>
                            <div class="form-group" id="item-func_id">
                                <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='58701.Fonksiyon'></label>
                                <div class="col col-8 col-xs-12">
                                    <select name="func_id" id="func_id">
                                        <option value=""><cf_get_lang dictionary_id='57734.Seçiniz'>
                                        <cfoutput query="get_units">
                                            <option value="#get_units.unit_id#">#unit_name#</option>
                                        </cfoutput>
                                    </select>
                                </div>
                            </div>
                            <div class="form-group" id="item-business_code">
                                <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='55900.Meslek Grubu'></label>
                                <div class="col col-8 col-xs-12">
                                    <div class="input-group">
                                        <input type="hidden" name="business_code_id" id="business_code_id" value="">
                                        <input type="text" name="business_code" id="business_code" value="">
                                        <span class="input-group-addon icon-ellipsis btnPointer" onclick="openBoxDraggable('<cfoutput>#request.self#?fuseaction=objects.popup_list_business_codes&field_id=position.business_code_id&field_name=position.business_code</cfoutput>');"></span>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </cf_box_elements>
                    <div class="ui-form-list-btn">
                        <cf_workcube_buttons type_format="1" is_upd='0'>
                    </div>
               
   
</cfform>
</cf_box>