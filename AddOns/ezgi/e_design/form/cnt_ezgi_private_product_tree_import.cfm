<!---Design Sorgusu--->
<cfset module_name="prod">
<cfquery name="get_colors" datasource="#dsn3#">
	SELECT * FROM EZGI_COLORS ORDER BY COLOR_NAME
</cfquery>
<cfoutput query="get_colors">
	<cfset 'COLOR_NAME_#COLOR_ID#' = COLOR_NAME>
</cfoutput>
<cfquery name="get_defaults" datasource="#dsn3#">
	SELECT * FROM EZGI_DESIGN_DEFAULTS
</cfquery>
<cfquery name="get_product_cat_piece" datasource="#dsn3#">
  	SELECT HIERARCHY FROM PRODUCT_CAT WHERE PRODUCT_CATID = #get_defaults.DEFAULT_PIECE_CAT_ID#
</cfquery>
<cfquery name="get_product_cat_package" datasource="#dsn3#">
  	SELECT HIERARCHY FROM PRODUCT_CAT WHERE PRODUCT_CATID = #get_defaults.DEFAULT_PACKAGE_CAT_ID#
</cfquery>
<cfquery name="get_design_info" datasource="#dsn3#">
	SELECT 
        ED.DESIGN_NAME, 
        ED.PROCESS_ID
   	FROM 
    	EZGI_DESIGN AS ED 
  	WHERE 
    	ED.DESIGN_ID = #attributes.design_id#
</cfquery>
<cfquery name="GET_PROTOTIP" datasource="#dsn3#"> <!---Tasarım Özelleştirilebilir mi Kontrol Ediliyor--->
	SELECT        
        ERM.DESIGN_MAIN_NAME, 
        ED.DESIGN_NAME
	FROM            
    	EZGI_DESIGN_MAIN_ROW AS ERM INNER JOIN
      	EZGI_DESIGN AS ED ON ERM.DESIGN_ID = ED.DESIGN_ID
	WHERE        
    	ERM.DESIGN_MAIN_ROW_ID IN
                             	(
                                	SELECT        
                                    	MAIN_PROTOTIP_ID
                               		FROM            
                                 		EZGI_DESIGN_MAIN_ROW AS ERM
                               		WHERE        
                                    	DESIGN_ID = #attributes.design_id#
                               	) AND 
      	ERM.MAIN_PROTOTIP_ID IS NULL AND 
        ISNULL(ED.IS_PROTOTIP,0) = 0
</cfquery>
<cfif GET_PROTOTIP.recordcount>
	<script type="text/javascript">
		alert("<cfoutput query="GET_PROTOTIP">#DESIGN_MAIN_NAME# , </cfoutput><cfoutput>#getLang('objects',870)#</cfoutput>!");
		window.close()
	</script>
    <cfabort>
</cfif>
<cfquery name="GET_PROTOTIP" datasource="#dsn3#"> <!---Master Ürünler Özelleştirilebilir mi Kontrol Ediliyor--->
	SELECT        
    	S.PRODUCT_CODE, 
        S.PRODUCT_NAME
	FROM            
   		EZGI_DESIGN_MAIN_ROW AS ERM INNER JOIN
		STOCKS AS S ON ERM.DESIGN_MAIN_RELATED_ID = S.STOCK_ID
	WHERE        
    	ERM.DESIGN_MAIN_ROW_ID IN
                             	(
                                	SELECT        
                                    	MAIN_PROTOTIP_ID
                               		FROM            
                                    	EZGI_DESIGN_MAIN_ROW AS ERM
                               		WHERE        
                                    	DESIGN_ID = #attributes.design_id#
                              	) AND 
       	ERM.MAIN_PROTOTIP_ID IS NULL AND 
        ISNULL(S.IS_PROTOTYPE,0) = 0
</cfquery>
<cfif GET_PROTOTIP.recordcount>
	<script type="text/javascript">
		alert("<cfoutput query="GET_PROTOTIP">#PRODUCT_CODE# - #PRODUCT_NAME# , </cfoutput><cfoutput>#getLang('objects',870)#</cfoutput>!");
		window.close()
	</script>
    <cfabort>
</cfif>
<!---Design Sorgusu--->
<cfquery name="get_satirlar" datasource="#dsn3#">
	SELECT 
    	*
  	FROM
    	(
        SELECT        
            3 AS TYPE, 
            0 AS PIECE_TYPE, 
            EDR.DESIGN_MAIN_COLOR_ID AS COLOR_ID,
            EDR.DESIGN_MAIN_NAME AS DESIGN_ROW_NAME, 
            S.PRODUCT_NAME, 
            SM.SPECT_MAIN_NAME AS PRODUCT_CODE, 
            EDR.DESIGN_MAIN_ROW_ID AS IID, 
            S.STOCK_ID, 
            S.PRODUCT_STATUS,
            0 AS PARTNER_ID,
            SM.SPECT_MAIN_ID
        FROM            
          	EZGI_DESIGN_MAIN_ROW AS EDR LEFT OUTER JOIN
          	SPECT_MAIN AS SM ON EDR.MAIN_SPECT_RELATED_ID = SM.SPECT_MAIN_ID LEFT OUTER JOIN
         	STOCKS AS S ON EDR.DESIGN_MAIN_RELATED_ID = S.STOCK_ID
        WHERE        
            EDR.DESIGN_ID = #attributes.design_id#
            <cfif isdefined('attributes.design_main_row_id') and len(attributes.design_main_row_id)>
                AND EDR.DESIGN_MAIN_ROW_ID = #attributes.design_main_row_id#
            </cfif>
      	<cfif get_design_info.PROCESS_ID lte 2> <!---Modül + Paket--->
			UNION ALL
			SELECT        
				2 AS TYPE, 
				0 AS PIECE_TYPE, 
				EDP.PACKAGE_COLOR_ID AS COLOR_ID,
				EDP.PACKAGE_NAME AS DESIGN_ROW_NAME, 
				SM.SPECT_MAIN_NAME AS PRODUCT_NAME, 
				S.PRODUCT_CODE, 
				EDP.PACKAGE_ROW_ID AS IID, 
				S.STOCK_ID, 
				S.PRODUCT_STATUS,
                ISNULL(EDP.PACKAGE_PARTNER_ID,0) AS PARTNER_ID,
                SM.SPECT_MAIN_ID
			FROM            
				EZGI_DESIGN_PACKAGE AS EDP LEFT OUTER JOIN
             	SPECT_MAIN AS SM ON EDP.PACKAGE_SPECT_RELATED_ID = SM.SPECT_MAIN_ID LEFT OUTER JOIN
              	STOCKS AS S ON EDP.PACKAGE_RELATED_ID = S.STOCK_ID
			WHERE        
				EDP.DESIGN_ID = #attributes.design_id#
                <cfif isdefined('attributes.design_main_row_id') and len(attributes.design_main_row_id)>
                    AND EDP.DESIGN_MAIN_ROW_ID = #attributes.design_main_row_id#
                </cfif>
		</cfif>
        <cfif get_design_info.PROCESS_ID eq 1> <!---Modül + Paket + Parça--->
            UNION ALL
            SELECT        
                1 AS TYPE, 
                EDE.PIECE_TYPE, 
                EDE.PIECE_COLOR_ID AS COLOR_ID,
                EDE.PIECE_NAME AS DESIGN_ROW_NAME, 
                SM.SPECT_MAIN_NAME AS PRODUCT_NAME, 
                S.PRODUCT_CODE, 
                EDE.PIECE_ROW_ID AS IID, 
                S.STOCK_ID, 
                S.PRODUCT_STATUS,
                ISNULL(EDE.PACKAGE_PARTNER_ID,0) PARTNER_ID,
                SM.SPECT_MAIN_ID
            FROM            
             	EZGI_DESIGN_PIECE AS EDE LEFT OUTER JOIN
              	SPECT_MAIN AS SM ON EDE.PIECE_SPECT_RELATED_ID = SM.SPECT_MAIN_ID LEFT OUTER JOIN
            	STOCKS AS S ON EDE.PIECE_RELATED_ID = S.STOCK_ID
            WHERE        
                EDE.DESIGN_ID = #attributes.design_id# AND
                EDE.PIECE_TYPE <> 4
                <cfif isdefined('attributes.design_main_row_id') and len(attributes.design_main_row_id)>
                    AND EDE.DESIGN_MAIN_ROW_ID = #attributes.design_main_row_id#
                </cfif>
       	</cfif>
        ) AS TBL
 	ORDER BY
    	TYPE,
        PIECE_TYPE
</cfquery>
<cfform name="old_product" id="old_product" method="post" action="">
	<cfinput name="design_id" value="#attributes.design_id#" type="hidden">
    <cfif isdefined('attributes.design_main_row_id')>
    	<cfinput name="design_main_row_id" value="#attributes.design_main_row_id#" type="hidden">
    </cfif>
    <BR />
    <cf_big_list id="list_product_big_list">
        <thead>
            <tr>
                <th style="text-align:center; width:25px"><cf_get_lang_main no='1165.Sıra'></th>
                <th style="text-align:center; width:80px"><cfoutput>#getLang('main',245)# #getLang('report',216)#</cfoutput></th>
                <th style="text-align:center;"><cfoutput>#getLang('main',1995)# #getLang('main',245)# #getLang('main',485)#</cfoutput></th>
				<th style="text-align:center; width:20px"><cfoutput>#getLang('main',245)# #getLang('main',485)#</cfoutput></th>
               <!--- <th style="text-align:center; width:90px">Ürün Kodu</th>--->
                <!---<th style="text-align:center; width:120px"><cfoutput>#getLang('main',482)#</cfoutput></th>
                <th style="text-align:center; width:20px"><cfoutput>#getLang('main',70)#</cfoutput></th>--->
                <th style="text-align:center; width:20px"></th>
            </tr>
        </thead>
        <tbody>
        <cfif get_satirlar.recordcount>
        	<cfset is_transfer = 1>
        	<cfset urun_type = 0>
			<cfoutput query="get_satirlar">
            	<cfset hata = 0>
                <cfif type eq 1 and (PIECE_TYPE eq 1 or PIECE_TYPE eq 2 or PIECE_TYPE eq 3)> <!---Yarı Maül Parçalar Ürün Adı Tanımı--->
                	<cfif get_satirlar.COLOR_ID lte 0>
                    	<cfset urun_adi = "#get_design_info.DESIGN_NAME# #get_satirlar.DESIGN_ROW_NAME#" >
                    <cfelse>
            			<cfset urun_adi = "#get_design_info.DESIGN_NAME# #get_satirlar.DESIGN_ROW_NAME# (#Evaluate('COLOR_NAME_#get_satirlar.COLOR_ID#')#)">
                    </cfif>
               	<cfelse>
                	<cfset urun_adi = DESIGN_ROW_NAME>
                </cfif>
                <cfset RECETE_ADI = get_satirlar.PRODUCT_NAME>
                <cfset get_product_tree.recordcount =0>
                <cfinclude template="../query/cnt_ezgi_product_tree_import_ortak.cfm">
            	<cfif get_product_tree.recordcount> <!---Tasarımda Ağaç Yapılacak Satır Varsa--->
                	<cfif len(get_satirlar.SPECT_MAIN_ID)> <!---Tasarımdaki Ürün, Workcube Ürünle Bağlı mı--->
                    	<cfquery name="get_workcube_broduct_tree" datasource="#dsn3#">
                        	SELECT        
                            	ISNULL(STOCK_ID,0) AS RELATED_ID, 
                                ISNULL(OPERATION_TYPE_ID, 0) AS OPERATION_TYPE_ID, 
                                ISNULL(RELATED_MAIN_SPECT_ID,0) AS RELATED_MAIN_SPECT_ID,
                                AMOUNT
							FROM         
                            	SPECT_MAIN_ROW
							WHERE        
                            	SPECT_MAIN_ID = #get_satirlar.SPECT_MAIN_ID#
                     	</cfquery>
                        <cfif get_workcube_broduct_tree.recordcount eq get_product_tree.recordcount> <!---Tasarımla Ağaç Arasındaki Satır Sayısı Eşitse--->
                            <cfloop query="get_workcube_broduct_tree">
                                <cfset "TREE_#get_satirlar.TYPE#_#get_satirlar.IID#_#get_satirlar.PIECE_TYPE#_#get_workcube_broduct_tree.OPERATION_TYPE_ID#_#get_workcube_broduct_tree.RELATED_ID#_#get_workcube_broduct_tree.RELATED_MAIN_SPECT_ID#" = AMOUNT>
                            </cfloop>
                            <cfloop query="get_product_tree">
								<cfif isdefined("TREE_#get_satirlar.TYPE#_#get_satirlar.IID#_#get_satirlar.PIECE_TYPE#_#get_product_tree.OPERATION_TYPE_ID#_#get_product_tree.RELATED_ID#_#get_product_tree.SPECT_RELATED_ID#") and Round(Evaluate("TREE_#get_satirlar.TYPE#_#get_satirlar.IID#_#get_satirlar.PIECE_TYPE#_#get_product_tree.OPERATION_TYPE_ID#_#get_product_tree.RELATED_ID#_#get_product_tree.SPECT_RELATED_ID#")*100000000)/100000000 eq Round(amount*100000000)/100000000> <!---Tasarımla Ağaç Arasındaki Satır Miktarı Eşitse--->
                            		<cfset hata =0>
                            	<cfelse>
                                 	<cfset hata =1> <!---Tasarımla Ağaç Arasındaki Satır Miktarı Farklı--->
                                    <cfbreak>
                            	</cfif>
                            </cfloop>
                        <cfelse>
                            <cfset hata =2><!---Tasarımla Ağaç Arasındaki Satır Sayısı Farklı--->
                        </cfif>
                  	<cfelse>
                    	<cfset hata =3> <!---Tasarımdaki Ürün, Workcube Ürünle Bağlı Değil--->
                    </cfif>
             	<cfelse>
                    <cf_get_lang_main no='2972.Tasarımda Reçete Transferi Yapılacak Bilgi Yok'>
                    <cfdump var="#get_product_tree#">
                    <cfabort>
               	</cfif>
            	<cfif urun_type neq type>
                	<tr><td colspan="8" style="height:1mm">&nbsp;</td></tr>
                   	<cfset urun_type = type> 
                </cfif>
           		<tr id="row_#currentrow#">
               		<td style="text-align:center;" nowrap="nowrap">#currentrow#&nbsp;</td>
                  	<td style="text-align:left;" nowrap="nowrap">&nbsp;
                    	<cfif type eq 1>
                        	<cfif PIECE_TYPE eq 1>
                        		#getLang('main',2865)#
                          	<cfelseif PIECE_TYPE eq 2>
                            	#getLang('main',2157)# #getLang('prod',69)#
                          	<cfelseif PIECE_TYPE eq 3>
                            	#getLang('sales',255)# #getLang('prod',173)#
                          	<cfelseif PIECE_TYPE eq 4>
                            	#getLang('prod',132)#
                          	</cfif>
                        <cfelseif type eq 2>
                        	<cfset PIECE_TYPE eq 0>
                        	#getLang('main',2903)#
                        <cfelseif type eq 3>
                        	<cfset PIECE_TYPE eq 0>
                        	#getLang('main',2944)#
                        </cfif>
                    </td>
                	<td style="text-align:left;" nowrap="nowrap">&nbsp;#urun_adi#</td>
                    <!---<td style="text-align:left;" nowrap="nowrap">&nbsp;
                    	<cfif urun_adi neq RECETE_ADI>
                        	<span style="color:red"><strong>#RECETE_ADI#</strong></span>
                        <cfelse>
                    		#RECETE_ADI#
                        </cfif>
                   	</td>--->
                    <cfif partner_id eq 0>
						<cfif hata eq 1 or hata eq 2>
                            <cfset upd_type = 2><!---Ürün Reçetesi Farklı--->
                            
                            <!---<td style="text-align:center;" nowrap="nowrap"><span style="color:red"><strong><cfif hata eq 1>#getLang('main',1365)# #getLang('main',2973)#<cfelseif hata eq 2>#getLang('objects',1496)# #getLang('main',2973)#</cfif></strong></span></td>--->
                            <td style="text-align:center;" nowrap="nowrap">
                                <a href="javascript://" onClick="windowopen('#request.self#?fuseaction=prod.popup_dsp_ezgi_product_tree_import&upd_type=#upd_type#&type=#type#&piece_type=#piece_type#&IID=#IID#&stock_id=#get_satirlar.STOCK_ID#&design_id=#attributes.design_id#&urun_adi=#urun_adi#<cfif isdefined("attributes.design_main_row_id") and len(attributes.design_main_row_id)>&design_main_row_id=#attributes.design_main_row_id#</cfif>','wide');">
                                    <img src="images/control.gif" title="#getLang('main',2974)# #getLang('main',2973)#" />
                                </a>
                            </td>
                            <td style="text-align:center;" nowrap="nowrap">
                                <input type="checkbox" id="select_#type#_#IID#" name="select_#type#_#IID#" value="1" checked>
                                <cfinput name="iid_list" value="#get_satirlar.TYPE#_#get_satirlar.IID#" type="hidden">
                                <cfinput name="upd_type_#get_satirlar.TYPE#_#get_satirlar.IID#" value="#upd_type#" type="hidden">
                                <cfinput name="stock_id_#get_satirlar.TYPE#_#get_satirlar.IID#" value="#get_satirlar.STOCK_ID#" type="hidden">
                                <cfinput name="spect_main_id_#get_satirlar.TYPE#_#get_satirlar.IID#" value="#get_satirlar.SPECT_MAIN_ID#" type="hidden">
                            </td>
                        <cfelseif hata eq 3> 
                            <cfset upd_type = 1><!---Ürün Transferi Eksik--->
                            
                            <!---<td style="text-align:center;" nowrap="nowrap"><span style="color:red"><strong><cf_get_lang_main no='2975.Ürün Transferi Eksik'></strong></span></td>--->
                            <td style="text-align:center;" nowrap="nowrap">
                                <img src="images/control.gif" title="#getLang('main',2976)#" />
                            </td>
                            <td style="text-align:center;" nowrap="nowrap">
                                <input type="checkbox" id="select_#type#_#IID#" name="select_#type#_#IID#" value="1" checked>
                                <cfinput name="iid_list" value="#get_satirlar.TYPE#_#get_satirlar.IID#" type="hidden">
                                <cfinput name="upd_type_#get_satirlar.TYPE#_#get_satirlar.IID#" value="#upd_type#" type="hidden">
                                <cfinput name="stock_id_#get_satirlar.TYPE#_#get_satirlar.IID#" value="#get_satirlar.STOCK_ID#" type="hidden">
                                <cfinput name="spect_main_id_#get_satirlar.TYPE#_#get_satirlar.IID#" value="#get_satirlar.SPECT_MAIN_ID#" type="hidden">
                            </td>
                        <cfelse>
                            <cfif urun_adi neq RECETE_ADI> 
                                <cfset upd_type = 3><!---Ürün Adı Uyumsuz--->
                                
                                <!---<td style="text-align:center;" nowrap="nowrap"><span style="color:red"><strong>#getLang('main',809)# #getLang('main',2977)#</strong></span></td>--->
                                <td style="text-align:center;" nowrap="nowrap">
                                    <!---<img src="images/d_ok.gif" title="#getLang('main',809)# #getLang('main',2977)#" />--->
                                    <img src="images/c_ok.gif" title="" />
                                </td>
                                <td style="text-align:center;" nowrap="nowrap">
                                   <!--- <input type="checkbox" id="select_#type#_#IID#" name="select_#type#_#IID#" value="1">--->
                                    <cfinput name="iid_list" value="#get_satirlar.TYPE#_#get_satirlar.IID#" type="hidden">
                                    <cfinput name="upd_type_#get_satirlar.TYPE#_#get_satirlar.IID#" value="#upd_type#" type="hidden">
                                    <cfinput name="stock_id_#get_satirlar.TYPE#_#get_satirlar.IID#" value="#get_satirlar.STOCK_ID#" type="hidden">
                                    <cfinput name="spect_main_id_#get_satirlar.TYPE#_#get_satirlar.IID#" value="#get_satirlar.SPECT_MAIN_ID#" type="hidden">
                                    <cfinput name="urun_adi_#get_satirlar.TYPE#_#get_satirlar.IID#" value="#urun_adi#" type="hidden">
                                </td>
                            <cfelseif PRODUCT_STATUS neq 1> 
                                <cfset upd_type = 4><!---Ürün Pasif Edilmiş--->
                                
                                <!---<td style="text-align:center;" nowrap="nowrap"><span style="color:red"><strong>#getLang('main',2979)#</strong></span></td>--->
                                <td style="text-align:center;" nowrap="nowrap">
                                    <img src="images/d_ok.gif" title="#getLang('main',2979)#" />
                                </td>
                                <td style="text-align:center;" nowrap="nowrap">
                                    <input type="checkbox" id="select_#type#_#IID#" name="select_#type#_#IID#" value="1">
                                    <cfinput name="iid_list" value="#get_satirlar.TYPE#_#get_satirlar.IID#" type="hidden">
                                    <cfinput name="upd_type_#get_satirlar.TYPE#_#get_satirlar.IID#" value="#upd_type#" type="hidden">
                                    <cfinput name="stock_id_#get_satirlar.TYPE#_#get_satirlar.IID#" value="#get_satirlar.STOCK_ID#" type="hidden">
                                    <cfinput name="spect_main_id_#get_satirlar.TYPE#_#get_satirlar.IID#" value="#get_satirlar.SPECT_MAIN_ID#" type="hidden">
                                </td>
                            <cfelse>
                                <!---<td style="text-align:center;" nowrap="nowrap"><span style="color:green"><strong>#getLang('main',2978)#</strong></span></td>--->
                                <td style="text-align:center;" nowrap="nowrap"><img src="images/c_ok.gif" title="#getLang('main',2978)#" /></td>
                                <td style="text-align:center;" nowrap="nowrap"></td>
                            </cfif>
                        </cfif>
                  	<cfelse>
                    	<cfinput type="hidden" id="select_#type#_#IID#" name="select_#type#_#IID#" value="0">
                     	<cfinput name="iid_list" value="#get_satirlar.TYPE#_#get_satirlar.IID#" type="hidden">
                     	<cfinput name="upd_type_#get_satirlar.TYPE#_#get_satirlar.IID#" value="5" type="hidden">
                   		<cfinput name="stock_id_#get_satirlar.TYPE#_#get_satirlar.IID#" value="#get_satirlar.STOCK_ID#" type="hidden">
                  		<cfinput name="spect_main_id_#get_satirlar.TYPE#_#get_satirlar.IID#" value="#get_satirlar.SPECT_MAIN_ID#" type="hidden">
                    	<!---<td style="text-align:center;" nowrap="nowrap"><span style="color:green"><strong>#getLang('main',2978)#</strong></span></td>--->
                      	<td style="text-align:center;" nowrap="nowrap"><img src="images/c_ok.gif" title="#getLang('main',2978)#" /></td>
                       	<td style="text-align:center;" nowrap="nowrap"></td>
                    </cfif>
				</tr>
      		</cfoutput>
        	<tfoot>
            	<tr>
               		<td colspan="6" height="20" style="text-align:right">
                        <cf_workcube_buttons is_upd='1' is_delete='0' add_function='control_product_tree()' insert_info='#getLang('main',1371)# #getLang('main',52)#'>            
                  	</td>
            	</tr>
       		</tfoot>
    	<cfelse>
         	<tr> 
           		<td colspan="6" height="20"><cf_get_lang_main no='72.Kayıt Yok'>!</td>
          	</tr>
     	</cfif>
        </tbody>
    </cf_big_list>
</cfform>

<script language="javascript">
	function control_product_tree()
	{
		document.getElementById("old_product").action = "<cfoutput>#request.self#</cfoutput>?fuseaction=prod.emptypopup_cnt_ezgi_import_private_creative_workcube";
		document.getElementById("old_product").submit();
		return true;
	}
</script>



