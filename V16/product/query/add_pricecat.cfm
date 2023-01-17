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
		alert("<cf_get_lang no ='878.Bu İsim Kullanılıyor Lütfen Kontrol Ediniz'> !");
		window.location.href="<cfoutput>#request.self#?fuseaction=product.list_price_cat</cfoutput>";
	</script>
	<cfabort>
</cfif>
<cf_date tarih = "form.startdate">
<cfif isdefined('target_due_date') and isdate(target_due_date)><cf_date tarih = "attributes.target_due_date"></cfif>
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
				IS_KDV,
				MARGIN, 
				TARGET_MARGIN_ID,
				ROUNDING,
				VALID_DATE,
				VALID_EMP,
				STARTDATE,
				NUMBER_OF_INSTALLMENT,
				AVG_DUE_DAY,
				TARGET_DUE_DATE,
				DUE_DIFF_VALUE,
				EARLY_PAYMENT,
				PAYMETHOD,
				IS_CALC_PRODUCTCAT,
				IS_PURCHASE,
				IS_SALES,
				RECORD_EMP,
				RECORD_DATE,
				RECORD_IP			
			)
			VALUES  
			(
				1,
				<cfif isDefined("form.company_cat")><cfqueryparam cfsqltype="cf_sql_varchar" value=",#form.company_cat#,"><cfelse><cfqueryparam cfsqltype="cf_sql_varchar" value=","></cfif>,
				<cfif isDefined("form.consumer_cat")><cfqueryparam cfsqltype="cf_sql_varchar" value=",#form.consumer_cat#,"><cfelse><cfqueryparam cfsqltype="cf_sql_varchar" value=","></cfif>,
				<cfif isDefined("form.branch")><cfqueryparam cfsqltype="cf_sql_varchar" value=",#form.branch#,"><cfelse><cfqueryparam cfsqltype="cf_sql_varchar" value=","></cfif>,
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.price_cat#">,
				<cfif isDefined('is_kdv')>1<cfelse>0</cfif>,
				<cfif trim(form.margin) IS "" or not isnumeric(form.margin)>NULL,NULL,<cfelse>#trim(form.margin)#,#form.target_margin#,</cfif>
				#form.rounding#,
				NULL,
				NULL,
				#form.startdate#,
				<cfif len(attributes.number_of_installment)>#attributes.number_of_installment#<cfelse>0</cfif>,
				<cfif len(attributes.avg_due_day)>#attributes.avg_due_day#<cfelse>0</cfif>,
				<cfif len(attributes.target_due_date)>#attributes.target_due_date#<cfelse>NULL</cfif>,
				<cfif len(attributes.due_diff_value)>#attributes.due_diff_value#<cfelse>0</cfif>,
				<cfif len(attributes.early_payment)>#attributes.early_payment#<cfelse>0</cfif>,
				#attributes.paymethod#,
				<cfif isdefined("attributes.is_price_from_category")>1<cfelse>0</cfif>,
				<cfif isdefined("attributes.is_purchase")>1<cfelse>0</cfif>,
				<cfif isdefined("attributes.is_sales")>1<cfelse>0</cfif>,
				#session.ep.userid#,
				#now()#,
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#cgi.remote_addr#">				
			)
		</cfquery>
	</cftransaction>
</cflock>
<script type="text/javascript">
	window.location.reload();
</script>
