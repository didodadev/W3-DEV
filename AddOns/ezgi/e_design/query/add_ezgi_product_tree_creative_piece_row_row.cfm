<cfquery name="add_piece_row" datasource="#dsn3#">
  	INSERT INTO 
   		EZGI_DESIGN_PIECE_ROW
    	(
            PIECE_ROW_ID, 
            SIRA_NO,
            PIECE_ROW_ROW_TYPE,
            AMOUNT,
            <cfif attributes.row_row_type eq 4>
            	RELATED_PIECE_ROW_ID
            <cfelse>
            	STOCK_ID
          	</cfif>
    	)
	VALUES        
    	(
      		#get_max_id.max_id#,
            #attributes.sira_no#,
            #attributes.row_row_type#,
            #attributes.miktar#,
            #attributes.stock_id#
    	)
</cfquery>
<cfif attributes.row_row_type eq 4> <!---Ürün Montajda Kullanıldıysa Paket Numarası Temizleniyor--->
    <cfquery name="upd_piece_package_id" datasource="#dsn3#">
        UPDATE 
        	EZGI_DESIGN_PIECE_ROWS 
      	SET 
        	DESIGN_PACKAGE_ROW_ID = NULL ,
            PIECE_FLOOR = NULL ,
            PIECE_PACKAGE_ROTA = NULL 
       	WHERE 
        	PIECE_ROW_ID = #attributes.stock_id#
    </cfquery>
</cfif>