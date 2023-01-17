<cfset wrk = createObject("component","V16.worknet.cfc.worknet")>
<cfset cmp = createObject("component","V16.worknet.cfc.worknet_add_member")>
<cfset company_cmp = createObject("component","V16.member.cfc.member_company")>
<cfset get_our_cmp = company_cmp.GET_OURCMP_INFO(company_id : session.ep.company_id)>
<cfset get_all_worknet = wrk.select(status : 1)>
<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
    <cf_box>
        <div class="watalogy-head">
            <img src="css/assets/icons/catalyst-icon-svg/watalogy-logo.svg">
        </div>
        <div class="w-cards">
            <cfoutput query="get_all_worknet">
                <div class="col col-3 col-md-3 col-sm-4 col-xs-12">
                    <div class="watalogy-cards">
                        <cf_get_server_file output_file="asset/watalogyImages/#IMAGE_PATH#" output_server="#SERVER_IMAGE_PATH_ID#" output_type="0" image_class="w-cards">
                        <cfif get_our_cmp.IS_WATALOGY_INTEGRATED eq 1 and len(get_our_cmp.WATALOGY_MEMBER_CODE)>
                            <cfset getRelationCompany = cmp.getRelationCompany( wrkid: WORKNET_ID)>
                            <cfif getRelationCompany.recordcount gt 0>
                                <span onclick="javascript:location.href='#request.self#?fuseaction=watalogy.marketplace&event=det&wid=#WORKNET_ID#'" class="integration-button"><cf_get_lang dictionary_id='63676.Yönet'></span>
                            <cfelse>
                                <span onclick="javascript:location.href='#request.self#?fuseaction=watalogy.marketplace&event=det&wid=#WORKNET_ID#'" class="integration-button"><cf_get_lang dictionary_id='63687.Entegre Ol'></span>
                            </cfif>                           
                        <cfelse>
                            <span onclick="javascript:openBoxDraggable('#request.self#?fuseaction=watalogy.marketplace&event=add&worknet_id=#WORKNET_ID#','','ui-draggable-box-medium')" class="integration-button"><cf_get_lang dictionary_id='65264.Watalogy Servislerini Başlat'></span>
                        </cfif>
                    </div>
                </div>
            </cfoutput>
        </div>
    </cf_box>
</div>