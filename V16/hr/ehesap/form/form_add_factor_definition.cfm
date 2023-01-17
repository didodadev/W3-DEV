<cfset xfa.add = "ehesap.emptypopup_add_factor_definition">
<cfsavecontent variable="message"><cf_get_lang dictionary_id='63766.Memur Ücret Katsayısı Ekle'></cfsavecontent>
<cfparam name="attributes.modal_id" default="">
<cf_box title="#message#" scroll="1" closable="1" collapsable="1" resize="1" popup_box="#iif(isdefined("attributes.draggable"),1,0)#">
    <cfform name="form_add_factor" method="post" action="#request.self#?fuseaction=#xfa.add#">
        <cfif isdefined("attributes.draggable")>
            <cfinput type="hidden" name="draggable" style="width:150px;"  value="1" required="yes" message="#message#" onkeyup="return(FormatCurrency(this,event,7));" class="moneybox">
        </cfif>
        <cf_box_elements>
            <div class="form-group col col-12 col-md-12 col-sm-12 col-xs-12">
                <div class="col col-4 col-md-4 col-sm-4 col-xs-12">
                    <label><cf_get_lang dictionary_id='57655.Başlama Tarihi'>*</label>
                </div>
                <div class="col col-8 col-md-8 col-sm-8 col-xs-12">
                    <div class="input-group">
                        <cfsavecontent variable="message"><cf_get_lang dictionary_id='57738.Başlama Tarihi girmelisiniz'></cfsavecontent>
                        <cfinput type="text" name="startdate" style="width:150px;" validate="#validate_style#" required="yes" message="#message#">
                        <span class="input-group-addon"><cf_wrk_date_image date_field="startdate"></span>
                    </div>
                </div>
            </div>
            <div class="form-group col col-12 col-md-12 col-sm-12 col-xs-12">
                <div class="col col-4 col-md-4 col-sm-4 col-xs-12">
                    <label><cf_get_lang dictionary_id='57700.Bitiş Tarihi'>*</label>
                </div>
                <div class="col col-8 col-md-8 col-sm-8 col-xs-12">
                    <div class="input-group">
                        <cfsavecontent variable="message"><cf_get_lang dictionary_id='57739.Bitiş Tarihi girmelisiniz'></cfsavecontent>
                        <cfinput type="text" name="finishdate" style="width:150px;" validate="#validate_style#" required="yes" message="#message#">
                        <span class="input-group-addon"><cf_wrk_date_image date_field="finishdate"></span>
                    </div>
                </div>
            </div>
            <div class="form-group col col-12 col-md-12 col-sm-12 col-xs-12">
                <div class="col col-4 col-md-4 col-sm-4 col-xs-12">
                    <label><cf_get_lang dictionary_id="59313.Aylık Katsayı">*</label>
                </div>
                <div class="col col-8 col-md-8 col-sm-8 col-xs-12">
                    <cfsavecontent variable="message"><cf_get_lang dictionary_id="59313.Aylık Katsayı"></cfsavecontent>
                    <cfinput type="text" name="salary_factor" style="width:150px;"  value="" required="yes" message="#message#" onkeyup="return(FormatCurrency(this,event,7));" class="moneybox">
                </div>
            </div>
            <div class="form-group col col-12 col-md-12 col-sm-12 col-xs-12">
                <div class="col col-4 col-md-4 col-sm-4 col-xs-12">
                    <label><cf_get_lang dictionary_id="59314.Taban Aylık Katsayı">*</label>
                </div>
                <div class="col col-8 col-md-8 col-sm-8 col-xs-12">
                    <cfsavecontent variable="message"><cf_get_lang dictionary_id="59314.Taban Aylık Katsayı"></cfsavecontent>
                    <cfinput type="text" name="base_salary_factor" style="width:150px;" required="yes" value="" message="#message#" onkeyup="return(FormatCurrency(this,event,7));" class="moneybox">
                </div>
            </div>
            <div class="form-group col col-12 col-md-12 col-sm-12 col-xs-12">
                <div class="col col-4 col-md-4 col-sm-4 col-xs-12">
                    <label><cf_get_lang dictionary_id="59315.Yan Ödeme Katsayı">*</label>
                </div>
                <div class="col col-8 col-md-8 col-sm-8 col-xs-12">
                    <cfsavecontent variable="message"><cf_get_lang dictionary_id="59315.Yan Ödeme Katsayı"></cfsavecontent>
                    <cfinput type="text" name="benefit_factor" value="" required="yes" message="#message#" style="width:150px;" onkeyup="return(FormatCurrency(this,event,7));" class="moneybox">
                </div>
            </div>
            <div class="form-group col col-12 col-md-12 col-sm-12 col-xs-12">
                <div class="col col-4 col-md-4 col-sm-4 col-xs-12">
                    <label><cf_get_lang dictionary_id='62934.Aile Yardımı Puanı'>*</label>
                </div>
                <div class="col col-8 col-md-8 col-sm-8 col-xs-12">
                    <cfsavecontent variable="message"><cf_get_lang dictionary_id='62934.Aile Yardımı Puanı'></cfsavecontent>
                    <cfinput type="text" name="family_allowance_point" value="" required="yes"  message="#message#" style="width:150px;" onkeyup="return(FormatCurrency(this,event,7));"  class="moneybox">
                </div>
            </div>
            <div class="form-group col col-12 col-md-12 col-sm-12 col-xs-12">
                <div class="col col-4 col-md-4 col-sm-4 col-xs-12">
                    <label>1. <cf_get_lang dictionary_id='62935.Çocuk Yardımı Puanı'>*</label>
                </div>
                <div class="col col-8 col-md-8 col-sm-8 col-xs-12">
                    <cfsavecontent variable="message">1. <cf_get_lang dictionary_id='62935.Çocuk Yardımı Puanı'></cfsavecontent>
                    <cfinput type="text" name="child_benefit_first" value="" required="yes"  message="#message#" style="width:150px;" onkeyup="return(FormatCurrency(this,event,7));" class="moneybox">
                </div>
            </div>
            <div class="form-group col col-12 col-md-12 col-sm-12 col-xs-12">
                <div class="col col-4 col-md-4 col-sm-4 col-xs-12">
                    <label>2. <cf_get_lang dictionary_id='62935.Çocuk Yardımı Puanı'>*</label>
                </div>
                <div class="col col-8 col-md-8 col-sm-8 col-xs-12">
                    <cfsavecontent variable="message">2. <cf_get_lang dictionary_id='62935.Çocuk Yardımı Puanı'></cfsavecontent>
                    <cfinput type="text" name="child_benefit_second" value="" required="yes"  message="#message#" style="width:150px;" onkeyup="return(FormatCurrency(this,event,7));" class="moneybox">
                </div>
            </div>
            <div class="form-group col col-12 col-md-12 col-sm-12 col-xs-12">
                <div class="col col-4 col-md-4 col-sm-4 col-xs-12">
                    <label><cf_get_lang dictionary_id='63763.En Yüksek Devlet Memuru Aylığı'>*</label>
                </div>
                <div class="col col-8 col-md-8 col-sm-8 col-xs-12">
                    <cfsavecontent variable="message"><cf_get_lang dictionary_id='63761.Toplu Sözleşme İkramiyesi Tutarı'></cfsavecontent>
                    <cfinput type="text" name="highest_civil_servant_salary " id="highest_civil_servant_salary " value="" required="yes"  message="#message#" onkeyup="return(FormatCurrency(this,event,7));" class="moneybox">
                </div>
            </div>
            <div class="form-group col col-12 col-md-12 col-sm-12 col-xs-12">
                <div class="col col-4 col-md-4 col-sm-4 col-xs-12">
                    <label><cf_get_lang dictionary_id='64844.Hafta İçi Fazla Mesai Ücreti'>*</label>
                </div>
                <div class="col col-8 col-md-8 col-sm-8 col-xs-12">
                    <cfsavecontent variable="message"><cf_get_lang dictionary_id='64844.Hafta İçi Fazla Mesai Ücreti'></cfsavecontent>
                    <cfinput type="text" name="weekday_fee " id="weekday_fee " value="" required="yes"  message="#message#" onkeyup="return(FormatCurrency(this,event,7));" class="moneybox">
                </div>
            </div>
            <div class="form-group col col-12 col-md-12 col-sm-12 col-xs-12">
                <div class="col col-4 col-md-4 col-sm-4 col-xs-12">
                    <label><cf_get_lang dictionary_id='64845.Hafta Sonu Fazla Mesai Ücreti'>*</label>
                </div>
                <div class="col col-8 col-md-8 col-sm-8 col-xs-12">
                    <cfsavecontent variable="message"><cf_get_lang dictionary_id='64845.Hafta Sonu Fazla Mesai Ücreti'></cfsavecontent>
                    <cfinput type="text" name="weekday_rate " id="weekday_rate " value="" required="yes"  message="#message#" onkeyup="return(FormatCurrency(this,event,7));" class="moneybox">
                </div>
            </div>
            <div class="form-group col col-12 col-md-12 col-sm-12 col-xs-12">
                <div class="col col-4 col-md-4 col-sm-4 col-xs-12">
                    <label><cf_get_lang dictionary_id='63761.Toplu Sözleşme İkramiyesi Tutarı'>*</label>
                </div>
                <div class="col col-8 col-md-8 col-sm-8 col-xs-12">
                    <cfsavecontent variable="message"><cf_get_lang dictionary_id='63761.Toplu Sözleşme İkramiyesi Tutarı'></cfsavecontent>
                    <cfinput type="text" name="collective_agreement_bonus_amount" id="collective_agreement_bonus_amount" value="" required="yes"  message="#message#" onkeyup="return(FormatCurrency(this,event,7));" class="moneybox">
                </div>
            </div>
            <div class="form-group col col-12 col-md-12 col-sm-12 col-xs-12">
                <div class="col col-4 col-md-4 col-sm-4 col-xs-12">
                    <label><cf_get_lang dictionary_id='63762.Toplu Sözleşme İkramiyesi Ayları'>*</label>
                </div>
                <div class="col col-8 col-md-8 col-sm-8 col-xs-12">
                    <cfsavecontent variable="message"><cf_get_lang dictionary_id='63761.Toplu Sözleşme İkramiyesi Tutarı'></cfsavecontent>
                    <cfset get_month = myQuery=QueryNew("ID,Name","integer,varchar")>
                    <cfset get_month_list=StructNew()>
                    <cfloop from="1" to="12" index="i">
                        <cfset get_month_list={ID=i,Name="#listgetat(ay_list(),i,',')#"}>
                         <cfset QueryAddRow(get_month,get_month_list)>
                    </cfloop>
                    <cf_multiselect_check
                        query_name="get_month"
                        name="collective_agreement_bonus_month"
                        option_value="ID"
                        option_name="NAME"
                        option_text="#getLang('main',322)#"
                        value="">
                </div>
            </div>
        </cf_box_elements>
        <cf_box_footer>
            <cf_workcube_buttons is_upd='0' add_function="kontrol()">
        </cf_box_footer>
    </cfform>
</cf_box>
<script type="text/javascript">
    function kontrol(){
        UnformatFields();
        <cfif isdefined("attributes.draggable")>
            loadPopupBox('form_add_factor' , '<cfoutput>#attributes.modal_id#</cfoutput>');
            return false;
        </cfif>
    }
    function UnformatFields()
    {
        form_add_factor.salary_factor.value = filterNum(form_add_factor.salary_factor.value,7);
        form_add_factor.base_salary_factor.value = filterNum(form_add_factor.base_salary_factor.value,7);
        form_add_factor.benefit_factor.value = filterNum(form_add_factor.benefit_factor.value,7);
        form_add_factor.family_allowance_point.value = filterNum(form_add_factor.family_allowance_point.value,7);
		form_add_factor.child_benefit_first.value = filterNum(form_add_factor.child_benefit_first.value,7);
		form_add_factor.child_benefit_second.value = filterNum(form_add_factor.child_benefit_second.value,7);
        form_add_factor.collective_agreement_bonus_amount.value = filterNum(form_add_factor.collective_agreement_bonus_amount.value,7);
        form_add_factor.highest_civil_servant_salary.value = filterNum(form_add_factor.highest_civil_servant_salary.value,7);
        form_add_factor.weekday_fee.value = filterNum(form_add_factor.weekday_fee.value,7);
        form_add_factor.weekday_rate.value = filterNum(form_add_factor.weekday_rate.value,7);
    }
</script>
