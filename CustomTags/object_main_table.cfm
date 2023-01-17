<cfparam name="attributes.id" default="main_table_#round(rand()*10000000)#">
<cfparam name="attributes.hide" default="0">
<cfparam name="attributes.style" default="">
<cfparam name="attributes.align" default="">

<cfset degerim_ = thisTag.GeneratedContent>
<cfset thisTag.GeneratedContent =''>
<cfset caller.hidden_tr_length = 0>
<cfset caller.tr_sayac = 0>
<cfif thisTag.executionMode eq "start">      
	<cfoutput>
        <table cellpadding="0" cellspacing="0" id="#attributes.id#" border="0" <cfif len(attributes.align)>align="<cfoutput>#attributes.align#"</cfoutput></cfif> <cfif len(attributes.style)>style="<cfoutput>#attributes.style#"</cfoutput></cfif> <cfif attributes.hide eq 1>style="display:none;"</cfif>>
        	<tr>
    </cfoutput>
<cfelse>
	<cfoutput>#degerim_#</cfoutput>
		</tr>
	</table>
</cfif>
