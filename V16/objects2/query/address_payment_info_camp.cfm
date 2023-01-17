<table width="100%" border="0" cellspacing="0" cellpadding="0" align="center">
  <tr>
	<td class="headbold" height="35">Teslimat ve Ödeme Bilgileri</td>
  </tr>
</table>
<table width="100%" border="0" cellpadding="0" cellspacing="0" align="center">
  <tr class="color-header">
    <td>
	<table width="100%" border="0" cellpadding="2" cellspacing="1">
	  <tr class="color-row">
		<td valign="top">
			<table>			  
			  	<tr>
					<td class="txtboldblue">Sevk Yöntemini Seçiniz</td>
			  	</tr>
			  	<tr style="display:none">
					<td>
					<cf_workcube_process is_upd='0' process_cat_width='170' is_detail='0'>
					<input type="hidden" name="deliverdate" id="deliverdate" value="<cfoutput>#dateformat(now(),'dd/mm/yyyy')#</cfoutput>" validate="eurodate">
					</td>
			  	</tr>
			  	<tr>
					<td>
					<select name="ship_method_id" id="ship_method_id" style="width:170px;">
						<option value="">Sevk Yöntemi Seçiniz</option>
						<cfoutput query="get_shipmethod">
						<option value="#SHIP_METHOD_ID#" <cfif SHIP_METHOD_ID eq GET_CREDIT.SHIP_METHOD_ID>selected</cfif>>#SHIP_METHOD#</option>
						</cfoutput>
					</select>
				  	</td>
			  </tr>
			  <tr>
			  	<td class="txtboldblue">Teslim Adresi Seçiniz</td>
			  </tr>
 			<cfoutput query="GET_ADDRESS">
			  <tr>
			  	<td valign="top">
					<input type="radio" name="ship_address_row" id="ship_address_row" value="#currentrow#" onClick="yeni_adres(this)" <cfif currentrow eq 1>checked</cfif>>
					<input type="hidden" name="ship_address#currentrow#" id="ship_address#currentrow#" value="#ADDRESS# #POSTCODE# #SEMT# <cfif len(COUNTY)>#listgetat(county_name_list,listfind(county_id_list,COUNTY,','),',')# / </cfif><cfif len(CITY)>#listgetat(city_name_list,listfind(city_id_list,CITY,','),',')#</cfif> <cfif len(COUNTRY)>#listgetat(country_name_list,listfind(country_id_list,COUNTRY,','),',')#</cfif>">
					<input type="hidden" name="ship_address_city#currentrow#" id="ship_address_city#currentrow#" value="#CITY#">
					<input type="hidden" name="ship_address_county#currentrow#" id="ship_address_county#currentrow#" value="#COUNTY#">
					#ADDRESS# #POSTCODE# #SEMT# <cfif len(COUNTY)>#listgetat(county_name_list,listfind(county_id_list,COUNTY,','),',')# / </cfif><cfif len(CITY)>#listgetat(city_name_list,listfind(city_id_list,CITY,','),',')#</cfif> <cfif len(COUNTRY)>#listgetat(country_name_list,listfind(country_id_list,COUNTRY,','),',')#</cfif>
				</td>
			  </tr>
			  </cfoutput>
			  <tr>
			  	<td valign="top">
					<input type="radio" name="ship_address_row" id="ship_address_row" value="0" onClick="yeni_adres(this)">
					&nbsp;&nbsp;&nbsp;Yeni Teslimat Adresi Girin
				</td>
			  </tr>
			  <tr>
			  	<td valign="top">
					<table id="shipaddress0" style="display:none">
					  <tr>
						<td>Ülke</td>
						<td>
						  <select name="ship_address_country0" id="ship_address_country0" onChange="remove_adress('1');" style="width:150px;">
						  <option value="">Seçiniz</option>
						  <cfoutput query="GET_COUNTRY_ALL">
							<option value="#country_id#,#country_name#" <cfif country_id eq 1>selected</cfif>>#country_name#</option>
						  </cfoutput>
						  </select>			
						</td>
					  </tr>
					  <tr>
						<td>İl</td>
						<td>
						<select name="ship_address_city0" id="ship_address_city0" style="width:150px;" onChange="remove_adress('2');">
							<option value="">Seçiniz</option>
							<cfoutput query="get_city_all">
							<option value="#CITY_ID#,#CITY_NAME#">#CITY_NAME#</option>
							</cfoutput>
						</select>
						</td>
					  </tr>
					  <tr> 
						<td>İlçe</td>
						<td><input type="hidden" name="ship_address_county0" id="ship_address_county0" readonly="">
						  <input type="text" name="ship_address_county_name0" id="ship_address_county_name0" value="" maxlength="30" style="width:150px;" readonly tabindex="12">
						  <a href="javascript://" onClick="pencere_ac();"><img src="/images/plus_list.gif" border="0" align="absmiddle"></a>
						</td>
					  </tr>
					  <tr>
						<td>Semt</td>
						<td><input type="text" name="ship_address_semt0" id="ship_address_semt0" value="" maxlength="50" style="width:150px;"></td>
					  </tr>
					  <tr>
						<td>Posta Kodu</td>
						<td><input type="text" name="ship_address_postcode0" id="ship_address_postcode0" value="" style="width:150px;" maxlength="5"></td>
					  </tr>
					  <tr> 
						<td valign="top">Adres</td>
						<td><textarea name="ship_address0" id="ship_address0" style="width:200px;height:50px;"></textarea></td>
					  </tr>
					</table>
				</td>
			  </tr>
			  <tr>
			  	<td class="txtboldblue">Ödeme Yöntemi Seçiniz</td>
			  </tr>
			  <cfif isDefined("attributes.company_id")>
				  <cfif GET_HAVALE.RECORDCOUNT>
				  <tr>
					<td class="txtbold">
					<input type="hidden" name="paymethod_id_1" id="paymethod_id_1" value="<cfoutput>#GET_HAVALE.PAYMETHOD_ID#,#GET_HAVALE.DUE_DAY#</cfoutput>">
					<input type="radio" name="paymethod_type" id="paymethod_type" value="1" onClick="odemeyontemi(1);">
					<cfoutput>#GET_HAVALE.PAYMETHOD#</cfoutput>
					</td>
				  </tr>
				  </cfif>
				   <tr>
					<td>
					<table id="pay_type_1"> <!--- style="display:none;" --->
					  <tr>
						<cfquery name="GET_PROCESS_CAT_TALIMAT" datasource="#dsn3#">
							SELECT PROCESS_CAT_ID FROM SETUP_PROCESS_CAT WHERE IS_PARTNER = 1 AND PROCESS_TYPE = 251
						</cfquery>
						<input type="hidden" name="process_cat_talimat" id="process_cat_talimat" value="<cfoutput>#GET_PROCESS_CAT_TALIMAT.PROCESS_CAT_ID#</cfoutput>">
						<input type="hidden" name="process_type_talimat" id="process_type_talimat" value="251">
						<td>Banka Hesaplarımız</td>
						<td>
						<select name="account_id" id="account_id" style="width:200px;">
							<cfoutput query="GET_BANK">
							<option value="#account_id#-#account_currency_id#">#ACCOUNT_NAME#</option>
							</cfoutput>
						</select>
						</td>
					  </tr>
					  <tr>
						<td>Havale/EFT Tutarı</td>
						<td>
						<input type="hidden" name="company_id" id="company_id" value="<cfif isdefined("session.pp.company_id")><cfoutput>#session.pp.company_id#</cfoutput><cfelse></cfif>">
						<input type="hidden" name="PAYM_DATE" id="PAYM_DATE" value="<cfoutput>#dateformat(now(),'dd/mm/yyyy')#</cfoutput>" validate="eurodate">
						<input type="hidden" name="ACT_DATE" id="ACT_DATE" value="<cfoutput>#dateformat(now(),'dd/mm/yyyy')#</cfoutput>"validate="eurodate">
						<input type="hidden" name="ORDER_AMOUNT" id="ORDER_AMOUNT" value="<cfoutput>#wrk_round(tum_toplam_kdvli)#</cfoutput>" onkeyup="return(FormatCurrency(this,event));" style="width:125px;" class="moneybox" readonly >
						<input type="text" name="ORDER_AMOUNT_DSP" id="ORDER_AMOUNT_DSP" value="<cfoutput>#TLFormat(tum_toplam_kdvli)#</cfoutput>" onkeyup="return(FormatCurrency(this,event));" style="width:125px;" class="moneybox" readonly >
						</td>
					 </tr>
					</table>
				  </td>
				  </tr>
			 </cfif>
			  <tr>
			  	<td class="txtbold"><input type="radio" name="paymethod_type" id="paymethod_type" value="2" onClick="odemeyontemi(2);"> Kredi Kartı İle Ödemek İstiyorum</td>
			  </tr>
			  <tr>
			  	<td>
				<table id="pay_type_2" style="display:none;">
				<tr>
					<td valign="top">
					<table>
						<tr class="txtboldblue">
							<td width="25"></td>
							<td width="140">Kart</td>
							<td width="70" align="right" style="text-align:right;">Taksit Tutarı</td>
							<td width="90" align="right" style="text-align:right;">Toplam Tutar</td>
					<cfif get_accounts.recordcount>
					<cfoutput query="get_accounts">
						<cfif len(NUMBER_OF_INSTALMENT) and NUMBER_OF_INSTALMENT neq 0><cfset taksit_tutar = tum_toplam_kdvli / NUMBER_OF_INSTALMENT><cfelse><cfset taksit_tutar = tum_toplam_kdvli></cfif>
							<tr>
								<td align="center"><input type="radio" name="action_to_account_id" id="action_to_account_id" onClick="get_paymnt_type_info(#currentrow#,#my_temp_tutar#,#my_temp_tutar_price_standard#);" value="#ACCOUNT_ID#;#ACCOUNT_CURRENCY_ID#;#PAYMENT_TYPE_ID#;#POS_TYPE#;#NUMBER_OF_INSTALMENT#" <cfif isDefined("attributes.paymethod_id_com") and attributes.paymethod_id_com eq PAYMENT_TYPE_ID>checked</cfif>></td><!--- eleman sırası değişmesin AE --->
								<td>#CARD_NO#</td>
								<td align="right" style="text-align:right;">#TLFormat(taksit_tutar)#</td>
								<td align="right" style="text-align:right;">#TLFormat(tum_toplam_kdvli)#</td>
							</tr>
					</cfoutput>
					</cfif>
					</table>
					<table>
						<tr>
							<cfquery name="GET_PROCESS_CAT_TAHSILAT" datasource="#dsn3#">
								SELECT PROCESS_CAT_ID FROM SETUP_PROCESS_CAT WHERE IS_PARTNER = 1 AND PROCESS_TYPE = 241
							</cfquery>
							<input type="hidden" name="process_cat" id="process_cat" value="<cfoutput>#GET_PROCESS_CAT_TAHSILAT.PROCESS_CAT_ID#</cfoutput>">
							<input type="hidden" name="process_type" id="process_type" value="251">
							<input type="hidden" name="action_from_company_id" id="action_from_company_id" value="<cfif isdefined("session.pp.company_id")><cfoutput>#session.pp.company_id#</cfoutput><cfelse><cfoutput>#session.ww.userid#</cfoutput></cfif>">
							<input type="hidden" name="action_date" id="action_date" value="<cfoutput>#dateformat(now(),'dd/mm/yyyy')#</cfoutput>">
							<td width="80">Kart No</td>
							<td>
								<cfsavecontent variable="message">Lütfen Geçerli Kredi Kartı Numarasını Giriniz!</cfsavecontent>
								<cfinput type="text" name="card_no" validate="creditcard" style="width:145px;" maxlength="16" message="#message#" autocomplete="off">
							</td>
						</tr>
						<tr>
							<td>Kart Hamili</td>
							<td><input name="card_owner" id="card_owner" type="text" style="width:145px;" maxlength="30"></td>
						</tr>
						<tr>
							<td>CVV-Son Kullanım Tarihi</td>
							<td>
								<cfinput name="cvv_no" type="text" style="width:50px;" maxlength="3" message="CVV No Giriniz" autocomplete="off">
								<select name="exp_month" id="exp_month" style="width:40px;">
									<cfloop from="1" to="12" index="k">
										<cfoutput>
										<option value="#k#">#k#</option>
										</cfoutput> 
									</cfloop>
								</select>
								<select name="exp_year" id="exp_year" style="width:50px;">
									<cfloop from="2006" to="2050" index="i">
										<cfoutput>
										<option value="#i#">#i#</option>
										</cfoutput> 
									</cfloop>
								</select>
							</td>
						</tr>
						<tr>
							<td>Toplam Tutar</td>
							<td>
								<input type="hidden" name="sales_credit" id="sales_credit" value="<cfoutput>#wrk_round(tum_toplam_kdvli)#</cfoutput>">
								<input type="text" name="sales_credit_dsp" id="sales_credit_dsp" style="width:145px;" readonly class="moneybox" value="<cfoutput>#TLFormat(tum_toplam_kdvli)#</cfoutput>">
							</td>
						</tr>
						<cfif isDefined("session.pp")>
							<tr>
								<td><input name="is_price_standart" id="is_price_standart" type="checkbox" onClick="use_price_standart();">Son Kullanıcı Fiyatı</td>
								<td style="display:none" id="price_standart_info">
									<input type="hidden" name="price_standart_last" id="price_standart_last" value="">
									<input type="text" name="price_standart_dsp" id="price_standart_dsp" style="width:145px" class="moneybox" onkeyup="return(FormatCurrency(this,event));" value="<cfoutput>#TLFormat(tum_toplam_kdvli_ps)#</cfoutput>">
								</td>
							</tr>
						</cfif>
						<tr style="display:none" id="joker_info">
							<td></td>
							<td><input name="joker_vada" id="joker_vada" type="checkbox" checked="checked">Joker Vada Kullanmak İstiyorum</td>
						</tr>
					</table>
					</td>
				</tr>
				</table>
				</td>
			  </tr>
			 <cfset kalan_risk = 0>
			  <cfif GET_COMPANY_RISK.recordcount>
				<cfset kalan_risk = GET_COMPANY_RISK.TOTAL_RISK_LIMIT - GET_COMPANY_RISK.BAKIYE - (GET_COMPANY_RISK.CEK_ODENMEDI + GET_COMPANY_RISK.SENET_ODENMEDI + GET_COMPANY_RISK.CEK_KARSILIKSIZ + GET_COMPANY_RISK.SENET_KARSILIKSIZ) - wrk_round(tum_toplam_kdvli)>
			  <cfelse>
				<cfset kalan_risk = - wrk_round(tum_toplam_kdvli)>
			  </cfif>
			  <cfif GET_ORDER_BAKIYE.recordcount and len(GET_ORDER_BAKIYE.NETTOTAL)>
				  <cfset kalan_risk = kalan_risk - GET_ORDER_BAKIYE.NETTOTAL>
			  </cfif>
			<cfif kalan_risk gt 0>
				<tr>
				<td colspan="2" class="txtbold"><input type="radio" name="paymethod_type" id="paymethod_type" value="3" onClick="odemeyontemi(3);"> Risk Limitimi Kullanmak İstiyorum</td>
				</tr>
				<tr>
				<td colspan="2">
				<!--- <table id="pay_type_3" style="display:none;"> kapatıldı AE
				  <tr>
					<td>Ödeme Yönteminiz</td>
					<td>
					<select name="paymethod_id_3" style="width:170px;">
					  <option value="">Seçiniz</option>
					  <cfoutput query="get_paymethod">
					  <option value="#PAYMETHOD_ID#,#DUE_DAY#" <cfif PAYMETHOD_ID eq GET_CREDIT.PAYMETHOD_ID>selected</cfif>>#PAYMETHOD#</option>
					  </cfoutput>
					</select>
					</td>
				  </tr>
				</table> --->
				</td>
				</tr>
			  </cfif>
			  <tr>
				<td valign="top" class="txtboldblue">
				<br/><br/>Notlar-Açıklama</td>
			  </tr>
			  <tr>
				<td><textarea style="width:300px;height:40px;" name="order_detail" id="order_detail"></textarea></td>
			  </tr>
			  <tr>
				<td height="35"><cf_workcube_buttons is_upd='0' is_cancel='0' insert_info='Siparişi Bitir' add_function='kontrol()'></td>
			  </tr>
			</table>
		</td>
		</tr>
	</table>
	</td>
  </tr>
</table>
