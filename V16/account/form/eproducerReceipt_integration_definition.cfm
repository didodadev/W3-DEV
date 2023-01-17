

<cfset save_folder = "#upload_folder#e_government#dir_seperator#xslt" />
<!--- Dizin kontrolü --->
<cfif Not DirectoryExists("#save_folder#")>
    <cfdirectory action="create" directory="#save_folder#" />
</cfif>
<cfif session.ep.admin eq 1>
    <cfset eproducer = createObject("component","V16.e_government.cfc.emustahsil.common")>
    <cfset eproducer.dsn = dsn>
    <cfset get_our_company = eproducer.get_our_company_fnc(session.ep.company_id)>
    <div class="col col-12 col-xs-12">  
    <cf_box title="#getLang('','E-Müstahsil Makbuzu Entegrasyon Tanımları',62043)#" closable="0">
        <cfform name="eproducer_integration_definition"  enctype="multipart/form-data" method="post">
            <input type="hidden" name="save_folder" id="save_folder" value="<cfoutput>#save_folder#</cfoutput>" />
            <cf_box_elements>
                <div class="col col-6 col-md-6 col-sm-6 col-xs-12" type="column" index="1" sort="true">
                    <div class="form-group">
                        <label class="col col-4"><cf_get_lang dictionary_id='57493.Aktif'></label> 
                        <label class="col col-6"><input type="checkbox" id="is_active" name="is_active" <cfif get_our_company.IS_EPRODUCER_RECEIPT eq 1>checked</cfif>/></label> 
                    </div> 
                    <div class="form-group">
                        <label class="col col-4"><cf_get_lang dictionary_id='62366.E-Müstahsil Makbuzu Geçiş Tarihi'> *</label> 
                        <div class="col col-4">
                            <div class="input-group">
                                <cfinput type="text" name="eproducer_date" value="#iif( len(get_our_company.EPRODUCER_RECEIPT_DATE),'dateformat(get_our_company.EPRODUCER_RECEIPT_DATE,dateformat_style)',DE(dateformat(now(),dateformat_style)))#" validate="#validate_style#" maxlength="10">
                                <span class="input-group-addon btnPointer"><cf_wrk_date_image date_field="eproducer_date"></span>
                            </div>
                        </div>
                    </div>
                    <div class="form-group" id="item-live_url">
                        <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='62363.Live URL'> *</label>
                        <div class="col col-4 col-xs-12">
                            <input type="text" name="eproducer_live_url" id="eproducer_live_url" value="<cfoutput>#get_our_company.EPRODUCER_LIVE_URL#</cfoutput>">
                        </div>
                    </div>
                    <div class="form-group" id="item-test_url">
                        <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='58826.Test'> <cf_get_lang dictionary_id='29761.URL'> *</label>
                        <div class="col col-4 col-xs-12">
                            <input type="text" name="eproducer_test_url" id="eproducer_test_url" value="<cfoutput>#get_our_company.EPRODUCER_TEST_URL#</cfoutput>">
                        </div>
                    </div>
                    <div class="form-group">
                        <label class="col col-4"><cf_get_lang dictionary_id='58826.Test'></label> 
                        <label class="col col-6"><input type="checkbox" id="eproducer_test_system" name="eproducer_test_system" <cfif get_our_company.eproducer_test_system eq 1>checked</cfif>/></label> 
                    </div> 
                    <div class="form-group">
                        <label class="col col-4"><cf_get_lang dictionary_id='47568.Şirket KOdu'>*</label> 
                        <label class="col col-4"><input type="text" id="eproducer_company_code" name="eproducer_company_code" value="<cfoutput>#get_our_company.eproducer_company_code#</cfoutput>"/></label> 
                    </div> 
                    <div class="form-group">
                        <label class="col col-4"><cf_get_lang dictionary_id='57551.Kullanıcı Adı'>*</label> 
                        <label class="col col-4"><input type="text" id="eproducer_user_name" name="eproducer_user_name" value="<cfoutput>#get_our_company.eproducer_user_name#</cfoutput>"/></label> 
                    </div> 
                    <div class="form-group">
                        <label class="col col-4"><cf_get_lang dictionary_id='57552.Şifre'>*</label> 
                        <label class="col col-4"><input type="password" id="eproducer_password" name="eproducer_password" value="<cfoutput>#get_our_company.eproducer_password#</cfoutput>"/></label> 
                    </div> 
                    <div class="form-group">
                        <label class="col col-4"><cf_get_lang dictionary_id='57241.Şablon'></label> 
                        <div class="col col-4">
                            <input type="file" id="eproducer_template" name="eproducer_template" accept=".xslt" width="185" />
                        </div>
                        <cfif len(get_our_company.template_filename)>
                            <span class="input-group-addon no-bg"></span>
                            <input type="checkbox" id="del_template" name="del_template" onchange="del_template_control();"/> <label for="del_template">Şablonu Sil</label>
                        </cfif>
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
            $("#eproducer_template").prop('disabled', true);
        }else{
            $("#eproducer_template").prop('disabled', false);
        }
    }

    function kontrol(){

        if( $("#eproducer_company_code").val() == '' || $("#eproducer_user_name").val() == '' || $("#eproducer_password").val() == '' ) {
            alert("<cf_get_lang dictionary_id='62365.Şirket Kodu, Kullanıcı Adı ya da Şifre alanlarını boş bırakmayın'>");
            return false;
        }

        if( $("#eproducer_live_url").val() == '' || $("#eproducer_test_url").val() == '' ){
            alert("URL <cf_get_lang dictionary_id='43296.Alanını boş bırakmayın'>");
            return false;
        }

        if( $('#eproducer_template').val() != '' ) {
            var obj = $('#eproducer_template');
            var file = obj[0].files[0];
            if(file.size == 0){		
                alert("<cf_get_lang dictionary_id='30521.Dosya İçeriğini Kontrol Ediniz'>");
                return false;
            }			

            if ((obj.val() != "") && !(file.name.substring(file.name.indexOf('.')+1,file.name.length).toLowerCase() == 'xslt')){
                alert("<cf_get_lang dictionary_id='30519.İlgili dosya xslt olmalıdır'>!");        
                return false;
            }
        }

        return true;
    }
</script>