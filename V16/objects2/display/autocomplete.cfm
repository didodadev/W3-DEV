<cfsetting showdebugoutput="no">
<cfparam name="URL.mask" default="">
<cfparam name="URL.query" default="">
<cfparam name="URL.extra_params" default="">
<cfset mask1 = #URLDecode(URL.mask,"utf-8")#>
<cfset mask2 = #Replace(mask1,"'","\'")#>

<cfinclude template="/workdata/#URL.query#.cfm">
<table width="100%" align="center" border="0" cellpadding="0" cellspacing="0" style="border-bottom:solid 1px silver">
	<tr class="color-list" height="20">
		<td width="98%"><cfoutput><b>#mask1#</b> kelimesi ile ilgili sonuçlar...</cfoutput></td>
		<td width="2%" align="left">
		<img src="/images/pod_close.gif" border="0" 
			onClick="document.getElementById('<cfoutput>#URL.divName#</cfoutput>').style.display='none';" 
			onmouseover="this.style.cursor='hand'">
		</td>
	</tr>
</table>
<cfset get_js_query = evaluate("#url.query#('#mask1#',#URLDecode(url.extra_params)#)")>
<cfset i=0>
<cfoutput query="get_js_query">
	<div align="left" <cfif i mod 2>class="odd"</cfif>>
		<input type="hidden" value="<cfloop list="#URL.column_visible#" index="txt">#evaluate('get_js_query.#txt#')#<cfbreak></cfloop>" />
		<cfloop list="#URL.column_value#" index="txt" >
			<input type="hidden" value="#evaluate('get_js_query.#txt#')#" />			
		</cfloop>
		<a href="javascript://" onmousedown="setAtt('#URL.AutocompleteId#',#i#,false)" tabindex="-1">
			<cfset str="">
			<cfloop list="#URL.column_visible#" index="txt">
				<cfset str = str & "#evaluate('get_js_query.#txt#')# || ">
			</cfloop>
			#left(str,len(str)-3)#
		</a>
	</div>
			
	<cfset i = i + 1>
</cfoutput>
<cfif i eq 0>	
		Kayıt bulunamadı...
</cfif>

<cfif i neq 0>
	<script type="text/javascript">
		<cfoutput>
			setAtt('#URL.AutocompleteId#',0,true);
		</cfoutput>
	</script>
</cfif>

