<cfquery name="get_det_po" datasource="#dsn3#">
	SELECT
		PO.P_ORDER_ID,
		PO.FINISH_DATE,
		PO.P_ORDER_NO,
		S.PROPERTY,
		P.PRODUCT_NAME,
		P.PRODUCT_ID,
		S.STOCK_ID
	FROM
		PRODUCTION_ORDERS PO,
		STOCKS S,
		PRODUCT P
	WHERE
		PO.P_ORDER_ID = #attributes.action_id# AND
		PO.STOCK_ID = S.STOCK_ID AND
		S.PRODUCT_ID = P.PRODUCT_ID
</cfquery>

<cfset uretim_no_ = "#attributes.action_id#">
<cfloop from="1" to="#6-len(attributes.action_id)#" index="smk">
	<cfset uretim_no_ = "0" & uretim_no_>
</cfloop>

<cfset stock_ = "#get_det_po.STOCK_ID#">
<cfloop from="1" to="#6-len(get_det_po.STOCK_ID)#" index="smk">
	<cfset stock_ = "0" & stock_>
</cfloop>
<cfset seri_ = "#uretim_no_##stock_#">

<cfif len(get_det_po.finish_date)>
	<cfset finishdate = dateformat(date_add('h',session.ep.time_zone,get_det_po.finish_date),dateformat_style)>
<cfelse>
	<cfset finishdate = "">
</cfif>

<cfsavecontent variable="my_seri_"><CF_BarcodeGenerator BarCode="#seri_#"></cfsavecontent>

<cfloop from="1" to="25" index="mcm">
	<table cellpadding="2" cellspacing="2" border="1">
		<cfloop from="1" to="5" index="uss">
			<cfif uss lt 3>
			<tr>
				<td style="width:3.5cm;height:1.5cm;" align="center" class="print">
				<cfoutput>
				#get_det_po.PRODUCT_NAME##get_det_po.PROPERTY#
				#my_seri_#
				</cfoutput>
				</td>
			</tr>
			<cfelseif uss eq 3>
			<tr>
				<td style="width:3.5cm;height:1.5cm;" align="center" class="print">
				<cfoutput>
				#get_det_po.p_order_no#<br/>
				#finishdate#
				</cfoutput>
				</td>
			</tr>
			<cfelse>
			<tr>
				<td style="width:3.5cm;height:1.5cm;" align="center" class="print">
				<cfoutput>
				#get_det_po.PRODUCT_NAME##get_det_po.PROPERTY#
				#my_seri_#
				</cfoutput>
				</td>
			</tr>	
			</cfif>
		</cfloop>
	</table>
<br/>	
</cfloop>
