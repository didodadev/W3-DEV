<cfset attributes.help_id = attributes.id>
<cfif isDefined("attributes.help_id")>
  <cfinclude template="../query/get_help.cfm">
  <table width="100%" cellpadding="2" cellspacing="1" border="0">
    <tr bgcolor="#FFFFFF">
      <td valign="top"> 
	  	<cfoutput>
          <table width="95%" align="center">
            <tr>
              <td>#employee_domain##request.self#?fuseaction=#get_help.help_circuit#.#get_help.help_fuseaction#<br/>
                <hr>
              </td>
            </tr>
            <tr>
              <td><STRONG>#get_help.help_head#</STRONG><br/>
                <br/>
              </td>
            <tr>
              <td>#get_help.help_topic#</td>
            </tr>
          </table>
        </cfoutput> 
		</td>
    </tr>
  </table>
</cfif>

