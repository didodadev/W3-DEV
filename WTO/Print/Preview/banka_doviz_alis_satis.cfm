<cfset satir_sayisi=35>
<cfset satir_basla=1>
<cfset total_a = 0>
<cfset total_b = 0>
<cfset total_a_money = 0>
<cfset total_b_money = 0>
<cfquery name="GET_BANK_ACTIONS" datasource="#DSN2#">
	SELECT
		BA.ACTION_ID,
		BA.ACTION_TYPE,
		BA.ACTION_DETAIL,
		0 AS BORC,
		BA.ACTION_VALUE AS ALACAK,	
		BA.ACTION_CURRENCY_ID,
		BA.OTHER_CASH_ACT_VALUE,
		BA.ACTION_DATE,
		ACCOUNTS.ACCOUNT_NAME
	FROM
		BANK_ACTIONS BA,
		#dsn3_alias#.ACCOUNTS ACCOUNTS
	WHERE
		BA.ACTION_FROM_ACCOUNT_ID = ACCOUNTS.ACCOUNT_ID AND
		(BA.ACTION_ID =#attributes.action_id#
		OR
		BA.ACTION_ID = #attributes.action_id+1#)
		AND BA.ACTION_FROM_ACCOUNT_ID IS NOT NULL
	
	UNION ALL
	
	SELECT
		BA.ACTION_ID,
		BA.ACTION_TYPE,
		BA.ACTION_DETAIL,
		BA.ACTION_VALUE AS BORC,
		0 AS ALACAK,
		BA.ACTION_CURRENCY_ID,
		BA.OTHER_CASH_ACT_VALUE,
		BA.ACTION_DATE,
		ACCOUNTS.ACCOUNT_NAME
	FROM
		BANK_ACTIONS BA,	
		#dsn3_alias#.ACCOUNTS ACCOUNTS
	WHERE
		BA.ACTION_TO_ACCOUNT_ID = ACCOUNTS.ACCOUNT_ID AND
		(BA.ACTION_ID= #attributes.action_id#		
		OR
		BA.ACTION_ID = #attributes.action_id+1#)
		AND BA.ACTION_TO_ACCOUNT_ID IS NOT NULL
	ORDER BY
		BA.ACTION_ID ASC
</cfquery>
<cfif get_bank_actions.recordcount>
	<cfset page = Ceiling(get_bank_actions.recordcount/satir_sayisi)>
<cfelse>
	<cfset page = 1>
</cfif>
<cfquery name="COMPANY_INFO" datasource="#DSN#">
	SELECT COMPANY_NAME FROM OUR_COMPANY WHERE COMP_ID = #session.ep.company_id#
</cfquery>

<cfloop from="1" to="#page#" index="i"> 
	<table style="width:190mm;height:200mm;" cellpadding="0" cellspacing="0" border="0">
		<tr>
			<td valign="top">
				<cfif isDefined("attributes.print")>
					<script type="text/javascript">
						function waitfor()
						{
							window.close();
						}
						setTimeout("waitfor()",3000);
						window.opener.close();
						window.print();
					</script>
				</cfif>
				<br/>
				<table cellpadding="0" cellspacing="2" border="2">
					<tr>
						<td valign="top">
						<table width="100%">
						<cfoutput>
							<tr>
								<td>&nbsp;</td>
								<td align="center" class="headbold" colspan="3">&nbsp;</td>
								<td style="text-align:right;">&nbsp;</td>
								<td class="formbold" style="text-align:right;">#dateformat(get_bank_actions.action_date,dateformat_style)#</td>
							</tr>
							<tr>
								<td class="formbold" width="90"><cf_get_lang_main no='1073.ŞİRKET ADI'> :</td>
								<td class="formbold" colspan="3" style="width:150mm;">#company_info.company_name#</td>
							</tr>
						</cfoutput>
						</table>
						<br/>
						</td>
					</tr>
					<tr>
						<td valign="top" style="height:50mm"><br/>
						<table align="center" width="100%" height="75">
							<tr bgcolor="CCCCCC">
								<td class="formbold" width="200" align="center"><cf_get_lang_main no='109.BANKA'> <cf_get_lang_main no='240.HESAP'> <cf_get_lang_main no='485.ADI'></td>
								<td class="formbold" width="150" align="center"><cf_get_lang_main no='217.AÇIKLAMA'></td>
								<td class="formbold" width="105" align="center"><cf_get_lang_main no='175.BORÇ'> <cf_get_lang_main no='261.TUTARI'></td>
								<td class="formbold" width="105" align="center"><cf_get_lang_main no='176.ALACAK'> <cf_get_lang_main no='261.TUTARI'></td>
							</tr>
							<cfoutput query="get_bank_actions" startrow="#satir_basla#" maxrows="#satir_sayisi#">
							<tr height="20">
								<td>#get_bank_actions.account_name#</td>
								<td>#get_bank_actions.action_type#</td>
								<td align="center">&nbsp;#TLFormat(get_bank_actions.borc)# #get_bank_actions.action_currency_id#<cfset total_b = total_b + get_bank_actions.borc><cfset total_b_money = get_bank_actions.action_currency_id></td>
								<td align="center">&nbsp;#TLFormat(get_bank_actions.alacak)# #get_bank_actions.action_currency_id#<cfset total_a = total_a + get_bank_actions.alacak><cfset total_a_money = get_bank_actions.action_currency_id></td>
							</tr>
							</cfoutput>		  
						</table>
						</td>
					</tr>
					<cfif i neq page>
						<tr> 
							<td valign="top" height="100">
							<table width="100%">
								<tr height="20">
									<td class="formbold" colspan="8"><cf_get_lang no="247.Fiş devam ediyor">...<br/></td>
								</tr>
								<tr>
									<td>&nbsp;</td>
								</tr>
							</table>
							</td>
						</tr>
					<cfelse>
						<tr> 
							<td valign="top" height="50">
							<table width="100%" cellspacing="0" cellpadding="0" border="0">
								<tr height="20">
									<td class="formbold"><cf_get_lang_main no='261.TUTAR'> :</td>
									<td class="formbold" width="600" align="left" nowrap><cfoutput>#TLFormat(total_b)# #total_b_money#</cfoutput></td>
									<cfset cols_ = 3>
								</tr>
								<tr>
									<td colspan="<cfoutput>#cols_#</cfoutput>">&nbsp;</td>
								</tr>
								<tr>
									<td class="formbold">
										<cf_get_lang_main no="2220.YALNIZ"> :
										<cfset mynumber = total_b>
										<cfset pbirimi = total_b_money>
									</td>
									<td class="formbold" width="600" nowrap><cf_n2txt number="mynumber" para_birimi='#total_b_money#'> <cfoutput>#mynumber# 'dir.</cfoutput></td>
								</tr>
							</table>
							<br/>
							</td>
						</tr> 
					</cfif>  
					<tr>
						<td>
						<table width="100%">
							<tr>
								<td class="formbold"><cf_get_lang_main no='1545.İMZA'> :</td>
							</tr>			
							<tr>
								<td height="40">&nbsp;</td>
							</tr>
						</table>
						</td>
					</tr>
				</table>
			</td>
			<td style="width:10mm">&nbsp;</td>
		</tr>
	</table>
	<cfset satir_basla=satir_sayisi+satir_basla>
</cfloop>
