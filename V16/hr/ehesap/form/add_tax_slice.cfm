<cfset xfa.add = "ehesap.emptypopup_add_tax_slice">
<cfsavecontent variable="message"><cf_get_lang dictionary_id="53058.Vergi Dilimi Ekle"></cfsavecontent>
<cfparam name="attributes.modal_id" default="">
<cf_box title="#message#" scroll="1" closable="1" collapsable="1" resize="1" popup_box="#iif(isdefined("attributes.draggable"),1,0)#">
	<cfform name="form_add_tax_slices" method="post" action="#request.self#?fuseaction=#xfa.add#">
		<cf_box_elements>
			<div class="row" type="row">
				<div class="col col-8 col-md-8 col-sm-8 col-xs-12" type="column" sort="true" index="1">
					<div class="form-group" id="item-name">
						<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id ='57480.Başlık'></label>
						<div class="col col-8 col-xs-12">
							<cfinput type="text" name="NAME" maxlength="50">
						</div>
					</div>
					<div class="form-group" id="item-date">
						<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57655.Başlama Tarihi'>/<cf_get_lang dictionary_id='57700.Bitiş Tarihi'></label>
						<div class="col col-8 col-xs-12">
							<div class="input-group">
								<cfinput type="text" name="startdate" validate="#validate_style#">
								<span class="input-group-addon btnPointer"><cf_wrk_date_image date_field="startdate"></span>
								<span class="input-group-addon no-bg"></span>
								<cfinput type="text" name="finishdate" validate="#validate_style#">
								<span class="input-group-addon btnPointer"><cf_wrk_date_image date_field="finishdate"></span>
							</div>
						</div>
					</div>
				</div>
			</div>
			<div class="row" type="row">
				<div class="col col-8 col-md-8 col-sm-8 col-xs-12" type="column" sort="true" index="2">
					<div class="form-group" id="item-baslik">
						<label class="col col-2 bold"><cf_get_lang dictionary_id='58710.Kademe'></label>
						<label class="col col-4 bold"><cf_get_lang dictionary_id='53052.Alt Sınır'></label>
						<label class="col col-4 bold"><cf_get_lang dictionary_id='53053.Üst Sınır'></label>
						<label class="col col-2 bold"><cf_get_lang dictionary_id='53201.Vergi Oranı'></label>
					</div>
					<div class="form-group" id="item-payment1">
						<label class="col col-2">1</label>
						<div class="col col-4">
							<cfinput type="text" name="MIN_PAYMENT_1" onkeyup="return(FormatCurrency(this,event));">
						</div>
						<div class="col col-4">
							<cfinput type="text" name="MAX_PAYMENT_1" onkeyup="return(FormatCurrency(this,event));">
						</div>
						<div class="col col-2">
							<cfinput type="text" name="RATIO_1" maxlength="6" validate="float">
						</div>
					</div>
					<div class="form-group" id="item-payment2">
						<label class="col col-2">2</label>
						<div class="col col-4">
							<cfinput type="text" name="MIN_PAYMENT_2" onkeyup="return(FormatCurrency(this,event));">
						</div>
						<div class="col col-4">
							<cfinput type="text" name="MAX_PAYMENT_2" onkeyup="return(FormatCurrency(this,event));">
						</div>
						<div class="col col-2">
							<cfinput type="text" name="RATIO_2" maxlength="6" validate="float">
						</div>
					</div>
					<div class="form-group" id="item-payment3">
						<label class="col col-2">3</label>
						<div class="col col-4">
							<cfinput type="text" name="MIN_PAYMENT_3" onkeyup="return(FormatCurrency(this,event));">
						</div>
						<div class="col col-4">
							<cfinput type="text" name="MAX_PAYMENT_3" onkeyup="return(FormatCurrency(this,event));">
						</div>
						<div class="col col-2">
							<cfinput type="text" name="RATIO_3" maxlength="6" validate="float">
						</div>
					</div>
					<div class="form-group" id="item-payment4">
						<label class="col col-2">4</label>
						<div class="col col-4">
							<cfinput type="text" name="MIN_PAYMENT_4" onkeyup="return(FormatCurrency(this,event));">
						</div>
						<div class="col col-4">
							<cfinput type="text" name="MAX_PAYMENT_4" onkeyup="return(FormatCurrency(this,event));">
						</div>
						<div class="col col-2">
							<cfinput type="text" name="RATIO_4" maxlength="6" validate="float">
						</div>
					</div>
					<div class="form-group" id="item-payment5">
						<label class="col col-2">5</label>
						<div class="col col-4">
							<cfinput type="text" name="MIN_PAYMENT_5" onkeyup="return(FormatCurrency(this,event));">
						</div>
						<div class="col col-4">
							<cfinput type="text" name="MAX_PAYMENT_5" onkeyup="return(FormatCurrency(this,event));">
						</div>
						<div class="col col-2">
							<cfinput type="text" name="RATIO_5" maxlength="6" validate="float">
						</div>
					</div>
					<div class="form-group" id="item-payment6">
						<label class="col col-2">6</label>
						<div class="col col-4">
							<cfinput type="text" name="MIN_PAYMENT_6" onkeyup="return(FormatCurrency(this,event));">
						</div>
						<div class="col col-4">
							<cfinput type="text" name="MAX_PAYMENT_6" onkeyup="return(FormatCurrency(this,event));">
						</div>
						<div class="col col-2">
							<cfinput type="text" name="RATIO_6" maxlength="6" validate="float">
						</div>
					</div>
				</div>
			</div>
			<div class="row" type="row">
				<div class="col col-8 col-md-8 col-sm-8 col-xs-12" type="column" sort="true" index="3">
					<div class="form-group" id="item-sakatlik_indirimi">
						<label class="col col-12 bold"><cf_get_lang dictionary_id="54168.Sakatlık İndirimi"></label>
					</div>
					<div class="form-group" id="item-sakat_style">
						<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id="54180.Hesaplama Türü"></label>
						<div class="col col-8 col-xs-12">
							<select name="sakat_style" id="sakat_style" style="width:120px">
								<option value="0"><cf_get_lang dictionary_id="58457.Günlük"></option>
								<option value="1"><cf_get_lang dictionary_id="58932.Aylık"></option>
							</select>
						</div>
					</div>
					<div class="form-group" id="item-sakat1">
						<label class="col col-4 col-xs-12">1.<cf_get_lang dictionary_id="54179.Derece"></label>
						<div class="col col-8 col-xs-12">
							<cfinput type="text" name="sakat1" onkeyup="return(FormatCurrency(this,event,6));">
						</div>
					</div>
					<div class="form-group" id="item-sakat2">
						<label class="col col-4 col-xs-12">2.<cf_get_lang dictionary_id="54179.Derece"></label>
						<div class="col col-8 col-xs-12">
							<cfinput type="text" name="sakat2" onkeyup="return(FormatCurrency(this,event,6));">
						</div>
					</div>
					<div class="form-group" id="item-sakat3">
						<label class="col col-4 col-xs-12">3.<cf_get_lang dictionary_id="54179.Derece"></label>
						<div class="col col-8 col-xs-12">
							<cfinput type="text" name="sakat3" onkeyup="return(FormatCurrency(this,event,6));">
						</div>
					</div>
				</div>
			</div>
			<div class="row formContentFooter">
				<div class="col col-12">
					<cf_workcube_buttons is_upd='0' add_function="kontrol()">
				</div>
			</div>
		</cf_box_elements>
	</cfform>
</cf_box>
<script type="text/javascript">
function kontrol()
{
	if(!$("#NAME").val().length)
	{
		alertObject({message: "<cfoutput><cf_get_lang dictionary_id='58939.İsim girmelisiniz'> !</cfoutput>"})    
		return false;
	}
	if(!$("#startdate").val().length)
	{
		alertObject({message: "<cfoutput><cf_get_lang dictionary_id='57738.Başlama Tarihi girmelisiniz'> !</cfoutput>"})    
		return false;
	}
	if(!$("#finishdate").val().length)
	{
		alertObject({message: "<cfoutput><cf_get_lang dictionary_id='57739.Bitiş Tarihi girmelisiniz'> !</cfoutput>"})    
		return false;
	}
	if(!$("#MIN_PAYMENT_1").val().length || !$("#MIN_PAYMENT_2").val().length || !$("#MIN_PAYMENT_3").val().length || !$("#MIN_PAYMENT_4").val().length || !$("#MIN_PAYMENT_5").val().length  || !$("#MIN_PAYMENT_6").val().length)
	{
		alertObject({message: "<cfoutput><cf_get_lang dictionary_id='53202.Alt Sınır girmelisiniz'> !</cfoutput>"})    
		return false;
	}
	if(!$("#MAX_PAYMENT_1").val().length || !$("#MAX_PAYMENT_2").val().length || !$("#MAX_PAYMENT_3").val().length || !$("#MAX_PAYMENT_4").val().length || !$("#MAX_PAYMENT_5").val().length || !$("#MAX_PAYMENT_6").val().length)
	{
		alertObject({message: "<cfoutput><cf_get_lang dictionary_id='53203.Üst Sınır girmelisiniz'> !</cfoutput>"})    
		return false;
	}
	if(!$("#RATIO_1").val().length || !$("#RATIO_2").val().length || !$("#RATIO_3").val().length || !$("#RATIO_4").val().length || !$("#RATIO_5").val().length || !$("#RATIO_6").val().length)
	{
		alertObject({message: "<cfoutput><cf_get_lang dictionary_id='53204.Vergi Oranı girmelisiniz'> !</cfoutput>"})    
		return false;
	}
	if(!$("#sakat1").val().length || !$("#sakat2").val().length || !$("#sakat3").val().length )
	{
		alertObject({message: "<cfoutput><cf_get_lang dictionary_id='58194.zorunlu alan'> <cf_get_lang dictionary_id='56434.Sakatlık Derecesi'> !</cfoutput>"})	 
		return false;
	}
	UnformatFields();
	/* return true; */
	<cfif isdefined("attributes.draggable")>
		loadPopupBox('form_add_tax_slices' , '<cfoutput>#attributes.modal_id#</cfoutput>');
	</cfif>
}
function UnformatFields()
{
  form_add_tax_slices.MIN_PAYMENT_1.value = filterNum(form_add_tax_slices.MIN_PAYMENT_1.value);
  form_add_tax_slices.MAX_PAYMENT_1.value = filterNum(form_add_tax_slices.MAX_PAYMENT_1.value);
  form_add_tax_slices.MIN_PAYMENT_2.value = filterNum(form_add_tax_slices.MIN_PAYMENT_2.value);
  form_add_tax_slices.MAX_PAYMENT_2.value = filterNum(form_add_tax_slices.MAX_PAYMENT_2.value);
  form_add_tax_slices.MIN_PAYMENT_3.value = filterNum(form_add_tax_slices.MIN_PAYMENT_3.value);
  form_add_tax_slices.MAX_PAYMENT_3.value = filterNum(form_add_tax_slices.MAX_PAYMENT_3.value);
  form_add_tax_slices.MIN_PAYMENT_4.value = filterNum(form_add_tax_slices.MIN_PAYMENT_4.value);
  form_add_tax_slices.MAX_PAYMENT_4.value = filterNum(form_add_tax_slices.MAX_PAYMENT_4.value);
  form_add_tax_slices.MIN_PAYMENT_5.value = filterNum(form_add_tax_slices.MIN_PAYMENT_5.value);
  form_add_tax_slices.MAX_PAYMENT_5.value = filterNum(form_add_tax_slices.MAX_PAYMENT_5.value);
  form_add_tax_slices.MIN_PAYMENT_6.value = filterNum(form_add_tax_slices.MIN_PAYMENT_6.value);
  form_add_tax_slices.MAX_PAYMENT_6.value = filterNum(form_add_tax_slices.MAX_PAYMENT_6.value);
  form_add_tax_slices.sakat1.value = filterNum(form_add_tax_slices.sakat1.value,6);
  form_add_tax_slices.sakat2.value = filterNum(form_add_tax_slices.sakat2.value,6);
  form_add_tax_slices.sakat3.value = filterNum(form_add_tax_slices.sakat3.value,6);
}
</script>
