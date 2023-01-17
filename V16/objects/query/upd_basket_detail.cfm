<cfset extendedList = ''>
<cfloop index="elementIndex" from="1" to="#listlen(form.fieldNames,',')#">
	<cfif listgetAt(form.fieldNames,elementIndex,',') contains 'extended_property' and not (listgetAt(form.fieldNames,elementIndex,',') contains '_GENISLIK' or listgetAt(form.fieldNames,elementIndex,',') contains '_SIRA')>
    	<cfset extendedList = listAppend(extendedList,listgetAt(form.fieldNames,elementIndex,','),',')>
    </cfif>
</cfloop>

<cfif isdefined("attributes.isAdd") and attributes.isAdd eq 1>
	<cfif cgi.referer contains 'form_copy_bskt_detail'>
        <cfset attributes.basket_id = attributes.MODULE_ID_>
    <cfelse>
        <cfset attributes.basket_id = attributes.basket_id>
    </cfif>
<cfelse>
	<cfset mod_id=attributes.BASKET_ID>
</cfif>

<cfif listfind("1,5,6,7,8,11,15,17,20,31,32,33,35,36,37,39,40,41,42,43,47,49",attributes.BASKET_ID)>
	<cfset bit_sale_purchase=0>
<cfelseif listfind("2,3,4,10,14,18,21,22,24,25,34,38,46,48,51,52,53",attributes.BASKET_ID)>
	<cfset bit_sale_purchase=1>
<cfelseif listfind("12,13,19",attributes.BASKET_ID)> 
	<cfset bit_sale_purchase=2>
<cfelseif listfind("26,28,29,44,45,50",attributes.BASKET_ID)> 
	<cfset bit_sale_purchase=3>
</cfif>
<!--- moduller yazilir.--->
<cfset module_str = "">
<cfset module_str_display = "">
<cfif not isdefined("attributes.module_content") or not  ListFind(attributes.module_content,'pbs_code')  >
	<cfset module_str=module_str & ",pbs_code"><cfelse><cfset module_str_display=ListAppend(module_str_display,"pbs_code",",")>
</cfif>
<cfif not isdefined("attributes.module_content") or not  ListFind(attributes.module_content,'product_name') >
	<cfset module_str=module_str & ",product_name"><cfelse><cfset module_str_display=ListAppend(module_str_display,"product_name",",")>
</cfif>
<cfif not isdefined("attributes.module_content") or not  ListFind(attributes.module_content,'product_name2') >
	<cfset module_str=module_str & ",product_name2"><cfelse><cfset module_str_display=ListAppend(module_str_display,"product_name2",",")>
</cfif>
<cfif not isdefined("attributes.module_content") or not  ListFind(attributes.module_content,'special_code') >
	<cfset module_str=module_str & ",special_code"><cfelse><cfset module_str_display=ListAppend(module_str_display,"special_code",",")>
</cfif>
<cfif not isdefined("attributes.module_content") or not ListFind(attributes.module_content,'ek_tutar') >
	<cfset module_str=module_str & ",ek_tutar"><cfelse><cfset module_str_display=ListAppend(module_str_display,"ek_tutar",",")>
</cfif>
<cfif not isdefined("attributes.module_content") or not ListFind(attributes.module_content,'ek_tutar_price') >
	<cfset module_str=module_str & ",ek_tutar_price"><cfelse><cfset module_str_display=ListAppend(module_str_display,"ek_tutar_price",",")>
</cfif>
<cfif not isdefined("attributes.module_content") or not ListFind(attributes.module_content,'ek_tutar_cost') >
	<cfset module_str=module_str & ",ek_tutar_cost"><cfelse><cfset module_str_display=ListAppend(module_str_display,"ek_tutar_cost",",")>
</cfif>
<cfif not isdefined("attributes.module_content") or not ListFind(attributes.module_content,'ek_tutar_marj') >
	<cfset module_str=module_str & ",ek_tutar_marj"><cfelse><cfset module_str_display=ListAppend(module_str_display,"ek_tutar_marj",",")>
</cfif>
<cfif not isdefined("attributes.module_content") or not ListFind(attributes.module_content,'ek_tutar_other_total') >
	<cfset module_str=module_str & ",ek_tutar_other_total"><cfelse><cfset module_str_display=ListAppend(module_str_display,"ek_tutar_other_total",",")>
</cfif>
<cfif not isdefined("attributes.module_content") or not  ListFind(attributes.module_content,'manufact_code')  >
	<cfset module_str=module_str & ",manufact_code"><cfelse><cfset module_str_display=ListAppend(module_str_display,"manufact_code",",")>
</cfif>
<cfif not isdefined("attributes.module_content") or not ListFind(attributes.module_content,'stock_code')  >
	<cfset module_str=module_str & ",stock_code"><cfelse><cfset module_str_display=ListAppend(module_str_display,"stock_code",",")>
</cfif>
<cfif not isdefined("attributes.module_content") or not  ListFind(attributes.module_content,'Barcod')>
	<cfset module_str=module_str & ",Barcod"><cfelse><cfset module_str_display=ListAppend(module_str_display,"Barcod",",")>
</cfif>
<cfif not isdefined("attributes.module_content") or not ListFind(attributes.module_content,'spec') >
	<cfset module_str=module_str & ",spec"><cfelse> <cfset module_str_display=ListAppend(module_str_display,"spec",",")>
</cfif>
<cfif not isdefined("attributes.module_content") or not ListFind(attributes.module_content,'is_promotion') >
	<cfset module_str=module_str & ",is_promotion"><cfelse><cfset module_str_display=ListAppend(module_str_display,"is_promotion",",")>
</cfif>
<cfif not isdefined("attributes.module_content") or not ListFind(attributes.module_content,'is_specific_weight') >
	<cfset module_str=module_str & ",is_specific_weight"><cfelse><cfset module_str_display=ListAppend(module_str_display,"is_specific_weight",",")>
</cfif>
<cfif not isdefined("attributes.module_content") or not ListFind(attributes.module_content,'use_configurator') >
	<cfset module_str=module_str & ",use_configurator"><cfelse><cfset module_str_display=ListAppend(module_str_display,"use_configurator",",")>
</cfif>
<cfif not isdefined("attributes.module_content") or not ListFind(attributes.module_content,'iskonto_tutar') >
	<cfset module_str=module_str & ",iskonto_tutar"><cfelse><cfset module_str_display=ListAppend(module_str_display,"iskonto_tutar",",")>
</cfif>
<cfif not isdefined("attributes.module_content") or not ListFind(attributes.module_content,'disc_ount') >
	<cfset dis_kontrol1=1>
	<cfset module_str=module_str & ",disc_ount"><cfelse><cfset module_str_display=ListAppend(module_str_display,"disc_ount",",")>
</cfif>
<cfif isdefined("dis_kontrol1")or  not ListFind(attributes.module_content,'disc_ount2_')>
	<cfset dis_kontrol2=2>	
    <cfset module_str=module_str & ",disc_ount2_"><cfelse><cfset module_str_display=ListAppend(module_str_display,"disc_ount2_",",")>
</cfif>
<cfif isdefined("dis_kontrol1") or  isdefined("dis_kontrol2") or not ListFind(attributes.module_content,'disc_ount3_')>
	<cfset dis_kontrol3=1>
    <cfset module_str=module_str & ",disc_ount3_"><cfelse><cfset module_str_display=ListAppend(module_str_display,"disc_ount3_",",")>
</cfif>
<cfif isdefined("dis_kontrol1") or isdefined("dis_kontrol2") or  isdefined("dis_kontrol3") or not ListFind(attributes.module_content,'disc_ount4_') >
	<cfset dis_kontrol4=1>
    <cfset module_str=module_str & ",disc_ount4_"><cfelse><cfset module_str_display=ListAppend(module_str_display,"disc_ount4_",",")>
</cfif>
<cfif isdefined("dis_kontrol4")  or not ListFind(attributes.module_content,'disc_ount5_') >
	<cfset dis_kontrol5 = 1 >
    <cfset module_str=module_str & ",disc_ount5_">
<cfelse>
	<cfset module_str_display=ListAppend(module_str_display,"disc_ount5_",",")>
</cfif>
<cfif isdefined("dis_kontrol5")  or not ListFind(attributes.module_content,'disc_ount6_') >
	<cfset dis_kontrol6 = 1 >
    <cfset module_str=module_str & ",disc_ount6_">
<cfelse>
	<cfset module_str_display=ListAppend(module_str_display,"disc_ount6_",",")>
</cfif>
<cfif isdefined("dis_kontrol6")  or not ListFind(attributes.module_content,'disc_ount7_') >
	<cfset dis_kontrol7 = 1 >
    <cfset module_str=module_str & ",disc_ount7_">
<cfelse>
	<cfset module_str_display=ListAppend(module_str_display,"disc_ount7_",",")>
</cfif>
<cfif isdefined("dis_kontrol7")  or not ListFind(attributes.module_content,'disc_ount8_') >
	<cfset dis_kontrol8 = 1 >
	<cfset module_str = module_str & ",disc_ount8_">
<cfelse>
	<cfset module_str_display=ListAppend(module_str_display,"disc_ount8_",",")>
</cfif>
<cfif isdefined("dis_kontrol8")  or not ListFind(attributes.module_content,'disc_ount9_') >
	<cfset dis_kontrol9 = 1 >
	<cfset module_str = module_str & ",disc_ount9_">
<cfelse>
	<cfset module_str_display=ListAppend(module_str_display,"disc_ount9_",",")>
</cfif>
<cfif isdefined("dis_kontrol9")  or not ListFind(attributes.module_content,'disc_ount10_') >
	<cfset module_str=module_str & ",disc_ount10_">
<cfelse>
	<cfset module_str_display=ListAppend(module_str_display,"disc_ount10_",",")>
</cfif>
<cfif not isdefined("attributes.module_content") or not ListFind(attributes.module_content,'Amount')>
	<cfset module_str=module_str & ",Amount"><cfelse><cfset module_str_display=ListAppend(module_str_display,"Amount",",")>
</cfif>
<cfif not isdefined("attributes.module_content") or not ListFind(attributes.module_content,'Amount2')>
	<cfset module_str=module_str & ",Amount2"><cfelse><cfset module_str_display=ListAppend(module_str_display,"Amount2",",")>
</cfif>
<cfif not isdefined("attributes.module_content") or not ListFind(attributes.module_content,'List_price')>
	  <cfset module_str=module_str & ",List_price">
	  <cfset int_list_price = 0> 
<cfelse>
	<cfset module_str_display=ListAppend(module_str_display,"List_price",",")>
	<cfset int_list_price = 1>
</cfif>
<cfif int_list_price eq 0 or not isdefined("attributes.module_content") or not ListFind(attributes.module_content,'list_price_discount')> <!--- liste fiyatı secilmemisse liste fiyatı iskontosu da display liste secilemez --->
	<cfset module_str=module_str & ",list_price_discount"><cfelse><cfset module_str_display=ListAppend(module_str_display,"list_price_discount",",")>
</cfif>
<cfif not isdefined("attributes.module_content") or not ListFind(attributes.module_content,'Price')>
	<cfset module_str=module_str & ",Price">
	<cfset int_price = 0>
<cfelse>
	<cfset module_str_display=ListAppend(module_str_display,"Price",",")>
	<cfset int_price = 1>
</cfif>
<cfif not isdefined("attributes.module_content") or not ListFind(attributes.module_content,'tax_price')>
	<cfset module_str=module_str & ",tax_price">
<cfelse>
	<cfset module_str_display=ListAppend(module_str_display,"tax_price",",")>
</cfif>
<cfif not isdefined("attributes.module_content")  or not ListFind(attributes.module_content,'Tax')>
	<cfset int_control_tax=1>
	<cfset int_kdv = 0>
	<cfset module_str=module_str & ",Tax">
<cfelse>
	<cfset int_kdv = 1>
	<cfset module_str_display=ListAppend(module_str_display,"Tax",",")>
</cfif>
<cfif not isdefined("attributes.module_content") or  not ListFind(attributes.module_content,'price_other') >
	<cfset module_str=module_str & ",price_other">
	<cfset int_price_other=0>		
<cfelse>
	<cfset module_str_display=ListAppend(module_str_display,"price_other",",")> 
	<cfset int_price_other=1>
</cfif>
<cfif not isdefined("attributes.module_content")  or not ListFind(attributes.module_content,'Unit')>
	<cfset module_str=module_str & ",Unit"><cfelse><cfset module_str_display=ListAppend(module_str_display,"Unit",",")>
</cfif>
<cfif not isdefined("attributes.module_content")  or not ListFind(attributes.module_content,'Unit2')>
	<cfset module_str=module_str & ",Unit2"><cfelse><cfset module_str_display=ListAppend(module_str_display,"Unit2",",")>
</cfif>
<cfif not isdefined("attributes.module_content")  or not ListFind(attributes.module_content,'number_of_installment')  >
	<cfset module_str=module_str & ",number_of_installment"><cfelse><cfset module_str_display=ListAppend(module_str_display,"number_of_installment",",")>
</cfif>
<cfif not isdefined("attributes.module_content")  or not ListFind(attributes.module_content,'Duedate')  >
	<cfset module_str=module_str & ",Duedate"><cfelse><cfset module_str_display=ListAppend(module_str_display,"Duedate",",")>
</cfif>
<cfif not isdefined("attributes.module_content") or not ListFind(attributes.module_content,'is_member_selected') >
	<cfset module_str = module_str & ",is_member_selected"><cfelse><cfset module_str_display=ListAppend(module_str_display,"is_member_selected",",")>
</cfif>
<cfif not isdefined("attributes.module_content") or not ListFind(attributes.module_content,'deliver_date') >
	<cfset module_str=module_str & ",deliver_date"><cfelse><cfset module_str_display=ListAppend(module_str_display,"deliver_date",",")>
</cfif>
<cfif not isdefined("attributes.module_content") or not ListFind(attributes.module_content,'shelf_number') >
	<cfset module_str=module_str & ",shelf_number"><cfelse><cfset module_str_display=ListAppend(module_str_display,"shelf_number",",")>
</cfif>
<cfif not isdefined("attributes.module_content") or not ListFind(attributes.module_content,'shelf_number_2') >
	<cfset module_str=module_str & ",shelf_number_2"><cfelse><cfset module_str_display=ListAppend(module_str_display,"shelf_number_2",",")>
</cfif>
<cfif not isdefined("attributes.module_content")  or not ListFind(attributes.module_content,'deliver_dept') >
	<cfset module_str=module_str & ",deliver_dept">
<cfelse>
	<cfset deliver_dept_selected=1>
    <cfset module_str_display=ListAppend(module_str_display,"deliver_dept",",")>
</cfif>
<cfif isdefined("deliver_dept_selected") or not isdefined("attributes.module_content") or not ListFind(attributes.module_content,'deliver_dept_assortment') >
	<cfset module_str=module_str & ",deliver_dept_assortment"><cfelse><cfset module_str_display=ListAppend(module_str_display,"deliver_dept_assortment",",")>
</cfif>
<cfif not isdefined("attributes.module_content") or not ListFind(attributes.module_content,'is_price_total_other_money') >
	<cfset module_str = module_str & ",is_price_total_other_money"><cfelse><cfset module_str_display=ListAppend(module_str_display,"is_price_total_other_money",",")>
</cfif>
<cfif not isdefined("attributes.module_content") or not ListFind(attributes.module_content,'is_amount_total') >
	<cfset module_str = module_str & ",is_amount_total"><cfelse><cfset module_str_display=ListAppend(module_str_display,"is_amount_total",",")>
</cfif>
<cfif not isdefined("attributes.module_content") or not ListFind(attributes.module_content,'is_paper_discount') >
	<cfset module_str = module_str & ",is_paper_discount"><cfelse><cfset module_str_display=ListAppend(module_str_display,"is_paper_discount",",")>
</cfif>
<cfif not isdefined("attributes.module_content") or not ListFind(attributes.module_content,'barcode_price_list') >
	<cfset module_str = module_str & ",barcode_price_list"><cfelse><cfset module_str_display=ListAppend(module_str_display,"barcode_price_list",",")>
</cfif>
<cfif not isdefined("attributes.module_content") or not ListFind(attributes.module_content,'barcode_amount') >
	<cfset module_str = module_str & ",barcode_amount"><cfelse><cfset module_str_display=ListAppend(module_str_display,"barcode_amount",",")>
</cfif>
<cfif not isdefined("attributes.module_content") or not ListFind(attributes.module_content,'barcode_amount_2') >
	<cfset module_str = module_str & ",barcode_amount_2"><cfelse><cfset module_str_display=ListAppend(module_str_display,"barcode_amount_2",",")>
</cfif>
<cfif not isdefined("attributes.module_content") or not ListFind(attributes.module_content,'barcode_stock_code') >
	<cfset module_str = module_str & ",barcode_stock_code"><cfelse><cfset module_str_display=ListAppend(module_str_display,"barcode_stock_code",",")>
</cfif>
<cfif not isdefined("attributes.module_content") or not ListFind(attributes.module_content,'barcode_barcode') >
	<cfset module_str = module_str & ",barcode_barcode"><cfelse><cfset module_str_display=ListAppend(module_str_display,"barcode_barcode",",")>
</cfif>
<cfif not isdefined("attributes.module_content") or not ListFind(attributes.module_content,'barcode_serial_no') >
	<cfset module_str = module_str & ",barcode_serial_no"><cfelse><cfset module_str_display=ListAppend(module_str_display,"barcode_serial_no",",")>
</cfif>
<cfif not isdefined("attributes.module_content") or not ListFind(attributes.module_content,'barcode_lot_no') >
	<cfset module_str = module_str & ",barcode_lot_no"><cfelse><cfset module_str_display=ListAppend(module_str_display,"barcode_lot_no",",")>
</cfif>
<cfif not isdefined("attributes.module_content") or not ListFind(attributes.module_content,'barcode_choose_row') >
	<cfset module_str = module_str & ",barcode_choose_row"><cfelse><cfset module_str_display=ListAppend(module_str_display,"barcode_choose_row",",")>
</cfif>
<cfif not isdefined("attributes.module_content") or not ListFind(attributes.module_content,'basket_acc_code') >
	<cfset module_str=module_str & ",basket_acc_code"><cfelse><cfset module_str_display=ListAppend(module_str_display,"basket_acc_code",",")> 
</cfif>
<cfif not isdefined("attributes.module_content") or not ListFind(attributes.module_content,'basket_exp_item') >
	<cfset module_str=module_str & ",basket_exp_item"><cfelse><cfset module_str_display=ListAppend(module_str_display,"basket_exp_item",",")> 
</cfif>
<cfif not isdefined("attributes.module_content") or not ListFind(attributes.module_content,'basket_exp_center') >
	<cfset module_str=module_str & ",basket_exp_center"><cfelse><cfset module_str_display=ListAppend(module_str_display,"basket_exp_center",",")> 
</cfif>
<cfif not isdefined("attributes.module_content") or not  ListFind(attributes.module_content,'basket_work') >
	<cfset module_str=module_str & ",basket_work"><cfelse><cfset module_str_display=ListAppend(module_str_display,"basket_work",",")>
</cfif>
<cfif not isdefined("attributes.module_content") or not  ListFind(attributes.module_content,'basket_project') >
	<cfset module_str=module_str & ",basket_project"><cfelse><cfset module_str_display=ListAppend(module_str_display,"basket_project",",")>
</cfif>
<cfif not isdefined("attributes.module_content") or  not ListFind(attributes.module_content,'row_height') >
	<cfset module_str=module_str & ",row_height"><cfelse><cfset module_str_display=ListAppend(module_str_display,"row_height",",")> 
</cfif>
<cfif not isdefined("attributes.module_content") or  not ListFind(attributes.module_content,'row_depth') >
	<cfset module_str=module_str & ",row_depth"><cfelse><cfset module_str_display=ListAppend(module_str_display,"row_depth",",")> 
</cfif>
<cfif not isdefined("attributes.module_content") or  not ListFind(attributes.module_content,'row_width') >
	<cfset module_str=module_str & ",row_width"><cfelse><cfset module_str_display=ListAppend(module_str_display,"row_width",",")> 
</cfif>
<cfif not isdefined("attributes.module_content") or not  ListFind(attributes.module_content,'basket_extra_info') >
	<cfset module_str=module_str & ",basket_extra_info"><cfelse><cfset module_str_display=ListAppend(module_str_display,"basket_extra_info",",")>
</cfif>
<cfif not isdefined("attributes.module_content") or not  ListFind(attributes.module_content,'select_info_extra') >
	<cfset module_str=module_str & ",select_info_extra"><cfelse><cfset module_str_display=ListAppend(module_str_display,"select_info_extra",",")>
</cfif>
<cfif not isdefined("attributes.module_content") or not  ListFind(attributes.module_content,'detail_info_extra') >
	<cfset module_str=module_str & ",detail_info_extra"><cfelse><cfset module_str_display=ListAppend(module_str_display,"detail_info_extra",",")>
</cfif>
<cfif not isdefined("attributes.module_content") or  not ListFind(attributes.module_content,'basket_employee') >
	<cfset module_str=module_str & ",basket_employee"><cfelse><cfset module_str_display=ListAppend(module_str_display,"basket_employee",",")> 
</cfif>
<cfif not isdefined("attributes.module_content") or not  ListFind(attributes.module_content,'reserve_date') >
	<cfset module_str=module_str & ",reserve_date"><cfelse><cfset module_str_display=ListAppend(module_str_display,"reserve_date",",")>
</cfif>
<cfif not isdefined("attributes.module_content") or not  ListFind(attributes.module_content,'reserve_type') >
	<cfset module_str=module_str & ",reserve_type"><cfelse><cfset module_str_display=ListAppend(module_str_display,"reserve_type",",")>
</cfif>
<cfif not isdefined("attributes.module_content") or not  ListFind(attributes.module_content,'order_currency') >
	<cfset module_str=module_str & ",order_currency"><cfelse><cfset module_str_display=ListAppend(module_str_display,"order_currency",",")>
</cfif>
<cfif not isdefined("attributes.module_content") or not  ListFind(attributes.module_content,'promosyon_maliyet') >
	<cfset module_str=module_str & ",promosyon_maliyet"><cfelse><cfset module_str_display=ListAppend(module_str_display,"promosyon_maliyet",",")>
</cfif>
<cfif not isdefined("attributes.module_content") or not  ListFind(attributes.module_content,'promosyon_yuzde') >
	<cfset module_str=module_str & ",promosyon_yuzde"><cfelse><cfset module_str_display=ListAppend(module_str_display,"promosyon_yuzde",",")>
</cfif>
<cfif not isdefined("attributes.module_content") or  not ListFind(attributes.module_content,'row_cost_total') >
	<cfset module_str=module_str & ",row_cost_total"><cfelse><cfset module_str_display=ListAppend(module_str_display,"row_cost_total",",")> 
</cfif>
<cfif not isdefined("attributes.module_content") or  not ListFind(attributes.module_content,'extra_cost_rate') >
	<cfset module_str=module_str & ",extra_cost_rate"><cfelse><cfset module_str_display=ListAppend(module_str_display,"extra_cost_rate",",")> 
</cfif>
<cfif not isdefined("attributes.module_content") or  not ListFind(attributes.module_content,'extra_cost') >
	<cfset module_str=module_str & ",extra_cost"><cfelse><cfset module_str_display=ListAppend(module_str_display,"extra_cost",",")> 
</cfif>
<cfif not isdefined("attributes.module_content") or  not ListFind(attributes.module_content,'marj') >
	<cfset module_str=module_str & ",marj"><cfelse><cfset module_str_display=ListAppend(module_str_display,"marj",",")> 
</cfif>
<cfif not isdefined("attributes.module_content") or  not ListFind(attributes.module_content,'darali') >
	<cfset module_str=module_str & ",darali"><cfelse><cfset module_str_display=ListAppend(module_str_display,"darali",",")> 
</cfif>
<cfif not isdefined("attributes.module_content") or  not ListFind(attributes.module_content,'dara') >
	<cfset module_str=module_str & ",dara"><cfelse><cfset module_str_display=ListAppend(module_str_display,"dara",",")> 
</cfif>
<cfif not isdefined("attributes.module_content") or  not ListFind(attributes.module_content,'net_maliyet') >
	<cfset module_str=module_str & ",net_maliyet"><cfelse><cfset module_str_display=ListAppend(module_str_display,"net_maliyet",",")> 
</cfif>
<cfif int_price_other eq 0 or not isdefined("attributes.module_content") or isdefined("is_other_money")><!--- or  (not ListFind(attributes.module_content,'other_money_gross_total') ) --->
	<cfset module_str=module_str & ",other_money_gross_total"><cfelse><cfset module_str_display=ListAppend(module_str_display,"other_money_gross_total",",")> 
</cfif>
<cfif not isdefined("attributes.module_content") or  not ListFind(attributes.module_content,'zero_stock_control_date')>
	<cfset module_str=module_str & ",zero_stock_control_date"><cfelse><cfset module_str_display=ListAppend(module_str_display,"zero_stock_control_date",",")> 
</cfif>
<cfif not isdefined("attributes.module_content") or  not ListFind(attributes.module_content,'zero_stock_status') >
	<cfset module_str=module_str & ",zero_stock_status"><cfelse><cfset module_str_display=ListAppend(module_str_display,"zero_stock_status",",")> 
</cfif>
<cfif int_price_other eq 0 or not isdefined("attributes.module_content") or not ListFind(attributes.module_content,'price_net_doviz') >
	<cfset module_str=module_str & ",price_net_doviz"><cfelse><cfset module_str_display=ListAppend(module_str_display,"price_net_doviz",",")>
</cfif>
<cfif not isdefined("attributes.module_content") or  not ListFind(attributes.module_content,'price_net')  >
	<cfset module_str=module_str & ",price_net"><cfelse><cfset module_str_display=ListAppend(module_str_display,"price_net",",")>
</cfif>
<cfif not isdefined("attributes.module_content") or  not ListFind(attributes.module_content,'otv_from_tax_price') >
	<cfset module_str=module_str & ",otv_from_tax_price"><cfelse><cfset module_str_display=ListAppend(module_str_display,"otv_from_tax_price",",")>
</cfif>
<cfif not isdefined("attributes.module_content") or  not ListFind(attributes.module_content,'is_installment') >
	<cfset module_str=module_str & ",is_installment"><cfelse><cfset module_str_display=ListAppend(module_str_display,"is_installment",",")>
</cfif>
<cfif not isdefined("attributes.module_content") or  not ListFind(attributes.module_content,'is_cash_pos') >
	<cfset module_str=module_str & ",is_cash_pos"><cfelse><cfset module_str_display=ListAppend(module_str_display,"is_cash_pos",",")>
</cfif>
<cfif not isdefined("attributes.module_content") or  not ListFind(attributes.module_content,'is_risc') >
	<cfset module_str=module_str & ",is_risc"><cfelse><cfset module_str_display=ListAppend(module_str_display,"is_risc",",")>
</cfif>
<cfif not isdefined("attributes.module_content") or  not ListFind(attributes.module_content,'is_serialno_guaranty') >
	<cfset module_str=module_str & ",is_serialno_guaranty"><cfelse><cfset module_str_display=ListAppend(module_str_display,"is_serialno_guaranty",",")>
</cfif>
<cfif not isdefined("attributes.module_content") or  not ListFind(attributes.module_content,'lot_no') >
	<cfset module_str = module_str & ",lot_no"><cfelse><cfset module_str_display=ListAppend(module_str_display,"lot_no",",")>
</cfif>
<cfif not isdefined("attributes.module_content") or  not ListFind(attributes.module_content,'is_project_not_change')>
	<cfset module_str = module_str & ",is_project_not_change"><cfelse><cfset module_str_display=ListAppend(module_str_display,"is_project_not_change",",")>
</cfif>
<cfif not isdefined("attributes.module_content") or  not ListFind(attributes.module_content,'is_member_not_change')>
	<cfset module_str = module_str & ",is_member_not_change"><cfelse><cfset module_str_display=ListAppend(module_str_display,"is_member_not_change",",")>
</cfif>
<cfif int_price_other eq 0 or not isdefined("attributes.module_content") or not ListFind(attributes.module_content,'other_money') >
	<cfset module_str = module_str & ",other_money"><cfelse><cfset module_str_display=ListAppend(module_str_display,"other_money",",")>
</cfif>		
<cfif int_price_other eq 0 or  not isdefined("attributes.module_content")  or not ListFind(attributes.module_content,'other_money_value') >
	<cfset is_other_money = 1 >
	<cfset module_str = module_str & ",other_money_value" ><cfelse><cfset module_str_display = ListAppend(module_str_display,"other_money_value",",") >
</cfif>
<cfif not isdefined("attributes.module_content") or not ListFind(attributes.module_content,'is_project_selected') >
	<cfset module_str = module_str & ",is_project_selected"><cfelse><cfset module_str_display=ListAppend(module_str_display,"is_project_selected",",")>
</cfif>
<cfif not isdefined("attributes.module_content") or  not ListFind(attributes.module_content,'check_row_discounts') >
	<cfset module_str = module_str & ",check_row_discounts"><cfelse><cfset module_str_display=ListAppend(module_str_display,"check_row_discounts",",")>
</cfif>
<cfif not isdefined("attributes.module_content") or not ListFind(attributes.module_content,'is_use_add_unit') >
	<cfset module_str = module_str & ",is_use_add_unit"><cfelse><cfset module_str_display=ListAppend(module_str_display,"is_use_add_unit",",")>
</cfif>
<cfif int_kdv eq 0 or (int_price eq 0 and int_list_price eq 0) or not isdefined("attributes.module_content") or not ListFind(attributes.module_content,'price_total') >
	<cfset module_str=module_str & ",price_total"><cfelse><cfset module_str_display=ListAppend(module_str_display,"price_total",",")>
</cfif>
<cfif int_price eq 0 or not isdefined("attributes.module_content") or not ListFind(attributes.module_content,'row_nettotal') >
	<cfset module_str=module_str & ",row_nettotal">
    <cfset int_nettotal = 0 >
<cfelse>
	<cfset int_nettotal = 1 >
    <cfset module_str_display=ListAppend(module_str_display,"row_nettotal",",")>
</cfif>
<cfif int_nettotal eq 0 or int_kdv eq 0 or not isdefined("attributes.module_content") or not ListFind(attributes.module_content,'row_lasttotal')  >
	<cfset module_str=module_str & ",row_lasttotal"><cfelse><cfset module_str_display=ListAppend(module_str_display,"row_lasttotal",",")>
</cfif>
<cfif int_price eq 0 or not isdefined("attributes.module_content") or not ListFind(attributes.module_content,'row_total')>
	<cfset module_str=module_str & ",row_total"><cfelse><cfset module_str_display=ListAppend(module_str_display,"row_total",",")>
</cfif>
<cfif not isdefined("attributes.module_content")  or not ListFind(attributes.module_content,'OTV')  >
	<cfset int_control_otv=1>
    <cfset int_otv = 0>
    <cfset module_str=module_str & ",OTV">
<cfelse>
	<cfset int_otv = 1>
    <cfset module_str_display=ListAppend(module_str_display,"OTV",",")>
</cfif>
<cfif int_kdv eq 0 or int_price eq 0 or not isdefined("attributes.module_content") or (not ListFind(attributes.module_content,'row_taxtotal') or isdefined("int_control_tax"))>
	<cfset module_str=module_str & ",row_taxtotal">
    <cfset bool_kdv_all=0>
<cfelse>
	<cfset bool_kdv_all=1>
    <cfset module_str_display=ListAppend(module_str_display,"row_taxtotal",",")>
</cfif>
<cfif  int_otv eq 0 or int_price eq 0 or not isdefined("attributes.module_content") or (not ListFind(attributes.module_content,'row_otvtotal') or isdefined("int_control_otv"))>
	<cfset module_str=module_str & ",row_otvtotal">
    <cfset bool_otv_all=0>
<cfelse>
	<cfset bool_otv_all=1>
    <cfset module_str_display=ListAppend(module_str_display,"row_otvtotal",",")>
</cfif>
<cfif bool_kdv_all eq 0 or not isdefined("attributes.module_content") or not ListFind(attributes.module_content,'Kdv') >
	<cfset module_str=module_str & ",Kdv">
<cfelse>
	<cfset module_str_display=ListAppend(module_str_display,"Kdv",",")>
</cfif>
<cfif not isdefined("attributes.module_content") or not ListFind(attributes.module_content,'paymethod')>
	<cfset module_str=module_str & ",paymethod"><cfelse><cfset module_str_display=ListAppend(module_str_display,"paymethod",",")>
</cfif>
<cfif not isdefined("attributes.module_content") or not ListFind(attributes.module_content,'spec_product_cat_property') >
	<cfset module_str=module_str & ",spec_product_cat_property"><cfelse><cfset module_str_display=ListAppend(module_str_display,"spec_product_cat_property",",")>
</cfif>
<cfif not isdefined("attributes.module_content") or not ListFind(attributes.module_content,'reason_code') >
	<cfset module_str=module_str & ",reason_code"><cfelse><cfset module_str_display=ListAppend(module_str_display,"reason_code",",")>
</cfif>
<cfif not isdefined("attributes.module_content") or not ListFind(attributes.module_content,'otv_type') >
	<cfset module_str=module_str & ",otv_type"><cfelse><cfset module_str_display=ListAppend(module_str_display,"otv_type",",")>
</cfif>
<cfif not isdefined("attributes.module_content") or not ListFind(attributes.module_content,'otv_discount') >
	<cfset module_str=module_str & ",otv_discount"><cfelse><cfset module_str_display=ListAppend(module_str_display,"otv_discount",",")>
</cfif>
<!--- ihracat --->
<cfif not isdefined("attributes.module_content") or not ListFind(attributes.module_content,'delivery_condition') >
	<cfset module_str=module_str & ",delivery_condition"><cfelse><cfset module_str_display=ListAppend(module_str_display,"delivery_condition",",")>
</cfif>
<cfif not isdefined("attributes.module_content") or not ListFind(attributes.module_content,'container_type') >
	<cfset module_str=module_str & ",container_type"><cfelse><cfset module_str_display=ListAppend(module_str_display,"container_type",",")>
</cfif>
<cfif not isdefined("attributes.module_content") or not ListFind(attributes.module_content,'container_number') >
	<cfset module_str=module_str & ",container_number"><cfelse><cfset module_str_display=ListAppend(module_str_display,"container_number",",")>
</cfif>
<cfif not isdefined("attributes.module_content") or not ListFind(attributes.module_content,'container_quantity') >
	<cfset module_str=module_str & ",container_quantity"><cfelse><cfset module_str_display=ListAppend(module_str_display,"container_quantity",",")>
</cfif>
<cfif not isdefined("attributes.module_content") or not ListFind(attributes.module_content,'delivery_country') >
	<cfset module_str=module_str & ",delivery_country"><cfelse><cfset module_str_display=ListAppend(module_str_display,"delivery_country",",")>
</cfif>
<cfif not isdefined("attributes.module_content") or not ListFind(attributes.module_content,'delivery_city') >
	<cfset module_str=module_str & ",delivery_city"><cfelse><cfset module_str_display=ListAppend(module_str_display,"delivery_city",",")>
</cfif>
<cfif not isdefined("attributes.module_content") or not ListFind(attributes.module_content,'delivery_county') >
	<cfset module_str=module_str & ",delivery_county"><cfelse><cfset module_str_display=ListAppend(module_str_display,"delivery_county",",")>
</cfif>
<cfif not isdefined("attributes.module_content") or not ListFind(attributes.module_content,'delivery_type') >
	<cfset module_str=module_str & ",delivery_type"><cfelse><cfset module_str_display=ListAppend(module_str_display,"delivery_type",",")>
</cfif>
<cfif not isdefined("attributes.module_content") or not ListFind(attributes.module_content,'gtip_number') >
	<cfset module_str=module_str & ",gtip_number"><cfelse><cfset module_str_display=ListAppend(module_str_display,"gtip_number",",")>
</cfif>
<cfif not isdefined("attributes.module_content") or not ListFind(attributes.module_content,'OIV') >
	<cfset module_str=module_str & ",OIV"><cfelse><cfset module_str_display=ListAppend(module_str_display,"OIV",",")>
</cfif>
<cfif not isdefined("attributes.module_content") or not ListFind(attributes.module_content,'BSMV') >
	<cfset module_str=module_str & ",BSMV"><cfelse><cfset module_str_display=ListAppend(module_str_display,"BSMV",",")>
</cfif>
<cfif not isdefined("attributes.module_content") or not ListFind(attributes.module_content,'row_activity_id') >
	<cfset module_str=module_str & ",row_activity_id"><cfelse><cfset module_str_display=ListAppend(module_str_display,"row_activity_id",",")>
</cfif>
<cfif not isdefined("attributes.module_content") or not ListFind(attributes.module_content,'row_subscription_name') >
	<cfset module_str=module_str & ",row_subscription_name"><cfelse><cfset module_str_display=ListAppend(module_str_display,"row_subscription_name",",")>
</cfif>
<cfif not isdefined("attributes.module_content") or not ListFind(attributes.module_content,'row_assetp_name') >
	<cfset module_str=module_str & ",row_assetp_name"><cfelse><cfset module_str_display=ListAppend(module_str_display,"row_assetp_name",",")>
</cfif>
<cfif not isdefined("attributes.module_content") or not ListFind(attributes.module_content,'row_bsmv_rate') >
	<cfset module_str=module_str & ",row_bsmv_rate"><cfelse><cfset module_str_display=ListAppend(module_str_display,"row_bsmv_rate",",")>
</cfif>
<cfif not isdefined("attributes.module_content") or not ListFind(attributes.module_content,'row_volume') >
	<cfset module_str=module_str & ",row_volume"><cfelse><cfset module_str_display=ListAppend(module_str_display,"row_volume",",")>
</cfif>
<cfif not isdefined("attributes.module_content") or not ListFind(attributes.module_content,'row_weight') >
	<cfset module_str=module_str & ",row_weight"><cfelse><cfset module_str_display=ListAppend(module_str_display,"row_weight",",")>
</cfif>
<cfif not isdefined("attributes.module_content") or not ListFind(attributes.module_content,'row_specific_weight') >
	<cfset module_str=module_str & ",row_specific_weight"><cfelse><cfset module_str_display=ListAppend(module_str_display,"row_specific_weight",",")>
</cfif>
<cfif not isdefined("attributes.module_content") or not ListFind(attributes.module_content,'row_bsmv_amount') >
	<cfset module_str=module_str & ",row_bsmv_amount"><cfelse><cfset module_str_display=ListAppend(module_str_display,"row_bsmv_amount",",")>
</cfif>
<cfif not isdefined("attributes.module_content") or not ListFind(attributes.module_content,'row_bsmv_currency') >
	<cfset module_str=module_str & ",row_bsmv_currency"><cfelse><cfset module_str_display=ListAppend(module_str_display,"row_bsmv_currency",",")>
</cfif>
<cfif not isdefined("attributes.module_content") or not ListFind(attributes.module_content,'row_oiv_rate') >
	<cfset module_str=module_str & ",row_oiv_rate"><cfelse><cfset module_str_display=ListAppend(module_str_display,"row_oiv_rate",",")>
</cfif>
<cfif not isdefined("attributes.module_content") or not ListFind(attributes.module_content,'row_oiv_amount') >
	<cfset module_str=module_str & ",row_oiv_amount"><cfelse><cfset module_str_display=ListAppend(module_str_display,"row_oiv_amount",",")>
</cfif>
<cfif not isdefined("attributes.module_content") or not ListFind(attributes.module_content,'row_tevkifat_rate') >
	<cfset module_str=module_str & ",row_tevkifat_rate"><cfelse><cfset module_str_display=ListAppend(module_str_display,"row_tevkifat_rate",",")>
</cfif>
<cfif not isdefined("attributes.module_content") or not ListFind(attributes.module_content,'row_tevkifat_amount') >
	<cfset module_str=module_str & ",row_tevkifat_amount"><cfelse><cfset module_str_display=ListAppend(module_str_display,"row_tevkifat_amount",",")>
</cfif>
<cfif not isDefined("attributes.module_content") or not listFind(attributes.module_content, 'row_tevkifat_id')>
	<cfset module_str=module_str & ",row_tevkifat_id"><cfelse><cfset module_str_display=ListAppend(module_str_display,"row_tevkifat_id", ",")>
</cfif>

<cfif len(module_str)>
	<cfset module_str = mid(module_str,2,len(module_str)-1)>
</cfif>

<!--- <cfdump var="#attributes#" abort>
<cfoutput>#module_str#</cfoutput><br>
<cfoutput>#module_str_display#</cfoutput><br>
<cfabort> --->

<cftransaction>
	<cftry>
		<cfquery name="GET_BASKET" datasource="#DSN3#">
			SELECT
				BASKET_ID,
				RECORD_EMP,
				RECORD_IP,
				RECORD_DATE
			FROM
				SETUP_BASKET	
			WHERE
				BASKET_ID = #attributes.basket_id# AND
				B_TYPE = #attributes.B_TYPE#
		</cfquery>
		<cfif isdefined("attributes.isAdd") and attributes.isAdd eq 1>
			<cfif GET_BASKET.RECORDCOUNT>
				<script type="text/javascript">
					alert("<cf_get_lang no='503.Bu Modul Için Zaten Kayit Var !'>");
					history.back();
				</script>
				<cfabort>
			</cfif>
		<cfelse>
			<!---
			<cf_wrk_get_history datasource="#dsn3#" source_table="SETUP_BASKET" target_table="SETUP_BASKET_HISTORY" insert_column_name="DENEME" record_name="BASKET_ID" RECORD_ID="#attributes.BASKET_ID#">
			--->
			<cfquery name="DEL_MODULE" datasource="#DSN3#">
				DELETE FROM SETUP_BASKET WHERE BASKET_ID = #attributes.BASKET_ID# AND B_TYPE = #attributes.B_TYPE#
			</cfquery> 
			<!---
			<cf_wrk_get_history datasource="#dsn3#" source_table="SETUP_BASKET_ROWS" target_table="SETUP_BASKET_ROWS_HISTORY" insert_column_name="DENEME" record_name="BASKET_ID" RECORD_ID="#attributes.BASKET_ID#">
			--->
			
			<cfloop list="#module_str_display#" index="lst_index">
				<cfquery name="get_basket_row" datasource="#DSN3#">
					SELECT BASKET_ROW_ID FROM SETUP_BASKET_ROWS WHERE BASKET_ID = #attributes.BASKET_ID# AND TITLE = '#lst_index#'
				</cfquery>
				<cfif get_basket_row.recordCount and isdefined("attributes.#lst_index#_is_changed") and evaluate("attributes.#lst_index#_is_changed") eq 1>
					<cfquery name="delete_setup_language_info" datasource="#dsn3#">
						DELETE FROM #dsn#.SETUP_LANGUAGE_INFO WHERE TABLE_NAME = 'SETUP_BASKET_ROWS' AND COLUMN_NAME = 'TITLE_NAME' AND UNIQUE_COLUMN_ID = #get_basket_row.BASKET_ROW_ID#
					</cfquery>
				</cfif>
			</cfloop>

			<cfquery name="DEL_MODULE2" datasource="#DSN3#">
				DELETE FROM SETUP_BASKET_ROWS WHERE BASKET_ID = #attributes.BASKET_ID# AND B_TYPE = #attributes.B_TYPE#
			</cfquery>
		</cfif>
		<cfquery name="ADD_MODULE" datasource="#DSN3#">
			INSERT INTO 
				SETUP_BASKET
			(
				BASKET_ID,
				B_TYPE,
				PURCHASE_SALES,
				AMOUNT_ROUND,
				PRODUCT_SELECT_TYPE,
				PRICE_ROUND_NUMBER,
				BASKET_TOTAL_ROUND_NUMBER,
				BASKET_RATE_ROUND_NUMBER,
				USE_PROJECT_DISCOUNT,
				LINE_NUMBER,
				OTV_CALC_TYPE,
				BASKET_MOD,
				RECORD_EMP,
				RECORD_IP,
				RECORD_DATE,
				UPDATE_EMP,
				UPDATE_IP,
				UPDATE_DATE
			) 
			VALUES
			(
				#attributes.basket_id#,
				#attributes.B_TYPE#,
				<cfif bit_sale_purchase lte 1>#bit_sale_purchase#<cfelse>NULL</cfif>,
				#attributes.amount_round#,
				#attributes.PRODUCT_SELECT_TYPE#,
				#attributes.price_round_num#,
				#attributes.basket_total_round_num#,
				#attributes.basket_rate_round_num#,
				<cfif isdefined('attributes.use_project_discount_') and len(attributes.use_project_discount_)>#attributes.use_project_discount_#<cfelse>0</cfif>,
				#attributes.line_number#,
				<cfif isdefined("attributes.otv_calc_type") and len(attributes.otv_calc_type)>#attributes.otv_calc_type#<cfelse>NULL</cfif>,
				<cfif isDefined("attributes.basket_mod") and len(attributes.basket_mod)>#attributes.basket_mod#<cfelse>NULL</cfif>,
				<cfif isdefined("attributes.isAdd") and attributes.isAdd eq 1>
					#session.ep.userid#,
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#cgi.remote_addr#">,
					<cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">,
				<cfelse>
					<cfif len( GET_BASKET.RECORD_EMP )>#GET_BASKET.RECORD_EMP#<cfelse>NULL</cfif>,
					<cfif len( GET_BASKET.RECORD_IP )><cfqueryparam cfsqltype="cf_sql_varchar" value="#GET_BASKET.RECORD_IP#"><cfelse>NULL</cfif>,
					<cfif len( GET_BASKET.RECORD_DATE )>'#GET_BASKET.RECORD_DATE#'<cfelse>NULL</cfif>,
				</cfif>
				<cfif isdefined("attributes.isAdd") and attributes.isAdd eq 1>
					NULL,
					NULL,
					NULL
				<cfelse>
					#session.ep.userid#,
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#cgi.remote_addr#">,
					<cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">
				</cfif>
			)
		</cfquery>
		<cfloop list="#module_str_display#" index="lst_index">
			<cfquery name="add_q" datasource="#DSN3#">
				INSERT INTO
					SETUP_BASKET_ROWS 
				(
					TITLE,
					IS_SELECTED,
					BASKET_ID,
					LINE_ORDER_NO,
					B_TYPE,
					TITLE_NAME,
					GENISLIK,
					IS_READONLY,
					IS_MOBILE,
					IS_REQUIRED,
					LANGUAGE_ID
				)
				VALUES
				(
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#lst_index#">,
					1,
					#attributes.BASKET_ID#,
					<cfif isdefined("attributes.#lst_index#_sira") and len(evaluate("attributes.#lst_index#_sira"))>#evaluate("attributes.#lst_index#_sira")#<cfelse>NULL</cfif>,
					#attributes.B_TYPE#,
					<cfif isdefined("attributes.#lst_index#") and len(evaluate("attributes.#lst_index#"))><cfqueryparam cfsqltype="cf_sql_varchar" value='#wrk_eval("attributes.#lst_index#")#'><cfelse>NULL</cfif>,
					<cfif isdefined("attributes.#lst_index#_genislik") and len(evaluate("attributes.#lst_index#_genislik"))>#evaluate("attributes.#lst_index#_genislik")#<cfelse>100</cfif>,
					<cfif isdefined("attributes.#lst_index#_readonly") and len(evaluate("attributes.#lst_index#_readonly"))>#evaluate("attributes.#lst_index#_readonly")#<cfelse>0</cfif>,
					<cfif isdefined("attributes.#lst_index#_mobile") and len(evaluate("attributes.#lst_index#_mobile"))>#evaluate("attributes.#lst_index#_mobile")#<cfelse>0</cfif>,
					<cfif isdefined("attributes.#lst_index#_required") and len(evaluate("attributes.#lst_index#_required"))>#evaluate("attributes.#lst_index#_required")#<cfelse>0</cfif>,
					<cfif isdefined("attributes.#lst_index#_dictionary_id") and len(evaluate("attributes.#lst_index#_dictionary_id"))>#evaluate("attributes.#lst_index#_dictionary_id")#<cfelse>NULL</cfif>
				)
			</cfquery>
		</cfloop>
		<cfloop list="#module_str#" index="lst_index">
			<cfquery name="add_q_non" datasource="#DSN3#">
				INSERT INTO 
					SETUP_BASKET_ROWS 
					(
						TITLE,
						IS_SELECTED,
						BASKET_ID,
						LINE_ORDER_NO,
						B_TYPE,
						TITLE_NAME,
						GENISLIK,
						IS_READONLY,
						IS_MOBILE,
						IS_REQUIRED,
						LANGUAGE_ID
					)
					VALUES
					(
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#lst_index#">,
						0,
						#attributes.BASKET_ID#,
						<cfif isdefined("attributes.#lst_index#_sira") and len(evaluate("attributes.#lst_index#_sira"))>#evaluate("attributes.#lst_index#_sira")#<cfelse>NULL</cfif>,
						#attributes.B_TYPE#,
						<cfif isdefined("attributes.#lst_index#") and len(evaluate("attributes.#lst_index#"))><cfqueryparam cfsqltype="cf_sql_varchar" value='#wrk_eval("attributes.#lst_index#")#'><cfelse>NULL</cfif>,
						<cfif isdefined("attributes.#lst_index#_genislik") and len(evaluate("attributes.#lst_index#_genislik"))>#evaluate("attributes.#lst_index#_genislik")#<cfelse>25</cfif>,
						<cfif isdefined("attributes.#lst_index#_readonly") and len(evaluate("attributes.#lst_index#_readonly"))>#evaluate("attributes.#lst_index#_readonly")#<cfelse>0</cfif>,
						<cfif isdefined("attributes.#lst_index#_mobile") and len(evaluate("attributes.#lst_index#_mobile"))>#evaluate("attributes.#lst_index#_mobile")#<cfelse>0</cfif>,
						<cfif isdefined("attributes.#lst_index#_required") and len(evaluate("attributes.#lst_index#_required"))>#evaluate("attributes.#lst_index#_required")#<cfelse>0</cfif>,
						<cfif isdefined("attributes.#lst_index#_dictionary_id") and len(evaluate("attributes.#lst_index#_dictionary_id"))>#evaluate("attributes.#lst_index#_dictionary_id")#<cfelse>NULL</cfif>
					)
			</cfquery>
		</cfloop>
		<cfquery name="UPD_ROW" datasource="#DSN3#">
			UPDATE SETUP_BASKET_ROWS SET TITLE_NAME = TITLE WHERE TITLE_NAME IS NULL
		</cfquery>
		<cfquery name="upd_row" datasource="#DSN3#">
			UPDATE SETUP_BASKET_ROWS SET GENISLIK = 100 WHERE GENISLIK IS NULL
		</cfquery>
		<cfif listlen(extendedList)>
			<cfloop index="elemInd" from="1" to="#listlen(extendedList)#">
				<cfset elementEx = listGetAt(extendedList,elemInd,',')>
				<cfquery name="add_q_non" datasource="#DSN3#">
					INSERT INTO 
						SETUP_BASKET_ROWS 
						(
							TITLE,
							IS_SELECTED,
							BASKET_ID,
							LINE_ORDER_NO,
							B_TYPE,
							TITLE_NAME,
							GENISLIK,
							IS_READONLY,
							LANGUAGE_ID
						)
						VALUES
						(
							<cfqueryparam cfsqltype="cf_sql_varchar" value="#elementEx#">,
							<cfif ListFind(attributes.module_content,elementEx)>1<cfelse>0</cfif>,
							#attributes.BASKET_ID#,
							<cfif len(form["#elementEx#_sira"])>#form["#elementEx#_sira"]#<cfelse>NULL</cfif>,
							#attributes.B_TYPE#,
							<cfif len(form["#elementEx#"])>'#form["#elementEx#"]#'<cfelse>'#elementEx#'</cfif>,
							<cfif len(form["#elementEx#_genislik"])>#form['#elementEx#_genislik']#<cfelse>100</cfif>,
							0,
							<cfif len(form["#elementEx#_dictionary_id"])>#form['#elementEx#_dictionary_id']#<cfelse>NULL</cfif>,
						)
				</cfquery>
			</cfloop>
		</cfif>
		<cfcatch>
			<cftransaction action="rollback">
			<script>alert("Basket ayarları yapılırken sorun oluştu!");</script>
		</cfcatch>
	</cftry>
	<script type="text/javascript">
		window.location.reload();
	</script>
</cftransaction>