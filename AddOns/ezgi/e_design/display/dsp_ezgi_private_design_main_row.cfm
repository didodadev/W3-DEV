<cfsetting showdebugoutput="yes">
<cfquery name="get_design_main_row" datasource="#dsn3#">
	SELECT
    	EDMR.*,
    	O.OFFER_NUMBER, 
        O.OFFER_ID, 
        OFR.PRODUCT_NAME2
	FROM            
    	OFFER_ROW AS OFR INNER JOIN
   		OFFER AS O ON OFR.OFFER_ID = O.OFFER_ID RIGHT OUTER JOIN
   		EZGI_DESIGN_MAIN_ROW AS EDMR ON OFR.WRK_ROW_ID = EDMR.WRK_ROW_RELATION_ID
	WHERE        
    	EDMR.DESIGN_ID = #attributes.design_id#
	ORDER BY 
    	OFR.OFFER_ROW_ID
</cfquery>
<cf_seperator title="#getLang('objects',720)#" id="sarf_" is_closed="1">
<div id="sarf_" style="display:none;">
    <cf_form_list id="table2">
        <thead>
            <tr style="height:30px">
                <th style="width:20px;text-align:center;cursor: pointer" onclick="imp_main_row();"> <img src="/images/workdevxml.gif" style="text-align:center" title="#getLang('main',3021)#"></th>
                <th style="text-align:left; width:100%;cursor: pointer" onclick="imp_main_row();"><cf_get_lang_main no='245.Ürün'></th>
                <th width="20px" style="text-align:center;cursor: pointer"><a href="javascript://" onClick="add_main_row();"><img src="/images/plus_list.gif" align="absmiddle" title="#getLang('main',2857)#" border="0"></a></th>
            </tr>
        </thead>
        <tbody>
			<cfoutput query="get_design_main_row">
                <tr id="frm_row_exit#currentrow#">
                    <td style="text-align:right;cursor: pointer;<cfif isdefined('attributes.design_main_row_id') and attributes.design_main_row_id eq DESIGN_MAIN_ROW_ID>background-color:LightGray</cfif>" <cfif not DESIGN_MAIN_ROW_ID gt 0>onclick="imp_main_row(#DESIGN_MAIN_ROW_ID#);"</cfif>>
                    	<cfif not len(OFFER_ID)>
                        	<img src="/images/ship_delivery.gif" style="text-align:center" title="#getLang('main',497)#">
                        <cfelse>
							<cfif MAIN_SPECT_RELATED_ID gt 0>
                                <a href="javascript://" onClick="windowopen('#request.self#?fuseaction=objects.popup_detail_product&sid=#DESIGN_MAIN_RELATED_ID#','list');">
                                    <img src="/images/c_ok.gif" style="text-align:center" title="#getLang('main',3021)#">
                                </a>
                            <cfelse>
                                #currentrow#
                            </cfif>
                        </cfif>
                    </td>
                    <td title="#OFFER_NUMBER# - #PRODUCT_NAME2#" style="text-align:left;cursor: pointer;<cfif isdefined('attributes.design_main_row_id') and attributes.design_main_row_id eq DESIGN_MAIN_ROW_ID>background-color:LightGray</cfif>" nowrap onclick="imp_main_row(#DESIGN_MAIN_ROW_ID#);">#DESIGN_MAIN_NAME#</td>
                    <td style="text-align:center;cursor: pointer;<cfif isdefined('attributes.design_main_row_id') and attributes.design_main_row_id eq DESIGN_MAIN_ROW_ID>background-color:LightGray</cfif>" onclick="upd_main_row(#DESIGN_MAIN_ROW_ID#);"><img src="/images/update_list.gif" title="#getLang('main',52)#"></td>
                </tr>
            </cfoutput>
       </tbody>
    </cf_form_list>
</div>
<script type="text/javascript">
	function add_main_row()
	{
		windowopen('<cfoutput>#request.self#?fuseaction=prod.popup_add_ezgi_private_product_tree_creative_main_row&design_id=#attributes.design_id#</cfoutput>','longpage');
	}
	function upd_main_row(main_row_id)
	{
		windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=prod.popup_upd_ezgi_product_tree_creative_main_row&design_main_row_id='+main_row_id,'small');	
	}
</script>