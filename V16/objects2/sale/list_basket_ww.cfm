<script language="javascript">
	window.history.forward(1);
</script>
<cfif not isdefined("session.pp") and not isdefined("session.ww.userid") and not IsDefined("Cookie.wrk_basket_#ReplaceList(cgi.http_host,'-,:','_,_')#")>
	<cfset cookie_name_ = createUUID()>
	<cfcookie name="wrk_basket_#ReplaceList(cgi.http_host,'-,:','_,_')#" value="#cookie_name_#" expires="1">
</cfif>
<cfif not isdefined("attributes.is_control_zero_stock")>
	<cfset attributes.is_control_zero_stock = 1>
</cfif>
<cfif isdefined("session.ww.userid")>
	<cfquery name="GET_BLOCK_INFO" datasource="#DSN#">
		SELECT 
			BG.BLOCK_GROUP_PERMISSIONS BLOCK_STATUS
		FROM 
			COMPANY_BLOCK_REQUEST CBL,
			BLOCK_GROUP BG 
		WHERE 
			CBL.CONSUMER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ww.userid#"> AND
			CBL.BLOCK_GROUP_ID = BG.BLOCK_GROUP_ID AND
			CBL.BLOCK_START_DATE <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#"> AND
			ISNULL(CBL.BLOCK_FINISH_DATE,GETDATE()) >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">
	</cfquery>
<cfelse>
	<cfset get_block_info.recordcount = 0>
</cfif>
<cfquery name="DEL_PROM_ROWS" datasource="#DSN3#"><!--- kargo ürünü siliniyor --->
	DELETE FROM 
		ORDER_PRE_ROWS
	WHERE
		ISNULL(IS_CARGO,0) = 1 AND
		<cfif isdefined("session.pp")>
			RECORD_PAR = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.pp.userid#">
		<cfelseif isdefined("session.ww.userid")>
			RECORD_CONS = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ww.userid#">
		<cfelseif isdefined("session.ep.userid")>
			RECORD_EMP = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.userid#">
		<cfelse>
			1=2
		</cfif>
</cfquery>
<cfif (get_block_info.recordcount and listgetat(get_block_info.block_status,2,',') eq 0) or get_block_info.recordcount eq 0>
	<cfif isdefined("attributes.list_basket_image_width") and len(attributes.list_basket_image_width)>
		<cfset image_width_ = attributes.list_basket_image_width>
	<cfelse>	
		<cfset image_width_ = 70>
	</cfif>
	<cfif isdefined("attributes.list_basket_image_height") and len(attributes.list_basket_image_height)>
		<cfset image_height_ = attributes.list_basket_image_height>
	<cfelse>
		<cfset image_height_ = 70>
	</cfif>	
	<cfscript>
		if (listfindnocase(partner_url,'#cgi.http_host#',';'))
		{
			int_money = session.pp.money;
			int_comp_id = session.pp.our_company_id;
			int_period_id = session.pp.period_id;
			int_money2 = session.pp.money2;
		}
		else if (listfindnocase(server_url,'#cgi.http_host#',';') )
		{	
			int_money = session.ww.money;
			int_comp_id = session.ww.our_company_id;
			int_period_id = session.ww.period_id;
			int_money2 = session.ww.money2;
		}
		else
		{
			int_money = session.ep.money;
			int_comp_id = session.ep.company_id;
			int_period_id = session.ep.period_id;
			int_money2 = session.ep.money2;
		}
	</cfscript>   
	<cfif isdefined('attributes.is_basket_use_detail_promotion') and attributes.is_basket_use_detail_promotion eq 1>
	 <!--- detaylı promosyon calısacaksa --->
		<cfquery name="DEL_PROM_ROWS" datasource="#DSN3#"> <!--- daha once eklenmiş ve li promosyonlar siliniyor --->
			DELETE FROM 
				ORDER_PRE_ROWS
			WHERE
				<cfif isdefined('attributes.is_from_add_prom_prod') and attributes.is_from_add_prom_prod eq 1><!--- veyalı promosyon urunu eklenmisse, ve li promosyon urunleri silinip, yeniden hesaplanır --->
					PROM_WORK_TYPE IN (0) AND
				<cfelse>
					PROM_WORK_TYPE IN (0,1) AND
				</cfif>
				(ISNULL(PROD_PROM_ACTION_TYPE,0) = 0) AND
				ISNULL(IS_PROM_ASIL_HEDIYE,0) = 1 AND 
				<cfif isdefined("session.pp")>
					RECORD_PAR = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.pp.userid#">
				<cfelseif isdefined("session.ww.userid")>
					RECORD_CONS = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ww.userid#">
				<cfelseif isdefined("session.ep.userid")>
					RECORD_EMP = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.userid#">
				<cfelse>
					1=2
				</cfif>
		</cfquery>
		<cfquery name="UPD_PROM_ROWS" datasource="#DSN3#"> <!--- baskete eklenmis, fakat sonradan ekle degistir promosyon kazanc urunleriyle degistirilen satırlar geri alınıyor --->
			UPDATE 
				ORDER_PRE_ROWS
			SET
				PROD_PROM_ACTION_TYPE = 0,
				IS_PROM_ASIL_HEDIYE = 0,
				QUANTITY = ISNULL(QUANTITY_OLD,QUANTITY),
				PRICE = ISNULL(PRICE_OLD_2,PRICE),
				PRICE_KDV = ISNULL(PRICE_KDV_OLD,PRICE_KDV),
				PRICE_MONEY=ISNULL(PRICE_OLD_MONEY_2,PRICE_MONEY),
				IS_PRODUCT_PROMOTION_NONEFFECT = NULL,
				IS_NONDELETE_PRODUCT = NULL,
				PROM_ID=NULL
			WHERE
				ISNULL(PROD_PROM_ACTION_TYPE,0) = 1 AND 
				<cfif isdefined('attributes.is_from_add_prom_prod') and attributes.is_from_add_prom_prod eq 1><!--- veyalı promosyon urunu eklenmisse, ve li promosyon urunleri silinip, yeniden hesaplanır --->
					ISNULL(PROM_WORK_TYPE,0) = 0 AND
				</cfif>
				<!--- ISNULL(IS_PROM_ASIL_HEDIYE,0)=1 AND  --->
				<cfif isdefined("session.pp")>
					RECORD_PAR = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.pp.userid#">
				<cfelseif isdefined("session.ww.userid")>
					RECORD_CONS = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ww.userid#">
				<cfelseif isdefined("session.ep.userid")>
					RECORD_EMP = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.userid#">
				<cfelse>
					1=2
				</cfif>
		</cfquery>       
		<cfif fusebox.use_stock_speed_reserve> <!--- sipariste anında urun rezerve calısıyorsa, sepetteki urunlerin rezerveleri de siliniyor --->
			<cfinclude template="../../objects2/query/get_basket_rows.cfm">
			<!---<cfquery name="DEL_RESERVE_ROWS" datasource="#DSN3#">
				DELETE FROM ORDER_ROW_RESERVED WHERE PRE_ORDER_ID = <cfqueryparam cfsqltype="cf_sql_varchar" value="#CFTOKEN#">
			</cfquery>--->
            <cfstoredproc procedure="DEL_ORDER_ROW_RESERVED" datasource="#DSN3#">
    			<cfprocparam cfsqltype="cf_sql_varchar" value="#cftoken#">
    		</cfstoredproc>
			<cfoutput query="get_rows">
				<!--- Stok stratejisine göre action_type ı 1,2,3 olmayanlara rezerve yapılıyor --->
				<cfif (len(get_rows.stock_action_type) and not listfind('1,2,3',get_rows.stock_action_type,',')) or not len(get_rows.stock_action_type)>
					<cfquery name="ADD_RESERVE_" datasource="#DSN3#">
						INSERT INTO 
							ORDER_ROW_RESERVED
						(
							STOCK_ID,
							PRODUCT_ID,
							RESERVE_STOCK_OUT,
							ORDER_ROW_ID,
							PRE_ORDER_ID,
							IS_BASKET
						) 
						VALUES
						(
							#get_rows.stock_id#,
							#get_rows.product_id#,
							#quantity#,
							#order_row_id#,
							'#CFTOKEN#',
							1				
						)
					</cfquery>
				</cfif>
			</cfoutput>
		</cfif>
		<cfif isdefined('attributes.run_basket_promotions') and attributes.run_basket_promotions eq 1 or (isdefined('attributes.is_from_add_prom_prod') and attributes.is_from_add_prom_prod eq 1)>
			<cfinclude template="../query/get_basket_express_member_detail.cfm">
			<cfinclude template="add_order_demands.cfm">
			<cfinclude template="../query/get_basket_express_member_detail.cfm">
			<cfinclude template="../query/add_basket_detail_promotion_product.cfm">
		</cfif>
	</cfif>
	<cfinclude template="../query/get_basket_rows.cfm">
	<cfif isdefined("attributes.is_basket_stock_action_type") and attributes.is_basket_stock_action_type eq 1>
		<cfquery name="GET_SALEABLE_STOCK_ACTION" datasource="#DSN3#">
			SELECT STOCK_ACTION_ID,STOCK_ACTION_NAME,STOCK_ACTION_MESSAGE FROM SETUP_SALEABLE_STOCK_ACTION ORDER BY STOCK_ACTION_ID
		</cfquery>
		<cfset saleable_stock_action_list_=valuelist(get_saleable_stock_action.stock_action_id)>
	</cfif>
	<cfif isdefined("attributes.is_basket_product_images") and attributes.is_basket_product_images eq 1>
		<cfinclude template="../product/box.cfm">
		<cfset product_id_list = ''>
		<cfif get_rows.recordcount>
			<cfoutput query="get_rows">
				<cfif not listfindnocase(product_id_list,get_rows.product_id)>
					<cfset product_id_list = listappend(product_id_list,get_rows.product_id,',')>
				</cfif>
			</cfoutput>
			<cfif listlen(product_id_list)>
				<cfquery name="GET_PRODUCT_IMAGES" datasource="#DSN3#">
					SELECT PATH,PRODUCT_ID,PATH_SERVER_ID,DETAIL, STOCK_ID FROM PRODUCT_IMAGES WHERE IMAGE_SIZE = 0 AND PRODUCT_ID IN (#product_id_list#) ORDER BY PRODUCT_ID
				</cfquery>
				<cfset product_id_list = listdeleteduplicates(valuelist(get_product_images.PRODUCT_ID,','),'numeric','ASC',',')>
				<cfset product_id_list=listsort(product_id_list,"numeric","ASC",",")>
			</cfif>
		</cfif>
	</cfif>
	<cfquery name="GET_GENERAL_PROM" datasource="#DSN3#" maxrows="1">
		SELECT
			COMPANY_ID, 
			LIMIT_VALUE, 
			DISCOUNT, 
			AMOUNT_DISCOUNT,
			AMOUNT_DISCOUNT_MONEY_1, 
			PROM_ID,
			LIMIT_CURRENCY
		FROM 
			PROMOTIONS 
		WHERE 
			PROM_STATUS = 1 AND 
			PROM_TYPE = 0 AND 
			LIMIT_TYPE <> 1 AND 
			LIMIT_VALUE IS NOT NULL AND 
			DISCOUNT IS NOT NULL AND 
			<cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#"> BETWEEN STARTDATE AND FINISHDATE
		ORDER BY
			PROM_ID DESC
	</cfquery>
	<cfquery name="GET_COMP_MONEY" datasource="#DSN#">
		SELECT MONEY FROM SETUP_MONEY WHERE PERIOD_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#int_period_id#"> AND RATE1 = 1 AND RATE2 = 1
	</cfquery> 
	<cfset str_money_bskt_func = get_comp_money.money>
	<cfscript>session_basket_kur_ekle(process_type:0);</cfscript>
	<cfquery name="GET_MONEY" datasource="#DSN#">
		SELECT 
			COMPANY_ID,
			PERIOD_ID,
			MONEY,
			RATE1,
			<cfif isDefined("session.pp")>
				RATEPP2 RATE2
			<cfelse>
				RATEWW2 RATE2
			</cfif>
		FROM 
			SETUP_MONEY
		WHERE 
			PERIOD_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#int_period_id#">
	</cfquery>
	
	<cfquery name="GET_STDMONEY" dbtype="query">
		SELECT MONEY FROM GET_MONEY WHERE RATE2 = RATE1
	</cfquery>
	
	<cfquery name="GET_MONEY_MONEY2" dbtype="query">
		SELECT 
			RATE1,RATE2
		FROM 
			GET_MONEY
		WHERE 
			MONEY = <cfqueryparam cfsqltype="cf_sql_varchar" value="#int_money2#"> AND
			COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#int_comp_id#">
	</cfquery>
	
	<cfform name="form_basket_list_base" action="#request.self#?fuseaction=#attributes.fuseaction#" method="post">
        <table align="center" cellpadding="2" cellspacing="2" class="tblCanta" style="width:100%">
			<input type="hidden" name="fuseact" id="fuseact" value="<cfoutput>#attributes.fuseaction#</cfoutput>">
			<input type="hidden" name="is_add_orderww" id="is_add_orderww" value="1">
			<input type="hidden" name="form_complete" id="form_complete" value="1"/> <!--- sayfa yüklenirken kontrol icin FA --->
            <input type="hidden" name="is_control_zero_stock" id="is_control_zero_stock" value="<cfif isDefined('attributes.is_control_zero_stock') and len(attributes.is_control_zero_stock)><cfoutput>#attributes.is_control_zero_stock#</cfoutput></cfif>">
           	<input type="hidden" name="is_zero_stock_dept" id="is_zero_stock_dept" value="<cfif isdefined('attributes.is_zero_stock_dept') and len(attributes.is_zero_stock_dept)>#attributes.is_zero_stock_dept#</cfif>">
			<cfoutput>
				<cfloop query="get_money_bskt">
					<cfif str_money_bskt_func eq money_type>
						<input type="hidden" name="rd_money" id="rd_money" value="#currentrow#">
					</cfif>
					<input type="hidden" name="hidden_rd_money_#currentrow#" id="hidden_rd_money_#currentrow#" value="#money_type#">
					<input type="hidden" name="txt_rate1_#currentrow#" id="txt_rate1_#currentrow#" value="#rate1#">
					<input type="hidden" name="txt_rate2_#currentrow#" id="txt_rate2_#currentrow#" value="#rate2#">
				</cfloop>
				<input type="hidden" name="run_basket_promotions" id="run_basket_promotions" value="<cfif isdefined('attributes.run_basket_promotions') and len(attributes.run_basket_promotions)>#attributes.run_basket_promotions#<cfelse>0</cfif>">
				<input type="hidden" name="is_basket_use_detail_promotion" id="is_basket_use_detail_promotion" value="<cfif isdefined('attributes.is_basket_use_detail_promotion') and len(attributes.is_basket_use_detail_promotion)>#attributes.is_basket_use_detail_promotion#<cfelse>0</cfif>">
				<input type="hidden" name="kur_say" id="kur_say" value="#get_money_bskt.RecordCount#">
				<input type="hidden" name="basket_money" id="basket_money" value="#str_money_bskt_func#">
				<input type="hidden" name="consumer_id" id="consumer_id" value="<cfif isdefined('attributes.consumer_id') and len(attributes.consumer_id)>#attributes.consumer_id#</cfif>">
				<input type="hidden" name="company_id" id="company_id" value="<cfif isdefined('attributes.company_id') and len(attributes.company_id)>#attributes.company_id#</cfif>">
				<input type="hidden" name="partner_id" id="partner_id" value="<cfif isdefined('attributes.partner_id') and len(attributes.partner_id)>#attributes.partner_id#</cfif>">
			</cfoutput>
			<cfif get_rows.recordcount>
				<tr class="color-header" style="height:22px;">
					<cfif isdefined("attributes.is_basket_product_rows") and attributes.is_basket_product_rows eq 1>
						<td class="form-title" style="width:25px;"></td>
					</cfif>
					<cfif isdefined("attributes.is_basket_product_images") and attributes.is_basket_product_images eq 1>
						<td>&nbsp;</td>
					</cfif>
					<cfif isdefined('attributes.is_basket_special_code') and attributes.is_basket_special_code eq 1>
						<td class="form-title"><cf_get_lang_main no='377.Özel Kod'></td>
					</cfif>
					<cfif isdefined('attributes.is_stock_code') and attributes.is_stock_code eq 1>
						<td class="form-title">Stok Kodu</td>
					</cfif>
					<td class="form-title"><cf_get_lang_main no="245.Ürün"></td>
					<cfif isdefined('attributes.is_basket_use_detail_promotion') and attributes.is_basket_use_detail_promotion eq 1>
						<td class="form-title"><cf_get_lang no="266.İlgili Promosyon"></td>
					</cfif>
					<cfif isdefined('attributes.is_basket_stock_strategy') and attributes.is_basket_stock_strategy eq 1>
						<td class="form-title" style="width:60px;">Tedarik Süresi</td>
					</cfif>
					<td class="form-title"><cf_get_lang_main no="223.Miktar"></td>
					<td class="form-title" style="width:35px;"><cf_get_lang_main no ='224.Birim'></td>
					<cfif isdefined("attributes.is_basket_prices_session_money") and listfindnocase('1,4,5',attributes.is_basket_prices_session_money)>
						<td align="right" class="form-title" style="text-align:right; width:110px;">TL <cf_get_lang_main no='226.Birim Fiyat'></td>
					</cfif>
					<cfif isdefined("attributes.is_basket_prices_kdvsiz") and attributes.is_basket_prices_kdvsiz eq 1>
						<td align="right" class="form-title" style="text-align:right; width:110px;"><cf_get_lang_main no='2227.KDV siz'> <cf_get_lang_main no='226.Birim Fiyat'></td>
						<td align="right" class="form-title" style="text-align:right;"><cf_get_lang no="136.KDV siz Satır Toplam"></td>
					</cfif>
					<cfif isdefined("attributes.is_basket_prices_kdvli") and attributes.is_basket_prices_kdvli eq 1>
						<td align="right" class="form-title" style="text-align:right;"><cf_get_lang no="135.KDVli Birim Fiyat"></td>
						<td align="right" class="form-title" style="text-align:right;"><cf_get_lang no="137.KDVli Satır Toplam"></td>
					</cfif>
					<cfif isdefined("attributes.is_basket_prices_session_money") and listfindnocase('1,2,5',attributes.is_basket_prices_session_money)>
						<td align="right" class="form-title" style="text-align:right;"><cfoutput>#session_base.money#</cfoutput><cf_get_lang_main no ='672.Fiyat'> </td>
					</cfif>
					<cfif isdefined("attributes.is_basket_prices_session_money") and listfindnocase('1,3',attributes.is_basket_prices_session_money)>
						<td align="right" class="form-title" style="text-align:right;"><cfoutput>#session_base.money#</cfoutput> <cf_get_lang no="135.KDVli Fiyat"></td>
					</cfif>
					<cfif isdefined("attributes.is_basket_stock_action_type") and attributes.is_basket_stock_action_type eq 1>
						<td class="form-title"><cf_get_lang no ='1467.Hareket Türü'></td>
					</cfif>
					<td class="form-title" style="text-align:center; width:35px;"><cf_get_lang_main no ='51.Sil'></td>
				</tr>
				<cfset kontrol_stock_type = 0>
				<!--- Bu sayfada kontrol_stock_type_2' nin geçtiği yerler Barbaros Kuz' un isteğiyle Gökhan Acun tarafından kapatılmıştır. 6 Ay sonra silinebilir. 23092010 --->
				<cfset tum_toplam = 0>
				<cfset tum_toplam_kdvli = 0>
				<cfset genel_toplam = 0> <!--- promosyon bilgisinin goruntulenmesi bu toplama gore kontrol ediliyor --->
				<cfoutput query="get_rows">
					<!--- Stokta olmayan ürünlerde miktar güncellenmeyecek --->
					<cfset quantity_info=0>
					<cfif fusebox.use_stock_speed_reserve>
						<cfquery name="GET_OTHER_ROWS" dbtype="query">
							SELECT * FROM GET_ROWS WHERE STOCK_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_rows.stock_id#"> AND ORDER_ROW_ID <> <cfqueryparam cfsqltype="cf_sql_integer" value="#get_rows.order_row_id#"> AND STOCK_ACTION_TYPE IS NOT NULL AND STOCK_ACTION_TYPE IN(1,2,3)
						</cfquery>
						<cfif get_other_rows.recordcount>
							<cfset quantity_info=1>
						</cfif>
					</cfif>
					<tr height="<cfif isdefined("attributes.is_basket_product_images") and attributes.is_basket_product_images eq 1>#image_height_+20#<cfelse>25</cfif>" class="color-row">
						<cfif isdefined("attributes.is_basket_product_rows") and attributes.is_basket_product_rows eq 1> <td>#currentrow#</td></cfif>
						<cfif isdefined("attributes.is_basket_product_images") and attributes.is_basket_product_images eq 1>
                            <td style="width:#image_width_#px;">
                                <cfif listfind(product_id_list,product_id,',')>
                                    <!---#box_ust#--->
                                    <cfset image_server_ = get_product_images.path_server_id[listfind(product_id_list,product_id,',')]>
                                    <cfif image_server_ eq fusebox.server_machine>
                                        <cfset small_image_server = ''>
                                    <cfelse>
                                        <cfset small_image_server = listgetat(fusebox.server_machine_list,get_product_images.path_server_id[listfind(product_id_list,product_id,',')],';')>
                                    </cfif>
									<cfquery name="GET_PRODUCT_IMAGE" dbtype="query">
                                        SELECT * FROM GET_PRODUCT_IMAGES WHERE PRODUCT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#product_id#"> AND STOCK_ID LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%,#stock_id#,%">
                                    </cfquery>
                                    <cfif get_product_image.recordcount>
                                    	<a href="#url_friendly_request('objects2.detail_product&product_id=#product_id#&sid=#stock_id#','#user_friendly_url#')#" ><img src="#small_image_server#/documents/product/#get_product_images.path[listfind(product_id_list,product_id,',')]#" border="0" width="#image_width_#" height="#image_height_#" title="#get_product_images.detail[listfind(product_id_list,product_id,',')]#"></a>
                                    <cfelse>
										<a href="#url_friendly_request('objects2.detail_product&product_id=#product_id#&sid=#stock_id#','#user_friendly_url#')#" ><img src="../../objects2/image/no_img.png" width="#image_width_#" height="#image_height_#"></a>
									<!---<cfelse>
                                        <a href="#url_friendly_request('objects2.detail_product&product_id=#product_id#&sid=#stock_id#','#user_friendly_url#')#" ><img src="#small_image_server#/documents/product/#get_product_images.path[listfind(product_id_list,product_id,',')]#" border="0" width="#image_width_#" height="#image_height_#" title="#get_product_images.detail[listfind(product_id_list,product_id,',')]#"></a>  --->                          
                                    </cfif>                           
						        <cfelse>
									<a href="#request.self#?fuseaction=objects2.detail_product&product_id=#product_id#&stock_id=#stock_id#"><img src="../../objects2/image/no_img.png" width="#image_width_#" height="#image_height_#"></a>			
                                    <!---#box_alt#--->
                                </cfif>
                            </td>
                        </cfif>		  
                        <cfif isdefined('attributes.is_basket_special_code') and attributes.is_basket_special_code eq 1>
                            <td class="tableyazi">#stock_code_2#</td>
                        </cfif>
                        <cfif isdefined('attributes.is_stock_code') and attributes.is_stock_code eq 1>
                            <td class="tableyazi">#stock_code#</td>
                        </cfif>
                        <td>
                            <a href="#url_friendly_request('objects2.detail_product&product_id=#product_id#&sid=#stock_id#','#user_friendly_url#')#" class="tableyazi">#product_name#</a>
                            <cfif isdefined('attributes.is_basket_product_detail') and attributes.is_basket_product_detail eq 1>
                                <br />#product_detail#
                            </cfif>
                            <cfif len(prom_id) and not is_prom_asil_hediye>
                                <cfquery name="GET_PRO" datasource="#DSN3#">
                                    SELECT						
                                        ICON_ID,
                                        FREE_STOCK_ID,
                                        DISCOUNT,
                                        PROM_HEAD,
                                        AMOUNT_DISCOUNT,
                                        AMOUNT_DISCOUNT_MONEY_1,
                                        AMOUNT_1_MONEY
                                    FROM
                                        PROMOTIONS
                                    WHERE
                                        PROM_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#prom_id#">
                                </cfquery>
                                <cfif get_pro.recordcount>
                                  <cfif len(get_pro.icon_id) and (get_pro.icon_id gt 0)>
                                      <cfquery name="GET_ICON" datasource="#DSN3#">
                                            SELECT ICON, ICON_SERVER_ID FROM SETUP_PROMO_ICON WHERE ICON_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_pro.icon_id#">
                                        </cfquery>
                                        <br/>
                                      <cf_get_server_file output_file="sales/#get_icon.icon#" output_server="#get_icon.icon_server_id#" output_type="0" image_link=1 alt="#getLang('main',617)#" title="#getLang('main',617)#">
                                    </cfif>
                                    <font color="FF0000">
                                    <cfif len(get_pro.free_stock_id)>
                                        <strong>#get_pro.prom_head#:</strong> #get_product_name(stock_id:get_pro.free_stock_id,with_property:1)#
                                    </cfif>
                                    <cfif len(get_pro.discount) and get_pro.discount gt 0>
                                        <strong><cf_get_lang no='132.Yüzde İndirim'>:</strong> % #get_pro.discount#
                                    </cfif>
                                    <cfif len(get_pro.amount_discount) and get_pro.amount_discount gt 0>
                                        <strong><cf_get_lang no='133.Tutar Indirimi'>:</strong> #get_pro.amount_discount# <cfif len(get_pro.amount_discount_money_1)>#get_pro.amount_discount_money_1#<cfelse>#price_money#</cfif>
                                    </cfif>
                                    </font>
                                <cfelse>
                                    &nbsp;
                                </cfif>
                            </cfif>
                            <cfif len(is_prom_asil_hediye) and is_prom_asil_hediye eq 1 and not (len(prom_product_price) and prom_product_price gt 0)><strong>(<cf_get_lang no='131.Hediye'>)</strong></cfif> <!--- promosyon urunun promosyon bedeli varsa hediye yazılmıyor --->
                            <cfif is_spec eq 1>
                                <cfquery name="GET_INNER_ROWS" datasource="#DSN3#">
                                    SELECT PRODUCT_NAME,DIFF_PRICE,ROW_MONEY,AMOUNT FROM ORDER_PRE_ROWS_SPECS WHERE MAIN_ORDER_ROW_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#order_row_id#">
                                </cfquery>
                                <br/>
                                <a href="javascript://" onclick="gizle_goster(spect_#currentrow#);"><b><font color="##FF0000"><cf_get_lang no="139.Ürün Bileşenleri"></font></b></a>
                                <table style="display:none;" id="spect_#currentrow#">
                                    <tr>
                                        <td><cf_get_lang_main no="245.Ürün Adı"></td>
                                        <td style="width:60px;"><cf_get_lang_main no="223.Miktar"></td>
                                    </tr>
                                    <cfloop query="get_inner_rows">
                                        <tr>
                                            <td>#get_inner_rows.product_name#</td>
                                            <td>#get_inner_rows.amount#</td>
                                        </tr>
                                    </cfloop>
                                </table>
                            </cfif>
                        </td>
                        <cfif isdefined('attributes.is_basket_use_detail_promotion') and attributes.is_basket_use_detail_promotion eq 1>
                            <td class="tableyazi">
                                <cfif len(is_prom_asil_hediye) and is_prom_asil_hediye eq 1>
                                    <cfquery name="GET_PROM_HEAD" datasource="#DSN3#">
                                        SELECT						
                                            ICON_ID,
                                            FREE_STOCK_ID,
                                            DISCOUNT,
                                            PROM_HEAD,
                                            AMOUNT_DISCOUNT,
                                            AMOUNT_DISCOUNT_MONEY_1,
                                            AMOUNT_1_MONEY
                                        FROM
                                            PROMOTIONS
                                        WHERE
                                            PROM_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#prom_id#">
                                    </cfquery>
                                    <cfquery name="GET_PRO_INFO" datasource="#DSN3#">
                                        SELECT						
                                            IS_INVENTORY
                                        FROM
                                            PRODUCT
                                        WHERE
                                            PRODUCT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#product_id#">
                                    </cfquery>
                                    <cfif get_pro_info.is_inventory eq 1>
                                        #get_prom_head.prom_head#<!--- BK kaldirdi Dore icin 20101022 : #PROM_ID# --->		 
                                    </cfif>
                                </cfif>
                            </td>
                        </cfif>
                        <cfif isdefined('attributes.is_basket_stock_strategy') and attributes.is_basket_stock_strategy eq 1>
                            <cfquery name="GET_STOCK_STRATEGY" datasource="#DSN3#">
                                SELECT PROVISION_TIME FROM STOCK_STRATEGY WHERE STOCK_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#stock_id#"> AND PRODUCT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#product_id#">
                            </cfquery>
                            <td><cfif get_stock_strategy.recordcount>#get_stock_strategy.provision_time# Gün</cfif></td>
                        </cfif>
                        <td>
                            <cfinput type="hidden" name="control_amount_#order_row_id#" id="control_amount_#order_row_id#" value="#TLFormat(quantity*prom_stock_amount,fusebox.Format_Currency)#">
                            <cfsavecontent variable="message">#currentrow# no lu üründe miktar girmelisiniz !</cfsavecontent>
                            <cfsavecontent variable="message2">Ürün Miktarını Değiştirmek İçin Ürünü Sepetten Silip Tekrar Eklemelisiniz !</cfsavecontent>
                            <cfif (len(prom_free_stock_id) and prom_free_stock_id eq 1) or len(unique_relation_id) or (len(is_prom_asil_hediye) and is_prom_asil_hediye eq 1) or stock_action_type eq -1 or quantity_info eq 1>
                                <cfif quantity_info eq 1>
                                    <cfinput type="text" name="amount_#order_row_id#" id="amount_#order_row_id#" value="#TLFormat(quantity*prom_stock_amount,fusebox.Format_Currency)#" validate="integer" maxlength="8" required="yes" message="#message#" class="moneybox" readonly="yes" onKeyUp="return FormatCurrency(this,event,#fusebox.Format_Currency#);" passthrough="onBlur='if(filterNum(this.value) <=0) this.value=1;'" onClick="alert('#message2#');" style="width:40px">
                                <cfelse>
                                    <cfinput type="text" name="amount_#order_row_id#" id="amount_#order_row_id#" value="#TLFormat(quantity*prom_stock_amount,fusebox.Format_Currency)#" validate="integer" maxlength="8" required="yes" message="#message#" class="moneybox" readonly="yes" onKeyUp="return FormatCurrency(this,event,#fusebox.Format_Currency#);" passthrough="onBlur='if(filterNum(this.value) <=0) this.value=1;'" style="width:40px">
                                </cfif>
                            <cfelse>
                                <cfinput type="text" name="amount_#order_row_id#" id="amount_#order_row_id#" value="#TLFormat(quantity*prom_stock_amount,fusebox.Format_Currency)#" validate="integer" maxlength="8" required="yes" message="#message#" class="moneybox" onKeyUp="return FormatCurrency(this,event,#fusebox.Format_Currency#);" passthrough="onBlur='if(filterNum(this.value) <=0) this.value=1;'" style="width:40px"><!--- BK eski halleri 20110725 onKeyUp="isNumber(this);" --->
                        	</cfif>
				  		</td>
				 		<td align="center">#main_unit#</td>
						<cfquery name="GET_MONEY_RATE2" dbtype="query">
							SELECT 
								RATE2
							FROM 
								GET_MONEY
							WHERE 
								MONEY = <cfqueryparam cfsqltype="cf_sql_varchar" value="#price_money#"> AND
								COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#int_comp_id#">
						</cfquery>
						<cfif isdefined("attributes.is_basket_prices_session_money") and listfindnocase('1,4,5',attributes.is_basket_prices_session_money)>
							<td align="right" class="tableyazi" style="text-align:right;">
								<cfif len(price_old)>
									<strike>#TLFormat(price_old * get_money_rate2.rate2)# #session_base.money#</strike><br/>
								</cfif>
								#TLFormat(price * get_money_rate2.rate2)# #session_base.money# 
							</td>
						</cfif>
						<cfif isdefined("attributes.is_basket_prices_kdvsiz") and attributes.is_basket_prices_kdvsiz eq 1>
							<td align="right" class="tableyazi" style="text-align:right;">
								<cfif len(price_old)>
									<strike>#TLFormat(price_old)# #price_money#</strike><br/>
								</cfif>
								#TLFormat(price)# #price_money#
							</td>
							<td <cfif (len(stock_action_type) and not listfind('1,2,3',stock_action_type)) or not len(stock_action_type)>style="text-align:right;"<cfelse>align="center"</cfif> class="tableyazi">
								<cfif (len(stock_action_type) and not listfind('1,2,3',stock_action_type)) or not len(stock_action_type)>
                                    #TLFormat(price * quantity * prom_stock_amount)#
                                    #price_money#
                                <cfelse>
                                    ---	
                                </cfif>
							</td>
						</cfif>
						<cfif isdefined("attributes.is_basket_prices_kdvli") and attributes.is_basket_prices_kdvli eq 1>
							<td align="right" class="tableyazi" style="text-align:right;"> #TLFormat((price+price*tax/100))# #price_money#</td>
							<td <cfif (len(stock_action_type) and not listfind('1,2,3',stock_action_type)) or not len(stock_action_type)>align="right" style="text-align:right"<cfelse>align="center"</cfif> class="tableyazi">
								<cfif (len(stock_action_type) and not listfind('1,2,3',stock_action_type)) or not len(stock_action_type)>
									#TLFormat((price+price*tax/100) * quantity * prom_stock_amount)#
									#price_money#
								<cfelse>
									---	
								</cfif>
							</td>
						</cfif>
						<cfif isdefined("attributes.is_basket_prices_session_money") and listfindnocase('1,2,5',attributes.is_basket_prices_session_money)>
							<td align="right" class="tableyazi" style="text-align:right;"><cfif (len(stock_action_type) and not listfind('1,2,3',stock_action_type)) or not len(stock_action_type)>#TLFormat(price * quantity * prom_stock_amount * get_money_rate2.rate2)#<cfelse>---</cfif></td>
						</cfif>
						<cfif isdefined("attributes.is_basket_prices_session_money") and listfindnocase('1,3',attributes.is_basket_prices_session_money)>
							<td <cfif (len(stock_action_type) and not listfind('1,2,3',stock_action_type)) or not len(stock_action_type)>style="text-align:right"<cfelse>align="center"</cfif> class="tableyazi"><cfif (len(stock_action_type) and not listfind('1,2,3',stock_action_type)) or not len(stock_action_type)>#TLFormat((price+price*tax/100) * quantity * prom_stock_amount * get_money_rate2.rate2)#<cfelse>---</cfif></td>
						</cfif>
						<cfif isdefined("attributes.is_basket_stock_action_type") and attributes.is_basket_stock_action_type eq 1>
							<td class="tableyazi">
								<cfif stock_action_type eq -1>
									Bekleyen Siparişten Eklenen Ürün
								<cfelseif stock_action_type eq -2>
									Gecikme Cezası
								<cfelse>
									#get_saleable_stock_action.stock_action_message[listfind(saleable_stock_action_list_,stock_action_id)]#
								</cfif>
								<cfif len(stock_action_type) and stock_action_type eq 4 and len(pre_stock_id)>
									<cfquery name="GET_ALTERNATIVE_NAME" datasource="#DSN3#">
										SELECT STOCK_CODE_2 FROM STOCKS WHERE STOCK_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#pre_stock_id#">
									</cfquery>
									<b>(#get_alternative_name.stock_code_2#)</b>
								</cfif>
							</td>
						</cfif>
						<td align="center">
                        	<cfif is_nondelete_product eq 0>
								<a href="javascript://" onclick="sil(#order_row_id#,'#stock_action_type#','#demand_id#');" class="rowdelete" title="<cf_get_lang_main no='51.Sil'>"></a>
							</cfif>
                        </td>
					</tr>
					<cfscript>
						if((not is_prom_asil_hediye or (len(prom_product_price) and prom_product_price gt 0)) and (not len(stock_action_type) or (len(stock_action_type) and not listfind('1,2,3',stock_action_type)))) //promosyon verilen urunun promosyon fiyatı varsa toplama eklenir
						{
							satir_toplam_std = wrk_round((price*quantity*prom_stock_amount*get_money_rate2.rate2),4);
							tum_toplam = tum_toplam + satir_toplam_std;
							satir_toplam_std_kdvli =wrk_round(((price+price*tax/100)*quantity*prom_stock_amount*get_money_rate2.rate2),4);
							tum_toplam_kdvli = tum_toplam_kdvli + satir_toplam_std_kdvli;
						}
					</cfscript>	
					<cfif not len(stock_action_type) or (len(stock_action_type) and not listfind('1,2,3',stock_action_type))>
						<cfset kontrol_stock_type = 1>
					</cfif>
					<!--- Bu sayfada kontrol_stock_type_2' nin geçtiği yerler Barbaros Kuz' un isteğiyle Gökhan Acun tarafından kapatılmıştır. 6 Ay sonra silinebilir. 23092010 --->
				</cfoutput> 
				<cfif get_general_prom.recordcount>
					<cfquery name="GET_GENERAL_PROM_MONEY" dbtype="query">
						SELECT 
							RATE1,RATE2
						FROM 
							GET_MONEY
						WHERE 
							MONEY = <cfqueryparam cfsqltype="cf_sql_varchar" value="#get_general_prom.limit_currency#"> AND
							COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#int_comp_id#">
					</cfquery>
					<cfset get_general_prom_limit_value = get_general_prom.limit_value * (get_general_prom_money.rate2 / get_general_prom_money.rate1)>
				</cfif>
			  	<cfif (len(get_general_prom.limit_value) and len(get_general_prom.discount) and get_general_prom_limit_value lte tum_toplam)>
					<cfset kdvsiz_toplam_indirimli = tum_toplam * ((100 - get_general_prom.discount)/100)>
					<cfset kdvli_toplam_indirimli = 0>
					<cfoutput query="get_rows">
						<cfif (not is_prom_asil_hediye)>
							<cfquery name="GET_MONEY_RATE2" dbtype="query" >
								SELECT 
									RATE2
								FROM 
									GET_MONEY
								WHERE 
									MONEY = <cfqueryparam cfsqltype="cf_sql_varchar" value="#price_money#"> AND
									COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#int_comp_id#">
							</cfquery>
							<cfscript>
								satir_toplam_kdvsiz = wrk_round((price*quantity*prom_stock_amount*get_money_rate2.rate2),4);
								toplam_indirim = tum_toplam *wrk_round((get_general_prom.discount/100),4);
								satir_agirligi = satir_toplam_kdvsiz / tum_toplam;
								satir_indirim = toplam_indirim * satir_agirligi;
								satir_kdvli_toplam_indirimli = wrk_round(((satir_toplam_kdvsiz-satir_indirim)*(1+(TAX/100))),4);
								kdvli_toplam_indirimli = kdvli_toplam_indirimli + satir_kdvli_toplam_indirimli;
							</cfscript>
						</cfif>
					</cfoutput>	
					<cfset tum_toplam = kdvsiz_toplam_indirimli>
					<cfset tum_toplam_kdvli = kdvli_toplam_indirimli>
					<cfset genel_toplam =  tum_toplam>
			  	</cfif>
				<cfquery name="GET_GENERAL_PROM_2" datasource="#DSN3#" maxrows="1">
					SELECT 
						P.COMPANY_ID, 
						P.LIMIT_VALUE, 
						P.DISCOUNT, 
						P.AMOUNT_DISCOUNT, 
						P.PROM_ID,
						P.LIMIT_CURRENCY,
						P.LIMIT_TYPE,
						P.FREE_STOCK_ID,
						P.FREE_STOCK_AMOUNT,
						P.FREE_STOCK_PRICE,
						P.AMOUNT_1_MONEY,
						S.PRODUCT_NAME,
						S.PROPERTY
					FROM 
						PROMOTIONS P,
						STOCKS S
					WHERE 
						P.FREE_STOCK_ID = S.STOCK_ID AND 
						P.PROM_STATUS = 1 AND 
						P.PROM_TYPE = 0 AND 
						P.FREE_STOCK_ID IS NOT NULL AND 
						P.FREE_STOCK_AMOUNT IS NOT NULL AND 
						P.FREE_STOCK_PRICE IS NOT NULL AND 
						P.LIMIT_VALUE IS NOT NULL AND 
						<cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#"> BETWEEN P.STARTDATE AND P.FINISHDATE
					ORDER BY
						P.PROM_ID DESC
				</cfquery>
				<cfif get_general_prom_2.recordcount>
					<cfquery name="GET_GENERAL_PROM_2_MONEY" dbtype="query">
						SELECT 
							RATE1,RATE2
						FROM 
							GET_MONEY
						WHERE 
							MONEY = <cfqueryparam cfsqltype="cf_sql_varchar" value="#get_general_prom_2.limit_currency#"> AND
							COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#int_comp_id#">
					</cfquery>
					<cfset get_general_prom_2_limit_value = get_general_prom_2.limit_value * (get_general_prom_2_money.rate2 / get_general_prom_2_money.rate1)>
				</cfif>
				<cfoutput>
					<cfif get_general_prom_2.recordcount and (len(get_general_prom_2.limit_value) and get_general_prom_2.limit_value lte tum_toplam)>
						<tr class="color-row" style="height:20px;">
							<cfif isdefined("attributes.is_basket_product_rows") and attributes.is_basket_product_rows eq 1><td>#get_rows.recordcount+1#</td></cfif>
						  	<cfif isdefined("attributes.is_basket_product_images") and attributes.is_basket_product_images eq 1>
								<td style="vertical-align:top;">&nbsp;</td>
						  	</cfif>
						  	<cfif isdefined('attributes.is_basket_special_code') and attributes.is_basket_special_code eq 1>
						  		<td style="vertical-align:top;">&nbsp;</td>
						  	</cfif>
						  	<td style="vertical-align:top;">
								#get_general_prom_2.product_name# #get_general_prom_2.property#
								<strong>(<cf_get_lang no="131.Hediye"> - Genel P)</strong>
						  	</td>
						  	<cfif isdefined('attributes.is_basket_stock_strategy') and attributes.is_basket_stock_strategy eq 1>
								<td style="vertical-align:top;"></td>
						  	</cfif>
						  	<cfif isdefined('attributes.is_basket_use_detail_promotion') and attributes.is_basket_use_detail_promotion eq 1>
							 	<td class="form-title" style="vertical-align:top;"></td>
						  	</cfif>
						 	<cfif isdefined('attributes.is_basket_stock_strategy') and attributes.is_basket_stock_strategy eq 1>
								<td class="form-title" style="width:60px;"></td>
						  	</cfif>
						  	<td><cfinput type="text" name="amount_gp" value="#get_general_prom_2.free_stock_amount#" style="width:40px" validate="integer" required="yes" class="box" readonly="yes"></td>
						  	<cfif isdefined("attributes.is_basket_prices_kdvsiz") and attributes.is_basket_prices_kdvsiz eq 1>
								<td align="right" class="tableyazi" style="text-align:right;">#TLFormat(get_general_prom_2.free_stock_price)# #get_general_prom_2.amount_1_money#</td>
							  	<td align="right" class="tableyazi" style="text-align:right;">0 #get_general_prom_2.amount_1_money#</td>
						  	</cfif>
						  	<cfif isdefined("attributes.is_basket_prices_kdvli") and attributes.is_basket_prices_kdvli eq 1>
								<td></td>
							  	<td></td>
						  	</cfif>
						  	<td align="center">&nbsp;</td>
						  	<td align="center">&nbsp;</td>
						</tr>
					</cfif>
				</cfoutput>
			</table>
		<br/>
		<cfif (isdefined('attributes.is_basket_kur') and attributes.is_basket_kur eq 1) or (isdefined("attributes.is_basket_prices_total") and attributes.is_basket_prices_total eq 1)>
			<hr style="color:CCCCCC; height:0.1px;">
		</cfif>
		<table align="right" style="width:100%">
			<cfoutput>
			<cfif isdefined('attributes.is_basket_use_detail_promotion') and attributes.is_basket_use_detail_promotion eq 1>
                <cfif isdefined('attributes.run_basket_promotions') and attributes.run_basket_promotions eq 1>
                    <cfquery name="GET_PROMS" datasource="#DSN3#" maxrows="1">
                        SELECT 
                            PROM_DETAIL,
                            DETAIL_PROM_TYPE
                        FROM 
                            PROMOTIONS 
                        WHERE 
                            IS_DETAIL = 1 
                            AND IS_PROM_WARNING = 1 
                            AND PROM_STATUS = 1
                            AND PROM_HIERARCHY > 
                                            ISNULL((
                                            SELECT 
                                                TOP 1
                                                P.PROM_HIERARCHY
                                            FROM
                                                ORDER_PRE_ROWS OPR,
                                                PROMOTIONS P
                                            WHERE
                                                <cfif isdefined("session.pp")>
                                                    OPR.RECORD_PAR = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.pp.userid#">
                                                <cfelseif isdefined("session.ww.userid")>
                                                    OPR.RECORD_CONS = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ww.userid#">
                                                <cfelseif isdefined("session.ep")>
                                                    OPR.RECORD_EMP = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.userid#">
                                                <cfelse>
                                                    1 = 0
                                                </cfif>	
                                                AND OPR.PROM_ID = P.PROM_ID
                                                AND P.IS_PROM_WARNING = 1
                                                AND OPR.PROM_ID IS NOT NULL
                                            ),-1)
                            AND PROM_ID NOT IN(
                                                SELECT 
                                                    OPR.PROM_ID
                                                FROM
                                                    ORDER_PRE_ROWS OPR,
                                                    PROMOTIONS P
                                                WHERE
                                                    <cfif isdefined("session.pp")>
                                                        OPR.RECORD_PAR = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.pp.userid#">
                                                    <cfelseif isdefined("session.ww.userid")>
                                                        OPR.RECORD_CONS = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ww.userid#">
                                                    <cfelseif isdefined("session.ep")>
                                                        OPR.RECORD_EMP = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.userid#">
                                                    <cfelse>
                                                        1 = 0														
                                                    </cfif>	
                                                    AND OPR.PROM_ID = P.PROM_ID
                                                    AND P.IS_PROM_WARNING = 1
                                                ) 
                        ORDER BY 
                            PROM_HIERARCHY
                    </cfquery>
                    <cfif get_proms.recordcount and (get_proms.detail_prom_type neq 4 or (get_proms.detail_prom_type eq 4 and not(isdefined("cargo_product_id") and len(cargo_product_id))))>
                        <tr>
                            <td style="vertical-align:top;">
                                <font color="##FF0000" size="+1">#get_proms.prom_detail#</font>
                            </td>
                        </tr>
                    </cfif>
                </cfif>
            </cfif>
            <tr style="height:20px;">
				<cfif isdefined('attributes.is_basket_kur') and attributes.is_basket_kur eq 1>
                    <cfquery name="GET_KUR" dbtype="query">
                        SELECT 
                            * 
                        FROM 
                            GET_MONEY 
                        WHERE 
                            <cfif isdefined("session.pp.money")>
                                MONEY <> <cfqueryparam cfsqltype="cf_sql_varchar" value="#session.pp.money#">
                            <cfelseif isdefined("session.ww.money")>
                                MONEY <> <cfqueryparam cfsqltype="cf_sql_varchar" value="#session.ww.money#">
                            <cfelse>
                                MONEY <> <cfqueryparam cfsqltype="cf_sql_varchar" value="#session.ep.money#">
                            </cfif>
                        ORDER BY 
                            MONEY
                    </cfquery>
                    <cfset row_span_count = 0>
                    <cfif isdefined("attributes.is_basket_prices_total") and attributes.is_basket_prices_total eq 1>
                    	<cfset row_span_count = row_span_count + 1>
                    </cfif>
                    <cfif isdefined("attributes.is_basket_prices_total") and attributes.is_basket_prices_total eq 1>
                    	<cfif (len(get_general_prom.limit_value) and len(get_general_prom.discount) and get_general_prom.limit_value lte genel_toplam)>
                    		<cfset row_span_count = row_span_count + 1>
                    	</cfif>
                        <cfset row_span_count = row_span_count + 1>
                        <cfif isdefined("attributes.is_basket_prices_total_kdv") and attributes.is_basket_prices_total_kdv eq 1>
                        	<cfset row_span_count = row_span_count + 2>
                        </cfif>
                        <cfset row_span_count = row_span_count + 1>
                        <cfif isdefined("attributes.is_last_price") and isdefined("attributes.price_catid") and attributes.is_last_price eq 1 and len(attributes.price_catid)>
                        	<cfset row_span_count = row_span_count + 3>
                        </cfif>
                    </cfif>
                    <cfif isdefined("order_total_money_credit") and order_total_money_credit gt 0>
						<cfset row_span_count = row_span_count + 1>
                    </cfif>
                    <td rowspan="<cfoutput>#row_span_count#</cfoutput>" align="left">
                        <table>
                            <tr>
                                <td colspan="2" class="txtbold"><cf_get_lang no="140.Kurlar"></td>
                            </tr>
                            <cfloop query="get_kur">
                                <tr>
                                    <td class="txtbold">#money#</td>
                                    <td align="right" style="text-align:right;">#TLFormat(rate2,4)#</td>
                                </tr>
                            </cfloop>
                        </table>
                    </td>
                </cfif>
                <cfif isdefined("attributes.is_basket_prices_total") and attributes.is_basket_prices_total eq 1>
                    <td class="basket_total" style="text-align:right;"><cf_get_lang_main no ='80.Toplam'> (<cf_get_lang no ='141.KDV Hariç'>)</td>
                    <td class="tableyazi" style="width:90px;text-align:right;">#TLFormat(tum_toplam)# #get_stdmoney.money#</td>
                    <cfif isdefined("attributes.is_basket_prices_total_other_money") and attributes.is_basket_prices_total_other_money eq 1>
                        <td class="tableyazi" align="right" style="width:90px;"><cfif len(get_money_money2.rate2)>#TLFormat(tum_toplam/get_money_money2.rate2/get_money_money2.rate1)# #int_money2#</cfif></td>
                    </cfif>
                </cfif>
			</tr>
			<cfif isdefined("attributes.is_basket_prices_total") and attributes.is_basket_prices_total eq 1>
				<cfif (len(get_general_prom.limit_value) and len(get_general_prom.discount) and get_general_prom.limit_value lte genel_toplam)>
				<tr style="height:20px;">
					<td class="basket_total"><cf_get_lang no='1305.Genel Promosyon İskontosu'></td>
					<td class="tableyazi" style="text-align:right;">#TLFormat(toplam_indirim)# #get_stdmoney.money#</td>
					<cfif isdefined("attributes.is_basket_prices_total_other_money") and attributes.is_basket_prices_total_other_money eq 1>
						<td align="right" class="tableyazi">#TLFormat(toplam_indirim/get_money_money2.rate2/get_money_money2.rate1)# #int_money2#</td>
					</cfif>
				</tr>
				</cfif>
				<tr style="height:1px;">
					<td colspan="3"><hr style="width:100%;"></td>
				</tr>
				<cfif isdefined("attributes.is_basket_prices_total_kdv") and attributes.is_basket_prices_total_kdv eq 1>
					<tr style="height:20px;">
						<td class="basket_total" style="text-align:right;">KDV</td>
						<td class="tableyazi" align="right" style="text-align:right;"><cfset all_total_kdv = (#tum_toplam_kdvli#-#tum_toplam#)>
							#TLFormat(all_total_kdv)# #get_stdmoney.money#
						</td>
						<cfif isdefined("attributes.is_basket_prices_total_other_money") and attributes.is_basket_prices_total_other_money eq 1>
						<td class="tableyazi" align="right">
							<cfif len(get_money_money2.rate2)>
								#TLFormat(all_total_kdv/get_money_money2.rate2/get_money_money2.rate1)# #int_money2#
							</cfif>
						</td>
						</cfif>
					</tr>
                    <tr style="height:1px;">
                        <td colspan="3"><hr style="width:100%;"></td>
                    </tr>
				</cfif>
				<tr style="height:20px;">
					<td class="basket_total" style="text-align:right;"><cf_get_lang_main no ='80.Toplam'> (<cf_get_lang no ='142.KDV Dahil'>)</td>
					<td class="tableyazi" align="right" style="text-align:right;">#TLFormat(tum_toplam_kdvli)# #get_stdmoney.money#</td>
					<cfif isdefined("attributes.is_basket_prices_total_other_money") and attributes.is_basket_prices_total_other_money eq 1>
						<td class="tableyazi" align="right"><cfif len(get_money_money2.rate2)>#TLFormat(tum_toplam_kdvli/get_money_money2.rate2/get_money_money2.rate1)# #int_money2#</cfif></td>
					</cfif>
				</tr>
				<cfif isdefined("attributes.is_last_price") and isdefined("attributes.price_catid") and attributes.is_last_price eq 1 and len(attributes.price_catid)>
					<cfinclude template="../query/get_basket_price_total.cfm">
					<cfif len(get_basket_price_total_.total_price) and len(tum_toplam_kdvli)>
						<cfif len(get_other_products.total_p)>
							<cfset total_profit = wrk_round(get_basket_price_total_.total_price-(tum_toplam_kdvli-get_other_products.total_p))>
						<cfelse>
							<cfset total_profit = wrk_round(get_basket_price_total_.total_price-tum_toplam_kdvli)>
						</cfif>
					<cfelse>
						<cfset total_profit = 0>
					</cfif>
                    <tr style="height:1px;">
						<td colspan="3"><hr style="width:100%;"></td>
					</tr>
					<tr style="height:20px;">
						<td class="basket_total" style="text-align:right;">İndirim Öncesi Fiyat Toplam</td>
						<td class="tableyazi" align="right" style="text-align:right;"><cfif len(get_basket_price_total_.total_price)>#TLFormat(get_basket_price_total_.total_price)#<cfelse>0</cfif> #get_stdmoney.money#</td>
						<cfif isdefined("attributes.is_basket_prices_total_other_money") and attributes.is_basket_prices_total_other_money eq 1>
							<td class="tableyazi" align="right">
								<cfif len(get_money_money2.rate2) and len(get_basket_price_total_.total_price)>
									#TLFormat(get_basket_price_total_.total_price/get_money_money2.rate2/get_money_money2.rate1)# #int_money2#
								</cfif>
							</td>
						</cfif>
					</tr>
					<tr style="height:20px;">
						<td class="basket_total" style="text-align:right;">Toplam Kazancınız</td>
						<td class="tableyazi" align="right" style="text-align:right;">#TLFormat(total_profit)# #get_stdmoney.money#</td>
						<cfif isdefined("attributes.is_basket_prices_total_other_money") and attributes.is_basket_prices_total_other_money eq 1>
							<td class="tableyazi" align="right">
								<cfif len(get_money_money2.rate2)>
									#TLFormat(total_profit/get_money_money2.rate2/get_money_money2.rate1)# #int_money2#
								</cfif>
							</td>
						</cfif>
					</tr>
				</cfif>
				<input type="hidden" name="grosstotal" id="grosstotal" value="#tum_toplam_kdvli#">
			</cfif>
			<cfif isdefined("credit_card_bank_payment_list") and len(credit_card_bank_payment_list)>
				<input type="hidden" name="credit_card_bank_payment_list" id="credit_card_bank_payment_list" value="<cfoutput>#credit_card_bank_payment_list#</cfoutput>">
			</cfif>
			<cfif isdefined("cargo_product_id") and len(cargo_product_id)>
				<input type="hidden" name="cargo_product_id" id="cargo_product_id" value="<cfoutput>#cargo_product_id#</cfoutput>">
				<input type="hidden" name="cargo_product_price" id="cargo_product_price" value="<cfoutput>#cargo_product_price#</cfoutput>">
				<input type="hidden" name="cargo_product_tax" id="cargo_product_tax" value="<cfoutput>#cargo_product_tax#</cfoutput>">
			</cfif>
			<cfif isdefined("order_total_money_credit") and order_total_money_credit gt 0>
				<input type="hidden" name="order_money_credit_count" id="order_money_credit_count" value="<cfoutput>#order_money_credit_count#</cfoutput>">
				<cfloop from="1" to="#order_money_credit_count#" index="crdt_indx">
					<input type="hidden" name="credit_rate_#crdt_indx#" id="credit_rate_#crdt_indx#" value="#evaluate('credit_rate_#crdt_indx#')#">
					<input type="hidden" name="order_total_money_credit_#crdt_indx#" id="order_total_money_credit_#crdt_indx#" value="#evaluate('order_total_money_credit_#crdt_indx#')#">
					<input type="hidden" name="credit_valid_date_#crdt_indx#" id="credit_valid_date_#crdt_indx#" value="#evaluate('credit_valid_date_#crdt_indx#')#">
				</cfloop>
				<tr style="height:20px;">
					<td class="basket_total" style="text-align:right;">Kazanılan Parapuan</td>
					<td class="tableyazi" style="text-align:right;">#TLFormat(order_total_money_credit)# #get_stdmoney.money#</td>
					<cfif isdefined("attributes.is_basket_prices_total_other_money") and attributes.is_basket_prices_total_other_money eq 1>
						<td class="tableyazi" align="right"></td>
					</cfif>
				</tr>
			</cfif>
			</cfoutput>
		</table>
		<cfif (isdefined('attributes.is_basket_kur') and attributes.is_basket_kur eq 1) or (isdefined("attributes.is_basket_prices_total") and attributes.is_basket_prices_total eq 1)>
			<hr style="color:CCCCCC; height:0.1px;">
		</cfif>
		<table align="center" style="width:98%">
			<cfoutput>				
				<cfif isdefined("session_base.userid")>
					<tr style="height:20px;">
						<td align="right">
							<div class="butonTasi">
								<table align="right">
									<tr>
										<td nowrap="nowrap">
											<cfif isdefined('attributes.btn_devam_link') and len(attributes.btn_devam_link)>
												<a href="#attributes.btn_devam_link#" class="btnDevam">Alışverişe Devam Et</a>
											<cfelse>
												 <a href="#request.self#?fuseaction=objects2.view_product_list" class="btnDevam">Alışverişe Devam Et</a>
											</cfif>
										</td>
										<cfif kontrol_stock_type eq 1>		
											<cfif isdefined("attributes.is_basket_offer") and attributes.is_basket_offer eq 1>				
												<td><a href="#request.self#?fuseaction=objects2.add_offer" class="basket_offer"></a></td>
												<td><a href="##" onclick="<cfoutput>windowopen('#request.self#?fuseaction=objects2.popup_list_basketww_proposal','project')</cfoutput>" class="basket_print"></a></td>
											</cfif>
										</cfif>
										<td><!---<a href="##" onclick="amountChange();" class="basket_fiyat"></a>--->
											<input type="button" onclick="amountChange();" class="basket_fiyat" value="<cf_get_lang no='269.Sepeti Güncelle'>">
                                        </td>
										<cfsavecontent variable="message"><cf_get_lang no="146.Sepeti boşaltmak istediğinize emin misiniz"></cfsavecontent>
										<td><!---<a href="##" onclick="if (confirm('#message#')) window.location='<cfoutput>#request.self#?fuseaction=objects2.emptypopup_del_basketww</cfoutput>'" class="basket_delete"></a>--->
											<input type="button" onclick="if (confirm('#message#')) window.location='<cfoutput>#request.self#?fuseaction=objects2.emptypopup_del_basketww</cfoutput>'" class="basket_delete" value="<cf_get_lang no='147.Sepeti Boşalt'>">
										</td>
										<cfif kontrol_stock_type eq 1>
											<cfif isdefined('attributes.is_basket_use_detail_promotion') and attributes.is_basket_use_detail_promotion eq 1>
												<cfif isdefined("attributes.run_basket_promotions") and attributes.run_basket_promotions eq 1>
													<td><!---<a href="##" onclick="siparisKaydet();" class="basket_order"></a>--->
														<input type="button" onclick="siparisKaydet();" class="basket_order" value="<cf_get_lang no='268.Satın Al'>">
													</td>
												<cfelse>
													<td><!---<a href="##" onclick="reload_proms();" class="add_basket_proms" id="prom_button"></a>--->
														<input type="button" onclick="reload_proms();" class="add_basket_proms" value="<cf_get_lang no='267.Prom Çalıştır'>">
													</td>
												</cfif>
											<cfelse>
												<cfif isdefined("attributes.is_basket_order") and attributes.is_basket_order eq 1>
													<td><a href="##" onclick="siparisKaydet();" class="basket_order">Devam Et</a></td>
												</cfif>	
											</cfif>
										</cfif>
									</tr>
								</table>
							</div>
						</td>
					</tr>
				<cfelse>
					<!---<tr height="20">
						<td><a href="#request.self#?fuseaction=objects2.view_product_list" class="btnDevam"></a></td>
						<td align="right" style="text-align:right;">
							<div class="butonTasi">
								<cfif isdefined("attributes.is_basket_offer") and attributes.is_basket_offer eq 1>
									<cfsavecontent variable="message"><cf_get_lang no ='.'></cfsavecontent>
									<a href="##" onClick="if (confirm('Teklif kaydetmek için üye girişi yapmalısınız.. \n(Üye değilseniz üye giriş sayfasında ilgili linke tıklayarak üye olabilirsiniz..) \n\nÜye girişi sayfasına gitmek ister misiniz?')) window.location='<cfoutput>#request.self#?fuseaction=objects2.member_login&referer_adress=objects2.add_offer</cfoutput>'" class="basket_offer"></a>
									<a href="##" onClick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects2.popup_list_basketww_proposal&is_prices=1','project')" class="basket_print"></a>
								</cfif>
								<cfif (isdefined("attributes.is_basket_prices") and attributes.is_basket_prices eq 1) or (isdefined("attributes.is_basket_prices_session_money") and attributes.is_basket_prices_session_money eq 1) or (isdefined("attributes.is_basket_prices") and attributes.is_basket_prices eq 1)>
									<a href="##" onClick="amountChange();" class="basket_fiyat"></a>
								<cfelse>
									<a href="##" onClick="amountChange();" class="basket_upd_offer"></a>
								</cfif>
								<cfsavecontent variable="message"><cf_get_lang no="146.Sepeti boşaltmak istediğinize emin misiniz"></cfsavecontent>
								<a href="##" onClick="if (confirm('#message#')) window.location='<cfoutput>#request.self#?fuseaction=objects2.emptypopup_del_basketww</cfoutput>'" class="basket_delete"></a>
								<cfif isdefined("attributes.is_basket_order") and attributes.is_basket_order eq 1>
									<a href="##" onClick="if (confirm('Sipariş kaydetmek için üye girişi yapmalısınız.. \n(Üye değilseniz üye giriş sayfasında ilgili linke tıklayarak üye olabilirsiniz..) \n\nÜye girişi sayfasına gitmek ister misiniz?')) window.location='<cfoutput>#request.self#?fuseaction=objects2.member_login&referer_adress=objects2.list_basket</cfoutput>'" class="basket_order"></a>
								</cfif>
							</div>
						</td>
					</tr>--->
					<tr align="right" style="height:20px;">
						<td align="right" style="text-align:right;">    
							<div class="butonTasi">
								<table align="right">
									<tr>
										<td>
											<cfif isdefined('attributes.btn_devam_link') and len(attributes.btn_devam_link)>
												<a href="#attributes.btn_devam_link#" class="btnDevam"></a>
											<cfelse>
												 <a href="#request.self#?fuseaction=objects2.view_product_list" class="btnDevam"></a>
											</cfif>
										</td>
										<cfif isdefined("attributes.is_basket_offer") and attributes.is_basket_offer eq 1>
											<td>
												<cfsavecontent variable="message"><cf_get_lang no ='.'></cfsavecontent>
												<a href="##" onclick="if (confirm('Teklif kaydetmek için üye girişi yapmalısınız.. \n(Üye değilseniz üye giriş sayfasında ilgili linke tıklayarak üye olabilirsiniz..) \n\nÜye girişi sayfasına gitmek ister misiniz?')) window.location='<cfoutput>#request.self#?fuseaction=objects2.member_login&referer_adress=objects2.add_offer</cfoutput>'" class="basket_offer"></a>
												<a href="##" onclick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects2.popup_list_basketww_proposal&is_prices=1','project')" class="basket_print"></a>
											</td>
										</cfif>
										
										<!---<cfif (isdefined("attributes.is_basket_prices") and attributes.is_basket_prices eq 1) or (isdefined("attributes.is_basket_prices_session_money") and attributes.is_basket_prices_session_money eq 1) or (isdefined("attributes.is_basket_prices") and attributes.is_basket_prices eq 1)>--->
										<td><a href="##" onclick="amountChange();" class="basket_fiyat"></a></td>
										<!---<cfelse>
											<td><a href="##" onClick="amountChange();" class="basket_upd_offer"></a></td>
										</cfif>--->     
										<td>
											<cfsavecontent variable="message"><cf_get_lang no="146.Sepeti boşaltmak istediğinize emin misiniz"></cfsavecontent>
											<a href="##" onclick="if (confirm('#message#')) window.location='<cfoutput>#request.self#?fuseaction=objects2.emptypopup_del_basketww</cfoutput>'" class="basket_delete"></a>
										</td>
										<cfif isdefined("attributes.is_basket_order") and attributes.is_basket_order eq 1>
											<td>
												<a href="##" onclick="if (confirm('Sipariş kaydetmek için üye girişi yapmalısınız.. \n(Üye değilseniz üye giriş sayfasında ilgili linke tıklayarak üye olabilirsiniz..) \n\nÜye girişi sayfasına gitmek ister misiniz?')) window.location='<cfoutput>#request.self#?fuseaction=objects2.member_login&referer_adress=objects2.list_basket</cfoutput>'" class="basket_order"></a>
											</td>
										</cfif>
								   	</tr>
							   	</table>
							</div>
						</td>
					</tr>
				</cfif>
			</cfoutput>
            <cfelse>
                <tr style="height:22px;">
                    <td class="form-title"><cf_get_lang_main no="75.No"></td>
                    <td class="form-title"><cf_get_lang_main no="245.Ürün"></td>
                    <td class="form-title" style="width:40px;"><cf_get_lang_main no="223.Miktar"></td>
                    <cfif isdefined("attributes.is_basket_prices") and attributes.is_basket_prices eq 1>
                        <td align="right" class="form-title" style="text-align:right;width:70px;"><cf_get_lang_main no="226.Birim Fiyat"></td>
                        <td align="right" class="form-title" style="text-align:right;width:90px;"><cf_get_lang_main no="672.Fiyat"></td>
                    </cfif>
                </tr>
                <tr  class="color-row" style="height:20px;">
                    <td colspan="5" class="tableyazi"><cf_get_lang no="134.Sepette Ürün Yok">!</td>
                </tr>
            </cfif>
        </table>
		<cfif ArrayLen(session.basketww_camp)>
            <cfoutput>
                <table>
                    <tr>
                        <td class="headbold" style="height:35px;">
                            <a class="tableyazi" href="#request.self#?fuseaction=objects2.list_basket_camp"><cf_get_lang no="148.Kampanya Alışveriş Sepeti"></a>
                        </td>
                    </tr>
                </table>
            </cfoutput>	
        </cfif>
		<cfif isdefined('attributes.is_basket_use_detail_promotion') and attributes.is_basket_use_detail_promotion eq 1>
            <input type="hidden" name="required_prom_id_list" id="required_prom_id_list" value="<cfif isDefined('required_prom_id_list') and len(required_prom_id_list)><cfoutput>#required_prom_id_list#</cfoutput></cfif>">
        </cfif>
	</cfform>
	<cfif isdefined('attributes.is_basket_use_detail_promotion') and attributes.is_basket_use_detail_promotion eq 1><!--- detaylı promosyon --->
	 	<cfif isdefined('attributes.run_basket_promotions') and attributes.run_basket_promotions eq 1 or (isdefined('attributes.is_from_add_prom_prod') and attributes.is_from_add_prom_prod eq 1)>
			<cfinclude template="list_basket_detail_promotions.cfm">
		</cfif>
	</cfif>
	<!--- sıfır stok kontrolleri için listeler olusuyor --->
	<cfscript>
		stock_id_list='';
		pre_stock_id_list='';
		stock_amount_list='';
		prom_id_list='';
		stock_id_list_kontrol='';
		prom_list_kontrol = '';
	</cfscript>
	<cfoutput query="get_rows">
		<cfset yer=listfind(stock_id_list,stock_id,',')>
		<cfif not listfind(stock_id_list,stock_id,',')>
			<cfset stock_id_list = listappend(stock_id_list,stock_id,',')>
			<cfset stock_amount_list= listappend(stock_amount_list,quantity,',')>
		<cfelse>
			<cfset total_stock_miktar = quantity+listgetat(stock_amount_list,yer,',')>
			<cfset stock_amount_list = listsetat(stock_amount_list,yer,total_stock_miktar,',')>
		</cfif>
		<cfif len(pre_stock_id) and not listfind(pre_stock_id_list,pre_stock_id,',')>
			<cfset pre_stock_id_list = listappend(pre_stock_id_list,pre_stock_id,',')>
		<cfelseif len(stock_id) and not listfind(pre_stock_id_list,stock_id,',')>
			<cfset pre_stock_id_list = listappend(pre_stock_id_list,stock_id,',')>
		</cfif>
		<cfif len(prom_id) and not listfind(prom_id_list,prom_id,',')>
			<cfset prom_id_list = listappend(prom_id_list,prom_id,',')>
		</cfif>
		<cfif len(prom_id)>
			<cfset prom_list_kontrol = listappend(prom_list_kontrol,prom_id,',')>
		<cfelse>
			<cfset prom_list_kontrol = listappend(prom_list_kontrol,0,',')>
		</cfif>
		<cfset stock_id_list_kontrol = listappend(stock_id_list_kontrol,stock_id,',')>
	</cfoutput>
	<script type="text/javascript">
		is_basket_order_ = 1;//ürünler silinirken sipariş sayfasına gidilmesin diye eklendi
		function sil(rowno,stok_act_type,demand_id)
		{
			if(demand_id == undefined)
				demand_id ='';
			/*if(is_prod_del!=undefined && is_prod_del == 1)
			{
				alert('Ürünü Sepetten Çıkartamazsınız!!');
				return false;
			}*/
			if(demand_id != '')
			{
				if( ! confirm('Ürünü Sepettten Çıkarırsanız Bekleyen Siparişiniz İptal Edilecek Emin misiniz ?'))
					return false;
			}
			if (confirm("<cf_get_lang_main no='121.Silmek Istediginizden Emin Misiniz'>"))
			{
				is_basket_order_ = 0;
				window.location = '<cfoutput>#request.self#?fuseaction=objects2.emptypopup_del_basketww_row<cfif isDefined('attributes.consumer_id') and len(attributes.consumer_id)>&consumer_id=#attributes.consumer_id#</cfif></cfoutput>&is_basket_order_='+is_basket_order_+'&demand_id='+demand_id+'&row_id='+rowno;
			}
		}
		is_prom_run_ = 0;//Promosyonlar tekrar tekrar çalışmasın diye eklendi
		function reload_proms() //promosyon calıstır
		{
			if(document.getElementById('form_complete') == undefined)
			{
				alert('Sayfa Yükleniyor. Lütfen Bekleyiniz!')
				return false;
			}
			
			upd_price_flag = 0;
			<cfoutput query="get_rows">
				if(upd_price_flag == 0 && document.form_basket_list_base.amount_#order_row_id#.value != document.form_basket_list_base.control_amount_#order_row_id#.value) /*urun miktarları degistirilmisse sepetin guncellenmesi icin uyarıyor*/
				{
					upd_price_flag = 1;
				}
			</cfoutput>
			if(upd_price_flag) 
			{
				alert("<cf_get_lang no='1371.Lütfen Sepetinizi Güncelleyiniz!'>"); 
				return false;
			}
			if(is_prom_run_ == 0)
			{
				is_prom_run_ = 1;
				document.form_basket_list_base.run_basket_promotions.value = 1;
				document.form_basket_list_base.submit();
			}
		}
		function amountChange()
		{
			flag = 0;
			<cfoutput query="get_rows">
				<cfif fusebox.Format_Currency eq 0>
				if(flag == 0 && document.form_basket_list_base.amount_#order_row_id#.value.length == 0 || isNaN(document.form_basket_list_base.amount_#order_row_id#.value))
					flag = 1;
				<cfelse>
				if(flag == 0 && document.form_basket_list_base.amount_#order_row_id#.value.length == 0)
					flag = 1;			
				</cfif>
				
			</cfoutput>
			if(flag == 0)
			{
				document.form_basket_list_base.action='<cfoutput>#request.self#</cfoutput>?fuseaction=objects2.emptypopup_upd_basketww_row';  /*&rowno='+rowno*/
				document.form_basket_list_base.submit();
				return true;
			}
			else
			{
				alert('<cf_get_lang no="149.Miktar sayısal olmalıdır"> !');
				return false;
			}
		}
		
		function siparisKaydet()
		{
			if(document.getElementById('form_complete') == undefined)
			{
				alert('Sayfa Yükleniyor. Lütfen Bekleyiniz!')
				return false;
			}
			
			if(is_basket_order_ == 1)
			{
				upd_price_flag = 0;
				<cfoutput query="get_rows">
					if(upd_price_flag == 0 && document.form_basket_list_base.amount_#order_row_id#.value != document.form_basket_list_base.control_amount_#order_row_id#.value) /*urun miktarları degistirilmisse sepetin guncellenmesi icin uyarıyor*/
					{
						upd_price_flag = 1;
					}
				</cfoutput>
				if(upd_price_flag) 
					{
					alert("<cf_get_lang no='1371.Lütfen Sepetinizi Güncelleyiniz!'>"); 
					return false;
					}
				<cfif isdefined('attributes.is_basket_use_detail_promotion') and attributes.is_basket_use_detail_promotion eq 1>
				//detaylı promosyonda siparis kaydetmeden promların calıstırılması
					if(document.form_basket_list_base.run_basket_promotions.value!=1 || is_prom_run_ == 1){alert('Önce Promosyonları Çalıştırınız!');return false;}
					<cfif isdefined('required_prom_id_list') and len(required_prom_id_list)>//zorunlu promosyon urunleri sepete eklenmemisse
		
						var get_prom_str = wrk_safe_query("obj2_get_prom_str",'dsn3',0,<cfoutput>#required_prom_id_list#</cfoutput>);
						if(get_prom_str.recordcount)
						{	
							alert_prom_list='';
							for(var pr_i=0; pr_i < get_prom_str.recordcount; pr_i++)
								alert_prom_list = alert_prom_list+'\n'+ get_prom_str.PROM_HEAD[pr_i];
							if(get_prom_str.recordcount ==1)
								alert(alert_prom_list + "\n\n Yukarıdaki Promosyona Hak Kazandınız. Lütfen Aşağıdan Seçiminizi Yapınız!");
							else
								alert(alert_prom_list + "\n\n Yukarıdaki Promosyonlara Hak Kazandınız. Lütfen Aşağıdan Seçiminizi Yapınız!!");
							
							return false;
						}
					</cfif>
				</cfif>
				<cfif isdefined('attributes.is_only_prom_products') and attributes.is_only_prom_products eq 1>
					var stock_id_list_kontrol=<cfoutput>'#stock_id_list_kontrol#'</cfoutput>;
					var prom_list_kontrol=<cfoutput>'#prom_list_kontrol#'</cfoutput>;
					var stock_id_count_kontrol=list_len(stock_id_list_kontrol,',');
					for(jj=1;jj<=stock_id_count_kontrol;jj++)
					{
						var stock_id=list_getat(stock_id_list_kontrol,jj,',');
						var prom_id=list_getat(prom_list_kontrol,jj,',');
						if(prom_id == 0)
						{
							var get_prod_name = wrk_safe_query("obj2_get_prod_name",'dsn3',0,stock_id);
							alert(get_prod_name.PRODUCT_NAME+" Ürününü Sadece Promosyonla Alabilirsiniz. Lütfen Sepetinizi Düzenleyiniz !");
							return false;
						}
					}
				</cfif>
				<cfif attributes.is_control_zero_stock eq 1>
					if(!zero_stock_control('','',0,'',1)) return false;
				</cfif>
				var stock_id_list=<cfif listlen(stock_id_list,',')><cfoutput>'#stock_id_list#'</cfoutput><cfelse>'0'</cfif>;
				var pre_stock_id_list=<cfif listlen(pre_stock_id_list,',')><cfoutput>'#pre_stock_id_list#'</cfoutput><cfelse>'0'</cfif>;
				var prom_id_list=<cfif listlen(prom_id_list,',')><cfoutput>'#prom_id_list#'</cfoutput><cfelse>'0'</cfif>;
				var stock_amount_list=<cfif listlen(stock_amount_list,',')><cfoutput>'#stock_amount_list#'</cfoutput><cfelse>'0'</cfif>;
				var stock_id_count=list_len(stock_id_list,',');
				var pre_stock_id_count=list_len(pre_stock_id_list,',');
				for(jj=1;jj<=stock_id_count;jj++)
				{
					var stock_id=list_getat(stock_id_list,jj,',');
					var stock_amount=list_getat(stock_amount_list,jj,',');
					var get_strategy = wrk_safe_query("obj2_get_strategy",'dsn3',0,stock_id);
					var control_amount = get_strategy.MAX_VALUE;
					if(control_amount > 0 && parseFloat(stock_amount) > control_amount)
					{
						var get_prod_name = wrk_safe_query("obj2_get_prod_name",'dsn3',0,stock_id);
						alert(get_prod_name.PRODUCT_NAME+" Ürünü İçin En Fazla "+ control_amount +" Adet Sipariş Verebilirsiniz !");
						return false;
						break;
					}
				}
				for(jj=1;jj<=pre_stock_id_count;jj++)
				{
					var stock_id=list_getat(stock_id_list,jj,',');
					var pre_stock_id=list_getat(pre_stock_id_list,jj,',')
					var get_prom = wrk_safe_query("obj2_get_prom",'dsn3',0,pre_stock_id);
					prom_kontrol = 0;
					for(var pr_i=0; pr_i < get_prom.recordcount; pr_i++)
					{
						if(list_find(prom_id_list,get_prom.PROMOTION_ID[pr_i]))
							prom_kontrol = 1;
					}
					if(get_prom.PROMOTION_ID != undefined && prom_kontrol == 0)
					{
						var get_prod_name2 = wrk_safe_query("obj2_get_prod_name",'dsn3',0,stock_id);
						var get_prom_name2 = wrk_safe_query("obj2_get_prom_str",'dsn3',0,get_prom.PROMOTION_ID);
						alert(get_prod_name2.PRODUCT_NAME+" Ürününü Sadece "+ get_prom_name2.PROM_HEAD +" Promosyonuyla Alabilirsiniz!");
						return false;
						break;
					}
				}
				<cfoutput>
					<cfif attributes.fuseaction contains 'list_basket_cs'>
						document.form_basket_list_base.action='<cfif use_https>#https_domain#</cfif>#request.self#?fuseaction=objects2.form_add_orderww_cs';
					<cfelse>
						document.form_basket_list_base.action='<cfif use_https>#https_domain#</cfif>#request.self#?fuseaction=objects2.form_add_orderww';
					</cfif>
					document.form_basket_list_base.submit();
				</cfoutput>
			}
		}
		function zero_stock_control(dep_id,loc_id,is_update,process_type,stock_type)
		{
			var hata = '';
			
			var stock_id_list=<cfif listlen(stock_id_list,',')><cfoutput>'#stock_id_list#'</cfoutput><cfelse>'0'</cfif>;
			var stock_amount_list=<cfif listlen(stock_amount_list,',')><cfoutput>'#stock_amount_list#'</cfoutput><cfelse>'0'</cfif>;
		
			//stock kontrolleri
			var stock_id_count=list_len(stock_id_list,',');
			if(stock_id_count >0)
			{
				for(jj=1;jj<=stock_id_count;jj++)
				{
					var stock_id=list_getat(stock_id_list,jj,',');
					var stock_amount=list_getat(stock_amount_list,jj,',');
					var listParam = stock_id + "*" + "<cfoutput>#dsn3_alias#</cfoutput>" + "*" + "<cfoutput>#dsn_alias#</cfoutput>"; 
					var get_total_stock = wrk_safe_query("obj2_get_total_stock",'dsn2',0,listParam);
					if(get_total_stock.recordcount)
					{
						if(parseFloat(get_total_stock.PRODUCT_TOTAL_STOCK) < parseFloat(stock_amount))
							hata = hata+ 'Ürün:'+get_total_stock.PRODUCT_NAME+' \nAçıklama:'+get_total_stock.PROPERTY+'\n';
					}else
					{//bu lokasyona hiç giriş veya çıkış olmadı ise kayıt gelemyecektir o yüzden else yazıldı
						var get_stock = wrk_safe_query("obj2_get_stock",'dsn3',0,stock_id);
						if(get_stock.recordcount && get_stock.IS_PRODUCTION ==0 )
							hata = hata+ 'Ürün:'+get_stock.PRODUCT_NAME+' \nAçıklama:'+get_stock.PROPERTY+'\n';
					}
				}
			}
			
			if(hata!='')
			{
				alert(hata+'\n\n Yukarıdaki ürünlerde satılabilir stok miktarı yeterli değildir. Lütfen miktarları kontrol ediniz');
				return false;
			}
			else
				return true;
		}
	</script>
</cfif> 

