<cfparam name="attributes.bank_code" default="" />

<!-- Banka-->
<cfquery name="GET_ACCOUNTS" datasource="#dsn#">
	SELECT A.BANK_CODE, A.BANK_NAME FROM SETUP_BANK_TYPES A ORDER BY A.BANK_NAME
</cfquery>

<cfset module_name = 'main' />
<cfsavecontent variable="head_text">
<title><cf_get_lang dictionary_id='48844.WoDiBa Banka İşlem Tipi Tanımları'></title>
</cfsavecontent>
<cfhtmlhead text="#head_text#" />

<cf_box title="#getLang('main','',48844,'WoDiBa Banka İşlem Tipi Tanımları')#" scroll="1" draggable="1" collapsable="1" resize="1" popup_box="#iif(isdefined("attributes.draggable"),1,0)#">
    <cfform action="#request.self#?fuseaction=settings.wodiba_bank_process_type_definitions&event=add" method="post" height = "%60" width="%60">
    <input type="hidden" name="is_submit" id="is_submit" value="1" />
    <div class="row">
        <div class="col col-12 uniqueRow">
            <div class="row formContent">
                <div class="row" type="row">
                    <!--- Banka Adı --->
                    <div class="form-group" id="item-bank_code">
                        <label class="col col-4 col-xs-12" for="bank_code"><cf_get_lang dictionary_id='48695.Bank Name'> *</label>
                            <select name="bank_code" id="bank_code" style="width:100px;">
                                <option value=""><cf_get_lang_main no='322.Seçiniz'></option>
                                <cfoutput query="GET_ACCOUNTS">
                                    <option value="#bank_code#">#bank_name#-#Bank_Code#</option>
                                </cfoutput>
                            </select>
                    </div>
                    <div class="form-group">
                        <label class="col col-12 col-md-12 col-xs-12"><cf_get_lang dictionary_id='48886'> *</label>
                        <input type="text" name="selectTCode1" id="selectTCode1" style="width:250px;"  />
                    </div>
                    <div class="form-group">
                        <label class="col col-12 col-md-12 col-xs-12"><cf_get_lang dictionary_id='48886'>2</label>
                        <input type="text" name="selectTCode2" id="selectTCode2" style="width:250px;"  />
                    </div>
                    <div class="form-group">
                        <label class="col col-12 col-md-12 col-xs-12"><cf_get_lang dictionary_id='57800'></label>
                        <select name="selectPType" id="selectPType">
                            <option value=""><cf_get_lang dictionary_id='57692.İşlem'></option>
                            <option value="1044">Çek İşlemi Ödeme Bankadan (1044)</option>
                            <option value="1043">Çek İşlemi Tahsil Bankaya (1043)</option>
                            <option value="2501">Çek/Senet Banka Ödeme (2501)</option>
                            <option value="23"><cf_get_lang_main no='2401.Döviz Alış Satış Virman İşlemi'> (23)</option>
                            <option value="24">Gelen Havale (24)</option>
                            <option value="121">Gelir Fişi (121)</option>
                            <option value="25">Giden Havale (25)</option>
                            <option value="120">Harcama Fişi (120)</option>
                            <option value="22">İşlem (Para Çekme) (22)</option>
                            <option value="21">İşlem (Para Yatırma) (21)</option>
                            <option value="244">Kredi Kartı Borcu Ödeme (244)</option>
                            <option value="248">Kredi Kartı Borcu Ödeme İptal (248)</option>
                            <option value="243">Kredi Kartı Hesaba Geçiş (243)</option>
                            <option value="247">Kredi Kartı Hesaba Geçiş İptal (247)</option>
                            <option value="291">Kredi Ödemesi (291)</option>
                            <option value="292">Kredi Tahsilatı (292)</option>
                            <option value="1051">Senet İşlemi Ödeme Bankadan (1051)</option>
                            <option value="1053">Senet İşlemi Tahsil Bankaya (1053)</option>
                        </select>
                    </div>
                    <div class="form-group">
                        <label class="col col-12 col-md-12 col-xs-12"><cf_get_lang dictionary_id='54291'></label>
                        <input type="text" name="inputd1" id="inputd1" style="width:250px;" value="" />
                    </div>
                    <div class="form-group">
                        <label class="col col-12 col-md-12 col-xs-12"><cf_get_lang dictionary_id='54291'> 2</label>
                        <input type="text" name="inputd2" id="inputd2" style="width:250px;" value="" />
                    </div>
                    <div class="form-group">
                        <label class="col col-12 col-md-12 col-xs-12"><cf_get_lang_main no='142.Giriş'>/ <cf_get_lang_main no='19.Çıkış'> *</label>
                        <select name="selectIO" id="selectIO">
                            <option value=""><cf_get_lang_main no='322.Seçiniz'></option>
                            <option value="IN"><cf_get_lang_main no='142.Giriş'></option>
                            <option value="OUT"><cf_get_lang_main no='19.Çıkış'></option>
                        </select>
                    </div>
                </div>
                <div class="row formContentFooter">
                    <div class="col col-12">
                        <cf_workcube_buttons is_upd='0' add_function="ControlValue()">
                    </div>
                </div>
            </div>
        </div>
    </div>
    </cfform>
</cf_box>
<cfif isdefined("attributes.is_submit")>
<script>alert('<cf_get_lang_main no='33728.Eklendi'>');</script>
</cfif>

<script type="text/javascript">
    $(document).keydown(function(e){
        // ESCAPE key pressed
        if (e.keyCode == 27) {
            window.close();
        }
    });

    function ControlValue()
	{
		bank_code = document.getElementById('bank_code').value;
        selectPType = document.getElementById('selectPType').value;
        selectIO = document.getElementById('selectIO').value;
        selectTCode1=document.getElementById('selectTCode1').value;
		
		if(bank_code == ""){
			alert("<cf_get_lang dictionary_id='58940.Banka Seçiniz'> !"); return false;
		}
        if(selectTCode1==""){
			alert("<cf_get_lang dictionary_id='62552.Lütfen İşlem Kodunu Girin'> !"); return false;
		}
        if(selectPType == ""){
			alert("<cf_get_lang dictionary_id='45500.İşlem Tipi Seçmelisiniz!'> !"); return false;
		}    
        if(selectIO == ""){
			alert("<cf_get_lang dictionary_id='62551.Giriş / Çıkış Seçiniz'> !"); return false;
		}

		return true;
	}
</script>