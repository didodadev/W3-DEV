<cfparam name="attributes.id" default="ajax_list_#round(rand()*10000000)#">
<cfparam name="attributes.style" default="">
<cfset SCHEMA_ORG.SCHEMA_TYPE = 'no'>
<cfif thisTag.executionMode eq "start">
    <tr class="row_border">
        <td>
            <table id="<cfoutput>#attributes.id#</cfoutput>" style="<cfoutput>#(len(attributes.style)?attributes.style:'')#</cfoutput>">
               
            
<cfelse>      
            </table>
        </td>
    </tr>          
</cfif>