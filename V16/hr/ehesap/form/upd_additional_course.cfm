<!---
    File: V16\hr\ehesap\display\list_additional_course.cfm
    Author: Esma R. Uysal <esmauysal@workcube.com>
    Date: 2021-07-13
    Description: Memur Ek Ders ÜCret Tablosu Güncelleme
        
    History:
        
    To Do:

--->
<cfset get_component = createObject("component","V16.hr.ehesap.cfc.additional_course") />
<cfset get_course_info = get_component.GET_ADDITIONAL_COURSE_TABLE(additional_course_id: attributes.additional_course_id) />

<cfsavecontent variable="message"><cf_get_lang dictionary_id='63390.Ek Ders Ücret Tablosu'></cfsavecontent>
<cfparam name="attributes.modal_id" default="">
<cf_box title="#message#" scroll="1" closable="1" collapsable="1" resize="1" popup_box="#iif(isdefined("attributes.draggable"),1,0)#">
	<cfform name="form_add_course" method="post">
        <input type="hidden" name="additional_course_id" value="<cfoutput>#attributes.additional_course_id#</cfoutput>">
		<cf_box_elements>
			<div class="row" type="row">
				<div class="col col-12 col-md-12 col-sm-12 col-xs-12" type="column" sort="true" index="1">
					<div class="form-group" id="item-name">
						<label class="col col-3 col-xs-12"><cf_get_lang dictionary_id ='57480.Başlık'></label>
						<div class="col col-9 col-xs-12">
							<cfinput type="text" name="title" maxlength="50" value="#get_course_info.title#">
						</div>
					</div>
					<div class="form-group" id="item-date">
						<label class="col col-3 col-xs-12"><cf_get_lang dictionary_id='57655.Başlama Tarihi'>/<cf_get_lang dictionary_id='57700.Bitiş Tarihi'></label>
						<div class="col col-9 col-xs-12">
							<div class="input-group">
								<cfinput type="text" name="start_date" validate="#validate_style#" value="#dateformat(get_course_info.start_date,dateformat_style)#">
								<span class="input-group-addon btnPointer"><cf_wrk_date_image date_field="start_date"></span>
								<span class="input-group-addon no-bg"></span>
								<cfinput type="text" name="finish_date" validate="#validate_style#" value="#dateformat(get_course_info.finish_date,dateformat_style)#">
								<span class="input-group-addon btnPointer"><cf_wrk_date_image date_field="finish_date"></span>
							</div>
						</div>
					</div>
				</div>
			</div>
			<div class="row" type="row">
				<div class="col col-12 col-md-12 col-sm-12 col-xs-12" type="column" sort="true" index="2">
					<div class="form-group" id="item-baslik">
						<label class="col col-3 bold"><cf_get_lang dictionary_id='30201.Görev'></label>
						<label class="col col-3 bold"><cf_get_lang dictionary_id='63396.N.Ö. Gündüz'></label>
						<label class="col col-3 bold"><cf_get_lang dictionary_id='63397.N.Ö. Gece ve Tatillerde'></label>
						<label class="col col-3 bold"><cf_get_lang dictionary_id='63398.İ.Ö. Gece'></label>
					</div>
					<div class="form-group" id="item-payment1">
						<label class="col col-3"><cf_get_lang dictionary_id='63391.Profesör'></label>
						<div class="col col-3">
							<cfinput type="text" name="daytime_education_1" onkeyup="return(FormatCurrency(this,event));" class="unformat_input moneybox" value="#tlformat(get_course_info.daytime_education_1)#">
						</div>
						<div class="col col-3">
							<cfinput type="text" name="public_holiday_1" onkeyup="return(FormatCurrency(this,event));" class="unformat_input moneybox" value="#tlformat(get_course_info.public_holiday_1)#">
						</div>
						<div class="col col-3">
							<cfinput type="text" name="evening_education_1" onkeyup="return(FormatCurrency(this,event));" class="unformat_input moneybox" value="#tlformat(get_course_info.evening_education_1)#">
						</div>
					</div>
					<div class="form-group" id="item-payment2">
						<label class="col col-3"><cf_get_lang dictionary_id='63392.Doçent'></label>
						<div class="col col-3">
							<cfinput type="text" name="daytime_education_2" onkeyup="return(FormatCurrency(this,event));" class="unformat_input moneybox" value="#tlformat(get_course_info.daytime_education_2)#"> 
						</div>
						<div class="col col-3">
							<cfinput type="text" name="public_holiday_2" onkeyup="return(FormatCurrency(this,event));" class="unformat_input moneybox" value="#tlformat(get_course_info.public_holiday_2)#">
						</div>
						<div class="col col-3">
							<cfinput type="text" name="evening_education_2" onkeyup="return(FormatCurrency(this,event));" class="unformat_input moneybox" value="#tlformat(get_course_info.evening_education_2)#">
						</div>
					</div>
                    <div class="form-group" id="item-payment3">
						<label class="col col-3"><cf_get_lang dictionary_id='63393.Yardımcı Doçent'></label>
						<div class="col col-3">
							<cfinput type="text" name="daytime_education_3" onkeyup="return(FormatCurrency(this,event));" class="unformat_input moneybox" value="#tlformat(get_course_info.daytime_education_3)#">
						</div>
						<div class="col col-3">
							<cfinput type="text" name="public_holiday_3" onkeyup="return(FormatCurrency(this,event));" class="unformat_input moneybox" value="#tlformat(get_course_info.public_holiday_3)#">
						</div>
						<div class="col col-3">
							<cfinput type="text" name="evening_education_3" onkeyup="return(FormatCurrency(this,event));" class="unformat_input moneybox" value="#tlformat(get_course_info.evening_education_3)#">
						</div>
					</div>
                    <div class="form-group" id="item-payment4">
						<label class="col col-3"><cf_get_lang dictionary_id='63394.Öğretim Görevlisi'></label>
						<div class="col col-3">
							<cfinput type="text" name="daytime_education_4" onkeyup="return(FormatCurrency(this,event));" class="unformat_input moneybox" value="#tlformat(get_course_info.daytime_education_4)#">
						</div>
						<div class="col col-3">
							<cfinput type="text" name="public_holiday_4" onkeyup="return(FormatCurrency(this,event));" class="unformat_input moneybox"  value="#tlformat(get_course_info.public_holiday_4)#">
						</div>
						<div class="col col-3">
							<cfinput type="text" name="evening_education_4" onkeyup="return(FormatCurrency(this,event));" class="unformat_input moneybox"  value="#tlformat(get_course_info.evening_education_4)#">
						</div>
					</div>
                    <div class="form-group" id="item-payment5">
						<label class="col col-3"><cf_get_lang dictionary_id='63395.Okutman'></label>
						<div class="col col-3">
							<cfinput type="text" name="daytime_education_5" onkeyup="return(FormatCurrency(this,event));" class="unformat_input moneybox" value="#tlformat(get_course_info.daytime_education_5)#">
						</div>
						<div class="col col-3">
							<cfinput type="text" name="public_holiday_5" onkeyup="return(FormatCurrency(this,event));" class="unformat_input moneybox" value="#tlformat(get_course_info.public_holiday_5)#">
						</div>
						<div class="col col-3">
							<cfinput type="text" name="evening_education_5" onkeyup="return(FormatCurrency(this,event));" class="unformat_input moneybox" value="#tlformat(get_course_info.evening_education_5)#">
						</div>
					</div>
				</div>
			</div>
			
			<div class="row formContentFooter">
				<div class="col col-12">
					<cf_workcube_buttons 
                        is_upd='1' 
                        add_function="kontrol()" 
                        data_action = "/V16/hr/ehesap/cfc/additional_course:UPD_ADDITIONAL_COURSE_TABLE" 
                        next_page="#request.self#?fuseaction=ehesap.personal_payment"
                        del_action= '/V16/hr/ehesap/cfc/additional_course:DEL_ADDITIONAL_COURSE_TABLE:additional_course_id=#attributes.additional_course_id#'
                        del_next_page = '#request.self#?fuseaction=ehesap.personal_payment'
                    >
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
