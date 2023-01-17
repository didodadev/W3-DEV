<cfif not IsDefined("Cookie.wrk_basket_#replace(cgi.http_host,'-','','all')#")>
	<script type="text/javascript">
		alert("<cf_get_lang no ='1398.Detay Bilgileri Doldurulmadığı İçin Sepete Ürün Atamazsınız'>!");
		history.back();
	</script>
	<cfabort>
</cfif>

<cfquery name="GET_VALUES" datasource="#DSN3#">
	SELECT
		*
	FROM
		ORDER_INFO_PLUS
	WHERE
		RECORD_GUEST = 1 AND 
		RECORD_IP = <cfqueryparam cfsqltype="cf_sql_varchar" value="#cgi.remote_addr#"> AND
		COOKIE_NAME = <cfqueryparam cfsqltype="cf_sql_varchar" value="#evaluate("cookie.wrk_basket_#replace(cgi.http_host,'-','','all')#")#">
</cfquery>
<cfif not GET_VALUES.recordcount>
	<script type="text/javascript">
		alert("<cf_get_lang no ='1398.Detay Bilgileri Doldurulmadığı İçin Sepete Ürün Atamazsınız'>!");
		history.back();
	</script>
	<cfabort>
</cfif>

<cfquery name="get_stock" datasource="#dsn3#" maxrows="1">
	SELECT
		S.IS_KARMA,
		S.IS_PROTOTYPE,
		S.PRODUCT_ID,
		S.PRODUCT_NAME,
		S.TAX,
		S.PRODUCT_UNIT_ID,
		P.SEGMENT_ID
	FROM
		STOCKS S,
		PRODUCT P
	WHERE
		S.PRODUCT_ID = P.PRODUCT_ID AND
		S.STOCK_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.puan_stock_id#">
</cfquery>

<cfif len(get_stock.SEGMENT_ID)>
	<cfquery name="control_segment" datasource="#dsn3#" maxrows="1">
		SELECT SEGMENT_ID FROM ORDER_PRE_ROWS_SPECIAL WHERE SEGMENT_ID IS NOT NULL AND SEGMENT_ID <> <cfqueryparam cfsqltype="cf_sql_integer" value="#get_stock.segment_id#"> AND RECORD_PAR = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.pp.userid#">
	</cfquery>
	<cfif control_segment.recordcount>
		<script type="text/javascript">
			alert("<cf_get_lang no ='1399.Farklı Hedef Pazar Ürünlerini Tek Sepette Toplayamazsınız'>!");
			history.back();
		</script>
		<cfabort>
	</cfif>
</cfif>

<cfquery name="control_product" datasource="#dsn3#">
	SELECT 
		QUANTITY 
	FROM 
		ORDER_PRE_ROWS_SPECIAL 
	WHERE 
		COOKIE_NAME = <cfqueryparam cfsqltype="cf_sql_varchar" value="#evaluate("cookie.wrk_basket_#replace(cgi.http_host,'-','','all')#")#"> AND
		STOCK_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.puan_stock_id#"> AND
		PROM_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.puan_prom_id#">
</cfquery>

<cfif control_product.recordcount>
	<cfquery name="upd_" datasource="#dsn3#">
		UPDATE
			ORDER_PRE_ROWS_SPECIAL
		SET
			QUANTITY = #control_product.QUANTITY + attributes.istenen_miktar#,
			PROM_POINT = #(control_product.QUANTITY+attributes.istenen_miktar) * attributes.puan_prom_point#
		WHERE
			COOKIE_NAME = <cfqueryparam cfsqltype="cf_sql_varchar" value="#wrk_eval("cookie.wrk_basket_#replace(cgi.http_host,'-','','all')#")#"> AND
			STOCK_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.puan_stock_id#"> AND
			PROM_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.puan_prom_id#">
	</cfquery>
<cfelse>
	<cfquery name="control_sepet" datasource="#dsn3#">
		SELECT 
			PRODUCT_ID 
		FROM 
			ORDER_PRE_ROWS_SPECIAL 
		WHERE 
			COOKIE_NAME = <cfqueryparam cfsqltype="cf_sql_varchar" value="#evaluate("cookie.wrk_basket_#replace(cgi.http_host,'-','','all')#")#">
	</cfquery>
	<cfif control_sepet.recordcount>
		<cfset product_id_list = valuelist(control_sepet.PRODUCT_ID)>
		<cfquery name="get_this_product_properties" datasource="#dsn1#">
			SELECT 
				PP.PROPERTY_ID,
				PPD.PROPERTY_DETAIL,
				PDP.VARIATION_ID
			FROM
				PRODUCT_PROPERTY PP,
				PRODUCT_PROPERTY_DETAIL PPD,
				PRODUCT_DT_PROPERTIES PDP
			WHERE
				PPD.PRPT_ID = PP.PROPERTY_ID AND
				PP.IS_VARIATION_CONTROL = 1 AND
				PDP.PROPERTY_ID = PP.PROPERTY_ID AND
				PDP.VARIATION_ID = PPD.PROPERTY_DETAIL_ID AND
				PDP.PRODUCT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.puan_product_id#">
		</cfquery>
			<cfif get_this_product_properties.recordcount>
				<cfset variation_list = valuelist(get_this_product_properties.VARIATION_ID)>
				<cfquery name="get_all_properties" datasource="#dsn1#">
					SELECT 
						PP.PROPERTY_ID,
						PPD.PROPERTY_DETAIL,
						PDP.VARIATION_ID
					FROM
						PRODUCT_PROPERTY PP,
						PRODUCT_PROPERTY_DETAIL PPD,
						PRODUCT_DT_PROPERTIES PDP
					WHERE
						PPD.PRPT_ID = PP.PROPERTY_ID AND
						PP.IS_VARIATION_CONTROL = 1 AND
						PDP.PROPERTY_ID = PP.PROPERTY_ID AND
						PDP.VARIATION_ID = PPD.PROPERTY_DETAIL_ID AND
						PDP.PRODUCT_ID IN (#product_id_list#) AND
						PP.PROPERTY_ID IN (#valuelist(get_this_product_properties.PROPERTY_ID)#)
				</cfquery>
				<cfif get_all_properties.recordcount>
					<cfset all_var_list = valuelist(get_all_properties.VARIATION_ID)>
					<cfset error_ = 0>
					<cfloop list="#variation_list#" index="this_">
						<cfif not listfindnocase(all_var_list,this_)>
							<cfset error_ = 1>
						</cfif>
					</cfloop>
					<cfif error_ eq 1>
						<script type="text/javascript">
							alert("<cf_get_lang no ='1400.Farklı Varyasyon Ürünlerini Tek Sepette Toplayamazsınız'>!");
							history.back();
						</script>
						<cfabort>
					</cfif>
				</cfif>
			</cfif>
	</cfif>
	<cfquery name="ADD_INFO" datasource="#DSN3#">
	INSERT INTO 
		ORDER_PRE_ROWS_SPECIAL
		(
			COOKIE_NAME,
			STOCK_ID,
			PRODUCT_ID,
			PRODUCT_NAME,
			QUANTITY,
			PRODUCT_UNIT_ID,
			PROM_ID,
			PROM_POINT,
			RECORD_PAR,
			RECORD_DATE,
			SEGMENT_ID,			
			RECORD_IP
		)
			VALUES
		(
			'#wrk_eval("cookie.wrk_basket_#replace(cgi.http_host,'-','','all')#")#',
			#attributes.puan_stock_id#,
			#attributes.puan_product_id#,
			'#attributes.puan_product_name#',
			#attributes.istenen_miktar#,
			#get_stock.PRODUCT_UNIT_ID#,
			#attributes.puan_prom_id#,
			#attributes.istenen_miktar*attributes.puan_prom_point#,
			#session.pp.userid#,
			#now()#,
			<cfif len(get_stock.SEGMENT_ID)>#get_stock.SEGMENT_ID#<cfelse>NULL</cfif>,
			'#cgi.remote_addr#'
		)
	</cfquery>
</cfif>
<cflocation url="#request.self#?fuseaction=objects2.popup_iframe_puan_basket" addtoken="no">
