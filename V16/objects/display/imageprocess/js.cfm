<cfoutput>
<script type="text/javascript">
<cfswitch expression = "#session.module#">
     <cfcase value="asset">		
	     <cfif isDefined("session.port")>
             parent.location.href="#request.self#?fuseaction=#session.module#.list_asset"; 		    
		 <cfelse>
             parent.location.href="#request.self#?fuseaction=#session.module#.list_asset"; 
		 </cfif>
	 </cfcase>
     <cfcase value="hr">
	     <cfif not isDefined("session.employee_id")>
		 	parent.opener.html_edit.textEdit.document.body.innerHTML += '<img src="hr/#session.imFile#" <cfif len(listgetat(session.info,3,",")) and (listgetat(session.info,3,",") is not 0)>width="#listgetat(session.info,3,",")#"</cfif> <cfif len(listgetat(session.info,2,",")) and (listgetat(session.info,2,",") is not 0)>height="#listgetat(session.info,2,",")#"</cfif> border="0"><br/>';
			parent.opener.html_edit.textEdit.focus();		    
		    parent.close();   
		 <cfelse>
         parent.location.href="#request.self#?fuseaction=#session.module#.form_upd_emp&employee_id=#session.employee_id#";
		 </cfif>		 
	 </cfcase>
     <cfcase value="member">
	     <cfif isDefined("session.pid")>
            parent.location.href="#request.self#?fuseaction=#session.module#.form_list_company&event=updPartner&pid=#session.pid#";
		 <cfelseif 	isDefined("session.cid")>
            parent.location.href="#request.self#?fuseaction=#session.module#.consumer_list&event=det&cid=#session.cid#";		 
		 </cfif>
	 </cfcase>
     <cfcase value="content">
	    <cfif not isDefined("url.cntid")>
			parent.opener.html_edit.textEdit.document.body.innerHTML += '<img src="content/#session.imFile#" <cfif len(listgetat(session.info,3,",")) and (listgetat(session.info,3,",") is not 0)>width="#listgetat(session.info,3,",")#"</cfif> <cfif len(listgetat(session.info,2,",")) and (listgetat(session.info,2,",") is not 0)>height="#listgetat(session.info,2,",")#"</cfif> border="0"><br/>';
			parent.opener.html_edit.textEdit.focus();		    
		    parent.close();
		<cfelse>
 		  parent.wrk_opener_reload();
          parent.close();			
        </cfif>			
	 </cfcase>
     <cfcase value="correspondence">
		parent.opener.html_edit.textEdit.document.body.innerHTML += '<img src="correspondence/#session.imFile#" <cfif len(listgetat(session.info,3,",")) and (listgetat(session.info,3,",") is not 0)>width="#listgetat(session.info,3,",")#"</cfif> <cfif len(listgetat(session.info,2,",")) and (listgetat(session.info,2,",") is not 0)>height="#listgetat(session.info,2,",")#"</cfif> border="0"><br/>';
		parent.opener.html_edit.textEdit.focus();		    
		parent.close();
	 </cfcase>	 
     <cfcase value="product">
		parent.wrk_opener_reload();
        parent.close();
	 </cfcase>
     <cfcase value="training_management">
	 	    		
		parent.opener.html_edit.textEdit.document.body.innerHTML += '<img src="training/#session.training_folder#/#session.imFile#" <cfif len(listgetat(session.info,3,",")) and (listgetat(session.info,3,",") is not 0)>width="#listgetat(session.info,3,",")#"</cfif> <cfif len(listgetat(session.info,2,",")) and (listgetat(session.info,2,",") is not 0)>height="#listgetat(session.info,2,",")#"</cfif> border="0"><br/>';
		parent.opener.html_edit.textEdit.focus();
		parent.close();
		
	 </cfcase>
     <cfcase value="contract,sales,salespur,objects">
	 	    		
		parent.opener.html_edit.textEdit.document.body.innerHTML += '<img src="<cfif session.module eq 'contract'>contract/#ListGetAt(session.impath,ListLen(session.impath,dir_seperator),dir_seperator)#<cfelse>#session.module#</cfif>/#session.imFile#" <cfif len(listgetat(session.info,3,",")) and (listgetat(session.info,3,",") is not 0)>width="#listgetat(session.info,3,",")#"</cfif><cfif len(listgetat(session.info,2,",")) and (listgetat(session.info,2,",") is not 0)>height="#listgetat(session.info,2,",")#"</cfif> border="0"><br/>';
		parent.opener.html_edit.textEdit.focus();
		parent.close();
		
	 </cfcase>	 	 
 	 <cfdefaultcase>
		<cfinclude template="../../../dsp_hata.cfm">
	 </cfdefaultcase>

</cfswitch>   
</script>
</cfoutput>
<cfif isDefined("session.module")>
	<cfscript>
	   structdelete(session,"module");
	</cfscript>
</cfif>
<cfif isDefined("session.employee_id")>
	<cfscript>
	   structdelete(session,"employee_id");
	</cfscript>
</cfif>
<cfif isDefined("session.imFile")>
	<cfscript>
	   structdelete(session,"imFile");
	</cfscript>
</cfif>
<cfif isDefined("session.resim")>
	<cfscript>
	   structdelete(session,"resim");
	</cfscript>
</cfif>
<cfif isDefined("session.imTempFile")>
	<cfscript>
	   structdelete(session,"imTempFile");
	</cfscript>
</cfif>
<cfif isDefined("session.imPath")>
	<cfscript>
	   structdelete(session,"imPath");
	</cfscript>
</cfif>
<cfif isDefined("session.port")>
	<cfscript>
	   structdelete(session,"port");
	</cfscript>
</cfif>
<cfif isDefined("session.pid")>
	<cfscript>
	   structdelete(session,"pid");
	</cfscript>
</cfif>
<cfif isDefined("session.info")>
	<cfscript>
	   structdelete(session,"info");
	</cfscript>
</cfif>
