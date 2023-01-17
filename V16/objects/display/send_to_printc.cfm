<!--- 
Description :
   prints html contents

Parameters :
	module       ==> Module directory path name for page
	file         ==> file name of the page

syntax1 : #request.self#?fuseaction=objects.popup_send_to_printc&module=<module name>&file=<file name>#page_code#
sample1 : #request.self#?fuseaction=objects.popup_send_to_printc&module=finance/ch&file=list_emps_extre#page_code#

Note1 : For sub modules , we should  arrange 'module' that syntax : <parent file structure>/<child file structure>

Note2 : Settle '<!-- sil -->' statement into the start and the end point of unnecessary part of the page

Note3 : '#page_code#' statement is important at the end
 --->

<cfif isDefined("attributes.style")>

	<cfsavecontent variable="cont">
		<cfmodule template="../../index.cfm" fuseaction="#attributes.module#.#attributes.file#" module_id="48">
	</cfsavecontent>
	<cfset cont = "<!-- sil -->" & cont & "<!-- sil -->">
	
	<cfset start = find('<!-- sil -->',cont,1)>
	<cfset middle = find('<!-- sil -->',cont,start + 12)>
	<cfloop condition="(start GT 0) and (middle GT 0)">
		  
	  <cfset cont = removechars(cont,start,middle-start+12)>	
	  <cfset start = find('<!-- sil -->',cont,1)>
	  <cfset middle = find('<!-- sil -->',cont,start + 12)>
	
	</cfloop>
	
	<cfset start = find('<!-- siil -->',cont,1)>
	<cfset middle = find('<!-- siil -->',cont,start + 13)>
	<cfloop condition="(start GT 0) and (middle GT 0)">
		  
	  <cfset cont = removechars(cont,start,middle-start+13)>	
	  <cfset start = find('<!-- siil -->',cont,1)>
	  <cfset middle = find('<!-- siil -->',cont,start + 13)>
	
	</cfloop>	
	
	<cfoutput>#cont#</cfoutput>
 <script type="text/javascript">
		function waitfor(){
		<cfif isDefined("attributes.is_pop") and (attributes.is_pop EQ 1)>
		  window.opener.close();
		</cfif>	
		  window.close();
		}
	
		setTimeout("waitfor()",3000);  
		
		window.print();	
	</script> 
	<cfelse>
	<cfsavecontent variable="cont">
		<cfmodule template="../../index.cfm" fuseaction="#attributes.module#.#attributes.faction#" popup_for_files='1'>
	</cfsavecontent>
	<cfset cont = "<!-- sil -->" & cont & "<!-- sil -->">	
	
	<cfset start = find('<!-- sil -->',cont,1)>
	<cfset middle = find('<!-- sil -->',cont,start + 12)>
	<cfloop condition="(start GT 0) and (middle GT 0)">
		  
	  <cfset cont = removechars(cont,start,middle-start+12)>	
	  <cfset start = find('<!-- sil -->',cont,1)>
	  <cfset middle = find('<!-- sil -->',cont,start + 12)>
	
	</cfloop>
	
	<cfset start = find('<!-- siil -->',cont,1)>
	<cfset middle = find('<!-- siil -->',cont,start + 13)>
	<cfloop condition="(start GT 0) and (middle GT 0)">
		  
	  <cfset cont = removechars(cont,start,middle-start+13)>	
	  <cfset start = find('<!-- siil -->',cont,1)>
	  <cfset middle = find('<!-- siil -->',cont,start + 13)>
	
	</cfloop>
	
	
	<cfif attributes.trail>
	<cfsavecontent variable="logo">
	     	<cfinclude template="view_company_logo.cfm">
	</cfsavecontent>
	
	<cfsavecontent variable="address">
	     	<cfinclude template="view_company_info.cfm">
	</cfsavecontent>	
	</cfif>
	
	<cfoutput>
	    <cfif attributes.trail>
		#logo#<br/>
		#cont#<br/>
		#address#
		<cfelse>
		#cont#
		</cfif>
	</cfoutput>	

 <script type="text/javascript">
		function waitfor(){
		<cfif isDefined("attributes.is_pop") and (attributes.is_pop EQ 1)>
		  window.opener.close();
		</cfif>	
		  window.close();
		}
	
		setTimeout("waitfor()",3000); 		
		
		window.print();	
	</script>   
</cfif>
