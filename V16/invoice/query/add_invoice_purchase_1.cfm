<!--- 20050302 buradaki dosya siralari performans ve oncelik dusunulerek duzenlendi bilgi disinda degistirmeyin --->
<cfif not isdefined('xml_import')>
	<cfinclude template="check_product_exists.cfm">
</cfif>
<cfif isdefined("attributes.note")>
	<cfset note = attributes.note>
</cfif>
<cfscript>
	attributes.acc_type_id = '';
	if(isdefined("attributes.employee_id") and listlen(attributes.employee_id,'_') eq 2)
	{
		attributes.acc_type_id = listlast(attributes.employee_id,'_');
		attributes.employee_id = listfirst(attributes.employee_id,'_');
	}
</cfscript>
<cfset 	form.basket_rate2 = form.basket_rate2 / form.basket_rate1>
<cf_date tarih ='attributes.invoice_date'>
<cfif isdefined("attributes.process_date") and len(attributes.process_date)>
	<cf_date tarih ='attributes.process_date'>
</cfif>
<cf_date tarih = "attributes.basket_due_value_date_">
<cfif isdefined('attributes.realization_date') and isdate(attributes.realization_date)>
	<cf_date tarih='attributes.realization_date'>
</cfif>
<cfset invoice_due_date = attributes.basket_due_value_date_>
<cfif isdefined('attributes.deliver_date_frm') and isdate(attributes.deliver_date_frm)>
	<cf_date tarih='attributes.deliver_date_frm'>
</cfif>
<!--- gelen fatura tarihine gore vade tarihi bulunur YO20062802--->
<cfset form.invoice_number = trim(form.invoice_number)>
<cfif not isdefined('xml_import')>
	<cfquery name="GET_SALE" datasource="#new_dsn2_group#">
		SELECT
			INVOICE_NUMBER,
			PURCHASE_SALES
		FROM
			INVOICE
		WHERE
			PURCHASE_SALES = 0 AND
			INVOICE_NUMBER = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.invoice_number#">
		  <cfif len(attributes.company_id) and len(attributes.comp_name)>
			AND COMPANY_ID = #attributes.company_id# 
		  <cfelseif len(attributes.consumer_id)>
			AND CONSUMER_ID = #attributes.consumer_id#
		  <cfelse>
		  	AND EMPLOYEE_ID = #attributes.employee_id#
		  </cfif>
	</cfquery>
	<cfif get_sale.recordcount>
		<script type="text/javascript">
			alert("<cf_get_lang dictionary_id='64681.Girdiğiniz Fatura Numarası Seçilen Cari Adına Kullanılmış'> !");
			window.location.href='<cfoutput>#cgi.referer#</cfoutput>';
			//history.back();
		</script>
		<cfabort>
	</cfif>
</cfif>
<cfinclude template="check_taxes.cfm">
<cfinclude template="get_basket_irs.cfm">
<!---muhasebe hareketlerinde location_type a gore urun muhasebe kodları alınıyor --->
<cfif len(attributes.department_id) and len(attributes.location_id)>
	<cfquery name="GET_LOCATION_TYPE" datasource="#new_dsn2_group#">
		SELECT LOCATION_TYPE,IS_SCRAP FROM #dsn_alias#.STOCKS_LOCATION WHERE DEPARTMENT_ID=#attributes.department_id# AND LOCATION_ID=#attributes.location_id#
	</cfquery>
	<cfset location_type=GET_LOCATION_TYPE.LOCATION_TYPE>
	<cfset is_scrap=GET_LOCATION_TYPE.IS_SCRAP>
<cfelse>
	<cfset location_type = "">
	<cfset is_scrap = 0>
</cfif>
<cfif not included_irs and not isdefined('xml_import')>
	<cfquery name="GET_PURCHASE" datasource="#new_dsn2_group#">
		SELECT
			SHIP_NUMBER
		FROM
			SHIP
		WHERE
			PURCHASE_SALES = 0 AND 
			SHIP_NUMBER = '#form.invoice_number#'
		 <cfif len(attributes.company_id) and len(attributes.comp_name)>
			AND COMPANY_ID = #attributes.company_id# 
		  <cfelseif len(attributes.consumer_id)>
			AND CONSUMER_ID = #attributes.consumer_id#
		  <cfelse>
		  	AND EMPLOYEE_ID = #attributes.employee_id#
		  </cfif>
	</cfquery>
	<cfif get_purchase.recordcount>
		<script type="text/javascript">
			alert("Girdiğiniz İrsaliye Numarası Seçilen Cari Adına Kullanılmış !");
			window.location.href='<cfoutput>#cgi.referer#</cfoutput>';
			//history.back();
		</script>
		<cfabort>
	</cfif>
</cfif>
<cfif isDefined("attributes.company_id") and len(attributes.company_id)>
	<cfquery name="get_customer_info" datasource="#new_dsn2_group#">
		SELECT
			SALES_COUNTY,
			COMPANY_VALUE_ID AS CUSTOMER_VALUE_ID,
			RESOURCE_ID,
			IMS_CODE_ID
		FROM
			#dsn_alias#.COMPANY
		WHERE
			COMPANY_ID=#attributes.company_id#
	</cfquery>
<cfelseif isdefined("attributes.consumer_id") and len(attributes.consumer_id)>
	<cfquery name="get_customer_info" datasource="#new_dsn2_group#">
		SELECT
			SALES_COUNTY,
			CUSTOMER_VALUE_ID,
			RESOURCE_ID,
			IMS_CODE_ID
		FROM
			#dsn_alias#.CONSUMER
		WHERE
			CONSUMER_ID=#attributes.consumer_id#
	</cfquery>
</cfif>
<cfinclude template="get_bill_process_cat.cfm">
<cfinclude template="check_disc_accs.cfm">
<!--- basketin secili olan kurun degeri cari ve muh islemlerinde kullaniliyor--->
<cfset attributes.currency_multiplier = ''>
<cfset paper_currency_multiplier = ''>
<cfif isDefined('attributes.kur_say') and len(attributes.kur_say)>
	<cfloop from="1" to="#attributes.kur_say#" index="mon">
		<cfif evaluate("attributes.hidden_rd_money_#mon#") is session.ep.money2>
			<cfset attributes.currency_multiplier = evaluate('attributes.txt_rate2_#mon#/attributes.txt_rate1_#mon#')>
		</cfif>
		<cfif evaluate("attributes.hidden_rd_money_#mon#") is form.basket_money>
			<cfset paper_currency_multiplier = evaluate('attributes.txt_rate2_#mon#/attributes.txt_rate1_#mon#')>
		</cfif>
	</cfloop>	
</cfif>
