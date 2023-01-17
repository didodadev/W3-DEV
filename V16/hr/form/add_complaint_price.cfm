<cfset components = createObject('component','V16.hr.cfc.assurance_type')>
<cfset get_health_price_protocol = components.GET_HEALTH_PRICE_PROTOCOL()>
<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
	<cf_box title="#getLang('','Tedavi fiyatları import','59975')#" nofooter="1">
        <cfform name="formimport" action="#request.self#?fuseaction=hr.emptypopup_health_prices_import" enctype="multipart/form-data" method="post">
            <cf_box_elements>
                <div class="col col-4 col-md-4 col-sm-6 col-xs-12" type="column" index="1" sort="true">
                    <div class="form-group" id="price_protocol">
                        <label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='34700.Fiyat Protokolü'>*</label>
                        <div class="col col-6 col-md-8 col-sm-8 col-xs-12">
                            <select name="price_protocol" id="price_protocol">
                                <option value=""><cf_get_lang dictionary_id='57734.Seçiniz'></option>
                                <cfif get_health_price_protocol.recordCount>
                                    <cfoutput query="get_health_price_protocol">
                                        <option value="#protocol_id#">#protocol_name#</option>
                                    </cfoutput>
                                </cfif>
                            </select>
                        </div>
                    </div> 
                    <div class="form-group" id="company_id">
                        <label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='59585.Anlaşmalı Kurum'></label>
                        <div class="col col-6 col-md-8 col-sm-8 col-xs-12">
                            <div class="input-group">
                                <input type="hidden" name="company_id" id="company_id" value="">
                                <input type="text" name="company" id="company" value="" onFocus="AutoComplete_Create('company','MEMBER_NAME','MEMBER_NAME','get_member_autocomplete','\'1\'','COMPANY_ID','company_id','','3','250');" autocomplete="off">
                                <span class="input-group-addon btnPointer icon-ellipsis" onClick="openBoxDraggable('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_pars&field_comp_name=formimport.company&field_comp_id=formimport.company_id');"></span>
                            </div>
                        </div>
                    </div> 
                    <div class="form-group" id="product_id">
                        <label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='38484.İlişkili Ürün'></label>
                        <div class="col col-6 col-md-8 col-sm-8 col-xs-12">
                            <div class="input-group">
                                <input type="hidden" name="product_id" id="product_id" value="">
                                <input type="text" name="product_name" id="product_name" value="" onfocus="AutoComplete_Create('product_name','PRODUCT_NAME','PRODUCT_NAME,STOCK_CODE','get_product_autocomplete','0','PRODUCT_ID','product_id','','3','225');" autocomplete="off">
                                <span class="input-group-addon btnPointer icon-ellipsis" onclick="openBoxDraggable('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_product_names&product_id=formimport.product_id&field_name=formimport.product_name<cfif session.ep.isBranchAuthorization>&is_store_module=1</cfif>&keyword='+encodeURIComponent(document.formimport.product_name.value));"></span>
                            </div>
                        </div>
                    </div>                    
                    <div class="form-group" id="item-uploaded_file">
                        <label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='57468.Belge'>*</label>
                        <div class="col col-6 col-md-8 col-sm-8 col-xs-12">
                            <input type="file" name="uploaded_file" id="uploaded_file">
                        </div>
                    </div>    
                    <div class="form-group" id="item-download-link">
                        <label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='43671.Örnek Ürün Dosyası'></label>
                        <div class="col col-6 col-md-8 col-sm-8 col-xs-12">
                            <a href="/IEF/standarts/import_example_file/Tedavi_Fiyat_Aktarim.csv"><strong><cf_get_lang dictionary_id='43675.İndir'></strong></a>
                        </div>
                    </div>
                </div>
                <div class="col col-6 col-md-6 col-sm-8 col-xs-12" type="column" index="2" sort="true">
                    <div class="form-group" id="item-format">
                        <label><b><cf_get_lang dictionary_id='58594.Format'></b></label>
                    </div>
                    <div class="form-group" id="item-exp1">
                        <cf_get_lang dictionary_id='33719.NOT: Dosya uzantısı csv olacak ve alan araları noktalı virgül (;) ile ayrılacaktır. Format UTF-8 Aktarım işlemi dosyanın 2 satırından itibaren başlar bu yüzden birinci satırda alan isimleri olmalıdır.'>       
                    </div> 
                    <div class="form-group" id="item-exp2">
                        <cf_get_lang dictionary_id='44951.Bu belgede olması gereken alan sayısı'>:5                        
                    </div> 
                    <div class="form-group" id="item-exp3">
                        <cf_get_lang dictionary_id='44197.Alanlar sırasıyla'>;
                    </div> 
                    
                    <div class="form-group" id="item-exp4">
                        1-<cf_get_lang dictionary_id='63425.Tedavi Türü'>ID(*)<br/>
                        2-<cf_get_lang dictionary_id='58084.Fiyat'>(*)(<cf_get_lang dictionary_id='58967.Örnek'>: 1.499,99 | 1.000)<br/>
                        3-<cf_get_lang dictionary_id='57489.Para Birimi'>(*)(<cf_get_lang dictionary_id='58967.Örnek'>TL)<br/>
                        4-<cf_get_lang dictionary_id='42519.Vergi Oranı'>((<cf_get_lang dictionary_id='58967.Örnek'>: 3 | 5,75))<br/>
                        5-<cf_get_lang dictionary_id='38190.İskonto Oranı'>(<cf_get_lang dictionary_id='58967.Örnek'> : 44 | 49,99)<br/>
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
	function kontrol()
	{
        if(price_protocol.value == '')
        {
            alertObject({message: "<cf_get_lang dictionary_id='58194.Zorunlu alan :'><cf_get_lang dictionary_id='34700.Fiyat Protokolü'>"});
            return false;
        }
		if(formimport.uploaded_file.value.length == 0){
			alert("<cf_get_lang dictionary_id='43424.Belge Seçmelisiniz'>!");
			return false;
        }
        return true;
	}
</script>
    