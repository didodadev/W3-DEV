<!--- bu sayfayı include lara ayırdım bilginize...Aysenur20061019 --->
<cfparam name="is_order_to_directcustomer" default="0">
<cfset attributes.campaign_id = "">
<cfif ArrayLen(session.basketww_camp)>
	<cfset attributes.campaign_id = session.basketww_camp[1][24]>
</cfif>
<cfscript>
	session_basket_kur_ekle(process_type:0);
	if (listfindnocase(employee_url,'#cgi.http_host#',';'))
	{
		int_comp_id = session.ep.company_id;
		int_period_id = session.ep.period_id;
		int_money = session.ep.money;
		int_money2 = session.ep.money2;
	}
	else if (listfindnocase(partner_url,'#cgi.http_host#',';'))
	{
		int_comp_id = session.pp.our_company_id;
		int_period_id = session.pp.period_id;
		int_money = session.pp.money;
		int_money2 = session.pp.money2;
		attributes.company_id = session.pp.company_id;
	}
	else if (listfindnocase(server_url,'#cgi.http_host#',';') )
	{	
		int_comp_id = session.ww.our_company_id;
		int_period_id = session.ww.period_id;
		int_money = session.ww.money;
		int_money2 = session.ww.money2;
		attributes.consumer_id = session.ww.userid;
	}
</cfscript>
<cfinclude template="../query/get_order_detail_money.cfm">
<cfinclude template="../query/get_order_detail_account.cfm">
<cfinclude template="../query/get_order_detail.cfm">
<table border="0" cellspacing="0" cellpadding="0" align="center" style="width:100%;">
  	<tr style="height:25px;">
		<td class="formbold"><cf_get_lang no ='1304.Kampanya Siparişi'></td>
        <td class="txtbold" style="text-align:right;"><cfoutput>#dateformat(now(),'dd/mm/yyyy')#</cfoutput></td>
  	</tr>
</table>
<cfif use_https>
	<cfset url_link = https_domain>
<cfelse>
	<cfset url_link = "">
</cfif>
<cfform name="list_basketww" action="#url_link##request.self#?fuseaction=objects2.emptypopup_add_orderww_camp" method="post" onsubmit="return (unformat_fields());">
	<div id="sale_basket_rows_list" style="width:99%;height:200px;"></div>
    <input type="hidden" name="first_time" id="first_time" value="1">
    <input type="hidden" name="kredi_karti_indirim_orani" id="kredi_karti_indirim_orani" value="0">    
    <input type="hidden" name="cargo_kontrol" id="cargo_kontrol" value="1">
    <input type="hidden" name="tum_toplam_kdvli" id="tum_toplam_kdvli" value="0">
    <input type="hidden" name="tum_toplam_kdvli_risk" id="tum_toplam_kdvli_risk" value="0">
    <input type="hidden" name="tum_toplam_komisyonsuz" id="tum_toplam_komisyonsuz" value="0">
    <input type="hidden" name="my_temp_tutar" id="my_temp_tutar" value="0">
    <input type="hidden" name="my_temp_tutar_price_standart" id="my_temp_tutar_price_standart" value="0">
    <input type="hidden" name="toplam_desi" id="toplam_desi" value="0.1">
    <input type="hidden" name="sepet_adres" id="sepet_adres" value="<cfoutput>#request.self#</cfoutput>?fuseaction=objects2.popupajax_sale_basket_rows_camp">
	<cfif ArrayLen(session.basketww_camp)>
        <cfinclude template="address_payment_info.cfm">
    <cfelse>
        <table align="center" cellpadding="2" cellspacing="1" style="width:100%;">
        	<tr class="color-header" style="height:22px;">
        		<td class="form-title">No</td>
                <td class="form-title"><cf_get_lang_main no ='152.Ürünler'></td>
                <td class="form-title" style="width:50px;"><cf_get_lang_main no ='223.Miktar'></td>
                <td class="form-title" style="width:125px;text-align:right;"><cf_get_lang_main no ='226.Birim Fiyat'></td>
                <td class="form-title" style="width:150px;text-align:right;"><cf_get_lang_main no ='672.Fiyat'></td>
        	</tr>
        	<tr class="color-row" style="height:20px;">
        		<td colspan="5"><cf_get_lang no='134.Sepette Ürün Yok'>!</td>
        	</tr>
        </table>
	</cfif>
</cfform>
<script type="text/javascript">
	var sepet_adres_ = document.getElementById('sepet_adres').value;
	if(document.getElementById('first_time').value == '1')
	{
		if(document.list_basketww.ship_address_country0 != undefined)
		{
			var country_id_ = document.getElementById('ship_address_country0').value;
			if(country_id_.length)
				(country_id_,'ship_address_city0','ship_address_county0',0);
		}
 		AjaxPageLoad(sepet_adres_,'sale_basket_rows_list','1',"Ürünler Listeleniyor!");
		document.getElementById('first_time').value = '0';
	}

	function clear_cargo_row()
	{
		adres_ = '<cfoutput>#request.self#</cfoutput>?fuseaction=objects2.emptypopup_del_basketww_camp&is_delete_cargo=1';
		AjaxPageLoad(adres_,'sale_basket_rows_list','1','Hesaplanıyor!');
		clear_paymethod();
	}

	function clear_paymethod()
	{
		if(isDefined('paymethod_type[0]')) document.list_basketww.paymethod_type[0].checked = false;
		if(isDefined('paymethod_type[1]')) document.list_basketww.paymethod_type[1].checked = false;
		if(isDefined('paymethod_type[2]')) document.list_basketww.paymethod_type[2].checked = false;
		pay_type_2.style.display='none';
		<cfif get_accounts.recordcount>
			<cfoutput query="get_accounts">
				if(isDefined('action_to_account_id[#currentrow-1#]')) document.list_basketww.action_to_account_id[#currentrow-1#].checked = false;
			</cfoutput>
		</cfif>
		return true;
	}

	function change_cargo_info(ship_method)
	{
		clear_cargo_row();
		city_ = '';
		ship_method_ = ship_method;
		toplam_desi_ = document.getElementById('toplam_desi').value;
		var radioLength = document.list_basketww.ship_address_row.length;
		if(radioLength == undefined)
		{
			if(isDefined('ship_address_row'))
				if(document.list_basketww.ship_address_row.checked)
					{
						if(document.getElementById('ship_address_city0').value!='')
							city_ = document.getElementById('ship_address_city0').value;
					}
				else
					city_ = document.getElementById('ship_address_city0').value;
		}
		else
		{
			for(var i = 0; i < radioLength; i++) 
			{
				if(document.list_basketww.ship_address_row[i].checked)
				{
					x = document.list_basketww.ship_address_row[i].value;
					if(eval("document.getElementById('ship_address_city" + x + "')").value != '')
						city_ = eval("document.getElementById('ship_address_city" + x + "')").value;
				}
			}
		}
		if(city_.length==0) // sehir yoksa kargo hesaplama yok.
		{
			alert('Bulunduğunuz Şehri Seçmelisiniz!');
			if(document.list_basketww.ship_method_id.disabled == false)
			document.getElementById('ship_method_id').value = '';
			kargo_info_td.innerHTML = '';
			kargo_info_tr.style.display = 'none';
			return false;
		}
		else // sehir varsa kargoya bakar
		{
			kargo_info_tr.style.display = '';
			var listParam = city_ + "*" + ship_method_ + "*" + toplam_desi_;
			var get_cargos = wrk_safe_query("obj2_get_cargos","dsn","10",listParam);
			if(get_cargos.recordcount)
			{
				document.getElementById('cargo_kontrol').value = '0';
				kargo_info_td.innerHTML = '<table><tr><td>';
				for(i=0;i<get_cargos.recordcount;i++)
				{
					kargo_info_td.innerHTML += '<input type=radio name=sevk_type value=1 onClick=cargo_ekle("' + get_cargos.CUSTOMER_PRICE[i] + '","' + get_cargos.PRODUCT_ID[i] + '","' + get_cargos.OTHER_MONEY[i] + '"' + ')>';
					kargo_info_td.innerHTML += get_cargos.NICKNAME[i];
					kargo_info_td.innerHTML += ' - ' + '<strike>' + get_cargos.PRICE[i] + ' ' +  get_cargos.OTHER_MONEY[i] + ' + KDV </strike> <b>' + get_cargos.CUSTOMER_PRICE[i] + ' ' + get_cargos.OTHER_MONEY[i] + ' + KDV</b>';
					kargo_info_td.innerHTML += '<br/>';					
					if(get_cargos.recordcount==1)
					{
						document.list_basketww.sevk_type.checked = true;
						cargo_ekle(get_cargos.CUSTOMER_PRICE[i],get_cargos.PRODUCT_ID[i],get_cargos.OTHER_MONEY[i]);
					}
					else
					{
						document.list_basketww.sevk_type[0].checked = true;
						cargo_ekle(get_cargos.CUSTOMER_PRICE[i],get_cargos.PRODUCT_ID[i],get_cargos.OTHER_MONEY[i]);
					}
				}
				kargo_info_td.innerHTML += '</td></tr></table>';
			}
			else
			{
				var listParam = city_ + "*" + ship_method_ + "*" + toplam_desi_;
				var get_cargo_type = wrk_safe_query("obj2_get_cargo_type","dsn","1",listParam);
				if(get_cargo_type.recordcount)
				{
					var listParam = city_ + "*" + toplam_desi_ + "*" + get_cargo_type.SHIP_METHOD_PRICE_ID;
					var get_cargos2 = wrk_safe_query("obj2_get_cargos_2","dsn","1",listParam);
					if(get_cargos2.recordcount)
					{
						document.getElementById('cargo_kontrol').value = '0';
						kargo_info_td.innerHTML = '<table><tr><td>';
						for(i=0;i<get_cargos2.recordcount;i++)
						{
							kargo_tutar_ = wrk_round(parseFloat(get_cargo_type.CUSTOMER_PRICE) + (get_cargos2.PRICE * (toplam_desi_ - get_cargos2.MAX_LIMIT)));
							kargo_info_td.innerHTML += '<input type=radio name=sevk_type value=1 onClick=cargo_ekle("' + kargo_tutar_ + '","' + get_cargos2.PRODUCT_ID[i] + '","' + get_cargos2.OTHER_MONEY[i] + '"' + ')>';
							kargo_info_td.innerHTML += get_cargos2.NICKNAME[i];
							kargo_info_td.innerHTML += ' - ' + '<b>' + kargo_tutar_ + ' ' + get_cargos2.OTHER_MONEY[i] + ' + KDV</b>';
							kargo_info_td.innerHTML += '<br/>';					
							if(get_cargos2.recordcount==1)
							{
								document.list_basketww.sevk_type.checked = true;
								cargo_ekle(kargo_tutar_,get_cargos2.PRODUCT_ID[i],get_cargos2.OTHER_MONEY[i]);
							}
							else
							{
								document.list_basketww.sevk_type[0].checked = true;
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
		}	
	}

	function unformat_fields()
	{
		<cfif isDefined("session.pp")>
			<cfif isdefined("attributes.is_view_last_user_price") and attributes.is_view_last_user_price eq 1>
				document.getElementById('price_standart_last').value = filterNum(document.getElementById('price_standart_last').value);
			</cfif>
		</cfif>
	}
	
	function remove_adress(parametre)
	{
		if(parametre==1)
		{
			document.getElementById('ship_address_city0').value = '';
			document.getElementById('ship_address_county0').value = '';
			document.getElementById('ship_address_county_name0').value = '';
		}
		else
		{
			document.getElementById('ship_address_county0').value = '';
			document.getElementById('ship_address_county_name0').value = '';
		}	
	}
	function yeni_adres(nesne)
	{
		if(nesne.checked==true && nesne.value==0)
		{
			shipaddress0.style.display='';
		}else
		{
			shipaddress0.style.display='none';
		}
	}
	function pencere_ac(no)
	{
		x = document.list_basketww.ship_address_country0.selectedIndex;
		if (document.list_basketww.ship_address_country0[x].value == "")
		{
			alert("<cf_get_lang no ='31.İlk Olarak Ülke Seçiniz'>.");
		}	
		else if(document.list_basketww.ship_address_city0.value == "")
		{
			alert("<cf_get_lang no ='32.İl Seçiniz'>!");
		}
		else
		{
			windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects2.popup_dsp_county&field_id=list_basketww.ship_address_county0&field_name=list_basketww.ship_address_county_name0&city_id=' + list_getat(document.list_basketww.ship_address_city0.value,1,","),'small');
			return remove_adress();
		}
	}
	
	function odemeyontemi(type)
	{
		if(document.getElementById('ship_method_id').value == '')
		{
			alert('Önce Sevkiyat Şekli Seçmelisiniz!');
			if(isDefined('paymethod_type[0]')) document.list_basketww.paymethod_type[0].checked = false;
			if(isDefined('paymethod_type[1]')) document.list_basketww.paymethod_type[1].checked = false;
			if(isDefined('paymethod_type[2]')) document.list_basketww.paymethod_type[2].checked = false;
			return false;
		}
		
		if(type==1)
		{
			pay_type_1.style.display='';
			if(document.list_basketww.pay_type_2)
				pay_type_2.style.display='none';
			clear_pos_row();
		}
		else if(type==2)
		{	
			pay_type_2.style.display='';
			if(document.list_basketww.pay_type_1)
				pay_type_1.style.display='none';
		}
		<cfif isDefined("attributes.company_id") and len(attributes.company_id)>
			else if(type==3)
			{
				if(document.list_basketww.pay_type_1)
					pay_type_1.style.display='none';
				if(document.list_basketww.pay_type_2)	
					pay_type_2.style.display='none';
				clear_pos_row();
			}
		</cfif>
	}
	
	function kontrol() 
	{
		var kontrol=0;
		if(document.getElementById('ship_method_id').value == '')
		{
			alert('Sevkiyat Şekli Seçmelisiniz!');
			return false;
		}
			
		if(document.getElementById('cargo_kontrol').value=='0')
		{
			alert('Kargo Firması Seçmelisiniz!');
			return false;
		}
			
		if(document.list_basketww.ship_address_row!=undefined && document.list_basketww.ship_address_row.length>1)
		{
			for(var j=0;j<document.list_basketww.ship_address_row.length;j++)
			{
				if(document.list_basketww.ship_address_row[j].checked==true)
				{
						if(document.list_basketww.ship_address_row[document.list_basketww.ship_address_row.length-1].checked==true)
						{
							if(document.getElementById('ship_address_country0').value.length==0)
							{
								alert("<cf_get_lang no ='1092.Teslim Ülke Giriniz'>!");
								return false;
							}
							
							if(document.getElementById('ship_address_city0').value.length==0)
							{
								alert("<cf_get_lang no ='1093.Teslim Şehri Giriniz'>!");
								return false;
							}
							
							if(document.getElementById('ship_address_county0').value.length==0)
							{
								alert("<cf_get_lang no ='1094.Teslim İlçe Giriniz'>!");
								return false;
							}
							
							if(document.getElementById('ship_address_semt0').value.length==0)
							{
								alert("<cf_get_lang no ='1095.Teslim Semt Giriniz'>!");
								return false;
							}
							if(document.list_basketww.ship_district_id0 != undefined && document.getElementById('ship_district_id0').value=="")
							{
								alert("<cf_get_lang no ='1303.Teslim Mahalle Giriniz'> !");
								return false;
							}
							if(document.list_basketww.ship_address0 != undefined && document.getElementById('ship_address0').value.length==0)
							{
								alert("<cf_get_lang no ='1096.Teslim Adresi Giriniz'>!");
								return false;
							}
						}
					kontrol=1;
					break;
				}
			}
		}
		else if(document.list_basketww.ship_address_row!=undefined && document.list_basketww.ship_address_row.length == undefined)
		{
				if(document.getElementByıd('ship_address_country0').value.length==0)
				{
					alert("<cf_get_lang no ='1092.Teslim Ülke Giriniz'>!");
					return false;
				}
				
				if(document.getElementById('ship_address_city0').value.length==0)
				{
					alert("<cf_get_lang no ='1093.Teslim Şehri Giriniz'>!");
					return false;
				}
				
				if(document.getElementById('ship_address_county0').value.length==0)
				{
					alert("<cf_get_lang no ='1094.Teslim İlçe Giriniz'>!");
					return false;
				}
	
				if(document.getElementById('ship_address_semt0').value.length==0)
				{
					alert("<cf_get_lang no ='1095.Teslim Semt Giriniz'>!");
					return false;
				}
				
				if(document.getElementById('ship_address0').value.length==0)
				{
					alert("<cf_get_lang no ='1096.Teslim Adresi Giriniz'>!");
					return false;
				}
				kontrol=1;
		}
		if(kontrol==0)
		{
			alert("<cf_get_lang no ='1097.Teslim Adres Bilgilerini Giriniz'>!");
			return false;
		}
		kontrol=0;
		if(document.list_basketww.paymethod_type != undefined && document.list_basketww.paymethod_type.checked==true)
			kontrol=1;
		if(document.list_basketww.paymethod_type.value != undefined)//tek ödeme yöntemli ve çoklular için 2 blok yapıldı.
		{
			if(document.list_basketww.paymethod_type.checked==true)
			{
				if(document.list_basketww.paymethod_type.value == 2)//Kredi kartı ile ödeme yaparsa
				{
					if(document.list_basketww.action_to_account_id == undefined)
					{
						alert("<cf_get_lang_main no ='615.Ödeme Yöntemi Seçiniz'>!");
						return false;
					}
					if(document.getElementById('card_no').value == "")
					{
						alert("<cf_get_lang no='519.Lütfen Geçerli Kredi Kartı Numarasını Giriniz'>!");
						return false;
					}
					if(document.getElementById('cvv_no').value == "")
					{
						alert("<cf_get_lang no ='1098.CVV No Giriniz'>!");
						return false;
					}
					if(document.list_basketww.credit_card_rules != undefined && document.list_basketww.credit_card_rules.checked == false)
					{
						alert("Devam Etmek İçin Kredi Kartı Kullanım Şartlarını Kabul Etmelisiniz !");
						return false;
					}
					if(document.getElementById('process_cat_rev').value == "" || document.getElementById('process_type').value == "")
					{
						alert("<cf_get_lang no ='1099.Kredi Kartı Tahsilat İşlem Tipi Tanımlayınız'>!");
						return false;
					}
					temp_xxx=0;
					if('<cfoutput>#get_accounts.recordcount#</cfoutput>' > 1)
					{
						for(var t=0; t <'<cfoutput>#get_accounts.recordcount#</cfoutput>'; t++)
						{
							if (eval('document.getElementById("action_to_account_id")[t].checked'))
								temp_xxx=1;
						}
					}
					else
					{
						if (eval('document.getElementById("action_to_account_id").checked'))
							temp_xxx=1;
					}
					if(temp_xxx==0)				
					{
						alert("<cf_get_lang no ='1100.Kredi Kartı Ödeme Yöntemi Seçiniz'>!");
						return false;
					}
				}
				if(document.list_basketww.paymethod_type.value == 1)//Havale ile ödeme yaparsa
				{
					x = document.list_basketww.account_id.selectedIndex;
					if (document.list_basketww.account_id[x].value == "")
					{
						alert("<cf_get_lang no ='1101.Hesap Seçiniz'>!");
						return false;
					}
					if(document.getElementById('process_type_talimat').value == "" || document.getElementById('process_cat_talimat').value == "")
					{
						alert("<cf_get_lang no ='1102.Havale İşlem Tipi Tanımlayınız'>!");
						return false;
					}
					kontrol=1;
				}
				if(document.getElementById('paymethod_type').value == 3)//Risk limiti ile ödeme yaparsa
				{
					if(document.getElementById('kalan_risk_info').value < 0)
						alert("<cf_get_lang no ='1103.Risk Limitiniz'>: " +commaSplit(document.getElementById('kalan_risk_info').value));
				}
				kontrol=1;
			}
		}
		else
		{
			for(var j=0;j<document.list_basketww.paymethod_type.length;j++)
			{
				if(document.list_basketww.paymethod_type[j].checked==true)
				{
					if(document.list_basketww.paymethod_type[j].value == 2)//Kredi kartı ile ödeme yaparsa
					{
						if(document.list_basketww.action_to_account_id == undefined)
						{
							alert("<cf_get_lang_main no ='615.Ödeme Yöntemi Seçiniz'>!");
							return false;
						}
						if(document.getElementById('card_no').value == "")
						{
							alert("<cf_get_lang no ='1104.Kredi Kartı No Giriniz'>!");
							return false;
						}
						if(document.getElementById('cvv_no').value == "")
						{
							alert("<cf_get_lang no ='1098.CVV No Giriniz'>!");
							return false;
						}
						if(document.list_basketww.credit_card_rules != undefined && document.list_basketww.credit_card_rules.checked == false)
						{
							alert("Devam Etmek İçin Kredi Kartı Kullanım Şartlarını Kabul Etmelisiniz !");
							return false;
						}
						if(document.getElementById('process_cat_rev').value == "" || document.getElementById('process_type').value == "")
						{
							alert("<cf_get_lang no ='1099.Kredi Kartı Tahsilat İşlem Tipi Tanımlayınız'>!");
							return false;
						}
						temp_xxx=0;
						if('<cfoutput>#get_accounts.recordcount#</cfoutput>' > 1)
						{
							for(var t=0; t <'<cfoutput>#get_accounts.recordcount#</cfoutput>'; t++)
							{
								if (eval('document.getElementById("action_to_account_id")[t].checked'))
									temp_xxx=1;
							}
						}
						else
						{
							if (eval('document.getElementById("action_to_account_id").checked'))
								temp_xxx=1;
						}
						if(temp_xxx==0)				
						{
							alert("<cf_get_lang no ='1100.Kredi Kartı Ödeme Yöntemi Seçiniz'>!");
							return false;
						}
					//kontrol=1;
					}
					if(document.list_basketww.paymethod_type[j].value == 1)//Havale ile ödeme yaparsa
					{
						x = document.list_basketww.account_id.selectedIndex;
						if (document.list_basketww.account_id[x].value == "")
						{
							alert("<cf_get_lang no ='1101.Hesap Seçiniz'>!");
							return false;
						}
						if(document.getElementById('process_type_talimat').value == "" || document.getElementById('process_cat_talimat').value == "")
						{
							alert("<cf_get_lang no ='1102.Havale İşlem Tipi Tanımlayınız'>!");
							return false;
						}
					//kontrol=1;
					}
					<cfif isDefined("session.pp")>
						if(document.list_basketww.paymethod_type[j].value == 3)//Risk limiti ile ödeme yaparsa
						{
							if(document.getElementById('kalan_risk_info').value < 0)
								alert("<cf_get_lang no ='1103.Risk Limitiniz'>: " +commaSplit(document.getElementById('kalan_risk_info').value));
						}
					</cfif>
					kontrol=1;
					break
				}
			}
		}
		if(kontrol==0)
		{
			alert("<cf_get_lang_main no ='615.Ödeme Yöntemi Seçiniz'>!");
			return false;
		}
		<cfif isDefined("session.pp")>
			<cfif isdefined("attributes.is_view_last_user_price") and attributes.is_view_last_user_price eq 1>
				if(document.list_basketww.is_price_standart.checked)
					if(filterNum(document.getElementById('price_standart_dsp').value) > document.getElementById('sales_credit').value)
					{
						alert("<cf_get_lang no ='1105.Son Kullanıcı Fiyatından Daha Yüksek Tutar Giremezsiniz'>!");
						return false;
					}
				if(document.list_basketww.is_price_standart.checked && (document.list_basketww.consumer_info != undefined && document.list_basketww.consumer_info.checked))
				{
					if(document.getElementById('member_name').value=="" || document.getElementById('member_surname').value=="" || document.getElementById('address').value=="")
					{
						alert("<cf_get_lang no ='1106.Müşteri İçin Ad Soyad ve Adres Bilgilerini Giriniz'>!");
						return false;
					}
					if(document.getElementById('consumer_stage').value=="")
					{
						alert("<cf_get_lang no ='1107.Bireysel Üye Süreçlerinizi Kontrol Ediniz'>!");
						return false;
					}
				}
			</cfif>
		</cfif>
		document.list_basketww.ship_method_id.disabled = false;
		if(document.list_basketww.exp_month != undefined)
			document.list_basketww.exp_month.disabled = false;
		if(document.list_basketww.exp_year != undefined)
			document.list_basketww.exp_year.disabled = false;
		return process_cat_control();
	}
	document.list_basketww.joker_vada.checked = false;

	function cargo_ekle(tutar,urun,gelen_money)
	{
		document.getElementById('cargo_kontrol').value = '1';
		var get_comp_prod = wrk_safe_query("obj2_get_comp_prod",'dsn3','1',urun);
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
		document.getElementById('is_commission').value = 0;
		//son kullanici
		document.getElementById('price_standard').value = wrk_round(aa_temp_price_standard*(100 + parseFloat(get_comp_prod.TAX)) / 100);
		document.getElementById('price_standard_kdv').value = aa_temp_price_standard;
		document.getElementById('campaign_id').value = '<cfoutput>#attributes.campaign_id#</cfoutput>';
		<cfif isdefined('attributes.order_from_basket_express') and attributes.order_from_basket_express eq 1>
			<cfoutput>
				document.getElementById('consumer_id').value = '#attributes.consumer_id#';
				document.getElementById('company_id').value = '#attributes.company_id#';
				document.getElementById('partner_id').value = '#attributes.partner_id#';
				document.getElementById('order_from_basket_express').value = 1;
			</cfoutput>
		</cfif>
		satir_gonder.action = '<cfoutput>#request.self#</cfoutput>?fuseaction=objects2.emptypopup_add_basketww_row_camp';
		AjaxFormSubmit('satir_gonder','sale_basket_rows_list',1,'','',sepet_adres_,'sale_basket_rows_list');
		clear_paymethod();
	}

	function get_payment_hesapla(type,paym_type_id)
	{
		var new_sql_1 = 'SELECT S.TAX,CPT.COMMISSION_STOCK_ID,CPT.COMMISSION_PRODUCT_ID,CP.SERVICE_COMM_MULTIPLIER COMMISSION_MULTIPLIER,CPT.FIRST_INTEREST_RATE FROM CREDITCARD_PAYMENT_TYPE CPT,CAMPAIGN_PAYMETHODS CP,STOCKS S WHERE S.STOCK_ID=CPT.COMMISSION_STOCK_ID AND CP.PAYMETHOD_ID = CPT.PAYMENT_TYPE_ID AND CP.CAMPAIGN_ID = <cfoutput>#attributes.campaign_id#</cfoutput> AND CPT.PAYMENT_TYPE_ID = '+paym_type_id;
		return new_sql_1;
	}

	function get_paymnt_type_info_on(siram,indirim)
	{
		my_temp_tutar = document.getElementById('my_temp_tutar').value;
		my_temp_tutar_price_standart = document.getElementById('my_temp_tutar_price_standart').value;
		document.getElementById('kredi_karti_indirim_orani').value = indirim;
		return get_paymnt_type_info(siram,my_temp_tutar,my_temp_tutar_price_standart);
	}
	function get_paymnt_type_info(sira,tutar,tutar_price_standard)
	{
		<cfif get_accounts.recordcount eq 1>
			paym_type_id = document.getElementById('action_to_account_id').value.split(';')[2];
		<cfelse>
			paym_type_id = eval('document.getElementById("action_to_account_id")[sira-1]').value.split(';')[2];
		</cfif>
		
		var new_sql = get_payment_hesapla(<cfif isdefined("attributes.company_id") and len(attributes.company_id)>1<cfelse>0</cfif>,paym_type_id);
		var listParam = "<cfoutput>#attributes.campaign_id#</cfoutput>" + "*" + paym_type_id;
		var get_comp_prod = wrk_safe_query("obj2_get_comp_prod_5",'dsn3',0,listParam);
		bb = get_comp_prod.COMMISSION_MULTIPLIER;
		if(get_comp_prod.COMMISSION_MULTIPLIER != '' && get_comp_prod.COMMISSION_MULTIPLIER > 0 && get_comp_prod.COMMISSION_STOCK_ID != '' && get_comp_prod.COMMISSION_PRODUCT_ID != '')
		{
				document.getElementById('price_catid_2').value = -2;
				var aa_temp = wrk_round((tutar * get_comp_prod.COMMISSION_MULTIPLIER)/100);
				var aa_temp_price_standard = wrk_round((tutar_price_standard * get_comp_prod.COMMISSION_MULTIPLIER)/100);
				document.getElementById('price').value = wrk_round((aa_temp*100)/(100 + parseFloat(get_comp_prod.TAX)));
				document.getElementById('price_old').value = '';
				document.getElementById('istenen_miktar').value = 1;
				document.getElementById('sid').value = get_comp_prod.COMMISSION_STOCK_ID; 
				document.getElementById('price_kdv').value = aa_temp;
				document.getElementById('price_money').value = '<cfoutput>#session_base.money#</cfoutput>';
				document.getElementById('price_standard_money').value = '<cfoutput>#session_base.money#</cfoutput>';
				document.getElementById('prom_id').value = '';
				document.getElementById('prom_discount').value = '';
				document.getElementById('prom_amount_discount').value = '';
				document.getElementById('prom_cost').value = '';
				document.getElementById('prom_free_stock_id').value = '';
				document.getElementById('prom_stock_amount').value = 1;
				document.getElementById('prom_free_stock_amount').value = 1;
				document.getElementById('prom_free_stock_pric')e.value = 0;
				document.getElementById('prom_free_stock_money').value = '';
				document.getElementById('is_commission').value = 1;
				document.getElementById('is_cargo').value = 0;
				document.getElementById('paymethod_id_com').value = paym_type_id;
				//son kullanici
				document.getElementById('price_standard').value = wrk_round((aa_temp_price_standard*100)/(100 + parseFloat(get_comp_prod.TAX)));
				document.getElementById('price_standard_kdv').value = aa_temp_price_standard;
				document.getElementById('campaign_id').value = '<cfoutput>#attributes.campaign_id#</cfoutput>';
				<cfif isdefined('attributes.order_from_basket_express') and attributes.order_from_basket_express eq 1>
					<cfoutput>
						document.getElementById('consumer_id').value = '#attributes.consumer_id#';
						document.getElementById('company_id').value = '#attributes.company_id#';
						document.getElementById('partner_id').value = '#attributes.partner_id#';
						document.getElementById('order_from_basket_express').value = 1;
					</cfoutput>
				</cfif>
				satir_gonder.action = '<cfoutput>#request.self#</cfoutput>?fuseaction=objects2.emptypopup_add_basketww_row_camp';
				AjaxFormSubmit('satir_gonder','sale_basket_rows_list',1,'','',sepet_adres_,'sale_basket_rows_list');//
		}
		else
		{
			<cfif get_accounts.recordcount eq 1>
				if(list_basketww.action_to_account_id.value.split(';')[3] == 9 && list_basketww.action_to_account_id.value.split(';')[5] != undefined && list_basketww.action_to_account_id.value.split(';')[5] > 0)
				{//pos type i alır,Yapıkredi taksitlide işlem olur sadece
					joker_info.style.display='';
					document.list_basketww.joker_vada.checked = true;//joker vada seçili gelsin
				}
				else
				{
					joker_info.style.display='none';
					document.list_basketww.joker_vada.checked = false;
				}
			<cfelse>
				if(eval('document.getElementById("action_to_account_id")[sira-1]').value.split(';')[3] == 9 && eval('document.getElementById("action_to_account_id")[sira-1]').value.split(';')[5] != undefined && eval('document.getElementById("action_to_account_id")[sira-1]').value.split(';')[5] > 0)
				{//pos type i alır,Yapıkredi taksitlide işlem olur sadece
					joker_info.style.display='';
					document.list_basketww.joker_vada.checked = true;//joker vada seçili gelsin
				}
				else
				{
					joker_info.style.display='none';
					document.list_basketww.joker_vada.checked = false;
				}
			</cfif>
			adres_ = '<cfoutput>#request.self#</cfoutput>?fuseaction=objects2.emptypopup_del_basketww_camp&is_delete_info=1&paymethod_id_com=';
			<cfif get_accounts.recordcount eq 1>
				adres_ += eval('document.getElementById("action_to_account_id")').value.split(';')[2];
			<cfelse>
				adres_ += eval('document.getElementById("action_to_account_id")[sira-1]').value.split(';')[2];
			</cfif>
			AjaxPageLoad(adres_,'sale_basket_rows_list','1','Hesaplanıyor!');
		}
		return pay_type_general(paym_type_id);
	}
	
	function clear_pos_row(pay_info)
	{
		<cfif get_accounts.recordcount>
			<cfif get_accounts.recordcount eq 1>
				document.list_basketww.action_to_account_id.checked = false;
			<cfelse>
				<cfoutput query="get_accounts">
					document.list_basketww.action_to_account_id[#currentrow-1#].checked = false;
				</cfoutput>
			</cfif>
		</cfif>
		adres_ = '<cfoutput>#request.self#</cfoutput>?fuseaction=objects2.emptypopup_del_basketww_camp&is_delete_info=1';
		AjaxPageLoad(adres_,'sale_basket_rows_list','1','Hesaplanıyor!');
	}
	function pay_type_general()
	{
		<cfif isDefined("attributes.paymethod_id_com")>
			<cfif isDefined("attributes.campaign_id")>
				var new_sql = 'obj2_get_pay_mtd_3';
			<cfelse>
				var new_sql = 'obj2_get_pay_mtd_4';
			</cfif>
			var listParam = "<cfoutput>#attributes.campaign_id#</cfoutput>" + "*" + <cfoutput>#attributes.paymethod_id_com#</cfoutput>;
			var get_pay_mtd = wrk_safe_query(new_sql,'dsn3',0,listParam);
			if( get_pay_mtd.POS_TYPE == 9 && get_pay_mtd.number_of_instalment != '' && get_pay_mtd.number_of_instalment > 0)
			{//pos type i alır,Yapıkredi taksitlide işlem olur sadece
				joker_info.style.display='';
				document.list_basketww.joker_vada.checked = true;//joker vada seçili gelsin
			}
			else
			{
				joker_info.style.display='none';
				document.list_basketww.joker_vada.checked = false;
			}
		</cfif>
	}
	<cfif isDefined("session.pp")>
		function use_price_standart()
		{
			if(document.list_basketww.is_price_standart.checked)
				price_standart_info.style.display='';
			else
				price_standart_info.style.display='none';
		}
	</cfif>
	
	<cfif get_havale.recordcount>
		function havale_hesapla()
		{
			tum_toplam_kdvli = document.getElementById('tum_toplam_kdvli').value;
			<cfif len(get_havale.first_interest_rate)>
				havale_tutar_ = tum_toplam_kdvli * (1 - <cfoutput>#get_havale.first_interest_rate#</cfoutput> / 100);
			<cfelse>
				havale_tutar_ = tum_toplam_kdvli;
			</cfif>
				document.getElementById('order_amount').value = wrk_round(havale_tutar_,2);
				document.getElementById('order_amount_dsp').value = commaSplit(wrk_round(havale_tutar_,2));
		}
	</cfif>
	
	<cfif get_accounts.recordcount>
		function kredi_karti_hesapla()
		{
			tum_toplam_kdvli = document.getElementById('tum_toplam_kdvli').value;
			tum_toplam_komisyonsuz = document.getElementById('tum_toplam_komisyonsuz').value;
			my_temp_tutar = document.getElementById('my_temp_tutar').value;
			my_temp_tutar_price_standart = document.getElementById('my_temp_tutar_price_standart').value;
			indirim_orani = document.list_basketww.kredi_karti_indirim_orani.value;
			<cfoutput query="get_accounts">
				<cfif len(vft_code)><!--- vft li işlemlerde komisyonlu tutarlar gönderilmez bankaya,vft kendisi hesaplama yapar --->
						main_total = tum_toplam_komisyonsuz;
					<cfif len(commission_multiplier) and commission_multiplier gt 0>
						main_total_dsp = parseFloat(tum_toplam_komisyonsuz) + parseFloat(tum_toplam_komisyonsuz * #commission_multiplier#/100);
					<cfelse>
						main_total_dsp = main_total;
					</cfif>
				<cfelseif len(commission_multiplier) and commission_multiplier gt 0>
					main_total_dsp = parseFloat(tum_toplam_komisyonsuz) + parseFloat(tum_toplam_komisyonsuz * #commission_multiplier#/100);
					main_total = main_total_dsp;
				<cfelse>
					main_total = tum_toplam_komisyonsuz;
					main_total_dsp = tum_toplam_komisyonsuz;
				</cfif>
				<cfif len(number_of_instalment) and number_of_instalment neq 0>
					taksit_tutar = main_total_dsp / #number_of_instalment#;
				<cfelse>
					taksit_tutar = main_total_dsp;
				</cfif>
				<cfif len(first_interest_rate)>
					main_total = main_total - parseFloat(tum_toplam_komisyonsuz * #first_interest_rate#/100);
					main_total_dsp = main_total;
					<cfif len(number_of_instalment) and number_of_instalment neq 0>
						taksit_tutar = main_total_dsp / #number_of_instalment#;
					<cfelse>
						taksit_tutar = main_total_dsp;
					</cfif>
				</cfif>
				<cfif (isdefined("attributes.is_view_multiplier") and attributes.is_view_multiplier eq 1) or not isdefined("attributes.is_view_multiplier")>
					kredi_taksit_tutar_#currentrow#.innerHTML = <cfif len(number_of_instalment) and number_of_instalment neq 0>'#number_of_instalment# x' + </cfif> commaSplit(wrk_round(taksit_tutar));
				</cfif>
					kredi_toplam_tutar_#currentrow#.innerHTML = commaSplit(wrk_round(main_total_dsp));
					<cfif isDefined("attributes.paymethod_id_com") and attributes.paymethod_id_com eq payment_type_id>
						document.getElementById('sales_credit').value = wrk_round(main_total);
					<cfelse>
						document.getElementById('sales_credit').value = wrk_round(tum_toplam_kdvli);
					</cfif>
					document.getElementById('sales_credit_dsp').value =  commaSplit(wrk_round(tum_toplam_kdvli));
			</cfoutput>
			if(indirim_orani > 0)
			{
				tutar1 = document.getElementById('sales_credit').value;
				tutar2 = filterNum(document.getElementById('sales_credit_dsp').value);
				document.getElementById('sales_credit').value = wrk_round(tutar1 - (tutar1 * indirim_orani / 100));
				document.getElementById('sales_credit_dsp').value = commaSplit(wrk_round(tutar2 - (tutar2 * indirim_orani / 100)));
			}
		}
	</cfif>
	
	function risk_hesapla()
	{
		<cfif ((get_company_risk.recordcount and get_company_risk.bakiye lt 0) or (get_credit.recordcount and get_credit.open_account_risk_limit gt 0)) and get_company_bakiye.total_bakiye lte 0>
			risk_table.style.display = 'none';
			risk_tutar_ = <cfoutput>(#get_company_risk.total_risk_limit# - #get_company_risk.bakiye# - (#get_company_risk.cek_odenmedi# + #get_company_risk.senet_odenmedi# + #get_company_risk.cek_karsiliksiz# + #get_company_risk.senet_karsiliksiz#))</cfoutput>;
			kalan_risk_ = parseFloat(risk_tutar_ - tum_toplam_kdvli);
		<cfelse>
			kalan_risk_ = -1;
		</cfif>
		if(kalan_risk_ > 0)
		{
			<cfif get_order_bakiye.recordcount and len(get_order_bakiye.nettotal)>
				kalan_risk_ = parseFloat(kalan_risk_ - <cfoutput>#get_order_bakiye.nettotal#</cfoutput>);
			</cfif>
			if(kalan_risk_ > 0)
			{
				<cfif ((get_company_risk.recordcount and get_company_risk.bakiye lt 0) or (get_credit.recordcount and get_credit.open_account_risk_limit gt 0)) and get_company_bakiye.total_bakiye lte 0>
					risk_table.style.display = '';
					document.getElementById('kalan_risk_info').value = kalan_risk_;
					goster(risk_table);
				<cfelse>
					document.getElementById('kalan_risk_info').value = 0;
				</cfif>
			}
		}
		<cfif isdefined("attributes.is_dsp_risk_info") and attributes.is_dsp_risk_info eq 1>
			toplam_limit_hesapla();
		</cfif>
	}
	
	pay_type_general();
	//window.defaultStatus="Bu sayfada SSL Kullanılmaktadır."
</script>
<form action="" method="post" name="satir_gonder">
	<input type="hidden" name="price_catid_2" id="price_catid_2" value="">
	<input type="hidden" name="istenen_miktar" id="istenen_miktar" value="">
	<input type="hidden" name="sid" id="sid" value="">
	<input type="hidden" name="price" id="price" value="">
	<input type="hidden" name="price_old" id="price_old" value="">
	<input type="hidden" name="price_kdv" id="price_kdv" value="">
	<input type="hidden" name="price_money" id="price_money" value="">
	<input type="hidden" name="prom_id" id="prom_id" value="">
	<input type="hidden" name="is_cargo" id="is_cargo" value="0">
	<input type="hidden" name="prom_discount" id="prom_discount" value="">
	<input type="hidden" name="prom_amount_discount" id="prom_amount_discount" value="">
	<input type="hidden" name="prom_cost" id="prom_cost" value="">
	<input type="hidden" name="prom_free_stock_id" id="prom_free_stock_id" value="">
	<input type="hidden" name="prom_stock_amount" id="prom_stock_amount" value="1">
	<input type="hidden" name="prom_free_stock_amount" id="prom_free_stock_amount" value="1">
	<input type="hidden" name="prom_free_stock_price" id="prom_free_stock_price" value="0">
	<input type="hidden" name="prom_free_stock_money" id="prom_free_stock_money" value="">
	<input type="hidden" name="is_commission" id="is_commission" value="0">
	<input type="hidden" name="paymethod_id_com" id="paymethod_id_com" value="0">
	<input type="hidden" name="price_standard" id="price_standard" value="">
	<input type="hidden" name="price_standard_kdv" id="price_standard_kdv" value="">
	<input type="hidden" name="price_standard_money" id="price_standard_money" value="">
	<input type="hidden" name="campaign_id" id="campaign_id" value="">
</form> 

