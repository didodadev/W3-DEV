
<cfif len(attributes.SELECT_PRODUCTION)>
	<cfquery name="ADD_MAIN_INFO" datasource="#DSN3#">
    	INSERT INTO 
        	EZGI_DESIGN_MAIN_ROW
      	(
        	DESIGN_ID,
        	OFFER_ROW_ID,
            WRK_ROW_RELATION_ID,  
            DESIGN_MAIN_NAME, 
            DESIGN_MAIN_COLOR_ID, 
            MAIN_ROW_SETUP_ID, 
            DESIGN_MAIN_RELATED_ID, 
            OLCU1, 
            OLCU2,  
            DESIGN_MAIN_CODE,
            KARMA_KOLI_MIKTAR,
            MAIN_PROTOTIP_ID
       	)
    	SELECT  
        	#attributes.DESIGN_ID#,      
        	ORR.OFFER_ROW_ID, 
            ORR.WRK_ROW_ID, 
            E.DESIGN_MAIN_NAME, 
            E.DESIGN_MAIN_COLOR_ID, 
            E.MAIN_ROW_SETUP_ID, 
            E.DESIGN_MAIN_RELATED_ID, 
            E.OLCU1, 
            E.OLCU2, 
            E.DESIGN_MAIN_CODE, 
         	ORR.QUANTITY,
            E.DESIGN_MAIN_ROW_ID
		FROM            
        	OFFER_ROW AS ORR INNER JOIN
        	EZGI_DESIGN_MAIN_ROW AS E ON ORR.STOCK_ID = E.DESIGN_MAIN_RELATED_ID
		WHERE        
        	ORR.OFFER_ROW_ID IN (#attributes.SELECT_PRODUCTION#) AND 
            E.OFFER_ROW_ID IS NULL
    </cfquery>
    <cfquery name="get_main_info" datasource="#dsn3#">
    	SELECT DESIGN_MAIN_ROW_ID, OFFER_ROW_ID, MAIN_PROTOTIP_ID FROM EZGI_DESIGN_MAIN_ROW WHERE OFFER_ROW_ID IN (#attributes.SELECT_PRODUCTION#)
    </cfquery>
    <cfset attributes.package_piece_select = 1>
    <cfset attributes.main = 1>
    <cfset attributes.collect_add = 1>
    <cfloop query="get_main_info">
    	<cfset attributes.DESIGN_MAIN_ROW_ID = get_main_info.DESIGN_MAIN_ROW_ID>
    	<cfset attributes.sid = get_main_info.MAIN_PROTOTIP_ID>
        <cfquery name="get_package_content" datasource="#dsn3#">
            SELECT
                DISTINCT
                EDP.PIECE_ROW_ID,        
                EDP.PIECE_TYPE,
                EDP.PACKAGE_IS_MASTER,	
        		EDP.PACKAGE_PARTNER_ID
            FROM            
                EZGI_DESIGN_PIECE AS EDP
            WHERE 
           		EDP.DESIGN_MAIN_ROW_ID = #attributes.sid# AND
              	EDP.PIECE_TYPE IN (1,2,3,4) AND
                EDP.PIECE_STATUS = 1
            ORDER BY
                EDP.PIECE_TYPE
        </cfquery>
        <cfset attributes.PIECE_ROW_ID_LIST = ValueList(get_package_content.PIECE_ROW_ID)>
        <cfloop query="get_package_content">
        	<cfset 'PIECE_TYPE_#PIECE_ROW_ID#' = PIECE_TYPE>
            <cfset 'attributes.a_#PIECE_ROW_ID#' = 1>
			<cfif PIECE_TYPE eq 3>
                <cfquery name="get_sub_pieces" datasource="#dsn3#">
                    SELECT RELATED_PIECE_ROW_ID FROM EZGI_DESIGN_PIECE_ROW WHERE PIECE_ROW_ID = #PIECE_ROW_ID# AND RELATED_PIECE_ROW_ID IS NOT NULL
                </cfquery>
                <cfset 'PIECE_SUB_ID_#PIECE_ROW_ID#' = ValueList(get_sub_pieces.RELATED_PIECE_ROW_ID)>
            <cfelse>
                <cfset 'PIECE_SUB_ID_#PIECE_ROW_ID#' = 0>
            </cfif>
            <cfif PACKAGE_IS_MASTER gt 0>
                <cfset 'PIECE_ORTAK_#PIECE_ROW_ID#' = 'M'>                                 
          	<cfelse>
				<cfif PACKAGE_PARTNER_ID gt 0>
                 	 <cfset 'PIECE_ORTAK_#PIECE_ROW_ID#' = 'O'> 
             	<cfelse>
                      <cfset 'PIECE_ORTAK_#PIECE_ROW_ID#' = ''>                                   	 
            	</cfif>
        	</cfif>
        </cfloop>
        <cfinclude template="cpy_ezgi_product_tree_creative_package_row.cfm">
    </cfloop>
    <script type="text/javascript">
   		alert('<cf_get_lang_main no='3067.Özel Tasarıma Transfer Başarıyla Tamamlandı!'>')
      	wrk_opener_reload();
     	window.close();
  	</script>
</cfif>