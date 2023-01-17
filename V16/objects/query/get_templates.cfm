<cfquery name="get_templates" datasource="#dsn#">
	SELECT 
	      * 
	FROM 
		TEMPLATE_FORMS
	WHERE 
	    TEMPLATE_MODULE = #attributes.module#
	<cfif isdefined("attributes.template_id")>
		AND TEMPLATE_ID = #attributes.TEMPLATE_ID#
	</cfif>
	<cfif isDefined("attributes.keyword")>
	   AND TEMPLATE_HEAD LIKE '%#attributes.keyword#%'
	</cfif>	  	
</cfquery>
