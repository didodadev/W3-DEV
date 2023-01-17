<cfparam name="attributes.date1" default="#now()#"> 
<cfparam name="attributes.date2" default="#now()#"> 
<cfparam name="is_equal_group_stations" default="0">
<cfparam name="attributes.production_stage" default="">
<cfparam name="attributes.lot_no" default="">
<cfparam name="attributes.is_submitted" default="">
<cfparam name="attributes.keyword" default="">
<cfparam name="attributes.order_no" default="">
<cfparam name="attributes.consumer_id" default="">
<cfparam name="attributes.company_id" default="">
<cfparam name="attributes.member_type" default="">
<cfparam name="attributes.member_name" default="">
<cfparam name="attributes.vardiya_sales" default="">
<cfparam name="attributes.order_employee_id" default="">
<cfparam name="attributes.order_employee" default="">
<cfparam name="attributes.sales_partner_id" default="">
<cfparam name="attributes.sales_partner" default="">
<cfparam name="attributes.product_id" default="">
<cfparam name="attributes.product_name" default="">
<cfparam name="attributes.product_catid" default="">
<cfparam name="attributes.product_cat" default="">
<cfparam name="attributes.start_date" default="">
<cfparam name="attributes.finish_date" default="">
<cfparam name="attributes.stock_id" default="">
<cfparam name="attributes.spect_main_id" default="">
<cfparam name="attributes.spect_name" default="">
<cfparam name="attributes.reference_no" default="">
<cfparam name="attributes.result" default="">
<cfparam name="attributes.is_submitted" default="0">
<cfquery name="get_station" datasource="#dsn3#">
	SELECT        
    	WORKSTATION_ID
	FROM            
    	EZGI_MASTER_PLAN_SABLON
	WHERE        
    	PROCESS_ID = #attributes.islem_id#
</cfquery>
<cfquery name="GET_W" datasource="#dsn3#">
	SELECT        
    	MASTER_PLAN_ID, 
        MASTER_PLAN_START_DATE, 
        MASTER_PLAN_FINISH_DATE, 
        MASTER_PLAN_NUMBER, 
        MASTER_PLAN_CAT_ID
	FROM            
    	EZGI_MASTER_PLAN
	WHERE        
    	MASTER_PLAN_ID = #attributes.master_plan_id#
  	ORDER BY
    	MASTER_PLAN_NUMBER
</cfquery>
<cfquery name="get_up_sub_plan" datasource="#dsn3#">
	SELECT        
    	EMAP.RELATED_MASTER_ALT_PLAN_ID, 
        EMAP.PROCESS_ID, 
        EMPS.WORKSTATION_ID
	FROM            
    	EZGI_MASTER_ALT_PLAN AS EMAP INNER JOIN
      	EZGI_MASTER_PLAN_SABLON AS EMPS ON EMAP.PROCESS_ID = EMPS.PROCESS_ID
	WHERE        
    	EMAP.MASTER_ALT_PLAN_ID = #attributes.master_alt_plan_id#
</cfquery>
<cfquery name="get_station_times" datasource="#dsn#">
	SELECT * FROM SETUP_SHIFTS WHERE SHIFT_ID=#GET_W.MASTER_PLAN_CAT_ID#
</cfquery>
<cfset works_prog = get_station_times.SHIFT_NAME>
<cfset works_prog_id = get_station_times.SHIFT_ID>
<cfif get_up_sub_plan.recordcount>
   	<cfquery name="GET_EZGI_MIP_1" datasource="#dsn3#">
		SELECT        
        	GS.REAL_STOCK, 
            GS.PRODUCT_STOCK, 
            GS.RESERVED_STOCK, 
            GS.PURCHASE_PROD_STOCK, 
            GS.RESERVED_PROD_STOCK, 
            GS.SALEABLE_STOCK, 
            GS.RESERVE_SALE_ORDER_STOCK, 
            GS.NOSALE_STOCK,
       		GS.BELONGTO_INSTITUTION_STOCK, 
            GS.RESERVE_PURCHASE_ORDER_STOCK, 
            GS.PRODUCTION_ORDER_STOCK, 
            GS.NOSALE_RESERVED_STOCK, 
            GS.PRODUCT_ID, 
            GS.STOCK_ID,
           	S.PRODUCT_CODE,
            S.PRODUCT_NAME,
         	ISNULL((
            	SELECT        
                	MAXIMUM_STOCK
              	FROM            
                  	STOCK_STRATEGY
              	WHERE        
                	STOCK_ID = S.STOCK_ID
          	), 0) AS MAXIMUM_STOCK, 
			ISNULL((
            	SELECT        
                	MINIMUM_STOCK
              	FROM            
                	STOCK_STRATEGY AS STOCK_STRATEGY_1
            	WHERE        
                	STOCK_ID = S.STOCK_ID
          	), 0) AS MINIMUM_STOCK,
            (
            	SELECT        
                	TOP (1) SPECT_MAIN_ID
				FROM            
                	SPECT_MAIN
				WHERE        
                	SPECT_STATUS = 1 AND 
                    STOCK_ID = S.STOCK_ID
				ORDER BY 
                	SPECT_MAIN_ID
            ) AS SPECT_MAIN_ID,
         	(
            	SELECT     
                	MAIN_UNIT
               	FROM          
                	PRODUCT_UNIT
           		WHERE      
                	IS_MAIN = 1 AND 
                    PRODUCT_ID = S.PRODUCT_ID
           	) AS MAIN_UNIT
		FROM            
        	#dsn2_alias#.GET_STOCK_LAST_PROFILE AS GS INNER JOIN
          	STOCKS AS S ON GS.STOCK_ID = S.STOCK_ID
		WHERE   
        	S.IS_PRODUCTION = 1 AND 
            GS.SALEABLE_STOCK < 0 AND
            S.STOCK_ID IN
            				(
                           	SELECT        
                                STOCK_ID
                			FROM            
                            	WORKSTATIONS_PRODUCTS
                			WHERE        
                            	WS_ID = #get_up_sub_plan.WORKSTATION_ID#
                            ) 
    </cfquery>
</cfif>
<br />
<table width="98%" align="center" border="0">
	<tr>
		<td class="headbold" width="500"><cf_get_lang_main no='3413.Plan İhtiyaç Karşılama Raporu'></td>
		<td align="right">
			<table>
		
			</table> 
		<!-- sil -->
		</td>
	</tr>
</table>
<table width="98%" border="0" cellspacing="1" cellpadding="2" class="color-border" align="center">
	<tr class="color-header" height="22">
        <td width="2%" height="30px" align="center" valign="middle" class="form-title"><cf_get_lang_main no='1165.Sıra'></td>
        <td width="7%" align="center" valign="middle" class="form-title"><cf_get_lang_main no='106.Stok Kodu'></td>
        <td width="24%" align="center" valign="middle" class="form-title"><cf_get_lang_main no='809.Ürün Adı'></td>
        <td width="4%" align="center" valign="middle" class="form-title"><cf_get_lang_main no='224.Birim'></td>
        <td width="6%" align="center" valign="middle" class="form-title"><cf_get_lang_main no='708.Gerçek Stok'></td>
        <td width="6%" align="center" valign="middle" class="form-title"><cf_get_lang_main no='3414.Verilen Sipariş Rezerve'></td>
        <td width="6%" align="center" valign="middle" class="form-title"><cf_get_lang_main no='3415.Alınan Sipariş Rezerve'></td>
        <td width="6%" align="center" valign="middle" class="form-title"><cf_get_lang_main no='3416.Tüm Üretim İhtiyaçları'></td>
        <td width="6%" align="center" valign="middle" class="form-title"><cf_get_lang_main no='3417.Tüm Üretim Beklenen'></td>
        <td width="6%" align="center" valign="middle" class="form-title">Optimum <cf_get_lang_main no='40.Stok'></td>
        <td width="6%" align="center" valign="middle" class="form-title"><cf_get_lang_main no='3418.Gerçek İhtiyaç'></td>
        <td width="6%" align="center" valign="middle" class="form-title"><cf_get_lang_main no='3419.İş Emri Miktarı'></td>
        <td class="form-title" align="center" width="1%" title="<cf_get_lang_main no='3009.Hepsini Seç'>"><input type="checkbox" name="allSelectDemand" id="allSelectDemand" onClick="wrk_select_all('allSelectDemand','is_active');"></td>
  	</tr>
    <cfif get_up_sub_plan.recordcount>
   		<cfset islem_type=1>
    	<cfinclude template="ezgi_production_plan_include.cfm">
 	<cfelse>
      	<tr class="color-row" height="20">
       		<td colspan="16"><cf_get_lang_main no='72.Kayıt Yok'> !</td>
     	</tr>
  	</cfif>       
</table>