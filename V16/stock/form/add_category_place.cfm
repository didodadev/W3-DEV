<cf_get_lang_set module_name="stock">
    <cf_box title="#getlang('','Kategori Alanı','45191')#" scroll="1" collapsable="1" resize="1" popup_box="#iif(isdefined("attributes.draggable"),1,0)#">
	<cfform name="add_product_plc" action="#request.self#?fuseaction=#fusebox.circuit#.emptypopup_add_category_place" method="post">
    	<cf_box_elements>       
                <div class="col col-12 col-md-12 col-sm-12 col-xs-12" type="column" index="1" sort="true">
                        	<div class="form-group" id="item-product_cat">
                            	<label class="col col-3 col-xs-12"><cf_get_lang dictionary_id='57486.kategori'>*</label>
                                <div class="col col-9 col-xs-12">
                                	<div class="input-group">
                                    	<input type="hidden" name="product_catid" id="product_catid" value="">
                                        <cfsavecontent variable="message"><cf_get_lang dictionary_id='57486.kategori'></cfsavecontent>
                                        <cfinput type="text" name="product_cat" value="" required="yes" style="width:150px;" message="#message#">
                                        <span class="input-group-addon icon-ellipsis btnPointer" onClick="openBoxDraggable('<cfoutput>#request.self#?fuseaction=objects.popup_product_cat_names&field_id=add_product_plc.product_catid&field_name=add_product_plc.product_cat</cfoutput>');" title="<cf_get_lang no='189.Ürün Kategorisi Seçiniz'>!"></span>
                                    </div>
                                </div>
                            </div>
                            <div class="form-group" id="item-txt_department_in">
                            	<label class="col col-3 col-xs-12"><cf_get_lang dictionary_id='30031.lokasyon'>*</label>
                                <div class="col col-9 col-xs-12">
                                	<div class="input-group">
                                    	<input type="hidden" name="department_in" id="department_in">
                                        <cfsavecontent variable="message"><cf_get_lang dictionary_id='45248.lokasyon girmelisiniz'></cfsavecontent>
                                        <cfinput type="Text"  style="width:150px;" name="txt_department_in" required="yes" message="#message#">
                                        <span class="input-group-addon icon-ellipsis btnPointer" onclick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_stores_locations&form_name=add_product_plc&field_name=txt_department_in&field_id=department_in<cfif session.ep.isBranchAuthorization>&is_branch=1</cfif>','list');"></span>
                                    </div>
                                </div>
                            </div>
                            <div class="form-group" id="item-boyut">
                            	<label class="col col-3 col-xs-12"><cf_get_lang dictionary_id='57713.boyut'> (m3)</label>
                                <div class="col col-9 col-xs-12">
                                	<div class="input-group">
                                    	<input  name="width" id="width" placeholder="<cf_get_lang dictionary_id='57695.genislik'>" type="text" style="width:47px;">
                                        <span class="input-group-addon no-bg">*</span>
                                        <input  name="height" id="height" placeholder="<cf_get_lang dictionary_id='57696.yukseklik'>" type="text" style="width:47px;">
                                        <span class="input-group-addon no-bg">*</span>
										<input  name="depth" id="depth" placeholder="<cf_get_lang dictionary_id='45200.derinlik'>" type="text" style="width:47px;">
                                    </div>
                                </div>
                            </div>
                            <div class="form-group" id="item-detail">
                            	<label class="col col-3 col-xs-12"><cf_get_lang dictionary_id='57629.aciklama'></label>
                                <div class="col col-9 col-xs-12">
                					<cfsavecontent variable="message"><cf_get_lang dictionary_id='29484.Fazla karakter sayısı'></cfsavecontent>
									<textarea name="detail" id="detail" style="width:150px;" maxlength="50" onkeyup="return ismaxlength(this)" onBlur="return ismaxlength(this);" message="<cfoutput>#message#</cfoutput>"></textarea>
                                </div>
                            </div>
                            <div class="form-group" id="item-START_DATE">
                            	<label class="col col-3 col-xs-12"><cf_get_lang dictionary_id='57742.tarih'>*</label>
                                <div class="col col-9 col-xs-12">
                                	<div class="input-group">
                                    	<cfsavecontent variable="message"><cf_get_lang dictionary_id='58503.Lutfen Tarih Giriniz'></cfsavecontent>
										<cfinput value=""  validate="#validate_style#" required="Yes" message="#message#" type="text" name="START_DATE" style="width:63px;">
                                        <span class="input-group-addon"><cf_wrk_date_image date_field="START_DATE"></span>
                                        <span class="input-group-addon no-bg"></span>
                                        <cfsavecontent variable="message"><cf_get_lang dictionary_id='58503.Lutfen Tarih Giriniz'></cfsavecontent>
										<cfinput value=""  validate="#validate_style#" required="Yes" message="#message#" type="text" name="FINISH_DATE" style="width:63px;">
                                        <span class="input-group-addon"><cf_wrk_date_image date_field="FINISH_DATE"></span>
                                    </div>
                                </div>
                            </div>
                </div>
            </cf_box_elements>
            <cf_box_footer>
                    <cf_workcube_buttons type_format='1' is_upd='0' add_function='kontrol()'>
            </cf_box_footer>
	</cfform>
</cf_box>
<script type="text/javascript">
function kontrol()
{
	x = (50 - document.add_product_plc.detail.value.length);
	if ( x < 0 )
	{ 
		alert ("<cf_get_lang dictionary_id='57771.Detay'><cf_get_lang dictionary_id ='58210.Alanindaki Fazla Karakter Sayısı'> "+ ((-1) * x));
		return false;
	}
	if (!date_check(document.add_product_plc.START_DATE, document.add_product_plc.FINISH_DATE, "<cf_get_lang dictionary_id='58862.Başlangıç Tarihi Bitiş Tarihinden büyük olamaz'>!"))
		return false;
	return true;	
}
</script>
<cf_get_lang_set module_name="#lcase(listgetat(attributes.fuseaction,1,'.'))#">
