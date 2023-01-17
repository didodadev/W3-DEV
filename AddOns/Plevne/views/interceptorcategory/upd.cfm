<cfinclude template="../../config.cfm" runonce="true">
<cfinclude template="../../models/types.cfm" runonce="true">

<cfobject name="inst_interceptor_categories" type="component" component="#addonns#.domains.interceptor_categories">
<cfset query_interceptor_category = inst_interceptor_categories.get_interceptor_categories(interceptor_category_id: attributes.id)>
<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
    <cf_box title="#getLang('','Kurumsal Üyeler',29408)#" scroll="1" collapsable="1" resize="1" popup_box="#iif(isdefined("attributes.draggable"),1,0)#">
        <cfform name="add_form" method="post">
            <input type="hidden" name="interceptor_category_id" value="<cfoutput>#attributes.id#</cfoutput>"> 
            <cf_box_elements>
                <div class="col col-4 col-md-4 col-sm-6 col-xs-12" type="column" index="1" sort="true">
                    <div class="form-group" id="item-title">
                        <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id="58233.Tanım"></label>
                        <div class="col col-8 col-xs-12">
                            <input type="text" name="title" value="<cfoutput>#query_interceptor_category.title#</cfoutput>" required>
                        </div>
                    </div>
                </div>
                <div class="col col-4 col-md-4 col-sm-6 col-xs-12" type="column" index="2" sort="true">
                    <div class="form-group" id="item-">
                        <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id="57982.Tür"></label>
                        <div class="col col-8 col-xs-12">
                            <cfoutput>
                            <select name="kind" id="kind">
                                <option value="#plevne_kinds.REQUEST_FILTER#" <cfif query_interceptor_category.interceptor_kind eq plevne_kinds.REQUEST_FILTER>selected</cfif>>Request Filter</option>
                            </select>
                            </cfoutput>
                        </div>
                    </div>
                </div>
                <div class="col col-4 col-md-4 col-sm-6 col-xs-12" type="column" index="3" sort="true">
                    <div class="form-group" id="item-status">
                        <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id="57756.Durum"></label>
                        <div class="col col-8 col-xs-12">
                            <select name="status" id="status">
                                <option value="1" <cfif query_interceptor_category.status eq 1>selected</cfif>><cf_get_lang dictionary_id='57493.Aktif'></option>
                                <option value="0" <cfif query_interceptor_category.status eq 0>selected</cfif>><cf_get_lang dictionary_id='57494.Pasif'></option>
                            </select>
                        </div>
                    </div>
                </div>
            </cf_box_elements>
            <cf_box_footer>
                <cf_workcube_buttons is_upd='0' add_function='kontrol()'>
            </cf_box_footer>
        </cfform>
    </cf_box>
</div>
<script type="text/javascript">
    function kontrol() {
        return document.getElementById("add_form").checkValidity();
    }
</script>