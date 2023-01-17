<cfsetting showdebugoutput="no">
<cfquery name="get_cheques" datasource="#dsn2#">
	SELECT 
		C.CHEQUE_NO,
		C.CHEQUE_DUEDATE,
		C.CHEQUE_VALUE,
		C.OTHER_MONEY_VALUE,
		C.CHEQUE_STATUS_ID
	FROM 
		PAYROLL P,
		CHEQUE C,
		CHEQUE_HISTORY CH
	WHERE 
		P.ACTION_ID = CH.PAYROLL_ID AND
		CH.CHEQUE_ID = C.CHEQUE_ID AND
		P.CONTRACT_ID = #attributes.contract_id#
</cfquery>
<cfquery name="get_vouchers" datasource="#dsn2#">
	SELECT 
		V.VOUCHER_NO,
		V.VOUCHER_DUEDATE,
		V.VOUCHER_VALUE,
		V.OTHER_MONEY_VALUE,
		V.VOUCHER_STATUS_ID
	FROM 
		VOUCHER_PAYROLL P,
		VOUCHER V,
		VOUCHER_HISTORY VH
	WHERE 
		P.ACTION_ID = VH.PAYROLL_ID AND
		VH.VOUCHER_ID = V.VOUCHER_ID AND
		P.CONTRACT_ID = #attributes.contract_id#
</cfquery>
<cf_grid_list>
	<thead>
		<tr>
			<th width="40"></th>
			<th width="25"><cf_get_lang dictionary_id='57487.No'></th>
			<th width="100"><cf_get_lang dictionary_id='57880.Belge No'></th>
			<th width="80"><cf_get_lang dictionary_id='57881.Vade Tarihi'></th>
			<th width="80"><cf_get_lang dictionary_id='57482.Aşama'></th>
			<th width="80" style="text-align:right;"><cf_get_lang dictionary_id='57673.Tutar'></th>
			<th width="80" style="text-align:right;"><cf_get_lang dictionary_id='57677.Döviz'><cf_get_lang dictionary_id='57673.Tutar'></th>
		</tr>
	</thead>
	<tbody>
		<tr class="ohover">
			<td class="txtbold"><cf_get_lang dictionary_id='58007.Çek'></td>
		</tr>
		<cfif get_cheques.recordcount>
			<cfoutput query="get_cheques">
				<tr>
					<td width="40"></td>
					<td>#currentrow#</td>
					<td>#CHEQUE_NO#</td>
					<td>#dateFormat(CHEQUE_DUEDATE,dateformat_style)#</td>
					<td>
						<cfif cheque_status_id eq 1>Portföyde
						<cfelseif cheque_status_id eq 2>Bankada
						<cfelseif cheque_status_id eq 3>Tahsil Edildi
						<cfelseif cheque_status_id eq 4>Ciro Edildi
						<cfelseif cheque_status_id eq 5>Karşılıksız
						<cfelseif cheque_status_id eq 6>Ödenmedi
						<cfelseif cheque_status_id eq 7>Ödendi
						<cfelseif cheque_status_id eq 8>İptal
						<cfelseif cheque_status_id eq 9>İade
						<cfelseif cheque_status_id eq 10>Karşılıksız-Portföyde
						<cfelseif cheque_status_id eq 12>İcra
						<cfelseif cheque_status_id eq 13>Teminatta
						<cfelse>Transfer
						</cfif>
					</td>
					<td style="text-align:right;">#tlFormat(CHEQUE_VALUE,2)#</td>
					<td style="text-align:right;">#tlFormat(OTHER_MONEY_VALUE,2)#</td>
				</tr>
		   </cfoutput>
		<cfelse>
			<tr>
				<td colspan="7"><cf_get_lang dictionary_id='58486.Kayıt Bulunamadı'> !</td>
			</tr>
		</cfif>
		<tr class="nohover">
			<td class="txtbold"><cf_get_lang dictionary_id='58008.Senet'></td>
		</tr>	
		<cfif get_vouchers.recordcount>
			<cfoutput query="get_vouchers">
				<tr>
					<td width="40"></td>
					<td>#currentrow#</td>
					<td>#VOUCHER_NO#</td>
					<td>#dateFormat(VOUCHER_DUEDATE,dateformat_style)#</td>
					<td>
						<cfif voucher_status_id eq 1><cf_get_lang dictionary_id="49748.Portföyde">
						<cfelseif voucher_status_id eq 2><cf_get_lang dictionary_id="49764.Bankada">
						<cfelseif voucher_status_id eq 3><cf_get_lang dictionary_id="49774.Tahsil Edildi">
						<cfelseif voucher_status_id eq 4><cf_get_lang dictionary_id="49776.Ciro Edildi">
						<cfelseif voucher_status_id eq 5><cf_get_lang dictionary_id="50077.Protestolu">
						<cfelseif voucher_status_id eq 6><cf_get_lang dictionary_id="49809.Ödenmedi">
						<cfelseif voucher_status_id eq 7><cf_get_lang dictionary_id="50255.Ödendi">
						<cfelseif voucher_status_id eq 8><cf_get_lang dictionary_id="58506.İptal">
						<cfelseif voucher_status_id eq 9><cf_get_lang dictionary_id="50335.İade">
						<cfelseif voucher_status_id eq 10><cf_get_lang dictionary_id="50077.Protestolu-Portföyde">
						<cfelseif voucher_status_id eq 11><cf_get_lang dictionary_id="50071.Kısmi Tahsil">
						<cfelseif voucher_status_id eq 12><cf_get_lang dictionary_id="50070.İcra">
						<cfelseif voucher_status_id eq 13><cf_get_lang dictionary_id="50467.Teminatta">
						<cfelse><cf_get_lang dictionary_id="58568.Transfer">
						</cfif>
					</td>
					<td style="text-align:right;">#tlFormat(VOUCHER_VALUE,2)#</td>
					<td style="text-align:right;">#tlFormat(OTHER_MONEY_VALUE,2)#</td>
				</tr>
		   </cfoutput>
		<cfelse>
			<tr>
				<td colspan="7"><cf_get_lang dictionary_id='58486.Kayıt Bulunamadı'> !</td>
			</tr>
		</cfif>
	</tbody>
</cf_grid_list>



