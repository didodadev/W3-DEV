<!--- Uretim Talebi Detayli --->
<cfif isdefined("attributes.action_id") and len(attributes.action_id)>
	<cfset liste = attributes.action_id>
<cfelseif isdefined("attributes.iid") and Len(attributes.iid)>
	<cfset liste = attributes.iid>
<cfelse>
	<cf_get_lang dictionary_id='33255.Seçmiş Olduğunuz Şablon Bu İşlem İçin Uygun Değil'>!
	<cfexit method="exittemplate">
</cfif>
<cfloop list="#liste#" index="i">
	<cfset attributes.action_id = i>
    <cfquery name="GET_DET_PO" datasource="#DSN3#">
        SELECT
            P.IS_PRODUCTION,
            P.IS_PROTOTYPE,
            PO.*,
            S.PROPERTY,
            P.PRODUCT_NAME,
            P.PRODUCT_ID,
            S.STOCK_ID,
            S.STOCK_CODE
        FROM
            PRODUCTION_ORDERS PO,
            STOCKS S,
            PRODUCT P,
            #dsn_alias#.PRO_PROJECTS PRO_PROJECTS 
        WHERE
            PO.P_ORDER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.action_id#"> AND
            PO.STOCK_ID = S.STOCK_ID AND
            S.PRODUCT_ID = P.PRODUCT_ID 
    </cfquery>
	<cfset satis_sirket="">
	<cfset satis_calisani="">
	<cfset SIPARIS_NO="">
	<cfif len(get_det_po.p_order_id)>
        <cfquery name="get_or_num" datasource="#DSN3#">
        SELECT
            ORDERS.COMPANY_ID,
            ORDERS.ORDER_NUMBER,
            ORDERS.ORDER_EMPLOYEE_ID,
            ORDERS.COMPANY_ID,
            ORDERS.PARTNER_ID,
            ORDERS.CONSUMER_ID,
            ORDERS.SHIP_ADDRESS,
            ORDERS.SHIP_METHOD
        FROM
            ORDERS,
            ORDER_ROW,
            PRODUCTION_ORDERS_ROW
        WHERE
            PRODUCTION_ORDERS_ROW.PRODUCTION_ORDER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_det_po.p_order_id#"> AND
            PRODUCTION_ORDERS_ROW.ORDER_ROW_ID = ORDER_ROW.ORDER_ROW_ID AND
            ORDER_ROW.ORDER_ID = ORDERS.ORDER_ID 
        </cfquery>
        <cfif get_or_num.recordcount and len (get_or_num.PARTNER_ID)>
            <cfquery name="get_partner" datasource="#dsn#">
               SELECT * FROM COMPANY_PARTNER WHERE PARTNER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_or_num.PARTNER_ID#">
            </cfquery>
        </cfif>
        <cfif get_or_num.recordcount and len(get_or_num.SHIP_METHOD)>
            <cfquery name="get_order_ship" datasource="#DSN#">
                SELECT SHIP_METHOD_ID, SHIP_METHOD SM FROM SHIP_METHOD WHERE SHIP_METHOD_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_or_num.SHIP_METHOD#">
            </cfquery>
        </cfif>
        <cfoutput query="get_or_num">
            <cfset SIPARIS_NO=valuelist(get_or_num.order_number,',')>
        </cfoutput>
        <cfif isdefined("get_or_num.company_id") and len(get_or_num.company_id)>
            <cfset satis_sirket=get_par_info(get_or_num.company_id,1,1,0)>
        <cfelseif len(get_or_num.consumer_id)>
            <cfset satis_sirket=get_cons_info(get_or_num.consumer_id,1,1,0)>
        </cfif>
        <cfif len(get_or_num.order_employee_id)>
            <cfset satis_calisani=get_emp_info(get_or_num.order_employee_id,1,0)>
        </cfif>
    <cfelse>
        <cfset satis_sirket="">
        <cfset satis_calisani="">
        <cfset SIPARIS_NO="">
    </cfif>
	<cfif isnumeric(get_det_po.station_id) and len(get_det_po.station_id)>
        <cfquery name="GET_W" datasource="#DSN3#">
            SELECT STATION_NAME FROM WORKSTATIONS WHERE STATION_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_det_po.station_id#">
        </cfquery>
    </cfif>
    <cfquery name="CHECK" datasource="#DSN#">
        SELECT
            COMPANY_NAME,
            TEL_CODE,
            TEL,TEL2,
            TEL3,
            TEL4,
            FAX,
            ADDRESS,
            WEB,
            EMAIL,
            ASSET_FILE_NAME3
        FROM
            OUR_COMPANY
        WHERE 
          <cfif isDefined("session.ep.company_id")>
            COMP_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.company_id#">
          <cfelseif isDefined("session.pp.company")>	
            COMP_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.pp.company_id#">
          <cfelseif isDefined("session.ww.our_company_id")>
            COMP_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ww.our_company_id#">
        </cfif>
    </cfquery>
	<cfif len(get_det_po.spect_var_id)>
        <cfquery name="get_spec_2" datasource="#dsn1#">
            SELECT
                SR.PROPERTY_ID,
                SR.VARIATION_ID,
                SR.TOTAL_MIN,
                SR.TOTAL_MAX,
                SR.PRODUCT_SPACE,
                SR.PRODUCT_DISPLAY,
                SR.PRODUCT_NAME,
                PRODUCT_PROPERTY.PROPERTY,
                PRODUCT_PROPERTY_DETAIL.PROPERTY_DETAIL
            FROM
                #dsn3_alias#.SPECTS_ROW SR,
                PRODUCT_PROPERTY,
                PRODUCT_PROPERTY_DETAIL
            WHERE
                SR.SPECT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_det_po.spect_var_id#">
                AND SR.PROPERTY_ID=PRODUCT_PROPERTY.PROPERTY_ID
                AND PRODUCT_PROPERTY.PROPERTY_ID = PRODUCT_PROPERTY_DETAIL.PRPT_ID
                AND IS_PROPERTY=1
                AND SR.VARIATION_ID=PRODUCT_PROPERTY_DETAIL.PROPERTY_DETAIL_ID
            </cfquery> 
    </cfif>
    <cfquery name="get_det_project" datasource="#dsn#">
        SELECT
            PRODUCTION_ORDERS.PROJECT_ID,
            PRO_PROJECTS.PROJECT_HEAD,
            PRO_PROJECTS.PROJECT_ID
        FROM 
            #dsn3_alias#.PRODUCTION_ORDERS PRODUCTION_ORDERS,
            PRO_PROJECTS
        WHERE
            PRODUCTION_ORDERS.PROJECT_ID = PRO_PROJECTS.PROJECT_ID	
    </cfquery>
    
    <cf_woc_header>
        <cf_woc_elements>
            <cf_wuxi id="pro_no" data=": #get_det_po.p_order_no#" label="57456+57487" type="cell">
            <cf_wuxi id="ord_no" data=": #SIPARIS_NO#" label="58211" type="cell">
                <cfif len(get_det_po.start_date)><cf_wuxi id="sta_date" data=": #dateformat(get_det_po.start_date,dateformat_style)# #timeformat(get_det_po.start_date,timeformat_style)#" label="58467" type="cell"></cfif>
                <cfif len(get_det_po.finish_date)><cf_wuxi id="fin_date" data=": #dateformat(get_det_po.finish_date,dateformat_style)# #timeformat(get_det_po.finish_date,timeformat_style)#" label="57502" type="cell"></cfif>
                <cfif len(get_det_project.project_id)><cf_wuxi id="project" data=": #get_det_project.PROJECT_HEAD#" label="57416" type="cell"></cfif>        
            <cf_wuxi id="company" data=": #satis_sirket#" label="57574" type="cell">
            <cf_wuxi id="sal_emp" data=": #satis_calisani#" label="45229" type="cell">
                <cfif len(get_det_po.station_id)><cf_wuxi id="station" data=": #get_w.station_name#" label="58834" type="cell"></cfif>
            <cf_wuxi id="desc" data=":  #get_det_po.detail#" label="57629" type="cell">
        </cf_woc_elements>

        <cf_woc_elements>
            <b><cf_get_lang dictionary_id='61154.Üretilecek Ürün'></b>:
            <cf_woc_list id="ProducttobeProduced">
                <thead>
                    <tr>
                        <cf_wuxi label="57518" type="cell" is_row="0" id="wuxi_57518"> 
                        <cf_wuxi label="57657" type="cell" is_row="0" id="wuxi_57657"> 
                        <cf_wuxi label="54850" type="cell" is_row="0" id="wuxi_54850"> 
                        <cf_wuxi label="54851" type="cell" is_row="0" id="wuxi_54851"> 
                        <cf_wuxi label="57635" type="cell" is_row="0" id="wuxi_57635"> 
                    </tr>
                </thead>
                <tbody>
                    <tr>
                        <cf_wuxi data="#get_det_po.stock_code#" type="cell" is_row="0"> 
                        <cf_wuxi data="#get_det_po.product_name#" type="cell" is_row="0"> 
                            <cfif len(get_det_po.spect_var_id)><cf_wuxi data="#get_det_po.spect_var_id#" type="cell" is_row="0"><cfelse><td>&nbsp;</td></cfif>
                            <cfif len(get_det_po.spect_var_name)><cf_wuxi data="#get_det_po.spect_var_name#" type="cell" is_row="0"><cfelse><td>&nbsp;</td></cfif>
                        <cf_wuxi data="#get_det_po.quantity#" type="cell" is_row="0">              
                    </tr>
                </tbody>
            </cf_woc_list> 
        </cf_woc_elements>

        <cf_woc_elements>
            <b><cf_get_lang dictionary_id='40146.Ürün Özellikleri'></b>:
            <cf_woc_list id="ProductFeatures">
                <thead>
                    <tr>
                        <cf_wuxi label="57632" type="cell" is_row="0" id="wuxi_57518"> 
                        <cf_wuxi label="33615" type="cell" is_row="0" id="wuxi_57657"> 
                        <cf_wuxi label="57629" type="cell" is_row="0" id="wuxi_54850"> 
                        <cf_wuxi label="48152" type="cell" is_row="0" id="wuxi_54851"> 
                        <cf_wuxi label="55735" type="cell" is_row="0" id="wuxi_57635"> 
                        <cf_wuxi label="57662" type="cell" is_row="0" id="wuxi_54851"> 
                        <cf_wuxi label="61155" type="cell" is_row="0" id="wuxi_57635"> 
                    </tr>
                </thead>
                <tbody>
                    <cfif isdefined("get_spec_2") and get_spec_2.recordcount>
                    <cfoutput query="get_spec_2">
                    <tr>
                        <cf_wuxi data="#PROPERTY#" type="cell" is_row="0"> 
                        <cf_wuxi data="#PROPERTY_DETAIL#" type="cell" is_row="0"> 
                        <cf_wuxi data="#PRODUCT_NAME#" type="cell" is_row="0"> 
                        <cf_wuxi data="#TOTAL_MIN#" type="cell" is_row="0"> 
                        <cf_wuxi data="#TOTAL_MAX#" type="cell" is_row="0">      
                        <cf_wuxi data="#PRODUCT_SPACE#" type="cell" is_row="0"> 
                        <cf_wuxi data="#PRODUCT_DISPLAY#" type="cell" is_row="0">          
                    </tr>
                    </cfoutput></cfif>
                </tbody>
            </cf_woc_list> 
        </cf_woc_elements>

        <cfif isdefined("get_det_po.spect_var_id") and len(get_det_po.spect_var_id)>
            <cfquery name="Get_spect_name" datasource="#dsn3#">
                SELECT
                    T.PRODUCT_NAME,
                    T.PROPERTY
                FROM
                    STOCKS T,
                    SPECTS P
                WHERE
                    T.STOCK_ID = P.STOCK_ID AND
                    P.SPECT_VAR_ID = #get_det_po.spect_var_id#
            </cfquery>
            <cfquery name="GET_SPEC" datasource="#dsn3#">
                SELECT
                    SPECTS.SPECT_VAR_NAME,
                    STOCKS.PRODUCT_NAME,
                    SPECTS_ROW.*,
                    STOCKS.PROPERTY,
                    STOCKS.STOCK_CODE
                FROM
                    SPECTS,
                    SPECTS_ROW,
                    STOCKS
                WHERE
                    SPECTS.SPECT_VAR_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_det_po.spect_var_id#"> AND
                    SPECTS.SPECT_VAR_ID = SPECTS_ROW.SPECT_ID AND
                    STOCKS.STOCK_ID=SPECTS_ROW.STOCK_ID
            </cfquery>
            <cf_woc_elements>
                <b><cf_get_lang dictionary_id='57647.Spec'></b>: <cfoutput>#Get_spect_name.product_name# #Get_spect_name.property#</cfoutput>
                <cf_woc_list id="Spec">
                    <thead>
                        <tr>
                            <cf_wuxi label="57518" type="cell" is_row="0" id="wuxi_57518"> 
                            <cf_wuxi label="44019" type="cell" is_row="0" id="wuxi_44019"> 
                            <cf_wuxi label="54850" type="cell" is_row="0" id="wuxi_54850"> 
                            <cf_wuxi label="54851" type="cell" is_row="0" id="wuxi_54851"> 
                            <cf_wuxi label="57635" type="cell" is_row="0" id="wuxi_57635"> 
                        </tr>
                    </thead>
                    <tbody>
                        <tr>
                            <cf_wuxi data="#GET_SPEC.stock_code#" type="cell" is_row="0"> 
                            <cf_wuxi data="#GET_SPEC.product_name# #GET_SPEC.property#<cfif is_sevk eq 1> (SB)</cfif>" type="cell" is_row="0"> 
                                <cfif len(get_det_po.spect_var_id)><cf_wuxi data="#get_det_po.spect_var_id#" type="cell" is_row="0"><cfelse><td>&nbsp;</td></cfif>
                                <cfif len(get_det_po.spect_var_name)><cf_wuxi data="#get_det_po.spect_var_name#" type="cell" is_row="0"><cfelse><td>&nbsp;</td></cfif>
                            <cf_wuxi data="#get_det_po.quantity*GET_SPEC.amount_value#" type="cell" is_row="0">              
                        </tr>
                    </tbody>
                </cf_woc_list> 
            </cf_woc_elements>   
            
        <cfelseif isdefined("get_det_po.is_production") and len(get_det_po.is_production)>
            <cfquery name="GET_SPEC" datasource="#DSN3#">
                SELECT
                    PRODUCT_TREE.AMOUNT AMOUNT_VALUE,
                    PRODUCT_TREE.IS_SEVK,
                    STOCKS.PRODUCT_NAME,
                    STOCKS.STOCK_CODE
                FROM
                    STOCKS,
                    PRODUCT_TREE
                WHERE
                    PRODUCT_TREE.STOCK_ID = #get_det_po.stock_id# AND
                    STOCKS.STOCK_ID = PRODUCT_TREE.RELATED_ID
            </cfquery>
            <cf_woc_elements>
                <b><cf_get_lang dictionary_id='42103.Ürün Ağacı'></b>:
                <cf_woc_list id="ProductTree">
                    <thead>
                        <tr>
                            <cf_wuxi label="57518" type="cell" is_row="0" id="wuxi_57518"> 
                            <cf_wuxi label="44019" type="cell" is_row="0" id="wuxi_44019"> 
                            <cf_wuxi label="54850" type="cell" is_row="0" id="wuxi_54850"> 
                            <cf_wuxi label="54851" type="cell" is_row="0" id="wuxi_54851"> 
                            <cf_wuxi label="57635" type="cell" is_row="0" id="wuxi_57635"> 
                        </tr>
                    </thead>
                    <tbody>
                        <tr>
                            <cf_wuxi data="#get_spec.stock_code#" type="cell" is_row="0"> 
                            <cf_wuxi data="#get_spec.product_name#<cfif get_spec.is_sevk eq 1> (SB)</cfif>" type="cell" is_row="0"> 
                                <cfif len(get_det_po.spect_var_id)><cf_wuxi data="#get_det_po.spect_var_id#" type="cell" is_row="0"><cfelse><td>&nbsp;</td></cfif>
                                <cfif len(get_det_po.spect_var_name)><cf_wuxi data="#get_det_po.spect_var_name#" type="cell" is_row="0"></cfif>
                            <cf_wuxi data="#get_det_po.quantity*get_spec.amount_value#" type="cell" is_row="0">              
                        </tr>
                    </tbody>
                </cf_woc_list> 
            </cf_woc_elements>
        </cfif>

            <tr>
                <td colspan="3" style="width:180mm;">
                <br/><br/><br/><br/>
                <table border="1" width="100%" cellpadding="5" cellspacing="0">
                    <cfoutput>
                    <tr>
                        <td style="width:30mm;"><b><cf_get_lang dictionary_id='34344.Sevkiyat Bilgileri'></b></td>
                        <td><b><cf_get_lang dictionary_id='58607.Firma'>:</b> <cfif isdefined("get_or_num.company_id")and len(get_or_num.company_id)>#get_par_info(get_or_num.company_id,1,1,0)#</cfif>
                            <br/><br/>
                            <b><cf_get_lang dictionary_id='57578.Yetkili'>:</b> <cfif isdefined("get_or_num.PARTNER_ID") and len(get_or_num.PARTNER_ID)>#get_par_info(get_or_num.PARTNER_ID,0,-1,0)#</cfif>
                            <br/><br/>
                            <b><cf_get_lang dictionary_id='58723.Adres'>:</b> <cfif isdefined("get_or_num.SHIP_ADDRESS") and len(get_or_num.SHIP_ADDRESS)>#get_or_num.SHIP_ADDRESS#</cfif>
                            <br/><br/>
                            <b><cf_get_lang dictionary_id='57499.Telefon'>:</b> <cfif isdefined("get_partner.COMPANY_PARTNER_TEL") and len(get_partner.COMPANY_PARTNER_TEL) and isdefined("get_partner.COMPANY_PARTNER_TELCODE") and len(get_partner.COMPANY_PARTNER_TELCODE)>(#get_partner.COMPANY_PARTNER_TELCODE#)  #get_partner.COMPANY_PARTNER_TEL#</cfif>
                            <br/><br/>
                        </td>
                    </tr>
                    <tr>
                        <td><b><cf_get_lang dictionary_id='33321.Teslimat Şekli'></b></td>
                        <td>&nbsp;<cfif isdefined("get_or_num.SHIP_METHOD") and len(get_or_num.SHIP_METHOD) and isdefined("get_order_ship.SM") and len(get_order_ship.SM)>#get_order_ship.SM#</cfif>
                        </td>
                    </tr>
                    </cfoutput>
                </table>
                </td>
            </tr>
    <cf_woc_footer>

</cfloop>
