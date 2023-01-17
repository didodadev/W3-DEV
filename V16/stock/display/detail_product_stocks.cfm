<cfparam name="adres" default="stock.popup_detail_product_stocks">
<cfparam name="attributes.keyword" default="">
<cfinclude template="../query/get_stock_list_for_detail.cfm">
<cfif isDefined("attributes.department_id") and len(attributes.department_id)>
	<cfset adres = "#adres#&department_id=#attributes.department_id#">
</cfif>
<cfif len(attributes.keyword)>
	<cfset adres = "#adres#&keyword=#attributes.keyword#">
</cfif>
<cfif isdefined("attributes.is_form_submitted")>
	<cfset form_varmi = 1>
<cfelse>
	<cfset form_varmi = 0>
</cfif>
<cfset adres="#adres#&pid=#attributes.pid#">
<cfparam name="attributes.page" default=1>
<cfparam name="attributes.maxrows" default='#session.ep.maxrows#'>
<cfparam name="attributes.totalrecords" default=#get_product.recordcount#>
<cfset attributes.startrow=((attributes.page-1)*attributes.maxrows)+1>
<cfform name="stock_search" method="post"action="#request.self#?fuseaction=stock.popup_detail_product_stocks&pid=#attributes.pid#">
	<cf_medium_list_search title="#getLang('main',754)#">
		<cf_medium_list_search_area>
			<table>
				<tr>
					<cfinput type="hidden" name="is_form_submitted" value="1">
					<td><cf_get_lang_main no='48.Filtre'></td>
					<td><cfinput type="text" name="keyword" style="width:100px;" value="#attributes.keyword#" maxlength="50"></td>
					<td>
						<cfinclude template="../query/get_stores.cfm">
						<select name="department_id" id="department_id">
							<option value=""><cf_get_lang no='171.Tüm Depolar'></option>
							<cfoutput query="stores">
								<option value="#department_id#" <cfif isDefined("attributes.department_id") and attributes.department_id eq department_id> selected</cfif>>#department_head#</option>
							</cfoutput>
						</select>
					</td>
					<td>
						<cfsavecontent variable="message"><cf_get_lang_main no='125.Sayi_Hatasi_Mesaj'></cfsavecontent>
						<cfinput type="text" name="maxrows" style="width:25px;" value="#attributes.maxrows#" validate="integer" range="1,250" required="yes" onKeyUp="isNumber(this)" maxlength="3" message="#message#">
					</td>
					<td align="right" style="text-align:right;"><cf_wrk_search_button></td>
				<cf_workcube_file_action pdf='1' mail='1' doc='1' print='1'> 
				</tr>
			</table>
		</cf_medium_list_search_area>
	</cf_medium_list_search>
</cfform>
<cf_medium_list>
	<thead>
		<tr>
			<th width="100"><cf_get_lang_main no='106.stok kodu'></th>
			<th width="100"><cf_get_lang_main no='221.barkod'></th>
			<th><cf_get_lang_main no='245.ürün'></th>
			<th width="70" style="text-align:right;"><cf_get_lang_main no='223.miktar'></th>
			<th width="60"><cf_get_lang_main no='224.birim'></th>
			<th width="75"><cf_get_lang_main no='344.durum'></th>
		</tr>
	</thead>
	<tbody>
		<cfif get_product.recordcount and form_varmi eq 1>
			<cfquery name="GET_STRATEGY" datasource="#DSN2#">
				SELECT 
					MAXIMUM_STOCK,
					REPEAT_STOCK_VALUE,
					MINIMUM_STOCK,
					PRODUCT_ID,
					STOCK_ID,
					ISNULL(DEPARTMENT_ID,0) AS DEPARTMENT_ID
				FROM 
					GET_STOCK_STRATEGY
				WHERE 
					PRODUCT_ID = #PID#
				<cfif isDefined("attributes.department_id") and len(attributes.department_id)>
					AND DEPARTMENT_ID = #attributes.department_id#
				<cfelse>
					AND DEPARTMENT_ID IS NULL
				</cfif>			
			</cfquery>
			<cfscript>
				if(get_strategy.recordcount)
				{
					for(str_i=1;str_i lte get_strategy.recordcount;str_i=str_i+1)
					{
						'is_strategy_#GET_STRATEGY.STOCK_ID[str_i]#_#GET_STRATEGY.DEPARTMENT_ID[str_i]#'=1;
						'strategy_min_stock_#GET_STRATEGY.STOCK_ID[str_i]#_#GET_STRATEGY.DEPARTMENT_ID[str_i]#'=GET_STRATEGY.MINIMUM_STOCK[str_i];
						'strategy_max_stock_#GET_STRATEGY.STOCK_ID[str_i]#_#GET_STRATEGY.DEPARTMENT_ID[str_i]#'=GET_STRATEGY.MAXIMUM_STOCK[str_i];
						'strategy_repeat_stock_value_#GET_STRATEGY.STOCK_ID[str_i]#_#GET_STRATEGY.DEPARTMENT_ID[str_i]#'= GET_STRATEGY.REPEAT_STOCK_VALUE[str_i];
					}
				}
			</cfscript>
			<cfoutput query="get_product" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">
				<cfif not (isdefined('attributes.department_id') and len(attributes.department_id))>
					<cfset temp_dept_id=0>
				<cfelse>
					<cfset temp_dept_id=attributes.department_id>
				</cfif>
				<cfsavecontent variable="message"><cf_get_lang_main no='1433.Tanımsız'></cfsavecontent>
				<cfset stock_status = '#message#'>
				<cfif isdefined('is_strategy_#STOCK_ID#_#temp_dept_id#') and evaluate('is_strategy_#stock_id#_#temp_dept_id#') eq 1>
					<cfif product_stock lte 0>
						<cfsavecontent variable="f_stock"><cf_get_lang no ='37.Stok Yok'></cfsavecontent>
						<cfset stock_status = '<font color="ff0000">#f_stock#</font>'>
					<cfelseif isdefined('strategy_min_stock_#stock_id#_#temp_dept_id#') and len(evaluate('strategy_min_stock_#stock_id#_#temp_dept_id#')) and product_stock lte evaluate('strategy_min_stock_#stock_id#_#temp_dept_id#')>
						<cfsavecontent variable="yt_stock"><cf_get_lang no ='383.Yetersiz Stok'></cfsavecontent>
						<cfset stock_status = '<font color="ff0000">#yt_stock#</font>'>
					<cfelseif isdefined('strategy_repeat_stock_value_#stock_id#_#temp_dept_id#') and len(evaluate('strategy_repeat_stock_value_#stock_id#_#temp_dept_id#')) and product_stock lte evaluate('strategy_repeat_stock_value_#stock_id#_#temp_dept_id#') 
						and isdefined('strategy_min_stock_#stock_id#_#temp_dept_id#') and len(evaluate('strategy_min_stock_#stock_id#_#temp_dept_id#')) and product_stock gt evaluate('strategy_min_stock_#stock_id#_#temp_dept_id#')>
						<cfsavecontent variable="order"><cf_get_lang no ='141.Sipariş Ver'></cfsavecontent>
						<cfset stock_status = '<font color="009933">#order#</font>'>
					<cfelseif isdefined('strategy_max_stock_#stock_id#_#temp_dept_id#') and len(evaluate('strategy_max_stock_#stock_id#_#temp_dept_id#')) and product_stock lt evaluate('strategy_max_stock_#stock_id#_#temp_dept_id#')>
						<cfsavecontent variable="yl_stock"><cf_get_lang no ='108.Yeterli Stok'></cfsavecontent>
						<cfset stock_status = "#yl_stock#">
					<cfelseif isdefined('strategy_max_stock_#stock_id#_#temp_dept_id#') and len(evaluate('strategy_max_stock_#stock_id#_#temp_dept_id#')) and product_stock gte evaluate('strategy_max_stock_#stock_id#_#temp_dept_id#')>
						<cfsavecontent variable="fz_stock"><cf_get_lang no ='159.Fazla Stok'></cfsavecontent>
						<cfset stock_status = '<font color="6666FF">#fz_stock#</font>'>
					</cfif>
				</cfif>
				<tr>
					<td>
					<a href="javascript://"  class="tableyazi" onClick="windowopen('#request.self#?fuseaction=objects.popup_detail_product&pid=#product_id#&sid=#stock_id#','list');">#stock_code#</a></td>
					<td width="100">#barcod#</td>
					<td>#product_name#<cfif len(property) and trim(property) neq "-">-#property#</cfif></td>
					<td style="text-align:right;"><a href="javascript://" onclick="windowopen('#request.self#?fuseaction=stock.popup_stock_graph&pid=#product_id#&product_name=#product_name#','small');"><font color="ff0000"><cfif isnumeric(product_stock)>#AmountFormat(product_stock)#<cfelse>#product_stock#</cfif></font></a></td>
					<td>#main_unit#</td>
					<td>#stock_status#</td>
				</tr>
			</cfoutput>
		<cfelse>
			<tr>
				<td colspan="6" height="20"><cfif form_varmi eq 0><cf_get_lang_main no='289.Filtre Ediniz'>!<cfelse><cf_get_lang_main no='72.Kayıt Yok'>!</cfif></td>
			</tr>
		</cfif>
	</tbody>
</cf_medium_list>
<cf_popup_box_footer>
	<cfset adres = "#adres#&is_form_submitted=1">
	<cfif attributes.maxrows lt attributes.totalrecords>
		<table cellpadding="0" cellspacing="0" border="0" align="center" width="99%" height="35">
			<tr>
				<td>
				<cf_pages page="#attributes.page#"
					maxrows="#attributes.maxrows#"
					totalrecords="#attributes.totalrecords#"
					startrow="#attributes.startrow#"
					adres="#adres#">
				</td>
				<!-- sil --><td style="text-align:right;"><cf_get_lang_main no='80.Toplam'>:<cfoutput>#attributes.totalrecords#&nbsp;-&nbsp;<cf_get_lang_main no='169.sayfa'>:#attributes.page#/#lastpage#</cfoutput></td><!-- sil -->
			</tr>
		</table>
	</cfif>
</cf_popup_box_footer>
<!-- sil -->
<script type="text/javascript">
	document.getElementById('keyword').focus();
</script>
<!-- sil -->
