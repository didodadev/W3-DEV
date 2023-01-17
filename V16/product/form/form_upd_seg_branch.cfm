<cfinclude template="../query/get_branches.cfm">
<cfsavecontent variable="right_">
	<a href="javascript://" onClick="windowopen('<cfoutput>#request.self#?fuseaction=product.popup_add_seg_branch&id=#attributes.id#</cfoutput>','page');"><img src="/images/plus1.gif" title="<cf_get_lang dictionary_id='57582.Ekle'>"></a>
</cfsavecontent>
<!--- <cf_catalystHeader> --->
<cfparam name="attributes.modal_id" default="">
<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
    <cf_box title="#getLang('','Ürün Hedef Pazar',37251)# : #attributes.ID#" collapsable="0" resize="0" popup_box="#iif(isdefined("attributes.draggable"),1,0)#">
        <cfform name="upd_seg_branch" method="post" action="#request.self#?fuseaction=product.emptypopup_upd_seg_pro&pro_seg_id=#attributes.ID#">
            <cfoutput>
                <input type="hidden" name="pro_seg_id" id="pro_seg_id" value="#attributes.ID#">
                <input type="hidden" name="id" id="id" value="#attributes.ID#">
                <cfif isdefined("attributes.draggable")>
                    <cfinput type="hidden" name="draggable" id="draggable" value="#attributes.draggable#">
                    <cfinput type="hidden" name="modal_id" id="modal_id" value="#attributes.modal_id#">
                </cfif>
            </cfoutput>
            <cf_box_elements vertical="1">
                <div class="col col-3 col-md-4 col-sm-6 col-xs-12" type="column" index="1" sort="false">
                    <div class="form-group scrollContent scroll-x2" id="item-">
                    <cfif get_branch.recordcount>
                        <cfoutput query="get_branch">
                            <cfquery name="get_pro_seg_branch" datasource="#DSN1#">
                                SELECT * FROM PRODUCT_SEGMENT_BRANCH WHERE PRODUCT_SEGMENT_ID = #URL.ID# AND PRODUCT_SEGMENT_BRANCH_ID = #BRANCH_ID#
                            </cfquery>
                            <label><input type="checkbox" name="BRANCH_ID" id="BRANCH_ID" value="#BRANCH_ID#" <cfif get_pro_seg_branch.RECORDCOUNT>checked</cfif>>#BRANCH_NAME#</label><br />
                        </cfoutput>
                    <cfelse>
                        <label><cf_get_lang dictionary_id='57484.Kayıt Yok'>!</label>
                    </cfif>
                </div>
                <cf_box_footer>
                    <cf_workcube_buttons type_format='1' is_upd='0' add_function='#iif(isdefined("attributes.draggable"),DE("loadPopupBox('upd_product_segment' , #attributes.modal_id#)"),DE(""))#'>
                </cf_box_footer>
            </cf_box_elements>
        </cfform>
    </cf_box>
</div>
