<cfsetting showdebugoutput="no">
<cfquery name="get_guarantees" datasource="#dsn#">
	SELECT 
		CS.CONSUMER_ID,
		CS.COMPANY_ID,
		CS.GIVE_TAKE,
		CS.SECUREFUND_CAT_ID,
		SS.SECUREFUND_CAT,
		CS.BANK_BRANCH_ID,
		CS.START_DATE,
		CS.FINISH_DATE,
		CS.ACTION_VALUE,
		CS.ACTION_VALUE2
	FROM 
		COMPANY_SECUREFUND CS
		LEFT JOIN SETUP_SECUREFUND SS ON CS.SECUREFUND_CAT_ID = SS.SECUREFUND_CAT_ID
	WHERE 
		OFFER_ID = #attributes.offer_id#
		AND GIVE_TAKE = #attributes.give_take#
</cfquery>
<cf_ajax_list>
	<thead>
		<tr>
			<th width="25"><cf_get_lang dictionary_id='57487.No'></th>
			<th width="100"><cf_get_lang dictionary_id='57658.Üye'></th>
			<th width="80"><cf_get_lang dictionary_id='57486.Kategori'></th>
			<th width="150"><cf_get_lang dictionary_id='57521.Banka'>/<cf_get_lang dictionary_id='57453.Şube'></th>
			<th width="65"><cf_get_lang dictionary_id='57655.Başlama Tarihi'></th>
			<th width="65"><cf_get_lang dictionary_id='57700.Bitiş Tarihi'></th>
			<th width="65" style="text-align:right;"><cf_get_lang dictionary_id ='57673.Tutar'></th>
			<th width="65" style="text-align:right;"><cf_get_lang dictionary_id ='57279.Doviz Tutar'></th>
		</tr>
	</thead>
	<tbody>
		<cfif get_guarantees.recordcount>
			<cfoutput query="get_guarantees">
				<cfset day_diff = dateDiff('d', FINISH_DATE, now())-1>
				<tr>
					<td><cfif day_diff gte 0><font color="red"></cfif>#currentrow#</td>
					<td>
						<cfif len(company_id)>
							<cfif day_diff gte 0><font color="red"></cfif>#get_par_info(company_id,1,0,0)#
						<cfelseif len(consumer_id)>
							<cfif day_diff gte 0><font color="red"></cfif>#get_cons_info(consumer_id,0,0)#
						</cfif>
					</td>
					<td><cfif len(securefund_cat)><cfif day_diff gte 0><font color="red"></cfif>#SECUREFUND_CAT#</cfif></td>
					<td>
						<cfif len(bank_branch_id)>
							<cfquery name="GET_BANK_BRANCHES" datasource="#DSN3#">
								SELECT BANK_BRANCH_ID,BANK_BRANCH_NAME,BANK_NAME FROM BANK_BRANCH WHERE BANK_BRANCH_ID = #bank_branch_id#
							</cfquery> 
							<cfif day_diff gte 0><font color="red"></cfif>#GET_BANK_BRANCHES.BANK_NAME# / #GET_BANK_BRANCHES.BANK_BRANCH_NAME#
						</cfif>
					</td>
					<td><cfif day_diff gte 0><font color="red"></cfif>#dateFormat(START_DATE,dateformat_style)#</td>
					<td><cfif day_diff gte 0><font color="red"></cfif>#dateFormat(FINISH_DATE,dateformat_style)#</td>
					<td style="text-align:right;"><cfif day_diff gte 0><font color="red"></cfif>#tlFormat(ACTION_VALUE,2)#</td>
					<td style="text-align:right;"><cfif day_diff gte 0><font color="red"></cfif>#tlFormat(ACTION_VALUE2,2)#</td>
				</tr>
		   </cfoutput>
		<cfelse>
			<tr>
				<td colspan="8"><cf_get_lang dictionary_id='57484.Kayıt Bulunamadı'> !</td>
			</tr>
		</cfif>
	</tbody>
</cf_ajax_list>



