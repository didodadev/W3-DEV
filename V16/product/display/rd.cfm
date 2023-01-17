<cfif session.resim eq 4>
	<cfset session.imTempPath = "#upload_folder##createuuid()##dir_seperator#">
	<cfdirectory action="CREATE" directory="#session.imTempPath#">		   
	<cfset path = "#session.imPath##session.imFile#">		
	<cfif (findnocase("gif","#path#",1) neq 0)>
		<cfx_WorkcubeImage
			NAME="image"
			ACTION="rotate"
			SRC="#path#"
			DST="#path#"
			PARAMETERS="0">		   							   
		<cffile action="DELETE" file="#path#">						   
		<cfset  session.imFile = listgetat(session.imFile,1,".")&"."&"jpg">   	
	</cfif>

	<cftry>
		<cffile action="COPY" source="#session.imPath##session.imFile#" destination="#session.imTempPath#">	         				
	<cfcatch type="Any">
		<script type="text/javascript">
			alert("<cf_get_lang dictionary_id='33838.Dosyanız kopyalanamadı Dosyanızı kontrol ediniz'>!");
			history.back();
		</script>
	</cfcatch>
	</cftry>

	<script type="text/javascript">
	   window.moveTo(100,100);
	   window.resizeBy(400,200);
	</script>
</cfif>	

<cfinclude template="../../objects/display/imageprocess/improcess.cfm">   
<cfset session.resim=1>
