<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
    <cf_box title="#getLang('','Takip Aktarım','45162')#">
        <cfform name="demand_import" action="" enctype="multipart/form-data" method="post">
            <cf_box_elements>
                <div class="col col-4 col-md-4 col-sm-4 col-xs-12" type="column" index="1" sort="true">
					<div class="form-group" id="item-file_format">
                        <label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='32901.Belge Formatı'></label>
                        <div class="col col-6 col-md-8 col-sm-8 col-xs-12">
                            <select name="file_format" id="file_format">
                                <option value="UTF-8"><cf_get_lang dictionary_id='32802.UTF-8'></option>
                            </select>
                        </div>
                    </div>     
					<div class="form-group" id="item-file">
                        <label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='57468.Belge'>*</label>
                        <div class="col col-6 col-md-8 col-sm-8 col-xs-12">
                            <input type="file" name="uploaded_file" id="uploaded_file">
                        </div>
                    </div>                
					<div class="form-group" id="item-example_file">
                        <label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='43671.Örnek Ürün Dosyası'></label>
                        <div class="col col-6 col-md-8 col-sm-8 col-xs-12">
                            <a  href="/documents/settings/Takip_Aktarim.csv"><strong><cf_get_lang no='1692.İndir'></strong></a>
                        </div>
                    </div> 
                    <div class="form-group" id="item-example_file">
                        <label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='31402.Kayıt Tipi'></label>
                        <div class="col col-6 col-md-8 col-sm-8 col-xs-12">
                            <select name="recort_type" id="recort_type">
                                <option value="0"><cf_get_lang dictionary_id='57633.Barkod'></option>
                                <option value="1"><cf_get_lang dictionary_id='57789.Özel Kod'></option>
                                <option value="2"><cf_get_lang dictionary_id='57518.Stok Kodu'></option>
                            </select>                        
                        </div>
                    </div>                                     
                </div>
                <div class="col col-6 col-md-6 col-sm-6 col-xs-12" type="column" index="2" sort="true">
					<div class="form-group" id="item-format">
						<label><b><cf_get_lang dictionary_id='58594.Format'></b></label>
					</div>   
                    <div class="form-group" id="item-exp1">
						<cf_get_lang dictionary_id='57629.Açıklama'>:
					</div>     
				    <div class="form-group" id="item-exp2">
                        <cf_get_lang dictionary_id='44246.Dosya uzantısı csv veya txt olacak ve alan araları noktalı virgül (;) ile ayrılacaktır'>					
                    </div>     
                    <div class="form-group" id="item-exp3">
                        <cf_get_lang dictionary_id='53889.Aktarım işlemi dosyanın 2 satırından itibaren başlar bu yüzden birinci satırda alan isimleri olmalıdır'>
                    </div>      
                    <div class="form-group" id="item-exp4">
                        <cf_get_lang dictionary_id='44247.Ayıraç noktalı virgul olduğundan notlar içinde olmaması gerekmektedir'>
                    </div>  
                    <div class="form-group" id="item-exp5">
                        <cf_get_lang dictionary_id='44750.Küsuratlı değerler için virgül (,) değil nokta (.) kullanılmalıdır'>
                    </div>     
                    <div class="form-group" id="item-exp6">
                        <cf_get_lang dictionary_id='30116.Belgede toplam 7 alan olacaktır'>
                    </div>        
                    <div class="form-group" id="item-exp7">
                        <cf_get_lang dictionary_id='44197.Alanlar sırasıyla'>;
                    </div>
                    <div class="form-group" id="item-exp8">
                        1-<cf_get_lang dictionary_id='33915.Üye Kodu'>(<cf_get_lang dictionary_id='29801.Zorunlu'>)</br>
                        2-<cf_get_lang dictionary_id='57518.Stok Kodu'>,<cf_get_lang dictionary_id='57633.Barkod'>,<cf_get_lang dictionary_id='57789.Özel Kod'>(<cf_get_lang dictionary_id='29801.Zorunlu'>) : <cf_get_lang dictionary_id='63227.Belge satırı ise seçilecek kayıt tipinin(Stok Kodu, Barkod, Özel Kod)değerini tutar. Belgedeki bütün kolonlar aynı tip olmak zorundadır.'></br>
                        3-<cf_get_lang dictionary_id='37427.KDV li Fiyat'>(<cf_get_lang dictionary_id='29801.Zorunlu'>) : <cf_get_lang dictionary_id='63228.Belge satırı ise ürünün KDV eklenmiş fiyatını tutar'> . <cf_get_lang dictionary_id='44750.Küsuratlı değerler için virgül (,) değil nokta (.) kullanılmalıdır'> (<cf_get_lang dictionary_id='58967.Örnek'>: 32.44)</br>
                        4-<cf_get_lang dictionary_id='63229.Takip türünün sayısal karşılığı'> (<cf_get_lang dictionary_id='29801.Zorunlu'>) : <cf_get_lang dictionary_id='63230.Belge satırı ise takip türünün sayısal değerlerinden birini alır'> (1-<cf_get_lang dictionary_id='32404.Fiyat Habercisi'>, 2-<cf_get_lang dictionary_id='32410.Stok Habercisi'>, 3-<cf_get_lang dictionary_id='32411.Ön Sipariş'>)</br>
                        5-<cf_get_lang dictionary_id='57635.Miktar'>(<cf_get_lang dictionary_id='29801.Zorunlu'>) : <cf_get_lang dictionary_id='63231.Belge satırı ise ürünün miktarını belirtir'></br>
                        6-<cf_get_lang dictionary_id='57636.Birim'>(<cf_get_lang dictionary_id='29801.Zorunlu'>) : <cf_get_lang dictionary_id='63232.Belge satırı ise ürün miktarını belirlemekte kullanılan birimi belirtir'>. (<cf_get_lang dictionary_id='58082.Adet'>, <cf_get_lang dictionary_id='37188.Kg'> <cf_get_lang dictionary_id='63133.vs'>.)</br>
                        7-<cf_get_lang dictionary_id='36199.Açıklama'></br>  
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
	if(document.demand_import.uploaded_file.value.length == '')
	{
		alert('<cf_get_lang dictionary_id='54246.Belge Seçmelisiniz'>');
		return false;
	}
	windowopen('','small','demandimport');
	demand_import.action='<cfoutput>#request.self#?fuseaction=settings.add_demand_import</cfoutput>';
	demand_import.target='demandimport';
	demand_import.submit();
	return false;
}
</script>
