<!---
    File :          AddOns\Yazilimsa\Protein\view\sites\site.cfm
    Author :        Semih Akartuna <semihakartuna@yazilimsa.com>
    Date :          28.08.2020
    Description :   Protein site detay sayfasıdır.
    Notes :         
--->
<cfif isdefined('attributes.site') and len(attributes.site)>
    <cfquery name="thısDomaın" datasource="#dsn#">
        SELECT DOMAIN FROM PROTEIN_SITES WHERE SITE_ID= <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.site#"> 
    </cfquery>
    <cfset pageHead = "Site : #thısDomaın.DOMAIN#">
</cfif>
<cf_catalystHeader>
<div class="row">
    <div class="col col-9 col-md-12 col-sm-12 pl-0">
        <cfinclude  template="definitions.cfm">
        <cfif attributes.event eq "upd">
            <cfinclude  template="pages.cfm">
        </cfif>
    </div>
    <div class="col col-3 col-md-12 col-sm-12 pl-0">
        <cfif attributes.event eq "upd">
            <cfinclude  template="menus.cfm">
            <cfinclude  template="templates.cfm">
        </cfif>
    </div>
</div>