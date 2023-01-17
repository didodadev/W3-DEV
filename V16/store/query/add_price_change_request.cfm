<cfif form.active_company neq session.ep.company_id>
	<script type="text/javascript">
		alert("<cf_get_lang no='53.İşlemin Muhasebe Dönemi İle Aktif Muhasebe Döneminiz Farklı'>...<cf_get_lang no='49.Muhasebe Dönem Şirketinizi Kontrol Ediniz'>!");
		window.opener.location.href='<cfoutput>#request.self#?fuseaction=store.prices</cfoutput>';
		window.close();
	</script>
	<cfabort>
</cfif>
<cfif form.active_year neq session.ep.period_year>
	<cfif ((form.active_year gte 2005) and (session.ep.period_year lte 2004)) or ((form.active_year lte 2004) and (session.ep.period_year gte 2005))>
		<script type="text/javascript">
			alert("<cf_get_lang no='53.İşlemin Muhasebe Dönemi İle Aktif Muhasebe Döneminiz Farklı'>...<cf_get_lang no ='57.Muhasebe Döneminizi Kontrol Ediniz'>!");
			window.opener.location.href='<cfoutput>#request.self#?fuseaction=store.prices</cfoutput>';
			window.close();
		</script>
	<cfabort>
	</cfif>
</cfif>
<cf_date tarih="form.startdate">
<cfset form.startdate = date_add("h", form.start_clock, form.startdate)>
<cfset form.startdate = date_add("n", form.start_min, form.startdate)>
<cfset is_kdv_f = 0>
<cfif isdefined("form.is_kdv") and ListFind(form.is_kdv, form.price_catid, ",")>
	<cfset is_kdv_f = 1>
</cfif>
<cfset end_price = wrk_round(attributes.price)>
<cfset end_price_with_kdv = wrk_round(end_price+((end_price*attributes.satis_kdv)/100))>
<cfset end_price_without_kdv = wrk_round((end_price*100)/(attributes.satis_kdv+100))>
<cfset attributes.ROUNDING = 0>
<cfquery name="ADD_PRICE_CHANGE" datasource="#dsn3#">
	INSERT INTO 
		PRICE_CHANGE 
		(
			PRICE_STATUS,
			PRICE_CATID,
			PRODUCT_ID,
			STARTDATE,
			PRICE,
			PRICE_KDV,
			IS_KDV,
			ROUNDING,
			MONEY,
			UNIT,
			REASON,
			RECORD_DATE,
			RECORD_EMP,
			RECORD_IP
		 )					 
		VALUES 
		(
			1,
			#FORM.PRICE_CATID#,
			#FORM.PID#,
			#FORM.STARTDATE#,
			<cfif is_kdv_f>
				#end_price_without_kdv#,
				#end_price#,
			<cfelse>
				#end_price#,
				#end_price_with_kdv#,
			</cfif>
			#is_kdv_f#,
			#ATTRIBUTES.ROUNDING#,
			'#money#',
			#FORM.UNIT_ID#,
			'#FORM.REASON#',
			#NOW()#,
			#SESSION.EP.USERID#,
			'#CGI.REMOTE_ADDR#'
		)
</cfquery>
<script type="text/javascript">
	wrk_opener_reload();
	window.close();
</script>
