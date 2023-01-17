<cfinclude template="../query/get_property_detail_1.cfm">
 
    <cfsavecontent variable="title"><cf_get_lang dictionary_id='36638.Varyasyon Ekle'></cfsavecontent>
	<cf_box title="#title#" scroll="1" collapsable="1" resize="1" popup_box="#iif(isdefined("attributes.draggable"),1,0)#">
        <cfform name="add_prpt" action="#request.self#?fuseaction=prod.emptypopup_add_property_act" method="post">
                        <cf_box_elements>
                            <div class="col col-6" type="column" index="1" sort="true">
                                <div class="form-group" id="item-prpt">
                                    <label class="col col-4"><cf_get_lang dictionary_id='57632.Özellik'></label>
                                    <div class="col col-8">
                                        <input type="hidden" name="prpt_id" id="prpt_id" value="<cfoutput>#url.prpt_id#</cfoutput>">
                                        <cfoutput>#URL.PROPERTY#</cfoutput>  
                                    </div>
                                </div>
                                <div class="form-group" id="item-prop">
                                    <label class="col col-4"><cf_get_lang dictionary_id='36634.Varyasyon'></label>
                                    <div class="col col-8">
                                        <cfinput type="Text" name="prop" value="" required="yes"  message="Bir Varyasyon Girmeden Kaydedemezsiniz."maxlength="15">
                                    </div>
                                </div>
                            </div>
                            <div class="col col-4" type="column" index="2" sort="true">
                                <div class="form-group" id="item-PROPERTY">                                  
                                    <table class="ajax_list">
                                        <thead>
                                            <tr>
                                            <th><cf_get_lang dictionary_id='36637.Varyasyonlar'></th>
                                            <th></th>
                                            </tr>
                                        </thead>
                                        <cfoutput query="get_property_detail">
                                            <tbody>
                                                <tr>
                                                    <td nowrap="nowrap">
                                                    <a href="javascript://" onClick="openBoxDraggable('#request.self#?fuseaction=product.emptypopup_del_sub_property&modal_id=#attributes.modal_id#&draggable=0&property_detail_id=#property_detail_id#');" title="<cf_get_lang dictionary_id='57463.Sil'>">
                                                        <i class="fa fa-minus"></i> </a>                                                         
                                                    </td>
                                                    <td><a href="javascript://">#property_detail#</a></td>
                                                </tr>
                                            </tbody>
                                        </cfoutput>  
                                    </table>                                    
                                </div>
                            </div>
                        </cf_box_elements>                        
                        <cf_box_footer><cf_workcube_buttons is_upd='0' add_function="control_add()&&loadPopupBox('add_prpt')"></cf_box_footer>                        
	</cfform>
    </cf_box>

<script>
	function control_add() {		
		loadPopupBox('add_prpt' , <cfoutput>#attributes.modal_id#</cfoutput>);
		return false;
	}		
</script>