<cf_get_lang_set module_name="invent"><!--- sayfanin en altinda kapanisi var --->
<cfif isDefined("attributes.iid")>
	<cfset attributes.action_id = attributes.iid>
</cfif>
<cfparam name="attributes.old_value" default="0">
<cfquery name="GET_INVENTORY" datasource="#DSN3#">
	SELECT
		INVENTORY.ENTRY_DATE,
		INVENTORY.AMOUNT,
		INVENTORY_ROW.PROCESS_TYPE,
		INVENTORY_ROW.PAPER_NO,
		INVENTORY_ROW.QUANTITY,
		INVENTORY_ROW.INVENTORY_ID
	FROM
		INVENTORY,
		INVENTORY_ROW
	WHERE
		INVENTORY_ROW.INVENTORY_ID = INVENTORY.INVENTORY_ID AND
		INVENTORY_ROW.INVENTORY_ID = #attributes.action_id#
</cfquery>
<cfquery name="GET_AMORTIZATION" datasource="#DSN3#">
	SELECT
		INVENTORY_AMORTIZATON.*,
		INVENTORY_AMORTIZATION_MAIN.*,
		INVENTORY.AMOUNT,
		INVENTORY.LAST_INVENTORY_VALUE
	FROM
		INVENTORY_AMORTIZATON,
		INVENTORY_AMORTIZATION_MAIN,
		INVENTORY
	WHERE
		INVENTORY_AMORTIZATON.INVENTORY_ID = INVENTORY.INVENTORY_ID AND
		INVENTORY_AMORTIZATON.INVENTORY_ID = #attributes.action_id# AND
		INVENTORY_AMORTIZATION_MAIN.INV_AMORT_MAIN_ID=INVENTORY_AMORTIZATON.INV_AMORT_MAIN_ID
	ORDER BY INVENTORY_AMORTIZATION_MAIN.ACTION_DATE
</cfquery>
<cfquery name="GET_INVENT" datasource="#DSN3#">
	SELECT * FROM INVENTORY WHERE INVENTORY_ID = #attributes.action_id#
</cfquery>
<cfif GET_INVENT.recordcount>
<br/><br/>
<table align="center">
	<tr>
		<td><h4><cf_get_lang_main no='119.SABİT KIYMETLER'> (<cf_get_lang_main no='1190.DEMİRBAŞ'>)</h4></td>
	</tr>
</table>
<br/><br/>
<table align="center">
	<tr>
		<td>
		<table>
			<tr>
				<td width="110" class="txtbold"><cf_get_lang_main no='1466.Demirbaş No'> : </td>
				<td width="70"><cfoutput>#get_invent.inventory_number#</cfoutput></td>
				<td width="140" class="txtbold"><cf_get_lang_main no='219.Ad'> : </td>
				<td width="150"><cfoutput>#get_invent.inventory_name#</cfoutput></td>
				<td width="140" class="txtbold"><cf_get_lang no='42.Alacak Muhasebe Kodu'> : </td>
				<td width="60"><cfoutput>#get_invent.claim_account_id#</cfoutput></td>
			</tr>
			<tr>
				<td class="txtbold"><cf_get_lang_main no='223.Miktar'> : </td>
				<td><cfoutput>#get_invent.quantity#</cfoutput></td>
				<td class="txtbold"><cf_get_lang_main no='1737.Toplam Tutar'> : </td>
				<td><cfoutput>#TLFormat(get_invent.quantity * get_invent.amount)#</cfoutput></td>
				<td class="txtbold"><cf_get_lang no='40.Borçlu Muhasebe Kodu'> : </td>
				<td><cfoutput>#get_invent.debt_account_id#</cfoutput></td>
			</tr>
			<tr>
				<td class="txtbold"><cf_get_lang_main no='216.Giriş Tarihi'> : </td>
				<td><cfoutput>#dateformat(get_invent.entry_date,dateformat_style)#</cfoutput></td>
					<cfquery name="GET_ACCOUNT_NAME" datasource="#DSN2#">
						SELECT ACCOUNT_NAME, ACCOUNT_CODE FROM ACCOUNT_PLAN WHERE ACCOUNT_CODE = '#get_invent.account_id#'
					</cfquery>
				<td class="txtbold"><cf_get_lang_main no='1399.Muhasebe Kodu'> : </td>
				<td><cfoutput>#get_account_name.account_code# - #get_account_name.account_name#</cfoutput></td>
				<td class="txtbold"><cf_get_lang no='74.Hesaplama Dönemi'> : </td>
				<td><cfoutput>#get_invent.account_period#</cfoutput></td>
			</tr>
			<tr>
				<td class="txtbold"><cf_get_lang no='22.Amortisman Oranı'> : </td>
				<td><cfoutput>#get_invent.amortizaton_estimate#</cfoutput></td>
				<td class="txtbold"><cf_get_lang_main no='1623.Amortisman Yöntemi'> : </td>
				<td><cfif get_invent.amortizaton_method eq 0><cf_get_lang_main no='1624.Azalan Bakiye Üzerinden'>
					<cfelseif get_invent.amortizaton_method eq 1><cf_get_lang_main no='1625.Sabit Miktar Üzeriden'>
					<cfelseif get_invent.amortizaton_method eq 2><cf_get_lang_main no='1626.Hızlandırılmış Azalan Bakiye'>
					<cfelse><cf_get_lang_main no='1627.Hızlandırılmış Sabit Değer'></cfif>
				</td>
			</tr>
		</table>
		<br/><br/><br/>
		<table>
			<tr>
				<td class="txtbold"><font size="2"><cf_get_lang no='51.Amortisman Değişimleri'></font></td>
			</tr>
		</table>
		<table>
			<tr>
				<td width="40" class="txtbold" bgcolor="CCCCCC"><cf_get_lang_main no='75.No'></td>
				<td width="40" class="txtbold" bgcolor="CCCCCC"><cf_get_lang_main no='1043.Yıl'></td>
				<td width="160" class="txtbold" bgcolor="CCCCCC"><cf_get_lang no="34.Amotrisman Dönemi"></td>
				<td width="140" class="txtbold" bgcolor="CCCCCC"><cf_get_lang no='22.Amortisman Oranı'></td>
				<td width="140" class="txtbold" bgcolor="CCCCCC"><cf_get_lang no='80.Önceki Değer'></td>
				<td width="140" class="txtbold" bgcolor="CCCCCC"><cf_get_lang no='53.Amortisman Tutarı'></td>
			</tr>
			<cfset toplam=0>
			<cfif get_amortization.recordcount>
			<cfoutput query="get_amortization">
			<tr>
				<td>#currentrow#</td>
				<td>#amortizaton_year#</td>
				<td><cfif amortizaton_method eq 0><cf_get_lang_main no='1624.Azalan Bakiye Üzerinden'><cfelseif amortizaton_method eq 1><cf_get_lang_main no='1625.Sabit Miktar Üzeriden'><cfelseif amortizaton_method eq 2><cf_get_lang_main no='1626.Hızlandırılmış Azalan Bakiye'><cfelse><cf_get_lang_main no='1627.Hızlandırılmış Sabit Değer'></cfif></td>
				<td>#amortizaton_estimate#</td>
				<td style="text-align:right;"><cfif attributes.old_value eq 0>#TLFormat(amount)#<cfelse>#TLFormat(attributes.old_value)#</cfif></td>
				<td style="text-align:right;">#TLFormat(amortizaton_inv_value)#</td>
			</tr>
			<tr>
				<td colspan="5" class="txtbold" style="text-align:right;"><cf_get_lang no='39.Toplam Dönemsel Amortisman Tutarı'></td>
					<cfif len(periodic_amort_value)>
						<cfset toplam=toplam+periodic_amort_value>
					</cfif>
				<td class="txtbold" style="text-align:right;"><cfoutput>#Tlformat(toplam)#</cfoutput></td>
			</tr>
			</cfoutput>
			</cfif>
		</table>
		<br/><br/><br/>
		<table>
			<tr>
				<td class="txtbold"><font size="2"><cf_get_lang no='98.Alış - Satış Stok İşlemleri'></font></td>
			</tr>
		</table>
		<table>
			<tr>
				<td width="60" class="txtbold" bgcolor="CCCCCC"><cf_get_lang_main no='330.Tarih'></td>
				<td width="140" class="txtbold" bgcolor="CCCCCC"><cf_get_lang_main no='388.İşlem Tipi'></td>
				<td width="120" class="txtbold" bgcolor="CCCCCC"><cf_get_lang_main no='468.Belge No'></td>
				<td width="100" class="txtbold" bgcolor="CCCCCC"><cf_get_lang_main no='223.Miktar'></td>
				<td width="120" class="txtbold" bgcolor="CCCCCC"><cf_get_lang_main no='226.Birim Fiyat'></td>
				<td width="120" class="txtbold" bgcolor="CCCCCC"><cf_get_lang_main no='261.Tutar'></td>
			</tr>
			<tr>
			<cfset toplam_2=0>
			<cfif get_inventory.recordcount>
			<cfoutput query="get_inventory">
				<td>#dateformat(entry_date,dateformat_style)#</td>
				<td>#get_process_name(process_type)#</td>
				<td>#paper_no#</td>
				<td>#quantity#</td>
				<td style="text-align:right;">#TLFormat(amount)#</td>
				<td style="text-align:right;">#TLFormat(quantity * amount)#</td>
			</tr>
			<tr>
				<td colspan="5" class="txtbold" style="text-align:right;"><cf_get_lang_main no='1715.Toplam Stok'><cf_get_lang_main no='470.İşlem Tutarı'></td>
					<cfif len((quantity * amount))>
						<cfset toplam_2=toplam_2+(quantity * amount)>
					</cfif>
				<td class="txtbold" style="text-align:right;"><cfoutput>#Tlformat(toplam_2)#</cfoutput></td>
			</tr>
			</cfoutput>
			</cfif>
		</table>
		</td>
	</tr>
</table>
</cfif>
<cf_get_lang_set module_name="#lcase(listgetat(attributes.fuseaction,1,'.'))#"><!--- sayfanin en ustunde acilisi var --->
