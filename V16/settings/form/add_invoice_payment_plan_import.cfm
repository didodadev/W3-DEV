<!--- Fatura Ödeme Planı Aktarım 20130103--->
<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
    <cf_box title="#getLang('','Fatura Ödeme Planı Aktarımı','63202')#" closable="0">
        <cfform name="formimport" action="#request.self#?fuseaction=settings.emptypopup_add_invoice_payment_plan_import" enctype="multipart/form-data" method="post">
            <cf_box_elements>
                <div class="col col-4 col-md-4 col-sm-4 col-xs-12" type="column" index="1" sort="true">
                    <div class="form-group" id="item-file_format">
                        <label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='32901.Belge Formatı'></label>
                        <div class="col col-6 col-md-8 col-sm-8 col-xs-12">
                            <select name="file_format" id="file_format">
                                <option value="UTF-8"><cf_get_lang dictionary_id='55929.UTF-8'></option>
                            </select>
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
                            <a href="/IEF/standarts/import_example_file/Fatura_odeme_Plani_Aktarim.csv"><strong><cf_get_lang dictionary_id='43675.İndir'></strong></a>
                        </div>
                    </div>
                </div> 
                <div class="col col-6 col-md-6 col-sm-8 col-xs-12" type="column" index="2" sort="true">              
                    <div class="form-group" id="item-format">
                        <label><b><cf_get_lang dictionary_id='58594.Format'></b></label>
                    </div> 
                    </br>
                    <div class="form-group" id="item-exp1">
                        <cf_get_lang dictionary_id='63203.DOSYA DESENI'>
                    </div> 
                    <div class="form-group" id="item-exp2">
                        <cf_grid_list>
                            <thead>
                                <tr>
                                    <th><cf_get_lang dictionary_id='30817.Müşteri No'></th>
                                    <th><cf_get_lang dictionary_id='57629.Açıklama'></th>
                                    <th><cf_get_lang dictionary_id='58133.Fatura No'></th>
                                    <th><cf_get_lang dictionary_id='58759.Fatura Tarihi'></th>
                                    <th><cf_get_lang dictionary_id='57881.Vade Tarihi'></th>
                                    <th><cf_get_lang dictionary_id='57673.Tutar'></th>
                                    <th><cf_get_lang dictionary_id='57279.Döviz Tutar'></th>
                                    <th><cf_get_lang dictionary_id='57489.Para Birimi'>(<cf_get_lang dictionary_id='63204.TL,USD,EUR vs.'>)</th>
                                    <th><cf_get_lang dictionary_id='58516.Ödeme Yöntemi'><cf_get_lang dictionary_id='58527.ID'></th>
                                </tr>
                            </thead>
                            <tbody>
                                <tr>
                                    <td class="text-center">M1051200161</td>
                                    <td class="text-center"><cf_get_lang dictionary_id='63205.Açıklama Alanı'></td>
                                    <td class="text-center">F-No</td>
                                    <td class="text-center">03/01/2013</td>
                                    <td class="text-center">22/01/2013</td>
                                    <td class="text-center">100.15</td>
                                    <td class="text-center">87.12</td>
                                    <td class="text-center">USD</td>
                                    <td class="text-center">6</td>
                                </tr>
                            </tbody>
                        </cf_grid_list>
                    </div>                   
                    <div class="form-group" id="item-exp3">
                        <cf_get_lang dictionary_id='63134.ÖRNEK VERİ'>
                    </div> 
                    <div class="form-group" id="item-exp4">
                        <cf_get_lang dictionary_id='44342.Dosya uzantısı csv olmalı,alan araları noktalı virgül (;) ile ayrılmalı ve kaydedilirken karakter desteği olarak UTF-8 seçilmelidir'>
                    </div> 
                    <div class="form-group" id="item-exp5">
                        <cf_get_lang dictionary_id='36511.Aktarım işlemi dosyanın 2. satırından itibaren başlar bu yüzden birinci satırda alan isimleri olmalıdır'>
                    </div> 
                    <div class="form-group" id="item-exp6">
                        <cf_get_lang dictionary_id='44951.Bu belgede olması gereken alan sayısı'>:9
                    </div> 
                    </br>                
                    <div class="form-group" id="item-exp7">
                        M1051200161&nbsp;AciklamaAlani1&nbsp;F-No1&nbsp;03/01/2013&nbsp;22/01/2013&nbsp;100.15&nbsp;87.12&nbsp;USD&nbsp;6
                    </div>
                    <div class="form-group" id="item-exp8">
                        M1051200161&nbsp;AciklamaAlani2&nbsp;F-No2&nbsp;04/01/2013&nbsp;23/01/2013&nbsp;100.15&nbsp;87.12&nbsp;USD&nbsp;6
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
		if(document.getElementById("uploaded_file").value == '')
		{
			alert("<cf_get_lang dictionary_id='58194.Zorunlu Alan'>:<cf_get_lang dictionary_id='57468.Belge'>");
			return false;
		}
		return true;
	}
</script>
