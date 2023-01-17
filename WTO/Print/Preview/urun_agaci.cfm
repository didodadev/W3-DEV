<link rel="stylesheet" href="/css/assets/template/catalyst/print.css" type="text/css">
<cfparam name="old_main_spec_id" default="0">
<cfparam name="attributes.stock_id" default="0">
<cfparam name="attributes.widget_load" default="">
<cfparam name="attributes.action_id" default="">
<cfparam name="attributes.widget_string" default="">
<cfset attributes.stock_main_id = attributes.stock_id>
<cfquery name="CHECK" datasource="#DSN#">
    SELECT 
    ASSET_FILE_NAME2,
    ASSET_FILE_NAME2_SERVER_ID,
    COMPANY_NAME
    FROM 
      OUR_COMPANY 
    WHERE 
      <cfif isdefined("attributes.our_company_id")>
        COMP_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.our_company_id#">
      <cfelse>
        <cfif isDefined("session.ep.company_id") and len(session.ep.company_id)>
          COMP_ID = #session.ep.company_id#
        <cfelseif isDefined("session.pp.company_id") and len(session.pp.company_id)>	
          COMP_ID = #session.pp.company_id#
        <cfelseif isDefined("session.ww.our_company_id")>
          COMP_ID = #session.ww.our_company_id#
        <cfelseif isDefined("session.cp.our_company_id")>
          COMP_ID = #session.cp.our_company_id#
        </cfif> 
      </cfif>    
</cfquery>
<cfquery name="get_product_tree" datasource="#DSN3#">
	SELECT DISTINCT 
		S.PRODUCT_UNIT_ID, 
		PT.STOCK_ID, 
		P.PRODUCT_CODE, 
		PT.PRODUCT_ID, 
		P.PRODUCT_NAME,
		ISNULL(PT.FIRE_RATE,0) AS FIRE_RATE, 
		ISNULL(PT.FIRE_AMOUNT,0) AS FIRE_AMOUNT, 
		PT.AMOUNT, 
		PU.MAIN_UNIT
	FROM 
		PRODUCT_TREE PT 
	LEFT JOIN 
		PRODUCT P 
		ON 
		PT.PRODUCT_ID = P.PRODUCT_ID
	LEFT JOIN 
		STOCKS S 
		ON 
		S.STOCK_ID = PT.STOCK_ID
	LEFT JOIN 
		PRODUCT_UNIT PU 
		ON 
		PU.PRODUCT_ID = P.PRODUCT_ID
	WHERE 
		PT.STOCK_ID = #attributes.action_id#
	GROUP BY 
		S.PRODUCT_UNIT_ID, 
		PT.STOCK_ID, 
		P.PRODUCT_CODE, 
		PT.PRODUCT_ID, 
		P.PRODUCT_NAME, 
		PT.FIRE_RATE, 
		PT.FIRE_AMOUNT, 
		PT.AMOUNT, 
		PU.MAIN_UNIT
</cfquery>
<cfset Page_Count = 1>
<cfoutput>
	<table style="width:210mm">
		<tr>
			<td>
				<table width="100%">
					<tr class="row_border">
						<td class="print-head">
                            <table style="width:100%;">   
								<tr>
									<td class="print_title"><cf_get_lang dictionary_id='36365.Ürün Ağacı'></td>
									<td style="text-align:right;">
										<cfif len(check.asset_file_name2)>
										<cfset attributes.type = 1>
										<cf_get_server_file output_file="/settings/#check.asset_file_name2#" output_server="#check.asset_file_name2_server_id#" output_type="5">
										</cfif>
									</td>
								</tr>
							</table> 
						</td>
						<tr class="row_border">
							<td>
								<table>
									<tr>
										<td style="height:35px;"><b><cf_get_lang dictionary_id='35700.Bileşenler'></b></td>
									</tr> 
								</table>
								<table  class="print_border"  style="width:180mm">
									<tr>
										<th><b><cf_get_lang dictionary_id='57518.Stok Kodu'></b></td>
										<th style="width:130px"><b><cf_get_lang dictionary_id='54291.Açıklaması'></b></td>
										<th><b><cf_get_lang dictionary_id='36357.Fire Oranı'></b></td>
										<th ><b><cf_get_lang dictionary_id='36356.Fire Miktarı'></b></td>
										<th><b><cf_get_lang dictionary_id='57635.Miktar'></b></th>
										<th><b><cf_get_lang dictionary_id ='57636.Birim'></b></th>
									</tr>
									<cfloop query="get_product_tree">
										<tr>
											<th>#get_product_tree.PRODUCT_CODE#</th>
											<th>#get_product_tree.PRODUCT_NAME#</th>
											<th>#get_product_tree.FIRE_RATE#</th>
											<th>#get_product_tree.FIRE_AMOUNT#</th>
											<th>#get_product_tree.AMOUNT#</th>
											<th>#get_product_tree.MAIN_UNIT#</th>
										</tr>
									</cfloop>
								</table>
							</td>
						</tr>
					</tr>
				</table>
				<table>
					<br>
						<tr class="fixed">
						<td style="font-size:9px!important;"><b>© Copyright</b> <cfoutput>#check.COMPANY_NAME#</cfoutput> dışında kullanılamaz, paylaşılamaz.</td>
						</tr>
					</br>
				</table> 
			</td>
		</tr>
	</table>
</cfoutput>
