<cfinclude template="core.cfm">
<cftry>
	<cfset addContent(data: form.uploadedContent, classID: attributes.class_id)>                       
	<script type="text/javascript">
		{alert("<cfoutput>#getLang('store',42)#</cfoutput>");
		wrk_opener_reload();
		window.close();
		}
	</script>
	<cfcatch>
	<script type="text/javascript">
	{
	  alert("<cfoutput>#getLang('campaign',49)#</cfoutput>!");
	  history.go(-1);
	}
	</script>
	</cfcatch>
</cftry>
