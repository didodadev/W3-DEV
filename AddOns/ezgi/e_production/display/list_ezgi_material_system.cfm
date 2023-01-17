<cfif not isdefined("attributes.is_excel")>
	<cfsetting showdebugoutput="yes">
</cfif>
<cfset sifir = 0>
<cfparam name="attributes.price_cat" default="-1">
<cfparam name="attributes.ezgi_type" default="1">
<cfparam name="attributes.controller_emp_id" default="">
<cfparam name="attributes.page" default=1>
<cfparam name="attributes.is_filtre" default="">
<cfparam name="attributes.form_varmi" default="1">
<cfparam name="attributes.page" default=1>
<cfparam name="attributes.list_type" default="1">
<cfparam name="attributes.maxrows" default='#session.ep.maxrows#'>
<cfset attributes.startrow=((attributes.page-1)*attributes.maxrows)+1>
<cfquery name="get_alt_plan_no" datasource="#dsn3#">
	SELECT MASTER_PLAN_ID,MASTER_ALT_PLAN_NO FROM EZGI_MASTER_ALT_PLAN WHERE MASTER_ALT_PLAN_ID = #attributes.master_alt_plan_id#
</cfquery>
<cfset attributes.master_plan_id = get_alt_plan_no.MASTER_PLAN_ID>
<cfquery name="get_department" datasource="#dsn3#">
    	SELECT        
        	S.DEPARTMENT_ID
		FROM         
        	EZGI_MASTER_ALT_PLAN AS A INNER JOIN
        	EZGI_MASTER_PLAN AS M ON A.MASTER_PLAN_ID = M.MASTER_PLAN_ID INNER JOIN
          	#dsn_alias#.SETUP_SHIFTS AS S ON M.MASTER_PLAN_CAT_ID = S.SHIFT_ID
		WHERE        
        	A.MASTER_ALT_PLAN_ID =#attributes.master_alt_plan_id#
</cfquery>
<cfset attributes.store_id = get_department.DEPARTMENT_ID>
<cfquery name="get_production_location" datasource="#dsn#">
	SELECT        
    	TOP (1) LOCATION_ID, 
        COMMENT
	FROM            
    	STOCKS_LOCATION
	WHERE        
    	DEPARTMENT_ID = #attributes.store_id# 
</cfquery>
<cfparam name="attributes.production_loc_id" default="#get_production_location.LOCATION_ID#">
<cfparam name="attributes.production_loc_name" default="#get_production_location.COMMENT#">
<cfquery name="get_ready_location" datasource="#dsn#">
	SELECT        
    	TOP (1) LOCATION_ID, 
        COMMENT
	FROM            
    	STOCKS_LOCATION
	WHERE        
    	DEPARTMENT_ID = #attributes.store_id# 
</cfquery>
<cfparam name="attributes.ready_loc_id" default="#get_ready_location.LOCATION_ID#">
<cfparam name="attributes.ready_loc_name" default="#get_ready_location.COMMENT#">
<cfset attributes.location_id = '#get_production_location.LOCATION_ID#,#get_ready_location.LOCATION_ID#'>

<cfset alt_plan_no = get_alt_plan_no.MASTER_ALT_PLAN_NO>
<cfquery name="GET_DEPARTMENT" datasource="#DSN#">
	SELECT
		DEPARTMENT_ID,
		DEPARTMENT_HEAD
	FROM
		DEPARTMENT D 
	WHERE
    	DEPARTMENT_ID = #attributes.store_id#
  	ORDER BY
    	DEPARTMENT_ID      
</cfquery>
<cfoutput query="get_department">
	<cfset 'department_name_#DEPARTMENT_ID#'=DEPARTMENT_HEAD>
</cfoutput>
<cfquery name="GET_LOCATION" datasource="#DSN#">
	SELECT    
    	DEPARTMENT_ID, 
    	LOCATION_ID, 
        COMMENT
	FROM         
    	STOCKS_LOCATION
	WHERE     
    	LOCATION_ID IN (#attributes.location_id#) AND
        DEPARTMENT_ID = #attributes.store_id#
  	ORDER BY
    	DEPARTMENT_ID,
        LOCATION_ID
</cfquery>
<cfoutput query="get_location">
	<cfset 'COMMENT_#DEPARTMENT_ID#_#LOCATION_ID#'=COMMENT>
</cfoutput>
<cfif isdefined("attributes.form_varmi")>
	<cfquery name="metarial_system_row" datasource="#dsn3#">
    	SELECT  
        	IS_PRODUCTION,   
        	PRODUCT_ID, 
            STOCK_ID, 
            STOCK_CODE, 
            PRODUCT_NAME, 
            UNIT, 
            SUM(AMOUNT) AS AMOUNT, 
            SPECT_MAIN_ID,
            SUM(SARF_MIKTAR) AS SARF_MIKTAR
		FROM         
        	(
            SELECT   
            	S.IS_PRODUCTION,
            	S.PRODUCT_ID, 
                S.STOCK_ID, 
                S.STOCK_CODE, 
                S.PRODUCT_NAME + ' - ' + ISNULL(S.PROPERTY, '') AS PRODUCT_NAME, 
                PU.ADD_UNIT AS UNIT, 
                POS.AMOUNT, 
                POS.SPECT_MAIN_ID,
                ISNULL((
                SELECT     
                	SUM(PORR.AMOUNT) AS SARF_MIKTAR
				FROM         
                	PRODUCTION_ORDER_RESULTS AS POR INNER JOIN
                    PRODUCTION_ORDER_RESULTS_ROW AS PORR ON POR.PR_ORDER_ID = PORR.PR_ORDER_ID
				WHERE     
                	POR.P_ORDER_ID = PO.P_ORDER_ID AND 
                    POR.IS_STOCK_FIS = 1 AND 
                    PORR.TYPE = 2 AND 
                    PORR.STOCK_ID = S.STOCK_ID
                ),0) AS SARF_MIKTAR
         	FROM          
            	STOCKS AS S INNER JOIN
                PRODUCTION_ORDERS_STOCKS AS POS ON S.STOCK_ID = POS.STOCK_ID INNER JOIN
                PRODUCT_UNIT AS PU ON S.PRODUCT_UNIT_ID = PU.PRODUCT_UNIT_ID INNER JOIN
                PRODUCTION_ORDERS AS PO ON POS.P_ORDER_ID = PO.P_ORDER_ID
            WHERE 
            	<cfif len(attributes.is_filtre)>
                	(S.STOCK_CODE LIKE '%#attributes.is_filtre#%' OR PRODUCT_NAME LIKE '%#attributes.is_filtre#%') AND
                </cfif> 
                POS.TYPE = 2 AND 
                S.IS_PURCHASE = 1 AND
                S.IS_PRODUCTION = 0 AND
                <cfif attributes.list_type eq 1><!--- MRP Ürünler İse--->
                	ISNULL(S.IS_LIMITED_STOCK,0) = 0 AND 
                <cfelseif attributes.list_type eq 2><!--- Kanban Ürünler İse--->
                	S.IS_LIMITED_STOCK = 1 AND 
                </cfif> 
                PO.P_ORDER_ID IN 
                                (
                                SELECT     
        							P.P_ORDER_ID
                                FROM         
                                    EZGI_MASTER_ALT_PLAN AS EMAP INNER JOIN
                                    EZGI_MASTER_PLAN_RELATIONS AS EMPR ON EMAP.MASTER_ALT_PLAN_ID = EMPR.MASTER_ALT_PLAN_ID INNER JOIN
                                    PRODUCTION_ORDERS AS P ON EMPR.P_ORDER_ID = P.P_ORDER_ID
                                WHERE     
                                    EMAP.MASTER_ALT_PLAN_ID = #attributes.master_alt_plan_id# OR
                                    EMAP.RELATED_MASTER_ALT_PLAN_ID = #attributes.master_alt_plan_id#
                                )
        	) AS TBL
		GROUP BY 
        	IS_PRODUCTION, 
        	PRODUCT_ID, 
            STOCK_ID, 
            STOCK_CODE, 
            PRODUCT_NAME, 
            UNIT, 
            SPECT_MAIN_ID
		ORDER BY 
        	STOCK_CODE
	</cfquery>
    <cfif metarial_system_row.recordcount>
		<cfset stock_id_list = Valuelist(metarial_system_row.STOCK_ID)>
        <cfquery name="get_stock" datasource="#dsn2#">
            SELECT 
                SUM(SR.STOCK_IN-SR.STOCK_OUT) PRODUCT_STOCK,
                SR.STOCK_ID,
                SR.STORE AS DEPARTMENT_ID,
                SR.STORE_LOCATION AS LOCATION_ID
            FROM 
                STOCKS_ROW SR
            WHERE
                SR.STORE IN (#attributes.store_id#) AND
                SR.STORE_LOCATION IN (#attributes.location_id#) AND
                SR.STOCK_ID IN (#stock_id_list#)
            GROUP BY
                SR.STOCK_ID,
                SR.STORE,
                SR.STORE_LOCATION
            ORDER BY
                SR.STOCK_ID,
                SR.STORE,
                SR.STORE_LOCATION      
        </cfquery>
        <cfoutput query="get_stock">
        	<cfset 'PRODUCT_STOCK_#STOCK_ID#_#DEPARTMENT_ID#_#LOCATION_ID#' = PRODUCT_STOCK>
        </cfoutput>
        <cfquery name="get_period" datasource="#dsn#">
            SELECT     
            	TOP (2)
                PERIOD_YEAR
            FROM         
                SETUP_PERIOD
            WHERE     
                OUR_COMPANY_ID = #session.ep.company_id#
          	ORDER BY
            	PERIOD_YEAR desc      
        </cfquery>
        <cfset our_company_years = Valuelist(get_period.PERIOD_YEAR)>
        <cfquery name="get_ambar_fis" datasource="#dsn3#">
        	SELECT
            	SUM(STOCK_IN) AS AMBAR_STOCK,
                STOCK_ID
          	FROM
            	(      
                <cfloop list="#our_company_years#" index="comp_ii">
                    SELECT     
                        SR.STOCK_IN,
                        SR.STOCK_ID
                    FROM         
                        #dsn#_#comp_ii#_#session.ep.company_id#.STOCK_FIS AS SF INNER JOIN
                        #dsn#_#comp_ii#_#session.ep.company_id#.STOCKS_ROW AS SR ON SF.FIS_ID = SR.UPD_ID
                    WHERE     
                        SF.FIS_TYPE = 113 AND 
                        SF.REF_NO = '#alt_plan_no#' AND 
                        SR.STORE = #attributes.store_id# AND 
                        SR.STORE_LOCATION = #attributes.production_loc_id# AND 
                        SR.STOCK_IN > 0 AND 
                        SR.STOCK_ID IN (#stock_id_list#)
                        <cfif listlen(our_company_years) neq 1 and comp_ii neq listlast(our_company_years,',')> UNION ALL </cfif>
                </cfloop>
                ) AS TBL
          	GROUP BY
            	STOCK_ID
        </cfquery>
        <cfoutput query="get_ambar_fis">
        	<cfset 'AMBAR_STOCK_#STOCK_ID#' = AMBAR_STOCK>
        </cfoutput>
        <cfquery name="GET_INTERNALDEMAND" datasource="#dsn3#">
        	SELECT     
            	IR.STOCK_ID, 
                SUM(IR.QUANTITY) AS TALEP_STOCK
			FROM         
            	INTERNALDEMAND AS I INNER JOIN
                INTERNALDEMAND_ROW AS IR ON I.INTERNAL_ID = IR.I_ID
			WHERE     
            	I.REF_NO = '#alt_plan_no#' AND
                IR.STOCK_ID IN (#stock_id_list#)
			GROUP BY 

            	IR.STOCK_ID
        </cfquery>
        <cfoutput query="GET_INTERNALDEMAND">
        	<cfset 'TALEP_STOCK_#STOCK_ID#' = TALEP_STOCK>
        </cfoutput>
        <cfquery name="GET_MONEY" datasource="#DSN2#">
            SELECT * FROM SETUP_MONEY
        </cfquery>
        <!--- ÜRÜN FİYATLAR --->
    	<cfquery name="GET_PRICE" datasource="#DSN3#">
        	SELECT
            	P.MONEY,
               	P.PRICE,
               	S.STOCK_ID
          	FROM
				<cfif attributes.price_cat eq -1>
					PRICE_STANDART P,
				<cfelse>
					PRICE P,
				</cfif>
              	STOCKS S
       		WHERE
            	S.PRODUCT_ID = P.PRODUCT_ID AND
                S.STOCK_ID IN (#stock_id_list#) AND
				<cfif attributes.price_cat eq -1>
					P.PRICESTANDART_STATUS = 1 AND
					P.PURCHASESALES = 0
				<cfelse>
					ISNULL(P.STOCK_ID,0)=0 AND
					ISNULL(P.SPECT_VAR_ID,0)=0 AND
					P.STARTDATE <= #now()# AND
					(P.FINISHDATE >= #now()# OR P.FINISHDATE IS NULL) AND
					P.PRICE_CATID = #attributes.price_cat#
				</cfif>
      	</cfquery>
        <cfif GET_PRICE.RECORDCOUNT>
        	<cfscript>
            	for(prod_xx=1;prod_xx lte GET_PRICE.recordcount; prod_xx=prod_xx+1)
				{
                	'product_price_#GET_PRICE.STOCK_ID[prod_xx]#' = GET_PRICE.PRICE[prod_xx];
					'product_money_#GET_PRICE.STOCK_ID[prod_xx]#' = GET_PRICE.MONEY[prod_xx];
				}
         	</cfscript>
      	</cfif>
    </cfif>
</cfif>
<!---<cfdump expand="yes" var="#attributes#">
<cfdump expand="yes" var="#metarial_system_row#"><cfdump expand="yes" var="#get_stock#"><cfdump expand="yes" var="#get_ambar_fis#"><cfabort>--->
<cfif isdefined("attributes.form_varmi")>
	<cfif not isdefined("metarial_system_row.QUERY_COUNT")>
    	<cfparam name="attributes.totalrecords" default="#metarial_system_row.recordcount#">
    <cfelse>
    	<cfparam name="attributes.totalrecords" default="0">
    </cfif>
<cfelse>
	<cfparam name="attributes.totalrecords" default="0">
</cfif>
<cf_big_list_search title="<cf_get_lang_main no='3283.Alt Plan Malzeme Kontrol Sistemi'>">
	<cfform name="list_meterials" id="list_meterials" method="post" action="#request.self#?fuseaction=prod.popup_ezgi_material_system">
	<input name="form_varmi" id="form_varmi" value="1" type="hidden">
    <cfinput name="master_alt_plan_id" id="master_alt_plan_id" value="#attributes.master_alt_plan_id#" type="hidden">
    	<cf_big_list_search_area>
            <table>
                <tr>
                	<td><cf_get_lang_main no='48.Filtre'></td>
                    <td><cfinput type="text" name="is_filtre" id="is_filtre" style="width:90px;" value="#attributes.is_filtre#"></td>
                    <td width="100px">
                    	<select name="list_type" style="width:120px; height:20px">
                            <option value="1" <cfif attributes.list_type eq 1>selected</cfif>>MRP <cf_get_lang_main no='152.Ürünler'></option>
                            <option value="2" <cfif attributes.list_type eq 2>selected</cfif>>Kanban <cf_get_lang_main no='152.Ürünler'></option>
                        </select>
                    </td>
                    <td><cf_get_lang_main no='3284.Liste Tipi'> 
                    	<select name="ezgi_type" id="ezgi_type" style="width:150px; height:20px">
                        	<option value="1" <cfif attributes.ezgi_type eq 1>selected</cfif>><cf_get_lang_main no='3285.İç Talep Eksiği'></option>
                            <option value="2" <cfif attributes.ezgi_type eq 2>selected</cfif>><cf_get_lang_main no='3286.Ambar Fişi Eksiği'></option>
                        </select>
                    <td>
                    	<cfsavecontent variable="message"><cf_get_lang_main no='125.Sayi_Hatasi_Mesaj'></cfsavecontent>
                        <cfinput type="text" name="maxrows" id="maxrows" value="#attributes.maxrows#" validate="integer" range="1,1250" required="yes" message="#message#" style="width:25px;">
                       	<cf_wrk_search_button><cf_workcube_file_action pdf='1' mail='1' doc='1' print='1'>
                    </td>
                </tr>
            </table>
        </cf_big_list_search_area>
	</cfform>
</cf_big_list_search>  
<cf_big_list>
    <thead>
        <tr>
        	<th style="width:25px; text-align:center"><cf_get_lang_main no ='1165.Sıra'></th>
			<th style="text-align:right;width:90px"><cf_get_lang_main no ='106.Stok Kodu'></th>
			<th><cf_get_lang_main no ='245.Ürün'></th>
            <cfloop list="#attributes.store_id#" index="_depID_" delimiters=",">
                <cfloop list="#attributes.location_id#" index="_locID_" delimiters=",">

                    <th style="width:60px; text-align:center" class="txtbold"><cfoutput>#Evaluate('comment_#_depID_#_#_locID_#')#</cfoutput></th>
                </cfloop>
           	</cfloop> 
            <th style="text-align:right;width:60px"><cf_get_lang_main no='3287.Depo Toplamı'></th>
            <th style="text-align:right;width:60px"><cf_get_lang_main no='3288.Plan İhtiyacı'></th>
            <th style="text-align:right;width:40px" title="<cf_get_lang_main no ='224.Birim'>"><cf_get_lang_main no ='224.Birim'></th>
            <th style="text-align:right;width:60px"><cf_get_lang_main no='1831.Sarf Fişi'></th>
            <th style="text-align:right;width:60px"><cf_get_lang_main no='1032.Kalan'> <cfoutput>#getLang('prod',124)#</cfoutput></th>
            <th style="text-align:right;width:60px" title="<cf_get_lang_main no='1078.Verilen'> <cf_get_lang_main no='3289.İç Talep Miktarı'>"><cf_get_lang_main no='1386.İç Talep'></th>
            <th style="text-align:right;width:60px" title="<cf_get_lang_main no='3290.Ambar Fişi Miktarı'>"><cf_get_lang_main no='1833.Ambar Fişi'></th>
            <th style="text-align:right;width:60px"><cfif attributes.ezgi_type eq 1><cf_get_lang_main no='1386.	İç Talep'><cfelse><cf_get_lang_main no='1833.Ambar Fişi'></cfif> <cf_get_lang_main no ='1032.Kalan'></th>
            
          	<th style="width:20px; text-align:center"></th>
       </tr>
    </thead>
    <tbody>
        <cfif isdefined("attributes.form_varmi") and metarial_system_row.recordcount>
            <cfoutput query="metarial_system_row" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">
                <tr class="color-row">
                	<cfset toplam_urun = 0>
                    <td style="text-align:right">
                    	<cfif metarial_system_row.IS_PRODUCTION eq 1>
                            <font style="background-color:orange">
                        </cfif>
                    	#currentrow#
                   		<cfif metarial_system_row.IS_PRODUCTION eq 1>

                            </font>
                        </cfif>
                    </td>
                    <td style="text-align:center">
                    	<cfif metarial_system_row.IS_PRODUCTION eq 1>
                            <font style="background-color:orange">
                        </cfif>
                    	#STOCK_CODE#
                   		<cfif metarial_system_row.IS_PRODUCTION eq 1>
                            </font>
                        </cfif>
                    </td>
                    <td style="text-align:left">
                    	<cfif metarial_system_row.IS_PRODUCTION eq 1>
                            <font style="background-color:orange">
                        </cfif>
                    	#product_name#
                   		<cfif metarial_system_row.IS_PRODUCTION eq 1>
                            </font>
                        </cfif>
                    </td>
                    <cfloop list="#attributes.store_id#" index="_depID_" delimiters=",">
                        <cfloop list="#attributes.location_id#" index="_locID_" delimiters=",">
                            <td style="text-align:right">
								<cfif isdefined('PRODUCT_STOCK_#metarial_system_row.STOCK_ID#_#_depID_#_#_locID_#')>
                                	<cfif Evaluate('PRODUCT_STOCK_#metarial_system_row.STOCK_ID#_#_depID_#_#_locID_#') lt 0>
                                    	<font color="red">
                                   	<cfelse>     
                                        <font color="black">
                                    </cfif>
                                    #TlFormat(Evaluate('PRODUCT_STOCK_#metarial_system_row.STOCK_ID#_#_depID_#_#_locID_#'),2)#
                                    <cfset toplam_urun = toplam_urun + Evaluate('PRODUCT_STOCK_#metarial_system_row.STOCK_ID#_#_depID_#_#_locID_#')>
                                    </font>
                                <cfelse>
                                	#TlFormat(sifir,2)#
                                </cfif>
                            </td>
                        </cfloop>
                    </cfloop>
                    <td style="text-align:right">
                    	<cfif toplam_urun lt 0>
                  			<font color="red">
                       	<cfelse>     
                         	<font color="black">
                       	</cfif>
                    		#TlFormat(toplam_urun,2)#
                    	</font>
                    </td> 
                    <td style="text-align:right">#TlFormat(amount,2)#</td>
                    <td style="text-align:left">#unit#</td>
                    <td style="text-align:right">#TlFormat(SARF_MIKTAR,2)#</td>
                    <td style="text-align:right">
                    	<cfif amount-SARF_MIKTAR lt 0>
                  			<font color="red">
                        <cfelseif amount-SARF_MIKTAR eq 0>    
                       		<font color="green">
                        <cfelse>     
                         	<font color="black">
                       	</cfif>
                    	#TlFormat(amount-SARF_MIKTAR,2)#
                        </font>
                    </td>
                    <td style="text-align:right">
                    	<cfif isdefined('TALEP_STOCK_#STOCK_ID#')>
                            <cfif amount - Evaluate('TALEP_STOCK_#STOCK_ID#') lte 0>    
                                <font color="green">
                            <cfelse>     
                                <font color="black">
                            </cfif>
                        		#TlFormat(Evaluate('TALEP_STOCK_#STOCK_ID#'),2)#
                            </font>
                       	<cfelse>
                         	#TlFormat(sifir,2)#     
                        </cfif>
                    </td>
                    <td style="text-align:right">
                    	<cfif isdefined('AMBAR_STOCK_#STOCK_ID#')>
                        	<cfif amount - Evaluate('AMBAR_STOCK_#STOCK_ID#') lte 0>    
                                <font color="green">
                            <cfelse>     
                                <font color="black">
                            </cfif>
                        		#TlFormat(Evaluate('AMBAR_STOCK_#STOCK_ID#'),2)#
                           	</font>     
                      	<cfelse>
                         	#TlFormat(sifir,2)#       
                        </cfif>
                    </td>
                    <td style="text-align:right">
                    	<cfif attributes.ezgi_type eq 1>
                        	<cfif isdefined('TALEP_STOCK_#STOCK_ID#')>
								<cfset row_total_need = amount - Evaluate('TALEP_STOCK_#STOCK_ID#')>
                           	<cfelse>
                            	<cfset row_total_need = amount>
                            </cfif>     
                     	<cfelse>
                        	<cfif isdefined('AMBAR_STOCK_#STOCK_ID#')>
								<cfset row_total_need = amount - Evaluate('AMBAR_STOCK_#STOCK_ID#')>
                           	<cfelse>
                            	<cfset row_total_need = amount>
                            </cfif>
                     	</cfif>
                        <cfif row_total_need lt 0><cfset row_total_need = 0></cfif>
                    	<input type="text" name="row_total_need_#stock_id#" id="row_total_need_#stock_id#" value="#tlformat(row_total_need)#" class="box" style="width:80px;" onKeyup="return(FormatCurrency(this,event));" onBlur="hesapla(#stock_id#);">
                    </td>
                    <td style="text-align:center">
                    	<input type="checkbox" name="conversion_product_#stock_id#" value="#stock_id#" id="_conversion_product_#currentrow#">
                    </td>
                    <cfif isdefined('product_price_#STOCK_ID#')>
						<cfset row_price =  Evaluate('product_price_#STOCK_ID#')>
                    <cfelse>
                        <cfset row_price = 0 >
                    </cfif>
                    <input type="hidden" name="row_price_unit_#stock_id#" id="row_price_unit_#stock_id#" value="#tlformat(row_price)#">
                    <input type="hidden" name="row_price_#stock_id#" id="row_price_#stock_id#" value="#tlformat(row_total_need*row_price)#" onKeyup="return(FormatCurrency(this,event));">
                    <select name="row_stock_money_#stock_id#" id="row_stock_money_#stock_id#" style="width:45px;display:none;">
                        <cfloop query="get_money">
                                        <option value="#money#,#RATE2#"<cfif isdefined('product_money_#metarial_system_row.STOCK_ID#') and Evaluate('product_money_#metarial_system_row.STOCK_ID#') is money>selected</cfif>>#money#</option>
                        </cfloop>
                    </select>
                </tr>
                <cfset son_row = currentrow>
            </cfoutput>
      	    <tfoot>
                <tr>
                    <td colspan="13" style="text-align:right">
                    	<cfif attributes.ezgi_type eq 2>
                    		<input type="button" value="<cfoutput>#getLang('prod',585)#</cfoutput>" name="ambar_fisi" id="ambar_fisi" onClick="kota_kontrol(2);" style="width:160px;">
						<cfelse>
                    		<input type="button" value="<cfoutput>#getLang('prod',588)#</cfoutput>" name="satin_alma_talebi" id="satin_alma_talebi" onClick="kota_kontrol(3);" style="width:160px;">
                    	</cfif>
                    </td>
                    <td style="text-align:center">
                    	<input type="checkbox" name="all_conv_product" id="all_conv_product" onClick="javascript: wrk_select_all2('all_conv_product','_conversion_product_',<cfoutput>#metarial_system_row.recordcount#</cfoutput>);">
                    </td>
                </tr>
            </tfoot>  
            
        <cfelse>
            <tr><td class="color-row" colspan="20"><cfif not isdefined("attributes.form_varmi")><cf_get_lang_main no='289.Filtre ediniz'> !<cfelse><cf_get_lang_main no='72.Kayıt Yok'> !</cfif></td></tr>
        </cfif>
    </tbody>
    
</cf_big_list>
<cfif isdefined("attributes.form_varmi")>
	<cfset url_str = "prod.popup_ezgi_material_system">
    <cfif attributes.totalrecords gt attributes.maxrows>
     <table width="99%" align="center" cellpadding="0" cellspacing="0">
        <cfif len(attributes.is_filtre)>
            <cfset url_str = "#url_str#&is_filtre=#attributes.is_filtre#">
        </cfif>
        <cfif len(attributes.master_alt_plan_id)>
            <cfset url_str = "#url_str#&master_alt_plan_id=#attributes.master_alt_plan_id#">
        </cfif>
        <cfif len(attributes.ezgi_type)>
            <cfset url_str = "#url_str#&ezgi_type=#attributes.ezgi_type#">
        </cfif>
		<tr>
            <td><cf_pages 
                page="#attributes.page#"
                maxrows="#attributes.maxrows#"
                totalrecords="#attributes.totalrecords#"
                startrow="#attributes.startrow#"
                adres="#url_str#&form_varmi=1">
            </td>
            <td align="right" style="text-align:right;"><cf_get_lang_main no='128.Toplam Kayıt'><cfoutput>:#attributes.totalrecords#&nbsp;-&nbsp;<cf_get_lang_main no='169.Sayfa'>:#attributes.page#/#lastpage#</cfoutput></td>
        </tr>
		</table>
     </cfif>
</cfif>
<form name="aktar_form" method="post">
    <input type="hidden" name="list_price" id="list_price" value="0">
    <input type="hidden" name="price_cat" id="price_cat" value="">
    <input type="hidden" name="CATALOG_ID" id="CATALOG_ID" value="">
    <input type="hidden" name="NUMBER_OF_INSTALLMENT" id="NUMBER_OF_INSTALLMENT" value="">
    <input type="hidden" name="convert_stocks_id" id="convert_stocks_id" value="">
	<input type="hidden" name="convert_amount_stocks_id" id="convert_amount_stocks_id" value="">
	<input type="hidden" name="convert_price" id="convert_price" value="">
	<input type="hidden" name="convert_price_other" id="convert_price_other" value="">
	<input type="hidden" name="convert_money" id="convert_money" value="">
</form>
<script type="text/javascript">
	document.getElementById('is_filtre').focus();
	function kota_kontrol(type)
		/*
		___Type__
		2:Ambar Fişi
		3:Satın Alma Talebi
		*/
	{
		 var convert_list ="";
		 var convert_list_amount ="";
		 var convert_list_price ="";
		 var convert_list_price_other="";
		 var convert_list_money ="";
		 //
		 <cfif isdefined("attributes.form_varmi")>
			 <cfoutput query="metarial_system_row" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">
				 if(document.all.conversion_product_#stock_id#.checked && filterNum(document.getElementById('row_total_need_#stock_id#').value) > 0)
				 {
					convert_list += "#stock_id#,";
					convert_list_amount += filterNum(document.getElementById('row_total_need_#stock_id#').value,3)+',';
					convert_list_price_other += filterNum(document.getElementById('row_price_unit_#stock_id#').value,3)+',';
					convert_list_price += list_getat(document.getElementById('row_stock_money_#stock_id#').value,2,',')*filterNum(document.getElementById('row_price_unit_#stock_id#').value,8)+',';
					convert_list_money += list_getat(document.getElementById('row_stock_money_#stock_id#').value,1,',')+',';
				 }
			 </cfoutput>
		</cfif>
		document.getElementById('convert_stocks_id').value=convert_list;
		document.getElementById('convert_amount_stocks_id').value=convert_list_amount;
		document.getElementById('convert_price').value=convert_list_price;
		document.getElementById('convert_price_other').value=convert_list_price_other;
		document.getElementById('convert_money').value=convert_list_money;
		if(convert_list)//Ürün Seçili ise
		{
			 windowopen('','wide','cc_paym');
			 if(type==2)
			 {
				 aktar_form.action="<cfoutput>#request.self#?fuseaction=stock.form_add_fis&type=convert&ref_no=#alt_plan_no#&location_in=#attributes.production_loc_id#&department_in=#attributes.store_id#&location_out=#attributes.ready_loc_id#&department_out=#attributes.store_id#</cfoutput>";
				 document.getElementById('ambar_fisi').disabled=true;
			 }
			 if(type==3)
			 {
				 aktar_form.action="<cfoutput>#request.self#?fuseaction=correspondence.list_internaldemand&event=add&type=convert&ref_no=#alt_plan_no#&location_in=#attributes.ready_loc_id#&department_in=#attributes.store_id#</cfoutput>";
				  document.getElementById('satin_alma_talebi').disabled=true;
			 }
			 aktar_form.target='cc_paym';
			 aktar_form.submit();
		 }
		 else
		 	alert("<cf_get_lang_main no='59.Eksik Veri'> : <cf_get_lang_main no ='245.Ürün'>.");
	}
	function wrk_select_all2(all_conv_product,_conversion_product_,number)
	{
		for(var cl_ind=1; cl_ind <= number; cl_ind++)
		{
			if(document.getElementById(all_conv_product).checked == true)
			{
				if(document.getElementById('_conversion_product_'+cl_ind).checked == false)
					document.getElementById('_conversion_product_'+cl_ind).checked = true;
			}
			else
			{
				if(document.getElementById('_conversion_product_'+cl_ind).checked == true)
					document.getElementById('_conversion_product_'+cl_ind).checked = false;
			}
		}
	}
</script>	