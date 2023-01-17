<cfset copy_folder = "#upload_folder##form.hr#">

<cfset  session.imTempPath = "#upload_folder##createuuid()##dir_seperator#">
<cfdirectory action="CREATE" directory="#session.imTempPath#">
<cftry>
	<cffile action = "copy" 
	  source="#copy_folder#"
	  destination = "#session.imTempPath#"> 
	<cfcatch type="Any">
		<script type="text/javascript">
			alert("<cf_get_lang no ='1747.Dosyanızı Kontrol Ediniz'> !");
			history.back();
		</script>
	</cfcatch>  
</cftry>
<cfset session.resim = 2>
