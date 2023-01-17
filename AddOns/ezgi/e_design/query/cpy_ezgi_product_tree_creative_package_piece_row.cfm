<cfquery name="cpy_piece" datasource="#dsn3#">
    INSERT INTO 
        EZGI_DESIGN_PIECE_ROWS
        (
            DESIGN_MAIN_ROW_ID, 
            DESIGN_PACKAGE_ROW_ID, 
            DESIGN_ID, 
            MASTER_PRODUCT_ID, 
            PIECE_TYPE, 
            PIECE_NAME, 
            PIECE_CODE, 
            PIECE_STATUS, 
            PIECE_COLOR_ID, 
         	PIECE_RELATED_ID,
            PIECE_DETAIL, 
            PIECE_AMOUNT, 
            MATERIAL_ID, 
            TRIM_TYPE, 
            TRIM_SIZE, 
            IS_FLOW_DIRECTION, 
            BOYU, 
            ENI, 
            KESIM_BOYU, 
            KESIM_ENI, 
            KALINLIK, 
            AGIRLIK, 
            RECORD_EMP, 
            RECORD_IP, 
            RECORD_DATE
        )
    SELECT    
    	DISTINCT    
        #attributes.DESIGN_MAIN_ROW_ID#, 
        <cfif (isdefined('attributes.package_row_id') and len(attributes.package_row_id) and Evaluate('PIECE_TYPE_#cpy_piece_id#') eq 3) or (isdefined('to_package_select') and isdefined('sub_piece') and sub_piece eq 0)>
        	#attributes.package_row_id#,
        <cfelse>
        	#get_max_id.max_id#,
        </cfif> 
        #get_old_design_id.DESIGN_ID#, 
        MASTER_PRODUCT_ID, 
        PIECE_TYPE, 
        REPLACE(PIECE_NAME,'#get_new_design_id.MAIN_ROW_SETUP_NAME#','#get_old_design_id.MAIN_ROW_SETUP_NAME#'), 
        PIECE_CODE, 
        PIECE_STATUS, 
        PIECE_COLOR_ID,
        <cfif isdefined('workcube_select') or Evaluate('PIECE_TYPE_#cpy_piece_id#') eq 4>
        	PIECE_RELATED_ID,
        <cfelse>
        	NULL,
        </cfif>
        PIECE_DETAIL, 
        PIECE_AMOUNT, 
        MATERIAL_ID, 
        TRIM_TYPE, 
        TRIM_SIZE, 
        IS_FLOW_DIRECTION, 
        BOYU, 
        ENI, 
        KESIM_BOYU, 
        KESIM_ENI, 
        KALINLIK, 
        AGIRLIK, 
        #session.ep.userid#,
        '#cgi.remote_addr#',
        #now()#
    FROM            
        EZGI_DESIGN_PIECE AS EDP
    WHERE        
        PIECE_ROW_ID = #cpy_piece_id# AND 
        PIECE_STATUS = 1
</cfquery>
<cfquery name="get_piece_max_id" datasource="#dsn3#">
    SELECT MAX(PIECE_ROW_ID) AS MAX_ID FROM EZGI_DESIGN_PIECE
</cfquery>
<cfset 'new_piece_row_id_#cpy_piece_id#' = get_piece_max_id.max_id>
<cfif Evaluate('PIECE_TYPE_#cpy_piece_id#') eq 3>
    <cfquery name="get_sub_piece_row" datasource="#dsn3#">
        SELECT RELATED_PIECE_ROW_ID, AMOUNT, SIRA_NO, PIECE_ROW_ROW_TYPE FROM EZGI_DESIGN_PIECE_ROW WHERE PIECE_ROW_ID = #cpy_piece_id# AND (NOT (RELATED_PIECE_ROW_ID IS NULL))
    </cfquery>
    <cfloop query="get_sub_piece_row">
        <cfquery name="cpy_piece_row" datasource="#dsn3#">
            INSERT INTO 
                EZGI_DESIGN_PIECE_ROW
                (
                    PIECE_ROW_ID, 
                    RELATED_PIECE_ROW_ID, 
                    AMOUNT, 
                    SIRA_NO, 
                    PIECE_ROW_ROW_TYPE
                )
            VALUES
                (
                    #get_piece_max_id.max_id#,
                    #Evaluate('new_piece_row_id_#get_sub_piece_row.RELATED_PIECE_ROW_ID#')#,
                    #get_sub_piece_row.AMOUNT#,
                    #get_sub_piece_row.SIRA_NO#,
                    #get_sub_piece_row.PIECE_ROW_ROW_TYPE#
                )
        </cfquery>
    </cfloop>
</cfif>
<cfquery name="cpy_piece_row" datasource="#dsn3#">
    INSERT INTO 
        EZGI_DESIGN_PIECE_ROW
        (
            PIECE_ROW_ID, 
            RELATED_PIECE_ROW_ID, 
            STOCK_ID, 
            AMOUNT, 
            SIRA_NO, 
            PIECE_ROW_ROW_TYPE
        )
    SELECT        
        #get_piece_max_id.max_id#, 
        RELATED_PIECE_ROW_ID, 
        STOCK_ID, 
        AMOUNT, 
        SIRA_NO, 
        PIECE_ROW_ROW_TYPE
    FROM
        EZGI_DESIGN_PIECE_ROW
    WHERE        
        PIECE_ROW_ID = #cpy_piece_id# AND
        PIECE_ROW_ROW_TYPE <> 4
</cfquery>
<cfquery name="cpy_piece_rota" datasource="#dsn3#">
	INSERT INTO 
    	EZGI_DESIGN_PIECE_ROTA
     	(
        	PIECE_ROW_ID, 
            OPERATION_TYPE_ID, 
            SIRA, 
            AMOUNT
      	)
	SELECT        
    	#get_piece_max_id.max_id#, 
        OPERATION_TYPE_ID, 
        SIRA, 
        AMOUNT
	FROM            
    	EZGI_DESIGN_PIECE_ROTA
	WHERE        
    	PIECE_ROW_ID = #cpy_piece_id#
</cfquery>