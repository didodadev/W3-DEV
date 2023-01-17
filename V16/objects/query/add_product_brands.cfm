<cfquery name="CHECK_SAME" datasource="#DSN1#">
	SELECT BRAND_ID FROM PRODUCT_BRANDS WHERE BRAND_NAME = '#attributes.brand_name#'
</cfquery>
<cfif check_same.recordcount>
	<script type="text/javascript">
		if(!confirm("<cf_get_lang dictionary_id ='34208.Aynı İsimli Bir Marka Var Bu Şirkette Yetkili Olmasını İstermisiniz'> ?"))
			history.back();
	</script>
	<cfquery name="add_brand_company_" datasource="#dsn1#">
		INSERT INTO 
            PRODUCT_BRANDS_OUR_COMPANY 
		(
			OUR_COMPANY_ID,
			BRAND_ID
		)
		VALUES
		(
			#session.ep.company_id#,
			#check_same.brand_id#
		)
	</cfquery>
	<script type="text/javascript">
		wrk_opener_reload();
		window.close();
	</script>
	<cfabort>
</cfif>
<cfquery name="get_brands" datasource="#dsn1#">
	SELECT BRAND_CODE FROM PRODUCT_BRANDS WHERE BRAND_CODE = '#attributes.brand_code#'
</cfquery>
<cfif get_brands.recordcount>
	<script type="text/javascript">
		alert("<cf_get_lang dictionary_id='64045.Aynı Marka Kodu ile Bir Marka Daha Var Lütfen Başka Bir Marka Kodu Giriniz'> !");
		history.back();
	</script>
	<cfabort>
</cfif>

<cflock name="#createUUID()#" timeout="20">
    <cftransaction>
        <cfquery name="ADD_PRODUCT_BRANDS" datasource="#DSN1#" result="MAX_ID">
            INSERT	INTO
                PRODUCT_BRANDS
            (
                IS_ACTIVE,
                IS_INTERNET,
                BRAND_CODE,
                BRAND_NAME,
                DETAIL,
                RECORD_IP,
                RECORD_EMP,
                RECORD_DATE
            )
                VALUES
            (
                <cfif isdefined("attributes.is_active")>1<cfelse>0</cfif>,
                <cfif isdefined("attributes.is_internet")>1,<cfelse>0,</cfif>
                <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.brand_code#">,
                <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.brand_name#">,
                <cfif len(attributes.detail)><cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.detail#"><cfelse>NULL</cfif>,
                <cfqueryparam cfsqltype="cf_sql_varchar" value="#cgi.remote_addr#">,
                #session.ep.userid#,
                #now()#
            )
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
						#MAX_ID.IDENTITYCOL#,
						#m#
					)
				</cfquery>
            </cfloop>
        </cfif>
    </cftransaction>
</cflock>	
<script type="text/javascript">
	window.location.href = "<cfoutput>#request.self#?fuseaction=product.list_product_brands&event=upd&id=#MAX_ID.IDENTITYCOL#</cfoutput>";
</script>
