<cfquery name="get_accounts" datasource="#dsn3#">
	SELECT 
	    ACCOUNT_ID, 
        ACCOUNT_NAME, 
        ACCOUNT_CURRENCY_ID
    FROM 
    	ACCOUNTS
</cfquery>
<cfquery name="get_cashes" datasource="#dsn2#">
	SELECT 
	    CASH_ID, 
        CASH_NAME, 
        BRANCH_ID, 
        CASH_CURRENCY_ID 
    FROM 
    	CASH 
</cfquery>
<cfquery name="get_process_cat_dekont" datasource="#dsn3#" maxrows="1">
	SELECT DISTINCT
		SPC.PROCESS_CAT_ID
	FROM
		SETUP_PROCESS_CAT_FUSENAME AS SPCF,
		SETUP_PROCESS_CAT SPC
	WHERE
		SPC.PROCESS_CAT_ID = SPCF.PROCESS_CAT_ID AND
		SPCF.FUSE_NAME = 'ch.popup_form_add_debit_claim_note' AND
		SPC.PROCESS_TYPE = 41
</cfquery>
<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
    <cf_box title="#getLang('','Çek/Senet Aktarım','63623')#">
        <cfform name="formimport" action="" enctype="multipart/form-data" method="post">
            <input type="hidden" name="dekont_process_cat" id="dekont_process_cat" value="<cfoutput>#get_process_cat_dekont.process_cat_id#</cfoutput>">
            <cf_box_elements>
                <div class="col col-4 col-md-4 col-sm-4 col-xs-12" type="column" index="1" sort="true">  
                    <div class="form-group" id="item-file_format">
                        <label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='32901.Belge Formatı'></label>
                        <div class="col col-8 col-md-8 col-sm-8 col-xs-12">
                            <select name="file_format" id="file_format">
                                <option value="UTF-8"><cf_get_lang dictionary_id='32802.UTF-8'></option>
                            </select>
                        </div>
                    </div>  
                    <div class="form-group" id="item-file">
                        <label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='57468.Belge'></label>
                        <div class="col col-8 col-md-8 col-sm-8 col-xs-12">
                            <input type="file" name="uploaded_file" id="uploaded_file">
                        </div>
                    </div> 
                    <div class="form-group" id="item-product_example">
                        <label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='43671.Örnek Ürün Dosyası'></label>
                        <div class="col col-8 col-md-8 col-sm-8 col-xs-12">
                            <a href="/IEF/standarts/import_example_file/cek_Senet_aktarim.csv"><strong><cf_get_lang dictionary_id='43675.İndir'></strong></a>
                        </div>
                    </div> 
                    <div class="form-group" id="item-import">
                        <label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='58530.Aktarım Türü'></label>
                        <div class="col col-8 col-md-8 col-sm-8 col-xs-12">
                            <select name="import_type" id="import_type" onchange="change_account();">
                                <option value="1"><cf_get_lang dictionary_id='58007.Çek'></option>
                                <option value="2"><cf_get_lang dictionary_id='58008.Senet'></option>
                            </select>
                        </div>
                    </div> 
                    <div class="form-group" id="item-status">
                        <label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='57482.Aşama'></label>
                        <div class="col col-8 col-md-8 col-sm-8 col-xs-12">
                            <select name="status" id="status" onchange="change_account();">
                                <option value="1"><cf_get_lang dictionary_id='32810.Portföyde'></option>
                                <option value="2"><cf_get_lang dictionary_id='33788.Bankada'></option>
                                <option value="5"><cf_get_lang dictionary_id='43934.Karşılıksız - Protestolu'></option>
                                <option value="6"><cf_get_lang dictionary_id='33792.Ödenmedi'></option>
                                <option value="4"><cf_get_lang dictionary_id='33790.Ciro Edildi'></option>
                                <option value="13"><cf_get_lang dictionary_id='32812.Teminatta'></option>
                            </select>
                        </div>
                    </div>  
                    <div class="form-group" id="banka" style="display:none;">
                        <label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='57521.Banka'>*</label>
                        <div class="col col-8 col-md-8 col-sm-8 col-xs-12">
                            <select name="bank_account" id="bank_account">
                                <option value=""><cf_get_lang dictionary_id='57734.Seçiniz'></option>
                                <cfoutput query="get_accounts">
                                    <option value="#account_id#;#account_currency_id#">#account_name#</option>
                                </cfoutput>
                            </select>
                        </div>
                    </div> 
                    <div class="form-group" id="kasa">
                        <label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='57520.Kasa'>*</label>
                        <div class="col col-8 col-md-8 col-sm-8 col-xs-12">
                            <select name="cash" id="cash">
                                <option value=""><cf_get_lang dictionary_id='57734.Seçiniz'></option>
                                <cfoutput query="get_cashes">
                                    <option value="#cash_id#;#branch_id#;#cash_currency_id#">#cash_name#</option>
                                </cfoutput>
                            </select>
                        </div>
                    </div> 
                    <div class="form-group" id="item-import_format">
                        <label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='58531.Aktarım Formatı'>*</label>
                        <div class="col col-8 col-md-8 col-sm-8 col-xs-12">
                            <select name="import_format" id="import_format">
                                <option value=""><cf_get_lang dictionary_id='57734.Seçiniz'></option>
                                <option value="1"><cf_get_lang dictionary_id='30266.Kurumsal'>- <cf_get_lang dictionary_id='57558.Üye No'></option>
                                <option value="2"><cf_get_lang dictionary_id='30266.Kurumsal'> - <cf_get_lang dictionary_id='43937.Cari Özel Kod'></option>
                                <option value="3"><cf_get_lang dictionary_id='30266.Kurumsal'> - <cf_get_lang dictionary_id='57752.Vergi No'></option>
                                <option value="4"><cf_get_lang dictionary_id='31101.Bireysel'> - <cf_get_lang dictionary_id='57558.Üye No'></option>
                                <option value="5"><cf_get_lang dictionary_id='31101.Bireysel'> - <cf_get_lang dictionary_id='58025.TC Kimlik No'></option>
                                <option value="6"><cf_get_lang dictionary_id='31101.Bireysel'> - <cf_get_lang dictionary_id='57789.Özel Kod'></option>
                            </select>
                        </div>
                    </div> 
                    <div class="form-group" id="is_cari_action_">
                        <label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='43939.Cari Hareket Yapılsın'></label>
                        <div class="col col-8 col-md-8 col-sm-8 col-xs-12">
                            <input type="checkbox" name="is_cari_action" id="is_cari_action" value="" onclick="kontrol_cari();">
                        </div>
                    </div> 
                    <div class="form-group" id="is_cari_action_dekont_" style="display:none;">
                        <label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='63624.Dekont Kaydı Yapılsın'></label>
                        <div class="col col-8 col-md-8 col-sm-8 col-xs-12">
                            <input type="checkbox" name="is_cari_action_dekont" id="is_cari_action_dekont" value="">
                        </div>
                    </div> 
                </div>
                <div class="col col-8 col-md-8 col-sm-8 col-xs-12" type="column" index="2" sort="true"> 
                    <div class="form-group" id="item-format">
                        <label><b><cf_get_lang dictionary_id='58594.Format'></b></label>
                    </div>   
                    <div class="form-group" id="item-exp1">
                        <cf_get_lang dictionary_id='36199.Açıklama'>:
                    </div> 
                    <div class="form-group" id="item-exp2">
                        <cf_get_lang dictionary_id='44342.Dosya uzantısı csv olmalı,alan araları noktalı virgül (;) ile ayrılmalı ve kaydedilirken karakter desteği olarak UTF-8 seçilmelidir'>
                    </div>    
                    <div class="form-group" id="item-exp3">
                        <cf_get_lang dictionary_id='54238.Aktarım işlemi dosyanın 2 satırından itibaren başlar bu yüzden birinci satırda alan isimleri mutlaka olmalıdır.'>
                    </div>   
                    <div class="form-group" id="item-exp4">
                        <cf_get_lang dictionary_id='44343.Form üzerinden yapılan seçime göre çek veya senet import edilir'>.
                    </div>   
                    <div class="form-group" id="item-exp5">
                        <cf_get_lang dictionary_id='44344.Bütün aşamalar için farklı dosyalar hazırlanmalı ve aşama form üzerinden dosyaya uygun seçilmedilir'>.
                    </div> 
                    <div class="form-group" id="item-exp6">
                        <cf_get_lang dictionary_id='44345.Aşamalara uygun olarak kasa ve banka seçimleri de form üzerinden yapılmalıdır'>.
                    </div>
                    <div class="form-group" id="item-exp7">
                        <cf_get_lang dictionary_id='44346.Cari hareket yapılsın seçilirse portföyde, bankada ve karşılıksız çek/senetler için cari hareket yapar ve karşılık olarak da borç dekontu kaydeder'>.
                    </div>
                    <div class="form-group" id="item-exp8">
                        <cf_get_lang dictionary_id='45041.Belgede olması gereken alan sayısı'> : 19
                    </div>
                    <div class="form-group" id="item-exp9">
                        <cf_get_lang dictionary_id='45042.Alanlar sırası ile'>;
                    </div>
                    <div class="form-group" id="item-exp10">
                        1-<cf_get_lang dictionary_id='57881.Vade Tarihi'>(<cf_get_lang dictionary_id='29801.Zorunlu'>) : <cf_get_lang dictionary_id='44357.Çek veya senetin vade tarihi 01/01/2007 formatında girilmelidir'>.</br>
                        2-<cf_get_lang dictionary_id='44349.Borçlu: Text olarak borçlu adı girilebilir'>.</br>
                        3-<cf_get_lang dictionary_id='57519.Cari Hesap'>(<cf_get_lang dictionary_id='29801.Zorunlu'>) : <cf_get_lang dictionary_id='63625.Aktarım sırasında formdan seçtiğiniz formata göre üye no, özel kod , vergi no veya tc kimlik no olmalıdır'>.</br>
                        4-<cf_get_lang dictionary_id='44351.Banka Adı: Text olarak banka adı girilebilir'>.</br>
                        5-<cf_get_lang dictionary_id='44352.Banka Şubesi: Text olarak banka şube adı girilebilir'>.</br>
                        6-<cf_get_lang dictionary_id='58007.Çek'>/<cf_get_lang dictionary_id='58008.Senet'><cf_get_lang dictionary_id='57487.No'>(<cf_get_lang dictionary_id='29801.Zorunlu'>)</br>
                        7-<cf_get_lang dictionary_id='57673.Tutar'>(<cf_get_lang dictionary_id='29801.Zorunlu'>) : <cf_get_lang dictionary_id='44353.Float olarak çek veya senetin tutarı girilmelidir. Örn : 20065'></br>
                        8-<cf_get_lang dictionary_id='57489.Para Birimi'>(<cf_get_lang dictionary_id='29801.Zorunlu'>) : <cf_get_lang dictionary_id='44354.Text olarak çek veya senetin para birimi girilmelidir. Örn : YTL'></br>
                        9-<cf_get_lang dictionary_id='63626.İşlem Dövizi Karşılığı'></br>
                        10-<cf_get_lang dictionary_id='58121.İşlem Dövizi'></br>
                        11-<cf_get_lang dictionary_id='59210.Müşteri Çeki'> : <cf_get_lang dictionary_id='63627.Müşteri Çeki ise 0 girilmelidir'>.</br>
                        12-<cf_get_lang dictionary_id='57789.Özel Kod'> : <cf_get_lang dictionary_id='44355.Çek veya senetin özel kodu varsa buraya text olarak girilebilir'>.</br>
                        13-<cf_get_lang dictionary_id='58516.Ödeme Yöntemi'> : <cf_get_lang dictionary_id='44356.Çek veya senetin bağlı olduğu belgenin ödeme yöntemi varsa ID si girilebilir'>.</br>
                        14-<cf_get_lang dictionary_id='57673.Tutar'><cf_get_lang dictionary_id='63628.Sistem Dövizi Karşılığı :Float olarak çek veya senetin sistem dövizi karşılığı girilebilir Girilmezse sistem şu andaki kurdan hesaplar'><cf_get_lang dictionary_id='54221.Örn'>: 200,65 </br>
                        15-<cf_get_lang dictionary_id='58178.Hesap No'> : <cf_get_lang dictionary_id='44952.Hesap No bilgisi girilebilir.'></br>
                        16-<cf_get_lang dictionary_id='58902.Çek Sahibi'> : <cf_get_lang dictionary_id='44953.Ciro Edilen çekler için çekin ilk alındığı cari bilgisi girilmelidir'> : <cf_get_lang dictionary_id='63625.Aktarım sırasında formdan seçtiğiniz formata göre üye no, özel kod , vergi no veya tc kimlik no olmalıdır'>.</br>
                        17-<cf_get_lang dictionary_id='58970.Ciro Eden'> : <cf_get_lang dictionary_id='45043.Çekin Ciro Eden bilgisi girilmelidir.'></br>
                        18-<cf_get_lang dictionary_id='29945.Ödeme Sözü'> : <cf_get_lang dictionary_id='63629.Eğer Senet Ödeme Sözü ise 1 , değilse 0 girilmelidir.'></br>
                        19-<cf_get_lang dictionary_id='57879.İşlem Tarihi'> : <cf_get_lang dictionary_id='63630.Cari Hareketin işlem tarihi girilebilir'>.<cf_get_lang dictionary_id='63631.Değer girilmezse bugünün tarihini alır'>.</br>           
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
	function change_account()
	{
		var selected_ptype = document.formimport.status.options[document.formimport.status.selectedIndex].value;
		var selected_import_type = document.formimport.import_type.options[document.formimport.import_type.selectedIndex].value;
		if(selected_ptype == 1 || (selected_ptype == 6 && selected_import_type == 2))
		{
			kasa.style.display='';
			banka.style.display='none';
			is_cari_action_.style.display='';
		}
		else if(selected_ptype == 4) //cek ve senet icin ciro asaması
		{
			banka.style.display='none';
			kasa.style.display='';
			is_cari_action_.style.display='';
		}
		else
		{
			banka.style.display='';
			kasa.style.display='none';
			is_cari_action_.style.display='';
		}
	}
	function kontrol_cari()
	{
		if(document.all.is_cari_action.checked == true)
		{
			is_cari_action_dekont_.style.display='';
		}
		else
		{
			is_cari_action_dekont_.style.display='none';
		}
	}
	function kontrol()
	{
		var selected_ptype = document.formimport.status.options[document.formimport.status.selectedIndex].value;
		var selected_import_type = document.formimport.import_type.options[document.formimport.import_type.selectedIndex].value;
		if(formimport.uploaded_file.value.length==0)
		{
			alert("<cf_get_lang no='1441.Belge Seçmelisiniz'>!");
			return false;
		}
		if(((selected_import_type == 1 && selected_ptype != 1 && selected_ptype != 4) || (selected_import_type == 2 && (selected_ptype == 5 || selected_ptype == 2 ))) && formimport.bank_account.value.length== '')
		{
			alert("<cf_get_lang no ='1957.Banka Hesabı Seçmelisiniz'> !");
			return false;
		}
		if(((selected_import_type == 1 && (selected_ptype == 1 || selected_ptype == 4))  || (selected_import_type == 2 && (selected_ptype == 6 || selected_ptype == 1 || selected_ptype == 4))) && formimport.cash.value.length== '')
		{
			alert("<cf_get_lang no ='1958.Kasa Seçmelisiniz'> !");
			return false;
		}
		if(formimport.import_format.value.length== '')
		{
			alert("<cf_get_lang no ='1959.Aktarım Formatı Seçmelisiniz'>!");
			return false;
		}
		if(formimport.is_cari_action.checked== true && formimport.dekont_process_cat.value.length== '')
		{
			alert("<cf_get_lang no ='1960.Cari İşlem Yapabilmek İçin İşlem Kategorilerinizi Tanımlayınız'>!");
			return false;
		}
		formimport.action='<cfoutput>#request.self#?fuseaction=settings.emptypopup_add_cheque_voucher_import</cfoutput>';
		formimport.target='cc_che';
		formimport.submit();
		return false;
	}
</script>
