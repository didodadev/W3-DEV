<!---
	BK 060705
	Bu dosya ilgili alanlarin degisiklige ugramasi durumunda surecdeki ilgili kisilere uyarı atmak amaci ile hazirlanmistir.
	Formda bulunan deger page_warning_value 1 set edilir.
 --->
<script type="text/javascript">
function process_cat_dsp_function()
{
	if(document.form_basket.page_warning_value != undefined)
	{
		if(	(document.form_basket.old_consumer_id.value != document.form_basket.consumer_id.value) || (document.form_basket.old_partner_id.value != document.form_basket.old_partner_id.value) ||
			(document.form_basket.old_company_id.value != document.form_basket.company_id.value) || (document.form_basket.old_invoice_consumer_id.value != document.form_basket.invoice_consumer_id.value) || (document.form_basket.old_invoice_company_id.value != document.form_basket.invoice_company_id.value) ||
			(document.form_basket.old_invoice_partner_id.value != document.form_basket.invoice_partner_id.value) || (document.form_basket.old_invoice_process_value.value != document.form_basket.process_stage.value) || (document.form_basket.old_subscription_type.value != document.form_basket.subscription_type.value) || 
			(document.form_basket.old_ref_company_id.value != document.form_basket.ref_company_id.value) || (document.form_basket.old_invoice_process_value.value != document.form_basket.process_stage.value) || (document.form_basket.old_ref_company_id.value != document.form_basket.ref_company_id.value) || 
			(document.form_basket.old_ref_member_id.value != document.form_basket.ref_member_id.value) || (document.form_basket.old_credit_card_id.value != document.form_basket.credit_card_id.value) || (document.form_basket.old_special_code.value != document.form_basket.special_code.value)
		  )
		{
			document.form_basket.page_warning_value.value = 1;
		}
	}
}
</script>
