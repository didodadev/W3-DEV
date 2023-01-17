<cfset degerim_ = thisTag.GeneratedContent>
<cfparam name="attributes.case_value" default="">
<cfset thisTag.GeneratedContent =''>
<cfif thisTag.executionMode neq "start">
	<cfset ilk_ = listlen(degerim_,'##')-1>
	<cfset a = degerim_>
	<cfset replace_deger_list_ = ''>
	<cfloop from="1" to="#ilk_#" index="ccm">
		<cfif ccm mod 2 eq 1>
			<cfset eleman_ = listgetat(degerim_,ccm+1,'##')>
			<cfset replace_deger_list_ = listappend(replace_deger_list_,'#eleman_#','█')>
		</cfif>
	</cfloop>
	<cfif listlen(replace_deger_list_,'█')>
		<cfloop list="#replace_deger_list_#" index="mmk" delimiters="█">
			<cfif mmk contains 'session.'>
				<cfset new_deger_ = "#mmk#">
			<cfelse>
				<cfset new_deger_ = "caller.#mmk#">
			</cfif>
			<cfset ccc = evaluate(new_deger_)>
			<cfset ccc = replace(ccc,"'","''","all")>
			<cfset degerim_ = replace(degerim_,mmk,ccc,'all')>
		</cfloop>
	</cfif>
	<cfset degerim_ = replace(degerim_,'##','','all')>
	<cfset degerim_ = replace(degerim_,'SELECT','','one')>
	<cfset degerim_ilk_ = degerim_>

	<cfset degerim_ = replace(degerim_,'_FROM_','_§_','all')>
	<cfset degerim_ = replace(degerim_,'_FROM','_§','all')>
	<cfset degerim_ = replace(degerim_,'FROM_','§_','all')>
	<cfset select_ = left(degerim_,find('FROM',degerim_)-1)>
	<cfset select_ = replace(select_,'_§_','_FROM_','all')>
	<cfset select_ = replace(select_,'_§','_FROM','all')>
	<cfset select_ = replace(select_,'§_','FROM_','all')>
	
	<cfset from_ = replace(degerim_ilk_,select_,'','one')>
	<cfset from_ = replace(from_,'FROM','','one')>
	<cfset from_ = replace(from_,'_WHERE_','_§_','all')>
	<cfset from_ = replace(from_,'_WHERE','_§','all')>
	<cfset from_ = replace(from_,'WHERE_','§_','all')>
	<cfset from_ = left(from_,find('WHERE',from_)-1)>

	<cfset degerim_ilk_ = replace(degerim_ilk_,"{ts ''","{ts '","all")>
	<cfset degerim_ilk_ = replace(degerim_ilk_,"''}","'}","all")>
	<cfset where_ = replace(degerim_ilk_,select_,'','one')>
	<cfset where_ = replace(where_,from_,'','one')>
	<cfset where_ = replace(where_,'FROM','','one')>
	<cfset where_ = replace(where_,'WHERE','','one')>
	<cfset where_ = left(where_,find('ORDER BY',where_)-1)>
	
	<cfset order_by_ = replace(degerim_ilk_,select_,'','one')>
	<cfset order_by_ = replace(order_by_,from_,'','one')>
	<cfset order_by_ = replace(order_by_,'FROM','','one')>
	<cfset order_by_ = replace(order_by_,where_,'','one')>
	<cfset order_by_ = replace(order_by_,'WHERE','','one')>
	<cfset order_by_ = replace(order_by_,'ORDER BY','','one')>
	
	<cfstoredproc procedure="WRK_PAGE_ROWS" datasource="#attributes.datasource#">
		<cfprocparam TYPE="IN" cfsqltype="cf_sql_text" value="#trim(select_)#">
		<cfprocparam TYPE="IN" cfsqltype="cf_sql_text" value="#trim(from_)#">
		<cfprocparam TYPE="IN" cfsqltype="cf_sql_text" value="#trim(where_)#">
		<cfprocparam TYPE="IN" cfsqltype="cf_sql_text" value="#trim(order_by_)#">
		<cfprocparam TYPE="IN" cfsqltype="cf_sql_integer" value="#caller.attributes.page#">
		<cfprocparam TYPE="IN" cfsqltype="cf_sql_integer" value="#caller.attributes.maxrows#">
		<cfprocresult name="#attributes.name#" resultset="1">
	</cfstoredproc>
	<cfset 'caller.#attributes.name#' = evaluate("#attributes.name#")>
	
	<cfstoredproc procedure="WRK_PAGE_TOTAL" datasource="#attributes.datasource#">
		<cfprocparam TYPE="IN" cfsqltype="cf_sql_text" value="#attributes.case_value#">
		<cfprocparam TYPE="IN" cfsqltype="cf_sql_text" value="#trim(from_)#">
		<cfprocparam TYPE="IN" cfsqltype="cf_sql_text" value="#trim(where_)#">
		<cfprocresult name="RECORDCOUNT" resultset="1">
	</cfstoredproc>
	<cfset caller.recordcount.recct = RECORDCOUNT.recct>
<cfelse>
</cfif>
