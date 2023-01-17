<cfquery name="get_serials" datasource="#dsn3#">
	SELECT 
		SGN.SERIAL_NO,
		S.PRODUCT_NAME,
		S.PROPERTY 
	FROM
		SERVICE_GUARANTY_NEW SGN,
		STOCKS S
	WHERE
		SGN.PROCESS_ID = #attributes.action_id# AND
		SGN.PROCESS_CAT = #attributes.action_type# AND
		SGN.PERIOD_ID = #session.ep.period_id# AND
		SGN.STOCK_ID = S.STOCK_ID
	ORDER BY 
		SGN.SERIAL_NO
</cfquery>

<cfloop from="1" to="#get_serials.recordcount#" index="i">
<cfif i eq 1 or (i mod 6) eq 1>
	<table cellpadding="2" cellspacing="2" border="0" class="print">
</cfif>
			<tr>
				<td style="width:2.5cm;height:1.5cm;" align="center" class="print">
				<cfoutput>
					<cfset urun=#get_serials.PRODUCT_NAME[i]#&#get_serials.PROPERTY[i]#>
					<cfif len(urun) gt 16> 
						#left(urun,16)#
					<cfelse>
						#urun#
					</cfif>
					<cfif isnumeric(get_serials.SERIAL_NO[i]) and (len(get_serials.SERIAL_NO[i]) mod 2) eq 0>
						<CF_BarcodeGenerator BarCode="#get_serials.SERIAL_NO[i]#" Height="12">
					<cfelse>
						<CF_BarcodeGenerator BarCode="#get_serials.SERIAL_NO[i]#" BarCodeType="8" Height="12">
					</cfif>
				</cfoutput>
				</td>
			</tr>
	<cfif (i mod 6) eq 0>
		</table><br/>
	</cfif>
</cfloop>
