<cfset save_folder = "#upload_folder#e_government#dir_seperator#xslt" />
<!--- Dizin kontrolü --->
<cfif Not DirectoryExists("#save_folder#")>
    <cfdirectory action="create" directory="#save_folder#" />
</cfif>
<cfif session.ep.admin eq 1>
    <cfscript>
        eshipment = createObject("component","V16.e_government.cfc.eirsaliye.common");
        eshipment.dsn = dsn;
        get_our_company = eshipment.get_our_company_fnc(session.ep.company_id);
        get_shipment_num = eshipment.GetShipNumber();
    </cfscript>

    <div class="col col-12 col-xs-12">  
    <cf_box title="#getLang('','E-İrsaliye Entegrasyon Tanımları',60902)#" closable="0">
        <cfform name="eshipment_integration_definition"  enctype="multipart/form-data" method="post">
            <input type="hidden" name="save_folder" id="save_folder" value="<cfoutput>#save_folder#</cfoutput>" />
            <cf_box_elements>
                <div class="col col-6 col-md-6 col-sm-6 col-xs-12" type="column" index="1" sort="true">
                    <div class="form-group">
                        <label class="col col-4"><cf_get_lang dictionary_id='57493.Aktif'></label> 
                        <label class="col col-6"><input type="checkbox" id="is_active" name="is_active" <cfif get_our_company.is_eshipment eq 1>checked</cfif>/></label> 
                    </div> 
                    <div class="form-group">
                        <label class="col col-4"><cf_get_lang dictionary_id='62362.E-İrsaliye Geçiş Tarihi'> *</label> 
                        <div class="col col-4">
                            <div class="input-group">
                                <cfinput type="text" name="eshipment_date" value="#iif( len(get_our_company.ESHIPMENT_DATE),'dateformat(get_our_company.ESHIPMENT_DATE,dateformat_style)',DE(dateformat(now(),dateformat_style)))#" validate="#validate_style#" maxlength="10">
                                <span class="input-group-addon btnPointer"><cf_wrk_date_image date_field="eshipment_date"></span>
                            </div>
                        </div>
                    </div>
                    <div class="form-group" id="item-live_url">
                        <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='62363.Live URL'> *</label>
                        <div class="col col-4 col-xs-12">
                            <input type="text" name="eshipment_live_url" id="eshipment_live_url" value="<cfoutput>#get_our_company.ESHIPMENT_LIVE_URL#</cfoutput>">
                        </div>
                    </div>
                    <div class="form-group" id="item-test_url">
                        <label class="col col-4 col-xs-12">Test URL *</label>
                        <div class="col col-4 col-xs-12">
                            <input type="text" name="eshipment_test_url" id="eshipment_test_url" value="<cfoutput>#get_our_company.ESHIPMENT_TEST_URL#</cfoutput>">
                        </div>
                    </div>
                    <div class="form-group" style="display:none">
                        <td><cf_get_lang dictionary_id='30555.İmza Adresi'> *</td>
                        <td><input type="text" id="eshipment_signature_url" name="eshipment_signature_url" value="" maxlength="100" style="width:185px;"/>&nbsp;(Örnek : http://192.168.7.77/sign.asmx?wsdl veya http://192.168.10.15:8080/signer/services/SignerPort)</td>
                    </div>   
                    <div class="form-group">
                        <label class="col col-4"><cf_get_lang dictionary_id='58826.Test'></label> 
                        <label class="col col-6"><input type="checkbox" id="eshipment_test_system" name="eshipment_test_system" <cfif get_our_company.eshipment_test_system eq 1>checked</cfif>/></label> 
                    </div> 
                    <div class="form-group" id="item-eshipment_type">
                        <label class="col col-4 col-xs-12">Entegrasyon Tipi*</label>
                        <div class="col col-4 col-xs-12">
                            <select name="eshipment_type" id="eshipment_type" style="width:185px;">
                                <option value=""><cf_get_lang dictionary_id='57734.Seçiniz'> !</option>
                                <option value="dp" <cfif get_our_company.eshipment_type_alias eq 'dp'> selected</cfif>>Digital Planet</option>
                                <option value="dgn" <cfif get_our_company.eshipment_type_alias eq 'dgn'> selected</cfif>>Doğan E-Dönüşüm</option>
                                <option value="spr" <cfif get_our_company.eshipment_type_alias eq 'spr'> selected</cfif>>Süper Entegratör</option>
                            </select>
                        </div>
                    </div>
                    <div class="form-group">
                        <label class="col col-4"><cf_get_lang dictionary_id='30522.UBL Versiyon Seçiniz'><cf_get_lang dictionary_id='32484.Versiyon'>*</label> 
                        <div class="col col-4">
                            <select class="col col-4" name="eshipment_ublversion" id="eshipment_ublversion">
                                <option value=""><cf_get_lang dictionary_id='57734.Seçiniz'> !</option>
                                <option value="2.1;TR1.2.1" <cfif get_our_company.customizationid eq 'TR1.2.1'> selected</cfif>>TR1.2.1</option>
                            </select>
                        </div>
                    </div> 
                    <div class="form-group">
                        <label class="col col-4"><cf_get_lang dictionary_id='47568.Şirket KOdu'>*</label> 
                        <label class="col col-4"><input type="text" id="eshipment_company_code" name="eshipment_company_code" value="<cfoutput>#get_our_company.eshipment_company_code#</cfoutput>"/></label> 
                    </div> 
                    <div class="form-group">
                        <label class="col col-4"><cf_get_lang dictionary_id='57551.Kullanıcı Adı'>*</label> 
                        <label class="col col-4"><input type="text" id="eshipment_user_name" name="eshipment_user_name" value="<cfoutput>#get_our_company.eshipment_user_name#</cfoutput>"/></label> 
                    </div> 
                    <div class="form-group">
                        <label class="col col-4"><cf_get_lang dictionary_id='57552.Şifre'>*</label> 
                        <label class="col col-4"><input type="password" id="eshipment_password" name="eshipment_password" value="<cfoutput>#get_our_company.eshipment_password#</cfoutput>"/></label> 
                    </div> 
                    <div class="form-group">
                        <label class="col col-4"><cf_get_lang dictionary_id='60911.E-İrsaliye'> <cf_get_lang dictionary_id='57487.No'>*</label> 
                        <div class="col col-4">
                            <div class="input-group">
                                <input type="text" name="eshipment_prefix" value="<cfoutput>#get_shipment_num.eshipment_prefix#</cfoutput>" maxlength="3" required="yes"/>
                                <span class="input-group-addon no-bg"></span>
                                <input type="text" name="eshipment_number" value="<cfoutput>#get_shipment_num.eshipment_number#</cfoutput>" maxlength="9" required="yes"/>
                            </div>
                        </div>
                    </div> 
                    <div class="form-group">
                        <label class="col col-4"><cf_get_lang dictionary_id='57241.Şablon'></label> 
                        <div class="col col-4">
                            <input type="file" id="eshipment_template" name="eshipment_template" accept=".xslt" width="185" />
                        </div>
                        <cfif len(get_our_company.template_filename)>
                            <span class="input-group-addon no-bg"></span>
                            <input type="checkbox" id="del_template" name="del_template" onchange="del_template_control();"/> <label for="del_template">Şablonu Sil</label>
                        </cfif>
                    </div> 
                    <div class="form-group">
                        <label class="col col-4"><cf_get_lang dictionary_id='62364.Gelen E-İrsaliyede Süreç Kullanılıyor'></label> 
                        <label class="col col-6"><input type="checkbox" id="is_receiving_process" name="is_receiving_process"/></label> 
                    </div> 
                    <div class="form-group">
                        <label class="col col-4"><cf_get_lang dictionary_id='30523.Özel Periyot'></label> 
                        <label class="col col-6"><input type="checkbox" id="special_period" name="special_period"/></label> 
                    </div> 
                    <div class="form-group">
                        <label class="col col-4"><cf_get_lang dictionary_id='62361.Çoklu Seri Kullanılsın'></label> 
                        <label class="col col-6"><input type="checkbox" id="multiple_prefix" name="multiple_prefix"/></label> 
                    </div> 
                </div>
            </cf_box_elements>
            <cf_box_footer>
                <div class="col col-12">
                    <cf_workcube_buttons type_format="1" is_upd='0' add_function='kontrol()'>
                </div>
            </cf_box_footer>
        </cfform>
    </cf_box>
    </div>
<cfelse>
    <cf_get_lang dictionary_id='29938.Sistem Yöneticinize Başvurun'>
</cfif>
<script>
    function del_template_control()
    {
        if( $("#del_template").is(':checked') ) {
            $("#eshipment_template").prop('disabled', true);
        }else{
            $("#eshipment_template").prop('disabled', false);
        }
    }

    function kontrol(){

        if( $("#eshipment_company_code").val() == '' || $("#eshipment_user_name").val() == '' || $("#eshipment_password").val() == '' ) {
            alert("<cf_get_lang dictionary_id='62365.Şirket Kodu, Kullanıcı Adı ya da Şifre alanlarını boş bırakmayın'>");
            return false;
        }

        if( $("#eshipment_live_url").val() == '' || $("#eshipment_test_url").val() == '' ){
            alert("URL <cf_get_lang dictionary_id='43296.Alanını boş bırakmayın'>");
            return false;
        }

        if( $("#eshipment_type").val() == '' ){
            alert("URL <cf_get_lang dictionary_id='57262.Entegrasyon Yöntemi Seçiniz'>");
            return false;
        }

        if( $("#eshipment_ublversion").val() == '' ){
            alert("<cf_get_lang dictionary_id='30522.Ubl Versiyon Seçin'>");
            return false;
        }

        if( $("input[name=eshipment_prefix]").val().length != 3){
            alert("<cf_get_lang dictionary_id='61024.Ön Ek 3 Karakter olmalıdır'>");
            return false;
        }

        if( $("input[name=eshipment_number]").val().length != 9){
            alert("<cf_get_lang dictionary_id='61025.Ön Ek 3 Karakter olmalıdır'>");
            return false;
        }

        if( $('#eshipment_template').val() != '' ) {
            var obj = $('#eshipment_template');
            var file = obj[0].files[0];
            if(file.size == 0)
            {		
                alert("<cf_get_lang dictionary_id='30521.Dosya İçeriğini Kontrol Ediniz'>");
                return false;
            }			

            if ((obj.val() != "") && !(file.name.substring(file.name.indexOf('.')+1,file.name.length).toLowerCase() == 'xslt'))
            {
                alert("<cf_get_lang dictionary_id='30519.İlgili dosya xslt olmalıdır'>!");        
                return false;
            }
        }

        return true;
    }
</script>