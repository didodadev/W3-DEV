<cfoutput>
control_basket_extra_info_ = 0;
control_select_info_extra_ = 0;
control_basket_other_money_ = 0;
hidden_alan_icerik = '';
<cfloop from="1" to="#listlen(hidden_list,",")#" index="dli">
	<cfset element = ListGetAt(hidden_list,dli,",")>
	<cfswitch expression="#element#">
	<cfcase value="stock_code">
		hidden_alan_icerik += '<input type="hidden" id="stock_code" name="stock_code" value="' + stock_code + '">';
	</cfcase>
	<cfcase value="barcod">
		hidden_alan_icerik += '<input type="hidden" id="barcod" name="barcod" value="' + barcod + '">';
	</cfcase>
	<cfcase value="manufact_code">
		hidden_alan_icerik += '<input type="hidden" id="manufact_code" name="manufact_code" value="' + manufact_code + '">';
	</cfcase>
	<cfcase value="special_code">
		hidden_alan_icerik += '<input type="hidden" id="special_code" name="special_code" value="' + special_code + '">';
	</cfcase>
	<cfcase value="product_name">
		hidden_alan_icerik += '<input type="hidden" id="product_name" name="product_name" value="' + product_name + '">';
	</cfcase>
	<cfcase value="amount">
		hidden_alan_icerik += '<input type="hidden" id="amount" name="amount" value="' + amount_ + '">';
	</cfcase>
	<cfcase value="unit">
		hidden_alan_icerik+= '<input type="hidden" id="unit" name="unit" value="' + unit_ + '">';
	</cfcase>
	<cfcase value="spec">
		hidden_alan_icerik += '<input type="hidden" id="spect_id" name="spect_id" value="' + spect_id + '">';
		hidden_alan_icerik += '<input type="hidden" id="spect_name" name="spect_name" value="' + spect_name + '">';
	</cfcase>
	<cfcase value="list_price">
		hidden_alan_icerik += '<input type="hidden" id="list_price" name="list_price" value="' + list_price_ + '">';
	</cfcase>
	<cfcase value="list_price_discount">
		hidden_alan_icerik += '<input type="hidden" id="list_price_discount" name="list_price_discount" value="">';
	</cfcase>
	<cfcase value="tax_price">
		hidden_alan_icerik += '<input type="hidden" id="tax_price" name="tax_price" value="">';
	</cfcase>
	<cfcase value="price">
		hidden_alan_icerik += '<input type="hidden" id="price" name="price" value="' + price + '">';
	</cfcase>
	<cfcase value="price_other">
		hidden_alan_icerik += '<input type="hidden" id="price_other" name="price_other" value="' + price_other + '">';
	</cfcase>
	<cfcase value="price_net">
		hidden_alan_icerik += '<input type="hidden" id="price_net" name="price_net" value="' + wrk_round(price_net,price_round_number) + '">';
	</cfcase>
	<cfcase value="price_net_doviz">
		hidden_alan_icerik += '<input type="hidden" id="price_net_doviz" name="price_net_doviz" value="' + wrk_round(price_net_doviz,price_round_number) + '">';
	</cfcase>
	<cfcase value="tax">
		hidden_alan_icerik += '<input type="hidden" id="tax" name="tax" value="' + tax + '">';
	</cfcase>
	<cfcase value="OTV">
		hidden_alan_icerik += '<input type="hidden" id="otv_oran" name="otv_oran" value="' + otv + '">';
	</cfcase>
	<cfcase value="duedate">
		hidden_alan_icerik += '<input type="hidden" id="duedate" name="duedate" value="' + duedate + '">';
	</cfcase>
	<cfcase value="number_of_installment">
		hidden_alan_icerik += '<input type="hidden" id="number_of_installment" name="number_of_installment" value="' + number_of_installment + '">';
	</cfcase>
	<cfcase value="iskonto_tutar">
		hidden_alan_icerik += '<input type="hidden" id="iskonto_tutar" name="iskonto_tutar" value="' + iskonto_tutar + '">';
	</cfcase>
	<cfcase value="disc_ount">
		hidden_alan_icerik += '<input type="hidden" id="indirim1" name="indirim1" value="' + d1 + '">';
	</cfcase>
	<cfcase value="disc_ount2_">
		hidden_alan_icerik += '<input type="hidden" id="indirim2" name="indirim2"  value="' + d2 + '">';
	</cfcase>
	<cfcase value="disc_ount3_">
		hidden_alan_icerik += '<input type="hidden" id="indirim3" name="indirim3"  value="' + d3 + '">';
	</cfcase>
	<cfcase value="disc_ount4_">
		hidden_alan_icerik += '<input type="hidden" id="indirim4" name="indirim4"  value="' + d4 + '">';
	</cfcase>
	<cfcase value="disc_ount5_">
		hidden_alan_icerik += '<input type="hidden" id="indirim5" name="indirim5"  value="' + d5 + '">';
	</cfcase>
	<cfcase value="disc_ount6_">
		hidden_alan_icerik += '<input type="hidden" id="indirim6" name="indirim6"  value="' + d6 + '">';
	</cfcase>
	<cfcase value="disc_ount7_">
		hidden_alan_icerik += '<input type="hidden" id="indirim7" name="indirim7"  value="' + d7 + '">';
	</cfcase>
	<cfcase value="disc_ount8_">
		hidden_alan_icerik += '<input type="hidden" id="indirim8" name="indirim8"  value="' + d8 + '">';
	</cfcase>
	<cfcase value="disc_ount9_">
		hidden_alan_icerik += '<input type="hidden" id="indirim9" name="indirim9"  value="' + d9 + '">';
	</cfcase>
	<cfcase value="disc_ount10_">
		hidden_alan_icerik += '<input type="hidden" id="indirim10" name="indirim10"  value="' + d10 + '">';
	</cfcase>
	<cfcase value="row_total">
		hidden_alan_icerik += '<input type="hidden" id="row_total" name="row_total" value="' + wrk_round(price*amount_,price_round_number) + '">';
	</cfcase>
	<cfcase value="row_nettotal">
		hidden_alan_icerik += '<input type="hidden" id="row_nettotal" name="row_nettotal" value="' + net_total + '">';
	</cfcase>
	<cfcase value="row_taxtotal">
		hidden_alan_icerik += '<input type="hidden" id="row_taxtotal" name="row_taxtotal" value="' + row_tax_total + '">';
	</cfcase>
	<cfcase value="row_otvtotal">
		hidden_alan_icerik += '<input type="hidden" id="row_otvtotal" name="row_otvtotal" value="' + row_otv_total + '">';
	</cfcase>
	<cfcase value="row_lasttotal">
		hidden_alan_icerik += '<input type="hidden" id="row_lasttotal" name="row_lasttotal" value="' + (net_total+row_tax_total+row_otv_total) + '">';
	</cfcase>
	<cfcase value="other_money">
		hidden_alan_icerik += '<select id="other_money_" name="other_money_" style="display:none"><cfloop query="get_money_bskt"><option value="#money_type#">#money_type#</option></cfloop></select>';
		control_basket_other_money_ = 1;
	</cfcase>
	<cfcase value="other_money_value">
		hidden_alan_icerik += '<input type="hidden" id="other_money_value_" name="other_money_value_" value="'+wrk_round(other_money_value_,price_round_number)+ '">';
	</cfcase>
	<cfcase value="other_money_gross_total">
		hidden_alan_icerik += '<input type="hidden" id="other_money_gross_total" name="other_money_gross_total" value="'+wrk_round(other_money_value_*(100+(parseFloat(tax)+(parseFloat(otv)*parseFloat(tax)/100))+parseFloat(otv))/100,price_round_number)+'">';
	</cfcase>
	<cfcase value="deliver_date">
		hidden_alan_icerik += '<input type="hidden" id="deliver_date" name="deliver_date" value="' + deliver_date + '" maxlength="10">';
	</cfcase>
	<cfcase value="reserve_date">
		hidden_alan_icerik += '<input type="hidden" id="reserve_date" name="reserve_date" value="' + reserve_date + '" maxlength="10">';
	</cfcase>
	<cfcase value="deliver_dept">
		hidden_alan_icerik += '<input type="hidden" id="deliver_dept" name="deliver_dept" value="' + deliver_dept + '">';
		hidden_alan_icerik += '<input type="hidden" id="basket_row_departman" name="basket_row_departman" value="' + department_head + '">';
	</cfcase>
	<cfcase value="lot_no">
		hidden_alan_icerik += '<input type="hidden" id="lot_no" name="lot_no" value="' + lot_no + '">';
	</cfcase>
	<cfcase value="net_maliyet">
		hidden_alan_icerik += '<input type="hidden" id="net_maliyet" name="net_maliyet"  value="' + net_maliyet + '" >';
	</cfcase>
	<cfcase value="marj">
		hidden_alan_icerik += '<input type="hidden" id="marj" name="marj" value="' + flt_marj +'">';
	</cfcase>
	<cfcase value="extra_cost">
		hidden_alan_icerik += '<input type="hidden" id="extra_cost" name="extra_cost" value="' + extra_cost +'">';
	</cfcase>	
	<cfcase value="extra_cost_rate">
		hidden_alan_icerik += '<input type="hidden" id="extra_cost_rate" name="extra_cost_rate" value="">';
	</cfcase>
	<cfcase value="row_cost_total">
		hidden_alan_icerik +='<input type="hidden" id="row_cost_total" name="row_cost_total" value="">';
	</cfcase>
	<cfcase value="dara">
		hidden_alan_icerik += '<input type="hidden" id="dara" name="dara" value="0">';
	</cfcase>
	<cfcase value="darali">
		hidden_alan_icerik += '<input type="hidden" id="darali" name="darali" value="' + <cfif ListFindNoCase(display_list,"amount")>amount_<cfelse>1</cfif> + '">';
	</cfcase>
	<cfcase value="promosyon_yuzde">
		hidden_alan_icerik += '<input type="hidden" id="promosyon_yuzde" name="promosyon_yuzde" value="' + promosyon_yuzde +'">';
	</cfcase>
	<cfcase value="promosyon_maliyet">
		hidden_alan_icerik += '<input type="hidden" id="promosyon_maliyet" name="promosyon_maliyet" value="' + promosyon_maliyet +'">';
	</cfcase>
	<cfcase value="order_currency">
		hidden_alan_icerik += '<input type="hidden" id="order_currency" name="order_currency" value="-1">'; <!--- siparis asaması acık --->
	</cfcase>
	<cfcase value="reserve_type">
		if(form_basket.reserved!= undefined && form_basket.reserved.checked==true) <!--- siparis detaydaki reserve et secili ise satırlarda reserve olarak atanır --->
			temp_reserve_type = - 1;
		else
			 temp_reserve_type = - 3;
		hidden_alan_icerik += '<input type="hidden" id="reserve_type"  name="reserve_type" value="'+temp_reserve_type+'">'; <!--- rezerve degil olarak set ediliyor --->
	</cfcase>
	<cfcase value="product_name2">
		hidden_alan_icerik += ' <input type="hidden" id="product_name_other" name="product_name_other" value="">';
	</cfcase>
	<cfcase value="amount2">
		hidden_alan_icerik += '<input type="hidden" id="amount_other" name="amount_other" value="' + amount_other + '">';
	</cfcase>
	<cfcase value="unit2">
		hidden_alan_icerik += '<input type="hidden" id="unit_other" name="unit_other" value="">';
	</cfcase>
	<cfcase value="ek_tutar">
		hidden_alan_icerik += '<input type="hidden" id="ek_tutar" name="ek_tutar" value="' + ek_tutar + '">';
	</cfcase>
	<cfcase value="ek_tutar_other_total">
		hidden_alan_icerik += '<input type="hidden" id="ek_tutar_other_total" name="ek_tutar_other_total" value="' + ek_tutar_other_total + '">';
	</cfcase>
	<cfcase value="ek_tutar_price">
		hidden_alan_icerik += '<input type="hidden" id="ek_tutar_price"  name="ek_tutar_price" value="'+ ek_tutar_price +'">';
	</cfcase>
	<cfcase value="ek_tutar_cost">
		hidden_alan_icerik += '<input type="hidden" id="ek_tutar_cost" name="ek_tutar_cost" value="">';
	</cfcase>
	<cfcase value="ek_tutar_marj">
		hidden_alan_icerik += '<input type="hidden" id="ek_tutar_marj" name="ek_tutar_marj" value="">';
	</cfcase>
	<cfcase value="shelf_number">
		hidden_alan_icerik += '<input type="hidden" id="shelf_number" name="shelf_number" value="">';
		hidden_alan_icerik += '<input type="hidden" id="shelf_number_txt" name="shelf_number_txt" value="">';
	</cfcase>
	<cfcase value="shelf_number_2">
		hidden_alan_icerik += '<input type="hidden" id="to_shelf_number" name="to_shelf_number" value="">';
		hidden_alan_icerik += '<input type="hidden" id="to_shelf_number_txt" name="to_shelf_number_txt" value="">';
	</cfcase>
    <cfcase value="pbs_code">
		hidden_alan_icerik += '<input type="hidden" id="pbs_id" name="pbs_id" value="">';
		hidden_alan_icerik += '<input type="hidden" id="pbs_code" name="pbs_code" value="">';
	</cfcase>
	<cfcase value="basket_extra_info">
		hidden_alan_icerik += '<select id="basket_extra_info" name="basket_extra_info" style="display:none;"><cfloop list="#basket_info_list#" index="info_ii"><option value="#listfirst(info_ii,';')#">#listlast(info_ii,";")#</option></cfloop></select>';
		control_basket_extra_info_ = 1;
	</cfcase>
	<cfcase value="select_info_extra">
		hidden_alan_icerik += '<select id="select_info_extra" name="select_info_extra" style="display:none;"><cfloop list="#select_info_extra_list#" index="extra_ii"><option value="#listfirst(extra_ii,';')#">#listlast(extra_ii,";")#</option></cfloop></select>';
		control_select_info_extra_ = 1;
	</cfcase>
	<cfcase value="detail_info_extra">
		hidden_alan_icerik += ' <input type="hidden" id="detail_info_extra" name="detail_info_extra" value="">';
	</cfcase>
	<cfcase value="basket_employee">
		hidden_alan_icerik += '<input type="hidden" id="basket_employee_id" name="basket_employee_id" value="">';
		hidden_alan_icerik += '<input type="hidden" id="basket_employee" name="basket_employee" value="">';
	</cfcase>
	<cfcase value="row_width">
		hidden_alan_icerik += '<input type="hidden" id="row_width" name="row_width" value="' + row_width +'">';
	</cfcase>
	<cfcase value="row_depth">
		hidden_alan_icerik += '<input type="hidden" id="row_depth" name="row_depth" value="' + row_depth +'">';
	</cfcase>
	<cfcase value="row_height">
		hidden_alan_icerik += '<input type="hidden" id="row_height" name="row_height" value="' + row_height +'">';
	</cfcase>
	<cfcase value="basket_project">
		hidden_alan_icerik += '<input type="hidden" id="row_project_id" name="row_project_id" value="'+row_project_id+'">';
		hidden_alan_icerik += '<input type="hidden" id="row_project_name" name="row_project_name" value="'+row_project_name+'">';
	</cfcase>
    <cfcase value="basket_work">
    	hidden_alan_icerik += '<input type="hidden" id="row_work_id" name="row_work_id" value="'+row_work_id+'">';
		hidden_alan_icerik += '<input type="hidden" id="row_work_name" name="row_work_name" value="'+row_work_name+'">';
    </cfcase>
	<cfcase value="basket_exp_center">
		hidden_alan_icerik += '<input type="hidden" id="row_exp_center_id" name="row_exp_center_id" value="'+row_exp_center_id+'">';
		hidden_alan_icerik += '<input type="hidden" id="row_exp_center_name" name="row_exp_center_name" value="'+row_exp_center_name+'">';
	</cfcase>
    <cfcase value="basket_exp_item">
		hidden_alan_icerik += '<input type="hidden" id="row_exp_item_id" name="row_exp_item_id" value="'+row_exp_item_id+'">';
		hidden_alan_icerik += '<input type="hidden" id="row_exp_item_name" name="row_exp_item_name" value="'+row_exp_item_name+'">';
	</cfcase>
    <cfcase value="basket_acc_code">
		hidden_alan_icerik += '<input type="hidden" id="row_acc_code" name="row_acc_code" value="'+row_acc_code+'">';
	</cfcase>
	</cfswitch>
</cfloop>
newCell.innerHTML += hidden_alan_icerik;
if(control_basket_extra_info_ == '1')
	{
		if(basket_extra_info != undefined && basket_extra_info != '') <!--- ek acıklama id si gonderilmisse, ilgili tanım secili hale getiriliyor --->
		{
			if(document.all.product_id.length != undefined) 
				basket_extra_info_new = document.all.basket_extra_info[rowCount-1];
			else
				basket_extra_info_new = document.all.basket_extra_info;
			if(basket_extra_info_new.options.length != undefined)
			{
			for(var inf_count_=0; inf_count_ < basket_extra_info_new.options.length; inf_count_++)
				if(basket_extra_info_new.options[inf_count_].value == basket_extra_info)
					setSelectedIndex('basket_extra_info', rowCount-1, inf_count_);
			}
		}
	}
if(control_select_info_extra_ == '1')
	{
		if(select_info_extra != undefined && select_info_extra != '') <!--- ek acıklama 2 id si gonderilmisse, ilgili tanım secili hale getiriliyor --->
		{
			if(document.all.product_id.length != undefined) 
				select_info_extra_new = document.all.select_info_extra[rowCount-1];
			else
				select_info_extra_new = document.all.select_info_extra;
			if(select_info_extra_new.options.length != undefined)
			{
			for(var extr_count_=0; extr_count_ < select_info_extra_new.options.length; extr_count_++)
				if(select_info_extra_new.options[extr_count_].value == select_info_extra)
					setSelectedIndex('select_info_extra', rowCount-1, extr_count_);
			}
		}
	}
if(control_basket_other_money_ == '1')
	{
		for (var counter_temp=0; counter_temp < #get_money_bskt.recordcount#; counter_temp++)
			if (getIndexValue('other_money_', rowCount-1, counter_temp) == money)
				setSelectedIndex('other_money_', rowCount-1, counter_temp);
	}
</cfoutput>