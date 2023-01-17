<!---
    File: V16\hr\ehesap\display\add_academic_rate.cfm
    Author: Esma R. Uysal <esmauysal@workcube.com>
    Date: 2021-010-11
    Description: Akademik personel oranları
        
    History:
        
    To Do:

--->
<cfsavecontent variable="message"><cf_get_lang dictionary_id='64062.Akademik Teşvik Ödeneği Oranları'></cfsavecontent>
<cfparam name="attributes.modal_id" default="">
<cf_box title="#message#" scroll="1" closable="1" collapsable="1" resize="1" popup_box="#iif(isdefined("attributes.draggable"),1,0)#">
	<cfform name="form_add_course" method="post">
		<cf_box_elements>
			<div class="row" type="row">
				<div class="col col-12 col-md-12 col-sm-12 col-xs-12" type="column" sort="true" index="1">
					<div class="form-group" id="item-name">
						<label class="col col-3 col-xs-12"><cf_get_lang dictionary_id ='57480.Başlık'></label>
						<div class="col col-9 col-xs-12">
							<cfinput type="text" name="title" maxlength="50">
						</div>
					</div>
					<div class="form-group" id="item-date">
						<label class="col col-3 col-xs-12"><cf_get_lang dictionary_id='57655.Başlama Tarihi'>/<cf_get_lang dictionary_id='57700.Bitiş Tarihi'></label>
						<div class="col col-9 col-xs-12">
							<div class="input-group">
								<cfinput type="text" name="start_date" validate="#validate_style#">
								<span class="input-group-addon btnPointer"><cf_wrk_date_image date_field="start_date"></span>
								<span class="input-group-addon no-bg"></span>
								<cfinput type="text" name="finish_date" validate="#validate_style#">
								<span class="input-group-addon btnPointer"><cf_wrk_date_image date_field="finish_date"></span>
							</div>
						</div>
					</div>
				</div>
			</div>
			<div class="row" type="row">
				<div class="col col-12 col-md-12 col-sm-12 col-xs-12" type="column" sort="true" index="2">
					<div class="form-group" id="item-baslik">
						<label class="col col-3 bold"><cf_get_lang dictionary_id='64062.'></label>
					</div>
					<div class="form-group" id="item-rate_1">
						<label class="col col-3"><cf_get_lang dictionary_id='63391.Profesör'></label>
						<div class="col col-9">
							<cfinput type="text" name="rate_1" onkeyup="return(FormatCurrency(this,event));" class="unformat_input moneybox">
						</div>
					</div>
					<div class="form-group" id="item-rate_2">
						<label class="col col-3"><cf_get_lang dictionary_id='63392.Doçent'></label>
						<div class="col col-9">
							<cfinput type="text" name="rate_2" onkeyup="return(FormatCurrency(this,event));" class="unformat_input moneybox">
						</div>
					</div>
                    <div class="form-group" id="item-rate_3">
						<label class="col col-3"><cf_get_lang dictionary_id='63393.Yardımcı Doçent'></label>
						<div class="col col-9">
							<cfinput type="text" name="rate_3" onkeyup="return(FormatCurrency(this,event));" class="unformat_input moneybox">
						</div>
					</div>
                    <div class="form-group" id="item-rate_4">
						<label class="col col-3"><cf_get_lang dictionary_id='63394.Öğretim Görevlisi'></label>
						<div class="col col-9">
							<cfinput type="text" name="rate_4" onkeyup="return(FormatCurrency(this,event));" class="unformat_input moneybox">
						</div>
					</div>
                    <div class="form-group" id="item-rate_5">
						<label class="col col-3"><cf_get_lang dictionary_id='63395.Okutman'></label>
						<div class="col col-9">
							<cfinput type="text" name="rate_5" onkeyup="return(FormatCurrency(this,event));" class="unformat_input moneybox">
						</div>
					</div>
                    <div class="form-group" id="item-rate_6">
						<label class="col col-3"><cf_get_lang dictionary_id='64061.Araştırma Görevlisi'></label>
						<div class="col col-9">
							<cfinput type="text" name="rate_6" onkeyup="return(FormatCurrency(this,event));" class="unformat_input moneybox">
						</div>
					</div>
				</div>
			</div>
			
			<div class="row formContentFooter">
				<div class="col col-12">
					<cf_workcube_buttons is_upd='0' add_function="kontrol()" data_action = "/V16/hr/ehesap/cfc/academic_personnel_rate:ADD_SETUP_ACADEMIC_PERSONNEL" next_page="#request.self#?fuseaction=ehesap.personal_payment">
				</div>
			</div>
		</cf_box_elements>
	</cfform>
</cf_box>
<script type="text/javascript">
function kontrol()
{
	if(!$("#title").val().length)
	{
		alertObject({message: "<cfoutput><cf_get_lang dictionary_id='58939.İsim girmelisiniz'> !</cfoutput>"})    
		return false;
	}
	if(!$("#start_date").val().length)
	{
		alertObject({message: "<cfoutput><cf_get_lang dictionary_id='57738.Başlama Tarihi girmelisiniz'> !</cfoutput>"})    
		return false;
	}
	if(!$("#finish_date").val().length)
	{
		alertObject({message: "<cfoutput><cf_get_lang dictionary_id='57739.Bitiş Tarihi girmelisiniz'> !</cfoutput>"})    
		return false;
	}
	UnformatFields();
}
function UnformatFields()
{
    $(".unformat_input").each(function(){
		if($(this).val() != '')
			$(this).val(filterNum($(this).val()));
		else
		{
			alert("<cf_get_lang dictionary_id='63399.Lütfen tüm alanları doldurunuz!'>");
			return false;
		}
    });
}
</script>
