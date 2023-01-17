<cfquery name="upd_product_info" datasource="#dsn3#">
	UPDATE       
    	PRODUCT
	SET  
    	<cfif Evaluate('attributes.upd_type_#i#') eq 4>              
    		PRODUCT_STATUS =1
       	<cfelseif Evaluate('attributes.upd_type_#i#') eq 3> 
        	PRODUCT_NAME = '#Evaluate('attributes.urun_adi_#i#')#'
     	</cfif>
	WHERE        
    	PRODUCT_ID =
                    (
                        SELECT TOP (1)   
                            PRODUCT_ID
                        FROM            
                            STOCKS
                        WHERE        
                            STOCK_ID = #Evaluate('attributes.STOCK_ID_#i#')#
                    )
</cfquery>
<cfif Evaluate('attributes.upd_type_#i#') eq 3> 
	<cfquery name="upd_product_language_info" datasource="#dsn3#">
        UPDATE       
        	#dsn_alias#.SETUP_LANGUAGE_INFO
        SET                
        	ITEM = '#Evaluate('attributes.urun_adi_#i#')#'
        WHERE        
        	TABLE_NAME = N'PRODUCT' AND 
            LANGUAGE = 'tr' AND 
            COLUMN_NAME = N'PRODUCT_NAME' AND
         	UNIQUE_COLUMN_ID =
            					(
                                    SELECT TOP (1)        
                                        PRODUCT_ID
                                    FROM            
                                        STOCKS
                                    WHERE        
                                        STOCK_ID = #Evaluate('attributes.STOCK_ID_#i#')#
                                )  
	</cfquery>
</cfif>