<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
    <cf_box title="#getLang('','Sipariş Aktarım','44760')#">
        <cfform name="form_order_import" enctype="multipart/form-data" method="post" action="#request.self#?fuseaction=settings.emptypopup_add_order_import">
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
                    <div class="form-group" id="item-file">
                        <label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='57468.Belge'>*</label>
                        <div class="col col-6 col-md-8 col-sm-8 col-xs-12">
                            <input type="file" name="uploaded_file" id="uploaded_file">
                        </div>
                    </div>   
                    <div class="form-group" id="item-example_file">
                        <label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='43671.Örnek Ürün Dosyası'></label>
                        <div class="col col-6 col-md-8 col-sm-8 col-xs-12">
                            <a  href="/IEF/standarts/import_example_file/siparis_aktarim.csv"><strong><cf_get_lang dictionary_id='43675.İndir'></strong></a>
                        </div>
                    </div>  
                    <div class="form-group" id="item-product_type">
                        <label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='63233.Ürün Kayıt Tipi'></label>
                        <div class="col col-6 col-md-8 col-sm-8 col-xs-12">
                            <select name="stock_record_type" id="stock_record_type">
                                <option value=""><cf_get_lang dictionary_id='57734.Seçiniz'></option>
                                <option value="1" selected><cf_get_lang dictionary_id='57518.Stok Kodu'></option>
                                <option value="2"><cf_get_lang dictionary_id='57789.Özel Kod'></option>
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
						<cf_get_lang dictionary_id='44342.Dosya uzantısı csv olmalı,alan araları noktalı virgül (;) ile ayrılmalı ve kaydedilirken karakter desteği olarak UTF-8 seçilmelidir'>
					</div>      
					<div class="form-group" id="item-exp3">
						<cf_get_lang dictionary_id='54238.Aktarım işlemi dosyanın 2 satırından itibaren başlar bu yüzden birinci satırda alan isimleri mutlaka olmalıdır.'>							
					</div>  
                    <div class="form-group" id="item-exp4">
                        <cf_get_lang dictionary_id='44993.Belgede olması gereken alanlar sırasıyla aşağıdaki gibidir;'>
                    </div>   
                    <div class="form-group" id="item-exp5">
                        1-<cf_get_lang dictionary_id='44998.Belge / Satır (Zorunlu)'> : <cf_get_lang dictionary_id='44994.Satırın belge mi yoksa sipariş satırı mı olduğunu belirtir. Eğer belge ise 0 , sipariş satırı ise her satır için artan numaralar olmalıdır.'></br>
                        2-<cf_get_lang dictionary_id='44999.Sipariş Tipi / Stok Kodu (Zorunlu)'> : <cf_get_lang dictionary_id='44995.Belge satırı ise sipariş tipini(Alış 0 , Satış 1) , sipariş satırı ise ürün stok kodunu tutar.'></br>
                        3-<cf_get_lang dictionary_id='38133.Sipariş Başlığı'>-<cf_get_lang dictionary_id='45001.Spekt Kodu (Sipariş Başlığı : Zorunlu)'> : <cf_get_lang dictionary_id='44996.Belge satırı ise sipariş başlığı , sipariş satırı ise spekt id alanıdır.'></br>
                        4-<cf_get_lang dictionary_id='31097.Üye Tipi'> - <cf_get_lang dictionary_id='43582.Rezerve Tipi'> (<cf_get_lang dictionary_id='29801.Zorunlu'>) : <cf_get_lang dictionary_id='44997.Belge satırı ise üye tipini(Kurumsal K, Bireysel B) , sipariş satırı ise rezerve tipini tutar.(Rezerve:-1,Kısmi Rezerve:-2,Rezerve Değil:-3,Rezerve Kapatıldı:-4)'></br>
                        5-<cf_get_lang dictionary_id='45003.CariKod'> - <cf_get_lang dictionary_id='57635.Miktar'> (<cf_get_lang dictionary_id='29801.Zorunlu'>) : <cf_get_lang dictionary_id='45005.Belge satırı ise üye kodunu , sipariş satırı ise ürün miktarını tutar.'></br>
                        6-<cf_get_lang dictionary_id='33313.Satış Çalışanı'> - <cf_get_lang dictionary_id='45007.Birim (Zorunlu)'> : <cf_get_lang dictionary_id='45008.Belge satırı ise satış çalışanının ID sini , sipariş satırı ise ürün birimini tutar.'></br>
                        7-<cf_get_lang dictionary_id='29501.Sipariş Tarihi'> - <cf_get_lang dictionary_id='45010.Birim Fiyat (Zorunlu)'> : <cf_get_lang dictionary_id='45011.Belge satırı ise sipariş tarihini , sipariş satırı ise ürün birim fiyatını tutar.'></br>
                        8-<cf_get_lang dictionary_id='38422.Sevk Tarihi'> - <cf_get_lang dictionary_id='57489.Para Birimi'> : <cf_get_lang dictionary_id='45014.Belge satırı ise sevk tarihini , sipariş satırı ise satır para birimini tutar.'></br>
                        9-<cf_get_lang dictionary_id='57645.Teslim Tarihi'> - <cf_get_lang dictionary_id='32536.KDV Oranı'>(<cf_get_lang dictionary_id='29801.Zorunlu'>) : <cf_get_lang dictionary_id='45016.Belge satırı ise teslim tarihini , sipariş satırı ise satır kdv oranını tutar.'></br>
                        10-<cf_get_lang dictionary_id='58516.Ödeme Yöntemi'> - <cf_get_lang dictionary_id='45017.ISK'> 1 : <cf_get_lang dictionary_id='45018.Belge satırı ise ödeme yönteminin ID sini , sipariş satırı ise satır iskonto 1 oranını tutar.'></br>
                        11-<cf_get_lang dictionary_id='57881.Vade Tarihi'> - <cf_get_lang dictionary_id='45017.ISK'> 2 : <cf_get_lang dictionary_id='45019.Belge satırı ise vade tarihini , sipariş satırı ise satır iskonto 2 oranını tutar.'></br>
                        12-<cf_get_lang dictionary_id='41807.Teslim Adresi'> - <cf_get_lang dictionary_id='45017.ISK'> 3 : <cf_get_lang dictionary_id='45021.Belge satırı ise teslim adresini, sipariş satırı ise satır iskonto 3 oranını tutar.'></br>
                        13-<cf_get_lang dictionary_id='57482.Aşama'> - <cf_get_lang dictionary_id='45017.ISK'> 4 : (<cf_get_lang dictionary_id='57482.Aşama'> : <cf_get_lang dictionary_id='29801.Zorunlu'>) : <cf_get_lang dictionary_id='45022.Belge satırı ise sipariş aşamasının ID sini , sipariş satırı ise satır iskonto 4 oranını tutar.'></br>
                        14-<cf_get_lang dictionary_id='45023.Sipariş Önceliği'> -<cf_get_lang dictionary_id='45017.ISK'> 5 : <cf_get_lang dictionary_id='45024.Belge satırı ise sipariş önceliğinin ID sini , sipariş satırı ise satır iskonto 5 oranını tutar.'></br>
                        15-<cf_get_lang dictionary_id='58763.Depo'> -<cf_get_lang dictionary_id='45017.ISK'> 6 : <cf_get_lang dictionary_id='45025.Belge satırı ise deponun ID sini , sipariş satırı ise satır iskonto 6 oranını tutar.'></br>
                        16-<cf_get_lang dictionary_id='30031.Lokasyon'> -<cf_get_lang dictionary_id='38548.Satır Aşaması'> : <cf_get_lang dictionary_id='45027.Belge satırı ise lokasyonun ID sini , sipariş satırı ise satır aşamasını tutar.(Açık:-1,Tedarik:-2,Kapatıldı:-3,Kısmi Üretim:-4,Üretim:-5,Sevk:-6,Eksik Teslimat:-7,Fazla Teslimat:-8,İptal:-9,Kapatıldı(Manuel):-10)'></br>
                        17-<cf_get_lang dictionary_id='36199.Açıklama'> : <cf_get_lang dictionary_id='45028.Belge ve satır için açıklama alanlarını tutar.'></br>
                        18-<cf_get_lang dictionary_id='57416.Proje'> -<cf_get_lang dictionary_id='36199.Açıklama'> 2 : <cf_get_lang dictionary_id='45029.Belge satırı ise projenin ID sini , sipariş satırı ise açıklama 2 alanını tutar.'></br>
                        19-<cf_get_lang dictionary_id='34753.Özel Tanım'> - <cf_get_lang dictionary_id='57646.Teslim Depo'> : <cf_get_lang dictionary_id='45031.Belge satırı ise özel tanımın ID sini , sipariş satırı ise teslim depo ID sini tutar.'></br>
                        20-<cf_get_lang dictionary_id='29500.Sevk Yöntemi'> -<cf_get_lang dictionary_id='45032.Teslim Lokasyon'> : <cf_get_lang dictionary_id='45033.Belge satırı ise sevk yönteminin ID sini , sipariş satırı ise teslim lokasyon ID sini tutar.'></br>
                        21-<cf_get_lang dictionary_id='58121.İşlem Dövizi'> -<cf_get_lang dictionary_id='45034.Fiyat Listesi ID'>(<cf_get_lang dictionary_id='29801.Zorunlu'>) : <cf_get_lang dictionary_id='45035.Belge satırı ise belgenin işlem dövizini , sipariş satırı ise fiyat listesi ID sini tutar.'></br>
                        22-<cf_get_lang dictionary_id='45036.Belgenin Döviz Kuru'> -<cf_get_lang dictionary_id='45037.Satır Döviz Kuru'> : <cf_get_lang dictionary_id='45038.Belge ve satır için işlem dövizinin kurunu tutar.Girilmezse sistem işlem tarihindeki kuru alır.'></br>
                        23-<cf_get_lang dictionary_id='63234.Teslim Adresi İlçesi'> - <cf_get_lang dictionary_id='32845.Boş'>  : <cf_get_lang dictionary_id='63235.Belge satırı ise teslim adresi ilçe ID si, sipariş satırı ise bos (Bir karakter boşluk bırakılmalı).'></br>
                        24-<cf_get_lang dictionary_id='59774.Sistem No'> - <cf_get_lang dictionary_id='32845.Boş'> : <cf_get_lang dictionary_id='63237.Belge satırı ise sistem ID si, sipariş satırı ise 2.birim girilebilir.'></br>
                        25-<cf_get_lang dictionary_id='41807.Teslim Adresi'> <cf_get_lang dictionary_id='58527.ID'> <cf_get_lang dictionary_id='32845.Boş'> : <cf_get_lang dictionary_id='63238.Belge satırı ise teslim adresi ID si, sipariş satırı ise 2.miktar girilebilir. 2.miktar ve 2. birim alanları girilirse ana birim miktarı 2.miktar üzerinden hesaplanarak yazılır.'></br>
                        26-<cf_get_lang dictionary_id='57453.Şube'> <cf_get_lang dictionary_id='58527.ID'> - <cf_get_lang dictionary_id='32845.Boş'> : <cf_get_lang dictionary_id='63239.Belge satırı ise şube ID si, sipariş satırı ise bos (Bir karakter boşluk bırakılmalı).'></br>
                        27-<cf_get_lang dictionary_id='58794.Referans No'> - <cf_get_lang dictionary_id='32845.Boş'> : <cf_get_lang dictionary_id='63240.Belge satırı ise referans no, sipariş satırı ise bos (Bir karakter boşluk bırakılmalı).'></br>
                        28-<cf_get_lang dictionary_id='58211.Sipariş No'> - <cf_get_lang dictionary_id='32845.Boş'> : <cf_get_lang dictionary_id='63241.Belge satırı ise sipariş numarası(Girilmezse otomatik sipariş numarası verilir), sipariş satırı ise bos (Bir karakter boşluk bırakılmalı).'>
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
		if(document.form_order_import.uploaded_file.value.length == '')
		{
			alert('<cf_get_lang dictionary_id='54246.Belge Seçmelisiniz'> !');
			return false;
		}
		
		if (document.form_order_import.stock_record_type.value.length ==0)
		{ 
			alert ("<cf_get_lang dictionary_id='63242.Lütfen Ürün Kayıt Tipi Seçiniz'> !");
			return false;
		}
		return true;
	}
</script>
