<cfset fuseaction_ = ListGetAt(attributes.fuseaction,2,'.')>
<cfparam name="authority_station_id_list" default="0">
<cfparam name="attributes.lot_number" default="">
<cfparam name="attributes.start_date" default="">
<cfparam name="attributes.finish_date" default="">
<cfparam name="attributes.is_form_submitted" default="">
<cfparam name="attributes.station_id" default="">
<cfif isdefined('attributes.start_date') and isdate(attributes.start_date)>
  	<cf_date tarih='attributes.start_date'>
<cfelse>
  	<cfset attributes.start_date= wrk_get_today()>
</cfif>
<cfif isdefined('attributes.new_employee')>
	<cfset add_employee = 1>
	<cfinclude template="../query/add_ezgi_station_employee.cfm">
</cfif>
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
            PRODUCTION_LEVEL, 
            IS_STAGE, 
            START_DATE, 
            STOCK_CODE, 
            SPEC_MAIN_ID, 
            STOCK_ID, 
            PRODUCT_ID, 
            PRODUCT_NAME, 
            SPECT_VAR_NAME, 
            QUANTITY, 
            P_OPERATION_ID, 
            OPERATION_TYPE_ID, 
            OPERATION_CODE, 
            OPERATION_TYPE, 
            AMOUNT, 
            STAGE, 
            STATION_ID, 
            REAL_TIME, 
            WAIT_TIME, 
            ACTION_EMPLOYEE_ID, 
            ACTION_START_DATE, 
            ISNULL(REAL_AMOUNT,0) REAL_AMOUNT, 
            ISNULL(LOSS_AMOUNT,0) LOSS_AMOUNT, 
            STATION_NAME, 
            O_START_DATE,
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
          	,0) ROW_RESULT_AMOUNT
		FROM         
        	EZGI_OPERATION_M
      	WHERE
        	OPERATION_TYPE_ID IN
                          		(	
                                SELECT     	
                                	OPERATION_TYPE_ID
                            	FROM      	
                                	WORKSTATIONS_PRODUCTS
                            	WHERE      	
                                	WS_ID = #station_id# AND 
                                 	STOCK_ID IS NULL AND 
                                   	OPERATION_TYPE_ID IS NOT NULL
                             	) AND 
    		IS_STAGE IN (0,1,2,3,4)
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
               	REAL_TIME IS NULL AND 
               	WAIT_TIME IS NULL
        	</cfif>
		ORDER BY
        	P_ORDER_NO DESC ,
            OPERATION_TYPE            
    </cfquery>
<cfelse>
	<cfset GET_PO_DET.recordcount = 0>
</cfif>
<!---<cfdump expand="yes" var="#GET_PO_DET#"><cfabort>--->
<cfparam name="attributes.page" default=1>
<cfparam name="attributes.maxrows" default='#session.ep.maxrows#'>
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
    	EZGI_OPERATION_S
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
</style>
<table width="98%" align="center" border="0">
	<tr>
		<!---<td class="headbold" height="30" style="font-size:18px;">Üretim Emirleri</td>--->
		<cfform name="search_list" action="#request.self#?fuseaction=production.#fuseaction_#" method="post">
			<input type="hidden" name="is_form_submitted" value="1">
            <cfoutput>
                <input type="hidden" name="station_id" value="#station_id#">
                <input type="hidden" name="employee_id" value="#employee_id#">
            </cfoutput>
            <cfset link_back = "#request.self#?fuseaction=production.emptypopup_list_production_orders&is_form_submitted=1&start_date=#DateFormat(date_add("d",-1,attributes.start_date),"dd/mm/yyyy")#&station_id=#station_id#&employee_id=#employee_id#">
			<cfset link_next = "#request.self#?fuseaction=production.emptypopup_list_production_orders&is_form_submitted=1&start_date=#DateFormat(date_add("d",1,attributes.start_date),"dd/mm/yyyy")#&station_id=#station_id#&employee_id=#employee_id#">
			<td style="text-align:right">
				<table width="100%">
					<tr>
                    	<td align="right" width="500px">
                        	<cfif get_employee_durum.recordcount and get_employee_durum.REAL_AMOUNT eq 0>
                            	<img src="images/production/calisiyor_1.png" onmousedown="this.src='images/production/calisiyor_2.png';" onmouseout="this.src='images/production/calisiyor_1.png';" border="0" onclick="delete_control()"/>
                            <cfelse>
                            	<cfif pause_cat eq 0>
                            		<a href=<cfoutput>"#request.self#?fuseaction=production.upd_ezgi_station_employee&station_id=#attributes.station_id#&employee_id=#attributes.employee_id#&upd_employee=1</cfoutput>">
                            		<img src="images/production/k_degistir1.png" onmousedown="this.src='images/production/k_degistir2.png';" onmouseout="this.src='images/production/k_degistir1.png';" border="0" />
                                	</a>
                               	<cfelse>
                                	<img src="images/production/k_bos.png"  border="0" />
                                </cfif>
                                <cfif pause_cat eq 3 or pause_cat eq 0>
                                 	<a href="javascript://" onclick="prod_pause(3);"><img src="images/production/k_ariza1.png" onmousedown="this.src='images/production/k_ariza2.png';" onmouseout="this.src='images/production/k_ariza1.png';" border="0" /></a>
                              	<cfelse>
                                  	<img src="images/production/k_bos.png" border="0" />
                              	</cfif>
                                <cfif pause_cat eq 1 or pause_cat eq 0>
                                  	<a href="javascript://" onclick="prod_pause(1);"><img src="images/production/k_mola1.png" onmousedown="this.src='images/production/k_mola2.png';" onmouseout="this.src='images/production/k_mola1.png';" border="0" /></a>
                              	<cfelse>
                                  	<img src="images/production/k_bos.png" border="0" />
                               	</cfif>
                                <cfif pause_cat eq 2 or pause_cat eq 0>
                                 	<a href="javascript://" onclick="prod_pause(2);"><img src="images/production/k_duraklama1.png" onmousedown="this.src='images/production/k_duraklama2.png';" onmouseout="this.src='images/production/k_duraklama1.png';" border="0" /></a>
                               	<cfelse>
                                  	<img src="images/production/k_bos.png" border="0" />
                               	</cfif>
                            </cfif>
                        </td>
						<td align="right" width="650px" style= "font-size:16px; font-weight:bold"><cfoutput>#get_workstation_name.station_name# - #get_emp_info(employee_id,0,0)#</cfoutput></td>
                        <td></td>
						<td align="right" width="110px" style= "font-size:16px; font-weight:bold"><cf_get_lang_main no='1456.İş Emri'> No </td>
						<td align="right" width="150px"><input name="lot_number" id="lot_number"  type="text" value="" onKeyDown="if(event.keyCode == 13) {return location_production_detail(trim(this.value));}" style="width:140px; height:40px; font-size:24px; font-weight:bold"></td>
						<td></td>
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
					<td class="box_yazi" style="text-align:center" width="15%">O<cf_get_lang_main no='1622.Operasyon'></td>
					<td class="box_yazi" style="text-align:center" width="4%"><cf_get_lang_main no='223.Miktar'></td>
                    <td class="box_yazi" style="text-align:center" width="4%"><cf_get_lang_main no='1674.Fire'></td>
                    <td class="box_yazi" style="text-align:center" width="4%"><cf_get_lang_main no='3105.Biten'></td>
					<td class="box_yazi" style="text-align:center" width="4%"><cf_get_lang_main no='1032.Kalan'></td>
                    <td class="box_yazi" style="text-align:center" width="3%">OP.</td>
                    <td class="box_yazi" style="text-align:center" width="3%">IE.</td>
				</tr>
				<!---<cfif get_po_det.recordcount>--->
					<cfoutput query="get_po_det" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">
						<tr height="50" onMouseOver="this.className='color-light';" onMouseOut="this.className='color-row';" class="color-row">
							<td class="box_yazi_td" style="text-align:center">
                            	<cfif OPERATION_GRUP_ID gt 0 and OPERATION_GRUP_ID eq get_employee_durum_gurup.OPERATION_GRUP_ID>
                            	<!---<a href="#request.self#?fuseaction=production.emptypopup_add_ezgi_production_order&upd=#p_order_id#&station_id=#attributes.station_id#&employee_id=#attributes.employee_id#&p_operation_id=#P_OPERATION_ID#&start_date=#Dateformat(attributes.start_date,'DD/MM/YYYY')#" style="font-size:14px" class="tableyazi"><img src="/images/production/coz1.png" title="Başlamak İçin Basınız"></a>--->
                                <cfelse>
                                	&nbsp;#currentrow#
                                </cfif>
                            </td>
							<td class="box_yazi_td">&nbsp;#DateFormat(START_DATE,'dd/mm/yyyy')#</td>
							<td class="box_yazi_td">&nbsp;#P_ORDER_NO#</td>
							<td class="box_yazi_td" style="text-align:center;">
                            	<cfif pause_cat eq 0>
                            	<cfif (get_employee_durum.recordcount and not ListContains(p_operation_id_list,P_OPERATION_ID,',') and STAGE neq 3 and OPERATION_GRUP_ID eq 0) and ezgi_operation_gurup_id_durum eq 1>
                                	<span style=" font-size:10px"><cf_get_lang_main no='3106.Grup Sonlandırma Bitmeden Yeni Üretime Başlamayın></span>
                            	<cfelseif (get_employee_durum.recordcount and not ListContains(p_operation_id_list,P_OPERATION_ID,',') and STAGE neq 3 and OPERATION_GRUP_ID eq 0) ><!---and ezgi_operation_gurup_id_durum eq 0--->
                                	<a href="#request.self#?fuseaction=production.add_ezgi_production_order&upd=#p_order_id#&station_id=#attributes.station_id#&employee_id=#attributes.employee_id#&p_operation_id=#P_OPERATION_ID#&operation_gurup_id=#ezgi_operation_gurup_id#" style="font-size:14px" class="tableyazi"><img src="/images/production/gurupla1.png" title="Başlamak İçin Basınız">
                                	</a>
                              	<cfelseif (get_employee_durum.recordcount and ListContains(p_operation_id_list,P_OPERATION_ID,',') and STAGE neq 3 and OPERATION_GRUP_ID gt 0)>
                                <a href="#request.self#?fuseaction=production.add_ezgi_production_order&upd=#p_order_id#&station_id=#attributes.station_id#&employee_id=#attributes.employee_id#&p_operation_id=#P_OPERATION_ID#&operation_gurup_id=#ezgi_operation_gurup_id#" style="font-size:14px" class="tableyazi"><img src="/images/production/secin_yesil_1.png" title="Başlamak İçin Basınız">
                                </a>
                                
                            	<cfelseif (get_employee_durum.recordcount and ListContains(p_operation_id_list,P_OPERATION_ID,',') and STAGE neq 3) or ACTION_EMPLOYEE_ID eq '' or (real_amount neq 0 or loss_amount neq 0 and stage eq 1)>
                            		<a href="#request.self#?fuseaction=production.add_ezgi_production_order&upd=#p_order_id#&station_id=#attributes.station_id#&employee_id=#attributes.employee_id#&p_operation_id=#P_OPERATION_ID#" style="font-size:14px" class="tableyazi"><img src="/images/production/secin_yesil_1.png" title="Başlamak İçin Basınız">
                                	</a>
                              	<cfelseif (not get_employee_durum.recordcount and ACTION_EMPLOYEE_ID neq attributes.employee_id and STAGE neq 3)> 
                                	<a href="#request.self#?fuseaction=production.add_ezgi_production_order&upd=#p_order_id#&station_id=#attributes.station_id#&employee_id=#attributes.employee_id#&p_operation_id=#P_OPERATION_ID#" style="font-size:14px" class="tableyazi"><img src="/images/production/secin_sari_1.png" title="Başlamak İçin Basınız">
                                	</a>
                                <cfelse>
                                	&nbsp;#get_emp_info(ACTION_EMPLOYEE_ID,0,0)#
                                </cfif>
                                <cfelse>
                                	<img src="/images/production/secin_bos.png" title="Duraklama Halinde">
                                </cfif>
                            </td>
                            <td class="box_yazi_td">&nbsp;#PRODUCT_NAME#</td>
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
									<img src="/images/red_glob.gif" title="<cf_get_lang no ='271.Bitti'>!">
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
				<!---<cfelse>
					<tr height="30" class="color-row"><td colspan="15"><cfif isdefined("attributes.is_form_submitted")>Kayıt Yok!<cfelse>Filtre Ediniz!</cfif></td></tr>
				</cfif>--->
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
					adres="production.#fuseaction_##url_str#">
			</td>
			<!-- sil -->
			<td align="right" style="text-align:right;font-size:14px"><cfoutput><cf_get_lang_main no='128.Toplam Kayıt'>:#attributes.totalrecords# &nbsp;-&nbsp;<cf_get_lang_main no='169.Sayfa'>:#attributes.page#/#lastpage#</cfoutput></td>
			<!-- sil -->
		</tr>
	</table>
</cfif>
<script language="javascript">
	document.search_list.lot_number.select();
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