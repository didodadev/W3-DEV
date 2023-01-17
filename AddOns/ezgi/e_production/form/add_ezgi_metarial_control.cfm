<!---Ezgi Bilgisayar - Üretim Kumas Kontrol Penceresi ZAG - 25/02/2014--->
<style>
.thb {
	font-size: 11px;
	font-weight: bold;
	background-color: silver;
	text-align:center
}
.stil1 {
	font-size: 12px;
	font-weight: bold;

}
</style>
<cfquery name="get_default" datasource="#dsn3#">
	SELECT       
    	EMAD.DEFAULT_RAW_STORE_ID, 
        EMAD.DEFAULT_RAW_LOC_ID, 
        EMAD.DEFAULT_PRODUCTION_STORE_ID, 
        EMAD.DEFAULT_PRODUCTION_LOC_ID, 
        EMAD.POINT_METHOD, 
        EMAD.CONTROL_METHOD,
        EMAD.FABRIC_CAT
	FROM            
    	EZGI_MASTER_PLAN_DEFAULTS AS EMAD INNER JOIN
     	EZGI_MASTER_PLAN AS EMAP ON EMAD.SHIFT_ID = EMAP.MASTER_PLAN_CAT_ID
	WHERE        
    	EMAP.MASTER_PLAN_ID = #attributes.master_plan_id#
</cfquery>
<cfparam name="attributes.total_control" default="0">
<cfset control_department = get_default.DEFAULT_RAW_STORE_ID>
<cfset control_location = get_default.DEFAULT_RAW_LOC_ID>
<cfset upd = 0>
<!---Lot a Bağlı Siparişin Açıklaması Alınıyor--->
<cfquery name="get_orders_info" datasource="#dsn3#">
	SELECT        
    	O.ORDER_NUMBER,
        ISNULL(O.ORDER_ID,0) AS ORDER_ID
	FROM            
    	PRODUCTION_ORDERS_ROW AS POR INNER JOIN
      	ORDERS AS O ON POR.ORDER_ID = O.ORDER_ID RIGHT OUTER JOIN
     	PRODUCTION_ORDERS AS PO ON POR.PRODUCTION_ORDER_ID = PO.P_ORDER_ID
	WHERE        
    	PO.LOT_NO = '#attributes.lot_no#'
	GROUP BY 
    	O.ORDER_NUMBER,
        O.ORDER_ID
</cfquery>
<!---Lot a Bağlı Kumaş ihtiyaç Bilgileri Toplanıyor--->
<cfquery name="get_malzeme" datasource="#dsn3#">
	SELECT     
    	<cfif get_default.CONTROL_METHOD eq 1 or get_orders_info.ORDER_ID eq 0>
       		PO.LOT_NO,
  		<cfelseif get_default.CONTROL_METHOD eq 2 and get_orders_info.ORDER_ID gt 0>
        	#get_orders_info.ORDER_ID# AS ORDER_ID,
    	</cfif> 
        POS.POR_STOCK_ID, 
        PU.MAIN_UNIT, 
        S.PRODUCT_NAME, 
        S.PRODUCT_CODE,
        S.STOCK_ID, 
        POS.AMOUNT, 
        SAQ.QUESTION_NAME,
        (SELECT PRODUCT_NAME FROM STOCKS WHERE STOCK_ID = PO.STOCK_ID) AS URUN_ADI
	FROM         
    	PRODUCTION_ORDERS_STOCKS AS POS INNER JOIN
       	PRODUCTION_ORDERS AS PO ON POS.P_ORDER_ID = PO.P_ORDER_ID INNER JOIN
        PRODUCT_UNIT AS PU ON POS.PRODUCT_UNIT_ID = PU.PRODUCT_UNIT_ID INNER JOIN
        STOCKS AS S ON POS.STOCK_ID = S.STOCK_ID INNER JOIN
        SPECT_MAIN AS SM ON PO.SPEC_MAIN_ID = SM.SPECT_MAIN_ID INNER JOIN
        SPECT_MAIN_ROW AS SMR ON POS.SPECT_MAIN_ROW_ID = SMR.SPECT_MAIN_ROW_ID AND SM.SPECT_MAIN_ID = SMR.SPECT_MAIN_ID INNER JOIN
        #dsn_alias#.SETUP_ALTERNATIVE_QUESTIONS AS SAQ ON SMR.QUESTION_ID = SAQ.QUESTION_ID
	WHERE     
   		POS.TYPE = 2 AND 
        S.PRODUCT_CODE LIKE N'#get_default.FABRIC_CAT#%' AND
        <cfif get_default.CONTROL_METHOD eq 1 or get_orders_info.ORDER_ID eq 0>
        	PO.LOT_NO =#attributes.lot_no#
		<cfelseif get_default.CONTROL_METHOD eq 2 and get_orders_info.ORDER_ID gt 0>
        	PO.LOT_NO IN 	
            			(
            				SELECT        
                            	PO1.LOT_NO
							FROM            
                            	ORDER_ROW AS ORR INNER JOIN
                             	PRODUCTION_ORDERS AS PO INNER JOIN
                             	PRODUCTION_ORDERS_ROW AS PORR ON PO.P_ORDER_ID = PORR.PRODUCTION_ORDER_ID ON ORR.ORDER_ID = PORR.ORDER_ID INNER JOIN
                             	PRODUCTION_ORDERS_ROW AS PORR1 ON ORR.ORDER_ROW_ID = PORR1.ORDER_ROW_ID INNER JOIN
                             	EZGI_MASTER_ALT_PLAN AS EMAP INNER JOIN
                            	EZGI_MASTER_PLAN_RELATIONS AS EMAR ON EMAP.MASTER_ALT_PLAN_ID = EMAR.MASTER_ALT_PLAN_ID ON PORR1.PRODUCTION_ORDER_ID = EMAR.P_ORDER_ID INNER JOIN
                         		PRODUCTION_ORDERS AS PO1 ON PORR1.PRODUCTION_ORDER_ID = PO1.P_ORDER_ID
							WHERE        
                            	PO.LOT_NO = N'#attributes.lot_no#' AND 
                                EMAP.MASTER_PLAN_ID = #attributes.master_plan_id#
            				
            
            			)
        </cfif>
  	ORDER BY
    	S.PRODUCT_CODE
</cfquery>
<cfset por_stock_id_list = Valuelist(get_malzeme.POR_STOCK_ID)>
<cfif get_malzeme.recordcount>
	<cfquery name="get_malzeme_group" dbtype="query">
    	SELECT
        	STOCK_ID,
    		SUM(AMOUNT) TOTAL_AMOUNT
      	FROM
        	GET_MALZEME
       	GROUP BY
        	STOCK_ID      
    </cfquery>
    <cfif get_malzeme_group.recordcount>
    	<cfloop query="get_malzeme_group">
    		<cfset 'TOTAL_AMOUNT_#STOCK_ID#' = TOTAL_AMOUNT>
    	</cfloop>
    </cfif>
    <cfset stock_id_list = ValueList(get_malzeme.STOCK_ID)>
    <!---Optimizasyon Giriş Kontrolü Yapılıyor--->
    <cfquery name="get_ezgi_metarial_control" datasource="#dsn3#">
    	SELECT     
            POR_STOCK_ID, 
            AMOUNT, 
            RECORD_EMP, 
            RECORD_DATE, 
            UPDATE_EMP, 
            UPDATE_DATE,
            PASTAL_CODE
		FROM         
        	EZGI_METARIAL_CONTROL
		WHERE     
        	<cfif get_default.CONTROL_METHOD eq 1 or get_orders_info.ORDER_ID eq 0>
            	LOT_NO =#attributes.lot_no#
            <cfelseif get_default.CONTROL_METHOD eq 2 and get_orders_info.ORDER_ID gt 0>
        		ORDER_ID = #get_orders_info.ORDER_ID# AND
                POR_STOCK_ID IN (#por_stock_id_list#)
        	</cfif>
    </cfquery>
    <!---<cfdump expand="yes" var="#get_ezgi_metarial_control#">
    <cfdump expand="yes" var="#get_malzeme#">
    <cfabort>--->
    <cfif get_ezgi_metarial_control.recordcount>
    	<cfset upd = 1>
        <cfset record_emp =get_ezgi_metarial_control.RECORD_EMP>
        <cfset record_date =get_ezgi_metarial_control.RECORD_DATE>
        <cfset update_emp =get_ezgi_metarial_control.UPDATE_EMP>
        <cfset update_date =get_ezgi_metarial_control.UPDATE_DATE>
        <cfoutput query="get_ezgi_metarial_control">
        	<cfset 'AMOUNT_#POR_STOCK_ID#' = AMOUNT>
            <cfset 'PASTAL_CODE_#POR_STOCK_ID#' = PASTAL_CODE>
        </cfoutput>
    </cfif>
    <cfset ic_talep = 0>
 	<cfquery name="get_kontrol" datasource="#dsn3#">
     	SELECT 
        	ISNULL(STATUS,0) STATUS 
       	FROM 
        	EZGI_METARIAL_CONTROL 
      	WHERE 
            <cfif get_default.CONTROL_METHOD eq 1 or get_orders_info.ORDER_ID eq 0>
            	LOT_NO =#attributes.lot_no#
            <cfelseif get_default.CONTROL_METHOD eq 2 and get_orders_info.ORDER_ID gt 0>
        		ORDER_ID = #get_orders_info.ORDER_ID#	
        	</cfif>
  	</cfquery>
  	<cfif get_kontrol.recordcount>
        	<cfquery name="get_kontrol_1" dbtype="query">
            	SELECT STATUS FROM get_kontrol WHERE STATUS = 0
            </cfquery>
            <cfif not get_kontrol_1.recordcount>
            	<cfset ic_talep = 1>     
            </cfif>
   	</cfif>
    <cfif ic_talep eq 1>
        <cfquery name="_PRODUCT_TOTAL_STOCK_" datasource="#DSN2#"><!--- Ürünlerin stock durumlarını liste yöntemi ile alıyoruz. --->
            SELECT 
                    ISNULL(SUM(PRODUCT_STOCK),0) AS PRODUCT_STOCK,
                    STOCK_ID
                FROM 
                    (
                        SELECT
                            SUM(SR.STOCK_IN - SR.STOCK_OUT) AS PRODUCT_STOCK, 
                            ISNULL(SR.SPECT_VAR_ID,0) SPECT_VAR_ID,
                            S.PRODUCT_ID, 
                            S.STOCK_ID, 
                            S.STOCK_CODE, 
                            S.PROPERTY,
                            S.STOCK_STATUS, 
                            S.BARCOD
                        FROM
                            #dsn1_alias#.STOCKS S,
                            STOCKS_ROW SR
                        WHERE
                            S.STOCK_ID = SR.STOCK_ID AND 
                            SR.STORE = #control_department# AND 
                            SR.STORE_LOCATION = #control_location#
                        GROUP BY
                            SR.SPECT_VAR_ID,
                            S.PRODUCT_ID,
                            S.STOCK_ID,
                            S.STOCK_CODE,
                            S.PROPERTY,
                            S.STOCK_STATUS, 
                            S.BARCOD
                    ) AS GET_STOCK
                WHERE
                    STOCK_ID IN (#stock_id_list#)
                GROUP BY 
                    STOCK_ID
            </cfquery>
            <cfoutput query="_PRODUCT_TOTAL_STOCK_">
                <cfset 'PRODUCT_STOCK_#STOCK_ID#'= PRODUCT_STOCK>
            </cfoutput>
            <cfquery name="getStockStrategy" datasource="#dsn3#"><!--- Ürünün stok stratejilerini çekiyoruz. --->
                SELECT
                    DISTINCT
                    SS.STOCK_ID,
                    ISNULL(SS.MAXIMUM_STOCK,0) AS MAXIMUM_STOCK,
                    ISNULL(SS.PROVISION_TIME,0) AS PROVISION_TIME ,
                    ISNULL(SS.REPEAT_STOCK_VALUE,0) AS REPEAT_STOCK_VALUE,
                    ISNULL(SS.MINIMUM_STOCK,0) AS MINIMUM_STOCK,
                    ISNULL(SS.MINIMUM_ORDER_STOCK_VALUE,0) AS MINIMUM_ORDER_STOCK_VALUE
                FROM
                    STOCK_STRATEGY SS
                WHERE
                    SS.STOCK_ID IN(#stock_id_list#) AND
                    ISNULL(SS.DEPARTMENT_ID,0)=0
            </cfquery>
            <cfoutput query="getStockStrategy">
                <cfset 'MAXIMUM_STOCK_#STOCK_ID#'= MAXIMUM_STOCK>
                <cfset 'PROVISION_TIME_#STOCK_ID#'= PROVISION_TIME>
                <cfset 'REPEAT_STOCK_VALUE_#STOCK_ID#'= REPEAT_STOCK_VALUE>
                <cfset 'MINIMUM_STOCK_#STOCK_ID#'= MINIMUM_STOCK>
                <cfset 'MINIMUM_ORDER_STOCK_VALUE_#STOCK_ID#'= MINIMUM_ORDER_STOCK_VALUE>
            </cfoutput>
            <cfquery name="_GET_STOCK_RESERVED_" datasource="#DSN3#"><!--- Ürünün rezerve durumlarını liste yöntemi ile çekiyoruz. --->
                SELECT
                    ISNULL(SUM(STOCK_ARTIR),0) AS ARTAN,
                    ISNULL(SUM(STOCK_AZALT),0) AS AZALAN,
                    STOCK_ID
                FROM
                    GET_STOCK_RESERVED_SPECT
                WHERE
                    STOCK_ID IN (#stock_id_list#)
                GROUP BY 
                    STOCK_ID
            </cfquery>
            <cfoutput query="_GET_STOCK_RESERVED_">
                <cfset 'ARTAN_STOCK_#STOCK_ID#'= ARTAN>
                <cfset 'AZALAN_STOCK_#STOCK_ID#'= AZALAN>
            </cfoutput>
            <cfquery name="_location_based_total_stock_" datasource="#dsn2#">
                SELECT
                    STOCK_ID,
                    SUM(STOCK_IN - SR.STOCK_OUT) AS TOTAL_LOCATION_STOCK
                FROM
                    STOCKS_ROW SR,
                    #dsn_alias#.STOCKS_LOCATION SL 
                WHERE
                    STOCK_ID IN (#stock_id_list#) AND
                    SR.STORE = SL.DEPARTMENT_ID AND
                    SR.STORE_LOCATION = SL.LOCATION_ID AND
                    NO_SALE = 1
               GROUP BY STOCK_ID
        </cfquery>
   	</cfif>
    <!---Lot a Bağlı İhtiyaçların Stok Grup Toplamları Bulunuyor--->
    <cfquery name="get_malzeme_group" dbtype="query">
		SELECT     
            <cfif get_default.CONTROL_METHOD eq 1 or get_orders_info.ORDER_ID eq 0>
            	LOT_NO,
            <cfelseif get_default.CONTROL_METHOD eq 2 and get_orders_info.ORDER_ID gt 0>
        		ORDER_ID,
        	</cfif>
            MAIN_UNIT, 
            PRODUCT_NAME, 
            PRODUCT_CODE,
            STOCK_ID, 
            sum(AMOUNT) AMOUNT
        FROM
        	get_malzeme     
		GROUP BY
        	<cfif get_default.CONTROL_METHOD eq 1 or get_orders_info.ORDER_ID eq 0>
            	LOT_NO,
            <cfelseif get_default.CONTROL_METHOD eq 2 and get_orders_info.ORDER_ID gt 0>
        		ORDER_ID,
        	</cfif>
            MAIN_UNIT, 
            PRODUCT_NAME, 
            PRODUCT_CODE,
            STOCK_ID
        ORDER BY
            PRODUCT_CODE
    </cfquery>
    <table width="98%" border="0" cellspacing="0" cellpadding="0" align="center">
        <tr class="color-list">
        	<td style="height:40px; font-size:16px; font-weight:bold"> &nbsp;
				<cfif get_default.CONTROL_METHOD eq 1 or get_orders_info.ORDER_ID eq 0>
                    Kumaş Stok Kontrol - Lot No : <cfoutput>#get_malzeme.lot_no#</cfoutput>
                <cfelseif get_default.CONTROL_METHOD eq 2 and get_orders_info.ORDER_ID gt 0>
                    Kumaş Stok Kontrol - Sipariş No : <cfoutput>#get_orders_info.order_number#</cfoutput>
                </cfif>
            </td>
            <td></td>
        </tr>
    <cfform name="kumaskontrol" action="#request.self#?fuseaction=prod.emptypopup_add_ezgi_metarial_control" method="post">
    	<cfinput type="hidden" name="master_plan_id" value="#attributes.master_plan_id#">
    	<cfif get_default.CONTROL_METHOD eq 1 or get_orders_info.ORDER_ID eq 0>
        	<cfinput type="hidden" name="lot_no" value="#get_malzeme.lot_no#">
		<cfelseif get_default.CONTROL_METHOD eq 2 and get_orders_info.ORDER_ID gt 0>
        	<cfinput type="hidden" name="ORDER_ID" value="#get_orders_info.ORDER_ID#">
        </cfif>
        <cfinput type="hidden" name="upd" value="#upd#">
        <table width="98%" border="1" cellspacing="0" cellpadding="0" align="center">
            <tr height="20">
            	<td class="thb" width="200" >&nbsp;Ürün Adı&nbsp;</td>
                <td class="thb" width="150" >&nbsp;Alternatif Soru&nbsp;</td>
                <td class="thb" >&nbsp;Kumaş Adı&nbsp;</td>
                <cfif upd eq 1>
                	<td class="thb" width="40" align="right" class="form-title">Miktar&nbsp;</td>
                </cfif>
                <td class="thb" width="100">Pastal Kodu&nbsp;</td>
                <td class="thb" width="40" align="right" class="form-title">Optimiz&nbsp;</td>   
                <td class="thb" width="40" align="center" >&nbsp;Birim&nbsp;</td>
                <cfif upd eq 1>
                	<td class="thb" width="70" align="center" >&nbsp;K.Kontrol&nbsp;</td>
              	</cfif>      
            </tr>
            <cfif get_malzeme.recordcount>
            	<cfif upd eq 1>
                    <tr height="20">
                		<td class="thb" colspan="7">&nbsp;</td>
                        <td class="thb">
                        	<select name="total_control" style="width:82;text-align:center; height:20px" onchange="secenek(this.value)">
                            	<option value="0" <cfif attributes.total_control eq 0>selected</cfif>>Yapılmadı</option>
                             	<option value="1" <cfif attributes.total_control eq 1>selected</cfif>>Var</option>
                               	<option value="2" <cfif attributes.total_control eq 2>selected</cfif>>Yok</option>
                          	</select>
                        </td>
                    </tr>
                </cfif>
            	<cfset stock_ = get_malzeme.stock_id>
                <cfoutput query="get_malzeme">
                    <cfquery name="METARIAL_KONTROL" datasource="#dsn3#">
                        SELECT      
                            ISNULL(STATUS,0) STATUS,
                            AMOUNT OLD_AMOUNT
                        FROM         
                            EZGI_METARIAL_CONTROL
                        WHERE     
                            POR_STOCK_ID = #POR_STOCK_ID#
                    </cfquery>
                    <cfif stock_ neq stock_id>
                    	<tr height="20">
                    		<td class="thb" colspan="<cfif upd eq 1>5<cfelse>4</cfif>" style="text-align:right"> Toplam&nbsp;</td>
                    		<td class="thb" style="text-align:right">
                            	<input type="text" name="t_amount_#stock_#" style="width:40px;text-align:right; font-weight:bold" value="<cfif isdefined('TOTAL_AMOUNT_#stock_#')>#Tlformat(Evaluate('TOTAL_AMOUNT_#stock_#'))#<cfelse>0</cfif>">
                          	</td>
                            <td class="thb" align="center" valign="middle">
                            	<!---<a href="#request.self#?fuseaction=objects.popup_list_ezgi_material_lot_search&stock_id=#stock_#&amount=#Evaluate('TOTAL_AMOUNT_#stock_#')#&lot_no=#get_malzeme.lot_no#" ><img src="/images/plus_list.gif" title="Rezervasyon <cf_get_lang_main no='170.Ekle'>"></a>--->
                            </td>
                            <cfif upd eq 1>
                            	<td class="thb">&nbsp;</td>
                            </cfif>
                        </tr>
                        <cfset stock_ = get_malzeme.stock_id>
                    </cfif>
                    <tr height="20" onMouseOver="this.className='color-light';" onMouseOut="this.className='color-row';" class="color-row"> 
                        <input type="hidden" name="por_stock_id" value="#POR_STOCK_ID#" />
                        
                        <input type="hidden" name="old_amount_#POR_STOCK_ID#" value="#AMOUNT#" />
                        <td class="thc" style="font-weight:bold">&nbsp;#URUN_ADI#</td>
                        <td class="thc">&nbsp;#QUESTION_NAME#</td>
                        <td class="thc">&nbsp;#PRODUCT_NAME#</td>
                        <cfif upd eq 1>
                        	<td class="thc" style="text-align:right"><cfif isdefined('AMOUNT_#POR_STOCK_ID#')>#TlFormat(Evaluate('AMOUNT_#POR_STOCK_ID#'))#</cfif></td>
                        </cfif>
                        <td class="thc">
                        	<input type="text" name="pastal_code_#POR_STOCK_ID#" maxlength="99"  style="width:100px; text-align:left; " value="<cfif isdefined('PASTAL_CODE_#POR_STOCK_ID#')>#Evaluate('PASTAL_CODE_#POR_STOCK_ID#')#</cfif>">
                        </td>
                        
                        <td class="thc" style="text-align:right">
                            <input type="hidden" name="metarial_control_amount_#POR_STOCK_ID#" readonly="readonly" style="width:60px; text-align:right" value="#Tlformat(AMOUNT)#">
                            #Tlformat(AMOUNT)#
                        </td>
                        <td class="thc" align="center">&nbsp;#MAIN_UNIT#</td>
                        <cfif upd eq 1>
                            <td class="thc" align="center">
                                <select id="var_yok_#POR_STOCK_ID#" name="var_yok_#POR_STOCK_ID#" style="width:82; text-align:center; height:20px">
                                    <option value="0" <cfif METARIAL_KONTROL.STATUS eq 0>selected</cfif>>Yapılmadı</option>
                                    <option value="1" <cfif METARIAL_KONTROL.STATUS eq 1>selected</cfif>>Var</option>
                                    <option value="2" <cfif METARIAL_KONTROL.STATUS eq 2>selected</cfif>>Yok</option>
                                </select>
                            </td>
                        </cfif>
                    </tr>
                </cfoutput>
                <tr height="20">
					<cfoutput>
                    <td class="thb" colspan="<cfif upd eq 1>5<cfelse>4</cfif>" style="text-align:right"> Toplam&nbsp;</td>
                    <td class="thb" style="text-align:right"><input type="text" name="t_amount_#stock_#" style="width:40px; text-align:right; font-weight:bold" value="<cfif isdefined('TOTAL_AMOUNT_#stock_#')>#Tlformat(Evaluate('TOTAL_AMOUNT_#stock_#'))#<cfelse>0</cfif>"></td>
                    <td class="thb" align="center" valign="middle">
                    	<!---<a href="#request.self#?fuseaction=objects.popup_list_ezgi_material_lot_search&stock_id=#stock_#&amount=#Evaluate('TOTAL_AMOUNT_#stock_#')#&lot_no=#get_malzeme.lot_no#" ><img src="/images/plus_list.gif" title="Rezervasyon <cf_get_lang_main no='170.Ekle'>"></a>--->
                    </td>
                    <cfif upd eq 1>
                      	<td class="thb">&nbsp;</td>
                	</cfif>
					</cfoutput>
             	</tr>
            </cfif>        
        </table>
        <br />
        <table width="98%" border="0" cellspacing="0" cellpadding="0" align="center">
            <tr class="color-list" height="35">
                <td valign="middle" class="thb" style="text-align:left">
                	<cfif upd eq 1>
                    	<cfoutput>
                    	&nbsp;Kayıt : #get_emp_info(record_emp,0,0)# - #Dateformat(record_date, 'DD/MM/YYYY')# #Timeformat(record_date, 'HH:MM')#<br />&nbsp;Güncelleme : #get_emp_info(update_emp,0,0)# - #Dateformat(update_date, 'DD/MM/YYYY')# #Timeformat(update_date, 'HH:MM')#
                      </cfoutput>
                    </cfif>
                </td>
                <td align="right" valign="middle" class="thb">
                	<cfif upd eq 1>
                    	<cfsavecontent variable="message">Güncelle</cfsavecontent>
                		<cfsavecontent variable="message1">Kapat</cfsavecontent>
                    	<cf_workcube_buttons is_upd='1' insert_info="#message#" is_delete='0' is_cancel='1' cancel_info="#message1#" add_function='kontrol_row()'>
               		<cfelse>
                    	<cfsavecontent variable="message">Kaydet</cfsavecontent>
                		<cfsavecontent variable="message1">Kapat</cfsavecontent>
                		<cf_workcube_buttons is_upd='0' insert_info="#message#" is_cancel='1' cancel_info="#message1#" add_function='kontrol_row()'>
                    </cfif>
                </td>
            </tr> 	
        </table>
        <br />
        <cfif ic_talep eq 1>
            <table width="98%" border="1" cellspacing="0" cellpadding="0" align="center">
                <tr>
                    <td class="thb" style="height:25px">&nbsp;Stok Kodu</td>
                    <td class="thb">&nbsp;Ürün</td>
                    <td class="thb" width="60" style="text-align:right;">Stok&nbsp;</td>
                    <td class="thb" width="60" style="text-align:right;">Min Stok&nbsp;</td>
                    <td class="thb" width="60" style="text-align:right;" title="Satınalma Siparişleri..">Sipariş&nbsp;</td>
                    <td class="thb" width="60" style="text-align:right;">Tedarik(Gün)&nbsp;</td>
                    <td class="thb" width="60" style="text-align:right;">İhtiyaç&nbsp;</td>
                    <td class="thb" width="25" style="text-align:right;"></td>
                </tr>
                <cfquery name="get_kontrol_1" datasource="#dsn3#">
                	SELECT 
                    	POS.STOCK_ID, 
                        POS.AMOUNT
					FROM         
                    	EZGI_METARIAL_CONTROL AS EMC INNER JOIN
                      	PRODUCTION_ORDERS_STOCKS AS POS ON EMC.POR_STOCK_ID = POS.POR_STOCK_ID
					WHERE     
                    	<cfif get_default.CONTROL_METHOD eq 1 or get_orders_info.ORDER_ID eq 0>
                        	EMC.LOT_NO = '#attributes.lot_no#' AND
                        <cfelseif get_default.CONTROL_METHOD eq 2 and get_orders_info.ORDER_ID gt 0>
                            EMC.ORDER_ID = #get_orders_info.ORDER_ID# AND
                            POS.POR_STOCK_ID IN (#por_stock_id_list#) AND
                        </cfif>
                        EMC.STATUS = 2
                </cfquery>
                <!---<cfdump expand="yes" var="#get_kontrol_1#">--->
                <cfquery name="METARIAL_KONTROL" dbtype="query">
                    SELECT
                        STOCK_ID, 
                        SUM(AMOUNT) AS AMOUNT
                    FROM         
                        get_kontrol_1
                    GROUP BY 
                        STOCK_ID
                </cfquery>
                <cfoutput query="METARIAL_KONTROL">
                    <cfset 'm_kontrol_#STOCK_ID#' = AMOUNT>
                </cfoutput>
                <cfquery name="get_ic_talep" datasource="#dsn3#">
                   	SELECT     
                      	I.INTERNAL_NUMBER, 
                        EMR.ACTION_ID, 
                        IR.STOCK_ID
					FROM         
                      	EZGI_METARIAL_RELATIONS AS EMR INNER JOIN
                  		INTERNALDEMAND AS I ON EMR.ACTION_ID = I.INTERNAL_ID INNER JOIN
                  		INTERNALDEMAND_ROW AS IR ON I.INTERNAL_ID = IR.I_ID
					WHERE     
                     	EMR.TYPE = 1 AND 
                        <cfif get_default.CONTROL_METHOD eq 1 or get_orders_info.ORDER_ID eq 0>
                        	EMR.LOT_NO = '#attributes.lot_no#'
                        <cfelseif get_default.CONTROL_METHOD eq 2 and get_orders_info.ORDER_ID gt 0>
                            EMR.LOT_NO = '#get_orders_info.ORDER_number#'
                        </cfif>
                 </cfquery>
                 <cfif get_ic_talep.recordcount>
                 	<cfoutput query="get_ic_talep">
                    	<cfset 'ACTION_ID_#STOCK_ID#' = ACTION_ID>
                        <cfset 'INTERNAL_NUMBER_#STOCK_ID#' = INTERNAL_NUMBER>
                    </cfoutput>
                 </cfif>
                <cfoutput query="get_malzeme_group">
                    
                    <tr onMouseOver="this.className='color-light';" onMouseOut="this.className='color-row';" class="color-row" style="height:20px"> 
                        <td class="thc">
                            &nbsp;#PRODUCT_CODE#&nbsp;
                        </td>
                        <td class="thc">&nbsp;#PRODUCT_NAME#&nbsp;</td>
                        <td class="thc" style="text-align:right;"><cfif isdefined('PRODUCT_STOCK_#STOCK_ID#')>#evaluate('PRODUCT_STOCK_#STOCK_ID#')#&nbsp;<cfelse>0&nbsp;</cfif></td>
                        <td class="thc" style="text-align:right;"><cfif isdefined('MINIMUM_STOCK_#STOCK_ID#')>#evaluate('MINIMUM_STOCK_#STOCK_ID#')#&nbsp;<cfelse>0&nbsp;</cfif></td>
                        <td class="thc" style="text-align:right;">
                            <cfif isdefined('ARTAN_STOCK_#STOCK_ID#')>
                                    #evaluate('ARTAN_STOCK_#STOCK_ID#')#&nbsp;
                            <cfelse>
                                0&nbsp;
                            </cfif>
                        </td>
                        <td class="thc" style="text-align:right;"><cfif isdefined('PROVISION_TIME_#STOCK_ID#')>#evaluate('PROVISION_TIME_#STOCK_ID#')#&nbsp;<cfelse>0&nbsp;</cfif></td>
                        <td class="thc" style="text-align:right;">
                            <cfif isdefined('m_kontrol_#STOCK_ID#')>
                                #TlFormat(Evaluate('m_kontrol_#STOCK_ID#'))#&nbsp;
                            <cfelse>
                                0&nbsp;
                            </cfif>
                        </td>
                        <td class="thc" style="text-align:center; vertical-align:middle">
                        	<cfif isdefined('ACTION_ID_#STOCK_ID#')>
								<cfset action_id = Evaluate('ACTION_ID_#STOCK_ID#')>
                                <a href="#request.self#?fuseaction=purchase.list_internaldemand&event=upd&id=#action_id#"><img src="/images/update_list.gif" title="<cf_get_lang_main no='52.Güncelle'>" border="0"></a>
                            <cfelse>
								<cfif isdefined('m_kontrol_#STOCK_ID#')>
                                    <input type="checkbox" name="select_production" value="#STOCK_ID#_#Evaluate('m_kontrol_#STOCK_ID#')#">
                                <cfelse>
                                	&nbsp;
                                </cfif>
                          	</cfif>
                        </td>
                    </tr>
                </cfoutput>
            </table>
            <br />
            <table width="98%" border="0" cellspacing="0" cellpadding="0" align="center">
                <tr>
                    <td class="thb" style="text-align:right; vertical-align:middle; height:30px"><input type="button" value="İç Talep Oluştur" onClick="grupla();"></td>
                </tr> 	
            </table>
      	</cfif>      
    </cfform>
</cfif>
<script language="javascript">
	function kontrol_row()
	{
		return true;
	}
	function grupla(type)
		{//type sadece -1 olarak gelir,-1 geliyorsa hepsini seç demektir.
			p_order_id_list = '';
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
						p_order_id_list +=my_objets.value+',';
				}
			}
			
			<cfif get_default.CONTROL_METHOD eq 1 or get_orders_info.ORDER_ID eq 0>
       			var lot_no = document.all.lot_no.value;
			<cfelseif get_default.CONTROL_METHOD eq 2 and get_orders_info.ORDER_ID gt 0>
				var lot_no = <cfoutput>'#get_orders_info.ORDER_NUMBER#'</cfoutput>;
			</cfif>
			p_order_id_list = p_order_id_list.substr(0,p_order_id_list.length-1);//sondaki virgülden kurtarıyoruz.
			if(p_order_id_list=='')
			{
			alert('İç Talep İçin Seçim Yapınız !!!');
			}
			else
			{
			window.location ='<cfoutput>#request.self#?fuseaction=prod.emptypopup_add_ezgi_metarial_talep&master_plan_id=#attributes.master_plan_id#</cfoutput>&p_order_id_list='+p_order_id_list+'&lot_no='+lot_no;
			wrk_opener_reload();
			}
		}
	function secenek(secim)
	{
		<cfloop query="get_malzeme">
			<cfoutput>
			cii=#get_malzeme.POR_STOCK_ID#;
			</cfoutput>
			eval("document.getElementById('var_yok_'+cii)").value=secim;
		</cfloop>
	}
</script>