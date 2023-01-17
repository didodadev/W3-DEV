<cfif form.active_company neq session.ep.company_id>
	<script type="text/javascript">
		alert("<cf_get_lang no ='862.İşlemin Muhasebe Dönemi İle Aktif Muhasebe Döneminiz Farklı'>...<cf_get_lang no ='863.Muhasebe Döneminizi Kontrol Ediniz'>!");
		window.location.href='<cfoutput>#request.self#?fuseaction=product.list_price_cat</cfoutput>';
	</script>
	<cfabort>
</cfif>
<cf_date tarih="form.startdate">
<cfset form.startdate = date_add('h',form.start_clock,date_add('n',form.start_min,form.startdate))>

<cfinclude template="../query/get_price_cat.cfm">
	
<cfquery name="UPD_PRICE_CAT" datasource="#dsn3#">
	UPDATE
		PRICE_CAT 
	SET 
	<cfif isDefined("form.company_cat")>
		COMPANY_CAT = ',#listsort(",#GET_PRICE_CAT.COMPANY_CAT#,#form.company_cat#,","Numeric")#,',
	</cfif>
	<cfif isDefined("form.consumer_cat")>
		CONSUMER_CAT = ',#listsort(",#GET_PRICE_CAT.CONSUMER_CAT#,#form.consumer_cat#,","Numeric")#,',
	</cfif>
	<cfif isDefined("form.branch")>
		BRANCH = ',#listsort(",#GET_PRICE_CAT.BRANCH#,#form.branch#,","Numeric")#,',
	</cfif>
		TARGET_MARGIN = '#FORM.TARGET_MARGIN#',
		PRICE_CAT = '#FORM.PRICE_CAT#',
		STARTDATE = #form.startdate#,
		ROUNDING = #FORM.ROUNDING#,
		IS_KDV = <cfif IsDefined("attributes.IS_KDV")>1<cfelse>0</cfif>
	WHERE 
		PRICE_CATID = #attributes.pcat_id# 
</cfquery>

<cfif form.go_val is 0>
	
	<cflocation url="#cgi.referer#" addtoken="no">

<cfelse>
	
	<cfquery name="DEL_PRICE_CAT_ROWS" datasource="#dsn3#">
		DELETE FROM
			PRICE_CAT_ROWS
		WHERE
			PRICE_CATID = #attributes.PCAT_ID#
	</cfquery>

	<cfquery name="DELETE_PRICE_TO_OLD" datasource="#dsn3#">
		DELETE FROM	PRICE WHERE PRICE_CATID = #attributes.pcat_id# AND STARTDATE=#form.startdate#
	</cfquery>
				
	<cfloop list="#product_cat_ids#" index="i">
		<cfquery name="add_price_cat_rows" datasource="#dsn3#">
			INSERT INTO
				PRICE_CAT_ROWS
				(
				PRICE_CATID,
				PRODUCT_CATID,
				MARGIN
				)
			VALUES
				(
				#attributes.PCAT_ID#,
				#i#,
				0#EVALUATE("list_margin_#i#")#
				)
		</cfquery>
	</cfloop>

	<cfquery name="GET_PRODUCT_CATS" datasource="#dsn3#">
		SELECT 
			PRODUCT_CATID,
			MARGIN
		FROM 
			PRICE_CAT_ROWS
		WHERE
			PRICE_CAT_ROWS.PRODUCT_CATID IN (#attributes.PRODUCT_CAT_IDS#)
			AND
			PRICE_CAT_ROWS.PRICE_CATID = #attributes.PCAT_ID#
	</cfquery>
	
	<cfloop query="GET_PRODUCT_CATS">
	
		<cfquery name="GET_PRODUCT" datasource="#dsn3#">
			SELECT 
				P.PRODUCT_ID,
				PU.PRODUCT_UNIT_ID,
				P.TAX ,
				S.STOCK_ID
			FROM 
				PRODUCT AS P,
				STOCKS S,
				PRODUCT_UNIT AS PU
			WHERE
				S.PRODUCT_ID = P.PRODUCT_ID AND
				P.PRODUCT_ID=PU.PRODUCT_ID AND
				PU.IS_MAIN = 1 AND
				P.PRODUCT_CATID = #product_catid#
		</cfquery>
		
		<cflock name="#CreateUUID()#" timeout="70">
			<cftransaction>
				
				<cfloop from="1" to="#get_product.recordcount#" index="prd_index">
					
					<cfif len(form.target_margin)>
					
						<!--- Alis Fiyati Üzerinden Eklenti Yapiliyor.. --->
						<cfif form.target_margin eq 'standart'><!--- standart alis fiyatina ekleme --->
							<cfquery name="GET_PRICE" datasource="#dsn3#">
								SELECT 
									PRICE, 
									MONEY 
								FROM 
									PRICE_STANDART
								WHERE 
									PRODUCT_ID = #GET_PRODUCT.PRODUCT_ID[PRD_INDEX]# AND
									PRICESTANDART_STATUS = 1 AND
									PURCHASESALES = 0 AND
									UNIT_ID = #GET_PRODUCT.PRODUCT_UNIT_ID[PRD_INDEX]#
							</cfquery>
						<cfelse><!--- ortalama ve son alis fiyatina eklemek icin query buraya yazilacak su anda standartdi aliyoruz--->
							<cfquery name="GET_PRICE" datasource="#dsn3#">
								SELECT 
									PRICE,
									MONEY 
								FROM 
									PRICE_STANDART
								WHERE 
									PRODUCT_ID = #GET_PRODUCT.PRODUCT_ID[PRD_INDEX]# AND
									PRICESTANDART_STATUS = 1 AND
									PURCHASESALES = 0 AND
									UNIT_ID = #GET_PRODUCT.PRODUCT_UNIT_ID[PRD_INDEX]#
							</cfquery>
						</cfif>
						
						<cfif GET_PRICE.recordcount>
							<cfset end_price = get_price.price + ((get_price.price*GET_PRODUCT_CATS.margin)/100)>
						</cfif>
						
					<cfelse>
					
						<!--- Satis Fiyati Üzerinden Indirim Yapiliyor.. --->
						<cfquery name="GET_PRICE" datasource="#dsn3#">
							SELECT 
								PRICE,MONEY 
							FROM 
								PRICE_STANDART
							WHERE
								PRODUCT_ID = #GET_PRODUCT.PRODUCT_ID[PRD_INDEX]# AND
								PRICESTANDART_STATUS = 1 AND
								PURCHASESALES = 1 AND
								UNIT_ID = #GET_PRODUCT.PRODUCT_UNIT_ID[PRD_INDEX]#
						</cfquery>
						<cfif GET_PRICE.recordcount>
							<cfset end_price = get_price.price - ((get_price.price*GET_PRODUCT_CATS.margin)/100)>
						</cfif>
					
					</cfif>

					<cfif GET_PRICE.recordcount and end_price>
						<cfscript>
							end_price_with_kdv = end_price+((end_price*GET_PRODUCT.TAX[PRD_INDEX])/100);
							/*
							if (attributes.ROUNDING is 0)
								{
								end_price = round(end_price);
								end_price_with_kdv = round(end_price_with_kdv);
								}
							else if (attributes.ROUNDING is 1)
								{
								end_price = round(end_price*10)/10;
								end_price_with_kdv = round(end_price_with_kdv*10)/10;
								}
							else if (attributes.ROUNDING is 2)
								{
								end_price = round(end_price*100)/100;
								end_price_with_kdv = round(end_price_with_kdv*100)/100;
								}
							else if (attributes.ROUNDING is 3)
								{
								end_price = round(end_price*1000)/1000;
								end_price_with_kdv = round(end_price_with_kdv*1000)/1000;
								}
							*/
							add_price(product_id : GET_PRODUCT.PRODUCT_ID[PRD_INDEX],
								product_unit_id : GET_PRODUCT.PRODUCT_UNIT_ID[PRD_INDEX],
								price_cat : attributes.pcat_id,
								start_date : form.startdate,
								price : end_price,
								price_money : GET_PRICE.MONEY,
								is_kdv : #iif(isDefined('IS_KDV'),1,0)#,
								price_with_kdv : end_price_with_kdv,
								stock_id : get_product.stock_id[PRD_INDEX]
								);
						</cfscript>
					</cfif>

				</cfloop>

			</cftransaction>
		</cflock>

	</cfloop>

	<cflocation url="#cgi.referer#" addtoken="no">

</cfif>
