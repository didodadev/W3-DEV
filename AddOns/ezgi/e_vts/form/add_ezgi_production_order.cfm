<cfif not isnumeric(attributes.upd)>
	<cfset hata  = 10>
	<cfinclude template="../../../dsp_hata.cfm">
</cfif>
<cfparam name="attributes.employee" default="">
<cfparam name="attributes.asset" default="">
<cfparam name="attributes.serial_no" default="">
<cfparam name="attributes.operation_gurup_id" default="">
<!---Özelleştirilmiş Paketlerin İsmini Değiştirme--->
<cfquery name="get_defaults" datasource="#dsn3#">
	SELECT  PROTOTIP_PACKAGE_ID, PROTOTIP_PIECE_1_ID, PROTOTIP_PIECE_2_ID, PROTOTIP_PIECE_3_ID FROM EZGI_DESIGN_DEFAULTS
</cfquery>
<cfif len(get_defaults.PROTOTIP_PACKAGE_ID)>
	<cfquery name="get_prototip_package_ids" datasource="#dsn3#">
    	SELECT 
        	PACKAGE_RELATED_ID AS STOCK_ID
		FROM            
      		EZGI_DESIGN_PACKAGE_ROW
		WHERE        
        	DESIGN_MAIN_ROW_ID = #get_defaults.PROTOTIP_PACKAGE_ID#
    </cfquery>
    <cfset default_prototip_package_stock_ids = ValueList(get_prototip_package_ids.STOCK_ID)>
</cfif>
<!---Özelleştirilmiş Paketlerin İsmini Değiştirme--->
<cfquery name="get_timing_type" datasource="#dsn3#">
	SELECT        
    	TIMING_TYPE
	FROM            
    	EZGI_MASTER_PLAN_SABLON AS EMAS
	WHERE        
    	SHIFT_ID =
            	(
                	SELECT        
                    	TOP (1) EMAS.SHIFT_ID
              		FROM            
                  		EZGI_MASTER_ALT_PLAN AS EMAP1 INNER JOIN
                     	EZGI_MASTER_PLAN_RELATIONS AS EMPR ON EMAP1.MASTER_ALT_PLAN_ID = EMPR.MASTER_ALT_PLAN_ID INNER JOIN
                 		PRODUCTION_ORDERS AS PO ON EMPR.P_ORDER_ID = PO.P_ORDER_ID INNER JOIN
                   		EZGI_MASTER_PLAN_SABLON AS EMAS ON EMAP1.PROCESS_ID = EMAS.PROCESS_ID
              		WHERE        
                		PO.P_ORDER_ID = #upd#
            	) AND 
   		STATUS_ID = 0
</cfquery>
<cfquery name="get_order" datasource="#dsn3#">
	SELECT     	
    	PO.P_ORDER_ID, 
     	PO.OPERATION_TYPE_ID, 
    	PO.AMOUNT, 
      	PO.STAGE,
      	ISNULL((	
              	SELECT     	
                	SUM(REAL_AMOUNT) AS REAL_AMOUNT
				FROM       	
                 	PRODUCTION_OPERATION_RESULT
				WHERE     	
                 	OPERATION_ID = PO.P_OPERATION_ID
        		),0) REAL_AMOUNT,
    	ISNULL((	
        		SELECT     	
                	SUM(LOSS_AMOUNT) AS LOSS_AMOUNT
				FROM       	
                	PRODUCTION_OPERATION_RESULT
				WHERE     	
                	OPERATION_ID = PO.P_OPERATION_ID
         		),0) LOSS_AMOUNT,
       	ISNULL((	
        		SELECT     	
                	SUM(REAL_TIME) AS REAL_TIME
				FROM       	
                	PRODUCTION_OPERATION_RESULT
				WHERE     	
                	OPERATION_ID = PO.P_OPERATION_ID
       			),0) REAL_TIME,
     	PRO.STOCK_ID,
     	PRO.STATION_ID, 
    	PRO.START_DATE, 
      	PRO.FINISH_DATE, 
      	PRO.QUANTITY, 
       	PRO.STATUS, 
      	PRO.P_ORDER_NO, 
     	PRO.PO_RELATED_ID, 
      	PRO.SPECT_VAR_ID, 
      	PRO.PROD_ORDER_STAGE, 
      	PRO.IS_DEMONTAJ, 
      	PRO.DEMAND_NO, 
       	PRO.LOT_NO, 
       	PRO.SPEC_MAIN_ID, 
      	PRO.IS_GROUP_LOT, 
      	PRO.IS_STAGE, 
      	PRO.DETAIL, 
      	PRO.SPECT_VAR_NAME, 
      	PRO.PROJECT_ID,
       	PRO.REFERENCE_NO,
     	PRO.RECORD_DATE,
      	S.PRODUCT_ID, 
      	S.PROPERTY, 
      	S.PRODUCT_NAME, 
      	S.STOCK_CODE, 
      	S.PRODUCT_CATID, 
      	PU.MAIN_UNIT, 
       	O.OPERATION_TYPE, 
    	O.OPERATION_CODE,
   		PO.P_OPERATION_ID,
      	ISNULL((
        		SELECT
					SUM(POR_.AMOUNT) ORDER_AMOUNT
				FROM
					PRODUCTION_ORDER_RESULTS_ROW POR_,
					PRODUCTION_ORDER_RESULTS POO
				WHERE
					POR_.PR_ORDER_ID = POO.PR_ORDER_ID
					AND POO.P_ORDER_ID = PO.P_ORDER_ID
					AND POR_.TYPE = 1
					AND POO.IS_STOCK_FIS = 1
				),0) ROW_RESULT_AMOUNT
	FROM       	
    	PRODUCTION_OPERATION AS PO INNER JOIN
     	PRODUCTION_ORDERS AS PRO ON PO.P_ORDER_ID = PRO.P_ORDER_ID INNER JOIN
     	STOCKS AS S ON PRO.STOCK_ID = S.STOCK_ID INNER JOIN
    	OPERATION_TYPES AS O ON PO.OPERATION_TYPE_ID = O.OPERATION_TYPE_ID LEFT OUTER JOIN
    	PRODUCT_UNIT AS PU ON S.PRODUCT_ID = PU.PRODUCT_ID
	WHERE     	
    	PO.P_OPERATION_ID = #p_operation_id#  AND 
        PU.IS_MAIN = 1
</cfquery>
<cfquery name="get_lot_no" datasource="#dsn3#">
	SELECT        
    	POS.STOCK_ID, 
        POS.AMOUNT, 
        POS.PRODUCT_UNIT_ID, 
        POS.LOT_NO, 
        S.PRODUCT_NAME, 
        S.PRODUCT_CODE, 
        S.IS_ZERO_STOCK, 
        ISNULL(S.IS_LOT_NO, 0) AS IS_LOT_NO, 
        ISNULL(S.IS_LIMITED_STOCK, 0) AS LIMITED_STOCK, 
        PU.MAIN_UNIT
	FROM           
    	PRODUCTION_ORDERS_STOCKS AS POS INNER JOIN
      	STOCKS AS S ON POS.STOCK_ID = S.STOCK_ID INNER JOIN
   		PRODUCT_UNIT AS PU ON POS.PRODUCT_UNIT_ID = PU.PRODUCT_UNIT_ID
	WHERE        
    	POS.P_ORDER_ID = #upd# AND 
        POS.TYPE = 2 AND 
        ISNULL(S.IS_LOT_NO, 0) = 1
</cfquery>
<cfquery name="get_order_result" datasource="#dsn3#">
	SELECT     	
    	OPERATION_RESULT_ID, 
    	ACTION_START_DATE
	FROM        
    	PRODUCTION_OPERATION_RESULT
	WHERE     	
    	(ACTION_EMPLOYEE_ID = #employee_id#) AND 
    	(STATION_ID = #station_id#) AND 
        (OPERATION_ID = #p_operation_id#) AND 
        (REAL_AMOUNT = 0) AND 
        (LOSS_AMOUNT = 0)
</cfquery>
<cfif get_order_result.recordcount>
	<cfset result_id = get_order_result.OPERATION_RESULT_ID>
	<cfset time_start = get_order_result.ACTION_START_DATE>
<cfelse>
	<cfset result_id = ''>
	<cfset time_start = now()>
</cfif>
<cfquery name="get_prod_pause" datasource="#dsn3#">
	SELECT     
    	PROD_PAUSE_TYPE_ID
	FROM         
    	SETUP_PROD_PAUSE
	WHERE     
    	P_ORDER_ID = #upd# AND 
        STATION_ID = #station_id# AND 
        EMPLOYEE_ID = #employee_id# AND 
        OPERATION_ID = #p_operation_id# AND 
        PROD_DURATION IS NULL
</cfquery>
<cfif get_prod_pause.recordcount>
	<cfquery name="get_prod_pause_cat" datasource="#dsn3#">
    	SELECT     
        	PROD_PAUSE_CAT_ID
		FROM         
        	SETUP_PROD_PAUSE_TYPE
		WHERE     
        	PROD_PAUSE_TYPE_ID = #get_prod_pause.PROD_PAUSE_TYPE_ID#
    </cfquery>
    <cfif get_prod_pause_cat.recordcount>
    	<cfset pause_cat = get_prod_pause_cat.PROD_PAUSE_CAT_ID>
    <cfelse>
    	<cfset pause_cat = 0>
    </cfif>
<cfelse>
	<cfset pause_cat = 0>
</cfif>
<cfparam name="attributes.keyword" default="get_order.AMOUNT">
<cfset deliver_get = get_emp_info(employee_id,0,0)>
<cfif not get_order.RECORDCOUNT>
	<cfset hata  = 10>
	<cfinclude template="../../../dsp_hata.cfm">
<cfelse>
	<cfquery name="get_prod_pause_type" datasource="#dsn3#">
		SELECT DISTINCT
			SPPT.PROD_PAUSE_TYPE_ID,
			SPPT.PROD_PAUSE_TYPE
		FROM
			SETUP_PROD_PAUSE_TYPE SPPT,
			SETUP_PROD_PAUSE_TYPE_ROW SPPTR
		WHERE
			SPPT.PROD_PAUSE_TYPE_ID=SPPTR.PROD_PAUSE_TYPE_ID AND
			SPPTR.PROD_PAUSE_PRODUCTCAT_ID = #get_order.product_catid#
	</cfquery>
	<cfquery name="GET_ROW" datasource="#dsn3#">
		SELECT
        	ORDERS.ORDER_ID,
			ORDERS.ORDER_NUMBER,
			PRODUCTION_ORDERS_ROW.PRODUCTION_ORDER_ID P_ORDER_ID
		FROM
			PRODUCTION_ORDERS_ROW,
			ORDERS
		WHERE
			PRODUCTION_ORDERS_ROW.PRODUCTION_ORDER_ID = #attributes.upd# AND
			PRODUCTION_ORDERS_ROW.ORDER_ID = ORDERS.ORDER_ID 
	</cfquery>
	<cfquery name="get_serial" datasource="#dsn3#">	
		SELECT SERIAL_NO,GUARANTY_ID FROM SERVICE_GUARANTY_NEW WHERE PROCESS_ID = #attributes.upd#
	</cfquery>
	<cfif len(get_order.station_id)>
		<cfquery name="GET_STATION_INFO" datasource="#dsn3#">
			SELECT 
				DEPARTMENT,
				STATION_NAME,
				EXIT_DEP_ID,
				EXIT_LOC_ID,
				ENTER_DEP_ID,
				ENTER_LOC_ID,
				PRODUCTION_DEP_ID,
				PRODUCTION_LOC_ID
			FROM 
				WORKSTATIONS 
			WHERE 
				STATION_ID = #get_order.STATION_ID#
		</cfquery>
	<cfelse>
		<cfset get_station_info.recordcount = 0>
	</cfif>
    <cfquery name="get_bottom_station" datasource="#dsn3#">
			SELECT 
				STATION_NAME
			FROM 
				WORKSTATIONS 
			WHERE 
				STATION_ID = #station_id#
		</cfquery>
	<cfif GET_STATION_INFO.recordcount and len(GET_STATION_INFO.DEPARTMENT)>
		<cfquery name="get_employees" datasource="#dsn#">
			SELECT EMPLOYEE_NAME +' '+ EMPLOYEE_SURNAME EMPLOYEE,EMPLOYEE_ID FROM EMPLOYEE_POSITIONS WHERE DEPARTMENT_ID = #GET_STATION_INFO.DEPARTMENT# AND EMPLOYEE_ID IS NOT NULL
		</cfquery>
	<cfelse>
		<cfset get_employees.recordcount = 0>
		<cfset get_employees.EMPLOYEE = ''>
		<cfset get_employees.EMPLOYEE_ID = ''>
	</cfif>
	<style>
		.box_yazi {font-size:16px;font:bold} 
		.box_yazi_td {font-size:15px;font:bold;color:blue} 
		.box_yazi_td2 {font-size:18px;font:bold}
		.fade {
			   opacity: 1;
			   transition: opacity .25s ease-in-out;
			   -moz-transition: opacity .25s ease-in-out;
			   -webkit-transition: opacity .25s ease-in-out;
			   }
   .fade:hover {
				  opacity: 0.5;
				  }
	</style>
<table cellspacing="0" cellpadding="1" width="100%" height="100%" align="center" border="0">
	<tr>
		<td colspan="2" valign="top">
		<cfform name="timeform" method="post" action="#request.self#?fuseaction=production.form_add_production_order&upd=#attributes.upd#">
			<input type="hidden" name="start_date" id="start_date" value="">
			<input type="hidden" name="record_num" id="record_num" value="">
            <input type="hidden" name="operation_gurup_id" id="operation_gurup_id" value="<cfoutput>#attributes.operation_gurup_id#</cfoutput>">
			<table cellspacing="0" cellpadding="1" width="98%" height="98%" align="center" border="0">
				<cfoutput query="get_order">
					<tr>
						<td>
							<table cellspacing="0" cellpadding="0" width="100%" align="center" border="1">
								<tr>
									<td class="box_yazi" width="100" height="30px">&nbsp;<cf_get_lang_main no='1677.Emir No'> :</td>
									<td class="box_yazi_td" style="width:100px;">&nbsp;#p_order_no#</td>
									<td class="box_yazi" width="120">&nbsp;<cf_get_lang_main no='799.Sipariş No'> :</td>
									<td class="box_yazi_td" style="width:100px;">&nbsp;#get_row.order_number#</td>
									<td class="box_yazi" width="140">&nbsp;<cfoutput>#getLang('prod',356)#</cfoutput> :</td>
									<td class="box_yazi_td" style="width:230px;"><cfif len(get_bottom_station.station_name)>&nbsp;#get_bottom_station.station_name#</cfif></td>
                                    <td class="box_yazi" width="110">&nbsp;<cf_get_lang_main no='3104.Operatör'>:</td>
									<td class="box_yazi_td" style="width:230px;"><cfif len(get_order.station_id)>&nbsp;#deliver_get#</cfif>
								</tr>
							</table>
						</td>
					</tr>
                    <cfset emir_no = p_order_no>
				</cfoutput>
				<cfquery name="get_operations" datasource="#dsn3#">
					SELECT * FROM PRODUCTION_ORDER_OPERATIONS WHERE P_ORDER_ID = #attributes.upd#
				</cfquery>
				<cfquery name="get_serial_count" dbtype="query">
					SELECT 
						COUNT(SERIAL_NO),
						EMPLOYEE_ID,
						ASSET_ID,
						AMOUNT,
						SERIAL_NO
					FROM 
						get_operations 
					GROUP BY 
						SERIAL_NO,
						EMPLOYEE_ID,
						ASSET_ID,
						AMOUNT,
						SERIAL_NO
				</cfquery>
				<tr><td>&nbsp;</td></tr>
				<tr valign="top">
					<td>
						<table cellspacing="0" cellpadding="0" width="100%" align="center" border="1">
							<tr height="30">
								<td class="box_yazi_td2" style="width:400px;text-align:center"><cfoutput>#getLang('production',25)#</cfoutput></td>
								<td class="box_yazi_td2" style="width:200px;text-align:center"><cfoutput>#getLang('main',1622)# #getLang('main',1239)#</cfoutput></td>
								<td class="box_yazi_td2" style="width:100px;text-align:center"><cfoutput>#getLang('production',27)#</cfoutput></td>
								<td class="box_yazi_td2" style="width:100px;text-align:center"><cfoutput>#getLang('prod',295)#</cfoutput></td>
                                <td class="box_yazi_td2" style="width:100px;text-align:center"><cfoutput>#getLang('main',1674)#</cfoutput></td>
                                <td class="box_yazi_td2" style="width:100px;text-align:center"><cfoutput>#getLang('main',1032)#</cfoutput></td>
								<td class="box_yazi_td2" style="text-align:center"><cfoutput>#getLang('main',224)#</cfoutput></td>
                                <td class="box_yazi_td2" style="width:150px;text-align:center;<cfif get_order.STAGE neq 3>display:none;</cfif>"><cfoutput>#getLang('main',3118)#</cfoutput></td>
							</tr>
							<tr height="30">
								<cfoutput query="get_order">
                                	<cfset kalan = AMOUNT - REAL_AMOUNT>
                                    <cfif isdefined('default_prototip_package_stock_ids') and ListFind(default_prototip_package_stock_ids,stock_id)>
                                        <cfquery name="get_prototip_package_name" datasource="#dsn3#">
                                            SELECT        
                                                EDP.PACKAGE_NAME
                                            FROM            
                                                PRODUCTION_ORDERS AS PO INNER JOIN
                                                EZGI_DESIGN_PACKAGE_ROW AS EDP ON PO.SPEC_MAIN_ID = EDP.PACKAGE_SPECT_RELATED_ID
                                            WHERE        
                                                PO.STOCK_ID = #get_order.STOCK_ID# AND 
                                                PO.SPEC_MAIN_ID = #get_order.SPEC_MAIN_ID#
                                        </cfquery>
                                        <cfif get_prototip_package_name.recordcount>
                                            <cfset product_name_ = get_prototip_package_name.PACKAGE_NAME>
                                        <cfelse>
                                            <cfset product_name_ = PRODUCT_NAME>
                                        </cfif>
                                    <cfelse>
                                        <cfset product_name_ = PRODUCT_NAME>
                                    </cfif>
									<td class="box_yazi_td" style="text-align:center">&nbsp;#product_name_#</td>
									<td class="box_yazi_td" style="text-align:center">&nbsp;#OPERATION_TYPE#</td>
									<td class="box_yazi_td" style="text-align:center">&nbsp;#AMOUNT#</td>
                                    <td class="box_yazi_td" style="text-align:center">&nbsp;#REAL_AMOUNT#</td>
                                    <td class="box_yazi_td" style="text-align:center">&nbsp;#LOSS_AMOUNT#</td>
									<td class="box_yazi_td" style="text-align:center">
										<input type="text" name="remaining"  id="remaining" value="#kalan#" class="box" style="text-align:center; font-size:14px; width:100px; color:blue" readonly="readonly" />
									</td>
									<td class="box_yazi_td" style="width:180px;text-align:center">&nbsp;#MAIN_UNIT#</td>
                                    <td class="box_yazi_td" style="text-align:center;<cfif get_order.STAGE neq 3>display:none;</cfif>">&nbsp;#REAL_TIME#</td>
								</cfoutput>
							</tr>
						</table>
					</td>
				</tr>
                    <tr height="350px">
                        <td>
                            <table cellspacing="0" cellpadding="1" width="100%" align="center" border="0" >
                            	<tr height="350px" id="p_tamam"<cfif get_order.STAGE neq 3>style="display:none;"</cfif>>
                                 	<td align="center" valign="middle" style="font-family:Arial, Helvetica, sans-serif; font-size:56px; font-weight:bold; color:#900; text-align:center">
                                     	<cf_get_lang_main no='3119.Üretim Tamamlanmıştır'>.!!!
                                  	</td>
                              	</tr>
                                <cfif get_order.STAGE neq 3>
                                    <tr id="p_starts"<cfif get_order_result.recordcount>style="display:none;"</cfif>>
                                        <td style="text-align:left">
                                            <cfif pause_cat eq 0>
                                                <a href="javascript://" onclick="sw_start(1);">
                                                	<button type="button" name="uretim_basla" style="background-color:LightGray;font-size:18px; font-weight:bold;height:150px; width:200px" title="<cf_get_lang_main no='3107.Başlamak İçin Basınız'>" autofocus><cfoutput>#getLang('production',34)#</cfoutput></button>&nbsp;
                                                </a>
                                            <cfelse>
                                                <button type="button" name="uretim_bos" style="font-size:18px; font-weight:bold;height:150px; width:200px" title="<cf_get_lang_main no='3107.Başlamak İçin Basınız'>"></button>&nbsp;
                                            </cfif>     
                                        </td>
                                         <td align="center" valign="middle" style="font-family:Arial, Helvetica, sans-serif; font-size:56px; font-weight:bold; color:red">
                                            <cfif get_lot_no.recordcount>
                                                <cf_get_lang_main no='3120.Dikkat Lot No Giriş Yapınız'> !
                                            </cfif>
                                         </td>
                                    </tr>
                                    <tr id="p_finish"<cfif not get_order_result.recordcount>style="display:none;"</cfif>>
                                        <td style="text-align:left">
                                            <cfif pause_cat eq 0>	
                                                <a href="javascript://" onclick="sw_start(2);">
                                                	<button type="button" name="uretim_bitir" style="background-color:LightGray;font-size:18px; font-weight:bold;height:150px; width:200px" title="<cf_get_lang_main no='3107.Başlamak İçin Basınız'>" autofocus><cfoutput>#getLang('production',38)#</cfoutput></button>&nbsp;
                                                </a>
                                            <cfelse>
                                                <button type="button" name="uretim_bos" style="font-size:18px; font-weight:bold;height:150px; width:200px" title="<cf_get_lang_main no='3107.Başlamak İçin Basınız'>"></button>&nbsp;
                                            </cfif>       
                                        </td>
                                        <td align="center" valign="middle" style="font-family:Arial, Helvetica, sans-serif; font-size:56px; font-weight:bold; color:green">
                                            <cfif pause_cat eq 0>
                                                <cf_get_lang_main no='3121.Üretim Başladı'>.
                                            <cfelse>
                                                <span style="color:orange"><cf_get_lang_main no='3122.Duraklama Zamanı'>.
                                          	</cfif>
                                        </td>
                                    </tr>
                              	</cfif>
                                <tr id="p_amount" style="display:none;" height="100%">
                                    <td valign="middle">
                                        <table width="100%">
                                            <tr>
                                                <td align="left" width="75%">
                                                    <table cellspacing="0" cellpadding="1" border="0" align="center" height="98%" width="98%">
                                                        <tr class="color-border" height="280px">                  
                                                            <td> 
                                                                <table cellspacing="1" cellpadding="2" border="0" align="center" height="100%" width="100%" class="tableyazi">
                                                                    <tr class="color-row" height="50%" id="p_fire">
                                                                        <td align="center" width="50%" style = "font-size:48px; font-family:'Palatino Linotype', 'Book Antiqua', Palatino, serif; font-weight:bold; color:#900"><cf_get_lang_main no='3123.Fire Sebebi'></td>
                                                                        
                                                                        <td align="center" width="50%" style = "font-size:48px; font-family:'Palatino Linotype', 'Book Antiqua', Palatino, serif; font-weight:bold; color:#900"><cf_get_lang_main no='2940.Fire Miktarı'></td>
                                                                        
                                                                    </tr>
                                                                    <tr class="color-row" height="50%" id="p_product">
                                                                        <td style = "font-size:48px; font-family:'Palatino Linotype', 'Book Antiqua', Palatino, serif; font-weight:bold; width:100%; text-align:center"><cf_get_lang_main no='3124.Üretilen Miktar'></td>
                                                                    </tr>
                                                                    <tr class="color-row" height="50%">
                                                                        <td style="text-align:center">
                                                                            <input type="text" id="keyword" name="keyword" value="<cfoutput><cfif isdefined("keyword") and len(keyword)>#keyword#</cfif></cfoutput>" style="font-size:65px; font-family:'Palatino Linotype', 'Book Antiqua', Palatino, serif; text-align:right; font-weight:bold; width:280px; height:70px" class="box">
                                                                            <input type="hidden" name="fire" id="fire" value="">
                                                                            <input type="hidden" name="product_status" id="product_status" value="">
                                                                            <input type="hidden" name="result_id" id="result_id" value="<cfoutput>#result_id#</cfoutput>">
                                                                            <input type="hidden" name="time_start" id="time_start" value="<cfoutput>#time_start#</cfoutput>">
                                                                        </td>
                                                                        <td style="display:none;"><cf_workcube_process_cat slct_width="140"><cf_workcube_process is_upd='0' process_cat_width='130' is_detail='0'></td>
                                                                    </tr>
                                                                </table>
                                                            </td>
                                                        </tr>
                                                    </table>
                                                </td>                 
                                                 <td align="left" width="25%">
                                                    <table cellspacing="0" cellpadding="1" border="0" align="center" height="98%" width="98%">
                                                        <tr class="color-border" height="255px">                  
                                                            <td> 
                                                                <table cellspacing="1" cellpadding="2" border="0" align="center" height="100%" width="100%" class="tableyazi">
                                                                    <tr class="color-row" height="25%">
                                                                        <td style=" width:25%; text-align:center" >
                                                                        	<button type="button" name="k7" style="background-color:LightGray;font-size:22px; font-weight:bold;height:60px; width:60px" title="" onclick="key_control(7)">7</button>
                                                                        </td> 
                                                                        <td style=" width:25%; text-align:center" >
                                                                        	<button type="button" name="k8" style="background-color:LightGray;font-size:22px; font-weight:bold;height:60px; width:60px" title="" onclick="key_control(8)">8</button>
																		</td>
                                                                        <td style=" width:25%; text-align:center" >
                                                                        	<button type="button" name="k9" style="background-color:LightGray;font-size:22px; font-weight:bold;height:60px; width:60px" title="" onclick="key_control(9)">9</button>
                                                                        </td>
                                                                        <td rowspan="3" style=" width:25%; text-align:center; vertical-align:middle">
                                                                        	<button type="button" name="giris" style="background-color:LightGray;font-size:22px; font-weight:bold;height:210px; width:60px" title="" onclick="operation_add(1)">
                                                                   				<div id="Ay" style="font-size:22px; font-weight:bold;writing-mode:tb-rl;filter:fliph flipv; text-align:center; vertical-align:middle">
                            														<cfoutput>#getLang('assetcare',12)#</cfoutput>
                        														</div>         
                                                                            </button>
                                                                       	</td>
                                                                    </tr>
                                                                    <tr class="color-row" style="height:25%">
                                                                        <td style="text-align:center">
                                                                        	<button type="button" name="k4" style="background-color:LightGray;font-size:22px; font-weight:bold;height:60px; width:60px" title="" onclick="key_control(4)">4</button>
                                                                       	</td> 
                                                                        <td style="text-align:center">
                                                                        	<button type="button" name="k5" style="background-color:LightGray;font-size:22px; font-weight:bold;height:60px; width:60px" title="" onclick="key_control(5)">5</button>
                                                                       	</td>
                                                                        <td style="text-align:center">
                                                                        	<button type="button" name="k6" style="background-color:LightGray;font-size:22px; font-weight:bold;height:60px; width:60px" title="" onclick="key_control(6)">6</button>
                                                                       	</td>
                                                                    </tr>
                                                                    <tr class="color-row" style="height:25%">
                                                                        <td style="text-align:center">
                                                                        	<button type="button" name="k1" style="background-color:LightGray;font-size:22px; font-weight:bold;height:60px; width:60px" title="" onclick="key_control(1)">1</button>
                                                                        </td> 
                                                                        <td style="text-align:center">
                                                                        	<button type="button" name="k2" style="background-color:LightGray;font-size:22px; font-weight:bold;height:60px; width:60px" title="" onclick="key_control(2)">2</button>
                                                                        </td>
                                                                        <td style="text-align:center">
                                                                       		<button type="button" name="k3" style="background-color:LightGray;font-size:22px; font-weight:bold;height:60px; width:60px" title="" onclick="key_control(3)">3</button>
                                                                        </td>
                                                                    </tr>
                                                                    <tr class="color-row" style="height:25%">
                                                                        <td colspan="2" style="text-align:center">
                                                                        	<button type="button" name="k0" style="background-color:LightGray;font-size:22px; font-weight:bold;height:60px; width:135px" title="" onclick="key_control(0)">0</button>
                                                                        </td> 
                                                                        <td style="text-align:center">
                                                                        	<button type="button" name="ks" style="background-color:red;font-size:22px; font-weight:bold;height:60px; width:60px" title="" onclick="key_control(-1)"><img src="images/list_minus.gif" border="0" style="text-align:center; vertical-align:middle"></button>
                                                                      	</td>
                                                                        <td style="text-align:center">
                                                                        	<button type="button" name="kk" style="background-color:LightGray;font-size:22px; font-weight:bold;height:60px; width:60px" title="" onclick="key_control('.')">,</button>
                                                                        </td>
                                                                    </tr>
                                                                </table>
                                                            </td>
                                                        </tr>
                                                    </table>                   
                                                </td>
                                                <td style="display:none;"><cf_workcube_process_cat slct_width="140"><cf_workcube_process is_upd='0' process_cat_width='130' is_detail='0'></td>
                                            </tr>
                                        </table>
                                    </td>
                                </tr>
                            </table>
                        </td>
                    </tr>
               	<tr height="100px" valign="bottom">
                  	<td>
                       	<table style="width:100%; height:100%" cellpadding="0" cellspacing="3" border="0">
                         	<tr class="color-row">
                               	<td style="width:98px; text-align:center" id="p_mola"<cfif get_order.STAGE eq 0 or get_order.STAGE eq 3>style="display:none;"</cfif>>
										<cfif pause_cat eq 1 or pause_cat eq 0>
                                            <a href="javascript://" onclick="prod_pause(1);">
                                            	<button type="button" name="mola" style="background-color:LightGray;font-size:16px; font-weight:bold;height:100px; width:100px" title="<cf_get_lang_main no='3107.Başlamak İçin Basınız'>" <cfif pause_cat neq 0>autofocus</cfif>><cfoutput>#getLang('main',3102)#</cfoutput></button>&nbsp;
                                            </a>
                                        <cfelse>
                                            <button type="button" name="mola_bos" style="font-size:18px; font-weight:bold;height:100px; width:100px" title="<cf_get_lang_main no='3107.Başlamak İçin Basınız'>"></button>&nbsp;
                                      	</cfif>
                              	</td>

                                <td style="width:98px; text-align:center">
                                	<cfif pause_cat eq 0>
                                  	 	<a href="javascript://" onclick="sw_start();">
                                        	<button type="button" name="fire" style="background-color:LightGray;font-size:16px; font-weight:bold;height:100px; width:100px" title="<cf_get_lang_main no='3107.Başlamak İçin Basınız'>"><cfoutput>#getLang('main',1674)#</cfoutput></button>&nbsp;
                                        </a>
                                  	<cfelse>
                                    	<button type="button" name="fire_bos" style="font-size:18px; font-weight:bold;height:100px; width:100px" title="<cf_get_lang_main no='3107.Başlamak İçin Basınız'>"></button>&nbsp;
                                    </cfif>      
                                </td>
                                <td style="width:98px; text-align:center">
                                	<cfif pause_cat eq 0>
                                  		<a href="javascript://" onclick="control(2);">
                                        	<button type="button" name="fire" style="background-color:LightGray;font-size:16px; font-weight:bold;height:100px; width:100px" title="<cf_get_lang_main no='3107.Başlamak İçin Basınız'>"><cfoutput>#getLang('main',3111)#</cfoutput></button>&nbsp;
                                        </a>
                                	<cfelse>
                                		<button type="button" name="recete_bos" style="font-size:18px; font-weight:bold;height:100px; width:100px" title="<cf_get_lang_main no='3107.Başlamak İçin Basınız'>"></button>&nbsp;
                                	</cfif>
                                </td>
                                <td style="width:98px; text-align:center">
                                	<cfoutput>
                                	<cfif pause_cat eq 0>
                                  		<a href="javascript://" onclick="control(9)">
                                        	<button type="button" name="tresim" style="background-color:LightGray;font-size:16px; font-weight:bold;height:100px; width:100px" title="<cf_get_lang_main no='3107.Başlamak İçin Basınız'>"><cfoutput>#getLang('objects',406)#</cfoutput></button>&nbsp;
                                        </a>
                                  	<cfelse>
                                    	<button type="button" name="tresim_bos" style="font-size:18px; font-weight:bold;height:100px; width:100px" title="<cf_get_lang_main no='3107.Başlamak İçin Basınız'>"></button>&nbsp;
                                    </cfif>
                                    </cfoutput>
                                </td>
                                
                                <td style="width:98px; text-align:center">
                                    <cfif pause_cat eq 0>
                                  		<a href="javascript://" onclick="etiket(1);">
                                        	<button type="button" name="etiket" style="background-color:LightGray;font-size:16px; font-weight:bold;height:100px; width:100px" title="<cf_get_lang_main no='3107.Başlamak İçin Basınız'>"><cfoutput>#getLang('correspondence',203)#</cfoutput></button>&nbsp;
                                        </a>
                                	<cfelse>
                                    	<button type="button" name="etiket_bos" style="font-size:18px; font-weight:bold;height:100px; width:100px" title="<cf_get_lang_main no='3107.Başlamak İçin Basınız'>"></button>&nbsp;
                                	</cfif>
                                </td>
                                <cfif GET_ROW.recordcount>
                                    <td style="width:98px; text-align:center">
                                        <cfif pause_cat eq 0>
                                            <a href="javascript://" onclick="siparis();">
                                                <button type="button" name="siparis" style="background-color:LightGray;font-size:16px; font-weight:bold;height:100px; width:100px" title="<cf_get_lang_main no='3107.Başlamak İçin Basınız'>"><cfoutput>#getLang('main',2542)#</cfoutput></button>&nbsp;
                                            </a>
                                        <cfelse>
                                            <button type="button" name="siparis_bos" style="font-size:18px; font-weight:bold;height:100px; width:100px" title="<cf_get_lang_main no='3107.Başlamak İçin Basınız'>"></button>&nbsp;
                                        </cfif>
                                    </td>
                                </cfif>
                                <td style="width:98px; text-align:center">
                                	<cfif pause_cat eq 0>
                                  		<a href="javascript://" onclick="control(1);">
                                        <button type="button" name="rapor" style="background-color:DodgerBlue;font-size:16px; font-weight:bold;height:100px; width:100px" title="<cf_get_lang_main no='3107.Başlamak İçin Basınız'>"><cfoutput>#getLang('report',1938)#</cfoutput></button>&nbsp;
                                        </a>
                                  	<cfelse>
                                    	<button type="button" name="rapor_bos" style="font-size:18px; font-weight:bold;height:100px; width:100px" title="<cf_get_lang_main no='3107.Başlamak İçin Basınız'>"></button>&nbsp;
                                    </cfif>      
                                </td>
                                <td style="width:98px; text-align:center">
                                	<a href="javascript://" onclick="operation_add(2);">
                            			<button type="button" name="geri" style="background-color:Khaki;font-size:16px; font-weight:bold;height:100px; width:100px" title="<cf_get_lang_main no='3107.Başlamak İçin Basınız'>"><cfoutput>#getLang('main',20)#</cfoutput></button>&nbsp;
                                    
                                    </a>
                               	</td>    	
                                <cfif not isdefined('attributes.toplu_vts')>
                                    <td style="width:98px; text-align:center">
                                        <a href="javascript://" onclick="operation_add(3);"> 
                                            <button type="button" name="cik" style="background-color:Gold;font-size:16px; font-weight:bold;height:100px; width:100px" title="<cf_get_lang_main no='3107.Başlamak İçin Basınız'>"><cfoutput>#getLang('main',518)# #getLang('prod',662)#</cfoutput></button>&nbsp;
                                        </a>
                                    </td>
                                </cfif>
                                <td>&nbsp;</td>
                          	</tr>
                      	</table>
                  	</td>
               	</tr>									
			</table>	
		</cfform>
		</td>
	</tr>
</table>
<table width="100%" align="center" cellpadding="0" cellspacing="1" border="0">
	<tr>
    	<td><div id="groups_p"></div></td>
    </tr>
</table>

<script type="text/javascript">
	function sw_start(type)
	{
		if(type == 1)
		{
			document.timeform.product_status.value = "1";
			<cfoutput>
				var p_order_id = #attributes.upd#;
				var p_operation_id = #p_operation_id#;
				var station_id = #station_id#;
				var employee_id = #employee_id#;
				var operation_amount = #get_order.AMOUNT#;
			</cfoutput>
			var operation_gurup_id = document.getElementById('operation_gurup_id').value;
			window.open('<cfoutput>#request.self#</cfoutput>?fuseaction=production.addoperationresult_ezgi&operasyon=1&realized_amount_=0&upd_id='+p_order_id+'&operation_id_='+p_operation_id+'&station_id_='+station_id+'&employee_id_='+employee_id+'&operation_gurup_id='+operation_gurup_id);
		}
		if(type == 2)
		{
			var new_sql = "SELECT SUM(REAL_AMOUNT) AS REAL_AMOUNT FROM PRODUCTION_OPERATION_RESULT WHERE OPERATION_ID = <cfoutput>#p_operation_id#</cfoutput>";
		 	var get_amount = wrk_query(new_sql,'dsn3');
			if (get_amount.REAL_AMOUNT != undefined)
			{
				var operation_amount = <cfoutput>#get_order.AMOUNT#;</cfoutput>
				document.getElementById('remaining').value = operation_amount - get_amount.REAL_AMOUNT;
			}
			p_starts.style.display='none';
			p_finish.style.display='none';
			p_amount.style.display='';
			p_product.style.display='';
			p_fire.style.display='none';
			document.timeform.fire.value = "0";
			document.getElementById('keyword').focus();
		}
		if(type == 3)
		{
			var status = document.timeform.product_status.value;
			if(status ==1)
			{
				alert('<cf_get_lang_main no='3125.Üretim Sonuçlandırtıktan Sonra Fire Giriniz'>');	
			}
			else
			{
				p_starts.style.display='none';
				p_tamam.style.display='none';
				p_finish.style.display='none';
				p_amount.style.display='';
				p_product.style.display='none';
				p_fire.style.display='';
				document.timeform.fire.value = "1";
			}
		}
		if(type == 4)
		{
			p_starts.style.display='none';
			p_finish.style.display='';
			p_mola.style.display='';
			p_amount.style.display='none';
			document.timeform.product_status.value = "1";
			timestart_= document.timeform.time_start.value;
		}
	}
	function key_control(hkey)
		{
			if (hkey==-1)
			{
				var iLen = String(document.timeform.keyword.value).length;
				if (iLen>1)
				{
					ezgi = String(document.timeform.keyword.value).substring(0, iLen - 1);
				}
				else
				{
					ezgi = '';
				}
				document.timeform.keyword.value = ezgi;
			}
			else
			{
				var kLen = String(document.timeform.keyword.value).length;
				if(kLen<1&&hkey=='.') 
				{
				ezgi= (document.timeform.remaining.value);
				document.timeform.keyword.value = ezgi;
				}
				else
				{
				ezgi = (document.timeform.keyword.value + hkey);
				document.timeform.keyword.value = ezgi;
				}
			}
		}
		function prod_pause(tkey)
		{
			<cfoutput>
				var p_order_no_ = #get_order.p_order_no#;
				var p_order_id = #attributes.upd#;
				var p_operation_id = #p_operation_id#;
				var station_id = #station_id#;
				var employee_id = #employee_id#;
				var kalan_ = #kalan#
				var pause_cat = #pause_cat#
			</cfoutput>
			if(pause_cat==0)
			{
				if(tkey==1||tkey==2||tkey==3)
				{
					windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=production.popup_form_add_ezgi_prod_pause&upd_id='+p_order_id+'&operation_id_='+p_operation_id+'&station_id_='+station_id+'&employee_id_='+employee_id+'&type_id='+tkey+'&p_order_no='+p_order_no_,'small');
				}
			}
			else
			{
				windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=production.emptypopup_add_ezgi_prod_pause&p_order_id='+p_order_id+'&station_id='+station_id+'&operation_id='+p_operation_id+'&employee_id='+employee_id+'&pause_cat='+pause_cat,'small');	
			}
		}
	function operation_add(type)
		{
			<cfoutput>
				var p_order_id = #attributes.upd#;
				var p_operation_id = #p_operation_id#;
				var station_id = #station_id#;
				var employee_id = #employee_id#;
				var amount_=#get_order.AMOUNT#;
				var real_amount_= #get_order.REAL_AMOUNT#;
				var loss_amount_=#get_order.LOSS_AMOUNT#;
				
			</cfoutput>
			if (type== 1)
			{
				var kalan_miktar = document.getElementById('remaining').value;
				var product_amount = document.timeform.keyword.value;
				var fire_= document.timeform.fire.value;
				if (product_amount == '0' || product_amount == '')
				{
					alert('<cf_get_lang_main no='2146.Lütfen miktar giriniz.'>!');
				}
				else if(product_amount*1>kalan_miktar*1 && fire_!=1)
				{
					alert('<cf_get_lang_main no='3126.Girdiğiniz Miktar, Kalan Üretim Miktarından Fazla'>.!');
				}
				else
				{	
					if(fire_==1)
					{
						if(product_amount>amount_-loss_amount_)
						{
							alert('<cf_get_lang_main no='3127.Girdiğiniz Fire, Üretim Miktarından Fazla'>.!');
						}
						else
						{
							var operation_gurup_id = document.getElementById('operation_gurup_id').value;
							window.open('<cfoutput>#request.self#</cfoutput>?fuseaction=production.addoperationresult_ezgi&realized_amount_= 0&upd_id='+p_order_id+'&operation_id_='+p_operation_id+'&station_id_='+station_id+'&loss_amount_='+product_amount+'&employee_id_='+employee_id+'&operation_gurup_id='+operation_gurup_id);
							window.opener.location.reload();
						}
					}
					else
					{

						var operation_gurup_id = document.getElementById('operation_gurup_id').value;
						var process_stage= document.getElementById('process_stage').value;
						var process_cat = document.getElementById('process_cat').options[1].value;
						window.open('<cfoutput>#request.self#</cfoutput>?fuseaction=production.addoperationresult_ezgi&upd_id='+p_order_id+'&operation_id_='+p_operation_id+'&station_id_='+station_id+'&realized_amount_='+product_amount+'&employee_id_='+employee_id+'&operation_gurup_id='+operation_gurup_id+'&process_stage='+process_stage+'&process_cat='+process_cat);
						window.opener.location.reload();
					}
				}
			}
			else
			{
				if (type== 2)
				{
					<cfif not isdefined('attributes.toplu_vts')>
						<cfif get_timing_type.TIMING_TYPE eq 3>
							window.location.href='<cfoutput>#request.self#?fuseaction=production.list_ezgi_production_operation&is_form_submitted=1&station_id=#station_id#&employee_id=#employee_id#&lot_number=#get_order.LOT_NO#</cfoutput>';
						<cfelse>
							window.location.href='<cfoutput>#request.self#?fuseaction=production.list_ezgi_production_operation&is_form_submitted=1&station_id=#station_id#&employee_id=#employee_id#<!---&lot_number=#emir_no#---></cfoutput>';
						</cfif>
					<cfelse>
						window.location.href='<cfoutput>#request.self#</cfoutput>?fuseaction=production.list_ezgi_collect_production';
					</cfif>
				}
				else if (type== 3)
				{
					window.location.href='<cfoutput>#request.self#?fuseaction=production.employee_ezgi_identification_1</cfoutput>';
				}
			}
		}
	function control(c_key)
	{
		<cfoutput>
			var p_order_id = #attributes.upd#;
			var p_operation_id = #p_operation_id#;
			var station_id = #station_id#;
			var employee_id = #employee_id#;
		</cfoutput>
		if (c_key== 1)
			windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=production.popup_dsp_ezgi_prod_pause&employee_id='+employee_id,'longpage');
		if (c_key== 2)
			windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=production.popup_dsp_ezgi_material_list&p_order_id='+p_order_id+'&p_operation_id='+p_operation_id+'&employee_id='+employee_id+'&station_id='+station_id,'wide');
		if (c_key== 9)
			window.open('<cfoutput>#request.self#</cfoutput>?fuseaction=production.popup_dsp_ezgi_prod_teknik_resim&p_order_id='+p_order_id+'&p_operation_id='+p_operation_id,'width=1500,height=1000');

	}
	function etiket()
	{
		<cfoutput>var p_order_id = #attributes.upd#;</cfoutput>
		windowopen('<cfoutput>#request.self#?fuseaction=objects.popup_print_files&print_type=280</cfoutput>&action_id='+p_order_id,'wide');
	}
	function siparis()
	{
		<cfif GET_ROW.recordcount>
			<cfoutput>var order_id = #get_row.order_id#;</cfoutput>
			windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=production.popup_dsp_ezgi_orders&order_id='+order_id,'wide'); 
		</cfif>
	}
	function emirler()
	{
		<cfoutput>var station_id = #station_id#; var employee_id = #employee_id#;</cfoutput>
		window.open('<cfoutput>#request.self#</cfoutput>?fuseaction=production.popup_dsp_ezgi_production&station_id='+station_id,'','toolbar=yes, scrollbars=yes,width=1350,height=750');
	}
</script>
</cfif>