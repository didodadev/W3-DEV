<cfset var_="upd_purchase_basket">
<cfparam name="attributes.urun" default="">
<cfparam name="attributes.sid" default="">
<cfquery name="get_name" datasource="#dsn3#">
	SELECT DESIGN_MAIN_NAME FROM EZGI_DESIGN_MAIN_ROW WHERE DESIGN_MAIN_ROW_ID = #attributes.design_main_row_id#
</cfquery>
<cfset urun_adi = get_name.DESIGN_MAIN_NAME> <!---Ürün Adı Tanımı--->
<cfquery name="get_package_control" datasource="#dsn3#"> <!---Kopyalanacak Modülün Paket Tanımı Yapılmış mı--->
	SELECT PACKAGE_NUMBER FROM EZGI_DESIGN_PACKAGE WHERE DESIGN_MAIN_ROW_ID = #attributes.design_main_row_id#
</cfquery>

<cfif len(attributes.sid)>
	<cfquery name="get_package_content" datasource="#dsn3#">
    	SELECT
        	DISTINCT
        	EDP.PIECE_ROW_ID,        
        	EDP.PIECE_TYPE, 
            EDP.PIECE_NAME, 
            EDP.PIECE_CODE, 
            EDP.PIECE_COLOR_ID, 
            EDP.PIECE_RELATED_ID, 
            EDP.PIECE_AMOUNT, 
            EDP.BOYU, 
            EDP.ENI, 
            EDP.PACKAGE_IS_MASTER,	
        	EDP.PACKAGE_PARTNER_ID,
         	EC.COLOR_NAME,
            (
            	SELECT        
                	TOP (1) PPP.PROPERTY_DETAIL
				FROM            
                	#dsn1_alias#.PRODUCT_PROPERTY_DETAIL AS PPP INNER JOIN
            		EZGI_DESIGN_DEFAULTS AS EDD ON PPP.PRPT_ID = EDD.DEFAULT_THICKNESS_PROPERTY_ID
				WHERE        
                	PPP.PROPERTY_DETAIL_ID = EDP.KALINLIK
            ) AS KALINLIK,
            (SELECT PACKAGE_NUMBER FROM EZGI_DESIGN_PACKAGE WHERE PACKAGE_ROW_ID = EDP.DESIGN_PACKAGE_ROW_ID) AS PACKAGE_NUMBER
		FROM            
        	EZGI_DESIGN_PIECE AS EDP  LEFT OUTER JOIN
         	EZGI_COLORS AS EC ON EDP.PIECE_COLOR_ID = EC.COLOR_ID
		WHERE 
        	<cfif isdefined('attributes.main')>       
                EDP.DESIGN_MAIN_ROW_ID = #attributes.sid# AND
					<cfif (isdefined('attributes.package_row_id') and len(attributes.package_row_id)) or not get_package_control.recordcount>
                        EDP.PIECE_TYPE IN (1,2,3,4) AND
                    <cfelse>
                        EDP.PIECE_TYPE IN (1,2,4) AND
                    </cfif>
            <cfelse>
            	EDP.DESIGN_PACKAGE_ROW_ID = #attributes.sid# AND	
            </cfif> 
            EDP.PIECE_STATUS = 1
      	ORDER BY
        	EDP.PIECE_TYPE
    </cfquery>
    <cfset piece_row_id_list = ValueList(get_package_content.PIECE_ROW_ID)>
    <cfloop query="get_package_content">
    	<cfif PIECE_TYPE eq 3>
        	<cfquery name="get_sub_pieces" datasource="#dsn3#">
            	SELECT RELATED_PIECE_ROW_ID FROM EZGI_DESIGN_PIECE_ROW WHERE PIECE_ROW_ID = #PIECE_ROW_ID# AND RELATED_PIECE_ROW_ID IS NOT NULL
            </cfquery>
            <cfset 'PIECE_SUB_LIST_#PIECE_ROW_ID#' = ValueList(get_sub_pieces.RELATED_PIECE_ROW_ID)>
        <cfelse>
        	<cfset 'PIECE_SUB_LIST_#PIECE_ROW_ID#' = 0>
        </cfif>
    </cfloop>
<cfelse>
	<cfset get_package_content.recordcount =0>
    <cfset piece_row_id_list = ''>
</cfif>
<table class="dph">
    <tr>
        <td class="dpht">&nbsp;<cfif isdefined('attributes.main')><cf_get_lang_main no='2868.Modülden Parça Kopyala'> - <cfelse><cf_get_lang_main no='2869.Modüle Paket Kopyala'> - </cfif><cfoutput>#urun_adi#</cfoutput></td>
        <td class="dphb">
        	<cfoutput>
             	<!---<a href="javascript://" onClick="windowopen('#request.self#?fuseaction=prod.popup_add_ezgi_product_tree_import&piece_id=#attributes.piece_id#','list');"><img src="/images/tree_bt.gif" border="0" title="Ürün Ağacı Kontrol"></a>--->
            </cfoutput>
            &nbsp;&nbsp;
        </td>
	</tr>
</table>
<table class="dpm" align="center">
    <tr>
    	<td valign="top" class="dpml">
        	<cfform name="add_piece_relation" id="add_piece_relation" method="post" action="#request.self#?fuseaction=prod.emptypopup_cpy_ezgi_product_tree_creative_package_row">
            	<cf_form_box>
                	<cfif isdefined('attributes.private')> <!---Özel Tasarımdan Geliyorsa--->
                    	<cfinput name="private" id="private" value="#attributes.private#" type="hidden">
                    </cfif>
                    <cfinput name="design_main_row_id" id="design_main_row_id" value="#attributes.design_main_row_id#" type="hidden">
                    <cfinput name="design_main_name" id="design_main_name" value="#urun_adi#" type="hidden">
                    <cfinput name="piece_row_id_list" id="piece_row_id_list" value="#piece_row_id_list#" type="hidden">
                    <cfif isdefined('attributes.package_row_id') and len(attributes.package_row_id)>
                    	<cfinput name="package_row_id" value="#attributes.package_row_id#" type="hidden">
                    </cfif>
                    <cfif isdefined('attributes.main')><input type="hidden" name="main" value="1"></cfif>
                    <table>
                        <tr>
                           	<td width="120"><cfif isdefined('attributes.main')><cf_get_lang_main no='2871.Kopyalanacak Modül'><cfelse><cf_get_lang_main no='2870.Kopyalanacak Paket'></cfif> *</td>
                        	<td width="300"><cfsavecontent variable="message"><cf_get_lang_main no='782.Girilmesi Zorunlu Alan'>!</cfsavecontent>
                                <input type="text" name="urun" id="urun" value="<cfoutput>#attributes.urun#</cfoutput>" style="width:280px; vertical-align:middle">
                              	<input type="hidden" name="sid" id="sid" value="<cfoutput>#attributes.sid#</cfoutput>">
                              	<a href="javascript://" onclick="relation_product_row();"><img src="/images/plus_thin.gif" align="absmiddle" border="0"></a>
                            </td>
                            <td style="text-align:right; vertical-align:bottom; height:30px;" >
                                <cfinput type="button" value="#getLang('main',50)#" name="cnc_buton" onClick="window.close();">
                                <cfinput type="submit" value="#getLang('main',49)#" name="upd_buton" onClick="insert_control();">
                            </td>
                        </tr>
                        <tr>
                        	<td></td>
                        	<td colspan="2" >
                            	<input type="checkbox" name="workcube_select" id="workcube_select" value="1" <cfif isdefined('attributes.workcube_select')>checked</cfif> />&nbsp;<cf_get_lang_main no='2872.Workcube Bağlantılı Ortak Parça Olarak Kopyala'><br />
                                <cfif isdefined('attributes.package_row_id') and len(attributes.package_row_id)>
                            		<input type="checkbox" name="to_package_select" id="to_package_select" value="1" <cfif isdefined('attributes.to_package_select')>checked</cfif> />&nbsp;<cf_get_lang_main no='2873.Tüm Parçaları Seçilen Pakete Dahil Et'>
                                <cfelseif not get_package_control.recordcount> <!---Eğer Modüle Paket Tanımı Yapılmamışsa--->
                                	<input type="checkbox" name="package_piece_select" id="package_piece_select" value="1" onChange="tumunu_sec()" <cfif isdefined('attributes.package_piece_select')>checked</cfif> />&nbsp;<cf_get_lang_main no='2874.Tüm Paketleri ve Parçaları Uyumlu Kopyala'>
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
                                    	<thead style=" width:100%">
                                            <tr>
                                                <th style="text-align:center;width:20px;cursor:pointer"><cf_get_lang_main no='1165.Sıra'></th>
                                                <cfif isdefined('attributes.main')>
                                                	<th style="text-align:center;width:20px;cursor:pointer"></th>
                                                </cfif>
                                                <th style="text-align:center;width:20px;cursor:pointer">ÜK</th>
                                                <th style="text-align:center;width:20px;cursor:pointer"></th>
                                                <th style="text-align:center;width:30px;cursor:pointer"><cfoutput>#getLang('stock',371)#</cfoutput></th>
                                                <th style="text-align:center;width:20px;cursor:pointer"><cfoutput>#getLang('main',1173)#</cfoutput></th>
                                                <th style="text-align:center;width:290px;cursor:pointer"><cfoutput>#getLang('main',2848)# #getLang('main',485)#</cfoutput></th>
                                                <th style="text-align:center;width:40px;cursor:pointer"><cfoutput>#getLang('report',790)#</cfoutput></th>
                                                <th style="text-align:center;width:40px;cursor:pointer"><cfoutput>#getLang('report',749)#</cfoutput></th>
                                                <th style="text-align:center;width:20px;cursor:pointer"><cfoutput>#getLang('main',284)#</cfoutput></th>
                                                <th style="text-align:center;width:20px;cursor:pointer"><cfoutput>#getLang('main',223)#</cfoutput></th>
                                                <th style="text-align:center;width:110px;cursor:pointer"><cfoutput>#getLang('report',185)#</cfoutput></th>
                                            </tr>
                                        </thead>
                                        <tbody>
                                        	<cfif get_package_content.recordcount>
        										<cfoutput query="get_package_content">
                                                	<cfif len(attributes.sid)>
                                                        <cfinput type="hidden" name="record_count" value="#PIECE_ROW_ID#">
                                                        <input type="hidden" name="piece_type_#PIECE_ROW_ID#" value="#PIECE_TYPE#">
                                                        <input type="hidden" name="piece_sub_id_#PIECE_ROW_ID#" id="piece_sub_id_#PIECE_ROW_ID#" value="#Evaluate('PIECE_SUB_LIST_#PIECE_ROW_ID#')#" />
                                                    </cfif>
                                                    <cfif PACKAGE_IS_MASTER gt 0>
                                                    	<input type="hidden" name="piece_ortak_#PIECE_ROW_ID#" value="M">
                                                	<cfelse>
														<cfif PACKAGE_PARTNER_ID gt 0>
                                                      		<input type="hidden" name="piece_ortak_#PIECE_ROW_ID#" value="O">
                                                       	<cfelse>
                                                        	<input type="hidden" name="piece_ortak_#PIECE_ROW_ID#" value=""> 
                                                        </cfif>
                                                    </cfif>
                                                	 <tr id="frm_row_exit#currentrow#">
                										<td style="text-align:right;vertical-align:middle;">
                											#currentrow#
              											</td>
                                                        <cfif isdefined('attributes.main')>
                                                        	<td style="text-align:center;vertical-align:middle;" >
                                                            	<input type="checkbox" id="a_#PIECE_ROW_ID#" name="a_#PIECE_ROW_ID#" onClick="control_piece_type(#PIECE_TYPE#,#PIECE_ROW_ID#)" value="1" <cfif isdefined('attributes.package_piece_select')>checked disabled</cfif>/>
                                                            </td>
                                                        </cfif>
                										<td title="<cfif PACKAGE_IS_MASTER gt 0>
<cf_get_lang_main no='3007.Master Paket Parçası'><cfelse><cfif PACKAGE_PARTNER_ID gt 0><cf_get_lang_main no='2867.Ortak Paket Parçası'></cfif></cfif>" style="text-align:center;<cfif PACKAGE_IS_MASTER gt 0>background-color:Green<cfelse><cfif PACKAGE_PARTNER_ID gt 0>background-color:MistyRose</cfif></cfif>">
                											<cfif PIECE_RELATED_ID gt 0>
                    											<img src="/images/c_ok.gif">
                    										</cfif>
                										</td>
                										<td style="text-align:center;">
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
                                                        <td style="text-align:center;">#PACKAGE_NUMBER#</td>
                										<td style="text-align:center;">#PIECE_CODE#</td>
                                                        <td nowrap style="width:170px;text-align:left;">
                                                        	<input type="text" style="width:100%; border:none;cursor:pointer;" readonly="readonly" value="#PIECE_NAME#" />
                                                       	</td>
                										<td style="text-align:center;">#BOYU#</td>
                										<td style="text-align:center;">#ENI#</td>
                										<td style="text-align:center;">#KALINLIK#</td>
                										<td style="text-align:center;">#PIECE_AMOUNT#</td>
                										<td style="text-align:center;" nowrap>#COLOR_NAME#</td>
                									</tr>
                                                </cfoutput>
                                                <tfoot>
                                                	<tbody  ><tr>
                                                    	<td colspan="12">
                                                    		<input type="button" name="buton" id="buton" value="<cf_get_lang_main no='3009.Hepsini Seç'>" onclick="hesini_sec(-1);" />
                                                            <input type="button" name="buton_sil" id="buton_sil" value="<cf_get_lang_main no='3008.Hepsini Kaldır'>" style="display:none" onclick="hesini_sec(-2);" />
                                                    	</td>
                                                 	</tr>
                                                </tfoot>
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
		<cfif isdefined('attributes.main')>
			windowopen('<cfoutput>#request.self#?fuseaction=prod.popup_ezgi_stocks&ezgi_design=2&product_type=2&price_cat=-2&add_product_cost=1&module_name=product&var_=#var_#&is_action=1&startdate=&price_lists=&product_id=add_piece_relation.pid&field_id=add_piece_relation.sid&field_name=add_piece_relation.urun'</cfoutput>,'page');
		<cfelse>
			windowopen('<cfoutput>#request.self#?fuseaction=prod.popup_ezgi_stocks&ezgi_design=2&product_type=3&price_cat=-2&add_product_cost=1&module_name=product&var_=#var_#&is_action=1&startdate=&price_lists=&product_id=add_piece_relation.pid&field_id=add_piece_relation.sid&field_name=add_piece_relation.urun'</cfoutput>,'page');
		</cfif>
	}
	function add_ezgi_row(stock_id,product_name)
	{
		document.getElementById('urun').value = product_name;
		document.getElementById('sid').value = stock_id;
		document.getElementById("add_piece_relation").action = "<cfoutput>#request.self#</cfoutput>?fuseaction=prod.popup_cpy_ezgi_product_tree_creative_package_row";
		document.getElementById("add_piece_relation").submit();
	}
	function control_piece_type(piece_type,piece_row_id)
	{
		var sub_list = document.getElementById('piece_sub_id_'+piece_row_id).value;
		sub_list_len = list_len(sub_list);
		for (i = 1; i <= sub_list_len; i++) 
		{ 
			list_value = list_getat(sub_list,i);
			if(list_value > 0)
			{
					if(eval('document.all.a_'+piece_row_id).checked==false)						   
						document.getElementById('a_'+list_value).checked = false;
					else
						document.getElementById('a_'+list_value).checked = true;
						
			}
		}
	}
	function hesini_sec(type)
	{
		var piece_row_id_list = document.getElementById('piece_row_id_list').value;
		piece_row_id_list_len = list_len(piece_row_id_list);
		for (j = 1; j <= piece_row_id_list_len; j++) 
		{
			piece_list_value = list_getat(piece_row_id_list,j);
			if(piece_list_value > 0)
			{
				if(type == -1)
					document.getElementById('a_'+piece_list_value).checked = true;
				else
					document.getElementById('a_'+piece_list_value).checked = false;
			}
		}
		if(type == -1)
		{
			document.getElementById('buton').style.display="none";
			document.getElementById('buton_sil').style.display="";
		}
		else
		{
			document.getElementById('buton').style.display="";
			document.getElementById('buton_sil').style.display="none";
		}
	}
	function tumunu_sec()
	{
		var piece_row_id_list = document.getElementById('piece_row_id_list').value;
		piece_row_id_list_len = list_len(piece_row_id_list);
		for (j = 1; j <= piece_row_id_list_len; j++) 
		{
			piece_list_value = list_getat(piece_row_id_list,j);
			if(piece_list_value > 0)
			{
				if(document.all.package_piece_select.checked==true)
				{
					document.getElementById('a_'+piece_list_value).checked = true;
					document.getElementById('a_'+piece_list_value).disabled = true;
					document.getElementById('buton').style.display="none";
				}
				else
				{
					document.getElementById('a_'+piece_list_value).disabled = false;
					document.getElementById('a_'+piece_list_value).checked = false;
					document.getElementById('buton').style.display="";
				}
			}
		}
	}
	function insert_control()
	{
		var piece_row_id_list = document.getElementById('piece_row_id_list').value;
		piece_row_id_list_len = list_len(piece_row_id_list);
		alert_key = 1;
		for (j = 1; j <= piece_row_id_list_len; j++) 
		{
			piece_list_value = list_getat(piece_row_id_list,j);
			if(document.getElementById('a_'+piece_list_value).checked == true)
				alert_key = 0;
		}
		if(alert_key == 1)
		{
			alert('<cf_get_lang_main no='2875.Kopyalanacak Kayıtları Lütfen Seçiniz'> !');
			return false;
		}	
	}
</script>