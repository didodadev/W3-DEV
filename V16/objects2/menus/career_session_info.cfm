<cfif isdefined("session.cp.userid")>
    <div class="welcomeUser" align="right">
        <cfoutput>
				<img src="../objects2/image/profile.gif" align="absmiddle" border="0" />&nbsp;&nbsp;#session.cp.name# #session.cp.surname#&nbsp;|&nbsp;<a href="index.cfm?fuseaction=home.act_logout" style="font-size: 11px;font-family: Geneva, tahoma, arial, Helvetica, sans-serif;color: ##333;">Çıkış Yap</a>
        </cfoutput>
    </div>
</cfif>
