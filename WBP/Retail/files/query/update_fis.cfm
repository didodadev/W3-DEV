<cfloop from="1" to="#attributes.payment_count#" index="ccc">
	<cfset tutar_ = filterNum(evaluate('attributes.payment_odeme_tutar_#ccc#'))>
    <cfif evaluate('attributes.payment_odeme_tipi_#ccc#') eq 1>
    	<cfset tutar_ = -1 * tutar_>
    </cfif>
    <cfquery name="upd_" datasource="#dsn_dev#">
    	UPDATE
        	GENIUS_ACTIONS_PAYMENTS
        SET
        	ODEME_TUTAR = #tutar_#
        WHERE
        	ACTION_PAYMENT_ID = #evaluate('attributes.payment_row_id_#ccc#')#
    </cfquery>
</cfloop>


<cfset kdv0 = 0>
<cfset kdv1 = 0>
<cfset kdv8 = 0>
<cfset kdv18 = 0>
<cfset fis_toplam = 0>
<cfset fis_toplam_kdv = 0>


<cfloop from="1" to="#attributes.active_row_count#" index="ccc">
	<cfset satir_id_ = evaluate('attributes.action_row_id_#ccc#')>
    <cfset miktar_ = evaluate('attributes.action_row_miktar_#ccc#')>
    <cfset birim_fiyat_ = evaluate('attributes.action_row_birim_fiyat_#ccc#')>
    <cfset toplam_satir_ = evaluate('attributes.action_row_satir_toplam_#ccc#')>
    <cfset kdv_ = evaluate('attributes.action_row_kdv_#ccc#')>
    <cfset satir_kdv_ = filternum(toplam_satir_) - (filternum(toplam_satir_) / ((100 + kdv_) / 100))>
    
    <cfif kdv_ eq 0><cfset kdv0 = kdv0 + wrk_round(satir_kdv_)></cfif>
    <cfif kdv_ eq 1><cfset kdv1 = kdv1 + wrk_round(satir_kdv_)></cfif>
    <cfif kdv_ eq 8><cfset kdv8 = kdv8 + wrk_round(satir_kdv_)></cfif>
    <cfif kdv_ eq 18><cfset kdv18 = kdv18 + wrk_round(satir_kdv_)></cfif>
    
    <cfset fis_toplam = fis_toplam + filterNum(toplam_satir_)>
	<cfset fis_toplam_kdv = fis_toplam_kdv + wrk_round(satir_kdv_)>
    
    <cfquery name="upd_" datasource="#dsn_dev#">
    	UPDATE
        	GENIUS_ACTIONS_ROWS
        SET
        	MIKTAR = #filternum(miktar_,4)#,
            BIRIM_FIYAT = #filternum(birim_fiyat_)#,
            SATIR_TOPLAM = #filternum(toplam_satir_)#,
            SATIR_KDV_TUTAR = #satir_kdv_#
        WHERE
        	ACTION_ROW_ID = #satir_id_#
    </cfquery>
</cfloop>

<cfquery name="get_rows_passive" datasource="#dsn_dev#">
	SELECT
    	*,
        S.PROPERTY
    FROM
    	GENIUS_ACTIONS_ROWS
        	LEFT JOIN #dsn3_alias#.STOCKS S ON (S.STOCK_ID = GENIUS_ACTIONS_ROWS.STOCK_ID)
    WHERE
    	ACTION_ID = #attributes.action_id# AND
        SATIR_IPTALMI = 1
</cfquery>
<cfif get_rows_passive.recordcount>
	<cfoutput query="get_rows_passive">
        <cfset birim_fiyat_ = birim_fiyat>
        <cfset toplam_satir_ = satir_toplam>
        <cfset kdv_ = satir_kdv>
        <cfset satir_kdv_ = satir_kdv_tutar>
        
        <cfif kdv_ eq 0><cfset kdv0 = kdv0 - wrk_round(satir_kdv_)></cfif>
        <cfif kdv_ eq 1><cfset kdv1 = kdv1 - wrk_round(satir_kdv_)></cfif>
        <cfif kdv_ eq 8><cfset kdv8 = kdv8 - wrk_round(satir_kdv_)></cfif>
        <cfif kdv_ eq 18><cfset kdv18 = kdv18 - wrk_round(satir_kdv_)></cfif>
        
        <cfset fis_toplam = fis_toplam - toplam_satir_>
        <cfset fis_toplam_kdv = fis_toplam_kdv - wrk_round(satir_kdv_)>
	</cfoutput>
</cfif>

<cfquery name="upd_" datasource="#dsn_dev#">
	UPDATE
    	GENIUS_ACTIONS
    SET
    	FIS_TOPLAM = #fis_toplam#,
        FIS_TOPLAM_KDV = #fis_toplam_kdv#,
        KDV0 = #kdv0#,
        KDV1 = #kdv1#,
        KDV8 = #kdv8#,
        KDV18 = #kdv18#
    WHERE
    	ACTION_ID = #attributes.ACTION_ID#
</cfquery>
<script>
	window.opener.location.reload();
	window.close();
</script>