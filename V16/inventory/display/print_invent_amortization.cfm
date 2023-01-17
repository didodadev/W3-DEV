<cf_xml_page_edit fuseact="invent.popup_print_invent_amortization">
<cfparam name="attributes.last_amortization_year" default="">
<cfparam name="attributes.old_value" default="0">
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
		INV_AMORT_MAIN_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.action_id#">
</cfquery>
<cfquery name="GET_INVENT" datasource="#dsn3#">
	SELECT
		DISTINCT
		INVENTORY_AMORTIZATON.*,
		INVENTORY.LAST_INVENTORY_VALUE,
		INVENTORY.ENTRY_DATE,
		INVENTORY.AMORTIZATION_TYPE,
		INVENTORY.ACCOUNT_ID,
		INVENTORY.INVENTORY_NUMBER,
		INVENTORY.INVENTORY_NAME,
		INVENTORY.PROJECT_ID,
		INVENTORY.EXPENSE_ITEM_ID,
		INVENTORY.EXPENSE_CENTER_ID,
		ISNULL(INVENTORY_AMORTIZATON.INV_QUANTITY,INVENTORY.QUANTITY) QUANTITY,
		INVENTORY.AMOUNT,
		INVENTORY_ROW.STOCK_IN
	FROM
		INVENTORY,
		INVENTORY_ROW,
		INVENTORY_AMORTIZATON
	WHERE
		INVENTORY.INVENTORY_ID=INVENTORY_ROW.INVENTORY_ID AND 
		INVENTORY_ROW.STOCK_IN > 0 AND 
		INVENTORY.INVENTORY_ID=INVENTORY_AMORTIZATON.INVENTORY_ID AND
		INVENTORY_AMORTIZATON.INV_AMORT_MAIN_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.action_id#">
</cfquery>
<cfset inv_list = valuelist(get_invent.inventory_id)>
<cfsavecontent variable="message"><cf_get_lang dictionary_id="56971.Değerle"></cfsavecontent>
<cf_medium_list_search title="#message#">
	<cf_medium_list_search_area>
		<table>
			<tr>
				<td>
					<cfoutput>
						<a href="#request.self#?fuseaction=invent.popup_upd_invent_amortization&inv_id=#attributes.action_id#"><img src="/images/refer.gif" border="0"  align="absmiddle" alt="<cf_get_lang dictionary_id='57464.Güncelle'>" title="<cf_get_lang dictionary_id='57464.Güncelle'>"></a>
						<cfif get_module_user(31)>
							<a href="javascript://" onClick="windowopen('#request.self#?fuseaction=account.popup_list_card_rows&action_id=#attributes.action_id#&process_cat=#get_detail.process_type#','page');"><img src="/images/extre.gif"  border="0" align="absmiddle" alt="<cf_get_lang dictionary_id ='58452.Mahsup Fişi'>" title="<cf_get_lang dictionary_id ='58452.Mahsup Fişi'>"></a>
						</cfif>
					</cfoutput>
					<cf_workcube_file_action pdf='1' mail='1' doc='1' print='1'>
				</td>
			</tr>
		</table>
	</cf_medium_list_search_area>
</cf_medium_list_search>
<!-- sil -->
<cf_medium_list>
	<cfif get_invent.recordcount>
		<thead>
			<tr>
				<th><cf_get_lang dictionary_id='57487.No'></th>
				<th><cf_get_lang dictionary_id='58878.Demirbaş No'></th>
				<cfif xml_show_entry_date eq 1><th><cf_get_lang dictionary_id="57628.Giriş Tarihi"></th></cfif>
				<cfif xml_show_amortization_type eq 1><th><cf_get_lang dictionary_id="59775.Kıst Amortisman Türü"></th></cfif>
				<th width="75"><cf_get_lang dictionary_id ='57629.Açıklama'></th>
				<th><cf_get_lang dictionary_id ='57635.Miktar'></th>
				<th width="125"><cf_get_lang dictionary_id='56955.Borçlu Hesap'></th>
				<th width="125"><cf_get_lang dictionary_id='34115.Alacaklı Hesap'></th>
				<cfif is_acc_project eq 1><th width="100"><cf_get_lang dictionary_id='57416.Proje'></th></cfif>
				<th width="125"><cf_get_lang dictionary_id='58460.Masraf Merkezi'></th>
				<th width="125"><cf_get_lang dictionary_id='58234.Bütçe Kalemi'></th>
				<th><cf_get_lang dictionary_id='56953.Son Degerlendirme Yılı'></th>
				<th><cf_get_lang dictionary_id ='58606.Amortisman Yöntemi'></th>
				<th nowrap="nowrap"><cf_get_lang dictionary_id ='56908.İlk Değer'></th>
				<th nowrap="nowrap"><cf_get_lang dictionary_id ='56909.Son Değer'></th>
				<th width="75"><cf_get_lang dictionary_id ='56915.Amortisman Oranı'></th>
				<th><cf_get_lang dictionary_id ='56946.Amortisman Tutarı'></th>
				<th><cf_get_lang dictionary_id='56967.Hesaplama Dönemi'></th>
				<th><cf_get_lang dictionary_id='56952.Dönemsel Amortisman Tutarı'></th>
				<th><cf_get_lang dictionary_id='56951.Toplam Ayrılan Amortisman Tutarı'></th>
				<th><cf_get_lang dictionary_id='56950.Yeni Değer'></th>
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
		<tbody>
			<cfoutput query="get_invent">
				<tr>
					<td>#currentrow#</td>
					<td>#inventory_number#</td>
					<cfif xml_show_entry_date eq 1><td>#DateFormat(entry_date,dateformat_style)#</td></cfif>
					<cfif xml_show_amortization_type eq 1><td><cfif amortization_type eq 1>Tabi<cfelse>Tabi Değil</cfif></td></cfif>
					<td>#inventory_name#</td>
					<td>#quantity#</td>
					<td>#get_invent.debt_account_id#</td>
					<td>#get_invent.claim_account_id#</td>
					<cfif is_acc_project eq 1>
						<td><cfif len(PROJECT_ID)>#get_project_name(project_id)#</cfif></td>
					</cfif>
					<td><cfif len(EXPENSE_CENTER_ID)>#get_exp_center.EXPENSE[listfind(expense_id_list,EXPENSE_CENTER_ID,',')]#</cfif></td>
					<td><cfif len(EXPENSE_ITEM_ID)>#get_exp_detail.EXPENSE_ITEM_NAME[listfind(item_id_list,EXPENSE_ITEM_ID,',')]#</cfif></td>
					<td>#AMORTIZATON_YEAR#</td>
					<td width="70">
						<cfif AMORTIZATON_METHOD eq 0>
							<cf_get_lang dictionary_id='29421.Azalan Bakiye Üzerinden'>
						<cfelseif AMORTIZATON_METHOD eq 1>
							<cf_get_lang dictionary_id='29422.Sabit Miktar Üzeriden'>
						</cfif>
					</td>
					<td style="text-align:right;">#TLFormat(AMOUNT)#</td>
					<cfset attributes.old_value=AMORTIZATON_VALUE+PERIODIC_AMORT_VALUE>
					<cfset total_amortization = PERIODIC_AMORT_VALUE*get_invent.quantity>
					<td style="text-align:right;">#TLFormat(attributes.old_value)#</td>
					<td style="text-align:right;">#TLFormat(AMORTIZATON_ESTIMATE)#</td>
					<td style="text-align:right;">#TLFormat(AMORTIZATON_INV_VALUE)#</td>
					<td style="text-align:right;">#get_invent.account_period#</td>
					<td width="60" style="text-align:right;">#TLFormat(periodic_amort_value)#</td>
					<td width="60" style="text-align:right;">#TLFormat(total_amortization)#</td>
					<td width="60" style="text-align:right;">#TLFormat(amortizaton_value)#</td>
				</tr>
			</cfoutput>
		</tbody>
	</cfif>
</cf_medium_list>

