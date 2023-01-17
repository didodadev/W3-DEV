<cfif isdefined("session.pp.userkey")>
    <table>
        <tr>
            <td class="session_header">
            <cfoutput><a href="#request.self#?fuseaction=objects2.form_upd_my_company" class="session_link">
            	<img src="../objects2/image/profile.gif" align="absmiddle" border="0" />&nbsp;&nbsp;#session.pp.company_nick# - #session.pp.name# #session.pp.surname#
             </a></cfoutput>
            </td>
        </tr>
    </table>
</cfif>
