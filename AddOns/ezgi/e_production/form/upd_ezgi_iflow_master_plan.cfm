<cfparam name="attributes.sort_type" default="10">
<cfset main_result_amount = 0>
<cfset kapasite_kullanim_orani = 0>
<cfset makine_sayisi = 0>
<cfset biggest_time_day = 0>
<cfset biggest_time_operation = 1>
<cfquery name="get_plan_info" datasource="#dsn#">
	SELECT        
        SS.DEPARTMENT_ID,
        SS.CONTROL_HOUR_1,
       	E.MASTER_PLAN_ID, 
        E.MASTER_PLAN_START_DATE, 
        E.MASTER_PLAN_FINISH_DATE, 
        E.MASTER_PLAN_NAME, 
        E.MASTER_PLAN_NUMBER, 
        E.MASTER_PLAN_DETAIL, 
        E.MASTER_PLAN_STATUS, 
     	E.MASTER_PLAN_STAGE, 
        E.IS_PROCESS, 
        E.EMPLOYYEE_ID, 
        E.MASTER_PLAN_PROJECT_ID,
        E.MASTER_PLAN_CAT_ID,
        E.GROSSTOTAL,
        (
        	SELECT        
            	SUM(PO.QUANTITY) AS QUANTITY
			FROM            
            	#dsn3_alias#.PRODUCTION_ORDERS AS PO INNER JOIN
              	#dsn3_alias#.EZGI_IFLOW_PRODUCTION_ORDERS AS EP ON PO.LOT_NO = EP.LOT_NO INNER JOIN
            	#dsn3_alias#.STOCKS AS S ON PO.STOCK_ID = S.STOCK_ID
			WHERE        
            	S.PRODUCT_CATID =
                             	(
                                	SELECT        
                                    	DEFAULT_PACKAGE_CAT_ID
                               		FROM            
                                   		#dsn3_alias#.EZGI_DESIGN_DEFAULTS
                             	) AND 
             	EP.MASTER_PLAN_ID = E.MASTER_PLAN_ID
        ) AS TOTAL_PACKAGE,
        (
        	SELECT        
            	ISNULL(SUM(TBL.AMOUNT), 0) AS AMOUNT
			FROM          
            	#dsn3_alias#.PRODUCTION_ORDERS AS PO INNER JOIN
               	#dsn3_alias#.EZGI_IFLOW_PRODUCTION_ORDERS AS EP ON PO.LOT_NO = EP.LOT_NO INNER JOIN
              	#dsn3_alias#.STOCKS AS S ON PO.STOCK_ID = S.STOCK_ID LEFT OUTER JOIN
            	(
                	SELECT        
                    	POR.P_ORDER_ID, SUM(PORR.AMOUNT) AS AMOUNT
                 	FROM            
                    	#dsn3_alias#.PRODUCTION_ORDER_RESULTS AS POR INNER JOIN
                    	#dsn3_alias#.PRODUCTION_ORDER_RESULTS_ROW AS PORR ON POR.PR_ORDER_ID = PORR.PR_ORDER_ID
              		WHERE        
                    	POR.IS_STOCK_FIS = 1 AND 
                        PORR.TYPE = 1
                  	GROUP BY 
                    	POR.P_ORDER_ID
             	) AS TBL ON PO.P_ORDER_ID = TBL.P_ORDER_ID
			WHERE        
            	S.PRODUCT_CATID =
                             	(
                                	SELECT        
                                    	DEFAULT_PACKAGE_CAT_ID
                               		FROM  	
                                    	#dsn3_alias#.EZGI_DESIGN_DEFAULTS
                           		) AND 
               	EP.MASTER_PLAN_ID = E.MASTER_PLAN_ID
        ) AS PACKAGE_RESULT_AMOUNT,
        (
        	SELECT        
            	SUM(AMOUNT) AS MODUL_AMOUNT
			FROM            
            	(
                	SELECT        
                    	MIN(ISNULL(TBL.AMOUNT, 0)) AS AMOUNT
                 	FROM            
                    	#dsn3_alias#.PRODUCTION_ORDERS AS PO INNER JOIN
                    	#dsn3_alias#.EZGI_IFLOW_PRODUCTION_ORDERS AS EP ON PO.LOT_NO = EP.LOT_NO INNER JOIN
                   		#dsn3_alias#.STOCKS AS S ON PO.STOCK_ID = S.STOCK_ID LEFT OUTER JOIN
                     	(
                        	SELECT        
                            	POR.P_ORDER_ID, SUM(PORR.AMOUNT) AS AMOUNT
                        	FROM            
                            	#dsn3_alias#.PRODUCTION_ORDER_RESULTS AS POR INNER JOIN
                             	#dsn3_alias#.PRODUCTION_ORDER_RESULTS_ROW AS PORR ON POR.PR_ORDER_ID = PORR.PR_ORDER_ID
                           	WHERE        
                            	POR.IS_STOCK_FIS = 1 AND 
                                PORR.TYPE = 1
                     		GROUP BY 
                            	POR.P_ORDER_ID
                      	) AS TBL ON PO.P_ORDER_ID = TBL.P_ORDER_ID
               		WHERE        
                    	S.PRODUCT_CATID =
                                    	(
                                        	SELECT        
                                            	DEFAULT_PACKAGE_CAT_ID
                                         	FROM            
                                          		#dsn3_alias#.EZGI_DESIGN_DEFAULTS
                                       	) AND 
                     	EP.MASTER_PLAN_ID = E.MASTER_PLAN_ID
                	GROUP BY 
                    	EP.LOT_NO
       			) AS TBL2
        ) AS MODUL_AMOUNT,
        CASE
        	WHEN E.UPDATE_DATE > 0 THEN E.UPDATE_DATE
            ELSE E.RECORD_DATE
      	END MASTER_PLAN_PLANNING_DATE
	FROM            
    	SETUP_SHIFTS AS SS INNER JOIN
  		#dsn3_alias#.EZGI_IFLOW_MASTER_PLAN AS E ON SS.SHIFT_ID = E.MASTER_PLAN_CAT_ID
	WHERE        
    	E.MASTER_PLAN_ID = #attributes.master_plan_id#
</cfquery>
<cfset attributes.shift_id = get_plan_info.MASTER_PLAN_CAT_ID>
<cfset attributes.start_date = get_plan_info.MASTER_PLAN_START_DATE>
<cfset attributes.finish_date = get_plan_info.MASTER_PLAN_FINISH_DATE>
<cfset ara_stok = get_plan_info.GROSSTOTAL>
<cfparam name="attributes.department_id" default="#get_plan_info.DEPARTMENT_ID#">
<cfset gunluk_caliasma_saat = get_plan_info.CONTROL_HOUR_1>
<cfquery name="get_defaults" datasource="#dsn3#">
	SELECT * FROM EZGI_DESIGN_DEFAULTS
</cfquery>
<cfset toplam_operator_sayisi = get_defaults.DEFAULT_ACTIVE_OPERATOR_AMOUNT>
<cfif gunluk_caliasma_saat lte 0>
	
</cfif>
<cfif not len(attributes.department_id)>

</cfif>
<cfif toplam_operator_sayisi lte 0>

</cfif>
<!---Operasyonlar Bulunuyor--->
<cfquery name="get_operations" datasource="#dsn3#">
	SELECT        
    	OPERATION_TYPE_ID, 
      	OPERATION_TYPE, 
    	OPERATION_CODE
	FROM            
   		OPERATION_TYPES
	WHERE        
     	IS_VIRTUAL = 0 AND 
     	OPERATION_STATUS = 1 AND 
    	OPERATION_TYPE_ID IN
                    		(
                           	SELECT        
                            	OPERATION_TYPE_ID
                         	FROM            
                              	WORKSTATIONS_PRODUCTS
                          	WHERE        
                            	WS_ID IN
                                 	(
                                   	SELECT        
                                    	STATION_ID
                                  	FROM            
                                      	WORKSTATIONS
                                  	WHERE        
                                     	DEPARTMENT = #attributes.department_id# AND 
                                    	ACTIVE = 1 AND
                                     	OPERATION_TYPE_ID IS NOT NULL
                                  	)
       						)
	ORDER BY 
     	OPERATION_CODE
</cfquery>
<cfoutput query="get_operations">
 	<cfset 'total_operation_time_#OPERATION_TYPE_ID#' = 0>
</cfoutput>
<!---Operasyon Kişi ve Makina Sayısı Bulunuyor--->
<cfquery name="GET_EMPLOYEE_NUMBER" datasource="#DSN3#">
 	SELECT        
    	OPERATION_TYPE_ID, 
    	COUNT(*) AS SAYI,
     	ISNULL((
           	SELECT        
           		EZGI_KATSAYI
			FROM            
            	WORKSTATIONS
			WHERE        
             	STATION_ID =
                    		(
                          	SELECT        
                             	TOP (1) WS_ID
                           	FROM            
                            	WORKSTATIONS_PRODUCTS AS WP
                        	WHERE        
                             	OPERATION_TYPE_ID = WA.OPERATION_TYPE_ID AND 
                             	DEFAULT_STATUS = 1
                        	ORDER BY 
                              	WS_ID
                      		)
      	),1) AS KATSAYI 
 	FROM            
   		WORKSTATIONS_PRODUCTS WA
  	GROUP BY 
     	OPERATION_TYPE_ID
  	HAVING        
     	OPERATION_TYPE_ID IS NOT NULL
</cfquery>
<cfoutput query="GET_EMPLOYEE_NUMBER">
	<cfset 'SAYI_#OPERATION_TYPE_ID#' = SAYI>
	<cfset 'KATSAYI_#OPERATION_TYPE_ID#' = KATSAYI>
 	<cfif KATSAYI gt 0 AND SAYI gt 0>
      	<cfset kapasite_kullanim_orani = kapasite_kullanim_orani + (KATSAYI * SAYI)>
    	<cfset makine_sayisi = makine_sayisi + SAYI>
	</cfif>
</cfoutput>
<!---Üretim Emirleri Alınıyor--->
<cfinclude template="../query/get_ezgi_iflow_production_order.cfm">
<cfif get_production_orders.recordcount>
	<!---Biten Paketin Toplam Süresi Hesaplanıyor--->
    <cfset iflow_product_id_list = ValueList(get_production_orders.IFLOW_P_ORDER_ID)>
    <cfset iflow_product_id_list = ListDeleteDuplicates(iflow_product_id_list,',')>
    <!---Bu PlandaKi Emirler İçindeki Operasyonlar Bulunuyor--->
	<cfquery name="get_working_operations" datasource="#dsn3#">
    	SELECT * FROM EZGI_IFLOW_PRODUCTION_OPERATION WHERE IFLOW_P_ORDER_ID IN (#iflow_product_id_list#)
    </cfquery>
	<cfoutput query="get_working_operations">
        <cfset 'SURE_#OPERATION_TYPE_ID#_#IFLOW_P_ORDER_ID#' = O_TOTAL_PROCESS_TIME> <!---Operasyon Dosyasına Insert Edilmiş Olan (Üretim Plan Miktarı * Operasyon Süresi) dir--->
    </cfoutput>
<cfelse>
	<cfset get_operations.recordcount = 0>
	<cfset get_production_orders.recordcount = 0>
    <cfset arama_yapilmali = 1>
</cfif>
<cfquery name="GET_COMPANY_CAT" datasource="#DSN#">
	SELECT COMPANYCAT_ID,COMPANYCAT FROM COMPANY_CAT ORDER BY COMPANYCAT
</cfquery>
<cfquery name="GET_CONSUMER_CAT" datasource="#DSN#">
	SELECT CONSCAT_ID,CONSCAT FROM CONSUMER_CAT ORDER BY HIERARCHY
</cfquery>
<cfif get_operations.recordcount>
	<cfset op_col = get_operations.recordcount>
    <cfset son_col = get_operations.recordcount+14>
<cfelse>
	<cfset son_col = 14>
    <cfset op_col = 0>
</cfif>
<cfset Total_Package = get_plan_info.total_package>
<cfset Total_Main = 0>
<cfif get_production_orders.recordcount>
	<cfoutput query="get_production_orders">
    	<!---<cfset Total_Package = Total_Package + (PAKET_SAYI*QUANTITY)> <!---Paket Sayısı Hesaplama--->--->
        <cfif PRODUCT_TYPE eq 2><cfset Total_Main = Total_Main + QUANTITY></cfif> <!---Modül Sayısı Hesaplama--->
    	<cfset 'biggest_time_operation_#get_production_orders.IFLOW_P_ORDER_ID#' = 0>
        <cfset 'total_product_order_time_#get_production_orders.IFLOW_P_ORDER_ID#' = 0>
     	<cfloop query="get_operations">
         	<cfif isdefined('SURE_#get_operations.OPERATION_TYPE_ID#_#get_production_orders.IFLOW_P_ORDER_ID#')>
            	<!---Operasyon Sütunun Kümüle Operasyon Süresinin Hesaplanması--->
                <cfset 'total_operation_time_#OPERATION_TYPE_ID#_#get_production_orders.IFLOW_P_ORDER_ID#' = Evaluate('total_operation_time_#OPERATION_TYPE_ID#') + (Evaluate('SURE_#get_operations.OPERATION_TYPE_ID#_#get_production_orders.IFLOW_P_ORDER_ID#')/Evaluate('KATSAYI_#OPERATION_TYPE_ID#')/Evaluate('SAYI_#OPERATION_TYPE_ID#'))>
            	<cfset 'total_operation_time_#OPERATION_TYPE_ID#' = Evaluate('total_operation_time_#OPERATION_TYPE_ID#') + (Evaluate('SURE_#get_operations.OPERATION_TYPE_ID#_#get_production_orders.IFLOW_P_ORDER_ID#')/Evaluate('KATSAYI_#OPERATION_TYPE_ID#')/Evaluate('SAYI_#OPERATION_TYPE_ID#'))>
                
                <!---Üretim Planının Toplam Operasyon Süresinin Hesaplaması--->
                <cfset 'total_product_order_time_#get_production_orders.IFLOW_P_ORDER_ID#' = Evaluate('total_product_order_time_#get_production_orders.IFLOW_P_ORDER_ID#') + (Evaluate('SURE_#get_operations.OPERATION_TYPE_ID#_#get_production_orders.IFLOW_P_ORDER_ID#')/Evaluate('KATSAYI_#OPERATION_TYPE_ID#')/Evaluate('SAYI_#OPERATION_TYPE_ID#'))>
                <cfif get_operations.OPERATION_TYPE_ID eq get_defaults.DEFAULT_CUTTING_OPERATION_TYPE_ID>
                	<!---Satırın Kesim Zamanı Hesaplaması--->
                	<cfset 'cutting_time_#get_production_orders.IFLOW_P_ORDER_ID#' = Evaluate('SURE_#get_operations.OPERATION_TYPE_ID#_#get_production_orders.IFLOW_P_ORDER_ID#')/Evaluate('KATSAYI_#OPERATION_TYPE_ID#')/Evaluate('SAYI_#OPERATION_TYPE_ID#')>
				</cfif>
                <!---Her Operasyonun Son Değeri Bulunuyor--->
         	</cfif>
       		<cfif Evaluate('total_operation_time_#OPERATION_TYPE_ID#') gt Evaluate('biggest_time_operation_#get_production_orders.IFLOW_P_ORDER_ID#')>
            	<!---En Büyük Kümülatif Operasyon Türü Bulunuyor--->
             	<cfset 'biggest_time_operation_type_id_#get_production_orders.IFLOW_P_ORDER_ID#' = OPERATION_TYPE_ID> 
                <!---En Büyük Kümülatif Operasyon Süresi Bulunuyor --->
              	<cfset 'biggest_time_operation_#get_production_orders.IFLOW_P_ORDER_ID#' =  Evaluate('total_operation_time_#OPERATION_TYPE_ID#')>   
                <cfset biggest_time_operation = Evaluate('total_operation_time_#OPERATION_TYPE_ID#')>   
          	</cfif>
     	</cfloop>
        <cfif isdefined('biggest_time_operation_#get_production_orders.IFLOW_P_ORDER_ID#') and Evaluate('biggest_time_operation_#get_production_orders.IFLOW_P_ORDER_ID#') gt 0>
        	<!---Satırdaki En Büyük Kümüle Operasyon Süresi üzerinden  Toplam Çalışma Zamanı (Gün) Hesaplanıyor--->
        	<cfset 'working_days_#get_production_orders.IFLOW_P_ORDER_ID#' = Evaluate('biggest_time_operation_#get_production_orders.IFLOW_P_ORDER_ID#')/60/60/gunluk_caliasma_saat>
      	</cfif>
    </cfoutput>
    <cfloop query="get_operations">
    	<cfif Evaluate('total_operation_time_#OPERATION_TYPE_ID#') gt biggest_time_day> 
    		<cfset biggest_time_day_operation_type_id = OPERATION_TYPE_ID>
            <cfset biggest_time_day = Evaluate('total_operation_time_#OPERATION_TYPE_ID#')>
      	</cfif>
    </cfloop>
</cfif>
<cfform name="form_basket" method="post" action="">
	<input name="is_form_submitted" id="is_form_submitted" type="hidden" value="1">
    <input name="operation_time_key" id="operation_time_key" value="0" type="hidden">
    <cfinput name="master_plan_id" id="master_plan_id" type="hidden" value="#attributes.master_plan_id#">
   	<cf_basket_form id="gizli">
    	<cfoutput>
         	<table width="100%" height="30px" cellpadding="1" cellspacing="1" border="0" class="color-header">
             	<tr style="height:10px;background-color:white">
                	<td style="vertical-align:middle; width:120px; font-weight:bold" nowrap="nowrap">&nbsp;<cf_get_lang_main no='711.Planlama'> <cf_get_lang_main no='1239.Türü'></td>
                 	<td style="vertical-align:middle; font-weight:normal; width:140px" nowrap="nowrap">&nbsp;#get_plan_info.MASTER_PLAN_NAME#&nbsp;</td>
                 	<td style="vertical-align:middle; width:120px; font-weight:bold" nowrap="nowrap">&nbsp;<cf_get_lang_main no='215.Kayıt Tarihi'></td>
                 	<td style="vertical-align:middle; font-weight:normal; width:180px" nowrap="nowrap">&nbsp;
                    	<input type="text" name="planning_date" id="planning_date"  validate="eurodate" style="width:65px;" value="#dateformat(get_plan_info.MASTER_PLAN_PLANNING_DATE,'DD/MM/YYYY')#"> 
                     	<cf_wrk_date_image date_field="planning_date">
                  	</td>
                  	<td style="vertical-align:middle; width:100px; font-weight:bold" nowrap="nowrap">&nbsp;<cf_get_lang_main no='81.Aktif'>&nbsp;
                    	
                    </td>
               		<td style="vertical-align:middle; font-weight:normal; width:140px; text-align:center" nowrap="nowrap">
                    	<input type="checkbox" name="master_plan_status" value="1" <cfif get_plan_info.MASTER_PLAN_STATUS eq 1>checked="checked"</cfif> >	
                    </td>
                 	<td style="vertical-align:middle;" rowspan="3">&nbsp;</td>
                    
                    <td style="vertical-align:middle; width:55px" rowspan="3">
                   		<a style="cursor:pointer" onclick="production_operations();">
                       		<button type="button" name="operations_form" style="width:75px; font-size:10px; font-weight:bold;height:85px">
                            	<img src="/images/action.gif" alt="<cf_get_lang_main no='3378.Tüm'> <cf_get_lang_main no='2806.Operasyonlar'>" border="0"><br>
                                #getLang('prod',63)#
                            </button>
                     	</a>
                  	</td>
                    <td style="vertical-align:middle; width:55px" rowspan="3">
                   		<a style="cursor:pointer" onclick="production_plans();">
                       		<button type="button" name="production_form" style="width:55px; font-size:10px; font-weight:bold;height:85px">
                            	<img src="/images/action_plus.gif" alt="<cf_get_lang_main no='3378.Tüm'> <cf_get_lang_main no='116.Emirler'>" border="0"><br>
                                <cf_get_lang_main no='116.Emirler'>
                            </button>
                     	</a>
                  	</td>
               		<td style="vertical-align:middle; width:55px" rowspan="3">
                   		<a style="cursor:pointer" onclick="window.location.reload();">
                       		<button type="button" name="refresh_form" style="width:55px; font-size:10px; font-weight:bold;height:85px">
                            	<img src="/images/refresh.png" alt="<cf_get_lang_main no='1667.Yenile'>" border="0"><br>
                                <cf_get_lang_main no='1667.Yenile'>
                            </button>
                     	</a>
                  	</td>
                    <td style="vertical-align:middle; width:55px" rowspan="3">
                   		<a style="cursor:pointer" onclick="grupla(-3);">
                       		<button type="button" name="metarial_list" style="width:55px; font-size:10px; font-weight:bold;height:85px">
                            	<img src="/images/forklift.gif" alt="<cf_get_lang_main no='3246.Malzeme İhtiyacı'>" border="0"><br>
                                <cf_get_lang_main no='3247.Malzeme'>
                            </button>
                     	</a>
                  	</td>
                    <td style="vertical-align:middle; width:55px" rowspan="3">
                   		<a style="cursor:pointer" onclick="del_form();">
                       		<button type="button" name="delete_form" style="width:55px; font-size:10px; font-weight:bold;height:85px">
                            	<img src="/images/delete.gif" alt="<cf_get_lang_main no='51.Sil'>" border="0"><br>
                                <cf_get_lang_main no='51.Sil'>
                            </button>
                     	</a>
                  	</td>
                    <td style="vertical-align:middle; width:55px" rowspan="3">
                   		<a style="cursor:pointer" onclick="upd_form();">
                       		<button type="button" name="upd_form" style="width:55px; font-size:10px; font-weight:bold;height:85px">
                            	<img src="/images/enabled.gif" alt="<cf_get_lang_main no='52.Güncelle'>" border="0"><br>
                                <cf_get_lang_main no='52.Güncelle'>
                            </button>
                     	</a>
                  	</td>
                    <td style="vertical-align:middle; width:55px" rowspan="3">
                   		<a style="cursor:pointer" onclick="window.history.go(-1);">
                       		<button type="button" name="exit_form" style="width:55px; font-size:10px; font-weight:bold;height:85px">
                            	<img src="/images/exit.gif" alt="<cf_get_lang_main no='50.Vazgeç'>" border="0"><br>
                                <cf_get_lang_main no='50.Vazgeç'>
                            </button>
                     	</a>
                  	</td>
                    <td style="vertical-align:middle; width:55px" rowspan="3">
                   		<a style="cursor:pointer" onclick="grupla(-4);">
                       		<button type="button" name="trasferring" style="width:55px; font-size:10px; font-weight:bold;height:85px">
                            	<img src="/images/transfer.gif" alt="#getLang('pos',12)#" border="0"><br>#getLang('pos',12)#
                            </button>
                     	</a>
                  	</td>
                    <td style="vertical-align:middle; width:55px" rowspan="3">
                   		<a style="cursor:pointer" onclick="grupla(-2);">
                       		<button type="button" name="print_form" style="width:55px; font-size:10px; font-weight:bold;height:85px">
                            	<img src="/images/print_plus.gif" alt="<cf_get_lang_main no='62.Yazdır'>" border="0"><br>
                                <cf_get_lang_main no='62.Yazdır'>
                            </button>
                     	</a>
                  	</td>
                    
                </tr>
              	<tr style="height:10px;background-color:white">
                	<td style="vertical-align:middle; font-weight:bold" nowrap="nowrap">&nbsp;<cf_get_lang_main no='468.Belge No'></td>
                 	<td style="vertical-align:middle; font-weight:normal;" nowrap="nowrap">&nbsp;#get_plan_info.MASTER_PLAN_NUMBER#&nbsp;</td>
                 	<td style="vertical-align:middle; font-weight:bold" nowrap="nowrap">&nbsp;<cf_get_lang_main no='641.Başlangıç Tarihi'></td>
                	<td style="vertical-align:middle; font-weight:normal;" nowrap="nowrap">&nbsp;
                    	<input type="text" name="start_date" id="start_date"  validate="eurodate" style="width:65px;" value="#dateformat(attributes.start_date,'DD/MM/YYYY')#"> 
                     	<cf_wrk_date_image date_field="start_date">
                     	<select name="start_h" id="start_h">
                         	<cfloop from="0" to="23" index="i">
                             	<option value="#i#" 
									<cfif isdefined('attributes.start_date') and timeformat(attributes.start_date,'HH') eq i> selected</cfif>><cfif i lt 10>0</cfif>#i#
                              	</option>
                         	</cfloop>
                     	</select>
                    	<select name="start_m" id="start_m">
                          	<cfloop from="0" to="59" index="i">
                             	<option value="#i#" 
									<cfif isdefined('attributes.start_date') and timeformat(attributes.start_date,'MM') eq i> selected</cfif>><cfif i lt 10>0</cfif>#i#
                              	</option>
                         	</cfloop>
                    	</select>
                    </td>
                  	
                 	<td style="vertical-align:middle; font-weight:bold" nowrap="nowrap">&nbsp;<cf_get_lang_main no='642.Süreç/Asama'></td>
                  	<td style="vertical-align:middle; font-weight:normal" nowrap="nowrap">&nbsp;
                    	<cf_workcube_process is_upd='0' select_value='#get_plan_info.MASTER_PLAN_STAGE#' process_cat_width='128' is_detail='1'>&nbsp;
                    </td>
           		</tr>
               	<tr style="height:10px;background-color:white">
                	<td style="vertical-align:middle; font-weight:bold" nowrap="nowrap">&nbsp;<cf_get_lang_main no='487.Kaydeden'></td>
                  	<td style="vertical-align:middle; font-weight:normal;" nowrap="nowrap">&nbsp;#get_emp_info(get_plan_info.EMPLOYYEE_ID,0,0)#&nbsp;</td>
                 	<td style="vertical-align:middle; font-weight:bold" nowrap="nowrap">&nbsp;<cf_get_lang_main no='288.Bitiş Tarihi'></td>
                  	<td style="vertical-align:middle;font-weight:normal;" nowrap="nowrap">&nbsp;
                    	<input type="text" name="finish_date" id="finish_date"  validate="eurodate" style="width:65px;" value="#dateformat(attributes.finish_date,'DD/MM/YYYY')#"> 
                       	<cf_wrk_date_image date_field="finish_date">
                      	<select name="finish_h" id="finish_h">
                          	<cfloop from="0" to="23" index="i">
                              	<option value="#i#" 
									<cfif isdefined('attributes.finish_date') and timeformat(attributes.finish_date,'HH') eq i> selected</cfif>><cfif i lt 10>0</cfif>#i#
                              	</option>
                          	</cfloop>
                       	</select>
                      	<select name="finish_m" id="finish_m">
                         	<cfloop from="0" to="59" index="i">
                            	<option value="#i#" 
									<cfif isdefined('attributes.finish_date') and timeformat(attributes.finish_date,'MM') eq i> selected</cfif>><cfif i lt 10>0</cfif>#i#
                            	</option>
                         	</cfloop>
                     	</select>
                    </td>
                  	
                 	<td style="vertical-align:middle; font-weight:bold" nowrap="nowrap">&nbsp;<cf_get_lang_main no='217.Açiklama'></td>
                 	<td style="vertical-align:middle; text-align:right; font-size:11px" nowrap="nowrap">&nbsp;
                    	<cfinput name="detail" type="text" value="#get_plan_info.MASTER_PLAN_DETAIL#" style="width:130px" maxlength="500">&nbsp;
                    </td>
             	</tr>
           	</table>
    	</cfoutput>
	</cf_basket_form>     
 
    <cf_basket id="report_bask">
        <table class="detail_basket_list">
            <thead>
                <tr valign="middle">
                	<cfoutput>
                    <th colspan="13" rowspan="4" class="color-list">
                        <table width="100%" height="100%" cellpadding="0" cellspacing="0" border="0">
                        	<tr class="color-list">
                                <td style="vertical-align:middle; text-align:center; height:15px;width:96px;font-weight:bold" nowrap="nowrap"><cfoutput>#getLang('report',753)#</cfoutput></td>
                                <td style="vertical-align:middle; text-align:center; width:96px;font-weight:bold" nowrap="nowrap"><cf_get_lang_main no='1457.Planlanan'></td>
                                <td style="vertical-align:middle; text-align:center; width:96px;font-weight:bold" nowrap="nowrap"><cf_get_lang_main no='1622.Toplam'> <cf_get_lang_main no='2944.Modül'></td>
                                <td style="vertical-align:middle; text-align:center; width:96px;font-weight:bold" nowrap="nowrap"><cf_get_lang_main no='3105.Biten'> <cf_get_lang_main no='2944.Modül'></td>
                                <td style="vertical-align:middle; text-align:center; width:116px;font-weight:bold" nowrap="nowrap"><cf_get_lang_main no='1622.Toplam'> <cf_get_lang_main no='2903.Paket'></td>
                                <td style="vertical-align:middle; text-align:center; width:96px;font-weight:bold" nowrap="nowrap"><cf_get_lang_main no='3105.Biten'> <cf_get_lang_main no='2903.Paket'></td>
                                <td style="vertical-align:middle; text-align:center; width:100px;font-weight:bold" nowrap="nowrap"><cf_get_lang_main no='1919.Ara'> <cf_get_lang_main no='40.Stok'> (<cf_get_lang_main no='78.Gün'>)</td>
                            </tr>
                            <tr class="color-list">
                                <td style="vertical-align:middle; color:navy; font-size:26px;font-weight:bold; text-align:center; height:50px;" nowrap="nowrap">#TlFormat(DateDiff('d',get_plan_info.MASTER_PLAN_start_DATE,get_plan_info.MASTER_PLAN_finish_DATE)+1,1)#</td>
                                <td style="vertical-align:middle; color:navy; font-size:26px;font-weight:bold; text-align:center;" nowrap="nowrap">#TlFormat(biggest_time_day/60/60/gunluk_caliasma_saat,1)#</td>
                                <td style="vertical-align:middle; color:navy; font-size:26px;font-weight:bold; text-align:center;" nowrap="nowrap">#TlFormat(Total_Main,0)#</td>
                                <td style="vertical-align:middle; color:navy; font-size:26px;font-weight:bold; text-align:center;" nowrap="nowrap">#TlFormat(get_plan_info.MODUL_AMOUNT,0)#</td>
                                <td style="vertical-align:middle; color:navy; font-size:26px;font-weight:bold; text-align:center;" nowrap="nowrap">#TlFormat(Total_Package,0)#</td>
                                <td style="vertical-align:middle; color:navy; font-size:26px;font-weight:bold; text-align:center;" nowrap="nowrap">#TlFormat(get_plan_info.PACKAGE_RESULT_AMOUNT,0)#</td>
                                <td style="vertical-align:middle; color:navy; font-size:26px;font-weight:bold; text-align:center;" nowrap="nowrap">
                                	<cfinput type="text" name="ara_stok" id="ara_stok" value="#ara_stok#" style="text-align:center;width:85px;font-size:26px;color:navy; font-weight:bold" class="box">
                                </td>
                            </tr>
                        </table>
                    </th>
                    </cfoutput>
                    <cfif get_operations.recordcount>
                        <th style="height:15px;text-align:left; vertical-align:middle;background-color:DarkGray; color:black;">
                            OEE
                        </th>

                        <cfoutput query="get_operations">
                            
                           	<cfif isdefined('KATSAYI_#OPERATION_TYPE_ID#')>
                            	
                               		<th style="width:35px; text-align:center; vertical-align:middle;background-color:DarkGray; color:black;" title="#OPERATION_type#">
                                    	<a style="cursor:pointer" onclick="upd_operation(#OPERATION_TYPE_ID#);">
                                        <button type="button" name="upd_operation_#OPERATION_TYPE_ID#" style="width:100%;background-color:DarkGray; font-size:10px;height:100%; font-weight:bold">
                                            #Tlformat(Evaluate('KATSAYI_#OPERATION_TYPE_ID#')*100,0)#
                                        </button>
                                    </a>
                              		</th>
                                
                          	</cfif>
                            
                        </cfoutput>
                    </cfif>
                </tr>
                <tr valign="middle">
                    <cfif get_operations.recordcount>
                        <th style="height:15px;width:35px; text-align:left; vertical-align:middle;background-color:Silver; color:black;">
                            <cf_get_lang_main no='3379.Doluluk'>
                        </th>
                        <cfoutput query="get_operations">
                            <th style="width:35px; text-align:center; vertical-align:middle;
                            <cfif isdefined('total_operation_time_#OPERATION_TYPE_ID#') and (Evaluate('total_operation_time_#OPERATION_TYPE_ID#')/60)/(biggest_time_operation/60)*100 eq 100>
                            	background-image: url(/images/3.png);color:white;
                            <cfelse>
                            	background-color:Silver;color:black;
                            </cfif> 
                             font-weight:normal" title="#OPERATION_type#">
                                <cfif isdefined('total_operation_time_#OPERATION_TYPE_ID#') and len(Evaluate('total_operation_time_#OPERATION_TYPE_ID#')) and biggest_time_operation gt 0>
                                	#TlFormat((Evaluate('total_operation_time_#OPERATION_TYPE_ID#')/60)/(biggest_time_operation/60)*100,0)#
                                <cfelse>
                                	-
                                </cfif>
                            </th>
                        </cfoutput>
                    </cfif>
                </tr>
                <tr valign="middle">
                    <cfif get_operations.recordcount>
                        <th style="height:15px; text-align:left; vertical-align:middle;background-color:LightGray; color:black;">
                            <cf_get_lang_main no='3380.Makina'>
                        </th>
                        <cfoutput query="get_operations">
                            <th style="height:15px; text-align:center; vertical-align:middle;
                            <cfif isdefined('total_operation_time_#OPERATION_TYPE_ID#') and (Evaluate('total_operation_time_#OPERATION_TYPE_ID#')/60)/(biggest_time_operation/60)*100 gt 50>
                            	background-image: url(/images/2.png);color:white;
                            <cfelse>
                            	background-color:LightGray;color:black;
                            </cfif>
                            font-weight:normal" title="#OPERATION_type#">
                                <cfif isdefined('SAYI_#OPERATION_TYPE_ID#')>
                                    #Evaluate('SAYI_#OPERATION_TYPE_ID#')#
                                </cfif>
                            </th>
                        </cfoutput>
                    </cfif>
                </tr>
                <tr valign="middle">
                    <cfif get_operations.recordcount>
                        <th style="height:15px; text-align:left; vertical-align:middle;background-color:Gainsboro; color:black;" nowrap>
                            <cf_get_lang_main no='1044.Oran'>
                        </th>
                        <cfoutput query="get_operations">
                            <th style="height:15px; text-align:center; vertical-align:middle;
                            <cfif isdefined('total_operation_time_#OPERATION_TYPE_ID#') and (Evaluate('total_operation_time_#OPERATION_TYPE_ID#')/60)/(biggest_time_operation/60)*100 gt 0>
                            	background-image: url(/images/1.png);color:white;
                            <cfelse>
                            	background-color:Gainsboro;color:black;
                            </cfif>
                            font-weight:normal" title="#OPERATION_type#">
                          		<cfif isdefined('total_operation_time_#OPERATION_TYPE_ID#') and len(Evaluate('total_operation_time_#OPERATION_TYPE_ID#')) and gunluk_caliasma_saat gt 0>
                            	 	#TlFormat(Evaluate('total_operation_time_#OPERATION_TYPE_ID#')/60/60/gunluk_caliasma_saat,1)#
                          		<cfelse>
                                	-
                          		</cfif>
                            </th>
                        </cfoutput>
                    </cfif>
                </tr>
                <tr valign="middle">
                    <!-- sil -->
                    <th style="width:1%;"></th>
                    <th style="width:20px; text-align:center; vertical-align:middle">
                    	<input type="checkbox" alt="<cf_get_lang no ='546.Hepsini Seç'>" onClick="grupla(-1);">
                    </th>
                    <th style="width:20px; text-align:center; vertical-align:middle" class="header_icn_none" rowspan="1">
                    	<a href="javascript://" onclick="windowopen('<cfoutput>#request.self#?fuseaction=prod.popup_add_ezgi_iflow_production_order&master_plan_id=#attributes.master_plan_id#</cfoutput>','longpage');">
                    		<img src="/images/plus_list.gif" title="<cf_get_lang_main no='170.Ekle'>">
                      	</a>
                  	</th>
                    <!-- sil -->
                    <th style="width:25px; text-align:center; vertical-align:middle" rowspan="1"><cf_get_lang_main no='1165.Sıra'></th>
                    <th style="width:40px; text-align:center; vertical-align:middle" rowspan="1"><cf_get_lang_main no='3273.Parti'></th>
                    <th style="width:50px; text-align:center; vertical-align:middle" rowspan="1"><cf_get_lang_main no='245.Ürün'><br /> <cf_get_lang_main no='3019.Tipi'></th>
                    <th style="width:150px; text-align:center; vertical-align:middle" rowspan="1"><cf_get_lang_main no='245.Ürün'></th>
                    <th style="width:50px; text-align:center; vertical-align:middle" rowspan="1"><cf_get_lang_main no='223.Miktar'></th>
                    <th style="width:40px; text-align:center; vertical-align:middle" rowspan="1"><cf_get_lang_main no='3105.Biten'></th>
                    <th style="width:85px; text-align:center; vertical-align:middle" rowspan="1"><cf_get_lang_main no='3274.Kesim'><br /><cf_get_lang_main no='90.Bitiş'></th>
                    <th style="width:85px; text-align:center; vertical-align:middle" rowspan="1"><cf_get_lang_main no='1351.Depo'><br /><cf_get_lang_main no='3297.Teslim'></th>
                    <th style="text-align:center; vertical-align:middle" rowspan="1"><cf_get_lang_main no='217.Açıklama'></th>
                    <th style="width:50px; text-align:center; vertical-align:middle" rowspan="1"><cf_get_lang_main no='80.Toplam'><br /><cf_get_lang_main no='2903.Paket'></th>
                    <th style="height:15px; text-align:center; vertical-align:middle;">
                        <cf_get_lang_main no='78.Gün'>
                    </th>
                    <cfif get_operations.recordcount>
                        <cfoutput query="get_operations">
                            <th style="height:25px; width:50px; text-align:center; vertical-align:middle;" title="#OPERATION_type#">#OPERATION_CODE#</th>
                        </cfoutput>
                    </cfif>
                </tr>
            </thead>
            <tbody>
            	<cfset delete_control = 1>
                <cfif get_production_orders.recordcount>
                    <cfset total_row = get_production_orders.recordcount + 1>
                    <cfoutput query="get_production_orders">
                        <tr>
                            <!-- sil --> 
                            <td align="center" id="order_row#currentrow#" class="color-row" onclick="gizle_goster(product_order_detail#currentrow#);connectAjax('#currentrow#','#PRODUCT_TYPE#','#STOCK_ID#','#quantity#','#IFLOW_P_ORDER_ID#','0');gizle_goster_nested('siparis_goster#currentrow#','siparis_gizle#currentrow#');">
                            	<img id="siparis_goster#currentrow#" style="cursor:pointer;" src="/images/listele.gif" title="<cf_get_lang_main no ='1184.Göster'>">
                             	<img id="siparis_gizle#currentrow#" style="cursor:pointer;display:none;" src="/images/listele_down.gif" title="<cf_get_lang_main no ='1216.Gizle'>">
                        	</td>
                            <td style="text-align:center;">
                            	<input type="checkbox" name="select_production" value="#IFLOW_P_ORDER_ID#">
                            </td>
                            <td style="text-align:center;">
                                <cfif IS_STAGE eq 4>
                                	<img src="/images/blue_glob.gif" title="<cf_get_lang_main no='1515.Sanal'> <cf_get_lang_main no='2252.Üretim Emri'>">
                            	<cfelseif IS_STAGE eq 0>
                                 	<img src="/images/yellow_glob.gif" title="<cf_get_lang_main no='3279.Başlamadı'>">
                             	<cfelseif IS_STAGE eq 1>
                                  	<img src="/images/green_glob.gif" title="<cf_get_lang_main no='3201.Başladı'>">
                                    <cfset delete_control = 0>
                              	<cfelseif IS_STAGE eq 2>
                               		<img src="/images/red_glob.gif" title="<cf_get_lang_main no='3108.Bitti'>">
                                    <cfset delete_control = 0>
                            	<cfelseif IS_STAGE eq 3>
                                	<img src="/images/grey_glob.gif" title="<cf_get_lang_main no='3101.Arıza'>">
                                    <cfset delete_control = 0>
                             	</cfif>
                            </td>
                            <!-- sil -->
                            <td style="text-align:center;"><!---#CURRENTROW#--->
                                <select name="sira_#currentrow#_#IFLOW_P_ORDER_ID#" id="sira_#currentrow#_#IFLOW_P_ORDER_ID#" style="width:40px;" onChange="control_form(-2,#IFLOW_P_ORDER_ID#)">
                                    <cfloop from="1" to="#total_row#" index="i">
                                        <option value="#i#" <cfif i eq currentrow> selected</cfif>>#I#</option>
                                    </cfloop>
                                </select>
                            </td>
                            <td style="text-align:center;">
                            	<a href="javascript://" onclick="windowopen('#request.self#?fuseaction=prod.popup_upd_ezgi_iflow_production_order&rel_p_order_id=#rel_p_order_id#&master_plan_id=#attributes.master_plan_id#','longpage');" class="tableyazi">
                            		#P_ORDER_PARTI_NUMBER#
                              	</a>
                          	</td>
                            <td style="text-align:center;">
                                <cfif PRODUCT_TYPE eq 1><cf_get_lang_main no='1099.Takım'>
                                <cfelseif PRODUCT_TYPE eq 2><cf_get_lang_main no='2944.Modül'>
                                <cfelseif PRODUCT_TYPE eq 3><cf_get_lang_main no='2903.Paket'>
                                <cfelseif PRODUCT_TYPE eq 4><cf_get_lang_main no='2848.Parça'>
                                <cfelse><cf_get_lang_main no='3207.Hammadde'>
                                </cfif>
                            </td>
                            <td style="text-align:left;" nowrap="nowrap">#Left(PRODUCT_NAME,40)#<cfif len(PRODUCT_NAME) gt 40>...</cfif></td>
                            <td style="text-align:center;">#AmountFormat(QUANTITY,0)#</td>
                            <td style="text-align:right;">#AmountFormat(0,2)#</td>
                            <td style="text-align:center;" nowrap>#DateFormat(CUTTING_FINISH_DATE, 'DD/MM/YYYY')# (#TimeFormat(CUTTING_FINISH_DATE, 'HH:MM')#)</td>
                            <td style="text-align:center;" nowrap>#DateFormat(FINISH_DATE, 'DD/MM/YYYY')# (#TimeFormat(FINISH_DATE, 'HH:MM')#)</td>
                            <td nowrap title="#DETAIL#">#Left(DETAIL,8)#<cfif len(detail) gt 8>...</cfif></td>
                            <td style="text-align:center;">#AmountFormat(PAKET_SAYI,0)#</td>
                            <td style="text-align:center; font-weight:bold">#AmountFormat(TOTAL_PRODUCTION_TIME,1)#</td>
                            <cfloop query="get_operations">
                            	<td style="text-align:center;<cfif isdefined('biggest_time_operation_type_id_#get_production_orders.IFLOW_P_ORDER_ID#')><cfif Evaluate('biggest_time_operation_type_id_#get_production_orders.IFLOW_P_ORDER_ID#') eq OPERATION_TYPE_ID>background-color:red;color:white</cfif><cfelse>background-color:black;color:white</cfif>" title="#OPERATION_type#">
                                 	<cfif isdefined('total_operation_time_#OPERATION_TYPE_ID#_#get_production_orders.IFLOW_P_ORDER_ID#')>
                                     	#TlFormat(Evaluate('total_operation_time_#OPERATION_TYPE_ID#_#get_production_orders.IFLOW_P_ORDER_ID#')/60,0)#
                                 	<cfelse>
                                       	- 
                                 	</cfif>
                           		</td>
                           </cfloop> 
                        </tr>
                        <tr id="product_order_detail#currentrow#" class="nohover" style="display:none" >
                            <td colspan="#son_col#">
                                <div align="left" id="DISPLAY_PRODUCT_ORDER_INFO#currentrow#" style="border:none;"></div>
                            </td>
                        </tr>
                    </cfoutput>
                    <!---<cf_basket_form id="dip">
                        <table width="100%" height="30px" cellpadding="1" cellspacing="1" border="0" class="color-header">
                            <tr style="height:10px;background-color:white">
                                <td height="30" style="text-align:right">

                                </td>
                            </tr>
                      	</table>
                  	</cf_basket_form>--->  	
                <cfelse>
                    <tr> 
                        <td colspan="50" height="20"><cf_get_lang_main no='72.Kayıt Yok'>!</td>
                    </tr>
                </cfif>
            </tbody>
        </table>
    </cf_basket>
</cfform> 
<script type="text/javascript">
	function connectAjax(crtrow,product_type,stock_id,order_amount,IFLOW_P_ORDER_ID,operation_type_id)
	{
		var bb = '<cfoutput>#request.self#?fuseaction=prod.emptypopup_ezgi_iflow_ajax_product_order_info&department_id=#attributes.department_id#&son_col=#son_col#&master_plan_id=#attributes.master_plan_id#</cfoutput>&product_type='+product_type+'&sid='+ stock_id+'&amount='+order_amount+'&IFLOW_P_ORDER_ID='+IFLOW_P_ORDER_ID+'&operation_type_id='+operation_type_id;
		AjaxPageLoad(bb,'DISPLAY_PRODUCT_ORDER_INFO'+crtrow,1);
	}
	function hesapla()
	{
		windowopen('<cfoutput>#request.self#?fuseaction=prod.emptypopup_upd_ezgi_iflow_master_plan_operation&master_plan_id=#attributes.master_plan_id#</cfoutput>','small');	
	}
	function grupla(type)
	{
		var master_plan_id=document.form_basket.master_plan_id.value;
		iflow_p_order_id_list = '';
		chck_leng = document.getElementsByName('select_production').length;
		for(ci=0;ci<chck_leng;ci++)
		{
			var my_objets = document.all.select_production[ci];
			if(chck_leng == 1)
				var my_objets =document.all.select_production;
			if(type == -1){//hepsini seç denilmişse	
				if(my_objets.checked == true)
					my_objets.checked = false;
				else
					my_objets.checked = true;
			}
			else
			{
				if(my_objets.checked == true)
					iflow_p_order_id_list +=my_objets.value+',';
			}
		}
		iflow_p_order_id_list = iflow_p_order_id_list.substr(0,iflow_p_order_id_list.length-1);//sondaki virgülden kurtarıyoruz.
		if(type < -1)
		{
			if(list_len(iflow_p_order_id_list,','))
			{
				if(type == -2)
				windowopen('<cfoutput>#request.self#?fuseaction=objects.popup_print_files&print_type=289</cfoutput>&iid='+iflow_p_order_id_list+'&master_plan_id='+master_plan_id,'page');
				if(type == -3)
				windowopen('<cfoutput>#request.self#?fuseaction=prod.popup_dsp_ezgi_iflow_product_metarial_need</cfoutput>&iid='+iflow_p_order_id_list+'&master_plan_id='+master_plan_id,'longpage');
				if(type == -4)
				windowopen('<cfoutput>#request.self#?fuseaction=prod.popup_list_ezgi_iflow_transferring</cfoutput>&iid='+iflow_p_order_id_list+'&master_plan_id='+master_plan_id,'small');
			}
			else
			alert("<cf_get_lang_main no='3381.İşlem Yapmak İstediğiniz Üretim Emirlerini Seçiniz'>!")
		}
	}
	function upd_form()
	{
		if (form_basket.start_date.value.length == 0)
		{
			alert("<cf_get_lang_main no='3334.Plan Başlama Tarihi Girmelisiniz'> !");
			return false;
		}
		if (form_basket.finish_date.value.length == 0)
		{
			alert("<cf_get_lang_main no='3335.Plan Bitiş Tarihi Girmelisiniz'> !");
			return false;
		}
		if(process_cat_control())
		{
			sor=confirm("<cf_get_lang_main no='3382.Bilgileri Güncelliyorum. Emin misiniz'>?");
			if (sor == true)
			{
				document.getElementById("form_basket").action = "<cfoutput>#request.self#</cfoutput>?fuseaction=prod.emptypopup_upd_ezgi_iflow_master_plan";
				document.getElementById("form_basket").submit();
			}
			else
				return false;
		}
		else
			return false;
	}
	function del_form()
	{
		<cfif delete_control eq 1>
			if(process_cat_control())
			{
				sor=confirm("<cf_get_lang_main no='3383.Üretim Planı ve Tüm Emirler Tamamen Silinecektir. Emin misiniz'>?");
				if (sor == true)
				{
					window.location ="<cfoutput>#request.self#?fuseaction=prod.emptypopup_del_ezgi_iflow_master_plan&master_plan_id=#attributes.master_plan_id#</cfoutput>";
				}
				else
					return false;
			}
			else
				return false;
		<cfelse>
			alert("<cf_get_lang_main no='3384.Plana Ait Ürünlerin Üretimi Başladığından Toplu Silme Yapamazsınız'> !");
			return false;
		</cfif>
	}
	function upd_operation(operation_type_id)
	{
		windowopen('<cfoutput>#request.self#?fuseaction=prod.popup_upd_ezgi_iflow_operation_rate&master_plan_id=#attributes.master_plan_id#</cfoutput>&operation_type_id='+operation_type_id,'small');
	}
	function production_plans()
	{
		windowopen('<cfoutput>#request.self#?fuseaction=prod.popup_list_ezgi_iflow_production_order&is_form_submitted=1&master_plan_id=#attributes.master_plan_id#</cfoutput>','longpage');	
	}
	function production_operations()
	{
		windowopen('<cfoutput>#request.self#?fuseaction=prod.popup_list_ezgi_iflow_production_operations&is_form_submitted=1&master_plan_id=#attributes.master_plan_id#</cfoutput>','longpage');	
	}
</script>