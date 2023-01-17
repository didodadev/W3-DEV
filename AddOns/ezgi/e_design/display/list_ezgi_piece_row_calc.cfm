<cfset var_="upd_purchase_basket">
<cfparam name="attributes.urun" default="">
<cfparam name="attributes.stock_id" default="">
<cfparam name="attributes.pid" default="">
<cfparam name="attributes.rate" default="1">
<cfif len(attributes.stock_id)>
	<cfquery name="get_calc_content" datasource="#dsn3#">
    	SELECT 
        	SUM(AMOUNT) AS AMOUNT,
            STOCK_ID,
            PRODUCT_ID, 
            STOCK_CODE, 
            PRODUCT_NAME,
            (
            SELECT 
            	TOP (1)       
            	MAIN_UNIT
			FROM            
            	PRODUCT_UNIT
			WHERE        
            	PRODUCT_ID = TBL.PRODUCT_ID AND 
                IS_MAIN = 1
			) AS MAIN_UNIT
      	FROM
        	(
            SELECT        
                STOCK_ID2 AS STOCK_ID, 
                PRODUCT_ID,
                STOCK_CODE, 
                PRODUCT_NAME, 
                AMOUNT * AMOUNT2 * AMOUNT3 * AMOUNT4 * AMOUNT5 * AMOUNT6 * AMOUNT7 * AMOUNT8 * AMOUNT9 AS AMOUNT
            FROM           
                EZGI_PRODUCT_TREE_BOM1
            WHERE        
                STOCK_ID = #attributes.stock_id#
            ) AS TBL
     	GROUP BY
        	STOCK_ID,
            PRODUCT_ID, 
            STOCK_CODE, 
            PRODUCT_NAME
    </cfquery>
<cfelse>
	<cfset get_calc_content.recordcount =0>
</cfif>
<table class="dph">
    <tr>
        <td class="dpht">&nbsp;<cf_get_lang_main no='2985.Hizmet Hesaplayarak Ekle'>-</td>
        <td class="dphb">
        	<cfoutput>
            </cfoutput>
            &nbsp;&nbsp;
        </td>
	</tr>
</table>
<table class="dpm" align="center">
    <tr>
    	<td valign="top" class="dpml">
        	<cfform name="add_piece_relation" id="add_piece_relation" method="post" action="#request.self#?fuseaction=prod.popup_list_ezgi_piece_row_calc">
            	<cf_form_box>
                    <table>
                        <tr>
                           	<td width="80"><cf_get_lang_main no='1613.Ürün Ekle'> *</td>
                        	<td width="300"><cfsavecontent variable="message"><cf_get_lang_main no='782.Girilmesi Zorunlu Alan'>!</cfsavecontent>
                                <input type="text" name="urun" id="urun" value="<cfoutput>#attributes.urun#</cfoutput>" style="width:280px; vertical-align:middle">
                              	<input type="hidden" name="stock_id" id="stock_id" value="<cfoutput>#attributes.stock_id#</cfoutput>">
                                <input type="hidden" name="pid" id="pid" value="<cfoutput>#attributes.pid#</cfoutput>">
                                <cfinput type="hidden" name="design_piece_row_id" value="#attributes.design_piece_row_id#">
                              	<a href="javascript://" onclick="relation_product_row();"><img src="/images/plus_thin.gif" align="absmiddle" border="0"></a>
                            </td>
                      	</tr>
                        <tr>
                            <td><cf_get_lang_main no='1044.Oran'> *</td>
                        	<td><input type="text" name="rate" id="rate" value="<cfoutput>#attributes.rate#</cfoutput>" style="width:80px; vertical-align:middle; text-align:right"></td>
                        </tr>
                    </table>
                    <br>
                    <table>
                        <tr>
                            <td style="text-align:right; vertical-align:middle; height:25px" >
                            	<cfinput type="button" value="#getLang('main',50)#" name="cnc_buton" onClick="window.close();">&nbsp;
                                <cfinput type="submit" value="#getLang('main',1586)#" name="upd_buton">&nbsp;
                            	<cfif len(attributes.stock_id)>
                                	<input type="button" value="<cf_get_lang_main no='170.Ekle'>" onClick="grupla();">
                                </cfif>
                            </td>
                        </tr>
                    </table>
                </cf_form_box>
                <cf_form_box>
                    <cf_area width="100%">
                        <cf_object_main_table>
                            <cf_object_table column_width_list="100%">
                                <cf_object_tr id="form_ul_piece_main_row">
                                    <cf_object_td >
                                    	<cf_big_list id="piece_">
                                    	<thead style="width:520px">
                                            <tr>
                                                <th style="text-align:center;width:25px;cursor:pointer"><cf_get_lang_main no='1165.Sıra'></th>
                                                <th style="text-align:center;width:90px;"><cf_get_lang_main no='1388.Ürün Kodu'></th>
                                                <th style="text-align:center;width:350px;"><cf_get_lang_main no='809.Ürün Adı'></th>
                                                <th style="text-align:center;width:60px;"><cf_get_lang_main no='223.Miktar'></th>
                                                <th style="text-align:center;width:20px;">
                                                	<input type="checkbox" alt="Hepsini Seç" onClick="grupla(-1);">
                                                </th>
                                            </tr>
                                        </thead>
                                        <tbody>
                                        	<cfif get_calc_content.recordcount>
        										<cfoutput query="get_calc_content">
                                                	<input type="hidden" id="product_name_#stock_id#" name="product_name_#stock_id#" value="#product_name#">
                                                    <input type="hidden" id="product_id_#stock_id#" name="product_id_#stock_id#" value="#product_id#">
                                                    <input type="hidden" id="MAIN_UNIT_#stock_id#" name="MAIN_UNIT_#stock_id#" value="#MAIN_UNIT#">
                                                	<tr id="frm_row_exit#currentrow#">
                										<td style="text-align:right;vertical-align:middle;">#currentrow#</td>
                										<td nowrap>#STOCK_CODE#</td>
                										<td>#PRODUCT_NAME#</td>
                										<td style="text-align:right;">
                                                        	<input type="text" name="amount_#stock_id#" id="amount_#stock_id#" value="#TlFormat(AMOUNT*Filternum(attributes.rate,2),8)#" style="width:75px; text-align:right">
                                                        </td>
                										<td style="text-align:center;" nowrap>
                                                        	<input type="checkbox" name="select_production" checked="checked" value="#stock_id#">
                                                        </td>
                									</tr>
                                                </cfoutput>
                                          	</cfif>
                                      	</tbody>
                                        </cf_big_list>
                                    </cf_object_td>
                                </cf_object_tr>
                            </cf_object_table>
                        </cf_object_main_table>
                    </cf_area>
                </cf_form_box>
         	</cfform>
     	</td>
 	</tr>
</table>
<script type="text/javascript">
	function relation_product_row(product_type, creative_id, satir_no)
	{
		windowopen("<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_ezgi_product_names&list_order_no=5&product_id=add_piece_relation.pid&field_id=add_piece_relation.stock_id&field_name=add_piece_relation.urun",'list');
	}
	function add_ezgi_row(stock_id,product_name)
	{
		document.getElementById('urun').value = product_name;
		document.getElementById('stock_id').value = stock_id;
		document.getElementById("add_piece_relation").action = "<cfoutput>#request.self#?fuseaction=prod.popup_list_ezgi_piece_row_calc</cfoutput>";
		document.getElementById("add_piece_relation").submit();
	}
	function grupla(type)
	{//type sadece -1 olarak gelir,-1 geliyorsa hepsini seç demektir.
			stock_id_list = '';
			chck_leng = document.getElementsByName('select_production').length;
			for(ci=0;ci<chck_leng;ci++)
			{
				var my_objets = document.all.select_production[ci];
				if(chck_leng == 1)
					var my_objets =document.all.select_production;
				if(type == -1)
				{//hepsini seç denilmişse	
					if(my_objets.checked == true)
						my_objets.checked = false;
					else
						my_objets.checked = true;
				}
				else
				{
					if(my_objets.checked == true)

						stock_id_list +=my_objets.value+',';
				}
			}
			stock_id_list = stock_id_list.substr(0,stock_id_list.length-1);//sondaki virgülden kurtarıyoruz.
			if(stock_id_list!='')
			{
				document.getElementById("add_piece_relation").action = "<cfoutput>#request.self#?fuseaction=prod.emptypopup_add_ezgi_piece_row_calc</cfoutput>";
				document.getElementById("add_piece_relation").submit();
			}
	}
</script>