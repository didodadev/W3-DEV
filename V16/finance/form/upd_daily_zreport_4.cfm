<cfif isdefined("attributes.iid")>
	<cfquery name="GET_INVOICE_STATISTICAL" datasource="#DSN2#">
		SELECT * FROM INVOICE_STATISTICAL WHERE INVOICE_ID = #attributes.iid#
	</cfquery>
</cfif>
<cf_box_elements vertical="1">
	<cfoutput>
		<div class="col col-3 col-md-4 col-sm-6 col-xs-12" type="column" index="1" sort="true">
			<div class="form-group" id="item-total_number_receipt">
				<label><cf_get_lang dictionary_id="56218.Toplam Fiş Sayısı"></label>
				<input type="text" name="total_number_receipt" id="total_number_receipt" value="#TlFormat(get_invoice_statistical.total_number_receipt,0)#"  class="moneybox" onKeyUp="return(FormatCurrency(this,event,0));">
			</div>
			<div class="form-group" id="item-valid_number_receipt">
				<label ><cf_get_lang dictionary_id="56235.Geçerli Fiş Sayısı"></label>
				<input type="text" name="valid_number_receipt" id="valid_number_receipt" value="#TlFormat(get_invoice_statistical.valid_number_receipt,0)#"  class="moneybox" onKeyUp="return(FormatCurrency(this,event,0));">
			</div>
			<div class="form-group" id="item-cancel_number_receipt">
				<label ><cf_get_lang dictionary_id="56243.İptal Edilen Fiş Sayısı"></label>
				<input type="text" name="cancel_number_receipt" id="cancel_number_receipt" value="#TlFormat(get_invoice_statistical.cancel_number_receipt,0)#"  class="moneybox" onKeyUp="return(FormatCurrency(this,event,0));">
			</div>
			<div class="form-group" id="item-total_number_sales_receipt">
				<label ><cf_get_lang dictionary_id="56250.Geçerli Satış Fişi Sayısı"></label>
				<input type="text" name="total_number_sales_receipt" id="total_number_sales_receipt" value="#TlFormat(get_invoice_statistical.total_number_sales_receipt,0)#"  class="moneybox" onKeyUp="return(FormatCurrency(this,event,0));">
			</div>
			<div class="form-group" id="item-cancel_number_sales_receipt">
				<label ><cf_get_lang dictionary_id="56253.İptal Edilen Satış Fişi Sayısı"></label>
				<input type="text" name="cancel_number_sales_receipt" id="cancel_number_sales_receipt" value="#TlFormat(get_invoice_statistical.cancel_number_sales_receipt,0)#"  class="moneybox" onKeyUp="return(FormatCurrency(this,event,0));">
			</div>
			<div class="form-group" id="item-cancel_invoice_total">
				<label ><cf_get_lang dictionary_id="56259.İptal Edilen Fiş Toplamı"></label>
				<input type="text" name="cancel_invoice_total" id="cancel_invoice_total" value="#TlFormat(get_invoice_statistical.cancel_invoice_total)#"  class="moneybox" onKeyUp="return(FormatCurrency(this,event));">
			</div>
			<div class="form-group" id="item-not_financial_invoice_total">
				<label ><cf_get_lang dictionary_id="56262.Mali Olmayan Fiş Sayısı"></label>
				<input type="text" name="not_financial_invoice_total" id="not_financial_invoice_total" value="#TlFormat(get_invoice_statistical.not_financial_invoice_total,0)#"  class="moneybox" onKeyUp="return(FormatCurrency(this,event,0));">
			</div>
			<div class="form-group" id="item-total_number_invoice">
				<label ><cf_get_lang dictionary_id="48809.Toplam Fatura Sayısı"></label>
				<input type="text" name="total_number_invoice" id="total_number_invoice" value="#TlFormat(get_invoice_statistical.total_number_invoice,0)#"  class="moneybox" onKeyUp="return(FormatCurrency(this,event,0));">
			</div>
		</div>
		<div class="col col-3 col-md-4 col-sm-6 col-xs-12" type="column" index="2" sort="true">
			<div class="form-group" id="item-total_cancellation">
				<label ><cf_get_lang dictionary_id="56226.(B.) Toplam İptal"></label>
				<input type="text" name="total_cancellation" id="total_cancellation" value="#TlFormat(get_invoice_statistical.total_cancellation)#"  class="moneybox" onKeyUp="return(FormatCurrency(this,event));">
			</div>
			<div class="form-group" id="item-total_bonus">
				<label ><cf_get_lang dictionary_id="56242.(C.) Toplam İkramiye"></label>
				<input type="text" name="total_bonus" id="total_bonus" value="#TlFormat(get_invoice_statistical.total_bonus)#"  class="moneybox" onKeyUp="return(FormatCurrency(this,event));">
			</div>
			<div class="form-group" id="item-total_discount">
				<label ><cf_get_lang dictionary_id="56246.(D.) Toplam İndirim"></label>
				<input type="text" name="total_discount" id="total_discount" value="#TlFormat(get_invoice_statistical.total_discount)#"  class="moneybox" onKeyUp="return(FormatCurrency(this,event));">
			</div>
			<div class="form-group" id="item-total_deposit">
				<label ><cf_get_lang dictionary_id="56251.(E.) Toplam Depozito"></label>
				<input type="text" name="total_deposit" id="total_deposit" value="#TlFormat(get_invoice_statistical.total_deposit)#"  class="moneybox" onKeyUp="return(FormatCurrency(this,event));">
			</div>
			<div class="form-group" id="item-total_discount2">
				<label ><cf_get_lang dictionary_id="56254.(G.) Toplam İndirim"></label>
				<input type="text" name="total_discount2" id="total_discount2" value="#TlFormat(get_invoice_statistical.total_discount2)#"  class="moneybox" onKeyUp="return(FormatCurrency(this,event));">
			</div>
			<div class="form-group" id="item-total_number_diplomatic_receipt">
				<label ><cf_get_lang dictionary_id="56263.Toplam Diplomatik S.Sayısı"></label>
				<input type="text" name="total_number_diplomatic_receipt" id="total_number_diplomatic_receipt" value="#TlFormat(get_invoice_statistical.total_number_diplomatic_receipt,0)#"  class="moneybox" onKeyUp="return(FormatCurrency(this,event,0));">
			</div>
			<div class="form-group" id="item-valid_number_diplomatic_receipt">
				<label ><cf_get_lang dictionary_id="56290.Geçerli Diplomatik S.Sayısı"></label>
				<input type="text" name="valid_number_diplomatic_receipt" id="valid_number_diplomatic_receipt" value="#TlFormat(get_invoice_statistical.valid_number_diplomatic_receipt,0)#"  class="moneybox" onKeyUp="return(FormatCurrency(this,event,0));">
			</div>
			<div class="form-group" id="item-cancel_number_diplomatic_receipt">
				<label ><cf_get_lang dictionary_id="56272.İptal Edilen Dip.S.Sayısı"></label>
				<input type="text" name="cancel_number_diplomatic_receipt" id="cancel_number_diplomatic_receipt" value="#TlFormat(get_invoice_statistical.cancel_number_diplomatic_receipt,0)#"  class="moneybox" onKeyUp="return(FormatCurrency(this,event,0));">
			</div>
		</div>
		<div class="col col-3 col-md-4 col-sm-6 col-xs-12" type="column" index="3" sort="true">
			<div class="form-group" id="item-total_expense_number_receipt">
				<label ><cf_get_lang dictionary_id="56233.Toplam Gider Pusulası Sayısı"></label>
				<input type="text" name="total_expense_number_receipt" id="total_expense_number_receipt" value="#TlFormat(get_invoice_statistical.total_expense_number_receipt,0)#"  class="moneybox" onKeyUp="return(FormatCurrency(this,event,0));">
			</div>
			<div class="form-group" id="item-valid_expense_number_receipt">
				<label ><cf_get_lang dictionary_id="56270.Geçerli Gider Pusulası Sayısı"></label>
				<input type="text" name="valid_expense_number_receipt" id="valid_expense_number_receipt" value="#TlFormat(get_invoice_statistical.valid_expense_number_receipt,0)#"  class="moneybox" onKeyUp="return(FormatCurrency(this,event,0));">
			</div>
			<div class="form-group" id="item-cancel_expense_number_receipt">
				<label ><cf_get_lang dictionary_id="56247.İptal Edilen Gider Pus.Sayısı"></label>
				<input type="text" name="cancel_expense_number_receipt" id="cancel_expense_number_receipt" value="#TlFormat(get_invoice_statistical.cancel_expense_number_receipt,0)#"  class="moneybox" onKeyUp="return(FormatCurrency(this,event,0));">
			</div>
			<div class="form-group" id="item-total_expense">
				<label ><cf_get_lang dictionary_id="56252.Gider Pus. Toplamı"></label>
				<input type="text" name="total_expense" id="total_expense" value="#TlFormat(get_invoice_statistical.total_expense)#"  class="moneybox" onKeyUp="return(FormatCurrency(this,event));">
			</div>
			<div class="form-group" id="item-total_kdv_expense">
				<label ><cf_get_lang dictionary_id="56258.Gider Pus. KDV Top."></label>
				<input type="text" name="total_kdv_expense" id="total_kdv_expense" value="#TlFormat(get_invoice_statistical.total_kdv_expense)#"  class="moneybox" onKeyUp="return(FormatCurrency(this,event));">
			</div>
			<div class="form-group" id="item-total_cancel_expense">
				<label ><cf_get_lang dictionary_id="56260.Gider Pus. İptal Top."></label>
				<input type="text" name="total_cancel_expense" id="total_cancel_expense" value="#TlFormat(get_invoice_statistical.total_cancel_expense)#"  class="moneybox" onKeyUp="return(FormatCurrency(this,event));">
			</div>
			<div class="form-group" id="item-valid_number_invoice">
				<label ><cf_get_lang dictionary_id="56271.Geçerli Fatura Sayısı"></label>
				<input type="text" name="valid_number_invoice" id="valid_number_invoice" value="#TlFormat(get_invoice_statistical.valid_number_invoice,0)#"  class="moneybox" onKeyUp="return(FormatCurrency(this,event,0));">
			</div>
		</div>
		<div class="col col-3 col-md-4 col-sm-6 col-xs-12" type="column" index="4" sort="true">
			<div class="form-group" id="item-cancel_number_invoice">
				<label ><cf_get_lang dictionary_id="56273.İptal Edilen Fatura Sayısı"></label>
				<input type="text" name="cancel_number_invoice" id="cancel_number_invoice" value="#TlFormat(get_invoice_statistical.cancel_number_invoice,0)#"  class="moneybox" onKeyUp="return(FormatCurrency(this,event,0));">
			</div>
			<div class="form-group" id="item-total_diplomatic">
				<label ><cf_get_lang dictionary_id="56274.Diplomatik S.Toplamı"></label>
				<input type="text" name="total_diplomatic" id="total_diplomatic" value="#TlFormat(get_invoice_statistical.total_diplomatic)#"  class="moneybox" onKeyUp="return(FormatCurrency(this,event));">
			</div>
			<div class="form-group" id="item-total_invoice">
				<label ><cf_get_lang dictionary_id="48962.Fatura Toplamı"></label>
				<input type="text" name="total_invoice" id="total_invoice" value="#TlFormat(get_invoice_statistical.total_invoice)#"  class="moneybox" onKeyUp="return(FormatCurrency(this,event));">
			</div>
			<div class="form-group" id="item-total_cancel_diplomatic">
				<label ><cf_get_lang dictionary_id="56275.Dip.Satış İptal Top."></label>
				<input type="text" name="total_cancel_diplomatic" id="total_cancel_diplomatic" value="#TlFormat(get_invoice_statistical.total_cancel_diplomatic)#"  class="moneybox" onKeyUp="return(FormatCurrency(this,event));">
			</div>
			<div class="form-group" id="item-total_kdv_invoice">
				<label ><cf_get_lang dictionary_id="56277.Fatura KDV Toplamı"></label>
				<input type="text" name="total_kdv_invoice" id="total_kdv_invoice" value="#TlFormat(get_invoice_statistical.total_kdv_invoice)#"  class="moneybox" onKeyUp="return(FormatCurrency(this,event));">
			</div>
			<div class="form-group" id="item-total_error_number_memory">
				<label ><cf_get_lang dictionary_id="56278.Belleğin Hatadan Kurtulma Sayısı"></label>
				<input type="text" name="total_error_number_memory" id="total_error_number_memory" value="#TlFormat(get_invoice_statistical.total_error_number_memory,0)#"  class="moneybox" onKeyUp="return(FormatCurrency(this,event,0));">
			</div>
			<div class="form-group" id="item-total_cancel_invoice">
				<label ><cf_get_lang dictionary_id="56279.Fatura İptal Toplamı"></label>
				<input type="text" name="total_cancel_invoice" id="total_cancel_invoice" value="#TlFormat(get_invoice_statistical.total_cancel_invoice)#"  class="moneybox" onKeyUp="return(FormatCurrency(this,event));">
			</div>
		</div>
	</cfoutput>	
</cf_box_elements>
