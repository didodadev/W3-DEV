<cfparam name="attributes.related_product_id" default="">
<cfparam name="attributes.related_stock_id" default="">
<cfparam name="attributes.related_product_name" default="">
<cfparam name="attributes.package_row_id" default="">
<cfset module_name="product">
<cfset var_="upd_purchase_basket">
<cfquery name="get_money" datasource="#dsn2#">
	SELECT MONEY FROM SETUP_MONEY
</cfquery>
<!---Montaj Edilebilecek Ürünler--->
<cfquery name="get_montage_product" datasource="#dsn3#">
	SELECT        
    	E.PIECE_ROW_ID, 
        E.PIECE_NAME, 
        E.PIECE_CODE, 
        E.DESIGN_PACKAGE_ROW_ID,
        ISNULL(E.PIECE_AMOUNT,0) AS PIECE_AMOUNT, 
        ISNULL(TBL.AMOUNT, 0) AS USED_AMOUNT
	FROM            
    	EZGI_DESIGN_PIECE AS E LEFT OUTER JOIN
     	(
        	SELECT        
            	RELATED_PIECE_ROW_ID, SUM(AMOUNT) AS AMOUNT
        	FROM            
            	EZGI_DESIGN_PIECE_ROW
    		GROUP BY 
            	RELATED_PIECE_ROW_ID
       	) AS TBL ON E.PIECE_ROW_ID = TBL.RELATED_PIECE_ROW_ID
	WHERE        
    	E.PIECE_TYPE IN (1,2) AND 
        E.PIECE_STATUS = 1 AND 
		E.DESIGN_MAIN_ROW_ID=#attributes.design_main_row_id# AND
        ISNULL(TBL.AMOUNT, 0) < E.PIECE_AMOUNT
	ORDER BY 
    	E.PIECE_NAME
</cfquery>
<cfif not get_montage_product.recordcount>
	<cfset newRow = QueryAddRow(get_montage_product, 1)>
    <cfset temp = QuerySetCell(get_montage_product, "PIECE_ROW_ID", "", 1)> 
    <cfset temp = QuerySetCell(get_montage_product, "PIECE_NAME", "Kayıt Yok", 1)>
    <cfset temp = QuerySetCell(get_montage_product, "PIECE_CODE", "00", 1)>
    <cfset temp = QuerySetCell(get_montage_product, "PIECE_AMOUNT", "0", 1)>
    <cfset temp = QuerySetCell(get_montage_product, "USED_AMOUNT", "0", 1)>
</cfif>
<!---Montaj Edilebilecek Ürünler--->
<cfquery name="get_main_defaults" datasource="#dsn3#">
	SELECT        
    	DEFAULT_YONGA_LEVHA_THICKNESS, 
        DEFAULT_YONGA_LEVHA_FIRE_RATE, 
        DEFAULT_PVC_THICKNESS, 
        DEFAULT_PVC_FIRE_AMOUNT, 
        DEFAULT_PIECE_TYPE, 
        DEFAULT_TRIM_TYPE, 
    	DEFAULT_TRIM_AMOUNT
	FROM            
    	EZGI_DESIGN_DEFAULTS
</cfquery>
<!---Defaultlar--->
<cfparam name="attributes.piece_type" default="#get_main_defaults.DEFAULT_PIECE_TYPE#">
<cfparam name="attributes.trim_type" default="#get_main_defaults.DEFAULT_PIECE_TYPE#">
<cfparam name="attributes.trim_rate" default="#get_main_defaults.DEFAULT_TRIM_AMOUNT#">
<cfparam name="attributes.pvc_fire_amount" default="#get_main_defaults.DEFAULT_PVC_FIRE_AMOUNT#">
<cfparam name="attributes.yonga_levha_fire_rate" default="#get_main_defaults.DEFAULT_YONGA_LEVHA_FIRE_RATE#">
<cfset default_thickness = get_main_defaults.DEFAULT_YONGA_LEVHA_THICKNESS>
<cfset default_pvc_thickness = get_main_defaults.DEFAULT_PVC_THICKNESS>
<!---Defaultlar--->
<cfset get_aksesuar.recordcount = 0>
<cfset get_yrm.recordcount = 0>
<cfset get_hzm.recordcount = 0>
<cfset get_yari_mamul.recordcount = 0>

<!---Parça Defaultlarını Çekme--->
<cfquery name="get_colors" datasource="#dsn3#">
	SELECT * FROM EZGI_COLORS ORDER BY COLOR_NAME
</cfquery>
<cfquery name="get_piece_defaults" datasource="#dsn3#">
	SELECT PIECE_DEFAULT_ID, PIECE_DEFAULT_CODE, PIECE_DEFAULT_NAME FROM EZGI_DESIGN_PIECE_DEFAULTS ORDER BY PIECE_DEFAULT_NAME
</cfquery>
<!---Parça Defaultlarını Çekme--->
<!---Paket Bilgisi Çekme--->
<cfquery name="get_design_package_row" datasource="#dsn3#">
	SELECT PACKAGE_NUMBER, PACKAGE_ROW_ID FROM EZGI_DESIGN_PACKAGE WHERE DESIGN_MAIN_ROW_ID = #attributes.design_main_row_id# ORDER BY PACKAGE_NUMBER
</cfquery>
<!---Paket Bilgisi Çekme--->
<!---Modül Bilgisi Çekme--->
<cfquery name="get_design_main_row" datasource="#dsn3#">
	SELECT 
    	*, 
        (SELECT MAIN_ROW_SETUP_NAME FROM EZGI_DESIGN_MAIN_ROW_SETUP WHERE MAIN_ROW_SETUP_ID = EZGI_DESIGN_MAIN_ROW.MAIN_ROW_SETUP_ID) as MAIN_ROW_SETUP_NAME,
        (SELECT COLOR_NAME FROM EZGI_COLORS WHERE COLOR_ID = EZGI_DESIGN_MAIN_ROW.DESIGN_MAIN_COLOR_ID) as COLOR_NAME
  	FROM 
    	EZGI_DESIGN_MAIN_ROW 
  	WHERE 
    	DESIGN_MAIN_ROW_ID = #attributes.design_main_row_id#
</cfquery>
<cfset main_setup_name = get_design_main_row.MAIN_ROW_SETUP_NAME>
<!---Modül Bilgisi Çekme--->
<!---Kalınlık Bilgisi Çekme--->
<cfquery name="get_thickness" datasource="#dsn3#">
	SELECT        
    	THICKNESS_ID, 
        THICKNESS_VALUE, 
        THICKNESS_NAME, 
        UNIT
	FROM            
    	EZGI_DESIGN_PRODUCT_PROPERTIES_UST
	WHERE        
    	COLOR_ID = #get_design_main_row.DESIGN_MAIN_COLOR_ID# AND 
        LIST_ORDER_NO = 1
	ORDER BY 
    	THICKNESS_NAME
</cfquery>
<!---Kalınlık Bilgisi Çekme--->
<!---Tasarım Bilgisi Çekme--->
<cfquery name="get_design" datasource="#dsn3#">
	SELECT  * FROM EZGI_DESIGN WHERE DESIGN_ID = #get_design_main_row.DESIGN_ID#
</cfquery>
<!---Tasarım Bilgisi Çekme--->
<!---Parça Kodu Belirleme--->
<cfquery name="get_design_piece_row" datasource="#dsn3#">
	SELECT TOP (1) * FROM EZGI_DESIGN_PIECE WHERE DESIGN_MAIN_ROW_ID = #attributes.design_main_row_id# ORDER BY PIECE_CODE DESC
</cfquery>
<cfif get_design_piece_row.recordcount>
	 <cfif left(get_design_piece_row.PIECE_CODE,1) eq 0>
     	<cfset new_piece_code = right(get_design_piece_row.PIECE_CODE,1)*1 + 1>
   	<cfelse>
    	<cfset new_piece_code = get_design_piece_row.PIECE_CODE*1 + 1>
    </cfif>
    <cfif len(new_piece_code) eq 1>
    	<cfset new_piece_code = '0#new_piece_code#'>
    </cfif>
<cfelse>
	<cfset new_piece_code = '01'>
</cfif>
<!---Parça Kodu Belirleme--->
<!---Yonga Levha Reçete Satırlarını Belirleme--->
<cfquery name="get_yonga_levha" datasource="#DSN3#">
	SELECT        
    	*
	FROM            
    	EZGI_DESIGN_PRODUCT_PROPERTIES_UST
	WHERE
    	THICKNESS_ID = #default_thickness# AND        
    	COLOR_ID = #get_design_main_row.DESIGN_MAIN_COLOR_ID# AND 
        LIST_ORDER_NO = 1
	ORDER BY 
    	THICKNESS_NAME
</cfquery>
<!---Yonga Levha Reçete Satırlarını Belirleme--->
<!---PVC Reçete Satırlarını Belirleme--->
<cfquery name="get_pvc1" datasource="#DSN3#">
	SELECT        
    	*,
        0 AS S_TYPE
	FROM            
    	EZGI_DESIGN_PRODUCT_PROPERTIES_UST
	WHERE
    	THICKNESS_ID = #default_thickness# AND        
    	COLOR_ID = #get_design_main_row.DESIGN_MAIN_COLOR_ID# AND 
        LIST_ORDER_NO = 3
	ORDER BY 
    	PRODUCT_NAME
</cfquery>
<cfset s_stock_id_list = ValueList(get_pvc1.STOCK_ID)>
<cfquery name="get_pvc2" datasource="#DSN3#">
	SELECT        
    	*,
        1 AS S_TYPE
	FROM            
    	EZGI_DESIGN_PRODUCT_PROPERTIES_UST
	WHERE
    	THICKNESS_ID = #default_thickness# AND        
        LIST_ORDER_NO = 3
        <cfif Listlen(s_stock_id_list)>  
        	AND STOCK_ID NOT IN (#s_stock_id_list#) 
        </cfif>
	ORDER BY 
    	PRODUCT_NAME
</cfquery>
<cfquery name="get_pvc" dbtype="query">
	<cfif Listlen(s_stock_id_list)>
        SELECT
            PRODUCT_NAME,
            STOCK_ID,
            KALINLIK_ETKISI_ID,
            S_TYPE
        FROM
            get_pvc1
        UNION ALL
    </cfif>
    SELECT
    	PRODUCT_NAME,
        STOCK_ID,
        KALINLIK_ETKISI_ID,
        S_TYPE
   	FROM
    	get_pvc2
 	ORDER BY
    	S_TYPE,
        PRODUCT_NAME	 	
</cfquery>
<!---PVC Reçete Satırlarını Belirleme--->
<br />
<cf_form_box title="&nbsp;	">
	<cfform name="add_piece_main_row" method="post" action="#request.self#?fuseaction=prod.emptypopup_add_ezgi_product_tree_creative_piece_row">
    	<cfinput type="hidden" name="design_id" value="#get_design_main_row.DESIGN_ID#">
        <cfinput type="hidden" name="design_main_row_id" value="#attributes.design_main_row_id#">
        <cfinput type="hidden" name="pvc_fire_amount" value="#attributes.pvc_fire_amount#">
        <cfinput type="hidden" name="yonga_levha_fire_rate" value="#attributes.yonga_levha_fire_rate#">
    	<br />
        <cf_area width="350px">
		<table>
        	<tr height="25px"  id="piece_type_">
                <td width="90"><cf_get_lang_main no ='2848.Parça'> <cf_get_lang_main no ='218.Tip'>*</td>
                <td width="210">
                	<select name="piece_type" id="piece_type" style="width:200px;height:20px" onchange="piece_types();">
                   		<option value="1">01-<cfoutput>#getLang('main',2865)# #getLang('report',1688)# #getLang('main',2610)#</cfoutput></option>
                        <option value="2">02-<cfoutput>#getLang('main',2157)# #getLang('report',1688)# #getLang('main',2610)#</cfoutput></option>
                    	<option value="3">03-<cfoutput>#getLang('main',2877)#</cfoutput></option>
                   		<option value="4">04-<cfoutput>#getLang('prod',132)# #getLang('main',170)#</cfoutput></option>
                    </select>
                </td>
            </tr>
            <tr height="25px"  id="piece_default_type_">
                <td valign="top"><cf_get_lang_main no ='1555.Örnek'> <cf_get_lang_main no ='2848.Parça'>*</td>
                <td valign="top">
                	<select name="default_type" id="default_type" style="width:130px;height:20px" onchange="hesapla();">
                    	<option value=""><cf_get_lang_main no='322.Seçiniz'></option>
                        <cfoutput query="get_piece_defaults">
                        	<option value="#PIECE_DEFAULT_ID#" >#PIECE_DEFAULT_NAME#</option>
                        </cfoutput>
                    </select>
                    &nbsp;
                 	<a href="javascript://" onClick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=prod.popup_add_ezgi_default_piece&is_piece=1','small');"><img src="/images/plus_list.gif" border="0" title="Örnek Parça Ekle" style="vertical-align:top" ></a>
                </td>
            </tr>
        	
            <tr height="25px"  id="piece_name_">
                <td valign="top"><cf_get_lang_main no ='2848.Parça'> <cf_get_lang_main no ='485.Adı'>*</td>
                <td valign="top">
                	<cfinput type="text" name="design_name_piece_row" id="design_name_piece_row" value="#main_setup_name#" maxlength="50" style="width:200px;" >
                </td>
            </tr>
            <tr height="25px"  id="piece_related_name_" style="display:none">
                <td valign="top"><cf_get_lang_main no ='245.Ürün'> <cf_get_lang_main no ='485.Adı'>*</td>
                <td valign="top">
                    <input type="text" name="related_product_name" id="related_product_name" style="width:190px; vertical-align:top">
                    <input type="hidden" name="related_product_id" id="related_product_id">
                    <input type="hidden" name="related_stock_id" id="related_stock_id"> 
                    <a href="javascript://" onclick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_ezgi_product_names&list_order_no=3,4&product_id=add_piece_main_row.related_product_id&field_id=add_piece_main_row.related_stock_id&field_name=add_piece_main_row.related_product_name','list');"><img src="/images/plus_thin.gif"></a>
                    
                </td>
            </tr>
            <tr height="25px"  id="piece_color_">
                <td valign="top"><cf_get_lang_main no ='1968.Renk Düzenle'> <span id="piece_color__" style="font-weight:bold;">*</span></td>
                <td valign="top">
                	<select name="color_type" id="color_type" style="width:130px;height:20px" onchange="set_thickness(this.value)">
                    	<option value="0"><cf_get_lang_main no='322.Seçiniz'></option>
                        <cfoutput query="get_colors">
                        	<option value="#COLOR_ID#" <cfif  get_design.color_id eq COLOR_ID>style="font-weight:bold" selected </cfif>>#COLOR_NAME#</option>
                        </cfoutput>
                    </select>
                </td>
            </tr>
            <tr height="25px"  id="piece_amount_">
                <td valign="top"><cf_get_lang_main no ='223.Miktar'>*</td>
                <td valign="top">
                	<cfinput type="text" id="piece_amount" name="piece_amount" value="#TlFormat(1,4)#" maxlength="9" style="width:70px;text-align:right">
                </td>
            </tr>
            <tr height="25px"  id="piece_kalinlik_">
                <td valign="top"><cf_get_lang_main no ='2878.Kalınlık'> (mm.) <span id="piece_kalinlik__" style="font-weight:bold">*</span></td>
                <td valign="top">
                	<select name="piece_kalinlik" id="piece_kalinlik" style="width:70px;height:20px"  onchange="set_product(this.value)">
                    	<option value=""><cf_get_lang_main no='322.Seçiniz'></option>
                        <cfoutput query="get_thickness">
                        	<option value="#THICKNESS_ID#" <cfif default_thickness eq THICKNESS_ID>selected</cfif>>#THICKNESS_NAME#</option>
                        </cfoutput>
                    </select>
                </td>
            </tr>
	    <tr height="25px"  id="piece_boy_">
                <td valign="top"><cfoutput>#getLang('report',790)#</cfoutput> (mm.) <span id="piece_boy__" style="font-weight:bold">*</span></td>
                <td valign="top">
                	<cfinput type="text" name="piece_boy" id="piece_boy" value="#TlFormat(0,1)#" maxlength="7" style="width:70px;text-align:right" onkeyup="return(FormatCurrency(this,event,1));">
                </td>
            </tr>
            <tr height="25px"  id="piece_en_">
                <td valign="top"><cfoutput>#getLang('report',749)#</cfoutput> (mm.)<span id="piece_en__" style="font-weight:bold">*</span></td>
                <td valign="top">
                	<cfinput type="text" name="piece_en" id="piece_en" value="#TlFormat(0,1)#" maxlength="7" style="width:70px;text-align:right" onkeyup="return(FormatCurrency(this,event,1));">
                </td>
            </tr>
            
            <tr height="25px"  id="piece_su_yonu_">
                <td valign="top"><cfoutput>#getLang('main',2879)# #getLang('main',2880)#</cfoutput></td>
                <td valign="top">
                	<input type="checkbox" name="piece_su_yonu" id="piece_su_yonu" checked="checked" value="1" />
                </td>
            </tr>
            <tr height="25px"  id="piece_weight_">
                <td valign="top"><cf_get_lang_main no ='1987.Ağırlık'> (kg.)</td>
                <td valign="top">
                	<cfinput type="text" id="piece_weight" name="piece_weight" value="#TlFormat(0,2)#" maxlength="3" style="width:70px;text-align:right">
                </td>
            </tr>
            <tr height="25px" id="piece_kod_">
                <td valign="top"><cf_get_lang_main no ='2848.Parça'> <cf_get_lang_main no ='75.No'></td>
                <td valign="top">
                	<cfinput type="text" name="design_code_piece_row" id="design_code_piece_row" value="#new_piece_code#" maxlength="50" style="width:70px;" >
                </td>
            </tr>
            <tr height="25px"  id="piece_package_no_">
                <td valign="top"><cfoutput>#getLang('stock',371)# #getLang('main',75)#</cfoutput></td>
                <td valign="top">
                	<select name="piece_package_no" id="piece_package_no" style="width:70px;height:20px; text-align:center" onchange="piece_floor_no()">
                    	<option value=""><cf_get_lang_main no='322.Seçiniz'></option>
                        <cfoutput query="get_design_package_row">
                        	<option value="#PACKAGE_ROW_ID#" <cfif attributes.package_row_id eq PACKAGE_ROW_ID>selected</cfif>>#PACKAGE_NUMBER#</option>
                        </cfoutput>
                    </select>
                </td>
            </tr>
            <cfif get_design.PROCESS_ID eq 1>
            	<tr height="25px"  id="piece_package_floor_no_" style="display:none">
                    <td valign="top"><cfoutput>#getLang('main',2903)# #getLang('main',2905)# #getLang('main',75)#</cfoutput> </td>
                    <td valign="top">
                        <select name="piece_package_floor_no" id="piece_package_floor_no" style="width:70px;height:20px; text-align:center">
                            <option value=""><cf_get_lang_main no='322.Seçiniz'></option>
                            <option value="1">1</option>
                            <option value="2">2</option>
                            <option value="3">3</option>
                            <option value="4">4</option>
                            <option value="5">5</option>
                            <option value="6">6</option>
                            <option value="7">7</option>
                            <option value="8">8</option>
                            <option value="9">9</option>
                        </select>
                    </td>
                </tr>
                <tr height="25px"  id="piece_package_rota_" style="display:none">
                    <td valign="top"><cfoutput>#getLang('main',2906)#</cfoutput></td>
                    <td valign="top">
                        <select name="piece_package_rota" id="piece_package_rota" style="width:70px;height:20px; text-align:center">
                            <option value=""><cf_get_lang_main no='322.Seçiniz'></option>
                            <option value="A">A</option>
                            <option value="B">B</option>
                            <option value="C">C</option>
                            <option value="D">D</option>
                            <option value="E">E</option>
                            <option value="F">F</option>
                            <option value="G">G</option>
                            <option value="H">H</option>
                            <option value="I">I</option>
                        </select>
                    </td>
                </tr>
            </cfif>
            <tr height="25px"  id="piece_price_" style="display:none">
                <td valign="top"><cf_get_lang_main no ='245.Ürün'> <cf_get_lang_main no ='672.Fiyat'> </td>
                <td valign="top">
                    <input type="text" name="product_price" id="product_price" value="<cfoutput>#TlFormat(0,4)#</cfoutput>" style="width:70px; height:20px; vertical-align:top; text-align:right">
                    <select name="product_price_money" style="vertical-align:top;width:70px; height:20px">
                    	<cfoutput query="get_money">
                        	<option value="#money#" <cfif money eq session.ep.money>selected</cfif>>#money#</option>
                        </cfoutput>
                    </select>
                </td>
            </tr>
            <tr height="50px"  id="piece_detail_">
                <td valign="top"><cf_get_lang_main no ='217.Açıklama'> </td>
                <td valign="top">
                    <textarea name="piece_detail" id="piece_detail" style="width:200px; height:50px"></textarea>
                </td>
            </tr>
        </table>
        </cf_area>
        <cf_area width="350px">
        	<div id="yonga_levha_" style="width:260px; display:">
            	<cf_seperator title="#getLang('main',2865)#" id="_yonga_levha" is_closed="1">
             	<cf_form_list id="_yonga_levha">
                    <tbody>
                        <tr height="25px"  id="piece_yonga_levha_">
                            <td width="260">
                                <select name="piece_yonga_levha" id="piece_yonga_levha" style="width:250px;height:20px">
                                    <cfoutput query="get_yonga_levha">
                                        <option value="#STOCK_ID#" <cfif default_thickness eq THICKNESS_ID>selected</cfif>>#PRODUCT_NAME#</option>
                                    </cfoutput>
                                </select>
                            </td>
                        </tr>
                    </tbody>
           		</cf_form_list>
                <br />
         	</div>
            <div id="yari_mamul_" style="width:260px; display:none">
            	<cf_seperator title="#getLang('main',2881)#" id="_yari_mamul" is_closed="1">
             	<cf_form_list id="_yari_mamul">
                	<thead>
                   		<tr>
                        	<th width="20px">
                           		<input type="hidden" name="record_num_yrm" id="record_num_yrm" value="0">
                            	<input type="button" class="eklebuton" title="<cf_get_lang_main no='170.Ekle'>" onclick="add_row_yrm();"></th>
                         	<th width="170px" nowrap="nowrap"><cf_get_lang_main no='40.Stok'></th>
                        	<th width="80px"><cf_get_lang_main no='223.Miktar'></th>
                    	</tr>
                 	</thead>
                 	<tbody name="new_row_yrm" id="new_row_yrm">
						<cfif get_yari_mamul.recordcount>
							<cfoutput query="get_yari_mamul">
                            	<tr name="frm_row_yrm" id="frm_row_yrm#currentrow#">
                                 	
                             	</tr>
                          	</cfoutput>
                      	</cfif>
                 	</tbody>
              	</cf_form_list>
                <br />
         	</div>
           	<div id="kenar_" style="width:260px">
            	<cf_seperator title="#getLang('main',2882)#" id="_kenar" is_closed="1">
             	<cf_form_list id="_kenar">
            	<tbody style="width:100%;" cellpadding="0" cellspacing="0" border="0">
                	<tr>
                    	<td style="width:35px; height:25px;text-align:center">
                        	<img src="/images/production/ust.gif" title="<cf_get_lang_main no='573.Üst'> <cf_get_lang_main no='2883.Arka'>" style="text-align:center; vertical-align:middle;width:25px; height:20px" />
                        </td>
                        <td style="width:200px; text-align:left">
                        	<select name="pvc_materials_1" id="pvc_materials_1" style="width:180px;height:20px;<cfif not Listlen(s_stock_id_list)>display:none</cfif>">
								<cfoutput query="get_pvc">
                                    <option value="#STOCK_ID#" <cfif S_TYPE eq 0>style="font-weight:bold" <cfif default_pvc_thickness eq KALINLIK_ETKISI_ID>selected </cfif></cfif>>#PRODUCT_NAME#</option>
                                </cfoutput>
                            </select>
                        </td>
                        <td style="width:25px; text-align:center">
                            <cfif Listlen(s_stock_id_list)>
                                <a style="cursor:pointer" onclick="change_image(1);">
                                    <img src="images/production/true.png" style="width:15px; height:15px" title="<cf_get_lang_main no='2886.Seçildi'>" id="true_false_1">
                                </a>
                                <cfinput type="hidden" id="anahtar_1" name="anahtar_1" value="1">
                            <cfelse>
                            	<a style="cursor:pointer" onclick="change_image(1);">
                                    <img src="images/production/false.png" style="width:15px; height:15px" title="<cf_get_lang_main no='2887.Seçilmedi'>" id="true_false_1">
                                </a>
                                <cfinput type="hidden" id="anahtar_1" name="anahtar_1" value="0">
                            </cfif>
                            
                        </td>
                    </tr>
                    <tr>
                    	<td style="height:25px;text-align:center">
                        	<img src="/images/production/alt.gif" title="<cf_get_lang_main no='574.Alt'> <cf_get_lang_main no='2884.Ön'>" style="text-align:center; vertical-align:middle;width:25px;height:20px" />
                        </td>
                        <td style="text-align:left">
                        	<select name="pvc_materials_2" id="pvc_materials_2" style="width:180px;height:20px;<cfif not Listlen(s_stock_id_list)>display:none</cfif>">
								<cfoutput query="get_pvc">
                                    <option value="#STOCK_ID#" <cfif S_TYPE eq 0>style="font-weight:bold" <cfif default_pvc_thickness eq KALINLIK_ETKISI_ID>selected </cfif></cfif>>#PRODUCT_NAME#</option>
                                </cfoutput>
                            </select>
                        </td>
                        <td style="text-align:center">
                        	<cfif Listlen(s_stock_id_list)>
                                <a style="cursor:pointer" onclick="change_image(2);">
                                    <img src="images/production/true.png" style="width:15px; height:15px" title="<cf_get_lang_main no='2886.Seçildi'>" id="true_false_2">
                                </a>
                                <cfinput type="hidden" id="anahtar_2" name="anahtar_2" value="1">
                            <cfelse>
                            	<a style="cursor:pointer" onclick="change_image(2);">
                                    <img src="images/production/false.png" style="width:15px; height:15px" title="<cf_get_lang_main no='2887.Seçilmedi'>" id="true_false_2">
                                </a>
                                <cfinput type="hidden" id="anahtar_2" name="anahtar_2" value="0">
                            </cfif>
                        </td>
                    </tr>
                    <tr>
                    	<td style="height:25px;text-align:center">
                        	<img src="/images/production/sol_yan.gif" title="<cf_get_lang_main no='2885.Sağ'> <cf_get_lang_main no='573.Üst'>" style="text-align:center; vertical-align:middle;height:20px" />
                        </td>
                        <td style="text-align:left">
                        	<select name="pvc_materials_3" id="pvc_materials_3" style="width:180px;height:20px;<cfif not Listlen(s_stock_id_list)>display:none</cfif>">
								<cfoutput query="get_pvc">
                                    <option value="#STOCK_ID#" <cfif S_TYPE eq 0>style="font-weight:bold" <cfif default_pvc_thickness eq KALINLIK_ETKISI_ID>selected </cfif></cfif>>#PRODUCT_NAME#</option>
                                </cfoutput>
                            </select>
                        </td>
                        <td style="text-align:center">
                        	<cfif Listlen(s_stock_id_list)>
                                <a style="cursor:pointer" onclick="change_image(3);">
                                    <img src="images/production/true.png" style="width:15px; height:15px" title="<cf_get_lang_main no='2886.Seçildi'>" id="true_false_3">
                                </a>
                                <cfinput type="hidden" id="anahtar_3" name="anahtar_3" value="1">
                            <cfelse>
                            	<a style="cursor:pointer" onclick="change_image(3);">
                                    <img src="images/production/false.png" style="width:15px; height:15px" title="<cf_get_lang_main no='2887.Seçilmedi'>" id="true_false_3">
                                </a>
                                <cfinput type="hidden" id="anahtar_3" name="anahtar_3" value="0">
                            </cfif>
                        </td>
                    </tr>
                    <tr>
                    	<td style="height:25px;text-align:center">
                        	<img src="/images/production/sag_yan.gif" title="<cf_get_lang_main no='2888.Sol'> <cf_get_lang_main no='574.Alt'>" style="text-align:center; vertical-align:middle;height:20px" />
                        </td>
                        <td style="text-align:left">
                        	<select name="pvc_materials_4" id="pvc_materials_4" style="width:180px;height:20px;<cfif not Listlen(s_stock_id_list)>display:none</cfif>">
								<cfoutput query="get_pvc">
                                    <option value="#STOCK_ID#" <cfif S_TYPE eq 0>style="font-weight:bold" <cfif default_pvc_thickness eq KALINLIK_ETKISI_ID>selected </cfif></cfif>>#PRODUCT_NAME#</option>
                                </cfoutput>
                            </select>
                        </td>
                        
                        <td style="text-align:center">
                        	<cfif Listlen(s_stock_id_list)>
                                <a style="cursor:pointer" onclick="change_image(4);">
                                    <img src="images/production/true.png" style="width:15px; height:15px" title="<cf_get_lang_main no='2886.Seçildi'>" id="true_false_4">
                                </a>
                                <cfinput type="hidden" id="anahtar_4" name="anahtar_4" value="1">
                            <cfelse>
                            	<a style="cursor:pointer" onclick="change_image(4);">
                                    <img src="images/production/false.png" style="width:15px; height:15px" title="<cf_get_lang_main no='2887.Seçilmedi'>" id="true_false_4">
                                </a>
                                <cfinput type="hidden" id="anahtar_4" name="anahtar_4" value="0">
                            </cfif>
                        </td>
                    </tr>
                    <tr id="trim_rate_">
                    	<td colspan="2" nowrap="nowrap" style="text-align:left; vertical-align:middle; height:25px">
                        	&nbsp;<cf_get_lang_main no='2889.Tıraşlama Payı'> (mm)&nbsp;
                            <select name="trim_type" id="trim_type" style="width:107px;height:20px" onchange="change_trim_type_(this.value);">
                            	<option style=" font-weight:bold" value="0" <cfif attributes.trim_type eq 0>selected</cfif>><cf_get_lang_main no='2892.Tıraşlama Yok'></option>
                            	<option value="1" <cfif attributes.trim_type eq 1>selected</cfif>><cf_get_lang_main no='1132.Sabit'><cf_get_lang_main no='2893.Tıraşlama'></option>
                            </select>
                            
                        </td>
                        <td style="text-align:right; vertical-align:middle;">
                        	<span id="trim_rate_display_" style="<cfif attributes.trim_type eq 0>display:none</cfif>">
                        		<cfinput name="trim_rate" id="trim_rate" value="#TlFormat(attributes.trim_rate,1)#" class="box" style="text-align:right; width:20px; vertical-align:middle">
                            </span> 
                       	</td>
                    </tr>
                </tbody>
                <br />
                </cf_form_list>
           		</div>
            
                <div id="aksesuar_" style="width:260px">
                <cf_seperator title="#getLang('main',2894)#" id="_aksesuar" is_closed="1">
                    <cf_form_list id="_aksesuar">
                        <thead>
                            <tr>
                                <th width="20px">
                                    <input type="hidden" name="record_num" id="record_num" value="0">
                                    <a href="javascript:openProducts();"><img src="/images/plus_list.gif"  border="0"></a>
                               	</th>
                                <th width="170px" nowrap="nowrap"><cf_get_lang_main no='40.Stok'></th>
                                <th width="80px"><cf_get_lang_main no='223.Miktar'></th>
                            </tr>
                        </thead>
                       	<tbody name="new_row" id="new_row">
							<cfif get_aksesuar.recordcount>
								<cfoutput query="get_aksesuar">
                                    <tr name="frm_row" id="frm_row#currentrow#">
                                        <td>
                                            <input type="button" class="silbuton" title="<cf_get_lang_main no='51.Sil'>" onclick="sil(#currentrow#);">
                                            <input type="hidden" name="row_kontrol#currentrow#" id="row_kontrol#currentrow#" value="1">
                                        </td>
                                        <td nowrap="nowrap">
                                            <input type="hidden" name="product_id#currentrow#" id="product_id#currentrow#" value="#get_aksesuar.product_id#">
                                            <input type="hidden" name="stock_id#currentrow#" id="stock_id#currentrow#" value="#get_aksesuar.stock_id#">
                                            <input type="text" name="product_name#currentrow#" id="product_name#currentrow#" value="#get_aksesuar.product_name#" style="width:300px;">
                                        </td>
                                        <td><input type="text" name="quantity#currentrow#" id="quantity#currentrow#" value="#get_aksesuar.amount#" style="width:85px; text-align:right;"></td>
                                    </tr>
                                </cfoutput>

                        	</cfif>
                 		</tbody>
                  	</cf_form_list>
                    <br />
            	</div>
                <div id="hizmet_" style="width:260px">
                <cf_seperator title="#getLang('main',2895)#" id="_hizmet" is_closed="1">
                    <cf_form_list id="_hizmet">
                        <thead>
                            <tr>
                                <th width="20px">
                                    <input type="hidden" name="record_num_hzm" id="record_num_hzm" value="0">
                                    <input type="button" class="eklebuton" title="<cf_get_lang_main no='170.Ekle'>" onclick="add_row_hzm();"></th>
                                <th width="170px" nowrap="nowrap"><cfoutput>#getLang('objects',1288)#</cfoutput></th>
                                <th width="80px"><cf_get_lang_main no='223.Miktar'></th>
                            </tr>
                        </thead>
                       	<tbody name="new_row_hzm" id="new_row_hzm">
							<cfif get_hzm.recordcount>
								<cfoutput query="get_hzm">
                                    <tr name="frm_row_hzm" id="frm_row_hzm#currentrow#">
                                        <td>
                                            <input type="button" class="silbuton" title="<cf_get_lang_main no='51.Sil'>" onclick="sil_hzm(#currentrow#);">
                                            <input type="hidden" name="row_kontrol_hzm#currentrow#" id="row_kontrol_hzm#currentrow#" value="1">
                                        </td>
                                        <td nowrap="nowrap">
                                            <input type="hidden" name="pid_hzm#currentrow#" id="pid_hzm#currentrow#" value="#get_hzm.product_id#">
                                            <input type="hidden" name="stock_id_hzm#currentrow#" id="stock_id_hzm#currentrow#" value="#get_hzm.stock_id#">
                                            <input type="text" name="urun_hzm#currentrow#" id="urun_hzm#currentrow#" value="#get_hzm.product_name#" style="width:300px;">
                                            <a href="javascript://" onclick="pencere_ac_hzm(#currentrow#);"><img src="/images/plus_thin.gif" align="absmiddle" border="0"></a>
                                        </td>
                                        <td><input type="text" name="quantity_hzm#currentrow#" id="quantity_hzm#currentrow#" value="#get_hzm.amount#" style="width:85px; text-align:right;"></td>
                                    </tr>
                                </cfoutput>
                        	</cfif>
                 		</tbody>
                  	</cf_form_list>
            	</div>
        </cf_area>
	    <cf_form_box_footer>
		    <cf_workcube_buttons is_upd='0' add_function='kontrol()'>
	    </cf_form_box_footer>
	</cfform>
</cf_form_box>
<script type="text/javascript">
	var row_count=document.add_piece_main_row.record_num.value;
	var row_count_hzm=document.add_piece_main_row.record_num_hzm.value;
	var row_count_yrm=document.add_piece_main_row.record_num_yrm.value;
	function piece_types()
	{
		if(document.getElementById('piece_type').value == 1)
		{
			document.getElementById('piece_kod_').style.display = "";
			document.getElementById('piece_default_type_').style.display = "";
			document.getElementById('piece_color_').style.display = "";
			document.getElementById('piece_kalinlik_').style.display = "";
			document.getElementById('piece_boy_').style.display = "";
			document.getElementById('piece_en_').style.display = "";
			document.getElementById('piece_su_yonu_').style.display = "";
			document.getElementById('piece_related_name_').style.display = "none";
			document.getElementById('piece_price_').style.display = "none";
			document.getElementById('piece_name_').style.display = "";
			document.getElementById('yonga_levha_').style.display = "";
			document.getElementById('yari_mamul_').style.display = "none";
			document.getElementById('kenar_').style.display = "";
			document.getElementById('trim_rate_').style.display = "";
			document.getElementById('aksesuar_').style.display = "";
			document.getElementById('hizmet_').style.display = "";
			document.getElementById('piece_color__').style.display = "";
			document.getElementById('piece_boy__').style.display = "";
			document.getElementById('piece_en__').style.display = "";
			document.getElementById('piece_kalinlik__').style.display = "";
			set_pvc(document.getElementById("piece_kalinlik").value);
		}
		else if(document.getElementById('piece_type').value == 2)
		{
			document.getElementById('piece_kod_').style.display = "none";
			document.getElementById('piece_default_type_').style.display = "";
			document.getElementById('piece_color_').style.display = "";
			document.getElementById('piece_kalinlik_').style.display = "none";
			document.getElementById('piece_boy_').style.display = "";
			document.getElementById('piece_en_').style.display = "none";
			document.getElementById('piece_su_yonu_').style.display = "none";
			document.getElementById('piece_related_name_').style.display = "none";
			document.getElementById('piece_price_').style.display = "none";
			document.getElementById('piece_name_').style.display = "";
			document.getElementById('yonga_levha_').style.display = "none";
			document.getElementById('yari_mamul_').style.display = "none";
			document.getElementById('kenar_').style.display = "none";
			document.getElementById('aksesuar_').style.display = "";
			document.getElementById('hizmet_').style.display = "none";
			document.getElementById('piece_boy__').style.display = "none";
			document.getElementById('piece_color__').style.display = "none";
		}
		else if(document.getElementById('piece_type').value == 3)
		{
			document.getElementById('piece_kod_').style.display = "none";
			document.getElementById('piece_default_type_').style.display = "";
			document.getElementById('piece_color_').style.display = "";
			document.getElementById('piece_kalinlik_').style.display = "";
			document.getElementById('piece_boy_').style.display = "";
			document.getElementById('piece_en_').style.display = "";
			document.getElementById('piece_su_yonu_').style.display = "none";
			document.getElementById('piece_related_name_').style.display = "none";
			document.getElementById('piece_price_').style.display = "none";
			document.getElementById('piece_name_').style.display = "";
			document.getElementById('yonga_levha_').style.display = "none";
			document.getElementById('yari_mamul_').style.display = "";
			document.getElementById('kenar_').style.display = "";
			document.getElementById('trim_rate_').style.display = "none";
			document.getElementById('aksesuar_').style.display = "";
			document.getElementById('hizmet_').style.display = "none";
			document.getElementById('piece_color__').style.display = "";
			document.getElementById('piece_boy__').style.display = "none";
			document.getElementById('piece_en__').style.display = "none";
			document.getElementById('piece_kalinlik__').style.display = "none";
			set_pvc(0);
			document.getElementById('piece_kalinlik').selectedIndex=0;
			for(var kk=1;kk<=4;kk++)
			{
				document.getElementById("true_false_"+kk).src="images/production/false.png";
				document.getElementById("anahtar_"+kk).value = 0;
				document.getElementById("pvc_materials_"+kk).style.display="none";
			}
		}
		else if(document.getElementById('piece_type').value == 4)
		{
			document.getElementById('piece_kod_').style.display = "none";
			document.getElementById('piece_default_type_').style.display = "none";
			document.getElementById('piece_color_').style.display = "none";
			document.getElementById('piece_kalinlik_').style.display = "none";
			document.getElementById('piece_boy_').style.display = "none";
			document.getElementById('piece_en_').style.display = "none";
			document.getElementById('piece_su_yonu_').style.display = "none";
			document.getElementById('piece_related_name_').style.display = "";
			document.getElementById('piece_price_').style.display = "";
			document.getElementById('piece_name_').style.display = "none";
			document.getElementById('yonga_levha_').style.display = "none";
			document.getElementById('yari_mamul_').style.display = "none";
			document.getElementById('kenar_').style.display = "none";
			document.getElementById('aksesuar_').style.display = "none";
			document.getElementById('hizmet_').style.display = "none";
		}
	}
	function piece_floor_no()
	{
		<cfif get_design.PROCESS_ID eq 1>
		if(document.getElementById('piece_package_no').value == '')
		{
			document.getElementById('piece_package_floor_no_').style.display = "none";
			document.getElementById('piece_package_rota_').style.display = "none";
			document.getElementById('piece_package_floor_no').value = '';
			document.getElementById('piece_package_rota').value = '';
		}
		else
		{
			document.getElementById('piece_package_floor_no_').style.display = "";
			document.getElementById('piece_package_rota_').style.display = "";
		}
		</cfif>
	}
	function hesapla()
	{
		var main_row_name = <cfoutput>'#main_setup_name#'</cfoutput>;
		
		if(document.getElementById('default_type').value > 0)
		{
			
			<cfloop query="get_piece_defaults">
				setup_default_id = <cfoutput>#get_piece_defaults.piece_default_id#</cfoutput>;
				setup_default_name = <cfoutput>'#get_piece_defaults.piece_default_name#'</cfoutput>;
				if(document.getElementById('default_type').value == setup_default_id)
				{
					main_row_name = main_row_name +' '+ setup_default_name;
					if(document.getElementById('piece_type').value == 3)
					main_row_name = main_row_name +' M';
				}
			</cfloop>
		}
		document.getElementById('design_name_piece_row').value = main_row_name;
	}
	function set_thickness(color_id_)
	{
		default_thickness = <cfoutput>#default_thickness#</cfoutput>;
		var thickness_names = 
		wrk_query("SELECT THICKNESS_ID, THICKNESS_VALUE, THICKNESS_NAME, UNIT FROM EZGI_DESIGN_PRODUCT_PROPERTIES_UST AS EP WHERE LIST_ORDER_NO = 1 AND COLOR_ID = "+color_id_+"ORDER BY THICKNESS_NAME","dsn3");
		var option_count = document.getElementById('piece_kalinlik').options.length; 
		for(x=option_count;x>=0;x--)
			document.getElementById('piece_kalinlik').options[x] = null;
		if(thickness_names.recordcount != 0)
		{	
			document.getElementById('piece_kalinlik').options[0] = new Option('Seçiniz','');
			for(var xx=0;xx<thickness_names.recordcount;xx++)
			{
				document.getElementById('piece_kalinlik').options[xx+1]=new Option(thickness_names.THICKNESS_NAME[xx],thickness_names.THICKNESS_ID[xx],thickness_names.UNIT[xx]);
				if(thickness_names.THICKNESS_ID[xx] == default_thickness)
				{
					document.getElementById('piece_kalinlik').selectedIndex=xx+1;
				}
			}
		}
		else
			document.getElementById('piece_kalinlik').options[0] = new Option('Seçiniz','');
		thickness_=document.getElementById('piece_kalinlik').value;
		set_product(thickness_);
		set_pvc(thickness_);
	}
	function set_product(thickness_)
	{
		default_thickness = <cfoutput>#default_thickness#</cfoutput>;
		if(document.getElementById('color_type').value >0 && thickness_ >0)
		{
			var product_names = 
			wrk_query("SELECT THICKNESS_ID, UNIT, STOCK_ID, PRODUCT_NAME FROM EZGI_DESIGN_PRODUCT_PROPERTIES_UST AS EP WHERE LIST_ORDER_NO = 1 AND COLOR_ID = "+document.getElementById('color_type').value+" AND THICKNESS_ID ="+thickness_,"dsn3");
		}
		else if(document.getElementById('color_type').value >0 && thickness_ <=0)
		{
			var product_names = 
			wrk_query("SELECT THICKNESS_ID, UNIT, STOCK_ID, PRODUCT_NAME FROM EZGI_DESIGN_PRODUCT_PROPERTIES_UST AS EP WHERE LIST_ORDER_NO = 1 AND COLOR_ID = "+document.getElementById('color_type').value,"dsn3");
		}
		var option_count = document.getElementById('piece_yonga_levha').options.length; 
		for(x=option_count;x>=0;x--)
			document.getElementById('piece_yonga_levha').options[x] = null;
		if(product_names.recordcount != 0)
		{	
			document.getElementById('piece_yonga_levha').options[0] = new Option('Seçiniz','');
			for(var xx=0;xx<product_names.recordcount;xx++)
				document.getElementById('piece_yonga_levha').options[xx+1]=new Option(product_names.PRODUCT_NAME[xx],product_names.STOCK_ID[xx],product_names.UNIT[xx],product_names.THICKNESS_ID[xx]);
				if(product_names.THICKNESS_ID[xx] == default_thickness)
				{
					document.getElementById('piece_yonga_levha').selectedIndex=xx+1;
				}
		}
		else
		{
			document.getElementById('piece_yonga_levha').options[0] = new Option('Kayıt Yok','');	
		}
		set_pvc(thickness_);
	}
	
	function set_pvc(thickness_)
	{
		for (i = 1; i <= 4; i++)
		{
			if(document.getElementById('color_type').value >0 && thickness_ >0)
			{
				var pvc_name = 
				wrk_query("SELECT THICKNESS_ID, UNIT, STOCK_ID, PRODUCT_NAME FROM EZGI_DESIGN_PRODUCT_PROPERTIES_UST AS EP WHERE LIST_ORDER_NO = 3 AND THICKNESS_ID ="+thickness_+"UNION ALL SELECT THICKNESS_ID, UNIT, STOCK_ID, PRODUCT_NAME FROM EZGI_DESIGN_PRODUCT_PROPERTIES_UST AS EP WHERE LIST_ORDER_NO = 3 AND COLOR_ID = "+document.getElementById('color_type').value+" AND THICKNESS_ID ="+thickness_,"dsn3");
			}
			else if(document.getElementById('color_type').value >0 && thickness_ <=0)
			{
				var pvc_name = 
				wrk_query("SELECT THICKNESS_ID, UNIT, STOCK_ID, PRODUCT_NAME FROM EZGI_DESIGN_PRODUCT_PROPERTIES_UST AS EP WHERE LIST_ORDER_NO = 3","dsn3");
			}
			var option_count_pvc = document.getElementById('pvc_materials_'+i).options.length; 
			for(x=option_count_pvc;x>=0;x--)
				document.getElementById('pvc_materials_'+i).options[x] = null;
			if(pvc_name.recordcount != 0)
			{	
				document.getElementById('pvc_materials_'+i).options[0] = new Option('Seçiniz','');
				for(var xx=0;xx<pvc_name.recordcount;xx++)
				{
					document.getElementById('pvc_materials_'+i).options[xx+1]=new Option(pvc_name.PRODUCT_NAME[xx],pvc_name.STOCK_ID[xx],pvc_name.UNIT[xx],pvc_name.THICKNESS_ID[xx]);
					document.getElementById('pvc_materials_'+i).selectedIndex=xx+1;
				}
				if(document.getElementById('piece_type').value != 3)
				{
					document.getElementById("true_false_"+i).src="images/production/true.png";
					document.getElementById("anahtar_"+i).value = 1;
					document.getElementById("pvc_materials_"+i).style.display="";
				}
			}
			else
			{
				if(document.getElementById('piece_type').value != 3)
				{
					document.getElementById('pvc_materials_'+i).options[0] = new Option('Kayıt Yok','');	
					document.getElementById("true_false_"+i).src="images/production/false.png";
					document.getElementById("anahtar_"+i).value = 0;
					document.getElementById("pvc_materials_"+i).style.display="none";
				}
			}
		}
	}
	
	function change_image(kenar_id)
	{
		if(document.getElementById("anahtar_"+kenar_id).value == 0)
		{
			document.getElementById("true_false_"+kenar_id).src="images/production/true.png";
			document.getElementById("anahtar_"+kenar_id).value = 1;
			document.getElementById("pvc_materials_"+kenar_id).style.display="";
			if(document.getElementById("piece_type").value == 3 && (kenar_id == 1 || kenar_id == 2))
				document.getElementById('piece_en__').style.display = "";
			if(document.getElementById("piece_type").value == 3 && (kenar_id == 3 || kenar_id == 4))
				document.getElementById('piece_boy__').style.display = "";
		}
		else
		{
			document.getElementById("true_false_"+kenar_id).src="images/production/false.png";
			document.getElementById("anahtar_"+kenar_id).value = 0;
			document.getElementById("pvc_materials_"+kenar_id).style.display="none";
			if(document.getElementById("piece_type").value == 3 && kenar_id == 1)
			{
				if(document.getElementById("anahtar_2").value == 0)
				document.getElementById('piece_en__').style.display = "none";
			}
			if(document.getElementById("piece_type").value == 3 && kenar_id == 2)
			{
				if(document.getElementById("anahtar_1").value == 0)
				document.getElementById('piece_en__').style.display = "none";
			}
			if(document.getElementById("piece_type").value == 3 && kenar_id == 3)
			{
				if(document.getElementById("anahtar_4").value == 0)
				document.getElementById('piece_boy__').style.display = "none";
			}
			if(document.getElementById("piece_type").value == 3 && kenar_id == 4)
			{
				if(document.getElementById("anahtar_3").value == 0)
				document.getElementById('piece_boy__').style.display = "none";
			}
		}
	}
	function change_trim_type_(trim_type)
	{
		if(trim_type == 1)
		document.getElementById("trim_rate_display_").style.display="";
		else
		document.getElementById("trim_rate_display_").style.display="none";
	}
	function openProducts()
	{
		windowopen('<cfoutput>#request.self#?fuseaction=prod.popup_ezgi_stocks&price_cat=-2&list_order_no=3,4&add_product_cost=1&module_name=product&var_=#var_#&is_action=1&startdate=&price_lists='</cfoutput>,'page');
	}
	function add_row(stockid,stockprop,sirano,product_id,product_name,manufact_code,tax,tax_purchase,add_unit,product_unit_id,money,is_serial_no,discount1,discount2,discount3,discount4,discount5,discount6,discount7,discount8,discount9,discount10,del_date_no,p_price,s_price,product_cost,extra_product_cost,is_production,list_price,other_list_price,spec_main_id,spec_main_name)
	{
		row_count++;
		var newRow;
		var newCell;
		newRow = document.getElementById("new_row").insertRow(document.getElementById("new_row").rows.length);
		newRow.className = 'color-row';
		newRow.setAttribute("name","frm_row" + row_count);
		newRow.setAttribute("id","frm_row" + row_count);
		newRow.setAttribute("NAME","frm_row" + row_count);
		newRow.setAttribute("ID","frm_row" + row_count);

		document.add_piece_main_row.record_num.value = row_count;
		
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.setAttribute('nowrap','nowrap');
		newCell.innerHTML = '<a style="cursor:pointer" onclick="sil(' + row_count + ');" ><img src="/images/delete_list.gif" alt="<cf_get_lang_main no='51.Sil'>" border="0"></a>';	
		
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.setAttribute('nowrap','nowrap');
		newCell.innerHTML = '<input type="hidden" value="1" name="row_kontrol'+row_count+'">';
		newCell.innerHTML = newCell.innerHTML + '<input type="Hidden" name="stock_id'+row_count+'" value="' + stockid + '">';
		newCell.innerHTML = newCell.innerHTML + '<input type="hidden" name="product_id'+row_count+'" value="'+product_id+'">';
		newCell.innerHTML = newCell.innerHTML + '<input type="hidden" name="unit_id'+row_count+'" value="'+product_unit_id+'">';
		newCell.innerHTML = newCell.innerHTML + '<input type="text" title="'+add_unit+'" name="product_name' + row_count + '" style="width:160px;" class="boxtext" value="'+product_name+'">';
		
		newCell=newRow.insertCell(newRow.cells.length);
		newCell.innerHTML = '<input type="text" id="quantity' + row_count +'" name="quantity' + row_count +'" value="<cfoutput>#TlFormat(1,4)#</cfoutput>" style="width:50px; text-align:right;">';
	}
	function sil(sy)
	{
	
		var element=eval("add_piece_main_row.row_kontrol"+sy);
		element.value=0;
		var element=eval("frm_row"+sy); 
		element.style.display="none";		
	} 
	
	function add_row_hzm()
	{
		row_count_hzm++;
		var newRow_hzm;
		var newCell_hzm;
		newRow_hzm = document.getElementById("new_row_hzm").insertRow(document.getElementById("new_row_hzm").rows.length);
		newRow_hzm.setAttribute("name","frm_row_hzm" + row_count_hzm);
		newRow_hzm.setAttribute("id","frm_row_hzm" + row_count_hzm);
		newRow_hzm.setAttribute("NAME","frm_row_hzm" + row_count_hzm);
		newRow_hzm.setAttribute("ID","frm_row_hzm" + row_count_hzm);
		
		document.add_piece_main_row.record_num_hzm.value = row_count_hzm;
		
		newCell_hzm = newRow_hzm.insertCell(newRow_hzm.cells.length);
		newCell_hzm.innerHTML = '<a style="cursor:pointer" onclick="sil_hzm(' + row_count_hzm + ');" ><img src="/images/delete_list.gif" alt="<cf_get_lang_main no='51.Sil'>" border="0"></a>';	
			
		newCell_hzm=newRow_hzm.insertCell(newRow_hzm.cells.length);
		newCell_hzm.setAttribute('nowrap','nowrap');
		newCell_hzm.innerHTML = '<input type="hidden" value="1" id="row_kontrol_hzm' + row_count_hzm +'" name="row_kontrol_hzm' + row_count_hzm +'"><input type="text" name="urun_hzm' + row_count_hzm +'" id="urun_hzm'+ row_count_hzm +'" style="width:160px;"><input type="hidden" name="pid_hzm' + row_count_hzm +'" id="pid_hzm'+ row_count_hzm +'"><input type="hidden" name="stock_id_hzm' + row_count_hzm +'" id="stock_id_hzm' + row_count_hzm +'"> <a style="cursor:pointer" href"javascript://" onClick="pencere_ac_hzm('+ row_count_hzm +');"><img src="/images/plus_thin.gif" align="absmiddle" border="0"></a>';
		
		newCell_hzm=newRow_hzm.insertCell(newRow_hzm.cells.length);
		newCell_hzm.innerHTML = '<input type="text" id="quantity_hzm' + row_count_hzm +'" name="quantity_hzm' + row_count_hzm +'" value="<cfoutput>#TlFormat(1,4)#</cfoutput>" style="width:50px; text-align:right;">';
	}
	function pencere_ac_hzm(no_hzm)
	{
		windowopen("<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_ezgi_product_names&list_order_no=5&product_id=add_piece_main_row.pid_hzm" + no_hzm +"&field_id=add_piece_main_row.stock_id_hzm" + no_hzm +"&field_name=add_piece_main_row.urun_hzm" + no_hzm,'list');
	}
	function sil_hzm(sy_hzm)
	{
		
		var element_hzm=eval("add_piece_main_row.row_kontrol_hzm"+sy_hzm);
		element_hzm.value=0;
		var element_hzm=eval("frm_row_hzm"+sy_hzm);
		element_hzm.style.display="none";		
	} 
	
	function add_row_yrm()
	{
		row_count_yrm++;
		var newRow_yrm;
		var newCell_yrm;
		newRow_yrm = document.getElementById("new_row_yrm").insertRow(document.getElementById("new_row_yrm").rows.length);
		newRow_yrm.setAttribute("name","frm_row_yrm" + row_count_yrm);
		newRow_yrm.setAttribute("id","frm_row_yrm" + row_count_yrm);
		newRow_yrm.setAttribute("NAME","frm_row_yrm" + row_count_yrm);
		newRow_yrm.setAttribute("ID","frm_row_yrm" + row_count_yrm);
		
		document.add_piece_main_row.record_num_yrm.value = row_count_yrm;
		
		newCell_yrm = newRow_yrm.insertCell(newRow_yrm.cells.length);
		newCell_yrm.innerHTML = '<a style="cursor:pointer" onclick="sil_yrm(' + row_count_yrm + ');" ><img src="/images/delete_list.gif" alt="<cf_get_lang_main no='51.Sil'>" border="0"></a>';	
			
		newCell_yrm=newRow_yrm.insertCell(newRow_yrm.cells.length);
		newCell_yrm.setAttribute('nowrap','nowrap');
		newCell_yrm.innerHTML = '<select name="piece_yari_mamul'+row_count_yrm+'" id="piece_yari_mamul'+row_count_yrm+'" style="width:160px;height:20px"><cfoutput query="get_montage_product"><option value="#PIECE_ROW_ID#" style="<cfif isdefined('attributes.package_row_id') and attributes.package_row_id eq DESIGN_PACKAGE_ROW_ID>font-weight:bold</cfif>">#PIECE_NAME#</option></cfoutput></select><input type="hidden" value="1" id="row_kontrol_yrm' + row_count_yrm +'" name="row_kontrol_yrm' + row_count_yrm +'">';
		
		newCell_yrm=newRow_yrm.insertCell(newRow_yrm.cells.length);
		newCell_yrm.innerHTML = '<input type="text" id="quantity_yrm' + row_count_yrm +'" name="quantity_yrm' + row_count_yrm +'" value="<cfoutput>#TlFormat(1,4)#</cfoutput>" style="width:50px; text-align:right;">';
	}
	function pencere_ac_yrm(no_yrm)
	{
		windowopen("<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_ezgi_product_names&list_order_no=5&product_id=add_piece_main_row.pid_yrm" + no_yrm +"&field_id=add_piece_main_row.stock_id_yrm" + no_yrm +"&field_name=add_piece_main_row.urun_yrm" + no_yrm,'list');
	}
	function sil_yrm(sy_yrm)
	{
	
		var element_yrm=eval("add_piece_main_row.row_kontrol_yrm"+sy_yrm);
		element_yrm.value=0;
		var element_yrm=eval("frm_row_yrm"+sy_yrm); 
		element_yrm.style.display="none";		
	} 
	
	function kontrol()
	{
		if(document.getElementById("piece_amount").value <=0)
		{
			alert("<cf_get_lang_main no='782.Girilmesi Zorunlu Alan'> <cf_get_lang_main no='223.Miktar'> !");
			document.getElementById('piece_amount').focus();
			return false;
		}
		if(document.getElementById("piece_type").value == 1 || document.getElementById("piece_type").value == 2 || document.getElementById("piece_type").value == 3)
		{
			if(document.getElementById("default_type").value == "")
			{
				alert("<cf_get_lang_main no='782.Girilmesi Zorunlu Alan'> <cf_get_lang_main no='1555.Örnek'> <cf_get_lang_main no='2848.Parça'> !");
				document.getElementById('default_type').focus();
				return false;
			}
			if(document.getElementById("design_name_piece_row").value == "" || document.getElementById("design_name_piece_row").value <=0)
			{
				alert("<cf_get_lang_main no='782.Girilmesi Zorunlu Alan'> <cf_get_lang_main no='2848.Parça'> <cf_get_lang_main no='485.Adı'> !");
				document.getElementById('design_name_piece_row').focus();
				return false;
			}
			if(document.getElementById("record_num").value > 0)
			{
				sayi = document.getElementById("record_num").value;
				for (i = 1; i <= sayi; i++)
				{
					if(document.getElementById("quantity"+i).value <=0 && document.getElementById("row_kontrol"+i).value == 1)
					{
						alert(i+'. <cf_get_lang_main no='2896.Satırdaki Aksesuarın Miktarı Sıfırdan Büyük Olmalıdır'> !');
						document.getElementById("quantity"+i).focus();
						return false;
					}
					if(document.getElementById("stock_id"+i).value <=0 && document.getElementById("row_kontrol"+i).value == 1)
					{
						alert(i+'. <cf_get_lang_main no='2986.Satırdaki Aksesuar Seçilmemiştir'> !');
						document.getElementById("urun"+i).focus();
						return false;
					}
				}
			}
			if(document.getElementById("record_num_hzm").value > 0)
			{
				sayi = document.getElementById("record_num_hzm").value;
				for (i = 1; i <= sayi; i++)
				{
					if(document.getElementById("quantity_hzm"+i).value <=0 && document.getElementById("row_kontrol_hzm"+i).value == 1)
					{
						alert(i+'. <cf_get_lang_main no='2987.Satırdaki Hizmet Giderinin Miktarı Sıfırdan Büyük Olmalıdır'> !');
						document.getElementById("quantity_hzm"+i).focus();
						return false;
					}
					if(document.getElementById("stock_id_hzm"+i).value <=0 && document.getElementById("row_kontrol_hzm"+i).value == 1)
					{
						alert(i+'. <cf_get_lang_main no='2988.Satırdaki Hizmet Gideri Seçilmemiştir'> !');
						document.getElementById("urun_hzm"+i).focus();
						return false;
					}
				}
			}
		}
		if(document.getElementById("piece_type").value == 1 || document.getElementById("piece_type").value == 3)
		{
			if(document.getElementById("color_type").value == 0)
			{
				alert("<cf_get_lang_main no='782.Girilmesi Zorunlu Alan'> <cf_get_lang_main no='1968.Renk Düzenle'>!");
				document.getElementById('color_type').focus();
				return false;
			}
			if(document.getElementById("anahtar_1").value == 1 && document.getElementById("pvc_materials_1").value <=0)
			{
				alert("<cf_get_lang_main no='2897.1.Sırada PVC Seçildiğinde Mutlaka Satır Seçilmelidir'> !");
				document.getElementById('pvc_materials_1').focus();
				return false;
			}
			if(document.getElementById("anahtar_2").value == 1 && document.getElementById("pvc_materials_2").value <=0)
			{
				alert("<cf_get_lang_main no='2898.2.Sırada PVC Seçildiğinde Mutlaka Satır Seçilmelidir'> !");
				document.getElementById('pvc_materials_2').focus();
				return false;
			}
			if(document.getElementById("anahtar_3").value == 1 && document.getElementById("pvc_materials_3").value <=0)
			{
				alert("<cf_get_lang_main no='2899.3.Sırada PVC Seçildiğinde Mutlaka Satır Seçilmelidir'> !");
				document.getElementById('pvc_materials_3').focus();
				return false;
			}
			if(document.getElementById("anahtar_4").value == 1 && document.getElementById("pvc_materials_4").value <=0)
			{
				alert("<cf_get_lang_main no='2900.4.Sırada PVC Seçildiğinde Mutlaka Satır Seçilmelidir'> !");
				document.getElementById('pvc_materials_4').focus();
				return false;
			}
			if(document.getElementById("anahtar_1").value == 1 || document.getElementById("anahtar_2").value == 1)
			{
				if(document.getElementById("piece_en").value <= 0)
				{
					alert("<cf_get_lang_main no='782.Girilmesi Zorunlu Alan'> <cf_get_lang_main no='2901.En'>!");
					document.getElementById('piece_en').focus();
					return false;
				}
			}
			if (document.getElementById("anahtar_3").value == 1 || document.getElementById("anahtar_4").value == 1)
			{
				if(document.getElementById("piece_boy").value <= 0)
				{
					alert("<cf_get_lang_main no='782.Girilmesi Zorunlu Alan'> <cf_get_lang_main no='2902.Boy'> !");
					document.getElementById('piece_boy').focus();
					return false;
				}
			}
		}
		if(document.getElementById("piece_type").value == 1)
		{
			if(document.getElementById("piece_boy").value <= 0)
			{
				alert("<cf_get_lang_main no='782.Girilmesi Zorunlu Alan'> <cf_get_lang_main no='2902.Boy'> !");
				document.getElementById('piece_boy').focus();
				return false;
			}
			if(document.getElementById("piece_en").value <= 0)
			{
				alert("<cf_get_lang_main no='782.Girilmesi Zorunlu Alan'> <cf_get_lang_main no='2901.En'> !");
				document.getElementById('piece_en').focus();
				return false;
			}
			if(document.getElementById("piece_kalinlik").value <= 0)
			{
				alert("<cf_get_lang_main no='782.Girilmesi Zorunlu Alan'> <cf_get_lang_main no='2878.Kalınlık'> !");
				document.getElementById('piece_kalinlik').focus();
				return false;
			}
			if(document.getElementById("piece_yonga_levha").value <= 0)
			{
				alert("<cf_get_lang_main no='782.Girilmesi Zorunlu Alan'> <cf_get_lang_main no='2865.Yonga Levha'> !");
				document.getElementById('piece_yonga_levha').focus();
				return false;
			}
			
		}
		if(document.getElementById("piece_type").value == 4)
		{
			if(document.getElementById("related_product_name").value <= 0)
			{
				alert("<cf_get_lang_main no='782.Girilmesi Zorunlu Alan'> <cf_get_lang_main no ='245.Ürün'> <cf_get_lang_main no ='485.Adı'> !");
				document.getElementById('related_product_name').focus();
				return false;
			}
		}
		if(document.getElementById("piece_type").value == 3)
		{
			if(document.getElementById('piece_package_no').value <= 0)
			{
			 	alert("<cf_get_lang_main no='782.Girilmesi Zorunlu Alan'> <cf_get_lang_main no='2903.Paket'> <cf_get_lang_main no='75.No'> !");
				document.getElementById("piece_package_no").focus();
				return false;
			}
			if(document.getElementById("record_num_yrm").value <= 0)
			{
				alert("<cf_get_lang_main no='782.Girilmesi Zorunlu Alan'> <cf_get_lang_main no='2881.Montaj Edilecek Yarımamüller'> !");
				document.getElementById("record_num_yrm").focus();
				return false;
			}
			else
			{
				sayi = document.getElementById("record_num_yrm").value;
				control_double_id = '';
				for (i = 1; i <= sayi; i++)
				{
					if(document.getElementById("quantity_yrm"+i).value <=0 && document.getElementById("row_kontrol_yrm"+i).value == 1)
					{
						alert(i+'. <cf_get_lang_main no='2989.Satırdaki Montaj Edilecek Ürünün Miktarı Sıfırdan Büyük Olmalıdır'> !');
						document.getElementById("quantity_yrm"+i).focus();
						return false;
					}
					if(document.getElementById("piece_yari_mamul"+i).value <=0 && document.getElementById("row_kontrol_yrm"+i).value == 1)
					{
						alert(i+'. <cf_get_lang_main no='2990.Satırdaki Montaj Edilecek Ürün Seçilmemiştir'> !');
						document.getElementById("piece_yari_mamul"+i).focus();
						return false;
					}
					<!---else
					{
						if(document.getElementById("piece_yari_mamul"+i).value)
						{
							var control_id = document.getElementById("piece_yari_mamul"+i).value;
							if(list_len(control_double_id,','))
							{
								var is_finder = list_find(control_double_id,control_id,',');
								if(is_finder >0)
								{
									alert(i+'. Sıradaki Montaj Edilecek Ürün Birden Fazla Satırda Kullanılmış !');
									document.getElementById("piece_yari_mamul"+i).focus();
									return false;
								}
								else
									control_double_id +=control_id+',';
							}
							else
								control_double_id +=control_id+',';	
						}
					}--->
				}
			}
		}
	}
	
</script>