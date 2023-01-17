<cfset dsn_alias = dsn>
<cfset dsn1 = dsn1_alias = "#dsn#_product">

<cfif isDefined("session.wp.userid")>
        
    <cfset session_base = session.wp />

    <cfset dsn2 = dsn2_alias = '#dsn#_#session_base.period_year#_#session_base.company_id#' />
    <cfset dsn3 = dsn3_alias = '#dsn#_#session_base.company_id#' />
    
    <cfif isdefined("session_base.dateformat_style") and len(session_base.dateformat_style)>
        <cfset dateformat_style = session_base.dateformat_style />
        <cfset timeformat_style = session_base.timeformat_style />
        <cfset validate_style = dateformat_style is 'dd/mm/yyyy' ? 'eurodate' : 'date' />
    <cfelse>
        <cfset dateformat_style = 'dd/mm/yyyy' />
        <cfset timeformat_style = 'HH:MM' />
        <cfset validate_style = 'eurodate' />
    </cfif>

    <cfif isdefined("session_base.moneyformat_style") and len(session_base.moneyformat_style)>
        <cfset moneyformat_style = session_base.moneyformat_style>
    <cfelse>
        <cfset moneyformat_style = 0> 
    </cfif>

<cfelse>

    <cfset session.wp.language = 'tr' />

</cfif>

<cfset http_status = cgi.HTTPS eq 'on' ? "https://" : "http://" />
<cfset http_host = cgi.HTTP_HOST />
<cfset http_site = http_status & cgi.HTTP_HOST />
<cfset request.self = 'index.cfm' />
<cfset fusebox.is_special = 0 />
<cfset attributes = StructNew() />
<cfset StructAppend(attributes,form,true) />
<cfset StructAppend(attributes,url,true) />

<cfparam name="attributes.wo" default="#attributes.fuseaction?:''#" />
<cfparam name="attributes.event" default="" />
<cfparam name="attributes.fuseaction" default="#attributes.wo#" />
<cfparam name="attributes.tabMenuController" default="0" />

<cf_get_lang_set>
<cf_get_lang_set_main>
<cfset lang_array_main = variables.lang_array_main>