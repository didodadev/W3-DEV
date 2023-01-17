<cfparam name="attributes.related_product_id" default="">
<cfparam name="attributes.related_stock_id" default="">
<cfparam name="attributes.related_product_name" default="">
<cfparam name="attributes.package_row_id" default="">
<cfset module_name="product">
<cfset var_="upd_purchase_basket">
<cfquery name="get_money" datasource="#dsn2#">
	SELECT MONEY FROM SETUP_MONEY
</cfquery>
<cfquery name="get_design_piece_image" datasource="#dsn3#">
	SELECT TOP (1) * FROM EZGI_DESIGN_PIECE_IMAGES WHERE DESIGN_PIECE_ROW_ID = #attributes.design_piece_row_id# ORDER BY DESIGN_PIECE_ROW_ID DESC
</cfquery>
<cfquery name="piece_minus_id" datasource="#dsn3#">
	SELECT        
    	TOP (1) EDP1.PIECE_ROW_ID
	FROM            
    	EZGI_DESIGN_PIECE AS EDP INNER JOIN
      	EZGI_DESIGN_PIECE AS EDP1 ON EDP.DESIGN_MAIN_ROW_ID = EDP1.DESIGN_MAIN_ROW_ID AND EDP.PIECE_CODE > EDP1.PIECE_CODE
	WHERE        
    	EDP.PIECE_ROW_ID = #attributes.design_piece_row_id#
	ORDER BY 
    	EDP1.PIECE_CODE DESC
</cfquery>
<cfquery name="piece_plus_id" datasource="#dsn3#">
	SELECT        
    	TOP (1) EDP1.PIECE_ROW_ID
	FROM            
    	EZGI_DESIGN_PIECE AS EDP INNER JOIN
     	EZGI_DESIGN_PIECE AS EDP1 ON EDP.DESIGN_MAIN_ROW_ID = EDP1.DESIGN_MAIN_ROW_ID AND EDP.PIECE_CODE < EDP1.PIECE_CODE
	WHERE        
    	EDP.PIECE_ROW_ID = #attributes.design_piece_row_id#
	ORDER BY 
    	EDP1.PIECE_CODE
</cfquery>
<cfif isdefined('attributes.erp_link')>
	<!---Bağlantılı Paket ve Modüller Çekiliyor--->
    <cfquery name="get_related_design" datasource="#dsn3#">
        SELECT        
            EDP.PIECE_ROW_ID, 
            EDP.DESIGN_ID, 
            EDP.DESIGN_MAIN_ROW_ID, 
            EDP.DESIGN_PACKAGE_ROW_ID, 
            EDM.DESIGN_MAIN_NAME, 
            EDR.PACKAGE_NAME
        FROM           	
            EZGI_DESIGN_PIECE_ROWS AS EDP INNER JOIN
            EZGI_DESIGN_MAIN_ROW AS EDM ON EDP.DESIGN_MAIN_ROW_ID = EDM.DESIGN_MAIN_ROW_ID INNER JOIN
            EZGI_DESIGN_PACKAGE_ROW AS EDR ON EDP.DESIGN_PACKAGE_ROW_ID = EDR.PACKAGE_ROW_ID
        WHERE        
            EDP.PIECE_ROW_ID = #attributes.design_piece_row_id#
    </cfquery>
</cfif>
<cfquery name="get_upd_piece" datasource="#dsn3#"> <!---Update Edilecek Parçanın Bilgileri--->
	SELECT * FROM EZGI_DESIGN_PIECE WHERE PIECE_ROW_ID = #attributes.design_piece_row_id#
</cfquery>
<cfquery name="get_upd_piece_row" datasource="#dsn3#"> <!---Update Edilecek Parçanın Satır Bilgileri--->
	SELECT 
    	* ,
        (SELECT TOP (1) PIECE_NAME FROM EZGI_DESIGN_PIECE WHERE PIECE_ROW_ID = EZGI_DESIGN_PIECE_ROW.RELATED_PIECE_ROW_ID) AS PIECE_NAME,
        (SELECT TOP (1) PIECE_CODE FROM EZGI_DESIGN_PIECE WHERE PIECE_ROW_ID = EZGI_DESIGN_PIECE_ROW.RELATED_PIECE_ROW_ID) AS PIECE_CODE,
        (SELECT PRODUCT_ID FROM STOCKS WHERE STOCK_ID = EZGI_DESIGN_PIECE_ROW.STOCK_ID) AS PRODUCT_ID,
        (SELECT PRODUCT_NAME FROM STOCKS WHERE STOCK_ID = EZGI_DESIGN_PIECE_ROW.STOCK_ID) AS PRODUCT_NAME
  	FROM 
    	EZGI_DESIGN_PIECE_ROW 
 	WHERE 
    	PIECE_ROW_ID = #attributes.design_piece_row_id#
</cfquery>
<cfquery name="is_montage_used" datasource="#dsn3#"> <!---Bu Ürün Montajda Kullanıldı mı--->
	SELECT        
    	EZGI_DESIGN_PIECE_ROW.PIECE_ROW_ID, 
        EZGI_DESIGN_PIECE_ROW.RELATED_PIECE_ROW_ID
	FROM            
    	EZGI_DESIGN_PIECE_ROW INNER JOIN
     	EZGI_DESIGN_PIECE ON EZGI_DESIGN_PIECE_ROW.RELATED_PIECE_ROW_ID = EZGI_DESIGN_PIECE.PIECE_ROW_ID
	WHERE        
    	EZGI_DESIGN_PIECE_ROW.RELATED_PIECE_ROW_ID = #attributes.design_piece_row_id#

</cfquery>
<cfquery name="get_montage_product" datasource="#dsn3#">  <!---Montaj Edilebilecek Parçalara Bu Parçadaki Montaj Edilmiş Parçaların Eklenmesi--->
	SELECT        
    	PIECE_ROW_ID, 
        PIECE_NAME, 
        PIECE_CODE, 
        SUM(PIECE_AMOUNT) AS PIECE_AMOUNT, 
        SUM(USED_AMOUNT) AS USED_AMOUNT
	FROM            
    	(
        	SELECT        
            	E.PIECE_ROW_ID, 
                E.PIECE_NAME, 
                E.PIECE_CODE, 
                E.PIECE_AMOUNT, 
                ISNULL(TBL_1.AMOUNT, 0) AS USED_AMOUNT
        	FROM            
            	EZGI_DESIGN_PIECE AS E LEFT OUTER JOIN
           		(
                	SELECT        
                    	RELATED_PIECE_ROW_ID, 
                        SUM(AMOUNT) AS AMOUNT
                	FROM            
                    	EZGI_DESIGN_PIECE_ROW
                 	GROUP BY 
                    	RELATED_PIECE_ROW_ID
            	) AS TBL_1 ON E.PIECE_ROW_ID = TBL_1.RELATED_PIECE_ROW_ID
     		WHERE        
            	E.PIECE_TYPE IN (1,2) AND 
                E.PIECE_STATUS = 1 AND 
                E.DESIGN_MAIN_ROW_ID = #get_upd_piece.DESIGN_MAIN_ROW_ID# AND
                ISNULL(TBL_1.AMOUNT, 0) < E.PIECE_AMOUNT
       		UNION ALL
      		SELECT        
            	EPR.RELATED_PIECE_ROW_ID, 
                EP.PIECE_NAME, 
                EP.PIECE_CODE, 
                EPR.AMOUNT, 
                0 AS USED_AMOUNT
       		FROM            
            	EZGI_DESIGN_PIECE_ROW AS EPR INNER JOIN
           		EZGI_DESIGN_PIECE AS EP ON EPR.RELATED_PIECE_ROW_ID = EP.PIECE_ROW_ID
          	WHERE        
            	EPR.PIECE_ROW_ID = #attributes.design_piece_row_id#
     	) AS TBL
	GROUP BY 
    	PIECE_ROW_ID, 
        PIECE_NAME, 
        PIECE_CODE
</cfquery>
<cfquery name="get_yari_mamul" dbtype="query">
	SELECT * FROM get_upd_piece_row WHERE PIECE_ROW_ROW_TYPE = 4
</cfquery>
<cfquery name="get_aksesuar" dbtype="query">
	SELECT * FROM get_upd_piece_row WHERE PIECE_ROW_ROW_TYPE = 2
</cfquery>
<cfquery name="get_hzm" dbtype="query">
	SELECT * FROM get_upd_piece_row WHERE PIECE_ROW_ROW_TYPE = 3
</cfquery>
<cfquery name="get_pvc_1" dbtype="query">
	SELECT * FROM get_upd_piece_row WHERE PIECE_ROW_ROW_TYPE = 1 AND SIRA_NO = 1
</cfquery>
<cfif get_pvc_1.recordcount>
	<cfset pvc_1 = get_pvc_1.STOCK_ID>
<cfelse>
	<cfset pvc_1 = 0>
</cfif>
<cfquery name="get_pvc_2" dbtype="query">
	SELECT * FROM get_upd_piece_row WHERE PIECE_ROW_ROW_TYPE = 1 AND SIRA_NO = 2
</cfquery>
<cfif get_pvc_2.recordcount>
	<cfset pvc_2 = get_pvc_2.STOCK_ID>
<cfelse>
	<cfset pvc_2 = 0>
</cfif>
<cfquery name="get_pvc_3" dbtype="query">
	SELECT * FROM get_upd_piece_row WHERE PIECE_ROW_ROW_TYPE = 1 AND SIRA_NO = 3
</cfquery>
<cfif get_pvc_3.recordcount>
	<cfset pvc_3 = get_pvc_3.STOCK_ID>
<cfelse>
	<cfset pvc_3 = 0>
</cfif>
<cfquery name="get_pvc_4" dbtype="query">
	SELECT * FROM get_upd_piece_row WHERE PIECE_ROW_ROW_TYPE = 1 AND SIRA_NO = 4
</cfquery>
<cfif get_pvc_4.recordcount>
	<cfset pvc_4 = get_pvc_4.STOCK_ID>
<cfelse>
	<cfset pvc_4 = 0>
</cfif>
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
<cfparam name="attributes.trim_type" default="#get_upd_piece.TRIM_TYPE#">
<cfparam name="attributes.trim_rate" default="#get_upd_piece.TRIM_SIZE#">
<cfparam name="attributes.pvc_fire_amount" default="#get_main_defaults.DEFAULT_PVC_FIRE_AMOUNT#">
<cfparam name="attributes.yonga_levha_fire_rate" default="#get_main_defaults.DEFAULT_YONGA_LEVHA_FIRE_RATE#">
<cfparam name="attributes.default_thickness" default="#get_main_defaults.DEFAULT_YONGA_LEVHA_THICKNESS#">
<!---Defaultlar--->

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
	SELECT PACKAGE_NUMBER, PACKAGE_ROW_ID FROM EZGI_DESIGN_PACKAGE WHERE DESIGN_MAIN_ROW_ID = #get_upd_piece.design_main_row_id# ORDER BY PACKAGE_NUMBER
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
    	DESIGN_MAIN_ROW_ID = #get_upd_piece.design_main_row_id#
</cfquery>
<cfset main_setup_name = get_design_main_row.MAIN_ROW_SETUP_NAME>
<!---Modül Bilgisi Çekme--->
<!---Kalınlık Bilgisi Çekme--->
<cfif len(get_upd_piece.PIECE_COLOR_ID)>
    <cfquery name="get_thickness" datasource="#dsn3#">
    	SELECT        
    	THICKNESS_ID, 
        THICKNESS_VALUE, 
        THICKNESS_NAME, 
        UNIT
	FROM            
    	EZGI_DESIGN_PRODUCT_PROPERTIES_UST
	WHERE        
    	COLOR_ID = #get_upd_piece.PIECE_COLOR_ID# AND 
        LIST_ORDER_NO = 1
	ORDER BY 
    	THICKNESS_NAME
    </cfquery>
<cfelse>
	<cfset get_thickness.recordcount = 0>
</cfif>
<!---Kalınlık Bilgisi Çekme--->
<!---Tasarım Bilgisi Çekme--->
<cfquery name="get_design" datasource="#dsn3#">
	SELECT  
    	DESIGN_CODE, 
        DESIGN_NAME, 
        COLOR_ID, 
        PROCESS_ID, 
        STATUS, 
        ISNULL(IS_PROTOTIP,0) AS IS_PROTOTIP, 
        ISNULL(IS_PRIVATE,0) AS IS_PRIVATE, 
        DETAIL, 
        PROJECT_HEAD, 
        PROCESS_STAGE, 
        PRODUCT_CAT,  
       	PRODUCT_QUANTITY, 
        RECORD_EMP, 
        RECORD_IP, 
        RECORD_DATE, 
        UPDATE_EMP, 
        UPDATE_IP, 
        UPDATE_DATE
   	FROM 
    	EZGI_DESIGN 
   	WHERE 
    	DESIGN_ID = #get_upd_piece.DESIGN_ID#
</cfquery>
<!---Tasarım Bilgisi Çekme--->
<!---Yonga Levha Reçete Satırlarını Belirleme--->
<cfquery name="get_yonga_levha" datasource="#DSN3#">
	SELECT        
    	*
	FROM            
    	EZGI_DESIGN_PRODUCT_PROPERTIES_UST
	WHERE
    	LIST_ORDER_NO = 1
    	<cfif len(get_upd_piece.PIECE_COLOR_ID)>
        	AND COLOR_ID = #get_upd_piece.PIECE_COLOR_ID# 
        </cfif>
        <cfif len(get_upd_piece.KALINLIK)>
        	AND THICKNESS_ID = #get_upd_piece.KALINLIK#
        </cfif>
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
    	LIST_ORDER_NO = 3
        <cfif len(get_upd_piece.KALINLIK)>
    		AND THICKNESS_ID = #get_upd_piece.KALINLIK#
      	</cfif>        
    	<cfif len(get_upd_piece.PIECE_COLOR_ID)>
        	AND COLOR_ID = #get_upd_piece.PIECE_COLOR_ID# 
        </cfif>
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
    	LIST_ORDER_NO = 3
    	<cfif len(get_upd_piece.KALINLIK)>
    		AND THICKNESS_ID = #get_upd_piece.KALINLIK#    
        </cfif>    
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
            S_TYPE
        FROM
            get_pvc1
        UNION ALL
    </cfif>
    SELECT
    	PRODUCT_NAME,
        STOCK_ID,
        S_TYPE
   	FROM
    	get_pvc2
 	ORDER BY
    	S_TYPE,
        PRODUCT_NAME	 	
</cfquery>
<!---PVC Reçete Satırlarını Belirleme--->
<!---Parça Hammadde İse PRODUCT_ID çekme--->
<cfif get_upd_piece.piece_type eq 4>
	<cfquery name="get_product_id" datasource="#dsn1#">
    	SELECT PRODUCT_ID FROM STOCKS WHERE STOCK_ID = #get_upd_piece.PIECE_RELATED_ID#
    </cfquery>
    <cfset related_product_id = get_product_id.PRODUCT_ID>
<cfelse>
	<cfset related_product_id = 0>
</cfif>
<!---Parça Hammadde İse PRODUCT_ID çekme--->
<!---Ortak Parça Varmı--->
<cfquery name="get_ortak_piece" datasource="#dsn3#">
	SELECT        
    	EPR.PIECE_RELATED_ID, 
        EPR.DESIGN_ID,
        EPR.DESIGN_MAIN_ROW_ID, 

        EPR.DESIGN_PACKAGE_ROW_ID, 
        ED.DESIGN_NAME, 
        EC.COLOR_NAME, 
        EPR.PIECE_NAME, 
        EPR.PIECE_ROW_ID, 
        S.PRODUCT_NAME, 
  		S.PRODUCT_CODE
	FROM            
    	EZGI_DESIGN_PIECE_ROWS AS EPR INNER JOIN
      	EZGI_DESIGN AS ED ON EPR.DESIGN_ID = ED.DESIGN_ID INNER JOIN
    	STOCKS AS S ON EPR.PIECE_RELATED_ID = S.STOCK_ID LEFT OUTER JOIN
    	EZGI_COLORS AS EC ON ED.COLOR_ID = EC.COLOR_ID
	WHERE        
    	EPR.PIECE_RELATED_ID =
                             	(
                                	SELECT        
                                    	TOP (100) PERCENT PIECE_RELATED_ID
                               		FROM            
                                    	EZGI_DESIGN_PIECE_ROWS AS EZGI_DESIGN_PIECE_ROWS_2
                               		WHERE        
                                    	PIECE_RELATED_ID IN
                                                         	(
                                                            	SELECT        
                                                                	PIECE_RELATED_ID
                                                               	FROM   
                                                                	EZGI_DESIGN_PIECE_ROWS AS EZGI_DESIGN_PIECE_ROWS_1
                                                               	WHERE        
                                                                	PIECE_TYPE <> 4
                                                               	GROUP BY 
                                                                	PIECE_RELATED_ID
                                                               	HAVING         
                                                                	(NOT (PIECE_RELATED_ID IS NULL)) AND 
                                                                    COUNT(*) > 1
                                                          	) AND 
                                 		PIECE_ROW_ID =#attributes.design_piece_row_id#
                               	) AND 
    	EPR.PIECE_ROW_ID <> #attributes.design_piece_row_id#
</cfquery>
<!---Ortak Parça Varmı--->
<!---Özelleştirilebilen Dizayn ise Özellik Girildimi--->
<cfif get_design.PROCESS_ID eq 1 and get_design.IS_PROTOTIP>
	<cfquery name="get_prototip" datasource="#dsn3#">
    	SELECT * FROM EZGI_DESIGN_PIECE_PROTOTIP WHERE PIECE_ROW_ID = #attributes.design_piece_row_id#
    </cfquery>
</cfif>
<!---Özelleştirilebilen Dizayn ise Özellik Girildimi--->
<table class="dph">
    <tr>
        <td class="dpht">&nbsp;<cf_get_lang_main no='2848.Parça'> <cf_get_lang_main no='52.Güncelle'>&nbsp;
        	<cfoutput>
            	<cfif piece_minus_id.recordcount>
                    <a href="#request.self#?fuseaction=prod.popup_upd_ezgi_product_tree_creative_piece_row&design_piece_row_id=#piece_minus_id.piece_row_id#" class="tableyazi">
                        <img src="/images/list_minus.gif" border="0" style="vertical-align:top" title="#getLang('objects2',179)# #getLang('main',2848)#" >
                    </a>
              	<cfelse>
                	<img src="/images/production/list_stop.gif" border="0" style="vertical-align:top" title="#getLang('main',2904)#" >
                </cfif>
                &nbsp;
                <span style="line-height:28px;padding:3px;font-size:14px;font-family:Geneva, tahoma, arial,Helvetica, sans-serif;font-weight:bold; vertical-align:top">
                	#get_upd_piece.PIECE_CODE#
                </span>
                &nbsp;
                <cfif piece_plus_id.recordcount>

                    <a href="#request.self#?fuseaction=prod.popup_upd_ezgi_product_tree_creative_piece_row&design_piece_row_id=#piece_plus_id.piece_row_id#" class="tableyazi">
                        <img src="/images/list_plus.gif" border="0" style="vertical-align:top" title="#getLang('objects2',180)# #getLang('main',2848)#" >
                    </a>
                <cfelse>
                	<img src="/images/production/list_stop.gif" border="0" style="vertical-align:top" title="#getLang('main',2904)#" >
                </cfif>
        	</cfoutput>
        </td>
        <td class="dphb">
        	<cfoutput>
            <cfif get_ortak_piece.RECORDCOUNT>
             	<img src="/images/bugpro.gif" border="0" style="vertical-align:top" title="#getLang('main',1187)# : #getLang('main',2866)#" >
             	&nbsp;
       		</cfif>
            <cfif get_design.PROCESS_ID eq 1 and get_design.IS_PROTOTIP>
            	<a href="javascript://" onClick="windowopen('#request.self#?fuseaction=prod.popup_upd_ezgi_product_tree_creative_piece_row_prototip&design_piece_row_id=#attributes.design_piece_row_id#','small');">
                	<cfif get_prototip.recordcount>
                		<img src="images/cube_vote_red.gif"  title="#getLang('main',2854)#" border="0" style="vertical-align:middle">
                    <cfelse>
                    	<img src="images/cube_vote_yellow.gif"  title="#getLang('main',2854)#" border="0" style="vertical-align:middle">
                    </cfif>
              	</a>&nbsp;
            </cfif>
            <cfif is_montage_used.recordcount>
            	<a href="javascript://" onClick="windowopen('#request.self#?fuseaction=prod.popup_upd_ezgi_product_tree_creative_piece_row&design_piece_row_id=#is_montage_used.piece_row_id#','list');"><img src="/images/tree_bt_related.gif" border="0" title="#getLang('campaign',244)# #getLang('main',573)# #getLang('main',2848)#" ></a>&nbsp;
            </cfif>
            <cfif get_upd_piece.PIECE_TYPE eq 1 or get_upd_piece.PIECE_TYPE eq 2>
                		<a style="cursor:pointer" onclick="copy_piece_row(#get_upd_piece.PIECE_ROW_ID#);"><img src="images/plus.gif"  title="#getLang('main',64)#" border="0" style="vertical-align:middle"></a>&nbsp;
          	</cfif>
            <cfif get_upd_piece.PIECE_TYPE eq 1 or get_upd_piece.PIECE_TYPE eq 2 or get_upd_piece.PIECE_TYPE eq 3>
                <a href="javascript://" onClick="add_piece_images();"><img src="/images/photo.gif" align="absmiddle" title="#getLang('main',102)#"></a>&nbsp;
                <a href="javascript://" onClick="windowopen('#request.self#?fuseaction=prod.popup_upd_ezgi_product_tree_creative_piece_rota&piece_id=#attributes.design_piece_row_id#','small');"><img src="/images/action.gif" border="0" title="#getLang('campaign',244)# #getLang('main',2806)#" style="vertical-align:top" ></a>
            </cfif>
            </cfoutput>
            &nbsp;&nbsp;
        </td>
	</tr>
</table>
<table class="dpm" align="center">
    <tr>
    	<td valign="top" class="dpml">
            <cf_form_box>
                <cfform name="upd_piece_main_row" method="post" action="#request.self#?fuseaction=prod.emptypopup_upd_ezgi_product_tree_creative_piece_row">
                    <cfinput type="hidden" name="design_id" value="#get_upd_piece.DESIGN_ID#">
                    <cfinput type="hidden" name="design_main_row_id" value="#get_upd_piece.design_main_row_id#">
                    <cfinput type="hidden" name="design_piece_row_id" value="#attributes.design_piece_row_id#">
                    <cfinput type="hidden" name="pvc_fire_amount" value="#attributes.pvc_fire_amount#">
                    <cfinput type="hidden" name="yonga_levha_fire_rate" value="#attributes.yonga_levha_fire_rate#">
                    <cfif get_ortak_piece.recordcount>
                    	<cfset is_common_piece_list = ValueList(get_ortak_piece.PIECE_ROW_ID)>
                        <cfset is_common_piece_list = ListDeleteDuplicates(is_common_piece_list,',')>
                    	<cfinput type="hidden" name="is_common_piece_list" value="#is_common_piece_list#">
                    </cfif>
                    <br />
                    <cf_area width="350px">
                    <table>
                        <tr height="25px"  id="piece_type_">
                            <td width="90"><cf_get_lang_main no ='2848.Parça'> <cf_get_lang_main no ='218.Tip'>*</td>
                            <td width="210">
                                <select name="piece_type" id="piece_type" style="width:200px;height:20px" onchange="piece_types();">
                                    <option value="1" <cfif get_upd_piece.PIECE_TYPE eq 1>selected</cfif>>01-<cfoutput>#getLang('main',2865)# #getLang('report',1688)# #getLang('main',2610)#</cfoutput></option>
                                    <option value="2" <cfif get_upd_piece.PIECE_TYPE eq 2>selected</cfif>>02-<cfoutput>#getLang('main',2157)# #getLang('report',1688)# #getLang('main',2610)#</cfoutput></option>
                                    <option value="3" <cfif get_upd_piece.PIECE_TYPE eq 3>selected</cfif>>03-<cfoutput>#getLang('main',2877)#</cfoutput></option>
                                    <option value="4" <cfif get_upd_piece.PIECE_TYPE eq 4>selected</cfif>>04-<cfoutput>#getLang('prod',132)# #getLang('main',170)#</cfoutput></option>
                                </select>
                            </td>
                        </tr>
                        <tr height="25px"  id="piece_default_type_" <cfif get_upd_piece.piece_type eq 4>style="display:none"</cfif>>
                            <td valign="top"><cf_get_lang_main no ='1555.Örnek'> <cf_get_lang_main no ='2848.Parça'>*</td>
                            <td valign="top">
                                <select name="default_type" id="default_type" style="width:130px;height:20px" onchange="hesapla();">
                                    <option value=""><cf_get_lang_main no='322.Seçiniz'></option>
                                    <cfoutput query="get_piece_defaults">
                                        <option value="#PIECE_DEFAULT_ID#" <cfif get_upd_piece.MASTER_PRODUCT_ID eq PIECE_DEFAULT_ID>selected</cfif>>#PIECE_DEFAULT_NAME#</option>
                                    </cfoutput>
                                </select>
                                &nbsp;
                                <a href="javascript://" onClick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=prod.popup_add_ezgi_default_piece&is_piece=1','small');"><img src="/images/plus_list.gif" border="0" title="Örnek Parça Ekle" style="vertical-align:top" ></a>
                            </td>
                        </tr>
                        
                        <tr height="25px"  id="piece_name_" <cfif get_upd_piece.piece_type eq 4>style="display:none"</cfif>>
                            <td valign="top"><cf_get_lang_main no ='2848.Parça'> <cf_get_lang_main no ='485.Adı'>*</td>
                            <td valign="top">
                                <cfinput type="text" name="design_name_piece_row" id="design_name_piece_row" value="#get_upd_piece.PIECE_NAME#" maxlength="50" style="width:200px;" >
                            </td>
                        </tr>
                        <tr height="25px"  id="piece_related_name_" <cfif get_upd_piece.piece_type eq 1 or get_upd_piece.piece_type eq 2 or get_upd_piece.piece_type eq 3>style="display:none"</cfif>>
                            <td valign="top"><cf_get_lang_main no ='245.Ürün'> <cf_get_lang_main no ='485.Adı'>*</td>
                            <td valign="top">
                                <input type="text" name="related_product_name" id="related_product_name" value="<cfoutput>#get_upd_piece.PIECE_NAME#</cfoutput>" style="width:190px; vertical-align:top">
                                <input type="hidden" name="related_product_id" id="related_product_id" value="<cfoutput>#related_product_id#</cfoutput>">
                                <input type="hidden" name="related_stock_id" id="related_stock_id" value="<cfoutput>#get_upd_piece.PIECE_RELATED_ID#</cfoutput>"> 
                                <a href="javascript://" onclick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_ezgi_product_names&list_order_no=3,4&product_id=upd_piece_main_row.related_product_id&field_id=upd_piece_main_row.related_stock_id&field_name=upd_piece_main_row.related_product_name','list');"><img src="/images/plus_thin.gif"></a>
                                
                            </td>
                        </tr>
                        <tr height="25px"  id="piece_color_" <cfif get_upd_piece.piece_type eq 4>style="display:none"</cfif>>
                            <td valign="top"><cf_get_lang_main no ='1968.Renk Düzenle'> <span id="piece_color__" style="font-weight:bold;<cfif get_upd_piece.piece_type eq 2>display:none</cfif>">*</span></td>
                            <td valign="top">
                                <select name="color_type" id="color_type" style="width:130px;height:20px" onchange="set_thickness(this.value)">
                                    <option value="0"><cf_get_lang_main no='322.Seçiniz'></option>
                                    <cfoutput query="get_colors">
                                        <option value="#COLOR_ID#" <cfif  get_upd_piece.piece_color_id eq COLOR_ID>style="font-weight:bold" selected </cfif>>#COLOR_NAME#</option>
                                    </cfoutput>
                                </select>
                            </td>
                        </tr>
                        <tr height="25px"  id="piece_amount_">
                            <td valign="top"><cf_get_lang_main no ='223.Miktar'>*</td>
                            <td valign="top">
                                <cfinput type="text" id="piece_amount" name="piece_amount" value="#TlFormat(get_upd_piece.piece_amount,4)#" maxlength="9" style="width:70px;text-align:right">
                            </td>
                        </tr>
                        <tr height="25px"  id="piece_kalinlik_" <cfif get_upd_piece.piece_type eq 2 or get_upd_piece.piece_type eq 4>style="display:none"</cfif>>
                            <td valign="top"><cf_get_lang_main no ='2878.Kalınlık'> (mm.) <span id="piece_kalinlik__" style="font-weight:bold;<cfif get_upd_piece.piece_type eq 3>display:none</cfif>">*</span></td>
                            <td valign="top">
                                <select name="piece_kalinlik" id="piece_kalinlik" style="width:70px;height:20px"  onchange="set_product(this.value)">
                                    <option value=""><cf_get_lang_main no='322.Seçiniz'></option>
                                    <cfif get_thickness.recordcount gt 0>
                                        <cfoutput query="get_thickness">
                                            <option value="#THICKNESS_ID#" <cfif get_upd_piece.KALINLIK eq THICKNESS_ID>selected</cfif>>#THICKNESS_NAME#</option>
                                        </cfoutput>
                                    </cfif>
                                </select>
                            </td>
                        </tr>
			<tr height="25px"  id="piece_boy_" <cfif get_upd_piece.piece_type eq 4>style="display:none"</cfif>>
                            <td valign="top"><cfoutput>#getLang('report',790)#</cfoutput> (mm.) <span id="piece_boy__" style="font-weight:bold;<cfif get_upd_piece.piece_type eq 2 or get_upd_piece.piece_type eq 3>display:none</cfif>">*</span></td>
                            <td valign="top">
                                <cfinput type="text" name="piece_boy" id="piece_boy" value="#get_upd_piece.BOYU#" onkeyup="isNumber(this);" maxlength="6" style="width:70px;text-align:right">
                                &nbsp;
                                <span style="font-weight:bold"><cfoutput>#get_upd_piece.kesim_boyu#</cfoutput></span>
                            </td>
                        </tr>
                        <tr height="25px"  id="piece_en_" <cfif get_upd_piece.piece_type eq 2 or get_upd_piece.piece_type eq 4>style="display:none"</cfif>>
                            <td valign="top"><cfoutput>#getLang('report',749)#</cfoutput> (mm.)<span id="piece_en__" style="font-weight:bold;<cfif get_upd_piece.piece_type eq 2 or get_upd_piece.piece_type eq 3>display:none</cfif>">*</span></td>
                            <td valign="top">
                                <cfinput type="text" name="piece_en" id="piece_en" value="#get_upd_piece.ENI#" onkeyup="isNumber(this);"  maxlength="6" style="width:70px;text-align:right">
                                &nbsp;
                                <span style="font-weight:bold"><cfoutput>#get_upd_piece.kesim_eni#</cfoutput></span>
                            </td>
                        </tr>
                        
                        
                        <tr height="25px"  id="piece_su_yonu_" <cfif get_upd_piece.piece_type eq 2 or get_upd_piece.piece_type eq 3 or get_upd_piece.piece_type eq 4>style="display:none"</cfif>>
                            <td valign="top"><cfoutput>#getLang('main',2879)# #getLang('main',2880)#</cfoutput> </td>
                            <td valign="top">
                                <input type="checkbox" name="piece_su_yonu" id="piece_su_yonu" value="1" <cfif get_upd_piece.IS_FLOW_DIRECTION eq 1>checked</cfif> />
                            </td>
                        </tr>
                        <tr height="25px"  id="piece_weight_">
                            <td valign="top"><cf_get_lang_main no ='1987.Ağırlık'> (kg.)</td>
                            <td valign="top">
                                <cfinput type="text" id="piece_weight" name="piece_weight" value="#TlFormat(get_upd_piece.AGIRLIK,2)#" maxlength="3" style="width:70px;text-align:right">
                            </td>
                        </tr>
                        <tr height="25px" id="piece_kod_" <cfif get_upd_piece.piece_type eq 2 or get_upd_piece.piece_type eq 3 or get_upd_piece.piece_type eq 4>style="display:none"</cfif>>
                            <td valign="top"><cf_get_lang_main no ='2848.Parça'> <cf_get_lang_main no ='75.No'></td>
                            <td valign="top">
                                <cfinput type="text" name="design_code_piece_row" id="design_code_piece_row" value="#get_upd_piece.PIECE_CODE#" maxlength="50" style="width:70px;" >
                            </td>
                        </tr>
                        <tr height="25px"  id="piece_package_no_">
                            <td valign="top"><cfoutput>#getLang('stock',371)# #getLang('main',75)#</cfoutput> </td>
                            <td valign="top">
                                <select name="piece_package_no" id="piece_package_no" style="width:70px;height:20px; text-align:center" onchange="piece_floor_no()">
                                    <option value=""><cf_get_lang_main no='322.Seçiniz'></option>
                                    <cfif not is_montage_used.recordcount>
                                        <cfoutput query="get_design_package_row">
                                            <option value="#PACKAGE_ROW_ID#" <cfif get_upd_piece.DESIGN_PACKAGE_ROW_ID eq PACKAGE_ROW_ID>selected</cfif>>#PACKAGE_NUMBER#</option>
                                        </cfoutput>
                                    </cfif>
                                </select>
                            </td>
                        </tr>
                        <cfif get_design.PROCESS_ID eq 1>
                            <tr height="25px"  id="piece_package_floor_no_" style="<cfif get_upd_piece.DESIGN_PACKAGE_ROW_ID eq ''>display:none</cfif>">
                                <td valign="top"><cfoutput>#getLang('main',2903)# #getLang('main',2905)# #getLang('main',75)#</cfoutput> </td>
                                <td valign="top">
                                    <select name="piece_package_floor_no" id="piece_package_floor_no" style="width:70px;height:20px; text-align:center">
                                        <option value=""  <cfif get_upd_piece.PIECE_FLOOR eq ''>selected</cfif>><cf_get_lang_main no='322.Seçiniz'></option>
                                        <option value="1" <cfif get_upd_piece.PIECE_FLOOR eq 1>selected</cfif>>1</option>
                                        <option value="2" <cfif get_upd_piece.PIECE_FLOOR eq 2>selected</cfif>>2</option>
                                        <option value="3" <cfif get_upd_piece.PIECE_FLOOR eq 3>selected</cfif>>3</option>
                                        <option value="4" <cfif get_upd_piece.PIECE_FLOOR eq 4>selected</cfif>>4</option>
                                        <option value="5" <cfif get_upd_piece.PIECE_FLOOR eq 5>selected</cfif>>5</option>
                                        <option value="6" <cfif get_upd_piece.PIECE_FLOOR eq 6>selected</cfif>>6</option>
                                        <option value="7" <cfif get_upd_piece.PIECE_FLOOR eq 7>selected</cfif>>7</option>
                                        <option value="8" <cfif get_upd_piece.PIECE_FLOOR eq 8>selected</cfif>>8</option>
                                        <option value="9" <cfif get_upd_piece.PIECE_FLOOR eq 9>selected</cfif>>9</option>
                                    </select>
                                </td>
                            </tr>
                            <tr height="25px"  id="piece_package_rota_" style="<cfif get_upd_piece.DESIGN_PACKAGE_ROW_ID eq ''>display:none</cfif>">
                                <td valign="top"><cfoutput>#getLang('main',2906)#</cfoutput></td>
                                <td valign="top">
                                    <select name="piece_package_rota" id="piece_package_rota" style="width:70px;height:20px; text-align:center">
                                        <option value=""  <cfif get_upd_piece.PIECE_PACKAGE_ROTA eq ''>selected</cfif>><cf_get_lang_main no='322.Seçiniz'></option>
                                        <option value="A" <cfif get_upd_piece.PIECE_PACKAGE_ROTA eq 'A'>selected</cfif>>A</option>
                                        <option value="B" <cfif get_upd_piece.PIECE_PACKAGE_ROTA eq 'B'>selected</cfif>>B</option>
                                        <option value="C" <cfif get_upd_piece.PIECE_PACKAGE_ROTA eq 'C'>selected</cfif>>C</option>
                                        <option value="D" <cfif get_upd_piece.PIECE_PACKAGE_ROTA eq 'D'>selected</cfif>>D</option>
                                        <option value="E" <cfif get_upd_piece.PIECE_PACKAGE_ROTA eq 'E'>selected</cfif>>E</option>
                                        <option value="F" <cfif get_upd_piece.PIECE_PACKAGE_ROTA eq 'F'>selected</cfif>>F</option>
                                        <option value="G" <cfif get_upd_piece.PIECE_PACKAGE_ROTA eq 'G'>selected</cfif>>G</option>
                                        <option value="H" <cfif get_upd_piece.PIECE_PACKAGE_ROTA eq 'H'>selected</cfif>>H</option>
                                        <option value="I" <cfif get_upd_piece.PIECE_PACKAGE_ROTA eq 'I'>selected</cfif>>I</option>
                                    </select>
                                </td>
                            </tr>
                        </cfif>
                        <tr height="25px"  id="piece_price_" <cfif get_upd_piece.piece_type eq 1 or get_upd_piece.piece_type eq 2 or get_upd_piece.piece_type eq 3>style="display:none"</cfif>>
                            <td valign="top"><cf_get_lang_main no ='245.Ürün'> <cf_get_lang_main no ='672.Fiyat'> </td>
                            <td valign="top">
                                <input type="text" name="product_price" id="product_price" value="<cfoutput>#TlFormat(get_upd_piece.PIECE_PRICE,4)#</cfoutput>" style="width:70px; height:20px; vertical-align:top; text-align:right">
                                <select name="product_price_money" style="vertical-align:top;width:70px; height:20px">
                                    <cfoutput query="get_money">
                                        <option value="#money#" <cfif money eq get_upd_piece.PIECE_PRICE_MONEY>selected</cfif>>#money#</option>
                                    </cfoutput>
                                </select>
                            </td>
                        </tr>
                        <tr height="50px"  id="piece_detail_">
                            <td valign="top"><cf_get_lang_main no ='217.Açıklama'> </td>
                            <td valign="top">
                                <textarea name="piece_detail" id="piece_detail" style="width:200px; height:50px"><cfoutput>#get_upd_piece.PIECE_DETAIL#</cfoutput></textarea>
                            </td>
                        </tr>
                    </table>
                    <br />
                    <cfif isdefined('attributes.erp_link')>
                    <div id="related_" style="width:100%; height:20px">
                    	<cf_form_list id="_related_">
                         	<tbody>
                              	<tr height="25px"  id="piece_related_">
                                  	<td width="100%">
                                    <a href="javascript://" onclick="windowopen('<cfoutput>#request.self#?fuseaction=prod.upd_ezgi_product_tree_creative&piece_type_select=&sort_id=5&design_id=#get_related_design.DESIGN_ID#&design_main_row_id=#get_related_design.DESIGN_MAIN_ROW_ID#&design_package_row_id=#get_related_design.DESIGN_PACKAGE_ROW_ID#&design_piece_row_id=#get_related_design.PIECE_ROW_ID#</cfoutput>','longpage');">
                                    	<span style="font-size:12px">
                                    		<cfoutput> #get_related_design.DESIGN_MAIN_NAME# - #get_related_design.PACKAGE_NAME#</cfoutput>
                                        </span>
                                    </a>
                               		</td>
                            	</tr>
                         	</tbody>
                    	</cf_form_list>
                    </div>
                    </cfif>
                    <cfif len(get_design_piece_image.PATH)>
                        <div id="image_" style="width:340px; <cfif get_upd_piece.piece_type eq 4>display:none</cfif>">
                            <cf_seperator title="<cf_get_lang_main no='668.Resim'>" id="_image" is_closed="1">
                            <cf_form_list id="_image">
                            	<tbody>
                                 	<tr height="25px"  id="image_">
                                    	<cfoutput>
                                     	<td valign="top">
                                         	<img src="/documents/product/#get_design_piece_image.PATH#" style="height:210px; width:297px; vertical-align:middle">
                                     	</td>
                                        </cfoutput>
                                 	</tr>
                             	</tbody>
                            </cf_form_list>
                        </div>
                    </cfif>
                    </cf_area>
                    <cf_area>
						<div id="yonga_levha_" style="width:260px; <cfif get_upd_piece.piece_type eq 2 or get_upd_piece.piece_type eq 3 or get_upd_piece.piece_type eq 4>display:none</cfif>">
                            <cf_seperator title="#getLang('main',2865)#" id="_yonga_levha" is_closed="1">
                            <cf_form_list id="_yonga_levha">
                                <tbody>
                                    <tr height="25px"  id="piece_yonga_levha_">
                                        <td width="260">
                                            <select name="piece_yonga_levha" id="piece_yonga_levha" style="width:250px;height:20px">
                                                <cfoutput query="get_yonga_levha">
                                                    <option value="#STOCK_ID#" <cfif get_upd_piece.MATERIAL_ID eq STOCK_ID>selected</cfif>>#PRODUCT_NAME#</option>
                                                </cfoutput>
                                            </select>
                                        </td>
                                    </tr>
                                </tbody>
                            </cf_form_list>
                            <br />
                        </div>
                        <div id="yari_mamul_" style="width:260px; <cfif get_upd_piece.piece_type eq 1 or get_upd_piece.piece_type eq 2 or get_upd_piece.piece_type eq 4>display:none</cfif>">
                            <cf_seperator title="#getLang('main',2881)#" id="_yari_mamul" is_closed="1">
                            <cf_form_list id="_yari_mamul">
                                <thead>
                                    <tr>
                                        <th width="20px">
                                            <cfinput type="hidden" name="record_num_yrm" id="record_num_yrm" value="#get_yari_mamul.recordcount#">
                                            <input type="button" class="eklebuton" title="<cf_get_lang_main no='170.Ekle'>" onclick="add_row_yrm();"></th>
                                        <th width="170px" nowrap="nowrap"><cf_get_lang_main no='40.Stok'></th>
                                        <th width="80px"><cf_get_lang_main no='223.Miktar'></th>
                                    </tr>
                                </thead>
                                <tbody name="new_row_yrm" id="new_row_yrm">
                                    <cfif get_yari_mamul.recordcount>
                                        <cfoutput query="get_yari_mamul">
                                            <tbody><tr name="frm_row_yrm" id="frm_row_yrm#currentrow#">
                                                <td>
                                                    <input type="button" class="silbuton" title="<cf_get_lang_main no='51.Sil'>" onclick="sil_yrm(#currentrow#);">
                                                    <input type="hidden" name="row_kontrol_yrm#currentrow#" id="row_kontrol_yrm#currentrow#" value="1">
                                                </td>
                                                <td nowrap="nowrap">
                                                    <select name="piece_yari_mamul#currentrow#" id="piece_yari_mamul#currentrow#" style="width:160px;height:20px">
                                                        <cfloop query="get_montage_product">
                                                            <option value="#PIECE_ROW_ID#" <cfif get_yari_mamul.RELATED_PIECE_ROW_ID eq PIECE_ROW_ID>selected</cfif>>#PIECE_NAME#</option>
                                                        </cfloop>
                                                    </select>
                                                </td>
                                                <td><input type="text" name="quantity_yrm#currentrow#" id="quantity_yrm#currentrow#" value="#TlFormat(get_yari_mamul.amount,4)#" onkeyup="isNumber(this);" style="width:50px; text-align:right;"></td>
                                            </tr>
                                        </tbody></cfoutput>
                                    </cfif>
                                
                            </cf_form_list>
                            <br />
                        </div>
                        <div id="kenar_" style="width:260px;<cfif get_upd_piece.piece_type eq 2 or get_upd_piece.piece_type eq 4>display:none</cfif>">
                            <cf_seperator title="#getLang('main',2882)#" id="_kenar" is_closed="1">
                            <cf_form_list id="_kenar">
                            <tbody style="width:100%;" cellpadding="0" cellspacing="0" border="0">
                                <tr>
                                    <td style="width:35px; height:25px;text-align:center">
                                        <img src="/images/production/ust.gif" title="<cf_get_lang_main no='573.Üst'> <cf_get_lang_main no='2883.Arka'>" style="text-align:center; vertical-align:middle;width:25px; height:20px" />
                                    </td>
                                    <td style="width:200px; text-align:left">
                                        <select name="pvc_materials_1" id="pvc_materials_1" style="width:180px;height:20px;<cfif pvc_1 eq 0>display:none</cfif>">
                                            <cfoutput query="get_pvc">
                                                <option value="#STOCK_ID#" <cfif S_TYPE eq 0>style="font-weight:bold"</cfif> <cfif pvc_1 eq STOCK_ID>selected</cfif>>#PRODUCT_NAME#</option>
                                            </cfoutput>
                                        </select>
                                    </td>
                                    <td style="width:25px; text-align:center">
                                        <cfif pvc_1 gt 0>
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
                                        <select name="pvc_materials_2" id="pvc_materials_2" style="width:180px;height:20px;<cfif pvc_2 eq 0>display:none</cfif>">
                                            <cfoutput query="get_pvc">
                                                <option value="#STOCK_ID#" <cfif S_TYPE eq 0>style="font-weight:bold"</cfif> <cfif pvc_2 eq STOCK_ID>selected</cfif>>#PRODUCT_NAME#</option>
                                            </cfoutput>
                                        </select>
                                    </td>
                                    <td style="text-align:center">
                                        <cfif pvc_2 gt 0>
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
                                        <select name="pvc_materials_3" id="pvc_materials_3" style="width:180px;height:20px;<cfif pvc_3 eq 0>display:none</cfif>">
                                            <cfoutput query="get_pvc">
                                                <option value="#STOCK_ID#" <cfif S_TYPE eq 0>style="font-weight:bold"</cfif> <cfif pvc_3 eq STOCK_ID>selected</cfif>>#PRODUCT_NAME#</option>
                                            </cfoutput>
                                        </select>
                                    </td>
                                    <td style="text-align:center">
                                        <cfif pvc_3 gt 0>
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
                                        <select name="pvc_materials_4" id="pvc_materials_4" style="width:180px;height:20px;<cfif pvc_4 eq 0>display:none</cfif>">
                                            <cfoutput query="get_pvc">
                                                <option value="#STOCK_ID#" <cfif S_TYPE eq 0>style="font-weight:bold"</cfif> <cfif pvc_4 eq STOCK_ID>selected</cfif>>#PRODUCT_NAME#</option>
                                            </cfoutput>
                                        </select>
                                    </td>
                                    <td style="text-align:center">
                                        <cfif pvc_4 gt 0>
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
                                <tr id="trim_rate_" <cfif get_upd_piece.piece_type neq 1>style="display:none"</cfif>>
                                    <td colspan="2" nowrap="nowrap" style="text-align:left; vertical-align:middle; height:25px">
                                        &nbsp;<cf_get_lang_main no='2889.Tıraşlama Payı'> (mm)&nbsp;
                                        <select name="trim_type" id="trim_type" style="width:107px;height:20px" onchange="change_trim_type_(this.value);">
                                            <option value="0" <cfif get_upd_piece.trim_type eq 0>selected</cfif>><cf_get_lang_main no='2892.Tıraşlama Yok'></option>
                                            <option value="1" <cfif get_upd_piece.trim_type eq 1>selected</cfif>><cf_get_lang_main no='1132.Sabit'><cf_get_lang_main no='2893.Tıraşlama'></option>
                                        </select>
                                        
                                    </td>
                                    <td style="text-align:right; vertical-align:middle;">
                                        <span id="trim_rate_display_" style="<cfif get_upd_piece.trim_type eq 0>display:none</cfif>">
                                            <cfinput name="trim_rate" id="trim_rate" value="#TlFormat(get_upd_piece.trim_size,1)#" class="box" style="text-align:right; width:20px; vertical-align:middle">
                                        </span> 
                                    </td>
                                </tr>
                            </tbody>
                            <br />
                            </cf_form_list>
                        </div>
                       	<div id="aksesuar_" style="width:260px;<cfif get_upd_piece.piece_type eq 4>display:none</cfif>">
                            <cf_seperator title="#getLang('main',2894)#" id="_aksesuar" is_closed="1">
                                <cf_form_list id="_aksesuar">
                                    <thead>
                                        <tr>
                                            <th width="20px">
                                                <input type="hidden" name="record_num" id="record_num" value="<cfoutput>#get_aksesuar.recordcount#</cfoutput>">
                                                <a href="javascript:openProducts();"><img src="/images/plus_list.gif"  border="0"></a>
                                          	</th>
                                            <th width="170px" nowrap="nowrap"><cf_get_lang_main no='40.Stok'></th>
                                            <th width="80px"><a href="javascript:CopyProducts();"><img src="/images/copy_list.gif"  border="0"></a><cf_get_lang_main no='223.Miktar'></th>
                                        </tr>
                                    </thead>
                                    <tbody name="new_row" id="new_row">
                                        <cfif get_aksesuar.recordcount>
                                            <cfoutput query="get_aksesuar">
                                                <tbody><tr name="frm_row" id="frm_row#currentrow#">
                                                    <td>
                                                        <input type="button" class="silbuton" title="<cf_get_lang_main no='51.Sil'>" onclick="sil(#currentrow#);">
                                                        <input type="hidden" name="row_kontrol#currentrow#" id="row_kontrol#currentrow#" value="1">
                                                    </td>
                                                    <td nowrap="nowrap">
                                                        <input type="hidden" name="product_id#currentrow#" id="product_id#currentrow#" value="#get_aksesuar.product_id#">
                                                        <input type="hidden" name="stock_id#currentrow#" id="stock_id#currentrow#" value="#get_aksesuar.stock_id#">
                                                        <input type="text" name="product_name#currentrow#" id="product_name#currentrow#" value="#get_aksesuar.product_name#" style="width:160px;">
                                                    </td>
                                                    <td><input type="text" name="quantity#currentrow#" id="quantity#currentrow#" value="#TlFormat(get_aksesuar.amount,4)#" style="width:50px; text-align:right;"></td>
                                                </tr>
                                            </tbody></cfoutput>
                                        </cfif>
                                    
                                </cf_form_list>
                                <br />
                            </div>
                            <div id="hizmet_" style="width:260px;<cfif get_upd_piece.piece_type neq 1>display:none</cfif>">
                            <cf_seperator title="#getLang('main',2895)#" id="_hizmet" is_closed="1">
                                <cf_form_list id="_hizmet">
                                    <thead>
                                        <tr>
                                            <th width="20px">
                                                <input type="hidden" name="record_num_hzm" id="record_num_hzm" value="<cfoutput>#get_hzm.recordcount#</cfoutput>">
                                                <input type="button" class="eklebuton" title="<cf_get_lang_main no='170.Ekle'>" onclick="add_row_hzm();"></th>
                                            <th width="170px" nowrap="nowrap"><cfoutput>#getLang('objects',1288)#</cfoutput></th>
                                            <th width="80px"><cf_get_lang_main no='223.Miktar'></th>
                                        </tr>

                                    </thead>
                                    <tbody name="new_row_hzm" id="new_row_hzm">
                                        <cfif get_hzm.recordcount>
                                            <cfoutput query="get_hzm">
                                                <tbody><tr name="frm_row_hzm" id="frm_row_hzm#currentrow#">
                                                    <td>
                                                        <input type="button" class="silbuton" title="<cf_get_lang_main no='51.Sil'>" onclick="sil_hzm(#currentrow#);">
                                                        <input type="hidden" name="row_kontrol_hzm#currentrow#" id="row_kontrol_hzm#currentrow#" value="1">
                                                    </td>
                                                    <td nowrap="nowrap">
                                                        <input type="hidden" name="pid_hzm#currentrow#" id="pid_hzm#currentrow#" value="#get_hzm.product_id#">
                                                        <input type="hidden" name="stock_id_hzm#currentrow#" id="stock_id_hzm#currentrow#" value="#get_hzm.stock_id#">
                                                        <input type="text" name="urun_hzm#currentrow#" id="urun_hzm#currentrow#" value="#get_hzm.product_name#" style="width:160px;">
                                                        <a href="javascript://" onclick="pencere_ac_hzm(#currentrow#);"><img src="/images/plus_thin.gif" align="absmiddle" border="0"></a>
                                                    </td>
                                                    <td><input type="text" name="quantity_hzm#currentrow#" id="quantity_hzm#currentrow#" value="#TlFormat(get_hzm.amount,4)#"  style="width:50px; text-align:right;"></td>
                                                </tr>
                                            </tbody></cfoutput>
                                        </cfif>
                                    
                                </cf_form_list>
                            </div>
                    </cf_area>
                    <cf_form_box_footer>
                        <cfif not is_montage_used.recordcount>
                        <cf_workcube_buttons 
                            is_upd='1' 
                            delete_page_url='#request.self#?fuseaction=prod.emptypopup_del_ezgi_product_tree_creative_piece_row&design_piece_row_id=#attributes.design_piece_row_id#'
                            add_function='kontrol()'>
                        <cfelse>
                            <cf_workcube_buttons 
                                is_upd='1' 
                                is_delete = '0' 
                                delete_page_url='#request.self#?fuseaction=prod.emptypopup_del_ezgi_product_tree_creative_piece_row&design_piece_row_id=#attributes.design_piece_row_id#'
                                add_function='kontrol()'>
                        </cfif>
                        <cf_record_info 
                            query_name="get_upd_piece"
                            record_emp="RECORD_EMP" 
                            record_date="record_date"
                            update_emp="UPDATE_EMP"
                            update_date="update_date">
                    </cf_form_box_footer>
                </cfform>
            </cf_form_box>
            <cfif get_ortak_piece.recordcount>
                <cf_form_box>
                    <cf_area width="350px">
                    	<div id="ortak_">
                        <cf_seperator title="#getLang('main',2866)#" id="_ortak" is_closed="1">
                    	<cf_form_list id="_ortak">
                        	<thead>
                             	<tr>
                                 	<th width="20px"><cf_get_lang_main no='1165.Sıra'></th>
                                    <th width="120px"><cf_get_lang_main no='1388.Ürün Kodu'></th>
                                   	<th width="220px"><cf_get_lang_main no='245.Ürün'></th>
                                  	<th width="80px"><cfoutput>#getLang('settings',1457)#</cfoutput></th>
                                    <th width="80px"><cf_get_lang_main no='2981.Tasarım Rengi'></th>
                                    <th width="150px"><cf_get_lang_main no='3202.Parça Adı'></th>
                             	</tr>
                         	</thead>
                            <tbody>
                            	<cfoutput query="get_ortak_piece">
                                	<tr>
                                    	<td style="text-align:right">#get_ortak_piece.currentrow#</td>
                                        <td style="text-align:CENTER">
                                        	<a class="tableyazi" href="javascript://" onclick="windowopen('#request.self#?fuseaction=objects.popup_detail_product&sid=#get_ortak_piece.PIECE_RELATED_ID#','list');">
                                        		#get_ortak_piece.product_CODE#
                                            </a>
                                      	</td>
                                    	<td>#get_ortak_piece.product_name#</td>
                                        <td>
                                        	<a class="tableyazi" href="javascript://" onclick="windowopen('#request.self#?fuseaction=prod.upd_ezgi_product_tree_creative&piece_type_select=&sort_id=5&design_id=#get_ortak_piece.DESIGN_ID#&design_main_row_id=#get_ortak_piece.DESIGN_MAIN_ROW_ID#','longpage');">
                                        		#get_ortak_piece.DESIGN_NAME#
                                           	</a>
                                        </td>
                                        <td>#get_ortak_piece.COLOR_NAME#</td>
                                        <td>#get_ortak_piece.PIECE_NAME#</td>
                                    </tr>
                                </cfoutput>
                            </tbody>
                       	</cf_form_list >
                        </div>
                    </cf_area>
                </cf_form_box>
            </cfif>
     	</td>

 	</tr>
</table>
<script type="text/javascript">
	var row_count=document.upd_piece_main_row.record_num.value;
	var row_count_hzm=document.upd_piece_main_row.record_num_hzm.value;
	var row_count_yrm=document.upd_piece_main_row.record_num_yrm.value;
	function copy_piece_row(piece_row_id)
	{
		copy_confirm = confirm('<cf_get_lang_main no='2907.Kopyalama İşlemine Başlıyorum'> !');
		if(copy_confirm == true)
		window.location ="<cfoutput>#request.self#</cfoutput>?fuseaction=prod.emptypopup_cpy_ezgi_product_tree_creative_piece_row&this_tree=1&design_piece_row_id="+piece_row_id;	
	}
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
				}
			</cfloop>
		}
		document.getElementById('design_name_piece_row').value = main_row_name;
	}
	function set_thickness(color_id_)
	{
		default_thickness = <cfoutput>#attributes.default_thickness#</cfoutput>;
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
		default_thickness = <cfoutput>#attributes.default_thickness#</cfoutput>;
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
	function CopyProducts()
	{
		windowopen('<cfoutput>#request.self#?fuseaction=prod.popup_list_ezgi_piece_row_calc&design_piece_row_id=#attributes.design_piece_row_id#'</cfoutput>,'small');
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
		document.upd_piece_main_row.record_num.value = row_count;
		
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.setAttribute('nowrap','nowrap');
		newCell.innerHTML = '<a style="cursor:pointer" onclick="sil(' + row_count + ');" ><img src="/images/delete_list.gif" alt="<cf_get_lang_main no='51.Sil'>" border="0"></a>';	
		
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.setAttribute('nowrap','nowrap');
		newCell.innerHTML = '<input type="hidden" value="1" name="row_kontrol'+row_count+'">';
		newCell.innerHTML = newCell.innerHTML + '<input type="Hidden" name="stock_id'+row_count+'" value="' + stockid + '">';
		newCell.innerHTML = newCell.innerHTML + '<input type="hidden" name="product_id'+row_count+'" value="'+product_id+'">';
		newCell.innerHTML = newCell.innerHTML + '<input type="hidden" name="unit_id'+row_count+'" value="'+product_unit_id+'">';
		newCell.innerHTML = newCell.innerHTML + '<input type="text" name="product_name' + row_count + '" style="width:160px;" class="boxtext" value="'+product_name+'">';
		
		newCell=newRow.insertCell(newRow.cells.length);
		newCell.innerHTML = '<input type="text" id="quantity' + row_count +'" name="quantity' + row_count +'" value="<cfoutput>#TlFormat(1,4)#</cfoutput>" style="width:50px; text-align:right;">';
	}
	
	function sil(sy)
	{
	
		var element=eval("upd_piece_main_row.row_kontrol"+sy);
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
		
		document.upd_piece_main_row.record_num_hzm.value = row_count_hzm;
		
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
		windowopen("<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_ezgi_product_names&list_order_no=5&product_id=upd_piece_main_row.pid_hzm" + no_hzm +"&field_id=upd_piece_main_row.stock_id_hzm" + no_hzm +"&field_name=upd_piece_main_row.urun_hzm" + no_hzm,'list');
	}
	function sil_hzm(sy_hzm)
	{
		
		var element_hzm=eval("upd_piece_main_row.row_kontrol_hzm"+sy_hzm);
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
		
		document.upd_piece_main_row.record_num_yrm.value = row_count_yrm;
		
		newCell_yrm = newRow_yrm.insertCell(newRow_yrm.cells.length);
		newCell_yrm.innerHTML = '<a style="cursor:pointer" onclick="sil_yrm(' + row_count_yrm + ');" ><img src="/images/delete_list.gif" alt="<cf_get_lang_main no='51.Sil'>" border="0"></a>';	
			
		newCell_yrm=newRow_yrm.insertCell(newRow_yrm.cells.length);
		newCell_yrm.setAttribute('nowrap','nowrap');
		newCell_yrm.innerHTML = '<select name="piece_yari_mamul'+row_count_yrm+'" id="piece_yari_mamul'+row_count_yrm+'" style="width:160px;height:20px"><cfoutput query="get_montage_product"><option value="#PIECE_ROW_ID#" >#PIECE_NAME#</option></cfoutput></select><input type="hidden" value="1" id="row_kontrol_yrm' + row_count_yrm +'" name="row_kontrol_yrm' + row_count_yrm +'">';
		
		newCell_yrm=newRow_yrm.insertCell(newRow_yrm.cells.length);
		newCell_yrm.innerHTML = '<input type="text" id="quantity_yrm' + row_count_yrm +'" name="quantity_yrm' + row_count_yrm +'" value="<cfoutput>#TlFormat(1,4)#</cfoutput>" style="width:50px; text-align:right;">';
	}
	function pencere_ac_yrm(no_yrm)
	{
		windowopen("<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_ezgi_product_names&list_order_no=5&product_id=upd_piece_main_row.pid_yrm" + no_yrm +"&field_id=upd_piece_main_row.stock_id_yrm" + no_yrm +"&field_name=upd_piece_main_row.urun_yrm" + no_yrm,'list');
	}
	function sil_yrm(sy_yrm)
	{
	
		var element_yrm=eval("upd_piece_main_row.row_kontrol_yrm"+sy_yrm);
		element_yrm.value=0;
		var element_yrm=eval("frm_row_yrm"+sy_yrm); 
		element_yrm.style.display="none";		
	} 
	function add_piece_images()
	{
		<cfif get_design_piece_image.recordcount>
			windowopen('<cfoutput>#request.self#?fuseaction=prod.form_upd_ezgi_popup_image&id=#attributes.design_piece_row_id#&type=brand&detail=#get_upd_piece.PIECE_NAME#&table=EZGI_DESIGN_PIECE_IMAGES</cfoutput>','small');
		<cfelse>
			windowopen('<cfoutput>#request.self#?fuseaction=prod.form_add_ezgi_popup_image&id=#attributes.design_piece_row_id#&type=brand&detail=#get_upd_piece.PIECE_NAME#&table=EZGI_DESIGN_PIECE_IMAGES</cfoutput>','small');
		</cfif>
	}
	function kontrol()
	{
		<cfif get_ortak_piece.recordcount>
			ortak_sor=confirm('Güncelleme İşlemi Tüm Ortak Parçalara Uygulanacaktır?');
			if (ortak_sor == true)
				return true;
			else
				return false;
		</cfif>
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
				alert("<cf_get_lang_main no='782.Girilmesi Zorunlu Alan'> <cf_get_lang_main no='1968.Renk Düzenle'> !");
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
					alert("<cf_get_lang_main no='782.Girilmesi Zorunlu Alan'> <cf_get_lang_main no='2901.En'> !");
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
						alert(i+'. <cf_get_lang_main no='2990.Satırdaki Montaj Edilecek Ürün Seçilmemiştir'>!');
						document.getElementById("piece_yari_mamul"+i).focus();
						return false;
					}
					<!---else
					{
						<cfoutput query="get_montage_product">
							control_montage_id = #PIECE_ROW_ID#;
							control_amount = #PIECE_AMOUNT-USED_AMOUNT#;
							if(document.getElementById("piece_yari_mamul"+i).value == control_montage_id)
							{
								if(document.getElementById("quantity_yrm"+i).value > control_amount)
								{
									alert(i+'. Sıradaki Montaj Edilecek Ürünün Miktarı Maximum '+control_amount+' Olabilir !');
									document.getElementById("quantity_yrm"+i).focus();
									return false;
									
								}
							}
						</cfoutput>
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
