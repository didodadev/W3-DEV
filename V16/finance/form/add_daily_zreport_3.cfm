<cfif isdefined("attributes.iid")>
	<cfif len(get_sale_det.expense_center_id)>
		<cfquery name="get_exp_center" datasource="#dsn2#">
			SELECT EXPENSE FROM EXPENSE_CENTER WHERE EXPENSE_ID = #get_sale_det.expense_center_id#
		</cfquery>
		<cfset exp_center_id = get_sale_det.expense_center_id>
		<cfset exp_center_name = get_exp_center.expense>
	<cfelse>
		<cfset exp_center_id = ''>
		<cfset exp_center_name = ''>
	</cfif>
	<cfif len(get_sale_det.expense_item_id)>
		<cfquery name="get_exp_item" datasource="#dsn2#">
			SELECT EXPENSE_ITEM_NAME FROM EXPENSE_ITEMS WHERE EXPENSE_ITEM_ID = #get_sale_det.expense_item_id#
		</cfquery>
		<cfset exp_item_id = get_sale_det.expense_item_id>
		<cfset exp_item_name = get_exp_item.expense_item_name>
	<cfelse>
		<cfset exp_item_id = ''>
		<cfset exp_item_name = ''>
	</cfif>
<cfelse>
	<cfset exp_center_id = ''>
	<cfset exp_center_name = ''>
	<cfset exp_item_id = ''>
	<cfset exp_item_name = ''>
</cfif>
<cf_basket_form id="toplam">
<cf_grid_list>
    <thead>
        <tr>
            <th></th>
            <th><cf_get_lang dictionary_id='37285.Toplam Satış'></th>
            <th><cf_get_lang dictionary_id='30081.Nakit Tahsilat'></th>
            <th><cf_get_lang dictionary_id='57836.Kredi Kartı Tahsilat'></th>
            <th><cf_get_lang dictionary_id='39894.Toplam Tahsilat'></th>
            <th><cf_get_lang dictionary_id='54880.Satış - Tahsilat Farkı'></th>
            <cfif x_show_cost_info eq 1>
                <th colspan="2"></th>
            </cfif>
        </tr>
   </thead>
   <tbody>
        <tr>
            <cfoutput>
                <td>#session.ep.money#</td>
                <td><div class="form-group"><input type="text" name="total_sale_amount" id="total_sale_amount" value="#TlFormat(0)#" style="width:100px;" class="moneybox" readonly="yes"></div></td>
                <td><div class="form-group"><input type="text" name="total_cash_amount" id="total_cash_amount" value="#TlFormat(0)#" style="width:100px;" class="moneybox" readonly="yes"></div></td>
                <td><div class="form-group"><input type="text" name="total_pos_amount" id="total_pos_amount" value="#TlFormat(0)#" style="width:100px;" class="moneybox" readonly="yes"></div></td>
                <td><div class="form-group"><input type="text" name="total_pay_amount" id="total_pay_amount" value="#TlFormat(0)#" style="width:100px;" class="moneybox" readonly="yes"></div></td>
                <td><div class="form-group"><input type="text" name="total_diff_amount" id="total_diff_amount" value="#TlFormat(0)#" style="width:100px;" class="moneybox" readonly="yes"></div></td>
                <cfif x_show_cost_info eq 1>
                    <td><cf_get_lang dictionary_id='61826.Gelir-Masraf Merkezi'></td>
                    <td><div class="form-group"><div class="input-group">
                        <input name="expense_center_id" id="expense_center_id" type="hidden" value="<cfoutput>#exp_center_id#</cfoutput>">
                        <cfinput name="expense_center" type="text" value="#exp_center_name#" style="width:160px;" readonly>
                        <span class="input-group-addon icon-ellipsis" onClick="openBoxDraggable('#request.self#?fuseaction=objects.popup_expense_center&field_name=form_basket.expense_center&field_id=form_basket.expense_center_id&is_invoice=1');"></span></div></div>
                    </td>
                </cfif>
            </cfoutput>
        </tr>
        <cfif len(session.ep.money2)>
            <tr>
                <cfoutput>
                    <td>#session.ep.money2#</td>
                    <td><div class="form-group"><input type="text" name="total_sale_amount2" id="total_sale_amount2" value="#TlFormat(0)#" style="width:100px;" class="moneybox" readonly="yes"></div></td>
                    <td><div class="form-group"><input type="text" name="total_cash_amount2" id="total_cash_amount2" value="#TlFormat(0)#" style="width:100px;" class="moneybox" readonly="yes"></div></td>
                    <td><div class="form-group"><input type="text" name="total_pos_amount2" id="total_pos_amount2" value="#TlFormat(0)#" style="width:100px;" class="moneybox" readonly="yes"></div></td>
                    <td><div class="form-group"><input type="text" name="total_pay_amount2" id="total_pay_amount2" value="#TlFormat(0)#" style="width:100px;" class="moneybox" readonly="yes"></div></td>
                    <td><div class="form-group"><input type="text" name="total_diff_amount2" id="total_diff_amount2" value="#TlFormat(0)#" style="width:100px;" class="moneybox" readonly="yes"></div></td>
                    <cfif x_show_cost_info eq 1>
                        <td><cf_get_lang dictionary_id='54682.Gelir-Gider Kalemleri'></td>
                        <td><div class="form-group"><div class="input-group">
                            <input type="hidden" name="expense_item_id" id="expense_item_id" value="<cfoutput>#exp_item_id#</cfoutput>">
                            <cfinput type="text" name="expense_item_name" value="#exp_item_name#" style="width:160px;" readonly>
                            <span class="input-group-addon icon-ellipsis" onClick="openBoxDraggable('#request.self#?fuseaction=objects.popup_list_exp_item&field_id=form_basket.expense_item_id&field_name=form_basket.expense_item_name');"></span></div></div>
                        </td>
                    </cfif>
                </cfoutput>
            </tr>
        </cfif>
     </tbody>
</cf_grid_list>
</cf_basket_form>
<script type="text/javascript">
	function genel_kontrol()
	{
		for(var g=1; g <=row_count_2; g++)
			pos_hesapla(g,1); //1 pos_hesapla fonksiyonundaki toplam tahsilat fonk. calismamasi icin
		for(var c=1; c <= form_basket.kur_say.value; c++)
			kasa_dovizi_hesapla(c,1); //1 kasa_dovizi_hesapla fonksiyonundaki toplam tahsilat fonk. calismamasi icin
		toplam_tahsilat();
	}
	genel_kontrol();
</script>
