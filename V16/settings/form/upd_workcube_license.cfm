<cfset workcube_license = createObject("V16.settings.cfc.workcube_license").get_license_information() />

<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
    <cf_box history_href="#request.self#?fuseaction=settings.workcube_license&event=list" title="Workcube Information" history_title="">
        <cfform name="workcube_license" action="" method="post">
            <cfinput type = "hidden" name="license_id" id="license_id" value="#workcube_license.LICENSE_ID#">
            <cf_box_elements>
                <div class="col col-9 col-xs-12" type="column" index ="0" sort = "true">                  
                    <div class="form-group" id="item-workcube_id">
                        <label class="col col-4 col-xs-12">Workcube ID*</label>
                        <div class="col col-8 col-xs-12">
                            <div class = "input-group">
                                <div class="input-group_tooltip"><cf_get_lang dictionary_id = "60976.Lisans numaranız. Abone ID ile aynı numaradır. Lisans veya LYKP belgenizde yazan numaradır."></div>
                                <cfinput type="text" name="workcube_id" id="workcube_id" required="true" value="#workcube_license.WORKCUBE_ID#">
                                <span class="input-group-addon btnPointer icon-question input-group-tooltip"></span>
                            </div>
                        </div>
                    </div>
                    <div class="form-group" id="item-license_type">
                        <label class="col col-4 col-xs-12">License Type*</label>
                        <div class="col col-8 col-xs-12">
                            <div class = "input-group">
                                <div class="input-group_tooltip"><cf_get_lang dictionary_id = "60988.Ticari Kullanım seçeneği işletmeler içindir. Partner seçeneği sadece yetkili partnerların kullanımı içindir. Debeloper seçeneği sertifikalı geliştiricilerin geliştirim yapma amacıyla kullanımı içindir. Amacı dışında kullanım lisans haklarını ihlaldir. Yasal haklar saklıdır."></div>
                                <select name = "license_type" id = "license_type" required>
                                    <option value = "">Choose</option>
                                    <option value = "1" <cfoutput>#( workcube_license.LICENSE_TYPE eq 1 ? 'selected' : '' )#</cfoutput>>Commercial</option>
                                    <option value = "2" <cfoutput>#( workcube_license.LICENSE_TYPE eq 2 ? 'selected' : '' )#</cfoutput>>Development</option>
                                    <option value = "3" <cfoutput>#( workcube_license.LICENSE_TYPE eq 3 ? 'selected' : '' )#</cfoutput>>Partner</option>
                                </select>
                                <span class="input-group-addon btnPointer icon-question input-group-tooltip"></span>
                            </div>
                        </div>
                    </div>
                    <div class="form-group" id="item-owner_company_title">
                        <label class="col col-4 col-xs-12">Owner Company Title*</label>
                        <div class="col col-8 col-xs-12">
                            <div class = "input-group">
                                <div class="input-group_tooltip"><cf_get_lang dictionary_id = "60987.Workcube kullanım hakkı elde eden işletmenin ünvanını yazınız."></div>
                                <cfinput type="text" name="owner_company_title" id="owner_company_title" required="true" value="#workcube_license.OWNER_COMPANY_TITLE#">
                                <span class="input-group-addon btnPointer icon-question input-group-tooltip"></span>
                            </div>
                        </div>
                    </div>
                    <div class="form-group" id="item-owner_company_id">
                        <label class="col col-4 col-xs-12">Owner Company ID*</label>
                        <div class="col col-8 col-xs-12">
                            <div class = "input-group">
                                <div class="input-group_tooltip"><cf_get_lang dictionary_id = "60977.Workcube tarafından size verilen numaradır. ID'nizi bilmiyorsanız Workcube'den alınız."></div>
                                <cfinput type="text" name="owner_company_id" id="owner_company_id" required="true" value="#workcube_license.OWNER_COMPANY_ID#">
                                <span class="input-group-addon btnPointer icon-question input-group-tooltip"></span>
                            </div>
                        </div>
                    </div>
                    <div class="form-group" id="item-owner_company_email">
                        <label class="col col-4 col-xs-12">Owner Company E-Mail*</label>
                        <div class="col col-8 col-xs-12">
                            <div class = "input-group">
                                <div class="input-group_tooltip"><cf_get_lang dictionary_id = "60989.Kullanım Lisansına sahip kuruluşun resmi mail adresini giriniz."></div>
                                <cfinput type="text" name="owner_company_email" id="owner_company_email" required="true" value="#workcube_license.OWNER_COMPANY_EMAIL#">
                                <span class="input-group-addon btnPointer icon-question input-group-tooltip"></span>
                            </div>
                        </div>
                    </div>
                    <div class="form-group" id="item-owner_company_phone">
                        <label class="col col-4 col-xs-12">Owner Company Phone*</label>
                        <div class="col col-8 col-xs-12">
                            <div class = "input-group">
                                <div class="input-group_tooltip"><cf_get_lang dictionary_id = "60990.Kullanım Lisansına sahip kuruluşun resmi telefon numarasını giriniz."></div>
                                <cfinput type="text" name="owner_company_phone" id="owner_company_phone" required="true" value="#workcube_license.OWNER_COMPANY_PHONE#">
                                <span class="input-group-addon btnPointer icon-question input-group-tooltip"></span>
                            </div>
                        </div>
                    </div>
                    <div class="form-group" id="item-implementetion_project_id">
                        <label class="col col-4 col-xs-12">Implementation Project ID*</label>
                        <div class="col col-8 col-xs-12">
                            <div class = "input-group">
                                <div class="input-group_tooltip"><cf_get_lang dictionary_id = "60978.Workcube tarafından size verilen project.workcube.com'da implementasyon aşamasında süreçlerinizi takip edebileceğiniz proje numarasıdır."></div>
                                <cfinput type="text" name="implementetion_project_id" id="implementetion_project_id" required="true" value="#workcube_license.IMPLEMENTATION_PROJECT_ID#">
                                <span class="input-group-addon btnPointer icon-question input-group-tooltip"></span>
                            </div>
                        </div>
                    </div>
                    <div class="form-group" id="item-implementetion_project_domain">
                        <label class="col col-4 col-xs-12">Implementation Project Domain</label>
                        <div class="col col-8 col-xs-12">
                            <div class = "input-group">
                                <div class="input-group_tooltip"><cf_get_lang dictionary_id = "61251.Workcube tarafından size verilen project.workcube.com'da implementasyon aşamasında süreçlerinizi takip edebileceğiniz proje alan adıdır."></div>
                                <cfinput type="text" name="implementetion_project_domain" id="implementetion_project_domain" value="#workcube_license.IMPLEMENTATION_PROJECT_DOMAIN#">
                                <span class="input-group-addon btnPointer icon-question input-group-tooltip"></span>
                            </div>
                        </div>
                    </div>
                    <div class="form-group" id="item-support_project_id">
                        <label class="col col-4 col-xs-12">Support Project ID*</label>
                        <div class="col col-8 col-xs-12">
                            <div class = "input-group">
                                <div class="input-group_tooltip"><cf_get_lang dictionary_id = "60979.Workcube tarafından size verilen project.workcube.com'da canlıya geçmiş uygulamanız ile ilgili destek süreçlerini takip edebileceğiniz proje numarasıdır."></div>
                                <cfinput type="text" name="support_project_id" id="support_project_id" required="true" value="#workcube_license.SUPPORT_PROJECT_ID#">
                                <span class="input-group-addon btnPointer icon-question input-group-tooltip"></span>
                            </div>
                        </div>
                    </div>
                    <div class="form-group" id="item-support_project_domain">
                        <label class="col col-4 col-xs-12">Support Project Domain</label>
                        <div class="col col-8 col-xs-12">
                            <div class = "input-group">
                                <div class="input-group_tooltip"><cf_get_lang dictionary_id = "61252.Workcube tarafından size verilen project.workcube.com'da canlıya geçmiş uygulamanız ile ilgili destek süreçlerini takip edebileceğiniz proje alan adıdır."></div>
                                <cfinput type="text" name="support_project_domain" id="support_project_domain" value="#workcube_license.SUPPORT_PROJECT_DOMAIN#">
                                <span class="input-group-addon btnPointer icon-question input-group-tooltip"></span>
                            </div>
                        </div>
                    </div>
                    <div class="form-group" id="item-technical_person_employee_title">
                        <label class="col col-4 col-xs-12">Technical Person Employee Titles*</label>
                        <div class="col col-8 col-xs-12">
                            <div class = "input-group">
                                <div class="input-group_tooltip"><cf_get_lang dictionary_id = "60992.İşletmenizde çalışan teknik personelin Workcube uygulamanızdaki Employee-Name'lerini yazınız."></div>
                                <cfinput type="text" name="technical_person_employee_title" id="technical_person_employee_title" required="true" value="#workcube_license.TECHNICAL_PERSON_EMPLOYEE_TITLE#">
                                <span class="input-group-addon btnPointer icon-question input-group-tooltip"></span>
                            </div>
                        </div>
                    </div>
                    <div class="form-group" id="item-technical_persons_id">
                        <label class="col col-4 col-xs-12">Technical Persons IDs*</label>
                        <div class="col col-8 col-xs-12">
                            <div class = "input-group">
                                <div class="input-group_tooltip"><cf_get_lang dictionary_id = "60980.Workcube'de register edilmiş olan teknik personelinizin numaraladır. ID'leri Workcube'den alınız.ID'leri virgül ile yazınız."></div>
                                <cfinput type="text" name="technical_persons_id" id="technical_persons_id" required="true" value="#workcube_license.TECHNICAL_PERSON_ID#">
                                <span class="input-group-addon btnPointer icon-question input-group-tooltip"></span>
                            </div>
                        </div>
                    </div>
                    <div class="form-group" id="item-technical_person_employee_id">
                        <label class="col col-4 col-xs-12">Technical Persons Employee IDs*</label>
                        <div class="col col-8 col-xs-12">
                            <div class = "input-group">
                                <div class="input-group_tooltip"><cf_get_lang dictionary_id = "60981.İşletmenizde çalışan teknik personelin Workcube uygulamanızdaki Employee-ID''lerini yazınız. Bu ID''ler Workcube''un sistem ayarlarına girme ve teknik bildirimler yapma izni verir.	"></div>
                                <cfinput type="text" name="technical_person_employee_id" id="technical_person_employee_id" required="true" value="#workcube_license.TECHNICAL_PERSON_EMPLOYEE_ID#">
                                <span class="input-group-addon btnPointer icon-question input-group-tooltip"></span>
                            </div>
                        </div>
                    </div>
                    <div class="form-group" id="item-implementation_power_user_employee_title">
                        <label class="col col-4 col-xs-12">Implementation Power User Employee Titles*</label>
                        <div class="col col-8 col-xs-12">
                            <div class = "input-group">
                                <div class="input-group_tooltip"><cf_get_lang dictionary_id = "60993.İşletmenizde çalışan anahtar kullanıcı veya proje ekibinizdeki yetkili kişilerin Workcube uygulamanızdaki Employee-Name'lerini yazınız."></div>
                                <cfinput type="text" name="implementation_power_user_employee_title" id="implementation_power_user_employee_title" required="true" value="#workcube_license.IMPLEMENTATION_POWER_USER_EMPLOYEE_TITLE#">
                                <span class="input-group-addon btnPointer icon-question input-group-tooltip"></span>
                            </div>
                        </div>
                    </div>
                    <div class="form-group" id="item-implementation_power_user_id">
                        <label class="col col-4 col-xs-12">Implementation Power User IDs*</label>
                        <div class="col col-8 col-xs-12">
                            <div class = "input-group">
                                <div class="input-group_tooltip"><cf_get_lang dictionary_id = "60982.Workcube'de register olan anahtar kullanıcı veya proje ekibinizdeki yetkili kişilerin Workcube ID'leridir. ID'leri Workcube'den alınız. ID'leri virgül ile yazınız."></div>
                                <cfinput type="text" name="implementation_power_user_id" id="implementation_power_user_id" required="true" value="#workcube_license.IMPLEMENTATION_POWER_USER_ID#">
                                <span class="input-group-addon btnPointer icon-question input-group-tooltip"></span>
                            </div>
                        </div>
                    </div>
                    <div class="form-group" id="item-implementation_power_user_employee_id">
                        <label class="col col-4 col-xs-12">Implementation Power User Employee IDs*</label>
                        <div class="col col-8 col-xs-12">
                            <div class = "input-group">
                                <div class="input-group_tooltip"><cf_get_lang dictionary_id = "60983.İşletmenizde çalışan anahtar kullanıcı veya proje ekibinizdeki yetkili kişilerin Workcube uygulamanızdaki  Employee-ID'lerini yazınız."></div>
                                <cfinput type="text" name="implementation_power_user_employee_id" id="implementation_power_user_employee_id" required="true" value="#workcube_license.IMPLEMENTATION_POWER_USER_EMPLOYEE_ID#">
                                <span class="input-group-addon btnPointer icon-question input-group-tooltip"></span>
                            </div>
                        </div>
                    </div>
                    <div class="form-group" id="item-workcube_partner_company_title">
                        <label class="col col-4 col-xs-12">Workcube Partner Company Title*</label>
                        <div class="col col-8 col-xs-12">
                            <div class = "input-group">
                                <div class="input-group_tooltip"><cf_get_lang dictionary_id = "60986.Workcube projenizi yöneten veya desteğinizi veren Workcube iş ortağı şirketin ünvanını - Muhatabanız olan yetkiliyi yazınız."></div>
                                <cfinput type="text" name="workcube_partner_company_title" id="workcube_partner_company_title" required="true" value="#workcube_license.WORKCUBE_PARTNER_COMPANY_TITLE#">
                                <span class="input-group-addon btnPointer icon-question input-group-tooltip"></span>
                            </div>
                        </div>
                    </div>
                    <div class="form-group" id="item-workcube_partner_company_id">
                        <label class="col col-4 col-xs-12">Workcube Partner Company ID*</label>
                        <div class="col col-8 col-xs-12">
                            <div class = "input-group">
                                <div class="input-group_tooltip"><cf_get_lang dictionary_id = "60984.Workcube projenizi yöneten veya desteğinizi veren Workcube iş ortağı şirketin Workcube'deki ID'sini yazın. ID'yi Workcube'den alınız."></div>
                                <cfinput type="text" name="workcube_partner_company_id" id="workcube_partner_company_id" required="true" value="#workcube_license.WORKCUBE_PARTNER_COMPANY_ID#">
                                <span class="input-group-addon btnPointer icon-question input-group-tooltip"></span>
                            </div>
                        </div>
                    </div>
                    <div class="form-group" id="item-workcube_partner_company_team">
                        <label class="col col-4 col-xs-12">Workcube Partner Company Team*</label>
                        <div class="col col-8 col-xs-12">
                            <div class = "input-group">
                                <div class="input-group_tooltip"><cf_get_lang dictionary_id = "60991.Workcube projenizi yöneten veya desteğinizi veren Workcube iş ortağı şirketin ekip çalışanlarının isimlerini yazın. İsimleri virgül ile yazınız."></div>
                                <cfinput type="text" name="workcube_partner_company_team" id="workcube_partner_company_team" required="true" value="#workcube_license.WORKCUBE_PARTNER_COMPANY_TEAM#">
                                <span class="input-group-addon btnPointer icon-question input-group-tooltip"></span>
                            </div>
                        </div>
                    </div>
                    <div class="form-group" id="item-workcube_partner_company_team_id">
                        <label class="col col-4 col-xs-12">Workcube Partner Company Team IDs*</label>
                        <div class="col col-8 col-xs-12">
                            <div class = "input-group">
                                <div class="input-group_tooltip"><cf_get_lang dictionary_id = "60985.Workcube projenizi yöneten veya desteğinizi veren Workcube iş ortağı şirketin ekip çalışanlarının Workcube'deki ID'lerini yazın. ID'yi Workcube'den alınız.ID'leri virgül ile yazınız."></div>
                                <cfinput type="text" name="workcube_partner_company_team_id" id="workcube_partner_company_team_id" required="true" value="#workcube_license.WORKCUBE_PARTNER_COMPANY_TEAM_ID#">
                                <span class="input-group-addon btnPointer icon-question input-group-tooltip"></span>
                            </div>
                        </div>
                    </div>
                    <div class="form-group" id="item-workcube_support_team_id">
                        <label class="col col-4 col-xs-12">Workcube Partner Team Emp IDs* </label>
                        <div class="col col-8 col-xs-12">
                            <div class = "input-group">
                                <div class="input-group_tooltip"><cf_get_lang dictionary_id = "61004.Destek aldığınız Workcube İş Ortağını Çalışan olarak kaydettiyseniz Employee ID'lerini virgülle yazınız"></div>
                                <cfinput type="text" name="workcube_support_team_id" id="workcube_support_team_id" required="true" value="#workcube_license.WORKCUBE_SUPPORT_TEAM_ID#">
                                <span class="input-group-addon btnPointer icon-question input-group-tooltip"></span>
                            </div>
                        </div>
                    </div>
                </div>
            </cf_box_elements>
            <cf_box_footer>
                <cf_record_info query_name="workcube_license">
                <cf_workcube_buttons type_format='1' is_delete="0" is_upd='1'>
            </cf_box_footer>
        </cfform>
    </cf_box>
</div>