<cfparam name="attributes.piece_type_select" default=""> 
<cfquery name="get_piece_row" datasource="#dsn3#">
	SELECT 
    	DISTINCT
    	AGIRLIK,	
        BOYU,	
        DESIGN_ID,	
        DESIGN_MAIN_ROW_ID,	
        DESIGN_PACKAGE_ROW_ID,	
        ENI,	
        IS_FLOW_DIRECTION,	
        KALINLIK,	
        KESIM_BOYU,	
        KESIM_ENI,	
        MASTER_PRODUCT_ID,	
        MATERIAL_ID,	
        PACKAGE_IS_MASTER,	
        PACKAGE_PARTNER_ID,	
        PIECE_AMOUNT,	
        PIECE_CODE,	
        PIECE_COLOR_ID,	
        PIECE_DETAIL,	
        PIECE_IS_MASTER,	
        PIECE_NAME,	
        PIECE_PARTNER_ID,	
        PIECE_RELATED_ID,	
        PIECE_ROW_ID,	
        PIECE_STATUS,	
        PIECE_TYPE,	
        TRIM_SIZE,	
        TRIM_TYPE,	
        PIECE_SPECT_RELATED_ID,
        (SELECT DESIGN_MAIN_NAME FROM EZGI_DESIGN_MAIN_ROW WHERE DESIGN_MAIN_ROW_ID = EZGI_DESIGN_PIECE.DESIGN_MAIN_ROW_ID) as DESIGN_MAIN_NAME,
        (SELECT PACKAGE_NUMBER FROM EZGI_DESIGN_PACKAGE WHERE PACKAGE_ROW_ID = EZGI_DESIGN_PIECE.DESIGN_PACKAGE_ROW_ID) as PACKAGE_NUMBER,
        (SELECT PROPERTY_DETAIL FROM #dsn1_alias#.PRODUCT_PROPERTY_DETAIL WHERE PROPERTY_DETAIL_ID = EZGI_DESIGN_PIECE.KALINLIK) AS KALINLIK_,
        (SELECT ISNULL(COUNT(PIECE_RELATED_ID), 0) AS SAYI FROM EZGI_DESIGN_PIECE_ROWS WHERE PIECE_RELATED_ID = EZGI_DESIGN_PIECE.PIECE_RELATED_ID AND PIECE_TYPE <> 4) AS ORTAK_PARCA,
        ISNULL((
        		SELECT        
                	SUM(EPR.AMOUNT * EP.PIECE_AMOUNT) AS AMOUNT
				FROM     
                	EZGI_DESIGN_PIECE_ROW AS EPR INNER JOIN
                 	EZGI_DESIGN_PIECE_ROWS AS EP ON EPR.PIECE_ROW_ID = EP.PIECE_ROW_ID
				WHERE        
                	EPR.RELATED_PIECE_ROW_ID = EZGI_DESIGN_PIECE.PIECE_ROW_ID
				GROUP BY 
                	EPR.RELATED_PIECE_ROW_ID
        		),0) AS USED_AMOUNT
  	FROM 
    	EZGI_DESIGN_PIECE 
  	WHERE 
    	<cfif isdefined('attributes.design_package_row_id')>
    		DESIGN_PACKAGE_ROW_ID = #attributes.design_package_row_id#
       	<cfelseif isdefined('attributes.design_main_row_id')>
        	DESIGN_MAIN_ROW_ID = #attributes.design_main_row_id#
        <cfelse>
        	DESIGN_ID = #attributes.design_id#
        </cfif>
        <cfif len(attributes.piece_type_select)>
        	AND PIECE_TYPE = #attributes.piece_type_select#
        </cfif>
  	ORDER BY
    	<cfif attributes.sort_id eq 5>
        	DESIGN_MAIN_NAME,PIECE_CODE
        <cfelseif attributes.sort_id eq 4> 
        	DESIGN_MAIN_NAME,PACKAGE_NUMBER
        <cfelseif attributes.sort_id eq 3>
        	PIECE_COLOR_ID,DESIGN_MAIN_NAME
        <cfelseif attributes.sort_id eq 2>
        	DESIGN_MAIN_NAME,PIECE_NAME
        <cfelseif attributes.sort_id eq 1>
        	BOYU
        <cfelseif attributes.sort_id eq 0>
        	PIECE_TYPE,DESIGN_MAIN_NAME
       	<cfelseif attributes.sort_id eq 6>
        	ENI,DESIGN_MAIN_NAME
        <cfelseif attributes.sort_id eq 7>
        	KALINLIK,DESIGN_MAIN_NAME
        <cfelseif attributes.sort_id eq 8>
        	PIECE_AMOUNT,DESIGN_MAIN_NAME
        <cfelseif attributes.sort_id eq 9>
        	IS_FLOW_DIRECTION,DESIGN_MAIN_NAME
        </cfif>    
</cfquery>
<!---ERP üzerinde Parça Stok Kartları da açılacaksa Aynı İsimli Kart Varmı--->
<cfif get_design.PROCESS_ID eq 1>
	<cfoutput query="get_piece_row">
        <cfset renk_adi = ''>
        <cfif isdefined('COLOR_NAME_#PIECE_COLOR_ID#')><cfset renk_adi = Evaluate('COLOR_NAME_#PIECE_COLOR_ID#')></cfif>
        <cfset urun_adi = '#get_design.design_name# #PIECE_NAME# (#renk_adi#)'> 
		<cfquery name="get_same_product" datasource="#dsn3#">
        	SELECT STOCK_ID FROM STOCKS WHERE PRODUCT_NAME = '#urun_adi#'
        </cfquery>
        <cfif get_same_product.recordcount>
			<cfset 'same#PIECE_ROW_ID#' = urun_adi>
        </cfif>
	</cfoutput>
</cfif>
<cf_seperator title="#getLang('main',2864)#" id="piece_" is_closed="1">
<div id="piece_" style="display:none;">
    <cf_form_list id="table6">
        <thead>
            <tr>
                <th style="text-align:center;width:30px;height:30px;cursor:pointer"><cf_get_lang_main no='1165.Sıra'></th>
                <th style="text-align:center;width:30px;cursor:pointer"><img src="/images/workdevxml.gif" style="text-align:center" title=""></th>
                <th style="text-align:center;width:30px;cursor:pointer">
                	<select name="piece_type_select" id="piece_type_select" style="width:30px; height:20px" onchange="piece_type_select_(this.value);">
                    	<option value="" <cfif attributes.piece_type_select eq ''>selected</cfif> ><cfoutput>#getLang('report',355)#</cfoutput></option>
                        <option value="1" <cfif attributes.piece_type_select eq 1>selected</cfif> ><cfoutput>#getLang('main',3010)#</cfoutput></option>
                        <option value="2" <cfif attributes.piece_type_select eq 2>selected</cfif> ><cfoutput>#getLang('main',3011)#</cfoutput></option>
                        <option value="3" <cfif attributes.piece_type_select eq 3>selected</cfif> ><cfoutput>#getLang('main',3012)#</cfoutput></option>
                        <option value="4" <cfif attributes.piece_type_select eq 4>selected</cfif> ><cfoutput>#getLang('main',3013)#</cfoutput></option>
                    </select>
                </th>
                <th style="text-align:center;width:30px;cursor:pointer" onclick="sort_piece_row(5);"><cf_get_lang_main no='1173.Kod'></th>
                <th style="text-align:center;width:100%;cursor:pointer" onclick="sort_piece_row(2);"><cf_get_lang_main no='245.Ürün'></th>
                <th style="text-align:center;width:40px;cursor:pointer" onclick="sort_piece_row(1);">&nbsp;<cfoutput>#getLang('main',2902)#</cfoutput>&nbsp;</th>
                <th style="text-align:center;width:40px;cursor:pointer" onclick="sort_piece_row(6);">&nbsp;<cfoutput>#getLang('main',2901)#</cfoutput>&nbsp;</th>
                <th style="text-align:center;width:30px;cursor:pointer" onclick="sort_piece_row(7);">&nbsp;<cfoutput>#getLang('main',3014)#</cfoutput>&nbsp;</th>
                <th style="text-align:center;width:40px;cursor:pointer" onclick="sort_piece_row(8);">&nbsp;<cfoutput>#getLang('main',3015)#</cfoutput>&nbsp;</th>
                <th style="text-align:center;width:90px;cursor:pointer" onclick="sort_piece_row(3);">&nbsp;<cfoutput>#getLang('main',3002)#</cfoutput>&nbsp;</th>
                <th style="text-align:center;width:30px;cursor:pointer" onclick="sort_piece_row(9);">&nbsp;<cfoutput>#getLang('main',3016)#</cfoutput>&nbsp;</th>
                <th style="text-align:center;width:30px;cursor:pointer" onclick="sort_piece_row(4);">&nbsp;PNo&nbsp;</th>
                <th style="text-align:center;width:30px;cursor:pointer"><cfoutput>#getLang('main',3017)#</cfoutput></th>
                <th style="text-align:center;<cfif not isdefined('attributes.design_package_row_id') and isdefined('attributes.design_main_row_id') and not get_piece_row.recordcount>width:60px<cfelse>width:20px</cfif>" nowrap="nowrap">
                	<cfif isdefined('attributes.design_main_row_id')>
                    	<a href="javascript://" onClick="cpy_piece();"><img src="/images/copy_list.gif" align="absmiddle" title="<cf_get_lang_main no='64.Kopyala'>"></a>
                		<a href="javascript://" onClick="add_piece_row();"><img src="/images/plus_list.gif" align="absmiddle" title="<cf_get_lang_main no='170.Ekle'>" border="0"></a>
                   	</cfif>
                  	<cfif not isdefined('attributes.design_package_row_id') and isdefined('attributes.design_main_row_id') and not get_piece_row.recordcount>
                    	<a href="javascript://" onClick="add_import_piece_row();"><img src="/images/transfer.gif" align="absmiddle" title="<cf_get_lang_main no='1156.Transfer'>" border="0"></a>
                    </cfif>
                </th>
                <th style="text-align:center;width:20px;">
                	<input type="checkbox" name="all_piece" id="all_piece" onClick="javascript: wrk_select_piece('all_piece','select_piece_row',<cfoutput>#get_piece_row.recordcount#</cfoutput>);">
                </th>
            </tr>
        </thead>
        <tbody>
        <cfoutput query="get_piece_row">
        	<input type="hidden" name="new_stock_id_3_#PIECE_ROW_ID#" id="new_stock_id_3_#PIECE_ROW_ID#" value="">
            <input type="hidden" name="new_product_id_3_#PIECE_ROW_ID#" id="new_product_id_3_#PIECE_ROW_ID#" value="">
            <tr id="frm_row_exit#currentrow#">
                <td nowrap="nowrap" title="<cfif PACKAGE_PARTNER_ID gt 0>Ortak Paket Parçası</cfif>" style="text-align:right;cursor: pointer; vertical-align:middle;<cfif isdefined('attributes.design_piece_row_id') and attributes.design_piece_row_id eq PIECE_ROW_ID>background-color:LightGray</cfif>">
                	<cfif PIECE_TYPE eq 1 or PIECE_TYPE eq 2>
                		<a style="cursor:pointer" onclick="copy_piece_row(#PIECE_ROW_ID#);"><img src="images/copy_list.gif"  title="<cf_get_lang_main no='64.Kopyala'>" border="0" style="vertical-align:middle"></a>
                  	</cfif>
                	#currentrow#
              	</td>
                <td style="text-align:center;cursor: pointer;<cfif isdefined('attributes.design_piece_row_id') and attributes.design_piece_row_id eq PIECE_ROW_ID>background-color:LightGray<cfelse><cfif PACKAGE_PARTNER_ID gt 0>background-color:MistyRose<cfelse><cfif ORTAK_PARCA gt 0>background-color:Gainsboro</cfif></cfif></cfif>">
                	<cfif PIECE_SPECT_RELATED_ID gt 0 or PIECE_TYPE eq 4 or PACKAGE_PARTNER_ID gt 0>
                    	<a href="javascript://" onClick="windowopen('#request.self#?fuseaction=objects.popup_detail_product&sid=#PIECE_RELATED_ID#','list');">
                        	<img src="/images/c_ok.gif" title="<cfif PACKAGE_PARTNER_ID gt 0>#getLang('main',2867)#<cfelse><cfif ORTAK_PARCA gt 0>#getLang('main',2866)#<cfelse>#getLang('main',40)# #getLang('objects2',1142)#</cfif></cfif>">
                        </a>
                    <cfelseif PACKAGE_PARTNER_ID lte 0>
                    	<a href="javascript://" onClick="relation_product_row(3,#PIECE_ROW_ID#);">
                			<img src="/images/attach.gif" id="attach_3_#PIECE_ROW_ID#" title="#getLang('main',40)# #getLang('objects2',1142)# #getLang('main',497)#">
                            <img src="/images/icons_valid.gif" id="icons_3_#PIECE_ROW_ID#" title="#getLang('main',40)# #getLang('objects2',1142)#" style="display:none">
                        </a>
                    </cfif>
                </td>
                <td style="text-align:center;cursor: pointer;<cfif isdefined('attributes.design_piece_row_id') and attributes.design_piece_row_id eq PIECE_ROW_ID>background-color:LightGray</cfif>" onclick="upd_piece_row(#PIECE_ROW_ID#);">
                	<cfif PIECE_TYPE eq 1>
                		<img src="/images/butcegider.gif" title="#getLang('main',2865)#">
                  	<cfelseif PIECE_TYPE eq 2>
                    	<img src="/images/arrow_up.png" title="#getLang('main',2157)# #getLang('prod',69)#">
                    <cfelseif PIECE_TYPE eq 3>
                		<img src="/images/elements.gif" title="#getLang('sales',255)# #getLang('prod',173)#">
                	<cfelseif PIECE_TYPE eq 4>
                    	<img src="/images/promo_multi.gif" title="#getLang('prod',132)#">
                    </cfif>
                </td>
                <td style="text-align:center;cursor:pointer;<cfif isdefined('attributes.design_piece_row_id') and attributes.design_piece_row_id eq PIECE_ROW_ID>background-color:LightGray</cfif>" nowrap onclick="imp_piece_row(#PIECE_ROW_ID#);">#PIECE_CODE#</td>
                <td <cfif Len(PIECE_NAME) gt 28>title="#PIECE_NAME#"</cfif> style="text-align:left;cursor: pointer;<cfif isdefined('attributes.design_piece_row_id') and attributes.design_piece_row_id eq PIECE_ROW_ID>background-color:LightGray</cfif>" nowrap onclick="imp_piece_row(#PIECE_ROW_ID#);">
                	<input name="productname#currentrow#" type="text" readonly="readonly" value="#PIECE_NAME#" style="width:100%; border:none;cursor:pointer;<cfif isdefined('attributes.design_piece_row_id') and attributes.design_piece_row_id eq PIECE_ROW_ID>background-color:LightGray</cfif>">
                
                </td>
                <td style="text-align:center;cursor:pointer;<cfif isdefined('attributes.design_piece_row_id') and attributes.design_piece_row_id eq PIECE_ROW_ID>background-color:LightGray</cfif>" nowrap onclick="imp_piece_row(#PIECE_ROW_ID#);">#BOYU#</td>
                <td style="text-align:center;cursor: pointer;<cfif isdefined('attributes.design_piece_row_id') and attributes.design_piece_row_id eq PIECE_ROW_ID>background-color:LightGray</cfif>" nowrap onclick="imp_piece_row(#PIECE_ROW_ID#);">#ENI#</td>
                <td style="text-align:center;cursor: pointer;<cfif isdefined('attributes.design_piece_row_id') and attributes.design_piece_row_id eq PIECE_ROW_ID>background-color:LightGray</cfif>" nowrap onclick="imp_piece_row(#PIECE_ROW_ID#);">#KALINLIK_#</td>
                <td style="text-align:center;cursor: pointer;<cfif isdefined('attributes.design_piece_row_id') and attributes.design_piece_row_id eq PIECE_ROW_ID>background-color:LightGray</cfif>" nowrap onclick="imp_piece_row(#PIECE_ROW_ID#);">#PIECE_AMOUNT#</td>
                <td title="<cfif isdefined('COLOR_NAME_#PIECE_COLOR_ID#')><cfif Len(Evaluate('COLOR_NAME_#PIECE_COLOR_ID#')) gt 12>#Evaluate('COLOR_NAME_#PIECE_COLOR_ID#')#</cfif></cfif>" style="text-align:left;cursor: pointer;<cfif isdefined('attributes.design_piece_row_id') and attributes.design_piece_row_id eq PIECE_ROW_ID>background-color:LightGray</cfif>" nowrap onclick="imp_piece_row(#PIECE_ROW_ID#);">&nbsp;
                	<cfif isdefined('COLOR_NAME_#PIECE_COLOR_ID#')>&nbsp;#Evaluate('COLOR_NAME_#PIECE_COLOR_ID#')#&nbsp;</cfif>
                </td>
                <td style="text-align:center;cursor: pointer;<cfif isdefined('attributes.design_piece_row_id') and attributes.design_piece_row_id eq PIECE_ROW_ID>background-color:LightGray</cfif>" nowrap onclick="imp_piece_row(#PIECE_ROW_ID#);">
                	<cfif PIECE_TYPE eq 1>
						<cfif IS_FLOW_DIRECTION eq 0>
                            <img src="images/production/false.png" style="width:15px; height:15px" />
                        <cfelse>
                            <img src="images/production/true.png" style="width:15px; height:15px" />
                        </cfif>
                    </cfif>
                </td>
                <td style="text-align:center;cursor: pointer;<cfif USED_AMOUNT neq 0><cfif USED_AMOUNT eq PIECE_AMOUNT>background-color:LimeGreen<cfelseif USED_AMOUNT lt PIECE_AMOUNT>background-color:yellow<cfelseif USED_AMOUNT gt PIECE_AMOUNT>background-color:coral</cfif><cfelse><cfif not len(PACKAGE_NUMBER)>background-color:red<cfelse><cfif isdefined('attributes.design_piece_row_id') and attributes.design_piece_row_id eq PIECE_ROW_ID>background-color:LightGray</cfif></cfif></cfif>" nowrap onclick="imp_piece_row(#PIECE_ROW_ID#);"><cfif USED_AMOUNT neq 0>K-#USED_AMOUNT#<cfelse>#PACKAGE_NUMBER#</cfif>
                	
                </td>
                <td style="text-align:center;cursor: pointer;<cfif isdefined('attributes.design_piece_row_id') and attributes.design_piece_row_id eq PIECE_ROW_ID>background-color:LightGray</cfif>" ><cfif PIECE_TYPE neq 4><img src="/images/barcode.gif" onclick="dsp_piece_row(#PIECE_ROW_ID#);" title="#getLang('main',1456)# #getLang('objects',406)#"></cfif></td>
                <td style="text-align:center;<cfif isdefined('attributes.design_piece_row_id') and attributes.design_piece_row_id eq PIECE_ROW_ID>background-color:LightGray</cfif>">
                	<cfif PACKAGE_PARTNER_ID gt 0>
                    	<img src="/images/lock_buton.gif" title="#getLang('main',2867)#">
                    <cfelse>
                    	<a href="javascript://" onclick="upd_piece_row(#PIECE_ROW_ID#);">
                			<img src="/images/update_list.gif" title="#getLang('main',52)#">
                        </a>
                   	</cfif>
                </td>
                <td style="text-align:center;">
                	<cfif PACKAGE_PARTNER_ID gt 0>
                    <cfelse>
                		<input type="checkbox" name="select_piece_row_#PIECE_ROW_ID#" value="#PIECE_ROW_ID#" id="select_piece_row#currentrow#" />
                   	</cfif>
                	
                </td>
            </tr>
        </cfoutput>
       </tbody>
    </cf_form_list>
</div>
<script type="text/javascript">
	function add_piece_row()
	{
		<cfif isdefined('attributes.design_main_row_id')>
			windowopen('<cfoutput>#request.self#?fuseaction=prod.popup_add_ezgi_product_tree_creative_piece_row&design_main_row_id=#attributes.design_main_row_id#<cfif isdefined("attributes.design_package_row_id") and len(attributes.design_package_row_id)>&package_row_id=#attributes.design_package_row_id#</cfif></cfoutput>','list');
		</cfif>
	}
	function add_import_piece_row()
	{
		<cfif isdefined('attributes.design_main_row_id')>
			windowopen('<cfoutput>#request.self#?fuseaction=prod.popup_add_ezgi_product_tree_creative_import_piece_row&design_main_row_id=#attributes.design_main_row_id#</cfoutput>','small');
		</cfif>
	}
	function upd_piece_row(piece_row_id)
	{
		windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=prod.popup_upd_ezgi_product_tree_creative_piece_row&design_piece_row_id='+piece_row_id,'list');
	}
	function copy_piece_row(piece_row_id)
	{
		window.location ="<cfoutput>#request.self#</cfoutput>?fuseaction=prod.emptypopup_cpy_ezgi_product_tree_creative_piece_row&is_private=1&design_piece_row_id="+piece_row_id;	
	}
	function dsp_piece_row(piece_row_id)
	{
		windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=prod.popup_dsp_ezgi_product_tree_creative_piece_row&design_piece_row_id='+piece_row_id,'wide');
	}
	function cpy_piece()
	{
		<cfif isdefined('attributes.design_main_row_id')>
			windowopen("<cfoutput>#request.self#?fuseaction=prod.popup_cpy_ezgi_product_tree_creative_package_row&main=1&design_main_row_id=#attributes.design_main_row_id#<cfif isdefined("attributes.design_package_row_id") and len(attributes.design_package_row_id)>&package_row_id=#attributes.design_package_row_id#</cfif>"</cfoutput>,'list');
		</cfif>
	}
	function wrk_select_piece(all_piece,select_piece_row,number)
	{
		for(var pic_rws=1; pic_rws <= number; pic_rws++)
		{
			if(document.getElementById('select_piece_row'+pic_rws)==undefined)
			{
				
			}
			else
			{
				if(document.getElementById(all_piece).checked == true)
				{
					if(document.getElementById('select_piece_row'+pic_rws).checked == false)
						document.getElementById('select_piece_row'+pic_rws).checked = true;
				}
				else
				{
					if(document.getElementById('select_piece_row'+pic_rws).checked == true)
						document.getElementById('select_piece_row'+pic_rws).checked = false;
				}
			}
		}
	}
</script>