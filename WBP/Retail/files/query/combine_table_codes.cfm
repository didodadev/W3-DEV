<cfif not isdefined("attributes.table_ids") or listlen(attributes.table_ids) lt 2>
	<script>
		alert('Birleştirme İçin En Az İki Tablo Seçmelisiniz!');
		history.back();
	</script>
    <cfabort>
</cfif>

<cfquery name="get_product_control" datasource="#dsn_dev#">
	SELECT
    	P.PRODUCT_ID,
        P.PRODUCT_NAME
    FROM
    	#dsn1_alias#.PRODUCT P
    WHERE
    	(
    	<cfloop from="1" to="#listlen(attributes.table_ids)#" index="ccc">
            P.PRODUCT_ID IN (SELECT TB#ccc#.PRODUCT_ID FROM SEARCH_TABLES_PRODUCTS TB#ccc# WHERE TB#ccc#.TABLE_ID = #listgetat(attributes.table_ids,ccc)#)
            <cfif ccc neq listlen(attributes.table_ids)>
            	AND
            </cfif>
        </cfloop>
        )
</cfquery>

<cfif get_product_control.recordcount>
	<script>
		alert('Aşağıdaki Ürünler Birleştirmek İstenen Tablolarda Ortaktır. Ortak Ürünlü Tablolar Birleştirilemez!\n\nÜrün Listesi:\n\n<cfoutput query="get_product_control">#PRODUCT_NAME#\n</cfoutput>');
		history.back();
	</script>
    <cfabort>
</cfif>

<cfquery name="get_tables" datasource="#dsn_dev#">
	SELECT TABLE_CODE FROM SEARCH_TABLES WHERE TABLE_ID IN (#attributes.table_ids#)
</cfquery>

<cfset ilk_tablo_ = listfirst(attributes.table_ids)>
<cfquery name="get_table_info" datasource="#dsn_dev#">
	SELECT * FROM SEARCH_TABLES WHERE TABLE_ID = #ilk_tablo_#
</cfquery>
<cfset ilk_tablo_code_ = get_table_info.table_code>

<cfloop from="1" to="#listlen(attributes.table_ids)#" index="ccc">
	<cfquery name="upd_" datasource="#dsn_dev#">
    	UPDATE
        	SEARCH_TABLES_ROWS
        SET
        	TABLE_ID = #ilk_tablo_#,
            TABLE_CODE = '#ilk_tablo_code_#'
        WHERE
        	TABLE_ID = #listgetat(attributes.table_ids,ccc)#
    </cfquery>
    <cfquery name="upd_" datasource="#dsn_dev#">
    	UPDATE
        	SEARCH_TABLES_PRODUCTS
        SET
        	TABLE_ID = #ilk_tablo_#,
            TABLE_CODE = '#ilk_tablo_code_#'
        WHERE
        	TABLE_ID = #listgetat(attributes.table_ids,ccc)#
    </cfquery>
    
    <cfquery name="add_" datasource="#dsn_dev#">
    	INSERT INTO
        	SEARCH_TABLES_COMBINES
            (
            TABLE_ID,
            NEW_TABLE_ID,
            RECORD_EMP,
            RECORD_DATE,
            RECORD_IP
            )
            VALUES
            (
            #listgetat(attributes.table_ids,ccc)#,
            #ilk_tablo_#,
            #session.ep.userid#,
            #now()#,
            '#cgi.remote_addr#'
            )
    </cfquery>
</cfloop>

<script>
	alert('Tablo Birleştirme İşi Tamamlandı!');
	window.location.href = '<cfoutput>#request.self#?fuseaction=retail.list_manage_products&table_code=#valuelist(get_tables.table_code)#</cfoutput>';
</script>
<cfabort>