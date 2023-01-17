<cfinclude template="../../V16/objects/functions/barcode.cfm">
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
		ASSET_P.ASSETP_ID =<cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.iid#">
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
<cfoutput>
<table border="0" style="width:4in;height:2in;">
	<tr>
		<td>
		<table>
	 <tr>
		<td class="txtbold"><cf_get_lang no='228.Alınan Firma'>:&nbsp;</td>
		<td>#get_partner.fullname#</td>
	</tr>
	<tr>
		<td class="txtbold"><cf_get_lang no='859.Demirbaş No'>:&nbsp;</td>
		<td>#get_assetp.inventory_number#</td>
	</tr>
	<tr>
		<td class="txtbold"><cf_get_lang_main no='74.Kategori'>:&nbsp;</td>
		<td>#get_assetp.assetp_cat#</td>
	</tr>
	<tr>
		<td class="txtbold"><cf_get_lang no='215.Varlık Adı'>:&nbsp;</td>
		<td>#get_assetp.assetp#</td>
	</tr>
	<tr>
		<td class="txtbold"><cf_get_lang no='227.Marka'>:&nbsp;</td>
		<td>#get_assetp.brand_name# - #get_assetp.brand_type_name# - #get_assetp.brand_type_cat_name#</td>
	</tr>
	<tr>
		<td class="txtbold"><cf_get_lang_main no='221.Barkod'>:&nbsp;</td>
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
	</table>
	</td>
	</tr>
</table>
</cfoutput>	
	
