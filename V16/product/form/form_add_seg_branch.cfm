<cfinclude template="../query/get_branches.cfm">
<!--- <cf_catalystHeader> --->
<cfparam name="attributes.modal_id" default="">
<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
    <cf_box title="#getLang('','Ürün Hedef Pazar',37251)# : #attributes.ID#" collapsable="0" resize="0" popup_box="#iif(isdefined("attributes.draggable"),1,0)#">
        <cfform name="add_seg_branch" method="post" action="#request.self#?fuseaction=product.emptypopup_add_seg_pro&pro_seg_id=#attributes.ID#">
            <cfoutput>
            <input type="hidden" name="pro_seg_id" id="pro_seg_id" value="#attributes.ID#">
            <input type="hidden" name="id" id="id" value="#attributes.ID#">
            <cfif isdefined("attributes.draggable")>
                <cfinput type="hidden" name="draggable" id="draggable" value="#attributes.draggable#">
                <cfinput type="hidden" name="modal_id" id="modal_id" value="#attributes.modal_id#">
            </cfif>
            </cfoutput>
            <div class="row">
                <div class="col col-12 uniqueRow">
                    <div class="row formContent">
                        <div class="row" type="row">
                        <div class="col col-3 col-md-4 col-sm-6 col-xs-12" type="column" index="1" sort="false">
                            <div class="form-group scrollContent scroll-x2" id="item-">
                                <cfif get_branch.recordcount>
                                    <cfoutput query="get_branch">
                                        <label><input type="checkbox" name="branch_id" id="branch_id" value="#branch_id#">#branch_name#</label><br />
                                    </cfoutput>
                                <cfelse>
                                    <label><cf_get_lang dictionary_id='57484.Kayıt Yok'>!</label>
                                </cfif>
                            </div>
                        </div>
                        </div>
                        <div class="row formContentFooter">
                            <div class="col col-12">
                                <cf_workcube_buttons type_format='1' is_upd='0' add_function='#iif(isdefined("attributes.draggable"),DE("loadPopupBox('upd_product_segment' , #attributes.modal_id#)"),DE(""))#'>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </cfform>
    </cf_box>
</div>