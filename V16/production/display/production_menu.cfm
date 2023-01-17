<!--- Üretim Menü --->
<cfquery name="get_company_logo" datasource="#dsn#">
	SELECT * FROM OUR_COMPANY WHERE COMP_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.company_id#">
</cfquery>
<table width="100%" height="100%" cellpadding="0" cellspacing="0">
	<tr class="color-row">
		<td style="text-align:center; width:100%;">
		<cfform name="search_list" action="#request.self#?fuseaction=production.welcome" method="post">
		<input type="hidden" name="is_submitted" id="is_submitted" value="1">
		<div align="center">
			<table width="70%">
				<cfset prod_orders = "#request.self#?fuseaction=production.list_production_orders&is_form_submitted=1">
				<cfset prod_results = "#request.self#?fuseaction=production.list_production_order_results&is_form_submitted=1"><!---  --->
				<cfset stocks = "#request.self#?fuseaction=production.list_stocks&is_form_submitted=1"><!---  --->
				<cfset serial_no_ = "#request.self#?fuseaction=production.list_serial_no_operations&is_form_submitted=1"><!---  --->
				<tr>
					<td style="text-align:left;height:100px;" id="prod_order">
						<input type="button" value="<cf_get_lang dictionary_id='38091.Uretim Emirleri'>" onClick="window.location.href='<cfoutput>#prod_orders#</cfoutput>'" style="font-size:22px;font:bold;width:300px;height:80px">
					</td>
					<td style="text-align:center" rowspan="2">
						<cf_get_server_file output_file="settings/#get_company_logo.asset_file_name2#" output_server="#get_company_logo.asset_file_name2_server_id#" output_type="5"><!---  image_width="200" image_height="160" --->
					</td>
					<td style="text-align:right" id="prod_result">
						<input type="button" value="<cf_get_lang dictionary_id='38092.Uretim Sonuçlari'>"  onClick="window.location.href='<cfoutput>#prod_results#</cfoutput>'" style="font-size:22px;font:bold;width:300px;height:80px;">
					</td>
				</tr>
				<tr>
					<td style="text-align:left;height:100px;" id="stocks">
						<input type="button" value="<cf_get_lang dictionary_id='58166.Stoklar'>"  onClick="window.location.href='<cfoutput>#stocks#</cfoutput>'" style="font-size:22px;font:bold;width:300px;height:80px;">
					</td>
					<td style="text-align:right" id="serial_no">
						<input type="button" value="<cf_get_lang dictionary_id='57718.Seri Nolar'>"  onClick="window.location.href='<cfoutput>#serial_no_#</cfoutput>'" style="font-size:22px;font:bold;width:300px;height:80px;">
					</td>
				</tr>
				<!--- <tr>
					<td colspan="3" style="text-align:center;height:95px;" id="reports">
						<input type="button" value="<cf_get_lang dictionary_id='57626.Raporlar'>"  onClick="" style="font-size:22px;font:bold;width:300px;height:80px;">
					</td>
				</tr> --->
			</table>
			</cfform>
		</div>
		</td>
	</tr>
</table>
