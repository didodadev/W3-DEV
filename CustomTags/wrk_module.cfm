<cfparam name="attributes.ekler" default="">
<cfset attrCollection = StructNew()>
<cfset attrCollection.inner_page = 1>
<cfif listlen(attributes.ekler)>
	<cfloop list="#attributes.ekler#" index="mmm">
		<cfset ilk = listfirst(mmm,'=')>
		<cfset son = listlast(mmm,'=')>
		<cfset 'attrCollection.#ilk#' = son>
	</cfloop>
</cfif>
<cfmodule template="/index.cfm" attributecollection="#attrCollection#">
