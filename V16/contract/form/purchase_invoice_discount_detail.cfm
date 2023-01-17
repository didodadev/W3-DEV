<cfinclude template="../query/get_moneys.cfm">
<cfinclude template="../query/get_purchase_invoice_discount_detail.cfm">
<cfform method="POST" onsubmit="return OnFormSubmit();" name="upd_contr" action="#request.self#?fuseaction=contract.emptypopup_upd_purchase_invoice_discount&contract_id=#attributes.contract_id#">
<cfoutput><input name="CONTRACT_ID" id="CONTRACT_ID" type="hidden" value="#attributes.CONTRACT_ID#"></cfoutput>
<table width="100%" border="0" cellspacing="0" cellpadding="0" height="100%">
  <tr class="color-border">
    <td>
<table width="100%" border="0" cellspacing="1" cellpadding="2" height="100%">
  <tr class="color-list">
    <td class="headbold" height="35">&nbsp;<cf_get_lang no='11.Fatura Altı İskontolar'></td>
  </tr>
  <tr class="color-row">
    <td valign="top">
<table width="100%" border="0">
  <tr>
    <td>
	  <table>
<tr>
  <td colspan="4" class="txtboldblue"><cf_get_lang no='162.Satınalma Sipariş/Fatura İskontoları (satınalma faturası ve siparişi toplamına uygulanır)'></td>
</tr>
  <tr class="txtboldblue">
    <td>&nbsp;</td>
    <td><cf_get_lang no='193.Koşul/Ciro'></td>
    <td><cf_get_lang_main no='77.Para Birimi'></td>
    <td><cf_get_lang_main no='229.İndirim'>%</td>
  </tr>
  <tr>
    <td><cf_get_lang no='107.Fatura Altı İskonto'> %</td>
    <td>
	<cfsavecontent variable="message"><cf_get_lang_main no='59.eksik veri'>:<cf_get_lang no='107.Fatura Altı İskonto !'></cfsavecontent>
	<cfinput validate="float" passThrough = "onkeyup=""return(FormatCurrency(this,event));""" message="#message#" type="text" name="INVOICE_IN_ENDORSEMENT" style="width:125px;text-align: right;" value="#TLFormat(GET_PURCHASE_INVOICE_DISCOUNT.INVOICE_IN_ENDORSEMENT)#"></td>
    <td><select name="INVOICE_IN_MONEY" id="INVOICE_IN_MONEY" style="width:60">
		<cfoutput query="get_moneys">
		<option value="#MONEY#" <cfif GET_PURCHASE_INVOICE_DISCOUNT.INVOICE_IN_MONEY IS get_moneys.MONEY>selected</cfif>>#MONEY#
		</cfoutput>
    </select></td>
    <td>
	<cfsavecontent variable="message"><cf_get_lang no='217.Iskonto 100 den büyük olamaz'></cfsavecontent>
	<cfinput type="text" name="INVOICE_IN_DISCOUNT"  range="0,100" message="#message#"  style="width:40px;" value="#TLFormat(GET_PURCHASE_INVOICE_DISCOUNT.INVOICE_IN_DISCOUNT)#" passThrough = "onkeyup=""return(FormatCurrency(this,event));"""></td>
  </tr>
  <tr>
    <td><cf_get_lang no='161.Peşin İskonto'> %</td>
    <td>
	<cfsavecontent variable="message"><cf_get_lang_main no='59.eksik veri'>:<cf_get_lang no='161.Peşin İskonto !'></cfsavecontent>
	<cfinput validate="float" passThrough = "onkeyup=""return(FormatCurrency(this,event));""" message="#message#" type="text" name="CASH_ENDORSEMENT" style="width:125px;text-align: right;" value="#TLFormat(GET_PURCHASE_INVOICE_DISCOUNT.CASH_ENDORSEMENT)#"></td>
    <td><select name="CASH_MONEY" id="CASH_MONEY" style="width:60">
		<cfoutput query="get_moneys">
		<option value="#MONEY#" <cfif GET_PURCHASE_INVOICE_DISCOUNT.CASH_MONEY IS get_moneys.MONEY>selected</cfif>>#MONEY#
		</cfoutput>
    </select></td>
    <td>
	<cfsavecontent variable="message"><cf_get_lang no='217.Iskonto 100 den büyük olamaz'></cfsavecontent>
	<cfinput type="text" name="CASH_DISCOUNT" style="width:40px;" range="0,100" message="#message#"  value="#TLFormat(GET_PURCHASE_INVOICE_DISCOUNT.CASH_DISCOUNT)#" passThrough = "onkeyup=""return(FormatCurrency(this,event));"""></td>
  </tr>
  <tr>
    <td><cf_get_lang no='160.Özel İskonto'> %</td>
    <td>
	<cfsavecontent variable="message"><cf_get_lang_main no='59.eksik veri'>:<cf_get_lang no='160.Özel İskonto !'></cfsavecontent>
	<cfinput validate="float" passThrough = "onkeyup=""return(FormatCurrency(this,event));""" message="#message#" type="text" name="SPECIAL_ENDORSEMENT" style="width:125px;text-align: right;" value="#TLFormat(GET_PURCHASE_INVOICE_DISCOUNT.SPECIAL_ENDORSEMENT)#"></td>
    <td><select name="SPECIAL_MONEY" id="SPECIAL_MONEY" style="width:60">
		<cfoutput query="get_moneys">
		<option value="#MONEY#" <cfif GET_PURCHASE_INVOICE_DISCOUNT.SPECIAL_MONEY IS get_moneys.MONEY>selected</cfif>>#MONEY#
		</cfoutput>
    </select></td>
    <td>
	<cfsavecontent variable="message"><cf_get_lang no='217.Iskonto 100 den büyük olamaz'></cfsavecontent>
	<cfinput type="text" name="SPECIAL_DISCOUNT" style="width:40px;" range="0,100" message="#message#"  value="#TLFormat(GET_PURCHASE_INVOICE_DISCOUNT.SPECIAL_DISCOUNT)#" passThrough = "onkeyup=""return(FormatCurrency(this,event));"""></td>
  </tr>
  <tr>
    <td><cf_get_lang no='129.Açılış İskontosu'> %</td>
    <td>
	<cfsavecontent variable="message"><cf_get_lang_main no='59.eksik veri'>:<cf_get_lang no='129.Açılış İskontosu !'></cfsavecontent>
	<cfinput validate="float" passThrough = "onkeyup=""return(FormatCurrency(this,event));""" message="<cf_get_lang no='129.Açılış İskontosu'>" type="text" name="OPENING_ENDORSEMENT" style="width:125px;text-align: right;" value="#TLFormat(GET_PURCHASE_INVOICE_DISCOUNT.OPENING_ENDORSEMENT)#"></td>
    <td><select name="OPENING_MONEY" id="OPENING_MONEY" style="width:60">
		<cfoutput query="get_moneys">
		<option value="#MONEY#" <cfif GET_PURCHASE_INVOICE_DISCOUNT.OPENING_MONEY IS get_moneys.MONEY>selected</cfif>>#MONEY#
		</cfoutput>
    </select></td>
    <td>
	<cfsavecontent variable="message"><cf_get_lang no='217.Iskonto 100 den büyük olamaz'></cfsavecontent>
	<cfinput type="text" name="OPENING_DISCOUNT" style="width:40px;" range="0,100" message="#message#"  value="#TLFormat(GET_PURCHASE_INVOICE_DISCOUNT.OPENING_DISCOUNT)#" passThrough = "onkeyup=""return(FormatCurrency(this,event));""">
	<input type="text" name="OPENING_DAYS" id="OPENING_DAYS" style="width:35" value="<cfoutput>#GET_PURCHASE_INVOICE_DISCOUNT.OPENING_DAYS#</cfoutput>"><cf_get_lang dictionary_id="57490.Gün"> 
	<input type="checkbox" name="OPENING_ALL_BRANCHES" id="OPENING_ALL_BRANCHES" <cfif GET_PURCHASE_INVOICE_DISCOUNT.OPENING_ALL_BRANCHES is 1>checked</cfif>> <cf_get_lang dictionary_id="54748.Tüm Mağazalar">
	</td>
  </tr>
  <tr>
    <td><cf_get_lang no='128.Lojistik İskontosu'> %</td>
    <td></td>
    <td></td>
    <td>
	<cfsavecontent variable="message"><cf_get_lang no='217.Iskonto 100 den büyük olamaz'></cfsavecontent>
	<cfinput type="text" name="LOGISTIC_DISCOUNT" style="width:40px;" range="0,100" message="#message#" value="#TLFormat(GET_PURCHASE_INVOICE_DISCOUNT.LOGISTIC_DISCOUNT)#" passThrough = "onkeyup=""return(FormatCurrency(this,event));"""></td>
  </tr>
  <tr>
    <td><cf_get_lang no='127.Kuruluş Kampanya İskontosu'> %</td>
    <td></td>
    <td></td>
    <td>
	<cfsavecontent variable="message"><cf_get_lang no='217.Iskonto 100 den büyük olamaz'></cfsavecontent>
	<cfinput type="text" name="NEW_COMPANY_DISCOUNT" style="width:40px;" range="0,100" message="#message#" maxlength="2" value="#TLFormat(GET_PURCHASE_INVOICE_DISCOUNT.NEW_COMPANY_DISCOUNT)#" passThrough = "onkeyup=""return(FormatCurrency(this,event));"""></td>
  </tr>
  <tr>
    <td class="formbold"><cf_get_lang no='126.Ürünle İlişkili İskontolar'></td>
    <td></td>
    <td></td>
    <td></td>
  </tr>
  <tr>
    <td><cf_get_lang no='125.Yeni Ürün İskontosu'> %</td>
    <td></td>
    <td></td>
    <td>
	<cfsavecontent variable="message"><cf_get_lang no='217.Iskonto 100 den büyük olamaz'></cfsavecontent>
	<cfinput type="text" name="NEW_PROD_DISCOUNT" style="width:40px;" range="0,100" message="#message#"  value="#TLFormat(GET_PURCHASE_INVOICE_DISCOUNT.NEW_PROD_DISCOUNT)#" passThrough = "onkeyup=""return(FormatCurrency(this,event));"""></td>
  </tr>
  <tr>
    <td><cf_get_lang no='113.İnsert İskontosu'> %</td>
    <td></td>
    <td></td>
    <td>
	<cfsavecontent variable="message"><cf_get_lang no='217.Iskonto 100 den büyük olamaz'></cfsavecontent>
	<cfinput type="text" name="INSERT_DISCOUNT" style="width:40px;" range="0,100" message="#message#" value="#TLFormat(GET_PURCHASE_INVOICE_DISCOUNT.INSERT_DISCOUNT)#" passThrough = "onkeyup=""return(FormatCurrency(this,event));"""></td>
  </tr>
  <tr>
    <td><cf_get_lang no='112.Gondol/Palet İskontosu'> %</td>
    <td></td>
    <td></td>
    <td>
	<cfsavecontent variable="message"><cf_get_lang no='217.Iskonto 100 den büyük olamaz'></cfsavecontent>
	<cfinput type="text" name="GONDOL_DISCOUNT" style="width:40px;" range="0,100" message="#message#"  value="#TLFormat(GET_PURCHASE_INVOICE_DISCOUNT.GONDOL_DISCOUNT)#" passThrough = "onkeyup=""return(FormatCurrency(this,event));"""></td>
  </tr>
  <tr>
    <td>&nbsp;</td>
    <td height="35" colspan="3"  style="text-align:right;">
		<cf_workcube_buttons is_upd='0' add_function='percentControl()'> 
	</td>
  </tr>
</table>
	</td>
  </tr>
</table>
</cfform>
</td>
</tr>
</table>
</td>
</tr>
</table>
<script type="text/javascript">
function kontrol()
{
 upd_contr.INVOICE_IN_ENDORSEMENT.value = f1(upd_contr.INVOICE_IN_ENDORSEMENT.value);
 upd_contr.CASH_ENDORSEMENT.value = f1(upd_contr.CASH_ENDORSEMENT.value);
 upd_contr.SPECIAL_ENDORSEMENT.value = f1(upd_contr.SPECIAL_ENDORSEMENT.value);
 upd_contr.OPENING_ENDORSEMENT.value = f1(upd_contr.OPENING_ENDORSEMENT.value);
 
 upd_contr.INVOICE_IN_DISCOUNT.value = f1(upd_contr.INVOICE_IN_DISCOUNT.value);
 upd_contr.CASH_DISCOUNT.value = f1(upd_contr.CASH_DISCOUNT.value);
 upd_contr.SPECIAL_DISCOUNT.value = f1(upd_contr.SPECIAL_DISCOUNT.value);
 upd_contr.OPENING_DISCOUNT.value = f1(upd_contr.OPENING_DISCOUNT.value);
 upd_contr.LOGISTIC_DISCOUNT.value = f1(upd_contr.LOGISTIC_DISCOUNT.value);
 upd_contr.NEW_COMPANY_DISCOUNT.value = f1(upd_contr.NEW_COMPANY_DISCOUNT.value);
 upd_contr.NEW_PROD_DISCOUNT.value = f1(upd_contr.NEW_PROD_DISCOUNT.value);
 upd_contr.INSERT_DISCOUNT.value = f1(upd_contr.INSERT_DISCOUNT.value);
 upd_contr.GONDOL_DISCOUNT.value = f1(upd_contr.GONDOL_DISCOUNT.value);
 
 return true;
}
function percentControl()
{
 INVOICEINDISCOUNT = f1(upd_contr.INVOICE_IN_DISCOUNT.value);
 CASHDISCOUNT = f1(upd_contr.CASH_DISCOUNT.value);
 SPECIALDISCOUNT = f1(upd_contr.SPECIAL_DISCOUNT.value);
 OPENINGDISCOUNT = f1(upd_contr.OPENING_DISCOUNT.value);
 LOGISTICDISCOUNT = f1(upd_contr.LOGISTIC_DISCOUNT.value);
 NEWCOMPANYDISCOUNT = f1(upd_contr.NEW_COMPANY_DISCOUNT.value);
 NEWPRODDISCOUNT = f1(upd_contr.NEW_PROD_DISCOUNT.value);
 INSERTDISCOUNT = f1(upd_contr.INSERT_DISCOUNT.value);
 GONDOLDISCOUNT = f1(upd_contr.GONDOL_DISCOUNT.value);

	if (INVOICEINDISCOUNT>100 || CASHDISCOUNT>100 || SPECIALDISCOUNT>100 || OPENINGDISCOUNT>100 || LOGISTICDISCOUNT>100 || NEWCOMPANYDISCOUNT>100 || INSERTDISCOUNT>100 || GONDOLDISCOUNT>100 || 	INVOICEINDISCOUNT<0 || CASHDISCOUNT<0 || SPECIALDISCOUNT<0 || OPENINGDISCOUNT<0 || LOGISTICDISCOUNT<0 || NEWCOMPANYDISCOUNT<0 || INSERTDISCOUNT<0 || GONDOLDISCOUNT<0)
	{
		alert('<cf_get_lang no='211.İskonto 0 ile 100 arasında olmalıdır'>');
		return false;
	}
	else
		return kontrol();
}
</script>

