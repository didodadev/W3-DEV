<cfquery name="GET_PROVISION_IMPORTS" datasource="#dsn2#">
	SELECT
		F_I_ROW.IS_CANCEL,
		F_I_ROW.SELLER_CODE,
		F_I_ROW.TERMINAL_NO,
		F_I_ROW.PROCESS_DATE,
		F_I_ROW.VALOR_DATE,
		F_I_ROW.POS_PROCESS_TYPE,
		F_I_ROW.NUMBER_OF_INSTALMENT,
		F_I_ROW.COMMISSION,
		F_I_ROW.MONEY2_MULTIPLIER,
		F_I_ROW.AWARD,
		F_I_ROW.GROSS_TOTAL,
		F_I_ROW.CARI_TUTAR,
		F_I_ROW.NET_TOTAL,
		F_I_ROW.FILE_IMPORT_BANK_POS_ROW_ID,
		F_I_ROW.BANK_TYPE,
		F_I_ROW.CC_REVENUE_ID,
		POS_EQUIPMENT_BANK.COMPANY_ID
	FROM
		FILE_IMPORT_BANK_POS_ROWS F_I_ROW,
		#dsn3_alias#.POS_EQUIPMENT_BANK POS_EQUIPMENT_BANK
	WHERE
		FILE_IMPORT_ID = #attributes.I_ID# AND
		F_I_ROW.SELLER_CODE = POS_EQUIPMENT_BANK.SELLER_CODE
UNION ALL
	SELECT
		F_I_ROW.IS_CANCEL,
		F_I_ROW.SELLER_CODE,
		F_I_ROW.TERMINAL_NO,
		F_I_ROW.PROCESS_DATE,
		F_I_ROW.VALOR_DATE,
		F_I_ROW.POS_PROCESS_TYPE,
		F_I_ROW.NUMBER_OF_INSTALMENT,
		F_I_ROW.COMMISSION,
		F_I_ROW.MONEY2_MULTIPLIER,
		F_I_ROW.AWARD,
		F_I_ROW.GROSS_TOTAL,
		F_I_ROW.CARI_TUTAR,
		F_I_ROW.NET_TOTAL,
		F_I_ROW.FILE_IMPORT_BANK_POS_ROW_ID,
		F_I_ROW.BANK_TYPE,
		F_I_ROW.CC_REVENUE_ID,
		0 COMPANY_ID
	FROM
		FILE_IMPORT_BANK_POS_ROWS F_I_ROW
	WHERE
		FILE_IMPORT_ID = #attributes.I_ID# AND
		F_I_ROW.SELLER_CODE NOT IN 
		(
			SELECT SELLER_CODE FROM #dsn3_alias#.POS_EQUIPMENT_BANK
		) 
	ORDER BY
		F_I_ROW.FILE_IMPORT_BANK_POS_ROW_ID
</cfquery>
<cfsavecontent variable="head_">
	<cfif GET_PROVISION_IMPORTS.BANK_TYPE eq 10>Akbank
	<cfelseif GET_PROVISION_IMPORTS.BANK_TYPE eq 11>İşBankası
	<cfelseif GET_PROVISION_IMPORTS.BANK_TYPE eq 12>HSBC
	<cfelseif GET_PROVISION_IMPORTS.BANK_TYPE eq 13>Garanti
	<cfelseif GET_PROVISION_IMPORTS.BANK_TYPE eq 14>YapıKredi
	<cfelseif GET_PROVISION_IMPORTS.BANK_TYPE eq 15>Finansbank
	</cfif>
	<cf_get_lang no ='337.Banka Pos Satırları'>
</cfsavecontent>
<cf_medium_list_search title="#head_#">
	<cf_medium_list_search_area>
	<cfform name="search_form" method="post" action="#request.self#?fuseaction=bank.popup_list_import_bank_pos_rows&i_id=#I_ID#">
		<table>
			<tr>
				<td>
				<!-- sil --><cf_workcube_file_action pdf='1' mail='0' doc='1' print='1'><!-- sil -->
				</td>
			</tr>
		</table>
	</cfform>
	</cf_medium_list_search_area>
</cf_medium_list_search>
<cf_medium_list>
	<thead>
		<cfoutput>
			<tr>
				<th><cf_get_lang_main no='75.No'></th>
				<th><cf_get_lang_main no ='1094.İptal'></th>
				<th><cf_get_lang_main no='649.Cari'></th>
				<th><cf_get_lang no ='336.İşyeri Kodu'></th>
				<th><cf_get_lang no ='335.Terminal No'></th>
				<th><cf_get_lang_main no='467.İşlem Tarihi'></th>
				<th><cf_get_lang no ='334.Valor Tarihi'></th>
				<th><cf_get_lang_main no='388.İşlem Tipi'></th>
				<th><cf_get_lang no ='144.Taksit Sayısı'></th>
				<th><cf_get_lang_main no='1379.Komisyon'></th>
				<th><cf_get_lang_main no='1379.Komisyon'>#session.ep.money2#</th>
				<th><cf_get_lang no ='332.Ödül'></th>
				<th><cf_get_lang no ='332.Ödül'>#session.ep.money2#</th>
				<th><cf_get_lang_main no='470.İşlem Tutarı'></th>
				<th><cf_get_lang_main no='470.İşlem Tutarı'>#session.ep.money2#</th>
				<th><cf_get_lang no ='331.Cari Tutar'></th>
				<th><cf_get_lang no ='331.Cari Tutar'>#session.ep.money2#</th>
				<th><cf_get_lang no ='330.Net Tutar'></th>
				<th><cf_get_lang no ='330.Net Tutar'>#session.ep.money2#</th>
				<!-- sil --><th></th><!-- sil -->
			</tr>
		</cfoutput>
	</thead>
	<tbody>
		<cfif GET_PROVISION_IMPORTS.recordcount>
			<cfset company_id_list = ''>
			<cfoutput query="GET_PROVISION_IMPORTS">
				<cfif len(COMPANY_ID) and COMPANY_ID neq 0 and not listfind(company_id_list,COMPANY_ID)>
					<cfset company_id_list = listappend(company_id_list,COMPANY_ID)>
				</cfif>
			</cfoutput>
			<cfif len(company_id_list)>
				<cfset company_id_list = listsort(company_id_list,"numeric","ASC",",")>
				<cfquery name="get_company_detail" datasource="#dsn#">
					SELECT NICKNAME FROM COMPANY WHERE COMPANY_ID IN (#company_id_list#) ORDER BY COMPANY_ID
				</cfquery>
			</cfif>
			<cfoutput query="GET_PROVISION_IMPORTS">
				<tr>
					<td>#currentrow#</td>
					<td align="center"><cfif IS_CANCEL eq 1>*</cfif></td>
					<td><a href="javascript://" onclick="windowopen('#request.self#?fuseaction=objects.popup_com_det&company_id=#COMPANY_ID#','medium');" class="tableyazi"><cfif listfind(company_id_list,COMPANY_ID,',')>#get_company_detail.NICKNAME[listfind(company_id_list,COMPANY_ID,',')]#</cfif></a></td>
					<td>#SELLER_CODE#</td>
					<td>#TERMINAL_NO#</td>
					<td>#dateformat(PROCESS_DATE,dateformat_style)#</td>
					<td>#dateformat(VALOR_DATE,dateformat_style)#</td>
					<td>#POS_PROCESS_TYPE#</td>
					<td>#NUMBER_OF_INSTALMENT#</td>
					<td style="text-align:right;">#TLFormat(COMMISSION)#</td>
					<td style="text-align:right;">#TLFormat(COMMISSION/MONEY2_MULTIPLIER)#</td>
					<td style="text-align:right;">#TLFormat(AWARD)#</td>
					<td style="text-align:right;">#TLFormat(AWARD/MONEY2_MULTIPLIER)#</td>
					<td style="text-align:right;">#TLFormat(GROSS_TOTAL)#</td>
					<td style="text-align:right;">#TLFormat(GROSS_TOTAL/MONEY2_MULTIPLIER)#</td>
					<td style="text-align:right;">#TLFormat(CARI_TUTAR)#</td>
					<td style="text-align:right;">#TLFormat(CARI_TUTAR/MONEY2_MULTIPLIER)#</td>
					<td style="text-align:right;">#TLFormat(NET_TOTAL)#</td>
					<td style="text-align:right;">#TLFormat(NET_TOTAL/MONEY2_MULTIPLIER)#</td>
					<!-- sil -->
					<td>
						<cfif not len(CC_REVENUE_ID)>
						<cfsavecontent variable="message"><cf_get_lang_main no ='121.Silmek İstediğinizden Emin misiniz'>?</cfsavecontent>
							<a href="javascript://" onClick="if (confirm('#message#')) windowopen('#request.self#?fuseaction=bank.emptypopup_del_bank_pos_rows&f_row_id=#FILE_IMPORT_BANK_POS_ROW_ID#','small');"><img src="/images/delete_list.gif" alt="Sil" border="0" title="<cf_get_lang_main no ='51.Sil'>"></a>
						</cfif>
					</td>
					<!-- sil -->
				</tr>
			</cfoutput>
		<cfelse>
			<tr>
				<td colspan="20"><cf_get_lang_main no ='72.Kayıt Yok'>!</td>
			</tr>
		</cfif>
	</tbody>
</cf_medium_list>

