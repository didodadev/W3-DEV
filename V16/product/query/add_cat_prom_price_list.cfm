
<cfif url.active_company neq session.ep.company_id>
	<script type="text/javascript">
		alert("<cf_get_lang dictionary_id='45859.İşlemin Muhasebe Dönemi İle Aktif Muhasebe Döneminiz Farklı'>...<cf_get_lang dictionary_id='45863.Muhasebe Döneminizi Kontrol Ediniz'>!");
		window.opener.location.href='<cfoutput>#request.self#?fuseaction=product.list_catalog_promotion</cfoutput>';
		window.close();
	</script>
	<cfabort>
</cfif>
<cf_get_lang dictionary_id='64252.Fiyat Oluşturma İşlemi Başladı, Lütfen Bekleyiniz'>...<br/><br/>
<cfsetting showdebugoutput="no">
<cfquery name="GET_CAT_PROM_ACTIONS" datasource="#DSN3#">
	SELECT
		CATALOG_ID,
		CATALOG_HEAD,
		STARTDATE,
		DATEADD(DAY,1,FINISHDATE) FINISHDATE
	FROM
		CATALOG_PROMOTION
	WHERE
		CATALOG_ID = #attributes.catalog_id#
</cfquery>

<cfset catalog_head_query = get_cat_prom_actions.catalog_head>
<cfif not get_cat_prom_actions.recordCount>
	<cf_get_lang dictionary_id='37877.Kayıtlı aksiyon yok'> !
	<cfabort>
</cfif>

<cfquery name="GET_ACTION_PRICE_LIST" datasource="#DSN3#">
	SELECT
		PRICE_LIST_ID
	FROM
		CATALOG_PRICE_LISTS
	WHERE
		CATALOG_PROMOTION_ID = #get_cat_prom_actions.catalog_id#
</cfquery>
<cfquery name="GET_CATALOG_PRODUCTS" datasource="#DSN3#">
	SELECT 
		P.PRODUCT_ID,
		CP.PRODUCT_UNIT_ID,
		CP.ACTION_PRICE,
		CP.RETURNING_PRICE,
		CP.ACTION_PRICE_DISCOUNT,
		CP.RETURNING_PRICE_DISCOUNT,
		CP.TAX,
		CP.MONEY
	FROM 
		CATALOG_PROMOTION_PRODUCTS CP, 
		PRODUCT P
	WHERE 
		CP.CATALOG_ID = #get_cat_prom_actions.catalog_id# AND
		P.PRODUCT_ID = CP.PRODUCT_ID
</cfquery>

<cfset cat_prom_prod_list = "#ValueList(get_catalog_products.product_id)#">
<cflock name="#createuuid()#" timeout="60">
	<cftransaction>
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
					<!---ISNULL(STOCK_ID,0)=0 AND--->
					ISNULL(SPECT_VAR_ID,0)=0 AND
					PRICE_CATID = #price_list_id_query# AND
					STARTDATE >= #CreateODBCDateTime(get_cat_prom_actions.startdate)# AND 
					STARTDATE <= #CreateODBCDateTime(get_cat_prom_actions.finishdate)#				
			</cfquery>
			<cfquery name="DEL_CAT_PROM_PROD_PRICE_ALL" datasource="#DSN3#">
				DELETE FROM 
					PRICE 
				WHERE 
					PRODUCT_ID IN (#cat_prom_prod_list#) AND
					<!---ISNULL(STOCK_ID,0)=0 AND--->
					ISNULL(SPECT_VAR_ID,0)=0 AND
					PRICE_CATID = #price_list_id_query# AND
					STARTDATE >= #CreateODBCDateTime(get_cat_prom_actions.startdate)# AND 
					STARTDATE <= #CreateODBCDateTime(get_cat_prom_actions.finishdate)#
			</cfquery>
			<cfquery name="DEL_CAT_PROM_PROD_HISTORY_PRICE_ALL" datasource="#DSN3#">
				DELETE FROM 
					PRICE_HISTORY 
				WHERE 
					PRODUCT_ID IN (#cat_prom_prod_list#) AND
					<!---ISNULL(STOCK_ID,0)=0 AND--->
					ISNULL(SPECT_VAR_ID,0)=0 AND
					PRICE_CATID = #price_list_id_query# AND
					STARTDATE >= #CreateODBCDateTime(get_cat_prom_actions.startdate)# AND 
					STARTDATE <= #CreateODBCDateTime(get_cat_prom_actions.finishdate)#
			</cfquery>
			<cfoutput query="get_catalog_products">
				<cfscript>
					// BK 20081229 bulunan donem 2009 ve para birimi YTL ise 
					if ((session.ep.period_year eq "2009") and (money eq 'YTL'))
						temp_money = 'TL';
					else
						temp_money = money;

					end_price = wrk_round( (ACTION_PRICE * 100) / (TAX + 100) ,session.ep.our_company_info.sales_price_round_num );
					add_price(product_id : PRODUCT_ID,
						product_unit_id : PRODUCT_UNIT_ID,
						price_cat : price_list_id_query,
						start_date : CreateODBCDateTime(get_cat_prom_actions.STARTDATE),
						price : end_price,
						price_money : temp_money,
						price_with_kdv : ACTION_PRICE,
						is_kdv : 1,
						catalog_id : get_cat_prom_actions.CATALOG_ID,
						price_discount: ACTION_PRICE_DISCOUNT						
						);

					end_price_2_without_kdv = wrk_round( (RETURNING_PRICE * 100) / (TAX + 100) ,session.ep.our_company_info.sales_price_round_num );
					end_price_2_w_kdv = RETURNING_PRICE;
					add_price(product_id : PRODUCT_ID,
						product_unit_id : PRODUCT_UNIT_ID,
						price_cat : price_list_id_query,
						start_date : CreateODBCDateTime(get_cat_prom_actions.FINISHDATE),
						price : end_price_2_without_kdv,
						price_money : temp_money,
						is_kdv : 1,
						price_with_kdv : end_price_2_w_kdv,
						price_discount: RETURNING_PRICE_DISCOUNT
						);
				</cfscript>
			</cfoutput>
			<cfoutput>#catalog_head_query# - #price_list_id_query# <cf_get_lang dictionary_id='64253.no lu fiyat listesi'></cfoutput> <cf_get_lang dictionary_id='52768.Bitti'> !<br/>
		</cfloop>
	</cftransaction>
</cflock>

<cfquery name="Set_CATALOG_PROMOTION_APPLIED" datasource="#DSN3#">
	UPDATE
		CATALOG_PROMOTION
	SET
		IS_APPLIED = 1,
		STAGE_ID = -2,
		VALIDATE_DATE = #now()#,
		VALID_EMP = #session.ep.userid#,
		VALID = 1
	WHERE
		CATALOG_ID = #get_cat_prom_actions.catalog_id#
</cfquery>
<br/>
<cf_get_lang dictionary_id='37878.Fiyat oluşturma işlemi tamamen bitti'> !!!<br/>
<script type="text/javascript">
	alert("<cf_get_lang dictionary_id='37879.Fiyat Listelerine Fiyatlar Yazıldı'> !");
	location.href="<cfoutput>#request.self#?fuseaction=product.list_catalog_promotion&event=upd&id=#catalog_id#</cfoutput>";
</script>
<br/><br/>
