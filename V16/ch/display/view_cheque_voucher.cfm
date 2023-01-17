<!---E.A 19072012 select ifadeleri düzenlendi.--->
<cfsetting showdebugoutput="no">
<cfquery name="get_money" datasource="#dsn2#">
	SELECT MONEY FROM SETUP_MONEY WHERE MONEY_STATUS = 1
</cfquery>
<cfquery name="get_cheque_voucher_kar" datasource="#dsn2#">
	SELECT 
		1 AS TYPE,
		CHEQUE_ID ID,
		CHEQUE_NO AS BELGE_NO,
		CHEQUE_DUEDATE AS VADE_DATE,
		CHEQUE_VALUE AS TUTAR,
		OTHER_MONEY_VALUE AS SISTEM_TUTAR,
		CURRENCY_ID AS MONEY_TYPE,
		CHEQUE_STATUS_ID AS STATUS
	FROM 
		CHEQUE 
	WHERE 
		CHEQUE_STATUS_ID = 5 AND 
		CHEQUE_DUEDATE < DATEADD(DAY,-1,GETDATE())
	<cfif attributes.member_type eq 'partner'>
		AND COMPANY_ID = #attributes.member_id#
	<cfelse>
		AND CONSUMER_ID = #attributes.member_id#
	</cfif>
		
	UNION ALL
	
	SELECT
		2 AS TYPE,
		VOUCHER_ID ID,
		VOUCHER_NO AS NO,
		VOUCHER_DUEDATE AS VADE_DATE,
		VOUCHER_VALUE AS TUTAR,
		OTHER_MONEY_VALUE AS SISTEM_TUTAR,
		CURRENCY_ID AS MONEY_TYPE,
		VOUCHER_STATUS_ID AS STATUS
	FROM
		VOUCHER
	WHERE
		VOUCHER_STATUS_ID = 5 AND 
		ISNULL(IS_PAY_TERM,0) = 0 AND 
		VOUCHER_DUEDATE < DATEADD(DAY,-1,GETDATE())
	<cfif attributes.member_type eq 'partner'>
		AND COMPANY_ID = #attributes.member_id#
	<cfelse>
		AND CONSUMER_ID = #attributes.member_id#
	</cfif>
	ORDER BY
		VADE_DATE
</cfquery>
<cfquery name="get_cheque_voucher_kar_2" datasource="#dsn2#">
	SELECT 
		1 AS TYPE,
		CHEQUE_ID ID,
		CHEQUE_NO AS BELGE_NO,
		CHEQUE_DUEDATE AS VADE_DATE,
		CHEQUE_VALUE AS TUTAR,
		OTHER_MONEY_VALUE AS SISTEM_TUTAR,
		CURRENCY_ID AS MONEY_TYPE,
		CHEQUE_STATUS_ID AS STATUS
	FROM 
		CHEQUE 
	WHERE 
		CHEQUE_STATUS_ID = 5 AND 
		CHEQUE_DUEDATE >= DATEADD(DAY,-1,GETDATE())
	<cfif attributes.member_type eq 'partner'>
		AND COMPANY_ID = #attributes.member_id#
	<cfelse>
		AND CONSUMER_ID = #attributes.member_id#
	</cfif>
	
	UNION ALL
	
	SELECT
		2 AS TYPE,
		VOUCHER_ID ID,
		VOUCHER_NO AS NO,
		VOUCHER_DUEDATE AS VADE_DATE,
		VOUCHER_VALUE AS TUTAR,
		OTHER_MONEY_VALUE AS SISTEM_TUTAR,
		CURRENCY_ID AS MONEY_TYPE,
		VOUCHER_STATUS_ID AS STATUS
	FROM
		VOUCHER
	WHERE
		VOUCHER_STATUS_ID = 5 AND 
		ISNULL(IS_PAY_TERM,0) = 0 AND 
		VOUCHER_DUEDATE >= DATEADD(DAY,-1,GETDATE())
	<cfif attributes.member_type eq 'partner'>
		AND COMPANY_ID = #attributes.member_id#
	<cfelse>
		AND CONSUMER_ID = #attributes.member_id#
	</cfif>
	ORDER BY
		VADE_DATE
</cfquery>
<cfquery name="get_cheque_voucher_pay" datasource="#dsn2#">
	SELECT 
		1 AS TYPE,
		CHEQUE_ID ID,
		CHEQUE_NO AS BELGE_NO,
		CHEQUE_DUEDATE AS VADE_DATE,
		CHEQUE_VALUE AS TUTAR,
		OTHER_MONEY_VALUE AS SISTEM_TUTAR,
		CURRENCY_ID AS MONEY_TYPE,
		CHEQUE_STATUS_ID AS STATUS
	FROM 
		CHEQUE 
	WHERE 
		CHEQUE_STATUS_ID IN(1,12) AND 
		CHEQUE_DUEDATE < DATEADD(DAY,-1,GETDATE())
	<cfif attributes.member_type eq 'partner'>
		AND COMPANY_ID = #attributes.member_id#
	<cfelse>
		AND CONSUMER_ID = #attributes.member_id#
	</cfif>
	
	UNION ALL
	
	SELECT
		2 AS TYPE,
		VOUCHER_ID ID,
		VOUCHER_NO AS NO,
		VOUCHER_DUEDATE AS VADE_DATE,
		VOUCHER_VALUE AS TUTAR,
		OTHER_MONEY_VALUE AS SISTEM_TUTAR,
		CURRENCY_ID AS MONEY_TYPE,
		VOUCHER_STATUS_ID AS STATUS
	FROM
		VOUCHER
	WHERE
		VOUCHER_STATUS_ID IN(1,10,12) AND 
		ISNULL(IS_PAY_TERM,0) = 0 AND 
		VOUCHER_DUEDATE < DATEADD(DAY,-1,GETDATE())
	<cfif attributes.member_type eq 'partner'>
		AND COMPANY_ID = #attributes.member_id#
	<cfelse>
		AND CONSUMER_ID = #attributes.member_id#
	</cfif>
	
	UNION ALL
	
	SELECT
		2 AS TYPE,
		VOUCHER_ID ID,
		VOUCHER_NO AS NO,
		VOUCHER_DUEDATE AS VADE_DATE,
		VOUCHER_VALUE- (SELECT SUM(CLOSED_AMOUNT) FROM VOUCHER_CLOSED WHERE ACTION_ID = VOUCHER.VOUCHER_ID AND IS_VOUCHER_DELAY IS NULL) AS TUTAR,
		OTHER_MONEY_VALUE- (SELECT SUM(CLOSED_AMOUNT) FROM VOUCHER_CLOSED WHERE ACTION_ID = VOUCHER.VOUCHER_ID AND IS_VOUCHER_DELAY IS NULL) AS SISTEM_TUTAR,
		CURRENCY_ID AS MONEY_TYPE,
		VOUCHER_STATUS_ID AS STATUS
	FROM
		VOUCHER
	WHERE
		VOUCHER_STATUS_ID = 11 AND 
		VOUCHER_DUEDATE < DATEADD(DAY,-1,GETDATE())
	<cfif attributes.member_type eq 'partner'>
		AND COMPANY_ID = #attributes.member_id#
	<cfelse>
		AND CONSUMER_ID = #attributes.member_id#
	</cfif>
	ORDER BY
		VADE_DATE
</cfquery>
<cfquery name="get_cheque_voucher_pay_2" datasource="#dsn2#">
	SELECT 
		1 AS TYPE,
		CHEQUE_ID ID,
		CHEQUE_NO AS BELGE_NO,
		CHEQUE_DUEDATE AS VADE_DATE,
		CHEQUE_VALUE AS TUTAR,
		OTHER_MONEY_VALUE AS SISTEM_TUTAR,
		CURRENCY_ID AS MONEY_TYPE,
		CHEQUE_STATUS_ID AS STATUS
	FROM 
		CHEQUE 
	WHERE 
		CHEQUE_STATUS_ID IN(1,12) AND 
		CHEQUE_DUEDATE >= DATEADD(DAY,-1,GETDATE())
	<cfif attributes.member_type eq 'partner'>
		AND COMPANY_ID = #attributes.member_id#
	<cfelse>
		AND CONSUMER_ID = #attributes.member_id#
	</cfif>
	
	UNION ALL
	
	SELECT
		2 AS TYPE,
		VOUCHER_ID ID,
		VOUCHER_NO AS NO,
		VOUCHER_DUEDATE AS VADE_DATE,
		VOUCHER_VALUE AS TUTAR,
		OTHER_MONEY_VALUE AS SISTEM_TUTAR,
		CURRENCY_ID AS MONEY_TYPE,
		VOUCHER_STATUS_ID AS STATUS
	FROM
		VOUCHER
	WHERE
		VOUCHER_STATUS_ID IN(1,10,12) AND 
		ISNULL(IS_PAY_TERM,0) = 0 AND 
		VOUCHER_DUEDATE >= DATEADD(DAY,-1,GETDATE())
	<cfif attributes.member_type eq 'partner'>
		AND COMPANY_ID = #attributes.member_id#
	<cfelse>
		AND CONSUMER_ID = #attributes.member_id#
	</cfif>
	
	UNION ALL
	
	SELECT
		2 AS TYPE,
		VOUCHER_ID ID,
		VOUCHER_NO AS NO,
		VOUCHER_DUEDATE AS VADE_DATE,
		VOUCHER_VALUE- (SELECT SUM(CLOSED_AMOUNT) FROM VOUCHER_CLOSED WHERE ACTION_ID = VOUCHER.VOUCHER_ID AND IS_VOUCHER_DELAY IS NULL) AS TUTAR,
		OTHER_MONEY_VALUE- (SELECT SUM(CLOSED_AMOUNT) FROM VOUCHER_CLOSED WHERE ACTION_ID = VOUCHER.VOUCHER_ID AND IS_VOUCHER_DELAY IS NULL) AS SISTEM_TUTAR,
		CURRENCY_ID AS MONEY_TYPE,
		VOUCHER_STATUS_ID AS STATUS
	FROM
		VOUCHER
	WHERE
		VOUCHER_STATUS_ID = 11 AND 
		ISNULL(IS_PAY_TERM,0) = 0 AND 
		VOUCHER_DUEDATE >= DATEADD(DAY,-1,GETDATE())
	<cfif attributes.member_type eq 'partner'>
		AND COMPANY_ID = #attributes.member_id#
	<cfelse>
		AND CONSUMER_ID = #attributes.member_id#
	</cfif>
	ORDER BY
		VADE_DATE
</cfquery>
<cfoutput query="get_money">
	<cfset 'toplam_karsılık_#money#' = 0>
	<cfset 'toplam_karsılık_2_#money#' = 0>
	<cfset 'toplam_pay_#money#' = 0>
	<cfset 'toplam_pay_2_#money#' = 0>
</cfoutput>
<cfset toplam_ort_kar_tutar = 0>
<cfset toplam_kar_tutar = 0>
<cfset toplam_ort_pay_tutar = 0>
<cfset toplam_pay_tutar = 0>
<cfset toplam_ort_kar_tutar_2 = 0>
<cfset toplam_kar_tutar_2 = 0>
<cfset toplam_ort_pay_tutar_2 = 0>
<cfset toplam_pay_tutar_2 = 0>
<cf_seperator id="senet_" header="#getLang('ch',102)#">
<div id="senet_">
	<cf_grid_list>
		<thead>
			<tr>
				<th colspan="7"><cf_get_lang no="217.Vadesi Gelenler"></th>
			</tr>
			<tr>
				<th width="15"><cfif get_cheque_voucher_pay.recordcount><input type="checkbox" name="hepsi1" id="hepsi1" value="1" onClick="check_all_1(this.checked);"></cfif></th>
				<input type="hidden" name="record_num1" id="record_num1" value="<cfoutput>#get_cheque_voucher_pay.recordcount#</cfoutput>">	
				<th width="25"><cf_get_lang_main no="1165.Sıra"></th>
				<th width="80"><cf_get_lang_main no='388.İşlem Tipi'></th>
				<th width="150"><cf_get_lang_main no='468.Belge No'></th>
				<th width="80"><cf_get_lang_main no='469.Vade Tarihi'></th>
				<th><cf_get_lang_main no='70.Aşama'></th>
				<th><cf_get_lang_main no ='261.Tutar'></th>
			</tr>
		</thead>
		<tbody>
			<cfif get_cheque_voucher_pay.recordcount>
				<cfoutput query="get_cheque_voucher_pay">
					<tr>
						<td width="15">
							<input type="checkbox" name="cheque_row1#currentrow#" id="cheque_row1#currentrow#" value="#id#" <cfif status eq 12>checked</cfif>>
							<input type="hidden" name="id1#currentrow#" id="id1#currentrow#" value="#id#">
							<input type="hidden" name="cheque_type1#currentrow#" id="cheque_type1#currentrow#" value="#type#">	
						</td>
						<td>#currentrow#</td>
						<td><cfif type eq 1><cf_get_lang_main no ='595.Çek'><cfelse><cf_get_lang_main no ='596.Senet'></cfif></td>
						<td><cfif type eq 1>
								<a href="javascript://" onclick="windowopen('#request.self#?fuseaction=objects.popup_cheque_det&id=#id#','small');" class="tableyazi">#belge_no#</a>
							<cfelse>
									<a href="javascript://" onclick="windowopen('#request.self#?fuseaction=objects.popup_voucher_det&id=#id#','small');" class="tableyazi">#belge_no#</a>
							</cfif>
						</td>
						<td>#dateformat(vade_date,dateformat_style)#</td>
						<td><cfif status eq 1>
								<font color="red"><cf_get_lang no='100.Portföyde'></font>
							<cfelseif status eq 10>
								<font color="red"><cf_get_lang no='104.Protestolu'>-<cf_get_lang no='100.Portföyde'></font>
							<cfelseif status eq 11>
								<font color="green"><cf_get_lang no='98.Kısmi Tahsil'></font>
							<cfelse>
								<cf_get_lang no='97.İcra'>
							</cfif>
						</td>
						<td class="moneybox">#tlformat(tutar)# #money_type#</td>
					</tr>
					<cfif len(get_cheque_voucher_pay.sistem_tutar)>
						<cfset gun_farki = DateDiff("d",createodbcdatetime('#year(now())#-#month(now())#-#day(now())#'),vade_date)>
						<cfset toplam_ort_pay_tutar = toplam_ort_pay_tutar + (sistem_tutar * gun_farki)>
						<cfset toplam_pay_tutar = toplam_pay_tutar + sistem_tutar>
					</cfif>
					<cfif len(get_cheque_voucher_pay.tutar)>
						<cfset 'toplam_pay_#money_type#' = evaluate('toplam_pay_#money_type#') + get_cheque_voucher_pay.tutar>
					</cfif>
				</cfoutput>
				<tr>
					<td></td><td></td><td></td>
					<td class="bold"><cf_get_lang_main no ='80.Toplam'></td>
					<td class="bold">
						<cfif toplam_pay_tutar gt 0>
							<cfset due_day = toplam_ort_pay_tutar / toplam_pay_tutar>
						<cfelse>
							<cfset due_day = 0>
						</cfif>
						<cfoutput>#dateformat(date_add('d',due_day,now()),dateformat_style)#</cfoutput>
					</td><td></td>
					<td class="bold moneybox">
						<cfoutput query="get_money">
							<cfif evaluate('toplam_pay_#money#') gt 0>
								#Tlformat(evaluate('toplam_pay_#money#'))# #money#<br/>
							</cfif>
						</cfoutput>
					</td>
				</tr>
			<cfelse>
				<tr>
					<td colspan="7"><cf_get_lang_main no='72.Kayıt Bulunamadı'> !</td>
				</tr>
			</cfif>
		</tbody>
	</cf_grid_list>
	<cf_grid_list>
		<thead>
			<tr>
				<th colspan="7"><cf_get_lang no="218.Vadesi Gelmeyeneler"></th>
			</tr>
			<tr>
				<th width="15"><cfif get_cheque_voucher_pay_2.recordcount><input type="checkbox" name="hepsi1_2" id="hepsi1_2" value="1" onClick="check_all_1(this.checked);"></cfif></th>
				<input type="hidden" name="record_num1_2" id="record_num1_2" value="<cfoutput>#get_cheque_voucher_pay_2.recordcount#</cfoutput>">	
				<th width="25"><cf_get_lang_main no="1165.Sıra"></th>
				<th width="80"><cf_get_lang_main no='388.İşlem Tipi'></th>
				<th width="150"><cf_get_lang_main no='468.Belge No'></th>
				<th width="80"><cf_get_lang_main no='469.Vade Tarihi'></th>
				<th><cf_get_lang_main no='70.Aşama'></th>
				<th><cf_get_lang_main no ='261.Tutar'></th>
			</tr>
		</thead>
		<tbody>
			<cfif get_cheque_voucher_pay_2.recordcount>
				<cfoutput query="get_cheque_voucher_pay_2">
					<tr height="20" onMouseOver="this.className='color-light';" onMouseOut="this.className='color-row';" class="color-row">
						<td width="15">
							<input type="checkbox" name="cheque_row1_2#currentrow#" id="cheque_row1_2#currentrow#" value="#id#" <cfif status eq 12>checked</cfif>>
							<input type="hidden" name="id1_2#currentrow#" id="id1_2#currentrow#" value="#id#">
							<input type="hidden" name="cheque_type1_2#currentrow#" id="cheque_type1_2#currentrow#" value="#type#">	
						</td>
						<td>#currentrow#</td>
						<td><cfif type eq 1><cf_get_lang_main no ='595.Çek'><cfelse><cf_get_lang_main no ='596.Senet'></cfif></td>
						<td><cfif type eq 1>
								<a href="javascript://" onclick="windowopen('#request.self#?fuseaction=objects.popup_cheque_det&id=#id#','small');" class="tableyazi">#belge_no#</a>
							<cfelse>
									<a href="javascript://" onclick="windowopen('#request.self#?fuseaction=objects.popup_voucher_det&id=#id#','small');" class="tableyazi">#belge_no#</a>
							</cfif>
						</td>
						<td>#dateformat(vade_date,dateformat_style)#</td>
						<td><cfif status eq 1>
								<font color="red"><cf_get_lang no='100.Portföyde'></font>
							<cfelseif status eq 10>
								<font color="red"><cf_get_lang no='104.Protestolu'>-<cf_get_lang no='100.Portföyde'></font>
							<cfelseif status eq 11>
								<font color="green"><cf_get_lang no='98.Kısmi Tahsil'></font>
							<cfelse>
								<cf_get_lang no='97.İcra'>
							</cfif>
						</td>
						<td  class="moneybox">#tlformat(tutar)# #money_type#</td>
					</tr>
					<cfif len(get_cheque_voucher_pay_2.sistem_tutar)>
						<cfset gun_farki = DateDiff("d",createodbcdatetime('#year(now())#-#month(now())#-#day(now())#'),vade_date)>
						<cfset toplam_ort_pay_tutar_2 = toplam_ort_pay_tutar_2 + (sistem_tutar * gun_farki)>
						<cfset toplam_pay_tutar_2 = toplam_pay_tutar_2 + sistem_tutar>
					</cfif>
					<cfif len(get_cheque_voucher_pay_2.tutar)>
						<cfset 'toplam_pay_2_#money_type#' = evaluate('toplam_pay_2_#money_type#') + get_cheque_voucher_pay_2.tutar>
					</cfif>
				</cfoutput>
				<tr class="color-row">
					<td></td><td></td><td></td>
					<td class="bold"><cf_get_lang_main no ='80.Toplam'></td>
					<td class="bold">
						<cfif toplam_pay_tutar_2 gt 0>
							<cfset due_day = toplam_ort_pay_tutar_2 / toplam_pay_tutar_2>
						<cfelse>
							<cfset due_day = 0>
						</cfif>
						<cfoutput>#dateformat(date_add('d',due_day,now()),dateformat_style)#</cfoutput>
					</td><td></td>
					<td class="bold moneybox">
						<cfoutput query="get_money">
							<cfif evaluate('toplam_pay_2_#money#') gt 0>
								#Tlformat(evaluate('toplam_pay_2_#money#'))# #money#<br/>
							</cfif>
						</cfoutput>
					</td>
				</tr>
			<cfelse>
				<tr>
					<td colspan="7"><cf_get_lang_main no='72.Kayıt Bulunamadı'> !</td>
				</tr>
			</cfif>
		</tbody>
	</cf_grid_list>
</div>
<cf_seperator id="cek_" header="#getLang('ch',93)#">
<div id="cek_">
	<cf_grid_list>
		<thead>
			<tr>
				<th colspan="7"><cf_get_lang no="217.Vadesi Gelenler"></th>
			</tr>
			<tr>
				<th  width="15"><cfif get_cheque_voucher_kar.recordcount><input type="checkbox" name="hepsi2" id="hepsi2" value="1" onClick="check_all_2(this.checked);"></cfif></th>
				<input type="hidden" name="record_num2" id="record_num2" value="<cfoutput>#get_cheque_voucher_kar.recordcount#</cfoutput>">
				<th width="25"><cf_get_lang_main no="1165.Sıra"></th>
				<th width="80"><cf_get_lang_main no='388.İşlem Tipi'></th>
				<th width="150"><cf_get_lang_main no='468.Belge No'></th>
				<th width="80"><cf_get_lang_main no='469.Vade Tarihi'></th>
				<th><cf_get_lang_main no='70.Aşama'></th>
				<th><cf_get_lang_main no ='261.Tutar'></th>
			</tr>
		</thead>
		<tbody>
			<cfif get_cheque_voucher_kar.recordcount>
				<cfoutput query="get_cheque_voucher_kar">
					<tr>
						<td width="15">
							<input type="checkbox" name="cheque_row2#currentrow#" id="cheque_row2#currentrow#" value="#id#" <cfif status eq 12>checked</cfif>>
							<input type="hidden" name="id2#currentrow#" id="id2#currentrow#" value="#id#">
							<input type="hidden" name="cheque_type2#currentrow#" id="cheque_type2#currentrow#" value="#type#">
						</td>
						<td>#currentrow#</td>
						<td><cfif type eq 1><cf_get_lang_main no ='595.Çek'><cfelse><cf_get_lang_main no ='596.Senet'></cfif></td>
						<td>
							<cfif type eq 1>
								<a href="javascript://" onclick="windowopen('#request.self#?fuseaction=objects.popup_cheque_det&id=#id#','small');" class="tableyazi">#belge_no#</a>
							<cfelse>
									<a href="javascript://" onclick="windowopen('#request.self#?fuseaction=objects.popup_voucher_det&id=#id#','small');" class="tableyazi">#belge_no#</a>
							</cfif>
						</td>
						<td>#dateformat(vade_date,dateformat_style)#</td>
						<td><cfif status eq 5>
								<font color="red"><cfif type eq 1><cf_get_lang no='94.Karşılıksız'><cfelse><cf_get_lang no='104.Protestolu'></cfif></font>
							<cfelse>
								<cf_get_lang no='97.İcra'>
							</cfif>
						</td>
						<td  class="moneybox">#tlformat(tutar)# #money_type#</td>
					</tr>
					<cfif len(get_cheque_voucher_kar.sistem_tutar)>
						<cfset gun_farki = DateDiff("d",createodbcdatetime('#year(now())#-#month(now())#-#day(now())#'),vade_date)>
						<cfset toplam_ort_kar_tutar = toplam_ort_kar_tutar + (sistem_tutar * gun_farki)>
						<cfset toplam_kar_tutar = toplam_kar_tutar + sistem_tutar>
					</cfif>
					<cfif len(get_cheque_voucher_kar.tutar)>
						<cfset 'toplam_karsılık_#money_type#' = evaluate('toplam_karsılık_#money_type#') + get_cheque_voucher_kar.tutar>
					</cfif>
				</cfoutput>
				<tr>
					<td></td><td></td><td></td>
					<td class="bold"><cf_get_lang_main no ='80.Toplam'></td>
					<td class="bold">
						<cfif toplam_kar_tutar gt 0>
							<cfset due_day = toplam_ort_kar_tutar / toplam_kar_tutar>
						<cfelse>
							<cfset due_day = 0>
						</cfif>
						<cfoutput>#dateformat(date_add('d',due_day,now()),dateformat_style)#</cfoutput>
					</td><td></td>
					<td class="bold moneybox">
						<cfoutput query="get_money">
							<cfif evaluate('toplam_karsılık_#money#') gt 0>
								#Tlformat(evaluate('toplam_karsılık_#money#'))# #money#<br/>
							</cfif>
						</cfoutput>
					</td>
				</tr>
			<cfelse>
				<tr>
					<td colspan="7"><cf_get_lang_main no='72.Kayıt Bulunamadı'> !</td>
				</tr>
			</cfif>
		</tbody>
	</cf_grid_list>
	<cf_grid_list>
		<thead>
			<tr>
				<th colspan="7"><cf_get_lang no="218.Vadesi Gelmeyenler"></th>
			</tr>
			<tr>
				<th  width="15"><cfif get_cheque_voucher_kar_2.recordcount><input type="checkbox" name="hepsi2_2" id="hepsi2_2" value="1" onClick="check_all_2(this.checked);"></cfif></th>
				<input type="hidden" name="record_num2_2" id="record_num2_2" value="<cfoutput>#get_cheque_voucher_kar_2.recordcount#</cfoutput>">
				<th width="25"><cf_get_lang_main no="1165.Sıra"></th>
				<th width="80"><cf_get_lang_main no='388.İşlem Tipi'></th>
				<th width="150"><cf_get_lang_main no='468.Belge No'></th>
				<th width="80"><cf_get_lang_main no='469.Vade Tarihi'></th>
				<th><cf_get_lang_main no='70.Aşama'></th>
				<th><cf_get_lang_main no ='261.Tutar'></th>
			</tr>
		</thead>
		<tbody>
			<cfif get_cheque_voucher_kar_2.recordcount>
				<cfoutput query="get_cheque_voucher_kar_2">
					<tr>
						<td width="15">
							<input type="checkbox" name="cheque_row2_2#currentrow#" id="cheque_row2_2#currentrow#" value="#id#" <cfif status eq 12>checked</cfif>>
							<input type="hidden" name="id2_2#currentrow#" id="id2_2#currentrow#" value="#id#">
							<input type="hidden" name="cheque_type2_2#currentrow#" id="cheque_type2_2#currentrow#" value="#type#">
						</td>
						<td>#currentrow#</td>
						<td><cfif type eq 1><cf_get_lang_main no ='595.Çek'><cfelse><cf_get_lang_main no ='596.Senet'></cfif></td>
						<td>
							<cfif type eq 1>
								<a href="javascript://" onclick="windowopen('#request.self#?fuseaction=objects.popup_cheque_det&id=#id#','small');" class="tableyazi">#belge_no#</a>
							<cfelse>
									<a href="javascript://" onclick="windowopen('#request.self#?fuseaction=objects.popup_voucher_det&id=#id#','small');" class="tableyazi">#belge_no#</a>
							</cfif>
						</td>
						<td>#dateformat(vade_date,dateformat_style)#</td>
						<td><cfif status eq 5>
								<font color="red"><cfif type eq 1><cf_get_lang no='94.Karşılıksız'><cfelse><cf_get_lang no='104.Protestolu'></cfif></font>
							<cfelse>
								<cf_get_lang no='97.İcra'>
							</cfif>
						</td>
						<td class="moneybox">#tlformat(tutar)# #money_type#</td>
					</tr>
					<cfif len(get_cheque_voucher_kar_2.sistem_tutar)>
						<cfset gun_farki = DateDiff("d",createodbcdatetime('#year(now())#-#month(now())#-#day(now())#'),vade_date)>
						<cfset toplam_ort_kar_tutar_2 = toplam_ort_kar_tutar_2 + (sistem_tutar * gun_farki)>
						<cfset toplam_kar_tutar_2 = toplam_kar_tutar_2 + sistem_tutar>
					</cfif>
					<cfif len(get_cheque_voucher_kar_2.tutar)>
						<cfset 'toplam_karsılık_2_#money_type#' = evaluate('toplam_karsılık_2_#money_type#') + get_cheque_voucher_kar_2.tutar>
					</cfif>
				</cfoutput>
				<tr class="color-row">
					<td></td><td></td><td></td>
					<td class="bold"><cf_get_lang_main no ='80.Toplam'></td>
					<td class="bold">
						<cfif toplam_kar_tutar_2 gt 0>
							<cfset due_day = toplam_ort_kar_tutar_2 / toplam_kar_tutar_2>
						<cfelse>
							<cfset due_day = 0>
						</cfif>
						<cfoutput>#dateformat(date_add('d',due_day,now()),dateformat_style)#</cfoutput>
					</td><td></td>
					<td class="bold moneybox">
						<cfoutput query="get_money">
							<cfif evaluate('toplam_karsılık_2_#money#') gt 0>
								#Tlformat(evaluate('toplam_karsılık_2_#money#'))# #money#<br/>
							</cfif>
						</cfoutput>
					</td>
				</tr>
			<cfelse>
				<tr>
					<td colspan="7"><cf_get_lang_main no='72.Kayıt Bulunamadı'> !</td>
				</tr>
			</cfif>
		</tbody>
	</cf_grid_list>
</div>
<script type="text/javascript">
	function check_all_1(deger)
	{
		<cfif get_cheque_voucher_pay.recordcount >
			if(document.all.hepsi1.checked)
			{
				for (var i=1; i <= <cfoutput>#get_cheque_voucher_pay.recordcount#</cfoutput>; i++)
				{
					var form_field = eval("document.upd_law_request.cheque_row1" + i);
					form_field.checked = true;
					eval('upd_law_request.cheque_row1'+i).focus();
				}
			}
			else
			{
				for (var i=1; i <= <cfoutput>#get_cheque_voucher_pay.recordcount#</cfoutput>; i++)
				{
					form_field = eval("document.upd_law_request.cheque_row1" + i);
					form_field.checked = false;
					eval('upd_law_request.cheque_row1'+i).focus();
				}				
			}
		</cfif>
		<cfif get_cheque_voucher_pay_2.recordcount >
			if(document.all.hepsi1_2.checked)
			{
				for (var i=1; i <= <cfoutput>#get_cheque_voucher_pay_2.recordcount#</cfoutput>; i++)
				{
					var form_field = eval("document.upd_law_request.cheque_row1_2" + i);
					form_field.checked = true;
					eval('upd_law_request.cheque_row1_2'+i).focus();
				}
			}
			else
			{
				for (var i=1; i <= <cfoutput>#get_cheque_voucher_pay_2.recordcount#</cfoutput>; i++)
				{
					var form_field = eval("document.upd_law_request.cheque_row1_2" + i);
					form_field.checked = false;
					eval('upd_law_request.cheque_row1_2'+i).focus();
				}				
			}
		</cfif>
	}
	function check_all_2(deger)
	{
		<cfif get_cheque_voucher_kar.recordcount >
			if(document.all.hepsi2.checked)
			{
				for (var i=1; i <= <cfoutput>#get_cheque_voucher_kar.recordcount#</cfoutput>; i++)
				{
					var form_field = eval("document.upd_law_request.cheque_row2" + i);
					form_field.checked = true;
					eval('upd_law_request.cheque_row2'+i).focus();
				}
			}
			else
			{
				for (var i=1; i <= <cfoutput>#get_cheque_voucher_kar.recordcount#</cfoutput>; i++)
				{
					var form_field = eval("document.upd_law_request.cheque_row2" + i);
					form_field.checked = false;
					eval('upd_law_request.cheque_row2'+i).focus();
				}				
			}
		</cfif>
		<cfif get_cheque_voucher_kar_2.recordcount >
			if(document.all.hepsi2_2.checked)
			{
				for (var i=1; i <= <cfoutput>#get_cheque_voucher_kar_2.recordcount#</cfoutput>; i++)
				{
					var form_field = eval("document.upd_law_request.cheque_row2_2" + i);
					form_field.checked = true;
					eval('upd_law_request.cheque_row2_2'+i).focus();
				}
			}
			else
			{
				for (var i=1; i <= <cfoutput>#get_cheque_voucher_kar_2.recordcount#</cfoutput>; i++)
				{
					var form_field = eval("document.upd_law_request.cheque_row2_2" + i);
					form_field.checked = false;
					eval('upd_law_request.cheque_row2_2'+i).focus();
				}
			}
		</cfif>
	}
</script>
