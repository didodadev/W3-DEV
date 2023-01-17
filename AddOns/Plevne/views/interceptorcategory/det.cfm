<cfinclude template="../../config.cfm" runonce="true">
<cfinclude template="../../models/types.cfm" runonce="true">

<cfobject name="inst_interceptor_categories" type="component" component="#addonns#.domains.interceptor_categories">
<cfset query_interceptor_category = inst_interceptor_categories.get_interceptor_categories(interceptor_category_id: attributes.id)>
<cf_catalystHeader>
<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
    <div class="row">
        <div class="col col-9 col-xs-12">
            <cf_box title="#getLang(dictionary_id: "57529")#">
                    <cf_box_elements>
                        <div class="col col-3 col-md-4 col-sm-6 col-xs-12" type="column" index="1" sort="true">
                            <div class="form-group" id="item-title">
                                <label class="col col-4 col-xs-12"><strong><cf_get_lang dictionary_id="58233.Tanım"></strong></label>
                                <div class="col col-8 col-xs-12">
                                    <cfoutput>#query_interceptor_category.title#</cfoutput>
                                </div>
                            </div>
                        </div>
                        <div class="col col-3 col-md-4 col-sm-6 col-xs-12" type="column" index="2" sort="true">
                            <div class="form-group" id="item-">
                                <label class="col col-4 col-xs-12"><strong><cf_get_lang dictionary_id="57982.Tür"></strong></label>
                                <div class="col col-8 col-xs-12">
                                    <cfoutput>
                                    <cfdump var="#structFindValue(plevne_kinds, query_interceptor_category.interceptor_kind)[1].KEY#">
                                    </cfoutput>
                                </div>
                            </div>
                        </div>
                        <div class="col col-3 col-md-4 col-sm-6 col-xs-12" type="column" index="3" sort="true">
                            <div class="form-group" id="item-status">
                                <label class="col col-4 col-xs-12"><strong><cf_get_lang dictionary_id="57756.Durum"></strong></label>
                                <div class="col col-8 col-xs-12">
                                    <cfoutput>
                                        <cfif query_interceptor_category.status eq "1">
                                            <cf_get_lang dictionary_id='57493.Aktif'>
                                        <cfelse>
                                            <cf_get_lang dictionary_id='57494.Pasif'>
                                        </cfif>
                                    </cfoutput>
                                </div>
                            </div>
                        </div>
                    </cf_box_elements>
            </cf_box>
            <cf_box 
                title="interceptor" 
                id="main_interceptor_list" 
                box_page="#request.self#?fuseaction=plevne.interceptor&ajax=1&interceptor_category_id=#query_interceptor_category.interceptor_category_id#"
                add_href="#request.self#?fuseaction=plevne.interceptor&event=add&ajax=1&interceptor_category_id=#query_interceptor_category.interceptor_category_id#"
                >
            </cf_box>
        </div>
    </div>
</div>
