<cfquery name="get_offer" datasource="#dsn3#">
	SELECT OFFER_NUMBER,PURCHASE_SALES FROM OFFER WHERE OFFER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.offer_id#">
</cfquery>
<cfquery name="get_offer_row" datasource="#dsn3#">
	SELECT * FROM OFFER_ROW WHERE OFFER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.offer_id#">
</cfquery>
<cfquery name="get_offer_new" datasource="#dsn3#">
	SELECT OFFER_NUMBER FROM OFFER WHERE OFFER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.rel_offer_id#">
</cfquery>
<cfquery name="get_rel_offer_row" datasource="#dsn3#">
	SELECT * FROM OFFER_ROW WHERE OFFER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.rel_offer_id#">
</cfquery>
<cfif get_offer.purchase_sales eq 0>
	<cfoutput query="get_offer_row">
		<cfloop query="get_rel_offer_row">
			<cfif get_offer_row.wrk_row_id eq get_rel_offer_row.wrk_row_relation_id>
				<cfset "rel_amount_#get_offer_row.wrk_row_id#" = get_rel_offer_row.quantity>
				<cfset "rel_price_#get_offer_row.wrk_row_id#" = get_rel_offer_row.price_other>
				<cfset "rel_price_money_#get_offer_row.wrk_row_id#" = get_rel_offer_row.other_money>
			</cfif>
		</cfloop>
	</cfoutput>
<cfelse>
	<cfoutput query="get_offer_row">
		<cfloop query="get_rel_offer_row">
			<cfif get_rel_offer_row.wrk_row_id eq get_offer_row.wrk_row_relation_id>
				<cfset "rel_amount_#get_offer_row.wrk_row_relation_id#" = get_rel_offer_row.quantity>
				<cfset "rel_price_#get_offer_row.wrk_row_relation_id#" = get_rel_offer_row.price_other>
				<cfset "rel_price_money_#get_offer_row.wrk_row_relation_id#" = get_rel_offer_row.other_money>
			</cfif>
		</cfloop>
	</cfoutput>
</cfif>
<table width="98%" border="0" cellspacing="0" cellpadding="0" align="center">
	<tr> 
		<td class="headbold" height="35"><cf_get_lang dictionary_id='60085.Teklif Karşılaştırma Raporu'>: <cfoutput>#get_offer.OFFER_NUMBER#</cfoutput></td>
		<cf_workcube_file_action pdf='1' mail='1' doc='1' print='1'>
	</tr>
</table>
<table width="98%" border="0" cellspacing="1" cellpadding="2" align="center" class="color-border">
	<tr class="color-header">
		<td height="22" class="form-title"></td>
		<cfif get_offer.purchase_sales eq 1>
			<td height="22" class="form-title" colspan="3" align="center"><cf_get_lang dictionary_id='30007.Satış Teklifi'></td>
			<td height="22" class="form-title" colspan="3" align="center"><cf_get_lang dictionary_id='39529.Alış Teklifi'></td>
		<cfelse>
			<td height="22" class="form-title" colspan="3" align="center"><cf_get_lang dictionary_id='39529.Alış Teklifi'></td>
			<td height="22" class="form-title" colspan="3" align="center"><cf_get_lang dictionary_id='30007.Satış Teklifi'></td>
		</cfif>
	</tr>
	<tr class="color-header"> 
		<td height="22" class="form-title"><cf_get_lang dictionary_id='57657.Ürün'></td>
		<td class="form-title" align="center"><cf_get_lang dictionary_id='57635.Miktar'></td>
		<td class="form-title" align="center"><cf_get_lang dictionary_id='57673.Tutar'></td>
		<td class="form-title" align="center"><cf_get_lang dictionary_id='57677.Döviz'></td>
		<td class="form-title" align="center"><cf_get_lang dictionary_id='57635.Miktar'></td>
		<td class="form-title" align="center"><cf_get_lang dictionary_id='57673.Tutar'></td>
		<td class="form-title" align="center"><cf_get_lang dictionary_id='57677.Döviz'></td>
	</tr>
	<cfoutput query="get_offer_row">
		<tr class="color-row" height="20">
			<td>#get_offer_row.PRODUCT_NAME#</td>
			<td  style="text-align:right;">#quantity#</td>
			<td  style="text-align:right;">#tlformat(price_other)#</td>
			<td>#other_money#</td>
			<cfif get_offer.purchase_sales eq 0>
				<td  style="text-align:right;"><cfif isdefined("rel_amount_#wrk_row_id#")>#evaluate("rel_amount_#wrk_row_id#")#</cfif></td>
				<td  style="text-align:right;"><cfif isdefined("rel_price_#wrk_row_id#")>#tlformat(evaluate("rel_price_#wrk_row_id#"))#</cfif></td>
				<td><cfif isdefined("rel_price_money_#wrk_row_id#")>#evaluate("rel_price_money_#wrk_row_id#")#</cfif></td>
			<cfelse>
				<td  style="text-align:right;"><cfif isdefined("rel_amount_#wrk_row_relation_id#")>#evaluate("rel_amount_#wrk_row_relation_id#")#</cfif></td>
				<td  style="text-align:right;"><cfif isdefined("rel_price_#wrk_row_relation_id#")>#tlformat(evaluate("rel_price_#wrk_row_relation_id#"))#</cfif></td>
				<td><cfif isdefined("rel_price_money_#wrk_row_relation_id#")>#evaluate("rel_price_money_#wrk_row_relation_id#")#</cfif></td>
			</cfif>
		</tr>
	</cfoutput>
</table>
