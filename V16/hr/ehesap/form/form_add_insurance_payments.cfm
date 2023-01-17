<cfset xfa.add = "ehesap.emptypopup_add_insurance_payments">
<cfparam name="attributes.modal_id" default="">
<cfsavecontent variable="message"><cf_get_lang dictionary_id="53055.Sigorta Primine Esas Ücret Ekle"></cfsavecontent>
<cf_box title="#message#" scroll="1" closable="1" collapsable="1" resize="1" popup_box="#iif(isdefined("attributes.draggable"),1,0)#">
	<cfform name="form_add_insurance" method="post" action="#request.self#?fuseaction=#xfa.add#">
		<cf_box_elements>
			<div class="col col-8 col-md-8 col-sm-8 col-xs-12" type="column" sort="true" index="1">
				<div class="form-group" id="item-startdate">
					<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57655.Başlama Tarihi'> *</label>
					<div class="col col-8 col-xs-12">
						<div class="input-group">
							<cfinput type="text" name="startdate" validate="#validate_style#"> 
							<span class="input-group-addon btnPointer"><cf_wrk_date_image date_field="startdate"></span>
						</div>
					</div>
				</div>
				<div class="form-group" id="item-finishdate">
					<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57700.Bitiş Tarihi'> *</label>
					<div class="col col-8 col-xs-12">
						<div class="input-group">
							<cfinput type="text" name="finishdate" validate="#validate_style#"> 
							<span class="input-group-addon btnPointer"><cf_wrk_date_image date_field="finishdate"></span>
						</div>
					</div>
				</div>
				<div class="form-group" id="item-minimum">
					<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='53047.Taban'> *</label>
					<div class="col col-8 col-xs-12">
						<cfinput type="text" name="minimum" value="" onkeyup="return(FormatCurrency(this,event));">
					</div>
				</div>
				<div class="form-group" id="item-maximum">
					<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='53048.Tavan'> *</label>
					<div class="col col-8 col-xs-12">
						<cfinput type="text" name="maximum" value="" onkeyup="return(FormatCurrency(this,event));">
					</div>
				</div>
				<div class="form-group" id="item-min_gross_payment_normal">
					<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='52979.Asgari Brüt Ücret'> (<cf_get_lang dictionary_id='53043.Normal'>) *</label>
					<div class="col col-8 col-xs-12">
						<cfinput type="text" name="min_gross_payment_normal" value="" onkeyup="return(FormatCurrency(this,event));">
					</div>
				</div>
				<div class="form-group" id="item-min_gross_payment_16">
					<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='52979.Asgari Brüt Ücret'> (16) *</label>
					<div class="col col-8 col-xs-12">
						<cfinput type="text" name="min_gross_payment_16" value="" onkeyup="return(FormatCurrency(this,event));">
					</div>
				</div>
				<div class="form-group" id="item-seniority_compansation_max">
					<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id="53129.Kıdem Tazminatı Tavanı"></label>
					<div class="col col-8 col-xs-12">
						<cfinput type="text" name="seniority_compansation_max" onkeyup="return(FormatCurrency(this,event));">
					</div>
				</div>
			</div>
			<div class="row formContentFooter">
				<div class="col col-12">
					<cf_workcube_buttons is_upd='0' add_function='kontrol()'>
				</div>
			</div>
		</cf_box_elements>	
	</cfform>
</cf_box>
<script type="text/javascript">
	function kontrol()
	{
		if(!$("#startdate").val().length)
		{
			alertObject({message: "<cfoutput><cf_get_lang dictionary_id='57738.Başlama Tarihi Girmelisiniz'> !</cfoutput>"})    
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
			loadPopupBox('form_add_insurance' , '<cfoutput>#attributes.modal_id#</cfoutput>');
			return false;
		</cfif>
	}

	function UnformatFields()
	{
		form_add_insurance.seniority_compansation_max.value = filterNum(form_add_insurance.seniority_compansation_max.value);	
		form_add_insurance.min_gross_payment_normal.value = filterNum(form_add_insurance.min_gross_payment_normal.value);
		form_add_insurance.min_gross_payment_16.value = filterNum(form_add_insurance.min_gross_payment_16.value);
		form_add_insurance.minimum.value = filterNum(form_add_insurance.minimum.value);
		form_add_insurance.maximum.value = filterNum(form_add_insurance.maximum.value);
		
		/* return true; */
	}
</script>