<!--- Uretim Emri Detayli --->
<cfif isdefined("attributes.action_id") and len(attributes.action_id)>
	<cfset liste = attributes.action_id>
<cfelseif isdefined("attributes.iid") and Len(attributes.iid)>
	<cfset liste = attributes.iid>
<cfelse>
	<cf_get_lang no="865.Seçmiş Olduğunuz Şablon Bu İşlem İçin Uygun Değil">!
	<cfexit method="exittemplate">
</cfif>
<cfquery name="get_product_sarf" datasource="#DSN3#">
	SELECT 
		POS.PRODUCT_ID,
		POS.STOCK_ID,
		POS.SPECT_MAIN_ID,
        POS.SPECT_VAR_ID,
		POS.AMOUNT,
		POS.PRODUCT_UNIT_ID,
		POS.SPECT_MAIN_ROW_ID,
        POS.LINE_NUMBER,
        POS.LOT_NO,
		S.PRODUCT_NAME,
		S.STOCK_CODE,
		PU.MAIN_UNIT,
		(SELECT TOP 1 SPECT_MAIN_NAME FROM SPECT_MAIN SM WHERE SM.STOCK_ID = S.STOCK_ID) SPECT_MAIN_NAME,
		ISNULL(POS.IS_PHANTOM,0) IS_PHANTOM,
		IS_SEVK,
		IS_PROPERTY,
		IS_FREE_AMOUNT,
		FIRE_AMOUNT,
		FIRE_RATE,
        WRK_ROW_ID
	FROM 
		PRODUCTION_ORDERS_STOCKS POS,
		STOCKS S,
		PRODUCT_UNIT PU
	WHERE
		POS.STOCK_ID = S.STOCK_ID AND 
		POS.PRODUCT_UNIT_ID = PU.PRODUCT_UNIT_ID AND
        P_ORDER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.action_id#"> AND
		(TYPE = 2  OR TYPE = 1)
	ORDER BY
		<cfif isdefined('is_line_number') and is_line_number eq 1>
        	POS.LINE_NUMBER
        <cfelse>
            POS.RECORD_DATE DESC
        </cfif>
</cfquery>
<cfloop list="#liste#" index="i">
	<cfset attributes.action_id = i>
    <cfquery name="GET_DET_PO" datasource="#DSN3#">
        SELECT
			PO.P_ORDER_ID,
			PO.P_ORDER_NO,
			PO.STATION_ID,
			PO.SPECT_VAR_ID,
			PO.SPECT_VAR_NAME,
			PO.QUANTITY,
			PO.START_DATE,
			PO.FINISH_DATE,
			PO.DETAIL,
            P.IS_PRODUCTION,
            P.IS_PROTOTYPE,
            S.PROPERTY,
            P.PRODUCT_NAME,
            P.PRODUCT_ID,
            S.STOCK_ID,
            S.STOCK_CODE,
			PP.PROJECT_ID,
			PP.PROJECT_HEAD
        FROM
			PRODUCTION_ORDERS PO
			LEFT JOIN STOCKS S ON S.STOCK_ID = PO.STOCK_ID
			LEFT JOIN PRODUCT P ON P.PRODUCT_ID = S.PRODUCT_ID
			LEFT JOIN #DSN_ALIAS#.PRO_PROJECTS PP ON PP.PROJECT_ID = PO.PROJECT_ID
        WHERE
            PO.P_ORDER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.action_id#">
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
    <table border="0" cellspacing="0" cellpadding="0" style="width:210mm;height:260mm;">
        <tr valign="top">
            <td style="height:5mm;" colspan="2">&nbsp;</td>
        </tr>
        <tr valign="top">
            <td style="width:25mm;height:15mm;"></td>
            <td class="headbold"><strong><cf_get_lang dictionary_id='30049.Üretim Emri'></strong></td>
        </tr>
        <tr valign="top">
            <td colspan="2" style="height:35mm;">
            <cfoutput>
            <table border="0" style="width:200mm;">
                <tr>
                    <td style="width:24mm;" class="txtbold"><cf_get_lang dictionary_id='57456.Üretim'><cf_get_lang dictionary_id='57487.No'></td>
                    <td style="width:100mm;">:&nbsp; #get_det_po.p_order_no#</td>
                    <td class="txtbold" style="width:15mm;"><cf_get_lang dictionary_id='58467.Başlama'></td>
                    <td>:&nbsp; <cfif len(get_det_po.start_date)>#dateformat(get_det_po.start_date,dateformat_style)# #timeformat(get_det_po.start_date,timeformat_style)#</cfif></td>
                </tr>
                <tr>
                    <td class="txtbold"><cf_get_lang dictionary_id='58211.Sipariş No'></td>
                    <td>:&nbsp; #SIPARIS_NO#</td>
                    <td class="txtbold"><cf_get_lang dictionary_id='57502.Bitiş'></td>
                    <td>:&nbsp; <cfif len(get_det_po.finish_date)>#dateformat(get_det_po.finish_date,dateformat_style)# #timeformat(get_det_po.finish_date,timeformat_style)#</cfif></td>
                </tr>
                <tr>
                    <td class="txtbold"><cf_get_lang dictionary_id='57574.Şirket'></td>
                    <td>:&nbsp; #satis_sirket#</td>
                    <td class="txtbold"><cf_get_lang dictionary_id='57416.Proje'></td>
                    <td>:&nbsp; #get_det_po.PROJECT_HEAD#</td>
                </tr>
                <tr>
                    <td class="txtbold"><cf_get_lang dictionary_id='34166.Satış Çalışan'></td>
                    <td>:&nbsp; #satis_calisani#</td>
                    <td class="txtbold">&nbsp;</td>
                    <td>&nbsp;</td>
                </tr>
                <tr>
                    <td class="txtbold"><cf_get_lang dictionary_id='58834.İstasyon'></td>
                    <td>:&nbsp; <cfif len(get_det_po.station_id)>#get_w.station_name#</cfif></td>
                    <td>&nbsp;</td>
                    <td>&nbsp;</td>
                </tr>
                <tr>
                    <td valign="top" class="txtbold"><cf_get_lang dictionary_id='36199.Açıklama'></td>
                    <td colspan="3" valign="top">:&nbsp; #get_det_po.detail#</td>
                </tr>
            </table>
            </cfoutput>
            </td>
        </tr>
        <tr valign="top">
            <td colspan="2" valign="top">
            <table border="0" style="width:180mm;">
                <tr>
                    <td class="txtbold" colspan="5">Üretilecek Ürün :</td>
                </tr>
                <tr class="color-list">
                    <td class="txtbold" style="width:25mm; height:6mm;"><cf_get_lang dictionary_id='57518.Stok Kodu'></td>
                    <td class="txtbold" style="width:80mm;"><cf_get_lang dictionary_id='44019.Ürün'></td>
                    <td class="txtbold" style="width:20mm;"><cf_get_lang dictionary_id='54850.Spec Id'></td>
                    <td class="txtbold" style="width:20mm;"><cf_get_lang dictionary_id='54851.Spec Adı'></td>
                    <td class="txtbold" style="width:15mm;" style="text-align:right;"><cf_get_lang dictionary_id='57635.Miktar'></td>
                </tr>
                <cfoutput>
                <tr>
                    <td>#get_det_po.stock_code#</td>
                    <td>#get_det_po.product_name#</td>
                    <td><cfif len(get_det_po.spect_var_id)>#get_det_po.spect_var_id#<cfelse>&nbsp;</cfif></td>
                    <td><cfif len(get_det_po.spect_var_name)>#get_det_po.spect_var_name#<cfelse>&nbsp;</cfif></td>
                    <td style="text-align:right;">#get_det_po.quantity#</td>
                </tr>
                </cfoutput>
            </table>
            <br/><br/><br/>
            <table border="1" style="width:180mm;" cellpadding="5" cellspacing="0">
                <tr>
                    <td colspan="7" class="txtbold">Ürün Özellikleri</td>
                </tr>
                <tr class="color-list">
                    <td class="txtbold" style="width:30mm;"><cf_get_lang dictionary_id='57632.Özellik'></td>
                    <td class="txtbold" style="width:20mm;"><cf_get_lang dictionary_id='33615.Varyasyon'></td>	
                    <td class="txtbold" style="width:40mm;" style="text-align:right;"><cf_get_lang dictionary_id='36199.Açıklama'></td>
                    <td class="txtbold" style="width:20mm;"><cf_get_lang dictionary_id='39470.En'></td>	
                    <td class="txtbold" style="width:20mm;"><cf_get_lang dictionary_id='39511.Boy'></td>	
                    <td class="txtbold" style="width:20mm;"><cf_get_lang dictionary_id='57662.Alan'></td>	
                    <td class="txtbold" style="width:20mm;"><cf_get_lang dictionary_id='61155.Çevre'></td>
                </tr> 
                <cfif isdefined("get_spec_2") and get_spec_2.recordcount>
                    <cfoutput query="get_spec_2">
                    <tr>
                        <td>#PROPERTY#</td>
                        <td>#PROPERTY_DETAIL#</td>
                        <td>#PRODUCT_NAME#</td>
                        <td>#TOTAL_MIN#</td>
                        <td>#TOTAL_MAX#</td>
                        <td>#PRODUCT_SPACE#</td>
                        <td>#PRODUCT_DISPLAY#</td>
                    </tr>
                    </cfoutput>
                </cfif>
            </table>
            <br/><br/><br/>
            <table border="0" style="width:180mm;">
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
                <tr>
                    <td class="txtbold" colspan="5"><cf_get_lang dictionary_id='30009.Sarflar'></td>
                </tr>
                <tr class="color-list">
                    <td class="txtbold" style="width:25mm; height:6mm;"><cf_get_lang dictionary_id='57518.Stok Kodu'></td>
                    <td class="txtbold" style="width:80mm;"><cf_get_lang dictionary_id='44019.Ürün'></td>
                    <td class="txtbold" style="width:20mm;"><cf_get_lang dictionary_id='54850.Spec Id'></td>
                    <td class="txtbold" style="width:20mm;"><cf_get_lang dictionary_id='54851.Spec Adı'></td>
                    <td class="txtbold" style="width:20mm;"><cf_get_lang dictionary_id='32916.Lot No'></td>
                    <td class="txtbold" style="width:15mm;" style="text-align:right;"><cf_get_lang dictionary_id='57635.Miktar'></td>
                    <th class="txtbold" style="width:15mm;"><cf_get_lang dictionary_id='57636.Birim'></th>
                </tr>
                <cfoutput query="get_product_sarf">
                    <tr>  
                        <td style="width:25mm; height:6mm;">#stock_code#</td>
                        <td style="width:80mm;">#product_name#<cfif get_spec.is_sevk eq 1> (SB)</cfif> </td>
                        <td style="width:20mm;"><cfif len(spect_main_id)>#spect_main_id#</cfif>&nbsp;</td>
                        <td style="width:20mm;"><cfif len(SPECT_MAIN_NAME)>#SPECT_MAIN_NAME#</cfif>&nbsp;</td>
                        <td style="width:20mm;"><cfif len(spect_main_id)>#lot_no#</cfif>&nbsp;</td>
                        <td style="width:15mm;" style="text-align:right;">#TlFormat(wrk_round(AMOUNT,8,1),8)#</td>
                        <td style="width:15mm;" style="text-align:right;">#main_unit#</td>
                    </tr>
                </cfoutput>
            </table>
            </td>
        </tr>
        <tr>
            <td colspan="3" style="width:180mm;">
            <br/><br/><br/><br/>
            <table border="1" width="100%" cellpadding="5" cellspacing="0">
                <cfoutput>
                <tr>
                    <td style="width:30mm;"><b><cf_get_lang dictionary_id='33320.Sevkiyat Bilgileri'></b></td>
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
    </table>
    <table>
        <tr>
            <td>
                <cfoutput query="CHECK">
                    <b>#CHECK.company_name#</b><br/>
                    #CHECK.address#<br/>
                    <b><cf_get_lang dictionary_id='57499.Telefon'>:</b> (#CHECK.tel_code#) - #CHECK.tel#,#CHECK.tel2#<br/>
                    <b><cf_get_lang dictionary_id='57488.Fax'>:</b> (#CHECK.tel_code#) #CHECK.fax#<br/>
                    #CHECK.web# - #CHECK.email# 
                </cfoutput>
            </td>
        </tr>
    </table>
</cfloop>
