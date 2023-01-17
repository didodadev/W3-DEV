<cfquery name="CHECK_SAME" datasource="#DSN1#">
	SELECT BRAND_ID FROM PRODUCT_BRANDS WHERE BRAND_NAME = '#attributes.brand_name#' AND BRAND_ID <> #attributes.id#
</cfquery>
<cfif check_same.recordcount>
	<script type="text/javascript">
		alert('Aynı İsimli Bir Marka Daha Var \rLütfen Başka Bir Marka İsmi Giriniz !');
		history.back();
	</script>
	<cfabort>
</cfif>
<cfquery name="get_brands" datasource="#dsn1#">
	SELECT BRAND_CODE FROM PRODUCT_BRANDS WHERE BRAND_CODE = '#attributes.brand_code#' AND BRAND_ID <> #attributes.id#
</cfquery>
<cfif get_brands.recordcount>
	<script type="text/javascript">
		alert('Aynı Marka Kodu ile Bir Marka Daha Var \rLütfen Başka Bir Marka Kodu Giriniz !');
		history.back();
	</script>
	<cfabort>
</cfif>
<cfquery name="ADD_PRODUCT_BRANDS" datasource="#dsn1#">
	UPDATE
		PRODUCT_BRANDS
	SET
		IS_ACTIVE = <cfif isdefined("attributes.is_active")>1<cfelse>0</cfif>,
		IS_INTERNET = <cfif isdefined("attributes.is_internet")>1<cfelse>0</cfif>,
		BRAND_CODE =<cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.brand_code#">,
		BRAND_NAME =<cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.BRAND_NAME#">,
		DETAIL= <cfif len(attributes.DETAIL)><cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.DETAIL#"><cfelse>NULL</cfif>,
		UPDATE_IP = <cfqueryparam cfsqltype="cf_sql_varchar" value="#cgi.remote_addr#">,
		UPDATE_EMP = #session.ep.userid#,
		UPDATE_DATE = #now()#
	WHERE
		BRAND_ID=#attributes.id#
</cfquery>

<cfquery name="DEL_PRODUCT_CAT_BRANDS" datasource="#DSN1#">
	DELETE FROM PRODUCT_BRANDS_OUR_COMPANY WHERE BRAND_ID = #attributes.ID#
</cfquery>

<cfif isdefined("attributes.our_company_ids") and listlen(attributes.our_company_ids)>
	<cfloop list="#attributes.our_company_ids#" index="m">
			<cfquery name="ADD_PRODUCT_CAT_BRANDS" datasource="#DSN1#">
				INSERT INTO
					PRODUCT_BRANDS_OUR_COMPANY
				(
					BRAND_ID,
					OUR_COMPANY_ID
				)				
				VALUES
				(
					#attributes.ID#,
					#m#
				)
			</cfquery>
	</cfloop>
</cfif>
<script type="text/javascript">
	location.href = document.referrer;
</script>
