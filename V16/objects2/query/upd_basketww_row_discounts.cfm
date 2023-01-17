<cfsetting showdebugoutput="no">
<cfquery name="UPD_BASKET_PRE_STATUS" datasource="#DSN3#"><!--- urunlerin pre_status leri geri alınıyor --->
	DECLARE @RetryCounter INT
	SET @RetryCounter = 1
	RETRY:
		BEGIN TRY
			UPDATE
				ORDER_PRE_ROWS
			SET
				IS_CHECKED=1,
				ROW_PRE_STATUS=NULL
			WHERE
				ISNULL(ROW_PRE_STATUS,0)=1
				AND ISNULL(IS_COMMISSION,0)=0
				AND ISNULL(IS_CARGO,0)=0
				AND ISNULL(IS_PROM_ASIL_HEDIYE,0)=0
				<cfif isdefined("session.pp")>
					AND RECORD_PAR = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.pp.userid#">
				<cfelseif isdefined("session.ww.userid")>
					AND RECORD_CONS = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ww.userid#">
				<cfelseif isdefined("session.ep")>
					AND RECORD_EMP = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.userid#">
				<cfelseif not isdefined("session_base.userid")><!--- sistemde olmayan misafir kullanıcılar için baskete atılan ürünler --->
					AND RECORD_GUEST = 1 
					AND RECORD_IP = <cfqueryparam cfsqltype="cf_sql_varchar" value="#cgi.remote_addr#">
					AND COOKIE_NAME = <cfqueryparam cfsqltype="cf_sql_varchar" value="#evaluate("cookie.wrk_basket_#ReplaceList(cgi.http_host,'-,:','_,_')#")#">
				</cfif>
		END TRY
		BEGIN CATCH
			DECLARE @DoRetry bit; 
			DECLARE @ErrorMessage varchar(500)
			SET @doRetry = 0;
			SET @ErrorMessage = ERROR_MESSAGE()
			IF ERROR_NUMBER() = 1205 
			BEGIN
				SET @doRetry = 1; 
			END
			IF @DoRetry = 1
			BEGIN
				SET @RetryCounter = @RetryCounter + 1
				IF (@RetryCounter > 3)
				BEGIN
					RAISERROR(@ErrorMessage, 18, 1) -- Raise Error Message if 
				END
				ELSE
				BEGIN
					WAITFOR DELAY '00:00:00.05' 
					GOTO RETRY	
				END
			END
			ELSE
			BEGIN
				RAISERROR(@ErrorMessage, 18, 1)
			END
		END CATCH
</cfquery>
<cfquery name="UPD_BASKET_PRE_STATUS" datasource="#DSN3#"><!--- urunlerin pre_status leri geri alınıyor --->
	DECLARE @RetryCounter INT
	SET @RetryCounter = 1
	RETRY:
		BEGIN TRY
			UPDATE
				ORDER_PRE_ROWS
			SET
				DISCOUNT1=0,
				DISCOUNT2=0,
				DISCOUNT3=0,
				DISCOUNT4=0,
				DISCOUNT5=0,
				PRICE_OLD=NULL,
				PRICE_KDV_OLD=NULL,
				PRICE=PRE_PRICE,
				PRICE_KDV=PRE_PRICE_KDV,
				PRICE_MONEY=PRE_PRICE_MONEY,
				PRE_PRICE=NULL,
				PRE_PRICE_KDV=NULL,
				PRE_PRICE_MONEY=NULL
			WHERE
				ISNULL(IS_CHECKED,0)=1
				AND PRE_PRICE IS NOT NULL
				AND PRE_PRICE_MONEY IS NOT NULL
				AND ISNULL(IS_COMMISSION,0)=0
				AND ISNULL(IS_CARGO,0)=0
				AND ISNULL(IS_PROM_ASIL_HEDIYE,0)=0
				<cfif isdefined("session.pp")>
					AND RECORD_PAR = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.pp.userid#">
				<cfelseif isdefined("session.ww.userid")>
					AND RECORD_CONS = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ww.userid#">
				<cfelseif isdefined("session.ep")>
					AND RECORD_EMP = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.userid#">
				<cfelseif not isdefined("session_base.userid")><!--- sistemde olmayan misafir kullanıcılar için baskete atılan ürünler --->
					AND RECORD_GUEST = 1 
					AND RECORD_IP = <cfqueryparam cfsqltype="cf_sql_varchar" value="#cgi.remote_addr#">
					AND COOKIE_NAME = <cfqueryparam cfsqltype="cf_sql_varchar" value="#evaluate("cookie.wrk_basket_#ReplaceList(cgi.http_host,'-,:','_,_')#")#">
				</cfif>
		END TRY
		BEGIN CATCH
			DECLARE @DoRetry bit; 
			DECLARE @ErrorMessage varchar(500)
			SET @doRetry = 0;
			SET @ErrorMessage = ERROR_MESSAGE()
			IF ERROR_NUMBER() = 1205 
			BEGIN
				SET @doRetry = 1; 
			END
			IF @DoRetry = 1
			BEGIN
				SET @RetryCounter = @RetryCounter + 1
				IF (@RetryCounter > 3)
				BEGIN
					RAISERROR(@ErrorMessage, 18, 1) -- Raise Error Message if 
				END
				ELSE
				BEGIN
					WAITFOR DELAY '00:00:00.05' 
					GOTO RETRY	
				END
			END
			ELSE
			BEGIN
				RAISERROR(@ErrorMessage, 18, 1)
			END
		END CATCH
</cfquery>
<cfquery name="GET_BASKET_ROWS_PRJ" datasource="#DSN3#">
	SELECT 
		OPR.*,
		P.BRAND_ID,P.PRODUCT_CATID
	FROM
		ORDER_PRE_ROWS OPR,
		#dsn1_alias#.PRODUCT P
	WHERE
		OPR.PRODUCT_ID=P.PRODUCT_ID
		AND ISNULL(OPR.IS_CHECKED,0)=1
		AND ISNULL(OPR.IS_COMMISSION,0)=0
		AND ISNULL(IS_CARGO,0)=0
		AND ISNULL(IS_PROM_ASIL_HEDIYE,0)=0
		<cfif isdefined("session.pp")>
			AND OPR.RECORD_PAR = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.pp.userid#">
		<cfelseif isdefined("session.ww.userid")>
			AND OPR.RECORD_CONS = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ww.userid#">
		<cfelseif isdefined("session.ep")>
			AND OPR.RECORD_EMP = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.userid#">
		<cfelseif not isdefined("session_base.userid")><!--- sistemde olmayan misafir kullanıcılar için baskete atılan ürünler --->
			AND OPR.RECORD_GUEST = 1 
			AND OPR.RECORD_IP =  <cfqueryparam cfsqltype="cf_sql_varchar" value="#cgi.remote_addr#">
			AND OPR.COOKIE_NAME = <cfqueryparam cfsqltype="cf_sql_varchar" value="#evaluate("cookie.wrk_basket_#ReplaceList(cgi.http_host,'-,:','_,_')#")#">
		</cfif>
		AND OPR.PRODUCT_ID IS NOT NULL
</cfquery>
<cfif get_basket_rows_prj.recordcount>
	<cfscript>
		non_useable_prod_list='';
		saleable_prod_list='';
		basket_prod_list=valuelist(get_basket_rows_prj.product_id);
		pro_disc_1=0;
		pro_disc_2=0;
		pro_disc_3=0;
		pro_disc_4=0;
		pro_disc_5=0;
		prj_price_cat_='';
		prj_prod_cat_list='';
		prj_prod_brand_list='';
		prj_prod_id_list='';
	</cfscript>
	<cfif isdefined('attributes.prj_id') and len(attributes.prj_id)>
		<cfquery name="GET_PRJ_DISCOUNTS" datasource="#DSN3#">
			SELECT
				PDC.BRAND_ID,
				PDC.PRODUCT_CATID,
				PRODUCT_ID,
				PD.IS_CHECK_RISK,
				PD.IS_CHECK_PRJ_LIMIT,
				PD.IS_CHECK_PRJ_PRODUCT,
				PD.PRICE_CATID,
				PD.DISCOUNT_1,
				PD.DISCOUNT_2,
				PD.DISCOUNT_3,
				PD.DISCOUNT_4,
				PD.DISCOUNT_5
			FROM 
				PROJECT_DISCOUNTS PD,
				PROJECT_DISCOUNT_CONDITIONS PDC
			WHERE
				PD.PRO_DISCOUNT_ID=PDC.PRO_DISCOUNT_ID
				AND PD.PROJECT_ID=<cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.prj_id#">
		</cfquery>
		<cfscript>
			useable_prod_list='';
			non_useable_prod_list='';
			if(len(get_prj_discounts.discount_1)) pro_disc_1=get_prj_discounts.discount_1;
			if(len(get_prj_discounts.discount_2)) pro_disc_2=get_prj_discounts.discount_2;
			if(len(get_prj_discounts.discount_3)) pro_disc_3=get_prj_discounts.discount_3;
			if(len(get_prj_discounts.discount_4)) pro_disc_4=get_prj_discounts.discount_4;
			if(len(get_prj_discounts.discount_5)) pro_disc_5=get_prj_discounts.discount_5;
			prj_price_cat_=listdeleteduplicates(listsort(valuelist(get_prj_discounts.price_catid),'numeric','asc'));
			prj_prod_cat_list=listdeleteduplicates(listsort(valuelist(get_prj_discounts.product_catid),'numeric','asc'));
			prj_prod_brand_list=listdeleteduplicates(listsort(valuelist(get_prj_discounts.brand_id),'numeric','asc'));
			prj_prod_id_list=listdeleteduplicates(listsort(valuelist(get_prj_discounts.product_id),'numeric','asc'));
			if(len(get_prj_discounts.is_check_prj_product) and get_prj_discounts.is_check_prj_product eq 1) /*baglantı kapsamında urun kontrolu yapılacaksa, urun marka-kategori kontrolleri yapılıyor*/
			{
				for(tyy=1; tyy lte get_basket_rows_prj.recordcount; tyy=tyy+1)
				{
					//writeoutput("<br/>#tyy#---pro:#get_basket_rows_prj.PRODUCT_ID[tyy]#--#prj_prod_id_list#<br/>marka:#get_basket_rows_prj.BRAND_ID[tyy]#--#prj_prod_brand_list#--<br/>#get_basket_rows_prj.PRODUCT_CATID[tyy]#--#prj_prod_cat_list#<br/>");
					if( (not len(prj_prod_id_list) or listfind(prj_prod_id_list,get_basket_rows_prj.product_id[tyy]) ) and ( not len(prj_prod_brand_list) or listfind(prj_prod_brand_list,get_basket_rows_prj.brand_id[tyy]) ) and (not len(prj_prod_cat_list) or listfind(prj_prod_cat_list,get_basket_rows_prj.product_catid[tyy])))
						saleable_prod_list=listappend(saleable_prod_list,get_basket_rows_prj.product_id[tyy]);
					else
						non_useable_prod_list=listappend(non_useable_prod_list,get_basket_rows_prj.product_id[tyy]);
				}
			}
			else
				saleable_prod_list=listsort(valuelist(get_basket_rows_prj.PRODUCT_ID),'numeric','asc');
		</cfscript>
		<!---<cfoutput><br/>saleable_prod_list:#saleable_prod_list#---non_useable_prod_list:#non_useable_prod_list#</cfoutput> --->
		<cfif len(saleable_prod_list)>
			<cfset indirim_carpan_ = ((100-pro_disc_1) * (100-pro_disc_2) * (100-pro_disc_3) * (100-pro_disc_4) * (100-pro_disc_5))>
			<cfif listfind('-1,-2',prj_price_cat_)>
				<cfquery name="GET_PROD_PRICES" datasource="#DSN3#">
					SELECT
						PRICE_STANDART.PRODUCT_ID,
						PRICE,
						PRICE_KDV,
						IS_KDV,
						MONEY 
					FROM 
						PRICE_STANDART,
						PRODUCT_UNIT
					WHERE
						PRICE_STANDART.PURCHASESALES = 1 AND
						PRODUCT_UNIT.IS_MAIN = 1 AND 
						PRICE_STANDART.PRICESTANDART_STATUS = 1 AND
						PRICE_STANDART.PRODUCT_ID = PRODUCT_UNIT.PRODUCT_ID AND
						PRICE_STANDART.PRODUCT_ID IN (#saleable_prod_list#)
				</cfquery>
			<cfelse>
				<cfquery name="GET_PROD_PRICES" datasource="#DSN3#">
					SELECT  
						P.PRODUCT_ID,
						P.PRICE PRICE,
						P.PRICE_KDV,
						P.MONEY
					FROM 
						PRICE P
					WHERE 
						ISNULL(P.STOCK_ID,0)=0 AND 
						ISNULL(P.SPECT_VAR_ID,0)=0 AND 
						<cfif len(saleable_prod_list)>
							P.PRODUCT_ID IN (#saleable_prod_list#) AND 
						</cfif>
                        P.PRICE_CATID = <cfqueryparam cfsqltype="cf_sql_integer" value="#prj_price_cat_#">  AND  
                       	<!---(
                            P.PRICE_CATID = <cfqueryparam cfsqltype="cf_sql_integer" value="#prj_price_cat_#">  OR 
                            P.PRICE_CATID IN (SELECT PRICE_CATID FROM PRICE_CAT_EXCEPTIONS WHERE ACT_TYPE = 2 AND COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.pp.company_id#">)
                        ) AND  --->
						P.STARTDATE <= #now()# AND
						(P.FINISHDATE >= #now()# OR P.FINISHDATE IS NULL)
				</cfquery>
			</cfif>
			<cfif get_prod_prices.recordcount>
				<cfset price_prod_list=listsort(valuelist(get_prod_prices.product_id),'numeric','asc')>
				<cfloop list="#saleable_prod_list#" index="pr_ii">
					<cfif not listfind(price_prod_list,pr_ii)>
						<cfset non_useable_prod_list=listappend(non_useable_prod_list,pr_ii)>
						<cfset saleable_prod_list=ListDeleteAt(saleable_prod_list,listfind(saleable_prod_list,pr_ii))>
					</cfif>
				</cfloop>
			<cfelse>
				<cfset non_useable_prod_list=listappend(non_useable_prod_list,saleable_prod_list)>
				<cfset saleable_prod_list=''>
			</cfif>
		</cfif>
	</cfif>
	<cfif len(non_useable_prod_list)>
		<cfquery name="UPD_BASKET_ROWS" datasource="#DSN3#">
			DECLARE @RetryCounter INT
			SET @RetryCounter = 1
			RETRY:
				BEGIN TRY
					UPDATE
						ORDER_PRE_ROWS
					SET
						ROW_PRE_STATUS=#get_basket_rows_prj.IS_CHECKED#, <!---satırın önceki IS_CHECK bilgisini tutuyor --->
						IS_CHECKED=0
					WHERE
						PRODUCT_ID IN (#non_useable_prod_list#)
						AND ISNULL(IS_CHECKED,0)=1
						AND ISNULL(IS_COMMISSION,0)=0
						AND ISNULL(IS_CARGO,0)=0
						AND ISNULL(IS_PROM_ASIL_HEDIYE,0)=0
						<cfif isdefined("session.pp")>
							AND RECORD_PAR = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.pp.userid#">
						<cfelseif isdefined("session.ww.userid")>
							AND RECORD_CONS = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ww.userid#">
						<cfelseif isdefined("session.ep")>
							AND RECORD_EMP = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.userid#">
						<cfelseif not isdefined("session_base.userid")><!--- sistemde olmayan misafir kullanıcılar için baskete atılan ürünler --->
							AND RECORD_GUEST = 1 
							AND RECORD_IP = <cfqueryparam cfsqltype="cf_sql_varchar" value="#cgi.remote_addr#">
							AND COOKIE_NAME = <cfqueryparam cfsqltype="cf_sql_varchar" value="#evaluate("cookie.wrk_basket_#ReplaceList(cgi.http_host,'-,:','_,_')#")#">
						</cfif>
				END TRY
				BEGIN CATCH
					DECLARE @DoRetry bit; 
					DECLARE @ErrorMessage varchar(500)
					SET @doRetry = 0;
					SET @ErrorMessage = ERROR_MESSAGE()
					IF ERROR_NUMBER() = 1205 
					BEGIN
						SET @doRetry = 1; 
					END
					IF @DoRetry = 1
					BEGIN
						SET @RetryCounter = @RetryCounter + 1
						IF (@RetryCounter > 3)
						BEGIN
							RAISERROR(@ErrorMessage, 18, 1) -- Raise Error Message if 
						END
						ELSE
						BEGIN
							WAITFOR DELAY '00:00:00.05' 
							GOTO RETRY	
						END
					END
					ELSE
					BEGIN
						RAISERROR(@ErrorMessage, 18, 1)
					END
				END CATCH
		</cfquery>
	</cfif>
	<cfoutput query="get_basket_rows_prj">
		<cfif len(saleable_prod_list) and listfind(saleable_prod_list,get_basket_rows_prj.product_id)>
			<cfquery name="GET_PRO_PRICE" dbtype="query">
				SELECT * FROM GET_PROD_PRICES WHERE PRODUCT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_basket_rows_prj.product_id#">
			</cfquery>
			<cfset first_price = get_pro_price.price>
			<cfset first_price_kdv = get_pro_price.price_kdv>
			<cfset last_price = get_pro_price.price>
			<cfset new_price = get_pro_price.price>
			<cfset new_price_kdv = get_pro_price.price_kdv>
			<cfif len(get_basket_rows_prj.diff_rate_id)>
				<cfloop list="#get_basket_rows_prj.diff_rate_id#" index="new_diff_rate">
					<cfset new_price = new_price + (first_price*new_diff_rate/100)>
					<cfset last_price = last_price + (first_price*new_diff_rate/100)>
					<cfset new_price_kdv = new_price_kdv + (first_price_kdv*new_diff_rate/100)>
				</cfloop>
			</cfif>
			<cfset new_price = wrk_round((new_price*indirim_carpan_)/10000000000)>
			<cfset new_price_kdv = wrk_round((new_price_kdv*indirim_carpan_)/10000000000)>
			<cfquery name="UPD_BASKET_ROW_PRICE" datasource="#DSN3#">
				DECLARE @RetryCounter INT
				SET @RetryCounter = 1
				RETRY:
					BEGIN TRY
						UPDATE
							ORDER_PRE_ROWS
						SET
							ROW_PRE_STATUS=1,
							PRE_PRICE=#last_price#,
							PRE_PRICE_KDV=#last_price*(1+(tax/100))#,
							PRE_PRICE_MONEY='#get_basket_rows_prj.PRICE_MONEY#',
							PRICE_OLD=#last_price#,
							PRICE_KDV_OLD=#last_price*(1+(tax/100))#,
							DISCOUNT1=#pro_disc_1#,
							DISCOUNT2=#pro_disc_2#,
							DISCOUNT3=#pro_disc_3#,
							DISCOUNT4=#pro_disc_4#,
							DISCOUNT5=#pro_disc_5#,
							PRICE=#new_price#,
							PRICE_KDV=#new_price_kdv#,
							PRICE_MONEY='#get_pro_price.MONEY#'
						WHERE
							PRODUCT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_basket_rows_prj.product_id#">
							AND ORDER_ROW_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_basket_rows_prj.order_row_id#">
							AND ISNULL(IS_COMMISSION,0)=0
							AND ISNULL(IS_CARGO,0)=0
							AND ISNULL(IS_PROM_ASIL_HEDIYE,0)=0
							<cfif isdefined("session.pp")>
								AND RECORD_PAR = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.pp.userid#">
							<cfelseif isdefined("session.ww.userid")>
								AND RECORD_CONS = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ww.userid#">
							<cfelseif isdefined("session.ep")>
								AND RECORD_EMP = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.userid#">
							<cfelseif not isdefined("session_base.userid")><!--- sistemde olmayan misafir kullanıcılar için baskete atılan ürünler --->
								AND RECORD_GUEST = 1 
								AND RECORD_IP = <cfqueryparam cfsqltype="cf_sql_varchar" value="#cgi.remote_addr#">
								AND COOKIE_NAME = <cfqueryparam cfsqltype="cf_sql_varchar" value="#evaluate("cookie.wrk_basket_#ReplaceList(cgi.http_host,'-,:','_,_')#")#">
							</cfif>
					END TRY
					BEGIN CATCH
						DECLARE @DoRetry bit; 
						DECLARE @ErrorMessage varchar(500)
						SET @doRetry = 0;
						SET @ErrorMessage = ERROR_MESSAGE()
						IF ERROR_NUMBER() = 1205 
						BEGIN
							SET @doRetry = 1; 
						END
						IF @DoRetry = 1
						BEGIN
							SET @RetryCounter = @RetryCounter + 1
							IF (@RetryCounter > 3)
							BEGIN
								RAISERROR(@ErrorMessage, 18, 1) -- Raise Error Message if 
							END
							ELSE
							BEGIN
								WAITFOR DELAY '00:00:00.05' 
								GOTO RETRY	
							END
						END
						ELSE
						BEGIN
							RAISERROR(@ErrorMessage, 18, 1)
						END
					END CATCH
			</cfquery>
		</cfif>
	</cfoutput>
</cfif>

