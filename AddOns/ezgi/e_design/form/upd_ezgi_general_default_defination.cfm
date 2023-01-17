<cfquery name="get_defaults" datasource="#dsn3#">
	SELECT * FROM EZGI_DESIGN_DEFAULTS
</cfquery>
<cfquery name="get_upd" datasource="#dsn3#">
	SELECT * FROM EZGI_COLORS
</cfquery>
<cfquery name="get_thickness" datasource="#dsn3#">
	SELECT THICKNESS_ID, THICKNESS_VALUE, THICKNESS_NAME, UNIT, THICKNESS_PLUS_VALUE FROM EZGI_THICKNESS WHERE IS_ACTIVE = 1 ORDER BY THICKNESS_NAME
</cfquery>
<cfquery name="get_thickness_ext" datasource="#dsn3#">
	SELECT THICKNESS_ID, THICKNESS_VALUE, THICKNESS_PRODUCT_NAME, UNIT FROM EZGI_THICKNESS_EXT WHERE IS_ACTIVE = 1 ORDER BY THICKNESS_NAME
</cfquery>
<cfif get_defaults.recordcount>
	<cfif len(get_defaults.DEFAULT_PACKAGE_CAT_ID)>
        <cfquery name="get_package_product_cat" datasource="#dsn1#">
            SELECT PRODUCT_CATID, HIERARCHY PRODUCT_CAT_CODE, PRODUCT_CAT FROM PRODUCT_CAT WHERE PRODUCT_CATID = #get_defaults.DEFAULT_PACKAGE_CAT_ID#
        </cfquery>
    </cfif>
    <cfif len(get_defaults.DEFAULT_PIECE_CAT_ID)>
        <cfquery name="get_piece_product_cat" datasource="#dsn1#">
            SELECT PRODUCT_CATID, HIERARCHY PRODUCT_CAT_CODE, PRODUCT_CAT FROM PRODUCT_CAT WHERE PRODUCT_CATID = #get_defaults.DEFAULT_PIECE_CAT_ID#
        </cfquery>
    </cfif>
    <cfif len(get_defaults.DEFAULT_MASTER_PVC_STOCK_ID)>
        <cfquery name="get_stock_info" datasource="#dsn3#">
            SELECT STOCK_ID, PRODUCT_ID, PRODUCT_NAME FROM STOCKS WHERE STOCK_ID = #get_defaults.DEFAULT_MASTER_PVC_STOCK_ID#
        </cfquery>
    </cfif>
    <cfif len(get_defaults.PIECE_STOCK_ID_1)>
        <cfquery name="get_stock_info_piece_1" datasource="#dsn3#">
            SELECT STOCK_ID, PRODUCT_ID, PRODUCT_NAME FROM STOCKS WHERE STOCK_ID = #get_defaults.PIECE_STOCK_ID_1#
        </cfquery>
    </cfif>
    <cfif len(get_defaults.PIECE_STOCK_ID_2)>
        <cfquery name="get_stock_info_piece_2" datasource="#dsn3#">
            SELECT STOCK_ID, PRODUCT_ID, PRODUCT_NAME FROM STOCKS WHERE STOCK_ID = #get_defaults.PIECE_STOCK_ID_2#
        </cfquery>
    </cfif>
    <cfif len(get_defaults.PIECE_STOCK_ID_3)>
        <cfquery name="get_stock_info_piece_3" datasource="#dsn3#">
            SELECT STOCK_ID, PRODUCT_ID, PRODUCT_NAME FROM STOCKS WHERE STOCK_ID = #get_defaults.PIECE_STOCK_ID_3#
        </cfquery>
    </cfif>
    <cfif len(get_defaults.PIECE_STOCK_ID_4)>
        <cfquery name="get_stock_info_piece_4" datasource="#dsn3#">
            SELECT STOCK_ID, PRODUCT_ID, PRODUCT_NAME FROM STOCKS WHERE STOCK_ID = #get_defaults.PIECE_STOCK_ID_4#
        </cfquery>
    </cfif>
    <cfif len(get_defaults.PIECE_STOCK_ID_5)>
        <cfquery name="get_stock_info_piece_5" datasource="#dsn3#">
            SELECT STOCK_ID, PRODUCT_ID, PRODUCT_NAME FROM STOCKS WHERE STOCK_ID = #get_defaults.PIECE_STOCK_ID_5#
        </cfquery>
    </cfif>
    <cfif len(get_defaults.package_STOCK_ID_1)>
        <cfquery name="get_stock_info_package_1" datasource="#dsn3#">
            SELECT STOCK_ID, PRODUCT_ID, PRODUCT_NAME FROM STOCKS WHERE STOCK_ID = #get_defaults.package_STOCK_ID_1#
        </cfquery>
    </cfif>
    <cfif len(get_defaults.package_STOCK_ID_2)>
        <cfquery name="get_stock_info_package_2" datasource="#dsn3#">
            SELECT STOCK_ID, PRODUCT_ID, PRODUCT_NAME FROM STOCKS WHERE STOCK_ID = #get_defaults.package_STOCK_ID_2#
        </cfquery>
    </cfif>
    <cfif len(get_defaults.package_STOCK_ID_3)>
        <cfquery name="get_stock_info_package_3" datasource="#dsn3#">
            SELECT STOCK_ID, PRODUCT_ID, PRODUCT_NAME FROM STOCKS WHERE STOCK_ID = #get_defaults.package_STOCK_ID_3#
        </cfquery>
    </cfif>
    <cfif len(get_defaults.package_STOCK_ID_4)>
        <cfquery name="get_stock_info_package_4" datasource="#dsn3#">
            SELECT STOCK_ID, PRODUCT_ID, PRODUCT_NAME FROM STOCKS WHERE STOCK_ID = #get_defaults.package_STOCK_ID_4#
        </cfquery>
    </cfif>
    <cfif len(get_defaults.package_STOCK_ID_5)>
        <cfquery name="get_stock_info_package_5" datasource="#dsn3#">
            SELECT STOCK_ID, PRODUCT_ID, PRODUCT_NAME FROM STOCKS WHERE STOCK_ID = #get_defaults.package_STOCK_ID_5#
        </cfquery>
    </cfif>
<cfelse>
	<cfset get_package_product_cat.product_cat = ''>
    <cfset get_package_product_cat.product_catid = ''>
    <cfset get_piece_product_cat.product_cat = ''>
    <cfset get_piece_product_cat.product_catid = ''>
</cfif>
<cfquery name="get_product_stage" datasource="#dsn#">
	SELECT 
    	R.PROCESS_ROW_ID, R.STAGE 
   	FROM 
    	PROCESS_TYPE AS P INNER JOIN PROCESS_TYPE_ROWS AS R ON P.PROCESS_ID = R.PROCESS_ID 
  	WHERE        
    	P.IS_ACTIVE = 1 AND P.FACTION LIKE N'%product.form_upd_product%'
</cfquery>
<cfquery name="get_product_tree_stage" datasource="#dsn#">
	SELECT 
    	R.PROCESS_ROW_ID, R.STAGE 
   	FROM 
    	PROCESS_TYPE AS P INNER JOIN PROCESS_TYPE_ROWS AS R ON P.PROCESS_ID = R.PROCESS_ID 
  	WHERE        
    	P.IS_ACTIVE = 1 AND P.FACTION LIKE N'%prod.add_product_tree%'
</cfquery>
<cfquery name="get_unit" datasource="#dsn#">
	SELECT UNIT FROM SETUP_UNIT ORDER BY UNIT
</cfquery>
<cfquery name="get_product_account_cat" datasource="#dsn3#">
	SELECT PRO_CODE_CATID, PRO_CODE_CAT_NAME FROM SETUP_PRODUCT_PERIOD_CAT WHERE IS_ACTIVE = 1
</cfquery>
<cfquery name="get_ws" datasource="#dsn3#">
	SELECT STATION_ID, STATION_NAME FROM WORKSTATIONS WHERE UP_STATION IS NULL
</cfquery>
<cfquery name="get_operation" datasource="#dsn3#">
	SELECT OPERATION_TYPE_ID, OPERATION_TYPE FROM OPERATION_TYPES
</cfquery>
<cfquery name="get_property" datasource="#dsn1#">
	SELECT PROPERTY_ID, PROPERTY FROM PRODUCT_PROPERTY
</cfquery>
<cfquery name="get_model" datasource="#dsn1#">
	SELECT MODEL_ID, MODEL_NAME FROM PRODUCT_BRANDS_MODEL
</cfquery>
<cfquery name="get_plus_name" datasource="#dsn3#">
	SELECT * FROM SETUP_PRO_INFO_PLUS_NAMES WHERE OWNER_TYPE_ID = - 6
</cfquery>
<cfset property_list =''>
<cfloop from="1" to="20" index="i">
	<cfif len(Evaluate('get_plus_name.PROPERTY#i#_NAME'))>
    	<cfset property_list = ListAppend(property_list,i)>
    </cfif>
</cfloop>
<table width="98%" border="0" cellspacing="0" cellpadding="0" align="center">
	<tr>
    	<td height="35" class="headbold"><cf_get_lang_main no='2917.Tasarım Genel Default Tanımları'></td>
	</tr>
</table>
<table width="98%" border="0" cellspacing="1" cellpadding="2" class="color-border" align="center">
    <cfform name="add_defaults" method="post" action="#request.self#?fuseaction=prod.emptypopup_upd_ezgi_general_default_defination">
        <tr class="color-row">
            <cfoutput>
            <td valign="top" width="25%">
            	<table width="100%">
					<tr height="30">
						<td colspan="2" class="txtboldblue"><cf_get_lang_main no='2908.Tasarım Tanımları'></td>
                  	</tr>
                    <tr height="20">
                        <td width="140"><cf_get_lang_main no='2918.Yonga Levha Kalınlığı'></td>
                        <td>
                        	<select name="default_thickness" id="default_thickness" style="width:75px">
                            	 <option value=""><cf_get_lang_main no='322.Seçiniz'></option>
                                <cfloop query="get_thickness">
                                    <option value="#thickness_id#"  <cfif get_thickness.thickness_id eq get_defaults.DEFAULT_YONGA_LEVHA_THICKNESS>selected="selected"</cfif>>#THICKNESS_VALUE# #UNIT#</option>
                                </cfloop>
                            </select>
                        </td>
              		</tr>
                    <tr height="20">
                        <td><cfoutput>#getLang('main',2865)# #getLang('prod',44)#</cfoutput> %</td>
                        <td>
                        	<cfinput type="text" name="default_fire_rate" id="default_fire_rate" value="#get_defaults.DEFAULT_YONGA_LEVHA_FIRE_RATE#" style="width:75px; text-align:right">
                        </td>
              		</tr>
                    <tr height="20">
                        <td><cf_get_lang_main no='2919.PVC Kalınlığı'></td>
                        <td>
                        	<select name="pvc_default_thickness" id="pvc_default_thickness" style="width:75px">
                            	 <option value=""><cf_get_lang_main no='322.Seçiniz'></option>
                                <cfloop query="get_thickness_ext">
                                    <option value="#thickness_id#"  <cfif get_thickness_ext.thickness_id eq get_defaults.DEFAULT_PVC_THICKNESS>selected="selected"</cfif>>#TlFormat(THICKNESS_VALUE,1)# #UNIT#</option>
                                </cfloop>
                            </select>
                        </td>
              		</tr>
                    <tr height="20">
                        <td>PVC <cfoutput>#getLang('report',420)#</cfoutput> (mm.)</td>
                        <td>
                        	<cfinput type="text" name="pvc_default_fire_rate" id="pvc_default_fire_rate" value="#get_defaults.DEFAULT_PVC_FIRE_AMOUNT#" style="width:75px; text-align:right">
                        </td>
              		</tr>
                    <tr height="20">
                        <td>PVC <cf_get_lang_main no='2915.Master Ürün'></td>
                        <td>
                        	<input type="text" name="urun" id="urun" style="width:150px;" value="<cfoutput><cfif len(get_defaults.DEFAULT_MASTER_PVC_STOCK_ID)>#get_stock_info.PRODUCT_NAME#</cfif></cfoutput>">
                           	<input type="hidden" name="pid" id="pid" value="<cfoutput><cfif len(get_defaults.DEFAULT_MASTER_PVC_STOCK_ID)>#get_stock_info.PRODUCT_ID#</cfif></cfoutput>">
                          	<input type="hidden" name="stock_id" id="stock_id" value="<cfoutput><cfif len(get_defaults.DEFAULT_MASTER_PVC_STOCK_ID)>#get_stock_info.STOCK_ID#</cfif></cfoutput>">
                          	<a style="cursor:pointer" href"javascript://" onClick="pencere_ac();">
                             	<img src="/images/plus_thin.gif" align="absmiddle" border="0" style="vertical-align:bottom">
                          	</a>
                        </td>
              		</tr>
                    <tr height="20">
                        <td ><cfoutput>#getLang('main',2915)# #getLang('main',813)# #getLang('objects',256)#</cfoutput></td>
                        <td>
							<select name="master_model_id" id="master_model_id" style="width:150px">
                            	 <option value=""><cf_get_lang_main no='322.Seçiniz'></option>
                                <cfloop query="get_model">
                                    <option value="#MODEL_ID#"  <cfif MODEL_ID eq get_defaults.DEFAULT_MASTER_SHORT_CODE_ID>selected="selected"</cfif>>#MODEL_NAME#</option>
                                </cfloop>
                            </select>
                        </td>
              		</tr>
                    <tr height="20">
                        <td><cfoutput>#getLang('settings',1133)# #getLang('main',2848)# #getLang('product',154)#</cfoutput></td>
                        <td>
                        	 <select name="piece_type" id="piece_type" style="width:170px" >
                             	<option value="1" <cfif get_defaults.DEFAULT_PIECE_TYPE eq 1>selected</cfif>>01-<cfoutput>#getLang('main',2865)# #getLang('report',1688)# #getLang('main',2610)#</cfoutput></option>
                             	<option value="2" <cfif get_defaults.DEFAULT_PIECE_TYPE eq 2>selected</cfif>>02-<cfoutput>#getLang('main',2157)# #getLang('report',1688)# #getLang('main',2610)#</cfoutput></option>
                            	<option value="3" <cfif get_defaults.DEFAULT_PIECE_TYPE eq 3>selected</cfif>>03-<cfoutput>#getLang('main',2877)#</cfoutput></option>
                             	<option value="4" <cfif get_defaults.DEFAULT_PIECE_TYPE eq 4>selected</cfif>>04-<cfoutput>#getLang('prod',132)# #getLang('main',170)#</cfoutput></option>
                        	</select>
                        </td>
              		</tr>
                    <tr height="20">
                        <td><cf_get_lang_main no='2865.Yonga Levha'> <cf_get_lang_main no='2893.Tıraşlama'></td>
                        <td>
                        	 <select name="trim_type" id="trim_type" style="width:170px" >
                             	<option value="0" <cfif get_defaults.DEFAULT_TRIM_TYPE eq 0>selected</cfif>><cf_get_lang_main no='2892.Tıraşlama Yok'></option>
                             	<option value="1" <cfif get_defaults.DEFAULT_TRIM_TYPE eq 1>selected</cfif>><cf_get_lang_main no='3622.Kenar Bantlama Varsa'></option>
                                <option value="2" <cfif get_defaults.DEFAULT_TRIM_TYPE eq 2>selected</cfif>><cf_get_lang_main no='3620.Tüm Kenarları Traşlama'></option>
                                <option value="3" <cfif get_defaults.DEFAULT_TRIM_TYPE eq 3>selected</cfif>><cf_get_lang_main no='3621.Kenar Seçmeli Traşlama'></option>
                        	</select>
                        </td>
              		</tr>
              		</tr>
                    <tr height="20">
                        <td><cf_get_lang_main no='2889.Tıraşlama Payı'> (mm.)</td>
                        <td>
                        	<cfinput type="text" name="trim_size" id="trim_size" value="#TlFormat(get_defaults.DEFAULT_TRIM_AMOUNT,1)#" style="width:75px; text-align:right">
                        </td>
              		</tr>
                    <tr height="20">
                        <td><cfoutput>#getLang('main',2157)# #getLang('prod',185)#</cfoutput></td>
                        <td>
                        	<cfinput type="text" name="product_amount" id="product_amount" value="#TlFormat(get_defaults.DEFAULT_PRODUCTION_AMOUNT,0)#" style="width:75px; text-align:right">
                        </td>
              		</tr>
                    <tr height="20">
                        <td><cf_get_lang_main no='2920.Süre Gösterim Bilgisi'></td>
                        <td>
                        	 <select name="time_type" id="time_type" style="width:75px" >
                             	<option value="0" <cfif get_defaults.DEFAULT_IS_STATION_OR_IS_OPERATION eq 0>selected</cfif>><cf_get_lang_main no='1622.Operasyon'></option>
                             	<option value="1" <cfif get_defaults.DEFAULT_IS_STATION_OR_IS_OPERATION eq 1>selected</cfif>><cf_get_lang_main no='1422.İstasyon'></option>
                        	</select>
                        </td>
              		</tr>
                    <tr height="20">
                        <td><cfoutput>#getLang('main',1045)# #getLang('hr',792)#</cfoutput></td>
                        <td>
                        	 <cfinput type="text" name="daily_working_time" id="daily_working_time" value="#TlFormat(get_defaults.DEFAULT_DAILY_WORKING_TIME,2)#" style="width:75px; text-align:right">(<cf_get_lang_main no='79.Saat'>)
                        </td>
              		</tr>
                    <tr height="20">
                        <td><cf_get_lang_main no='81.Aktif'> <cf_get_lang_main no='2921.Operatör Sayısı'> </td>
                        <td>
                        	 <cfinput type="text" name="active_operator_amount" id="active_operator_amount" value="#TlFormat(get_defaults.DEFAULT_ACTIVE_OPERATOR_AMOUNT,0)#" style="width:75px; text-align:right">
                        </td>
              		</tr>
                    <tr height="30">
						<td colspan="2" class="txtboldblue"><cf_get_lang_main no='2922.Tasarım Default Renk Tanım Bilgisi'> </td>
                  	</tr>
                    <tr height="20">
                        <td><cf_get_lang_main no='2923.Renk Özellik Tanımı'></td>
                        <td>
                        	<select name="color_property_id" id="color_property_id" style="width:125px">
                            	 <option value=""><cf_get_lang_main no='322.Seçiniz'></option>
                                <cfloop query="get_property">
                                    <option value="#property_id#"  <cfif property_id eq get_defaults.DEFAULT_COLOR_PROPERTY_ID>selected="selected"</cfif>>#property#</option>
                                </cfloop>
                            </select>
                        </td>
              		</tr>
                    <tr height="20">
                        <td><cf_get_lang_main no='2924.Kalınlık Özellik Tanımı'></td>
                        <td>
                        	<select name="thickness_property_id" id="thickness_property_id" style="width:125px">
                            	 <option value=""><cf_get_lang_main no='322.Seçiniz'></option>
                                <cfloop query="get_property">
                                    <option value="#property_id#"  <cfif property_id eq get_defaults.DEFAULT_THICKNESS_PROPERTY_ID>selected="selected"</cfif>>#property#</option>
                                </cfloop>
                            </select>
                        </td>
              		</tr>
                    <tr height="20">
                        <td><cf_get_lang_main no='2925.Kal.Etkisi Özellik Tanımı'></td>
                        <td>
                        	<select name="thickness_ext_property_id" id="thickness_ext_property_id" style="width:125px">
                            	 <option value=""><cf_get_lang_main no='322.Seçiniz'></option>
                                <cfloop query="get_property">
                                    <option value="#property_id#"  <cfif property_id eq get_defaults.DEFAULT_THICKNESS_EXT_PROPERTY_ID>selected="selected"</cfif>>#property#</option>
                                </cfloop>
                            </select>
                        </td>
              		</tr>
             	</table>
            </td>
            <td valign="top" width="25%">
            	<div id="piece_" style="width:100%">
                <cf_seperator title="#getLang('main',2926)#" id="_piece" is_closed="1">
                	<br />
                    <cf_form_list id="_piece">
                    <thead>
                        <tr height="20">
                            <th width="10px"><cfoutput>#getLang('main',1165)#</cfoutput></th>
                            <th width="180px"><cfoutput>#getLang('main',40)# #getLang('report',211)#</cfoutput></th>
                            <th width="130px"><cfoutput>#getLang('main',616)#</cfoutput></th>
                        </tr>
                    </thead>
                    <tbody name="piece" id="piece">
                        <tr height="20">
                           	<td style="text-align:right">1-</td>
                          	<td nowrap="nowrap">
                                <input type="text" name="urun_piece_1" id="urun_piece_1" style="width:140px;" value="<cfoutput><cfif len(get_defaults.PIECE_STOCK_ID_1)>#get_stock_info_piece_1.PRODUCT_NAME#</cfif></cfoutput>">
                                <input type="hidden" name="pid_piece_1" id="pid_piece_1" value="<cfoutput><cfif len(get_defaults.PIECE_STOCK_ID_1)>#get_stock_info_piece_1.PRODUCT_ID#</cfif></cfoutput>">
                                <input type="hidden" name="stock_id_piece_1" id="stock_id_piece_1" value="<cfoutput><cfif len(get_defaults.PIECE_STOCK_ID_1)>#get_defaults.PIECE_STOCK_ID_1#</cfif></cfoutput>">
                                <a style="cursor:pointer" href"javascript://" onClick="pencere_ac_piece_1();">
                                    <img src="/images/plus_thin.gif" align="absmiddle" border="0" style="vertical-align:bottom">
                                </a>
                            </td>
                            <td nowrap="nowrap">
                            	<input type="text" name="piece_formul_1" id="piece_formul_1" style="width:110px;" value="<cfoutput><cfif len(get_defaults.PIECE_FORMUL_1)>#get_defaults.PIECE_FORMUL_1#</cfif></cfoutput>">
                            </td>
                        </tr>
                        <tr height="20">
                           	<td style="text-align:right">2-</td>
                          	<td>
                                <input type="text" name="urun_piece_2" id="urun_piece_2" style="width:140px;" value="<cfoutput><cfif len(get_defaults.PIECE_STOCK_ID_2)>#get_stock_info_piece_2.PRODUCT_NAME#</cfif></cfoutput>">
                                <input type="hidden" name="pid_piece_2" id="pid_piece_2" value="<cfoutput><cfif len(get_defaults.PIECE_STOCK_ID_2)>#get_stock_info_piece_2.PRODUCT_ID#</cfif></cfoutput>">
                                <input type="hidden" name="stock_id_piece_2" id="stock_id_piece_2" value="<cfoutput><cfif len(get_defaults.PIECE_STOCK_ID_2)>#get_defaults.PIECE_STOCK_ID_2#</cfif></cfoutput>">
                                <a style="cursor:pointer" href"javascript://" onClick="pencere_ac_piece_2();">
                                    <img src="/images/plus_thin.gif" align="absmiddle" border="0" style="vertical-align:bottom">
                                </a>
                            </td>
                            <td>
                            	<input type="text" name="piece_formul_2" id="piece_formul_2" style="width:110px;" value="<cfoutput><cfif len(get_defaults.PIECE_FORMUL_2)>#get_defaults.PIECE_FORMUL_2#</cfif></cfoutput>">
                            </td>
                        </tr>
                        <tr height="20">
                           	<td style="text-align:right">3-</td>
                          	<td>
                                <input type="text" name="urun_piece_3" id="urun_piece_3" style="width:140px;" value="<cfoutput><cfif len(get_defaults.PIECE_STOCK_ID_3)>#get_stock_info_piece_3.PRODUCT_NAME#</cfif></cfoutput>">
                                <input type="hidden" name="pid_piece_3" id="pid_piece_3" value="<cfoutput><cfif len(get_defaults.PIECE_STOCK_ID_3)>#get_stock_info_piece_3.PRODUCT_ID#</cfif></cfoutput>">
                                <input type="hidden" name="stock_id_piece_3" id="stock_id_piece_3" value="<cfoutput><cfif len(get_defaults.PIECE_STOCK_ID_3)>#get_defaults.PIECE_STOCK_ID_3#</cfif></cfoutput>">
                                <a style="cursor:pointer" href"javascript://" onClick="pencere_ac_piece_3();">
                                    <img src="/images/plus_thin.gif" align="absmiddle" border="0" style="vertical-align:bottom">
                                </a>
                            </td>
                            <td>
                            	<input type="text" name="piece_formul_3" id="piece_formul_3" style="width:110px;" value="<cfoutput><cfif len(get_defaults.PIECE_FORMUL_3)>#get_defaults.PIECE_FORMUL_3#</cfif></cfoutput>">
                            </td>
                        </tr>
                        <tr height="20">
                           	<td style="text-align:right">4-</td>
                          	<td>
                                <input type="text" name="urun_piece_4" id="urun_piece_4" style="width:140px;" value="<cfoutput><cfif len(get_defaults.PIECE_STOCK_ID_4)>#get_stock_info_piece_4.PRODUCT_NAME#</cfif></cfoutput>">
                                <input type="hidden" name="pid_piece_4" id="pid_piece_4" value="<cfoutput><cfif len(get_defaults.PIECE_STOCK_ID_4)>#get_stock_info_piece_4.PRODCUT_ID#</cfif></cfoutput>">
                                <input type="hidden" name="stock_id_piece_4" id="stock_id_piece_4" value="<cfoutput><cfif len(get_defaults.PIECE_STOCK_ID_4)>#get_defaults.PIECE_STOCK_ID_4#</cfif></cfoutput>">
                                <a style="cursor:pointer" href"javascript://" onClick="pencere_ac_piece_4();">
                                    <img src="/images/plus_thin.gif" align="absmiddle" border="0" style="vertical-align:bottom">
                                </a>
                            </td>
                            <td>
                            	<input type="text" name="piece_formul_4" id="piece_formul_4" style="width:110px;" value="<cfoutput><cfif len(get_defaults.PIECE_FORMUL_4)>#get_defaults.PIECE_FORMUL_4#</cfif></cfoutput>">
                            </td>
                        </tr>
                        <tr height="20">
                           	<td style="text-align:right">5-</td>
                          	<td>
                                <input type="text" name="urun_piece_5" id="urun_piece_5" style="width:140px;" value="<cfoutput><cfif len(get_defaults.PIECE_STOCK_ID_5)>#get_stock_info_piece_5.PRODUCT_NAME#</cfif></cfoutput>">
                                <input type="hidden" name="pid_piece_5" id="pid_piece_5" value="<cfoutput><cfif len(get_defaults.PIECE_STOCK_ID_5)>#get_stock_info_piece_5.PRODUCT_ID#</cfif></cfoutput>">
                                <input type="hidden" name="stock_id_piece_5" id="stock_id_piece_5" value="<cfoutput><cfif len(get_defaults.PIECE_STOCK_ID_5)>#get_defaults.PIECE_STOCK_ID_5#</cfif></cfoutput>">
                                <a style="cursor:pointer" href"javascript://" onClick="pencere_ac_piece_5();">
                                    <img src="/images/plus_thin.gif" align="absmiddle" border="0" style="vertical-align:bottom">
                                </a>
                            </td>
                            <td>
                            	<input type="text" name="piece_formul_5" id="piece_formul_5" style="width:110px;" value="<cfoutput><cfif len(get_defaults.PIECE_FORMUL_5)>#get_defaults.PIECE_FORMUL_5#</cfif></cfoutput>">
                            </td>
                        </tr>
                    </tbody>
                </cf_form_list>
            	</div>
                <div id="package_" style="width:100%">
                <cf_seperator title="#getLang('main',2927)#" id="_package" is_closed="1">
                	<br />
                    <cf_form_list id="_package">
                    <thead>
                        <tr height="20">
                            <th width="10"><cfoutput>#getLang('main',1165)#</cfoutput></th>
                            <th width="180"><cfoutput>#getLang('main',40)# #getLang('report',211)#</cfoutput></th>
                            <th width="130"><cfoutput>#getLang('main',616)#</cfoutput></th>
                        </tr>
                    </thead>
                    <tbody name="package" id="package">
                        <tr height="20">
                           	<td style="text-align:right">1-</td>
                          	<td>
                                <input type="text" name="urun_package_1" id="urun_package_1" style="width:140px;" value="<cfoutput><cfif len(get_defaults.package_STOCK_ID_1)>#get_stock_info_package_1.PRODUCT_NAME#</cfif></cfoutput>">
                                <input type="hidden" name="pid_package_1" id="pid_package_1" value="<cfoutput><cfif len(get_defaults.package_STOCK_ID_1)>#get_stock_info_package_1.PRODUCT_ID#</cfif></cfoutput>">
                                <input type="hidden" name="stock_id_package_1" id="stock_id_package_1" value="<cfoutput><cfif len(get_defaults.package_STOCK_ID_1)>#get_defaults.package_STOCK_ID_1#</cfif></cfoutput>">
                                <a style="cursor:pointer" href"javascript://" onClick="pencere_ac_package_1();">
                                    <img src="/images/plus_thin.gif" align="absmiddle" border="0" style="vertical-align:bottom">
                                </a>
                            </td>
                            <td>
                            	<input type="text" name="package_formul_1" id="package_formul_1" style="width:110px;" value="<cfoutput><cfif len(get_defaults.package_FORMUL_1)>#get_defaults.package_FORMUL_1#</cfif></cfoutput>">
                            </td>
                        </tr>
                        <tr height="20">
                           	<td style="text-align:right">2-</td>
                          	<td>
                                <input type="text" name="urun_package_2" id="urun_package_2" style="width:140px;" value="<cfoutput><cfif len(get_defaults.package_STOCK_ID_2)>#get_stock_info_package_2.PRODUCT_NAME#</cfif></cfoutput>">
                                <input type="hidden" name="pid_package_2" id="pid_package_2" value="<cfoutput><cfif len(get_defaults.package_STOCK_ID_2)>#get_stock_info_package_2.PRODUCT_ID#</cfif></cfoutput>">
                                <input type="hidden" name="stock_id_package_2" id="stock_id_package_2" value="<cfoutput><cfif len(get_defaults.package_STOCK_ID_2)>#get_defaults.package_STOCK_ID_2#</cfif></cfoutput>">
                                <a style="cursor:pointer" href"javascript://" onClick="pencere_ac_package_2();">
                                    <img src="/images/plus_thin.gif" align="absmiddle" border="0" style="vertical-align:bottom">
                                </a>
                            </td>
                            <td>
                            	<input type="text" name="package_formul_2" id="package_formul_2" style="width:110px;" value="<cfoutput><cfif len(get_defaults.package_FORMUL_2)>#get_defaults.package_FORMUL_2#</cfif></cfoutput>">
                            </td>
                        </tr>
                        <tr height="20">
                           	<td style="text-align:right">3-</td>
                          	<td>
                                <input type="text" name="urun_package_3" id="urun_package_3" style="width:140px;" value="<cfoutput><cfif len(get_defaults.package_STOCK_ID_3)>#get_stock_info_package_3.PRODUCT_NAME#</cfif></cfoutput>">
                                <input type="hidden" name="pid_package_3" id="pid_package_3" value="<cfoutput><cfif len(get_defaults.package_STOCK_ID_3)>#get_stock_info_package_3.PRODUCT_ID#</cfif></cfoutput>">
                                <input type="hidden" name="stock_id_package_3" id="stock_id_package_3" value="<cfoutput><cfif len(get_defaults.package_STOCK_ID_3)>#get_defaults.package_STOCK_ID_3#</cfif></cfoutput>">
                                <a style="cursor:pointer" href"javascript://" onClick="pencere_ac_package_3();">
                                    <img src="/images/plus_thin.gif" align="absmiddle" border="0" style="vertical-align:bottom">
                                </a>
                            </td>
                            <td>
                            	<input type="text" name="package_formul_3" id="package_formul_3" style="width:110px;" value="<cfoutput><cfif len(get_defaults.package_FORMUL_3)>#get_defaults.package_FORMUL_3#</cfif></cfoutput>">
                            </td>
                        </tr>
                        <tr height="20">
                           	<td style="text-align:right">4-</td>
                          	<td>
                                <input type="text" name="urun_package_4" id="urun_package_4" style="width:140px;" value="<cfoutput><cfif len(get_defaults.package_STOCK_ID_4)>#get_stock_info_package_4.PRODUCT_NAME#</cfif></cfoutput>">
                                <input type="hidden" name="pid_package_4" id="pid_package_4" value="<cfoutput><cfif len(get_defaults.package_STOCK_ID_4)>#get_stock_info_package_4.PRODUCT_ID#</cfif></cfoutput>">
                                <input type="hidden" name="stock_id_package_4" id="stock_id_package_4" value="<cfoutput><cfif len(get_defaults.package_STOCK_ID_4)>#get_defaults.package_STOCK_ID_4#</cfif></cfoutput>">
                                <a style="cursor:pointer" href"javascript://" onClick="pencere_ac_package_4();">
                                    <img src="/images/plus_thin.gif" align="absmiddle" border="0" style="vertical-align:bottom">
                                </a>
                            </td>
                            <td>
                            	<input type="text" name="package_formul_4" id="package_formul_4" style="width:110px;" value="<cfoutput><cfif len(get_defaults.package_FORMUL_4)>#get_defaults.package_FORMUL_4#</cfif></cfoutput>">
                            </td>
                        </tr>
                        <tr height="20">
                           	<td style="text-align:right">5-</td>
                          	<td>
                                <input type="text" name="urun_package_5" id="urun_package_5" style="width:140px;" value="<cfoutput><cfif len(get_defaults.package_STOCK_ID_5)>#get_stock_info_package_5.PRODUCT_NAME#</cfif></cfoutput>">
                                <input type="hidden" name="pid_package_5" id="pid_package_5" value="<cfoutput><cfif len(get_defaults.package_STOCK_ID_5)>#get_stock_info_package_5.PRODUCT_ID#</cfif></cfoutput>">
                                <input type="hidden" name="stock_id_package_5" id="stock_id_package_5" value="<cfoutput><cfif len(get_defaults.package_STOCK_ID_5)>#get_defaults.package_STOCK_ID_5#</cfif></cfoutput>">
                                <a style="cursor:pointer" href"javascript://" onClick="pencere_ac_package_5();">
                                    <img src="/images/plus_thin.gif" align="absmiddle" border="0" style="vertical-align:bottom">
                                </a>
                            </td>
                            <td>
                            	<input type="text" name="package_formul_5" id="package_formul_5" style="width:110px;" value="<cfoutput><cfif len(get_defaults.package_FORMUL_5)>#get_defaults.package_FORMUL_5#</cfif></cfoutput>">
                            </td>
                        </tr>
                    </tbody>
                </cf_form_list>
            	</div>
            </td>
            <td valign="top" width="25%">
            	<table width="100%">
					<tr height="30">
						<td colspan="2" class="txtboldblue"><cf_get_lang_main no='2928.Tasarım Aktarım Tanımları'></td>
                  	</tr>
                    <tr height="20">
                        <td width="140"><cf_get_lang_main no='2903.Paket'> <cf_get_lang_main no='74.Kategori'></td>
                        <td>
							<cfsavecontent variable="message"><cf_get_lang_main no='782.Girilmesi Zorunlu Alan'>!</cfsavecontent>
                         	<input type="hidden" name="package_product_cat_code" id="package_product_cat_code" value="<cfif len(get_defaults.DEFAULT_PACKAGE_CAT_ID)><cfoutput>#get_package_product_cat..product_cat_code#</cfoutput></cfif>">
                       		<input type="hidden" name="package_product_catid" id="package_product_catid" value="<cfoutput>#get_package_product_cat.PRODUCT_CATID#</cfoutput>">
                         	<cfinput type="text" name="package_product_cat" id="package_product_cat" style="width:150px;" value="#get_package_product_cat.product_cat#" onFocus="AutoComplete_Create('package_product_cat','PRODUCT_CAT,HIERARCHY','PRODUCT_CAT_NAME','get_product_cat','','PRODUCT_CATID','package_product_catid','','3','200');">
                          	<a href="javascript://"onclick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_product_cat_names&field_code=add_defaults.package_product_cat_code&is_sub_category=1&field_id=add_defaults.package_product_catid&field_name=add_defaults.package_product_cat','list');"><img src="/images/plus_thin.gif" title="#getLang('main',1684)#" style="vertical-align:bottom"></a>
                        </td>
              		</tr>
                    <tr height="20">
                        <td width="140"><cf_get_lang_main no='2848.Parça'> <cf_get_lang_main no='74.Kategori'></td>
                        <td>
							<cfsavecontent variable="message1"><cf_get_lang_main no='782.Girilmesi Zorunlu Alan'>!</cfsavecontent>
                         	<input type="hidden" name="piece_product_cat_code" id="piece_product_cat_code" value="<cfif len(get_defaults.DEFAULT_PIECE_CAT_ID)><cfoutput>#get_piece_product_cat..product_cat_code#</cfoutput></cfif>">
                       		<input type="hidden" name="piece_product_catid" id="piece_product_catid" value="<cfoutput>#get_piece_product_cat.PRODUCT_CATID#</cfoutput>">
                         	<cfinput type="text" name="piece_product_cat" id="piece_product_cat" style="width:150px;" value="#get_piece_product_cat.product_cat#" onFocus="AutoComplete_Create('piece_product_cat','PRODUCT_CAT,HIERARCHY','PRODUCT_CAT_NAME','get_product_cat','','PRODUCT_CATID','piece_product_catid','','3','200');">
                          	<a href="javascript://"onclick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_product_cat_names&field_code=add_defaults.piece_product_cat_code&is_sub_category=1&field_id=add_defaults.piece_product_catid&field_name=add_defaults.piece_product_cat','list');"><img src="/images/plus_thin.gif" title="#getLang('main',1684)#" style="vertical-align:bottom"></a>
                        </td>
              		</tr>
                    <tr height="20">
                        <td width="140"><cf_get_lang_main no='245.Ürün'> <cf_get_lang_main no='2929.Kayıt Süreci'></td>
                        <td>
                        	<select name="product_process_stage" id="product_process_stage" style="width:150px">
                            	 <option value=""><cf_get_lang_main no='322.Seçiniz'></option>
                                <cfloop query="get_product_stage">
                                    <option value="#PROCESS_ROW_ID#"  <cfif PROCESS_ROW_ID eq get_defaults.DEFAULT_PRODUCT_PROCESS_STAGE>selected="selected"</cfif>>#Stage#</option>
                                </cfloop>
                            </select>
                        </td>
              		</tr>
                    <tr height="20">
                        <td ><cfoutput>#getLang('prod',52)# #getLang('main',2929)#</cfoutput></td>
                        <td>
							<select name="product_tree_process_stage" id="product_tree_process_stage" style="width:150px">
                            	 <option value=""><cf_get_lang_main no='322.Seçiniz'></option>
                                <cfloop query="get_product_tree_stage">
                                    <option value="#PROCESS_ROW_ID#"  <cfif PROCESS_ROW_ID eq get_defaults.DEFAULT_PRODUCT_TREE_PROCESS_STAGE>selected="selected"</cfif>>#Stage#</option>
                                </cfloop>
                            </select>
                        </td>
              		</tr>
                    <tr height="20">
                        <td ><cfoutput>#getLang('prod',429)# #getLang('main',224)#</cfoutput></td>
                        <td>
							<select name="main_unit" id="main_unit" style="width:150px">
                            	 <option value=""><cf_get_lang_main no='322.Seçiniz'></option>
                                <cfloop query="get_unit">
                                    <option value="#UNIT#"  <cfif UNIT eq get_defaults.DEFAULT_MAIN_UNIT>selected="selected"</cfif>>#UNIT#</option>
                                </cfloop>
                            </select>
                        </td>
              		</tr>
                    <tr height="20">
                        <td ><cfoutput>#getLang('main',2903)# #getLang('main',224)#</cfoutput></td>
                        <td>
							<select name="package_unit" id="package_unit" style="width:150px">
                            	 <option value=""><cf_get_lang_main no='322.Seçiniz'></option>
                                <cfloop query="get_unit">
                                    <option value="#UNIT#"  <cfif UNIT eq get_defaults.DEFAULT_PACKAGE_UNIT>selected="selected"</cfif>>#UNIT#</option>
                                </cfloop>
                            </select>
                        </td>
              		</tr>
                    <tr height="20">
                        <td ><cfoutput>#getLang('main',2848)# #getLang('main',224)#</cfoutput></td>
                        <td>
							<select name="piece_unit" id="piece_unit" style="width:150px">
                            	 <option value=""><cf_get_lang_main no='322.Seçiniz'></option>
                                <cfloop query="get_unit">
                                    <option value="#UNIT#"  <cfif UNIT eq get_defaults.DEFAULT_PIECE_UNIT>selected="selected"</cfif>>#UNIT#</option>
                                </cfloop>
                            </select>
                        </td>
              		</tr>
                    <tr height="20">
                        <td ><cfoutput>#getLang('prod',429)# #getLang('main',2930)#</cfoutput></td>
                        <td>
							<select name="main_account_id" id="main_account_id" style="width:150px">
                            	 <option value=""><cf_get_lang_main no='322.Seçiniz'></option>
                                <cfloop query="get_product_account_cat">
                                    <option value="#PRO_CODE_CATID#"  <cfif PRO_CODE_CATID eq get_defaults.DEFAULT_MAIN_ACCOUNT_ID>selected="selected"</cfif>>#PRO_CODE_CAT_NAME#</option>
                                </cfloop>
                            </select>
                        </td>
              		</tr>
                    <tr height="20">
                        <td ><cfoutput>#getLang('main',2903)# #getLang('main',2930)#</cfoutput></td>
                        <td>
							<select name="package_account_id" id="package_account_id" style="width:150px">
                            	 <option value=""><cf_get_lang_main no='322.Seçiniz'></option>
                                <cfloop query="get_product_account_cat">
                                    <option value="#PRO_CODE_CATID#"  <cfif PRO_CODE_CATID eq get_defaults.DEFAULT_PACKAGE_ACCOUNT_ID>selected="selected"</cfif>>#PRO_CODE_CAT_NAME#</option>
                                </cfloop>
                            </select>
                        </td>
              		</tr>
                    <tr height="20">
                        <td ><cfoutput>#getLang('main',2848)# #getLang('main',2930)#</cfoutput></td>
                        <td>
							<select name="piece_account_id" id="piece_account_id" style="width:150px">
                            	 <option value=""><cf_get_lang_main no='322.Seçiniz'></option>
                                <cfloop query="get_product_account_cat">
                                    <option value="#PRO_CODE_CATID#"  <cfif PRO_CODE_CATID eq get_defaults.DEFAULT_PIECE_ACCOUNT_ID>selected="selected"</cfif>>#PRO_CODE_CAT_NAME#</option>
                                </cfloop>
                            </select>
                        </td>
              		</tr>
                    <tr height="20">
                        <td ><cfoutput>#getLang('prod',429)# #getLang('main',2931)#</cfoutput></td>
                        <td>
							<select name="main_station_id" id="main_station_id" style="width:150px">
                            	 <option value=""><cf_get_lang_main no='322.Seçiniz'></option>

                                <cfloop query="get_ws">
                                    <option value="#STATION_ID#"  <cfif STATION_ID eq get_defaults.DEFAULT_MAIN_WORKSTATION_ID>selected="selected"</cfif>>#STATION_NAME#</option>
                                </cfloop>
                            </select>
                        </td>
              		</tr>
                    <tr height="20">
                        <td ><cfoutput>#getLang('main',2903)# #getLang('main',2931)#</cfoutput></td>
                        <td>
							<select name="package_station_id" id="package_station_id" style="width:150px">
                            	 <option value=""><cf_get_lang_main no='322.Seçiniz'></option>
                                <cfloop query="get_ws">
                                    <option value="#STATION_ID#"  <cfif STATION_ID eq get_defaults.DEFAULT_PACKAGE_WORKSTATION_ID>selected="selected"</cfif>>#STATION_NAME#</option>
                                </cfloop>
                            </select>
                        </td>
              		</tr>
                    <tr height="20">
                        <td ><cfoutput>#getLang('main',2848)# #getLang('main',2931)#</cfoutput></td>
                        <td>
							<select name="piece_station_id" id="piece_station_id" style="width:150px">
                            	 <option value=""><cf_get_lang_main no='322.Seçiniz'></option>
                                <cfloop query="get_ws">
                                    <option value="#STATION_ID#"  <cfif STATION_ID eq get_defaults.DEFAULT_PIECE_WORKSTATION_ID>selected="selected"</cfif>>#STATION_NAME#</option>
                                </cfloop>
                            </select>
                        </td>
              		</tr>
                    <tr height="20">
                        <td ><cfoutput>#getLang('prod',429)# #getLang('main',2932)#</cfoutput></td>
                        <td>
							<select name="main_operation_id" id="main_operation_id" style="width:150px">
                            	 <option value=""><cf_get_lang_main no='322.Seçiniz'></option>
                                <cfloop query="get_operation">
                                    <option value="#OPERATION_TYPE_ID#"  <cfif OPERATION_TYPE_ID eq get_defaults.DEFAULT_MAIN_OPERATION_TYPE_ID>selected="selected"</cfif>>#OPERATION_TYPE#</option>
                                </cfloop>
                            </select>
                        </td>
              		</tr>
                    <tr height="20">
                        <td ><cfoutput>#getLang('main',2903)# #getLang('main',2932)#</cfoutput></td>
                        <td>
							<select name="package_operation_id" id="package_operation_id" style="width:150px">
                            	 <option value=""><cf_get_lang_main no='322.Seçiniz'></option>
                                <cfloop query="get_operation">
                                    <option value="#OPERATION_TYPE_ID#"  <cfif OPERATION_TYPE_ID eq get_defaults.DEFAULT_PACKAGE_OPERATION_TYPE_ID>selected="selected"</cfif>>#OPERATION_TYPE#</option>
                                </cfloop>
                            </select>
                        </td>
              		</tr>
                    <tr height="20">
                        <td ><cfoutput>#getLang('main',2933)# #getLang('main',2932)#</cfoutput></td>
                        <td>
							<select name="cutting_operation_id" id="cutting_operation_id" style="width:150px">
                            	 <option value=""><cf_get_lang_main no='322.Seçiniz'></option>
                                <cfloop query="get_operation">
                                    <option value="#OPERATION_TYPE_ID#"  <cfif OPERATION_TYPE_ID eq get_defaults.DEFAULT_CUTTING_OPERATION_TYPE_ID>selected="selected"</cfif>>#OPERATION_TYPE#</option>
                                </cfloop>
                            </select>
                        </td>
              		</tr>
                    <tr height="20">
                        <td><cfoutput>#getLang('main',2865)# #getLang('main',1156)# #getLang('report',216)#</cfoutput></td>
                        <td>
                        	 <select name="transfer_type" id="transfer_type" style="width:150px" >
                             	<option value="0" <cfif get_defaults.DEFAULT_TRANSFER_TYPE eq 0>selected</cfif>><cfoutput>#getLang('main',2934)# #getLang('prod',132)#</cfoutput></option>
                             	<option value="1" <cfif get_defaults.DEFAULT_TRANSFER_TYPE eq 1>selected</cfif>><cfoutput>#getLang('objects',1702)# #getLang('product',462)#</cfoutput></option>
                        	</select>
                        </td>
              		</tr>
                    <tr height="20">
                        <td><cfoutput>#getLang('prod',429)# #getLang('main',1156)# #getLang('report',216)#</cfoutput></td>
                        <td>
                        	 <select name="main_transfer_type" id="main_transfer_type" style="width:150px" >
                             	<option value="1" <cfif get_defaults.DEFAULT_MAIN_TRANSFER_TYPE eq 1>selected</cfif>><cfoutput>#getLang('objects',747)# #getLang('main',245)#</cfoutput></option>
                             	<option value="2" <cfif get_defaults.DEFAULT_MAIN_TRANSFER_TYPE eq 2>selected</cfif>><cfoutput>#getLang('product',456)#</cfoutput></option>
                        	</select>
                        </td>
              		</tr>
                    <tr height="20">
                        <td><cfoutput>#getLang('objects',893)# #getLang('main',152)# #getLang('main',1156)# #getLang('report',216)#</cfoutput></td>
                        <td>
                        	 <select name="sub_transfer_type" id="sub_transfer_type" style="width:150px" >
                             	<option value="0" <cfif get_defaults.IS_HIZMET_PHANTOM eq 0>selected</cfif>><cfoutput>#getLang('objects',747)# #getLang('objects2',1669)#</cfoutput></option>
                             	<option value="1" <cfif get_defaults.IS_HIZMET_PHANTOM eq 1>selected</cfif>>Phantom <cfoutput>#getLang('objects2',1669)#</cfoutput></option>
                        	</select>
                        </td>
              		</tr>
             	</table>
            </td>
            <td valign="top" width="25%">
            	<table width="100%">
					<tr height="30">
						<td colspan="2" class="txtboldblue"><cf_get_lang_main no='398.Ek Bilgi'> <cf_get_lang_main no='2935.Tanımları'></td>
                  	</tr>
                    <tr height="20">
                        <td width="130"><cf_get_lang_main no='2936.Üretim Gideri Katsayısı'></td>
                        <td>
                        	<select name="production_expence_rate" id="production_expence_rate" style="width:160px; height:20px" >
                                <option value=""><cf_get_lang_main no='322.Seçiniz'></option>
                                <cfloop list="#property_list#" index="i">
                                    <option value="#i#" <cfif get_defaults.DEFAULT_PRODUCT_EXPENCE_NO eq i>selected</cfif>>#Evaluate('get_plus_name.PROPERTY#i#_NAME')#</option>
                                </cfloop>
                            </select>
                        </td>
              		</tr>
                    <tr height="20">
                        <td><cf_get_lang_main no='2937.İşçilik Gideri Katsayısı'></td>
                        <td>
							<select name="labor_expence_rate" id="labor_expence_rate" style="width:160px; height:20px" >
                                <option value=""><cf_get_lang_main no='322.Seçiniz'></option>
                                <cfloop list="#property_list#" index="i">
                                    <option value="#i#" <cfif get_defaults.DEFAULT_LABOR_EXPENCE_NO eq i>selected</cfif>>#Evaluate('get_plus_name.PROPERTY#i#_NAME')#</option>
                                </cfloop>
                            </select>
                        </td>
              		</tr>
                    <tr height="20">
                        <td><cf_get_lang_main no='2938.Kanban Gideri Katsayısı'></td>
                        <td>
							<select name="kanban_expence_rate" id="kanban_expence_rate" style="width:160px; height:20px" >
                                <option value=""><cf_get_lang_main no='322.Seçiniz'></option>
                                <cfloop list="#property_list#" index="i">
                                    <option value="#i#" <cfif get_defaults.DEFAULT_KANBAN_EXPENCE_NO eq i>selected</cfif>>#Evaluate('get_plus_name.PROPERTY#i#_NAME')#</option>
                                </cfloop>
                            </select>
                        </td>
              		</tr>
               	</table>
            </td>
            </cfoutput>
        </tr>
        <tr class="color-row">
        	<td colspan="4" valign="top" width="30px">
        		<table width="100%">
					<tr height="30">
            			<td height="35" style="text-align:right"><cf_workcube_buttons is_upd='0' add_function='control()'></td>
                  	</tr>
              	</table>
          	</td>
        </tr>
    </cfform>
</table>
<script type="text/javascript">
	function pencere_ac()
	{
		windowopen("<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_ezgi_product_names&product_id=add_defaults.pid&field_id=add_defaults.stock_id&field_name=add_defaults.urun",'list');
	}
	function pencere_ac_piece_1()
	{
		windowopen("<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_ezgi_product_names&list_order_no=4&product_id=add_defaults.pid_piece_1&field_id=add_defaults.stock_id_piece_1&field_name=add_defaults.urun_piece_1",'list');
	}
	function pencere_ac_piece_2()
	{
		windowopen("<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_ezgi_product_names&list_order_no=4&product_id=add_defaults.pid_piece_2&field_id=add_defaults.stock_id_piece_2&field_name=add_defaults.urun_piece_2",'list');
	}
	function pencere_ac_piece_3()
	{
		windowopen("<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_ezgi_product_names&list_order_no=4&product_id=add_defaults.pid_piece_3&field_id=add_defaults.stock_id_piece_3&field_name=add_defaults.urun_piece_3",'list');
	}
	function pencere_ac_piece_4()
	{
		windowopen("<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_ezgi_product_names&list_order_no=4&product_id=add_defaults.pid_piece_4&field_id=add_defaults.stock_id_piece_4&field_name=add_defaults.urun_piece_4",'list');
	}
	function pencere_ac_piece_5()
	{
		windowopen("<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_ezgi_product_names&list_order_no=4&product_id=add_defaults.pid_piece_5&field_id=add_defaults.stock_id_piece_5&field_name=add_defaults.urun_piece_5",'list');
	}
	function pencere_ac_package_1()
	{
		windowopen("<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_ezgi_product_names&list_order_no=4&product_id=add_defaults.pid_package_1&field_id=add_defaults.stock_id_package_1&field_name=add_defaults.urun_package_1",'list');
	}
	function pencere_ac_package_2()
	{
		windowopen("<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_ezgi_product_names&list_order_no=4&product_id=add_defaults.pid_package_2&field_id=add_defaults.stock_id_package_2&field_name=add_defaults.urun_package_2",'list');
	}
	function pencere_ac_package_3()
	{
		windowopen("<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_ezgi_product_names&list_order_no=4&product_id=add_defaults.pid_package_3&field_id=add_defaults.stock_id_package_3&field_name=add_defaults.urun_package_3",'list');
	}
	function pencere_ac_package_4()
	{
		windowopen("<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_ezgi_product_names&list_order_no=4&product_id=add_defaults.pid_package_4&field_id=add_defaults.stock_id_package_4&field_name=add_defaults.urun_package_4",'list');
	}
	function pencere_ac_package_5()
	{
		windowopen("<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_ezgi_product_names&list_order_no=4&product_id=add_defaults.pid_package_5&field_id=add_defaults.stock_id_package_5&field_name=add_defaults.urun_package_5",'list');
	}
	function control()
	{
		/*if(document.getElementById('default_thickness').value == '')
		{
			alert('Zorunlu Alan - Yonga Levha Kalınlığı');	
			document.getElementById('default_thickness').focus();
			return false;
		}*/
		if(document.getElementById('default_fire_rate').value == '')
		{
			alert('<cf_get_lang_main no='782.Zorunlu Alan'> - <cf_get_lang_main no='2865.Yonga Levha'> <cf_get_lang_main no='2939.Fire Oranı'> ');	
			document.getElementById('default_fire_rate').focus();
			return false;
		}
		/*if(document.getElementById('pvc_default_thickness').value == '')
		{
			alert('Zorunlu Alan - PVC Kalınlığı');	
			document.getElementById('pvc_default_thickness').focus();
			return false;
		}*/
		if(document.getElementById('pvc_default_fire_rate').value == '')
		{
			alert('<cf_get_lang_main no='782.Zorunlu Alan'> - PVC <cf_get_lang_main no='2940.Fire Miktarı'>');	
			document.getElementById('pvc_default_fire_rate').focus();
			return false;
		}
		if(document.getElementById('trim_type').value != 0)
		{
			if(document.getElementById('trim_size').value <= 0)
			{
				alert('<cf_get_lang_main no='782.Zorunlu Alan'> - <cf_get_lang_main no='2889.Tıraşlama Payı'>');	
				document.getElementById('trim_size').focus();
				return false;
			}
		}
		else
		{
			document.getElementById('trim_size').value = 0;
		}
		if(document.getElementById('product_amount').value <= 0)
		{
			alert('<cf_get_lang_main no='782.Zorunlu Alan'> - <cf_get_lang_main no='2157.Genel'> <cf_get_lang_main no='2941.Üretim Miktarı'>');	
			document.getElementById('product_amount').focus();
			return false;
		}
		if(document.getElementById('color_property_id').value == '')
		{
			alert('<cf_get_lang_main no='782.Zorunlu Alan'> - <cf_get_lang_main no='2923.Renk Özellik Tanımı'>');	
			document.getElementById('color_property_id').focus();
			return false;
		}
		if(document.getElementById('thickness_property_id').value == '')
		{
			alert('<cf_get_lang_main no='782.Zorunlu Alan'> - <cf_get_lang_main no='2924.Kalınlık Özellik Tanımı'>');	
			document.getElementById('thickness_property_id').focus();
			return false;
		}
		if(document.getElementById('thickness_ext_property_id').value == '')
		{
			alert('<cf_get_lang_main no='782.Zorunlu Alan'> - <cf_get_lang_main no='2925.Kal.Etkisi Özellik Tanımı'>');	
			document.getElementById('thickness_ext_property_id').focus();
			return false;
		}
		if(document.getElementById('package_product_cat').value == '')
		{
			alert('<cf_get_lang_main no='782.Zorunlu Alan'> - <cf_get_lang_main no='2903.Paket'> <cf_get_lang_main no='2942.Kategorisi'> ');	
			document.getElementById('package_product_cat').focus();
			return false;
		}
		if(document.getElementById('piece_product_cat').value == '')
		{
			alert('<cf_get_lang_main no='782.Zorunlu Alan'> - <cf_get_lang_main no='2848.Parça'> <cf_get_lang_main no='2942.Kategorisi'>');	
			document.getElementById('piece_product_cat').focus();
			return false;
		}
		if(document.getElementById('product_process_stage').value == '')
		{
			alert('<cf_get_lang_main no='782.Zorunlu Alan'> - <cf_get_lang_main no='245.Ürün'> <cf_get_lang_main no='2929.Kayıt Süreci'>');	
			document.getElementById('product_process_stage').focus();
			return false;
		}
		if(document.getElementById('product_tree_process_stage').value == '')
		{
			alert('<cf_get_lang_main no='782.Zorunlu Alan'> - <cf_get_lang_main no='2943.Ürün Ağacı'> <cf_get_lang_main no='2929.Kayıt Süreci'>');	
			document.getElementById('product_tree_process_stage').focus();
			return false;
		}
		if(document.getElementById('main_unit').value == '')
		{
			alert('<cf_get_lang_main no='782.Zorunlu Alan'> - <cf_get_lang_main no='2944.Modül'> <cf_get_lang_main no='224.Birim'> ');	
			document.getElementById('main_unit').focus();
			return false;
		}
		if(document.getElementById('package_unit').value == '')
		{
			alert('<cf_get_lang_main no='782.Zorunlu Alan'> - <cf_get_lang_main no='2903.Paket'> <cf_get_lang_main no='224.Birim'>');	
			document.getElementById('package_unit').focus();
			return false;
		}
		if(document.getElementById('piece_unit').value == '')
		{
			alert('<cf_get_lang_main no='782.Zorunlu Alan'> - <cf_get_lang_main no='2848.Parça'> <cf_get_lang_main no='224.Birim'>');	
			document.getElementById('piece_unit').focus();
			return false;
		}
		if(document.getElementById('main_account_id').value == '')
		{
			alert('<cf_get_lang_main no='782.Zorunlu Alan'> - <cf_get_lang_main no='2944.Modül'> <cf_get_lang_main no='2930.Muh.Bt.Hes.Kodu'> ');	
			document.getElementById('main_account_id').focus();
			return false;
		}
		if(document.getElementById('package_account_id').value == '')
		{
			alert('<cf_get_lang_main no='782.Zorunlu Alan'> - <cf_get_lang_main no='2903.Paket'> <cf_get_lang_main no='2930.Muh.Bt.Hes.Kodu'>');	
			document.getElementById('package_account_id').focus();
			return false;
		}
		if(document.getElementById('piece_account_id').value == '')
		{
			alert('<cf_get_lang_main no='782.Zorunlu Alan'> - <cf_get_lang_main no='2848.Parça'> <cf_get_lang_main no='2930.Muh.Bt.Hes.Kodu'>');	
			document.getElementById('piece_account_id').focus();
			return false;
		}
		if(document.getElementById('main_station_id').value == '')
		{
			alert('<cf_get_lang_main no='782.Zorunlu Alan'> - <cf_get_lang_main no='2944.Modül'> <cf_get_lang_main no='2931.İstasyonu'> ');	
			document.getElementById('main_station_id').focus();
			return false;
		}
		if(document.getElementById('package_station_id').value == '')
		{
			alert('<cf_get_lang_main no='782.Zorunlu Alan'> - <cf_get_lang_main no='2903.Paket'> <cf_get_lang_main no='2931.İstasyonu'>');	
			document.getElementById('package_station_id').focus();
			return false;
		}
		if(document.getElementById('piece_station_id').value == '')
		{
			alert('<cf_get_lang_main no='782.Zorunlu Alan'> - <cf_get_lang_main no='2848.Parça'> <cf_get_lang_main no='2931.İstasyonu'>');	
			document.getElementById('piece_station_id').focus();
			return false;
		}
		if(document.getElementById('main_operation_id').value == '')
		{
			alert('<cf_get_lang_main no='782.Zorunlu Alan'> - <cf_get_lang_main no='2944.Modül'> <cf_get_lang_main no='2932.Operasyonu'>');	
			document.getElementById('main_operation_id').focus();
			return false;
		}
		if(document.getElementById('package_operation_id').value == '')
		{
			alert('<cf_get_lang_main no='782.Zorunlu Alan'> - <cf_get_lang_main no='2903.Paket'> <cf_get_lang_main no='2932.Operasyonu'>');	
			document.getElementById('package_operation_id').focus();
			return false;
		}
		if(document.getElementById('cutting_operation_id').value == '')
		{
			alert('<cf_get_lang_main no='782.Zorunlu Alan'> - <cf_get_lang_main no='2933.Ebatlama'> <cf_get_lang_main no='2932.Operasyonu'>');	
			document.getElementById('cutting_operation_id').focus();
			return false;
		}
		if(document.getElementById('urun').value == '')
		{
			alert('<cf_get_lang_main no='782.Zorunlu Alan'> - PVC <cf_get_lang_main no='2915.Master Ürün'>');	
			document.getElementById('urun').focus();
			return false;
		}
		if(document.getElementById('master_model_id').value == '')
		{
			alert('<cf_get_lang_main no='782.Zorunlu Alan'> - <cf_get_lang_main no='2915.Master Ürün'> <cf_get_lang_main no='813.Model'> <cf_get_lang_main no='2945.Kodu'>');	
			document.getElementById('master_model_id').focus();
			return false;
		}
		if(document.getElementById('active_operator_amount').value <= 0)
		{
			alert('<cf_get_lang_main no='782.Zorunlu Alan'> - <cf_get_lang_main no='81.Aktif'> <cf_get_lang_main no='2921.Operatör Sayısı'> ');	
			document.getElementById('active_operator_amount').focus();
			return false;
		}
		if(document.getElementById('daily_working_time').value <= 0)
		{
			alert('<cf_get_lang_main no='782.Zorunlu Alan'> - <cf_get_lang_main no='1045.Günlük'> <cf_get_lang_main no='2946.Çalışma Süresi'>');	
			document.getElementById('daily_working_time').focus();
			return false;
		}
	}
</script>