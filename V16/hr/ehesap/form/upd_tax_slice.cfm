<cfset xfa.del = "ehesap.emptypopup_del_tax_slice">
<cfset xfa.upd = "ehesap.emptypopup_upd_tax_slice">
<cfinclude template="../query/get_tax_slice.cfm">
<cfsavecontent variable="images"><a href="<cfoutput>#request.self#</cfoutput>?fuseaction=ehesap.popup_form_add_tax_slice"><img src="/images/plus1.gif" border="0" title="<cf_get_lang dictionary_id ='53058.Vergi Dilimi Ekle'>"></a></cfsavecontent>
<cfsavecontent variable="message"><cf_get_lang dictionary_id="53223.Vergi Dilimi Düzenle"></cfsavecontent>
<cfparam name="attributes.modal_id" default="">
<cf_box title="#message#" scroll="1" closable="1" collapsable="1" resize="1" popup_box="#iif(isdefined("attributes.draggable"),1,0)#">
	<cfform name="form_upd_tax_slices" method="post" action="#request.self#?fuseaction=#xfa.upd#">
		<input type="hidden" name="tax_sl_id" id="tax_sl_id" value="<cfoutput>#attributes.tax_sl_id#</cfoutput>">
		<input type="hidden" name="pageDelEvent" id="pageDelEvent" value="delTax">
		<input type="hidden" name="is_delete" id="is_delete" value="0">
		<cf_box_elements>
			<div class="row" type="row">
				<div class="col col-8 col-md-8 col-sm-8 col-xs-12" type="column" sort="true" index="1">
					<div class="form-group" id="item-name">
						<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57480.Başlık'></label>
						<div class="col col-8 col-xs-12">
							<cfinput type="text" name="NAME" maxlength="50" value="#get_tax_slice.name#" >
						</div>
					</div>
					<div class="form-group" id="item-date">
						<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57655.Başlama Tarihi'>/<cf_get_lang dictionary_id='57700.Bitiş Tarihi'></label>
						<div class="col col-8 col-xs-12">
							<div class="input-group">
								<cfinput type="text" name="startdate" value="#dateformat(get_tax_slice.startdate,dateformat_style)#"  validate="#validate_style#" >
								<span class="input-group-addon btnPointer"><cf_wrk_date_image date_field="startdate"></span>
								<span class="input-group-addon no-bg"></span>
								<cfinput type="text" name="finishdate" value="#dateformat(get_tax_slice.finishdate,dateformat_style)#"  validate="#validate_style#" >
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
							<cfinput type="text" name="MIN_PAYMENT_1" value="#TLFormat(get_tax_slice.MIN_PAYMENT_1)#" onkeyup="return(FormatCurrency(this,event));">
						</div>
						<div class="col col-4">
							<cfinput type="text" name="MAX_PAYMENT_1" value="#TLFormat(get_tax_slice.MAX_PAYMENT_1)#" onkeyup="return(FormatCurrency(this,event));">
						</div>
						<div class="col col-2">
							<cfinput type="text" name="RATIO_1" value="#get_tax_slice.RATIO_1#" maxlength="6" validate="float">
						</div>
					</div>
					<div class="form-group" id="item-payment2">
						<label class="col col-2">2</label>
						<div class="col col-4">
							<cfinput type="text" name="MIN_PAYMENT_2" value="#TLFormat(get_tax_slice.MIN_PAYMENT_2)#" onkeyup="return(FormatCurrency(this,event));">
						</div>
						<div class="col col-4">
							<cfinput type="text" name="MAX_PAYMENT_2" value="#TLFormat(get_tax_slice.MAX_PAYMENT_2)#" onkeyup="return(FormatCurrency(this,event));">
						</div>
						<div class="col col-2">
							<cfinput type="text" name="RATIO_2" value="#get_tax_slice.RATIO_2#" maxlength="6" validate="float">
						</div>
					</div>
					<div class="form-group" id="item-payment3">
						<label class="col col-2">3</label>
						<div class="col col-4">
							<cfinput type="text" name="MIN_PAYMENT_3" value="#TLFormat(get_tax_slice.MIN_PAYMENT_3)#" onkeyup="return(FormatCurrency(this,event));">
						</div>
						<div class="col col-4">
							<cfinput type="text" name="MAX_PAYMENT_3" value="#TLFormat(get_tax_slice.MAX_PAYMENT_3)#" onkeyup="return(FormatCurrency(this,event));">
						</div>
						<div class="col col-2">
							<cfinput type="text" name="RATIO_3" value="#get_tax_slice.RATIO_3#" maxlength="6" validate="float">
						</div>
					</div>
					<div class="form-group" id="item-payment4">
						<label class="col col-2">4</label>
						<div class="col col-4">
							<cfinput type="text" name="MIN_PAYMENT_4" value="#TLFormat(get_tax_slice.MIN_PAYMENT_4)#" onkeyup="return(FormatCurrency(this,event));">
						</div>
						<div class="col col-4">
							<cfinput type="text" name="MAX_PAYMENT_4" value="#TLFormat(get_tax_slice.MAX_PAYMENT_4)#" onkeyup="return(FormatCurrency(this,event));">
						</div>
						<div class="col col-2">
							<cfinput type="text" name="RATIO_4" value="#get_tax_slice.RATIO_4#" maxlength="6" validate="float">
						</div>
					</div>
					<div class="form-group" id="item-payment5">
						<label class="col col-2">5</label>
						<div class="col col-4">
							<cfinput type="text" name="MIN_PAYMENT_5" value="#TLFormat(get_tax_slice.MIN_PAYMENT_5)#" onkeyup="return(FormatCurrency(this,event));">
						</div>
						<div class="col col-4">
							<cfinput type="text" name="MAX_PAYMENT_5" value="#TLFormat(get_tax_slice.MAX_PAYMENT_5)#" onkeyup="return(FormatCurrency(this,event));">
						</div>
						<div class="col col-2">
							<cfinput type="text" name="RATIO_5" value="#get_tax_slice.RATIO_5#" maxlength="6" validate="float">
						</div>
					</div>
					<div class="form-group" id="item-payment6">
						<label class="col col-2">6</label>
						<div class="col col-4">
							<cfinput type="text" name="MIN_PAYMENT_6" value="#TLFormat(get_tax_slice.MIN_PAYMENT_6)#" onkeyup="return(FormatCurrency(this,event));">
						</div>
						<div class="col col-4">
							<cfinput type="text" name="MAX_PAYMENT_6" value="#TLFormat(get_tax_slice.MAX_PAYMENT_6)#" onkeyup="return(FormatCurrency(this,event));">
						</div>
						<div class="col col-2">
							<cfinput type="text" name="RATIO_6" value="#get_tax_slice.RATIO_6#" maxlength="6" validate="float">
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
							<select name="sakat_style" id="sakat_style" style="width:120px;">
								<option value="0" <cfif get_tax_slice.sakat_style eq 0>selected</cfif>><cf_get_lang dictionary_id="58457.Günlük"></option>
								<option value="1" <cfif get_tax_slice.sakat_style eq 1>selected</cfif>><cf_get_lang dictionary_id="58932.Aylık"></option>
							</select>
						</div>
					</div>
					<div class="form-group" id="item-sakat1">
						<label class="col col-4 col-xs-12">1.<cf_get_lang dictionary_id="54179.Derece"></label>
						<div class="col col-8 col-xs-12">
							<cfinput type="text" name="sakat1" value="#TLFormat(get_tax_slice.sakat1,6)#" onkeyup="return(FormatCurrency(this,event,6));">
						</div>
					</div>
					<div class="form-group" id="item-sakat2">
						<label class="col col-4 col-xs-12">2.<cf_get_lang dictionary_id="54179.Derece"></label>
						<div class="col col-8 col-xs-12">
							<cfinput type="text" name="sakat2" value="#TLFormat(get_tax_slice.sakat2,6)#" onkeyup="return(FormatCurrency(this,event,6));">
						</div>
					</div>
					<div class="form-group" id="item-sakat3">
						<label class="col col-4 col-xs-12">3.<cf_get_lang dictionary_id="54179.Derece"></label>
						<div class="col col-8 col-xs-12">
							<cfinput type="text" name="sakat3" value="#TLFormat(get_tax_slice.sakat3,6)#" onkeyup="return(FormatCurrency(this,event,6));">
						</div>
					</div>
				</div>
			</div>
			<div class="col col-12 col-xs-12">
				<cf_box_footer>
					<cf_record_info query_name="get_tax_slice">
					<cfsavecontent variable="message"><cf_get_lang dictionary_id ='54017.Kayıtlı Vergi Dilimini Siliyorsunuz Emin misiniz'></cfsavecontent>
					<cf_workcube_buttons is_upd='1' add_function='kontrol()' del_function='del()' delete_alert='#message#'>
				</cf_box_footer>
			</div>
		</cf_box_elements>
		<div id="show_user_message_cont"></div>
	</cfform>
</cf_box>
<script type="text/javascript">
	function del(){
		document.form_upd_tax_slices.is_delete.value=1;
		AjaxFormSubmit('form_upd_tax_slices','show_user_message_cont',1,'Siliniyor!','Silindi!');
		<cfif isdefined("attributes.draggable")>
		    loadPopupBox('form_upd_tax_slices' , '<cfoutput>#attributes.modal_id#</cfoutput>');
		</cfif>
    }
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
			alertObject({message: "<cfoutput><cf_get_lang dictionary_id="58194.Zorunlu Alan">: <cf_get_lang dictionary_id="56434.Sakatlk Derecesi"> !</cfoutput>"})    
			return false;
		}
		UnformatFields();
		/* return true; */
		<cfif isdefined("attributes.draggable")>
			loadPopupBox('form_upd_tax_slices' , '<cfoutput>#attributes.modal_id#</cfoutput>');
		</cfif>
	}
	function UnformatFields()
	{
	  form_upd_tax_slices.MIN_PAYMENT_1.value = filterNum(form_upd_tax_slices.MIN_PAYMENT_1.value);
	  form_upd_tax_slices.MAX_PAYMENT_1.value = filterNum(form_upd_tax_slices.MAX_PAYMENT_1.value);
	  form_upd_tax_slices.MIN_PAYMENT_2.value = filterNum(form_upd_tax_slices.MIN_PAYMENT_2.value);
	  form_upd_tax_slices.MAX_PAYMENT_2.value = filterNum(form_upd_tax_slices.MAX_PAYMENT_2.value);
	  form_upd_tax_slices.MIN_PAYMENT_3.value = filterNum(form_upd_tax_slices.MIN_PAYMENT_3.value);
	  form_upd_tax_slices.MAX_PAYMENT_3.value = filterNum(form_upd_tax_slices.MAX_PAYMENT_3.value);
	  form_upd_tax_slices.MIN_PAYMENT_4.value = filterNum(form_upd_tax_slices.MIN_PAYMENT_4.value);
	  form_upd_tax_slices.MAX_PAYMENT_4.value = filterNum(form_upd_tax_slices.MAX_PAYMENT_4.value);
	  form_upd_tax_slices.MIN_PAYMENT_5.value = filterNum(form_upd_tax_slices.MIN_PAYMENT_5.value);
	  form_upd_tax_slices.MAX_PAYMENT_5.value = filterNum(form_upd_tax_slices.MAX_PAYMENT_5.value);
	  form_upd_tax_slices.MIN_PAYMENT_6.value = filterNum(form_upd_tax_slices.MIN_PAYMENT_6.value);
	  form_upd_tax_slices.MAX_PAYMENT_6.value = filterNum(form_upd_tax_slices.MAX_PAYMENT_6.value);
	  form_upd_tax_slices.sakat1.value = filterNum(form_upd_tax_slices.sakat1.value,6);
	  form_upd_tax_slices.sakat2.value = filterNum(form_upd_tax_slices.sakat2.value,6);
	  form_upd_tax_slices.sakat3.value = filterNum(form_upd_tax_slices.sakat3.value,6);
	}
</script>
