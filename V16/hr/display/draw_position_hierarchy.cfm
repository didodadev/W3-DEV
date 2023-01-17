<cf_box title="<cf_get_lang dictionary_id='58426.Pozisyon Şema Tasarımcısı'>" closable="0">
    <cfform name="add_pos" action="">
        <div class="row">
            <div class="col col-3 col-xs-12">
                <div class="form-group">
                    <div class="col col-12 col-xs-12">
                        <label><cf_get_lang dictionary_id='58497.Pozisyon'>*</label>
                        <div class="input-group">
                            <cfif isdefined("attributes.upper_position_code")>
                                <cfset position_name = "#attributes.upper_position#">
                            <cfelse>
                                <cfset position_name = "">
                            </cfif>
                            <input type="hidden" name="upper_position_code" id="upper_position_code" value="">
                            <input type="text" name="upper_position" id="upper_position"  onFocus="AutoComplete_Create('upper_position','FULLNAME','POSITION_NAME','get_emp_pos','','POSITION_CODE,POSITION_NAME','upper_position_code,upper_position','add_pos','3','162');" value="" style="width:190px;">
                            <span class="input-group-addon btnPointer icon-ellipsis" onClick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=hr.popup_list_positions&field_code=add_pos.upper_position_code&position_employee=add_pos.upper_position&show_empty_pos=1','list','popup_list_positions');return false"></span>
                        </div>
                    </div>        
                </div>    
                <div class="form-group">
                    <label class="col col-12 col-xs-12"><cf_get_lang dictionary_id='58427.Bağlılık'></label>
                    <label class="col col-4 col-xs-6">
                        <input type="radio" name="baglilik" id="baglilik" value="1" checked><cf_get_lang dictionary_id="58428.İdari">
                    </label>    
                    <label class="col col-4 col-xs-6">    
                        <input type="radio" name="baglilik" id="baglilik" value="2"><cf_get_lang dictionary_id="58429.Fonksiyonel">							
                    </label>    
                </div>
                <div class="form-group">
                    <label class="col col-12 col-xs-12"><cf_get_lang dictionary_id="57671.Basamak"></label>
                    <div class="col col-4 col-xs-4">
                        <select name="alt_cizim_sayisi" id="alt_cizim_sayisi">
                            <option value="1"><cf_get_lang dictionary_id="55781.Aşağı"></option>
                            <option value="1">1</option>
                            <option value="2">2</option>
                            <option value="3">3</option>
                            <option value="4">4</option>
                            <option value="5">5</option>
                            <option value="6">6</option>
                            <option value="7">7</option>
                            <option value="8">8</option>
                            <option value="9">9</option>
                            <option value="10">10</option>
                        </select>
                    </div>    
                    <div class="col col-4 col-xs-4">
                        <select name="ust_cizim_sayisi" id="ust_cizim_sayisi">
                            <option value="0"><cf_get_lang dictionary_id="55780.Yukarı"></option>
                            <option value="1">1</option>
                            <option value="2">2</option>
                        </select>
                    </div>
                    <div class="col col-4 col-xs-4">
                        <select name="is_kademe" id="is_kademe">
                            <option value="1" selected><cf_get_lang dictionary_id="58430.Kademesiz"></option>
                            <option value="2"><cf_get_lang dictionary_id="58432.Kademeli"></option>
                        </select>
                    </div>  
                </div>
                <cfif session.ep.ehesap>
                    <div class="form-group">
                        <label class="col col-12 col-xs-12">(<cf_get_lang dictionary_id='56373.Sadece İdari Çizimde'>)</label>
                        <label class="col col-6 col-xs-12"><input type="checkbox" value="1" name="is_fonksiyonel" id="is_fonksiyonel"><cf_get_lang dictionary_id='56374.Fonksiyonel Bağlıları Ekle'></label>
                    </div>
                    <div class="form-group">
                        <label class="col col-12 col-xs-12"><cf_get_lang dictionary_id='55498.Pozisyon Çalışanı'></label>
                        <label class="col col-6 col-xs-12"><input type="checkbox" value="1" name="is_empty_pos" id="is_empty_pos"><cf_get_lang dictionary_id='58433.Boş Pozisyonları Göster'></label>
                    </div>
                    <div class="form-group">
                        <label class="col col-12 col-xs-12"><cf_get_lang dictionary_id='55498.Pozisyon Çalışanı'></label>
                        <label class="col col-6 col-xs-12"><input type="checkbox" value="1" name="is_critical" id="is_critical"><cf_get_lang dictionary_id='58434.Kritik Pozisyonları Göster'></label>
                    </div>
                </cfif>
                <div class="form-group">
                    <label class="col col-12 col-xs-12"><input type="checkbox" value="1" name="is_active_in_out" id="is_active_in_out"><cf_get_lang dictionary_id ='53226.Aktif Çalışanlar'></label>
                </div>
                <div class="form-group">
                    <label class="col col-12 col-xs-12"><cf_get_lang dictionary_id='56331.Bilgiler'></label>
                    <label class="col col-3 col-xs-12">
                        <input type="checkbox" value="1" name="is_unvan" id="is_unvan"><cf_get_lang dictionary_id='57571.Ünvan'>
                    </label>
                    <label class="col col-3 col-xs-12">
                        <input type="checkbox" value="1" name="is_pozisyon" id="is_pozisyon"><cf_get_lang dictionary_id='58497.Pozisyon'>
                    </label>
                    <label class="col col-6 col-xs-12">    
                        <input type="checkbox" value="1" name="is_pozisyon_tipi" id="is_pozisyon_tipi"><cf_get_lang dictionary_id='57779.Pozisyon Tipleri'>
                    </label>
                    <label class="col col-3 col-xs-12">
                        <input type="checkbox" value="1" name="is_resim" id="is_resim"><cf_get_lang dictionary_id='58080.Resim'>
                    </label>    
                </div>
                <div class="form-group">
                    <label class="col col-12 col-xs-12"><cf_get_lang dictionary_id='29792.Tasarım'></label>
                    <div class="col col-4 col-xs-12">
                        <select name="tasarim_tipi" id="tasarim_tipi">
                            <option value="1" selected><cf_get_lang dictionary_id='29794.Yatay'></option>
                            <option value="2"><cf_get_lang dictionary_id='29793.Dikey'></option>
                            <option value="3"><cf_get_lang dictionary_id='58901.Ağaç'></option>
                        </select>
                    </div>
                </div>
            </div>    
        </div>
        <div class="row formContentFooter">
           <input type="button" value="<cf_get_lang dictionary_id='56376.Çizim Yap'>" onClick="kontrol();">
        </div>
    </cfform>
</cf_box>
<script type="text/javascript">
	function kontrol()
	{
	if(document.add_pos.upper_position_code.value == '' ||  document.add_pos.upper_position.value == '')
		{
		alert("<cf_get_lang dictionary_id='56375.Pozisyon Seçmelisiniz'>");
		return false;
		}
	windowopen('','project','cizim_ekrani_pozisyon');
	add_pos.action='<cfoutput>#request.self#?fuseaction=hr.popup_draw_position_hierarchy</cfoutput>';
	add_pos.target='cizim_ekrani_pozisyon';add_pos.submit();
	}
</script>
