<cfset setup_offtime = createObject("component","V16.settings.cfc.setup_offtime")>
<cfset get_offtime = setup_offtime.get_setupofftime()>
<div class="col col-12 col-xs-12">
	<cf_box title="#getLang('','settings',42119)#" <!--- İzin ve Mazeret Kategorileri --->add_href="#request.self#?fuseaction=settings.form_add_offtime">
        <cfform action="#request.self#?fuseaction=settings.emptypopup_offtime_add" method="post" name="offtime">
            <cf_box_elements>		
				<div class="col col-3 col-md-3 col-sm-3 col-xs-12" type="column" index="1" sort="true">
					<cfinclude template="../display/list_offtime.cfm">
				</div>	
				<div class="col col-9 col-md-9 col-sm-9 col-xs-12" type="column" index="2" sort="true">
					<div class="col col-6 col-md-6 col-sm-6 col-xs-12">
						<div class="form-group" id="item-getofftime">
							<label class="col col-3 col-md-6 col-xs-12"><cf_get_lang dictionary_id='29736.Üst Kategori'></label>
							<div class="col col-8 col-md-6 col-xs-12">
								<select name="upper_offtime_cat_id" id="upper_offtime_cat_id" style="width:180px;">
                                    <option value="0"><cf_get_lang dictionary_id='29736.Üst Kategori'></option>
                                    <cfoutput query="get_offtime">
                                        <option value="#offtimecat_id#">#offtimecat#</option>
                                    </cfoutput> 
                                </select>
							</div>
						</div>
						<div class="form-group" id="item-offtimecat">
							<label class="col col-3 col-md-6 col-xs-12"><cf_get_lang dictionary_id='57480.Konu'>*</label>
							<div class="col col-8 col-md-6 col-xs-12">
                                <cfsavecontent variable="message"><cf_get_lang dictionary_id='55455.Başlık girmelisiniz'></cfsavecontent>
                                    <cfinput type="Text" name="offTimeCat" size="30" value="" maxlength="50" required="Yes" message="#message#" style="width:180px;">							
                            </div>
						</div>
                        <div class="form-group" id="item-ebildirge">
							<label class="col col-3 col-md-6 col-xs-12"><cf_get_lang dictionary_id='43081.E-Bildirge Karşılığı '>*</label>
							<div class="col col-8 col-md-6 col-xs-12">
                                <select name="ebildirge_type_id" id="ebildirge_type_id" style="width:180px;"  onChange="show_type();" >
                                    <option value="01"><cf_get_lang dictionary_id='43316.İstirahat'></option>
                                    <!--- <option value="02">Ücretsiz/Aylık İzin</option> --->
                                    <option value="03"><cf_get_lang dictionary_id='43318.Disiplin Cezası'></option>
                                    <option value="04"><cf_get_lang dictionary_id='43319.Gözaltına Alınma'></option>
                                    <option value="05"><cf_get_lang dictionary_id='43320.Tutukluluk'></option>
                                    <option value="06"><cf_get_lang dictionary_id='43321.Kısmi İstihdam'></option>
                                    <option value="07"><cf_get_lang dictionary_id='43322.Puantaj Kayıtları'></option>
                                    <option value="08"><cf_get_lang dictionary_id='43323.Grev'></option>
                                    <option value="09"><cf_get_lang dictionary_id='43324.Lokavt'></option>
                                    <option value="10"><cf_get_lang dictionary_id='43325.GHE Olaylar'></option>
                                    <option value="11"><cf_get_lang dictionary_id='43326.Doğal Afet'></option>
                                    <option value="12"><cf_get_lang dictionary_id='43327.Birden Fazla'></option>
                                    <option value="13"><cf_get_lang dictionary_id='35232.Diğer nedenler'></option>
                                    <!--- <option value="14"><cf_get_lang dictionary_id='744.Diğer'></option> --->
                                    <option value="15"><cf_get_lang dictionary_id='44798.Devamsızlık'></option>
                                    <option value="16"><cf_get_lang dictionary_id='44799.Fesih Tarihinde Çalışmamış'></option>
                                    <option value="17"><cf_get_lang dictionary_id='44800.Ev Hizmetlerinde 30 Günden Az Çalışma'></option>
                                    <option value="18"><cf_get_lang dictionary_id='44833.Kısa Çalışma Ödeneği'></option>
                                    <option value="19"><cf_get_lang dictionary_id='61286.Ücretsiz Doğum İzni'></option>
                                    <option value="20"><cf_get_lang dictionary_id='61287.Ücretsiz Yol İzni'></option>
                                    <option value="21"><cf_get_lang dictionary_id='58156.Diğer'> <cf_get_lang dictionary_id='55756.Ücretsiz İzin'></option>
                                    <option value="22">5434 SK EK 76, GM 192</option>
                                    <option value="23"><cf_get_lang dictionary_id='61288.Yarım Çalışma Ödeneği'></option>
                                    <option value="24"><cf_get_lang dictionary_id='61289.Yarım Çalışma Ödeneği ve Diğer Nedenler'></option>
                                    <option value="25"><cf_get_lang dictionary_id='61290.Diğer Belge/Kanun Türlerinden Gün Tamamlama'></option>
                                    <option value="26"><cf_get_lang dictionary_id='61291.Kısmi İstihdama İzin Verilen Yabancı Uyruklu Sigortalı'></option>
                                    <option value="27"><cf_get_lang dictionary_id='60717.Kısa Çalışma Ödeneği ve diğer'></option>
                                    <option value="28"><cf_get_lang dictionary_id='61292.Pandemi Ücretsiz İzin'>(4857 Geç. 10. md)</option>
                                    <option value="29"><cf_get_lang dictionary_id='60784.Pandemi Ücretsiz İzin ve Diğer'></option>
                                </select>
							</div>
						</div>
                        <div class="form-group" id="item-offtimecat">
							<label class="col col-3 col-md-6 col-xs-12"><cf_get_lang dictionary_id='42462.Ücretli'></label>
							<div class="col col-8 col-md-6 col-xs-12">
                                    <input type="checkbox" name="is_paid" id="is_paid" value="1">
                             </div>
						</div>
                        <div class="form-group" id="item-yillikizin">
							<label class="col col-3 col-md-6 col-xs-12"><cf_get_lang dictionary_id='43082.Yıllık İzin'></label>
							<div class="col col-8 col-md-6 col-xs-12">
                                <input type="checkbox" name="yillik_izin" id="yillik_izin" value="1"  onchange="control(this,2)">
                             </div>
						</div>
                        <div class="form-group" id="paid_a_day">
							<label class="col col-3 col-md-6 col-xs-12"><cf_get_lang dictionary_id='61115.1 Gününü Şirket Öder'></label>
							<div class="col col-8 col-md-6 col-xs-12">
                                <input type="checkbox" name="paid_a_day" id="paid_a_day" value="1">
                             </div>
						</div>
                        <div class="form-group" id="item-twodays">
							<label class="col col-3 col-md-6 col-xs-12"><cf_get_lang dictionary_id='43083.2 Gününü Şirket Öder'></label>
							<div class="col col-8 col-md-6 col-xs-12">
                                <input type="checkbox" name="sirket_gun" id="sirket_gun" value="2">
                             </div>
						</div>
                        <div class="form-group" id="item-kidem">
							<label class="col col-3 col-md-6 col-xs-12"><cf_get_lang dictionary_id='44802.Kıdeme Dahil'></label>
							<div class="col col-8 col-md-6 col-xs-12">
                                <input type="checkbox" name="is_kidem" id="is_kidem" value="1">
                             </div>
						</div>
                        <div class="form-group" id="item-request">
							<label class="col col-3 col-md-6 col-xs-12"><cf_get_lang dictionary_id ='30828.Talep'><cf_get_lang dictionary_id ='32986.Edilebilir'></label>
							<div class="col col-8 col-md-6 col-xs-12">
                                <input type="checkbox" name="is_requested" id="is_requested" value="1">
                             </div>
						</div>
                        <div class="form-group" id="item-puantaj">
							<label class="col col-3 col-md-6 col-xs-12"><cf_get_lang dictionary_id = "53662.Puantajda görüntülenmesin"></label>
							<div class="col col-8 col-md-6 col-xs-12">
                                <input type="checkbox" name="is_puantaj_off" id="is_puantaj_off" value="1">
                             </div>
						</div>
                        <div class="form-group" id="item-RDSSK">
							<label class="col col-3 col-md-6 col-xs-12"><cf_get_lang dictionary_id = "31750.ARGE Gününe Dahil"></label>
							<div class="col col-8 col-md-6 col-xs-12">
                                 <input type="checkbox" name="IS_RD_SSK" id="IS_RD_SSK" value="1">
                             </div>
						</div>
                        <div class="form-group" id="item-entitlements">
							<label class="col col-3 col-md-6 col-xs-12"><cf_get_lang dictionary_id = "33623.İzin ekranında hak edişi göster"></label>
							<div class="col col-8 col-md-6 col-xs-12">
                                <input type="checkbox" name="show_entitlements" id="show_entitlements" value="1" onchange="control(this,1)">
                             </div>
						</div>
                        <div class="form-group" id="item-document">
							<label class="col col-3 col-md-6 col-xs-12"><cf_get_lang dictionary_id ='57468.Belge'><cf_get_lang dictionary_id ='34493.ekleme'><cf_get_lang dictionary_id ='29801.Zorunlu'></label>
							<div class="col col-8 col-md-6 col-xs-12">
                                <input type="checkbox" name="is_document" id="is_document" value="1">
                             </div>
						</div>
                        <div class="form-group" id="item-repeatable">
							<label class="col col-3 col-md-6 col-xs-12"><cf_get_lang dictionary_id ='41046.Periyodik İzin Girilebilir'></label>
							<div class="col col-8 col-md-6 col-xs-12">
                                 <input type="checkbox" name="IS_REPEATABLE_APP" id="IS_REPEATABLE_APP" value="1">
                             </div>
						</div>
                        <div class="form-group" id="item-freetime">
							<label class="col col-3 col-md-6 col-xs-12"><cf_get_lang dictionary_id ='59940.Serbest zamanda kullanılsın'></label>
							<div class="col col-8 col-md-6 col-xs-12">
                                 <input type="checkbox" name="IS_FREE_TIME" id="IS_FREE_TIME" value="1">
                             </div>
						</div>
                        <div class="form-group" id="item-offday">
							<label class="col col-3 col-md-6 col-xs-12"><cf_get_lang dictionary_id='61285.İzin Günü Öteleme'></label>
							<div class="col col-8 col-md-6 col-xs-12">
                                 <input type="checkbox" name="IS_OFFDAY_DELAY" id="IS_OFFDAY_DELAY" value="1">
                             </div>
						</div>
                        <div class="form-group" id="item-offtimecat">
							<label class="col col-3 col-md-6 col-xs-12"><cf_get_lang dictionary_id="60720.Takvim Gününden Hesapla"></label>
							<div class="col col-8 col-md-6 col-xs-12">
                                 <input type="checkbox" name="CALC_CALENDAR_DAY" id="CALC_CALENDAR_DAY" value="1">
                            </div>
						</div>
                        <div class="form-group" id="item-included_in_tax">
							<label class="col col-3 col-md-6 col-xs-12"><cf_get_lang dictionary_id='65282.İzin Vergiye Dahil Edilsin'></label>
							<div class="col col-8 col-md-6 col-xs-12">
                                 <input type="checkbox" name="included_in_tax" id="included_in_tax" value="1">
                            </div>
						</div>
                        <div class="form-group" id="item-permission">
							<label class="col col-3 col-md-6 col-xs-12"><cf_get_lang dictionary_id ='37319.max'><cf_get_lang dictionary_id ='58575.izin'><cf_get_lang dictionary_id ='58651.türü'></label>
							<div class="col col-8 col-md-6 col-xs-12">
								<select name="permission_type" id="permission_type" onChange="show_day();" style="width:122px;">
                                    <option value=""><cf_get_lang dictionary_id='57734.Seçiniz'></option>
                                    <option value="1"><cf_get_lang dictionary_id="57491.Saat">-<cf_get_lang dictionary_id="58127.Minute"></option>
                                    <option value="2"><cf_get_lang dictionary_id="57490.Gün"></option>
                                    <option value="3"><cf_get_lang dictionary_id="58455.Yıl"></option>
                                </select>
							</div>
						</div>
                        <div class="form-group"  id="day_part" <cfif isdefined("attributes.permission_type") and len(attributes.permission_type) and attributes.permission_type eq 2>style="display:inline"<cfelse>style="display:none"</cfif>>
							<label class="col col-3 col-md-6 col-xs-12"><cf_get_lang dictionary_id ='58458.haftalık'><cf_get_lang dictionary_id ='53727.çalışma günü'></label>
							<div class="col col-8 col-md-6 col-xs-12">
                                <select name="day_" id="day_" style="width:122px;">
                                    <option value=""><cf_get_lang dictionary_id='57734.Seçiniz'></option>
                                    <option value="5">5</option>
                                    <option value="6">6</option>
                                    <option value="7">7</option>
                                </select>
							</div>
						</div>
                        <div class="form-group" id="item-offtimecat">
							<label class="col col-3 col-md-6 col-xs-12"><cf_get_lang dictionary_id ='41119.Süresi'></label>
							<div class="col col-8 col-md-6 col-xs-12">
                                    <input type="text" name="max_permission_time" id="max_permission_time" value="" onKeyUp="return(FormatCurrency(this,event));" validate="integer">
                            </div>
						</div>
					</div>
			    </div>
			</cf_box_elements>
			<cf_box_footer>
			<cf_workcube_buttons is_upd='0' add_function='unformat()'>
		</cf_box_footer>
		</cfform>
	</cf_box>
</div>
<script>
    function show_day(){
        if(document.offtime.permission_type.value == 2)
        day_part.style.display = '';
        else 
        day_part.style.display = 'none';
        
    } 
    function show_type()
    {
        if(document.offtime.ebildirge_type_id.value == 01)
            document.getElementById("paid_a_day").style.display = '';
        else 
            document.getElementById("paid_a_day").style.display = 'none';
    } 
    function unformat(element,type)
    {
       $("#max_permission_time").val(filterNum($("#max_permission_time").val()));
    }
    function control(element,type)
    {
        if(element.checked && document.getElementById("yillik_izin").checked && type == 1){
            alert("<cf_get_lang dictionary_id='61293.Yıllık izin ve İzin ekranında hak edişi göster seçeneği aynı anda seçilemez'>!");
            element.checked = !element.checked;
        }else if(element.checked && document.getElementById("show_entitlements").checked && type == 2){
            alert("<cf_get_lang dictionary_id='61293.Yıllık izin ve İzin ekranında hak edişi göster seçeneği aynı anda seçilemez'>!");
            element.checked = !element.checked;
        }
    }
  </script>