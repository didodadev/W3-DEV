<cf_get_lang_set module_name="prod">
<cfsetting showdebugoutput="yes">
<cfparam name="attributes.keyword" default="">
<cfparam name="attributes.is_form_submitted" default="">
<cfif len(attributes.is_form_submitted)>
	<cfquery name="get_prod_order" datasource="#dsn3#">
    	SELECT
        	*
      	FROM
        	(
            SELECT     	
                    PO.P_ORDER_ID, 
                    S.PRODUCT_CODE, 
                    S.PRODUCT_NAME, 
                    S.STOCK_ID, 
                    S.PRODUCT_ID, 
                    PO.STATION_ID, 
                    PO.START_DATE, 
                    PO.FINISH_DATE,
                    ISNULL(PO.PRINT_COUNT,0) PRINT_COUNT, 
                    PO.QUANTITY, 
                    PO.STATUS, 
                    PO.P_ORDER_NO, 
                    PO.PO_RELATED_ID, 
                    PO.ORDER_ROW_ID, 
                    PO.SPECT_VAR_NAME,
                    PO.SPECT_VAR_ID, 
                    PO.PROD_ORDER_STAGE, 
                    PO.IS_STOCK_RESERVED, 
                    PO.SPEC_MAIN_ID, 
                    PO.PRODUCTION_LEVEL, 
                    ISNULL(PO.IS_GROUP_LOT,0) IS_GROUP_LOT, 
                    PO.IS_STAGE, 
                    PO.DETAIL,
                    W.STATION_NAME, 
                    W.BRANCH,
                    PTR.STAGE,
                    ISNULL(PTIP.PROPERTY2, 0) AS PRODUCT_POINT,
                    ISNULL(PTIP.PROPERTY2, 0)*PO.QUANTITY as P_ORDER_POINT,
                    (
                    SELECT     
                        S1.PRODUCT_NAME
                    FROM         
                        PRODUCTION_ORDERS AS PO1 INNER JOIN
                        STOCKS AS S1 ON PO1.STOCK_ID = S1.STOCK_ID
                    WHERE     
                        PO1.P_ORDER_ID = PO.PO_RELATED_ID
                    ) AS UST_EMIR,
                    CASE 
                        WHEN LEFT(PO.LOT_NO,1) = '-' THEN SUBSTRING(PO.LOT_NO,2,LEN(PO.LOT_NO)-1)
                        ELSE PO.LOT_NO
                    END 
                        LOT_NO,
                    O.ORDER_ID, 
                    O.ORDER_NUMBER, 
                    O.ORDER_DATE, 
                    O.ORDER_STATUS, 
                    O.DELIVERDATE,
                    O.IS_INSTALMENT,
                    CASE
                        WHEN O.COMPANY_ID IS NOT NULL THEN
                       (
                        SELECT     
                            NICKNAME
                        FROM         
                            #dsn_alias#.COMPANY
                        WHERE     
                            COMPANY_ID = O.COMPANY_ID
                        )
                        WHEN O.CONSUMER_ID IS NOT NULL THEN      
                        (	
                        SELECT     
                            CONSUMER_NAME + ' ' + CONSUMER_SURNAME AS ISIM
                        FROM         
                            #dsn_alias#.CONSUMER
                        WHERE     
                            CONSUMER_ID = O.CONSUMER_ID
                        )
                        WHEN O.EMPLOYEE_ID IS NOT NULL THEN
                        (
                        SELECT     
                            EMPLOYEE_NAME + ' ' + EMPLOYEE_SURNAME AS ISIM
                        FROM         
                            #dsn_alias#.EMPLOYEES
                        WHERE     
                            EMPLOYEE_ID = O.EMPLOYEE_ID
                        )
                        ELSE      
                            'Stok Üretim'
                        END
                            AS UNVAN,
                    (
                        SELECT     
                            MASTER_ALT_PLAN_NO
                        FROM         
                            EZGI_MASTER_ALT_PLAN
                        WHERE     
                            MASTER_ALT_PLAN_ID = EMPR.MASTER_ALT_PLAN_ID
                    ) AS MASTER_ALT_PLAN_NO,
                    (
                        SELECT     
                            MASTER_PLAN_ID
                        FROM         
                            EZGI_MASTER_ALT_PLAN
                        WHERE     
                            MASTER_ALT_PLAN_ID = EMPR.MASTER_ALT_PLAN_ID
                    ) AS MASTER_PLAN_ID,
                    (
                        SELECT     
                            PROCESS_ID
                        FROM         
                            EZGI_MASTER_ALT_PLAN
                        WHERE     
                            MASTER_ALT_PLAN_ID = EMPR.MASTER_ALT_PLAN_ID
                    ) AS PROCESS_ID,
                    EMPR.MASTER_ALT_PLAN_ID 
            FROM      	
                    ORDERS AS O INNER JOIN
                    ORDER_ROW AS ORR ON O.ORDER_ID = ORR.ORDER_ID INNER JOIN
                    PRODUCTION_ORDERS_ROW AS POR ON ORR.ORDER_ROW_ID = POR.ORDER_ROW_ID RIGHT OUTER JOIN
                    STOCKS AS S INNER JOIN
                    PRODUCTION_ORDERS AS PO ON S.STOCK_ID = PO.STOCK_ID INNER JOIN
                    WORKSTATIONS AS W ON PO.STATION_ID = W.STATION_ID INNER JOIN
                    #dsn_alias#.PROCESS_TYPE_ROWS AS PTR ON PO.PROD_ORDER_STAGE = PTR.PROCESS_ROW_ID INNER JOIN
                    EZGI_MASTER_PLAN_RELATIONS AS EMPR ON PO.P_ORDER_ID = EMPR.P_ORDER_ID ON POR.PRODUCTION_ORDER_ID = PO.P_ORDER_ID LEFT OUTER JOIN
                    PRODUCT_TREE_INFO_PLUS AS PTIP ON S.STOCK_ID = PTIP.STOCK_ID
      		) AS TBL
      	WHERE     	
       		LOT_NO LIKE '%#attributes.keyword#%' OR
      		P_ORDER_NO LIKE '%#attributes.keyword#%' OR
        	ORDER_NUMBER LIKE '%#attributes.keyword#%' OR
            UNVAN LIKE '%#attributes.keyword#%' OR
            PRODUCT_NAME LIKE '%#attributes.keyword#%'
		ORDER BY 	
    		DELIVERDATE
	</cfquery>
    <cfset control_list=Valuelist(get_prod_order.P_ORDER_ID)>
    <cfquery name="order_group_control" dbtype="query">
        SELECT SPEC_MAIN_ID FROM GET_PROD_ORDER WHERE IS_STAGE <> 1 AND IS_STAGE <> 2 GROUP BY SPEC_MAIN_ID HAVING (COUNT(*) > 1)
    </cfquery>
    <cfquery name="order_related_control" dbtype="query">
        SELECT SPEC_MAIN_ID FROM GET_PROD_ORDER WHERE PO_RELATED_ID IS NOT NULL
    </cfquery>
    <cfquery name="p_order_is_group_control" dbtype="query">
        SELECT P_ORDER_ID FROM GET_PROD_ORDER WHERE IS_GROUP_LOT = 0 AND IS_STAGE <> 1 AND IS_STAGE <> 2
    </cfquery>
    <cfquery name="get_row_say" dbtype="query">
        SELECT LOT_NO, COUNT(*) AS ROWSAY FROM GET_PROD_ORDER GROUP BY LOT_NO
    </cfquery>
<cfelse>
	<cfset arama_yapilmali=1>
</cfif>

<cfform name="search_product" method="post" action="#request.self#?fuseaction=#url.fuseaction#">
	<input name="is_form_submitted" id="is_form_submitted" type="hidden" value="1">
    <cf_big_list_search title="<cf_get_lang_main no='3318.Hızlı İş Emri Arama'>" collapsed="1">
        <cf_big_list_search_area>
            <table>
                <tr>
                    <td width="35"></td>
                    <td width="50">
                    	
                    </td>
                    <td></td>
                    <td width="300"><cf_get_lang_main no='48.Filtre'> 
                    	<cfinput name="keyword" value="#attributes.keyword#" type="text" style="width:60">
					</td>
					<!-- sil -->
					<td><cf_wrk_search_button> <cf_workcube_file_action pdf='1' mail='1' doc='1' print='1'></td>
                    <!-- sil -->
                </tr>
            </table>
        </cf_big_list_search_area>
    </cf_big_list_search>

    <cf_big_list id="list_product_big_list">
        <thead>
            <tr>
                <th width="35"></th>
                <th width="70"><cf_get_lang_main no='3212.Alt Plan'> No</th>
                <th width="60"><cf_get_lang_main no='1677.Emir No'></th>
                <th width="60"><cf_get_lang_main no='799.Sipariş No'></th>
                <th width="60"><cf_get_lang_main no='1704.Sipariş Tarihi'></th>
                <th width="60"><cf_get_lang_main no='3093.Termin Tarihi'></th>
                <th width="60">Lot No</th>
                <th><cf_get_lang_main no='649.Cari'> <cf_get_lang_main no='159.Ünvan'></th>
                <th><cf_get_lang_main no='245.Ürün'></th>
                <th width="90">Spec</th>
                <th width="60"><cf_get_lang_main no='1447.Süreç'></th>
                <th><cfoutput>#getLang('prod',291)#</cfoutput><br /><cfoutput>#getLang('prod',293)#</cfoutput></th>
                <th width="50"><cf_get_lang_main no='223.Miktar'></th>
                <th width="50"><cf_get_lang_main no='1572.Puan'></th>
                <th width="20">OPT</th>
                <th width="20">MLZ</th>
                <th width="20"></th>
                <th width="20"></th>
            </tr>
        </thead>
        <tbody>
            <cfif len(attributes.is_form_submitted)>
                <cfif get_prod_order.recordcount>
                	<cfset i=1>
                    <cfoutput query="get_prod_order">
                    	<tr height="20" onMouseOver="this.className='color-light';" onMouseOut="this.className='color-row';" class="color-row">
                          	<td>#currentrow#</td>
                            <td align="center"><a href="#request.self#?fuseaction=prod.upd_ezgi_master_sub_plan_manual&master_plan_id=#master_plan_id#&master_alt_plan_id=#master_alt_plan_id#&islem_id=#PROCESS_ID#" class="tableyazi">#MASTER_ALT_PLAN_NO#</a></td>
                           	<td align="center"><a href="#request.self#?fuseaction=prod.order&event=upd&upd=#P_ORDER_ID#" class="tableyazi" target="_blank">#P_ORDER_NO#</a></td>
                           	<cfif is_instalment eq 1>
								<cfset page_type = 'upd_fast_sale'>
                        	<cfelse>
                              	<cfset page_type = 'detail_order'>
                          	</cfif>
                          	<td align="center">
                            	<cfset fuse_type = 'sales'>
                              	<cfif get_prod_order.is_instalment eq 1>
                                  	<cfset page_type = 'list_order_instalment&event=upd'>
                             	<cfelse>
                                	<cfset page_type = 'list_order&event=upd'>
                             	</cfif>
                                <cfif len(get_prod_order.order_id)>
                                    <a href="javascript://" onclick="windowopen('#request.self#?fuseaction=#fuse_type#.#page_type#&order_id=#get_prod_order.order_id#','longpage');" class="tableyazi" title="Satış Siparişine Git">
                                        #ORDER_NUMBER#
                                    </a>
                                <cfelse>
                                
                                </cfif>
                            </td>
                         	<td align="center">#DateFormat(ORDER_DATE,'DD/MM/YYYY')#</td>
                           	<td align="center">#DateFormat(DELIVERDATE,'DD/MM/YYYY')#</td>
                           	<td align="center">#LOT_NO#</td>
                            <td align="center">#unvan#</td>
                         	<td><a href="#request.self#?fuseaction=prod.list_product_tree&event=upd&stock_id=#stock_id#" class="tableyazi">#product_name#</a></td>
                           	<td align="left">
							<cfif len(SPECT_VAR_ID)>
								<a  href="javascript://" onClick="windowopen('#request.self#?fuseaction=objects.popup_upd_spect&id=#SPECT_VAR_ID#&stock_id=#stock_id#','list');" class="tableyazi">#spec_main_id#-#spect_var_id#</a>	
							</cfif>
                          	</td>
                         	<td align="center">#STAGE#</td>
                         	<td align="center" nowrap>#DateFormat(start_date,'DD/MM/YYYY')#<br />#DateFormat(finish_date,'DD/MM/YYYY')#</td>
                          	<td style="text-align:right">#TlFormat(QUANTITY,2)#</td>
                          	<td style="text-align:right">#TlFormat(P_ORDER_POINT,2)#</td>
                          		<cfquery name="get_kontrol_0" datasource="#dsn3#"> <!---Optimizasyona ve Var-yok a giren emirler soruluyor--->
                                  	SELECT DISTINCT 
                                      	POS.STOCK_ID, 
                                       	POS.AMOUNT,
                                       	EMC.STATUS
                                 	FROM         
                                    	EZGI_METARIAL_CONTROL AS EMC INNER JOIN
                                       	PRODUCTION_ORDERS_STOCKS AS POS ON EMC.POR_STOCK_ID = POS.POR_STOCK_ID
                                  	WHERE     
                                     	EMC.LOT_NO = N'#lot_no#' 
                                  	</cfquery>
                                            <cfquery name="get_kontrol_1" dbtype="query"> <!---Var Denilenler Bulunuyor--->
                                                SELECT
                                                    STOCK_ID, 
                                                    AMOUNT
                                                FROM         
                                                    get_kontrol_0
                                                WHERE     
                                                    STATUS = 1
                                            </cfquery>
                                            <cfquery name="get_kontrol_2" dbtype="query"> <!---Yok Denilenler Bulunuyor--->
                                                SELECT
                                                    STOCK_ID, 
                                                    AMOUNT
                                                FROM         
                                                    get_kontrol_0
                                                WHERE     
                                                    STATUS = 2
                                            </cfquery>
                                            <cfquery name="get_ezgi_metarial_control" dbtype="query"> <!---Yok Denilenler Guruplanıyor--->
                                                SELECT
                                                    STOCK_ID, 
                                                    SUM(AMOUNT) AS AMOUNT
                                                FROM         
                                                    get_kontrol_2
                                                GROUP BY 
                                                    STOCK_ID
                                            </cfquery>
                                           <cfquery name="get_ezgi_metarial_control_0" dbtype="query"> <!---Optimizasyondan Geçen heşey guruplanıyor--->
                                                SELECT
                                                    STOCK_ID, 
                                                    SUM(AMOUNT) AS AMOUNT
                                                FROM         
                                                    get_kontrol_0
                                                GROUP BY 
                                                    STOCK_ID
                                            </cfquery>
                                            <cfloop query="get_ezgi_metarial_control_0">
                                                <cfset 'CONTROL_#get_prod_order.lot_no#_#get_ezgi_metarial_control_0.STOCK_ID#'= get_ezgi_metarial_control_0.AMOUNT>
                                            </cfloop>
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
                                                   	EMR.LOT_NO = N'#lot_no#' AND
                                                    IR.STOCK_ID IN 
                                                    				(
                                                                	SELECT     
                                                                   		STOCK_ID
																	FROM         
                                                                     	STOCKS
																	WHERE     
                                                                     	STOCK_CODE LIKE N'01.150.07%'
                                                                  	)
                                          	</cfquery>
                                            
                                            <cfquery name="get_period" datasource="#dsn3#">
                                                SELECT     
                                                    PERIOD_ID
                                                FROM         
                                                    EZGI_METARIAL_RELATIONS
                                                WHERE     
                                                    TYPE = 2 AND 
                                                    LOT_NO = '#lot_no#'
                                            </cfquery>
                                            <cfset teslim = 0>
                                            <cfset teslim_1 = 0>
                                            <cfif get_period.recordcount>
                                                <cfset period_list = ValueList(get_period.PERIOD_ID)>
                                                <cfquery name="get_period_ship_dsns" datasource="#dsn3#">
                                                    SELECT PERIOD_YEAR,OUR_COMPANY_ID,PERIOD_ID FROM #dsn_alias#.SETUP_PERIOD WHERE PERIOD_ID IN (#period_list#)
                                                </cfquery>
                                            </cfif>
                                            <cfif isdefined('period_list') and listlen(period_list) and period_list neq 0>
                                                <cfquery name="get_control_ambar_fis" datasource="#DSN3#">
                                                    SELECT 
                                                        STOCK_ID,
                                                        SUM(AMOUNT) AMOUNT
                                                    FROM
                                                        (
                                                        <cfloop query="get_period_ship_dsns">
                                                            SELECT     
                                                                SFR.STOCK_ID, 
                                                                SFR.AMOUNT
                                                            FROM         
                                                                EZGI_METARIAL_RELATIONS INNER JOIN
                                                                #dsn#_#get_period_ship_dsns.PERIOD_YEAR#_#get_period_ship_dsns.OUR_COMPANY_ID#.dbo.STOCK_FIS_ROW AS SFR ON EZGI_METARIAL_RELATIONS.ACTION_ID = SFR.FIS_ID
                                                            WHERE     
                                                                EZGI_METARIAL_RELATIONS.TYPE = 2 AND 
                                                                EZGI_METARIAL_RELATIONS.PERIOD_ID = #get_period_ship_dsns.period_id# AND 
                                                                EZGI_METARIAL_RELATIONS.LOT_NO = N'#get_prod_order.lot_no#' AND
                                                                SFR.STOCK_ID IN (
                                                                				SELECT     
                                                                                	STOCK_ID
																				FROM         
                                                                                	STOCKS
																				WHERE     
                                                                                	STOCK_CODE LIKE N'01.150.07%'
                                                                              	)
                                                            <cfif currentrow neq get_period_ship_dsns.recordcount> UNION ALL </cfif> 
                                                        </cfloop>
                                                        ) TBL
                                                    GROUP BY
                                                        STOCK_ID 			
                                                </cfquery>
                                                <cfif get_control_ambar_fis.recordcount>
													<cfif get_control_ambar_fis.recordcount neq get_ezgi_metarial_control_0.recordcount>
                                                        <cfset teslim = 2>		
                                                    <cfelse>
                                                        <cfset teslim = 1>
                                                    </cfif>
                                            	<cfelse>
                                            		<cfset teslim = 0>
                                            	</cfif>
                                            </cfif>
                                        	<td align="center">
                                            	<cfif get_kontrol_0.recordcount eq 0>
                                                    <a  href="javascript://" onClick="windowopen('#request.self#?fuseaction=prod.popup_add_ezgi_metarial_control&lot_no=#LOT_NO#','page');"> <img src="/images/offlineuser.gif" tittle="<cf_get_lang_main no='3319.Optimizasyon Onay Verilmedi'>" border="0">
                                              		</a>
                                               	<cfelse>
                                                	<a  href="javascript://" onClick="windowopen('#request.self#?fuseaction=prod.popup_add_ezgi_metarial_control&lot_no=#LOT_NO#','page');"> 
                                                	 <img src="/images/onlineuser_1.gif" tittle="<cf_get_lang_main no='3320.Optimizasyon Onay Verildi'>">
                                                     </a>
                                              	</cfif> 
                                            </td>
                                            <td align="center">
                                            	<cfif get_kontrol_0.recordcount>
                                                	
														<cfif get_kontrol_1.recordcount neq get_kontrol_0.recordcount>	
                                                            <cfif get_ic_talep.recordcount eq 0>
                                                                <a  href="javascript://" onClick="windowopen('#request.self#?fuseaction=prod.popup_add_ezgi_metarial_control&lot_no=#LOT_NO#','page');"> <img src="/images/offlineuser.gif" tittle="<cf_get_lang_main no='3321.İç Talep Verilmedi'>">
                                                                </a>
                                                            <cfelse>
                                                                <cfif get_ic_talep.recordcount neq get_ezgi_metarial_control.recordcount>
                                                                    <a  href="javascript://" onClick="windowopen('#request.self#?fuseaction=prod.popup_add_ezgi_metarial_control&lot_no=#LOT_NO#','page');"> <img src="/images/onlineuser.gif" tittle="<cf_get_lang_main no='3322.İç Talep Eksik Verildi'>">
                                                                    </a>
                                                                <cfelse>
                                                                	<cfif teslim eq 0>
                                                                    	<a  href="javascript://" onClick="windowopen('#request.self#?fuseaction=prod.emptypopup_add_ezgi_metarial_ambar_fisi&lot_no=#LOT_NO#','page');"> <img src="/images/onlineuser_2.gif" tittle="<cf_get_lang_main no='3323.İç Talep Tam Verildi'>">
                                                                    	</a>
                                                                  	<cfelseif teslim eq 1>
                                                                    	<a  href="javascript://" onClick="windowopen('#request.self#?fuseaction=prod.emptypopup_add_ezgi_metarial_ambar_fisi&lot_no=#LOT_NO#','page');">
                                                                        <img src="/images/onlineuser_1.gif" tittle="<cf_get_lang_main no='3324.Tam Ambar Fişi'>">
                                                                        </a>
                                                                    <cfelseif teslim eq 2>
                                                                    	<a  href="javascript://" onClick="windowopen('#request.self#?fuseaction=prod.emptypopup_add_ezgi_metarial_ambar_fisi&lot_no=#LOT_NO#','page');">
                                                                        <img src="/images/onlineuser_3.gif" tittle="<cf_get_lang_main no='3325.Eksik Ambar Fişi'>">
                                                                        </a>
                                                                    </cfif>      
                                                                </cfif>
                                                            </cfif>
                                                        <cfelse>
                                                        	<cfif teslim eq 0>
                                                            <a  href="javascript://" onClick="windowopen('#request.self#?fuseaction=prod.emptypopup_add_ezgi_metarial_ambar_fisi&lot_no=#LOT_NO#','page');"> <img src="/images/onlineuser_2.gif" tittle="<cf_get_lang_main no='3326.Kumaşlar Mevcut'>">
                                                            </a>
                                                            <cfelseif teslim eq 1>
                                                            	<a  href="javascript://" onClick="windowopen('#request.self#?fuseaction=prod.emptypopup_add_ezgi_metarial_ambar_fisi&lot_no=#LOT_NO#','page');">
                                                            	<img src="/images/onlineuser_1.gif" tittle="<cf_get_lang_main no='3324.Tam Ambar Fişi'>">
                                                                </a>
                                                            <cfelseif teslim eq 2>
                                                            	<a  href="javascript://" onClick="windowopen('#request.self#?fuseaction=prod.emptypopup_add_ezgi_metarial_ambar_fisi&lot_no=#LOT_NO#','page');">
                                                            	<img src="/images/onlineuser_3.gif" tittle="<cf_get_lang_main no='3325.Eksik Ambar Fişi'>">
                                                                </a>
                                                            </cfif>
                                                        </cfif>
                                              	</cfif>              
                                            </td>
                                       	<td align="center">
                                        	<a href="javascript://" onclick="windowopen('#request.self#?fuseaction=prod.popup_add_ezgi_iflow_production_order_result&p_order_id=#get_prod_order.p_order_id#','small');"><img src="/images/plus_list.gif" title="<cf_get_lang_main no='170.Ekle'>"></a>
                                        </td>
                                        <td align="center">
                                        	<a href="javascript://" onclick="windowopen('#request.self#?fuseaction=objects.popup_print_files&print_type=281&iid=#get_prod_order.P_ORDER_ID#&master_alt_plan_id=#get_prod_order.MASTER_ALT_PLAN_ID#','wide');">
											<cfif IS_STAGE eq 4>
												<cfif IS_GROUP_LOT eq 1>
                                                     <img src="/images/g_blue_glob.gif" title="<cf_get_lang no ='579.Gruplandı Fakat Operatöre Gönderilmedi'>">
                                                <cfelse>
                                                     <img src="/images/blue_glob.gif" title="<cf_get_lang no ='270.Başlamadı'>">
                                                </cfif>       
                                            <cfelseif IS_STAGE eq 0>
                                                <img src="/images/yellow_glob.gif" title="<cf_get_lang no ='578.Operatöre Gönderildi'>">
                                            <cfelseif IS_STAGE eq 1>
                                                <img src="/images/green_glob.gif" title="<cf_get_lang no ='577.Başladı'>">
                                            <cfelseif IS_STAGE eq 2>
                                                <img src="/images/red_glob.gif" title="<cf_get_lang no ='271.Bitti'>">
                                            <cfelseif IS_STAGE eq 3>
                                                <img src="/images/grey_glob.gif" title="<cf_get_lang no ='270.Başlamadı'>">
                                            </cfif>
                                            </a>
                                      	</td>
                                    </tr>
                                </cfoutput>
                            <cfelse>
                            	<tr>
                            		<td class="color-row" colspan="18"><cf_get_lang_main no='3327.Emir Bulunamadı'> !</td>
                            	</tr>
                            </cfif>
            <cfelse>
                <tr> 
                    <td colspan="18" height="20"><cf_get_lang_main no='3328.Lütfen Lot No Giriniz'> !</td>
                </tr>
            </cfif>
        </tbody>
    </cf_big_list>
</cfform>