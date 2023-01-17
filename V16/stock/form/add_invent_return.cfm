<cfsetting showdebugoutput="yes">
<cf_xml_page_edit fuseact="stock.add_invent_return">
<cfparam name="attributes.project_id" default="">
<cfparam name="attributes.project_name" default="">
<cfparam name="attributes.subscription_id" default="">
<cfparam name="attributes.subscription_no" default="">
<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
    <cf_box>
		<cfform name="order_form" method="post" action="#request.self#?fuseaction=stock.add_invent_return">
			<input type="hidden" name="form_submitted" id="form_submitted" value="1" />
			<cf_box_search more="0">
				<div class="form-group" id="item_subscription_id">
					<cfif isdefined('attributes.subscription_no') and len(attributes.subscription_no)>
						<cfset subscription_id_ = attributes.subscription_id>
					<cfelse>
						<cfset subscription_id_ = ''>
					</cfif>                    
					<div class="input-group">
						<cf_wrk_subscriptions subscription_id='#subscription_id_#' subscription_no='#attributes.subscription_no#' width_info='200' fieldid='subscription_id' fieldname='subscription_no' form_name='order_form' img_info='plus_thin'>
					</div>
				</div>
				<div class="form-group" id="item_project_id">
					<cfif isdefined('attributes.project_name') and len(attributes.project_name)>
						<cfset project_id_ = attributes.project_id>
					<cfelse>
						<cfset project_id_ = ''>
					</cfif>
					<div class="input-group">
						<cf_wrkproject project_id="#project_id_#" fieldname='project_name' agreementno="1" customer="2" employee="3" priority="4" stage="5" width="150" boxwidth="600" boxheight="400" buttontype="1">
					</div>
				</div>
				<cfif is_select_project eq 1>
					<div class="form-group" id="item_is_project">
						<label><cf_get_lang dictionary_id='45802.Projesiz Işlemler'><input type="checkbox" name="is_project" id="is_project" value="1" <cfif isdefined("attributes.is_project")>checked</cfif>></label>
					</div>
				</cfif>
				<div class="form-group">
					<cf_wrk_search_button button_type="4" search_function="control()" is_excel='0'>
				</div>
			</cf_box_search>
		</cfform>
	</cf_box>
<script type="text/javascript">
	function control()
	{
		if((document.order_form.subscription_id.value == '' || document.order_form.subscription_no.value == '') && (document.order_form.project_id.value == '' || document.order_form.project_name.value == ''))
		{
			alert("<cf_get_lang dictionary_id='57471.Eksik Veri'> : <cf_get_lang dictionary_id='58832.Abone'> <cf_get_lang dictionary_id='57998.veya'> <cf_get_lang dictionary_id='57416.Proje'> !");
			return false;
		}
		return true;
	}	
</script>
<cfif isdefined("attributes.form_submitted") and len(attributes.subscription_id)>
	<cfquery name="get_periods" datasource="#dsn#">
		SELECT 
        	PERIOD_ID, 
            PERIOD, 
            PERIOD_YEAR, 
            OUR_COMPANY_ID
        FROM 
    	    SETUP_PERIOD 
        WHERE 
	        OUR_COMPANY_ID = #session.ep.company_id# ORDER BY PERIOD_YEAR DESC
	</cfquery>
	<cfquery name="get_system_inventory" datasource="#dsn2#">
		SELECT
			SUM(STOCK_ROW_SPE_TOTAL) AS TOTAL,
			PRODUCT_NAME,
			STOCK_ID
		FROM
			(
			<cfset count_ = 0>
			<cfloop query="get_periods">
				<cfset count_ = count_ + 1>
				SELECT
					S.PRODUCT_NAME,
					SFR.STOCK_ID,
					SUM(SFR.AMOUNT) AS STOCK_ROW_SPE_TOTAL
				FROM
					#dsn3_alias#.INVENTORY I,
					#dsn3_alias#.INVENTORY_ROW IR,
					#dsn3_alias#.STOCKS S,
					#dsn#_#get_periods.period_year#_#session.ep.company_id#.STOCK_FIS SF,
					#dsn#_#get_periods.period_year#_#session.ep.company_id#.STOCK_FIS_ROW SFR
				WHERE
					I.INVENTORY_ID = IR.INVENTORY_ID AND
					IR.ACTION_ID =  SF.FIS_ID AND
					SFR.FIS_ID =  SF.FIS_ID AND
					SFR.STOCK_ID = S.STOCK_ID AND
					SFR.INVENTORY_ID = I.INVENTORY_ID AND
					IR.PERIOD_ID = #get_periods.period_id# AND
					I.SUBSCRIPTION_ID = #attributes.subscription_id# AND
					SF.FIS_TYPE = 118
				GROUP BY
					S.PRODUCT_NAME,
					SFR.STOCK_ID
				<cfif get_periods.recordcount neq count_>UNION ALL</cfif>
			</cfloop>
			) AS SATIRLAR
		GROUP BY
			PRODUCT_NAME,
			STOCK_ID
	</cfquery>
	<cfquery name="get_system_inventory_return" datasource="#dsn2#">
		SELECT
			SUM(STOCK_ROW_SPE_TOTAL) AS TOTAL,
			PRODUCT_NAME,
			STOCK_ID
		FROM
			(
			<cfset count_ = 0>
			<cfloop query="get_periods">
				<cfset count_ = count_ + 1>
				SELECT
					S.PRODUCT_NAME,
					SFR.STOCK_ID,
					SUM(SFR.AMOUNT) AS STOCK_ROW_SPE_TOTAL
				FROM
					#dsn3_alias#.INVENTORY I,
					#dsn3_alias#.INVENTORY_ROW IR,
					#dsn3_alias#.STOCKS S,
					#dsn#_#get_periods.period_year#_#session.ep.company_id#.STOCK_FIS SF,
					#dsn#_#get_periods.period_year#_#session.ep.company_id#.STOCK_FIS_ROW SFR
				WHERE
					I.INVENTORY_ID = IR.INVENTORY_ID AND
					IR.ACTION_ID =  SF.FIS_ID AND
					SFR.FIS_ID =  SF.FIS_ID AND
					SFR.STOCK_ID = S.STOCK_ID AND
					SFR.INVENTORY_ID = I.INVENTORY_ID AND
					IR.PERIOD_ID = #get_periods.period_id# AND
					I.SUBSCRIPTION_ID = #attributes.subscription_id# AND
					SF.FIS_TYPE = 1182
				GROUP BY
					S.PRODUCT_NAME,
					SFR.STOCK_ID
				<cfif get_periods.recordcount neq count_>UNION ALL</cfif>
			</cfloop>
			) AS SATIRLAR
		GROUP BY
			PRODUCT_NAME,
			STOCK_ID
	</cfquery>
	<cfquery name="get_system_inventory_sale" datasource="#dsn2#">
		SELECT
			SUM(STOCK_ROW_SPE_TOTAL) AS TOTAL,
			PRODUCT_NAME,
			STOCK_ID
		FROM
			(
			<cfset count_ = 0>
			<cfloop query="get_periods">
				<cfset count_ = count_ + 1>
				SELECT
					S.PRODUCT_NAME,
					IR2.STOCK_ID,
					SUM(SFR.AMOUNT) AS STOCK_ROW_SPE_TOTAL
				FROM
					#dsn3_alias#.INVENTORY I,
					#dsn3_alias#.INVENTORY_ROW IR,
					#dsn3_alias#.INVENTORY_ROW IR2,
					#dsn3_alias#.STOCKS S,
					#dsn#_#get_periods.period_year#_#session.ep.company_id#.INVOICE SF,
					#dsn#_#get_periods.period_year#_#session.ep.company_id#.INVOICE_ROW SFR
				WHERE
					I.INVENTORY_ID = IR.INVENTORY_ID AND
					I.INVENTORY_ID = IR2.INVENTORY_ID AND
					IR2.PROCESS_TYPE = 118 AND
					IR.ACTION_ID =  SF.INVOICE_ID AND
					SFR.INVOICE_ID =  SF.INVOICE_ID AND
					IR2.STOCK_ID = S.STOCK_ID AND
					SFR.INVENTORY_ID = I.INVENTORY_ID AND
					IR.PERIOD_ID = #get_periods.period_id# AND
					I.SUBSCRIPTION_ID = #attributes.subscription_id# AND
					SF.INVOICE_CAT = 66
				GROUP BY
					S.PRODUCT_NAME,
					IR2.STOCK_ID
				<cfif get_periods.recordcount neq count_>UNION ALL</cfif>
			</cfloop>
			) AS SATIRLAR
		GROUP BY
			PRODUCT_NAME,
			STOCK_ID
	</cfquery>
	<cfoutput query="get_system_inventory_return">
		<cfset 'return_stock_amount_#STOCK_ID#' = TOTAL>
	</cfoutput>
	<cfoutput query="get_system_inventory_sale">
		<cfset 'sale_stock_aount_#STOCK_ID#' = TOTAL>
	</cfoutput>
	<!--- Demirbaşlar --->
	<cfsavecontent variable="head"><cf_get_lang dictionary_id='45800.Demirbaş İade'></cfsavecontent>
	<cf_box title="#head#" uidrop="1" hide_table_column="1">
		<cf_flat_list>
			<thead>
				<tr>
					<th class="form-title"><cf_get_lang dictionary_id='57657.Ürün'></th>
					<th class="form-title" width="100"><cf_get_lang dictionary_id='57492.Toplam'> <cf_get_lang dictionary_id='57635.Miktar'></th>
					<th class="form-title" width="100"><cf_get_lang dictionary_id='45791.İade Miktarı'></th>
					<th width="100" align="right" nowrap class="form-title" style="text-align:right;"><cf_get_lang dictionary_id='57448.Satış'></th>
					<th width="50" align="right" class="form-title" style="text-align:right;"><cf_get_lang dictionary_id='58444.Kalan'></th>
					<th class="header_icn_none">
						<input type="checkbox" name="allSelectDemand_" id="allSelectDemand_" onclick="wrk_select_all('allSelectDemand_','invent_return_row_ids');">
					</th>
				</tr>
			</thead>
			<tbody>
				<cfif get_system_inventory.recordcount>
					<cfform action="#request.self#?fuseaction=stock.form_add_purchase" name="send_form_" method="post">
						<cfoutput>
						<input type="hidden" name="subscription_id" id="subscription_id" value="<cfif isdefined("attributes.subscription_id")>#attributes.subscription_id#</cfif>" />				
						<input type="hidden" name="subscription_no" id="subscription_no" value="<cfif isdefined("attributes.subscription_no")>#attributes.subscription_no#</cfif>" />
						</cfoutput>
						<cfoutput query="get_system_inventory">
							<cfif not isdefined("return_stock_amount_#STOCK_ID#") or TOTAL gt evaluate("return_stock_amount_#STOCK_ID#")>
								<cfset asil_ = total>
								<cfif isdefined("return_stock_amount_#STOCK_ID#")>
									<cfset iade_ = evaluate("return_stock_amount_#STOCK_ID#")>
								<cfelse>
									<cfset iade_ = 0>
								</cfif>
								<cfif isdefined("sale_stock_aount_#STOCK_ID#")>
									<cfset sale_ = evaluate("sale_stock_aount_#STOCK_ID#")>
								<cfelse>
									<cfset sale_ = 0>
								</cfif>
								<cfset deger_ = total - iade_ - sale_>
								<cfinput type="hidden" name="old_invent_return_amount_#STOCK_ID#" value="#deger_#">
								<cfif deger_ gt 0>
									<tr>
										<td>#PRODUCT_NAME#</td>
										<td align="right" style="text-align:right;">#total#</td>
										<td align="right" style="text-align:right;">#iade_#</td>
										<td align="right" style="text-align:right;">#sale_#</td>
										<td align="right" style="text-align:right;"><cfinput type="text" name="invent_return_amount_#STOCK_ID#" validate="float" onKeyUp="return(FormatCurrency(this,event));" value="#tlformat(deger_,0)#" style="width:50px;" class="moneybox" onBlur="kontrol_amount(#stock_id#,0);"></td>
										<td><input type="checkbox" name="invent_return_row_ids" id="invent_return_row_ids" value="#STOCK_ID#"></td>
									</tr>
								</cfif>
							</cfif>
						</cfoutput>	
						<tr class="total">
							<td colspan="7" style="text-align:right;">
								<cfsavecontent variable="message"><cf_get_lang dictionary_id='45793.İrsaliye Düzenle'></cfsavecontent>
								<cf_wrk_search_button search_function="kontrol_et(0)" button_type="2" button_name="#message#">
							</td>
						</tr>
					</cfform>
				<cfelse>
					<tr>
						<td colspan="6"><cf_get_lang dictionary_id='58486.Kayıt Bulunamadı'>!</td>
					</tr>
				</cfif>
			</tbody>
		</cf_flat_list>
	</cf_box>
</cfif>
<cfif isdefined("attributes.form_submitted")>
	<cfquery name="get_all_periods" datasource="#dsn#">
		SELECT 
        	PERIOD_ID, 
            PERIOD, 
            PERIOD_YEAR, 
            OUR_COMPANY_ID
        FROM 
        	SETUP_PERIOD 
        WHERE 
        	OUR_COMPANY_ID = #session.ep.company_id# AND PERIOD_YEAR >=#session.ep.period_year-5#
	</cfquery> 
	<cfset list_period_years=valuelist(get_all_periods.PERIOD_YEAR)>
	<!--- konsinye çıkışlar --->
	<cfquery name="get_konsinye_row" datasource="#dsn2#" cachedwithin="#fusebox.general_cached_time#">
		SELECT
			PRODUCT_ID,
			STOCK_ID,
			PRODUCT_NAME,
			SUM(TOTAL_KONS_AMOUNT) TOTAL_KONS_AMOUNT,
			SUM(TOTAL_AMOUNT) TOTAL_AMOUNT,
			SHIP_ID,
			SHIP_DATE,
			SHIP_PERIOD_ID,
			SHIP_PERIOD_YEAR,
			SHIP_NUMBER,
			PROJECT_ID	
		FROM
		(
		<cfloop query="get_all_periods">
			SELECT
				S.PRODUCT_ID,
				S.STOCK_ID,
				S.PRODUCT_NAME,
				SUM(SHIP_ROW.AMOUNT) TOTAL_KONS_AMOUNT,
				0 TOTAL_AMOUNT,
				SHIP.SHIP_ID,
				SHIP.SHIP_DATE,
				#get_all_periods.period_id# SHIP_PERIOD_ID,
				#get_all_periods.period_year# SHIP_PERIOD_YEAR,
				SHIP_NUMBER,
				ISNULL(SHIP.PROJECT_ID,0) PROJECT_ID		
			FROM 
				#dsn#_#get_all_periods.PERIOD_YEAR#_#get_all_periods.OUR_COMPANY_ID#.SHIP SHIP,
				#dsn#_#get_all_periods.PERIOD_YEAR#_#get_all_periods.OUR_COMPANY_ID#.SHIP_ROW SHIP_ROW,
				#dsn3_alias#.STOCKS S
			WHERE 
				SHIP_ROW.SHIP_ID = SHIP.SHIP_ID
				AND SHIP.IS_SHIP_IPTAL = 0 
				AND SHIP_ROW.STOCK_ID = S.STOCK_ID
				AND SHIP.IS_WITH_SHIP=0
				AND SHIP.SHIP_TYPE = 72
				AND S.IS_INVENTORY = 1
				<cfif len(attributes.subscription_id)>
					AND SHIP.SUBSCRIPTION_ID = #attributes.subscription_id#
				</cfif>
				<cfif len(attributes.project_id)>
					AND SHIP.PROJECT_ID = #attributes.project_id#
				</cfif>
				<cfif isdefined("attributes.is_project")>
					AND SHIP.PROJECT_ID IS NULL
				</cfif>
			GROUP  BY
				S.PRODUCT_ID,
				S.STOCK_ID,
				S.PRODUCT_NAME,
				SHIP.SHIP_ID,
				SHIP.SHIP_DATE,
				SHIP_NUMBER	,
				ISNULL(SHIP.PROJECT_ID,0)
			UNION ALL
			SELECT
				S.PRODUCT_ID,
				S.STOCK_ID,
				S.PRODUCT_NAME,
				0 TOTAL_KONS_AMOUNT,
				SUM(SHIP_ROW.AMOUNT) TOTAL_AMOUNT,
				SHIP.SHIP_ID,
				SHIP.SHIP_DATE,
				#get_all_periods.period_id# SHIP_PERIOD_ID,
				#get_all_periods.period_year# SHIP_PERIOD_YEAR,
				SHIP_NUMBER,
				ISNULL(SHIP.PROJECT_ID,0) PROJECT_ID		
			FROM 
				#dsn#_#get_all_periods.PERIOD_YEAR#_#get_all_periods.OUR_COMPANY_ID#.SHIP SHIP,
				#dsn#_#get_all_periods.PERIOD_YEAR#_#get_all_periods.OUR_COMPANY_ID#.SHIP_ROW SHIP_ROW,
				#dsn3_alias#.STOCKS S
			WHERE 
				SHIP_ROW.SHIP_ID = SHIP.SHIP_ID
				AND SHIP.IS_SHIP_IPTAL = 0 
				AND SHIP_ROW.STOCK_ID = S.STOCK_ID
				AND SHIP.SHIP_TYPE IN(70,71,88)
				AND S.IS_INVENTORY = 1
				<cfif len(attributes.subscription_id)>
					AND SHIP.SUBSCRIPTION_ID = #attributes.subscription_id#
				</cfif>
				<cfif len(attributes.project_id)>
					AND SHIP.PROJECT_ID = #attributes.project_id#
				</cfif>
				<cfif isdefined("attributes.is_project")>
					AND SHIP.PROJECT_ID IS NULL
				</cfif>
			GROUP  BY
				S.PRODUCT_ID,
				S.STOCK_ID,
				S.PRODUCT_NAME,
				SHIP.SHIP_ID,
				SHIP.SHIP_DATE,
				SHIP_NUMBER	,
				ISNULL(SHIP.PROJECT_ID,0)			
			<cfif currentrow neq get_all_periods.recordcount> UNION ALL </cfif>					
		</cfloop>
		)T1
		GROUP BY
			PRODUCT_ID,
			STOCK_ID,
			PRODUCT_NAME,
			SHIP_ID,
			SHIP_DATE,
			SHIP_PERIOD_ID,
			SHIP_PERIOD_YEAR,
			SHIP_NUMBER	,
			PROJECT_ID			
		ORDER BY
			SHIP_DATE
	</cfquery>
	<cfquery name="get_konsinye" dbtype="query">
		SELECT SUM(TOTAL_KONS_AMOUNT) TOTAL_KONS_AMOUNT,PRODUCT_ID,STOCK_ID,PRODUCT_NAME FROM get_konsinye_row GROUP BY PRODUCT_ID,STOCK_ID,PRODUCT_NAME
	</cfquery>
	<!--- konsinye iadeleri --->
	<cfquery name="get_konsinye_iade" datasource="#dsn2#" cachedwithin="#fusebox.general_cached_time#">
		<cfloop query="get_all_periods">
			SELECT
				S.PRODUCT_ID,
				S.STOCK_ID,
				S.PRODUCT_NAME,
				SUM(SHIP_ROW.AMOUNT) TOTAL_KONS_AMOUNT
			FROM 
				#dsn#_#get_all_periods.PERIOD_YEAR#_#get_all_periods.OUR_COMPANY_ID#.SHIP SHIP,
				#dsn#_#get_all_periods.PERIOD_YEAR#_#get_all_periods.OUR_COMPANY_ID#.SHIP_ROW SHIP_ROW,
				#dsn3_alias#.STOCKS S
			WHERE 
				SHIP_ROW.SHIP_ID = SHIP.SHIP_ID
				AND SHIP.IS_SHIP_IPTAL = 0 
				AND SHIP_ROW.STOCK_ID = S.STOCK_ID
				AND SHIP.IS_WITH_SHIP=0
				AND SHIP.SHIP_TYPE = 75
				AND S.IS_INVENTORY = 1
				<cfif len(attributes.subscription_id)>
					AND SHIP.SUBSCRIPTION_ID = #attributes.subscription_id#
				</cfif>
				<cfif len(attributes.project_id)>
					AND SHIP.PROJECT_ID = #attributes.project_id#
				</cfif>
				<cfif isdefined("attributes.is_project")>
					AND SHIP.PROJECT_ID IS NULL
				</cfif>
			GROUP  BY
				S.PRODUCT_ID,
				S.STOCK_ID,
				S.PRODUCT_NAME
			<cfif currentrow neq get_all_periods.recordcount> UNION ALL </cfif>					
		</cfloop>
	</cfquery>
	<!--- faturalanmış konsinye --->
	<cfquery name="get_inv_amount" datasource="#dsn#">
		SELECT
			SUM(AMOUNT) AS INV_AMOUNT,
			PRODUCT_ID,
			STOCK_ID,
			SHIP_ID,
			SHIP_DATE,
			SHIP_PERIOD_ID,
			SHIP_PERIOD_YEAR,
			SHIP_NUMBER,
			PROJECT_ID		
		FROM
		(
		<cfloop query="get_all_periods">
		<cfif currentrow neq 1> UNION ALL </cfif>					
			SELECT
				SUM(AMOUNT) AS AMOUNT,
				SRR.PRODUCT_ID,
				SRR.STOCK_ID,
				S.SHIP_ID,
				S.SHIP_DATE,
				#get_all_periods.period_id# SHIP_PERIOD_ID,
				#get_all_periods.period_year# SHIP_PERIOD_YEAR	,
				SHIP_NUMBER,
				ISNULL(S.PROJECT_ID,0) PROJECT_ID	
			FROM
				#dsn#_#get_all_periods.PERIOD_YEAR#_#get_all_periods.OUR_COMPANY_ID#.SHIP_ROW_RELATION SRR,
				#dsn#_#get_all_periods.PERIOD_YEAR#_#get_all_periods.OUR_COMPANY_ID#.INVOICE INV,
				#dsn#_#get_all_periods.PERIOD_YEAR#_#get_all_periods.OUR_COMPANY_ID#.SHIP S,
				#dsn3_alias#.STOCKS SS
			WHERE
				SRR.TO_INVOICE_ID =INV.INVOICE_ID
				AND SRR.SHIP_ID = S.SHIP_ID
				AND SRR.STOCK_ID = SS.STOCK_ID
				AND S.SHIP_TYPE IN (72,75,77,79)
				AND INV.PURCHASE_SALES = 1
				AND SRR.TO_INVOICE_CAT = INV.INVOICE_CAT
				AND SHIP_PERIOD=#get_all_periods.period_id#
				AND SRR.TO_INVOICE_ID IS NOT NULL
				AND SS.IS_INVENTORY = 1
				<cfif len(attributes.subscription_id)>
					AND S.SUBSCRIPTION_ID = #attributes.subscription_id#
				</cfif>
				<cfif len(attributes.project_id)>
					AND S.PROJECT_ID = #attributes.project_id#
				</cfif>
				<cfif isdefined("attributes.is_project")>
					AND S.PROJECT_ID IS NULL
				</cfif>
			GROUP BY
				SRR.PRODUCT_ID,
				SRR.STOCK_ID,
				S.SHIP_DATE,
				S.SHIP_ID,
				SHIP_NUMBER	,
				ISNULL(S.PROJECT_ID,0)	
			<cfif isdefined('list_period_years') and listfind(list_period_years,(get_all_periods.PERIOD_YEAR+1))>
			UNION ALL
				SELECT
					SUM(AMOUNT) AS AMOUNT,
					SRR.PRODUCT_ID,
					SRR.STOCK_ID,
					S.SHIP_ID,
					S.SHIP_DATE,
					#get_all_periods.period_id# SHIP_PERIOD_ID,
					#get_all_periods.period_year# SHIP_PERIOD_YEAR,
					SHIP_NUMBER	,
					ISNULL(S.PROJECT_ID,0) PROJECT_ID
				FROM
					#dsn#_#get_all_periods.PERIOD_YEAR+1#_#get_all_periods.OUR_COMPANY_ID#.SHIP_ROW_RELATION SRR,
					#dsn#_#get_all_periods.PERIOD_YEAR+1#_#get_all_periods.OUR_COMPANY_ID#.INVOICE INV,
					#dsn#_#get_all_periods.PERIOD_YEAR#_#get_all_periods.OUR_COMPANY_ID#.SHIP S,
					#dsn3_alias#.STOCKS SS
				WHERE
					SRR.TO_INVOICE_ID =INV.INVOICE_ID
					AND SRR.SHIP_ID = S.SHIP_ID
					AND SRR.STOCK_ID = SS.STOCK_ID
					AND S.SHIP_TYPE IN (72,75,77,79)
					AND INV.PURCHASE_SALES = 1
					AND SRR.TO_INVOICE_CAT = INV.INVOICE_CAT
					AND SHIP_PERIOD=#get_all_periods.period_id#
					AND SRR.TO_INVOICE_ID IS NOT NULL
					AND SS.IS_INVENTORY = 1
					<cfif len(attributes.subscription_id)>
						AND S.SUBSCRIPTION_ID = #attributes.subscription_id#
					</cfif>
					<cfif len(attributes.project_id)>
						AND S.PROJECT_ID = #attributes.project_id#
					</cfif>
					<cfif isdefined("attributes.is_project")>
						AND S.PROJECT_ID IS NULL
					</cfif>
				GROUP BY
					SRR.PRODUCT_ID,
					SRR.STOCK_ID,
					S.SHIP_DATE,
					S.SHIP_ID,
					SHIP_NUMBER	,
					ISNULL(S.PROJECT_ID,0)
			</cfif>
		</cfloop>
		 ) AS A1
		GROUP BY
			PRODUCT_ID,
			STOCK_ID,
			SHIP_ID,
			SHIP_DATE,
			SHIP_PERIOD_ID,
			SHIP_PERIOD_YEAR,
			SHIP_NUMBER	,
			PROJECT_ID	
	</cfquery>
	<!--- Satış çıkışlar --->
	<cfquery name="get_sale_row" datasource="#dsn2#" cachedwithin="#fusebox.general_cached_time#">
		SELECT
			PRODUCT_ID,
			STOCK_ID,
			PRODUCT_NAME,
			SUM(TOTAL_AMOUNT) TOTAL_AMOUNT,
			SHIP_ID,
			SHIP_DATE,
			SHIP_PERIOD_ID,
			SHIP_PERIOD_YEAR,
			SHIP_NUMBER,
			PROJECT_ID	
		FROM
		(
		<cfloop query="get_all_periods">
			SELECT
				S.PRODUCT_ID,
				S.STOCK_ID,
				S.PRODUCT_NAME,
				SUM(SHIP_ROW.AMOUNT) TOTAL_AMOUNT,
				SHIP.SHIP_ID,
				SHIP.SHIP_DATE,
				#get_all_periods.period_id# SHIP_PERIOD_ID,
				#get_all_periods.period_year# SHIP_PERIOD_YEAR,
				SHIP_NUMBER,
				ISNULL(SHIP.PROJECT_ID,0) PROJECT_ID		
			FROM 
				#dsn#_#get_all_periods.PERIOD_YEAR#_#get_all_periods.OUR_COMPANY_ID#.SHIP SHIP,
				#dsn#_#get_all_periods.PERIOD_YEAR#_#get_all_periods.OUR_COMPANY_ID#.SHIP_ROW SHIP_ROW,
				#dsn3_alias#.STOCKS S
			WHERE 
				SHIP_ROW.SHIP_ID = SHIP.SHIP_ID
				AND SHIP.IS_SHIP_IPTAL = 0 
				AND SHIP_ROW.STOCK_ID = S.STOCK_ID
				AND SHIP.SHIP_TYPE IN(70,71,88)
				AND S.IS_INVENTORY = 1
				AND SHIP.SHIP_ID NOT IN(SELECT SF.RELATED_SHIP_ID FROM #dsn#_#get_all_periods.PERIOD_YEAR#_#get_all_periods.OUR_COMPANY_ID#.STOCK_FIS SF WHERE SF.RELATED_SHIP_ID IS NOT NULL AND SF.RELATED_SHIP_ID=SHIP.SHIP_ID)
				<cfif len(attributes.subscription_id)>
					AND SHIP.SUBSCRIPTION_ID = #attributes.subscription_id#
				</cfif>
				<cfif len(attributes.project_id)>
					AND SHIP.PROJECT_ID = #attributes.project_id#
				</cfif>
				<cfif isdefined("attributes.is_project")>
					AND SHIP.PROJECT_ID IS NULL
				</cfif>
			GROUP  BY
				S.PRODUCT_ID,
				S.STOCK_ID,
				S.PRODUCT_NAME,
				SHIP.SHIP_ID,
				SHIP.SHIP_DATE,
				SHIP_NUMBER	,
				ISNULL(SHIP.PROJECT_ID,0)		
			<cfif currentrow neq get_all_periods.recordcount> UNION ALL </cfif>					
		</cfloop>
		)T1
		GROUP BY
			PRODUCT_ID,
			STOCK_ID,
			PRODUCT_NAME,
			SHIP_ID,
			SHIP_DATE,
			SHIP_PERIOD_ID,
			SHIP_PERIOD_YEAR,
			SHIP_NUMBER	,
			PROJECT_ID			
		ORDER BY
			SHIP_DATE
	</cfquery>
	<!--- satış iadeleri --->
	<cfquery name="get_sale_iade" datasource="#dsn2#" cachedwithin="#fusebox.general_cached_time#">
		<cfloop query="get_all_periods">
			SELECT
				S.PRODUCT_ID,
				S.STOCK_ID,
				S.PRODUCT_NAME,
				SUM(SHIP_ROW.AMOUNT) TOTAL_AMOUNT
			FROM 
				#dsn#_#get_all_periods.PERIOD_YEAR#_#get_all_periods.OUR_COMPANY_ID#.SHIP SHIP,
				#dsn#_#get_all_periods.PERIOD_YEAR#_#get_all_periods.OUR_COMPANY_ID#.SHIP_ROW SHIP_ROW,
				#dsn3_alias#.STOCKS S
			WHERE 
				SHIP_ROW.SHIP_ID = SHIP.SHIP_ID
				AND SHIP.IS_SHIP_IPTAL = 0 
				AND SHIP_ROW.STOCK_ID = S.STOCK_ID
				AND SHIP.SHIP_TYPE IN(73,74)
				AND S.IS_INVENTORY = 1
				AND SHIP.SHIP_ID NOT IN(SELECT SF.RELATED_SHIP_ID FROM #dsn#_#get_all_periods.PERIOD_YEAR#_#get_all_periods.OUR_COMPANY_ID#.STOCK_FIS SF WHERE SF.RELATED_SHIP_ID IS NOT NULL AND SF.RELATED_SHIP_ID=SHIP.SHIP_ID)
				<cfif len(attributes.subscription_id)>
					AND SHIP.SUBSCRIPTION_ID = #attributes.subscription_id#
				</cfif>
				<cfif len(attributes.project_id)>
					AND SHIP.PROJECT_ID = #attributes.project_id#
				</cfif>
				<cfif isdefined("attributes.is_project")>
					AND SHIP.PROJECT_ID IS NULL
				</cfif>
			GROUP  BY
				S.PRODUCT_ID,
				S.STOCK_ID,
				S.PRODUCT_NAME
			<cfif currentrow neq get_all_periods.recordcount> UNION ALL </cfif>					
		</cfloop>
	</cfquery>
	<!--- faturalanmış satış --->
	<cfquery name="get_inv_sale_amount" datasource="#dsn#">
		SELECT
			SUM(AMOUNT) AS INV_AMOUNT,
			PRODUCT_ID,
			STOCK_ID,
			SHIP_ID,
			SHIP_DATE,
			SHIP_PERIOD_ID,
			SHIP_PERIOD_YEAR,
			SHIP_NUMBER,
			PROJECT_ID		
		FROM
		(
		<cfloop query="get_all_periods">
		<cfif currentrow neq 1> UNION ALL </cfif>					
			SELECT
				SUM(INV_R.AMOUNT) AS AMOUNT,
				SR.PRODUCT_ID,
				SR.STOCK_ID,
				S.SHIP_ID,
				S.SHIP_DATE,
				#get_all_periods.period_id# SHIP_PERIOD_ID,
				#get_all_periods.period_year# SHIP_PERIOD_YEAR	,
				S.SHIP_NUMBER,
				ISNULL(S.PROJECT_ID,0) PROJECT_ID	
			FROM
				#dsn#_#get_all_periods.PERIOD_YEAR#_#get_all_periods.OUR_COMPANY_ID#.INVOICE_SHIPS SRR,
				#dsn#_#get_all_periods.PERIOD_YEAR#_#get_all_periods.OUR_COMPANY_ID#.INVOICE INV,
				#dsn#_#get_all_periods.PERIOD_YEAR#_#get_all_periods.OUR_COMPANY_ID#.INVOICE_ROW INV_R,
				#dsn#_#get_all_periods.PERIOD_YEAR#_#get_all_periods.OUR_COMPANY_ID#.SHIP S,
				#dsn#_#get_all_periods.PERIOD_YEAR#_#get_all_periods.OUR_COMPANY_ID#.SHIP_ROW SR,
				#dsn3_alias#.STOCKS SS

			WHERE
				SRR.INVOICE_ID =INV.INVOICE_ID
				AND INV_R.INVOICE_ID = INV.INVOICE_ID
				AND ISNULL(INV_R.WRK_ROW_RELATION_ID,0) = ISNULL(SR.WRK_ROW_ID,0)
				AND ISNULL(S.IS_WITH_SHIP,0) = 0
				AND SRR.SHIP_ID = S.SHIP_ID
				AND SR.SHIP_ID = S.SHIP_ID
				AND SR.STOCK_ID = SS.STOCK_ID
				AND INV_R.STOCK_ID = SS.STOCK_ID
				AND S.SHIP_TYPE IN (70,71,88)
				AND INV.PURCHASE_SALES = 1
				AND SS.IS_INVENTORY = 1
				AND S.SHIP_ID NOT IN(SELECT SF.RELATED_SHIP_ID FROM #dsn#_#get_all_periods.PERIOD_YEAR#_#get_all_periods.OUR_COMPANY_ID#.STOCK_FIS SF WHERE SF.RELATED_SHIP_ID IS NOT NULL AND SF.RELATED_SHIP_ID=S.SHIP_ID)
				<cfif len(attributes.subscription_id)>
					AND S.SUBSCRIPTION_ID = #attributes.subscription_id#
				</cfif>
				<cfif len(attributes.project_id)>
					AND S.PROJECT_ID = #attributes.project_id#
				</cfif>
				<cfif isdefined("attributes.is_project")>
					AND S.PROJECT_ID IS NULL
				</cfif>
			GROUP BY
				SR.PRODUCT_ID,
				SR.STOCK_ID,
				S.SHIP_DATE,
				S.SHIP_ID,
				S.SHIP_NUMBER	,
				ISNULL(S.PROJECT_ID,0)	
			UNION ALL
			SELECT
				SUM(INV_R.AMOUNT) AS AMOUNT,
				SR.PRODUCT_ID,
				SR.STOCK_ID,
				S.SHIP_ID,
				S.SHIP_DATE,
				#get_all_periods.period_id# SHIP_PERIOD_ID,
				#get_all_periods.period_year# SHIP_PERIOD_YEAR	,
				S.SHIP_NUMBER,
				ISNULL(S.PROJECT_ID,0) PROJECT_ID	
			FROM
				#dsn#_#get_all_periods.PERIOD_YEAR#_#get_all_periods.OUR_COMPANY_ID#.INVOICE_SHIPS SRR,
				#dsn#_#get_all_periods.PERIOD_YEAR#_#get_all_periods.OUR_COMPANY_ID#.INVOICE INV,
				#dsn#_#get_all_periods.PERIOD_YEAR#_#get_all_periods.OUR_COMPANY_ID#.INVOICE_ROW INV_R,
				#dsn#_#get_all_periods.PERIOD_YEAR#_#get_all_periods.OUR_COMPANY_ID#.SHIP S,
				#dsn#_#get_all_periods.PERIOD_YEAR#_#get_all_periods.OUR_COMPANY_ID#.SHIP_ROW SR,
				#dsn3_alias#.STOCKS SS
			WHERE
				SRR.INVOICE_ID =INV.INVOICE_ID
				AND INV_R.INVOICE_ID = INV.INVOICE_ID
				AND ISNULL(SR.WRK_ROW_RELATION_ID,0) = ISNULL(INV_R.WRK_ROW_ID,0)
				AND ISNULL(S.IS_WITH_SHIP,0) = 1
				AND SRR.SHIP_ID = S.SHIP_ID
				AND SR.SHIP_ID = S.SHIP_ID
				AND SR.STOCK_ID = SS.STOCK_ID
				AND INV_R.STOCK_ID = SS.STOCK_ID
				AND S.SHIP_TYPE IN (70,71,88)
				AND INV.PURCHASE_SALES = 1
				AND SS.IS_INVENTORY = 1
				AND S.SHIP_ID NOT IN(SELECT SF.RELATED_SHIP_ID FROM #dsn#_#get_all_periods.PERIOD_YEAR#_#get_all_periods.OUR_COMPANY_ID#.STOCK_FIS SF WHERE SF.RELATED_SHIP_ID IS NOT NULL AND SF.RELATED_SHIP_ID=S.SHIP_ID)
				<cfif len(attributes.subscription_id)>
					AND S.SUBSCRIPTION_ID = #attributes.subscription_id#
				</cfif>
				<cfif len(attributes.project_id)>
					AND S.PROJECT_ID = #attributes.project_id#
				</cfif>
				<cfif isdefined("attributes.is_project")>
					AND S.PROJECT_ID IS NULL
				</cfif>
			GROUP BY
				SR.PRODUCT_ID,
				SR.STOCK_ID,
				S.SHIP_DATE,
				S.SHIP_ID,
				S.SHIP_NUMBER,
				ISNULL(S.PROJECT_ID,0)
		</cfloop>
		 ) AS A1
		GROUP BY
			PRODUCT_ID,
			STOCK_ID,
			SHIP_ID,
			SHIP_DATE,
			SHIP_PERIOD_ID,
			SHIP_PERIOD_YEAR,
			SHIP_NUMBER	,
			PROJECT_ID	
	</cfquery>
	<!--- Konsinyeler --->
	<cfoutput query="get_konsinye_row">
		<cfif isdefined("kons_irsaliye_list_#stock_id#") and not listfind(evaluate("kons_irsaliye_list_#stock_id#"),"#ship_id#;#ship_period_id#;#total_kons_amount#;#ship_period_year#;#ship_number#;#project_id#")>
			<cfset "kons_irsaliye_list_#stock_id#" = listappend(evaluate("kons_irsaliye_list_#stock_id#"),"#ship_id#;#ship_period_id#;#total_kons_amount#;#ship_period_year#;#ship_number#;#project_id#")>
		<cfelse>
			<cfset "kons_irsaliye_list_#stock_id#" = "#ship_id#;#ship_period_id#;#total_kons_amount#;#ship_period_year#;#ship_number#;#project_id#">
		</cfif>
	</cfoutput>
	<cfoutput query="get_konsinye_iade">
		<cfif isdefined("kons_iade_#stock_id#")>
			<cfset "kons_iade_#stock_id#" = evaluate("kons_iade_#stock_id#") + total_kons_amount>
		<cfelse>
			<cfset "kons_iade_#stock_id#" = total_kons_amount>
		</cfif>
	</cfoutput>
	<cfoutput query="get_inv_amount">
		<cfif isdefined("inv_irsaliye_list_#stock_id#") and not listfind(evaluate("inv_irsaliye_list_#stock_id#"),"#ship_id#;#ship_period_id#;#inv_amount#;#ship_period_year#;#ship_number#;#project_id#")>
			<cfset "inv_irsaliye_list_#stock_id#" = listappend(evaluate("inv_irsaliye_list_#stock_id#"),"#ship_id#;#ship_period_id#;#inv_amount#;#ship_period_year#;#ship_number#;#project_id#")>
		<cfelse>
			<cfset "inv_irsaliye_list_#stock_id#" = "#ship_id#;#ship_period_id#;#inv_amount#;#ship_period_year#;#ship_number#;#project_id#">
		</cfif>
		<cfif isdefined("inv_amount_#stock_id#")>
			<cfset "inv_amount_#stock_id#" = evaluate("inv_amount_#stock_id#") + inv_amount>
		<cfelse>
			<cfset "inv_amount_#stock_id#" = inv_amount>
		</cfif>
	</cfoutput>
	<!--- Satışlar --->
	<cfoutput query="get_sale_row">
		<cfif isdefined("sale_irsaliye_list_#stock_id#") and not listfind(evaluate("sale_irsaliye_list_#stock_id#"),"#ship_id#;#ship_period_id#;#total_amount#;#ship_period_year#;#ship_number#;#project_id#")>
			<cfset "sale_irsaliye_list_#stock_id#" = listappend(evaluate("sale_irsaliye_list_#stock_id#"),"#ship_id#;#ship_period_id#;#total_amount#;#ship_period_year#;#ship_number#;#project_id#")>
		<cfelse>
			<cfset "sale_irsaliye_list_#stock_id#" = "#ship_id#;#ship_period_id#;#total_amount#;#ship_period_year#;#ship_number#;#project_id#">
		</cfif>
		<cfif isdefined("sale_amount_#stock_id#")>
			<cfset "sale_amount_#stock_id#" = evaluate("sale_amount_#stock_id#") + total_amount>
		<cfelse>
			<cfset "sale_amount_#stock_id#" = total_amount>
		</cfif>
	</cfoutput>
	<cfoutput query="get_sale_iade">
		<cfif isdefined("sale_iade_#stock_id#")>
			<cfset "sale_iade_#stock_id#" = evaluate("sale_iade_#stock_id#") + total_amount>
		<cfelse>
			<cfset "sale_iade_#stock_id#" = total_amount>
		</cfif>
	</cfoutput>
	<cfoutput query="get_inv_sale_amount">
		<cfif isdefined("inv_sale_amount_#stock_id#")>
			<cfset "inv_sale_amount_#stock_id#" = evaluate("inv_sale_amount_#stock_id#") + inv_amount>
		<cfelse>
			<cfset "inv_sale_amount_#stock_id#" = inv_amount>
		</cfif>
	</cfoutput>
	<cfsavecontent variable="head"><cf_get_lang dictionary_id='45801.Ürün İade'></cfsavecontent>
	<cf_box title="#head#" uidrop="1" hide_table_column="1">
		<cf_flat_list>
			<thead>
				<tr>
					<th></th>
					<th class="color-row" width="1"></th>
					<th class="form-title" colspan="4" align="center"><cf_get_lang dictionary_id='45518.Konsinye'></th>
					<th class="color-row" width="1"></th>
					<th class="form-title" colspan="4" align="center"><cf_get_lang dictionary_id='57448.Satış'></th>
					<th class="color-row" width="1"></th>
					<th class="form-title" colspan="2" align="center"><cf_get_lang dictionary_id='45794.İade Alınabilir'></th>
					<th></th>
				</tr>
				<tr height="22">
					<th class="form-title"><cf_get_lang dictionary_id='57657.Ürün'></th>
					<th class="color-row" width="1"></th>
					<th width="100" align="right" class="form-title" style="text-align:right;"><cf_get_lang dictionary_id='57431.Çıkış'></th>
					<th width="100" align="right" class="form-title" style="text-align:right;"><cf_get_lang dictionary_id='29418.İade'></th>
					<th width="100" align="right" class="form-title" style="text-align:right;"><cf_get_lang dictionary_id='45796.Faturalanan'></th>
					<th width="100" align="right" class="form-title" style="text-align:right;"><cf_get_lang dictionary_id='58444.Kalan'></th>
					<th class="color-row" width="1"></th>
					<th width="100" align="right" class="form-title" style="text-align:right;"><cf_get_lang dictionary_id='57431.Çıkış'></th>
					<th width="100" align="right" class="form-title" style="text-align:right;"><cf_get_lang dictionary_id='29418.İade'></th>
					<th width="100" align="right" class="form-title" style="text-align:right;"><cf_get_lang dictionary_id='45796.Faturalanan'></th>
					<th width="100" align="right" class="form-title" style="text-align:right;"><cf_get_lang dictionary_id='58444.Kalan'></th>
					<th class="color-row" width="1"></th>
					<th width="100" align="right" class="form-title" style="text-align:right;"><cf_get_lang dictionary_id='45518.Konsinye'></th>
					<th width="100" align="right" class="form-title" style="text-align:right;"><cf_get_lang dictionary_id='57448.Satış'></th>
					<th class="header_icn_none">
						<input type="checkbox" name="allSelectDemand" id="allSelectDemand" onclick="wrk_select_all('allSelectDemand','kons_row_ids');">
					</th>
				</tr>
			</thead>
			<tbody>
				<cfif get_konsinye.recordcount>
					<cfform action="#request.self#?fuseaction=stock.form_add_purchase" name="send_form_2" method="post">
						<cfoutput>
						<input type="hidden" name="kons_return_type" id="kons_return_type" value="">
						<input type="hidden" name="subscription_id" id="subscription_id" value="<cfif isdefined("attributes.subscription_id")>#attributes.subscription_id#</cfif>" />				
						<input type="hidden" name="subscription_no" id="subscription_no" value="<cfif isdefined("attributes.subscription_no")>#attributes.subscription_no#</cfif>" />
						<input type="hidden" name="project_id" id="project_id" value="<cfif isdefined("attributes.project_id")>#attributes.project_id#</cfif>" />				
						<input type="hidden" name="project_name" id="project_name" value="<cfif isdefined("attributes.project_name")>#attributes.project_name#</cfif>" />
						</cfoutput>
						<cfoutput query="get_konsinye">
							<cfif isdefined("kons_iade_#stock_id#")>
								<cfset kons_iade = evaluate("kons_iade_#stock_id#")>
							<cfelse>
								<cfset kons_iade = 0>
							</cfif>
							<cfif isdefined("inv_amount_#stock_id#")>
								<cfset inv_amount = evaluate("inv_amount_#stock_id#")>
							<cfelse>
								<cfset inv_amount = 0>
							</cfif>
							<cfif isdefined("sale_amount_#stock_id#")>
								<cfset sale_amount = evaluate("sale_amount_#stock_id#")>
							<cfelse>
								<cfset sale_amount = 0>
							</cfif>
							<cfif isdefined("sale_iade_#stock_id#")>
								<cfset sale_iade = evaluate("sale_iade_#stock_id#")>
							<cfelse>
								<cfset sale_iade = 0>
							</cfif>
							<cfif isdefined("inv_sale_amount_#stock_id#")>
								<cfset inv_sale_amount = evaluate("inv_sale_amount_#stock_id#")>
							<cfelse>
								<cfset inv_sale_amount = 0>
							</cfif>
							<cfif isdefined("kons_irsaliye_list_#stock_id#")>
								<cfset kons_irsaliye_list = evaluate("kons_irsaliye_list_#stock_id#")>
							<cfelse>
								<cfset kons_irsaliye_list = 0>
							</cfif>
							<cfif isdefined("inv_irsaliye_list_#stock_id#")>
								<cfset inv_irsaliye_list = evaluate("inv_irsaliye_list_#stock_id#")>
							<cfelse>
								<cfset inv_irsaliye_list = 0>
							</cfif>
							<cfif isdefined("sale_irsaliye_list_#stock_id#")>
								<cfset sale_irsaliye_list = evaluate("sale_irsaliye_list_#stock_id#")>
							<cfelse>
								<cfset sale_irsaliye_list = 0>
							</cfif>
							<cfset kalan = total_kons_amount-kons_iade-inv_amount>
							<cfset kalan_sale = sale_amount-sale_iade-inv_sale_amount>
							<cfif is_add_kons_invoice eq 1>
								<cfset kalan_sale = kalan_sale + inv_amount>
							</cfif>
							<input type="hidden" name="kons_irsaliye_list_#stock_id#" id="kons_irsaliye_list_#stock_id#" value="#kons_irsaliye_list#">
							<input type="hidden" name="inv_irsaliye_list_#stock_id#" id="inv_irsaliye_list_#stock_id#" value="#sale_irsaliye_list#">
							<input type="hidden" name="old_iade_#stock_id#" id="old_iade_#stock_id#" value="#kons_iade#">
							<input type="hidden" name="old_inv_iade_#stock_id#" id="old_inv_iade_#stock_id#" value="#sale_iade#">
							<cfif total_kons_amount gt 0 or kons_iade gt 0 or inv_amount gt 0 or sale_amount gt 0 or sale_iade gt 0 or inv_sale_amount gt 0>
								<tr>
									<td width="250">#product_name#</td>
									<td class="color-header" width="1"></td>
									<td align="right" style="text-align:right;">#total_kons_amount#</td>
									<td align="right" style="text-align:right;">#kons_iade#</td>
									<td align="right" style="text-align:right;">#inv_amount#</td>
									<td align="right" style="text-align:right;">#kalan#</td>
									<td class="color-header" width="1"></td>
									<td align="right" style="text-align:right;">#sale_amount#</td>
									<td align="right" style="text-align:right;">#sale_iade#</td>
									<td align="right" style="text-align:right;">#inv_sale_amount#</td>
									<td align="right" style="text-align:right;">#kalan_sale#</td>
									<td class="color-header" width="1"></td>
									<td align="right" style="text-align:right;">
										<cfinput type="hidden" name="old_kons_iade_#STOCK_ID#" value="#kalan#">
										<cfif kalan gt 0>
											<cfinput type="text" name="kons_iade_#STOCK_ID#" validate="float" onKeyUp="return(FormatCurrency(this,event));" onBlur="kontrol_amount(#stock_id#,1);" value="#tlformat(kalan,0)#" style="width:50px;" class="moneybox">
										<cfelse>
											<cfinput type="text" readonly name="kons_iade_#STOCK_ID#" validate="float" onKeyUp="return(FormatCurrency(this,event));" value="#kalan#" style="width:50px;" class="moneybox">
										</cfif>
									</td>
									<td align="right" style="text-align:right;">
										<cfinput type="hidden" name="old_sale_iade_#STOCK_ID#" value="#kalan_sale#">
										<cfif kalan_sale gt 0>
											<cfinput type="text" name="sale_iade_#STOCK_ID#" validate="float" onKeyUp="return(FormatCurrency(this,event));" onBlur="kontrol_amount(#stock_id#,2);" value="#tlformat(kalan_sale,0)#" style="width:50px;" class="moneybox">
										<cfelse>
											<cfinput type="text" readonly name="sale_iade_#STOCK_ID#" validate="float" onKeyUp="return(FormatCurrency(this,event));" value="#tlformat(kalan_sale,0)#" style="width:50px;" class="moneybox">
										</cfif>
									</td>
									<td><input type="checkbox" name="kons_row_ids" id="kons_row_ids" value="#STOCK_ID#"></td>
								</tr>
							</cfif>
						</cfoutput>
						<tr class="total" height="22">
							<td colspan="15" align="right" style="text-align:right;">
								<cfsavecontent variable="message"><cf_get_lang dictionary_id='45797.Konsinye İade İrsaliyesi Düzenle'></cfsavecontent>
								<cfsavecontent variable="message1"><cf_get_lang dictionary_id='45798.Satış İade İrsaliyesi Düzenle'></cfsavecontent>
								<cf_wrk_search_button search_function="kontrol_et(2)" button_type="2" button_name="#message1#">
								<cf_wrk_search_button search_function="kontrol_et(1)" button_type="2" button_name="#message#">
							</td>
						</tr>
					</cfform>
				<cfelse>
					<tr class="color-row" height="20">
						<td colspan="15"><cf_get_lang dictionary_id='58486.Kayıt Bulunamadı'>!</td>
					</tr>
				</cfif>
			</tbody>
		</cf_flat_list>
	</cf_box>
</div>

	<script type="text/javascript">
		function kontrol_et(type)
		{
			kontrol_ = 0;
			if(type == 0)
			{
				if (document.send_form_.invent_return_row_ids.length != undefined) /* n tane*/
				{
					for (i=0; i < document.send_form_.invent_return_row_ids.length; i++)
					{
						if (document.send_form_.invent_return_row_ids[i].checked)
							kontrol_ = 1;
					}							
				}
				else
				{
					if (document.send_form_.invent_return_row_ids.checked)
						kontrol_ = 1;	
				}
			}
			else
			{
				document.send_form_2.kons_return_type.value = type;
				if (document.send_form_2.kons_row_ids.length != undefined) /* n tane*/
				{
					for (i=0; i < document.send_form_2.kons_row_ids.length; i++)
					{
						if (document.send_form_2.kons_row_ids[i].checked)
							kontrol_ = 1;
					}							
				}
				else
				{
					if (document.send_form_2.kons_row_ids.checked)
						kontrol_ = 1;	
				}
			}
			if(kontrol_ == 0)
			{
				alert("<cf_get_lang dictionary_id='45799.En Az Bir İşlem Seçmelisiniz'> !");
				return false;
			}
			return true;
		}
		function kontrol_amount(s_id,type)
		{
			if(type == 0)
			{
				old_amount = eval('document.all.old_invent_return_amount_'+s_id).value;
				new_amount = parseFloat(filterNum(eval('document.all.invent_return_amount_'+s_id).value,0));
				if(new_amount > old_amount)
				{
					alert("<cf_get_lang dictionary_id='45792.Girilebilecek Aralık'> 1 -"+ old_amount);
					eval('document.all.invent_return_amount_'+s_id).value = commaSplit(old_amount,0);
				}
			}
			else if(type == 1)
			{
				old_amount = eval('document.all.old_kons_iade_'+s_id).value;
				new_amount = parseFloat(filterNum(eval('document.all.kons_iade_'+s_id).value,0));
				if(new_amount > old_amount)
				{
					alert("<cf_get_lang dictionary_id='45792.Girilebilecek Aralık'> 1 -"+ old_amount);
					eval('document.all.kons_iade_'+s_id).value = commaSplit(old_amount,0);
				}
			}
			else if(type == 2)
			{
				old_amount = eval('document.all.old_sale_iade_'+s_id).value;
				new_amount = parseFloat(filterNum(eval('document.all.sale_iade_'+s_id).value,0));
				if(new_amount > old_amount)
				{
					alert("<cf_get_lang dictionary_id='45792.Girilebilecek Aralık'> 1 -"+ old_amount);
					eval('document.all.sale_iade_'+s_id).value = commaSplit(old_amount,0);
				}
			}
		}
	</script>
</cfif>
