<!--- <cfinclude template="../../sales/query/get_moneys.cfm"> --->
<!--- <cfinclude template="../../sales/query/get_project_name.cfm"> --->
<cfquery name="GET_OPPORTUNITY" datasource="#DSN3#">
	SELECT * FROM  OPPORTUNITIES WHERE OPP_ID = #attributes.iid#
</cfquery>
<cfquery name="GET_OPPORTUNITY_TYPE" datasource="#DSN3#">
	SELECT OPPORTUNITY_TYPE_ID, OPPORTUNITY_TYPE FROM SETUP_OPPORTUNITY_TYPE ORDER BY OPPORTUNITY_TYPE
</cfquery>
<cfquery name="GET_PROBABILITY_NAME" datasource="#DSN3#">
    SELECT 
        SPR.PROBABILITY_NAME
    FROM  
        OPPORTUNITIES O,
        SETUP_PROBABILITY_RATE SPR
    WHERE
        O.PROBABILITY=SPR.PROBABILITY_RATE_ID AND 
        O.OPP_ID=#attributes.iid#
</cfquery>
<br/><br/>
<table align="center">
	<tr>
		<td><h4>SATIŞ FIRSATI</h4></td>
	</tr>
</table>
<table align="center">
	<tr>
		<td>
		<table>
			<tr>
				<td width="140" class="txtbold"><cf_get_lang_main no='200.Fırsat'><cf_get_lang_main no='75.No'> : </td>
				<td width="170"><cfoutput>#get_opportunity.opp_no#</cfoutput></td>
				<td width="100" class="txtbold"><cf_get_lang_main no='1195.Firma'>/<cf_get_lang_main no='166.Yetkili'> : </td>
				<td width="200"><cfif len(get_opportunity.partner_id)><cfoutput>#get_par_info(get_opportunity.company_id,1,0,0)#</cfoutput></cfif></td>
			</tr>
			<tr>
				<td class="txtbold"><cf_get_lang_main no='68.Konu'> : </td>
				<td><cfoutput>#get_opportunity.opp_head#</cfoutput></td>
				<td class="txtbold"><cf_get_lang_main no='1372.Referans'> : </td>
				<td><cfif len(get_opportunity.ref_partner_id)><cfoutput>#get_par_info(get_opportunity.ref_company_id,1,0,0)#</cfoutput>
					<cfelseif len(get_opportunity.ref_consumer_id)><cfoutput>#get_cons_info(get_opportunity.ref_consumer_id,1,0,0)#</cfoutput></cfif>
				</td>
			</tr>
			<tr>
				 <td class="txtbold"><cf_get_lang_main no='4.Proje'> : </td>
				<td><cfif isdefined("get_opportunity.project_id") and len(get_opportunity.project_id)><cfoutput>#get_project_name(get_opportunity.project_id)#</cfoutput></cfif></td>

				<td class="txtbold"><cf_get_lang no="923.Satış Çalışanı"> : </td>
				<td><cfoutput><cfif len(get_opportunity.sales_emp_id)>#get_emp_info(get_opportunity.sales_emp_id,0,0)#</cfif></cfoutput></td>
			</tr>
			<tr>
				<td class="txtbold"><cf_get_lang_main no="200.Fırsat"> (<cf_get_lang no="921.Başvuru">) <cf_get_lang_main no="1181.Tarihi"> : </td>
				<td><cfoutput>#dateformat(get_opportunity.opp_date,dateformat_style)#</cfoutput></td>
				<td class="txtbold"><cf_get_lang no='1777.Satış Ortağı'> : </td>
				<td><cfoutput><cfif len(get_opportunity.sales_partner_id)>#get_par_info(get_opportunity.sales_partner_id,0,-1,0)#</cfif></cfoutput></td>
			</tr>
			<tr>
				<td class="txtbold"><cf_get_lang_main no='74.Kategori'> : </td>
				<td><cfoutput query="get_opportunity_type"><cfif opportunity_type_id eq get_opportunity.opportunity_type_id>#opportunity_type#</cfif></cfoutput></td>
				<td class="txtbold"><cf_get_lang no="922.Hareket Durumu"> : </td>
				<td><cfif get_opportunity.activity_time eq 1><cf_get_lang no='1781.Hemen'>
					<cfelseif get_opportunity.activity_time eq 7>1 <cf_get_lang_main no='1322.Hafta'>
					<cfelseif get_opportunity.activity_time eq 30>1 <cf_get_lang_main no='1312.Ay'>
					<cfelseif get_opportunity.activity_time eq 90>3 <cf_get_lang_main no='1312.Ay'>
					<cfelseif get_opportunity.activity_time eq 180>6 <cf_get_lang_main no='1312.Ay'>
					<cfelseif get_opportunity.activity_time eq 181>6 <cf_get_lang no='1782.Aydan Fazla'></cfif>
				</td>
			</tr>
			<tr>
				<td class="txtbold"><cf_get_lang_main no='217.Açıklama'> : </td>
				<td colspan="4" rowspan="3" width="500"><cfoutput>#get_opportunity.opp_detail#</cfoutput></td>
			</tr>
		</table>
		<br/><br/>
		<table>
			<tr>
				<td width="130" class="txtbold" bgcolor="CCCCCC"><cf_get_lang_main no='809.Ürün Adı'></td>
				<td width="160" class="txtbold" bgcolor="CCCCCC"><cf_get_lang_main no='1604.Ürün Kategorisi'></td>
				<td width="120" class="txtbold" bgcolor="CCCCCC"><cf_get_lang_main no='1888.Tahmini'><cf_get_lang_main no='1265.Gelir'></td>
				<td width="120" class="txtbold" bgcolor="CCCCCC"><cf_get_lang_main no='1888.Tahmini'><cf_get_lang_main no='846.Maliyet'></td>
				<td width="100" class="txtbold" bgcolor="CCCCCC"><cf_get_lang_main no='1240.Olasılık'></td>
			</tr>
			<tr>
				<td><cfif len(get_opportunity.stock_id)>
						<cfset attributes.stock_id = get_opportunity.stock_id>
						<cfinclude template="/V16/sales/query/get_stock_name.cfm">
						<cfoutput>#get_stock_name.product_name#</cfoutput>
					</cfif>
				</td>
				<td><cfif len(get_opportunity.product_cat_id)>
						<cfset attributes.ID = get_opportunity.product_cat_id>
						<cfinclude template="/V16/product/query/get_product_cat.cfm">
						<cfoutput>#get_product_cat.hierarchy# #get_product_cat.product_cat#</cfoutput>
					</cfif>
				</td>
				<td style="text-align:right;"><cfoutput>#TLFormat(get_opportunity.income)# #get_opportunity.money#</cfoutput></td>
				<td style="text-align:right;"><cfoutput>#TLFormat(get_opportunity.cost)# #get_opportunity.money#</cfoutput></td>
				<td style="text-align:right;"><cfoutput>#GET_PROBABILITY_NAME.PROBABILITY_NAME#</cfoutput>
					<!--- <cfif get_opportunity.probability eq 84>%10
					<cfelseif get_opportunity.probability eq 85>%20
					<cfelseif get_opportunity.probability eq 86>%30
					<cfelseif get_opportunity.probability eq 87>%40
					<cfelseif get_opportunity.probability eq 88>%50
					<cfelseif get_opportunity.probability eq 89>%60
					<cfelseif get_opportunity.probability eq 90>%70
					<cfelseif get_opportunity.probability eq 91>%80
					<cfelseif get_opportunity.probability eq 92>%90
					<cfelseif get_opportunity.probability eq 93>%100</cfif>  --->
				</td>
			</tr>
		</table>
		</td>
	</tr>
</table>
