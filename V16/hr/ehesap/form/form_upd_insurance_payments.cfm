<cfinclude template="../query/get_insurance_payment.cfm">
<cfparam name="attributes.modal_id" default="">
<cfsavecontent variable="images"><a href="<cfoutput>#request.self#</cfoutput>?fuseaction=ehesap.popup_form_add_insurance_payments" title="<cf_get_lang dictionary_id='53055.Sigorta Primine Esas Ücret Ekle'>"><i class="fa fa-plus"></i></a></cfsavecontent>
<cfsavecontent variable="message"><cf_get_lang dictionary_id="53059.Sigorta Primine Esas Ücret Düzenle"></cfsavecontent>

<cf_box title="#message# : #attributes.ins_pay_id#" scroll="1" closable="1" collapsable="1" resize="1" popup_box="#iif(isdefined("attributes.draggable"),1,0)#">

    <cfform name="form_upd_payments" method="post" action="#request.self#?fuseaction=ehesap.emptypopup_upd_insurance_payments">
        <input type="hidden" name="ins_pay_id" id="ins_pay_id" value="<cfoutput>#attributes.ins_pay_id#</cfoutput>">
        <input type="hidden" name="pageDelEvent" id="pageDelEvent" value="delPayments">
        <input type="hidden" name="is_delete" id="is_delete" value="0">
        <cf_box_elements>
            <div class="row" type="row">
                <div class="col col-8 col-md-8 col-sm-8 col-xs-12" type="column" sort="true" index="1">
                    <div class="form-group" id="item-startdate">
                        <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57655.Başlama Tarihi'> *</label>
                        <div class="col col-8 col-xs-12">
                            <div class="input-group">
                                <cfinput value="#dateformat(get_insurance_payment.startdate,dateformat_style)#" type="text" name="startdate" validate="#validate_style#" >
                                <span class="input-group-addon btnPointer"><cf_wrk_date_image date_field="startdate"></span>
                            </div>
                        </div>
                    </div>
                    <div class="form-group" id="item-finishdate">
                        <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57700.Bitiş Tarihi'> *</label>
                        <div class="col col-8 col-xs-12">
                            <div class="input-group">
                                <cfinput type="text" value="#dateformat(get_insurance_payment.finishdate,dateformat_style)#" name="finishdate" validate="#validate_style#">
                                <span class="input-group-addon btnPointer"><cf_wrk_date_image date_field="finishdate"></span>
                            </div>
                        </div>
                    </div>
                    <div class="form-group" id="item-minimum">
                        <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='53047.Taban'> *</label>
                        <div class="col col-8 col-xs-12">
                            <cfinput type="text" name="minimum" value="#TLFormat(get_insurance_payment.min_payment)#" onkeyup="return(FormatCurrency(this,event));">
                        </div>
                    </div>
                    <div class="form-group" id="item-maximum">
                        <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='53048.Tavan'> *</label>
                        <div class="col col-8 col-xs-12">
                            <cfinput type="text" name="maximum" value="#TLFormat(get_insurance_payment.max_payment)#" onkeyup="return(FormatCurrency(this,event));">
                        </div>
                    </div>
                    <div class="form-group" id="item-min_gross_payment_normal">
                        <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='52979.Asgari Brüt Ücret'> (<cf_get_lang dictionary_id='53043.Normal'>) *</label>
                        <div class="col col-8 col-xs-12">
                            <cfinput type="text" name="min_gross_payment_normal" value="#tlformat(get_insurance_payment.min_gross_payment_normal)#" onkeyup="return(FormatCurrency(this,event));">
                        </div>
                    </div>
                    <div class="form-group" id="item-min_gross_payment_16">
                        <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='52979.Asgari Brüt Ücret'> (16) *</label>
                        <div class="col col-8 col-xs-12">
                            <cfinput type="text" name="min_gross_payment_16" value="#tlformat(get_insurance_payment.min_gross_payment_16)#" onkeyup="return(FormatCurrency(this,event));">
                        </div>
                    </div>
                    <div class="form-group" id="item-seniority_compansation_max">
                        <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id="53129.Kıdem Tazminatı Tavanı"></label>
                        <div class="col col-8 col-xs-12">
                            <cfinput type="text" name="seniority_compansation_max" value="#tlformat(get_insurance_payment.seniority_compansation_max)#" onkeyup="return(FormatCurrency(this,event));">
                        </div>
                    </div>
                </div>
                
            </div>
            <div class="row formContentFooter">
                <div class="col col-6 col-xs-12">
                    <cf_record_info query_name="get_insurance_payment">
                </div>
                <div class="col col-6 col-xs-12">
                    <cfsavecontent variable="message"><cf_get_lang dictionary_id ='54016.Kayıtlı Sigorta Primine Esas Ücreti Siliyorsunuz Emin misiniz'></cfsavecontent>
                    <cf_workcube_buttons is_upd='1' add_function="kontrol()" del_function="del()" <!--- delete_page_url='#request.self#?fuseaction=ehesap.emptypopup_del_insurance_payments&ins_pay_id=#attributes.ins_pay_id#'  --->delete_alert='#message#'>
                </div>
            </div>
        </cf_box_elements>
        <div id="show_user_message_cont"></div>
    </cfform>
</cf_box>
<script type="text/javascript">
    function del(){
        document.form_upd_payments.is_delete.value=1;
        AjaxFormSubmit('form_upd_payments','show_user_message_cont',1,'Siliniyor!','Silindi!');
        <cfif isdefined("attributes.draggable")>
            loadPopupBox('form_upd_payments' , '<cfoutput>#attributes.modal_id#</cfoutput>');
        </cfif>
    }
	function kontrol()
	{
		if(!$("#startdate").val().length)
		{
			alertObject({message: "<cfoutput><cf_get_lang dictionary_id ='57738.Başlama Tarihi Girmelisiniz'> !</cfoutput>"})    
			return false;
		}
		if(!$("#finishdate").val().length)
		{
			alertObject({message: "<cfoutput><cf_get_lang dictionary_id='57739.Bitiş Tarihi girmelisiniz'> !</cfoutput>"})    
			return false;
		}
		if(!$("#minimum").val().length)
		{
			alertObject({message: "<cfoutput><cf_get_lang dictionary_id='53060.Taban girmelisiniz'> !</cfoutput>"})    
			return false;
		}
		if(!$("#maximum").val().length)
		{
			alertObject({message: "<cfoutput><cf_get_lang dictionary_id='53061.Tavan girmelisiniz'> !</cfoutput>"})    
			return false;
		}
		if(!$("#min_gross_payment_normal").val().length)
		{
			alertObject({message: "<cfoutput><cf_get_lang dictionary_id ='57613.Girmelisiniz'><cf_get_lang dictionary_id ='52979.Asgari Brüt Ücret'>(<cf_get_lang dictionary_id='53043.Normal'>) !</cfoutput>"})    
			return false;
		}
		if(!$("#min_gross_payment_16").val().length)
		{
			alertObject({message: "<cfoutput><cf_get_lang dictionary_id ='57613.Girmelisiniz'><cf_get_lang dictionary_id ='52979.Asgari Brüt Ücret'> (16) !</cfoutput>"})    
			return false;
		}
		if(!$("#seniority_compansation_max").val().length)
		{
			alertObject({message: "<cfoutput><cf_get_lang dictionary_id='53129.Kıdem Tazminatı Tavanı'> !</cfoutput>"})    
			return false;
		}
		UnformatFields();
		/* return true; */
        <cfif isdefined("attributes.draggable")>
			loadPopupBox('form_upd_payments' , '<cfoutput>#attributes.modal_id#</cfoutput>');
            return false;
		</cfif>
	}
	function UnformatFields()
	{
		form_upd_payments.seniority_compansation_max.value = filterNum(form_upd_payments.seniority_compansation_max.value);
		form_upd_payments.minimum.value = filterNum(form_upd_payments.minimum.value);
		form_upd_payments.maximum.value = filterNum(form_upd_payments.maximum.value);
		form_upd_payments.min_gross_payment_normal.value = filterNum(form_upd_payments.min_gross_payment_normal.value);
		form_upd_payments.min_gross_payment_16.value = filterNum(form_upd_payments.min_gross_payment_16.value);
	}
</script>
