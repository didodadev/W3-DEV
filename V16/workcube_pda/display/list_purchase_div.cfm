<cfsetting showdebugoutput="no">
<cfif isdefined("attributes.start_date") and len(attributes.start_date)><cf_date tarih="attributes.start_date"></cfif>
<cfif isdefined("attributes.finish_date") and len(attributes.finish_date)><cf_date tarih="attributes.finish_date"></cfif>
<cfquery name="get_ship" datasource="#dsn2#">
	SELECT
		SHIP_ID,
		SHIP_NUMBER,
		SHIP_DATE
	FROM
		SHIP
	WHERE
		(COMPANY_ID IS NOT NULL OR CONSUMER_ID IS NOT NULL)
		<cfif isDefined("attributes.ship_type") and Len(attributes.ship_type)>
			AND PURCHASE_SALES = #attributes.ship_type#
		</cfif>
		<cfif len(attributes.company_id)>
			AND COMPANY_ID = #attributes.company_id#
		</cfif>
		<cfif isdefined("attributes.start_date") and len(attributes.start_date)>
			AND SHIP_DATE >= #attributes.start_date#
		</cfif>
		<cfif isdefined("attributes.finish_date") and len(attributes.finish_date)>
			AND SHIP_DATE <= #attributes.finish_date#
		</cfif>
	ORDER BY	
		SHIP_DATE DESC,
		SHIP_ID DESC
</cfquery>
<cf_box title="İrsaliyeler" body_style="overflow-y:scroll;height:100px;">
<table cellspacing="0" cellpadding="0" width="98%" border="0" align="center">
	<tr class="color-border">
		<td>
		<table cellspacing="1" cellpadding="2" width="100%" border="0">
			<tr height="22" class="color-header">		
				<td class="form-title" style="width:20px;text-align:center;">No</td>
				<td class="form-title" style="width:80px;">İrsaliye Tarihi</td>
				<td class="form-title">İrsaliye No</td>
				<td class="form-title">&nbsp;</td>
			</tr>
			<cfif get_ship.recordcount>
				<cfoutput query="get_ship">
					<tr height="20"  class="color-row">
						<td style="text-align:center;">#currentrow#</td>
						<td>#ship_number#</td>
						<td>#dateformat(ship_date,'dd/mm/yyyy')#</td>
						<td style="text-align:center;"><a href="javascript://" onClick="window.open('#request.self#?fuseaction=pda.emptypopup_print_files&print_type=30&action_id=#ship_id#');"><img src="/images/print2.gif" border="0" align="absmiddle" title="Yazdır"></a></td>
					</tr>		
				</cfoutput>
			<cfelse>
				<tr class="color-row">
					<td colspan="4" height="20">Kayıt Yok !</td>
				</tr>
			</cfif>
		</table>
		</td>
	</tr>
</table>
</cf_box>
