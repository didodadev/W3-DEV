<cfsavecontent  variable="head"><cf_get_lang no ='1180.Prim Hakedişleri'></cfsavecontent>
<cf_seperator title="#head#" id="prim1">
<div id="prim1" style="padding: 10px; display: block;float: left; width: 100%">
<cfif member_type eq 'consumer' and len(attributes.consumer_id)>
	<cfquery name="get_consumers" datasource="#dsn#">
		SELECT 
			MEMBER_CODE,
			CONSUMER_ID,
			CONSUMER_NAME,
			CONSUMER_SURNAME,
			CONSUMER_REFERENCE_CODE
        FROM
        	CONSUMER WITH (NOLOCK)
		WHERE
			REF_POS_CODE = #attributes.consumer_id# 
		ORDER BY
			CONSUMER.CONSUMER_REFERENCE_CODE
	</cfquery>
    <cfif get_consumers.recordcount>
	<cfquery name="get_member_sale" datasource="#dsn2#">
		SELECT 
			ISNULL(SUM(GROSSTOTAL),0) GROSSTOTAL,
			CONSUMER_ID
		FROM(
			SELECT
				SUM(GROSSTOTAL) GROSSTOTAL,
				CONSUMER_ID								
			FROM
				INVOICE WITH (NOLOCK)
			WHERE
				CONSUMER_ID IN(#valuelist(get_consumers.consumer_id)#) AND
				IS_IPTAL = 0 AND
				INVOICE_CAT IN(52,53)
			GROUP BY
				CONSUMER_ID
		UNION ALL
			SELECT
				SUM(-1*GROSSTOTAL) GROSSTOTAL,
				CONSUMER_ID									
			FROM
				INVOICE WITH (NOLOCK)
			WHERE
				CONSUMER_ID IN(#valuelist(get_consumers.consumer_id)#) AND
				IS_IPTAL = 0 AND
				INVOICE_CAT IN(54,55,62)											
			GROUP BY
				CONSUMER_ID
			)T1		
		GROUP BY
			CONSUMER_ID
	</cfquery>
	<cfloop query="get_member_sale">
		<cfif len(get_member_sale.grosstotal)>	
			<cfset 'member_sale_#get_member_sale.consumer_id#'= get_member_sale.grosstotal>
		</cfif>
	</cfloop>
	<cfquery name="get_premium" datasource="#dsn2#">
		SELECT
			INVOICE_MULTILEVEL_PREMIUM.PREMIUM_RATE,
			SUM(INVOICE_MULTILEVEL_PREMIUM.PREMIUM_SYSTEM_TOTAL) PREMIUM_SYSTEM_TOTAL,
			INVOICE_MULTILEVEL_PREMIUM.PREMIUM_SYSTEM_MONEY,
			INVOICE_MULTILEVEL_PREMIUM.PREMIUM_LINE,
			INVOICE_MULTILEVEL_PREMIUM.CONSUMER_ID
		FROM
			INVOICE_MULTILEVEL_PREMIUM WITH (NOLOCK)
		WHERE
			CONSUMER_ID IN(#valuelist(get_consumers.consumer_id)#)
			<cfif isdate(attributes.start_date) and isdate(attributes.finish_date)>
				AND PREMIUM_DATE BETWEEN #attributes.start_date# AND #attributes.finish_date#
			<cfelseif isdate(attributes.start_date)>
				AND PREMIUM_DATE >= #attributes.start_date#
			<cfelseif isdate(attributes.finish_date)>
				AND PREMIUM_DATE <= #attributes.finish_date#
			</cfif>
		GROUP BY
			INVOICE_MULTILEVEL_PREMIUM.PREMIUM_RATE,
			INVOICE_MULTILEVEL_PREMIUM.PREMIUM_SYSTEM_MONEY,
			INVOICE_MULTILEVEL_PREMIUM.PREMIUM_LINE,
			INVOICE_MULTILEVEL_PREMIUM.CONSUMER_ID
	</cfquery>
	<cfloop query="get_premium">
		<cfif len(get_premium.premium_system_total)>	
			<cfset 'premium_#get_premium.premium_line#_#get_premium.consumer_id#'= get_premium.premium_system_total>
			<cfset 'premium_rate_#get_premium.premium_line#_#get_premium.consumer_id#'= get_premium.premium_rate>
		</cfif>
	</cfloop>
	<cfparam name="is_multilevel" default="3">
	<cfset xml_page_control_list = 'is_multilevel'>
	<cf_xml_page_edit page_control_list="#xml_page_control_list#" default_value="3" fuseact="report.bsc_company">
	
		<cfset total=0>
		<cf_grid_list>
			<thead>
				<tr>
					<th><cf_get_lang_main no ='146.Üye No'></th>
					<th><cf_get_lang_main no ='246.Üye'></th>
					<th><cf_get_lang no ='1181.Referans Kodu'></th>
					<th><cf_get_lang_main no ='2213.Ciro'></th>
					<cfoutput>
						<cfloop from="1" to="#is_multilevel#" index="prm_ind">
							<cfset 'prim_#prm_ind#'=0>
							<cfset 'prim_rate_#prm_ind#'=0>
							<th style="text-align:right;">#prm_ind#.Seviye %</th>
							<th style="text-align:right;">#prm_ind#.Seviye Prim</th>
						</cfloop>
					</cfoutput>
				</tr>
			</thead>
			<tbody>
				<cfoutput query="get_consumers">
					<tr class="color-row" height="20">
						<td>#MEMBER_CODE#</td>
						<td>#CONSUMER_NAME# #CONSUMER_SURNAME#</td>
						<td>#CONSUMER_REFERENCE_CODE#</td>
						<td align="right" style="text-align:right;">
							<cfif isdefined("member_sale_#consumer_id#")>
								<cfset gross_total = evaluate("member_sale_#consumer_id#")>
							<cfelse>
								<cfset gross_total = 0>
							</cfif>
							<cfset total=total+gross_total>
							#TLFormat(gross_total)#
						</td>
						<cfloop from="1" to="#is_multilevel#" index="prm_ind">
							<cfif isdefined("premium_#prm_ind#_#consumer_id#")>
								<cfset premium_total = evaluate("premium_#prm_ind#_#consumer_id#")>
							<cfelse>
								<cfset premium_total = 0>
							</cfif>
							<cfif isdefined("premium_rate_#prm_ind#_#consumer_id#")>
								<cfset premium_rate = evaluate("premium_rate_#prm_ind#_#consumer_id#")>
							<cfelse>
								<cfset premium_rate = 0>
							</cfif>
							<cfset 'prim_#prm_ind#'=evaluate('prim_#prm_ind#')+premium_total>
							<td align="right" style="text-align:right;">%#premium_rate#</td>
							<td align="right" style="text-align:right;">#TLFormat(premium_total)# #session.ep.money#</td>
						</cfloop>
					</tr>
				</cfoutput>
				<tr class="color-row" height="20">
					<td colspan="3" class="txtboldblue"><cf_get_lang_main no ='80.Toplam'></td>
					<td align="right" class="txtboldblue" style="text-align:right;"><cfoutput>#TLFormat(total)# #session.ep.money#</cfoutput></td>
					<cfoutput>
						<cfloop from="1" to="#is_multilevel#" index="prm_ind">
							<td align="right" class="txtboldblue" style="text-align:right;"></td>
							<td align="right" class="txtboldblue" style="text-align:right;">#TLFormat(evaluate('prim_#prm_ind#'))# #session.ep.money#</td>
						</cfloop>
					</cfoutput>
				</tr>
			</tbody>
		</cf_grid_list>

	<cfelse>
		<cf_get_lang no ='1182.Prim Faturası Bulunamadı'>!
	</cfif>
</cfif>
</div>