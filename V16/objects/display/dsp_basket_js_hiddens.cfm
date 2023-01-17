<cfoutput>
<cfloop from="1" to="#listlen(hidden_list,",")#" index="dli">
	<cfset element = ListGetAt(hidden_list,dli,",")>
	<cfswitch expression="#element#">
		<cfcase value="stock_code">
			<input type="hidden" id="stock_code" name="stock_code" value="#sepet.satir[i].stock_code#">
		</cfcase>
		<cfcase value="barcod">
			<input type="hidden" id="barcod" name="barcod" value="#sepet.satir[i].barcode#">
		</cfcase>
		<cfcase value="special_code">
			<input type="hidden" id="special_code" name="special_code" value="#sepet.satir[i].special_code#">
		</cfcase>
		<cfcase value="manufact_code">
			<input type="hidden" id="manufact_code" name="manufact_code" value="#sepet.satir[i].manufact_code#">
		</cfcase>
		<cfcase value="product_name">
			<input type="hidden" id="product_name" name="product_name" value="#sepet.satir[i].product_name#">
		</cfcase>
		<cfcase value="amount">
			<input type="hidden" id="amount" name="amount" value="#AmountFormat(sepet.satir[i].amount,amount_round)#">
		</cfcase>
		<cfcase value="unit">
			<input type="hidden" id="unit" name="unit" value="#sepet.satir[i].unit#">
		</cfcase>			
		<cfcase value="spec">
			<input type="hidden" id="spect_id" name="spect_id" value="#sepet.satir[i].spect_id#">
			<input type="hidden" id="spect_name" name="spect_name" value="#sepet.satir[i].spect_name#">
		</cfcase>
		<cfcase value="list_price">
			<input type="hidden" id="list_price" name="list_price" value="<cfif StructKeyExists(sepet.satir[i],'list_price')>#TLFormat(sepet.satir[i].list_price,price_round_number)#</cfif>">
		</cfcase>
		<cfcase value="list_price_discount">
			<input type="hidden" id="list_price_discount" name="list_price_discount" value="">
		</cfcase>
		<cfcase value="tax_price">
			<input type="hidden" id="tax_price" name="tax_price" value="">
		</cfcase>
		<cfcase value="price">
			<input type="hidden" id="price" name="price" value="#TLFormat(sepet.satir[i].price,price_round_number)#">
		</cfcase>
		<cfcase value="price_other">
			<input type="hidden" id="price_other" name="price_other" value="#TLFormat(sepet.satir[i].price_other,price_round_number)#">
		</cfcase>
		<cfcase value="price_net">
			<cfset float_price_net = sepet.satir[i].row_nettotal/sepet.satir[i].amount>
			<input type="hidden" id="price_net" name="price_net" value="#TLFormat(float_price_net,price_round_number)#">
		</cfcase>
		<cfcase value="price_net_doviz">
			<cfset float_price_net_doviz = (sepet.satir[i].row_nettotal/sepet.satir[i].amount)*fl_total_2/fl_total>
			<input type="hidden" id="price_net_doviz" name="price_net_doviz" value="#TLFormat(float_price_net_doviz,price_round_number)#">
		</cfcase>
		<cfcase value="tax">
			<input type="hidden" id="tax" name="tax" value="#TLFormat(sepet.satir[i].tax_percent,0)#">
		</cfcase>
		<cfcase value="OTV">
			<input type="hidden" id="otv_oran" name="otv_oran" value="<cfif StructKeyExists(sepet.satir[i],'otv_oran')>#TLFormat(sepet.satir[i].otv_oran,0)#<cfelse>0</cfif>">
		</cfcase>
		<cfcase value="duedate">
			<input type="hidden" id="duedate" name="duedate" value="<cfif StructKeyExists(sepet.satir[i],'duedate')>#sepet.satir[i].duedate#</cfif>">
		</cfcase>
		<cfcase value="number_of_installment">
			<input type="hidden" id="number_of_installment" name="number_of_installment" value="<cfif StructKeyExists(sepet.satir[i],'number_of_installment')>#sepet.satir[i].number_of_installment#</cfif>">
		</cfcase>
		<!--- alt satırlardaki attributes.basket_id sonradan database den gelecek --->
		<cfcase value="iskonto_tutar">
			<input type="hidden" id="iskonto_tutar" name="iskonto_tutar" value="<cfif StructKeyExists(sepet.satir[i],'iskonto_tutar')>#TLFormat(sepet.satir[i].iskonto_tutar,price_round_number)#</cfif>">
		</cfcase>
		<cfcase value="disc_ount">
			<input type="hidden" id="indirim1" name="indirim1" value="#TLFormat(sepet.satir[i].indirim1)#">
		</cfcase>
		<cfcase value="disc_ount2_">
			<input type="hidden" id="indirim2" name="indirim2" value="#TLFormat(sepet.satir[i].indirim2)#">
		</cfcase>
		<cfcase value="disc_ount3_">
			<input type="hidden" id="indirim3" name="indirim3" value="#TLFormat(sepet.satir[i].indirim3)#">
		</cfcase>
		<cfcase value="disc_ount4_">
			<input type="hidden" id="indirim4" name="indirim4" value="#TLFormat(sepet.satir[i].indirim4)#">
		</cfcase>
		<cfcase value="disc_ount5_">
			<input type="hidden" id="indirim5" name="indirim5" value="#TLFormat(sepet.satir[i].indirim5)#">
		</cfcase>
		<cfcase value="disc_ount6_">
			<input type="hidden" id="indirim6" name="indirim6" value="#TLFormat(sepet.satir[i].indirim6)#">
		</cfcase>
		<cfcase value="disc_ount7_">
			<input type="hidden" id="indirim7" name="indirim7" value="#TLFormat(sepet.satir[i].indirim7)#">
		</cfcase>
		<cfcase value="disc_ount8_">
			<input type="hidden" id="indirim8" name="indirim8" value="#TLFormat(sepet.satir[i].indirim8)#">
		</cfcase>
		<cfcase value="disc_ount9_">
			<input type="hidden" id="indirim9" name="indirim9" value="#TLFormat(sepet.satir[i].indirim9)#">
		</cfcase>
		<cfcase value="disc_ount10_">
			<input type="hidden" id="indirim10" name="indirim10" value="#TLFormat(sepet.satir[i].indirim10)#">
		</cfcase>
		<cfcase value="row_total">
			<input type="hidden" id="row_total" name="row_total" value="#TLFormat(sepet.satir[i].row_total,price_round_number)#">
		</cfcase>
		<cfcase value="row_nettotal">
			<input type="hidden" id="row_nettotal" name="row_nettotal" value="#TLFormat(sepet.satir[i].row_nettotal,price_round_number)#">
		</cfcase>
		<cfcase value="row_taxtotal">
			<input type="hidden" id="row_taxtotal" name="row_taxtotal" value="#TLFormat(sepet.satir[i].row_taxtotal,price_round_number)#">
		</cfcase>
		<cfcase value="row_otvtotal">
			<input type="hidden" id="row_otvtotal" name="row_otvtotal" value="<cfif StructKeyExists(sepet.satir[i],'row_otvtotal')>#TLFormat(sepet.satir[i].row_otvtotal,price_round_number)#</cfif>">
		</cfcase>
		<cfcase value="row_lasttotal">
			<input type="hidden" id="row_lasttotal" name="row_lasttotal" value="#TLFormat(sepet.satir[i].row_lasttotal,price_round_number)#">
		</cfcase>
		<cfcase value="other_money">
        	<input type="hidden" id="other_money_" name="other_money_" value="<cfif StructKeyExists(sepet.satir[i],'other_money')>#sepet.satir[i].other_money#</cfif>">
		</cfcase>
		<cfcase value="other_money_value">
			<cfset fl_other_money = sepet.satir[i].row_nettotal*fl_total_2/fl_total>
			<!--- önceden sepet şablonunda olmayan yerlerde sonradan şablondan seçilme sorununa karşı --->
			<cfif fl_other_money is "">
				<cfset fl_other_money = sepet.satir[i].price>
			</cfif>
			<cfif StructKeyExists(sepet.satir[i],'otv_oran')>
				<cfif ListFindNoCase(display_list, "otv_from_tax_price")> <!--- kdv matrahına otv toplam ekleniyor --->
					<cfset sepet.satir[i].other_money_grosstotal = (fl_other_money*((sepet.satir[i].tax_percent + (sepet.satir[i].otv_oran*(sepet.satir[i].tax_percent/100)))+sepet.satir[i].otv_oran+100))/100>
				<cfelse>
					<cfset sepet.satir[i].other_money_grosstotal = (fl_other_money*(sepet.satir[i].tax_percent+sepet.satir[i].otv_oran+100))/100>
				</cfif>
			<cfelse>
				<cfset sepet.satir[i].other_money_grosstotal = (fl_other_money*(sepet.satir[i].tax_percent+100))/100>
			</cfif>
			<input type="hidden" id="other_money_value_" name="other_money_value_" value="#TLFormat(sepet.satir[i].other_money_value,price_round_number)#">
			<input type="hidden" id="other_money_gross_total" name="other_money_gross_total" value="#TLFormat(sepet.satir[i].other_money_grosstotal,price_round_number)#">
		</cfcase>
		<cfcase value="deliver_date">
			<input type="hidden" id="deliver_date" name="deliver_date" value="#sepet.satir[i].deliver_date#">
		</cfcase>
		<cfcase value="reserve_date">
			<input type="hidden" id="reserve_date" name="reserve_date" value="<cfif StructKeyExists(sepet.satir[i],'reserve_date')>#sepet.satir[i].reserve_date#</cfif>">
		</cfcase>
		<cfcase value="deliver_dept">
			<!--- FBS 20120406 hidden oldugunda value belgeden aldigi icin deger bos olmali, queryde bos ise belgenin degeri yaziliyor cunku <cfif len(sepet.satir[i].deliver_dept)>#sepet.satir[i].deliver_dept#</cfif> --->
			<input type="hidden" id="deliver_dept" name="deliver_dept" value="">
			<input type="hidden" id="basket_row_departman" name="basket_row_departman" value="">
		</cfcase>
		<cfcase value="lot_no">
			<input type="hidden" id="lot_no" name="lot_no" value="#sepet.satir[i].lot_no#">
		</cfcase>
        <cfcase value="pbs_code">
            <input type="hidden" id="pbs_id" name="pbs_id" value="<cfif StructKeyExists(sepet.satir[i],'pbs_id')>#sepet.satir[i].pbs_id#</cfif>">
            <input type="hidden" id="pbs_code" name="pbs_code" value="<cfif StructKeyExists(sepet.satir[i],'pbs_code')>#sepet.satir[i].pbs_code#</cfif>">
        </cfcase>
		<cfcase value="net_maliyet">
			<input type="hidden" id="net_maliyet" name="net_maliyet" value="<cfif StructKeyExists(sepet.satir[i],'net_maliyet')>#TLFormat(sepet.satir[i].net_maliyet,price_round_number)#</cfif>">
		</cfcase>
		<cfcase value="extra_cost">
			<input type="hidden" id="extra_cost" name="extra_cost" value="<cfif StructKeyExists(sepet.satir[i],'extra_cost')>#TLFormat(sepet.satir[i].extra_cost,price_round_number)#</cfif>">
		</cfcase>
		<cfcase value="extra_cost_rate">
			<input type="hidden" id="extra_cost_rate" name="extra_cost_rate" value=""></td>
		</cfcase> 
		<cfcase value="row_cost_total">
			<input type="hidden" id="row_cost_total" name="row_cost_total" value=""></td>
		</cfcase> 
		<cfcase value="marj">
			<input type="hidden" id="marj" name="marj" value="<cfif StructKeyExists(sepet.satir[i],'marj')>#TLFormat(sepet.satir[i].marj)#</cfif>">
		</cfcase> 
		<cfcase value="dara">
			<input type="hidden" id="dara" name="dara" value="<cfif StructKeyExists(sepet.satir[i],'dara')>#AmountFormat(sepet.satir[i].dara,amount_round)#</cfif>">
		</cfcase>
		<cfcase value="darali">
			<input type="hidden" id="darali" name="darali" value="<cfif StructKeyExists(sepet.satir[i],'darali')>#AmountFormat(sepet.satir[i].darali,amount_round)#</cfif>">
		</cfcase>
		<cfcase value="promosyon_yuzde">
			<input type="hidden" id="promosyon_yuzde" name="promosyon_yuzde" value="<cfif StructKeyExists(sepet.satir[i],'promosyon_yuzde')>#TLFormat(sepet.satir[i].promosyon_yuzde)#</cfif>">
		</cfcase>
		<cfcase value="promosyon_maliyet">
			<input type="hidden" id="promosyon_maliyet" name="promosyon_maliyet" value="<cfif StructKeyExists(sepet.satir[i],'promosyon_maliyet')>#TLFormat(sepet.satir[i].promosyon_maliyet,price_round_number)#</cfif>">
		</cfcase>
		<cfcase value="order_currency">
			<input type="hidden" id="order_currency" name="order_currency" value="<cfif StructKeyExists(sepet.satir[i],'order_currency')>#sepet.satir[i].order_currency#<cfelse>-1</cfif>"><!--- siparis asaması acık --->
		</cfcase>
		<cfcase value="reserve_type">
			<input type="hidden" id="reserve_type" name="reserve_type" value="<cfif StructKeyExists(sepet.satir[i],'reserve_type') and len(sepet.satir[i].reserve_type)>#sepet.satir[i].reserve_type#<cfelse>-1</cfif>"><!---sepet satırda tanımlı degilse rezerve olarak set ediliyor--->
		</cfcase>
		<cfcase value="product_name2">
			<input type="hidden" id="product_name_other" name="product_name_other" value="<cfif StructKeyExists(sepet.satir[i],'product_name_other') and len(sepet.satir[i].product_name_other)>#sepet.satir[i].product_name_other#</cfif>">
		</cfcase>
		<cfcase value="amount2">
			<input type="hidden" id="amount_other" name="amount_other" value="<cfif StructKeyExists(sepet.satir[i],'amount_other') and len(sepet.satir[i].amount_other)>#TLFormat(sepet.satir[i].amount_other,price_round_number)#</cfif>">
		</cfcase>
		<cfcase value="unit2">
			<input type="hidden" id="unit_other" name="unit_other" value="<cfif StructKeyExists(sepet.satir[i],'unit_other') and len(sepet.satir[i].unit_other)>#sepet.satir[i].unit_other#</cfif>" >
		</cfcase>	
		<cfcase value="ek_tutar">
			<input type="hidden" id="ek_tutar" name="ek_tutar" value="<cfif StructKeyExists(sepet.satir[i],'ek_tutar')>#TLFormat(sepet.satir[i].ek_tutar,price_round_number)#</cfif>">
		</cfcase>
		<cfcase value="ek_tutar_other_total">
			<input type="hidden" id="ek_tutar_other_total" name="ek_tutar_other_total" value="<cfif StructKeyExists(sepet.satir[i],'ek_tutar_other_total') and len(sepet.satir[i].ek_tutar_other_total)>#TLFormat(sepet.satir[i].ek_tutar_other_total,price_round_number)#</cfif>">
		</cfcase>
		<cfcase value="ek_tutar_price">
			<input type="hidden" id="ek_tutar_price" name="ek_tutar_price" value="<cfif StructKeyExists(sepet.satir[i],'ek_tutar_price')>#TLFormat(sepet.satir[i].ek_tutar_price,price_round_number)#</cfif>">
		</cfcase>
		<cfcase value="ek_tutar_cost">
			<input type="hidden" id="ek_tutar_cost" name="ek_tutar_cost" value="<cfif StructKeyExists(sepet.satir[i],'ek_tutar_cost')>#TLFormat(sepet.satir[i].ek_tutar_cost,price_round_number)#</cfif>">
		</cfcase>
		<cfcase value="ek_tutar_marj">
			<input type="hidden" id="ek_tutar_marj" name="ek_tutar_marj" value="<cfif StructKeyExists(sepet.satir[i],'ek_tutar_marj')>#TLFormat(sepet.satir[i].ek_tutar_marj,2)#</cfif>">
		</cfcase>
		<cfcase value="shelf_number">
			<input type="hidden" id="shelf_number" name="shelf_number" value="<cfif StructKeyExists(sepet.satir[i],'shelf_number')>#sepet.satir[i].shelf_number#</cfif>">
			<input type="hidden" id="shelf_number_txt" name="shelf_number_txt"  value="">
		</cfcase>			  
		<cfcase value="shelf_number_2">
			<input type="hidden" id="to_shelf_number" name="to_shelf_number" value="<cfif StructKeyExists(sepet.satir[i],'to_shelf_number')>#sepet.satir[i].to_shelf_number#</cfif>">
			<input type="hidden" id="to_shelf_number_txt" name="to_shelf_number_txt"  value="">
		</cfcase>			  
		<cfcase value="basket_extra_info">
        	<input type="hidden" id="basket_extra_info" name="basket_extra_info" value="<cfif StructKeyExists(sepet.satir[i],'basket_extra_info')>#sepet.satir[i].basket_extra_info#</cfif>">
		</cfcase>
		<cfcase value="select_info_extra">
        	<input type="hidden" id="select_info_extra" name="select_info_extra" value="<cfif StructKeyExists(sepet.satir[i],'select_info_extra')>#sepet.satir[i].select_info_extra#</cfif>">
		</cfcase>
		<cfcase value="detail_info_extra">
			<input type="hidden" id="detail_info_extra" name="detail_info_extra" value="<cfif StructKeyExists(sepet.satir[i],'detail_info_extra') and len(sepet.satir[i].detail_info_extra)>#sepet.satir[i].detail_info_extra#</cfif>">
		</cfcase>
		<cfcase value="basket_employee">
			<input type="hidden" id="basket_employee_id" name="basket_employee_id" value="<cfif StructKeyExists(sepet.satir[i],'basket_employee_id') and len(sepet.satir[i].basket_employee_id)>#sepet.satir[i].basket_employee_id#</cfif>">
			<input type="hidden" id="basket_employee" name="basket_employee" value="<cfif StructKeyExists(sepet.satir[i],'basket_employee') and len(sepet.satir[i].basket_employee)>#sepet.satir[i].basket_employee#</cfif>">
		</cfcase>
		<cfcase value="row_width">
			<input type="hidden" id="row_width" name="row_width" value="<cfif StructKeyExists(sepet.satir[i],'row_width') and len(sepet.satir[i].row_width)>#TLFormat(sepet.satir[i].row_width,0)#</cfif>">
		</cfcase>
		<cfcase value="row_depth">
			<input type="hidden" id="row_depth" name="row_depth" value="<cfif StructKeyExists(sepet.satir[i],'row_depth') and len(sepet.satir[i].row_depth)>#TLFormat(sepet.satir[i].row_depth,0)#</cfif>">
		</cfcase>
		<cfcase value="row_height">
			<input type="hidden" id="row_height" name="row_height" value="<cfif StructKeyExists(sepet.satir[i],'row_height') and len(sepet.satir[i].row_height)>#TLFormat(sepet.satir[i].row_height,0)#</cfif>">
		</cfcase>
		<cfcase value="basket_project">
			<input type="hidden" id="row_project_id" name="row_project_id" value="<cfif StructKeyExists(sepet.satir[i],'row_project_id') and len(sepet.satir[i].row_project_id)>#sepet.satir[i].row_project_id#</cfif>">
			<input type="hidden" id="row_project_name" name="row_project_name" value="<cfif StructKeyExists(sepet.satir[i],'row_project_name') and len(sepet.satir[i].row_project_name)>#sepet.satir[i].row_project_name#</cfif>" class="box" readonly='yes'>
		</cfcase>
		<cfcase value="basket_work">
			<input type="hidden" id="row_work_id" name="row_work_id" value="<cfif StructKeyExists(sepet.satir[i],'row_work_id') and len(sepet.satir[i].row_work_id)>#sepet.satir[i].row_work_id#</cfif>">
			<input type="hidden" id="row_work_name" name="row_work_name" value="<cfif StructKeyExists(sepet.satir[i],'row_work_name') and len(sepet.satir[i].row_work_name)>#sepet.satir[i].row_work_name#</cfif>" class="box" readonly='yes'>
		</cfcase>
        <cfcase value="basket_exp_center">
			<input type="hidden" id="row_exp_center_id" name="row_exp_center_id" value="<cfif StructKeyExists(sepet.satir[i],'row_exp_center_id') and len(sepet.satir[i].row_exp_center_id)>#sepet.satir[i].row_exp_center_id#</cfif>">
			<input type="hidden" id="row_exp_center_name" name="row_exp_center_name" value="<cfif StructKeyExists(sepet.satir[i],'row_exp_center_name') and len(sepet.satir[i].row_exp_center_name)>#sepet.satir[i].row_exp_center_name#</cfif>" class="box" readonly='yes'>
		</cfcase>
        <cfcase value="basket_exp_item">
			<input type="hidden" id="row_exp_item_id" name="row_exp_item_id" value="<cfif StructKeyExists(sepet.satir[i],'row_exp_item_id') and len(sepet.satir[i].row_exp_item_id)>#sepet.satir[i].row_exp_item_id#</cfif>">
			<input type="hidden" id="row_exp_item_name" name="row_exp_item_name" value="<cfif StructKeyExists(sepet.satir[i],'row_exp_item_name') and len(sepet.satir[i].row_exp_item_name)>#sepet.satir[i].row_exp_item_name#</cfif>" class="box" readonly='yes'>
		</cfcase>
        <cfcase value="basket_acc_code">
			<input type="hidden" id="row_acc_code" name="row_acc_code" value="<cfif StructKeyExists(sepet.satir[i],'row_acc_code') and len(sepet.satir[i].row_acc_code)>#sepet.satir[i].row_acc_code#</cfif>" class="box" readonly='yes'>
		</cfcase>
	</cfswitch>
</cfloop>
</cfoutput>
