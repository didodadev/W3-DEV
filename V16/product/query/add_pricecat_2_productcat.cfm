<cfquery name="KONTROL" datasource="#DSN3#">
	SELECT 
		PRICE_CAT 
	FROM 
		PRICE_CAT
	WHERE 
		PRICE_CAT = '#form.price_cat#' AND
		PRICE_CAT_STATUS = 1
</cfquery>

<cfif kontrol.recordcount>
	<script type="text/javascript">
		alert("<cf_get_lang no ='878.Bu İsim Kullanılıyor Lütfen Kontrol Ediniz'>..!");
		history.back();
	</script>
	<cfabort>
</cfif>

<cf_date tarih = "form.startdate">
<cflock name="#CREATEUUID()#" timeout="20">
	<cftransaction>
		<cfquery name="ADD_PRICE_CAT" datasource="#DSN3#" result="MAX_ID">
			INSERT INTO 
				PRICE_CAT 
			(
				PRICE_CAT_STATUS, 
				COMPANY_CAT, 
				CONSUMER_CAT, 
				BRANCH,
				PRICE_CAT, 
				TARGET_MARGIN,
				ROUNDING,
				IS_KDV,
				VALID_DATE,
				VALID_EMP,
				RECORD_EMP,
				STARTDATE,
				RECORD_DATE
			)
			VALUES   
			(
				1,
				<cfif isDefined("form.company_cat")>',#form.company_cat#,'<cfelse>','</cfif>,
				<cfif isDefined("form.consumer_cat")>',#form.consumer_cat#,'<cfelse>','</cfif>,
				<cfif isDefined("form.branch")>',#form.branch#,'<cfelse>','</cfif>,
				'#form.price_cat#',
				'#form.target_margin#',
				#form.rounding#,
				<cfif isDefined("form.is_kdv")>1<cfelse>0</cfif>,
				NULL,
				NULL,
				#session.ep.userid#,
				#form.startdate#,
				#now()#
			)
		</cfquery>
		<cfloop list="#product_cat_ids#" index="i">
			<cfquery name="ADD_PRICE_CAT_ROWS" datasource="#DSN3#">
				INSERT INTO
					PRICE_CAT_ROWS
				(
					PRICE_CATID,
					PRODUCT_CATID,
					MARGIN
				)
				VALUES
				(
					#MAX_ID.IDENTITYCOL#,
					#I#,
					#EVALUATE("list_margin_#i#")#
				)
			</cfquery>
		</cfloop>
	</cftransaction>
</cflock>

<cflocation url="#request.self#?fuseaction=product.form_upd_pricecat_2_productcat&pcat_id=#MAX_ID.IDENTITYCOL#" addtoken="no">
