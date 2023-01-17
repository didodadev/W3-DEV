<br/>
<cfquery name="get_process_cat" datasource="#dsn3#">
	SELECT 
		PROCESS_CAT_ID,
		PROCESS_CAT
	FROM
		SETUP_PROCESS_CAT 
	WHERE
		PROCESS_TYPE = 1181
</cfquery>

<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
	<cf_box title="#getLang('','Demirbaş Aktarım','43758')#">
		<cfform name="formimport" action="" enctype="multipart/form-data" method="post">
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
							<a  href="/IEF/standarts/import_example_file/demirbas_aktarimi.csv"><strong><cf_get_lang dictionary_id='43675.İndir'></strong></a>
						</div>
                    </div>  
					<div class="form-group" id="item-operation_type">
                        <label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='61806.İşlem Tipi'>*</label>
                        <div class="col col-6 col-md-8 col-sm-8 col-xs-12">
							<select name="process_cat" id="process_cat">
								<cfoutput query="get_process_cat">
									<option value="#process_cat_id#">#process_cat#</option>
								</cfoutput>
							</select>
						</div>
                    </div>  
					<div class="form-group" id="item-amortisman_method">
                        <label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='29420.Amortisman Yöntemi'>*</label>
                        <div class="col col-6 col-md-8 col-sm-8 col-xs-12">
							<select name="amor_method" id="amor_method">
								<option value=""><cf_get_lang dictionary_id='57734.Seçiniz'></option>
								<option value="0"><cf_get_lang dictionary_id='29421.Azalan Bakiye Üzerinden'></option>
								<option value="1"><cf_get_lang dictionary_id='29422.Normal Amortisman'></option>
							</select>
						</div>
                    </div>  
					<div class="form-group" id="item-fixture_type">
                        <label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='56900.Demirbaş Tipi'>*</label>
                        <div class="col col-6 col-md-8 col-sm-8 col-xs-12">
							<select name="inventory_type" id="inventory_type">
								<option value="1"><cf_get_lang dictionary_id='39693.Devirden Gelen'></option>
								<option value="2"><cf_get_lang dictionary_id='45091.Faturadan Kaydedilen'></option>
								<option value="3"><cf_get_lang dictionary_id='56897.Stok Fişinden Kaydedilen'></option>
								<option value="4"><cf_get_lang dictionary_id='56894.İrsaliyeden Kaydedilen'></option>
							</select>
						</div>
                    </div> 
					<div class="form-group" id="show_department_name_2" style="display:none;">
                        <label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='29428.Çıkış Depo'>*</label>
                        <div class="col col-6 col-md-8 col-sm-8 col-xs-12">
							<cf_wrkdepartmentlocation
							returnInputValue="location_id_2,department_name_2,department_id_2,branch_id_2"
							returnQueryValue="LOCATION_ID,LOCATION_NAME,DEPARTMENT_ID,BRANCH_ID"
							fieldName="department_name_2"
							fieldid="location_id_2"
							department_fldId="department_id_2"
							branch_fldId="branch_id_2"
							user_location="0"
							user_level_control="#session.ep.OUR_COMPANY_INFO.IS_LOCATION_FOLLOW#"
							width="200">
						</div>
                    </div> 
					<div class="form-group" style="display:none;" id="show_fis_date">
						<label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='47445.Fiş Tarihi'></label>
						<div class="col col-6 col-md-8 col-sm-8 col-xs-12">
							<div class="input-group">
								<input name="fis_date" id="fis_date" type="text" value="">
								<span class="input-group-addon"><cf_wrk_date_image date_field="fis_date"></span>
							</div>
						</div>
					</div>
					<div class="form-group" id="stock_ticket">
						<label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='45094.Stok Fişi Kaydedilsin'></label>
						<div class="col col-6 col-md-8 col-sm-8 col-xs-12">
							<input type="checkbox" name="is_stock_fis" id="is_stock_fis" value="" onclick="show_camp();">
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
						<cf_get_lang dictionary_id='44381.Belgede toplam 21 alan olacaktır alanlar sırasi ile'> ;
					</div>
					<div class="form-group" id="item-exp5">
						1-<cf_get_lang dictionary_id='44382.Demirbaş No (Zorunlu)  : Demirbaşa ait numara text olarak girilmelidir'> .</br>
						2-<cf_get_lang dictionary_id='44954.Demirbaş Kategorisi : Eğer demirbaşın ait olduğu kategori varsa ID si girilebilir.'></br>
						3-<cf_get_lang dictionary_id='44383.Açıklama (Zorunlu) : Demirbaş İsmi/Açıklama text olarak girilmelidir'> .</br>
						4-<cf_get_lang dictionary_id='44384.Giriş Tarihi (Zorunlu) : Demirbaşın giriş tarihi 01/01/2007 formatında girilmelidir'> .</br>
						5-<cf_get_lang dictionary_id='44385.Miktar: Devredilecek demirbaş miktarı numerik olarak girilmelidir. Boş bırakılırsa 1 atanır'> .</br>
						6-<cf_get_lang dictionary_id='44386.Dönem Başı Değer(Zorunlu): Demirbaşın dönem başındaki son değeri float olarak yazılmalıdır. Örn: 15365'></br>
						7-<cf_get_lang dictionary_id='63199.Dönem Başı Değer 2. Döviz Tutarı : Demirbaşın dönem başındaki son değeri float olarak yazılmalıdır Örn: 153,65'></br>
						8-<cf_get_lang dictionary_id='44387.Dönem Amortismanı : İlgili dönemde ayrılan amortisman tutarı float olarak yazılmalıdır. Örn : 1006'></br>
					    9-<cf_get_lang dictionary_id='63200.Dönem Amortismanı 2. Döviz Tutarı : İlgili dönemde ayrılan amortisman tutarı float olarak yazılmalıdır Örn : 1006'></br>
						**<cf_get_lang dictionary_id='44388.Dönem Başı Değer ve dönem amortismanı farkı alınarak son değer bulunur'> .</br>
						10-<cf_get_lang dictionary_id='44372.İşlem Para Birimi (Zorunlu) :Text olarak limit değerlerinin işlem dövizi girilmelidir. Örn : USD'></br>
						11-<cf_get_lang dictionary_id='44956.Faydalı Ömür: Faydalı Ömür numerik olarak girilebilir.'></br>
						12-<cf_get_lang dictionary_id='44390.Amortisman Oranı (Zorunlu): Amortisman oranı numerik olarak girilmelidir'> .</br>
						13-<cf_get_lang dictionary_id='44955.Amortisman Türü(Zorunlu): Kıst Amortismana Tabi ise 1, değilse 2 girilmelidir.'></br>
						14-<cf_get_lang dictionary_id='44391.Muhasebe Kodu (Zorunlu): Demirbaş muhasebe kodu 255.01.001 formatında girilmelidir'> .</br>
						15-<cf_get_lang dictionary_id='44392.Masraf Merkezi : Demirbaşın bağlı olduğu masraf merkezi varsa ID si girilebilir'> .</br>
						16-<cf_get_lang dictionary_id='44393.Gider Kalemi : Demirbaşın bağlı olduğu gider kalemi varsa ID si girilebilir'>.</br>
						17-<cf_get_lang dictionary_id='44394.Periyod : Amortismanın kaç periyod halinde değerleneceğini belirtir. İstenirse numerik olarak girilir. Girilmezse 1 olarak alınır'> .</br>
						18-<cf_get_lang dictionary_id='44395.Amortisman Borç Muhasebe Kodu : Demirbaş değerlemesinde kullanılacak olan borç muhasebe kodu 255.01.001 formatında girilebilir'>.</br>
						19-<cf_get_lang dictionary_id='44396.Amortisman Alacak Muhasebe Kodu : Demirbaş değerlemesinde kullanılacak olan alacak muhasebe kodu 255.01.001 formatında girilebilir'>.</br>
						20-<cf_get_lang dictionary_id='57452.Stok'> <cf_get_lang dictionary_id='58527.ID'> : <cf_get_lang dictionary_id='45095.Varsa Demirbaşın İlişkili Olduğu Stok ID yazılır'>.</br>
						21-<cf_get_lang dictionary_id='58832.Abone'> <cf_get_lang dictionary_id='58527.ID'> : <cf_get_lang dictionary_id='45096.Varsa Demirbaşın İlişkili Olduğu Sistem ID yazılır'> .</br>
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
		if(formimport.amor_method.value.length== '')
		{
			alert("<cf_get_lang dictionary_id='43949.Amortisman Yöntemi Seçmelisiniz'>!");
			return false;
		}
		if(document.formimport.is_stock_fis.checked == true && document.formimport.fis_date.value == '')
		{
			alert("<cf_get_lang dictionary_id='57471.Eksik Veri'> : <cf_get_lang dictionary_id='47445.Fiş Tarihi'>!");
			return false;
		}
		if(document.formimport.is_stock_fis.checked == true && (document.formimport.department_name_2.value == '' || document.formimport.department_id_2.value == ''))
		{
			alert("<cf_get_lang dictionary_id='57471.Eksik Veri'> : <cf_get_lang dictionary_id='29428.Çıkış Depo'>!");
			return false;
		}
		windowopen('','small','cc_che');
		formimport.action='<cfoutput>#request.self#?fuseaction=settings.emptypopup_add_inventory_import</cfoutput>';
		formimport.target='cc_che';
		formimport.submit();
		return false;
	}
	function show_camp()
	{
		if(document.formimport.is_stock_fis.checked == true)
		{
			show_fis_date.style.display='';
			show_department_name_2.style.display='';
		}
		else
		{
			show_fis_date.style.display='none';
			show_department_name_2.style.display='none';
		}
	}
</script>


