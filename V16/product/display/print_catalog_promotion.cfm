<cfsetting showdebugoutput="no">
<cfscript>
	// sayıları sadece iki ondalıklı yapan fonksiyon
	function yuvarla(fInput) 
	{
	  fInput = fInput * 1.00;
	  if (listlen(fInput,".") eq 2)
		{
		if (left(listgetat(fInput,2,"."),2) neq "00")
			{
			fInput = "#listgetat(fInput,1,".")#.#left(listgetat(fInput,2,"."),2)#";  
			}
		else
			{
			fInput = listgetat(fInput,1,".");
			}
		}
	  return(fInput);
	}
</cfscript>
<cfset attributes.kek=1>
<cfset module_name="product">
<cfset var_="upd_purchase_basket">
<cfset attributes.var_="upd_purchase_basket">
<cfinclude template="../query/get_action_stages.cfm">
<cfinclude template="../query/get_price_cats.cfm">
<cfinclude template="../query/get_catalog_promotion_detail.cfm">
<cfif len(get_catalog_detail.VALID_EMP)>
  <cfquery name="GET_EMP2" datasource="#DSN#">
	  SELECT EMPLOYEE_NAME,EMPLOYEE_SURNAME FROM EMPLOYEES WHERE EMPLOYEE_ID = #get_catalog_detail.VALID_EMP#
  </cfquery>
<cfelseif len(get_catalog_detail.VALIDATOR_POSITION_CODE)>
  <cfquery name="GET_EMP_POSITION" datasource="#DSN#">
	  SELECT EMPLOYEE_ID ,EMPLOYEE_NAME , EMPLOYEE_SURNAME FROM EMPLOYEE_POSITIONS WHERE POSITION_ID = #get_catalog_detail.VALIDATOR_POSITION_CODE#
  </cfquery>
</cfif>
<cfquery name="GET_CAMPAIGN" datasource="#DSN3#">
	SELECT CAMP_ID,CAMP_HEAD,CAMP_FINISHDATE,CAMP_STARTDATE FROM CAMPAIGNS WHERE CAMP_FINISHDATE > #now()#  ORDER BY CAMP_HEAD
</cfquery>
<table  border="0" cellspacing="1" cellpadding="2" align="center" width="590">
	<tr>
		<td valign="top">
			<table width="100%">
				<tr>
					<td height="30" align="right" style="text-align:right;"><STRONG><cfoutput>#dateformat(get_catalog_detail.startdate,dateformat_style)# - #dateformat(get_catalog_detail.finishdate,dateformat_style)#</cfoutput></STRONG> <cf_get_lang dictionary_id='37276.Tarihli'> <STRONG><cfoutput>#get_catalog_detail.catalog_head#</cfoutput></STRONG></td>
				</tr>
			</table>
			<br/>
			<table border="0">
				<tr>
					<td width="100" class="txtbold"><cf_get_lang dictionary_id='37272.Katalog No'></td>
					<td>
						<cfoutput>#get_catalog_detail.CAT_PROM_NO#</cfoutput>
						<cfif get_catalog_detail.catalog_status is 1>
							<cf_get_lang dictionary_id='57493.Aktif'>
						<cfelse>
							<cf_get_lang dictionary_id='57494.Pasif'>
						</cfif>
						<cfoutput query="get_action_stages">
							<cfif get_catalog_detail.stage_id eq stage_id>
							#stage_name#
							</cfif>
						</cfoutput>
					</td>
				</tr>
			<tr>
				<td class="txtbold">
					<cfif get_catalog_detail.valid eq 1>
						<cf_get_lang dictionary_id='58699.Onaylandı'>
					<cfelseif get_catalog_detail.valid eq 0>
						<cf_get_lang dictionary_id='57617.Reddedildi'>
					<cfelse>
						<cf_get_lang dictionary_id='57615.Onay Bekliyor'>
					</cfif>
				</td>
				<td>
					<cfif len(get_catalog_detail.valid)>
						<cfif get_emp2.recordcount>
							<cfset record_date = date_add('h',session.ep.TIME_ZONE,get_catalog_detail.validate_date)>
							<cfoutput> #get_emp2.employee_name# #get_emp2.employee_surname# (#dateformat(date_add('h',session.ep.time_zone,record_date),dateformat_style)# #timeformat(date_add('h',session.ep.time_zone,record_date),timeformat_style)#) </cfoutput>
						<cfelse>
							<cf_get_lang dictionary_id='37219.Bilinmiyor'>
						</cfif>
					<cfelse>
						<input type="hidden" name="valid" id="valid" value="">
					</cfif>
				</td>
			</tr>
			<cfif not len(get_catalog_detail.valid)>
				<tr>
					<td class="txtbold"><cf_get_lang dictionary_id='37275.Onaylayacak'></td>
					<td>
						<cfif len(get_catalog_detail.VALIDATOR_POSITION_CODE)>
							<cfoutput>#GET_EMP_POSITION.EMPLOYEE_NAME# #GET_EMP_POSITION.EMPLOYEE_SURNAME#</cfoutput>
						</cfif>
					</td>
				</tr>
			</cfif>
			<tr>
				<td class="txtbold"><cf_get_lang dictionary_id='57483.Kayıt'></td>
				<td>
					<cfset attributes.emp_id = get_catalog_detail.record_emp>
					<cfinclude template="../query/get_employee_name.cfm">
					<cfoutput>#GET_EMPLOYEES.EMPLOYEE_NAME# #GET_EMPLOYEES.EMPLOYEE_SURNAME# - #dateformat(get_catalog_detail.RECORD_DATE,dateformat_style)#</cfoutput>
				</td>
			</tr>
			<tr>
				<td class="txtbold"><cf_get_lang dictionary_id='37210.Aksiyon'></td>
				<td>
					<cfoutput>#get_catalog_detail.catalog_head#</cfoutput>
				</td>
			</tr>
			<tr>
				<td class="txtbold"><cf_get_lang dictionary_id='57629.Açıklama'></td>
				<td>
					<cfoutput>#get_catalog_detail.catalog_detail#</cfoutput>
				</td>
			</tr>		
			</table>
		</td>
	</tr>
	<tr>
		<td>
			<cfinclude template="basket_purchase_print.cfm">
		</td>
	</tr>
</table>
