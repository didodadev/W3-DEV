<cfinclude template="../../../V16/objects/functions/barcode.cfm">
<cfquery name="GET_ASSETP" datasource="#DSN#">
	SELECT 
		ASSET_P.SUP_PARTNER_ID,
        ASSET_P.INVENTORY_NUMBER,
        ASSET_P.ASSETP,
        ASSET_P.BARCODE,
        ASSET_P.SUP_CONSUMER_ID,
		ASSET_P_CAT.ASSETP_CAT,
		SETUP_BRAND_TYPE_CAT.BRAND_TYPE_CAT_NAME,
		SETUP_BRAND_TYPE.BRAND_TYPE_NAME,
		SETUP_BRAND.BRAND_NAME
	FROM
		ASSET_P INNER JOIN ASSET_P_CAT ON ASSET_P.ASSETP_CATID = ASSET_P_CAT.ASSETP_CATID
		LEFT JOIN SETUP_BRAND ON SETUP_BRAND.BRAND_ID = ASSET_P.BRAND_ID
		LEFT JOIN SETUP_BRAND_TYPE ON SETUP_BRAND_TYPE.BRAND_TYPE_ID = ASSET_P.BRAND_TYPE_ID
		LEFT JOIN SETUP_BRAND_TYPE_CAT ON SETUP_BRAND_TYPE_CAT.BRAND_TYPE_CAT_ID = ASSET_P.BRAND_TYPE_CAT_ID 
	WHERE
		ASSET_P.ASSETP_ID =<cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.action_type#">
</cfquery>
<cfquery name="GET_PARTNER" datasource="#DSN#">
    <cfif len(get_assetp.sup_partner_id)>
        SELECT
            C.FULLNAME
        FROM
            COMPANY_PARTNER CP,
            COMPANY C
        WHERE
            CP.PARTNER_ID =<cfqueryparam cfsqltype="cf_sql_integer" value="#get_assetp.sup_partner_id#"> AND
            CP.COMPANY_ID = C.COMPANY_ID
    <cfelseif len(get_assetp.sup_consumer_id)>
        SELECT
            CONSUMER_NAME +' '+ CONSUMER_SURNAME AS FULLNAME
        FROM
            CONSUMER
        WHERE
            CONSUMER_ID =<cfqueryparam cfsqltype="cf_sql_integer" value="#get_assetp.sup_consumer_id#"> 
	</cfif>
</cfquery>
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
<link rel="stylesheet" href="/css/assets/template/catalyst/print.css" type="text/css">

<cfoutput>
	<table style="width:210mm">
		<tr>
			<td>
				<table width="100%">
					<tr class="row_border">
						<td class="print-head">
							<table style="width:100%;">
								<tr>
									<td class="print_title"><cf_get_lang dictionary_id='49878.Fiziki Varlık Etiketi'></td>
										<td style="text-align:right;">
											<cfif len(check.asset_file_name2)>
											<cfset attributes.type = 1>
												<cf_get_server_file output_file="/settings/#check.asset_file_name2#" output_server="#check.asset_file_name2_server_id#" output_type="5">
											</cfif>
										</td>
									</td>
								</tr> 
							</table>
						</td>
					</tr>
				</table>
			</td>
		</tr>
		<tr class="row_border" class="row_border">
			<td>
				<table style="width:140mm" >
					<cfoutput>
						<tr>
							<td style="width:140px" class="txtbold"><cf_get_lang dictionary_id='32618.Alınan Şirket'></td>
							<td style="width:170px">#get_partner.fullname#</td>
							<td  style="width:140px" class="txtbold"><cf_get_lang dictionary_id='58878.Demirbaş No'></td>
							<td style="width:170px">#get_assetp.inventory_number#</td>
						</tr>
						<tr>
							<td class="txtbold"><cf_get_lang dictionary_id='57486.Kategori'></td>
							<td>#get_assetp.assetp_cat#</td>
							<td class="txtbold"><cf_get_lang dictionary_id='32605.Varlık Adı'></td>
							<td>#get_assetp.assetp#</td>
						</tr>
						<tr>
							<td class="txtbold"><cf_get_lang dictionary_id='58847.Marka'></td>
							<td>#get_assetp.brand_name# - #get_assetp.brand_type_name# - #get_assetp.brand_type_cat_name#</td>
						</tr>
						<tr>
							<td class="txtbold"><cf_get_lang dictionary_id='57633.Barkod'></td>
								<td>
								<cfset attributes.barcod = get_assetp.barcode>
								
								<cfif (len(attributes.barcod) eq 13) or (len(attributes.barcod) eq 12)>
									<cf_barcode type="EAN13" barcode="#attributes.barcod#" extra_height="0"><cfif len(errors)>#errors#</cfif>
								<cfelseif (len(attributes.barcod) eq 8) or (len(attributes.barcod) eq 7)>
									<cf_barcode type="EAN8" barcode="#attributes.barcod#" extra_height="0"><cfif len(errors)>#errors#</cfif>
								<cfelseif (len(attributes.barcod) eq 9)>
									<cf_barcode type="EAN13" barcode="#attributes.barcod#000" extra_height="0"><cfif len(errors)><cfoutput>#errors#</cfoutput></cfif>
								<cfelseif (len(attributes.barcod) eq 10)>
									<cf_barcode type="EAN13" barcode="#attributes.barcod#00" extra_height="0"><cfif len(errors)><cfoutput>#errors#</cfoutput></cfif>
								<cfelseif (len(attributes.barcod) eq 11)>
									<cf_barcode type="EAN13" barcode="#attributes.barcod#0" extra_height="0"><cfif len(errors)><cfoutput>#errors#</cfoutput></cfif>
								</cfif>
								</td>
						</tr>
					</cfoutput>
				</table>
			</td>
		</tr>
	</table>
	<table>
		<tr class="fixed">
			<td style="font-size:9px!important;"><b>© Copyright</b> <cfoutput>#check.COMPANY_NAME#</cfoutput> dışında kullanılamaz, paylaşılamaz.</td>
		</tr>
	</table> 
</cfoutput>	
		
	