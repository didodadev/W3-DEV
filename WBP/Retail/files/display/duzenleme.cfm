<cfloop list="#attributes.stock_list#" index="stock_id_">
	<cfset deger_ = evaluate("attributes.new_code_#stock_id_#")>
	<cfif len(deger_)>
    	<cfquery name="get_urun_id" datasource="#dsn1#">
        	SELECT PRODUCT_ID FROM PRODUCT WHERE PRODUCT_CODE_2 = '#deger_#'
        </cfquery>
        <cfif get_urun_id.recordcount>
        	<cfquery name="upd_" datasource="#dsn1#">
            	UPDATE
                	STOCKS
               	SET
                	NEW_PRODUCT_ID = #get_urun_id.PRODUCT_ID#
                WHERE
                	STOCK_ID = #stock_id_#
            </cfquery>
        </cfif>
    </cfif>
</cfloop>

iŞLEM tamamlandı