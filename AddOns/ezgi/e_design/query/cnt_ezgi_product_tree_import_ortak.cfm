﻿<cfif get_design_info.PROCESS_ID eq 1> <!---Tasarım Modül + Paket + Parça Bazında Transfer Edilecekse --->
	<cfif TYPE eq 1> <!---Parça İse--->
     	<cfif PIECE_TYPE eq 1 or PIECE_TYPE eq 2> <!---Parça Tipi Yonga Levha veya Genel Reçete İşlemi İse--->
          	<cfset attributes.design_package_row_id = ''>
         	<cfset attributes.design_piece_row_id = IID>
         	<cfinclude template="../query/get_ezgi_product_tree_creative_material.cfm">
         	<cfinclude template="../query/get_ezgi_product_tree_creative_operation.cfm">
        	<cfquery name="get_product_tree" dbtype="query">
            	SELECT 
               		STOCK_ID AS RELATED_ID,
                 	OPERATION_TYPE_ID,
                  	AMOUNT,
                 	LINE_NUMBER,
                    SPECT_MAIN_ID AS SPECT_RELATED_ID
             	FROM
                 	get_material
            	UNION ALL
              	SELECT
                  	RELATED_ID,
                	OPERATION_TYPE_ID,
                	AMOUNT,
                	LINE_NUMBER,
                    0 AS SPECT_RELATED_ID
          		FROM	
               		get_operation
      		</cfquery>
   		<cfelseif PIECE_TYPE eq 3> <!--- Parça Tipi Montaj Ürünü İse--->
         	<cfquery name="get_material_3" datasource="#dsn3#">
              	SELECT 
                	RELATED_ID, 
                 	OPERATION_TYPE_ID, 
                 	LINE_NUMBER,
              		SUM(AMOUNT) AMOUNT,
                    SPECT_RELATED_ID
             	FROM
                	(
                   	SELECT        
                     	EDP1.PIECE_RELATED_ID as RELATED_ID, 
                       	0 AS OPERATION_TYPE_ID, 
                       	EDPR.AMOUNT, 
                     	0 AS LINE_NUMBER,
                        EDP1.PIECE_SPECT_RELATED_ID AS SPECT_RELATED_ID
               		FROM            
                     	EZGI_DESIGN_PIECE_ROWS AS EDP INNER JOIN
                  		EZGI_DESIGN_PIECE_ROW AS EDPR ON EDP.PIECE_ROW_ID = EDPR.PIECE_ROW_ID INNER JOIN
                      	EZGI_DESIGN_PIECE_ROWS AS EDP1 ON EDPR.RELATED_PIECE_ROW_ID = EDP1.PIECE_ROW_ID
                 	WHERE        
                    	EDP.PIECE_TYPE = 3 AND 
                      	EDP.PIECE_ROW_ID = #IID# AND 
                   		EDPR.PIECE_ROW_ROW_TYPE = 4
               		UNION ALL
                  	SELECT        
                     	EDPR.STOCK_ID as RELATED_ID, 
                    	0 AS OPERATION_TYPE_ID, 
                      	EDPR.AMOUNT, 
                     	0 AS LINE_NUMBER,
                        EDP.PIECE_SPECT_RELATED_ID AS SPECT_RELATED_ID
                  	FROM            
                    	EZGI_DESIGN_PIECE_ROWS AS EDP INNER JOIN
                      	EZGI_DESIGN_PIECE_ROW AS EDPR ON EDP.PIECE_ROW_ID = EDPR.PIECE_ROW_ID
                  	WHERE        
                      	EDP.PIECE_TYPE = 3 AND 
                     	EDPR.PIECE_ROW_ROW_TYPE <> 4 AND 
                      	EDP.PIECE_ROW_ID = #IID#
               		) AS TBL
              	GROUP BY
                	RELATED_ID, 
                 	OPERATION_TYPE_ID, 
                	LINE_NUMBER,
                    SPECT_RELATED_ID
      		</cfquery>
          	<cfset attributes.design_piece_row_id = IID>
          	<cfinclude template="../query/get_ezgi_product_tree_creative_operation.cfm">
         	<cfquery name="get_product_tree" dbtype="query">
           		SELECT 
               		RELATED_ID,
                	OPERATION_TYPE_ID,
               		AMOUNT,
                 	LINE_NUMBER,
                    SPECT_RELATED_ID
             	FROM
                 	get_material_3
              	UNION ALL
              	SELECT
                 	RELATED_ID,
              		OPERATION_TYPE_ID,
                  	AMOUNT,
                  	LINE_NUMBER,
                    0 AS SPECT_RELATED_ID
             	FROM	
                	get_operation
      		</cfquery>
       	</cfif>
 	<cfelseif TYPE eq 2> <!---Paket İse--->
    	<cfquery name="get_package_all_tree" datasource="#dsn3#">
           	SELECT        
           		EDPA.PACKAGE_ROW_ID, 
              	EDPI.PIECE_RELATED_ID AS RELATED_ID, 
              	EDPI.PIECE_AMOUNT, 
                ISNULL(EDPI.PIECE_SPECT_RELATED_ID,0) AS SPECT_RELATED_ID,
            	EDPA.PACKAGE_NUMBER, 
             	EDPA.PACKAGE_NAME, 
            	EDPA.PACKAGE_BOYU, 
            	EDPA.PACKAGE_ENI, 
            	EDPA.PACKAGE_KALINLIK, 
            	EDPA.PACKAGE_WEIGHT, 
            	EDPA.PACKAGE_AMOUNT, 
            	EDPA.PACKAGE_DETAIL, 
            	EDPA.PACKAGE_RELATED_ID
          	FROM            
             	EZGI_DESIGN_PACKAGE AS EDPA LEFT OUTER JOIN
             	EZGI_DESIGN_PIECE AS EDPI ON EDPA.PACKAGE_ROW_ID = EDPI.DESIGN_PACKAGE_ROW_ID
          	WHERE        
            	EDPA.PACKAGE_ROW_ID = #IID#
     	</cfquery>
      	<cfset attributes.design_package_row_id = IID>
		<cfset attributes.design_piece_row_id = ''>
   		<cfinclude template="../query/get_ezgi_product_tree_creative_material.cfm">
        <cfquery name="get_product_tree" dbtype="query">
         	SELECT
           		STOCK_ID AS RELATED_ID,
              	AMOUNT / #get_package_all_tree.PACKAGE_AMOUNT# AS AMOUNT,
           		0 AS OPERATION_TYPE_ID, 
             	0 AS LINE_NUMBER,
                SPECT_MAIN_ID AS SPECT_RELATED_ID
         	FROM
              	get_ezgi_paket_standart_eklenti<!---../query/get_ezgi_product_tree_creative_material.cfm Satırından Geliyor--->
          	UNION ALL
          	SELECT        	
            	RELATED_ID, 
             	PIECE_AMOUNT / #get_package_all_tree.PACKAGE_AMOUNT# as AMOUNT, 
              	0 AS OPERATION_TYPE_ID, 
              	0 AS LINE_NUMBER,
                SPECT_RELATED_ID
          	FROM
             	get_package_all_tree
          	WHERE        
             	RELATED_ID IS NOT NULL AND 
             	PACKAGE_ROW_ID = #IID#
       	</cfquery>
       	<cfset newRow = QueryAddRow(get_product_tree)>
		<cfset temp = QuerySetCell(get_product_tree, "RELATED_ID", "0")> 
      	<cfset temp = QuerySetCell(get_product_tree, "AMOUNT", "1")>
      	<cfset temp = QuerySetCell(get_product_tree, "OPERATION_TYPE_ID", get_defaults.DEFAULT_PACKAGE_OPERATION_TYPE_ID)>
       	<cfset temp = QuerySetCell(get_product_tree, "LINE_NUMBER", "0")>
        <cfset temp = QuerySetCell(get_product_tree, "SPECT_RELATED_ID", "0")>
 	<cfelseif TYPE eq 3> <!---Modül İse--->
       	<cfquery name="get_main_all" datasource="#dsn3#">
          	SELECT        
             	EDM.DESIGN_MAIN_ROW_ID, 
           		EDM.DESIGN_MAIN_NAME, 
              	EDP.PACKAGE_RELATED_ID, 
             	EDP.PACKAGE_ROW_ID, 
             	EDP.PACKAGE_NUMBER, 
             	EDP.PACKAGE_DETAIL,
             	EDP.PACKAGE_AMOUNT,
                EDP.PACKAGE_SPECT_RELATED_ID
         	FROM            
            	EZGI_DESIGN_MAIN_ROW AS EDM LEFT OUTER JOIN
              	EZGI_DESIGN_PACKAGE AS EDP ON EDM.DESIGN_MAIN_ROW_ID = EDP.DESIGN_MAIN_ROW_ID
         	WHERE        
             	EDM.DESIGN_MAIN_ROW_ID = #IID#
    	</cfquery>
     	<cfquery name="get_product_tree" dbtype="query">
        	SELECT        
         		PACKAGE_RELATED_ID AS RELATED_ID, 
         		PACKAGE_AMOUNT AS AMOUNT, 
              	0 AS OPERATION_TYPE_ID, 
             	PACKAGE_NUMBER AS LINE_NUMBER,
                PACKAGE_SPECT_RELATED_ID AS SPECT_RELATED_ID
           	FROM
             	get_main_all
       		WHERE        
            	PACKAGE_ROW_ID IS NOT NULL AND 
             	DESIGN_MAIN_ROW_ID = #IID#
    	</cfquery>
     	<cfset newRow = QueryAddRow(get_product_tree)>
		<cfset temp = QuerySetCell(get_product_tree, "RELATED_ID", "0")> 
     	<cfset temp = QuerySetCell(get_product_tree, "AMOUNT", "1")>
     	<cfset temp = QuerySetCell(get_product_tree, "OPERATION_TYPE_ID", get_defaults.DEFAULT_MAIN_OPERATION_TYPE_ID)>
      	<cfset temp = QuerySetCell(get_product_tree, "LINE_NUMBER", "0")>
        <cfset temp = QuerySetCell(get_product_tree, "SPECT_RELATED_ID", "0")>
  	</cfif>
</cfif>
<cfif get_design_info.PROCESS_ID eq 2> <!---Tasarım Modül + Paket Bazında Transfer Edilecekse --->
  	<cfif TYPE eq 2> <!---Paket İse--->
		<cfset attributes.design_package_row_id = IID>
		<cfset attributes.design_piece_row_id = ''>
      	<cfinclude template="../query/get_ezgi_product_tree_creative_material.cfm">
        <cfquery name="get_package_amount" datasource="#dsn3#">
        	SELECT PACKAGE_AMOUNT FROM EZGI_DESIGN_PACKAGE WHERE PACKAGE_ROW_ID = #attributes.design_package_row_id#
        </cfquery>
     	<cfquery name="get_product_tree" dbtype="query">
         	SELECT 
           		STOCK_ID AS RELATED_ID,
             	OPERATION_TYPE_ID,
             	AMOUNT / #get_package_amount.PACKAGE_AMOUNT# as AMOUNT,
         		LINE_NUMBER,
                SPECT_MAIN_ID AS SPECT_RELATED_ID
        	FROM
          		get_material <!---../query/get_ezgi_product_tree_creative_material.cfm Satırından Geliyor--->
     	</cfquery>
     	<cfset newRow = QueryAddRow(get_product_tree)>
		<cfset temp = QuerySetCell(get_product_tree, "RELATED_ID", "0")> 
       	<cfset temp = QuerySetCell(get_product_tree, "AMOUNT", "1")>
     	<cfset temp = QuerySetCell(get_product_tree, "OPERATION_TYPE_ID", get_defaults.DEFAULT_PACKAGE_OPERATION_TYPE_ID)>
      	<cfset temp = QuerySetCell(get_product_tree, "LINE_NUMBER", "0")>
        <cfset temp = QuerySetCell(get_product_tree, "SPECT_RELATED_ID", "0")>
 	<cfelseif TYPE eq 3> <!---Modül İse--->
    	<cfquery name="get_main_all" datasource="#dsn3#">
          	SELECT        
           		EDM.DESIGN_MAIN_ROW_ID, 
             	EDM.DESIGN_MAIN_NAME, 
            	EDP.PACKAGE_RELATED_ID, 
            	EDP.PACKAGE_ROW_ID, 
             	EDP.PACKAGE_NUMBER, 
            	EDP.PACKAGE_DETAIL,
            	EDP.PACKAGE_AMOUNT,
                EDP.PACKAGE_SPECT_RELATED_ID AS SPECT_RELATED_ID
       		FROM            
            	EZGI_DESIGN_MAIN_ROW AS EDM LEFT OUTER JOIN
                EZGI_DESIGN_PACKAGE AS EDP ON EDM.DESIGN_MAIN_ROW_ID = EDP.DESIGN_MAIN_ROW_ID
         	WHERE        
            	EDM.DESIGN_MAIN_ROW_ID = #IID#
     	</cfquery>
      	<cfquery name="get_product_tree" dbtype="query">
        	SELECT        
            	PACKAGE_RELATED_ID AS RELATED_ID, 
               	PACKAGE_AMOUNT AS AMOUNT, 
               	0 AS OPERATION_TYPE_ID, 
              	PACKAGE_NUMBER AS LINE_NUMBER,
                SPECT_RELATED_ID
         	FROM
             	get_main_all
         	WHERE        
           		PACKAGE_ROW_ID IS NOT NULL AND 
             	DESIGN_MAIN_ROW_ID = #IID#
   		</cfquery>
       	<cfset newRow = QueryAddRow(get_product_tree)>
		<cfset temp = QuerySetCell(get_product_tree, "RELATED_ID", "0")> 
      	<cfset temp = QuerySetCell(get_product_tree, "AMOUNT", "1")>
     	<cfset temp = QuerySetCell(get_product_tree, "OPERATION_TYPE_ID", get_defaults.DEFAULT_MAIN_OPERATION_TYPE_ID)>
     	<cfset temp = QuerySetCell(get_product_tree, "LINE_NUMBER", "0")>
        <cfset temp = QuerySetCell(get_product_tree, "SPECT_RELATED_ID", "0")>
 	</cfif>
</cfif>
<cfif get_design_info.PROCESS_ID eq 3> <!---Tasarım Modül Bazında Transfer Edilecekse --->
	<cfif TYPE eq 3> <!---Modül İse--->
		<cfinclude template="../query/get_ezgi_product_tree_creative_material.cfm">
    	<cfquery name="get_product_tree" dbtype="query">
         	SELECT 
            	STOCK_ID AS RELATED_ID,
              	OPERATION_TYPE_ID,
             	AMOUNT,
          		LINE_NUMBER,
                SPECT_MAIN_ID AS SPECT_RELATED_ID
            FROM
            	get_material
    	</cfquery>
        <cfset newRow = QueryAddRow(get_product_tree)>
      	<cfset temp = QuerySetCell(get_product_tree, "RELATED_ID", "0")> 
      	<cfset temp = QuerySetCell(get_product_tree, "AMOUNT", "1")>
       	<cfset temp = QuerySetCell(get_product_tree, "OPERATION_TYPE_ID", get_defaults.DEFAULT_MAIN_OPERATION_TYPE_ID)>
      	<cfset temp = QuerySetCell(get_product_tree, "LINE_NUMBER", "0")>
        <cfset temp = QuerySetCell(get_product_tree, "SPECT_RELATED_ID", "0")>
	</cfif>
</cfif>