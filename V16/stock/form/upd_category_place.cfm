<cf_get_lang_set module_name="stock">
<cfparam name="attributes.keyword" default="">
<cfinclude template="../query/get_pro_cat_place.cfm">
<cf_box title="#getlang('','Kategori Alanı','45191')#" scroll="1" collapsable="1" resize="1" popup_box="#iif(isdefined("attributes.draggable"),1,0)#">
	<cfform action="#request.self#?fuseaction=#fusebox.circuit#.emptypopup_upd_category_place" method="post" name="add_product_plc">
    	<input type="hidden" name="pc_place_id" id="pc_place_id" value="<cfoutput>#attributes.pc_place_id#</cfoutput>">
                <cf_box_elements>
                    	<div class="col col-12 col-md-12 col-sm-12 col-xs-12" type="column" index="1" sort="true">
                        	<div class="form-group" id="item-product_cat">
                            	<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57486.kategori'>*</label>
                                <div class="col col-8 col-xs-12">
                                	<div class="input-group">
                                    	<input type="hidden" name="product_catid" id="product_catid" value="<cfoutput>#get_pro_cat_place.product_catid#</cfoutput>">
										<cfset attributes.product_catid=get_pro_cat_place.product_catid>
                                        <cfinclude template="../query/get_product_cat.cfm">
                                        <cfinput type="text" name="product_cat" value="#get_product_cat.product_cat#" required="yes" style="width:150px;">
                                        <span class="input-group-addon icon-ellipsis btnPointer" onclick="openBoxDraggable('<cfoutput>#request.self#?fuseaction=objects.popup_product_cat_names&field_id=add_product_plc.product_catid&field_name=add_product_plc.product_cat</cfoutput>');" title="<cf_get_lang dictionary_id='45366.Ürün Kategorisi Seçiniz'>!"></span>
                                    </div>
                                </div>
                            </div>
                            <div class="form-group" id="item-txt_department_in">
                            	<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='30031.lokasyon'>*</label>
                                <div class="col col-8 col-xs-12">
                                	<div class="input-group">
                                    	<cfset attributes.DEPARTMENT_ID=get_pro_cat_place.DEPARTMENT_ID >
                                        <cfinclude template="../query/get_department_head.cfm">
                                        <cfset dep_name=GET_DEPARTMENT_HEAD.DEPARTMENT_HEAD>
                                        <cfif len(get_pro_cat_place.LOCATION_ID) >
                                            <cfset atttibutes.department_id=get_pro_cat_place.DEPARTMENT_ID & "-" & get_pro_cat_place.LOCATION_ID>
                                            <cfset attributes.ID=get_pro_cat_place.DEPARTMENT_ID & "-" & get_pro_cat_place.LOCATION_ID>
                                            <cfinclude template="../query/get_det_stock_location.cfm">
                                            <cfset dep_name=dep_name & "-" & GET_DET_STOCK_LOCATION.COMMENT>
                                        </cfif>
                                        <input type="hidden" name="department_in" id="department_in" value="<cfoutput>#attributes.department_id#</cfoutput>">
                                        <cfsavecontent variable="message"><cf_get_lang dictionary_id='45248.lokasyon girmelisiniz'></cfsavecontent>
                                        <cfinput type="Text"  value="#dep_name#" style="width:150px;" name="txt_department_in" required="yes" message="#message#">
                                        <span class="input-group-addon icon-ellipsis btnPointer" onclick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_stores_locations&form_name=add_product_plc&field_name=txt_department_in&field_id=department_in<cfif session.ep.isBranchAuthorization>&is_branch=1</cfif>','list');"></span>
                                    </div>
                                </div>
                            </div>
                            <div class="form-group" id="item-boyut">
                            	<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57713.boyut'> (m3)</label>
                                <div class="col col-8 col-xs-12">
                                	<div class="input-group">
                                    	<input  name="width" id="width" type="text" placeholder="<cf_get_lang dictionary_id='57695.genislik'>" style="width:47px;"  value="<cfoutput>#get_pro_cat_place.WIDTH#</cfoutput>">
                                        <span class="input-group-addon no-bg">*</span>
                                        <input  name="height" id="height"  type="text" placeholder="<cf_get_lang dictionary_id='57696.yukseklik'>" style="width:47px;"  value="<cfoutput>#get_pro_cat_place.HEIGHT#</cfoutput>">
                                        <span class="input-group-addon no-bg">*</span>
										<input  name="depth" id="depth" type="text" placeholder="<cf_get_lang dictionary_id='45200.derinlik'>" style="width:47px;"  value="<cfoutput>#get_pro_cat_place.DEPTH#</cfoutput>">
                                    </div>
                                </div>
                            </div>
                            <div class="form-group" id="item-detail">
                            	<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57629.aciklama'></label>
                                <div class="col col-8 col-xs-12">
                					<textarea name="detail" id="detail"  style="width:150px;" ><cfoutput>#get_pro_cat_place.DETAIL#</cfoutput></textarea>
                                </div>
                            </div>
                            <div class="form-group" id="item-START_DATE">
                            	<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57742.tarih'>*</label>
                                <div class="col col-8 col-xs-12">
                                	<div class="input-group">
                                    	<cfsavecontent variable="message"><cf_get_lang dictionary_id='58503.Lutfen Tarih Giriniz'></cfsavecontent>
										<cfinput value="#dateformat(get_pro_cat_place.start_date,dateformat_style)#"  validate="#validate_style#" required="Yes" message="#message#" type="text" name="START_DATE" style="width:63px;">
                                        <span class="input-group-addon"><cf_wrk_date_image date_field="START_DATE"></span>
                                        <span class="input-group-addon no-bg"></span>
                                        <cfsavecontent variable="message"><cf_get_lang dictionary_id='58503.Lutfen Tarih Giriniz'></cfsavecontent>
                                        <cfinput  value="#dateformat(get_pro_cat_place.finish_date,dateformat_style)#"  validate="#validate_style#" required="Yes" message="#message#" type="text" name="FINISH_DATE" style="width:63px;">
                                        <span class="input-group-addon"><cf_wrk_date_image date_field="FINISH_DATE"></span>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </cf_box_elements>
                    <cf_box_footer>
                        	<cf_record_info query_name="get_pro_cat_place">
                        	<cf_workcube_buttons type_format='1' is_upd='1' is_delete='0' add_function='kontrol()'>
                    </cf_box_footer>
	</cfform>
</cf_box>
<script type="text/javascript">
function kontrol()
{
	x = (50 - document.add_product_plc.detail.value.length);
	if ( x < 0 )
	{ 
		alert ("<cf_get_lang dictionary_id='57771.Detay'><cf_get_lang dictionary_id ='58210.Alanindaki Fazla Karakter Sayısı'>"+ ((-1) * x));
		return false;
	}
	if (!date_check(document.add_product_plc.START_DATE, document.add_product_plc.FINISH_DATE, "<cf_get_lang dictionary_id='58862.Başlangıç Tarihi Bitiş Tarihinden büyük olamaz'>!"))
		return false;
	
	return true;	
}
</script>
<cf_get_lang_set module_name="#lcase(listgetat(attributes.fuseaction,1,'.'))#">

