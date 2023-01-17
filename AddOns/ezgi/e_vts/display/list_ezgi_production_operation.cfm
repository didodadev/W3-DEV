<cfset fuseaction_ = ListGetAt(attributes.fuseaction,2,'.')>
<cfparam name="authority_station_id_list" default="0">
<cfparam name="attributes.lot_number" default="">
<cfparam name="attributes.start_date" default="">
<cfparam name="attributes.finish_date" default="">
<cfparam name="attributes.is_form_submitted" default="">
<cfparam name="attributes.station_id" default="">
<cfparam name="attributes.is_show" default="1">
<cfif isdefined("attributes.start_date") and isdate(attributes.start_date)>
	<cf_date tarih="attributes.start_date">
<cfelse>
	<cfset attributes.start_date = wrk_get_today()>
</cfif>
<cfif isdefined("attributes.finish_date") and isdate(attributes.finish_date)>
	<cf_date tarih="attributes.finish_date">
<cfelse>
	<cfset attributes.finish_date = date_add('d',1,attributes.start_date)>
</cfif>
<cfif isdefined('attributes.new_employee')>
	<cfset add_employee = 1>
	<cfinclude template="../query/add_ezgi_station_employee.cfm">
</cfif>
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
<cfquery name="get_workstation_name" datasource="#dsn3#">
	SELECT STATION_NAME,STATION_ID FROM WORKSTATIONS WHERE STATION_ID = #attributes.station_id#
</cfquery>
<cfquery name="get_prod_pause" datasource="#dsn3#">
	SELECT     
    	PROD_PAUSE_TYPE_ID
	FROM         
    	SETUP_PROD_PAUSE
	WHERE     
        STATION_ID = #attributes.station_id# AND 
        EMPLOYEE_ID = #attributes.employee_id# AND 
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
<cfif isdefined("attributes.is_form_submitted")>
    <cfquery name="GET_PO_DET" datasource="#dsn3#">
    	SELECT 
        	P_ORDER_ID, 
            PO_RELATED_ID, 
            LOT_NO, 
            P_ORDER_NO, 
            IS_STAGE, 
            START_DATE, 
            STOCK_ID,
            SPEC_MAIN_ID, 
            STOCK_CODE_2,
            PRODUCT_NAME, 
            P_OPERATION_ID, 
            OPERATION_TYPE_ID, 
            OPERATION_CODE, 
            OPERATION_TYPE, 
            AMOUNT, 
            STAGE, 
            O_START_DATE,
            O_STATION_IP,
          	O_CURRENT_NUMBER,
            ACTION_EMPLOYEE_ID, 
            ISNULL(sum(REAL_AMOUNT),0) REAL_AMOUNT, 
            ISNULL(sum(LOSS_AMOUNT),0) LOSS_AMOUNT, 
            ISNULL(OPERATION_GRUP_ID,0) AS OPERATION_GRUP_ID,
            ISNULL(
            	(
            	SELECT
					SUM(POR_.AMOUNT) ORDER_AMOUNT
				FROM
					PRODUCTION_ORDER_RESULTS_ROW POR_,
					PRODUCTION_ORDER_RESULTS POO
				WHERE
					POR_.PR_ORDER_ID = POO.PR_ORDER_ID
					AND POO.P_ORDER_ID = EZGI_OPERATION_M.P_ORDER_ID
					AND POR_.TYPE = 1
					AND POO.IS_STOCK_FIS = 1
				)
          	,0) ROW_RESULT_AMOUNT,
             (
                SELECT        
                    EM.MASTER_PLAN_NUMBER
                FROM            
                    EZGI_IFLOW_PRODUCTION_ORDERS AS EI INNER JOIN
                    EZGI_IFLOW_MASTER_PLAN AS EM ON EI.MASTER_PLAN_ID = EM.MASTER_PLAN_ID
                WHERE        
                EI.LOT_NO = EZGI_OPERATION_M.LOT_NO
            ) AS MASTER_PLAN_NUMBER
		FROM         
        	EZGI_OPERATION_M
      	WHERE
        	<cfif attributes.is_show eq 0>
            	O_STATION_IP = #attributes.station_id# AND
            <cfelse>
                OPERATION_TYPE_ID IN
                                    (	
                                    SELECT     	
                                        OPERATION_TYPE_ID
                                    FROM      	
                                        WORKSTATIONS_PRODUCTS
                                    WHERE      	
                                        WS_ID = #attributes.station_id# AND 
                                        STOCK_ID IS NULL AND 
                                        OPERATION_TYPE_ID IS NOT NULL
                                    ) AND 
           	</cfif>
    		IS_STAGE IN (0,1,2,3,4)
            <cfif isdefined('attributes.all_info') and len(attributes.all_info)>
                AND START_DATE < #Dateadd('d',1,attributes.start_date)#
                AND START_DATE >= #attributes.start_date#
                AND IS_STAGE IN (0,1,3,4)
            <cfelse>
				<cfif isdefined('attributes.lot_number') and len(attributes.lot_number)>
                    AND(
                        <cfif left(attributes.lot_number,1) eq 2>
                            P_ORDER_NO LIKE '#attributes.lot_number#%'       
                        <cfelse>
                            LOT_NO LIKE '#attributes.lot_number#%'
                        </cfif>
                        )
                <cfelse>
                    AND ACTION_EMPLOYEE_ID = #employee_id# AND 
                    REAL_AMOUNT = 0 AND 
                    LOSS_AMOUNT = 0 AND 
                    ISNULL(REAL_TIME,0)=0 AND 
                    WAIT_TIME IS NULL
                </cfif>
          	</cfif>
		GROUP BY
        	P_ORDER_ID, 
            PO_RELATED_ID, 
            LOT_NO, 
            P_ORDER_NO, 
            IS_STAGE, 
            START_DATE, 
            STOCK_ID, 
            SPEC_MAIN_ID,
            STOCK_CODE_2,
            PRODUCT_NAME, 
            P_OPERATION_ID, 
            OPERATION_TYPE_ID, 
            OPERATION_CODE, 
            OPERATION_TYPE, 
            AMOUNT, 
            STAGE, 
            O_START_DATE,
            O_STATION_IP,
          	O_CURRENT_NUMBER,
            ACTION_EMPLOYEE_ID,
            OPERATION_GRUP_ID
        ORDER BY
        	<cfif isdefined('attributes.all_info') and len(attributes.all_info)>
            	P_ORDER_ID,
            	O_CURRENT_NUMBER,
            	O_START_DATE,
                
                OPERATION_TYPE 
            <cfelse>
            	O_CURRENT_NUMBER,
                P_ORDER_NO DESC ,
                OPERATION_TYPE   
            </cfif>         
    </cfquery>
<cfelse>
	<cfset GET_PO_DET.recordcount = 0>
</cfif>
<!---<cfdump expand="yes" var="#GET_PO_DET#"><cfabort>--->
<cfparam name="attributes.page" default=1>
<cfparam name="attributes.maxrows" default='250'>
<cfset attributes.startrow=((attributes.page-1)*attributes.maxrows)+1>
<cfif get_po_det.recordcount>
	<cfparam name="attributes.totalrecords" default='#get_po_det.recordcount#'>
<cfelse>
	<cfparam name="attributes.totalrecords" default='0'>
</cfif>
<cfif get_po_det.recordcount>
	<cfset p_order_id_list = ''>
	<cfset po_related_id_list = ''>
	<cfset station_id_list = ''>
	<cfoutput query="get_po_det" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">
		<cfif len(p_order_id) and not listfind(p_order_id_list,p_order_id)>
			<cfset p_order_id_list=listappend(p_order_id_list,p_order_id)>
		</cfif>
		<cfif len(po_related_id) and not listfind(po_related_id_list,po_related_id)>
			<cfset po_related_id_list=listappend(po_related_id_list,po_related_id)>
		</cfif>
		<cfif len(station_id) and not listfind(station_id_list,station_id)>
			<cfset station_id_list=listappend(station_id_list,station_id)>
		</cfif>
	</cfoutput>
	<cfquery name="GET_ROW" datasource="#dsn3#">
		SELECT
			ORDER_NUMBER,
			PRODUCTION_ORDERS_ROW.PRODUCTION_ORDER_ID P_ORDER_ID
		FROM
			PRODUCTION_ORDERS_ROW,
			ORDERS
		WHERE
			PRODUCTION_ORDERS_ROW.PRODUCTION_ORDER_ID IN(#p_order_id_list#) AND
			PRODUCTION_ORDERS_ROW.ORDER_ID = ORDERS.ORDER_ID 
	</cfquery>
	<cfloop query="GET_ROW">
		<cfif not isdefined('order_list_#p_order_id#')>
			<cfset 'order_list_#p_order_id#' = ORDER_NUMBER>
		<cfelse>
			<cfset 'order_list_#p_order_id#' = listdeleteduplicates(ListAppend(Evaluate('order_list_#p_order_id#'),ORDER_NUMBER,','))>
		</cfif>
	</cfloop>
	<cfif len(po_related_id_list)>
		<cfquery name="get_related_order" datasource="#DSN3#">
			SELECT P_ORDER_ID,P_ORDER_NO,PO_RELATED_ID FROM PRODUCTION_ORDERS WHERE PO_RELATED_ID IN (#po_related_id_list#) ORDER BY P_ORDER_ID
		</cfquery>
		<cfloop query="get_related_order">
			<cfif not isdefined('po_related_list_#p_order_id#')>
				<cfset 'po_related_list_#p_order_id#' = P_ORDER_NO>
			<cfelse>
				<cfset 'po_related_list_#p_order_id#' = listdeleteduplicates(ListAppend(Evaluate('po_related_list_#p_order_id#'),P_ORDER_NO,','))>
			</cfif>
		</cfloop>
	</cfif>
	<cfif len(station_id_list)>
		<cfset station_id_list=listsort(station_id_list,"numeric","ASC",",")>
		<cfquery name="get_w" datasource="#dsn3#">
			SELECT STATION_NAME,STATION_ID FROM WORKSTATIONS WHERE STATION_ID IN (#station_id_list#) ORDER BY STATION_ID
		</cfquery>
		<cfset station_id_list = listsort(listdeleteduplicates(valuelist(get_w.STATION_ID,',')),'numeric','ASC',',')>
	</cfif>
</cfif>
<cfscript>wrkUrlStrings('url_str','is_form_submitted','lot_number');</cfscript>
<cfset url_str = url_str & "&station_id=#station_id#&employee_id=#employee_id#">
<cfif isdate(attributes.start_date)>
	<cfset url_str = url_str & "&start_date=#dateformat(attributes.start_date,'dd/mm/yyyy')#">
</cfif>
<cfif isdate(attributes.finish_date)>
	<cfset url_str = url_str & "&finish_date=#dateformat(attributes.finish_date,'dd/mm/yyyy')#">
</cfif>
<cfquery name="get_employee_durum" datasource="#dsn3#">
	SELECT  
    	ISNULL(REAL_AMOUNT, 0) AS REAL_AMOUNT,
        P_OPERATION_ID,
        ISNULL(OPERATION_GRUP_ID,0) AS OPERATION_GRUP_ID
	FROM        
    	EZGI_OPERATION_M
	WHERE     
    	ACTION_EMPLOYEE_ID = #attributes.employee_id# AND 
        STATION_ID = #attributes.station_id# AND
        STAGE = 1 AND
        LOSS_AMOUNT=0 AND
        REAL_AMOUNT=0 
</cfquery>
<cfquery name="get_employee_durum_gurup" dbtype="query">
	SELECT
    	OPERATION_GRUP_ID
   	FROM
 		get_employee_durum
    GROUP BY
    	OPERATION_GRUP_ID
</cfquery>
<cfif get_employee_durum_gurup.recordcount>
	<cfset ezgi_operation_gurup_id = get_employee_durum_gurup.OPERATION_GRUP_ID>
    <cfquery name="get_gurup_durum" datasource="#dsn3#">
        SELECT     
            IS_RESULT
        FROM         
            EZGI_OPERATION_GRUP_NO
        WHERE     
            OPERATION_GRUP_ID = #ezgi_operation_gurup_id#
    </cfquery>
    <cfset ezgi_operation_gurup_id_durum = get_gurup_durum.IS_RESULT>
<cfelse>
	<cfset ezgi_operation_gurup_id_durum = 0>
</cfif>
<!---<cfdump expand="yes" var="#get_employee_durum_gurup#">--->
<cfset p_operation_id_list = Valuelist(get_employee_durum.P_OPERATION_ID)>
<style>
	.box_yazi {font-size:16px;border-color:#666666;font:bold} 
	.box_yazi_td {font-size:14px;border-color:#666666;} 
	.box_yazi_small {font-size:11px;border-color:#666666;} 
	.a_box_yazi {font-size:16px;border-color:#BDCAC5;font:bold} 
	.a_box_yazi_td {font-size:14px;border-color:#BDCAC5;} 
</style>
<table width="98%" align="center" border="0">
	<tr>
		<!---<td class="headbold" height="30" style="font-size:18px;">Üretim Emirleri</td>--->
		<cfform name="search_list" id="search_list" action="#request.self#?fuseaction=production.#fuseaction_#" method="post">
        	<cfinput type="hidden" name="all_info" id="all_info" value="">
			<cfinput type="hidden" name="is_form_submitted" value="1">
        	<cfinput type="hidden" name="station_id" value="#station_id#">
          	<cfinput type="hidden" name="employee_id" value="#employee_id#">
			<td style="text-align:right">
				<table width="100%">
					<tr>
                    	<td align="right" width="450px">
                        	<cfif get_employee_durum.recordcount and get_employee_durum.REAL_AMOUNT eq 0>
                            	<a href="javascript://" onclick="delete_control();">
                                 	<button type="button" name="worked" style="width:110px; background-color:red;font-size:14px; font-weight:bold;height:40px"><cfoutput>#getLang('report',1416)#</cfoutput></button>
                              	</a>
                            <cfelse>
                            	<cfif pause_cat eq 0>
                            		<a href=<cfoutput>"#request.self#?fuseaction=production.upd_ezgi_station_employee&station_id=#attributes.station_id#&employee_id=#attributes.employee_id#&upd_employee=1</cfoutput>">
                            			<button type="button" name="degistir" style="width:105px; font-size:14px; font-weight:bold;height:40px"><cfoutput>#getLang('main',19)#</cfoutput></button>
                                	</a>
                               	<cfelse>
                                	<button type="button" name="degistir" style="width:105px; font-size:14px; font-weight:bold;height:40px"></button>
                                </cfif>
                                <cfif pause_cat eq 3 or pause_cat eq 0>
                                 	<a href="javascript://" onclick="prod_pause(3);">
                                    	<button type="button" name="ariza" style="width:80px; font-size:14px; font-weight:bold;height:40px"><cfoutput>#getLang('main',3101)#</cfoutput></button>
                                    </a>
                              	<cfelse>
                                  	<button type="button" name="ariza" style="width:80px; font-size:14px; font-weight:bold;height:40px"></button>
                              	</cfif>
                                <cfif  pause_cat eq 1 or pause_cat eq 0>
                                 	<a href="javascript://" onclick="prod_pause(1);">
                                    	<button type="button" name="mola" style="width:80px; font-size:14px; font-weight:bold;height:40px"><cfoutput>#getLang('main',3102)#</cfoutput></button>
                                    </a>
                               	<cfelse>
                                  	<button type="button" name="mola" style="width:80px; font-size:14px; font-weight:bold;height:40px"></button>
                               	</cfif>
                                <cfif pause_cat eq 2 or pause_cat eq 0>
                                 	<a href="javascript://" onclick="prod_pause(2);">
                                    	<button type="button" name="duraklama" style="width:105px; font-size:14px; font-weight:bold;height:40px"><cfoutput>#getLang('main',3103)#</cfoutput></button>
                                    </a>
                               	<cfelse>
                                    <button type="button" name="duraklama" style="width:105px; font-size:14px; font-weight:bold;height:40px"></button>
                               	</cfif>
                            </cfif>
                        </td>
						<td align="right" width="510px" style= "font-size:16px; font-weight:bold"><cfoutput>#get_workstation_name.station_name# - #get_emp_info(employee_id,0,0)#</cfoutput></td>
                        <td></td>
						<td align="right" width="80px" style= "font-size:16px; font-weight:bold"><cf_get_lang_main no='1677.Emir No'> </td>
						<td align="right" width="270px"><input name="lot_number" id="lot_number"  type="text" value="" onKeyDown="if(event.keyCode == 13) {return location_production_detail(trim(this.value));}" style="width:140px; height:40px; font-size:24px; font-weight:bold; vertical-align:top">&nbsp;
                        	<cfif pause_cat eq 3 or pause_cat eq 0>
                           		<a href="javascript://" onclick="tumu();">
                                	<button type="button" name="tumu" style="width:105px; font-size:14px; font-weight:bold;height:40px"><cfoutput>#getLang('main',296)#</cfoutput></button>
                                </a>
                        	<cfelse>
                             	<button type="button" name="tumu" style="width:105px; font-size:14px; font-weight:bold;height:40px"><cfoutput>#getLang('main',296)#</cfoutput></button>
                        	</cfif>
                        </td>
					</tr>
				</table>
			</td>
		</cfform>
	</tr>
	<tr>
		<td colspan="3">
			<table border="1" cellspacing="0" cellpadding="0" width="100%" align="center" style="border-color:#666666;">
				<tr height="40" style="background-color:#CCCCCC;">
					<td class="box_yazi" style="text-align:center" width="4%"><cf_get_lang_main no ='75.No'></td>
					<td class="box_yazi" style="text-align:center" width="8%"><cf_get_lang_main no='330.Tarih'></td>
					<td class="box_yazi" style="text-align:center" width="8%"><cf_get_lang_main no='1677.Emir No'></td>
					<td class="box_yazi" style="text-align:center" width="8%"><cf_get_lang_main no='3104.Operatör'></td>
					<td class="box_yazi" style="text-align:center" ><cfoutput>#getLang('production',64)#</cfoutput></td>
					<td class="box_yazi" style="text-align:center" width="15%"><cf_get_lang_main no='1622.Operasyon'></td>
					<td class="box_yazi" style="text-align:center" width="4%"><cf_get_lang_main no='223.Miktar'></td>
                    <td class="box_yazi" style="text-align:center" width="4%"><cf_get_lang_main no='1674.Fire'></td>
                    <td class="box_yazi" style="text-align:center" width="4%"><cf_get_lang_main no='3105.Biten'></td>
					<td class="box_yazi" style="text-align:center" width="4%"><cf_get_lang_main no='1032.Kalan'></td>
                    <td class="box_yazi" style="text-align:center" width="3%">OP.</td>
                    <td class="box_yazi" style="text-align:center" width="3%">IE.</td>
				</tr>
					<cfoutput query="get_po_det" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">
						<tr height="50" onMouseOver="this.className='color-light';" onMouseOut="this.className='color-row';" class="color-row">
							<td class="box_yazi_td" style="text-align:center">
                            	<cfif attributes.station_id neq o_station_ip>
                        			<span style="background-color:red">
                        		<cfelse>
                                	<span>
                                </cfif>
                            	<cfif OPERATION_GRUP_ID gt 0 and OPERATION_GRUP_ID eq get_employee_durum_gurup.OPERATION_GRUP_ID>
                            	<!---<a href="#request.self#?fuseaction=production.add_ezgi_production_order&upd=#p_order_id#&station_id=#attributes.station_id#&employee_id=#attributes.employee_id#&p_operation_id=#P_OPERATION_ID#&start_date=#Dateformat(attributes.start_date,'DD/MM/YYYY')#" style="font-size:14px" class="tableyazi"><img src="/images/production/coz1.png" title="Başlamak İçin Basınız"></a>--->
                                <cfelse>
                                	&nbsp;#currentrow#
                                </cfif>
                                </span>
                            </td>
							<td class="box_yazi_td" style="text-align:center">&nbsp;
								<!---<cfif len(O_START_DATE)>
                                	#DateFormat(O_START_DATE,'dd/mm/yyyy')#
                                <cfelse>
                                	#DateFormat(START_DATE,'dd/mm/yyyy')#<BR />
                                    #MASTER_PLAN_NUMBER#
                                </cfif>--->
                                #DateFormat(START_DATE,'dd/mm/yyyy')#<BR />
                                    #MASTER_PLAN_NUMBER#
                           	</td>
							<td class="box_yazi_td" style="text-align:center">&nbsp;#P_ORDER_NO#</td>
							<td class="box_yazi_td" style="text-align:center;" nowrap="nowrap">&nbsp;
                            	<cfif not isdefined('attributes.all_info') or  not len(attributes.all_info)>
                                    <cfif  (get_employee_durum.recordcount and not ListContains(p_operation_id_list,P_OPERATION_ID,',') and STAGE neq 3 and OPERATION_GRUP_ID eq 0) >
                                        <a href="#request.self#?fuseaction=production.add_ezgi_production_order&upd=#p_order_id#&station_id=#attributes.station_id#&employee_id=#attributes.employee_id#&p_operation_id=#P_OPERATION_ID#&start_date=#Dateformat(attributes.start_date,'DD/MM/YYYY')#&operation_gurup_id=#ezgi_operation_gurup_id#" style="font-size:14px" class="tableyazi">
                                        	<button type="button" name="gurupla" style="background-color:MediumBlue; color:white;width:120px; font-size:14px; font-weight:bold;height:40px" title="<cf_get_lang_main no='3107.Başlamak İçin Basınız'>">#getLang('prod',502)#</button>
                                     	</a>
                                    <cfelseif (get_employee_durum.recordcount and ListContains(p_operation_id_list,P_OPERATION_ID,',') and STAGE neq 3 and OPERATION_GRUP_ID gt 0)>
                                        <a href="#request.self#?fuseaction=production.add_ezgi_production_order&upd=#p_order_id#&station_id=#attributes.station_id#&employee_id=#attributes.employee_id#&p_operation_id=#P_OPERATION_ID#&start_date=#Dateformat(attributes.start_date,'DD/MM/YYYY')#&operation_gurup_id=#ezgi_operation_gurup_id#" style="font-size:14px" class="tableyazi">
                                            <button type="button" name="seciniz" style="width:120px; font-size:14px; font-weight:bold;height:40px" title="<cf_get_lang_main no='3107.Başlamak İçin Basınız'>"><cf_get_lang_main no='322.Seçiniz'></button>
                                      
                                        </a>
                                    <cfelseif (get_employee_durum.recordcount and ListContains(p_operation_id_list,P_OPERATION_ID,',') and STAGE neq 3) or ACTION_EMPLOYEE_ID eq '' or (real_amount neq 0 or loss_amount neq 0 and stage eq 1)>
                                        <a href="#request.self#?fuseaction=production.add_ezgi_production_order&upd=#p_order_id#&station_id=#attributes.station_id#&employee_id=#attributes.employee_id#&p_operation_id=#P_OPERATION_ID#&start_date=#Dateformat(attributes.start_date,'DD/MM/YYYY')#" style="font-size:14px" class="tableyazi">
                                        	<button type="button" name="seciniz" style="width:120px; font-size:14px; font-weight:bold;height:40px" title="<cf_get_lang_main no='3107.Başlamak İçin Basınız'>"><cf_get_lang_main no='322.Seçiniz'></button>
                                        </a>
                                    <cfelseif (not get_employee_durum.recordcount and ACTION_EMPLOYEE_ID neq attributes.employee_id and STAGE neq 3)> 
                                        <a href="#request.self#?fuseaction=production.add_ezgi_production_order&upd=#p_order_id#&station_id=#attributes.station_id#&employee_id=#attributes.employee_id#&p_operation_id=#P_OPERATION_ID#&start_date=#Dateformat(attributes.start_date,'DD/MM/YYYY')#" style="font-size:14px" class="tableyazi">
                                        	<button type="button" name="isleniyor" style="background-color:Gold; color:white;width:120px; font-size:14px; font-weight:bold;height:40px" title="<cf_get_lang_main no='3107.Başlamak İçin Basınız'>"><cf_get_lang_main no='293.İşleniyor'></button>
                                        
                                        </a>
                                    <cfelse>
                                        #get_emp_info(ACTION_EMPLOYEE_ID,0,0)#
                                    </cfif>
                             	</cfif>
                            </td>
                            <td class="box_yazi_td">
                            	<cfif isdefined('default_prototip_package_stock_ids') and ListFind(default_prototip_package_stock_ids,stock_id)>
                                    <cfquery name="get_prototip_package_name" datasource="#dsn3#">
                                        SELECT        
                                            EDP.PACKAGE_NAME
                                        FROM            
                                            PRODUCTION_ORDERS AS PO INNER JOIN
                                            EZGI_DESIGN_PACKAGE_ROW AS EDP ON PO.SPEC_MAIN_ID = EDP.PACKAGE_SPECT_RELATED_ID
                                        WHERE        
                                            PO.STOCK_ID = #STOCK_ID# AND 
                                            PO.SPEC_MAIN_ID = #SPEC_MAIN_ID#
                                    </cfquery>
                                    <cfif get_prototip_package_name.recordcount>
                                        <cfset product_name_ = get_prototip_package_name.PACKAGE_NAME>
                                    <cfelse>
                                        <cfset product_name_ = PRODUCT_NAME>
                                    </cfif>
                                <cfelse>
                                    <cfset product_name_ = PRODUCT_NAME>
                                </cfif>
                            	&nbsp;#product_name_#<br />
                                <span class="box_yazi_small">&nbsp;#STOCK_CODE_2#</span>
                            </td>
							<td class="box_yazi_td">&nbsp;#OPERATION_TYPE#</td>
                            <td class="box_yazi_td" style="text-align:center">#AMOUNT#</td>
							<td class="box_yazi_td" style="text-align:center">#LOSS_AMOUNT#</td>
                            <td class="box_yazi_td" style="text-align:center">#REAL_AMOUNT#</td>
							<td class="box_yazi_td" style="text-align:center">#AMOUNT-REAL_AMOUNT#</td>
                            <td class="box_yazi_td" style="text-align:center">
								<cfif not len(STAGE)>
									<img src="/images/blue_glob.gif" title="<cf_get_lang no='9.Başlamadı'>!">
								<cfelseif STAGE eq 0>
									<img src="/images/yellow_glob.gif" title="<cf_get_lang no='11.Operatöre Gönderildi'>!">
								<cfelseif STAGE eq 1>
									<img src="/images/green_glob.gif" title="<cf_get_lang no='12.Başladı'>!">
								<cfelseif STAGE eq 3>
									<img src="/images/red_glob.gif" title="<cf_get_lang no='3108.Bitti'>!">
								<cfelseif STAGE eq 4>
									<img src="/images/blue_glob.gif" title="<cf_get_lang no='9.Başlamadı'>!">	
								</cfif>
							</td>
                            <td class="box_yazi_td" style="text-align:center">
								<cfif IS_STAGE eq 4>
                             		<img src="/images/blue_glob.gif" title="<cf_get_lang no ='270.Başlamadı'>">
                                <cfelseif IS_STAGE eq 0>
                                    <img src="/images/yellow_glob.gif" title="<cf_get_lang no ='578.Operatöre Gönderildi'>">
                                <cfelseif IS_STAGE eq 1>
                                    <img src="/images/green_glob.gif" title="<cf_get_lang no ='577.Başladı'>">
                                <cfelseif IS_STAGE eq 2>
                                    <img src="/images/red_glob.gif" title="<cf_get_lang no ='271.Bitti'>">
                                <cfelseif IS_STAGE eq 3>
                                    <img src="/images/grey_glob.gif" title="<cf_get_lang no ='270.Başlamadı'>">
                                </cfif>
							</td>
						</tr>
					</cfoutput>
			</table>	
		</td>
	</tr>
</table>
<cfif attributes.totalrecords gt attributes.maxrows>
	<table width="98%" align="center" cellpadding="0" cellspacing="0" border="0" height="35">
		<tr>
			<td style="font-size:14px;">
				<cf_pages 
					page="#attributes.page#" 
					maxrows="#attributes.maxrows#" 
					totalrecords="#get_po_det.recordcount#" 
					startrow="#attributes.startrow#" 
					adres="production.#fuseaction_##url_str#&all_info=1">
			</td>
			<!-- sil -->
			<td align="right" style="text-align:right;font-size:14px"><cfoutput><cf_get_lang_main no='128.Toplam Kayıt'>:#attributes.totalrecords# &nbsp;-&nbsp;<cf_get_lang_main no='169.Sayfa'>:#attributes.page#/#lastpage#</cfoutput></td>
			<!-- sil -->
		</tr>
	</table>
</cfif>
<script language="javascript">
	document.search_list.lot_number.select();
	function tumu()
	{
		document.getElementById("all_info").value = 1;
		alert("<cf_get_lang_main no='3109.Bugün İstasyonuna Atanan Tüm İşlerini Göreceksin'>");
		document.getElementById("search_list").submit();
	}
	function delete_control()
	{
		sor = confirm('<cf_get_lang_main no='3110.Üretim İçin Sonuç Girmeden Çıkmak İstediğinizden Emin misiniz'>?');
		if(sor==true)
		window.location.href='<cfoutput>#request.self#?fuseaction=production.upd_ezgi_station_employee_exit&station_id=#attributes.station_id#&employee_id=#attributes.employee_id#&p_operation_id=#get_employee_durum.p_operation_id#</cfoutput>';
	}
	function prod_pause(tkey)
	{
		<cfoutput>
			var station_id = #station_id#;
			var employee_id = #employee_id#;
			var pause_cat = #pause_cat#
		</cfoutput>
		if(pause_cat==0)
		{
			if(tkey==1||tkey==2||tkey==3)
			{
				windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=production.popup_form_add_ezgi_prod_pause&station_id_='+station_id+'&employee_id_='+employee_id+'&type_id='+tkey,'small');
			}
		}
		else
		{
			windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=production.emptypopup_add_ezgi_prod_pause&station_id='+station_id+'&employee_id='+employee_id+'&pause_cat='+pause_cat,'small');	
		}
	}
</script>