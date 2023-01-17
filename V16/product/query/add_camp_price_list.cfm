<cfif url.active_company neq session.ep.company_id>
	<script type="text/javascript">
		alert("<cf_get_lang no ='862.İşlemin Muhasebe Dönemi İle Aktif Muhasebe Döneminiz Farklı'>...<cf_get_lang no ='863.Muhasebe Döneminizi Kontrol Ediniz'>!");
		window.opener.location.href='<cfoutput>#request.self#?fuseaction=product.list_product</cfoutput>';
		window.close();
	</script>
	<cfabort>
</cfif>
<cf_get_lang no ='864.Fiyat Oluşturma İşlemi Başladı, Lütfen Bekleyiniz'>...<br/><br/>
<cfsetting showdebugoutput="no">
<cfinclude template="get_campaign_actions.cfm">
<cfif not get_campaign_actions.recordCount>
	<cf_get_lang no ='865.Kayıtlı aksiyon yok'> !
	<cfabort>
</cfif>

<cfquery name="GET_ACTION_PRICE_LIST_ALL" datasource="#DSN3#">
	SELECT PRICE_LIST_ID, CATALOG_PROMOTION_ID FROM CATALOG_PRICE_LISTS WHERE CATALOG_PROMOTION_ID IN (#ValueList(get_campaign_actions.CATALOG_ID)#)
</cfquery>
<cfquery name="GET_CATALOG_PRODUCTS_ALL" datasource="#DSN3#">
	SELECT  P.PRODUCT_ID, CP.PRODUCT_UNIT_ID, CP.ACTION_PRICE, CP.ACTION_PRICE_DISCOUNT, CP.RETURNING_PRICE, CP.RETURNING_PRICE_DISCOUNT, CP.TAX, ISNULL(CP.SALE_MONEY_TYPE,CP.MONEY) AS MONEY, CP.CATALOG_ID FROM CATALOG_PROMOTION_PRODUCTS CP, PRODUCT P WHERE CP.CATALOG_ID IN (#ValueList(get_campaign_actions.CATALOG_ID)#) AND P.PRODUCT_ID = CP.PRODUCT_ID
</cfquery>

<cfloop query="get_campaign_actions">
	<cfscript>
	catalog_id_query = get_campaign_actions.catalog_id;
	finishdate_query = get_campaign_actions.finishdate;
	startdate_query = get_campaign_actions.startdate;
	catalog_head_query = get_campaign_actions.catalog_head;
	</cfscript>
	<cfquery name="GET_ACTION_PRICE_LIST" dbtype="query">
		SELECT * FROM GET_ACTION_PRICE_LIST_ALL WHERE CATALOG_PROMOTION_ID = #catalog_id_query#
	</cfquery>
	<cfquery name="GET_CATALOG_PRODUCTS" dbtype="query">
		SELECT * FROM GET_CATALOG_PRODUCTS_ALL WHERE CATALOG_ID = #catalog_id_query#
	</cfquery>
	<cfset cat_prom_prod_list = "#ValueList(get_catalog_products.product_id)#">
	
	<!--- <cflock name="#createuuid()#" timeout="60">
		<cftransaction> --->
			<cfloop query="get_action_price_list">
				<cfset price_list_id_query = get_action_price_list.price_list_id>
				<cfquery name="INS_PRICE_DELETED_ROWS" datasource="#DSN3#">
					INSERT INTO 
						PRICE_DELETED_ROWS
					(PRICE_ID,PRICE_CATID,PRODUCT_ID,FINISHDATE,STARTDATE,PRICE,PRICE_KDV,PRICE_DISCOUNT,IS_KDV,ROUNDING,UNIT,MONEY,CATALOG_ID,PRICE_RECORD_DATE,PRICE_RECORD_EMP,PRICE_RECORD_IP,RECORD_DATE,RECORD_IP,RECORD_EMP)
					SELECT 
						PRICE_ID,PRICE_CATID,PRODUCT_ID,FINISHDATE,STARTDATE,PRICE,PRICE_KDV,PRICE_DISCOUNT,IS_KDV,ROUNDING,UNIT,MONEY,CATALOG_ID,RECORD_DATE,RECORD_EMP,RECORD_IP,#now()#,'#remote_addr#',#session.ep.userid#
					FROM 
						PRICE 
					WHERE 
						PRODUCT_ID IN (#cat_prom_prod_list#) AND
						ISNULL(STOCK_ID,0)=0 AND
						ISNULL(SPECT_VAR_ID,0)=0 AND
						PRICE_CATID = #price_list_id_query# AND
						STARTDATE <= #CreateODBCDateTime(finishdate_query)# AND 
						STARTDATE >= #CreateODBCDateTime(startdate_query)#
				</cfquery>
				<cfquery name="DEL_CAT_PROM_PROD_PRICE_ALL" datasource="#DSN3#"> 
					DELETE FROM PRICE 
					WHERE 
						PRODUCT_ID IN (#cat_prom_prod_list#) AND 
						ISNULL(STOCK_ID,0)=0 AND
						ISNULL(SPECT_VAR_ID,0)=0 AND
						PRICE_CATID = #price_list_id_query# AND
						STARTDATE <= #CreateODBCDateTime(finishdate_query)# AND
						STARTDATE >= #CreateODBCDateTime(startdate_query)#
				</cfquery>
				<cfquery name="DEL_CAT_PROM_PROD_PRICE_HISTORY_ALL" datasource="#DSN3#"> 
					DELETE FROM PRICE_HISTORY
					WHERE 
						PRODUCT_ID IN (#cat_prom_prod_list#) AND 
						ISNULL(STOCK_ID,0)=0 AND
						ISNULL(SPECT_VAR_ID,0)=0 AND
						PRICE_CATID = #price_list_id_query# AND
						STARTDATE <= #CreateODBCDateTime(finishdate_query)# AND
						STARTDATE >= #CreateODBCDateTime(startdate_query)#
				</cfquery>
				<cfoutput query="GET_CATALOG_PRODUCTS" group="PRODUCT_UNIT_ID">
					<cfscript>
					// BK 20081229 bulunan donem 2009 ve para birimi YTL ise 
					if ((session.ep.period_year eq "2009") and (get_catalog_products.money eq 'YTL'))
						temp_money = 'TL';
					else
						temp_money = get_catalog_products.money;

					end_price = wrk_round( (ACTION_PRICE * 100) / (TAX + 100) ,2 );
					add_price(product_id : GET_CATALOG_PRODUCTS.PRODUCT_ID,
						product_unit_id : GET_CATALOG_PRODUCTS.PRODUCT_UNIT_ID,
						price_cat : price_list_id_query,
						start_date : CreateODBCDateTime(startdate_query),
						price : end_price,
						//price_money : GET_CATALOG_PRODUCTS.MONEY,
						price_money : temp_money,
						price_with_kdv : GET_CATALOG_PRODUCTS.ACTION_PRICE,
						is_kdv : 1,
						catalog_id : catalog_id_query,
						price_discount: GET_CATALOG_PRODUCTS.ACTION_PRICE_DISCOUNT
						);

						end_price_2_without_kdv = wrk_round( (RETURNING_PRICE * 100) / (TAX + 100) ,2 );
						end_price_2_w_kdv = RETURNING_PRICE;
						add_price(product_id : PRODUCT_ID, 
							product_unit_id : PRODUCT_UNIT_ID, 
							price_cat : price_list_id_query, 
							start_date : CreateODBCDateTime(finishdate_query), 
							price : end_price_2_without_kdv, 
							//price_money : GET_CATALOG_PRODUCTS.MONEY, 
							price_money : temp_money,
							is_kdv : 1,
							price_with_kdv : end_price_2_w_kdv,
							price_discount: RETURNING_PRICE_DISCOUNT
							);
					</cfscript>
				</cfoutput>
				<cfoutput>#catalog_head_query# - #price_list_id_query# no lu fiyat listesi</cfoutput> bitti !<br/>
			</cfloop>
		<!--- </cftransaction>
	</cflock> --->

	<cfquery name="SET_CATALOG_PROMOTION_APPLIED" datasource="#DSN3#">
		UPDATE
			CATALOG_PROMOTION
		SET
			IS_APPLIED = 1,
			STAGE_ID = -2, 
			VALIDATE_DATE = #now()#, 
			VALID_EMP = #session.ep.userid#, 
			VALID = 1 
		WHERE
			CATALOG_ID = #catalog_id_query#
	</cfquery>
</cfloop>
<br/><br/>
<cf_get_lang no ='866.Fiyat oluşturma işlemi tamamen bitti'> !!!<br/>
<script type="text/javascript">
	alert("<cf_get_lang no ='867.Fiyat Listelerine Fiyatlar Yazıldı'> !");
	wrk_opener_reload();
	window.close();
</script>
<br/><br/>

