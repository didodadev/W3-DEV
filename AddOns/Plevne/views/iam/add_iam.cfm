<cf_catalystHeader>
<cf_box title="#getLang('','IAM','63639')#">
    <cfform name="add_iam">
        <cf_box_elements>
            <div class="col col-5 col-md-5 col-sm-5 col-xs-12" type="column" index="1" sort="true">
                <cf_duxi name="iam_active" type="checkbox"  value="1" label="57493" hint="aktif">
                <cf_duxi name="subscription_no"  required="yes" type="text" id="subscription_no" label="29502" hint="Abone No" >
                    <cf_wrk_subscriptions fieldId='subscription_id' fieldName='subscription_no' form_name='add_iam' subscription_no="#iif(isDefined("attributes.subscription_no"),'attributes.subscription_no',de(''))#" subscription_id="#iif(isDefined("attributes.subscription_id"),'attributes.subscription_id',de(''))#">
                </cf_duxi>
                <cf_duxi name="comp_id" id="comp_id" type="hidden" value="#iif(isDefined("attributes.company_id"),'attributes.company_id',de(''))#">
                <cf_duxi name="comp_member"  required="yes" type="text" label="49909"  hint="Kurumsal Üye" data="" threepoint="#request.self#?fuseaction=objects.popup_list_all_pars&field_comp_id=add_iam.comp_id&field_comp_name=add_iam.comp_member&select_list=6,7" value="#iif(isDefined("attributes.company_fullname"),'attributes.company_fullname',de(''))#">
                <cf_duxi name="domain"  required="yes" type="text" label="57892" hint="domain" value="#iif(isDefined("attributes.domain"),'attributes.domain',de(''))#">
                <cf_duxi name="member_name"  required="yes" type="text" label="57631" hint="Ad" value="">
                <cf_duxi name="member_sname"  required="yes" type="text" label="58726" hint="Soyad" value="">
                <cf_duxi name="username"  required="yes" type="text" label="57551" hint="Kullanıcı Adı" >
                <div class="form-group" id="item-consumer_password">
                    <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57552.Şifre'>*</label>
                    <div class="col col-8 col-xs-12">
                        <div class="input-group">
                            <cfinput type="text" class="input-type-password" required="yes" name="password" id="consumer_password" value="" maxlength="10" oncopy="return false" onpaste="return false">
                            <span class="input-group-addon showPassword" onclick="showPasswordClass('consumer_password')"><i class="fa fa-eye"></i></span>
                        </div>
                    </div>
                </div>
                <cf_duxi name="pr_mail"  required="yes" type="text" label="63640" hint="Birincil E-mail" value="">
                <cf_duxi name="sec_mail" type="text" label="63641" hint="İkincil E-mail" value="">
                <div class="form-group" id="item-mobile">
                    <label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='31920.Kod / Mobil Tel'>*</label>
                    <div class="col col-8 col-md-8 col-sm-8 col-xs-12">
                        <div class="col col-4 col-md-6 col-sm-6 col-xs-12">
                            <input type="text" name="mobile_code" id="mobile_code" required="yes" value="" maxlength="7">
                        </div>
                        <div class="col col-8 col-md-6 col-sm-6 col-xs-12">
                            <input type="text" name="mobile_no" id="mobile_no" required="yes" value="" maxlength="10">
                        </div>
                    </div>
                </div>
                <cf_duxi name="user_comp_name"  required="yes" type="text" label="63642" hint="Kullanıcı İşletme" value="#iif(isDefined("attributes.company_nickname"),'attributes.company_nickname',de(''))#">
            </div>
        </cf_box_elements>
        <cf_box_footer>
            <cf_box_footer>
                <cf_workcube_buttons
                is_upd='0' 
                add_function="kontrol()"
                data_action ="AddOns/Plevne/domains/iam:ADD_IAM"
                next_page="#request.self#?fuseaction=plevne.iam&event=upd&iam_id=">
            </cf_box_footer>
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
    }
</script>