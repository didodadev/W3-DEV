<cfsetting showdebugoutput="yes">
<cfquery name="get_design_main_row" datasource="#dsn3#">
	SELECT 
    	*,
        (
        	SELECT        
            	MAIN_ROW_SETUP_CODE
			FROM            
            	EZGI_DESIGN_MAIN_ROW_SETUP
			WHERE        
            	MAIN_ROW_SETUP_ID = EZGI_DESIGN_MAIN_ROW.MAIN_ROW_SETUP_ID
        ) AS CODE
  	FROM 
    	EZGI_DESIGN_MAIN_ROW 
  	WHERE 
    	DESIGN_ID = #attributes.design_id# 
  	ORDER BY 
    	CODE
</cfquery>
<cf_seperator title="#getLang('report',27)#" id="sarf_" is_closed="1">
<div id="sarf_" style="display:none;">
    <cf_form_list id="table2">
        <thead>
            <tr style="height:30px">
                <th width="20px" style="text-align:center;cursor: pointer" onclick="imp_main_row();"></th>
                <th style="text-align:left; width:100%;cursor: pointer" onclick="imp_main_row();"><cf_get_lang_main no='245.Ürün'></th>
                <th width="20px" style="text-align:center;cursor: pointer"><a href="javascript://" onClick="add_main_row();"><img src="/images/plus_list.gif" align="absmiddle" title="<cf_get_lang_main no='2857.Modül Ekle'>" border="0"></a></th>
            </tr>
        </thead>
        <tbody>
			<cfoutput query="get_design_main_row">
                <tr id="frm_row_exit#currentrow#">
                    <td style="text-align:right;cursor: pointer;<cfif isdefined('attributes.design_main_row_id') and attributes.design_main_row_id eq DESIGN_MAIN_ROW_ID>background-color:LightGray</cfif>" <cfif not DESIGN_MAIN_ROW_ID gt 0>onclick="imp_main_row(#DESIGN_MAIN_ROW_ID#);"</cfif>>
                    	<cfif DESIGN_MAIN_RELATED_ID gt 0>
                            <a href="javascript://" onClick="windowopen('#request.self#?fuseaction=objects.popup_detail_product&sid=#DESIGN_MAIN_RELATED_ID#','list');">
                                <img src="/images/c_ok.gif" style="text-align:center" title="<cf_get_lang_main no='40.Stok'> #getLang('objects2',1142)#">
                            </a>
                        <cfelse>
                            #currentrow#
                        </cfif>
                    </td>
                    <td title="#DESIGN_MAIN_NAME#" style="text-align:left;cursor: pointer;<cfif isdefined('attributes.design_main_row_id') and attributes.design_main_row_id eq DESIGN_MAIN_ROW_ID>background-color:LightGray</cfif>" nowrap onclick="imp_main_row(#DESIGN_MAIN_ROW_ID#);">#DESIGN_MAIN_NAME#</td>
                    <td style="text-align:center;cursor: pointer;<cfif isdefined('attributes.design_main_row_id') and attributes.design_main_row_id eq DESIGN_MAIN_ROW_ID>background-color:LightGray</cfif>" onclick="upd_main_row(#DESIGN_MAIN_ROW_ID#);"><img src="/images/update_list.gif" title="#getLang('main',52)#"></td>
                </tr>
            </cfoutput>
       </tbody>
    </cf_form_list>
</div>
<script type="text/javascript">
	function add_main_row()
	{
		windowopen('<cfoutput>#request.self#?fuseaction=prod.popup_add_ezgi_product_tree_creative_main_row&design_id=#attributes.design_id#</cfoutput>','small');
	}
	function upd_main_row(main_row_id)
	{
		windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=prod.popup_upd_ezgi_product_tree_creative_main_row&design_main_row_id='+main_row_id,'small');	
	}
</script>