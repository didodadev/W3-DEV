﻿<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
    <cfsavecontent variable="message"><cf_get_lang dictionary_id='37956.Stok Strateji Aktarı'></cfsavecontent>
    <cf_box  title="#message#">
        <cfform name="stock_strategy" action="" enctype="multipart/form-data" method="post">
            <cf_box_elements>
                <div class="col col-4 col-md-4 col-sm-6 col-xs-12" type="column" index="1" sort="true">
                    <div class="form-group" id="item-file-format">
                        <label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='53723.Belge Formatı'></label>
                        <div class="col col-8 col-md-8 col-sm-8 col-xs-12">
                            <select name="file_format" id="file_format">
                                <option value="UTF-8">UTF-8</option>
                            </select>
                        </div>
                    </div>
                    <div class="form-group" id="item-upload-file">
                        <label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='57468.Belge'>*</label>
                        <div class="col col-8 col-md-8 col-sm-8 col-xs-12">
                            <input type="file" name="uploaded_file" id="uploaded_file">
                        </div>
                    </div>
                    <div class="form-group" id="item-sample">
                        <label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='43671.Örnek Ürün Dosyası'></label>
                        <div class="col col-8 col-md-8 col-sm-8 col-xs-12">
                            <a href="/IEF/standarts/import_example_file/Stok_Strateji_Aktarim.csv"><cf_get_lang dictionary_id='43675.İndir'></a>
                        </div>
                    </div>
                    <div class="form-group" id="item-record-type">
                        <label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='37179.Kayıt Tipi'></label>
                        <div class="col col-8 col-md-8 col-sm-8 col-xs-12">
                            <select name="recort_type" id="recort_type">
                                <option value="0"><cf_get_lang dictionary_id ='57633.Barkod'></option>
                                <option value="1"><cf_get_lang dictionary_id ='57789.Özel Kod'></option>
                                <option value="2"><cf_get_lang dictionary_id ='57518.Stok Kodu'></option>
                            </select>
                        </div>
                    </div>
                </div>
                <div class="col col-8 col-md-8 col-sm-6 col-xs-12" type="column" index="2" sort="true">
                    <div class="form-group" id="item-web-path-title">
                        <label><b><cf_get_lang dictionary_id='58594.Format'></b></label>
                    </div>
                    <div class="form-group" id="item-web-path">
                        <cftry>
                            <cfinclude template="#file_web_path#templates/import_example/stokstratejiaktarim_#session.ep.language#.html">
                            <cfcatch>
                                <script type="text/javascript">
                                    alert("<cf_get_lang dictionary_id='29760.Yardım Dosyası Bulunamadı Lutfen Kontrol Ediniz'>");
                                </script>
                            </cfcatch>
                        </cftry>
                    </div>
                </div>
            </cf_box_elements>
            <cf_box_footer>
                <cf_workcube_buttons is_upd='0' add_function='control()'>
            </cf_box_footer>
        </cfform>
    </cf_box>
</div>
<script type="text/javascript">
function control()
{
	if(document.stock_strategy.uploaded_file.value.length == '')
	{
		alert('<cf_get_lang dictionary_id="43424.Bir Belge Seçmelisiniz.">');
		return false;
	}
	windowopen('','small','stockstrategyname');
	stock_strategy.action='<cfoutput>#request.self#?fuseaction=product.emptypopup_add_stock_strategy_import</cfoutput>';
	stock_strategy.target='stockstrategyname';
	stock_strategy.submit();
	return false;
}
</script>