<!---
    File: V16\report\display\wai_settings.cfm
    Author: Esma R. Uysal <esmauysal@workcube.com>
    Date: 2021-11-09
    Description: Wai tanımları
--->
<cfset get_component = createObject("component","V16.report.cfc.wai_settings") />
<cfset get_wai_settings = get_component.GET_WAI_SETTINGS() />

<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
    <cfform name="wai_settings">
        <cf_box title="#getLang('','WAI Ayarları',64210)#" scroll="1" collapsable="1" resize="1" popup_box="#iif(isdefined("attributes.draggable"),1,0)#">
            <cf_box_elements>
                <div class="col col-12 col-md-12 col-sm-12 col-xs-12" type="column" index="1" sort="true">
                    <div class="form-group" id="item-name">
                        <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='64211.Wai size nasıl hitap etsin?'></label>
                        <div class="col col-8 col-xs-12">
                            <input type="text" name="name" id="name" value="<cfoutput><cfif get_wai_settings.recordcount>#get_wai_settings.name#<cfelse>#session.ep.name#</cfif></cfoutput>" required>
                        </div>
                    </div>
                    <div class="form-group" id="item-period">
                        <label class="col col-4 col-xs-12" for="period"><cf_get_lang dictionary_id='64212.Wai hangi periyotta size düzenli bilgi versin?'></label>
                        <div class="col col-8 col-xs-12">
                            <select id="period" name="period">
                                <option value="1" <cfif get_wai_settings.period eq 1>selected</cfif>><cf_get_lang dictionary_id='58457.Günlük'></option>
                                <option value="2" <cfif get_wai_settings.period eq 2>selected</cfif>><cf_get_lang dictionary_id='58458.Haftalık'></option>
                                <option value="3" <cfif get_wai_settings.period eq 3>selected</cfif>><cf_get_lang dictionary_id='58932.Aylık'></option>
                            </select>
                        </div>
                    </div>
                </div>
            </cf_box_elements>
            <cf_box_footer>
                <div class="col col-23">
                    <cfif get_wai_settings.recordcount>
                        <cf_workcube_buttons is_upd='1' data_action="V16/report/cfc/wai_settings:UPD_WAI_SETTINGS" next_page="#request.self#?fuseaction=report.welcome" is_delete="0">
                    <cfelse>
                        <cf_workcube_buttons is_insert='1' data_action="V16/report/cfc/wai_settings:ADD_WAI_SETTINGS" next_page="#request.self#?fuseaction=report.welcome" >
                    </cfif>
                </div>
            </cf_box_footer>
        </cf_box>
    </cfform>
</div>
