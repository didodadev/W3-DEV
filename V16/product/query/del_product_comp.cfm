<cfif isDefined("url.position_code")>
  <cfloop from="1" to="#arraylen(session.product.emps)#" index="i">
     <cfif (url.position_code eq session.product.emps[i])>
	   <cfset ArrayDeleteAt(session.product.emps,i)>
		 <cfbreak>
	 </cfif>
  </cfloop>

<!--- <cfset session.product.emps=listdeleteat(session.product.emps,listfind(session.product.emps,url.position_code))>--->
<cfelseif isDefined("URL.PARTNER_ID")>
 <!--- <cfset session.product.pars=listdeleteat(session.product.pars,listfind(session.product.pars,URL.PARTNER_ID))>--->
  <cfloop from="1" to="#arraylen(session.product.pars)#" index="i">
     <cfif (URL.PARTNER_ID eq session.product.pars[i])>
	   <cfset ArrayDeleteAt(session.product.pars,i)>
 		 <cfbreak>
	 </cfif>
  </cfloop>
</cfif>
<script type="text/javascript">
	opener.location=opener.location+'&session_delete=';
	window.close();
</script>
