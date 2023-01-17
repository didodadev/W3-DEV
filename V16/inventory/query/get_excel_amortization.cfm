<cfparam name="attributes.last_amortization_year" default="">
<cfparam name="attributes.old_value" default=0>
<cfquery name="GET_DETAIL" datasource="#dsn3#">
	SELECT
		DETAIL,
		PROCESS_TYPE,
		ACTION_DATE,
		PROCESS_CAT,
		RECORD_EMP,
		RECORD_DATE,
		UPDATE_EMP,
		UPDATE_DATE
	FROM
		INVENTORY_AMORTIZATION_MAIN
	WHERE
		INV_AMORT_MAIN_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="1">		
</cfquery>
<cfquery name="GET_INVENT" datasource="#dsn3#">
	SELECT
		DISTINCT
		INVENTORY_AMORTIZATON.*,
		INVENTORY.LAST_INVENTORY_VALUE,
		INVENTORY.ACCOUNT_ID,
		INVENTORY.INVENTORY_NUMBER,
		INVENTORY.INVENTORY_NAME,
		INVENTORY.PROJECT_ID,
		INVENTORY.EXPENSE_ITEM_ID,
		INVENTORY.EXPENSE_CENTER_ID,
		ISNULL(INVENTORY_AMORTIZATON.INV_QUANTITY,INVENTORY.QUANTITY) QUANTITY,
		INVENTORY.AMOUNT,
		INVENTORY_ROW.STOCK_IN,
        INVENTORY.ACCOUNT_ID
	FROM
		INVENTORY,
		INVENTORY_ROW,
		INVENTORY_AMORTIZATON
	WHERE
		INVENTORY.INVENTORY_ID=INVENTORY_ROW.INVENTORY_ID AND 
		INVENTORY_ROW.STOCK_IN > 0 AND 
		INVENTORY.INVENTORY_ID=INVENTORY_AMORTIZATON.INVENTORY_ID AND
		INVENTORY_AMORTIZATON.INV_AMORT_MAIN_ID=<cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.inv_id#">
</cfquery>
<cfset inv_list = valuelist(get_invent.inventory_id)>

<cfset filename = "#createuuid()#">
<cfheader name="Expires" value="#Now()#">
<cfcontent type="application/vnd.msexcel;charset=utf-8">
<cfheader name="Content-Disposition" value="attachment; filename=#filename#.xls">
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<cfsavecontent variable="excel_icerik">
	<cfif get_invent.recordcount>
		<table class="detail_basket_list">
			<thead>	
				<tr>
					<th><cf_get_lang_main no='75.No'></th>
					<th><cf_get_lang_main no='1466.Demirbaş No'></th>
					<th width="75"><cf_get_lang_main no ='217.Açıklama'></th>
                    <th width="120"><cf_get_lang_main no ='1399.Muhasebe Kodu'></th>
					<th><cf_get_lang_main no ='223.Mikt'></th>
					<th width="120"><cf_get_lang no='62.Borçlu Hesap'></th>
					<th width="120"><cf_get_lang dictionary_id='34115.Alacaklı Hesap'></th>
					<th width="100"><cf_get_lang_main no='4.Proje'></th>
					<th width="125"><cf_get_lang_main no='1048.Masraf Merkezi'></th>
					<th width="125"><cf_get_lang_main no='822.Bütçe Kalemi'></th>
					<cfif isDefined("attributes.last_amortization_year") and len(attributes.last_amortization_year)>
						<th><cf_get_lang no='60.Son D Yılı'></th>
					</cfif>
					<th><cf_get_lang_main no ='1194.Amort Yöntemi'></th>
					<th nowrap="nowrap"><cf_get_lang no ='15.İlk Değer'></th>
					<th nowrap="nowrap"><cf_get_lang no ='16.Son Değer'></th>
					<th nowrap="nowrap"><cf_get_lang no ='22.Amortisman Oranı'></th>
					<th><cf_get_lang no ='53.Amortisman Tutarı'></th>
					<th><cf_get_lang no='74.Hesaplama Dönemi'>(<cf_get_lang_main no ='1193.Periyod/Yıl)'>)</th>
					<th><cf_get_lang no='59.Dönemsel Amortisman Tutarı'></th>
					<th><cf_get_lang no='58.Toplam Ayrılan Amortisman Tutarı'></th>
					<th><cf_get_lang no='57.Yeni Değer'></th>
				</tr>
			</thead>
			<cfset item_id_list=''>
			<cfset expense_id_list=''>
			<cfoutput query="get_invent">
				<cfif len(EXPENSE_ITEM_ID) and not listfind(item_id_list,EXPENSE_ITEM_ID)>
					<cfset item_id_list=listappend(item_id_list,EXPENSE_ITEM_ID)>
				</cfif>
				<cfif len(EXPENSE_CENTER_ID) and not listfind(expense_id_list,EXPENSE_CENTER_ID)>
					<cfset expense_id_list=listappend(expense_id_list,EXPENSE_CENTER_ID)>
				</cfif>
			</cfoutput>
			<cfif len(item_id_list)>
				<cfset item_id_list=listsort(item_id_list,"numeric","ASC",",")>
				<cfquery name="get_exp_detail" datasource="#dsn2#">
					SELECT EXPENSE_ITEM_NAME,ACCOUNT_CODE FROM EXPENSE_ITEMS WHERE EXPENSE_ITEM_ID IN (#item_id_list#) ORDER BY EXPENSE_ITEM_ID
				</cfquery>
			</cfif>
			<cfif len(expense_id_list)>
				<cfset expense_id_list=listsort(expense_id_list,"numeric","ASC",",")>
				<cfquery name="get_exp_center" datasource="#dsn2#">
					SELECT EXPENSE,EXPENSE_ID FROM EXPENSE_CENTER WHERE EXPENSE_ID IN (#expense_id_list#) ORDER BY EXPENSE_ID
				</cfquery>
			</cfif>
			<cfoutput query="get_invent">
			<tbody>
				<tr>
					<td>#currentrow#</td>
					<td>#INVENTORY_NUMBER#</td>
					<td nowrap="nowrap">#INVENTORY_NAME#</td>
                    <td style="text-align:center">#ACCOUNT_ID#</td>
					<td>#QUANTITY#</td>
					<td nowrap="nowrap">#get_invent.debt_account_id#</td>
					<td nowrap="nowrap">#get_invent.claim_account_id#</td>
					<td nowrap="nowrap"><cfif len(PROJECT_ID)>#get_project_name(PROJECT_ID)#</cfif></td>
					<td><cfif len(EXPENSE_CENTER_ID)>#get_exp_center.EXPENSE[listfind(expense_id_list,EXPENSE_CENTER_ID,',')]#</cfif></td>
					<td><cfif len(EXPENSE_ITEM_ID)>#get_exp_detail.EXPENSE_ITEM_NAME[listfind(item_id_list,EXPENSE_ITEM_ID,',')]#</cfif></td>
					<cfif isDefined("attributes.last_amortization_year") and len(attributes.last_amortization_year)>
						<td>#AMORTIZATON_YEAR#</td>
					</cfif>
					<td nowrap="nowrap">
						<cfif AMORTIZATON_METHOD eq 0>
							<cf_get_lang_main no='1624.Azalan Bakiye Üzerinden'>
						<cfelseif AMORTIZATON_METHOD eq 1>
							<cf_get_lang_main no='1625.Sabit Miktar Üzeriden'>
						</cfif>
					</td>
					<td style="text-align:right;">#TLFormat(AMOUNT)#</td>
					<cfset attributes.old_value=AMORTIZATON_VALUE+PERIODIC_AMORT_VALUE>
					<cfset total_amortization = PERIODIC_AMORT_VALUE*get_invent.quantity>
					<td style="text-align:right;">#TLFormat(attributes.old_value)#</td>
					<td style="text-align:right;">#TLFormat(AMORTIZATON_ESTIMATE)#</td>
					<td style="text-align:right;">#TLFormat(AMORTIZATON_INV_VALUE)#</td>
					<td style="text-align:right;">#get_invent.account_period#</td>
					<td style="text-align:right;" nowrap="nowrap">#TLFormat(periodic_amort_value)#</td>
					<td style="text-align:right;" nowrap="nowrap">#TLFormat(total_amortization)#</td>
					<td style="text-align:right;" nowrap="nowrap">#TLFormat(amortizaton_value)#</td>
				</tr>
			</tbody>
			</cfoutput>
		</table>
	</cfif>
</cfsavecontent>
<cfoutput>#excel_icerik#</cfoutput>
