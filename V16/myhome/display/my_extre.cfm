<cfif validate_style eq "eurodate">
	<cfset date1="01/01/#session.ep.period_year#">
	<cfset date2="31/12/#session.ep.period_year#">	
<cfelse>
	<cfset date1="01/01/#session.ep.period_year#">
	<cfset date2="12/31/#session.ep.period_year#">
</cfif>
<cf_date tarih='date1'>
<cf_date tarih='date2'>
<cfquery name="get_member_accounts" datasource="#dsn#">
    SELECT *,0 AS ACC_TYPE_ID FROM EMPLOYEES WHERE EMPLOYEE_ID = #session.ep.userid#
</cfquery>
<cfset attributes.employee_id = session.ep.userid>
<cfset attributes.member_type = 'employee'>
<cfset member_type = 'employee'>
<cfset attributes.company = '#session.ep.name# #session.ep.surname#'>
<cfset attributes.is_submitted = 1>
<input type="hidden" name="is_submitted" id="is_submitted" value="1">
<cfsavecontent variable="head_">
<cf_get_lang dictionary_id='57809.Hesap Extresi'> / <cfoutput>#dateformat(date1,dateformat_style)# - #dateformat(date2,dateformat_style)#</cfoutput>
	<cfif not(isdefined("x_select_ch_type") and x_select_ch_type eq 1)>
		: <cfoutput>#session.ep.name# #session.ep.surname#</cfoutput>
	</cfif>
</cfsavecontent>
<cfscript>
	all_borctoplam = 0;
	all_alacaktoplam = 0;
	attributes.acc_type_id = '';
	if(listlen(attributes.employee_id,'_') eq 2)
	{
		attributes.acc_type_id = listlast(attributes.employee_id,'_');
		attributes.employee_id = listfirst(attributes.employee_id,'_');
	}	
</cfscript>

<cfif fusebox.use_period>
	<cf_box title=#head_# id="list_extre" closable="0">
		<cfloop query="get_member_accounts">
			<cfif isdefined("get_member_accounts.acc_type_name")>
				<cf_seperator header="#get_member_accounts.acc_type_name#" id="#currentrow#">
			</cfif>
			<cf_flat_list id="#currentrow#">		
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
					<cfif (isdefined('attributes.company_id') and len(attributes.company_id) and len(attributes.company) and member_type is 'partner') or (isdefined("attributes.member_cat_type") and len(attributes.member_cat_type) and listfirst(attributes.member_cat_type,'-') eq 1) or (isdefined("attributes.pos_code") and len(attributes.pos_code) and len(attributes.pos_code_text))>
						FROM_CMP_ID = #attributes.COMPANY_ID# AND
					<cfelseif (isdefined('attributes.consumer_id') and  len(attributes.consumer_id) and len(attributes.company) and member_type is 'consumer') or (isdefined("attributes.member_cat_type") and len(attributes.member_cat_type) and listfirst(attributes.member_cat_type,'-') eq 2)>
						FROM_CONSUMER_ID = #attributes.consumer_id# AND
					<cfelseif isdefined('attributes.employee_id') and  len(attributes.employee_id) and len(attributes.company) and member_type is 'employee'>
						FROM_EMPLOYEE_ID = #attributes.employee_id# AND
					</cfif>
					<cfif isdefined("get_member_accounts.acc_type_id") and get_member_accounts.acc_type_id neq 0>
						ACC_TYPE_ID = #get_member_accounts.acc_type_id# AND
					<cfelseif isdefined("attributes.acc_type_id") and len(attributes.acc_type_id) and attributes.acc_type_id neq 0>
						ACC_TYPE_ID = #attributes.acc_type_id# AND
					</cfif>
					CR.ACTION_DATE >= #date1# AND 
					CR.ACTION_DATE <= #date2#
					AND CR.FROM_EMPLOYEE_ID = #session.ep.userid#
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
					<cfif (isdefined('attributes.company_id') and len(attributes.company_id) and len(attributes.company) and member_type is 'partner') or (isdefined("attributes.member_cat_type") and len(attributes.member_cat_type) and listfirst(attributes.member_cat_type,'-') eq 1) or (isdefined("attributes.pos_code") and len(attributes.pos_code) and len(attributes.pos_code_text))>
						TO_CMP_ID = #attributes.COMPANY_ID# AND
					<cfelseif (isdefined('attributes.consumer_id') and  len(attributes.consumer_id) and len(attributes.company) and member_type is 'consumer') or (isdefined("attributes.member_cat_type") and len(attributes.member_cat_type) and listfirst(attributes.member_cat_type,'-') eq 2)>
						TO_CONSUMER_ID = #attributes.consumer_id# AND
					<cfelseif isdefined('attributes.employee_id') and  len(attributes.employee_id) and len(attributes.company) and member_type is 'employee'>
						TO_EMPLOYEE_ID = #attributes.employee_id# AND
					</cfif>
					<cfif isdefined("get_member_accounts.acc_type_id") and get_member_accounts.acc_type_id neq 0>
						ACC_TYPE_ID = #get_member_accounts.acc_type_id# AND
					<cfelseif isdefined("attributes.acc_type_id") and len(attributes.acc_type_id) and attributes.acc_type_id neq 0>
						ACC_TYPE_ID = #attributes.acc_type_id# AND
					</cfif>
					CR.ACTION_DATE >= #date1# AND 
					CR.ACTION_DATE <= #date2#
					AND CR.TO_EMPLOYEE_ID = #session.ep.userid#
				ORDER BY 
					ACTION_DATE
			</cfquery>
			<thead>
				<tr>
					<th width="5%"><cf_get_lang dictionary_id='57742.Tarih'></td>
					<th width="30%"><cf_get_lang dictionary_id='57692.İşlem'></td>
					<th width="35%"><cf_get_lang dictionary_id="57629.Açıklama"></td>
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
						<tr>
							<td>#dateformat(action_date,dateformat_style)#</td>
							<td>#action_name#</td>
							<td>#action_detail#</td>
							<td style="text-align:right;">#TLFormat(borc)# #session.ep.money#</td>
							<td style="text-align:right;">#TLFormat(alacak)# #session.ep.money#</td>
							<td style="text-align:right;">
								<cfif borctoplam GT alacaktoplam>
									#TLFormat(total)# #session.ep.money# -B
								<cfelse>
									#TLFormat(total)# #session.ep.money# -A
								</cfif>
							</td>
						</tr>
					</cfoutput>
			</tbody>
			<tfoot>
				<cfoutput>
					<tr>
						<td width="70%" colspan="3" style="text-align:right;"><cf_get_lang dictionary_id="57492.Toplam"></td>
						<td style="text-align:right;">#TLFormat(borctoplam)# #session.ep.money#</td>
						<td style="text-align:right;">#TLFormat(alacaktoplam)# #session.ep.money#</td>
						<td style="text-align:right;">
							<cfif borctoplam GT alacaktoplam>
								#TLFormat(total)# #session.ep.money# (B)
							<cfelseif borctoplam LT alacaktoplam>
								#TLFormat(total)# #session.ep.money# (A)
							<cfelse>
								#TLFormat(total)# #session.ep.money#
							</cfif>
					</td>
				</tr>
				</cfoutput>
			</tfoot>
			<cfelse>
			<tbody>
				<tr>
					<td colspan="6"><cfif isdefined("attributes.is_submitted")><cf_get_lang dictionary_id='57484.Kayıt Yok'><cfelse><cf_get_lang dictionary_id='57701.Filtre Ediniz'></cfif>!</td>
				</tr>
			</tbody>	
			</cfif>
			</cf_flat_list>
		</cfloop>
		<cf_flat_list>
			<cfif isdefined("get_member_accounts.acc_type_name") and (all_borctoplam neq 0 or all_alacaktoplam neq 0)>
				<tfoot>
					<cfoutput>
						<tr>
							<td width="70%" colspan="3" class="txtbold" style="text-align:right;"><cf_get_lang dictionary_id="57680.Genel Toplam"></td>
							<td width="10%" class="txtbold" style="text-align:right;">#TLFormat(all_borctoplam)# #session.ep.money#</td>
							<td width="10%" class="txtbold" style="text-align:right;">#TLFormat(all_alacaktoplam)# #session.ep.money#</td>
							<td width="10%" class="txtbold" style="text-align:right;">
								<cfif all_borctoplam GT all_alacaktoplam>
									#TLFormat(abs(all_borctoplam-all_alacaktoplam))# #session.ep.money# (B)
								<cfelseif all_borctoplam LT all_alacaktoplam>
									#TLFormat(abs(all_borctoplam-all_alacaktoplam))# #session.ep.money# (A)
								<cfelse>
									#TLFormat(abs(all_borctoplam-all_alacaktoplam))# #session.ep.money#
								</cfif>
							</td>
						</tr>
					</cfoutput>
				</tfoot>
			<cfelseif isdefined("get_member_accounts.acc_type_name") and all_borctoplam eq 0 and all_alacaktoplam eq 0>
				<tbody>
					<tr>
						<td colspan="6"><cf_get_lang dictionary_id='57484.Kayıt Yok'>!</td>
					</tr>
				</tbody>
			</cfif>
		</cf_flat_list>
	</cf_box>
</cfif>

<cfinclude  template="../display/list_my_bordro.cfm">

<cfinclude  template="../display/list_payment_request.cfm">
