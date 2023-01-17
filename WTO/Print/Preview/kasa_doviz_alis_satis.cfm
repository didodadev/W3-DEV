<!--- Kasa Doviz Alis Satis --->
<cfset total_a = 0>
<cfset total_b = 0>
<cfquery name="GET_CASH_ACTIONS" datasource="#DSN2#">
	SELECT
		*
	FROM
		CASH_ACTIONS
	WHERE
		ACTION_ID = #attributes.action_id# OR
		ACTION_ID = #attributes.action_id+1#
	ORDER BY
		ACTION_ID ASC
</cfquery>

<cfquery name="COMPANY_INFO" datasource="#DSN#">
	SELECT
		COMPANY_NAME
	FROM
		OUR_COMPANY
	WHERE
		COMP_ID = #session.ep.company_id# 
</cfquery>
<cfquery name="get_money" datasource="#dsn2#">
	SELECT * FROM CASH_ACTION_MONEY WHERE IS_SELECTED = 1 AND ACTION_ID = #attributes.action_id#
</cfquery>
<table style="width:190mm;height:200mm;" cellpadding="0" cellspacing="0" border="0">
	<tr>
		<td style="width:1mm;"></td>
		<td valign="top">
		<table cellpadding="0" cellspacing="2" border="2">
			<tr>
				<td valign="top">
				<table width="100%">
					<cfoutput>
					<tr>
						<td>&nbsp;</td>
						<td style="text-align:center" class="headbold" colspan="3">&nbsp;</td>
						<td style="text-align:right">&nbsp;</td>
						<td class="formbold" style="text-align:right">#dateformat(get_cash_actions.action_date,dateformat_style)#</td>
					</tr>
					<tr>
						<td class="formbold" width="90"><cf_get_lang_main no='1073.ŞİRKET ADI'> :</td>
						<td class="formbold" colspan="3" style="width:150mm;">#company_info.company_name#</td> 
					</tr>
					<tr>
						<td class="formbold" width="90"><cf_get_lang_main no='388.İŞLEM TİPİ'> :</td>
						<td class="formbold" colspan="3" style="width:150mm;">#get_cash_actions.action_type#</td> 
					</tr>
					</cfoutput>
				</table><br/>
				</td>
			</tr>
			<tr>
				<td valign="top" style="height:50mm"><br/>
				<table align="center" width="100%" height="75">
					<tr bgcolor="CCCCCC">
						<td class="formbold" width="200" style="text-align:center"><cf_get_lang_main no='108.KASA'> <cf_get_lang no='244.HESAP ADI'></td>
						<td class="formbold" width="150" style="text-align:center"><cf_get_lang_main no='217.AÇIKLAMA'></td>
						<td class="formbold" width="105" style="text-align:center"><cf_get_lang_main no='175.BORÇ'> <cf_get_lang_main no='261.TUTARI'></td>
						<td class="formbold" width="105" style="text-align:center"><cf_get_lang_main no='176.ALACAK'> <cf_get_lang_main no='261.TUTARI'></td>
					</tr>
					<cfoutput query="get_cash_actions">
					<tr height="20">
						<td>
							<cfquery name="get_cash_name" datasource="#dsn2#">
								SELECT CASH_NAME FROM CASH WHERE CASH_ID = <cfif len(cash_action_from_cash_id)>#cash_action_from_cash_id#<cfelse>#cash_action_to_cash_id#</cfif>
							</cfquery>
							#get_cash_name.cash_name#
						</td>
						<td><cfif len(cash_action_from_cash_id)>#tlformat(cash_action_value/get_money.rate2)#<cfelse>#tlformat(cash_action_value)#</cfif>&nbsp;#get_money.money_type#</td>
						<td><cfif len(CASH_ACTION_TO_CASH_ID)>#tlformat((cash_action_value*(get_money.rate2/get_money.rate1)))#&nbsp;#session.ep.money#<cfset total_b= total_b+(cash_action_value*(get_money.rate2/get_money.rate1))><cfset doviz = cash_action_value></cfif></td>
						<td><cfif len(CASH_ACTION_FROM_CASH_ID)>#tlformat(cash_action_value)#&nbsp;#session.ep.money#<cfset total_a = total_a + cash_action_value></cfif></td>
					</tr>
					</cfoutput>		  
					<tr height="150">
						<td colspan="2" class="txtbold" style="text-align:right"><cf_get_lang_main no='80.Toplam'>:</td>
						<td><cfoutput>#tlformat(total_b)#</cfoutput></td>
						<td><cfoutput>#tlformat(total_a)#</cfoutput></td>
					</tr>
				</table>
				</td>
			</tr>
			<tr> 
				<td valign="top" height="50">
				<table width="100%" cellspacing="0" cellpadding="0">
				<cfoutput>
					<tr height="20">
						<td class="formbold" width="100%"><cf_get_lang_main no='217.Açıklama'>&nbsp;:#tlformat(doviz)#&nbsp;#get_money.money_type#</td>
					</tr>
					<tr>
						<td class="formbold">
							<cf_get_lang_main no="2220.YALNIZ"> &nbsp;&nbsp;
							<cfset mynumber = total_a>
							<cf_n2txt number="mynumber"> #mynumber# 'dir.
						</td>
					</tr>
				</cfoutput>
				</table><br/>
				</td>
			</tr> 
			<tr>
				<td>
				<table width="100%">
					<tr>
						<td class="formbold"><cf_get_lang_main no='1545.İMZA'> :</td>
					</tr>			
					<tr><td height="40"></tr>
				</table>
				</td>
			</tr>
			<tr><td><!--- <cfoutput>#i#/#page#</cfoutput> ---></td></tr>	
		</table>
		</td>
		<td style="width:10mm">&nbsp;</td>
	</tr>
</table>
