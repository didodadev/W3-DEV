<cftransaction>
	<cfquery name="get_defaults" datasource="#dsn3#">
        SELECT * FROM EZGI_DESIGN_DEFAULTS
    </cfquery>
    <cfquery name="get_design_package_row" datasource="#dsn3#">
        SELECT TOP(1) * FROM EZGI_DESIGN_PACKAGE WHERE DESIGN_MAIN_ROW_ID = #attributes.design_main_row_id# ORDER BY PACKAGE_NUMBER desc
    </cfquery>
    <cfquery name="get_design_main_row" datasource="#dsn3#">
        SELECT 	*  FROM EZGI_DESIGN_MAIN_ROW WHERE DESIGN_MAIN_ROW_ID = #attributes.design_main_row_id#
    </cfquery>
    <cfif get_design_package_row.recordcount>
        <cfset package_number = get_design_package_row.PACKAGE_NUMBER + 1>
    <cfelse>
        <cfset package_number = 1>
    </cfif>
    <cfif isdefined('is_private') and package_number gt 0>
    	<cfif len(get_defaults.PROTOTIP_PACKAGE_ID)>
        	<cfquery name="package_defaults" datasource="#dsn3#">
                SELECT        
                    EDPP.PACKAGE_ROW_ID, 
                    S.STOCK_ID, 
                    EDPP.PACKAGE_NUMBER, 
                    EDPP.PACKAGE_NAME
                FROM            
                    EZGI_DESIGN_PACKAGE_ROW AS EDPP LEFT OUTER JOIN
                    STOCKS AS S ON EDPP.PACKAGE_RELATED_ID = S.STOCK_ID
                WHERE        
                    EDPP.DESIGN_MAIN_ROW_ID = #get_defaults.PROTOTIP_PACKAGE_ID#
            </cfquery>
       		<cfif package_defaults.recordcount>
            	<cfquery name="get_related_id" dbtype="query">
                	SELECT * FROM package_defaults WHERE PACKAGE_NUMBER = #package_number#
                </cfquery>
                <cfif not len(get_related_id.STOCK_ID)>
                	<script type="text/javascript">
						alert("<cfoutput>#package_number#</cfoutput> <cf_get_lang_main no='2655.Nolu'> <cf_get_lang_main no='2860.İlişkili Master Paket'> - <cf_get_lang_main no='1074.Kayıt Bulunamadı'>!");
						window.close()
					</script>
					<cfabort>
                </cfif>
            <cfelse>
            	<script type="text/javascript">
					alert("<cfoutput>#package_number#</cfoutput> <cf_get_lang_main no='2655.Nolu'> <cf_get_lang_main no='2860.İlişkili Master Paket'> - <cf_get_lang_main no='2975.Ürün Transferi Eksik'>!");
					window.close()
				</script>
				<cfabort>
        	</cfif>
        <cfelse>
			<script type="text/javascript">
                alert("<cf_get_lang_main no='782.Zorunlu Alan'> : <cf_get_lang_main no='2917.Tasarım Genel Default Tanımları'>!");
                window.close()
            </script>
            <cfabort>
        </cfif>
    </cfif>
    <cfset package_name = "#get_design_main_row.DESIGN_MAIN_NAME# - #package_number# .#getLang('main',2903)#">
    <cfquery name="add_package" datasource="#dsn3#">
        INSERT INTO 
            EZGI_DESIGN_PACKAGE_ROW
            (
            DESIGN_ID, 
            DESIGN_MAIN_ROW_ID, 
            PACKAGE_NUMBER, 
            PACKAGE_NAME, 
            PACKAGE_COLOR_ID, 
            PACKAGE_AMOUNT
            <cfif isdefined('is_private') and package_number gt 0>
            	,PACKAGE_RELATED_ID
            </cfif>
            )
        VALUES
            (
            #get_design_main_row.DESIGN_ID#,
            #get_design_main_row.DESIGN_MAIN_ROW_ID#,
            #package_number#,
            '#package_name#',
            #get_design_main_row.DESIGN_MAIN_COLOR_ID#,
            1
            <cfif isdefined('is_private') and package_number gt 0>
            	,#get_related_id.STOCK_ID#
            </cfif>
            )
    </cfquery>
</cftransaction>
<script type="text/javascript">
 	wrk_opener_reload();
        window.close();
</script>