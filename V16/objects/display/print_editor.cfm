<table cellspacing="1" cellpadding="2" border="0" width="100%" height="100%">
    <tr>
        <td valign="top"><br/>		   
            <table>
                <tr> 
                    <td></td>
                    <td  id="forum"></td>
                </tr>				  			  
                <tr> 
                    <td></td>
                    <td id="subject"></td>
                </tr>
                <tr> 
                    <td></td>
                    <td id="title2"></td>
                </tr>
                <tr> 
                    <td></td>
                    <td id="message"></td>
                </tr>
            </table>
        </td>
    </tr>
</table>
<cfoutput>
<script type="text/javascript">
    <cfif isDefined("attributes.editor_name")>
    document.getElementById('message').innerHTML = window.opener.#attributes.editor_name#.value;
    <cfif isdefined("attributes.editor_header")> document.getElementById('subject').innerHTML = '<font size="2">#attributes.title1#</font> : ' + window.opener.#attributes.editor_header#.value;</cfif>
    <cfif len(attributes.title2)>document.getElementById('title2').innerHTML = '<font size="2">#attributes.title2#</font>';</cfif>
    
    </cfif>

<cfif isDefined("attributes.editor_Forum")>
    document.getElementById('forum').innerHTML = window.opener.#attributes.editor_Forum#.value;
</cfif>
function waitfor(){
<cfif isDefined("attributes.is_pop") and (attributes.is_pop EQ 1)>
window.opener.close();
</cfif>	
window.close();
}
setTimeout("waitfor()",3000);  
window.print();			
</script>
</cfoutput>
