<!---
	<cfdump var="#attributes#"><cfabort>
--->
<cfif isdefined("attributes.marketplace_pc_id") and len(attributes.marketplace_pc_id)>
        <cfquery name="UPD_MARKETPLACE_PRODUCT_CAT" datasource="#DSN#">
            UPDATE 
                MARKET_PLACE_PRODUCT_CAT 
            SET
				GITTIGIDIYOR_HIERARCHY = <cfif isdefined("attributes.GITTIGIDIYOR_HIERARCHY") and len(attributes.GITTIGIDIYOR_HIERARCHY)>'#attributes.GITTIGIDIYOR_HIERARCHY#'<cfelse>NULL</cfif>,
				GITTIGIDIYOR_PRODUCT_CAT = <cfif isdefined("attributes.GITTIGIDIYOR_PRODUCT_CAT") and len(attributes.GITTIGIDIYOR_PRODUCT_CAT)>'#attributes.GITTIGIDIYOR_PRODUCT_CAT#'<cfelse>NULL</cfif>,
				N11_HIERARCHY = <cfif isdefined("attributes.N11_HIERARCHY") and len(attributes.N11_HIERARCHY)>'#attributes.N11_HIERARCHY#'<cfelse>NULL</cfif>,
				N11_PRODUCT_CAT = <cfif isdefined("attributes.N11_PRODUCT_CAT") and len(attributes.N11_PRODUCT_CAT)>'#attributes.N11_PRODUCT_CAT#'<cfelse>NULL</cfif>,
				HEPSIBURADA_HIERARCHY = <cfif isdefined("attributes.HEPSIBURADA_HIERARCHY") and len(attributes.HEPSIBURADA_HIERARCHY)>'#attributes.HEPSIBURADA_HIERARCHY#'<cfelse>NULL</cfif>,
				HEPSIBURADA_PRODUCT_CAT = <cfif isdefined("attributes.HEPSIBURADA_PRODUCT_CAT") and len(attributes.HEPSIBURADA_PRODUCT_CAT)>'#attributes.HEPSIBURADA_PRODUCT_CAT#'<cfelse>NULL</cfif>,
				SAHIBINDEN_HIERARCHY = <cfif isdefined("attributes.SAHIBINDEN_HIERARCHY") and len(attributes.SAHIBINDEN_HIERARCHY)>'#attributes.SAHIBINDEN_HIERARCHY#'<cfelse>NULL</cfif>,
				SAHIBINDEN_PRODUCT_CAT = <cfif isdefined("attributes.SAHIBINDEN_PRODUCT_CAT") and len(attributes.SAHIBINDEN_PRODUCT_CAT)>'#attributes.SAHIBINDEN_PRODUCT_CAT#'<cfelse>NULL</cfif>,
				AMAZON_HIERARCHY = <cfif isdefined("attributes.AMAZON_HIERARCHY") and len(attributes.AMAZON_HIERARCHY)>'#attributes.AMAZON_HIERARCHY#'<cfelse>NULL</cfif>,
				AMAZON_PRODUCT_CAT = <cfif isdefined("attributes.AMAZON_PRODUCT_CAT") and len(attributes.AMAZON_PRODUCT_CAT)>'#attributes.AMAZON_PRODUCT_CAT#'<cfelse>NULL</cfif>,
				PTTAVM_HIERARCHY = <cfif isdefined("attributes.PTTAVM_HIERARCHY") and len(attributes.PTTAVM_HIERARCHY)>'#attributes.PTTAVM_HIERARCHY#'<cfelse>NULL</cfif>,
				PTTAVM_PRODUCT_CAT = <cfif isdefined("attributes.PTTAVM_PRODUCT_CAT") and len(attributes.PTTAVM_PRODUCT_CAT)>'#attributes.PTTAVM_PRODUCT_CAT#'<cfelse>NULL</cfif>,
                UPDATE_EMP = '#session.ep.userid#',
                UPDATE_DATE = #now()#
           WHERE 
               PRODUCT_CATID = <cfqueryparam cfsqltype="cf_sql_integer" list="yes" value="#attributes.product_catid#"> AND MARKETPLACE_PC_ID = <cfqueryparam cfsqltype="cf_sql_integer" list="yes" value="#attributes.marketplace_pc_id#">
        </cfquery>
<cfelse>
<cfquery name="ADD_MARKETPLACE_PRODUCT_CAT" datasource="#DSN#">
            INSERT INTO 
                MARKET_PLACE_PRODUCT_CAT 
				( 
					PRODUCT_CATID,
					GITTIGIDIYOR_HIERARCHY,
					GITTIGIDIYOR_PRODUCT_CAT,
					N11_HIERARCHY,
					N11_PRODUCT_CAT,
					HEPSIBURADA_HIERARCHY,
					HEPSIBURADA_PRODUCT_CAT,
					SAHIBINDEN_HIERARCHY,
					SAHIBINDEN_PRODUCT_CAT,
					AMAZON_HIERARCHY,
					AMAZON_PRODUCT_CAT,
					PTTAVM_HIERARCHY,
					PTTAVM_PRODUCT_CAT,
					RECORD_EMP,
					RECORD_DATE
				)
           VALUES 
               (<cfqueryparam cfsqltype="cf_sql_integer" list="yes" value="#attributes.product_catid#">,
			    <cfif isdefined("attributes.GITTIGIDIYOR_HIERARCHY") and len(attributes.GITTIGIDIYOR_HIERARCHY)>'#attributes.GITTIGIDIYOR_HIERARCHY#'<cfelse>NULL</cfif>,
			    <cfif isdefined("attributes.GITTIGIDIYOR_PRODUCT_CAT") and len(attributes.GITTIGIDIYOR_PRODUCT_CAT)>'#attributes.GITTIGIDIYOR_PRODUCT_CAT#'<cfelse>NULL</cfif>,
			    <cfif isdefined("attributes.N11_HIERARCHY") and len(attributes.N11_HIERARCHY)>'#attributes.N11_HIERARCHY#'<cfelse>NULL</cfif>,
			    <cfif isdefined("attributes.N11_PRODUCT_CAT") and len(attributes.N11_PRODUCT_CAT)>'#attributes.N11_PRODUCT_CAT#'<cfelse>NULL</cfif>,
			    <cfif isdefined("attributes.HEPSIBURADA_HIERARCHY") and len(attributes.HEPSIBURADA_HIERARCHY)>'#attributes.HEPSIBURADA_HIERARCHY#'<cfelse>NULL</cfif>,
			    <cfif isdefined("attributes.HEPSIBURADA_PRODUCT_CAT") and len(attributes.HEPSIBURADA_PRODUCT_CAT)>'#attributes.HEPSIBURADA_PRODUCT_CAT#'<cfelse>NULL</cfif>,
			    <cfif isdefined("attributes.SAHIBINDEN_HIERARCHY") and len(attributes.SAHIBINDEN_HIERARCHY)>'#attributes.SAHIBINDEN_HIERARCHY#'<cfelse>NULL</cfif>,
			    <cfif isdefined("attributes.SAHIBINDEN_PRODUCT_CAT") and len(attributes.SAHIBINDEN_PRODUCT_CAT)>'#attributes.SAHIBINDEN_PRODUCT_CAT#'<cfelse>NULL</cfif>,
			    <cfif isdefined("attributes.AMAZON_HIERARCHY") and len(attributes.AMAZON_HIERARCHY)>'#attributes.AMAZON_HIERARCHY#'<cfelse>NULL</cfif>,
			    <cfif isdefined("attributes.AMAZON_PRODUCT_CAT") and len(attributes.AMAZON_PRODUCT_CAT)>'#attributes.AMAZON_PRODUCT_CAT#'<cfelse>NULL</cfif>,
			    <cfif isdefined("attributes.PTTAVM_HIERARCHY") and len(attributes.PTTAVM_HIERARCHY)>'#attributes.PTTAVM_HIERARCHY#'<cfelse>NULL</cfif>,
			    <cfif isdefined("attributes.PTTAVM_PRODUCT_CAT") and len(attributes.PTTAVM_PRODUCT_CAT)>'#attributes.PTTAVM_PRODUCT_CAT#'<cfelse>NULL</cfif>,
				'#session.ep.userid#',
				#now()#
			   )
        </cfquery>
</cfif>

<script type="text/javascript">
	wrk_opener_reload();
	window.close();
</script>