<cf_xml_page_edit fuseact="settings.popup_form_add_county">
<cfquery name="GET_CITY" datasource="#DSN#">
    SELECT
        CITY_NAME 
    FROM 
        SETUP_CITY 
    WHERE 
        CITY_ID = #attributes.city_id#
</cfquery>
<cfquery name="GET_SPECIAL_STATE" datasource="#DSN#">
    SELECT
        SPECIAL_STATE_CAT_ID,
        SPECIAL_STATE_CAT 
    FROM 
        SETUP_SPECIAL_STATE_CAT 
    ORDER BY 
        SPECIAL_STATE_CAT
</cfquery>
<div class="col col-12 col-md-12 col-xs-12 col-sm-12">
    <cf_box title="#getLang('','İlçe Ekle','43480')#" scroll="1" collapsable="1" resize="1" popup_box="#iif(isdefined("attributes.draggable"),1,0)#">
        <cfform name="add_country" method="post" action="#request.self#?fuseaction=settings.emptypopup_add_county">
            <cf_box_elements>
                <div class="col col-6 col-md-6 col-sm-6 col-xs-12" type="column" index="1" sort="true">
                    <input type="hidden" name="city_id" id="city_id" value="<cfoutput>#attributes.city_id#</cfoutput>">
                    <div class="form-group">
                        <label class="col col-6"><cf_get_lang dictionary_id='43364.İl Adı'></label>
                        <cfoutput>#get_city.city_name#</cfoutput>
                    </div>
                    <div class="form-group">
                        <label class="col col-6"><cf_get_lang dictionary_id='43481.İlçe Adı'>*</label>
                        <cfinput type="text" name="county_name" required="Yes" message="#getLang('','İlçe Girmelisiniz','63598')#" maxlength="50">
                    </div>
                    <cfif xml_dsp_special_state>
                        <div class="form-group">
                            <label class="col col-6"><cf_get_lang dictionary_id='34141.Özel Durum'></label>
                            <select name="special_state" id="special_state">
                                <option value=""><cf_get_lang dictionary_id='57734.Seçiniz'></option>
                                <cfoutput query="get_special_state">
                                    <option value="#special_state_cat_id#">#special_state_cat#</option>
                                </cfoutput>
                            </select>
                        </div>
                    </cfif>
                </div>
            </cf_box_elements>
            <cf_box_footer>
                <cf_workcube_buttons is_upd='0'>
            </cf_box_footer>
        </cfform>
    </cf_box>
</div>
