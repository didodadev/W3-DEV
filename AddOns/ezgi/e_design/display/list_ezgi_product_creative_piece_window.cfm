
<cfquery name="get_design" datasource="#dsn3#">
	SELECT        
    	EDP.PIECE_ROW_ID, 
        EDP.DESIGN_ID, 
        EDP.DESIGN_MAIN_ROW_ID, 
        EDP.DESIGN_PACKAGE_ROW_ID, 
        EDM.DESIGN_MAIN_NAME, 
        EDR.PACKAGE_NAME,
        EDP.PIECE_NAME
	FROM         
    	EZGI_DESIGN_PIECE_ROWS AS EDP INNER JOIN
   		EZGI_DESIGN_MAIN_ROW AS EDM ON EDP.DESIGN_MAIN_ROW_ID = EDM.DESIGN_MAIN_ROW_ID INNER JOIN
     	EZGI_DESIGN_PACKAGE_ROW AS EDR ON EDP.DESIGN_PACKAGE_ROW_ID = EDR.PACKAGE_ROW_ID INNER JOIN
   		STOCKS AS S ON EDP.PIECE_RELATED_ID = S.STOCK_ID
	WHERE        
    	S.PRODUCT_ID = #attributes.pid#
</cfquery>
<br />
<cf_form_box title="#getLang('main',2992)#">
	<cfform name="add_design_main_row" method="post" action="">
		<table style="width:100%; height:100%">
            <cfif get_design.recordcount>
            	<cfoutput query="get_design">
            	<tr>
                    <td valign="top" style="width:30%"><cfoutput>#getLang('report',898)#</cfoutput> - #currentrow#</td>
                    <td valign="top">
                    	<a href="javascript://" onclick="windowopen('#request.self#?fuseaction=prod.popup_upd_ezgi_product_tree_creative_piece_row&design_piece_row_id=#get_design.PIECE_ROW_ID#&erp_link=1','list');">
                        	#get_design.PIECE_NAME#
                   		</a>
                    </td>
                </tr>
                </cfoutput>
            </cfif>
        </table>
	</cfform>
</cf_form_box>
</script>