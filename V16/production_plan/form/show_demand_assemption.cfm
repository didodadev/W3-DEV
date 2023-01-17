<!--- Metod karşılaştırma sayfası --->
<cfquery name="get_all_method" datasource="#dsn3#">
	SELECT 
		(SELECT AE.EXPONENTIAL_NAME FROM ASSEMPTION_EXPONENTIAL_VALUES AE WHERE AE.EXPONENTIAL_ID = DEMAND_ASSEMPTION_PRE.EXPONENTIAL_ID) METHOD_NAME,
		ISNULL(EXPONENTIAL_ID,0) EXPONENTIAL_ID,
		METHOD_ID,
		STOCK_ID,
		MFE,
		MAD,
		MSE
	FROM 
		DEMAND_ASSEMPTION_PRE
</cfquery>
<cfquery name="get_method_ids" dbtype="query">
	SELECT DISTINCT METHOD_ID,EXPONENTIAL_ID FROM get_all_method
</cfquery>
<cfoutput query="get_all_method">
	<cfset "method_name_#stock_id#_#method_id#_#exponential_id#" = method_name>
	<cfset "mfe_#stock_id#_#method_id#_#exponential_id#" = mfe>
	<cfset "mad_#stock_id#_#method_id#_#exponential_id#" = mad>
	<cfset "mse_#stock_id#_#method_id#_#exponential_id#" = mse>
</cfoutput><br>
<cfform name="add_assemption_" method="post" action="#request.self#?fuseaction=prod.emptypopup_add_assemption">
	<input type="hidden" name="row_count" id="row_count" value="<cfoutput>#get_product.recordcount#</cfoutput>">
	<input type="hidden" name="method_type" id="method_type" value="<cfoutput>#attributes.method_type#</cfoutput>">
	<input type="hidden" name="stock_id_list" id="stock_id_list" value="<cfoutput>#valuelist(get_product.stock_id)#</cfoutput>">
	<cfoutput query="get_product">
		<input type="hidden" name="stock_id_#currentrow#" id="stock_id_#currentrow#" value="#stock_id#">
		<cfset max_mfe = 0>
		<cfset min_mad = 0>
		<cfset min_mse = 0>
		<cfset max_checked_count = 0>
		<div style="float:left;">
			<cf_form_list>
				<thead>
					<tr>
						<th colspan="5">#product_name#</th>
					</tr>
					<tr>
						<th><cf_get_lang dictionary_id="36546.Hesaplama Yöntemi"></th>
						<th style="text-align:right;">MFE</th>
						<th style="text-align:right;">MAD</th>
						<th style="text-align:right;">MSE</th>
						<th width="10"></th>
					</tr>
				</thead>
				<tbody id="table1" name="table1">
					<cfloop query="get_method_ids">
						<cfset row_checked_count = 0>
						<cfset is_checked = 0>
						<tr>
							<td><cfif isdefined("method_name_#get_product.stock_id#_#method_id#_#exponential_id#") and len(evaluate("method_name_#get_product.stock_id#_#method_id#_#exponential_id#"))>#evaluate("method_name_#get_product.stock_id#_#method_id#_#exponential_id#")#<cfelse>#listgetat(method_name_list,method_id)#</cfif></td>
							<td style="text-align:right;">
								<cfif isdefined("mfe_#get_product.stock_id#_#method_id#_#exponential_id#")>
									#tlformat(evaluate("mfe_#get_product.stock_id#_#method_id#_#exponential_id#"))#
									<cfif evaluate("mfe_#get_product.stock_id#_#method_id#_#exponential_id#") gt max_mfe>
										<cfset row_checked_count = row_checked_count + 1>
										<cfset max_mfe = evaluate("mfe_#get_product.stock_id#_#method_id#_#exponential_id#")>
									</cfif>
								<cfelse>
									#tlformat(0)#
								</cfif>
							</td>
							<td style="text-align:right;">
								<cfif isdefined("mad_#get_product.stock_id#_#method_id#_#exponential_id#")>
									#tlformat(evaluate("mad_#get_product.stock_id#_#method_id#_#exponential_id#"))#
									<cfif evaluate("mad_#get_product.stock_id#_#method_id#_#exponential_id#") lt min_mad>
										<cfset row_checked_count = row_checked_count + 1>
										<cfset min_mad = evaluate("mad_#get_product.stock_id#_#method_id#_#exponential_id#")>
									</cfif>
								<cfelse>
									#tlformat(0)#
								</cfif>
							</td>
							<td style="text-align:right;">
								<cfif isdefined("mse_#get_product.stock_id#_#method_id#_#exponential_id#")>
									#tlformat(evaluate("mse_#get_product.stock_id#_#method_id#_#exponential_id#"))#
									<cfif evaluate("mse_#get_product.stock_id#_#method_id#_#exponential_id#") lt min_mse>
										<cfset row_checked_count = row_checked_count + 1>
										<cfset min_mse = evaluate("mse_#get_product.stock_id#_#method_id#_#exponential_id#")>
									</cfif>
								<cfelse>
									#tlformat(0)#
								</cfif>
							</td>
							<cfif row_checked_count gt max_checked_count>
								<cfset is_checked = 1>
								<cfset max_checked_count = row_checked_count>
							</cfif>
							<td><input name="method_id_#get_product.stock_id#" id="method_id_#get_product.stock_id#" type="radio" value="#method_id#_#exponential_id#" <cfif is_checked eq 1>checked</cfif>></td>
						</tr>
					</cfloop>
				</tbody>
			</cf_form_list>
		</div>
	</cfoutput>
	<cf_basket_footer>
		<input type="button" name="show_products" id="show_products" value="<cf_get_lang dictionary_id='36551.Tahminleri Kaydet'>" onClick="save_methods();">
	</cf_basket_footer>
</cfform>
<script language="javascript">
	function save_methods()
	{
		add_assemption_.submit();
		return false;
	}
</script>
