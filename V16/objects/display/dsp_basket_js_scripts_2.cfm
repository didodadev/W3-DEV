<script language="JavaScript1.3">
function change_bg_color_basket_row(gelen)
{
	if(gelen.bgColor=="<cfoutput>###lcase(colorrow)#</cfoutput>")
		gelen.bgColor = '<cfoutput>#colorlight#</cfoutput>';
	else
		gelen.bgColor = '<cfoutput>#colorrow#</cfoutput>';
}
function hesabi_bitir(satir)
{
	formatFieldValue('amount',(satir-1), 3,amount_round);
	formatFieldValue('tax',(satir-1),3,0);
	formatFieldValue('otv_oran',(satir-1),3,price_round_number);
	formatFieldValue('duedate',(satir-1), 1 ,0);
	formatFieldValue('number_of_installment',(satir-1), 1 ,0);
	formatFieldValue('indirim1',(satir-1), 3, 2);
	formatFieldValue('indirim2',(satir-1), 3, 2);
	formatFieldValue('indirim3',(satir-1), 3, 2);
	formatFieldValue('indirim4',(satir-1), 3, 2);
	formatFieldValue('indirim5',(satir-1), 3, 2);
	formatFieldValue('indirim6',(satir-1), 3, 2);
	formatFieldValue('indirim7',(satir-1), 3, 2);
	formatFieldValue('indirim8',(satir-1), 3, 2);
	formatFieldValue('indirim9',(satir-1), 3, 2);
	formatFieldValue('indirim10',(satir-1), 3,2);
	formatFieldValue('row_width',(satir-1), 3,2);
	formatFieldValue('row_depth',(satir-1), 3,2);
	formatFieldValue('row_height',(satir-1), 3,2);
	formatFieldValue('iskonto_tutar',(satir-1), 3,price_round_number);
	formatFieldValue('promosyon_yuzde',(satir-1), 3,2);
	formatFieldValue('row_lasttotal',(satir-1), 3,price_round_number);
	formatFieldValue('row_nettotal',(satir-1), 3,price_round_number);
	formatFieldValue('row_taxtotal',(satir-1), 3,price_round_number);
	formatFieldValue('row_otvtotal',(satir-1), 3,price_round_number);
	formatFieldValue('ek_tutar',(satir-1), 3,price_round_number);
	formatFieldValue('ek_tutar_price',(satir-1), 3,price_round_number);
	formatFieldValue('ek_tutar_cost',(satir-1), 3,price_round_number);
	formatFieldValue('ek_tutar_marj',(satir-1), 3, 2);
	formatFieldValue('ek_tutar_other_total',(satir-1), 3,price_round_number);
	formatFieldValue('amount_other',(satir-1), 3,price_round_number);
	formatFieldValue('list_price',(satir-1), 3,price_round_number);
	formatFieldValue('list_price_discount',(satir-1), 3,2);
	formatFieldValue('tax_price',(satir-1), 3,price_round_number);
	formatFieldValue('price',(satir-1), 3,price_round_number);
	formatFieldValue('price_net',(satir-1), 3,price_round_number);
	formatFieldValue('row_total',(satir-1), 3,price_round_number);
	formatFieldValue('price_other',(satir-1), 3,price_round_number);
	formatFieldValue('price_net_doviz',(satir-1), 3,price_round_number);
	formatFieldValue('other_money_value_',(satir-1), 3,price_round_number);
	formatFieldValue('other_money_gross_total',(satir-1), 3,price_round_number);
	formatFieldValue('dara',(satir-1),3, amount_round);
	formatFieldValue('darali',(satir-1),3,amount_round);
	formatFieldValue('promosyon_maliyet',(satir-1),3,price_round_number);
	formatFieldValue('net_maliyet',(satir-1),3,price_round_number);
	formatFieldValue('extra_cost',(satir-1),3,price_round_number);
	formatFieldValue('extra_cost_rate',(satir-1),3,2);
	formatFieldValue('row_cost_total',(satir-1),3,price_round_number);
	return true;
}
function clear_row(x)
{
if (document.form_basket.product_id.length != undefined)
	{
	document.form_basket.wrk_row_relation_id[x-1].value='';
	document.form_basket.related_action_id[x-1].value='';
	document.form_basket.related_action_table[x-1].value='';
	document.form_basket.row_catalog_id[x-1].value='';
	document.form_basket.row_unique_relation_id[x-1].value='';
	document.form_basket.karma_product_id[x-1].value='';
	document.form_basket.row_service_id[x-1].value='';
	document.form_basket.prom_relation_id[x-1].value='';
	document.form_basket.product_name_other[x-1].value='';
	document.form_basket.price_cat[x-1].value='';
	document.form_basket.unit_other[x-1].value='';
	document.form_basket.amount_other[x-1].value=0;
	document.form_basket.ek_tutar_other_total[x-1].value=0;
	document.form_basket.ek_tutar[x-1].value=0;
	document.form_basket.ek_tutar_price[x-1].value=0;
	document.form_basket.ek_tutar_cost[x-1].value=0;
	document.form_basket.ek_tutar_marj[x-1].value='';
	document.form_basket.ek_tutar_total[x-1].value=0;
	document.form_basket.shelf_number[x-1].value='';
	document.form_basket.shelf_number_txt[x-1].value='';
	document.form_basket.pbs_code[x-1].value='';
	document.form_basket.pbs_id[x-1].value='';
	document.form_basket.to_shelf_number[x-1].value='';
	document.form_basket.to_shelf_number_txt[x-1].value='';
	document.form_basket.row_project_id[x-1].value='';
	document.form_basket.row_project_name[x-1].value='';
	document.form_basket.row_work_id[x-1].value='';
	document.form_basket.row_work_name[x-1].value='';
	document.form_basket.product_id[x-1].value='';
	document.form_basket.stock_id[x-1].value='';
	document.form_basket.is_inventory[x-1].value='';
	document.form_basket.is_production[x-1].value='';
	document.form_basket.row_ship_id[x-1].value='0';
	document.form_basket.stock_id[x-1].value='';
	document.form_basket.stock_code[x-1].value='';
	document.form_basket.barcod[x-1].value='';
	document.form_basket.special_code[x-1].value='';
	document.form_basket.manufact_code[x-1].value='';
	document.form_basket.product_name[x-1].value='';
	document.form_basket.amount[x-1].value=0;
	document.form_basket.unit_id[x-1].value='';document.form_basket.unit[x-1].value='';
	document.form_basket.spect_id[x-1].value='';document.form_basket.spect_name[x-1].value='';
	document.form_basket.row_width[x-1].value='';
	document.form_basket.row_depth[x-1].value='';
	document.form_basket.row_height[x-1].value='';
	document.form_basket.list_price[x-1].value=0;
	document.form_basket.list_price_discount[x-1].value=0;
	document.form_basket.tax_price[x-1].value=0;
	document.form_basket.price[x-1].value=0;
	document.form_basket.price_other[x-1].value=0;
	document.form_basket.price_net[x-1].value=0;
	document.form_basket.price_net_doviz[x-1].value=0;									
	document.form_basket.tax[x-1].value=0;
	document.form_basket.otv_oran[x-1].value=0;
	document.form_basket.number_of_installment[x-1].value='';
	document.form_basket.duedate[x-1].value='';
	document.form_basket.iskonto_tutar[x-1].value=0;
	document.form_basket.indirim1[x-1].value=0;
	document.form_basket.indirim2[x-1].value=0;
	document.form_basket.indirim3[x-1].value=0;
	document.form_basket.indirim4[x-1].value=0;
	document.form_basket.indirim5[x-1].value=0;
	document.form_basket.indirim6[x-1].value=0;
	document.form_basket.indirim7[x-1].value=0;
	document.form_basket.indirim8[x-1].value=0;
	document.form_basket.indirim9[x-1].value=0;
	document.form_basket.indirim10[x-1].value=0;
	document.form_basket.row_total[x-1].value=0;
	document.form_basket.row_nettotal[x-1].value=0;
	document.form_basket.row_taxtotal[x-1].value=0;
	document.form_basket.row_otvtotal[x-1].value=0;
	document.form_basket.row_lasttotal[x-1].value=0;
	document.form_basket.other_money_value_[x-1].value=0;document.form_basket.other_money_gross_total[x-1].value=0;
	document.form_basket.deliver_date[x-1].value='';
	document.form_basket.reserve_date[x-1].value='';
	document.form_basket.deliver_dept[x-1].value='';
	document.form_basket.basket_row_departman[x-1].value='';
	document.form_basket.lot_no[x-1].value='';
	document.form_basket.net_maliyet[x-1].value='';
	document.form_basket.marj[x-1].value='';	
	document.form_basket.dara[x-1].value=0;
	document.form_basket.darali[x-1].value=1;	
	document.form_basket.is_promotion[x-1].value=0;
	document.form_basket.is_commission[x-1].value=0;
	document.form_basket.basket_employee[x-1].value='';
	document.form_basket.basket_employee_id[x-1].value='';
	document.form_basket.row_exp_center_id[x-1].value='';
	document.form_basket.row_exp_center_name[x-1].value='';
	document.form_basket.row_exp_item_id[x-1].value='';
	document.form_basket.row_exp_item_name[x-1].value='';
	document.form_basket.row_acc_code[x-1].value='';
	}
else/*20050520 bu ifade kapatilabilir, tek satir kaldiginda o satiri bosaltmaya gerek yok */
	{
	document.form_basket.wrk_row_relation_id.value='';
	document.form_basket.related_action_id.value='';
	document.form_basket.related_action_table.value='';
	document.form_basket.row_catalog_id.value='';
	document.form_basket.row_unique_relation_id.value='';
	document.form_basket.karma_product_id.value='';
	document.form_basket.row_service_id.value='';
	document.form_basket.prom_relation_id.value='';
	document.form_basket.product_name_other.value='';
	document.form_basket.price_cat.value='';
	document.form_basket.unit_other.value='';
	document.form_basket.amount_other.value=0;
	document.form_basket.ek_tutar_other_total.value=0;
	document.form_basket.ek_tutar.value=0;
	document.form_basket.ek_tutar_price.value=0;
	document.form_basket.ek_tutar_cost.value=0;
	document.form_basket.ek_tutar_marj.value='';
	document.form_basket.ek_tutar_total.value=0;
	document.form_basket.shelf_number.value='';
	document.form_basket.shelf_number_txt.value='';
	document.form_basket.pbs_code.value='';
	document.form_basket.pbs_id.value='';
	document.form_basket.to_shelf_number.value='';
	document.form_basket.to_shelf_number_txt.value='';
	document.form_basket.row_project_id.value='';
	document.form_basket.row_project_name.value='';
	document.form_basket.row_work_id.value='';
	document.form_basket.row_work_name.value='';
	document.form_basket.product_id.value='';
	document.form_basket.stock_id.value='';
	document.form_basket.is_inventory.value='';
	document.form_basket.is_production.value='';
	document.form_basket.row_ship_id.value='0';
	document.form_basket.stock_id.value='';
	document.form_basket.stock_code.value='';
	document.form_basket.barcod.value='';
	document.form_basket.special_code.value='';
	document.form_basket.manufact_code.value='';
	document.form_basket.product_name.value='';
	document.form_basket.amount.value=0;
	document.form_basket.unit_id.value='';document.form_basket.unit.value='';
	document.form_basket.spect_id.value='';document.form_basket.spect_name.value='';
	document.form_basket.row_width.value='';
	document.form_basket.row_depth.value='';
	document.form_basket.row_height.value='';
	document.form_basket.list_price.value=0;
	document.form_basket.list_price_discount.value=0;
	document.form_basket.tax_price.value=0;
	document.form_basket.price.value=0;
	document.form_basket.price_other.value=0;
	document.form_basket.price_net.value=0;
	document.form_basket.price_net_doviz.value=0;									
	document.form_basket.tax.value=0;
	document.form_basket.otv_oran.value=0;
	document.form_basket.duedate.value='';
	document.form_basket.number_of_installment.value='';
	document.form_basket.iskonto_tutar.value=0;
	document.form_basket.indirim1.value=0;
	document.form_basket.indirim2.value=0;
	document.form_basket.indirim3.value=0;
	document.form_basket.indirim4.value=0;
	document.form_basket.indirim5.value=0;
	document.form_basket.indirim6.value=0;
	document.form_basket.indirim7.value=0;
	document.form_basket.indirim8.value=0;
	document.form_basket.indirim9.value=0;
	document.form_basket.indirim10.value=0;
	document.form_basket.row_total.value=0;
	document.form_basket.row_nettotal.value=0;
	document.form_basket.row_taxtotal.value=0;
	document.form_basket.row_otvtotal.value=0;
	document.form_basket.row_lasttotal.value=0;
	document.form_basket.other_money_value_.value=0;document.form_basket.other_money_gross_total.value=0;
	document.form_basket.deliver_date.value='';
	document.form_basket.reserve_date.value='';
	document.form_basket.deliver_dept.value='';document.form_basket.basket_row_departman.value='';
	document.form_basket.lot_no.value='';
	document.form_basket.net_maliyet.value='';
	document.form_basket.marj.value='';	
	document.form_basket.dara.value=0;
	document.form_basket.darali.value=1;
	document.form_basket.is_promotion.value=0;
	document.form_basket.is_commission.value=0;
	document.form_basket.basket_extra_info.value='';
	document.form_basket.select_info_extra.value='';
	document.form_basket.detail_info_extra.value='';
	document.form_basket.basket_employee.value='';
	document.form_basket.basket_employee_id.value='';
	document.form_basket.row_exp_center_id.value='';
	document.form_basket.row_exp_center_name.value='';
	document.form_basket.row_exp_item_id.value='';
	document.form_basket.row_exp_item_name.value='';
	document.form_basket.row_acc_code.value='';
	}
	<cfif ListFindNoCase(display_list, "deliver_dept_assortment")>
	if (departmentArray[x] != undefined)
	{
		var deptArraylen =departmentArray[x].length;
		for(var counter2 = 1 ; counter2 <= deptArraylen ; counter2++ )
			if (departmentArray[x] != undefined){
				try { departmentArray[x][counter2][0] = 0; }
				catch(e){}
				}
	}
	</cfif>
	<cfif ListFindNoCase(display_list, "is_parse")>
		for (var ai=x; ai < rowCount; ai++) assortmentArray[x] = '';
	</cfif>
	toplam_hesapla(0);
	return true;
}
function del_row(x)
{
	table_list.deleteRow(x);
	<cfif ListFindNoCase(display_list, "is_parse")>
		delete assortmentArray[x];
		for (var ai=x; ai < rowCount; ai++) assortmentArray[x] = assortmentArray[x+1];
			delete assortmentArray[rowCount];
	</cfif>
	rowCount--;
	return true;
}
function del_rows()
{
	for (;rowCount>0;) del_row(rowCount);
	form_basket.rows_.value = rowCount;
	toplam_hesapla(1);
	return true;
}
<cfoutput>
/*asagidaki fonksiyondaki attributes.basket_id ler sonradan database den gelecek*/
function add_basket_row(product_id, stock_id, stock_code, barcod, manufact_code, product_name, unit_id_, unit_, spect_id, spect_name, price, price_other, tax, duedate, d1, d2, d3, d4, d5, d6, d7, d8, d9, d10, deliver_date, deliver_dept, department_head, lot_no, money, row_ship_id, amount_, product_account_code, is_inventory,is_production,net_maliyet,flt_marj,extra_cost,row_promotion_id,promosyon_yuzde,promosyon_maliyet,iskonto_tutar,is_promotion,prom_stock_id,otv,product_name_other,amount_other,unit_other,ek_tutar,shelf_number,row_unique_relation_id,row_catalog_id,toplam_hesap_yap,is_commission,basket_extra_info,select_info_extra,detail_info_extra,prom_relation_id,reserve_date,list_price,number_of_installment,price_cat,karma_product_id,row_service_id,ek_tutar_price,wrk_row_relation_id,related_action_id,related_action_table,row_width,row_depth,row_height,to_shelf_number,row_project_id,row_project_name,row_otv_amount,action_window_name,row_paymethod_id
,special_code,basket_employee_id,basket_employee,row_work_id,row_work_name, row_exp_center_id, row_exp_center_name, row_exp_item_id, row_exp_item_name, row_acc_code,price_other_calc)
{
	if(action_window_name != undefined && action_window_name != '' && action_window_name != basket_unique_code)
		{
		alert('Çalıştığınız Ekran Mevcut Sepet İle Uyumlu Değil!\nFiyat Listesi Ekranınızı Yenilemelisiniz!');
		return false;
		}
	rowCount++;
	var newRow,newCell,ek_tutar_cost;
	var ek_tutar_system = 0;
	var ek_tutar_marj =0;
	var ek_tutar_cost =0;
	var ek_tutar_other_total=0;
	var row_cost_total_ = 0;
	var indirim_carpan = (100-d1) * (100-d2) * (100-d3) * (100-d4) * (100-d5) * (100-d6) * (100-d7) * (100-d8) * (100-d9) * (100-d10);
	var price_net = price;
	if(isNaN(amount_) || amount_==0) amount_=1;
	if(isNaN(price_cat)) var price_cat='';
	if(isNaN(ek_tutar_price)) var ek_tutar_price=0;
	if(isNaN(list_price) || list_price =='') var list_price=price;/*sadece bilgi amaclı tutuluyor, urun eklenirken kullanılan ilk fiyat bilgisini tutmak icin*/
	if(isNaN(list_price_) || list_price_ =='') var list_price_=price;/*sadece bilgi amaclı tutuluyor, urun eklenirken kullanılan ilk fiyat bilgisini tutmak icin*/
	if(isNaN(number_of_installment) || number_of_installment =='') var number_of_installment=0;
	if(isNaN(row_width)) var row_width='';
	if(isNaN(price_other)) var price_other=0;
	if(isNaN(row_depth)) var row_depth='';
	if(isNaN(row_height)) var row_height='';
	if(isNaN(to_shelf_number)) var to_shelf_number='';
	if(isNaN(karma_product_id)) var karma_product_id='';
	if(isNaN(row_project_id)) var row_project_id='';
	if(isNaN(row_work_id)) var row_work_id='';
	if(isNaN(row_exp_center_id)) var row_exp_center_id='';
	if(isNaN(row_exp_item_id)) var row_exp_item_id='';
	if(row_paymethod_id==undefined) var row_paymethod_id='';
	if(row_project_name==undefined) var row_project_name='';
	if(row_work_name==undefined) var row_work_name='';
	if(row_exp_center_name==undefined) var row_exp_center_name='';
	if(row_exp_item_name==undefined) var row_exp_item_name='';
	if(row_acc_code==undefined) var row_acc_code='';
	if(prom_relation_id == undefined) var prom_relation_id='';
	if(row_service_id == undefined) var row_service_id = '';
	if(wrk_row_relation_id==undefined) wrk_row_relation_id='';
	if(special_code==undefined) special_code='';
	if(basket_employee_id==undefined) basket_employee_id='';
	if(basket_employee==undefined) basket_employee='';
	<cfif session.ep.period_year gte 2009>
		if(money!= undefined && money=='YTL')
			money='<cfoutput>#session.ep.money#</cfoutput>'; //onceki donemden ytl cekilip yeni isleme eklenecek satırlar tl ye cevriliyor
	<cfelseif session.ep.period_year lt 2009>
		if(money!= undefined && money=='TL')
			money='<cfoutput>#session.ep.money#</cfoutput>'; //onceki donemden tl cekilip yeni isleme eklenecek satırlar ytl ye cevriliyor
	</cfif>

	if(row_project_id != '' && row_project_name == '') //sadece proje_id gonderilmisse proje ismi cekilir
	{
		var get_pro_name =wrk_safe_query('obj_get_pro_name','dsn',0,row_project_id);
		if(get_pro_name.recordcount)
			row_project_name = get_pro_name.PROJECT_HEAD;
	}
	if(isNaN(amount_other) || amount_other =='') var amount_other=1;
	if(ek_tutar_price!='' && ek_tutar_price!=0) //iscilik birim ucreti gonderilmisse ek_tutar ve ek_tutar_marj bu degerden hesaplanır
	{
		if(isNaN(amount_other)) var amount_other=1;
			ek_tutar_cost = ek_tutar_price*amount_other;
		if(ek_tutar != '' && ek_tutar != 0)
			ek_tutar_marj=((ek_tutar*100)/ek_tutar_cost)-100;
		else
			ek_tutar=ek_tutar_cost;
	}
		
	if((iskonto_tutar!='') || (ek_tutar!=''))<!---  iskonto_tutar her zaman satir doviz cinsinden oldugundan yerel degerini bularak dusuyoruz--->
	{	
		var moneyArraylen=moneyArray.length;
		for(var mon_i=0; mon_i<moneyArraylen; mon_i++)
			if(moneyArray[mon_i]==money)
			{
				price_net  -= iskonto_tutar*rate2Array[mon_i]/rate1Array[mon_i];
				price_net  += ek_tutar*rate2Array[mon_i]/rate1Array[mon_i]; <!--- ek tutar her zaman satir doviz cinsinden oldugundan yerel degerini bularak ekliyoruz --->
				ek_tutar_system = ek_tutar*rate2Array[mon_i]/rate1Array[mon_i];
			}
	}
	if(promosyon_yuzde!='') price_net -= price_net*promosyon_yuzde/100;
	price_net = wrk_round(price_net*indirim_carpan/100000000000000000000,price_round_number);
	var net_total = wrk_round((price_net*amount_),price_round_number); //kdv bu tutar uzerinden hesaplandıgı icin basket functionlarında net_total formatlandıgı halde onceden wrk_roundan geciriyoruz.
	var ek_tutar_total_ = wrk_round((ek_tutar_system*amount_),price_round_number)
	if(isNaN(row_otv_amount) || row_otv_amount == undefined || row_otv_amount == '')
	{
		var row_otv_total = wrk_round(net_total*otv/100 ,price_round_number);
	}
	else
		var row_otv_total = wrk_round(row_otv_amount ,price_round_number); 
	<cfif ListFindNoCase(display_list, "otv_from_tax_price")> //otv, kdv matrahına ekleniyor
		var row_tax_total = wrk_round( (net_total+row_otv_total)*tax/100 ,price_round_number);
	<cfelse>
		var row_tax_total = wrk_round( net_total*tax/100 ,price_round_number);
	</cfif>
	var price_net_doviz = price_other;
	if(iskonto_tutar!='') price_net_doviz -=iskonto_tutar;
	if(ek_tutar!='')
	{
		price_net_doviz = (parseFloat(price_net_doviz)+parseFloat(ek_tutar));/*satır doviz toplamına ek tutarda katılıyor*/
		ek_tutar_other_total = wrk_round((ek_tutar* amount_),price_round_number);
	}
	temp_wrk_row_id=js_create_unique_id();
	if(reserve_date == undefined) reserve_date='';
	if(row_catalog_id == undefined) var row_catalog_id='';
	if(related_action_id == undefined) var related_action_id='';
	if(related_action_table == undefined) var related_action_table='';
	if(promosyon_yuzde!='') price_net_doviz -= price_net_doviz*promosyon_yuzde/100;
	price_net_doviz = wrk_round(price_net_doviz*indirim_carpan/100000000000000000000,price_round_number);
	var other_money_value_ = price_net_doviz*amount_;

	newRow = document.getElementById("table_list").insertRow(document.getElementById("table_list").rows.length);
	newRow.setAttribute("id","b_y_my_row_" + rowCount);
	newRow.className = 'color-row';
	/*newRow.onmouseover=function(){this.className='color-light'};
	newRow.onmouseout=function(){this.className='color-row'};
	newRow.setAttribute("onmouseover","this.className='color-light'");
	newRow.setAttribute("onmouseout","this.className='color-row'");*/
	newCell = newRow.insertCell(newRow.cells.length);
	newCell.setAttribute("id","row_no_" + rowCount);
	newCell.innerHTML = rowCount;

	newCell = newRow.insertCell(newRow.cells.length);
	newCell.style.whiteSpace = 'nowrap';
	newCell.innerHTML = '<input type="hidden" id="product_id" name="product_id" value="' + product_id + '">';
	newCell.innerHTML += '<input type="hidden" id="action_row_id" name="action_row_id" value="0">';
	newCell.innerHTML += '<input type="hidden" id="wrk_row_id" name="wrk_row_id" value="'+temp_wrk_row_id+'">';
	newCell.innerHTML += '<input type="hidden" id="wrk_row_relation_id" name="wrk_row_relation_id" value="'+wrk_row_relation_id+'">';
	newCell.innerHTML += '<input type="hidden" id="related_action_id" name="related_action_id" value="'+related_action_id+'">';
	newCell.innerHTML += '<input type="hidden" id="related_action_table" name="related_action_table" value="'+related_action_table+'">';
	newCell.innerHTML += '<input type="hidden" id="karma_product_id" name="karma_product_id" value="' + karma_product_id +'">';
	newCell.innerHTML += '<input type="hidden" id="is_inventory" name="is_inventory" value="' + is_inventory + '">';
	newCell.innerHTML += '<input type="hidden" id="row_paymethod_id" name="row_paymethod_id" value="' + row_paymethod_id + '">';
	/*newCell.innerHTML += '<input type="hidden" name="product_account_code" value="' + product_account_code + '">'; diger dosyalardan da product_account_code kaldırılacak OZDEN20090218*/
	newCell.innerHTML += '<input type="hidden" id="is_production" name="is_production" value="' + is_production + '">';
	newCell.innerHTML += '<input type="hidden" id="price_cat" name="price_cat" value="' + price_cat + '">';
	newCell.innerHTML += '<input type="hidden" id="stock_id" name="stock_id" value="' + stock_id + '">';
	newCell.innerHTML += '<input type="hidden" id="unit_id" name="unit_id" value="' + unit_id_ + '">';
	newCell.innerHTML += '<input type="hidden" id="row_ship_id" name="row_ship_id" value="' + row_ship_id + '">';
	newCell.innerHTML += '<input type="hidden" id="is_promotion" name="is_promotion" value="' + is_promotion + '">';
	newCell.innerHTML += '<input type="hidden" id="prom_stock_id" name="prom_stock_id" value="' + prom_stock_id + '">';
	newCell.innerHTML += '<input type="hidden" id="row_promotion_id" name="row_promotion_id" value="' + row_promotion_id + '">';
	newCell.innerHTML += '<input type="hidden" id="row_service_id" name="row_service_id" value="' + row_service_id + '">';
	newCell.innerHTML += '<input type="hidden" id="row_unique_relation_id" name="row_unique_relation_id" value="' + row_unique_relation_id + '">';
	newCell.innerHTML += '<input type="hidden" id="row_catalog_id" name="row_catalog_id" value="' + row_catalog_id + '">'; //satırın aksiyon bilgisi
	newCell.innerHTML += '<input type="hidden" id="prom_relation_id" name="prom_relation_id" value="' + prom_relation_id + '">'; /*promosyon satırı ve bedava urun arasındaki iliskiyi tutar, boylece baskete aynı promosyondan birden fazla eklendiginde sorun olusmaz*/
	newCell.innerHTML += '<input type="hidden" id="indirim_total" name="indirim_total" value="' + indirim_carpan + '">';
	newCell.innerHTML += '<input type="hidden" id="ek_tutar_total" name="ek_tutar_total" value="' + ek_tutar_total_ + '" >';
	newCell.innerHTML += '<a href="javascript://" onClick="if (confirm(\'Ürünü Silmek İstediğinizden Emin misiniz?\')) clear_related_rows(this.parentNode.parentNode.rowIndex); else return;"><img src="/images/delete_list.gif" alt="Ürünü Sil" border="0"></a>';
	newCell.innerHTML += '<input type="hidden" id="is_commission" name="is_commission" value="' + is_commission + '">';

	if(row_unique_relation_id != undefined && row_unique_relation_id != '' && wrk_row_relation_id == '')
		newCell.innerHTML += ' <a href="javascript://" onClick="alert(\'<cf_get_lang_main no="1326.Karma Koli İçeriğindeki Ürünler Tek Olarak Güncellenemez">!\');"><img src="/images/update_list.gif" border="0" alt="Farklı Ürün Seçmek İçin Tıklayınız"></a>';
	else if(wrk_row_relation_id == '')
		newCell.innerHTML += ' <a href="javascript://" onClick="control_comp_selected(this.parentNode.parentNode.rowIndex);"><img src="/images/update_list.gif" border="0" alt="Farklı Ürün Seçmek İçin Tıklayınız"></a>';
	newCell.innerHTML += ' <a href="javascript://" onClick="copy_basket_row(this.parentNode.parentNode.rowIndex-1);"><img src="/images/copy_list.gif" border="0" alt="Aynı Ürünü Eklemek İçin Tıklayınız"></a>';
	<cfif listfind("11,12,47,48,1,20,2,18,31,32,11,15,17,47,49,10",attributes.basket_id,",") and (attributes.fuseaction contains 'add' or (isdefined("attributes.event") and attributes.event is 'add'))><!--- seri no ekleme sayfası açılacak --->
		my_serial_ctrl = wrk_safe_query('chk_product_serial1','dsn3',0,product_id);
		if(my_serial_ctrl.IS_SERIAL_NO==1)
		newCell.innerHTML += ' <a href="javascript://" onClick="add_seri_no(this.parentNode.parentNode.rowIndex);"><img src="/images/barcode2.gif" border="0" alt="Seri No Eklemek İçin Tıklayınız"></a>';
	</cfif>
	<cfinclude template="dsp_basket_js_scripts_2_hiddens.cfm">
<cfloop from="1" to="#listlen(display_list,",")#" index="dli">
	<cfset element = ListGetAt(display_list,dli,",")>
	<cfif listlen(display_field_name_list) gte dli><!--- gecici olarak bu sekilde duzeltildi ozden16092005 --->
		<cfset deger_ = Replace(ListGetAt(display_field_name_list, dli, ','),"'","","all")>
		title_content = "#deger_#"; <!--- FBS 20120216 tirnak kaldirildi, baskette urun eklenmediginden, gecici cozum --->
	<cfelse>
		<cfset title_content = ''>
	</cfif>
	<cfif (listlen(display_field_name_list) gte dli) and element is 'list_price' and len(basket_price_cat_id_list_)>
		if(price_cat=='-1')
			row_price_cat_name_='Standart Alış';
		else if(price_cat=='-2')
			row_price_cat_name_='Standart Satış';
		else if(list_find(basket_price_cat_id_list_,price_cat) && list_getat(basket_price_cat_name_list_,list_find(basket_price_cat_id_list_,price_cat),'§'))
			row_price_cat_name_=list_getat(basket_price_cat_name_list_,list_find(basket_price_cat_id_list_,price_cat),'§');
		else
			row_price_cat_name_='';
		title_content = title_content+':'+row_price_cat_name_;
	</cfif>
	title_content = title_content+'\n'+product_name;
	//basket sablonu genel bilgileri, sonradan setup_baskete taşınabilir
	<cfif not listfindnocase('is_project_not_change,is_paper_discount,is_project_selected,is_store,is_amount_total,check_row_discounts,basket_cursor,is_prom_id,is_promotion,prom_stock_id,spec_product_cat_property,price_total,is_price_total_other_money,Kdv,is_member_selected,is_member_not_change,zero_stock_status,is_risc,is_cash_pos,is_installment,otv_from_tax_price,zero_stock_control_date,is_serialno_guaranty,is_use_add_unit',element)>
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.title = title_content;
		newCell.style.whiteSpace = 'nowrap';
	</cfif>
	<cfswitch expression="#element#">
	<cfcase value="stock_code">
		newCell.innerHTML = '<input type="text" id="stock_code" name="stock_code" style="width:#ListGetAt(display_field_width_list, dli, ",")#px;" class="boxtext" value="' + stock_code + '" readonly=yes>';
	</cfcase>
	<cfcase value="barcod">
		newCell.innerHTML = '<input type="text" id="barcod" name="barcod" style="width:#ListGetAt(display_field_width_list, dli, ",")#px;" class="boxtext" value="' + barcod + '" readonly=yes>';
	</cfcase>
	<cfcase value="special_code">
		newCell.innerHTML = '<input type="text" id="special_code" name="special_code" style="width:#ListGetAt(display_field_width_list, dli, ",")#px;" class="boxtext" value="' + special_code + '" readonly=yes>';
	</cfcase>
	<cfcase value="manufact_code">
		newCell.innerHTML = '<input type="text" id="manufact_code" name="manufact_code" style="width:#ListGetAt(display_field_width_list, dli, ",")#px;" class="boxtext" value="' + manufact_code + '">';
	</cfcase>
	<cfcase value="product_name">
		newCell.style.textAlign = 'right';
		newCell.innerHTML = ' <input type="text" id="product_name" name="product_name" <cfif ListGetAt(display_field_readonly_list,dli,",") eq 1>readonly="yes"</cfif> style="width:#ListGetAt(display_field_width_list, dli, ",")#px;"  class="boxtext" value="' + product_name + '">';
		newCell.id = 'td_'+rowCount;
		newCell.innerHTML+= ' <a href="javascript://" id="product_popup_#dli#" onClick="open_product_popup(this.parentNode.parentNode.rowIndex);"><img src="/images/plus_thin.gif" border="0" align="absmiddle"></a> ';
		<cfif get_module_user(5)>
			/* newCell.innerHTML+= ' <a href="javascript://" onClick="open_product_purchase_condition(this.parentNode.parentNode.rowIndex);"><img src="/images/plus_thin.gif" border="0" alt="Satınalma Koşulları"align="absmiddle"></a> '; */
			newCell.innerHTML+= ' <a href="javascript://" id="product_price_history_#dli#" onClick="open_product_price_history(this.parentNode.parentNode.rowIndex);"><img src="/images/plus_thin.gif" border="0" alt="Ürün Fiyat Tarihçe" align="absmiddle"></a> ';
		</cfif>
	</cfcase>
	<cfcase value="amount">
		/*row_unique_relation_id parametresi, karma_product_id yi tutar ve karma koli icerigindeki urunlerin bagımsız olarak miktarının degistirilmesi, guncellenme-silme islemlerini onlemek icin kullanılır*/
		if(row_unique_relation_id != undefined && row_unique_relation_id != '')
			newCell.innerHTML = '<input type="text" id="amount" name="amount" value="' + amount_ + '" style="width:#ListGetAt(display_field_width_list, dli, ",")#px;" readonly="yes" class="box">';
		else
			newCell.innerHTML = '<input type="text" id="amount" name="amount" value="' + amount_ + '" onBlur="if(this.value.length==0 || filterNumBasket(this.value,'+amount_round+')==0) this.value = \'1\';<cfif ListFindNoCase(display_list, "darali") and  ListFindNoCase(display_list, "dara")>dara_miktar_hesabi(this.parentNode.parentNode.rowIndex,3);<cfelse>hesapla(\'amount\',this.parentNode.parentNode.rowIndex);</cfif>" onkeyup="return(FormatCurrency(this,event,'+amount_round+'));" style="width:#ListGetAt(display_field_width_list, dli, ",")#px;" class="box" onFocus="form_basket.control_field_value.value=filterNumBasket(this.value,amount_round);this.select();">';
	</cfcase>
	<cfcase value="unit">
		newCell.innerHTML = '<input type="text" id="unit" name="unit" value="' + unit_ + '" style="width:#ListGetAt(display_field_width_list, dli, ",")#px;" class="boxtext" readonly=yes>';
	</cfcase>
	<cfcase value="product_name2">
		newCell.style.textAlign = 'right';
		newCell.innerHTML = ' <input type="text" id="product_name_other" name="product_name_other" value="' + product_name_other + '" style="width:#ListGetAt(display_field_width_list, dli, ",")#px;"  class="boxtext" >';
	</cfcase>
	<cfcase value="amount2">
		newCell.innerHTML = '<input type="text" id="amount_other" name="amount_other" value="' + amount_other + '" onkeyup="return(FormatCurrency(this,event,'+price_round_number+'));" style="width:#ListGetAt(display_field_width_list, dli, ",")#px;" onBlur="if(this.value.length == 0) this.value = \'0,0000\';hesapla(\'amount_other\',this.parentNode.parentNode.rowIndex);" class="box">';
	</cfcase>
	<cfcase value="unit2">
		<cfif ListFindNoCase(display_list, "is_use_add_unit")>
			var get_product_unit =wrk_safe_query('prdp_get_unit2_all','dsn3',0,product_id);
			str_html = '<select name="unit_other" style="width:#ListGetAt(display_field_width_list, dli, ",")#px;" class="boxtext" onchange="hesapla(\'amount_other\',this.parentNode.parentNode.rowIndex);">';
			for(var kk=0;kk<get_product_unit.recordcount;kk++)
			{
				if(get_product_unit.ADD_UNIT[kk] == unit_other)
				{
					str_html+='<option value=';
					str_html+='"';
					str_html+=get_product_unit.ADD_UNIT[kk];
					str_html+='"';
					str_html+=' selected>';
					str_html+=get_product_unit.ADD_UNIT[kk];
					str_html+='</option>';
				}
				else
				{
					str_html+='<option value=';
					str_html+='"';
					str_html+=get_product_unit.ADD_UNIT[kk];
					str_html+='"';
					str_html+='>';
					str_html+=get_product_unit.ADD_UNIT[kk];
					str_html+='</option>';
				}
			}
			str_html+='</select>';
			newCell.innerHTML=str_html;
		<cfelse>
			newCell.innerHTML = '<input type="text" id="unit_other" name="unit_other" value="' + unit_other + '" style="width:#ListGetAt(display_field_width_list, dli, ",")#px;" class="boxtext" maxlength="5">';
		</cfif>
	</cfcase>
	<cfcase value="ek_tutar">
		newCell.innerHTML = '<input type="text" id="ek_tutar" name="ek_tutar" value="' + ek_tutar + '" style="width:#ListGetAt(display_field_width_list, dli, ",")#px;" class="box"<cfif ListFindNoCase(basket_read_only_price_list, "ek_tutar")>readonly<cfelse> onBlur="if(this.value.length == 0) this.value = \'0,0000\';ek_tutar_hesapla(this.parentNode.parentNode.rowIndex,\'ek_tutar\');hesapla(\'ek_tutar\',this.parentNode.parentNode.rowIndex);" onkeyup="return(FormatCurrency(this,event,'+price_round_number+'));"  onFocus="form_basket.control_field_value.value=filterNumBasket(this.value,price_round_number);this.select();"</cfif>>';
	</cfcase>
	<cfcase value="ek_tutar_price">
		newCell.innerHTML = '<input type="text" id="ek_tutar_price" name="ek_tutar_price" value="'+ ek_tutar_price +'" style="width:#ListGetAt(display_field_width_list, dli, ",")#px;" class="box"<cfif ListFindNoCase(basket_read_only_price_list, "ek_tutar_price")>readonly<cfelse> onBlur="if(this.value.length == 0) this.value = \'0,0000\';ek_tutar_hesapla(this.parentNode.parentNode.rowIndex,\'ek_tutar_price\');" onkeyup="return(FormatCurrency(this,event,'+price_round_number+'));"  onFocus="form_basket.control_field_value.value=filterNumBasket(this.value,price_round_number);this.select();"</cfif>>';
	</cfcase>
	<cfcase value="ek_tutar_cost">
		newCell.innerHTML = '<input type="text" id="ek_tutar_cost" name="ek_tutar_cost" value="'+ek_tutar_cost+'" style="width:#ListGetAt(display_field_width_list, dli, ",")#px;" class="box"<cfif ListFindNoCase(basket_read_only_price_list, "ek_tutar_cost")>readonly<cfelse> onBlur="if(this.value.length == 0) this.value = \'0,0000\';ek_tutar_hesapla(this.parentNode.parentNode.rowIndex,\'ek_tutar_cost\');" onkeyup="return(FormatCurrency(this,event,'+price_round_number+'));"  onFocus="form_basket.control_field_value.value=filterNumBasket(this.value,price_round_number);this.select();"</cfif>>';
	</cfcase>
	<cfcase value="ek_tutar_marj">
		newCell.innerHTML = '<input type="text" id="ek_tutar_marj" name="ek_tutar_marj" value="'+ek_tutar_marj+'" style="width:#ListGetAt(display_field_width_list, dli, ",")#px;" class="box"<cfif ListFindNoCase(basket_read_only_price_list, "ek_tutar_marj")>readonly<cfelse> onBlur="if(this.value.length == 0) this.value = \'0,00\';ek_tutar_hesapla(this.parentNode.parentNode.rowIndex,\'ek_tutar_marj\');" onkeyup="return(FormatCurrency(this,event));" onFocus="form_basket.control_field_value.value=filterNumBasket(this.value,price_round_number);this.select();"</cfif>>';
	</cfcase>
	<cfcase value="ek_tutar_other_total">
		newCell.innerHTML = '<input type="text" id="ek_tutar_other_total" name="ek_tutar_other_total" value="' + ek_tutar_other_total + '" class="box" <cfif ListFindNoCase(basket_read_only_price_list, "ek_tutar_other_total")>readonly<cfelse>onkeyup="return(FormatCurrency(this,event,'+price_round_number+'));" style="width:#ListGetAt(display_field_width_list, dli, ",")#px;" onBlur="if(this.value.length == 0) this.value = \'0,0000\';hesapla(\'ek_tutar_other_total\',this.parentNode.parentNode.rowIndex);ek_tutar_hesapla(this.parentNode.parentNode.rowIndex,\'ek_tutar\');" onFocus="form_basket.control_field_value.value=filterNumBasket(this.value,price_round_number);this.select();"</cfif>>';
	</cfcase>
	<cfcase value="spec">
		newCell.innerHTML = '<input type="hidden" id="spect_id" name="spect_id" value="' + spect_id + '">';
		if(<cfoutput>#Listfind(display_list,'spec_product_cat_property',",")#</cfoutput> > 0 && is_production ==1)
		{
			newCell.innerHTML+= '<input type="hidden" id="spect_name" name="spect_name" value="' + spect_name + '">';
			var spec_property_sql='SELECT PP.PROPERTY_ID, REPLACE(PP.PROPERTY,\'"\',\' \') PROPERTY FROM PRODUCT_PROPERTY PP WHERE PP.PROPERTY_ID IN (SELECT PRODUCT_CAT_PROPERTY.PROPERTY_ID FROM PRODUCT_CAT_PROPERTY,PRODUCT WHERE PRODUCT_ID='+product_id+' AND PRODUCT_CAT_PROPERTY.PRODUCT_CAT_ID = PRODUCT.PRODUCT_CATID ) ORDER BY PP.PROPERTY';
			var get_prod_cat_property =wrk_query(spec_property_sql,'dsn1');
			var str_html='';
			if(get_prod_cat_property.recordcount)
			{		
				if(document.form_basket.spect_id.length==undefined) obj_count=1; else obj_count=document.form_basket.spect_id.length;
				str_html+='<table><tr>';
				str_html+='<input type="hidden" id="spec_cat_property_recordcount'+obj_count+'" name="spec_cat_property_recordcount'+obj_count+'" value="'+get_prod_cat_property.recordcount+'">';
				for(var spct_ind=0;spct_ind < get_prod_cat_property.recordcount;spct_ind++)
				{
					str_html+='<td>';
					str_html+='<input type="hidden" id="spec_cat_property_'+obj_count+'_'+spct_ind+'" name="spec_cat_property_'+obj_count+'_'+spct_ind+'" value="">';
					str_html+='<div id="spect_property_info'+obj_count+'_'+spct_ind+'" style="display:none"></div>';
					str_html+='<input type="text" id="property_name_'+obj_count+'_'+spct_ind+'" name="property_name_'+obj_count+'_'+spct_ind+'" value="'+get_prod_cat_property.PROPERTY[spct_ind]+'" style="width:#ListGetAt(display_field_width_list, dli, ",")#px;" onkeyup="AjaxPageLoad(\'<cfoutput>#request.self#?fuseaction=objects.popup_ajax_spect_property_cats&form_name=form_basket&field_id=spec_cat_property_'+obj_count+'_'+spct_ind+'&field_name=property_name_'+obj_count+'_'+spct_ind+'&is_multi_no='+obj_count+'_'+spct_ind+'&property_id='+get_prod_cat_property.PROPERTY_ID[spct_ind]+'&default_property_name='+get_prod_cat_property.PROPERTY[spct_ind]+'</cfoutput>\',\'spect_property_info'+obj_count+'_'+spct_ind+'\',1)">';
					str_html+='<div id="spect_cat_prpty_'+obj_count+'_'+spct_ind+'" style="display:none;width:10px; position:absolute; margin-left:-#ListGetAt(display_field_width_list, dli, ",")#; margin-top:20; border: none; z-index:1000;"><table class="color-border" cellpadding="2" cellspacing="1" width="100%"><tr height="18" class="color-row"><td id="property_td_'+obj_count+'_'+spct_ind+'"></td></tr></table></div>';
					str_html+='</td>';
				}
				str_html+='</tr></table>';
			}
		}
		else
		{
			str_html= '<input type="text" id="spect_name" name="spect_name" value="' + spect_name + '" style="width:#ListGetAt(display_field_width_list, dli, ",")#px;" class="boxtext" readonly=yes>';
		}
		newCell.innerHTML+=str_html + '<a href="javascript://" onclick="open_spec(this.parentNode.parentNode.rowIndex);"><cfif isdefined('div_ayarla')><div style="position:absolute;margin-left:-3px;; cursor:pointer; margin-top:-23px;"></cfif><img src="/images/plus_thin.gif" align="absmiddle" border="0"><cfif isdefined('div_ayarla')></div></cfif></a>';
	</cfcase>
	<cfcase value="list_price">
		newCell.innerHTML = '<input type="text" id="list_price" name="list_price" style="width:#ListGetAt(display_field_width_list, dli, ",")#px;" value="' + list_price + '" class="box" readonly="yes">';
	</cfcase>
	<cfcase value="list_price_discount">
		newCell.innerHTML = '<input type="text" id="list_price_discount" name="list_price_discount" style="width:#ListGetAt(display_field_width_list, dli, ",")#px;" value="" class="box"<cfif ListFindNoCase(basket_read_only_discount_list, "list_price_discount")>readonly<cfelse> onBlur="if(this.value.length == 0) this.value = \'0\';marj_maliyet_hesabi(this.parentNode.parentNode.rowIndex,1,\'list_price_discount\');" onkeyup="return(FormatCurrency(this,event,2));"  onFocus="form_basket.control_field_value.value=filterNumBasket(this.value,price_round_number);this.select();" </cfif>>';
	</cfcase>
	<cfcase value="tax_price">
		newCell.innerHTML = '<input type="text" id="tax_price" name="tax_price" style="width:#ListGetAt(display_field_width_list, dli, ",")#px;" value="' + ((net_total+row_tax_total+row_otv_total)/amount_) + '" class="box" <cfif ListFindNoCase(basket_read_only_price_list, "tax_price")>readonly<cfelse>onBlur="if(this.value.length == 0) this.value = \'0\';kdvdahildenhesapla(this.parentNode.parentNode.rowIndex,\'tax_price\');" onkeyup="return(FormatCurrency(this,event,'+price_round_number+'));"  onFocus="form_basket.control_field_value.value=filterNumBasket(this.value,price_round_number);this.select();"</cfif>>';
	</cfcase>
	<cfcase value="price">
		if(row_unique_relation_id != undefined && row_unique_relation_id != '') //karma koli icerigindeki urunlerde fiyat degistirilmemesi icin
			newCell.innerHTML = '<input type="text" id="price" name="price" style="width:#ListGetAt(display_field_width_list, dli, ",")#px;" value="' + price + '" class="box" readonly>';
		else
		{
			newCell.innerHTML = '<input type="text" id="price" name="price" style="width:#ListGetAt(display_field_width_list, dli, ",")#px;" value="' + price + '" class="box" <cfif ListFindNoCase(basket_read_only_price_list, "price")>readonly<cfelse>onBlur="if(this.value.length == 0) this.value = \'0\';<cfif ListFindNoCase(display_list, "net_maliyet") and ListFindNoCase(display_list, "marj")>marj_maliyet_hesabi(this.parentNode.parentNode.rowIndex,4);<cfelse>hesapla(\'price\',this.parentNode.parentNode.rowIndex);</cfif>" onkeyup="return(FormatCurrency(this,event,'+price_round_number+'));" onFocus="form_basket.control_field_value.value=filterNumBasket(this.value,price_round_number);this.select();" </cfif>>';
			<cfif not listfindnocase(basket_read_only_price_list,'price')> 
			newCell.innerHTML+= ' <a href="javascript://" onclick="open_price(this.parentNode.parentNode.rowIndex);"><img src="/images/plus_thin.gif" align="absmiddle" border="0"></a>';
			</cfif>
		}
	</cfcase>
	<cfcase value="price_other">
		newCell.innerHTML = '<input type="text" id="price_other" name="price_other" style="width:#ListGetAt(display_field_width_list, dli, ",")#px;" value="' + wrk_round(price_other,price_round_number) + '" class="box" <cfif ListFindNoCase(basket_read_only_price_list, "price_other")>readonly<cfelse>onBlur="if(this.value.length == 0) this.value = \'0,0000\';hesapla(\'price_other\',this.parentNode.parentNode.rowIndex);" onkeyup="return(FormatCurrency(this,event,'+price_round_number+'));" onFocus="form_basket.control_field_value.value=filterNumBasket(this.value,price_round_number);this.select();"</cfif>>';
	</cfcase>
	<cfcase value="price_net">
		newCell.innerHTML = '<input type="text" id="price_net" name="price_net" style="width:#ListGetAt(display_field_width_list, dli, ",")#px;" value="' + wrk_round(price_net,price_round_number) + '" class="box" readonly=yes>';
	</cfcase>
	<cfcase value="price_net_doviz">
		newCell.innerHTML = '<input type="text" id="price_net_doviz" name="price_net_doviz" style="width:#ListGetAt(display_field_width_list, dli, ",")#px;" value="' + wrk_round(price_net_doviz,price_round_number) + '" class="box" readonly=yes>';
	</cfcase>
	<cfcase value="tax">
		newCell.innerHTML = '<input type="text" id="tax" name="tax" style="width:#ListGetAt(display_field_width_list, dli, ",")#px;" value="' + tax + '" class="box" <cfif ListFindNoCase(basket_read_only_price_list, "tax")>readonly<cfelse> onBlur="if(this.value.length == 0) this.value = \'0\';hesapla(\'tax\',this.parentNode.parentNode.rowIndex);" onkeyup="return(FormatCurrency(this,event,0));" onFocus="form_basket.control_field_value.value=filterNumBasket(this.value,price_round_number);this.select();"</cfif>>';
	</cfcase>
	<cfcase value="OTV">
		newCell.innerHTML = '<input type="text" id="otv_oran" name="otv_oran" style="width:#ListGetAt(display_field_width_list, dli, ",")#px;" value="' + otv + '" class="box" <cfif ListFindNoCase(basket_read_only_price_list, "OTV")>readonly<cfelse>onBlur="if(this.value.length == 0) this.value = \'0\';hesapla(\'otv_oran\',this.parentNode.parentNode.rowIndex);" onkeyup="return(FormatCurrency(this,event,price_round_number));" onFocus="form_basket.control_field_value.value=filterNumBasket(this.value,price_round_number);this.select();"</cfif>>';
	</cfcase>
	<cfcase value="duedate">
		newCell.innerHTML = '<input type="text" id="duedate" name="duedate" style="width:#ListGetAt(display_field_width_list, dli, ",")#px;" value="' + duedate + '" class="box" <cfif session.ep.duedate_valid eq 1> readonly="yes" <cfelse> onBlur="<cfif not listfindnocase(display_list,"number_of_installment")>set_basket_duedate_price(this.parentNode.parentNode.rowIndex-1);</cfif>hesapla(\'duedate\',this.parentNode.parentNode.rowIndex);" onkeyup="return(FormatCurrency(this,event,0));" onFocus="form_basket.control_field_value.value=filterNumBasket(this.value,price_round_number);this.select();"</cfif>>';
		//arr_duedate[rowCount] = duedate.toString();
	</cfcase>
	<cfcase value="number_of_installment">
		newCell.innerHTML = '<input type="text" id="number_of_installment" name="number_of_installment" style="width:#ListGetAt(display_field_width_list, dli, ",")#px;" value="' + number_of_installment + '" class="box" onBlur="if(this.value.length == 0) this.value = \'0\';basket_taksit_hesapla(this.parentNode.parentNode.rowIndex-1);" onkeyup="return(FormatCurrency(this,event,0));" onFocus="form_basket.control_field_value.value=filterNumBasket(this.value,price_round_number);this.select();">';
	</cfcase>
	<cfcase value="iskonto_tutar">
		newCell.innerHTML = '<input type="text" id="iskonto_tutar" name="iskonto_tutar" style="width:#ListGetAt(display_field_width_list, dli, ",")#px;" value="' + iskonto_tutar + '" class="box" <cfif ListFindNoCase(basket_read_only_discount_list, "iskonto_tutar")>readonly<cfelse>onBlur="if(this.value.length == 0) this.value = \'0,0000\';hesapla(\'iskonto_tutar\',this.parentNode.parentNode.rowIndex);" onkeyup="return(FormatCurrency(this,event,'+price_round_number+'));" onFocus="form_basket.control_field_value.value=filterNumBasket(this.value,price_round_number);this.select();"</cfif>>';
	</cfcase>
	<cfcase value="disc_ount">
		newCell.innerHTML = '<input type="text" id="indirim1" name="indirim1" style="width:#ListGetAt(display_field_width_list, dli, ",")#px;" value="' + d1 + '" class="box"<cfif ListFindNoCase(basket_read_only_discount_list, "disc_ount")>readonly<cfelse> onBlur="if(this.value.length == 0) this.value = \'0\';basket_last_input_new_value=this.value;<cfif attributes.basket_id is 51>control_prod_discount(this.parentNode.parentNode.rowIndex-1);</cfif>hesapla(\'indirim1\',this.parentNode.parentNode.rowIndex);" onkeyup="return(FormatCurrency(this,event,2));" onFocus="form_basket.control_field_value.value=filterNumBasket(this.value,price_round_number);this.select();"</cfif>>';
	</cfcase>
	<cfcase value="disc_ount2_">
		newCell.innerHTML = '<input type="text" id="indirim2" name="indirim2" style="width:#ListGetAt(display_field_width_list, dli, ",")#px;"  value="' + d2 + '" class="box" <cfif ListFindNoCase(basket_read_only_discount_list, "disc_ount2_")>readonly<cfelse>onBlur="if(this.value.length == 0) this.value = \'0\';hesapla(\'indirim2\',this.parentNode.parentNode.rowIndex);" onkeyup="return(FormatCurrency(this,event,2));" onFocus="form_basket.control_field_value.value=filterNumBasket(this.value,price_round_number);this.select();"</cfif>>';
	</cfcase>
	<cfcase value="disc_ount3_">
		newCell.innerHTML = '<input type="text" id="indirim3" name="indirim3" style="width:#ListGetAt(display_field_width_list, dli, ",")#px;" value="' + d3 + '" class="box" <cfif ListFindNoCase(basket_read_only_discount_list, "disc_ount3_")>readonly<cfelse>onBlur="if(this.value.length == 0) this.value = \'0\';hesapla(\'indirim3\',this.parentNode.parentNode.rowIndex);" onkeyup="return(FormatCurrency(this,event,2));" onFocus="form_basket.control_field_value.value=filterNumBasket(this.value,price_round_number);this.select();"</cfif>>';
	</cfcase>
	<cfcase value="disc_ount4_">
		newCell.innerHTML = '<input type="text" id="indirim4" name="indirim4" style="width:#ListGetAt(display_field_width_list, dli, ",")#px;" value="' + d4 + '" class="box" <cfif ListFindNoCase(basket_read_only_discount_list, "disc_ount4_")>readonly<cfelse>onBlur="if(this.value.length == 0) this.value = \'0\';hesapla(\'indirim4\',this.parentNode.parentNode.rowIndex);" onkeyup="return(FormatCurrency(this,event,2));" onFocus="form_basket.control_field_value.value=filterNumBasket(this.value,price_round_number);this.select();"</cfif>>';
	</cfcase>
	<cfcase value="disc_ount5_">
		newCell.innerHTML = '<input type="text" id="indirim5" name="indirim5" style="width:#ListGetAt(display_field_width_list, dli, ",")#px;" value="' + d5 + '" class="box" <cfif ListFindNoCase(basket_read_only_discount_list, "disc_ount5_")>readonly<cfelse>onBlur="if(this.value.length == 0) this.value = \'0\';hesapla(\'indirim5\',this.parentNode.parentNode.rowIndex);" onkeyup="return(FormatCurrency(this,event,2));" onFocus="form_basket.control_field_value.value=filterNumBasket(this.value,price_round_number);this.select();"</cfif>>';
	</cfcase>
	<cfcase value="disc_ount6_">
		newCell.innerHTML = '<input type="text" id="indirim6" name="indirim6" style="width:#ListGetAt(display_field_width_list, dli, ",")#px;" value="' + d6 + '" class="box" <cfif ListFindNoCase(basket_read_only_discount_list, "disc_ount6_")>readonly<cfelse>onBlur="if(this.value.length == 0) this.value = \'0\';hesapla(\'indirim6\',this.parentNode.parentNode.rowIndex);" onkeyup="return(FormatCurrency(this,event,2));" onFocus="form_basket.control_field_value.value=filterNumBasket(this.value,price_round_number);this.select();"</cfif>>';
	</cfcase>
	<cfcase value="disc_ount7_">
		newCell.innerHTML = '<input type="text" id="indirim7" name="indirim7" style="width:#ListGetAt(display_field_width_list, dli, ",")#px;" value="' + d7 + '" class="box" <cfif ListFindNoCase(basket_read_only_discount_list, "disc_ount7_")>readonly<cfelse>onBlur="if(this.value.length == 0) this.value = \'0\';hesapla(\'indirim7\',this.parentNode.parentNode.rowIndex);" onkeyup="return(FormatCurrency(this,event,2));" onFocus="form_basket.control_field_value.value=filterNumBasket(this.value,price_round_number);this.select();"</cfif>>';
	</cfcase>
	<cfcase value="disc_ount8_">
		newCell.innerHTML = '<input type="text" id="indirim8" name="indirim8" style="width:#ListGetAt(display_field_width_list, dli, ",")#px;" value="' + d8 + '" class="box" <cfif ListFindNoCase(basket_read_only_discount_list, "disc_ount8_")>readonly<cfelse> onBlur="if(this.value.length == 0) this.value = \'0\';hesapla(\'indirim8\',this.parentNode.parentNode.rowIndex);" onkeyup="return(FormatCurrency(this,event,2));" onFocus="form_basket.control_field_value.value=filterNumBasket(this.value,price_round_number);this.select();"</cfif>>';
	</cfcase>
	<cfcase value="disc_ount9_">
		newCell.innerHTML = '<input type="text" id="indirim9" name="indirim9" style="width:#ListGetAt(display_field_width_list, dli, ",")#px;" value="' + d9 + '" class="box" <cfif ListFindNoCase(basket_read_only_discount_list, "disc_ount9_")>readonly<cfelse>onBlur="if(this.value.length == 0) this.value = \'0\';hesapla(\'indirim9\',this.parentNode.parentNode.rowIndex);" onkeyup="return(FormatCurrency(this,event,2));" onFocus="form_basket.control_field_value.value=filterNumBasket(this.value,price_round_number);this.select();"</cfif>>';
	</cfcase>
	<cfcase value="disc_ount10_">
		newCell.innerHTML = '<input type="text" id="indirim10" name="indirim10" style="width:#ListGetAt(display_field_width_list, dli, ",")#px;" value="' + d10 + '" class="box" <cfif ListFindNoCase(basket_read_only_discount_list, "disc_ount10_")>readonly<cfelse>onBlur="if(this.value.length == 0) this.value = \'0\';hesapla(\'indirim10\',this.parentNode.parentNode.rowIndex);" onkeyup="return(FormatCurrency(this,event,2));" onFocus="form_basket.control_field_value.value=filterNumBasket(this.value,price_round_number);this.select();"</cfif>>';
	</cfcase>
	<cfcase value="row_total">
		newCell.innerHTML = '<input type="text" id="row_total" name="row_total"  style="width:100%;" value="' + wrk_round((parseFloat(price)+parseFloat(ek_tutar_system))*amount_,price_round_number) + '" class="box" <cfif ListFindNoCase(basket_read_only_price_list, "row_total")>readonly<cfelse> onBlur="if(this.value.length == 0) this.value = \'0,00\';hesapla(\'row_total\',this.parentNode.parentNode.rowIndex);" onkeyup="return(FormatCurrency(this,event,'+price_round_number+'));" onFocus="form_basket.control_field_value.value=filterNumBasket(this.value,price_round_number);this.select();"</cfif>>';
	</cfcase>
	<cfcase value="row_nettotal">
		newCell.innerHTML = '<input type="text" id="row_nettotal" name="row_nettotal"  style="width:#ListGetAt(display_field_width_list, dli, ",")#px;" value="' + net_total + '" class="box" readonly=yes>';
	</cfcase>
	<cfcase value="row_taxtotal">
		newCell.innerHTML = '<input type="text" id="row_taxtotal" name="row_taxtotal"  style="width:#ListGetAt(display_field_width_list, dli, ",")#px;" value="' + row_tax_total + '" class="box" <cfif ListFindNoCase(basket_read_only_price_list, "row_taxtotal")>readonly<cfelse>onBlur="if(this.value.length == 0) this.value = \'0,0000\';hesapla(\'row_taxtotal\',this.parentNode.parentNode.rowIndex);" onkeyup="return(FormatCurrency(this,event,'+price_round_number+'));" onFocus="form_basket.control_field_value.value=filterNumBasket(this.value,price_round_number);this.select();"</cfif>>';
	</cfcase>
	<cfcase value="row_otvtotal">
		newCell.innerHTML = '<input type="text" id="row_otvtotal" name="row_otvtotal"  style="width:#ListGetAt(display_field_width_list, dli, ",")#px;" value="' + row_otv_total + '" class="box"<cfif ListFindNoCase(basket_read_only_price_list, "row_otvtotal")>readonly<cfelse> onBlur="if(this.value.length == 0) this.value = \'0,0000\';hesapla(\'row_otvtotal\',this.parentNode.parentNode.rowIndex);" onkeyup="return(FormatCurrency(this,event,'+price_round_number+'));" onFocus="form_basket.control_field_value.value=filterNumBasket(this.value,price_round_number);this.select();"</cfif>>';
	</cfcase>
	<cfcase value="row_lasttotal">
		newCell.innerHTML = '<input type="text" id="row_lasttotal" name="row_lasttotal" style="width:#ListGetAt(display_field_width_list, dli, ",")#px;" value="' + wrk_round(net_total+row_tax_total+row_otv_total,price_round_number) + '" class="box"<cfif ListFindNoCase(basket_read_only_price_list, "row_lasttotal")>readonly<cfelse> onBlur="if(this.value.length == 0) this.value = \'0,00\';kdvdahildenhesapla(this.parentNode.parentNode.rowIndex,\'row_lasttotal\');" onkeyup="return(FormatCurrency(this,event,'+price_round_number+'));" onFocus="form_basket.control_field_value.value=filterNumBasket(this.value,price_round_number);this.select();"</cfif>>';
		//arr_row_lasttotal[rowCount] = wrk_round(net_total+row_tax_total+row_otv_total,price_round_number).toString();
	</cfcase>
	<cfcase value="other_money">
		newCell.style.textAlign = 'right';
		newCell.innerHTML = '<select id="other_money_" name="other_money_" style="width:#ListGetAt(display_field_width_list, dli, ",")#px;" onChange="hesapla(\'other_money_\',this.parentNode.parentNode.rowIndex);"><cfloop query="get_money_bskt"><option value="#money_type#">#money_type#</option></cfloop></select>';		
		for (var counter_temp=0; counter_temp < #get_money_bskt.recordcount#; counter_temp++)
			if(getIndexValue('other_money_', rowCount-1, counter_temp) == money)
				setSelectedIndex('other_money_', rowCount-1, counter_temp);
	</cfcase>
	<cfcase value="other_money_value">
		newCell.style.textAlign = 'right';
		newCell.innerHTML = '<input type="text" id="other_money_value_" name="other_money_value_" value="'+wrk_round(other_money_value_,price_round_number)+'" class="box" style="width:#ListGetAt(display_field_width_list, dli, ",")#px;" <cfif ListFindNoCase(basket_read_only_price_list, "other_money_value")>readonly<cfelse>onblur="if(this.value.length == 0) this.value = \'0,0000\';hesapla(\'other_money_value_\',this.parentNode.parentNode.rowIndex);" onkeyup="return(FormatCurrency(this,event,'+price_round_number+'));" onFocus="form_basket.control_field_value.value=filterNumBasket(this.value,price_round_number);this.select();"</cfif>>';
	</cfcase>
	<cfcase value="other_money_gross_total"> /*basket sablonlarında other_money_gross_total alanı other_money_value alanına baglı olarak secilebiliyor*/
		newCell.style.textAlign = 'right';
		newCell.innerHTML = '<input type="text" id="other_money_gross_total" name="other_money_gross_total" value="'+wrk_round(other_money_value_*(100+(parseFloat(tax)+(parseFloat(otv)*parseFloat(tax)/100))+parseFloat(otv))/100,price_round_number)+'" class="box" style="width:#ListGetAt(display_field_width_list, dli, ",")#px;" readonly=yes>';
	</cfcase>
	<cfcase value="deliver_date">
		newCell.style.textAlign = 'right';
		newCell.innerHTML = '<input type="text" name="deliver_date" id="deliver_date" style="width:#ListGetAt(display_field_width_list, dli, ",")#px;" value="' + deliver_date + '" class="boxtext" maxlength="10">';
		newCell.innerHTML +=' <a href="javascript://" onClick="get_basket_date(\'deliver_date\',(this.parentNode.parentNode.rowIndex-1));"><img src="/images/plus_thin.gif" align="absbottom" border="0"></a>';
	</cfcase>
	<cfcase value="reserve_date">
		newCell.style.textAlign = 'right';
		newCell.innerHTML = '<input type="text" id="reserve_date" name="reserve_date" style="width:#ListGetAt(display_field_width_list, dli, ",")#px;" value="'+ reserve_date +'" class="boxtext" maxlength="10">';
		newCell.innerHTML +=' <a href="javascript://" onClick="get_basket_date(\'reserve_date\',(this.parentNode.parentNode.rowIndex-1));"><img src="/images/plus_thin.gif" align="absbottom" border="0"></a>';
	</cfcase>
	<cfcase value="deliver_dept">
		newCell.style.textAlign = 'right';
		newCell.innerHTML = '<input type="hidden" id="deliver_dept" name="deliver_dept" value="' + deliver_dept + '">';
		newCell.innerHTML+= '<input type="Text" style="width:#ListGetAt(display_field_width_list, dli, ",")#px;" id="basket_row_departman" name="basket_row_departman" value="' + department_head + '" class="boxtext"> ';
		newCell.innerHTML+= '<a href="javascript://" onclick="windowopen(\'#request.self#?fuseaction=objects.popup_list_stores_locations&form_name=form_basket&field_name=basket_row_departman&field_id=deliver_dept&row_id=\'+this.parentNode.parentNode.rowIndex,\'list\')" ><img src="/images/plus_thin.gif"  align="absmiddle" border="0"></a>';
	</cfcase>
	<cfcase value="deliver_dept_assortment">
		newCell.style.textAlign = 'right';
		newCell.innerHTML+= '<a href="javascript://" onclick="windowopen(\'#request.self#?fuseaction=objects.popup_list_department_products&form_name=form_basket&field_name=basket_row_departman&field_id=deliver_dept&row_id=\'+this.parentNode.parentNode.rowIndex + \'&rowCount=\' + rowCount+ \'&stock_id=\' + get_stock_id(this.parentNode.parentNode.rowIndex) ,\'list\');" ><img src="/images/plus_thin.gif"  align="absmiddle" border="0"></a>';
	</cfcase>
	<cfcase value="shelf_number">
		if(shelf_number != undefined && shelf_number != '')
		{/* raf id sine baglı olarak raf kodu getiriliyor */
			var get_shelf_name =wrk_safe_query('obj_get_shelf_name','dsn3',0,shelf_number);
			if(get_shelf_name.recordcount && get_shelf_name.SHELF_CODE != '')
				var temp_shelf_number_ = get_shelf_name.SHELF_CODE;
			else
				var temp_shelf_number_ = '';
		}
		else
			var temp_shelf_number_ = '';
		newCell.innerHTML = '<input type="hidden" id="shelf_number" name="shelf_number" value="' + shelf_number + '">';
		newCell.innerHTML+= '<input type="text" id="shelf_number_txt" name="shelf_number_txt" onFocus="AutoComplete_Create(\'shelf_number_txt\',\'NAME\',\'NAME\',\'get_shelf_autocomplete\',\'\',\'NAME\',\'shelf_number_txt\',\'\',\'\');" onkeyup="get_wrk_shelf(this.parentNode.parentNode.rowIndex-1,rowCount);" value="'+ temp_shelf_number_ +'" style="width:#ListGetAt(display_field_width_list, dli, ",")#px;" class="boxtext">';
		newCell.innerHTML+= '<a href="javascript://" onclick="open_shelf_list(this.parentNode.parentNode.rowIndex,rowCount,0,\'shelf_number\',\'shelf_number_txt\')" ><img src="/images/plus_thin_m.gif" alt="#getLang("main",2204)#" border="0" align="absmiddle"></a>';
		newCell.innerHTML+= '<a href="javascript://" onclick="open_shelf_list(this.parentNode.parentNode.rowIndex,rowCount,1,\'shelf_number\',\'shelf_number_txt\')" ><img src="/images/plus_thin.gif" alt="#getLang("main",2205)#" border="0" align="absmiddle"></a>';
	</cfcase>
	<cfcase value="pbs_code">
		newCell.innerHTML = '<input type="hidden" id="pbs_id" name="pbs_id" value="">';
		newCell.innerHTML+= '<input type="text" id="pbs_code" name="pbs_code" style="width:#ListGetAt(display_field_width_list, dli, ",")#px;" class="boxtext">';
		newCell.innerHTML+= '<a href="javascript://" onclick="open_pbs_list(this.parentNode.parentNode.rowIndex,rowCount,0,\'pbs_id\',\'pbs_code\')" ><img src="/images/plus_thin_m.gif" alt="PBS" border="0" align="absmiddle"></a>';
	</cfcase>
	<cfcase value="shelf_number_2">
		if(to_shelf_number != undefined && to_shelf_number != '')
		{/* raf id sine baglı olarak raf kodu getiriliyor */
			var get_shelf_name =wrk_safe_query('obj_get_shelf_name','dsn3',0,to_shelf_number);
			if(get_shelf_name.recordcount && get_shelf_name.SHELF_CODE != '')
				var temp_shelf_number2_ = get_shelf_name.SHELF_CODE;
			else
				var temp_shelf_number2_ = '';
		}
		else
			var temp_shelf_number2_ = '';
		newCell.innerHTML = '<input type="hidden" id="to_shelf_number" name="to_shelf_number" value="' + to_shelf_number + '">';
		newCell.innerHTML+= '<input type="text" id="to_shelf_number_txt" name="to_shelf_number_txt" onkeyup="get_wrk_shelf(this.parentNode.parentNode.rowIndex-1,rowCount);" value="'+ temp_shelf_number2_ +'" style="width:#ListGetAt(display_field_width_list, dli, ",")#px;" class="boxtext">';
		newCell.innerHTML+= '<a href="javascript://" onclick="open_shelf_list(this.parentNode.parentNode.rowIndex,rowCount,0,\'to_shelf_number\',\'to_shelf_number_txt\')" ><img src="/images/plus_thin_m.gif" alt="#getLang('main',2204)#" border="0" align="absmiddle"></a>';
	</cfcase>
	<cfcase value="is_parse">
		newCell.innerHTML = '<a href="javascript://" onclick="open_assort(this.parentNode.parentNode.rowIndex);"><img src="/images/plus_thin.gif"  align="absmiddle" border="0"></a>';
	</cfcase>
	<cfcase value="lot_no">
		newCell.innerHTML = '<input type="text" maxlength="150" id="lot_no" name="lot_no" style="width:#ListGetAt(display_field_width_list, dli, ",")#px" value="' + lot_no + '" onKeyup="lotno_control(this.parentNode.parentNode.rowIndex-1);" class="boxtext"> <a href="javascript://" onclick="open_lot_no_list(this.parentNode.parentNode.rowIndex);"><img src="/images/plus_thin.gif" style="cursor:pointer;" align="absbottom" border="0"></a>';
	</cfcase>
	<cfcase value="net_maliyet">
		newCell.style.textAlign = 'right';
		newCell.innerHTML = '<input type="text" id="net_maliyet" name="net_maliyet" style="width:100%;"  value="' + net_maliyet + '" class="box" <cfif ListFindNoCase(basket_read_only_price_list, "net_maliyet")>readonly<cfelse> onBlur="if(this.value.length==0) this.value = \'0,0000\';marj_maliyet_hesabi(this.parentNode.parentNode.rowIndex,1,\'net_maliyet\');" onkeyup="return(FormatCurrency(this,event,'+price_round_number+'));" onFocus="form_basket.control_field_value.value=filterNumBasket(this.value,price_round_number);this.select();"</cfif>>';
	</cfcase>
	<cfcase value="marj">
		newCell.style.textAlign = 'right';
		newCell.innerHTML = '<input type="text" id="marj" name="marj" style="width:100%;" value="' + flt_marj +'" class="box" <cfif ListFindNoCase(basket_read_only_price_list, "marj")>readonly<cfelse><cfif ListFindNoCase(display_list, "net_maliyet")> onBlur="if(this.value.length==0) this.value = \'0,00\';marj_maliyet_hesabi(this.parentNode.parentNode.rowIndex,2);"</cfif> onkeyup="return(FormatCurrency(this,event));" onFocus="form_basket.control_field_value.value=filterNumBasket(this.value,price_round_number);this.select();"</cfif>>';
	</cfcase>
	<cfcase value="extra_cost">
		newCell.style.textAlign = 'right';
		newCell.innerHTML = '<input type="text" id="extra_cost" name="extra_cost" style="width:100%;" value="' + extra_cost +'" class="box" <cfif ListFindNoCase(basket_read_only_price_list, "extra_cost")>readonly<cfelse>onBlur="if(this.value.length==0) this.value=\'0,0000\';marj_maliyet_hesabi(this.parentNode.parentNode.rowIndex,1,\'extra_cost\');" onkeyup="return(FormatCurrency(this,event,'+price_round_number+'));" onFocus="form_basket.control_field_value.value=filterNumBasket(this.value,price_round_number);this.select();"</cfif>>';
	</cfcase>	
	<cfcase value="extra_cost_rate">
		if(net_maliyet!='' && net_maliyet!=0 && extra_cost!='')
			var extra_cost_rate_ = wrk_round((extra_cost/net_maliyet)*100) ;
		else
			var extra_cost_rate_ = 0;
		newCell.style.textAlign = 'right';
		newCell.innerHTML = '<input type="text" id="extra_cost_rate" name="extra_cost_rate" style="width:100%;"  value="'+ extra_cost_rate_ +'" class="box" <cfif ListFindNoCase(basket_read_only_price_list, "extra_cost_rate")>readonly<cfelse> onBlur="if(this.value.length==0) this.value = \'0,0000\';<cfif ListFindNoCase(display_list,"net_maliyet") and  ListFindNoCase(display_list, "extra_cost")>marj_maliyet_hesabi(this.parentNode.parentNode.rowIndex,1,\'extra_cost_rate\')</cfif>" onkeyup="return(FormatCurrency(this,event));" onFocus="form_basket.control_field_value.value=filterNumBasket(this.value,price_round_number);this.select();"</cfif>>';
	</cfcase>
	<cfcase value="row_cost_total">
		if(net_maliyet!='' && net_maliyet!=0)
			row_cost_total_ +=parseFloat(net_maliyet);
		if(extra_cost!='' && extra_cost!=0)
			row_cost_total_ +=parseFloat(extra_cost);
		newCell.style.textAlign = 'right';
		newCell.innerHTML = '<input type="text" id="row_cost_total" name="row_cost_total" style="width:100%;" value="'+row_cost_total_+'" class="box" <cfif ListFindNoCase(basket_read_only_price_list, "row_cost_total")>readonly<cfelse> onBlur="if(this.value.length==0) this.value = \'0,0000\';" onkeyup="return(FormatCurrency(this,event,'+price_round_number+'));"</cfif>>';
	</cfcase>	
	<cfcase value="dara">
		newCell.style.textAlign = 'right';
		newCell.innerHTML = '<input type="text" id="dara" name="dara" style="width:100%;" value="0" <cfif ListFindNoCase(display_list,"darali")>onBlur="if(this.value.length==0) this.value = \'0,00\';dara_miktar_hesabi(this.parentNode.parentNode.rowIndex,2);"</cfif> onkeyup="return(FormatCurrency(this,event,'+amount_round+'));" onFocus="form_basket.control_field_value.value=filterNumBasket(this.value,price_round_number);this.select();" class="box">';
	</cfcase>
	<cfcase value="darali">
		newCell.style.textAlign = 'right';
		newCell.innerHTML = '<input type="text" id="darali" name="darali" style="width:100%;" value=" <cfif ListFindNoCase(display_list,"amount")>'+ amount_ +'<cfelse>1</cfif>"<cfif ListFindNoCase(display_list, "dara")>onBlur="if(this.value.length==0) this.value = \'0,00\';dara_miktar_hesabi(this.parentNode.parentNode.rowIndex,1);"</cfif> onkeyup="return(FormatCurrency(this,event,'+amount_round+'));" class="box">';
	</cfcase>
	<cfcase value="promosyon_yuzde">
		newCell.style.textAlign = 'right';
		newCell.innerHTML = '<input type="text" id="promosyon_yuzde" name="promosyon_yuzde" style="width:100%;" value="' + promosyon_yuzde +'" onBlur="if(this.value.length==0) this.value=\'0,00\';else if(this.value.length && filterNumBasket(this.value) >= 100) this.value=\'0,00\';hesapla(\'promosyon_yuzde\',this.parentNode.parentNode.rowIndex);" onkeyup="return(FormatCurrency(this,event));" onFocus="form_basket.control_field_value.value=filterNumBasket(this.value,price_round_number);this.select();" class="box">';
	</cfcase>
	<cfcase value="promosyon_maliyet">
		newCell.style.textAlign = 'right';
		newCell.innerHTML = '<input type="text" id="promosyon_maliyet" name="promosyon_maliyet" style="width:100%;" value="' + promosyon_maliyet +'" onkeyup="return(FormatCurrency(this,event,'+price_round_number+'));" onFocus="if(this.value == \'0,0000\') this.value = \'\';" class="box">';
	</cfcase>
	<cfcase value="order_currency">
		newCell.innerHTML = '<select id="order_currency" name="order_currency" style="width:#ListGetAt(display_field_width_list, dli, ",")#px;"><cfloop from="1" to="#listlen(order_currency_list)#" index="cur_list"><option value="#-1*cur_list#">#ListGetAt(order_currency_list,cur_list,",")#</option></cfloop></select>';
	</cfcase>
	<cfcase value="reserve_type">
		newCell.innerHTML = '<select id="reserve_type" name="reserve_type" style="width:#ListGetAt(display_field_width_list, dli, ",")#px;"><cfloop from="1" to="#listlen(reserve_type_list)#" index="rsv_i"><option value="#-1*rsv_i#">#ListGetAt(reserve_type_list,rsv_i,",")#</option></cfloop></select>';
		if(form_basket.reserved !=undefined && form_basket.reserved.checked ==false)/*siparis sayfalarındaki stok reserve et secili degilse satırlar defaul reserve_degil olarak getiriliyor. reserve tipi listesi sabit oldugu icin standart 2 degeri verildi, liste degisirse bu degerde yenilenmeli*/
			setSelectedIndex('reserve_type', rowCount-1, 2);
	</cfcase>
	<cfcase value="row_width">
		newCell.style.textAlign = 'right';
		newCell.innerHTML = '<input type="text" id="row_width" name="row_width" style="width:100%;" value="' + row_width +'" class="box" <cfif ListFindNoCase(basket_read_only_price_list, "row_width")>readonly </cfif> onkeyup="return(FormatCurrency(this,event,2));">';
	</cfcase>
	<cfcase value="row_depth">
		newCell.style.textAlign = 'right';
		newCell.innerHTML = '<input type="text" id="row_depth" name="row_depth" style="width:100%;" value="' + row_depth +'" class="box" <cfif ListFindNoCase(basket_read_only_price_list, "row_depth")>readonly </cfif> onkeyup="return(FormatCurrency(this,event,2));">';
	</cfcase>
	<cfcase value="row_height">
		newCell.style.textAlign = 'right';
		newCell.innerHTML = '<input type="text" id="row_height" name="row_height" style="width:100%;" value="' + row_height +'" class="box" <cfif ListFindNoCase(basket_read_only_price_list, "row_height")>readonly</cfif> onkeyup="return(FormatCurrency(this,event));">';
	</cfcase>
	<cfcase value="basket_extra_info">
		newCell.innerHTML = '<select id="basket_extra_info" name="basket_extra_info" style="width:#ListGetAt(display_field_width_list, dli, ",")#px;"><cfloop list="#basket_info_list#" index="info_list"><option value="#listfirst(info_list,';')#">#listlast(info_list,";")#</option></cfloop></select>';
		if(basket_extra_info != undefined && basket_extra_info != '') /*ek acıklama id si gonderilmisse, ilgili tanım secili hale getiriliyor*/
		{
			if(document.form_basket.product_id.length != undefined) 
				basket_extra_info_new = document.form_basket.basket_extra_info[rowCount-1];
			else
				basket_extra_info_new = document.form_basket.basket_extra_info;
				
			if(basket_extra_info_new.options.length != undefined)
			{
				for(var inf_count_=0; inf_count_ < basket_extra_info_new.options.length; inf_count_++)
					if(basket_extra_info_new.options[inf_count_].value == basket_extra_info)
						setSelectedIndex('basket_extra_info', rowCount-1, inf_count_);
			}
		}
	</cfcase>
	<cfcase value="select_info_extra">
		newCell.innerHTML = '<select id="select_info_extra" name="select_info_extra" style="width:#ListGetAt(display_field_width_list, dli, ",")#px;"><cfloop list="#select_info_extra_list#" index="extra_list"><option value="#listfirst(extra_list,';')#">#listlast(extra_list,";")#</option></cfloop></select>';
		if(select_info_extra != undefined && select_info_extra != '') /*ek acıklama id si gonderilmisse, ilgili tanım secili hale getiriliyor*/
		{
			if(document.form_basket.product_id.length != undefined) 
				select_info_extra_new = document.form_basket.select_info_extra[rowCount-1];
			else
				select_info_extra_new = document.form_basket.select_info_extra;
				
			if(select_info_extra_new.options.length != undefined)
			{
				for(var inf_count_=0; inf_count_ < select_info_extra_new.options.length; inf_count_++)
					if(select_info_extra_new.options[inf_count_].value == select_info_extra)
						setSelectedIndex('select_info_extra', rowCount-1, inf_count_);
			}
		}
	</cfcase>
	<cfcase value="detail_info_extra">
		newCell.style.textAlign = 'right';
		newCell.innerHTML = ' <input type="text" id="detail_info_extra" name="detail_info_extra" value="' + detail_info_extra + '" style="width:#ListGetAt(display_field_width_list, dli, ",")#px;"  class="boxtext" >';
	</cfcase>

	<cfcase value="basket_employee">
		newCell.innerHTML = '<input type="hidden" id="basket_employee_id" name="basket_employee_id" value="'+basket_employee_id+'">';
		newCell.innerHTML+= '<input type="text" id="basket_employee" name="basket_employee" value="'+basket_employee+'" style="width:#ListGetAt(display_field_width_list, dli, ",")#px;" class="boxtext">';
		newCell.innerHTML+= '<a href="javascript://" onclick="open_basket_employee_popup(this.parentNode.parentNode.rowIndex-1)"><img src="/images/plus_thin.gif" border="0" align="absmiddle"></a>';
	</cfcase>
	<cfcase value="basket_project">
		newCell.innerHTML = '<input type="hidden" id="row_project_id" name="row_project_id" value="' + row_project_id + '">';
		newCell.innerHTML+= '<input type="text" id="row_project_name" name="row_project_name" value="'+ row_project_name +'" style="width:#ListGetAt(display_field_width_list, dli, ",")#px;" class="boxtext">';
		newCell.innerHTML+= '<a href="javascript://" onclick="open_basket_project_popup(this.parentNode.parentNode.rowIndex-1)"><img src="/images/plus_thin.gif" border="0" align="absmiddle"></a>';
	</cfcase>
	<cfcase value="basket_work">
		newCell.innerHTML = '<input type="hidden" id="row_work_id" name="row_work_id" value="' + row_work_id + '">';
		newCell.innerHTML+= '<input type="text" id="row_work_name" name="row_work_name" value="'+ row_work_name +'" style="width:#ListGetAt(display_field_width_list, dli, ",")#px;" class="boxtext">';
		newCell.innerHTML+= '<a href="javascript://" onclick="open_basket_work_popup(this.parentNode.parentNode.rowIndex-1)"><img src="/images/plus_thin.gif" border="0" align="absmiddle"></a>';
	</cfcase>
	//alis faturalarina masraf merkezi, butce kalemi ve muhasebe kodu eklendi//
	<cfcase value="basket_exp_center">
		newCell.innerHTML = '<input type="hidden" id="row_exp_center_id" name="row_exp_center_id" value="' + row_exp_center_id + '">';
		newCell.innerHTML+= '<input type="text" id="row_exp_center_name" name="row_exp_center_name" value="'+ row_exp_center_name +'" style="width:#ListGetAt(display_field_width_list, dli, ",")#px;" class="boxtext">';
		newCell.innerHTML+= '<a href="javascript://" onclick="open_basket_exp_center_popup(this.parentNode.parentNode.rowIndex-1)"><img src="/images/plus_thin.gif" border="0" align="absmiddle"></a>';
	</cfcase>
	<cfcase value="basket_exp_item">
		newCell.innerHTML = '<input type="hidden" id="row_exp_item_id" name="row_exp_item_id" value="' + row_exp_item_id + '">';
		newCell.innerHTML+= '<input type="text" id="row_exp_item_name" name="row_exp_item_name" value="'+ row_exp_item_name +'" style="width:#ListGetAt(display_field_width_list, dli, ",")#px;" class="boxtext">';
		newCell.innerHTML+= '<a href="javascript://" onclick="open_basket_exp_item_popup(this.parentNode.parentNode.rowIndex-1)"><img src="/images/plus_thin.gif" border="0" align="absmiddle"></a>';
	</cfcase>
	<cfcase value="basket_acc_code">
		newCell.innerHTML = '<input type="text" id="row_acc_code" name="row_acc_code" value="' + row_acc_code + '" style="width:#ListGetAt(display_field_width_list, dli, ",")#px;" class="boxtext">';
		newCell.innerHTML+= '<a href="javascript://" onclick="open_basket_acc_code_popup(this.parentNode.parentNode.rowIndex-1)"><img src="/images/plus_thin.gif" border="0" align="absmiddle"></a>';
	</cfcase>
	//alis faturalarina masraf merkezi, butce kalemi ve muhasebe kodu eklendi//
	</cfswitch>
	//newCell.innerHTML += '#element#';
</cfloop>
	ayir(rowCount);
	hesabi_bitir(rowCount);
	change_row_values(rowCount);
//	change_row_values(rowCount);
//	hesabi_bitir(rowCount);
	if(toplam_hesap_yap == 0)
		{
		//hesaplama yapma
		}
	else
		{
		document.form_basket.control_field_value.value = '-1';
		toplam_hesapla(0);
		}
		if(price_other_calc!= undefined && price_other_calc!= '')
		hesapla('price',rowCount);
	return true;
}
function lotno_control(crntrw)
{
	//var prohibited=' [space] , ",  $, %, &, ', (, ), *, +, ,, ., /, <, =, >, ?, @, [, \, ], ], _, `, {, |,   }, , «, ';
	var prohibited_asci='32,34,35,36,37,38,39,40,41,42,43,44,47,60,61,62,63,64,91,92,93,94,96,123,124,125,156,171';
	lot_no = document.getElementsByName('lot_no')[crntrw];
	toplam_ = lot_no.value.length;
	deger_ = lot_no.value;
	if(toplam_>0)
	{
		for(var this_tus_=0; this_tus_< toplam_; this_tus_++)
		{
			tus_ = deger_.charAt(this_tus_);
			cont_ = list_find(prohibited_asci,tus_.charCodeAt());
			if(cont_>0)
			{
				alert("[space],\"\,##,$,%,&,',(,),*,+,,,/,<,=,>,?,@,[,\,],],`,{,|,},«,; Katakterlerinden Oluşan Lot No Girilemez!');
				lot_no.value = '';
				break;
			}
		}
	}
}
function copy_basket_row(from_row_no,copy_full,copy_type,cpy_shelf_no_,cpy_deliver_date_,cpy_amount_,cpy_to_shelf_no_,shelf_control)
{
	if( (rowCount > 1 && eval('form_basket.product_id['+from_row_no+'].value') == '') || (rowCount == 1 && eval('document.form_basket.product_id.value') == '') )
	{
		alert("<cf_get_lang dictionary_id='58846.Silinmiş Satır Kopyalanamaz'>!");
		return false;
	}
	else
	{
		var tbl = document.getElementById("table_list").tBodies[0];
		try
		{
			var newNode = tbl.rows[from_row_no+1].cloneNode(true);
		}
		catch(err)
		{
			var newNode = tbl.rows[from_row_no].cloneNode(true);
		}
		tbl.appendChild(newNode);		
		//hesabi_bitir(rowCount);
		
		rowCount++;

		var obj = document.getElementById('table_list').children[0].children[rowCount];
		var tds = obj.getElementsByTagName('td');
		tds[0].innerHTML = rowCount;
		
		ayir(rowCount);
		change_row_values(rowCount);
	
		//newNode.childNodes[0].innerHTML = parseInt(rowCount)+1;
		var form_selects = newNode.getElementsByTagName('select');
		var str = "";
		var j = 0;	
		for (var i=0;i<form_selects.length;i++)
		{
			var name_ = form_selects[i].name;
			form_selects[i].value = eval("document.form_basket." + name_)[from_row_no].value;
		}
		ayir_ters(rowCount,1);
		document.form_basket.wrk_row_id[rowCount-1].value = js_create_unique_id();
		document.form_basket.wrk_row_relation_id[rowCount-1].value = '';
		document.form_basket.row_paymethod_id[rowCount-1].value = '';
		document.form_basket.spect_id[rowCount-1].value = '';
		document.form_basket.spect_name[rowCount-1].value = '';
		document.form_basket.action_row_id[rowCount-1].value = '0';
		if(cpy_amount_ != undefined)
			document.form_basket.amount[rowCount-1].value =  cpy_amount_;
		if(cpy_shelf_no_ != undefined && cpy_shelf_no_ != '')
		{
			var shelf_name_sql='SELECT SHELF_CODE FROM PRODUCT_PLACE WHERE PLACE_STATUS=1 AND PRODUCT_PLACE_ID= '+ cpy_shelf_no_;
			var get_shelf_name =wrk_query(shelf_name_sql,'dsn3');
			if(get_shelf_name.recordcount && get_shelf_name.SHELF_CODE != '')
				document.form_basket.shelf_number_txt[rowCount-1].value = get_shelf_name.SHELF_CODE;
			document.form_basket.shelf_number[rowCount-1].value = cpy_shelf_no_;
		}
		if(cpy_to_shelf_no_ != undefined && cpy_to_shelf_no_ != '')
		{
			var shelf_name_sql='SELECT SHELF_CODE FROM PRODUCT_PLACE WHERE PLACE_STATUS=1 AND PRODUCT_PLACE_ID= '+ cpy_to_shelf_no_;
			var get_shelf_name =wrk_query(shelf_name_sql,'dsn3');
			if(get_shelf_name.recordcount && get_shelf_name.SHELF_CODE != '')
				document.form_basket.to_shelf_number_txt[rowCount-1].value = get_shelf_name.SHELF_CODE;
			document.form_basket.to_shelf_number[rowCount-1].value = cpy_to_shelf_no_;
		}
		else if( eval('document.form_basket.to_shelf_number_txt['+from_row_no+'].value')!='' && eval('document.form_basket.to_shelf_number['+from_row_no+'].value')!='')
		{
			var shelf_name_sql='SELECT SHELF_CODE FROM PRODUCT_PLACE WHERE PLACE_STATUS=1 AND PRODUCT_PLACE_ID= '+ eval('document.form_basket.to_shelf_number['+from_row_no+'].value');
			var get_shelf_name =wrk_query(shelf_name_sql,'dsn3');
			if(get_shelf_name.recordcount && get_shelf_name.SHELF_CODE != '')
				document.form_basket.to_shelf_number_txt[rowCount-1].value = get_shelf_name.SHELF_CODE;
			document.form_basket.to_shelf_number[rowCount-1].value = eval('document.form_basket.to_shelf_number['+from_row_no+'].value');
		}
		if(cpy_deliver_date_ != undefined && cpy_deliver_date_ != '')
			document.form_basket.deliver_date[rowCount-1].value = cpy_deliver_date_;
		toplam_hesapla(0);

		/*if(shelf_control == 1)
		{
			satir_silinecek(from_row_no);
			//satır silme olacak
		}*/
		return true; 
	}
}

function upd_row(product_id, stock_id, stock_code, barcod, manufact_code, product_name, unit_id_, unit_, spect_id, spect_name, price, price_other, tax, duedate, d1, d2, d3, d4, d5, d6, d7, d8, d9, d10, deliver_date, deliver_dept, department_head, lot_no, money, row_ship_id, amount_, product_account_code, is_inventory,is_production,net_maliyet,flt_marj,extra_cost,row_promotion_id,promosyon_yuzde,promosyon_maliyet,iskonto_tutar,is_promotion,prom_stock_id,otv,update_product_row_id,is_commission,row_catalog_id,row_unique_relation_id,product_name_other,amount_other,unit_other,ek_tutar,shelf_number,basket_extra_info,select_info_extra,detail_info_extra,prom_relation_id,reserve_type_,order_currency_,toplam_hesap,reserve_date,list_price,number_of_installment,price_cat,karma_product_id,row_service_id,ek_tutar_price,row_width,row_depth,row_height,to_shelf_number,row_project_id,row_project_name,action_window_name,row_paymethod_id,pbs_id,pbs_code,special_code,row_work_id,row_work_name,row_exp_center_id,row_exp_center_name,row_exp_item_id,row_exp_item_name,row_acc_code,price_other_calc)
{
	if(action_window_name != undefined && action_window_name != '' && action_window_name != basket_unique_code)
		{
		alert("<cf_get_lang dictionary_id='60047.Çalıştığınız Ekran Mevcut Sepet İle Uyumlu Değil'>! <cf_get_lang dictionary_id='60048.Fiyat Listesi Ekranınızı Yenilemelisiniz'>!");
		return false;
		}
	var net_total,net_total_doviz,row_tax_total,other_money_value_;
	var ek_tutar_other_total=0;
	var ek_tutar_total=0;
	var ek_tutar_marj=0;
	var ek_tutar_cost=0;
	var temp_wrk_row_id=js_create_unique_id();
	if(isNaN(row_width)) var row_width='';
	if(isNaN(row_depth)) var row_depth='';
	if(isNaN(row_height)) var row_height='';
	if(isNaN(to_shelf_number)) var to_shelf_number='';
	if(isNaN(shelf_number)) var shelf_number='';
	if(isNaN(pbs_id)) var pbs_id='';
	if(isNaN(pbs_code)) var pbs_code='';
	if(isNaN(ek_tutar)) var ek_tutar=0;
	if(isNaN(iskonto_tutar)) var iskonto_tutar =0;
	if(isNaN(ek_tutar_price)) var ek_tutar_price =0;
	if(isNaN(row_project_id)) var row_project_id =0;
	if(row_project_name==undefined) var row_project_name='';
	if(row_paymethod_id==undefined) var row_paymethod_id='';
	if(isNaN(row_work_id)) var row_work_id =0;
	if(row_work_name==undefined) var row_work_name='';
	//alis faturasi masraf merkezi, butce kalemi ve muhasebe kodu//
	if(isNaN(row_exp_center_id)) var row_exp_center_id =0;
	if(row_exp_center_name==undefined) var row_exp_center_name='';
	if(isNaN(row_exp_item_id)) var row_exp_item_id =0;
	if(row_exp_item_name==undefined) var row_exp_item_name='';
	if(row_acc_code==undefined) var row_acc_code='';
	//alis faturasi masraf merkezi, butce kalemi ve muhasebe kodu//
	var price_net_ = price;
	var price_net_doviz = price_other;
	if(isNaN(amount_other) || amount_other =='') var amount_other=1;
	if(ek_tutar_price!='') //iscilik birim ucreti gonderilmisse ek_tutar ve ek_tutar_marj bu degerden hesaplanır
	{
		if(isNaN(amount_other) || amount_other =='') var amount_other=1;
			ek_tutar_cost = ek_tutar_price*amount_other;
		if(ek_tutar != '' && ek_tutar != 0)
			ek_tutar_marj=((ek_tutar*100)/ek_tutar_cost)-100;
		else
			ek_tutar=ek_tutar_cost;
	}
	if((iskonto_tutar!=0) || (ek_tutar!=0))
	{ 
		price_net_doviz = parseFloat(price_net_doviz)+parseFloat(ek_tutar);
		price_net_doviz = parseFloat(price_net_doviz)-parseFloat(iskonto_tutar);
		ek_tutar_other_total = wrk_round((ek_tutar* amount_),price_round_number); /*ek tutar satır toplamı satırda secilen doviz cinsinden hesaplanıyor*/
		for(var mon_i=0;mon_i<moneyArray.length;mon_i++)
			if(moneyArray[mon_i]==money)
			{
				ek_tutar_total = wrk_round((ek_tutar*(rate2Array[mon_i]/rate1Array[mon_i])*amount_),price_round_number);/*ek tutarın sistem para birimi karsılıgı hesaplanıyor*/
				price_net_  -= iskonto_tutar*rate2Array[mon_i]/rate1Array[mon_i];
				price_net_  += ek_tutar*rate2Array[mon_i]/rate1Array[mon_i]; <!--- ek tutar her zaman satir doviz cinsinden oldugundan yerel degerini bularak ekliyoruz --->
			}
	}	
	if(isNaN(list_price) || list_price=='') var list_price=price; //sadece bilgi amaclı tutuluyor, urun eklenirken kullanılan ilk fiyat bilgisini tutmak icin
	if(isNaN(number_of_installment) || number_of_installment=='') var number_of_installment=0;
	if(price_cat == undefined) price_cat='';
	if(isNaN(karma_product_id)) karma_product_id='';
	if(isNaN(row_service_id)) row_service_id = '';
	if(isNaN(row_catalog_id)) row_catalog_id = '';
	if(reserve_date == undefined) reserve_date='';
	if (basket_extra_info == undefined || basket_extra_info == '') //ek açıklama tanım idsi gonderilmemisse, seciniz aşamasında gelmesi icin '-1' set edilir
		basket_extra_info = '-1'
	if (select_info_extra == undefined || select_info_extra == '') //ek açıklama 2 tanım idsi gonderilmemisse, seciniz aşamasında gelmesi icin '-1' set edilir
		select_info_extra = '-1'
	
	var upd_shelf_number_ = '',upd_to_shelf_number_=''; //raf kod bilgileri
	if(shelf_number != '' || to_shelf_number != '')
	{/* raf id sine baglı olarak raf kodu getiriliyor */
		
		var listParam = shelf_number + "*" + to_shelf_number ;
		var shelf_name_sql='obj_get_shelf_name_2';
		if(shelf_number != '' && to_shelf_number != '')
			shelf_name_sql= 'obj_get_shelf_name_3';
		else if(shelf_number != '')
			shelf_name_sql= 'obj_get_shelf_name_4';
		else if(to_shelf_number != '')
			shelf_name_sql= 'obj_get_shelf_name_5';
			
		var get_shelf_name =wrk_safe_query(shelf_name_sql,'dsn3');
		if(get_shelf_name.recordcount!=0)
		{
			for(shlf_i=0;shlf_i<get_shelf_name.recordcount;shlf_i++)
			{
				if(shelf_number !='' && get_shelf_name.PRODUCT_PLACE_ID[shlf_i]==shelf_number)
					var upd_shelf_number_ = get_shelf_name.SHELF_CODE[shlf_i];
				else if(to_shelf_number !='' && get_shelf_name.PRODUCT_PLACE_ID[shlf_i]==to_shelf_number)
					var upd_to_shelf_number_ = get_shelf_name.SHELF_CODE[shlf_i];
			}
		}
	}
	if(row_project_id != '' && row_project_name == '') //sadece proje_id gonderilmisse proje ismi cekilir
	{
		var get_prjct_name =wrk_safe_query("obj_get_prjct_name",'dsn',0,row_project_id);
		if(get_prjct_name.recordcount)
			row_project_name = get_prjct_name.PROJECT_HEAD;
	}
	indirim_carpan = (100-d1) * (100-d2) * (100-d3) * (100-d4) * (100-d5) * (100-d6) * (100-d7) * (100-d8) * (100-d9) * (100-d10);
	price_net_ = wrk_round(price_net_*indirim_carpan/100000000000000000000,price_round_number);
	if(promosyon_yuzde!='') price_net_doviz -= price_net_doviz*promosyon_yuzde/100;
	price_net_doviz = wrk_round(price_net_doviz*indirim_carpan/100000000000000000000,price_round_number);
	net_total_doviz = wrk_round( price_other*amount_*indirim_carpan/100000000000000000000 ,price_round_number);
	net_total = wrk_round((price_net_*amount_),price_round_number );
	row_otv_total = wrk_round(net_total*otv/100 ,price_round_number);
	<cfif ListFindNoCase(display_list, "otv_from_tax_price")>//kdv matrahına otv ekleniyor
		row_tax_total = wrk_round( (net_total+row_otv_total)*tax/100,price_round_number);
	<cfelse>
		row_tax_total = wrk_round( net_total*tax/100,price_round_number);
	</cfif>
	//other_money_value_ = wrk_round(((parseFloat(price_other)+parseFloat(ek_tutar))-iskonto_tutar)*amount_*indirim_carpan/100000000000000000000 ,price_round_number);
	other_money_value_ = price_net_doviz*amount_;
	//net maliyet ve ek tutar baglı olarak satır toplam maliyet ve ek maliyet oranı hesaplanıyor
	var row_cost_total_=0;
	var extra_cost_rate_ = 0;
	if(net_maliyet!='' && net_maliyet!=0)
	{
		row_cost_total_ +=net_maliyet;
		if(extra_cost!='' && extra_cost!=0)
		{
			extra_cost_rate_ = wrk_round((extra_cost/net_maliyet)*100);
			row_cost_total_ +=extra_cost;
		}
	}
	
	if (document.form_basket.product_id.length != undefined)
	{ /*old_prom_relation_id degiskeni tek satırlı baskette promosyon olmayacagı icin else bloguna eklenmedi*/
		if(document.form_basket.is_promotion[update_product_row_id-1].value == 0 && document.form_basket.row_promotion_id[update_product_row_id-1].value != '')
			var old_prom_relation_id = document.form_basket.prom_relation_id[update_product_row_id-1].value; //eski promosyon satırının silinmesinde kullanılıyor
		document.form_basket.row_catalog_id[update_product_row_id-1].value=row_catalog_id;
		document.form_basket.wrk_row_id[update_product_row_id-1].value=temp_wrk_row_id;
		document.form_basket.row_paymethod_id[update_product_row_id-1].value=row_paymethod_id;
		document.form_basket.wrk_row_relation_id[update_product_row_id-1].value='';
		document.form_basket.related_action_id[update_product_row_id-1].value='';
		document.form_basket.related_action_table[update_product_row_id-1].value='';
		document.form_basket.price_cat[update_product_row_id-1].value = price_cat;
		document.form_basket.product_id[update_product_row_id-1].value = product_id;
		document.form_basket.is_inventory[update_product_row_id-1].value = is_inventory;
		document.form_basket.is_production[update_product_row_id-1].value = is_production;
		//document.form_basket.product_account_code[update_product_row_id-1].value = product_account_code;
		document.form_basket.row_ship_id[update_product_row_id-1].value = row_ship_id;
		document.form_basket.stock_id[update_product_row_id-1].value = stock_id;
		document.form_basket.lot_no[update_product_row_id-1].value = '';
		document.form_basket.karma_product_id[update_product_row_id-1].value = '';
		document.form_basket.row_service_id[update_product_row_id-1].value = '';
		document.form_basket.row_unique_relation_id[update_product_row_id-1].value = row_unique_relation_id;
		document.form_basket.prom_relation_id[update_product_row_id-1].value = prom_relation_id;
		document.form_basket.shelf_number[update_product_row_id-1].value = shelf_number;
		document.form_basket.shelf_number_txt[update_product_row_id-1].value = upd_shelf_number_;
		document.form_basket.to_shelf_number[update_product_row_id-1].value = to_shelf_number;
		document.form_basket.to_shelf_number_txt[update_product_row_id-1].value = upd_to_shelf_number_;
		document.form_basket.pbs_id[update_product_row_id-1].value = pbs_id;
		document.form_basket.pbs_code[update_product_row_id-1].value = pbs_code;
		document.form_basket.basket_employee[update_product_row_id-1].value = '';
		document.form_basket.basket_employee_id[update_product_row_id-1].value = '';
		document.form_basket.unit_other[update_product_row_id-1].value = unit_other;
		document.form_basket.amount_other[update_product_row_id-1].value = amount_other;
		document.form_basket.product_name_other[update_product_row_id-1].value = product_name_other;		
		document.form_basket.ek_tutar[update_product_row_id-1].value = ek_tutar;
		document.form_basket.ek_tutar_price[update_product_row_id-1].value = ek_tutar_price;
		document.form_basket.ek_tutar_cost[update_product_row_id-1].value = ek_tutar_cost;
		document.form_basket.ek_tutar_marj[update_product_row_id-1].value = ek_tutar_marj;
		document.form_basket.ek_tutar_total[update_product_row_id-1].value = ek_tutar_total;
		document.form_basket.ek_tutar_other_total[update_product_row_id-1].value = ek_tutar_other_total;
		document.form_basket.is_commission[update_product_row_id-1].value = is_commission;
		document.form_basket.stock_code[update_product_row_id-1].value = stock_code;
		document.form_basket.barcod[update_product_row_id-1].value = barcod;
		document.form_basket.special_code[update_product_row_id-1].value = special_code;
		document.form_basket.manufact_code[update_product_row_id-1].value = manufact_code;
		document.form_basket.product_name[update_product_row_id-1].value = product_name;
		document.form_basket.amount[update_product_row_id-1].value = amount_;
		document.form_basket.unit_id[update_product_row_id-1].value = unit_id_;
		document.form_basket.unit[update_product_row_id-1].value = unit_;
		document.form_basket.spect_id[update_product_row_id-1].value = '';
		document.form_basket.spect_name[update_product_row_id-1].value = '';
		document.form_basket.list_price[update_product_row_id-1].value = list_price;
		document.form_basket.list_price_discount[update_product_row_id-1].value = 0;
		document.form_basket.price[update_product_row_id-1].value = price;
		document.form_basket.price_other[update_product_row_id-1].value = price_other;
		document.form_basket.price_net[update_product_row_id-1].value = price_net_;
		document.form_basket.price_net_doviz[update_product_row_id-1].value = price_net_doviz;
		document.form_basket.tax[update_product_row_id-1].value = tax;
		document.form_basket.otv_oran[update_product_row_id-1].value = otv;
		document.form_basket.row_total[update_product_row_id-1].value = price*amount_;
		document.form_basket.row_nettotal[update_product_row_id-1].value = net_total;
		document.form_basket.row_otvtotal[update_product_row_id-1].value = row_otv_total;
		document.form_basket.row_taxtotal[update_product_row_id-1].value = row_tax_total;
		document.form_basket.row_lasttotal[update_product_row_id-1].value = net_total+row_tax_total+row_otv_total;
		document.form_basket.tax_price[update_product_row_id-1].value = (net_total+row_tax_total+row_otv_total)/amount_;
		document.form_basket.other_money_[update_product_row_id-1].value = money;
		document.form_basket.other_money_value_[update_product_row_id-1].value = other_money_value_;
		document.form_basket.other_money_gross_total[update_product_row_id-1].value = wrk_round( other_money_value_*(100+parseFloat(tax))/100 ,price_round_number);
		document.form_basket.deliver_date[update_product_row_id-1].value = deliver_date;
		document.form_basket.reserve_date[update_product_row_id-1].value = reserve_date;
		document.form_basket.deliver_dept[update_product_row_id-1].value = deliver_dept;
		document.form_basket.basket_row_departman[update_product_row_id-1].value = department_head;
		document.form_basket.lot_no[update_product_row_id-1].value = lot_no;
		document.form_basket.iskonto_tutar[update_product_row_id-1].value = iskonto_tutar; 
		document.form_basket.net_maliyet[update_product_row_id-1].value = net_maliyet; 
		document.form_basket.extra_cost[update_product_row_id-1].value = extra_cost;
		document.form_basket.extra_cost_rate[update_product_row_id-1].value = extra_cost_rate_;
		document.form_basket.row_cost_total[update_product_row_id-1].value = row_cost_total_; 
		document.form_basket.marj[update_product_row_id-1].value = flt_marj;
		document.form_basket.dara[update_product_row_id-1].value = 0;
		document.form_basket.darali[update_product_row_id-1].value = amount_;/*20050412 1(bir) di gelen i yazsin*/
		document.form_basket.duedate[update_product_row_id-1].value = duedate;
		document.form_basket.number_of_installment[update_product_row_id-1].value = number_of_installment;
		document.form_basket.row_promotion_id[update_product_row_id-1].value = row_promotion_id;
		document.form_basket.promosyon_yuzde[update_product_row_id-1].value = 0;
		document.form_basket.promosyon_maliyet[update_product_row_id-1].value = 0;
		if(is_promotion != undefined && is_promotion !='')
			document.form_basket.is_promotion[update_product_row_id-1].value = is_promotion;
		else
			document.form_basket.is_promotion[update_product_row_id-1].value = 0;
		document.form_basket.prom_stock_id[update_product_row_id-1].value = '';	
		document.form_basket.indirim1[update_product_row_id-1].value = d1;
		document.form_basket.indirim2[update_product_row_id-1].value = d2;
		document.form_basket.indirim3[update_product_row_id-1].value = d3;
		document.form_basket.indirim4[update_product_row_id-1].value = d4;
		document.form_basket.indirim5[update_product_row_id-1].value = d5;
		document.form_basket.indirim6[update_product_row_id-1].value = d6;
		document.form_basket.indirim7[update_product_row_id-1].value = d7;
		document.form_basket.indirim8[update_product_row_id-1].value = d8;
		document.form_basket.indirim9[update_product_row_id-1].value = d9;
		document.form_basket.indirim10[update_product_row_id-1].value = d10;
		document.form_basket.indirim_total[update_product_row_id-1].value = indirim_carpan;
		document.form_basket.basket_extra_info[update_product_row_id-1].value = basket_extra_info;
		document.form_basket.select_info_extra[update_product_row_id-1].value = select_info_extra;
		document.form_basket.detail_info_extra[update_product_row_id-1].value = detail_info_extra;
		if(order_currency_ != undefined && order_currency_ != '')
		{
			document.form_basket.order_currency[update_product_row_id-1].value = order_currency_;
		}
		if(reserve_type_ != undefined && reserve_type_ != '')
		{
			document.form_basket.reserve_type[update_product_row_id-1].value = reserve_type_;
		}
		document.form_basket.row_width[update_product_row_id-1].value = row_width;
		document.form_basket.row_depth[update_product_row_id-1].value = row_depth;
		document.form_basket.row_height[update_product_row_id-1].value = row_height;
		document.form_basket.row_project_id[update_product_row_id-1].value = row_project_id;
		document.form_basket.row_project_name[update_product_row_id-1].value = row_project_name;
		document.form_basket.row_work_id[update_product_row_id-1].value = row_work_id;
		document.form_basket.row_work_name[update_product_row_id-1].value = row_work_name;
		document.form_basket.row_exp_center_id[update_product_row_id-1].value = row_exp_center_id;
		document.form_basket.row_exp_center_name[update_product_row_id-1].value = row_exp_center_name;
		document.form_basket.row_exp_item_id[update_product_row_id-1].value = row_exp_item_id;
		document.form_basket.row_exp_item_name[update_product_row_id-1].value = row_exp_item_name;
		document.form_basket.row_acc_code[update_product_row_id-1].value = row_acc_code;
	}
	else
	{
		document.form_basket.row_catalog_id.value=row_catalog_id;
		document.form_basket.wrk_row_id.value=temp_wrk_row_id;
		document.form_basket.wrk_row_relation_id.value='';
		document.form_basket.row_paymethod_id.value=row_paymethod_id;
		document.form_basket.related_action_id.value='';
		document.form_basket.related_action_table.value='';
		document.form_basket.price_cat.value = price_cat;
		document.form_basket.shelf_number.value = shelf_number;
		document.form_basket.shelf_number_txt.value = upd_shelf_number_;
		document.form_basket.to_shelf_number.value = to_shelf_number;
		document.form_basket.to_shelf_number_txt.value = upd_to_shelf_number_;
		document.form_basket.pbs_id.value = pbs_id;
		document.form_basket.pbs_code.value = pbs_code;
		document.form_basket.basket_employee.value = '';
		document.form_basket.basket_employee_id.value = '';
		document.form_basket.unit_other.value = '';
		document.form_basket.amount_other.value = amount_other;
		document.form_basket.product_name_other.value = '';
		document.form_basket.ek_tutar.value = ek_tutar;
		document.form_basket.ek_tutar_price.value = ek_tutar_price;
		document.form_basket.ek_tutar_cost.value = ek_tutar_cost;
		document.form_basket.ek_tutar_marj.value = ek_tutar_marj;
		document.form_basket.ek_tutar_total.value = ek_tutar_total;
		document.form_basket.ek_tutar_other_total.value = ek_tutar_other_total;
		document.form_basket.product_id.value = product_id;
		document.form_basket.is_inventory.value = is_inventory;
		document.form_basket.is_production.value = is_production;
		//document.form_basket.product_account_code.value = product_account_code;
		document.form_basket.row_ship_id.value = row_ship_id;
		document.form_basket.prom_relation_id.value ='';
		document.form_basket.row_unique_relation_id.value='';
		document.form_basket.karma_product_id.value='';
		document.form_basket.row_service_id.value='';
		document.form_basket.stock_id.value = stock_id;
		document.form_basket.is_commission.value = 0;<!---  tek satir olan bir sepette o tek urun komisyon urunu olamaz --->
		document.form_basket.stock_code.value = stock_code;
		document.form_basket.barcod.value = barcod;
		document.form_basket.special_code.value = special_code;
		document.form_basket.manufact_code.value = manufact_code;
		document.form_basket.product_name.value = product_name;
		document.form_basket.amount.value = amount_;
		document.form_basket.unit_id.value = unit_id_;
		document.form_basket.unit.value = unit_;
		document.form_basket.spect_id.value = '';
		document.form_basket.spect_name.value = '';
		document.form_basket.list_price.value = list_price;
		document.form_basket.list_price_discount.value = 0;
		document.form_basket.price.value = price;
		document.form_basket.price_other.value = price_other;
		document.form_basket.price_net.value = price_net_;
		document.form_basket.price_net_doviz.value = price_net_doviz;
		document.form_basket.tax.value = tax;
		document.form_basket.otv_oran.value = otv;
		document.form_basket.duedate.value = duedate;
		document.form_basket.number_of_installment.value = number_of_installment;
		document.form_basket.row_total.value = price*amount_;
		document.form_basket.row_nettotal.value = net_total;
		document.form_basket.row_otvtotal.value = row_otv_total;
		document.form_basket.row_taxtotal.value = row_tax_total;
		document.form_basket.row_lasttotal.value = net_total+row_tax_total+row_otv_total;
		document.form_basket.tax_price.value = (net_total+row_tax_total+row_otv_total)/amount_;
		document.form_basket.other_money_.value = money;
		document.form_basket.other_money_value_.value = other_money_value_;
		document.form_basket.other_money_gross_total.value = wrk_round(other_money_value_ *(100+parseFloat(tax))/100 ,price_round_number);
		document.form_basket.deliver_date.value = deliver_date;
		document.form_basket.reserve_date.value = reserve_date;
		document.form_basket.deliver_dept.value = deliver_dept;
		document.form_basket.basket_row_departman.value = department_head;
		document.form_basket.lot_no.value = lot_no;
		document.form_basket.net_maliyet.value = net_maliyet;
		document.form_basket.iskonto_tutar.value = iskonto_tutar;
		document.form_basket.marj.value = flt_marj;
		document.form_basket.extra_cost.value = extra_cost;
		document.form_basket.extra_cost_rate.value = extra_cost_rate_;
		document.form_basket.row_cost_total.value = row_cost_total_; 
		document.form_basket.dara.value = 0;
		document.form_basket.darali.value = amount_;
		document.form_basket.promosyon_yuzde.value = promosyon_yuzde;
		document.form_basket.promosyon_maliyet.value = promosyon_maliyet;	
		
		if(is_promotion != undefined && is_promotion !='')
			document.form_basket.is_promotion.value = is_promotion;
		else
			document.form_basket.is_promotion.value = 0;

		document.form_basket.prom_stock_id.value = prom_stock_id;
		document.form_basket.row_promotion_id.value =row_promotion_id;
		document.form_basket.indirim1.value = d1;
		document.form_basket.indirim2.value = d2;
		document.form_basket.indirim3.value = d3;
		document.form_basket.indirim4.value = d4;
		document.form_basket.indirim5.value = d5;
		document.form_basket.indirim6.value = d6;
		document.form_basket.indirim7.value = d7;
		document.form_basket.indirim8.value = d8;
		document.form_basket.indirim9.value = d9;
		document.form_basket.indirim10.value = d10;
		document.form_basket.indirim_total.value = indirim_carpan;
		document.form_basket.basket_extra_info.value = basket_extra_info;
		document.form_basket.select_info_extra.value = select_info_extra;
		document.form_basket.detail_info_extra.value = detail_info_extra;
		if(order_currency_ != undefined && order_currency_ != '')
		{
			document.form_basket.order_currency.value = order_currency_;
		}
		if(reserve_type_ != undefined && reserve_type_ != '')
		{
			document.form_basket.reserve_type.value = reserve_type_;
		}
		document.form_basket.row_width.value = row_width;
		document.form_basket.row_depth.value = row_depth;
		document.form_basket.row_height.value = row_height;
		document.form_basket.row_project_id.value = row_project_id;
		document.form_basket.row_project_name.value = row_project_name;
		document.form_basket.row_work_id.value = row_work_id;
		document.form_basket.row_work_name.value = row_work_name;
		document.form_basket.row_exp_center_id.value = row_exp_center_id;
		document.form_basket.row_exp_center_name.value = row_exp_center_name;
		document.form_basket.row_exp_item_id.value = row_exp_item_id;
		document.form_basket.row_exp_item_name.value = row_exp_item_name;
		document.form_basket.row_acc_code.value = row_acc_code;
	}
	
	if(document.form_basket.product_id.length != undefined && old_prom_relation_id != undefined && old_prom_relation_id != '')
	{ /*guncellenen satırın bedava promosyon satırı siliniyor, listeden secildiginde zaten promosyonunu yeni satır olarak ekliyor*/
		for(var counter_i=0; counter_i < rowCount; counter_i++) //promosyon urun satırı aranıyor
			if(document.form_basket.is_promotion[counter_i].value==1 && document.form_basket.prom_relation_id[counter_i].value==old_prom_relation_id) //urunun promosyon satırı bulunuyor
				clear_row(counter_i+1);
		
	}
	hesabi_bitir(update_product_row_id);
	if(toplam_hesap == undefined || toplam_hesap ==1) //dikkat add_bsket_row fonksiyonunun tersine gonderilmemisse veya 1 gonderilmisse calısır
		toplam_hesapla(0);
	if(price_other_calc!= undefined && price_other_calc!= '')
	hesapla('price',rowCount);
	return false;
	}
</cfoutput>
<cfif ListFindNoCase(display_list, "darali") and ListFindNoCase(display_list, "dara")>
	function dara_miktar_hesabi(int_row_id,int_nereden_geldi)
	{
		var satir = int_row_id-1;
		var flt_dara = getFieldValue('dara', satir,1);
		var flt_amount = getFieldValue('amount', satir,1);
		var flt_darali = getFieldValue('darali', satir,1);
		if(flt_dara=="") flt_dara=0; else flt_dara=parseFloat(flt_dara);		
		if(flt_darali=="") flt_darali=1; else flt_darali=parseFloat(flt_darali);		
		if((flt_darali-flt_dara) <= 0)
		{
			alert("<cf_get_lang dictionary_id ='60049.Darali ve Dara Miktarları Aynı veya Farkları Sıfırdan Küçük Olamaz'>!");
			if(int_nereden_geldi == 1)
				setFieldValue('darali', satir, 1, 3);
			else if(int_nereden_geldi ==2)
				setFieldValue('dara', satir, 0, 3);
		}
		else
		{
			if(int_nereden_geldi == 3){
				if (flt_amount=="") flt_amount=1;else flt_amount=parseFloat(flt_amount);		
				setFieldValue('darali', satir, flt_amount+flt_dara, 3);
			}else{
				if(flt_darali=="") flt_darali=1;else flt_darali=parseFloat(flt_darali);
					setFieldValue('amount', satir, flt_darali-flt_dara, 3);
			}
			setFieldValue('dara', satir, flt_dara, 3);
			hesapla('amount',int_row_id);
		}
	}
</cfif>

bool_marj_called=0;
function marj_maliyet_hesabi(int_row_id,int_nereden_geldi,field_name)
{
	var satir = int_row_id-1;
	var flt_maliyet = getFieldValue('net_maliyet', satir,1);if(flt_maliyet=="")flt_maliyet=0;else flt_maliyet=parseFloat(flt_maliyet);
	var flt_pr = getFieldValue('price', satir,1);if(flt_pr=="")flt_pr=0;else flt_pr=parseFloat(flt_pr);
	if(int_nereden_geldi != 5)
	{
	var flt_marj = getFieldValue('marj', satir,1);if(flt_marj=="")flt_marj=0; else flt_marj=parseFloat(flt_marj);
	var flt_ek_maliyet = getFieldValue('extra_cost', satir,1);if(flt_ek_maliyet=="")flt_ek_maliyet=0;else flt_ek_maliyet=parseFloat(flt_ek_maliyet);

	if(field_name=='list_price_discount')
	{
		var flt_list_pr = getFieldValue('list_price', satir,1);if(flt_list_pr=="")flt_list_pr=0;else flt_list_pr=parseFloat(flt_list_pr);
		var flt_list_price_disc = getFieldValue('list_price_discount', satir,1);if(flt_list_price_disc=="")flt_list_price_disc=0;else flt_list_price_disc=parseFloat(flt_list_price_disc);
		flt_maliyet=(flt_list_pr*(100-flt_list_price_disc))/100;
		setFieldValue('net_maliyet', satir, flt_maliyet, 3);
		<cfif ListFindNoCase(display_list, "extra_cost_rate")>
			if(flt_maliyet !=0)
				flt_extra_cost_rate=((flt_ek_maliyet*100)/flt_maliyet);
			else
				flt_extra_cost_rate=0;
			setFieldValue('extra_cost_rate', satir, flt_extra_cost_rate, 3);
		</cfif>
	}
	else if(field_name=='net_maliyet' || field_name == 'extra_cost') //maliyet veya ek_maliyet degistiginde ek_maliyet_oranı yeniden hesaplanıyor
	{
		<cfif ListFindNoCase(display_list, "extra_cost_rate")>
			if(flt_maliyet !=0)
			{
				flt_extra_cost_rate=((flt_ek_maliyet*100)/flt_maliyet);
				setFieldValue('extra_cost_rate', satir, flt_extra_cost_rate, 3);
			}
		</cfif>
	}
	else if(field_name=='extra_cost_rate') //oran degistirildiginde maliyet uzerinden ek_maliyet hesaplanıyor
	{
		var flt_extra_cost_rate = getFieldValue('extra_cost_rate', satir,1);if(flt_extra_cost_rate=="")flt_extra_cost_rate=0;
		flt_ek_maliyet=((flt_maliyet*flt_extra_cost_rate)/100);
		setFieldValue('extra_cost', satir, flt_ek_maliyet, 3);
	}
	
	if(flt_ek_maliyet!="")
		flt_maliyet=parseFloat(flt_maliyet) + parseFloat(flt_ek_maliyet);

	<cfif ListFindNoCase(display_list, "row_cost_total")> //satır toplam maliyet set ediliyor
		setFieldValue('row_cost_total', satir, flt_maliyet, 3);
	</cfif>
	
	switch(int_nereden_geldi){
		case 1:{
		<cfif ListFindNoCase(display_list, "net_maliyet") and ListFindNoCase(display_list, "marj")>
			int_flag_marj=0;
			if(flt_marj!=0){
				setFieldValue('price', satir, (flt_maliyet*(100+flt_marj)/100), 3);
				int_flag_marj=1;
				if(int_flag_marj) hesapla('price',int_row_id);					
			}else if(flt_marj==0 && flt_maliyet!=0){
				setFieldValue('marj', satir, ((flt_pr-flt_maliyet)/flt_maliyet)*100, 3);
				int_flag_marj=1;
			}
		</cfif>
			break;
		}
		case 2:{
			if(flt_maliyet != 0){
				setFieldValue('price', satir, (flt_maliyet*((100+flt_marj)/100)), 3);
				hesapla('price',int_row_id);
			}else
			{	
				setFieldValue('net_maliyet', satir, flt_pr, 3);
				<cfif ListFindNoCase(display_list, "extra_cost_rate")>
					if(flt_pr!=0) flt_extra_cost_rate=((flt_ek_maliyet*100)/flt_pr);else flt_extra_cost_rate=0;					
					setFieldValue('extra_cost_rate', satir, flt_extra_cost_rate, 3);
				</cfif>
				<cfif ListFindNoCase(display_list, "row_cost_total")> //satır toplam maliyet set ediliyor
					flt_maliyet=parseFloat(flt_pr)+parseFloat(flt_ek_maliyet);
					setFieldValue('row_cost_total', satir, flt_maliyet, 3);
				</cfif>
			}
			break;
		}
		case 4:{
			if(flt_pr!=0 && flt_maliyet != 0)
				setFieldValue('marj', satir, ((flt_pr-flt_maliyet)/flt_maliyet)*100, 3);
			else
				setFieldValue('marj', satir, 0, 3);
			hesapla('price',int_row_id);
			break;
		}
	}
	}
	else
	{
		hesapla('price_other',int_row_id);
		var flt_pr = getFieldValue('price', satir,1);if(flt_pr=="")flt_pr=0;else flt_pr=parseFloat(flt_pr);;
		if(flt_pr!=0 && flt_maliyet != 0)
			setFieldValue('marj', satir, ((flt_pr-flt_maliyet)/flt_maliyet)*100, 3);
		else
			setFieldValue('marj', satir, 0, 3);
	}
}

function ek_tutar_hesapla(bsk_row_id,field_name)
{
	var satir = bsk_row_id-1;
	var flt_amount = getFieldValue('amount_other', satir,1);if(flt_amount=='') flt_amount=1;
	var flt_ek_tutar_price = getFieldValue('ek_tutar_price', satir,1);if(flt_ek_tutar_price=="")flt_ek_tutar_price=0;else flt_ek_tutar_price=parseFloat(flt_ek_tutar_price);
	var flt_ek_tutar_cost = flt_amount*flt_ek_tutar_price;

	if(field_name=='amount_other' || field_name=='ek_tutar_price') //maliyet veya ek_maliyet degistiginde ek_maliyet_oranı yeniden hesaplanıyor
	{
		<cfif ListFindNoCase(display_list, "ek_tutar_cost")>
			setFieldValue('ek_tutar_cost', satir, flt_ek_tutar_cost, 3);
		</cfif>
		var flt_ek_tutar_marj =getFieldValue('ek_tutar_marj', satir,1);if(flt_ek_tutar_marj=="")flt_ek_tutar_marj=0;
		var flt_ek_tutar = (flt_ek_tutar_cost*(100+flt_ek_tutar_marj))/100
		setFieldValue('ek_tutar', satir, flt_ek_tutar, 3);
		hesapla('ek_tutar',bsk_row_id);
	}
	else if(field_name=='ek_tutar_marj') //oran degistirildiginde maliyet uzerinden ek_maliyet hesaplanıyor
	{
		var flt_ek_tutar_marj =getFieldValue('ek_tutar_marj', satir,1);if(flt_ek_tutar_marj=="")flt_ek_tutar_marj=0;
		var flt_ek_tutar = (flt_ek_tutar_cost*(100+flt_ek_tutar_marj))/100
		setFieldValue('ek_tutar', satir, flt_ek_tutar, 3);
		hesapla('ek_tutar',bsk_row_id);
	}
	else if(field_name=='ek_tutar') 
	{//ek_tutar_other_total degistirildiginde de -once hesapla ile ek_tutarın yeni hali hesaplandıgından- bu bolum calıstırılır
		var flt_ek_tutar = getFieldValue('ek_tutar', satir,1);if(flt_ek_tutar=='') flt_ek_tutar=0;
		if(flt_ek_tutar_cost!='' && flt_ek_tutar_cost != 0)
			var flt_ek_tutar_marj = ((flt_ek_tutar*100)/flt_ek_tutar_cost)-100;
		else
			var flt_ek_tutar_marj = 0;
		<cfif ListFindNoCase(display_list, "ek_tutar_marj")>
			setFieldValue('ek_tutar_marj', satir, flt_ek_tutar_marj, 3);
		</cfif>
	}
}
function remove_empty_rows()
{
	if (rowCount > 1)
	{
		var control_field_ = eval('document.form_basket.product_id');
		for (var remove_i = (rowCount-1); remove_i >=0; remove_i--)
		{
			if (rowCount > 1 && control_field_[remove_i].value.length == 0)/*20050511 rowCount > 1 ifadesi dogru*/
				del_row(remove_i+1);
		}
	}
	document.form_basket.rows_.value = rowCount;
	
	toplam_hesapla(1);<!--- 20060309 toplam_hesapla from_proms parametresini true almali ki (sanki get_basket_proms dan geliyor gibi) kullanicinin indirime elle yaptigi mudahale kaybolmasin --->
	return true;
}
function clear_related_rows(karma_prod_row)
{ /*silinecek satırın row_unique_relation_id alanı dolu ise, hem bu satır hem de iliskili oldugu diger satırlar silinir. bos ise sadece secilen satır silinir*/
	if(rowCount > 1)
	{
		var uniq_rel_id = document.form_basket.row_unique_relation_id[karma_prod_row-1].value;
		if(document.form_basket.row_promotion_id[karma_prod_row-1].value !='' && document.form_basket.is_promotion[karma_prod_row-1].value == 0) //silinecek satırın promosyon bilgisi alınıyor
			var free_prom_relation_id= document.form_basket.prom_relation_id[karma_prod_row-1].value; //baskete aynı promosyondan birden fazla dusuruldugunde satırlar arasındaki uniqe iliskiyi prom_relation_id tutar. 
		
		if(uniq_rel_id != '' || (free_prom_relation_id != undefined && free_prom_relation_id != '')) 
		{
			for (var remove_i = 0; remove_i < rowCount; remove_i++)
			{//1- silinecek satırla uniq_id baglantılı satırsa siliniyor 2-silinecek satırın promosyon ürün satırıysa siliniyor
				if (uniq_rel_id != '' && document.form_basket.row_unique_relation_id[remove_i].value == uniq_rel_id)
					clear_row(remove_i+1);
				else if(free_prom_relation_id != undefined && free_prom_relation_id!='' && document.form_basket.prom_relation_id[remove_i].value == free_prom_relation_id) /* && form_basket.is_promotion[remove_i].value == 1*/
					clear_row(remove_i+1);
			}
		}
		else
		{
			clear_row(karma_prod_row);
		}
	}
	else
		clear_row(karma_prod_row);
	return true;
}
function check_product_accounts()
{
	remove_empty_rows();
	var prod_list ='';
	if(isDefined('product_id'))
		{
			if(document.form_basket.product_id.length != undefined && document.form_basket.product_id.length >1)
			{
				var bsk_rowCount = document.form_basket.product_id.length;
				var acc_control_prod_id_ = eval('document.form_basket.product_id');
				for(var prd_ii=0; prd_ii<bsk_rowCount; prd_ii++)
				{
					if(acc_control_prod_id_[prd_ii].value!= '' && list_find(prod_list,acc_control_prod_id_[prd_ii].value,',')==0)
					{
					if(list_len(prod_list)==0)
						prod_list=acc_control_prod_id_[prd_ii].value;
					else
						prod_list= prod_list+','+acc_control_prod_id_[prd_ii].value;
					}		
				}
			}
			else if(document.form_basket.product_id[0]!=undefined && document.form_basket.product_id[0].value!=undefined)
			{
				prod_list=document.form_basket.product_id[0].value;
			}
			else
			{
				prod_list=document.form_basket.product_id.value;
			}
		}
	if (process_cat_array[form_basket.process_cat.selectedIndex] == 1 && process_cat_project_based_acc[form_basket.process_cat.selectedIndex] == 0 && process_cat_dept_based_acc[form_basket.process_cat.selectedIndex] == 0) //muhasebe islemi yapılıyor ve proje bazlı muhasebe secili degil ve depo bazlı muhasebe seçili değil
	{
		if(list_len(prod_list))
		{
			if(document.form_basket.location_id != undefined && document.form_basket.department_id.value.length && document.form_basket.department_id != undefined && document.form_basket.location_id.value.length ) 
			{
				var listParam = document.form_basket.department_id.value + "*" + document.form_basket.location_id.value;
				var LOCATION = wrk_safe_query('obj_control_department_location','dsn',0,listParam);	
				location_type_ = LOCATION.LOCATION_TYPE;
				is_scrap_ = LOCATION.IS_SCRAP;
			}
			else
			{
				location_type_ ='';
				is_scrap_ =0;
			}
						
			var new_prod_sql = 'obj_control_basket_prod_acc'
			if(list_find("54,55",process_type_array[form_basket.process_cat.selectedIndex]))
				var new_prod_sql = 'obj_control_basket_prod_acc_2'
			else if(process_type_array[form_basket.process_cat.selectedIndex] == 58)
				var new_prod_sql = 'obj_control_basket_prod_acc_3'
			else if(process_type_array[form_basket.process_cat.selectedIndex] == 63)
				var new_prod_sql = 'obj_control_basket_prod_acc_4'
			else if(process_type_array[form_basket.process_cat.selectedIndex] == 62)
				var new_prod_sql = 'obj_control_basket_prod_acc_5'
			else if(process_type_array[form_basket.process_cat.selectedIndex] == 531)
				var new_prod_sql = 'obj_control_basket_prod_acc_6'
			else if(process_type_array[form_basket.process_cat.selectedIndex] == 591)
				var new_prod_sql = 'obj_control_basket_prod_acc_7'
			else if(sale_product!=undefined && sale_product==1)
			{
				if(is_scrap_ == 1)//hurda
					var new_prod_sql = 'obj_control_basket_prod_acc_10'	
				else if (location_type_ == 1) //hammadde lokasyonu secilmisse
					var new_prod_sql = 'obj_control_basket_prod_acc_11'
				else if (location_type_ == 3)//mamul lokasyonu secilmisse
					var new_prod_sql = 'obj_control_basket_prod_acc_12'
				else
					var new_prod_sql = 'obj_control_basket_prod_acc_8'
			}
			else
			{
				if (location_type_ == 1) //hammadde lokasyonu secilmisse
					var new_prod_sql = 'obj_control_basket_prod_acc_13'
				else if (location_type_ == 3)//mamul lokasyonu secilmisse
					var new_prod_sql = 'obj_control_basket_prod_acc_14'
				else
					var new_prod_sql = 'obj_control_basket_prod_acc_9'
			}
			
			var control_basket_prod_acc = wrk_safe_query(new_prod_sql,'dsn3',0,prod_list);
			if(control_basket_prod_acc.recordcount)
			{
				alert_str = '<cf_get_lang dictionary_id="58483.Muhasebe Kodu Tanımlanmamış Ürünler">:\n'
				//alert_str = 'Muhasebe Kodu Tanımlanmamış Ürünler:\n'
				for(var cnt_i=0;cnt_i<control_basket_prod_acc.recordcount;cnt_i=cnt_i+1)
					alert_str = alert_str +' '+control_basket_prod_acc.PRODUCT_NAME[cnt_i] + '\n';
				alert(alert_str);
				return false;
			}
		}
	}
	return true;
}
function renameFieldNameAll()
{
	<cfif CGI.HTTP_USER_AGENT contains 'Firefox'>
		control_browser = 'document.form_basket';
	<cfelse>
		control_browser = 'document.all';
	</cfif>
	var temp_field_row_catalog_id =eval(control_browser+'.row_catalog_id');
	var temp_field_wrk_row_id =eval(control_browser+'.wrk_row_id');
	var temp_field_row_paymethod_id =eval(control_browser+'.row_paymethod_id');
	var temp_field_wrk_row_relation_id=eval(control_browser+'.wrk_row_relation_id');
	var temp_field_related_action_id =eval(control_browser+'.related_action_id');
	var temp_field_related_action_table=eval(control_browser+'.related_action_table');
	var temp_field_action_row_id =eval(control_browser+'.action_row_id');
	var temp_field_product_id =eval(control_browser+'.product_id');
	var temp_field_is_inventory =eval(control_browser+'.is_inventory');
	var temp_field_is_production =eval(control_browser+'.is_production');
	var temp_field_row_ship_id =eval(control_browser+'.row_ship_id');
	//var temp_field_product_account_code=eval(control_browser+'product_account_code');
	var temp_field_stock_id =eval(control_browser+'.stock_id');
	var temp_field_stock_code =eval(control_browser+'.stock_code');
	var temp_field_barcod =eval(control_browser+'.barcod');
	var temp_field_special_code =eval(control_browser+'.special_code');
	var temp_field_manufact_code =eval(control_browser+'.manufact_code');
	var temp_field_row_unique_relation_id =eval(control_browser+'.row_unique_relation_id');
	var temp_field_karma_product_id =eval(control_browser+'.karma_product_id');
	var temp_field_row_service_id =eval(control_browser+'.row_service_id');
	var temp_field_prom_relation_id =eval(control_browser+'.prom_relation_id');
	var temp_field_price_cat =eval(control_browser+'.price_cat');
	var temp_field_product_name_other =eval(control_browser+'.product_name_other');
	var temp_field_row_promotion_id =eval(control_browser+'.row_promotion_id');
	var temp_field_is_promotion =eval(control_browser+'.is_promotion');
	var temp_field_unit_other =eval(control_browser+'.unit_other');
	var temp_field_ek_tutar_total =eval(control_browser+'.ek_tutar_total');
	var temp_field_shelf_number =eval(control_browser+'.shelf_number');
	var temp_field_shelf_number_txt =eval(control_browser+'.shelf_number_txt');
	var temp_field_to_shelf_number =eval(control_browser+'.to_shelf_number');
	var temp_field_to_shelf_number_txt =eval(control_browser+'.to_shelf_number_txt');
	var temp_field_pbs_id=eval(control_browser+'.pbs_id');
	var temp_field_pbs_code =eval(control_browser+'.pbs_code');
	var temp_field_basket_employee =eval(control_browser+'.basket_employee');
	var temp_field_basket_employee_id =eval(control_browser+'.basket_employee_id');
	var temp_field_product_name =eval(control_browser+'.product_name');
	var temp_field_unit_id =eval(control_browser+'.unit_id');
	var temp_field_unit =eval(control_browser+'.unit');
	var temp_field_spect_id =eval(control_browser+'.spect_id');
	var temp_field_spect_name =eval(control_browser+'.spect_name');
	var temp_field_duedate =eval(control_browser+'.duedate');
	var temp_field_number_of_installment =eval(control_browser+'.number_of_installment');
	var temp_field_deliver_date =eval(control_browser+'.deliver_date');
	var temp_field_reserve_date =eval(control_browser+'.reserve_date');
	var temp_field_deliver_dept =eval(control_browser+'.deliver_dept');
	var temp_field_basket_row_departman =eval(control_browser+'.basket_row_departman');	
	var temp_field_lot_no=eval(control_browser+'.lot_no');
	var temp_field_indirim1 =eval(control_browser+'.indirim1');
	var temp_field_indirim2 =eval(control_browser+'.indirim2');
	var temp_field_indirim3 =eval(control_browser+'.indirim3');
	var temp_field_indirim4 =eval(control_browser+'.indirim4');
	var temp_field_indirim5 =eval(control_browser+'.indirim5');
	var temp_field_indirim6 =eval(control_browser+'.indirim6');
	var temp_field_indirim7 =eval(control_browser+'.indirim7');
	var temp_field_indirim8 =eval(control_browser+'.indirim8');
	var temp_field_indirim9 =eval(control_browser+'.indirim9');
	var temp_field_indirim10 =eval(control_browser+'.indirim10');
	var temp_field_amount_other =eval(control_browser+'.amount_other');
	var temp_field_ek_tutar_other_total =eval(control_browser+'.ek_tutar_other_total');
	var temp_field_ek_tutar =eval(control_browser+'.ek_tutar');
	var temp_field_ek_tutar_price =eval(control_browser+'.ek_tutar_price');
	var temp_field_ek_tutar_cost =eval(control_browser+'.ek_tutar_cost');
	var temp_field_ek_tutar_marj =eval(control_browser+'.ek_tutar_marj');
	var temp_field_amount =eval(control_browser+'.amount');
	var temp_field_list_price =eval(control_browser+'.list_price');
	var temp_field_list_price_disc=eval(control_browser+'.list_price_discount');
	var temp_field_price =eval(control_browser+'.price');
	var temp_field_price_other =eval(control_browser+'.price_other');
	var temp_field_price_net =eval(control_browser+'.price_net');
	var temp_field_price_net_doviz =eval(control_browser+'.price_net_doviz');
	var temp_field_tax =eval(control_browser+'.tax');
	var temp_field_otv_oran =eval(control_browser+'.otv_oran');
	var temp_field_row_total =eval(control_browser+'.row_total');
	var temp_field_row_nettotal =eval(control_browser+'.row_nettotal');
	var temp_field_row_taxtotal =eval(control_browser+'.row_taxtotal');
	var temp_field_tax_price =eval(control_browser+'.tax_price');
	var temp_field_row_otvtotal =eval(control_browser+'.row_otvtotal');
	var temp_field_row_lasttotal =eval(control_browser+'.row_lasttotal');
	var temp_field_other_money_value_ =eval(control_browser+'.other_money_value_');
	var temp_field_other_money_gross_total =eval(control_browser+'.other_money_gross_total');
	var temp_field_net_maliyet =eval(control_browser+'.net_maliyet');
	var temp_field_marj =eval(control_browser+'.marj');
	var temp_field_darali =eval(control_browser+'.darali');
	var temp_field_dara =eval(control_browser+'.dara');
	var temp_field_extra_cost =eval(control_browser+'.extra_cost');
	var temp_field_promosyon_yuzde =eval(control_browser+'.promosyon_yuzde');
	var temp_field_promosyon_maliyet =eval(control_browser+'.promosyon_maliyet');
	var temp_field_iskonto_tutar =eval(control_browser+'.iskonto_tutar');
	var temp_field_is_commission =eval(control_browser+'.is_commission');
	var temp_field_prom_stock_id= eval(control_browser+'.prom_stock_id');
	var temp_field_row_width =eval(control_browser+'.row_width');
	var temp_field_row_depth= eval(control_browser+'.row_depth');
	var temp_field_row_height =eval(control_browser+'.row_height');
	var temp_field_row_prj_id =eval(control_browser+'.row_project_id');
	var temp_field_row_prj_name= eval(control_browser+'.row_project_name');
	var temp_field_row_work_id =eval(control_browser+'.row_work_id');
	var temp_field_row_work_name= eval(control_browser+'.row_work_name');
	var temp_field_row_exp_center_id = eval(control_browser+'.row_exp_center_id');
	var temp_field_row_exp_center_name = eval(control_browser+'.row_exp_center_name');
	var temp_field_row_exp_item_id = eval(control_browser+'.row_exp_item_id');
	var temp_field_row_exp_item_name = eval(control_browser+'.row_exp_item_name');
	var temp_field_row_acc_code = eval(control_browser+'.row_acc_code');
	
	if(eval(control_browser+'.product_id.length') != undefined && eval(control_browser+'.product_id.length') >1)
	{
		var temp_prod_len = eval(control_browser+'.product_id.length')-1; 
		for (var row_jj=temp_prod_len; row_jj >= 0; row_jj--)
		{
		var new_row_jj=row_jj;
		temp_field_wrk_row_id[row_jj].name = 'wrk_row_id'+ (new_row_jj+1);
		temp_field_wrk_row_relation_id[row_jj].name = 'wrk_row_relation_id'+ (new_row_jj+1);
		temp_field_row_paymethod_id[row_jj].name = 'row_paymethod_id'+ (new_row_jj+1);
		temp_field_related_action_id[row_jj].name ='related_action_id'+ (new_row_jj+1);
		temp_field_related_action_table[row_jj].name='related_action_table'+ (new_row_jj+1);
		temp_field_row_catalog_id[row_jj].name =  'row_catalog_id' + (new_row_jj+1);
		temp_field_product_id[row_jj].name =  'product_id' + (new_row_jj+1);
		temp_field_action_row_id[row_jj].name =  'action_row_id' + (new_row_jj+1);
		temp_field_is_inventory[row_jj].name ='is_inventory' + (new_row_jj+1);
		temp_field_is_production[row_jj].name ='is_production' + (new_row_jj+1);
		temp_field_row_ship_id[row_jj].name ='row_ship_id' + (new_row_jj+1);
		//temp_field_product_account_code[row_jj].name ='product_account_code' + (new_row_jj+1);
		temp_field_stock_id[row_jj].name ='stock_id' + (new_row_jj+1);
		temp_field_stock_code[row_jj].name ='stock_code' + (new_row_jj+1);
		temp_field_barcod[row_jj].name ='barcod' + (new_row_jj+1);
		temp_field_special_code[row_jj].name ='special_code' + (new_row_jj+1);
		temp_field_manufact_code[row_jj].name ='manufact_code' + (new_row_jj+1);
		temp_field_row_unique_relation_id[row_jj].name ='row_unique_relation_id' + (new_row_jj+1);
		temp_field_karma_product_id[row_jj].name ='karma_product_id' + (new_row_jj+1);
		temp_field_row_service_id[row_jj].name ='row_service_id' + (new_row_jj+1);
		temp_field_prom_relation_id[row_jj].name ='prom_relation_id' + (new_row_jj+1);
		temp_field_price_cat[row_jj].name ='price_cat' + (new_row_jj+1);
		temp_field_product_name_other[row_jj].name ='product_name_other' + (new_row_jj+1);
		temp_field_row_promotion_id[row_jj].name ='row_promotion_id' + (new_row_jj+1);
		temp_field_is_promotion[row_jj].name ='is_promotion' + (new_row_jj+1);
		temp_field_unit_other[row_jj].name ='unit_other' + (new_row_jj+1);
		temp_field_ek_tutar_total[row_jj].name ='ek_tutar_total' + (new_row_jj+1);
		temp_field_shelf_number[row_jj].name ='shelf_number' + (new_row_jj+1);
		temp_field_shelf_number_txt[row_jj].name ='shelf_number_txt' + (new_row_jj+1);
		temp_field_to_shelf_number[row_jj].name ='to_shelf_number' + (new_row_jj+1);
		temp_field_to_shelf_number_txt[row_jj].name ='to_shelf_number_txt' + (new_row_jj+1);
		temp_field_pbs_id[row_jj].name ='pbs_id' + (new_row_jj+1);
		temp_field_pbs_code[row_jj].name ='pbs_code' + (new_row_jj+1);
		temp_field_basket_employee[row_jj].name ='basket_employee' + (new_row_jj+1);
		temp_field_basket_employee_id[row_jj].name ='basket_employee_id' + (new_row_jj+1);
		temp_field_product_name[row_jj].name ='product_name' + (new_row_jj+1);
		temp_field_unit_id[row_jj].name ='unit_id' + (new_row_jj+1);
		temp_field_unit[row_jj].name ='unit' + (new_row_jj+1);
		temp_field_spect_id[row_jj].name ='spect_id' + (new_row_jj+1);
		temp_field_spect_name[row_jj].name ='spect_name' + (new_row_jj+1);
		temp_field_duedate[row_jj].name ='duedate' + (new_row_jj+1);
		temp_field_number_of_installment[row_jj].name ='number_of_installment' + (new_row_jj+1);
		temp_field_deliver_date[row_jj].name ='deliver_date' + (new_row_jj+1);
		temp_field_reserve_date[row_jj].name ='reserve_date' + (new_row_jj+1);
		temp_field_deliver_dept[row_jj].name ='deliver_dept' + (new_row_jj+1);
		temp_field_basket_row_departman[row_jj].name ='basket_row_departman' + (new_row_jj+1);
		temp_field_lot_no[row_jj].name ='lot_no' + (new_row_jj+1);
		temp_field_indirim1[row_jj].value = filterNumBasket(temp_field_indirim1[row_jj].value,2);
		temp_field_indirim2[row_jj].value = filterNumBasket(temp_field_indirim2[row_jj].value,2);
		temp_field_indirim3[row_jj].value = filterNumBasket(temp_field_indirim3[row_jj].value,2);
		temp_field_indirim4[row_jj].value = filterNumBasket(temp_field_indirim4[row_jj].value,2);
		temp_field_indirim5[row_jj].value = filterNumBasket(temp_field_indirim5[row_jj].value,2);
		temp_field_indirim6[row_jj].value = filterNumBasket(temp_field_indirim6[row_jj].value,2);
		temp_field_indirim7[row_jj].value = filterNumBasket(temp_field_indirim7[row_jj].value,2);
		temp_field_indirim8[row_jj].value = filterNumBasket(temp_field_indirim8[row_jj].value,2);
		temp_field_indirim9[row_jj].value = filterNumBasket(temp_field_indirim9[row_jj].value,2);
		temp_field_indirim10[row_jj].value = filterNumBasket(temp_field_indirim10[row_jj].value,2);
		temp_field_indirim1[row_jj].name ='indirim1' + (new_row_jj+1);
		temp_field_indirim2[row_jj].name ='indirim2' + (new_row_jj+1);
		temp_field_indirim3[row_jj].name ='indirim3' + (new_row_jj+1);
		temp_field_indirim4[row_jj].name ='indirim4' + (new_row_jj+1);
		temp_field_indirim5[row_jj].name ='indirim5' + (new_row_jj+1);
		temp_field_indirim6[row_jj].name ='indirim6' + (new_row_jj+1);
		temp_field_indirim7[row_jj].name ='indirim7' + (new_row_jj+1);
		temp_field_indirim8[row_jj].name ='indirim8' + (new_row_jj+1);
		temp_field_indirim9[row_jj].name ='indirim9' + (new_row_jj+1);
		temp_field_indirim10[row_jj].name =  'indirim10' + (new_row_jj+1);
		temp_field_amount_other[row_jj].value = filterNumBasket(temp_field_amount_other[row_jj].value,price_round_number);
		temp_field_ek_tutar_other_total[row_jj].value = filterNumBasket(temp_field_ek_tutar_other_total[row_jj].value,price_round_number);
		temp_field_ek_tutar[row_jj].value = filterNumBasket(temp_field_ek_tutar[row_jj].value,price_round_number);
		temp_field_ek_tutar_price[row_jj].value = filterNumBasket(temp_field_ek_tutar_price[row_jj].value,price_round_number);
		temp_field_ek_tutar_cost[row_jj].value =filterNumBasket(temp_field_ek_tutar_cost[row_jj].value,price_round_number);
		temp_field_ek_tutar_marj[row_jj].value= filterNumBasket(temp_field_ek_tutar_marj[row_jj].value,2);
		temp_field_amount[row_jj].value = filterNumBasket(temp_field_amount[row_jj].value,amount_round);
		temp_field_list_price[row_jj].value = filterNumBasket(temp_field_list_price[row_jj].value,price_round_number);
		temp_field_list_price_disc[row_jj].value = filterNumBasket(temp_field_list_price_disc[row_jj].value,price_round_number);
		temp_field_tax_price[row_jj].value = filterNumBasket(temp_field_tax_price[row_jj].value,price_round_number);
		temp_field_price[row_jj].value = filterNumBasket(temp_field_price[row_jj].value,price_round_number);
		temp_field_price_other[row_jj].value = filterNumBasket(temp_field_price_other[row_jj].value,price_round_number);
		temp_field_price_net[row_jj].value = filterNumBasket(temp_field_price_net[row_jj].value,price_round_number);
		temp_field_price_net_doviz[row_jj].value = filterNumBasket(temp_field_price_net_doviz[row_jj].value,price_round_number);
		temp_field_amount_other[row_jj].name ='amount_other' + (new_row_jj+1);
		temp_field_ek_tutar_other_total[row_jj].name ='ek_tutar_other_total' + (new_row_jj+1);
		temp_field_ek_tutar[row_jj].name ='ek_tutar' + (new_row_jj+1);
		temp_field_ek_tutar_price[row_jj].name ='ek_tutar_price' + (new_row_jj+1);
		temp_field_ek_tutar_cost[row_jj].name ='ek_tutar_cost' + (new_row_jj+1);
		temp_field_ek_tutar_marj[row_jj].name= 'ek_tutar_marj' + (new_row_jj+1);
		temp_field_amount[row_jj].name ='amount' + (new_row_jj+1);
		temp_field_list_price[row_jj].name ='list_price' + (new_row_jj+1);
		temp_field_list_price_disc[row_jj].name ='list_price_discount' + (new_row_jj+1);
		temp_field_tax_price[row_jj].name ='tax_price' + (new_row_jj+1);
		temp_field_price[row_jj].name ='price' + (new_row_jj+1);
		temp_field_price_other[row_jj].name ='price_other' + (new_row_jj+1);
		temp_field_price_net[row_jj].name ='price_net' + (new_row_jj+1);
		temp_field_price_net_doviz[row_jj].name ='price_net_doviz' + (new_row_jj+1);
		temp_field_tax[row_jj].value = filterNumBasket(temp_field_tax[row_jj].value,0);
		temp_field_otv_oran[row_jj].value = filterNumBasket(temp_field_otv_oran[row_jj].value,price_round_number);
		temp_field_row_total[row_jj].value = filterNumBasket(temp_field_row_total[row_jj].value,price_round_number);
		temp_field_row_nettotal[row_jj].value = filterNumBasket(temp_field_row_nettotal[row_jj].value,price_round_number);
		temp_field_row_taxtotal[row_jj].value = filterNumBasket(temp_field_row_taxtotal[row_jj].value,price_round_number);
		temp_field_tax[row_jj].name ='tax' + (new_row_jj+1);
		temp_field_otv_oran[row_jj].name ='otv_oran' + (new_row_jj+1);
		temp_field_row_total[row_jj].name ='row_total' + (new_row_jj+1);
		temp_field_row_nettotal[row_jj].name ='row_nettotal' + (new_row_jj+1);
		temp_field_row_taxtotal[row_jj].name ='row_taxtotal' + (new_row_jj+1);
		temp_field_row_otvtotal[row_jj].value = filterNumBasket(temp_field_row_otvtotal[row_jj].value,price_round_number);
		temp_field_row_lasttotal[row_jj].value = filterNumBasket(temp_field_row_lasttotal[row_jj].value,price_round_number);
		temp_field_other_money_value_[row_jj].value = filterNumBasket(temp_field_other_money_value_[row_jj].value,price_round_number);
		temp_field_other_money_gross_total[row_jj].value = filterNumBasket(temp_field_other_money_gross_total[row_jj].value,price_round_number);
		temp_field_row_otvtotal[row_jj].name ='row_otvtotal' + (new_row_jj+1);
		temp_field_row_lasttotal[row_jj].name ='row_lasttotal' + (new_row_jj+1);
		temp_field_other_money_value_[row_jj].name ='other_money_value_' + (new_row_jj+1);
		temp_field_other_money_gross_total[row_jj].name ='other_money_gross_total' + (new_row_jj+1);
		temp_field_net_maliyet[row_jj].value = filterNumBasket(temp_field_net_maliyet[row_jj].value,price_round_number);
		temp_field_marj[row_jj].value = filterNumBasket(temp_field_marj[row_jj].value,2);
		temp_field_darali[row_jj].value = filterNumBasket(temp_field_darali[row_jj].value,amount_round);
		temp_field_dara[row_jj].value = filterNumBasket(temp_field_dara[row_jj].value,amount_round);
		temp_field_net_maliyet[row_jj].name ='net_maliyet' + (new_row_jj+1);
		temp_field_marj[row_jj].name ='marj' + (new_row_jj+1);
		temp_field_darali[row_jj].name ='darali' + (new_row_jj+1);
		temp_field_dara[row_jj].name ='dara' + (new_row_jj+1);
		temp_field_extra_cost[row_jj].value = filterNumBasket(temp_field_extra_cost[row_jj].value,price_round_number);
		temp_field_promosyon_yuzde[row_jj].value = filterNumBasket(temp_field_promosyon_yuzde[row_jj].value,2);
		temp_field_promosyon_maliyet[row_jj].value = filterNumBasket(temp_field_promosyon_maliyet[row_jj].value,price_round_number);
		temp_field_iskonto_tutar[row_jj].value = filterNumBasket(temp_field_iskonto_tutar[row_jj].value,price_round_number);
		temp_field_extra_cost[row_jj].name ='extra_cost' + (new_row_jj+1);
		temp_field_promosyon_yuzde[row_jj].name ='promosyon_yuzde' + (new_row_jj+1);
		temp_field_promosyon_maliyet[row_jj].name ='promosyon_maliyet' + (new_row_jj+1);
		temp_field_iskonto_tutar[row_jj].name ='iskonto_tutar' + (new_row_jj+1);
		temp_field_is_commission[row_jj].name ='is_commission' + (new_row_jj+1);
		temp_field_prom_stock_id[row_jj].name ='prom_stock_id' + (new_row_jj+1);
		temp_field_row_width[row_jj].value = filterNumBasket(temp_field_row_width[row_jj].value,2);
		temp_field_row_depth[row_jj].value = filterNumBasket(temp_field_row_depth[row_jj].value,2);
		temp_field_row_height[row_jj].value = filterNumBasket(temp_field_row_height[row_jj].value,2);
		temp_field_row_width[row_jj].name ='row_width' + (new_row_jj+1);
		temp_field_row_depth[row_jj].name ='row_depth' + (new_row_jj+1);
		temp_field_row_height[row_jj].name ='row_height' + (new_row_jj+1);
		temp_field_row_prj_id[row_jj].name ='row_project_id'+(new_row_jj+1);
		temp_field_row_prj_name[row_jj].name= 'row_project_name'+(new_row_jj+1);
		temp_field_row_work_id[row_jj].name ='row_work_id'+(new_row_jj+1);
		temp_field_row_work_name[row_jj].name= 'row_work_name'+(new_row_jj+1);
		//masraf merkezi, butce kalemi ve muhasebe kodu//
		temp_field_row_exp_center_id[row_jj].name ='row_exp_center_id'+(new_row_jj+1);
		temp_field_row_exp_center_name[row_jj].name= 'row_exp_center_name'+(new_row_jj+1);
		temp_field_row_exp_item_id[row_jj].name ='row_exp_item_id'+(new_row_jj+1);
		temp_field_row_exp_item_name[row_jj].name= 'row_exp_item_name'+(new_row_jj+1);
		temp_field_row_acc_code[row_jj].name= 'row_acc_code'+(new_row_jj+1);
		}
	}
	else
	{
	if(temp_field_wrk_row_id[0]!=undefined) temp_field_wrk_row_id[0].name ='wrk_row_id1';else temp_field_wrk_row_id.name =  'wrk_row_id1';
	if(temp_field_wrk_row_relation_id[0]!=undefined) temp_field_wrk_row_relation_id[0].name ='wrk_row_relation_id1';else temp_field_wrk_row_relation_id.name ='wrk_row_relation_id1';
	if(temp_field_row_paymethod_id[0]!=undefined) temp_field_row_paymethod_id[0].name ='row_paymethod_id1';else temp_field_row_paymethod_id.name ='row_paymethod_id1';
	if(temp_field_related_action_id[0]!=undefined) temp_field_related_action_id[0].name ='related_action_id1';else temp_field_related_action_id.name ='related_action_id1';
	if(temp_field_related_action_table[0]!=undefined) temp_field_related_action_table[0].name ='related_action_table1';else temp_field_related_action_table.name ='related_action_table1';
	if(temp_field_row_catalog_id[0]!=undefined) temp_field_row_catalog_id[0].name = 'row_catalog_id1';else temp_field_row_catalog_id.name ='row_catalog_id1';
	if(temp_field_action_row_id[0]!=undefined) temp_field_action_row_id[0].name ='action_row_id1';else temp_field_action_row_id.name ='action_row_id1';
	if(temp_field_product_id[0]!=undefined) temp_field_product_id[0].name = 'product_id1';else temp_field_product_id.name ='product_id1';
	if(temp_field_is_inventory[0]!=undefined) temp_field_is_inventory[0].name ='is_inventory1';else temp_field_is_inventory.name ='is_inventory1';
	if(temp_field_is_production[0]!=undefined) temp_field_is_production[0].name ='is_production1';else temp_field_is_production.name =  'is_production1';
	if(temp_field_row_ship_id[0]!=undefined) temp_field_row_ship_id[0].name ='row_ship_id1';else temp_field_row_ship_id.name ='row_ship_id1';
	//if(temp_field_product_account_code[0]!=undefined) temp_field_product_account_code[0].name ='product_account_code1';else temp_field_product_account_code.name ='product_account_code1';
	if(temp_field_stock_id[0]!=undefined) temp_field_stock_id[0].name ='stock_id1';else temp_field_stock_id.name = 'stock_id1';
	if(temp_field_stock_code[0]!=undefined) temp_field_stock_code[0].name ='stock_code1';else temp_field_stock_code.name ='stock_code1';
	if(temp_field_barcod[0]!=undefined) temp_field_barcod[0].name ='barcod1';else temp_field_barcod.name ='barcod1';
	if(temp_field_special_code[0]!=undefined) temp_field_special_code[0].name ='special_code1';else temp_field_special_code.name ='special_code1';
	if(temp_field_manufact_code[0]!=undefined) temp_field_manufact_code[0].name ='manufact_code1';else temp_field_manufact_code.name ='manufact_code1';
	if(temp_field_row_unique_relation_id[0]!=undefined) temp_field_row_unique_relation_id[0].name ='row_unique_relation_id1';else temp_field_row_unique_relation_id.name ='row_unique_relation_id1';
	if(temp_field_karma_product_id[0]!=undefined) temp_field_karma_product_id[0].name ='karma_product_id1';else temp_field_karma_product_id.name =  'karma_product_id1';
	if(temp_field_row_service_id[0]!=undefined) temp_field_row_service_id[0].name =  'row_service_id1';else temp_field_row_service_id.name =  'row_service_id1';
	if(temp_field_prom_relation_id[0]!=undefined) temp_field_prom_relation_id[0].name =  'prom_relation_id1';else temp_field_prom_relation_id.name ='prom_relation_id1';
	if(temp_field_price_cat[0]!=undefined) temp_field_price_cat[0].name =  'price_cat1';else temp_field_price_cat.name ='price_cat1';
	if(temp_field_product_name_other[0]!=undefined) temp_field_product_name_other[0].name ='product_name_other1';else temp_field_product_name_other.name ='product_name_other1';
	if(temp_field_row_promotion_id[0]!=undefined) temp_field_row_promotion_id[0].name ='row_promotion_id1';else temp_field_row_promotion_id.name ='row_promotion_id1';
	if(temp_field_is_promotion[0]!=undefined) temp_field_is_promotion[0].name =  'is_promotion1';else temp_field_is_promotion.name =  'is_promotion1';
	if(temp_field_unit_other[0]!=undefined) 
	{
		temp_field_unit_other[0].name ='unit_other1'; 
		try
		{
			temp_field_unit_other.name =  'unit_other1';
		}
		catch(e){}
	}
	else 
		temp_field_unit_other.name =  'unit_other1';
	//if(temp_field_unit_other[0]!=undefined) temp_field_unit_other[0].name ='unit_other1';else temp_field_unit_other.name =  'unit_other1';
	if(temp_field_ek_tutar_total[0]!=undefined) temp_field_ek_tutar_total[0].name ='ek_tutar_total1';else temp_field_ek_tutar_total.name =  'ek_tutar_total1';
	if(temp_field_shelf_number[0]!=undefined) temp_field_shelf_number[0].name ='shelf_number1';else temp_field_shelf_number.name =  'shelf_number1';
	if(temp_field_shelf_number_txt[0]!=undefined) temp_field_shelf_number_txt[0].name ='shelf_number_txt1';else temp_field_shelf_number_txt.name =  'shelf_number_txt1';
	if(temp_field_to_shelf_number[0]!=undefined) temp_field_to_shelf_number[0].name ='to_shelf_number1';else temp_field_to_shelf_number.name =  'to_shelf_number1';
	if(temp_field_to_shelf_number_txt[0]!=undefined) temp_field_to_shelf_number_txt[0].name ='to_shelf_number_txt1';else temp_field_to_shelf_number_txt.name =  'to_shelf_number_txt1';
	if(temp_field_pbs_id[0]!=undefined) temp_field_pbs_id[0].name ='pbs_id1';else temp_field_pbs_id.name =  'pbs_id1';
	if(temp_field_pbs_code[0]!=undefined) temp_field_pbs_code[0].name ='pbs_code1';else temp_field_pbs_code.name =  'pbs_code1';
	if(temp_field_basket_employee[0]!=undefined) temp_field_basket_employee[0].name ='basket_employee1';else temp_field_basket_employee.name =  'basket_employee1';
	if(temp_field_to_shelf_number[0]!=undefined) temp_field_to_shelf_number[0].name ='to_shelf_number1';else temp_field_to_shelf_number.name =  'to_shelf_number1';
	if(temp_field_to_shelf_number_txt[0]!=undefined) temp_field_to_shelf_number_txt[0].name ='to_shelf_number_txt1';else temp_field_to_shelf_number_txt.name =  'to_shelf_number_txt1';
	if(temp_field_basket_employee_id[0]!=undefined) temp_field_basket_employee_id[0].name = 'basket_employee_id1';else temp_field_basket_employee_id.name =  'basket_employee_id1';
	if(temp_field_product_name[0]!=undefined) temp_field_product_name[0].name ='product_name1';else temp_field_product_name.name =  'product_name1';
	if(temp_field_unit_id[0]!=undefined) temp_field_unit_id[0].name ='unit_id1';else temp_field_unit_id.name ='unit_id1';
	if(temp_field_unit[0]!=undefined) temp_field_unit[0].name ='unit1';else temp_field_unit.name ='unit1';
	if(temp_field_spect_id[0]!=undefined) temp_field_spect_id[0].name ='spect_id1';else temp_field_spect_id.name ='spect_id1';
	if(temp_field_spect_name[0]!=undefined) temp_field_spect_name[0].name ='spect_name1';else temp_field_spect_name.name ='spect_name1';
	if(temp_field_duedate[0]!=undefined) temp_field_duedate[0].name ='duedate1';else temp_field_duedate.name =  'duedate1';
	if(temp_field_number_of_installment[0]!=undefined) temp_field_number_of_installment[0].name =  'number_of_installment1';else temp_field_number_of_installment.name =  'number_of_installment1';
	if(temp_field_deliver_date[0]!=undefined) temp_field_deliver_date[0].name ='deliver_date1';else temp_field_deliver_date.name ='deliver_date1';
	if(temp_field_reserve_date[0]!=undefined) temp_field_reserve_date[0].name ='reserve_date1';else temp_field_reserve_date.name ='reserve_date1';
	if(temp_field_deliver_dept[0]!=undefined) temp_field_deliver_dept[0].name ='deliver_dept1';else temp_field_deliver_dept.name ='deliver_dept1';
	if(temp_field_basket_row_departman[0]!=undefined) temp_field_basket_row_departman[0].name =  'basket_row_departman1';else temp_field_basket_row_departman.name =  'basket_row_departman1';
	if(temp_field_lot_no[0]!=undefined) temp_field_lot_no[0].name =  'lot_no1';else temp_field_lot_no.name =  'lot_no1';
	if(temp_field_is_commission[0]!=undefined) temp_field_is_commission[0].name ='is_commission1';else temp_field_is_commission.name = 'is_commission1';
	if(temp_field_prom_stock_id[0]!=undefined) temp_field_prom_stock_id[0].name ='prom_stock_id1';else temp_field_prom_stock_id.name =  'prom_stock_id1';
	if(temp_field_indirim1[0]!=undefined){
		temp_field_indirim1[0].value = filterNumBasket(temp_field_indirim1[0].value,2);temp_field_indirim1[0].name='indirim11';}
	else{
		temp_field_indirim1.value = filterNumBasket(temp_field_indirim1.value,2); temp_field_indirim1.name='indirim11';}
	if(temp_field_indirim2[0]!=undefined)
		{temp_field_indirim2[0].value = filterNumBasket(temp_field_indirim2[0].value,2);temp_field_indirim2[0].name='indirim21';}
	else
		{temp_field_indirim2.value = filterNumBasket(temp_field_indirim2.value,2);temp_field_indirim2.name='indirim21';}
	if(temp_field_indirim3[0]!=undefined)
		{temp_field_indirim3[0].value = filterNumBasket(temp_field_indirim3[0].value,2);temp_field_indirim3[0].name='indirim31';}
	else
		{temp_field_indirim3.value = filterNumBasket(temp_field_indirim3.value,2);temp_field_indirim3.name='indirim31';}
	if(temp_field_indirim4[0]!=undefined){
		temp_field_indirim4[0].value = filterNumBasket(temp_field_indirim4[0].value,2);temp_field_indirim4[0].name='indirim41';}
	else{
		temp_field_indirim4.value = filterNumBasket(temp_field_indirim4.value,2);temp_field_indirim4.name='indirim41';}
	if(temp_field_indirim5[0]!=undefined){
		temp_field_indirim5[0].value = filterNumBasket(temp_field_indirim5[0].value,2);temp_field_indirim5[0].name='indirim51';}
	else{
		temp_field_indirim5.value = filterNumBasket(temp_field_indirim5.value,2);temp_field_indirim5.name='indirim51';}
	if(temp_field_indirim6[0]!=undefined){
		temp_field_indirim6[0].value = filterNumBasket(temp_field_indirim6[0].value,2);temp_field_indirim6[0].name='indirim61';}
	else{
		temp_field_indirim6.value = filterNumBasket(temp_field_indirim6.value,2);temp_field_indirim6.name='indirim61';}
	if(temp_field_indirim7[0]!=undefined){
		temp_field_indirim7[0].value = filterNumBasket(temp_field_indirim7[0].value,2);temp_field_indirim7[0].name='indirim71';}
	else{
		temp_field_indirim7.value = filterNumBasket(temp_field_indirim7.value,2);temp_field_indirim7.name='indirim71';}
	if(temp_field_indirim8[0]!=undefined){
		temp_field_indirim8[0].value = filterNumBasket(temp_field_indirim8[0].value,2);temp_field_indirim8[0].name='indirim81';}
	else{
		temp_field_indirim8.value = filterNumBasket(temp_field_indirim8.value,2);temp_field_indirim8.name='indirim81';}
	if(temp_field_indirim9[0]!=undefined){
		temp_field_indirim9[0].value = filterNumBasket(temp_field_indirim9[0].value,2);temp_field_indirim9[0].name='indirim91';}
	else{
		temp_field_indirim9.value = filterNumBasket(temp_field_indirim9.value,2);temp_field_indirim9.name='indirim91';}
	if(temp_field_indirim10[0]!=undefined){
		temp_field_indirim10[0].value = filterNumBasket(temp_field_indirim10[0].value,2);temp_field_indirim10[0].name='indirim101';}
	else{
		temp_field_indirim10.value = filterNumBasket(temp_field_indirim10.value,2);temp_field_indirim10.name='indirim101';}
	if(temp_field_amount_other[0]!=undefined){
		temp_field_amount_other[0].value = filterNumBasket(temp_field_amount_other[0].value,price_round_number);temp_field_amount_other[0].name='amount_other1';}
	else{
		temp_field_amount_other.value = filterNumBasket(temp_field_amount_other.value,price_round_number);
		temp_field_amount_other.name='amount_other1';}
	if(temp_field_ek_tutar_other_total[0]!=undefined){
		temp_field_ek_tutar_other_total[0].value = filterNumBasket(temp_field_ek_tutar_other_total[0].value,price_round_number);
		temp_field_ek_tutar_other_total[0].name ='ek_tutar_other_total1';}
	else{
		temp_field_ek_tutar_other_total.value = filterNumBasket(temp_field_ek_tutar_other_total.value,price_round_number);
		temp_field_ek_tutar_other_total.name ='ek_tutar_other_total1';}
	if(temp_field_ek_tutar[0]!=undefined){
		temp_field_ek_tutar[0].value = filterNumBasket(temp_field_ek_tutar[0].value,price_round_number);
		temp_field_ek_tutar[0].name ='ek_tutar1';}
	else{
		temp_field_ek_tutar.value = filterNumBasket(temp_field_ek_tutar.value,price_round_number);
		temp_field_ek_tutar.name ='ek_tutar1';}
	if(temp_field_ek_tutar_price[0]!=undefined){
		temp_field_ek_tutar_price[0].value = filterNumBasket(temp_field_ek_tutar_price[0].value,price_round_number);
		temp_field_ek_tutar_price[0].name ='ek_tutar_price1';}
	else{
		temp_field_ek_tutar_price.value = filterNumBasket(temp_field_ek_tutar_price.value,price_round_number);
		temp_field_ek_tutar_price.name ='ek_tutar_price1';}
	if(temp_field_ek_tutar_cost[0]!=undefined){
		temp_field_ek_tutar_cost[0].value = filterNumBasket(temp_field_ek_tutar_cost[0].value,price_round_number);
		temp_field_ek_tutar_cost[0].name ='ek_tutar_cost1';}
	else{
		temp_field_ek_tutar_cost.value = filterNumBasket(temp_field_ek_tutar_cost.value,price_round_number);
		temp_field_ek_tutar_cost.name ='ek_tutar_cost1';}
	if(temp_field_ek_tutar_marj[0]!=undefined){
		temp_field_ek_tutar_marj[0].value = filterNumBasket(temp_field_ek_tutar_marj[0].value,2);
		temp_field_ek_tutar_marj[0].name ='ek_tutar_marj1';}
	else{
		temp_field_ek_tutar_marj.value = filterNumBasket(temp_field_ek_tutar_marj.value,2);
		temp_field_ek_tutar_marj.name ='ek_tutar_marj1';}
	if(temp_field_amount[0]!=undefined){
		temp_field_amount[0].value = filterNumBasket(temp_field_amount[0].value,amount_round);
		temp_field_amount[0].name ='amount1';}
	else{
		temp_field_amount.value = filterNumBasket(temp_field_amount.value,amount_round);
		temp_field_amount.name ='amount1';}
	if(temp_field_list_price[0]!=undefined){
		temp_field_list_price[0].value = filterNumBasket(temp_field_list_price[0].value,price_round_number);
		temp_field_list_price[0].name ='list_price1';}
	else{
		temp_field_list_price.value = filterNumBasket(temp_field_list_price.value,price_round_number);
		temp_field_list_price.name ='list_price1';}
	if(temp_field_list_price_disc[0]!=undefined){
		temp_field_list_price_disc[0].value = filterNumBasket(temp_field_list_price_disc[0].value,price_round_number);
		temp_field_list_price_disc[0].name ='list_price_discount1';}
	else{
		temp_field_list_price_disc.value = filterNumBasket(temp_field_list_price_disc.value,price_round_number);
		temp_field_list_price_disc.name ='list_price_discount1';}
	if(temp_field_tax_price[0]!=undefined){
		temp_field_tax_price[0].value = filterNumBasket(temp_field_tax_price[0].value,price_round_number);
		temp_field_tax_price[0].name ='tax_price1';}
	else{
		temp_field_tax_price.value = filterNumBasket(temp_field_tax_price.value,price_round_number);
		temp_field_tax_price.name ='tax_price1';}
	if(temp_field_price[0]!=undefined){
		temp_field_price[0].value = filterNumBasket(temp_field_price[0].value,price_round_number);
		temp_field_price[0].name ='price1';}
	else{
		temp_field_price.value = filterNumBasket(temp_field_price.value,price_round_number);
		temp_field_price.name ='price1';}
	if(temp_field_price_other[0]!=undefined){
		temp_field_price_other[0].value = filterNumBasket(temp_field_price_other[0].value,price_round_number);
		temp_field_price_other[0].name ='price_other1';}
	else{
		temp_field_price_other.value = filterNumBasket(temp_field_price_other.value,price_round_number);
		temp_field_price_other.name ='price_other1';}
	if(temp_field_price_net[0]!=undefined){
		temp_field_price_net[0].value = filterNumBasket(temp_field_price_net[0].value,price_round_number);
		temp_field_price_net[0].name ='price_net1';}
	else{
		temp_field_price_net.value = filterNumBasket(temp_field_price_net.value,price_round_number);
		temp_field_price_net.name ='price_net1';}
	if(temp_field_price_net_doviz[0]!=undefined){
		temp_field_price_net_doviz[0].value = filterNumBasket(temp_field_price_net_doviz[0].value,price_round_number);
		temp_field_price_net_doviz[0].name ='price_net_doviz1';}
	else{
		temp_field_price_net_doviz.value = filterNumBasket(temp_field_price_net_doviz.value,price_round_number);
		temp_field_price_net_doviz.name ='price_net_doviz1';}
	if(temp_field_tax[0]!=undefined){
		temp_field_tax[0].value = filterNumBasket(temp_field_tax[0].value,0);
		temp_field_tax[0].name ='tax1';}
	else{
		temp_field_tax.value = filterNumBasket(temp_field_tax.value,0);
		temp_field_tax.name ='tax1';}
	if(temp_field_otv_oran[0]!=undefined){
		temp_field_otv_oran[0].value = filterNumBasket(temp_field_otv_oran[0].value,price_round_number);temp_field_otv_oran[0].name ='otv_oran1';}
	else{
		temp_field_otv_oran.value = filterNumBasket(temp_field_otv_oran.value,price_round_number);temp_field_otv_oran.name ='otv_oran1';}
	if(temp_field_row_total[0]!=undefined){
		temp_field_row_total[0].value = filterNumBasket(temp_field_row_total[0].value,price_round_number);temp_field_row_total[0].name ='row_total1';}
	else{
		temp_field_row_total.value = filterNumBasket(temp_field_row_total.value,price_round_number);temp_field_row_total.name ='row_total1';}
	if(temp_field_row_nettotal[0]!=undefined){
		temp_field_row_nettotal[0].value = filterNumBasket(temp_field_row_nettotal[0].value,price_round_number);temp_field_row_nettotal[0].name ='row_nettotal1';}
	else{
		temp_field_row_nettotal.value = filterNumBasket(temp_field_row_nettotal.value,price_round_number);temp_field_row_nettotal.name ='row_nettotal1';}
	if(temp_field_row_taxtotal[0]!=undefined){
		temp_field_row_taxtotal[0].value = filterNumBasket(temp_field_row_taxtotal[0].value,price_round_number);temp_field_row_taxtotal[0].name ='row_taxtotal1';}
	else{
		temp_field_row_taxtotal.value = filterNumBasket(temp_field_row_taxtotal.value,price_round_number);temp_field_row_taxtotal.name ='row_taxtotal1';}
	if(temp_field_row_otvtotal[0]!=undefined){
		temp_field_row_otvtotal[0].value = filterNumBasket(temp_field_row_otvtotal[0].value,price_round_number);temp_field_row_otvtotal[0].name ='row_otvtotal1';}
	else{
		temp_field_row_otvtotal.value = filterNumBasket(temp_field_row_otvtotal.value,price_round_number);temp_field_row_otvtotal.name ='row_otvtotal1';}
	if(temp_field_row_lasttotal[0]!=undefined){
		temp_field_row_lasttotal[0].value = filterNumBasket(temp_field_row_lasttotal[0].value,price_round_number);temp_field_row_lasttotal[0].name ='row_lasttotal1';}
	else{
		temp_field_row_lasttotal.value = filterNumBasket(temp_field_row_lasttotal.value,price_round_number);temp_field_row_lasttotal.name ='row_lasttotal1';}
	if(temp_field_other_money_value_[0]!=undefined){
		temp_field_other_money_value_[0].value = filterNumBasket(temp_field_other_money_value_[0].value,price_round_number);temp_field_other_money_value_[0].name ='other_money_value_1';}
	else{
		temp_field_other_money_value_.value = filterNumBasket(temp_field_other_money_value_.value,price_round_number);temp_field_other_money_value_.name ='other_money_value_1';}
	if(temp_field_other_money_gross_total[0]!=undefined){
		temp_field_other_money_gross_total[0].value = filterNumBasket(temp_field_other_money_gross_total[0].value,price_round_number);temp_field_other_money_gross_total[0].name ='other_money_gross_total1';}
	else{
		temp_field_other_money_gross_total.value = filterNumBasket(temp_field_other_money_gross_total.value,price_round_number);temp_field_other_money_gross_total.name ='other_money_gross_total1';}
	if(temp_field_net_maliyet[0]!=undefined){
		temp_field_net_maliyet[0].value = filterNumBasket(temp_field_net_maliyet[0].value,price_round_number);temp_field_net_maliyet[0].name ='net_maliyet1';}
	else{
		temp_field_net_maliyet.value = filterNumBasket(temp_field_net_maliyet.value,price_round_number);temp_field_net_maliyet.name ='net_maliyet1';}
	if(temp_field_marj[0]!=undefined){
		temp_field_marj[0].value = filterNumBasket(temp_field_marj[0].value,2);temp_field_marj[0].name ='marj1';}
	else{
		temp_field_marj.value = filterNumBasket(temp_field_marj.value,2);temp_field_marj.name ='marj1';}
	if(temp_field_darali[0]!=undefined){
		temp_field_darali[0].value = filterNumBasket(temp_field_darali[0].value,amount_round);
		temp_field_darali[0].name ='darali1';}
	else{
		temp_field_darali.value = filterNumBasket(temp_field_darali.value,amount_round);
		temp_field_darali.name ='darali1';}
	if(temp_field_dara[0]!=undefined){
		temp_field_dara[0].value = filterNumBasket(temp_field_dara[0].value,amount_round);
		temp_field_dara[0].name ='dara1';}
	else{
		temp_field_dara.value = filterNumBasket(temp_field_dara.value,amount_round);
		temp_field_dara.name ='dara1';}
	if(temp_field_extra_cost[0]!=undefined){
		temp_field_extra_cost[0].value = filterNumBasket(temp_field_extra_cost[0].value,price_round_number);
		temp_field_extra_cost[0].name ='extra_cost1';}
	else{
		temp_field_extra_cost.value = filterNumBasket(temp_field_extra_cost.value,price_round_number);
		temp_field_extra_cost.name ='extra_cost1';
		}
	if(temp_field_promosyon_yuzde[0]!=undefined){
		temp_field_promosyon_yuzde[0].value = filterNumBasket(temp_field_promosyon_yuzde[0].value,2);temp_field_promosyon_yuzde[0].name ='promosyon_yuzde1';}
	else{
		temp_field_promosyon_yuzde.value = filterNumBasket(temp_field_promosyon_yuzde.value,2);temp_field_promosyon_yuzde.name ='promosyon_yuzde1';}
	if(temp_field_promosyon_maliyet[0]!=undefined){
		temp_field_promosyon_maliyet[0].value = filterNumBasket(temp_field_promosyon_maliyet[0].value,price_round_number);temp_field_promosyon_maliyet[0].name ='promosyon_maliyet1';}
	else{
		temp_field_promosyon_maliyet.value = filterNumBasket(temp_field_promosyon_maliyet.value,price_round_number);
		temp_field_promosyon_maliyet.name ='promosyon_maliyet1';}
	if(temp_field_iskonto_tutar[0]!=undefined){
		temp_field_iskonto_tutar[0].value = filterNumBasket(temp_field_iskonto_tutar[0].value,price_round_number);
		temp_field_iskonto_tutar[0].name ='iskonto_tutar1';}
	else{
		temp_field_iskonto_tutar.value = filterNumBasket(temp_field_iskonto_tutar.value,price_round_number);
		temp_field_iskonto_tutar.name ='iskonto_tutar1';}

	if(temp_field_row_width[0]!=undefined){
		temp_field_row_width[0].value = filterNumBasket(temp_field_row_width[0].value,2);
		temp_field_row_width[0].name='row_width1';}
	else{
		temp_field_row_width.value = filterNumBasket(temp_field_row_width.value,2);
		temp_field_row_width.name='row_width1';}

	if(temp_field_row_depth[0]!=undefined){
		temp_field_row_depth[0].value = filterNumBasket(temp_field_row_depth[0].value,2);
		temp_field_row_depth[0].name='row_depth1';}
	else{
		temp_field_row_depth.value = filterNumBasket(temp_field_row_depth.value,2);
		temp_field_row_depth.name='row_depth1';}
		
	if(temp_field_row_height[0]!=undefined){
		temp_field_row_height[0].value = filterNumBasket(temp_field_row_height[0].value,2);temp_field_row_height[0].name='row_height1';}
	else{
		temp_field_row_height.value = filterNumBasket(temp_field_row_height.value,2);temp_field_row_height.name='row_height1';}
		
	if(temp_field_row_prj_id[0]!=undefined) temp_field_row_prj_id[0].name='row_project_id1'; else temp_field_row_prj_id.name='row_project_id1';
	if(temp_field_row_prj_name[0]!=undefined) temp_field_row_prj_name[0].name='row_project_name1'; else temp_field_row_prj_name.name='row_project_name1';
	if(temp_field_row_work_id[0]!=undefined) temp_field_row_work_id[0].name='row_work_id1'; else temp_field_row_work_id.name='row_work_id1';
	if(temp_field_row_work_name[0]!=undefined) temp_field_row_work_name[0].name='row_work_name1'; else temp_field_row_work_name.name='row_work_name1';
	//masraf merkezi, butce kalemi ve masraf merkezi//
	if(temp_field_row_exp_center_id[0]!=undefined) temp_field_row_exp_center_id[0].name='row_exp_center_id1'; else temp_field_row_exp_center_id.name='row_exp_center_id1';
	if(temp_field_row_exp_center_name[0]!=undefined) temp_field_row_exp_center_name[0].name='row_exp_center_name1'; else temp_field_row_exp_center_name.name='row_exp_center_name1';
	if(temp_field_row_exp_item_id[0]!=undefined) temp_field_row_exp_item_id[0].name='row_exp_item_id1'; else temp_field_row_exp_item_id.name='row_exp_item_id1';
	if(temp_field_row_exp_item_name[0]!=undefined) temp_field_row_exp_item_name[0].name='row_exp_item_name1'; else temp_field_row_exp_item_name.name='row_exp_item_name1';
	if(temp_field_row_acc_code[0]!=undefined) temp_field_row_acc_code[0].name='row_acc_code1'; else temp_field_row_acc_code.name='row_acc_code1';
	}
}
function pre_submit(kontrol_product)
{
	if(remove_empty_rows())<!--- 20050102 her zaman calismali --->
	{
	if(form_basket.wrk_submit_button.length != undefined)/* 20050520 bazi formlarda birden cok wrk_button oldugu icin butonun bir array olup olmadigini kontrol ediyor */
		wrk_button_enable = 'setTimeout("'+'form_basket.wrk_submit_button[0].disabled=false",10)';
	else
		wrk_button_enable = 'setTimeout("'+'form_basket.wrk_submit_button.disabled=false",10)';
	 /* if(rowCount == 0) return true; 20050520 ürün yoksa direkt geç ifade alttaki hale dondu */
	if(kontrol_product == undefined) kontrol_product = 0;
	if(kontrol_product == 0)
	{
		if(rowCount==0 || (rowCount==1 && document.form_basket.product_id.value != undefined && document.form_basket.product_id.value == '') ||  (rowCount==1 && document.form_basket.product_id.length!= undefined && document.form_basket.product_id[0].value == '') ){
			alert("<cf_get_lang dictionary_id='57725.Ürün Seçmediniz'>!");
			eval(wrk_button_enable);
			// Bu uc satiri kaldirmayiniz. Formlarin onsubmitleri ile workcube_buttons'taki ifadeler cakisiyordu. O yuzden ekledim. EY 20130430
			hide('message_div_main');
			hide('working_div_main');
			_CF_error_exists = true;
			return false;
			}
	}
	<cfif ListFindNoCase(display_list, "basket_employee")>
	/*
	FA- kaldırıldı böyle bir kontrole gerek olursa display file ile halledilmeli..
	if (document.form_basket.basket_employee_id != undefined && document.form_basket.basket_employee_id.length != undefined)
	{
		for (var bsk_j=0; bsk_j < document.form_basket.basket_employee_id.length; bsk_j++)
			if((document.form_basket.basket_employee_id[bsk_j].value=='' || document.form_basket.basket_employee[bsk_j].value=='') && document.form_basket.is_commission[bsk_j].value ==0 )<!--- satış temsilcisi secilmemis ve komisyon satırı degilse --->
			{
				alert("<cf_get_lang_main no='666.Satış Temsilcisi Seçiniz'>!");
				eval(wrk_button_enable);
				return false;
			}
	}
	else if(document.form_basket.basket_employee_id != undefined && document.form_basket.basket_employee != undefined)
	{
		if((document.form_basket.basket_employee_id.value=='' || document.form_basket.basket_employee.value=='') && document.form_basket.is_commission.value ==0 )<!--- satış temsilcisi secilmemis ve komisyon satırı degilse --->
		{
			alert("<cf_get_lang_main no='666.Satış Temsilcisi Seçiniz'>!");
			eval(wrk_button_enable);
			return false;
		}
	}*/
	</cfif>
	<cfif isdefined('use_basket_project_discount_') and use_basket_project_discount_ eq 1> <!--- proje baglantı kontrolleri --->
		if(!check_project_discount_conditions())
		{
			eval(wrk_button_enable);
			return false;
		}
	</cfif>
	<cfif ListFindNoCase(display_list, "is_project_selected")>
		if(prj_id_=='' && document.form_basket.project_id!=undefined)
			var prj_id_=document.form_basket.project_id.value;
		if(prj_name_=='' && document.form_basket.project_head!=undefined)
			var prj_name_=document.form_basket.project_head.value;
		if(prj_id_=='' || prj_name_=='')
		{
			alert("<cf_get_lang dictionary_id='58797.Proje Seçiniz'>");
			eval(wrk_button_enable);
			return false;
		}
	</cfif>
	<cfif ListFindNoCase(display_list, "check_row_discounts")><!--- şube iskonto yetki tanımlarını kontrol ediyor --->
		if(!check_branch_discount_rates())
		{
			eval(wrk_button_enable);
			return false;
		}
	</cfif>
	document.form_basket.rows_.value = rowCount;
	//satır sistem para birimi fakat döviz ve birim fiyatı farklı ise kontrol ediliyor, kontrol basket sablonuna baglanacak
	<cfif isdefined('attributes.basket_id') and not listfind('12,31,32',attributes.basket_id)><!--- sevk irs ve depo fislerinde kontrol yok --->
	/*var temp_price_ =eval('document.form_basket.price');
	var temp_price_other_ =eval('document.form_basket.price_other');
	if(rowCount > 1)
	{
		for (var row_ii=0; row_ii < rowCount; row_ii++)
		{
			if(document.form_basket.other_money_[row_ii].value == '<cfoutput>#session.ep.money#</cfoutput>' && filterNumBasket(temp_price_[row_ii].value,price_round_number)!=filterNumBasket(temp_price_other_[row_ii].value,price_round_number))	
			{
				alert(parseFloat(row_ii+1) + ". <cf_get_lang_main no='1329.Satırın Fiyat ve Döviz Fiyatlarınızı Kontrol Ediniz'>!");
				eval(wrk_button_enable);
				return false;
			}
		}
	}
	else
	{
		if(document.form_basket.other_money_!=undefined)
		{
			if(document.form_basket.other_money_.value == '<cfoutput>#session.ep.money#</cfoutput>' && filterNumBasket(temp_price_.value,price_round_number)!=filterNumBasket(temp_price_other_.value,price_round_number))	
			{
				alert("1. <cf_get_lang_main no='1329.Satırın Fiyat ve Döviz Fiyatlarınızı Kontrol Ediniz'>!");
				eval(wrk_button_enable);
				return false;
			}
		}
		else
		{
			if(document.form_basket.other_money_[0].value == '<cfoutput>#session.ep.money#</cfoutput>' && filterNumBasket(temp_price_[0].value,price_round_number)!=filterNumBasket(temp_price_other_[0].value,price_round_number))	
			{
				alert("1. <cf_get_lang_main no='1329.Satırın Fiyat ve Döviz Fiyatlarınızı Kontrol Ediniz'>!");
				eval(wrk_button_enable);
				return false;
			}
		}
	}*/
	</cfif>
	try{
		var temp_prod_len = document.form_basket.product_id.length;
		var no_post_parameter = 0;
		if(temp_prod_len != undefined)
		{
			for (var j=0; j <temp_prod_len; j++)
			{
				<cfif session.ep.our_company_info.is_lot_no eq 1>//şirket akış parametrelerinde lot no zorunlu olsun seçili ise
					if(check_lotno('form_basket'))//işlem kategorisinde lot no zorunlu olsun seçili ise
					{
						get_prod_detail = wrk_safe_query('obj2_get_prod_name','dsn3',0,document.form_basket.stock_id[j].value);
						if(get_prod_detail.IS_LOT_NO == 1)//üründe lot no takibi yapılıyor seçili ise
						{
							if(document.form_basket.lot_no[j].value == '')
							{
								no_post_parameter = 1;
								alert((j+1)+'. satırdaki '+ document.form_basket.product_name[j].value + ' ürünü için lot no takibi yapılmaktadır!');
								eval(wrk_button_enable);
							}
						}
					}
				</cfif>
			}
		}
		else
		{
			<cfif session.ep.our_company_info.is_lot_no eq 1>//şirket akış parametrelerinde lot no zorunlu olsun seçili ise
				if(check_lotno('form_basket'))//işlem kategorisinde lot no zorunlu olsun seçili ise
				{
					var get_prod_detail = wrk_safe_query('obj2_get_prod_name','dsn3',0,document.form_basket.stock_id.value);
					if(get_prod_detail.IS_LOT_NO == 1)//üründe lot no takibi yapılıyor seçili ise
					{
						if(document.form_basket.lot_no.value == '')
						{
							no_post_parameter = 1;
							alert('1. satırdaki '+ document.form_basket.product_name.value + ' ürünü için lot no takibi yapılmaktadır!');
							eval(wrk_button_enable);
						}
					}
				}
			</cfif>
		}
		if(no_post_parameter == 1)
			return false;
	}
	catch(e)
	{}
	//satır sistem para birimi fakat döviz ve birim fiyatı farklı ise kontrol ediliyor
	<cfoutput query="get_money_bskt">
	var temp_control_rate =#get_money_bskt.rate2/get_money_bskt.rate1#;
	var temp_basket_rate2_ = filterNumBasket(document.form_basket.txt_rate2_#currentrow#.value,basket_rate_round_number)/filterNumBasket(document.form_basket.txt_rate1_#currentrow#.value,basket_rate_round_number);
	if(temp_basket_rate2_ > ((temp_control_rate/100)*250) ) // belge geri donuslerindeki kur dagılmalarını engellemek icin rate2 artısları kontrol ediliyor
	{
		alert('#get_money_bskt.money_type#' Kur Bilgisinde %100\ 'den Fazla Artış Var');
		eval(wrk_button_enable);
		return false;
	}
	</cfoutput>
	<cfoutput query="get_money_bskt">
	var temp_control_rate =#get_money_bskt.rate2/get_money_bskt.rate1#;
	var temp_basket_rate2_ = filterNumBasket(document.form_basket.txt_rate2_#currentrow#.value,basket_rate_round_number);
	
	</cfoutput>
	<cfoutput query="get_money_bskt">
	form_basket.txt_rate1_#currentrow#.value = filterNumBasket(form_basket.txt_rate1_#currentrow#.value,basket_rate_round_number);
	form_basket.txt_rate2_#currentrow#.value = filterNumBasket(form_basket.txt_rate2_#currentrow#.value,basket_rate_round_number);
	</cfoutput>
	if (document.form_basket.product_id != undefined && document.form_basket.product_id.length != undefined && document.form_basket.product_name.length != undefined && document.form_basket.product_id.length > 1) //cok satırlı basketten tek satırlıya dusuldugunde product id karısıklıklarını onlemek icin gecici olarak eklendi.
	{
		var temp_prod_len = document.form_basket.product_id.length-1;
		for (var j=temp_prod_len; j >=0; j--)
		{
		/*	temp_str = document.form_basket.product_name[j].value;
			while (temp_str.indexOf('\'') >= 0)
			{
				yer = temp_str.indexOf('\'');
				temp_str = temp_str.substr(0,yer) + '' + temp_str.substr(yer+1, temp_str.length-yer-1);
			}*/
			var row_j_new_=(j+1);
			if(j==-1) // Basket düzenlemelerinden sonra bu bloga girmesine gerek kalmadi. Kontrol amacli kaldirilmadi. eski hali if(j==0) seklindeydi.
			{
				if(document.form_basket.other_money_!=undefined && document.form_basket.other_money_.value!=undefined)
					document.form_basket.other_money_.name='other_money_' + row_j_new_;
				else
					document.form_basket.other_money_[0].name='other_money_' + row_j_new_;
			
				if(document.form_basket.order_currency!=undefined && document.form_basket.order_currency.value!=undefined)
					document.form_basket.order_currency.name='order_currency' + row_j_new_;
				else
					document.form_basket.order_currency[0].name='order_currency' + row_j_new_;
				
				if(document.form_basket.reserve_type!=undefined && document.form_basket.reserve_type.value!=undefined)
					document.form_basket.reserve_type.name ='reserve_type' + row_j_new_;
				else
					document.form_basket.reserve_type[0].name ='reserve_type' + row_j_new_;
			
				if(document.form_basket.basket_extra_info!=undefined && document.form_basket.basket_extra_info.value!=undefined)
					document.form_basket.basket_extra_info.name = 'basket_extra_info' + row_j_new_;
				else
					document.form_basket.basket_extra_info[0].name = 'basket_extra_info' + row_j_new_;
				
				if(document.form_basket.select_info_extra!=undefined && document.form_basket.select_info_extra.value!=undefined)
					document.form_basket.select_info_extra.name = 'select_info_extra' + row_j_new_;
				else
					document.form_basket.select_info_extra[0].name = 'select_info_extra' + row_j_new_;
			}
			else
			{
				document.form_basket.other_money_[j].name = 'other_money_' + row_j_new_;
				document.form_basket.order_currency[j].name = 'order_currency' + row_j_new_;
				document.form_basket.reserve_type[j].name = 'reserve_type' + row_j_new_;
				document.form_basket.basket_extra_info[j].name = 'basket_extra_info' + row_j_new_;
				document.form_basket.select_info_extra[j].name = 'select_info_extra' + row_j_new_;
			}
		}
	}
	else if(document.form_basket.product_name != undefined)
	{ 
		/*try{
			temp_str = document.form_basket.product_name[0].value;}
		catch(e){
			temp_str = document.form_basket.product_name.value;}
		while (temp_str.indexOf('\'') >= 0)
			{
			yer = temp_str.indexOf('\'');
			temp_str = temp_str.substr(0,yer) + '' + temp_str.substr(yer+1, temp_str.length-yer-1);
			}
		try{
			document.form_basket.product_name.value = temp_str;}
		catch(e){
			document.form_basket.product_name[0].value = temp_str;}*/
		if(document.form_basket.other_money_.name != undefined)
		{
			document.form_basket.other_money_.name = 'other_money_1';
		}
		else
		{
			document.form_basket.other_money_[0].name = 'other_money_1';
		}

/*		if(document.form_basket.order_currency.name != undefined)
			document.form_basket.order_currency.name = 'order_currency1';
		else
			document.form_basket.order_currency[0].name = 'order_currency';
		if(document.form_basket.reserve_type.name != undefined)
			document.form_basket.reserve_type.name = 'reserve_type1';
		else
			document.form_basket.reserve_type[0].name = 'reserve_type1';
		if(document.form_basket.basket_extra_info.name != undefined)
			document.form_basket.basket_extra_info.name = 'basket_extra_info1';
		else
			document.form_basket.basket_extra_info[0].name = 'basket_extra_info1';
		if(document.form_basket.select_info_extra.name != undefined)
			document.form_basket.select_info_extra.name = 'select_info_extra1';
		else
			document.form_basket.select_info_extra[0].name = 'select_info_extra1';
		*/
		try{
			document.form_basket.order_currency.name = 'order_currency1';}
		catch(e)
		{
			try
			{
				document.form_basket.order_currency[0].name = 'order_currency1';
			}
			catch(e)
			{
				document.form_basket.order_currency.name = 'order_currency1';
			}
		}
		try{
			document.form_basket.reserve_type.name = 'reserve_type1';}
		catch(e)
		{
			try
			{
				document.form_basket.reserve_type[0].name = 'reserve_type1';
			}
			catch(e)
			{
				document.form_basket.reserve_type.name = 'reserve_type1';
			}
		}
		try{
			document.form_basket.basket_extra_info.name = 'basket_extra_info1';}
		catch(e)
		{
			try
			{
				document.form_basket.basket_extra_info[0].name = 'basket_extra_info1';
			}
			catch(e)
			{
				document.form_basket.basket_extra_info.name = 'basket_extra_info1';
			}
		}
		try{
			document.form_basket.select_info_extra.name = 'select_info_extra1';}
		catch(e)
		{
			try
			{
				document.form_basket.select_info_extra[0].name = 'select_info_extra1';
			}
			catch(e)
			{
				document.form_basket.select_info_extra.name = 'select_info_extra1';
			}
		}
		try{
			<cfif session.ep.our_company_info.is_lot_no eq 1>//şirket akış parametrelerinde lot no zorunlu olsun seçili ise
				if(check_lotno('form_basket'))//işlem kategorisinde lot no zorunlu olsun seçili ise
				{
					get_prod_detail = wrk_safe_query('obj2_get_prod_name','dsn3',0,document.form_basket.stock_id.value);
					if(get_prod_detail.IS_LOT_NO == 1)//üründe lot no takibi yapılıyor seçili ise
					{
						if(document.form_basket.lot_no.value == '')
						{
							alert("<cf_get_lang dictionary_id='60050.Lütfen Satırda Lot No Seçiniz'> !");
							eval(wrk_button_enable);
							return false;	
						}	
					}		
				}
			</cfif>
		}
		catch(e)
		{}
	}
		//document.form_basket.row_unique_relation_id.value='';
	<cfif ListFindNoCase(display_list, "shelf_number")>
		if (document.form_basket.shelf_number.length != undefined && document.form_basket.shelf_number.length > 1)
			for (var tt=0; tt < document.form_basket.shelf_number.length; tt++)
			{
				if(document.form_basket.shelf_number_txt[tt].value == '')
					document.form_basket.shelf_number[tt].value = '';
			}
		else
		{
			try{
				if(document.form_basket.shelf_number_txt[0].value == '')
					document.form_basket.shelf_number[0].value = '';
				}
			catch(e){
				if(document.form_basket.shelf_number_txt.value == '')
					document.form_basket.shelf_number.value = '';
				}
		}
	</cfif>
	<cfif ListFindNoCase(display_list, "pbs_code")>
		if (document.form_basket.pbs_id.length != undefined && document.form_basket.pbs_id.length > 1)
			for (var tt=0; tt < document.form_basket.pbs_id.length; tt++)
			{
				if(document.form_basket.pbs_code[tt].value == '')
					document.form_basket.pbs_id[tt].value = '';
			}
		else
		{
			try{
				if(document.form_basket.pbs_code[0].value == '')
					document.form_basket.pbs_id[0].value = '';
				}
			catch(e){
				if(document.form_basket.pbs_code.value == '')
					document.form_basket.pbs_id.value = '';
				}
		}
	</cfif>
	<cfif listfind('form_copy_bill,form_add_bill,detail_invoice_sale,add_sale_invoice_from_order,form_add_bill_from_ship,form_add_bill_other,detail_invoice_other,form_add_bill_purchase,detail_invoice_purchase,form_copy_bill_purchase,add_purchase_invoice_from_order',fusebox.fuseaction)>
		form_basket.stopaj.value = filterNumBasket(form_basket.stopaj.value,price_round_number);
		form_basket.stopaj_yuzde.value = filterNumBasket(form_basket.stopaj_yuzde.value,2);
	</cfif>


	if(document.form_basket.product_id != undefined)
		renameFieldNameAll();
	<cfif ListFindNoCase(display_list, "is_parse")>
	/*asotiler hiddenlara atanır*/
	hidden_fields.innerHTML = '';
	for (var row_counter=1; row_counter <= rowCount; row_counter++)
		{
		flag=0;
		if (assortmentArray[row_counter] != undefined)
			for (var counter2=1; counter2 <= assortmentArray[row_counter].length; counter2++)
				if (assortmentArray[row_counter][counter2] != undefined)
					{
					hidden_fields.innerHTML += '<input type="hidden" id="assortment_'+row_counter+'_'+counter2+'_1" name="assortment_'+row_counter+'_'+counter2+'_1" value="'+assortmentArray[row_counter][counter2][1]+'">'; /*property1*/
					hidden_fields.innerHTML += '<input type="hidden" id="assortment_'+row_counter+'_'+counter2+'_2" name="assortment_'+row_counter+'_'+counter2+'_2" value="'+assortmentArray[row_counter][counter2][2]+'">'; /* property2*/
					hidden_fields.innerHTML += '<input type="hidden" id="assortment_'+row_counter+'_'+counter2+'_3" name="assortment_'+row_counter+'_'+counter2+'_3" value="'+assortmentArray[row_counter][counter2][3]+'">'; /* amount*/
					flag++;
					}
		if (flag)
			hidden_fields.innerHTML += '<input type="hidden" id="assortment_'+row_counter+'_count" name="assortment_'+row_counter+'_count" value="'+flag+'">'; /*property1*/
		}
	/* asotiler hiddenlara atanır*/
	</cfif>
	/* vergiler hiddenlara atanır*/
	hidden_fields.innerHTML += '<input type="hidden" id="basket_tax_count" name="basket_tax_count" value="'+taxArray.length+'">';
	
	
	if (taxArray.length != 0)
	{
		<cfif listfind('invoice,',fusebox.circuit,',') or listfind("1,2,18,20,33,42,43",attributes.basket_id,",")>
		if(document.getElementById('tevkifat_oran')!=undefined && document.form_basket.tevkifat_oran.value.length && document.form_basket.tevkifat_oran.value!="")
		{
			var tev_oran = parseFloat(filterNumBasket(document.form_basket.tevkifat_oran.value,8));
			document.form_basket.tevkifat_oran.value = tev_oran;
		}
		</cfif>
		var taxArraylen= taxArray.length;
		for (var taxi=0; taxi < taxArraylen; taxi++)
		{ 
		hidden_fields.innerHTML += '<input type="hidden" id="basket_tax_'+(taxi+1)+'" name="basket_tax_'+(taxi+1)+'" value="'+taxArray[taxi]+'">';

		<cfif listfind('invoice,',fusebox.circuit,',') or listfind("1,2,18,20,33,42,43",attributes.basket_id,",")>
			if(document.getElementById('tevkifat_oran')!=undefined && form_basket.tevkifat_box.checked && form_basket.tevkifat_oran.value.length && form_basket.tevkifat_oran.value!="")
				{
				hidden_fields.innerHTML += '<input type="hidden" id="basket_tax_value_'+(taxi+1)+'" name="basket_tax_value_'+(taxi+1)+'" value="'+wrk_round(taxTotalArray[taxi]*tev_oran,price_round_number)+'">';
				hidden_fields.innerHTML += '<input type="hidden" id="tevkifat_tutar_'+(taxi+1)+'" name="tevkifat_tutar_'+(taxi+1)+'" value="'+wrk_round(taxTotalArray[taxi]-(taxTotalArray[taxi]*tev_oran),price_round_number)+'">';
				}
			else
				hidden_fields.innerHTML += '<input type="hidden" id="basket_tax_value_'+(taxi+1)+'" name="basket_tax_value_'+(taxi+1)+'" value="'+taxTotalArray[taxi]+'">';
		<cfelse>
			hidden_fields.innerHTML += '<input type="hidden" id="basket_tax_value_'+(taxi+1)+'" name="basket_tax_value_'+(taxi+1)+'" value="'+taxTotalArray[taxi]+'">';
		</cfif>
		}
	}
	/* vergiler hiddenlara atanır*/
	/* otv degerleri hiddenlara atanır*/
	hidden_fields.innerHTML += '<input type="hidden" id="basket_otv_count" name="basket_otv_count" value="'+otvArray.length+'">';
	if (otvArray.length != 0)
	{ 	
		var otvArraylen= otvArray.length;
		for (var otv_count=0; otv_count < otvArraylen; otv_count++)
		{
			if(otvArray[otv_count] != '')
			{
				if(rowCount == 1)
					hidden_fields.innerHTML += '<input type="hidden" id="basket_otv_'+(otv_count+1)+'" name="basket_otv_'+(otv_count+1)+'" value="'+otvArray[otv_count]+'">';
				else
					hidden_fields.innerHTML += '<input type="hidden" id="basket_otv_'+(otv_count+1)+'" name="basket_otv_'+(otv_count+1)+'" value="'+filterNumBasket(otvArray[otv_count])+'">';
			}
			else
				hidden_fields.innerHTML += '<input type="hidden" id="basket_otv_'+(otv_count+1)+'" name="basket_otv_'+(otv_count+1)+'" value="'+otvArray[otv_count]+'">';
			hidden_fields.innerHTML += '<input type="hidden" id="basket_otv_value_'+(otv_count+1)+'" name="basket_otv_value_'+(otv_count+1)+'" value="'+otvTotalArray[otv_count]+'">';
		}
	}
	/* otv degerleri hiddenlara atanır*/
	<cfif ListFindNoCase(display_list, "deliver_dept_assortment")>	
	for (var row_counter=1; row_counter <= rowCount; row_counter++)
	{
		flag=0;
		if (departmentArray[row_counter] != undefined){
			for(counter2 = 1 ; counter2 <= departmentArray[row_counter].length ; counter2++ )
				if (departmentArray[row_counter] != undefined)
					{
						try{
							hidden_fields.innerHTML += '<input type="hidden" id="department_'+row_counter+'_'+counter2+'_1" name="department_'+row_counter+'_'+counter2+'_1" value="'+departmentArray[row_counter][counter2][0]+'">'; /*amount*/
							hidden_fields.innerHTML += '<input type="hidden" id="department_'+row_counter+'_'+counter2+'_2" name="department_'+row_counter+'_'+counter2+'_2" value="'+departmentArray[row_counter][counter2][1]+'">'; /*department*/
							hidden_fields.innerHTML += '<input type="hidden" id="department_'+row_counter+'_'+counter2+'_3" name="department_'+row_counter+'_'+counter2+'_3" value="'+departmentArray[row_counter][counter2][2]+'">'; /* location*/
							flag++;
						}
						catch(e){}
					}
		}
		if (flag)
			hidden_fields.innerHTML += '<input type="hidden" id="department_'+row_counter+'_count" name="department_'+row_counter+'_count" value="'+flag+'">'; 
	}
	</cfif>	
	<cfif listfind("1,20,42,43",attributes.basket_id,",")>
		form_basket.yuvarlama.value= filterNumBasket(form_basket.yuvarlama.value,price_round_number);
	</cfif>
	<cfif not (browserDetect() contains 'MSIE')>
		<cfif ListFindNoCase(display_list, "is_parse")>
		for (var row_counter=1; row_counter <= rowCount; row_counter++)
			{
			flag=0;
			if (assortmentArray[row_counter] != undefined)
				for (var counter2=1; counter2 <= assortmentArray[row_counter].length; counter2++)
					if (assortmentArray[row_counter][counter2] != undefined)
						{
						ddd = row_counter+1;
						document.form_basket.appendChild(eval('document.form_basket.assortment_"+row_counter+"_"+counter2+"_1' + ddd));
						document.form_basket.appendChild(eval('document.form_basket.assortment_"+row_counter+"_"+counter2+"_1' + ddd));
						document.form_basket.appendChild(eval('document.form_basket.assortment_"+row_counter+"_"+counter2+"_1' + ddd));
					
						flag++;
						}
			if (flag)
				hidden_fields.innerHTML += '<input type="hidden" id="assortment_'+row_counter+'_count" name="assortment_'+row_counter+'_count" value="'+flag+'">'; /*property1*/
			}
		/* asotiler hiddenlara atanır*/
		</cfif>
		<cfif CGI.HTTP_USER_AGENT contains 'Firefox'>
			control_browser = 'document.form_basket';
		<cfelse>
			control_browser = 'document.all';
		</cfif>
	
		document.form_basket.appendChild(document.form_basket.basket_tax_count);
		var taxArraylen= taxArray.length;
		for (var taxi=0; taxi < taxArraylen; taxi++)
		{ 		
			bbb = taxi+1;
			document.form_basket.appendChild(document.getElementById('basket_tax_' + bbb));
			<cfif listfind('invoice,',fusebox.circuit,',') or listfind("1,2,18,20,33,42,43",attributes.basket_id,",")>
				if(document.getElementById('tevkifat_oran')!=undefined && form_basket.tevkifat_box.checked && form_basket.tevkifat_oran.value.length && form_basket.tevkifat_oran.value!="")
					{		
					document.form_basket.appendChild(eval('document.form_basket.basket_tax_value_' + (taxi+1)));
					document.form_basket.appendChild(eval('document.form_basket.tevkifat_tutar_' + (taxi+1)));
					}
				else{			
					document.form_basket.appendChild(eval('document.form_basket.basket_tax_value_' + (taxi+1)));
					}
			<cfelse>
				document.form_basket.appendChild(eval('document.form_basket.basket_tax_value_' + (taxi+1)));
			</cfif>
		}
		
		document.form_basket.appendChild(document.form_basket.basket_otv_count);
		var otvArraylen= otvArray.length;
			for (var otv_count=0; otv_count < otvArraylen; otv_count++)
			{
				ccc = otv_count+1;
				document.form_basket.appendChild(eval('document.form_basket.basket_otv_' + ccc));
				document.form_basket.appendChild(eval('document.form_basket.basket_otv_value_' + ccc));
			}		

		<cfif ListFindNoCase(display_list, "deliver_dept_assortment")>	
		for (var row_counter=1; row_counter <= rowCount; row_counter++)
		{
			flag=0;
			if (departmentArray[row_counter] != undefined){
				for(counter2 = 1 ; counter2 <= departmentArray[row_counter].length ; counter2++ )
					if (departmentArray[row_counter] != undefined)
						{
							try{
								ddd = row_counter+1;							
								document.form_basket.appendChild(eval('department_"+row_counter+"_"+counter2+"_1' + ddd));								
								document.form_basket.appendChild(eval('department_"+row_counter+"_"+counter2+"_2' + ddd));								
								document.form_basket.appendChild(eval('department_"+row_counter+"_"+counter2+"_3' + ddd));															
														
								flag++;
							}
							catch(e){}
						}
			}
			if (flag)
				hidden_fields.innerHTML += '<input type="hidden" id="department_'+row_counter+'_count" name="department_'+row_counter+'_count" value="'+flag+'">'; 
		}
		</cfif>			
		for (var row_app_=1; row_app_ <= rowCount; row_app_++)
		{			
			if(eval(control_browser+'product_id' + row_app_)!=undefined)
			{
				if(eval(control_browser+'other_money_' + row_app_)==undefined )
					document.form_basket.appendChild(eval(control_browser+'other_money_' + row_app_));
				if( eval(control_browser+'order_currency' + row_app_)==undefined )
					document.form_basket.appendChild(eval(control_browser+'order_currency' + row_app_));
				if( eval(control_browser+'reserve_type' + row_app_)==undefined )
					document.form_basket.appendChild(eval(control_browser+'reserve_type' + row_app_));
				if( eval(control_browser+'basket_extra_info' + row_app_)==undefined )
					document.form_basket.appendChild(eval(control_browser+'basket_extra_info' + row_app_));
				if( eval(control_browser+'select_info_extra' + row_app_)==undefined )
					document.form_basket.appendChild(eval(control_browser+'select_info_extra' + row_app_));
				if( eval(control_browser+'detail_info_extra' + row_app_)==undefined )
					document.form_basket.appendChild(eval(control_browser+'detail_info_extra' + row_app_));
				
				if( eval(control_browser+'row_catalog_id' + row_app_)==undefined )
					document.form_basket.appendChild(eval(control_browser+'row_catalog_id' + row_app_));
				if( eval(control_browser+'wrk_row_id' + row_app_)==undefined )
					document.form_basket.appendChild(eval(control_browser+'wrk_row_id' + row_app_));
				if( eval(control_browser+'wrk_row_relation_id' + row_app_)==undefined )
					document.form_basket.appendChild(eval(control_browser+'wrk_row_relation_id' + row_app_));
				if( eval(control_browser+'related_action_id' + row_app_)==undefined )
					document.form_basket.appendChild(eval(control_browser+'related_action_id' + row_app_));
				if( eval(control_browser+'related_action_table' + row_app_)==undefined )
					document.form_basket.appendChild(eval(control_browser+'related_action_table' + row_app_));
				if( eval(control_browser+'action_row_id' + row_app_)==undefined )
					document.form_basket.appendChild(eval(control_browser+'action_row_id' + row_app_));
				if( eval(control_browser+'product_id' + row_app_)==undefined )
					document.form_basket.appendChild(eval(control_browser+'product_id' + row_app_));
				if( eval(control_browser+'is_inventory' + row_app_)==undefined )
					document.form_basket.appendChild(eval(control_browser+'is_inventory' + row_app_));
				if( eval(control_browser+'is_production' + row_app_)==undefined )
					document.form_basket.appendChild(eval(control_browser+'is_production' + row_app_));
				if( eval(control_browser+'row_ship_id' + row_app_)==undefined )
					document.form_basket.appendChild(eval(control_browser+'row_ship_id' + row_app_));
				if( eval(control_browser+'stock_id' + row_app_)==undefined )
					document.form_basket.appendChild(eval(control_browser+'stock_id' + row_app_));
				if( eval(control_browser+'stock_code' + row_app_)==undefined )
					document.form_basket.appendChild(eval(control_browser+'stock_code' + row_app_));
				if( eval(control_browser+'special_code' + row_app_)==undefined )
					document.form_basket.appendChild(eval(control_browser+'special_code' + row_app_));
				if( eval(control_browser+'manufact_code' + row_app_)==undefined )
					document.form_basket.appendChild(eval(control_browser+'manufact_code' + row_app_));
				if( eval(control_browser+'row_unique_relation_id' + row_app_)==undefined )
					document.form_basket.appendChild(eval(control_browser+'row_unique_relation_id' + row_app_));
				if( eval(control_browser+'karma_product_id' + row_app_)==undefined )
					document.form_basket.appendChild(eval(control_browser+'karma_product_id' + row_app_));
				if( eval(control_browser+'row_service_id' + row_app_)==undefined )
					document.form_basket.appendChild(eval(control_browser+'row_service_id' + row_app_));
				if( eval(control_browser+'prom_relation_id' + row_app_)==undefined )
					document.form_basket.appendChild(eval(control_browser+'prom_relation_id' + row_app_));
				if( eval(control_browser+'barcod' + row_app_)==undefined )
					document.form_basket.appendChild(eval(control_browser+'barcod' + row_app_));
				if( eval(control_browser+'price_cat' + row_app_)==undefined )
					document.form_basket.appendChild(eval(control_browser+'price_cat' + row_app_));
				if( eval(control_browser+'product_name_other' + row_app_)==undefined )
					document.form_basket.appendChild(eval(control_browser+'product_name_other' + row_app_));
				if( eval(control_browser+'row_promotion_id' + row_app_)==undefined )
					document.form_basket.appendChild(eval(control_browser+'row_promotion_id' + row_app_));
				if( eval(control_browser+'is_promotion' + row_app_)==undefined )
					document.form_basket.appendChild(eval(control_browser+'is_promotion' + row_app_));
				if( eval(control_browser+'unit_other' + row_app_)==undefined )
					document.form_basket.appendChild(eval(control_browser+'unit_other' + row_app_));
				if( eval(control_browser+'ek_tutar_total' + row_app_)==undefined )
					document.form_basket.appendChild(eval(control_browser+'ek_tutar_total' + row_app_));
				if( eval(control_browser+'shelf_number' + row_app_)==undefined )
					document.form_basket.appendChild(eval(control_browser+'shelf_number' + row_app_));
				if( eval(control_browser+'shelf_number_txt' + row_app_)==undefined )
					document.form_basket.appendChild(eval(control_browser+'shelf_number_txt' + row_app_));
				if( eval(control_browser+'to_shelf_number' + row_app_)==undefined )
					document.form_basket.appendChild(eval(control_browser+'to_shelf_number' + row_app_));
				if( eval(control_browser+'to_shelf_number_txt' + row_app_)==undefined )
					document.form_basket.appendChild(eval(control_browser+'to_shelf_number_txt' + row_app_));
				if( eval(control_browser+'pbs_id' + row_app_)==undefined )
					document.form_basket.appendChild(eval(control_browser+'pbs_id' + row_app_));
				if( eval(control_browser+'pbs_code' + row_app_)==undefined )
					document.form_basket.appendChild(eval(control_browser+'pbs_code' + row_app_));
				if( eval(control_browser+'basket_employee' + row_app_)==undefined )
					document.form_basket.appendChild(eval(control_browser+'basket_employee' + row_app_));
				if( eval(control_browser+'basket_employee_id' + row_app_)==undefined )
					document.form_basket.appendChild(eval(control_browser+'basket_employee_id' + row_app_));
				if( eval(control_browser+'product_name' + row_app_)==undefined )
					document.form_basket.appendChild(eval(control_browser+'product_name' + row_app_));
				if( eval(control_browser+'unit_id' + row_app_)==undefined )
					document.form_basket.appendChild(eval(control_browser+'unit_id' + row_app_));
				if( eval(control_browser+'unit' + row_app_)==undefined )
					document.form_basket.appendChild(eval(control_browser+'unit' + row_app_));
				if( eval(control_browser+'spect_id' + row_app_)==undefined )
					document.form_basket.appendChild(eval(control_browser+'spect_id' + row_app_));
				if( eval(control_browser+'spect_name' + row_app_)==undefined )
					document.form_basket.appendChild(eval(control_browser+'spect_name' + row_app_));
				if( eval(control_browser+'duedate' + row_app_)==undefined )
					document.form_basket.appendChild(eval(control_browser+'duedate' + row_app_));
				if( eval(control_browser+'number_of_installment' + row_app_)==undefined )
					document.form_basket.appendChild(eval(control_browser+'number_of_installment' + row_app_));
				if( eval(control_browser+'deliver_date' + row_app_)==undefined )
					document.form_basket.appendChild(eval(control_browser+'deliver_date' + row_app_));
				if( eval(control_browser+'reserve_date' + row_app_)==undefined )
					document.form_basket.appendChild(eval(control_browser+'reserve_date' + row_app_));
				if( eval(control_browser+'deliver_dept' + row_app_)==undefined )
					document.form_basket.appendChild(eval(control_browser+'deliver_dept' + row_app_));
				if( eval(control_browser+'basket_row_departman' + row_app_)==undefined )
					document.form_basket.appendChild(eval(control_browser+'basket_row_departman' + row_app_));
				if( eval(control_browser+'lot_no' + row_app_)==undefined )
					document.form_basket.appendChild(eval(control_browser+'lot_no' + row_app_));
				if( eval(control_browser+'indirim1' + row_app_)==undefined )
					document.form_basket.appendChild(eval(control_browser+'indirim1' + row_app_));
				if( eval(control_browser+'indirim2' + row_app_)==undefined )
					document.form_basket.appendChild(eval(control_browser+'indirim2' + row_app_));
				if( eval(control_browser+'indirim3' + row_app_)==undefined )
					document.form_basket.appendChild(eval(control_browser+'indirim3' + row_app_));
				if( eval(control_browser+'indirim4' + row_app_)==undefined )
					document.form_basket.appendChild(eval(control_browser+'indirim4' + row_app_));
				if( eval(control_browser+'indirim5' + row_app_)==undefined )
					document.form_basket.appendChild(eval(control_browser+'indirim5' + row_app_));
				if( eval(control_browser+'indirim6' + row_app_)==undefined )
					document.form_basket.appendChild(eval(control_browser+'indirim6' + row_app_));
				if( eval(control_browser+'indirim7' + row_app_)==undefined )
					document.form_basket.appendChild(eval(control_browser+'indirim7' + row_app_));
				if( eval(control_browser+'indirim8' + row_app_)==undefined )
					document.form_basket.appendChild(eval(control_browser+'indirim8' + row_app_));
				if( eval(control_browser+'indirim9' + row_app_)==undefined )
					document.form_basket.appendChild(eval(control_browser+'indirim9' + row_app_));
				if( eval(control_browser+'indirim10' + row_app_)==undefined )
					document.form_basket.appendChild(eval(control_browser+'indirim10' + row_app_));
				if( eval(control_browser+'amount_other' + row_app_)==undefined )
					document.form_basket.appendChild(eval(control_browser+'amount_other' + row_app_));
				if( eval(control_browser+'ek_tutar_other_total' + row_app_)==undefined )
					document.form_basket.appendChild(eval(control_browser+'ek_tutar_other_total' + row_app_));
				if( eval(control_browser+'ek_tutar' + row_app_)==undefined )
					document.form_basket.appendChild(eval(control_browser+'ek_tutar' + row_app_));
				if( eval(control_browser+'ek_tutar_price' + row_app_)==undefined )
					document.form_basket.appendChild(eval(control_browser+'ek_tutar_price' + row_app_));
				if( eval(control_browser+'ek_tutar_cost' + row_app_)==undefined )
					document.form_basket.appendChild(eval(control_browser+'ek_tutar_cost' + row_app_));
				if( eval(control_browser+'ek_tutar_marj' + row_app_)==undefined )
					document.form_basket.appendChild(eval(control_browser+'ek_tutar_marj' + row_app_));
				if( eval(control_browser+'amount' + row_app_)==undefined )
					document.form_basket.appendChild(eval(control_browser+'amount' + row_app_));
				if( eval(control_browser+'list_price' + row_app_)==undefined )
					document.form_basket.appendChild(eval(control_browser+'list_price' + row_app_));
				if( eval(control_browser+'list_price_discount' + row_app_)==undefined )
					document.form_basket.appendChild(eval(control_browser+'list_price_discount' + row_app_));
				if( eval(control_browser+'price' + row_app_)==undefined )
					document.form_basket.appendChild(eval(control_browser+'price' + row_app_));
				if( eval(control_browser+'price_other' + row_app_)==undefined )
					document.form_basket.appendChild(eval(control_browser+'price_other' + row_app_));
				if( eval(control_browser+'price_net' + row_app_)==undefined )
					document.form_basket.appendChild(eval(control_browser+'price_net' + row_app_));
				if( eval(control_browser+'price_net_doviz' + row_app_)==undefined )
					document.form_basket.appendChild(eval(control_browser+'price_net_doviz' + row_app_));
				if( eval(control_browser+'tax' + row_app_)==undefined )
					document.form_basket.appendChild(eval(control_browser+'tax' + row_app_));
				if( eval(control_browser+'otv_oran' + row_app_)==undefined )
					document.form_basket.appendChild(eval(control_browser+'otv_oran' + row_app_));
				if( eval(control_browser+'row_total' + row_app_)==undefined )
					document.form_basket.appendChild(eval(control_browser+'row_total' + row_app_));
				if( eval(control_browser+'row_nettotal' + row_app_)==undefined )
					document.form_basket.appendChild(eval(control_browser+'row_nettotal' + row_app_));
				if( eval(control_browser+'row_taxtotal' + row_app_)==undefined )
					document.form_basket.appendChild(eval(control_browser+'row_taxtotal' + row_app_));
				if( eval(control_browser+'tax_price' + row_app_)==undefined )
					document.form_basket.appendChild(eval(control_browser+'tax_price' + row_app_));
				if( eval(control_browser+'row_otvtotal' + row_app_)==undefined )
					document.form_basket.appendChild(eval(control_browser+'row_otvtotal' + row_app_));
				if( eval(control_browser+'row_lasttotal' + row_app_)==undefined )
					document.form_basket.appendChild(eval(control_browser+'row_lasttotal' + row_app_));
				if( eval(control_browser+'other_money_value_' + row_app_)==undefined )
					document.form_basket.appendChild(eval(control_browser+'other_money_value_' + row_app_));
				if( eval(control_browser+'other_money_gross_total' + row_app_)==undefined )
					document.form_basket.appendChild(eval(control_browser+'other_money_gross_total' + row_app_));
				if( eval(control_browser+'net_maliyet' + row_app_)==undefined )
					document.form_basket.appendChild(eval(control_browser+'net_maliyet' + row_app_));
				if( eval(control_browser+'marj' + row_app_)==undefined )
					document.form_basket.appendChild(eval(control_browser+'marj' + row_app_));
				if( eval(control_browser+'darali' + row_app_)==undefined )
					document.form_basket.appendChild(eval(control_browser+'darali' + row_app_));
				if( eval(control_browser+'dara' + row_app_)==undefined )
					document.form_basket.appendChild(eval(control_browser+'dara' + row_app_));
				if( eval(control_browser+'extra_cost' + row_app_)==undefined )
					document.form_basket.appendChild(eval(control_browser+'extra_cost' + row_app_));
				if( eval(control_browser+'promosyon_yuzde' + row_app_)==undefined )
					document.form_basket.appendChild(eval(control_browser+'promosyon_yuzde' + row_app_));
				if( eval(control_browser+'promosyon_maliyet' + row_app_)==undefined )
					document.form_basket.appendChild(eval(control_browser+'promosyon_maliyet' + row_app_));
				if( eval(control_browser+'iskonto_tutar' + row_app_)==undefined )
					document.form_basket.appendChild(eval(control_browser+'iskonto_tutar' + row_app_));
				if( eval(control_browser+'is_commission' + row_app_)==undefined )
					document.form_basket.appendChild(eval(control_browser+'is_commission' + row_app_));
				if( eval(control_browser+'prom_stock_id' + row_app_)==undefined )
					document.form_basket.appendChild(eval(control_browser+'prom_stock_id' + row_app_));
				if( eval(control_browser+'row_width' + row_app_)==undefined )
					document.form_basket.appendChild(eval(control_browser+'row_width' + row_app_));
				if( eval(control_browser+'row_depth' + row_app_)==undefined )
					document.form_basket.appendChild(eval(control_browser+'row_depth' + row_app_));
				if( eval(control_browser+'row_height' + row_app_)==undefined )
					document.form_basket.appendChild(eval(control_browser+'row_height' + row_app_));
				if( eval(control_browser+'row_project_id' + row_app_)==undefined )
					document.form_basket.appendChild(eval(control_browser+'row_project_id' + row_app_));
				if( eval(control_browser+'row_project_name' + row_app_)==undefined )
					document.form_basket.appendChild(eval(control_browser+'row_project_name' + row_app_));
				if( eval(control_browser+'row_work_id' + row_app_)==undefined )
					document.form_basket.appendChild(eval(control_browser+'row_work_id' + row_app_));
				if( eval(control_browser+'row_work_name' + row_app_)==undefined )
					document.form_basket.appendChild(eval(control_browser+'row_work_name' + row_app_));
				if( eval(control_browser+'row_exp_center_id' + row_app_)==undefined )
					document.form_basket.appendChild(eval(control_browser+'row_exp_center_id' + row_app_));
				if( eval(control_browser+'row_exp_center_name' + row_app_)==undefined )
					document.form_basket.appendChild(eval(control_browser+'row_exp_center_name' + row_app_));
				if( eval(control_browser+'row_exp_item_id' + row_app_)==undefined )
					document.form_basket.appendChild(eval(control_browser+'row_exp_item_id' + row_app_));
				if( eval(control_browser+'row_exp_item_name' + row_app_)==undefined )
					document.form_basket.appendChild(eval(control_browser+'row_exp_item_name' + row_app_));
				if( eval(control_browser+'row_acc_code' + row_app_)==undefined )
					document.form_basket.appendChild(eval(control_browser+'row_acc_code' + row_app_));
			}
		}
	</cfif>

	return true;
	}
	else return false;
}

<cfif ListFindNoCase(display_list, "is_parse")>
function asorti_doldur(row_id,s1,s2,new_temp_row)
{
	counter = 1;
	assortmentArray[row_id] = new Array(1);
	for (var i=1;i <= s1; i++)
		for (var j=1;j <= s2; j++)
			{
			assortmentArray[row_id][counter] = new Array(4);
			assortmentArray[row_id][counter][0] = 0;
			assortmentArray[row_id][counter][1] = new_temp_row[counter][1];
			assortmentArray[row_id][counter][2] = new_temp_row[counter][2];
			assortmentArray[row_id][counter][3] = new_temp_row[counter][3];
			counter++;
			}
	return false;
}
</cfif>
<cfif ListFindNoCase(display_list, "deliver_dept_assortment")>	
function departman_urun_doldur(row_id,s1,new_temp_row)
{
	counter = 1;
	departmentArray[row_id] = new Array(1);
	for (var i=1 ; i <= s1 ; i++){
		departmentArray[row_id][counter] = new Array(1);
		departmentArray[row_id][counter][0] = filterNumBasket(new_temp_row[counter][0],3);
		departmentArray[row_id][counter][1] = new_temp_row[counter][1];
		departmentArray[row_id][counter][2] = new_temp_row[counter][2];
		counter++;
	}
	/*return false;*/
}
function get_stock_id(row_index)
{
	if(rowCount==1)
		return document.form_basket.stock_id.value;
	else
		return document.form_basket.stock_id[row_index-1].value;
}
</cfif>
</script>
