<cfif session.resim eq 3>
  <cfset  session.imTempPath = "#upload_folder##createuuid()##dir_seperator#">
  <cfdirectory action="CREATE" directory="#session.imTempPath#">
  <cfset path = "#upload_folder#content#dir_seperator##session.imFile#">
  <cfif ( findnocase("gif","#path#",1) neq 0) and (session.resim eq 3)>
    <cfx_WorkcubeImage NAME="image"
			                   ACTION="rotate"
			                   SRC="#path#"
							   DST="#path#"
							   PARAMETERS="0">
    <cfset  session.imFile = listgetat(session.imFile,1,".")&"."&"jpg">
  </cfif>
  <cftry>
    <cffile action="COPY" 
		            source="#upload_folder#/content/#session.imFile#" 
				    destination="#session.imTempPath#">
    <cfcatch type="Any">
      <script type="text/javascript">
				alert("<cf_get_lang_main no ='43.Dosyanız Upload Edilemedi ! Dosyanizi Kontrol Ediniz'>!");
				history.back();
			</script>
    </cfcatch>
  </cftry>
  <script type="text/javascript">
		   window.moveTo(100,100);
		   window.resizeBy(400,200);
		</script>
  <cfif not isDefined("url.cntid")>
    <cfset boy=#form.boy#>
    <cfset genis=#form.genis#>
    <cfif form.boy eq "">
      <cfset boy="0">
    </cfif>
    <cfif form.genis eq "">
      <cfset genis="0">
    </cfif>
    <cfset session.info="#session.imFile#,#boy#,#genis#">
  </cfif>
</cfif>
<cfinclude template="../../objects/display/imageprocess/improcess.cfm">
<cfset session.resim=1>

