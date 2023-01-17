<cfsetting showdebugoutput="yes">
<cfquery name="get_package_row" datasource="#dsn3#">
	SELECT 
    	* ,
        (SELECT DESIGN_MAIN_NAME FROM EZGI_DESIGN_MAIN_ROW WHERE DESIGN_MAIN_ROW_ID = EZGI_DESIGN_PACKAGE.DESIGN_MAIN_ROW_ID) as DESIGN_MAIN_NAME,
	(
		SELECT        
			EDS.MAIN_ROW_SETUP_CODE
		FROM           
			EZGI_DESIGN_MAIN_ROW_SETUP AS EDS INNER JOIN
                    	EZGI_DESIGN_MAIN_ROW AS EDM ON EDS.MAIN_ROW_SETUP_ID = EDM.MAIN_ROW_SETUP_ID
		WHERE        
			EDM.DESIGN_MAIN_ROW_ID = EZGI_DESIGN_PACKAGE.DESIGN_MAIN_ROW_ID
	) AS CODE
  	FROM 
    	EZGI_DESIGN_PACKAGE
  	WHERE 
    	<cfif isdefined('attributes.design_main_row_id')>
    		DESIGN_MAIN_ROW_ID = #attributes.design_main_row_id#
       	<cfelse>
        	DESIGN_ID = #attributes.design_id#
        </cfif>
 	ORDER BY
    	CODE,
    	PACKAGE_NUMBER
</cfquery>
<cf_seperator title="#getLang('main',2863)#" id="package_" is_closed="1">
<div id="package_" style="display:none;">
    <cf_form_list id="table3">
    	<cfform name="dsp_package_row" action="">
        <thead>
            <tr style="height:30px">
                <th style="width:20px;text-align:center"></th>
              	<th style="width:100%;cursor:pointer" onclick="imp_package_row();"><cf_get_lang_main no='245.Ürün'></th>
              	<th style="width:40px;text-align:center;">
                 	<cfoutput>
                       	<cfif isdefined('attributes.design_main_row_id')>
                          	<a style="cursor:pointer" onclick="cpy_package_row(#attributes.design_main_row_id#);"><img src="images/copy_list.gif"  title="<cf_get_lang_main no='170.Ekle'> #getLang('main',2862)#" border="0"></a>

                        	<a style="cursor:pointer" onclick="add_package_row(#attributes.design_main_row_id#);"><img src="images/plus_list.gif"  title="<cf_get_lang_main no='170.Ekle'> #getLang('stock',371)#" border="0"></a>
                     	</cfif>
                  	</cfoutput>
               	</th>
            </tr>
        </thead>
        </cfform>
        <tbody>
        <cfoutput query="get_package_row">
            <tr id="frm_row_exit#currentrow#">
             	<td title="<cfif PACKAGE_IS_MASTER gt 0>Master Ortak Paket<cfelseif PACKAGE_PARTNER_ID gt 0>Ortak Paket</cfif>" style="text-align:center;cursor: pointer;<cfif isdefined('attributes.design_package_row_id') and attributes.design_package_row_id eq PACKAGE_ROW_ID>background-color:LightGray<cfelse><cfif PACKAGE_IS_MASTER gt 0>background-color:Green<cfelseif PACKAGE_PARTNER_ID gt 0>background-color:MistyRose</cfif></cfif>">
                	<cfif PACKAGE_RELATED_ID gt 0>
                        <a href="javascript://" onClick="windowopen('#request.self#?fuseaction=objects.popup_detail_product&sid=#PACKAGE_RELATED_ID#','list');">
                            <img src="/images/c_ok.gif" style="text-align:center" title="#getLang('main',3021)#">
                        </a>
                    <cfelse>
                		<img src="/images/stopped.gif" id="attach_2_#PACKAGE_ROW_ID#">
                    </cfif>
                </td>
                <td title="#PACKAGE_NAME#" style="text-align:left;cursor: pointer;<cfif isdefined('attributes.design_package_row_id') and attributes.design_package_row_id eq PACKAGE_ROW_ID>background-color:LightGray</cfif>" nowrap onclick="imp_package_row(#PACKAGE_ROW_ID#)">
                	<input name="packagename#currentrow#" type="text" readonly="readonly" value="#PACKAGE_NAME#" style="width:100%; border:none;cursor:pointer;<cfif isdefined('attributes.design_package_row_id') and attributes.design_package_row_id eq PACKAGE_ROW_ID>background-color:LightGray</cfif>">
                </td>
                <td style="text-align:center;cursor: pointer;<cfif isdefined('attributes.design_package_row_id') and attributes.design_package_row_id eq PACKAGE_ROW_ID>background-color:LightGray</cfif>" onclick="upd_package_row(#PACKAGE_ROW_ID#);"><img src="/images/update_list.gif" title="#getLang('main',52)#" style="text-align:center"></td>
            </tr>
        </cfoutput>
       </tbody>
    </cf_form_list>
</div>
<script type="text/javascript">
	function add_package_row()
	{
		<cfif isdefined('attributes.design_main_row_id')>
			windowopen("<cfoutput>#request.self#?fuseaction=prod.emptypopup_add_ezgi_product_tree_creative_package_row&design_main_row_id=#attributes.design_main_row_id#</cfoutput>",'small')

		</cfif>
	}
	function cpy_package_row()
	{
		<cfif isdefined('attributes.design_main_row_id')>
		{
		windowopen("<cfoutput>#request.self#?fuseaction=prod.popup_cpy_ezgi_product_tree_creative_package_row&design_main_row_id=#attributes.design_main_row_id#"</cfoutput>,'list');
		}
		</cfif>
	}
	function upd_package_row(package_row_id)
	{
		windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=prod.popup_upd_ezgi_product_tree_creative_package_row&design_package_row_id='+package_row_id,'small');
	}
</script>