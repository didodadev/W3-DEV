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
<cfif isdefined("form.is_kdv")>
	<cfset is_kdv_f = 1>
</cfif>

<cfset end_price = wrk_round(price)>
<cfset gelen_money = money>
<cfset end_price_with_kdv = wrk_round(end_price+((end_price*attributes.satis_kdv)/100))>
<cfset end_price_without_kdv = wrk_round((end_price*100)/(attributes.satis_kdv+100))>
<cfset attributes.ROUNDING = 0>
<cflock timeout="20" name="#CreateUUID()#">
	<cftransaction>
		<cfscript>
			add_price(product_id : attributes.pid,
				product_unit_id : attributes.unit_id,
				price_cat : attributes.price_catid,
				start_date : form.startdate,
				price : iif(is_kdv_f,end_price_without_kdv,end_price),
				price_money : gelen_money,
				is_kdv : is_kdv_f,
				price_with_kdv : iif(is_kdv_f,end_price,end_price_with_kdv)
				);
		</cfscript>
	</cftransaction>
</cflock> 

<cf_workcube_process 
	is_upd='1' 
	old_process_line='0'
	process_stage='#attributes.process_stage#' 
	record_member='#session.ep.userid#'
	record_date='#now()#' 
	action_id='#attributes.pid#' 
	action_page='#request.self#?fuseaction=product.detail_product_price&pid=#attributes.pid#'
	warning_description='Şube Ürün Fiyat Ekleme : #attributes.product_name#'>

<cfif cgi.referer contains "popup">
	<script type="text/javascript">
		wrk_opener_reload();
		window.close();
	</script>
<cfelse>
	<cflocation url="#cgi.referer#" addtoken="no">
</cfif>
