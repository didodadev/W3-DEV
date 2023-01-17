<!--- Sayfa ürün tanımlar sayfasından ve ürün detayından olmak üzere 2 yerde çağırılıyor. --->
<cflock name="#CREATEUUID()#" timeout="20">
	<cftransaction>
		<!--- Bu cariye ait onceki hareketler siliniyor --->
		<cfif isDefined("attributes.form_upd_")>
			<cfquery name="DEL_SETUP_COMPANY_STOCK_CODE" datasource="#DSN1#">
				DELETE FROM 
                	SETUP_COMPANY_STOCK_CODE 
               	WHERE 
                <cfif isdefined('attributes.from_product_detail')>
					STOCK_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.stock_id#">
				<cfelse>
                	COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.company_id#">
				</cfif>
			</cfquery>
		</cfif>
		<cfloop from="1" to="#attributes.record_num#" index="i">
		  <cfif evaluate("attributes.row_kontrol#i#") neq 0>
			<cfquery name="ADD_COMPANY_STOCK_CODE" datasource="#DSN1#">
				INSERT INTO
					SETUP_COMPANY_STOCK_CODE
				(
					COMPANY_ID,
					STOCK_ID,
					COMPANY_STOCK_CODE,
					COMPANY_PRODUCT_NAME,
                    IS_ACTIVE,
                    PRIORITY,
                    DETAIL,
					UNIT_ID,
					RECORD_EMP,
					RECORD_DATE,
					RECORD_IP
				)
				VALUES
				(
				<cfif isdefined('attributes.from_product_detail')>				
                    #evaluate("attributes.member_id#i#")#,
                    #attributes.stock_id#,
                <cfelse>
                    #attributes.company_id#,
                    #evaluate("attributes.stock_id#i#")#,
                </cfif>
					'#wrk_eval("attributes.company_stock_code#i#")#',
					'#wrk_eval("attributes.company_product_name#i#")#',
                    <cfif isdefined("attributes.is_active#i#")>1<cfelse>0</cfif>,
                    <cfif len(wrk_eval("attributes.company_product_priority#i#"))>#wrk_eval("attributes.company_product_priority#i#")#<cfelse>NULL</cfif>,
                    <cfif len(wrk_eval("attributes.company_product_detail#i#"))>'#wrk_eval("attributes.company_product_detail#i#")#'<cfelse>NULL</cfif>,
					<cfif len(wrk_eval("attributes.company_stock_unit#i#")) And isdefined("attributes.company_stock_unit#i#")>#wrk_eval("attributes.company_stock_unit#i#")#<cfelse>0</cfif>,
					#session.ep.userid#,
					#now()#,
					'#cgi.remote_addr#'
				)
			</cfquery>
		  </cfif>
		</cfloop>
	</cftransaction>
</cflock>

<cfif not isdefined('attributes.from_product_detail')>
    <form name="form_get_company" method="post" action="<cfoutput>#request.self#?fuseaction=product.upd_company_stock_code</cfoutput>">
        <input type="hidden" name="form_varmi" id="form_varmi" value="1">
        <input type="hidden" name="company_id" id="company_id" value="<cfoutput>#attributes.company_id#</cfoutput>">
        <input type="hidden" name="member_name" id="member_name" value="<cfoutput>#attributes.member_name#</cfoutput>">
    </form>
    <script type="text/javascript">
        form_get_company.submit();
    </script>
<cfelse>
	<cfquery name="GET_PRODUCT_ID" datasource="#DSN1#">
    	SELECT
        	PRODUCT_ID
        FROM
        	STOCKS 
        WHERE
        	STOCK_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.stock_id#">
    </cfquery>
    <cflocation url="#request.self#?fuseaction=product.list_product&event=det&pid=#get_product_id.product_id#" addtoken="no">
</cfif>
