<cf_get_lang_set module_name="prod">
<cfsetting showdebugoutput="yes">
<cfparam name="attributes.keyword" default="">
<cfparam name="attributes.page" default=1>
<cfparam name="attributes.lot_no" default="">
<cfparam name="attributes.product_name" default="">
<cfparam name="attributes.deliverdate" default=0>
<cfparam name="attributes.operasyon" default="">
<cfparam name="attributes.durum" default="">
<cfparam name="attributes.master_plan_id" default="">
<cfparam name="attributes.stock_id" default="">
<cfparam name="attributes.list_type" default="1">
<cfparam name="attributes.is_form_submitted" default="">
<cfparam name="attributes._miktar" default="1">
<cfif not (isDefined('attributes.maxrows') and isNumeric(attributes.maxrows))>
  <cfset attributes.maxrows = session.ep.maxrows>
</cfif>
<cfset attributes.startrow=((attributes.page-1)*attributes.maxrows)+1>
<cfquery name="get_shift_id" datasource="#dsn3#">
	SELECT        
    	MASTER_PLAN_CAT_ID
	FROM            
    	EZGI_MASTER_PLAN
	WHERE        
    	MASTER_PLAN_ID = #attributes.master_plan_id#
</cfquery>
<cfset attributes.shift_id = #get_shift_id.MASTER_PLAN_CAT_ID#>
<cfquery name="get_User_Process_Cat" datasource="#dsn3#">
    SELECT
        TOP (1)
        SPC.PROCESS_CAT_ID	
    FROM
		SETUP_PROCESS_CAT_ROWS AS SPCR,
		SETUP_PROCESS_CAT_FUSENAME AS SPCF,
		#dsn_alias#.EMPLOYEE_POSITIONS AS EP,
		SETUP_PROCESS_CAT SPC
	WHERE
		SPC.PROCESS_CAT_ID = SPCR.PROCESS_CAT_ID AND
		SPC.PROCESS_CAT_ID = SPCF.PROCESS_CAT_ID AND
		SPC.PROCESS_MODULE IN (26) AND
        SPC.PROCESS_TYPE = 171 AND
		EP.POSITION_CODE = #session.ep.position_code# AND
		(
			SPCR.POSITION_CODE = EP.POSITION_CODE OR
			SPCR.POSITION_CAT_ID = EP.POSITION_CAT_ID
		) AND
		SPCF.FUSE_NAME = '#url.fuseaction#'
</cfquery> 
<cfif get_User_Process_Cat.recordcount>
	<cfset process_cat = get_User_Process_Cat.PROCESS_CAT_ID>
<cfelse>
	<script type="text/javascript">
		alert("<cf_get_lang_main no='3136.İşlem Kategorisi Tanımlayınız!'>!");
		window.close()
	</script>
	<cfabort>
</cfif>
<cfquery name="get_process_type" datasource="#dsn#">
	SELECT
    	TOP (1)
		PT.PROCESS_ID
	FROM
		PROCESS_TYPE PT,
		PROCESS_TYPE_OUR_COMPANY PTOC
	WHERE
		PT.IS_ACTIVE = 1 AND
		PT.PROCESS_ID = PTOC.PROCESS_ID AND
		PTOC.OUR_COMPANY_ID = #session.ep.company_id# AND
		CAST(PT.FACTION AS NVARCHAR(2500))+',' LIKE '%#url.fuseaction#%' 
	ORDER BY
		PTOC.OUR_COMPANY_ID,
		PT.PROCESS_ID

</cfquery> 
<cfif get_process_type.recordcount>
	<cfset process_stage = get_process_type.PROCESS_ID>
<cfelse>
	<script type="text/javascript">
		alert("<cf_get_lang_main no='3238.Önce Süreç Tanımlayın'> !");
		window.close()
	</script>
	<cfabort>
</cfif>   
<cfquery name="get_master_plans" datasource="#dsn3#">
	SELECT     
    	MASTER_PLAN_ID, 
        MASTER_PLAN_START_DATE, 
        MASTER_PLAN_FINISH_DATE, 
        MASTER_PLAN_NAME, 
        MASTER_PLAN_NUMBER, 
        MASTER_PLAN_DETAIL
	FROM         
    	EZGI_MASTER_PLAN
	WHERE     
    	MASTER_PLAN_PROCESS = 1 AND 
        IS_PROCESS = 1 AND 
        MASTER_PLAN_STATUS = 1 AND 
        MASTER_PLAN_CAT_ID = #attributes.shift_id#
</cfquery>

<cfquery name="get_sub_plans" datasource="#dsn3#">
	SELECT     
    	EMAP.MASTER_ALT_PLAN_ID, 
        EMAP.MASTER_ALT_PLAN_NO, 
        EMAP.PLAN_START_DATE, 
        EMAP.PLAN_FINISH_DATE, 
        EMAP.PLAN_DETAIL
	FROM         
    	EZGI_MASTER_PLAN AS EMP INNER JOIN
      	EZGI_MASTER_ALT_PLAN AS EMAP ON EMP.MASTER_PLAN_ID = EMAP.MASTER_PLAN_ID INNER JOIN
      	EZGI_MASTER_PLAN_SABLON AS EMPS ON EMAP.PROCESS_ID = EMPS.PROCESS_ID
	WHERE    
    	EMP.MASTER_PLAN_PROCESS = 1 AND 
        EMP.IS_PROCESS = 1 AND 
        EMP.MASTER_PLAN_STATUS = 1 AND 
        EMP.MASTER_PLAN_CAT_ID = #attributes.shift_id# AND 
        EMP.MASTER_PLAN_ID = #attributes.master_plan_id# AND 
       	EMPS.SIRA = 1
</cfquery>
<cfif get_sub_plans.recordcount and not len(attributes.sub_plan_id)>
	<cfset attributes.sub_plan_id = get_sub_plans.MASTER_ALT_PLAN_ID>
<cfelse>
	<cfparam name="attributes.sub_plan_id" default="">
</cfif>
<cfquery name="get_sub_plan_stations" datasource="#dsn3#">
	SELECT     
    	MENU_HEAD, 
        PROCESS_ID
	FROM         
    	EZGI_MASTER_PLAN_SABLON AS EMPS
	WHERE     
    	SHIFT_ID = #attributes.shift_id# AND 
        SIRA > 0
	ORDER BY 
    	SIRA
</cfquery>
<cfif len(attributes.is_form_submitted)>
	<cfquery name="get_p_orders" datasource="#dsn3#"> <!---Üretilmemiş veya Yarım Üretilmiş Sanal Operasyonlar Bulunuyor--->
    	SELECT 
        	*
      	FROM
        	(      
            SELECT     
                EMAPPPO.P_ORDER_ID, 
                EMAPPPO.SIRA, 
                EMAPPPO.URETIM_EMIR_MIKTAR, 
                EMAPPPO.URETIM_OPERASYON_MIKTAR, 
                EMAPPPO.URETILEN_OPERASYON, 
                EMAPPPO.URETILEN_EMIR, 
                EMAPPPO.LOT_NO, 
                EMAPPPO.P_ORDER_NO, 
                EMAPPPO.PRODUCT_NAME, 
                EMAPPPO.SPECT_VAR_NAME, 
                EMAPPPO.STOCK_ID, 
                EMAPPPO.PRODUCT_ID, 
                EMAPPPO.SPEC_MAIN_ID, 
                EMAPPPO.STOCK_CODE, 
                EMAPPPO.O_STATION_IP, 
                EMAPPPO.OPERATION_TYPE, 
                EMAPPPO.OPERATION_CODE, 
                EMAPPPO.OPERATION_TYPE_ID, 
                EMAPPPO.P_OPERATION_ID, 
                EMAPPPO.IS_VIRTUAL, 
                ISNULL(TBL_.URETIM_KATSAYI, 1) AS URETIM_KATSAYI,
                ISNULL(TBL_4.STOCK_KATSAYI, 0) AS STOCK_KATSAYI,
                ISNULL(
                    EMAPPPO.URETIM_OPERASYON_MIKTAR - EMAPPPO.URETILEN_OPERASYON 
                ,0) AS KALAN_OPERASYON
            FROM         
                EZGI_MASTER_ALT_PLAN_PRODUCTION_ORDER AS EMAPPPO LEFT OUTER JOIN
                (
                    SELECT     
                        EMAPSN.P_ORDER_ID, 
                        ISNULL(ROUND(MIN(TBL_1.URETILEN_KATSAYI), 2), 1) AS URETIM_KATSAYI
                    FROM          
                        EZGI_MASTER_ALT_PLAN_STOCK_NEED AS EMAPSN LEFT OUTER JOIN
                        (
                            SELECT     
                                SPEC_MAIN_ID, 
                                STOCK_ID, 
                                PRODUCT_ID, 
                                SUM(ALT_URETILEN) / SUM(ALT_EMIR) AS URETILEN_KATSAYI
                            FROM          
                                EZGI_MASTER_ALT_PLAN_PRODUCTED_STOCK AS EMAPPPS
                            WHERE      
                                MASTER_ALT_PLAN_ID = #attributes.sub_plan_id# OR
                                RELATED_MASTER_ALT_PLAN_ID = #attributes.sub_plan_id#
                            GROUP BY 
                                SPEC_MAIN_ID, 
                                STOCK_ID, 
                                PRODUCT_ID
                        ) AS TBL_1 ON EMAPSN.SPECT_MAIN_ID = TBL_1.SPEC_MAIN_ID AND EMAPSN.STOCK_ID = TBL_1.STOCK_ID
                    WHERE      
                        (
                        EMAPSN.MASTER_ALT_PLAN_ID = #attributes.sub_plan_id# AND 
                        EMAPSN.IS_PRODUCTION = 1 AND 
                        EMAPSN.SPECT_MAIN_ID IS NOT NULL
                        ) 
                        OR
                        (
                        EMAPSN.IS_PRODUCTION = 1 AND 
                        EMAPSN.SPECT_MAIN_ID IS NOT NULL AND 
                        EMAPSN.RELATED_MASTER_ALT_PLAN_ID = #attributes.sub_plan_id#
                        )
                    GROUP BY 
                        EMAPSN.P_ORDER_ID
                ) AS TBL_ ON EMAPPPO.P_ORDER_ID = TBL_.P_ORDER_ID LEFT OUTER JOIN
                (
                    SELECT     
                        P_ORDER_ID, 
                        MIN(STOCK_KATSAYI) AS STOCK_KATSAYI
                    FROM          
                        (
                            SELECT     
                                TOP (100) PERCENT EMAPSN.P_ORDER_ID, 
                                EMAPSN.AMOUNT, 
                                ISNULL(GSTSL.PRODUCT_STOCK, 0) AS PRODUCT_STOCK, 
                                EMAPSN.SPECT_MAIN_ID, ISNULL(GSTSL.PRODUCT_STOCK, 0) / EMAPSN.AMOUNT AS STOCK_KATSAYI
                            FROM          
                                EZGI_MASTER_ALT_PLAN_STOCK_NEED AS EMAPSN INNER JOIN
                                PRODUCTION_ORDERS AS PO ON EMAPSN.P_ORDER_ID = PO.P_ORDER_ID LEFT OUTER JOIN
                                #dsn2_alias#.GET_STOCK_LOCATION_SPECT_TOTAL AS GSTSL ON EMAPSN.STOCK_ID = GSTSL.STOCK_ID AND 
                                PO.PRODUCTION_DEP_ID = GSTSL.STORE AND PO.PRODUCTION_LOC_ID = GSTSL.STORE_LOCATION <!---AND 
                                ISNULL(EMAPSN.SPECT_MAIN_ID, 0) = ISNULL(GSTSL.SPECT_VAR_ID, 0)--->
                            WHERE      
                                (
                                EMAPSN.MASTER_ALT_PLAN_ID = #attributes.sub_plan_id#  OR
                                EMAPSN.RELATED_MASTER_ALT_PLAN_ID = #attributes.sub_plan_id#
                                )
                            GROUP BY 
                                EMAPSN.P_ORDER_ID, 
                                EMAPSN.AMOUNT, 
                                GSTSL.PRODUCT_STOCK, 
                                EMAPSN.SPECT_MAIN_ID
                        ) AS TBL_3
                    GROUP BY 
                        P_ORDER_ID
                ) AS TBL_4 ON EMAPPPO.P_ORDER_ID = TBL_4.P_ORDER_ID
            WHERE
            	EMAPPPO.IS_STAGE <>4 AND
                EMAPPPO.SHIFT_ID = #attributes.shift_id#
              	(    
                    (
                    EMAPPPO.RELATED_MASTER_ALT_PLAN_ID = #attributes.sub_plan_id# AND 
                    ISNULL(TBL_.URETIM_KATSAYI, 1) > 0 AND
                    EMAPPPO.URETIM_OPERASYON_MIKTAR - EMAPPPO.URETILEN_OPERASYON > 0
                    ) 
                OR
                    (
                    EMAPPPO.MASTER_ALT_PLAN_ID = #attributes.sub_plan_id# AND 
                    ISNULL(TBL_.URETIM_KATSAYI, 1) > 0 AND
                    EMAPPPO.URETIM_OPERASYON_MIKTAR - EMAPPPO.URETILEN_OPERASYON > 0
                    )
               	)
       		) AS TBL_5
            <cfif len(attributes.proc_type) and attributes.proc_type eq 2>
				WHERE ISNULL(IS_VIRTUAL,0) = 1
			<cfelseif len(attributes.proc_type) and attributes.proc_type eq 1>
            	WHERE ISNULL(IS_VIRTUAL,0) = 0
            </cfif>
      	ORDER BY 
          	SIRA DESC, 
            P_ORDER_ID
	</cfquery>
     
    <cfset arama_yapilmali = 1>      
<cfelse>
	<cfset get_p_orders.recordcount = 0> 
    <cfset arama_yapilmali = 0> 
</cfif>
<!---<cfdump var="#get_p_orders#">--->
<cfform name="search_product" method="post" action="#request.self#?fuseaction=#url.fuseaction#">
	<input name="is_form_submitted" id="is_form_submitted" type="hidden" value="1">
    <input name="type" type="hidden" value="5">
    <cf_big_list_search title="<cf_get_lang_main no='3211.İşlemdeki Operasyonlar'>" collapsed="1">
        <cf_big_list_search_area>
            <table>
                <tr>
                	<td></td>
                    <td align="right" width="60"><cf_get_lang_main no='2838.Master Plan'></td>
                    <td width="260">
                    	<select name="master_plan_id" id="master_plan_id" style=" width:200px" onChange="set_master_plan(this.value)";>
                        	<option value=""><cf_get_lang_main no ='322.Seçiniz'></option>
                            <cfoutput query="get_master_plans">
                            	<option value="#MASTER_PLAN_ID#" <cfif attributes.master_plan_id eq #MASTER_PLAN_ID#>selected</cfif>>#MASTER_PLAN_NUMBER#-#MASTER_PLAN_DETAIL#-#Dateformat(MASTER_PLAN_START_DATE,'DD/MM/YYYY')#-#Dateformat(MASTER_PLAN_FINISH_DATE,'DD/MM/YYYY')#</option>
                            </cfoutput>
                        </select>
                    </td>
                    <td align="right" width="45"><cf_get_lang_main no='3212.Alt Plan'></td>
                    <td width="260">
                        <select name="sub_plan_id" id="sub_plan_id" style=" width:200px" onChange="set_master_sub_plan(this.value)">
                        	<option value="" <cfif attributes.sub_plan_id eq ''>selected</cfif>><cf_get_lang_main no ='322.Seçiniz'></option>
                            <cfoutput query="get_sub_plans">
                            	<option value="#MASTER_ALT_PLAN_ID#" <cfif attributes.sub_plan_id eq #MASTER_ALT_PLAN_ID#>selected</cfif>>#MASTER_ALT_PLAN_NO#-#PLAN_DETAIL#</option>
                            </cfoutput>
                        </select>
                    </td>
                    <td align="right" width="60"><cfoutput>#getLang('prod',278)#</cfoutput></td>
                    <td width="100">
                    	<select name="list_type" style=" width:95px">
							<option value="1" <cfif attributes.list_type eq 1>selected</cfif>>Manuel</option>
                            <option value="2" <cfif attributes.list_type eq 2>selected</cfif>>Auto Pilot</option>
                        </select>
                    </td>
                    <td align="right" width="70"><cf_get_lang_main no='3239.Üretim Tipi'></td>
                    <td width="90">
                    	<select name="proc_type" style=" width:80px">
                        	<option value="0" <cfif attributes.proc_type eq 0>selected</cfif>><cf_get_lang_main no='296.Tümü'></option>
							<option value="1" <cfif attributes.proc_type eq 1>selected</cfif>><cfoutput>#getLang('crm',664)#</cfoutput></option>
                            <option value="2" <cfif attributes.proc_type eq 2>selected</cfif>><cf_get_lang_main no='1515.Sanal'></option>
                        </select>
                    </td>
                    <td width="20">
						<cfsavecontent variable="message"><cf_get_lang_main no='125.Sayi_Hatasi_Mesaj'></cfsavecontent>
						<cfinput type="text" name="maxrows" value="#attributes.maxrows#" required="yes" onKeyUp="isNumber(this)" validate="integer" range="1,999" message="#message#" maxlength="3" style="width:25px;">
					</td>
					<td><cf_wrk_search_button> <cf_workcube_file_action pdf='1' mail='1' doc='1' print='1'></td>
                </tr>
            </table>
        </cf_big_list_search_area>
    </cf_big_list_search>

    <cf_big_list id="list_product_big_list">
        <thead>
            <tr>
                <th style="text-align:center; width:25px"><cf_get_lang_main no='1165.Sıra'></th>
                <th style="text-align:center; width:40px"><cfoutput>#getLang('prod',153)#</cfoutput></th>
                <th style="text-align:center; width:100px"><cf_get_lang_main no='3240.Operasyon Adı'></th>
                <th style="text-align:center; width:70px"><cf_get_lang_main no='1677.Emir No'></th>
                <th style="text-align:center; width:70px"><cfoutput>#getLang('objects',526)#</cfoutput></th>
                <th style="text-align:center; width:90px"><cf_get_lang_main no='106.Stok Kodu'></th>
                <th style="text-align:center;"><cf_get_lang_main no='809.Ürün Adı'></th>
                <th style="text-align:center; width:25px">Ü.K.</th>
                <th style="text-align:center; width:25px">S.K.</th>
                <th style="text-align:center; width:70px"><cf_get_lang_main no='2995.Emir Miktarı'></th>
                <th style="text-align:center; width:70px"><cf_get_lang_main no='1032.Kalan'><br /><cf_get_lang_main no='223.Miktar'></th>
                <th style="text-align:center; width:70px"><cf_get_lang_main no='3515.Üretilecek Miktar'></th>
                <th style="text-align:center; width:25px"></th>
            </tr>
        </thead>
        <tbody>
            <cfif len(attributes.is_form_submitted) and get_p_orders.recordcount gt 0>
				<cfoutput query="get_p_orders">
                	<cfif STOCK_KATSAYI gt 1>
                    	<cfset uretilebilir_operasyon = kalan_operasyon>
                    <cfelseif  STOCK_KATSAYI lte 0>
                    	<cfset uretilebilir_operasyon = 0>
                    <cfelse>
                    	<cfset uretim_stogu = STOCK_KATSAYI * URETIM_EMIR_MIKTAR>
                        <cfif uretim_stogu gt kalan_operasyon>
                        	<cfset uretilebilir_operasyon = kalan_operasyon>
                        <cfelse>
                        	<cfset uretilebilir_operasyon = uretim_stogu>
                        </cfif>
                    </cfif>
                   	<tr>
                        <td style="text-align:right;" nowrap="nowrap">#currentrow#</td>
                        <td style="text-align:center;" nowrap="nowrap">#SIRA#</td>
                        <td style="text-align:center;" nowrap="nowrap">#OPERATION_TYPE#</td>
                        <td style="text-align:center;" nowrap="nowrap">
                            <a  href="javascript://" onClick="windowopen('#request.self#?fuseaction=prod.form_upd_prod_order&upd=#P_ORDER_ID#','longpage');" class="tableyazi" >
                                #P_ORDER_NO#
                            </a>
                        </td>
                        <td style="text-align:center;" nowrap="nowrap">
                            <a  href="javascript://" onClick="windowopen('#request.self#?fuseaction=prod.form_upd_prod_order&upd=#P_ORDER_ID#','longpage');" class="tableyazi" >
                                #LOT_NO#
                            </a>
                        </td>
                        <td style="text-align:center;" nowrap="nowrap">#STOCK_CODE#</td>
                        <td style="text-align:left;" nowrap="nowrap">#PRODUCT_NAME#</td>
                        <td style="text-align:right;" nowrap="nowrap">#AmountFormat(URETIM_KATSAYI,2)#</td>
                        <td style="text-align:right;" nowrap="nowrap">#AmountFormat(STOCK_KATSAYI,2)#</td>
                        <td style="text-align:right;" nowrap="nowrap">#AmountFormat(URETIM_EMIR_MIKTAR)#</td>
                        <td style="text-align:right;" nowrap="nowrap">#AmountFormat(KALAN_OPERASYON)#</td>
                        <td style="text-align:right;" nowrap="nowrap">
                        	<input type="text" name="product_amount_#P_OPERATION_ID#" id="product_amount_#P_OPERATION_ID#" value="#AmountFormat(uretilebilir_operasyon,3)#" class="box" style="width:80px;">
                        </td>
                        <td style="text-align:center;" nowrap="nowrap">
                        	<a href="javascript://" onclick="kontrol(#P_OPERATION_ID#,#O_STATION_IP#,#KALAN_OPERASYON#,#p_order_id#);"><img src="images/action_plus.gif" border="0" /></a>
                        </td>
					</tr>
              	</cfoutput>
                <tfoot>
                    <tr>
                        <td colspan="13" height="20" style="text-align:right">
                        <!---<cfif attributes.list_type eq 2>
							<cfinput type="submit" value="Burası" name="tetik" onFocus="pm_kontrol()">              
                        </cfif>---> 
                        </td>
                    </tr>
                </tfoot>
                <tr>
                 	<td style="display:none">
                        <cfif get_p_orders.recordcount and attributes.list_type eq 2 and attributes.is_form_submitted eq 1>
                            <audio autoplay="autoplay" controls="none">
                                <source src="/images/production/uretim.mp3" type="audio/mpeg">
                            </audio>
                        </cfif>
                	</td>
             	</tr>
            <cfelse>
                <tr> 
                    <td colspan="13" height="20"><cfif arama_yapilmali eq 0><cf_get_lang_main no='289.Filtre Ediniz'> !<cfelse><cf_get_lang_main no='72.Kayıt Yok'>!</cfif></td>
                </tr>
            </cfif>
        </tbody>
    </cf_big_list>
</cfform>
<script language="javascript">
	<cfoutput>
		var shift_id_ = #attributes.shift_id#
	</cfoutput>
	if(document.all.list_type.value ==2)
	pm_kontrol();
	function pm_kontrol()
	{
		<cfif len(attributes.is_form_submitted) and get_p_orders.recordcount gt 0>
			<cfoutput>
			var list_type = #attributes.list_type#;
			var proc_type = #attributes.proc_type#;
			var employee_id= #session.ep.userid#;
			var process_stage = #process_stage#;
			var process_cat = #process_cat#;
			var master_plan_id = #attributes.master_plan_id#;
			var sub_plan_id = #attributes.sub_plan_id#;
			var type = #attributes.type#;
			</cfoutput>
			<cfoutput query="get_p_orders" startrow="1" maxrows="1">
				 if(filterNum(document.getElementById('product_amount_#P_OPERATION_ID#').value) > 0)
				 {
					if(document.getElementById('product_amount_#P_OPERATION_ID#').value > #KALAN_OPERASYON#)
					{
					alert('<cf_get_lang_main no='3241.Girdiğiniz Miktar Kalan Üretimden Büyük Lütfen Düzeltiniz'>');
					return false
					}
					else
					{
						var station_id = #O_STATION_IP#;
						var p_operation_id = #P_OPERATION_ID#;
						var p_order_id = #p_order_id#;
						var amount_ = filterNum(document.getElementById('product_amount_'+p_operation_id).value);
						window.location.href='#request.self#?fuseaction=production.addOperationResult_ezgi&is_operation=0&proc_type='+proc_type+'&list_type='+list_type+'&product_time=1&station_id_='+station_id+'&operation_id_='+p_operation_id+'&upd_id='+p_order_id+'&realized_amount_='+amount_+'&employee_id_='+employee_id+'&process_stage='+process_stage+'&process_cat='+process_cat+'&master_plan_id='+master_plan_id+'&sub_plan_id='+sub_plan_id+'&type='+type;
					}
				 }
			</cfoutput>
		</cfif>
		geciktir = setTimeout("window.location.href='<cfoutput>#request.self#?fuseaction=prod.popup_display_ezgi_prod_menu&type=5&is_form_submitted=1&list_type=2&master_plan_id=#attributes.master_plan_id#&sub_plan_id=#attributes.sub_plan_id#&proc_type=#attributes.proc_type#</cfoutput>'", 1000000);
	}
	function kontrol(p_operation_id,station_id,amount,p_order_id)
	{
		if(filterNum(document.getElementById('product_amount_'+p_operation_id).value) > 0)
		{
			if(filterNum(document.getElementById('product_amount_'+p_operation_id).value) <= amount)
			{
				var amount_ = filterNum(document.getElementById('product_amount_'+p_operation_id).value)
				<cfoutput>
				var list_type = #attributes.list_type#;
				var proc_type = #attributes.proc_type#;
				var employee_id= #session.ep.userid#;
				var process_stage = #process_stage#;
				var process_cat = #process_cat#;
				var master_plan_id = #attributes.master_plan_id#;
				var sub_plan_id = #attributes.sub_plan_id#;
				var type = #attributes.type#;
				</cfoutput>
				sor = confirm('Üretimi Sonlandırmak İster misiniz ?');
				if(sor==true)
				window.location.href='<cfoutput>#request.self#</cfoutput>?fuseaction=production.addOperationResult_ezgi&is_operation=0&proc_type='+proc_type+'&list_type='+list_type+'&product_time=1&station_id_='+station_id+'&operation_id_='+p_operation_id+'&upd_id='+p_order_id+'&realized_amount_='+amount_+'&employee_id_='+employee_id+'&process_stage='+process_stage+'&process_cat='+process_cat+'&master_plan_id='+master_plan_id+'&sub_plan_id='+sub_plan_id+'&type='+type;
			}
			else
			{
				alert('<cf_get_lang_main no='3241.Girdiğiniz Miktar Kalan Üretimden Büyük Lütfen Düzeltiniz'>');	
				return false
			}
			
		}
		else
		{
			alert("<cf_get_lang_main no='59.Eksik Veri'> : <cf_get_lang_main no ='245.Ürün'>.");	
			return false
		}
	}
	function set_master_plan(xyz)
	{
		var master_plan_id_ = xyz;
		var master_plan_names = wrk_query("SELECT EMAP.MASTER_ALT_PLAN_ID, EMAP.MASTER_ALT_PLAN_NO, EMAP.PLAN_START_DATE, EMAP.PLAN_FINISH_DATE, EMAP.PLAN_DETAIL FROM EZGI_MASTER_PLAN AS EMP INNER JOIN EZGI_MASTER_ALT_PLAN AS EMAP ON EMP.MASTER_PLAN_ID = EMAP.MASTER_PLAN_ID INNER JOIN EZGI_MASTER_PLAN_SABLON AS EMPS ON EMAP.PROCESS_ID = EMPS.PROCESS_ID WHERE EMP.MASTER_PLAN_PROCESS = 1 AND EMP.IS_PROCESS = 1 AND EMP.MASTER_PLAN_STATUS = 1 AND EMP.MASTER_PLAN_CAT_ID = "+ shift_id_  +" AND EMPS.SIRA = 1 AND EMP.MASTER_PLAN_ID ="+ master_plan_id_ +"ORDER BY EMAP.PLAN_START_DATE","dsn3");
		
		var option_count = document.getElementById('sub_plan_id').options.length; 
		for(x=option_count;x>=0;x--)
			document.getElementById('sub_plan_id').options[x] = null;
		if(master_plan_names.recordcount != 0)
		{	
			document.getElementById('sub_plan_id').options[0] = new Option('Seçiniz','');
			for(var xx=0;xx<master_plan_names.recordcount;xx++)
				document.getElementById('sub_plan_id').options[xx+1]=new Option(master_plan_names.MASTER_ALT_PLAN_NO[xx]+"-"+master_plan_names.PLAN_DETAIL[xx],master_plan_names.MASTER_ALT_PLAN_ID[xx],master_plan_names.MASTER_ALT_PLAN_NO[xx]);
		}
		else
			document.getElementById('sub_plan_id').options[0] = new Option('Seçiniz','');
	}
</script>

