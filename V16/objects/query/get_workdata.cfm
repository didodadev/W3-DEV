<cfsetting showdebugoutput="no">
<cfif not len(cgi.referer)><!--- 20060315 guvenlik problemi olmasin diye --->
	var get_js_query=new Object();
	get_js_query.recordcount = 0;
	<cfexit method="exittemplate">
</cfif>
<!--- 		<cfif isDefined('attributes.qry') and isDefined('attributes.prmt')>
		<cfinclude template="../../workdata/#attributes.qry#.cfm">
		<cfset form_params="">
		<cfset get_js_query = evaluate("#attributes.qry#('#attributes.prmt#','#attributes.maxrows#'#form_params#)")>
		<cfif not isdefined('get_js_query.recordcount')>
			<cfset get_js_query.recordcount = 0>
		</cfif>
	<cfelse>
		<cfset get_js_query.recordcount = 0>
	</cfif>
		
		var get_js_query=new Object();
		get_js_query.recordcount=<cfoutput>#get_js_query.recordcount#</cfoutput>;
		<cfif get_js_query.recordcount>
			get_js_query.columnList='<cfoutput>#get_js_query.columnList#</cfoutput>';
			<cfloop list="#get_js_query.columnList#" index="i">
				get_js_query.<cfoutput>#i#</cfoutput>=new Array(1);
				<cfoutput query="get_js_query">
					get_js_query.#i#[#get_js_query.currentrow-1#] = "#evaluate('get_js_query.#i#[#get_js_query.currentrow#]')#";
				</cfoutput>
			</cfloop>
		</cfif> --->
<cfif isDefined('form.qry') and isDefined('form.prmt')>
	<cfinclude template="../../workdata/#form.qry#.cfm">
	<cfset form_params=""><!--- parametreler sınırsız olabilmesi için dongu eklendi --->
	<cfloop list="#form.FIELDNAMES#" delimiters="," index="form_element">
		<cfif FindNoCase('EXTRA',form_element)>
			<cfset form_elemet_value=evaluate('form.#form_element#')>
			<cfif left(form_elemet_value,1) eq "'" or left(form_elemet_value,1) eq '"' or IsNumeric(form_elemet_value)>
				<cfset form_params=form_params&",#form_elemet_value#">
			<cfelse>
				<cfset form_params=form_params&",'#form_elemet_value#'">
			</cfif>
		</cfif>
	</cfloop>
		<cfset get_js_query = evaluate("#form.qry#('#form.prmt#','#form.maxrows#'#form_params#)")>
		<cfif not isdefined('get_js_query.recordcount')>
			<cfset get_js_query.recordcount = 0>
		</cfif>
<cfelse>
	<cfset get_js_query.recordcount = 0>
</cfif>
		var get_js_query=new Object();
		get_js_query.recordcount=<cfoutput>#get_js_query.recordcount#</cfoutput>;
	<cfif get_js_query.recordcount>
		get_js_query.columnList='<cfoutput>#get_js_query.columnList#</cfoutput>';
		<cfloop list="#get_js_query.columnList#" index="i">
			get_js_query.<cfoutput>#i#</cfoutput>=new Array(1);
			<cfoutput query="get_js_query">
				get_js_query.#i#[#get_js_query.currentrow-1#] = "#evaluate('get_js_query.#i#[#get_js_query.currentrow#]')#";
			</cfoutput>
		</cfloop>
	</cfif>
