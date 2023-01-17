    <cfif isdefined("attributes.cat") and len (attributes.cat)>
        <cfquery name="get_cats" datasource="#dsn1#">
            SELECT 
                PRODUCT_CAT.PRODUCT_CATID, 
                PRODUCT_CAT.HIERARCHY, 
                PRODUCT_CAT.PRODUCT_CAT
            FROM 
                PRODUCT_CAT,
                PRODUCT_CAT_OUR_COMPANY PCO
            WHERE 
                PRODUCT_CAT.PRODUCT_CATID = PCO.PRODUCT_CATID AND
                PCO.OUR_COMPANY_ID = #session.ep.company_id# AND
                (
                <cfloop from="1" to="#listlen(attributes.cat)#" index="ccc">
                    <cfset cat_ = listgetat(attributes.cat,ccc)>
                     (PRODUCT_CAT.HIERARCHY = <cfqueryparam cfsqltype="cf_sql_varchar" value="#cat_#"> OR PRODUCT_CAT.HIERARCHY LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="#cat_#.%">)
                     <cfif ccc neq listlen(attributes.cat)>
                        OR
                     </cfif>
                </cfloop>
                )
        </cfquery>
    <cfelse>
    	<cfset get_cats.recordcount = 0>
    </cfif>
		<cfquery name="upd_" datasource="#dsn1#">
			UPDATE
				PRODUCT 
			SET 
				PRODUCT_MANAGER = #attributes.PRODUCT_MANAGER#,
				UPDATE_DATE = #NOW()#,
				UPDATE_EMP = #SESSION.EP.USERID#,
				UPDATE_IP = <cfqueryparam cfsqltype="cf_sql_varchar" value="#CGI.REMOTE_ADDR#">
			WHERE
             1=1
            	<cfif get_cats.recordcount>
					AND PRODUCT_CATID IN (#valuelist(get_cats.PRODUCT_CATID)#)                 
                </cfif>
                <cfif isdefined("attributes.company_id") and len(attributes.company_id) and isdefined("attributes.comp") and len(attributes.comp)>
                	AND COMPANY_ID = #attributes.company_id#
                </cfif>
                <cfif isdefined("attributes.brand_id") and len (attributes.brand_id) and isdefined("attributes.brand_name") and len(attributes.brand_name)>
              		AND BRAND_ID = #attributes.brand_id#  
                </cfif>
                <cfif isdefined("short_code_id") and len (attributes.short_code_id) and isdefined("attributes.short_code_name") and len("attributes.short_code_name")>
                	AND SHORT_CODE_ID = #attributes.short_code_id#
                </cfif>
		</cfquery>
<cf_add_log  log_type="1" action_id="#attributes.PRODUCT_MANAGER#" action_name="Ürün Sorumlusu Atama">
<script type="text/javascript">
	alert('İşleminiz Başarı İle Tamamlandı!');
	window.location.href='<cfoutput>#request.self#?fuseaction=product.set_product_manager</cfoutput>';
</script>
