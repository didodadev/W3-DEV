<cfinclude template = "../../objects/query/session_base.cfm">
<!--- vergi tanımları yapılmış mı kontrolü --->
<cfquery name="GET_BASKET" datasource="#DSN3#"><!--- 20050723 get_lang_main_cached_time : get_lang_set_main custom tag icinde set ediliyor --->
    SELECT 
		SETUP_BASKET.OTV_CALC_TYPE
    FROM 
        SETUP_BASKET
    WHERE 
   		SETUP_BASKET.BASKET_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.basket_id#">
</cfquery>
<cfset inventory_product_exists = 0 >
<cfset temp_tax_list = "">
<cfset kontrol_otv = 0>
<cfset temp_otv_list = "">
<cfset temp_bsmv_list= "">
<cfif not isdefined("new_dsn2_group")><cfset new_dsn2_group = dsn2><cfset kontrol_otv = 1></cfif>
<cfif new_dsn2_group eq dsn2>
	<cfset kontrol_otv = 1>
</cfif>
<cfloop from="1" to="#attributes.rows_#" index="tax_i">
    <cfif isdefined("attributes.tax#tax_i#") and  not listfind(temp_tax_list, evaluate("attributes.tax#tax_i#"), ",")>
		<cfset temp_tax_list = ListAppend(temp_tax_list, evaluate("attributes.tax#tax_i#"), ",")>
	</cfif>
    <cfif isdefined("attributes.otv_oran#tax_i#") and len(evaluate("attributes.otv_oran#tax_i#")) and evaluate("attributes.otv_oran#tax_i#") neq 0 and  not listfind(temp_otv_list, evaluate("attributes.otv_oran#tax_i#"), ",")>
		<cfset temp_otv_list = ListAppend(temp_otv_list, evaluate("attributes.otv_oran#tax_i#"), ",")>
	</cfif>
	<cfif isdefined("attributes.row_bsmv_rate#tax_i#") and len(evaluate("attributes.row_bsmv_rate#tax_i#")) and evaluate("attributes.row_bsmv_rate#tax_i#") neq 0 and  not listfind(temp_bsmv_list, evaluate("attributes.row_bsmv_rate#tax_i#"), ",")>
		<cfset temp_bsmv_list = ListAppend(temp_bsmv_list, evaluate("attributes.row_bsmv_rate#tax_i#"), ",")>
	</cfif>
	<cfif isdefined("attributes.is_inventory#tax_i#") and evaluate("attributes.is_inventory#tax_i#") eq 1>
		<cfset inventory_product_exists = 1>
	</cfif> 
</cfloop>
<cfif listlen(temp_tax_list)>
    <cfquery name="get_taxes" datasource="#new_dsn2_group#">
        SELECT * FROM SETUP_TAX WHERE TAX IN (#temp_tax_list#)
    </cfquery>
    <cfset tax_list = valuelist(get_taxes.tax)>
    <cfif ListLen(temp_tax_list,",") neq get_taxes.recordcount>
        <cfif not isdefined('xml_import')>
            <script type="text/javascript">
                alert("<cf_get_lang no ='47.Seçtiğiniz Kdv Değerlerinin İçinde Tanımlı Olmayan KDVler var'> !");
                window.location.href='<cfoutput>#cgi.referer#</cfoutput>';
                //history.back();
            </script>
            <cfabort>
        <cfelse>
             <cfoutput>#attributes.invoice_number#</cfoutput><cf_get_lang no ='347.Kdv Değerlerinin İçinde Tanımlı Olmayan KDVler var'>!<br/>
             <cfset error_flag =1>
        </cfif>
    </cfif>
</cfif>
<cfif listlen(temp_bsmv_list)>
    <cfquery name="get_taxes" datasource="#dsn3#">
        SELECT * FROM SETUP_BSMV WHERE TAX IN (#temp_bsmv_list#) AND PERIOD_ID = #session_base.PERIOD_ID#
    </cfquery>
    <cfset tax_list = valuelist(get_taxes.tax)>
    <cfif ListLen(temp_bsmv_list,",") neq get_taxes.recordcount>
        <cfif not isdefined('xml_import')>
            <script type="text/javascript">
                alert("<cf_get_lang no ='176.Seçtiğiniz Kdv Değerlerinin İçinde Tanımlı Olmayan KDVler var'> !");
                window.location.href='<cfoutput>#cgi.referer#</cfoutput>';
                //history.back();
            </script>
            <cfabort>
        <cfelse>
             <cfoutput>#attributes.invoice_number#</cfoutput><cf_get_lang no ='176.Kdv Değerlerinin İçinde Tanımlı Olmayan KDVler var'>!<br/>
             <cfset error_flag =1>
        </cfif>
    </cfif>
</cfif>
<cfif len(temp_otv_list) and kontrol_otv eq 1 and not len(get_basket.OTV_CALC_TYPE)>
	<cfquery name="get_otv" datasource="#dsn3#">
		SELECT * FROM SETUP_OTV WHERE TAX IN (#temp_otv_list#) AND PERIOD_ID = #session_base.PERIOD_ID#
	</cfquery>
	<cfset otv_list = valuelist(get_otv.tax)>
	<cfif ListLen(temp_otv_list,",") neq get_otv.recordcount>
		<cfif not isdefined('xml_import')>
			<script type="text/javascript">
				alert("<cf_get_lang no ='348.Seçtiğiniz ÖTV Değerlerinin İçinde Tanımlı Olmayan ÖTV ler var'> !");
				window.location.href='<cfoutput>#cgi.referer#</cfoutput>';
				//history.back();
			</script>
			<cfabort>
		<cfelse>
			<cfoutput>#attributes.invoice_number#</cfoutput> <cf_get_lang no ='349.ÖTV Değerlerinin İçinde Tanımlı Olmayan ÖTV ler var'>!<br/>
			<cfset error_flag =1>
		</cfif>
	</cfif>
<cfelse>
	<cfset get_otv.recordcount=0> <!--- faturanın muhasebe için include edilen dosyalarında kullanılıyor --->
</cfif>
