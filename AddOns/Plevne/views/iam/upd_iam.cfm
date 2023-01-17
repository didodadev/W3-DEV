<cf_catalystHeader>
<cf_box title="#getLang('','IAM','63639')#">
    <cfform method="post" name="upd_iam">
        <cf_box_elements>
            <div class="col col-5 col-md-5 col-sm-5 col-xs-12" type="column" index="1" sort="true">
                <cf_duxi name="iam_id" type="hidden" data="data_iam.IAM_ID">
                <cf_duxi name="iam_active" id="iam_active" data="data_iam.IAM_ACTIVE" type="checkbox"  value="1" label="57493" hint="aktif">
                <div class="form-group" id="item-subs">
                    <label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id="29502.Abone No">*</label>
                    <div class="col col-8 col-md-8 col-sm-8 col-xs-12">
                        <div class="input-group">
                            <cfinput type="hidden" name="subscription_id" id="subscription_id" value="#data_iam.SUBSCRIPTION_ID#">
                            <cfset subscription_id_ = data_iam.SUBSCRIPTION_ID>
                            <cfinput type="text" name="subscription_no" required="yes" id="subscription_no" value="#data_iam.SUBSCRIPTION_NO#">
                            <span class="input-group-addon btnPointer icon-ellipsis" onclick="openBoxDraggable('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_subscription&&field_id=upd_iam.subscription_id&field_no=upd_iam.subscription_no')"></span>
                            <span class="input-group-addon btnPointer icon-link" onclick="window.open('<cfoutput>#request.self#?fuseaction=sales.list_subscription_contract&event=upd&subscription_id=#subscription_id_#</cfoutput>')"></span>
                        </div>
                    </div>
                </div>
                <div class="form-group" id="item-comp">
                    <label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id="49909.Kurumsal Üye">*</label>
                    <div class="col col-8 col-md-8 col-sm-8 col-xs-12">
                        <div class="input-group">
                            <cfinput type="hidden" name="comp_id" id="comp_id" value="#data_iam.COMPANY_ID#">
                            <cfinput type="text" name="comp_member" id="comp_member" value="#data_iam.FULLNAME#">
                            <span class="input-group-addon btnPointer icon-ellipsis" onclick="openBoxDraggable('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_all_pars&field_comp_id=upd_iam.comp_id&field_comp_name=upd_iam.comp_member&select_list=6,7')"></span>
                            <span class="input-group-addon btnPointer icon-link" onclick="window.open('<cfoutput>#request.self#?fuseaction=member.form_list_company&event=det&cpid=#data_iam.COMPANY_ID#</cfoutput>')"></span>
                        </div>
                    </div>
                </div>
                <div class="form-group" id="item-domain">
                    <label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id="57892.domain">*</label>
                    <div class="col col-8 col-md-8 col-sm-8 col-xs-12">
                        <div class="input-group">
                            <cfinput type="text" name="domain" id="domain" value="#data_iam.REFERRAL_DOMAIN#">
                            <span class="input-group-addon btnPointer icon-link" onclick="window.open('<cfoutput>https://#data_iam.REFERRAL_DOMAIN#</cfoutput>')"></span>
                        </div>
                    </div>
                </div>
                <cf_duxi name="member_name"  required="yes" type="text" label="57631" hint="Ad" data="data_iam.IAM_NAME">
                <cf_duxi name="member_sname"  required="yes" type="text" label="58726" hint="Soyad" data="data_iam.IAM_SURNAME">
                <cf_duxi name="username"  required="yes" type="text" label="57551" hint="Kullanıcı Adı" data="data_iam.IAM_USER_NAME">
                <div class="form-group" id="item-consumer_password">
                    <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57552.Şifre'>*</label>
                    <div class="col col-8 col-xs-12">
                        <div class="input-group">
                            <cfinput type="text" class="input-type-password" name="password" id="consumer_password" value="#data_iam.IAM_PASSWORD#" maxlength="10" oncopy="return false" onpaste="return false">
                            <span class="input-group-addon showPassword" onclick="showPasswordClass('consumer_password')"><i class="fa fa-eye"></i></span>
                        </div>
                    </div>
                </div>
                <cf_duxi name="pr_mail"  required="yes" type="text" label="63640" hint="Birincil E-mail" data="data_iam.IAM_EMAIL_FIRST">
                <cf_duxi name="sec_mail" type="text" label="63641" hint="İkincil E-mail" data="data_iam.IAM_EMAİL_SECOND">
                <div class="form-group" id="item-mobile">
                    <label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='31920.Kod / Mobil Tel'></label>
                    <div class="col col-8 col-md-8 col-sm-8 col-xs-12">
                        <div class="col col-4 col-md-6 col-sm-6 col-xs-12">
                            <cfinput type="text" name="mobile_code" id="mobile_code" required="yes" value="#data_iam.IAM_MOBILE_CODE#" maxlength="7">
                        </div>
                        <div class="col col-8 col-md-6 col-sm-6 col-xs-12">
                            <cfinput type="text" name="mobile_no" id="mobile_no" required="yes" value="#data_iam.IAM_MOBILE_NUMBER#" maxlength="10">
                        </div>
                    </div>
                </div>
                <cf_duxi name="user_comp_name"  required="yes" type="text" label="63642" hint="Kullanıcı İşletme" data="data_iam.IAM_USER_COMPANY_NAME">
            </div>
        </cf_box_elements>
        <cf_box_footer>
            <cf_record_info query_name="data_iam">
            <cf_workcube_buttons
            is_upd='1'
            is_delete="0"
            add_function="kontrol()"
            data_action ="AddOns/Plevne/domains/iam:UPD_IAM"
            next_page="#request.self#?fuseaction=plevne.iam&event=upd&iam_id=">
        </cf_box_footer>
    </cfform>
</cf_box>
<script>
    function kontrol() {
        if($('#consumer_password').val() == "")
        {
            alert("<cf_get_lang dictionary_id='49039.Şifre Giriniz'>");
            return false;
        }
        if($('#mobile_no').val() == "" || $('#mobile_code').val() == "")
        {
            alert("<cf_get_lang dictionary_id='49218.Kod/Mobil Girmelisiniz'>");
            return false;
        }
        if($('#subscription_no').val() == "")
        {
            alert("<cf_get_lang dictionary_id='57471.Eksik Veri'>: <cf_get_lang dictionary_id='29502.Abone No'>");
            return false;
        }
        if($('#domain').val() == "")
        {
            alert("<cf_get_lang dictionary_id='57471.Eksik Veri'>: <cf_get_lang dictionary_id="57892.domain">");
            return false;
        }
        if($('#comp_member').val() == "")
        {
            alert("<cf_get_lang dictionary_id='57471.Eksik Veri'>: <cf_get_lang dictionary_id="49909.Kurumsal Üye">");
            return false;
        }
        
    }
</script>