<cfif isdefined("attributes.product_id") or isdefined("attributes.stock_id")>
	<cfquery name="GET_P1" datasource="#DSN3#">
        SELECT 
            PRODUCT_CATID,
            BRAND_ID
        FROM 
            STOCKS
        WHERE 
            <cfif isdefined("attributes.product_id")>
                PRODUCT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.product_id#">
            <cfelse>
                STOCK_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.stock_id#">
            </cfif>
	</cfquery>
	<cfset attributes.product_catid = get_p1.product_catid>
	<cfif len(get_p1.brand_id)>
		<cfset attributes.brand_id = get_p1.brand_id>
	</cfif>
</cfif>

<cfif isdefined("attributes.product_catid") and len(attributes.product_catid)>
	<cfquery name="GET_P" datasource="#dsn1#">
		SELECT 
			PRODUCT_CAT,
			PRODUCT_CATID,
			HIERARCHY
		FROM 
			PRODUCT_CAT
		WHERE 
			PRODUCT_CATID = <cfqueryparam value="#attributes.product_catid#" cfsqltype="cf_sql_integer">
	</cfquery>
</cfif>

<cfif isdefined("attributes.hierarchy") and len(attributes.hierarchy) and not isdefined("attributes.product_catid")>
	<cfquery name="GET_P" datasource="#DSN1#">
		SELECT 
			PRODUCT_CAT,
			PRODUCT_CATID,
			HIERARCHY
		FROM
			PRODUCT_CAT
		WHERE
			HIERARCHY = <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.hierarchy#">
	</cfquery>
</cfif>

<cfif isdefined("attributes.brand_id") and len(attributes.brand_id)>
	<cfquery name="GET_B" datasource="#DSN1#">
		SELECT 
			BRAND_NAME,
			BRAND_ID
		FROM 
			PRODUCT_BRANDS
		WHERE 
			BRAND_ID = <cfqueryparam value="#attributes.brand_id#" cfsqltype="cf_sql_integer">
	</cfquery>
</cfif>

<table align="center" cellpadding="0" cellspacing="0" style="width:100%;">
	<tr>
        <td>
            <h2 class="h_kategori">
            <cfoutput>
                <cfif isdefined("attributes.brand_id") and len(attributes.brand_id)><a href="#request.self#?fuseaction=objects2.view_product_list&brand_id=#get_b.brand_id#">#get_b.brand_name#</a> > </cfif>
                <cfif (isdefined("attributes.product_catid") and len(attributes.product_catid)) or (isdefined("attributes.hierarchy") and len(attributes.hierarchy))>
                    <cfif listlen(get_p.hierarchy,'.') gt 1>
                        <cfset ek_ = "">
                        <cfset ic_ = "">
                        <cfloop list="#get_p.hierarchy#" delimiters="." index="ccp">
                            <cfquery name="GET_P1" datasource="#DSN1#">
                                SELECT 
                                    PRODUCT_CAT,
                                    PRODUCT_CATID,
                                    HIERARCHY
                                FROM 
                                    PRODUCT_CAT
                                WHERE 
                                    HIERARCHY = '<cfif len(ek_)>#ek_#.</cfif>#ccp#'
                            </cfquery>
                            <cfif len(ek_)>
                                <cfset ek_ = ek_ & "." & "#ccp#">
                            <cfelse>
                                <cfset ek_ = "#ccp#">
                            </cfif>
                            <cfif len(ic_)>
                                <cfset ic_ = '#ic_# > <a href="#request.self#?fuseaction=objects2.view_product_list&product_catid=#get_p1.product_catid#&hierarchy=#get_p1.hierarchy#">#get_p1.product_cat#</a>'>
                            <cfelse>
                                <cfset ic_ = '<a href="#request.self#?fuseaction=objects2.view_product_list&product_catid=#get_p1.product_catid#&hierarchy=#get_p1.hierarchy#">#get_p1.product_cat#</a>'>
                            </cfif>
                        </cfloop>
                        #ic_#
                    <cfelse>
                        <a href="#request.self#?fuseaction=objects2.view_product_list&product_catid=#get_p.product_catid#&hierarchy=#get_p.hierarchy#">#get_p.PRODUCT_CAT#</a> > 
                    </cfif>
                </cfif> 
            </cfoutput>
            </h2>
    	</td>
	</tr>
</table>
