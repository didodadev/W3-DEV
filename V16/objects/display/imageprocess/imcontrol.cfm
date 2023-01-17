<!--- Erase unwanted images --->
<!---  26.06.2019 query DEL_OLD cfc ye taşındı.  --->
<cfset cfc= createObject("component","V16.content.cfc.get_content")>
<cfif isDefined("url.eskiSil")>
	<cfset path = "#session.imTempPath##session.imFile#">
  	<cfif FileExists("#path#")>
	<cfx_WorkcubeImage NAME="image"
	                   ACTION="r"
	                   SRC="#upload_folder#temp#dir_seperator#temp1.jpg"
					   DST="#upload_folder#temp#dir_seperator#temp1.jpg"
					   PARAMETERS="0"> 					    					   
	<cfx_WorkcubeImage NAME="image"
	                   ACTION="r"
	                   SRC="#upload_folder#temp#dir_seperator#temp2.jpg"
					   DST="#upload_folder#temp#dir_seperator#temp2.jpg"
					   PARAMETERS="0">
	<cftry>				   					   
	<cffile action="DELETE" file="#path#">			     
		<cfcatch type="Any">
			<script type="text/javascript">
				window.location.reload();			 
			</script>
		</cfcatch>
	</cftry>
	<cftry>				   					   
		<cfdirectory action="DELETE" directory="#session.imTempPath#">
	<cfcatch type="Any">
		<script type="text/javascript">
		window.location.reload();			 
		</script>
	</cfcatch>
	</cftry>	
	<cfif session.module eq "asset">
        <cfset DEL_OLD =cfc.DELOLD()> 
		<cfif FileExists("#session.imPath##session.imFile#")>		
			<cffile action="DELETE" file="#session.imPath##session.imFile#">	
		</cfif>   
	<cfelseif session.module eq "content">
	    <cfif not isDefined("url.cntid")>
		    <cfoutput>
			<script type="text/javascript">
				parent.opener.html_edit.textEdit.document.body.innerHTML += '<img src="content/#session.imFile#" <cfif (listgetat(session.info,3,",") is not "") and (listgetat(session.info,3,",") neq 0)>width="#listgetat(session.info,3,",")#"</cfif> <cfif (listgetat(session.info,2,",") is not "") and (listgetat(session.info,2,",") neq 0)>height="#listgetat(session.info,2,",")#"</cfif> border="0"><br/>';
				alert(opener.html_edit.textEdit.document.body.innerHTML);
				parent.opener.html_edit.textEdit.focus();				
				parent.close();
			</script>
			</cfoutput>
			<cfabort>	
		<cfelse>
			<script type="text/javascript">
			  parent.wrk_opener_reload();
			  parent.close();
			</script>
			<cfabort>			
        </cfif>
	<cfelseif session.module eq "product">
		  <script type="text/javascript">		  
             wrk_opener_reload();		  
		     window.close();
		  </script>
		  <cfabort>
	<cfelseif (session.module eq "sales") or (session.module eq "salespur")>
	      <cfoutput>	  		  
		  <script type="text/javascript">
			parent.opener.html_edit.textEdit.document.body.innerHTML += '<img src="#session.module#/#session.imFile#" <cfif (listgetat(session.info,3,",") is not "") and (listgetat(session.info,3,",") neq 0)>width="#listgetat(session.info,3,",")#"</cfif> <cfif (listgetat(session.info,2,",") is not "") and (listgetat(session.info,2,",") neq 0)>height="#listgetat(session.info,2,",")#"</cfif> border="0"><br/>';
			parent.opener.html_edit.textEdit.focus();
			parent.close();
		  </script>
		  </cfoutput>
		  <cfabort>		  		  		  		
	<cfelseif attributes.fuseaction contains 'popup'>
		<script type="text/javascript">
			parent.close();
		</script>
		<cfabort>				   			
	</cfif>		
  </cfif>
</cfif>
<cfif isDefined("session.pid")>
	<cfscript>
	   structdelete(session,"pid");
	</cfscript>	      		  
<cfelseif isDefined("session.cid")>
	<cfscript>
	   structdelete(session,"cid");
	</cfscript>	      		  
</cfif>
<cfif isDefined("session.employee_id")>
	<cfscript>
	   structdelete(session,"employee_id");
	</cfscript>
</cfif>
