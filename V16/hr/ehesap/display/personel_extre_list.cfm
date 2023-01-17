<cf_date tarih="attributes.date1"> 
<cf_date tarih="attributes.date2">
<cfquery name="get_member_accounts" datasource="#dsn#">
    SELECT DISTINCT EA.ACC_TYPE_ID,SC.ACC_TYPE_NAME FROM EMPLOYEES_ACCOUNTS EA,SETUP_ACC_TYPE SC WHERE SC.ACC_TYPE_ID = EA.ACC_TYPE_ID AND EA.EMPLOYEE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.employee_id#"> AND EA.PERIOD_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.period_id#"> ORDER BY EA.ACC_TYPE_ID DESC
</cfquery>
<cfif get_member_accounts.recordcount eq 0>
	<cfquery name="get_member_accounts" datasource="#dsn#">
		SELECT -1 AS ACC_TYPE_ID FROM EMPLOYEES WHERE EMPLOYEE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.employee_id#">
	</cfquery>
</cfif>
<cfset all_borctoplam = 0>
<cfset all_alacaktoplam = 0>
<cfloop query="get_member_accounts">
	<cfquery name="cari_rows" datasource="#dsn2#">
		SELECT
			CR.ACTION_DATE AS ACTION_DATE,
			CR.ACTION_NAME,
			CR.ACTION_DETAIL,
			0 AS BORC,
			CR.ACTION_VALUE ALACAK
		FROM
			CARI_ROWS CR
		WHERE
			FROM_EMPLOYEE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.employee_id#"> AND
			<cfif isdefined("get_member_accounts.acc_type_id")>
				ISNULL(ACC_TYPE_ID,0)= #get_member_accounts.acc_type_id# AND
			</cfif>
			CR.ACTION_DATE >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.date1#"> AND 
			CR.ACTION_DATE <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.date2#">
		UNION ALL
		SELECT
			CR.ACTION_DATE AS ACTION_DATE,
			CR.ACTION_NAME,
			CR.ACTION_DETAIL,
			CR.ACTION_VALUE AS BORC,
			0 AS ALACAK
		FROM
			CARI_ROWS CR
		WHERE
			TO_EMPLOYEE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.employee_id#"> AND
			<cfif isdefined("get_member_accounts.acc_type_id")>
				ISNULL(ACC_TYPE_ID,0) = #get_member_accounts.acc_type_id# AND
			</cfif>
			CR.ACTION_DATE >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.date1#"> AND 
			CR.ACTION_DATE <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.date2#">
		ORDER BY 
			ACTION_DATE
	</cfquery>
	<cfif isdefined("get_member_accounts.acc_type_name")>
		<cf_seperator header="#get_member_accounts.acc_type_name#" id="0#abs(get_member_accounts.acc_type_id)#">
	</cfif>
	<cf_grid_list id="0#abs(get_member_accounts.acc_type_id)#">
		<thead>
			<tr>
				<th width="5%"><cf_get_lang dictionary_id='57742.Tarih'></th>
				<th width="30%"><cf_get_lang dictionary_id='57692.İşlem'></th>
				<th width="35%"><cf_get_lang dictionary_id='57629.Açıklama'></th>
				<th width="10%" style="text-align:right;"><cf_get_lang dictionary_id='57587.Borç'></th>
				<th width="10%" style="text-align:right;"><cf_get_lang dictionary_id='57588.Alacak'></th>
				<th width="10%" style="text-align:right;"><cf_get_lang dictionary_id='57589.Bakiye'></th>
			</tr>
		</thead>
		<tbody>
			<cfset total = 0>
			<cfset borctoplam = 0>
			<cfset alacaktoplam = 0>
			<cfif cari_rows.recordcount>
				<cfoutput query="cari_rows">
					<cfset borctoplam = borctoplam + borc>
					<cfset alacaktoplam = alacaktoplam + alacak>
					<cfset all_borctoplam = all_borctoplam + borc>
					<cfset all_alacaktoplam = all_alacaktoplam + alacak>
					<cfset total = abs( borctoplam - alacaktoplam)>
					<tr height="20" class="color-row">
						<td>#dateformat(action_date,dateformat_style)#</td>
						<td>#action_name#</td>
						<td>#action_detail#</td>
						<td style="text-align:right;" nowrap><cf_wrk_crypto_gdpr mode="3" pattern="3" sensitive_label="7" data="#TLFormat(borc)# #session.ep.money#"></td>
						<td style="text-align:right;" nowrap><cf_wrk_crypto_gdpr mode="3" pattern="3" sensitive_label="7" data="#TLFormat(alacak)# #session.ep.money#"></td>
						<td style="text-align:right;" nowrap>
							<cfif borctoplam GT alacaktoplam>
								<cf_wrk_crypto_gdpr mode="3" pattern="3" sensitive_label="7" data="#TLFormat(total)# #session.ep.money# -B">
							<cfelse>
								<cf_wrk_crypto_gdpr mode="3" pattern="3" sensitive_label="7" data="#TLFormat(total)# #session.ep.money# -A">
							</cfif>
						</td>
					</tr>
				</cfoutput>
				<cfoutput>
					<tr height="20" class="color-row">
						<td width="70%" colspan="3" style="text-align:right;"><cf_get_lang dictionary_id='57492.Toplam'></td>
						<td style="text-align:right;" nowrap><cf_wrk_crypto_gdpr mode="3" pattern="3" sensitive_label="7" data="#TLFormat(borctoplam)# #session.ep.money#"></td>
						<td style="text-align:right;" nowrap><cf_wrk_crypto_gdpr mode="3" pattern="3" sensitive_label="7" data="#TLFormat(alacaktoplam)# #session.ep.money#"></td>
						<td style="text-align:right;" nowrap>
							<cfif borctoplam GT alacaktoplam>
								<cf_wrk_crypto_gdpr mode="3" pattern="3" sensitive_label="7" data="#TLFormat(total)# #session.ep.money# (B)">
							<cfelseif borctoplam LT alacaktoplam>
								<cf_wrk_crypto_gdpr mode="3" pattern="3" sensitive_label="7" data="#TLFormat(total)# #session.ep.money# (A)">
							<cfelse>
								<cf_wrk_crypto_gdpr mode="3" pattern="3" sensitive_label="7" data="#TLFormat(total)# #session.ep.money#">
							</cfif>
						</td>
					</tr>
				</cfoutput>
			<cfelse>
				<tr height="20" class="color-row">
					<td colspan="6"><cfif isdefined("attributes.is_submitted")><cf_get_lang dictionary_id='57484.Kayıt Yok'><cfelse><cf_get_lang dictionary_id='57701.Filtre Ediniz'></cfif>!</td>
				</tr>	
			</cfif>
		</tbody>
	</cf_grid_list>
</cfloop>
<cfif isdefined("get_member_accounts.acc_type_name") and (all_borctoplam neq 0 or all_alacaktoplam neq 0)>
	<cf_grid_list>
		<cfoutput>
			<tr height="20" class="color-row">
				<td width="70%" class="txtbold" style="text-align:right;"><cf_get_lang dictionary_id='57680.Genel Toplam'></td>
				<td width="10%" class="txtbold" style="text-align:right;" nowrap><cf_wrk_crypto_gdpr mode="3" pattern="3" sensitive_label="7" data="#TLFormat(all_borctoplam)# #session.ep.money#"></td>
				<td width="10%" class="txtbold" style="text-align:right;" nowrap><cf_wrk_crypto_gdpr mode="3" pattern="3" sensitive_label="7" data="#TLFormat(all_alacaktoplam)# #session.ep.money#"></td>
				<td width="10%" class="txtbold" style="text-align:right;" nowrap>
					<cfif all_borctoplam GT all_alacaktoplam>
						<cf_wrk_crypto_gdpr mode="3" pattern="3" sensitive_label="7" data="#TLFormat(abs(all_borctoplam-all_alacaktoplam))# #session.ep.money# (B)">
					<cfelseif all_borctoplam LT all_alacaktoplam>
						<cf_wrk_crypto_gdpr mode="3" pattern="3" sensitive_label="7" data="#TLFormat(abs(all_borctoplam-all_alacaktoplam))# #session.ep.money# (A)">
					<cfelse>
						<cf_wrk_crypto_gdpr mode="3" pattern="3" sensitive_label="7" data="#TLFormat(abs(all_borctoplam-all_alacaktoplam))# #session.ep.money#">
					</cfif>
				</td>
			</tr>
		</cfoutput>
	</cf_grid_list>
</cfif>