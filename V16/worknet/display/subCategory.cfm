<cfsetting showdebugoutput="no">
<cfscript>
	if (isDefined('session.ep.userid') and len(session.ep.language)) lang=ucase(session.ep.language);
	else if (isDefined('session.ww.language') and len(session.ww.language)) lang=ucase(session.ww.language);
	else if (isDefined('session.pp.userid') and len(session.pp.language)) lang=ucase(session.pp.language);
	else if (isDefined('session.pda.userid') and len(session.pda.language)) lang=ucase(session.pda.language);
	else if (isDefined('session.wp') and len(session.wp.language)) lang=ucase(session.wp.language);
</cfscript>
<cfquery name="get_main_category" datasource="#dsn1#">
    SELECT HIERARCHY FROM PRODUCT_CAT WHERE PRODUCT_CATID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.mainCategoryId#">
</cfquery>
<cfquery name="get_sub_category" datasource="#dsn1#">
    SELECT 
		#dsn_alias#.Get_Dynamic_Language(PC.PRODUCT_CATID,'#lang#','PRODUCT_CAT','PRODUCT_CAT',NULL,NULL,PRODUCT_CAT) AS PRODUCT_CAT,
        PC.PRODUCT_CATID,
        PC.HIERARCHY,
        PC.LIST_ORDER_NO
    FROM 
        PRODUCT_CAT PC,
        PRODUCT_CAT_OUR_COMPANY PCO
    WHERE 
        PC.HIERARCHY LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="#get_main_category.HIERARCHY#.%"> AND
        PCO.PRODUCT_CATID = PC.PRODUCT_CATID AND
        <cfif isdefined('session.ep')>
			PCO.OUR_COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.company_id#"> AND
		<cfelseif isdefined('session.pp')>
			PCO.OUR_COMPANY_ID =<cfqueryparam cfsqltype="cf_sql_integer" value="#session.pp.our_company_id#"> AND
		<cfelseif isdefined('session.wp')>
			PCO.OUR_COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.wp.our_company_id#"> AND
		</cfif>
        PC.HIERARCHY LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%.%">
    ORDER BY 
        PC.LIST_ORDER_NO,PC.HIERARCHY
</cfquery>

<cfif isdefined('attributes.type') and attributes.type eq 1>
    <select name="subCategory2" id="subCategory2" style="width:300px;height:100px;" size="5">
       <cfoutput query="get_sub_category">
            <option value="#product_catid#">#product_cat#</option>
       </cfoutput>
    </select>
<cfelse>
    <select name="subCategory" id="subCategory" style="width:300px;height:100px;" size="5">
       <cfoutput query="get_sub_category">
            <option value="#product_catid#">#product_cat#</option>
       </cfoutput>
    </select>
</cfif>
<cfabort>
