<script type="text/javascript"> 
	function get_paymethod_div()
	{
		goster(paymethod_div);
		AjaxPageLoad(<cfoutput>'#request.self#</cfoutput>?fuseaction=pda.emptypopup_get_paymethod_div&keyword='+encodeURI(document.getElementById('paymethod').value),'paymethod_div');		
	}
	
	function add_paymethod_st(id,name,int_due,due_day,paymethod_vehicle,due_date_rate,due_month)
	{ 	//standart odeme yontemi bilgilerini gonderir ve tanımlıysa kredi kartı odeme yontemi inputlarını bosaltır 
		document.getElementById('paymethod_id').value=id;
		document.getElementById('paymethod').value=name;
		document.getElementById('paymethod_vehicle').value = paymethod_vehicle;
		document.getElementById('card_paymethod_id').value='';
		document.getElementById('commission_rate').value = '';
		gizle(paymethod_div);
	}

	
	function add_paymethod_cc(id,name,stock_id,product_id,rate)
	{ 	//kredi kartı odeme yontemi bilgilerini gonderir ve tanımlıysa standart odeme yontemi inputlarını bosaltır
		document.getElementById('card_paymethod_id').value=id;
		document.getElementById('paymethod').value=name;
		document.getElementById('commission_rate').value = rate;
		document.getElementById('paymethod_id').value='';
		document.getElementById('paymethod_vehicle').value = '';
		gizle(paymethod_div);
	}
	
	function get_company_all_div()
	{
		if(div_name == undefined) var div_name = "company_all_div"; // Bu Sekilde Kullanildigi Yerler Var Hepsi Duzenlendiginde Kullanilmiyorsa Kaldirilacak
		if(document.getElementById('member_name').value.length <= 2)
		{
			alert("Lütfen listelemek için en az 3 karakter giriniz !");
			return false;
		}
		goster(document.getElementById(div_name));
		AjaxPageLoad(<cfoutput>'#request.self#</cfoutput>?fuseaction=pda.emptypopup_get_company_div_purchase&ref_member_name='+ encodeURI(document.getElementById('member_name').value) +'&div_name='+div_name+'&is_my=1' + '&form_id=add_order',div_name);		
		return false;
	}
	function add_company_div(div_name,company_id,member_name,partner_name,partner_id,member_type,price_cat)
	{
		document.getElementById('company_id').value = company_id;
		document.getElementById('member_name').value = member_name;
		document.getElementById('partner_id').value = partner_id;
		document.getElementById('member_type').value = member_type;
		document.getElementById('price_cat_id').value = price_cat;
		gizle(document.getElementById(div_name));
	}
	function clear_barcode()
	{
		gizle(show_buttons);
		document.getElementById('search_product').value="";
		document.getElementById('search_product').focus();	
	}
	function stock_reserve(no)
	{
		gizle(show_buttons);
		//Miktar değiştirildiyse önceden eklenen rezerveler silinir
		if(eval('document.getElementById("sid'+no+'")').value != '')	
			var del_stock_reserve_0 = workdata('del_order_reserve_from_row','<cfoutput>#CFTOKEN#</cfoutput>,'+eval('document.getElementById("sid'+no+'")').value);
		var listParam = "<cfoutput>#dsn2_alias#</cfoutput>" + "*" + eval('document.getElementById("barcode'+no+'")').value;
		var stock_control = wrk_safe_query("wpda_stock_control_2",'dsn3',0,listParam);
		if(eval('document.getElementById("sid'+no+'")').value == '')	
			eval('document.getElementById("sid'+no+'")').value = stock_control.STOCK_ID;
		if(stock_control.SALEABLE_STOCK > 0)
		{
			if(parseInt(eval('document.getElementById("amount'+no+'")').value) > parseInt(stock_control.SALEABLE_STOCK))
			{
				eval('document.getElementById("amount'+no+'")').value = parseInt(stock_control.SALEABLE_STOCK);
			}		
			var del_stock_reserve = workdata('del_order_reserve_from_row','<cfoutput>#CFTOKEN#</cfoutput>,'+stock_control.STOCK_ID);
			var listParam = stock_control.STOCK_ID + "*" + stock_control.PRODUCT_ID + "*" + "<cfoutput>#CFTOKEN#</cfoutput>" + "*" + eval('document.getElementById("amount'+no+'")').value; 
			var stock_reserve = wrk_safe_query("wpda_stock_reserve",'dsn3',0,listParam);
			alert('Satılabilir ' + stock_control.SALEABLE_STOCK + ' adet stoktan ' + eval('document.getElementById("amount'+no+'")').value + ' adet rezerve edildi!');
		}
		else
		{
			alert("Bu üründen stoklarda yoktur !");
			sil(no);
			return false;
		}
	}
	function stock_reserve_upd(no,quantity,stock_id,product_id)
	{
		gizle(show_buttons);
		//Miktar değiştirildiyse önceden eklenen rezerveler silinir
		if(eval('document.add_order.sid'+no).value != '')	
			var del_stock_reserve_0 = workdata('del_order_reserve_from_row','<cfoutput>#CFTOKEN#</cfoutput>,'+stock_id);
		if(eval('document.add_order.sid'+no).value == '')	
			eval('document.add_order.sid'+no).value = stock_id;
		
		var stock_control = wrk_safe_query('wpda_stock_control','dsn2',0,stock_id);
		var stock_total = parseInt(quantity) + parseInt(stock_control.SALEABLE_STOCK);
		if(parseInt(stock_total) > 0)
		{
			if(parseInt(eval('document.add_order.amount'+no).value) > parseInt(stock_total))
			{
				eval('document.add_order.amount'+no).value = parseInt(stock_total);
			}	
			//	yeni rezerve edilecek miktar eksi de olsa artı da olsa pre-order-id ile rezerve edilir.. ki diğer bakanlar doğru stok görebilsinler
			var new_reservable_stock_amount = eval('document.add_order.amount'+no).value - quantity;
			if(new_reservable_stock_amount != 0)
			{
				if(parseInt(new_reservable_stock_amount) > 0)
					{
						var listParam = stock_id + "*" + product_id + "*" + "<cfoutput>#CFTOKEN#</cfoutput>" + "*" + new_reservable_stock_amount;
						var new_sql_2 = "wpda_stock_reserve";
					}
				else if(parseInt(new_reservable_stock_amount) < 0)
					{
						var listParam = stock_id + "*" + product_id + "*" + "<cfoutput>#CFTOKEN#</cfoutput>" + "*" + Math.abs(new_reservable_stock_amount);
						var new_sql_2 = "wpda_stock_reserve_2";				
					}				
				var stock_reserve = wrk_safe_query(new_sql_2,'dsn3',0,listParam);
			}
			alert('Satılabilir ' + stock_total + ' adet stoktan ' + eval('document.add_order.amount'+no).value + ' adet rezerve edildi!');
		}
		else
		{
			alert("Bu üründen stoklarda yoktur !");
			sil(no);
			return false;
		}
	}

	function add_barcode(no,barcode,type)
	{
		if(type == undefined) type = 1;
		if(type == 0)
		{
			<cfif fuseaction is 'pda.form_add_ship_dispatch'>
				document.getElementById("search_product").select();
			<cfelse>
				document.getElementById("search_lot_no").select();
			</cfif>		
		}
		else
		{
			barcode_found = 0;
			var xx = document.getElementById("row_count").value;
			if(xx > 0)
			{	
				for(var i=1; i<=xx; i++)
				{      
					if(eval('document.getElementById("row_kontrol'+i+'")').value ==1)
					{
						<cfif fuseaction is 'pda.form_add_ship_dispatch'>
							if(barcode == eval('document.getElementById("barcode'+i+'")').value && document.getElementById("search_lot_no").value == eval('document.getElementById("lot_no'+i+'")').value)
							{
								eval('document.getElementById("amount'+i+'")').value = commaSplit(parseFloat(filterNum(eval('document.getElementById("amount'+i+'")').value,4)) + parseFloat(filterNum(document.getElementById("search_amount").value,4)),4);
								document.getElementById('search_product').select();
								barcode_found = 1;
								break;
							}	
						<cfelse>
							if(barcode == eval('document.getElementById("barcode'+i+'")').value)
							{
								eval('document.getElementById("amount'+i+'")').value ++;
								eval('document.getElementById("amount'+i+'")').select();
								if(type != 2) // ayni stoga ait satirlarda sorun oluyordu, bunlari da siparis iliskilerini tutmasi icin ayri eklemeli
									barcode_found = 1;
								break;
							}
						</cfif>
					}	
				}
			}

			if(barcode_found == 0)
			{
				var new_sql = "SELECT DISTINCT BARCODE FROM STOCKS_BARCODES WHERE STOCK_ID = (SELECT DISTINCT SB.STOCK_ID FROM STOCKS AS S,PRODUCT_UNIT AS PU,STOCKS_BARCODES SB WHERE SB.STOCK_ID = S.STOCK_ID AND S.PRODUCT_STATUS = 1 AND S.STOCK_STATUS = 1 AND S.PRODUCT_ID = PU.PRODUCT_ID AND SB.BARCODE = '" + barcode + "')";
				var get_barcode = wrk_query(new_sql,'dsn3');

				if(get_barcode.recordcount > 0)
				{
					no++;
					if(document.getElementById("ship_info") != undefined && document.getElementById("ship_info").style.display == 'none')
						goster(ship_info);
					if(document.getElementById("order_info") != undefined && document.getElementById("order_info").style.display == 'none') //Burasi Alis ve Satis Adina Kullaniliyor
						goster(order_info);
					var get_product_name = wrk_query("SELECT TOP 1 S.PRODUCT_NAME FROM STOCKS S, STOCKS_BARCODES SB WHERE S.STOCK_ID = SB.STOCK_ID AND SB.BARCODE ='"+barcode+"'","dsn3",1);

					document.getElementById('order_rows').innerHTML = document.getElementById('order_rows').innerHTML + '<div id="mydiv"><div id="n_my_div' + no + '"><table cellpadding="1" cellspacing="0"><tr><td><input type="hidden" name="row_kontrol' + no + '" id="row_kontrol' + no + '" value="1" /><a href="javascript://" onclick="sil_rezerv(' + no + ');sil(' + no + ');"><img  src="images/delete_list.gif" align="absmiddle" border="0" class="form_icon"></a><input type="text" name="barcode' + no + '" id="barcode' + no + '" value="' + barcode + '" class="wide_input"><input type="hidden" name="sid' + no + '" id="sid' + no + '" value=""><input type="hidden" name="is_free_product' + no + '" id="is_free_product' + no + '" value="0"><input type="text" name="amount' + no + '" id="amount' + no + '" readonly value="1" class="moneybox" onkeyup="FormatCurrency(this,2);" <cfif isdefined('session.pda.use_onkeydown_enter')>onkeydown<cfelse>onchange</cfif>="<cfif isDefined('session.pda.use_onkeydown_enter')>if(event.keyCode == 13)</cfif> clear_barcode();"></td></tr></table></div></div>';
					<!---document.getElementById('order_rows').innerHTML = document.getElementById('order_rows').innerHTML + '<table cellpadding="1" cellspacing="0"><tr><td><input type="hidden" name="row_kontrol' + no + '" id="row_kontrol' + no + '" value="1" /><a href="javascript://" onclick="sil_rezerv(' + no + ');sil(' + no + ');"><img  src="images/delete_list.gif" align="absmiddle" border="0" class="form_icon"></a><input type="text" name="barcode' + no + '" id="barcode' + no + '" value="' + barcode + '" class="wide_input"><input type="hidden" name="sid' + no + '" id="sid' + no + '" value=""><input type="hidden" name="is_free_product' + no + '" id="is_free_product' + no + '" value="0"><input type="text" name="amount' + no + '" id="amount' + no + '" readonly value="1" class="moneybox" onkeyup="FormatCurrency(this,2);" <cfif isdefined('session.pda.use_onkeydown_enter')>onkeydown<cfelse>onchange</cfif>="<cfif isDefined('session.pda.use_onkeydown_enter')>if(event.keyCode == 13)</cfif> clear_barcode();"></td></tr></table>';
					document.getElementById('order_rows').innerHTML = document.getElementById('order_rows').innerHTML + '</div>';	--->	
					<cfif fuseaction is 'pda.form_add_ship_dispatch'>
						eval('document.getElementById("amount'+no+'")').value = document.getElementById("search_amount").value;
						eval('document.getElementById("lot_no'+no+'")').value = document.getElementById("search_lot_no").value;
					</cfif>					
					document.getElementById('row_count').value = parseInt(document.getElementById('row_count').value) + 1;
				}
				else
				{
					alert("Barkod Bulunamadı !");
					clear_barcode();
					return false;
				}
			}
			<cfif fuseaction is 'pda.form_add_ship_dispatch' or fuseaction is 'pda.form_add_stock_count_file'>
				document.getElementById("search_product").select();
			<cfelse>
				document.getElementById("amount"+no).select();
			</cfif>
		}  
	}
		
	function add_barcode2(no,barcode,type)
	{
		if(type == undefined) type = 1;
		if(type == 0)
		{
			<cfif fuseaction is 'pda.form_add_ship_dispatch'>
				document.getElementById("search_product").select();
			<cfelse>
				document.getElementById("search_lot_no").select();
			</cfif>		
		}
		else
		{
			barcode_found = 0;
			var xx = document.getElementById("row_count").value;
			if(xx > 0)
			{	
				for(var i=1; i<=xx; i++)
				{      
					if(eval('document.getElementById("row_kontrol'+i+'")').value ==1)
					{
						<cfif fuseaction is 'pda.form_add_ship_dispatch'>
							if(barcode == eval('document.getElementById("barcode'+i+'")').value && document.getElementById("search_lot_no").value == eval('document.getElementById("lot_no'+i+'")').value)
							{
								eval('document.getElementById("amount'+i+'")').value = commaSplit(parseFloat(filterNum(eval('document.getElementById("amount'+i+'")').value,4)) + parseFloat(filterNum(document.getElementById("search_amount").value,4)),4);
								document.getElementById('search_product').select();
								barcode_found = 1;
								break;
							}	
						<cfelse>
							if(barcode == eval('document.getElementById("barcode'+i+'")').value)
							{
								eval('document.getElementById("amount'+i+'")').value ++;
								eval('document.getElementById("amount'+i+'")').select();
								if(type != 2) // ayni stoga ait satirlarda sorun oluyordu, bunlari da siparis iliskilerini tutmasi icin ayri eklemeli
									barcode_found = 1;
								break;
							}
						</cfif>
					}	
				}
			}

			if(barcode_found == 0)
			{
				var new_sql = "SELECT DISTINCT BARCODE FROM STOCKS_BARCODES WHERE STOCK_ID = (SELECT DISTINCT SB.STOCK_ID FROM STOCKS AS S,PRODUCT_UNIT AS PU,STOCKS_BARCODES SB WHERE SB.STOCK_ID = S.STOCK_ID AND S.PRODUCT_STATUS = 1 AND S.STOCK_STATUS = 1 AND S.PRODUCT_ID = PU.PRODUCT_ID AND SB.BARCODE = '" + barcode + "')";
				var get_barcode = wrk_query(new_sql,'dsn3');

				if(get_barcode.recordcount > 0)
				{
					no++;
					if(document.getElementById("ship_info") != undefined && document.getElementById("ship_info").style.display == 'none')
						goster(ship_info);
					if(document.getElementById("order_info") != undefined && document.getElementById("order_info").style.display == 'none') //Burasi Alis ve Satis Adina Kullaniliyor
						goster(order_info);
					<!---goster(document.getElementById("n_my_div" + no));
	
					eval('document.getElementById("row_kontrol'+no+'")').value = 1;
					eval('document.getElementById("barcode'+no+'")').value = barcode;
					<cfif fuseaction is 'pda.form_add_ship_dispatch'>
						eval('document.getElementById("amount'+no+'")').value = document.getElementById("search_amount").value;
						eval('document.getElementById("lot_no'+no+'")').value = document.getElementById("search_lot_no").value;
					</cfif>
					var get_product_name = wrk_query("SELECT TOP 1 S.PRODUCT_NAME FROM STOCKS S, STOCKS_BARCODES SB WHERE S.STOCK_ID = SB.STOCK_ID AND SB.BARCODE ='"+barcode+"'","dsn3",1);
					if(get_product_name.recordcount > 0)
						eval('document.getElementById("product_name'+no+'")').value = get_product_name.PRODUCT_NAME;--->
					var get_product_name = wrk_query("SELECT TOP 1 S.PRODUCT_NAME FROM STOCKS S, STOCKS_BARCODES SB WHERE S.STOCK_ID = SB.STOCK_ID AND SB.BARCODE ='"+barcode+"'","dsn3",1);

					document.getElementById('order_rows').innerHTML = document.getElementById('order_rows').innerHTML + '<div id="n_my_div' + no + '">';
					document.getElementById('order_rows').innerHTML = document.getElementById('order_rows').innerHTML + '<table cellpadding="1" cellspacing="0"><tr><td><input type="hidden" name="row_kontrol' + no + '" id="row_kontrol' + no + '" value="1" /><input type="hidden" name="sid' + no + '" id="sid' + no + '" value=""><input type="hidden" name="is_free_product' + no + '" id="is_free_product' + no + '" value="0"><input type="hidden" name="row_ship_id' + no + '" id="row_ship_id' + no + '" value=""><input type="hidden" name="wrk_row_relation_id' + no + '" id="wrk_row_relation_id' + no + '" value=""><input type="text" name="amount' + no + '" id="amount' + no + '" readonly value="1" class="moneybox" onkeyup="FormatCurrency(this,2);" <cfif isdefined('session.pda.use_onkeydown_enter')>onkeydown<cfelse>onchange</cfif>="<cfif isDefined('session.pda.use_onkeydown_enter')>if(event.keyCode == 13)</cfif> clear_barcode();"><input type="text" name="amount_diff' + no + '" id="amount_diff' + no + '" readonly value="0" class="moneybox" onkeyup="FormatCurrency(this,2);" <cfif isdefined('session.pda.use_onkeydown_enter')>onkeydown<cfelse>onchange</cfif>="<cfif isDefined('session.pda.use_onkeydown_enter')>if(event.keyCode == 13)</cfif> clear_barcode();"><input type="text" name="barcode' + no + '" id="barcode' + no + '" value="' + barcode + '" class="wide_input"><a href="javascript://" onclick="sil(' + no + ');"><img  src="images/delete_list.gif" align="absmiddle" border="0" class="form_icon"></a><a href="javascript://" onclick="gizle_goster("tr_product_name' + no + '");"><img  src="images/plus_ques.gif" align="absmiddle" border="0" class="form_icon"></a><a href="javascript://" onclick="data_transfer(1,' + no + ');"><img  src="images/copy_list.gif" align="absmiddle" border="0" class="form_icon"></a></td></tr>';
					if(get_product_name.recordcount > 0)
						document.getElementById('order_rows').innerHTML = document.getElementById('order_rows').innerHTML + '<tr id="tr_product_name' + no + '" style="display:;"><td><input type="text" name="product_name' + no + '" id="product_name' + no + '" value="' + get_product_name.PRODUCT_NAME + '" class="wide_input" readonly></td></tr></table>';
					else
						document.getElementById('order_rows').innerHTML = document.getElementById('order_rows').innerHTML + '<tr id="tr_product_name' + no + '" style="display:;"><td><input type="text" name="product_name' + no + '" id="product_name' + no + '" value="" class="wide_input" readonly></td></tr></table>';					
					document.getElementById('order_rows').innerHTML = document.getElementById('order_rows').innerHTML + '</div>';
					<cfif fuseaction is 'pda.form_add_ship_dispatch'>
						eval('document.getElementById("amount'+no+'")').value = document.getElementById("search_amount").value;
						eval('document.getElementById("lot_no'+no+'")').value = document.getElementById("search_lot_no").value;
					</cfif>					
					document.getElementById('row_count').value = parseInt(document.getElementById('row_count').value) + 1;
				}
				else
				{
					alert("Barkod Bulunamadı !");
					clear_barcode();
					return false;
				}
			}
			<cfif fuseaction is 'pda.form_add_ship_dispatch' or fuseaction is 'pda.form_add_stock_count_file'>
				document.getElementById("search_product").select();
			<cfelse>
				document.getElementById("amount"+no).select();
			</cfif>
		}  
	}
	function calc_order()
	{
		if(document.getElementById('company_id').value == '' && document.getElementById('member_name').value == '')
		{
			alert("Lütfen Müşteri (Cari Hesap) Seçiniz!");
			return false;
		}
	
		var xx = parseInt(document.getElementById('row_count').value);		
		var product_exists = 0;
		for(var i=1; i<=xx; i++)
		{
			if(eval('document.getElementById("row_kontrol'+i+'")').value == 1)
			{
				product_exists = product_exists + 1;
			}
		}
		if(product_exists == 0 || document.getElementById('row_count').value == 0)
		{
			alert("<cf_get_lang_main no='59.Eksik Veri'> : <cf_get_lang_main no='245.Ürün'>");
			return false;
		}
		var rate_list = "";
		var rate_list_2 = "";
		var barcode_list = '';
		var barcode_amount_list = '';
		var barcode_free_product_list = '';
		for(var i=1; i<=xx; i++)
		{	
			if(eval('document.getElementById("row_kontrol'+i+'")').value == 1)
			{	
				if(eval('document.getElementById("barcode'+i+'")') && eval('document.getElementById("barcode'+i+'")').value != '' && eval('document.getElementById("amount'+i+'")').value != '')
					if(barcode_list.length > 0)
					{
						barcode_list = barcode_list + ',' + eval('document.getElementById("barcode'+i+'")').value;
						barcode_amount_list = barcode_amount_list + ',' + eval('document.getElementById("amount'+i+'")').value;
						if(eval('document.getElementById("is_free_product'+i+'")'))
							barcode_free_product_list = barcode_free_product_list + ',' + eval('document.getElementById("is_free_product'+i+'")').value;
					}
					else
					{
						barcode_list = barcode_list + eval('document.getElementById("barcode'+i+'")').value;
						barcode_amount_list = barcode_amount_list + eval('document.getElementById("amount'+i+'")').value;
						if(eval('document.getElementById("is_free_product'+i+'")'))
							barcode_free_product_list = barcode_free_product_list + eval('document.getElementById("is_free_product'+i+'")').value;
					}
			}
		}	
		document.getElementById('price_list_id').value = document.getElementById('price_cat_id').value;
		document.getElementById('price_date').value = document.getElementById('order_date').value;
		document.getElementById('basket_products').value = barcode_list;
		document.getElementById('basket_products_amount').value = barcode_amount_list;	
		document.getElementById('basket_free_products').value = barcode_free_product_list;			
		document.form_calc_order.company_id.value = document.add_order.company_id.value;
	
		<cfoutput query="get_money_bskt">
			rate_list = rate_list + '&rt1_#money_type#='+document.form_calc_order.txt_rate1_#money_type#.value + '&rt2_#money_type#='+document.form_calc_order.txt_rate2_#money_type#.value;
		</cfoutput>
		//AjaxPageLoad(<cfoutput>'#request.self#</cfoutput>?fuseaction=pda.emptypopup_calc_order_div&'+rate_list+'&basket_money=USD&basket_products_amount='+document.form_calc_order.basket_products.value+'&basket_products='+document.form_calc_order.basket_products.value+'&company_id='+document.form_calc_order.company_id.value+'&price_list_id='+document.getElementById('price_list_id').value+'&price_date='+encodeURI(document.add_order.order_date.value),'calc_order_div');		
		AjaxFormSubmit('form_calc_order','calc_order_div',1,'Hesaplanıyor...','Hesaplandı!','','',1);
		goster(show_buttons);
	}
	function sil(sy)
	{
		document.getElementById('n_my_div'+sy).style.display = 'none';
		document.getElementById('row_kontrol'+sy).value = 0;///alanın silindiğini tutuyoruz. toplam hesaplamada ve kayıt ederken kullanılıyor
		gizle(show_buttons);
	}
	function sil_rezerv(no)
	{
		var get_stock_id = wrk_safe_query('wpda_get_stock_id','dsn3',0,eval('document.add_order.barcode'+no).value);
		var del_stock_reserve = workdata('del_order_reserve_from_row','<cfoutput>#CFTOKEN#</cfoutput>,'+get_stock_id.STOCK_ID);
	}
	function sil_rezerv_upd(no,quantity,stock_id,product_id)
	{
		//var get_stock_id = wrk_safe_query('wpda_get_stock_id','dsn3',0,eval('document.add_order.barcode'+no).value); 	
		var del_stock_reserve = workdata('del_order_reserve_from_row','<cfoutput>#CFTOKEN#</cfoutput>,'+stock_id);
		var listParam = stock_id + "*" + product_id + "*" + "<cfoutput>#CFTOKEN#</cfoutput>" + "*" + quantity;
		//var stock_reserve = wrk_safe_query(new_sql_2,'dsn3',0,listParam);	
		var stock_reserve = wrk_safe_query(del_stock_reserve,'dsn3',0,listParam);	
	}
	function control_inputs()
	{
		if(document.getElementById('company_id').value == '')
		{
			alert("<cf_get_lang_main no='59.Eksik Veri'> : <cf_get_lang_main no='246.Üye'>");
			return false;
		}
		if(document.getElementById('row_count').value == 0)
		{
			alert("<cf_get_lang_main no='59.Eksik Veri'> : <cf_get_lang_main no='245.Ürün'>");
			return false;
		}
	
		var xx = parseInt(document.getElementById('row_count').value);
	
		var product_exists = 0;
		for(var i=1; i<=xx; i++)
		{
			if(eval('document.getElementById("row_kontrol'+i+'")').value == 1)
			{
				product_exists = product_exists + 1;
			}
		}
		if(product_exists == 0)
		{
			alert("<cf_get_lang_main no='59.Eksik Veri'> : <cf_get_lang_main no='245.Ürün'>");
			return false;
		}
		document.getElementById('nettotal_usd').value = filterNum(document.getElementById('nettotal_usd').value,2);
		document.add_order.submit();;
	}
	function kontrol_prerecord()
	{
		goster(kontrol_prerecord_div);
		AjaxPageLoad(<cfoutput>'#request.self#</cfoutput>?fuseaction=pda.emptypopup_get_company_div&field_id=add_order.ref_company_id&field_name=add_order.ref_member_name&field_type=add_order.ref_member_type&field_partner_id=add_order.ref_partner_id&ref_member_name='+ encodeURI(add_order.ref_member_name.value) +'&div_name='+'kontrol_prerecord_div' +'&form_id=' + 'add_order','kontrol_prerecord_div');		
		return false;
	}
	
	function sil_bastan()
	{
		gizle(show_buttons);	
		document.getElementById('nettotal').value = 0;
		document.getElementById('basket_net_total').value = 0;
		document.getElementById('sa_discount').value = 0;
		document.getElementById('nettotal_usd').value = 0;
		document.getElementById('basket_net_total_usd').value = 0;
	}
</script>
