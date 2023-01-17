<!--- kopyalanacak belge --->
<cfif isDefined("form.member")>
   <cfset copy_folder = "#ExpandPath(form.member)#">
<cfelseif isDefined("form.consumer")>
   <cfset copy_folder = "#ExpandPath(form.consumer)#">
</cfif>
<!--- belge copy edilir --->
<cfset  session.imTempPath = "#upload_folder##createuuid()##dir_seperator#">
<cfdirectory action="CREATE" directory="#session.imTempPath#">
<cftry>
	<cffile action = "copy" 
	  		source="#copy_folder#"
	  		destination = "#session.imTempPath#">  
	<cfcatch type="Any">
		<script type="text/javascript">
			alert("<cf_get_lang_main no='43.Dosyanız Upload Edilmemdi ! Lütfen Dosyanızı kontrol Ediniz !'>");
			history.back();
		</script>
	</cfcatch>  
</cftry>
<cfset session.resim = 2>
