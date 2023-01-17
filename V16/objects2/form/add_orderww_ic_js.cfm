function change_cargo_info(ship_method)
{
	clear_cargo_row();
	// city_ = '0';
    var city_ = '';
	var ship_method_ = ship_method;
	toplam_desi_ = document.getElementById('toplam_desi').value;
    if(document.getElementById('is_same_tax_ship') != undefined && document.getElementById('is_same_tax_ship').checked == true)
	{
    	var radioLength = document.list_basketww.tax_address_row.length;
		if(radioLength == undefined)
		{
			if(document.getElementById('is_new_tax_address').value == 1)
			{
            	if(document.getElementById('tax_address_row') != undefined)
                {
                    if(document.getElemenetById('tax_address_row').checked)
					{
						if(document.getElementById('tax_address_city0').value!='')
							city_ = document.getElementById('tax_address_city0').value;
					}
					else
					{
						if(eval("document.getElementById('tax_address_city-1')").value != '')
							city_ = eval("document.getElementById('tax_address_city-1')").value;			
					}
                }
				else
					city_ = document.getElementById('tax_address_city0').value;
			}
            else
            {
             	if(document.getElementById('tax_address_city-1').value!='')
                	city_ = document.getElementById('tax_address_city-1').value;
            	/* if(document.getElementById('tax_address_row') != undefined)
					if(document.getElementById('tax_address_row').checked)
                    {
                        if(document.getElementById('tax_address_city1').value!='')
                            city_ = document.getElementById('tax_address_city1').value;
                    }
				else
					city_ = document.getElementById('tax_address_city1').value; */
			}
		}
		else
		{
			for(var i = 0; i < radioLength; i++) 
			{
				if(document.list_basketww.tax_address_row[i].checked)
				{
					x = document.list_basketww.tax_address_row[i].value;
					if(eval("document.getElementById('tax_address_city" + x + "')").value!='')
						city_ = eval("document.getElementById('tax_address_city" + x + "')").value;
				}
			}
		}
	}
	else
	{
    	var radioLength = document.list_basketww.ship_address_row.length;
		if(radioLength == undefined)
		{
			if(document.getElementById('is_new_ship_address').value == 1)
			{
            	if(document.getElementById('ship_address_row') != undefined)
					if(document.getElementById('ship_address_row').checked)
                    {
                        if(document.getElementById('ship_address_city0').value!='')
                            city_ = document.getElementById('ship_address_city0').value;
                    }
				else
					city_ = document.getElementById('ship_address_city0').value;
			}
            else
            {
            	if(document.getElementById('ship_address_row') != undefined)
					if(document.getElementById('ship_address_row').checked)
						{
							if(document.getElementById('ship_address_city1').value!='')
								city_ = document.getElementById('ship_address_city1').value;
						}
				else
					city_ = document.getElementById('ship_address_city1').value;
			}
		}
		else
		{
			for(var i = 0; i < radioLength; i++) 
			{
				if(document.list_basketww.ship_address_row[i].checked)
				{
					x = document.list_basketww.ship_address_row[i].value;
					if(eval("document.getElementById('ship_address_city" + x + "')").value!='')
						city_ = eval("document.getElementById('ship_address_city" + x + "')").value;
				}
			}
		}
	}

	if(city_.length==0) // sehir yoksa kargo hesaplama yok.
	{
    	if(document.getElementById('is_cargo_city').value == 1)
        {
            alert('Bulunduğunuz Şehri Seçmelisiniz!');		
            if(document.list_basketww.ship_method_id.disabled == false)
                document.list_basketww.ship_method_id.value = '';
            kargo_info_td.innerHTML = '';
            kargo_info_tr.style.display = 'none';
            gizle(sevkiyat_info);
            gizle(sevkiyat_devam);
            goster(teslimat_info);
            goster(teslimat_devam);
            return false;
        }
	}    
	else // sehir varsa kargoya bakar
	{
		kargo_info_tr.style.display = '';
		if(city_ == '') city_ = 0;
		if(ship_method_ == '') ship_method_ = 0;
		if(toplam_desi_ == '') toplam_desi_ = 0;
        var listParam = city_ + "*" + ship_method_ + "*" + toplam_desi_;
		var get_cargos = wrk_safe_query("obj2_get_cargo_type_3","dsn","10",listParam);
        
        <cfif browserdetect() contains 'Firefox' or browserdetect() contains 'Safari' or browserdetect() contains 'Chrome' or browserdetect() contains 'iPhone'>
            if(get_cargos.recordcount)
            {
				document.getElementById('cargo_kontrol').value = '0';
                document.getElementById('kargo_info_td').innerHTML = '<table><tr><td>';
                for(i=0;i < get_cargos.recordcount;i++)
                {
                    if(document.getElementById('cargo_product_id') != undefined && get_cargos.PRODUCT_ID == document.getElementById('cargo_product_id').value)
                        document.getElementById('kargo_info_td').innerHTML += '<input type="radio" name="sevk_type" id="sevk_type" value="1" onclick=cargo_ekle("' + document.getElementById('cargo_product_price').value + '","' + get_cargos.PRODUCT_ID[i] + '","' + get_cargos.OTHER_MONEY[i] + '"' + ') checked="checked">';
                    else
                        document.getElementById('kargo_info_td').innerHTML += '<input type="radio" name="sevk_type" id="sevk_type" value="1" onclick=cargo_ekle("' + get_cargos.CUSTOMER_PRICE[i] + '","' + get_cargos.PRODUCT_ID[i] + '","' + get_cargos.OTHER_MONEY[i] + '"' + ') checked="checked">';                        

					if(get_cargos.PICTURE[i] != '')
                    	document.getElementById('kargo_info_td').innerHTML += '<img src="/documents/settings/'+get_cargos.PICTURE[i]+'" style="height:30px;vertical-align:middle;"/>&nbsp;&nbsp;';
                    document.getElementById('kargo_info_td').innerHTML += get_cargos.NICKNAME[i];
                    if(get_cargos.PRICE[i] != get_cargos.CUSTOMER_PRICE[i])
                        document.getElementById('kargo_info_td').innerHTML += ' - ' + '<strike>' + get_cargos.PRICE[i] + ' ' +  get_cargos.OTHER_MONEY[i] + ' + KDV </strike> <b>' + get_cargos.CUSTOMER_PRICE[i] + ' ' + get_cargos.OTHER_MONEY[i] + ' + KDV</b>';
                    else
                        document.getElementById('kargo_info_td').innerHTML += ' - ' + get_cargos.CUSTOMER_PRICE[i] + ' ' + get_cargos.OTHER_MONEY[i] + ' + KDV</b>';
                    document.getElementById('kargo_info_td').innerHTML += '<br/>';					
                }
           
                if(get_cargos.recordcount==1)
                {
                    document.getElementById('sevk_type').checked = true;
                    if(document.getElementById('cargo_product_id') != undefined && get_cargos.PRODUCT_ID == document.getElementById('cargo_product_id').value)
                        cargo_ekle(document.getElementById('cargo_product_price').value,get_cargos.PRODUCT_ID,get_cargos.OTHER_MONEY);
                    else
                        cargo_ekle(get_cargos.CUSTOMER_PRICE,get_cargos.PRODUCT_ID,get_cargos.OTHER_MONEY);
                }
                else
                {
                    document.list_basketww.sevk_type[0].checked = true;
                    if(document.getElementById('cargo_product_id') != undefined && get_cargos.PRODUCT_ID[0] == document.getElementById('cargo_product_id').value)
                        cargo_ekle(document.getElementById('cargo_product_price').value,get_cargos.PRODUCT_ID[0],get_cargos.OTHER_MONEY[0]);
                    else
                        cargo_ekle(get_cargos.CUSTOMER_PRICE[0],get_cargos.PRODUCT_ID[0],get_cargos.OTHER_MONEY[0]);
                }
                    
                document.getElementById('kargo_info_td').innerHTML += '</td></tr></table>';
            }
            else
            {
 				if(ship_method_ == '') ship_method_ = 0;
                var lisParam = city_ + "*" + ship_method_ + "*" + toplam_desi_;
                var get_cargo_type = wrk_safe_query("obj2_get_cargo_type","dsn","1",listParam);
                if(get_cargo_type.recordcount)
               	{
                    var listParam = city_ + "*" + toplam_desi_ + "*" + get_cargo_type.SHIP_METHOD_PRICE_ID;
                    var get_cargos2 = wrk_safe_query("obj2_get_cargos_2","dsn","1",listParam);
                    if(get_cargos2.recordcount)
                    {
                        document.getElementById('cargo_kontrol').value = '0';

                        kargo_info_td.innerHTML = '<table><tr><td>';
                        for(i=0;i < get_cargos2.recordcount;i++)
                        {
                            kargo_tutar_ = wrk_round(parseFloat(get_cargo_type.CUSTOMER_PRICE) + (get_cargos2.PRICE * (toplam_desi_ - get_cargos2.MAX_LIMIT)));
                            if(document.getElementById('cargo_product_id') != undefined && get_cargos2.PRODUCT_ID[0] == document.getElementById('cargo_product_id').value)
                                kargo_info_td.innerHTML += '<input type="radio" name="sevk_type" id="sevk_type" value="1" onclick=cargo_ekle("' + document.getElementById('cargo_product_price').value + '","' + get_cargos2.PRODUCT_ID[i] + '","' + get_cargos2.OTHER_MONEY[i] + '"' + ') checked="checked">';
                            else
                                kargo_info_td.innerHTML += '<input type="radio" name="sevk_type" id="sevk_type" value="1" onclick=cargo_ekle("' + kargo_tutar_ + '","' + get_cargos2.PRODUCT_ID[i] + '","' + get_cargos2.OTHER_MONEY[i] + '"' + ') checked="checked">';
                            if(get_cargos2.PICTURE[i] != '')
                            	kargo_info_td.innerHTML += '<img src="/documents/settings/'+get_cargos2.PICTURE[i]+'" height="30" width="60" style="vertical-align:middle;"/>&nbsp;&nbsp;';
                            kargo_info_td.innerHTML += get_cargos2.NICKNAME[i];
                            kargo_info_td.innerHTML += ' - ' + '<b>' + kargo_tutar_ + ' ' + get_cargos2.OTHER_MONEY[i] + ' + KDV</b>';
                            kargo_info_td.innerHTML += '<br/>';					
                            if(get_cargos2.recordcount==1)
                            {
                                document.getElementById('sevk_type').checked = true;
                                if(document.getElementById('cargo_product_id') != undefined && get_cargos2.PRODUCT_ID[0] == document.getElementById('cargo_product_id').value)
                                    cargo_ekle(document.getElementById('cargo_product_price').value,get_cargos2.PRODUCT_ID[0],get_cargos2.OTHER_MONEY[i]);
                                else
                                    cargo_ekle(kargo_tutar_,get_cargos2.PRODUCT_ID[0],get_cargos2.OTHER_MONEY[0]);
                            }
                            else
                            {
                                document.list_basketww.sevk_type[0].checked = true;
                                if(document.getElementById('cargo_product_id') != undefined && get_cargos2.PRODUCT_ID[i] == document.getElementById('cargo_product_id').value)
                                    cargo_ekle(document.getElementById('cargo_product_price').value,get_cargos2.PRODUCT_ID[i],get_cargos2.OTHER_MONEY[i]);
                                else
                                    cargo_ekle(kargo_tutar_,get_cargos2.PRODUCT_ID[i],get_cargos2.OTHER_MONEY[i]);
                            }
                        }
                    	kargo_info_td.innerHTML += '</td></tr></table>';
                    }
                    else
                    {
                        kargo_info_td.innerHTML = '';
                    }
                }
                else
                {
                    kargo_info_td.innerHTML = '';
                }
            }	
		<cfelse>
        	if(get_cargos.recordcount)
            {
                document.getElementById('cargo_kontrol').value = '0';
                kargo_info_td.innerHTML = '<table><tr><td>';
                for(i=0;i < get_cargos.recordcount;i++)
                {
                    if(document.getElementById('cargo_product_id') != undefined && get_cargos.PRODUCT_ID == document.getElementById('cargo_product_id').value)
                        kargo_info_td.innerHTML += '<input type="radio" name="sevk_type" id="sevk_type" value="1" onclick=cargo_ekle("' + document.getElementById('cargo_product_price').value + '","' + get_cargos.PRODUCT_ID[i] + '","' + get_cargos.OTHER_MONEY[i] + '"' + ') checked="checked">';
                    else
                        kargo_info_td.innerHTML += '<input type="radio" name="sevk_type" id="sevk_type" value="1" onclick=cargo_ekle("' + get_cargos.CUSTOMER_PRICE[i] + '","' + get_cargos.PRODUCT_ID[i] + '","' + get_cargos.OTHER_MONEY[i] + '"' + ') checked="checked">';                        
                    if(get_cargos.PICTURE[i] != '')
                    	kargo_info_td.innerHTML += '<img src="/documents/settings/'+get_cargos.PICTURE[i]+'" style="height:30px;vertical-align:middle;"/>&nbsp;&nbsp;';
                    
                    kargo_info_td.innerHTML += get_cargos.NICKNAME[i];
                    if(get_cargos.PRICE[i] != get_cargos.CUSTOMER_PRICE[i])
                        kargo_info_td.innerHTML += ' - ' + '<strike>' + get_cargos.PRICE[i] + ' ' +  get_cargos.OTHER_MONEY[i] + ' + KDV </strike> <b>' + get_cargos.CUSTOMER_PRICE[i] + ' ' + get_cargos.OTHER_MONEY[i] + ' + KDV</b>';
                    else
                        kargo_info_td.innerHTML += ' - ' + get_cargos.CUSTOMER_PRICE[i] + ' ' + get_cargos.OTHER_MONEY[i] + ' + KDV</b>';
                    kargo_info_td.innerHTML += '<br/>';					
                }
    
                if(get_cargos.recordcount==1)
                {
                    document.list_basketww.sevk_type.checked = true;
                    if(document.getElementById('cargo_product_id') != undefined && get_cargos.PRODUCT_ID == document.getElementById('cargo_product_id').value)
                        cargo_ekle(document.getElementById('cargo_product_price').value,get_cargos.PRODUCT_ID,get_cargos.OTHER_MONEY);
                    else
                        cargo_ekle(get_cargos.CUSTOMER_PRICE,get_cargos.PRODUCT_ID,get_cargos.OTHER_MONEY);
                }
                else
                {
                    document.list_basketww.sevk_type[0].checked = true;
                    if(document.getElementById('cargo_product_id') != undefined && get_cargos.PRODUCT_ID[0] == document.getElementById('cargo_product_id').value)
                        cargo_ekle(document.getElementById('cargo_product_price').value,get_cargos.PRODUCT_ID[0],get_cargos.OTHER_MONEY[0]);
                    else
                        cargo_ekle(get_cargos.CUSTOMER_PRICE[0],get_cargos.PRODUCT_ID[0],get_cargos.OTHER_MONEY[0]);
                }
                    
                kargo_info_td.innerHTML += '</td></tr></table>';
            }
            else
            {
                if(ship_method_ == '') ship_method_ = 0;
                var lisParam = city_ + "*" + ship_method_ + "*" + toplam_desi_;
                var get_cargo_type = wrk_safe_query("obj2_get_cargo_type","dsn","1",listParam);
                
                if(get_cargo_type.recordcount)
                {
                    var listParam = city_ + "*" + toplam_desi_ + "*" + get_cargo_type.SHIP_METHOD_PRICE_ID;
                    var get_cargos2 = wrk_safe_query("obj2_get_cargos_2","dsn","1",listParam);
                    if(get_cargos2.recordcount)
                    {
                        document.getElementById('cargo_kontrol').value = '0';
                        kargo_info_td.innerHTML = '<table><tr><td>';
                        for(i=0;i < get_cargos2.recordcount;i++)
                        {
                            kargo_tutar_ = wrk_round(parseFloat(get_cargo_type.CUSTOMER_PRICE) + (get_cargos2.PRICE * (toplam_desi_ - get_cargos2.MAX_LIMIT)));
                            if(document.getElementById('cargo_product_id') != undefined && get_cargos2.PRODUCT_ID[0] == document.getElementById('cargo_product_id').value)
                                kargo_info_td.innerHTML += '<input type="radio" name="sevk_type" id="sevk_type" value="1" onclick=cargo_ekle("' + document.getElementById('cargo_product_price').value + '","' + get_cargos2.PRODUCT_ID[i] + '","' + get_cargos2.OTHER_MONEY[i] + '"' + ') checked="checked">';
                            else
                                kargo_info_td.innerHTML += '<input type="radio" name="sevk_type" id="sevk_type" value="1" onclick=cargo_ekle("' + kargo_tutar_ + '","' + get_cargos2.PRODUCT_ID[i] + '","' + get_cargos2.OTHER_MONEY[i] + '"' + ') checked="checked">';
					
                    		if(get_cargos2.PICTURE[i] != '')
                            	kargo_info_td.innerHTML += '<img src="/documents/settings/'+get_cargos2.PICTURE[i]+'" height="30" width="60" style="vertical-align:middle;"/>&nbsp;&nbsp;';
                            kargo_info_td.innerHTML += get_cargos2.NICKNAME[i];
                            kargo_info_td.innerHTML += ' - ' + '<b>' + kargo_tutar_ + ' ' + get_cargos2.OTHER_MONEY[i] + ' + KDV</b>';
                            kargo_info_td.innerHTML += '<br/>';					
                            if(get_cargos2.recordcount==1)
                            {
                                document.getElementById('sevk_type').checked = true;
                                if(document.getElementById('cargo_product_id') != undefined && get_cargos.PRODUCT_ID[0] == document.getElementById('cargo_product_id').value)
                                    cargo_ekle(document.getElementById('cargo_product_price').value,get_cargos2.PRODUCT_ID[0],get_cargos2.OTHER_MONEY[i]);
                                else
                                    cargo_ekle(kargo_tutar_,get_cargos2.PRODUCT_ID[0],get_cargos2.OTHER_MONEY[0]);
                            }
                            else
                            {
                                document.list_basketww.sevk_type[0].checked = true;
                                document.getElementById('sevk_type').checked = true;
                                if(document.getElementById('cargo_product_id') != undefined && get_cargos2.PRODUCT_ID[i] == document.getElementById('cargo_product_id').value)
                                    cargo_ekle(document.getElementById('cargo_product_price').value,get_cargos2.PRODUCT_ID[i],get_cargos2.OTHER_MONEY[i]);
                                else
                                    cargo_ekle(kargo_tutar_,get_cargos2.PRODUCT_ID[i],get_cargos2.OTHER_MONEY[i]);
                            }
                        }
                        kargo_info_td.innerHTML += '</td></tr></table>';
                    }
                    else
                    {
                        kargo_info_td.innerHTML = '';
                    }
                }
                else
                {
                    kargo_info_td.innerHTML = '';
                }
            }
        </cfif>
    }	
}

function cargo_ekle(tutar,urun,gelen_money)
{
	document.getElementById('cargo_kontrol').value = '1';
	var get_comp_prod = wrk_safe_query("obj2_get_comp_prod_2",'dsn3','1',urun);
	document.getElementById('price_catid_2').value = -2;
	var aa_temp = wrk_round(tutar);
	var aa_temp_price_standard = wrk_round(tutar);
	document.getElementById('price').value = aa_temp;
	document.getElementById('price_old').value = '';
	document.getElementById('istenen_miktar').value = 1;
	document.getElementById('sid').value = get_comp_prod.STOCK_ID; 
	document.getElementById('price_kdv').value = wrk_round(aa_temp*(100 + parseFloat(get_comp_prod.TAX)) / 100);
	document.getElementById('price_money').value = gelen_money;
	document.getElementById('price_standard_money').value = gelen_money;
	document.getElementById('prom_id').value = '';
	document.getElementById('prom_discount').value = '';
	document.getElementById('prom_amount_discount').value = '';
	document.getElementById('prom_cost').value = '';
	document.getElementById('prom_free_stock_id').value = '';
	document.getElementById('prom_stock_amount').value = 1;
	document.getElementById('prom_free_stock_amount').value = 1;
	document.getElementById('prom_free_stock_price').value = 0;
	document.getElementById('prom_free_stock_money').value = '';
	document.getElementById('is_cargo').value = 1;
    document.getElementById('is_discount').value = 0;
	document.getElementById('is_commission').value = 0;
	//son kullanici
	document.getElementById('price_standard').value = wrk_round(aa_temp_price_standard*(100 + parseFloat(get_comp_prod.TAX)) / 100);
	document.getElementById('price_standard_kdv').value = aa_temp_price_standard;
	<cfif isdefined('attributes.order_from_basket_express') and attributes.order_from_basket_express eq 1>
		<cfoutput>
			document.getElementById('consumer_id').value = '#attributes.consumer_id#';
			document.getElementById('company_id').value = '#attributes.company_id#';
			document.getElementById('partner_id').value = '#attributes.partner_id#';
			document.getElementById('order_from_basket_express').value = 1;
		</cfoutput>
	</cfif>
	document.satir_gonder.action = '<cfoutput>#request.self#</cfoutput>?fuseaction=objects2.emptypopup_add_basketww_row';
	AjaxFormSubmit('satir_gonder','cargo_action_div',1,'','',sepet_adres_,'sale_basket_rows_list');
	clear_paymethod();
}

function get_payment_hesapla(type,paym_type_id)
{
    if(type==1)
        var new_sql_1 = 'obj2_get_comp_prod_3';
    else
        var new_sql_1 = 'obj2_get_comp_prod_4';
    
    return new_sql_1;
}
	
function pay_type_general(gelen_tip,limit_info)
{
	if(limit_info == 0)
	{
		var get_pay_mtd = wrk_safe_query("obj2_get_pay_mtd_2",'dsn3',0,gelen_tip);
		
		if(get_pay_mtd.recordcount && get_pay_mtd.POS_TYPE == 9 && get_pay_mtd.NUMBER_OF_INSTALMENT != '' && get_pay_mtd.NUMBER_OF_INSTALMENT > 0)
		{
			//pos type i alır,Yapıkredi taksitlide işlem olur sadece
			joker_info.style.display='';
			document.getElementById('joker_vada').checked = true;//joker vada seçili gelsin
		}
		else
		{
			joker_info.style.display='none';
			document.getElementById('joker_vada').checked = false;
		}
	}
	else
	{
   		var get_pay_mtd = wrk_safe_query("obj2_get_pay_mtd_2",'dsn3',0,gelen_tip);
		if( get_pay_mtd.POS_TYPE == 9 && get_pay_mtd.NUMBER_OF_INSTALMENT != '' && get_pay_mtd.NUMBER_OF_INSTALMENT > 0)
		{//pos type i alır,Yapıkredi taksitlide işlem olur sadece
			lim_joker_info.style.display='';
			document.getElementById('lim_joker_vada').checked = true;//joker vada seçili gelsin
		}
		else
		{
			lim_joker_info.style.display='none';
			document.getElementById('lim_joker_vada').checked = false;
		}
	}
	return true;
}

function urun_sil(satir_no)
{
	adres_ = '<cfoutput>#request.self#</cfoutput>?fuseaction=objects2.emptypopup_del_basketww_row&row_id='+satir_no;
	AjaxPageLoad(adres_,'sale_basket_rows_list','1','<cf_get_lang no="262.Ürün Siliniyor">!');
	
	if(document.getElementById('ship_method_id').disabled == false)
		document.getElementById('ship_method_id').value = '';
	
	if(document.getElementById('project_attachment') != undefined)
		document.getElementById('project_attachment').value = '';
	
	kargo_info_td.innerHTML = '';
	kargo_info_tr.style.display = 'none';
	clear_cargo_row();
	document.getElementById('cargo_kontrol').value = '1';
	alert('<cf_get_lang no="262.Ürün Siliniyor">'); 
	AjaxPageLoad(document.getElementById('sepet_adres').value,'sale_basket_rows_list','1','Loading...');
}
	
function urun_hesapla(order_no,satir_no,stock_id)
{
	deger_ = eval('document.getElementById("row_' + satir_no + '")').value;
	eski_deger_ = eval('document.getElementById("old_row_' + satir_no + '")').value;
	if(deger_=='')
		yeni_deger = 1;
	else
		yeni_deger = filterNum(deger_);
	
	hatam_ = 0;
	stock_id_ = stock_id;
	stock_amount_= yeni_deger;
	<cfif isdefined('attributes.is_control_zero_stock') and attributes.is_control_zero_stock eq 1>
        var listParam = stock_id_ + "*" + "<cfoutput>#dsn3_alias#</cfoutput>" + "*" + "<cfoutput>#dsn_alias#</cfoutput>";
        var get_total_stock_js = wrk_safe_query("obj2_get_total_stock_js",'dsn2',listParam);
    
        if(get_total_stock_js.recordcount)
        {
            var total_stock_ = parseInt(get_total_stock_js.PRODUCT_TOTAL_STOCK);
            if(total_stock_ < stock_amount_)
            {
            alert('Stok Miktarı Yeterli Değildir!Maksimum Miktarla Sepet Güncellenecektir.');
            yeni_deger = total_stock_;
            }
        }
        else
        {
            var get_total_stock2 = wrk_safe_query("obj2_get_total_stock2",'dsn3',0,stock_id_);
            if(get_total_stock2.recordcount && get_total_stock2.IS_PRODUCTION==0)
            {
            	hatam_ = 1;
            }
        }
	</cfif>
	if(hatam_==1)
	{
		alert('Bu Satır İçin Girdiğiniz Stok Miktarı Yeterli Değildir!');
		return false;
	}
		
	eval('document.getElementById("row_' + satir_no + '")').value = yeni_deger;
	
	if(yeni_deger != eski_deger_)
	{
		adres_ = '<cfoutput>#request.self#</cfoutput>?fuseaction=objects2.emptypopup_upd_basketww_row_one&row_id='+order_no+'&row_deger='+yeni_deger;
		AjaxPageLoad(adres_,'sale_basket_rows_list','1','Loading...');
		if(document.getElementById('ship_method_id').disabled == false)
			document.getElementById('ship_method_id').value = '';
		kargo_info_td.innerHTML = '';
		kargo_info_tr.style.display = 'none';
		clear_cargo_row();
		document.getElementById('cargo_kontrol').value = '1';	
	}
		
	if(document.getElementById('project_attachment') != undefined)
		document.getElementById('project_attachment').value = '';
	alert('Seçtiğiniz ürünün miktarı güncelleniyor!'); 
	AjaxPageLoad(document.getElementById('sepet_adres').value,'sale_basket_rows_list','1','Loading...');
}
	
function urun_checked_(satir_no_,deger_)
{
	if(deger_==0)
    	checked_ = 1;
    else
    	checked_ = 0;
	
    adres_ = '<cfoutput>#request.self#</cfoutput>?fuseaction=objects2.emptypopup_upd_basketww_row_checked&row_id='+satir_no_+'&row_deger='+checked_;
    AjaxPageLoad(adres_,'sale_basket_rows_list','1','Loading...');
    if(document.getElementById('ship_method_id').disabled == false)
        document.getElementById('ship_method_id').value = '';
		
    if(document.getElementById('project_attachment') != undefined)
		document.getElementById('project_attachment').value = '';
	
	kargo_info_td.innerHTML = '';
    kargo_info_tr.style.display = 'none';
    clear_cargo_row();
    document.getElementById('cargo_kontrol').value = '1';
	AjaxPageLoad(document.getElementById('sepet_adres').value,'sale_basket_rows_list','1','Loading...');
}
function check_project_discount(prj_id)
{
	//adres_ = '<cfoutput>#request.self#</cfoutput>?fuseaction=objects2.emptypopup_upd_basketww_row_discounts&prj_id='+prj_id;
	adres_ = document.getElementById('sepet_adres').value;
	document.getElementById('project_str').value='&prj_id='+prj_id;
	document.getElementById('project_id_new_').value=prj_id;
	adres_ += document.getElementById('project_str').value;
	var sepet_adres_ = adres_;
	AjaxPageLoad(adres_,'sale_basket_rows_list','1','Loading...');
	if(typeof(set_project_risk_limit)!=undefined) set_project_risk_limit();
}
function urunRowDetail(rowID,rowNumber,updType)
{
	if(rowID == '') rowID = 0;
	if(updType == 1)
	{
		xx = eval('document.getElementById("order_row_detail_'+rowNumber+'")').value;
        var listParam = xx + "*" + rowID;
		var orderRowDetailSql = "obj2_updOrderRowDetailSql";
	}
	else
	{
		xx = eval('document.getElementById("basket_info_type_id_'+rowNumber+'")').value;
        var listParam = xx + "*" + rowID;
		var orderRowDetailSql = "obj2_updOrderRowDetailSql_2";
	}		
	if(list_len(listParam,'*') == 2)	
    	var updOrderRowDetailSql = wrk_safe_query(orderRowDetailSql,'dsn3',0,listParam);
}
