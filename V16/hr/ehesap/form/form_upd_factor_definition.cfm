<cfset attributes.factor_id = attributes.id>
<cfinclude template="../query/get_factor_definition.cfm">
<cfsavecontent variable="images"><a href="<cfoutput>#request.self#</cfoutput>?fuseaction=ehesap.popup_form_add_factor_definition"><img src="/images/plus1.gif" title="<cf_get_lang dictionary_id='46447.Katsayı Ekle'>"></a></cfsavecontent>
<cfsavecontent variable="message"><cf_get_lang dictionary_id='63767.Memur Ücret Katsayısı Güncelle'></cfsavecontent>

<cfparam name="attributes.modal_id" default="">
<cf_box title="#message#" scroll="1" closable="1" collapsable="1" resize="1" popup_box="#iif(isdefined("attributes.draggable"),1,0)#">
    <cfform name="form_upd_factor" method="post" action="#request.self#?fuseaction=ehesap.emptypopup_upd_factor_definition" onsubmit="return UnformatFields();">
        <input type="hidden" name="id" id="id" value="<cfoutput>#attributes.factor_id#</cfoutput>">
        <input type="hidden" name="is_delete" id="is_delete" value="0">
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
                        <cfsavecontent variable="message"><cf_get_lang dictionary_id='57738.Başlangıç Tarihi girmelisiniz'></cfsavecontent>
                    <cfinput value="#dateformat(get_factor_definition.startdate,dateformat_style)#" type="text" name="startdate" validate="#validate_style#" required="yes" message="#message#">
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
                        <cfinput type="text" value="#dateformat(get_factor_definition.finishdate,dateformat_style)#" name="finishdate" validate="#validate_style#" required="yes" message="#message#">
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
                    <cfinput type="text" name="salary_factor" value="#TLFormat(get_factor_definition.salary_factor,7)#" required="yes"  message="Aylık Katsayı!" onkeyup="return(FormatCurrency(this,event,7));" class="moneybox">
                </div>
            </div>
            <div class="form-group col col-12 col-md-12 col-sm-12 col-xs-12">
                <div class="col col-4 col-md-4 col-sm-4 col-xs-12">
                    <label><cf_get_lang dictionary_id="59314.Taban Aylık Katsayı">*</label>
                </div>
                <div class="col col-8 col-md-8 col-sm-8 col-xs-12">
                    <cfsavecontent variable="message"><cf_get_lang dictionary_id="59314.Taban Aylık Katsayı"></cfsavecontent>
                    <cfinput type="text" name="base_salary_factor" value="#TLFormat(get_factor_definition.base_salary_factor,7)#" required="yes" message="Taban Ayılk Katsayı" onkeyup="return(FormatCurrency(this,event,7));" class="moneybox">
                </div>
            </div>
            <div class="form-group col col-12 col-md-12 col-sm-12 col-xs-12">
                <div class="col col-4 col-md-4 col-sm-4 col-xs-12">
                    <label><cf_get_lang dictionary_id="59315.Yan Ödeme Katsayı">*</label>
                </div>
                <div class="col col-8 col-md-8 col-sm-8 col-xs-12">
                    <cfsavecontent variable="message"><cf_get_lang dictionary_id="59315.Yan Ödeme Katsayısı"></cfsavecontent>
                    <cfinput type="text" name="benefit_factor" value="#tlformat(get_factor_definition.benefit_factor,7)#" required="yes"  message="#message#" onkeyup="return(FormatCurrency(this,event,7));" class="moneybox">
                </div>
            </div>
            <div class="form-group col col-12 col-md-12 col-sm-12 col-xs-12">
                <div class="col col-4 col-md-4 col-sm-4 col-xs-12">
                    <label><cf_get_lang dictionary_id='62934.Aile Yardımı Puanı'>*</label>
                </div>
                <div class="col col-8 col-md-8 col-sm-8 col-xs-12">
                    <cfsavecontent variable="message"><cf_get_lang dictionary_id='62934.Aile Yardımı Puanı'></cfsavecontent>
                    <cfinput type="text" name="family_allowance_point" id="family_allowance_point" value="#tlformat(get_factor_definition.family_allowance_point,7)#" required="yes"  message="#message#" onkeyup="return(FormatCurrency(this,event,7));" class="moneybox">
                </div>
            </div>
            <div class="form-group col col-12 col-md-12 col-sm-12 col-xs-12">
                <div class="col col-4 col-md-4 col-sm-4 col-xs-12">
                    <label>1. <cf_get_lang dictionary_id='62935.Çocuk Yardımı Puanı'>*</label>
                </div>
                <div class="col col-8 col-md-8 col-sm-8 col-xs-12">
                    <cfsavecontent variable="message">1. <cf_get_lang dictionary_id='62935.Çocuk Yardımı Puanı'></cfsavecontent>
                    <cfinput type="text" name="child_benefit_first" id="child_benefit_first" value="#tlformat(get_factor_definition.child_benefit_first,7)#" required="yes"  message="#message#" onkeyup="return(FormatCurrency(this,event,7));" class="moneybox">
                </div>
            </div>
            <div class="form-group col col-12 col-md-12 col-sm-12 col-xs-12">
                <div class="col col-4 col-md-4 col-sm-4 col-xs-12">
                    <label>2. <cf_get_lang dictionary_id='62935.Çocuk Yardımı Puanı'>*</label>
                </div>
                <div class="col col-8 col-md-8 col-sm-8 col-xs-12">
                    <cfsavecontent variable="message">2. <cf_get_lang dictionary_id='62935.Çocuk Yardımı Puanı'></cfsavecontent>
                    <cfinput type="text" name="child_benefit_second" id="child_benefit_second" value="#tlformat(get_factor_definition.child_benefit_second,7)#" required="yes"  message="#message#" onkeyup="return(FormatCurrency(this,event,7));" class="moneybox">
                </div>
            </div>
            <div class="form-group col col-12 col-md-12 col-sm-12 col-xs-12">
                <div class="col col-4 col-md-4 col-sm-4 col-xs-12">
                    <label><cf_get_lang dictionary_id='63763.En Yüksek Devlet Memuru Aylığı'>*</label>
                </div>
                <div class="col col-8 col-md-8 col-sm-8 col-xs-12">
                    <cfsavecontent variable="message"><cf_get_lang dictionary_id='63763.En Yüksek Devlet Memuru Aylığı'></cfsavecontent>
                    <cfinput type="text" name="highest_civil_servant_salary " id="highest_civil_servant_salary " value="#tlformat(get_factor_definition.highest_civil_servant_salary ,7)#" required="yes"  message="#message#" onkeyup="return(FormatCurrency(this,event,7));" class="moneybox">
                </div>
            </div>
            <div class="form-group col col-12 col-md-12 col-sm-12 col-xs-12">
                <div class="col col-4 col-md-4 col-sm-4 col-xs-12">
                    <label><cf_get_lang dictionary_id='64844.Hafta İçi Fazla Mesai Ücreti'>*</label>
                </div>
                <div class="col col-8 col-md-8 col-sm-8 col-xs-12">
                    <cfsavecontent variable="message"><cf_get_lang dictionary_id='64844.Hafta İçi Fazla Mesai Ücreti'></cfsavecontent>
                    <cfinput type="text" name="weekday_fee " id="weekday_fee " value="#tlformat(get_factor_definition.WEEKDAY_FEE ,7)#" required="yes"  message="#message#" onkeyup="return(FormatCurrency(this,event,7));" class="moneybox">
                </div>
            </div>
            <div class="form-group col col-12 col-md-12 col-sm-12 col-xs-12">
                <div class="col col-4 col-md-4 col-sm-4 col-xs-12">
                    <label><cf_get_lang dictionary_id='64845.Hafta Sonu Fazla Mesai Ücreti'>*</label>
                </div>
                <div class="col col-8 col-md-8 col-sm-8 col-xs-12">
                    <cfsavecontent variable="message"><cf_get_lang dictionary_id='64845.Hafta Sonu Fazla Mesai Ücreti'></cfsavecontent>
                    <cfinput type="text" name="weekday_rate " id="weekday_rate " value="#tlformat(get_factor_definition.weekday_rate ,7)#" required="yes"  message="#message#" onkeyup="return(FormatCurrency(this,event,7));" class="moneybox">
                </div>
            </div>
            <div class="form-group col col-12 col-md-12 col-sm-12 col-xs-12">
                <div class="col col-4 col-md-4 col-sm-4 col-xs-12">
                    <label><cf_get_lang dictionary_id='63761.Toplu Sözleşme İkramiyesi Tutarı'>*</label>
                </div>
                <div class="col col-8 col-md-8 col-sm-8 col-xs-12">
                    <cfsavecontent variable="message"><cf_get_lang dictionary_id='63761.Toplu Sözleşme İkramiyesi Tutarı'></cfsavecontent>
                    <cfinput type="text" name="collective_agreement_bonus_amount" id="collective_agreement_bonus_amount" value="#tlformat(get_factor_definition.collective_agreement_bonus_amount ,7)#" required="yes"  message="#message#" onkeyup="return(FormatCurrency(this,event,7));" class="moneybox">
                </div>
            </div>
            <div class="form-group col col-12 col-md-12 col-sm-12 col-xs-12">
                <div class="col col-4 col-md-4 col-sm-4 col-xs-12">
                    <label><cf_get_lang dictionary_id='63762.Toplu Sözleşme İkramiyesi Ayları'>*</label>
                </div>
                <div class="col col-8 col-md-8 col-sm-8 col-xs-12">
                    <cfsavecontent variable="message"><cf_get_lang dictionary_id='63762.Toplu Sözleşme İkramiyesi Ayları'></cfsavecontent>
                    <cfset get_month = myQuery=QueryNew("ID,Name","integer,varchar")>
                    <cfset myFirstData=StructNew()>
                    <cfloop from="1" to="12" index="i">
                        <cfset myFirstData={ID=i,Name="#listgetat(ay_list(),i,',')#"}>
                         <cfset QueryAddRow(get_month,myFirstData)>
                    </cfloop>
                    <cf_multiselect_check
                        query_name="get_month"
                        name="collective_agreement_bonus_month"
                        option_value="ID"
                        option_name="NAME"
                        option_text="#getLang('main',322)#"
                        value="#get_factor_definition.collective_agreement_bonus_month#">
                </div>
            </div>
        </cf_box_elements>
        <cf_box_footer>
            <cf_record_info query_name="get_factor_definition">
            <cfsavecontent variable="message"><cf_get_lang dictionary_id="59598.Kayıtlı Katsayı tanımını siliyorsunuz.Emin misiniz?"></cfsavecontent>
            <cf_workcube_buttons is_upd='1' del_function='del()' delete_alert='#message#' add_function="kontrol()"> 
        </cf_box_footer>
        <div id="show_user_message_cont"></div>
    </cfform>
</cf_box>
<script type="text/javascript">
    function del(){
		document.form_upd_factor.is_delete.value=1;
		AjaxFormSubmit('form_upd_factor','show_user_message_cont',1,'Siliniyor!','Silindi!');
		<cfif isdefined("attributes.draggable")>
		    loadPopupBox('form_upd_factor' , '<cfoutput>#attributes.modal_id#</cfoutput>');
		</cfif>
    }

	function kontrol(){
        if($("#child_benefit_second").val() == '')
        {
            alert("2. <cf_get_lang dictionary_id='62935.Çocuk Yardımı Puanı'>");
            return false;
        }
        if($("#child_benefit_first").val() == '')
        {
            alert("2. <cf_get_lang dictionary_id='62935.Çocuk Yardımı Puanı'>");
            return false;
        }
        if($("#family_allowance_point").val() == '')
        {
            alert("<cf_get_lang dictionary_id='62934.Aile Yardımı Puanı'>");
            return false;
        }
        UnformatFields();
        /* return true; */
        <cfif isdefined("attributes.draggable")>
            loadPopupBox('form_upd_factor' , '<cfoutput>#attributes.modal_id#</cfoutput>');
            return false;
        </cfif>
        
    }
	function UnformatFields()
	{
		form_upd_factor.salary_factor.value = filterNum(form_upd_factor.salary_factor.value,7);
		form_upd_factor.base_salary_factor.value = filterNum(form_upd_factor.base_salary_factor.value,7);
		form_upd_factor.benefit_factor.value = filterNum(form_upd_factor.benefit_factor.value,7);
        form_upd_factor.family_allowance_point.value = filterNum(form_upd_factor.family_allowance_point.value,7);
		form_upd_factor.child_benefit_first.value = filterNum(form_upd_factor.child_benefit_first.value,7);
		form_upd_factor.child_benefit_second.value = filterNum(form_upd_factor.child_benefit_second.value,7);
        form_upd_factor.collective_agreement_bonus_amount.value = filterNum(form_upd_factor.collective_agreement_bonus_amount.value,7);
        form_upd_factor.highest_civil_servant_salary.value = filterNum(form_upd_factor.highest_civil_servant_salary.value,7);
        form_upd_factor.weekday_fee.value = filterNum(form_upd_factor.weekday_fee.value,7);
        form_upd_factor.weekday_rate.value = filterNum(form_upd_factor.weekday_rate.value,7);
	}
</script>
