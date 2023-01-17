<cfquery name="GET_CREDIT_PAYMENT" datasource="#dsn3#">
	SELECT 
		CREDITCARD_PAYMENT_TYPE.PAYMENT_TYPE_ID, 
		CREDITCARD_PAYMENT_TYPE.CARD_NO,
		CREDITCARD_PAYMENT_TYPE.NUMBER_OF_INSTALMENT,
		CREDITCARD_PAYMENT_TYPE.SERVICE_RATE,
		CREDITCARD_PAYMENT_TYPE.OTHER_COMISSION_RATE,
		STORE_POS_BANK.*
	FROM 
		CREDITCARD_PAYMENT_TYPE,
		#dsn2_alias#.STORE_POS_BANK AS STORE_POS_BANK
	WHERE 
		CREDITCARD_PAYMENT_TYPE.IS_ACTIVE = 1 AND
		STORE_POS_BANK.BANK_ID = CREDITCARD_PAYMENT_TYPE.PAYMENT_TYPE_ID AND
		STORE_POS_BANK.STORE_REPORT_ID = #attributes.id# AND
		STORE_POS_BANK.SALES_CREDIT <> 0
	ORDER BY 
		CREDITCARD_PAYMENT_TYPE.CARD_NO
</cfquery>
<cf_popup_box title="#getLang('finance',22)#">
<cfform name="add_credit_payment_types" action="#request.self#?fuseaction=finance.emptypopup_add_credit_payment_types" method="post">
<input type="hidden" name="id" id="id" value="<cfoutput>#attributes.id#</cfoutput>">
<cf_medium_list>
	<thead>
        <tr>
          <th><cf_get_lang dictionary_id="57692.İşlem"></th>
		  <th width="70"><cf_get_lang dictionary_id="57879.İşlem Tarihi"></th>
          <th style="text-align:right;"><cf_get_lang dictionary_id="54854.Kredili Satış Tut."></th>
          <th style="text-align:right;"><cf_get_lang dictionary_id="54857.Verilen Puan"></th>
          <th style="text-align:right;"><cf_get_lang dictionary_id="54856.Satış Puan"></th>
          <th style="text-align:right;"><cf_get_lang dictionary_id="57492.Toplam"></th>
          <th style="text-align:right;"><cf_get_lang dictionary_id="54340.Taksit"></th>
		  <th style="text-align:right;"><cf_get_lang dictionary_id="56201.Hiz. Kom. Or."></th>
          <th style="text-align:right;"><cf_get_lang dictionary_id="56211.Hiz. Kom."></th>
		  <th style="text-align:right;"><cf_get_lang dictionary_id="56212.Diğ Kom. Or."></th>
		  <th style="text-align:right;"><cf_get_lang dictionary_id="56215.Diğ. Kom."></th>
        </tr>
	</thead>
	<tbody>
		<cfoutput query="get_credit_payment">
		<input type="hidden" name="service_rate_value#currentrow#" id="service_rate_value#currentrow#" value="#service_rate#">
		<input type="hidden" name="other_comission_value_value#currentrow#" id="other_comission_value_value#currentrow#" value="#service_rate#">
		<cfscript>
			toplam_puan = 0;
			if (len(sales_credit))
				{toplam_puan = sales_credit;}
			if (len(puanli_pesin))
				{toplam_puan = toplam_puan - puanli_pesin;}
			if (len(puanli))
				toplam_puan = toplam_puan + puanli;
				hizmet_komisyon_orani = 0;
			if (len(sales_credit))
				{deger_val_ = sales_credit;}
				else
				{deger_val_ = 0;}
			if (len(service_rate))
				{hizmet_komisyon_orani = (deger_val_ * service_rate / 100);}
				other_komisyon_orani=0;
			if (len(other_comission_rate))
				other_komisyon_orani = ((deger_val_  * other_comission_rate) / 100);
		</cfscript>
		<tr>
			<td nowrap>#card_no#</td>
			<td><cfinput type="text" name="store_report_date#currentrow#" value="#attributes.store_report_date#" maxlength="10" validate="#validate_style#" required="yes" style="width:70px;" class="box"></td>
			<input type="hidden" name="number_of_operation#currentrow#" id="number_of_operation#currentrow#" value="#sales_taksit#">
			<td style="text-align:right;"><cfinput type="text" name="sales_credit#currentrow#" style="width:100px;" value="#tlformat(sales_credit)#" class="box" readonly="yes"></td>
			<td style="text-align:right;"><cfinput type="text" name="puanli_pesin#currentrow#" style="width:70px;" class="box" readonly="yes" value="#tlformat(puanli_pesin)#"></td>
			<td style="text-align:right;"><cfinput type="text" name="puanli#currentrow#" style="width:70px;" class="box" readonly="yes" value="#tlformat(puanli)#"></td>
			<td style="text-align:right;"><cfinput type="text" name="toplam_puan#currentrow#" class="box" value="#tlformat(toplam_puan)#" readonly="yes"  style="width:70px;"></td>
			<td style="text-align:right;"><cfinput type="text" name="number_of_instalment#currentrow#" class="box" value="#number_of_instalment#" readonly="yes"  style="width:70px;"></td>
			<td style="text-align:right;"><cfinput type="text" name="hizmet_kom#currentrow#" class="box" value="#tlformat(service_rate)#" readonly="yes"  style="width:70px;"></td>
			<td style="text-align:right;"><cfinput type="text" name="hizmet_komisyon_orani#currentrow#" class="box" value="#tlformat(hizmet_komisyon_orani)#" readonly="yes"  style="width:70px;"></td>
			<td style="text-align:right;"><cfinput type="text" name="other_kom#currentrow#" class="box" value="#tlformat(other_comission_rate)#" readonly="yes"  style="width:70px;"></td>
			<td style="text-align:right;"><cfinput type="text" name="other_komisyon_orani#currentrow#" class="box" value="#tlformat(other_komisyon_orani)#" readonly="yes"  style="width:70px;"></td>
		</tr>
		</cfoutput>
	</tbody>
	<tfoot>
		<tr>
			<td colspan="12" style="text-align:right;">
			<cf_workcube_buttons type_format="1" is_upd='1' 
				add_function='kontrol()'
				delete_page_url='#request.self#?fuseaction=finance.emptypopup_del_cred_pay&id=#attributes.id#'></td>
		</tr>
	</tfoot>
</cf_medium_list>
</cfform>
</cf_popup_box>
<script type="text/javascript">
function kontrol()
	{	
	for(r=1;r<=<cfoutput>#get_credit_payment.recordcount#</cfoutput>;r++)
		{
			sales_credit = eval("add_credit_payment_types.sales_credit"+r);
			puanli_pesin = eval("add_credit_payment_types.puanli_pesin"+r);
			puanli = eval("add_credit_payment_types.puanli"+r);
			toplam_puan = eval("add_credit_payment_types.toplam_puan"+r);
			number_of_instalment = eval("add_credit_payment_types.number_of_instalment"+r);
			hizmet_komisyon_orani = eval("add_credit_payment_types.hizmet_komisyon_orani"+r);
			other_komisyon_orani = eval("add_credit_payment_types.other_komisyon_orani"+r);
		
			sales_credit.value = filterNum(sales_credit.value);
			puanli_pesin.value = filterNum(puanli_pesin.value);
			puanli.value = filterNum(puanli.value);
			toplam_puan.value = filterNum(toplam_puan.value);
			number_of_instalment.value = filterNum(number_of_instalment.value);
			hizmet_komisyon_orani.value = filterNum(hizmet_komisyon_orani.value);
			other_komisyon_orani.value = filterNum(other_komisyon_orani.value);
		}
	}
</script>
