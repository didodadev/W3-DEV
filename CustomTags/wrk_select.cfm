<!--- 
Amaç:Bir tablodan kayıt çeken ve olduğu gibi listeleyen select box kullanılan yerlerde ki kod kirliliğinin önüne geçmek ve daha hızlı kodlama yapmak.
M.ER 20 01 2008
 --->
<cfparam name="attributes.table_name" default="">
<cfparam name="attributes.name" default="">
<cfparam name="attributes.width" default="180">
<cfparam name="attributes.value" default="">
<cfparam name="attributes.field" default="">
<cfparam name="attributes.is_multiple" default="0">
<cfparam name="attributes.option_text" default="#caller.getLang('main',322)#">
<cfparam name="attributes.datasource" default="#caller.dsn#">
<cfquery name="GET_QUERY" datasource="#attributes.datasource#">
    SELECT  
      CASE
        WHEN LEN(SLI.ITEM) > 0 THEN SLI.ITEM
        ELSE #attributes.field#
    END AS #attributes.field#,
    #attributes.value# 
    FROM 
    #attributes.table_name# 
    LEFT JOIN #caller.dsn_alias#.SETUP_LANGUAGE_INFO SLI ON SLI.UNIQUE_COLUMN_ID = #attributes.table_name#.#attributes.value# 
        AND SLI.COLUMN_NAME = <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.field#">
        AND SLI.TABLE_NAME = <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.table_name#">
        AND SLI.LANGUAGE = <cfqueryparam cfsqltype="cf_sql_varchar" value="#session.ep.language#">
    ORDER BY #attributes.field#
</cfquery>
<select name="<cfoutput>#attributes.name#" style="width:#attributes.width#px" id="#attributes.name#"</cfoutput> <cfif attributes.is_multiple eq 1>multiple</cfif>>
    <option value=""><cfoutput>#attributes.option_text#</cfoutput></option><!--- Seçiniz ---> 
	<cfoutput query="GET_QUERY">
        <option value="#Evaluate('#attributes.value#')#" <cfif isdefined("caller.attributes.#attributes.name#") and Evaluate("caller.attributes.#attributes.name#") eq Evaluate('#attributes.value#')>selected</cfif>>#Evaluate('#attributes.field#')#</option>
    </cfoutput>
</select>

