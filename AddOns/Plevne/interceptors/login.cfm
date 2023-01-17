<cfif (not isDefined("form.token")) or form.token eq "" or (not isDefined("session.logintoken")) or session.logintoken eq "" or session.logintoken neq form.token>
    <script>document.location.href = "/index.cfm?ex=notoken";</script>
        <cfheader statuscode="400" statustext="Token not found">
        <cfabort>
<cfelse>
    <cfset session.logintoken = "">
</cfif>
<cfif isDefined("form.username") and len(form.username)>
    <cfif reFindNoCase("^[\w-\.@]+$", form.username) eq 0>
        <script>document.location.href = "/index.cfm?ex=username";</script>
        <cfheader statuscode="400" statustext="Username is mistake">
        <cfabort>
    </cfif>
</cfif>
<cfif isDefined("form.password") and len(form.password)>
    <cfif reFindNoCase('javascript\s*:|vbscript\s*:|<InvalidTag|<scr|documents\s*\.|<ifr|<for|@import|<met|onerror=|string\.|fromchar|%3C%73%63%72%69%70%74|%3C%69%66%72%61%6D%65|XMLHttp|eval\s*\(|style\s*=\s*"width\s*:\s*expression\(|' & "'\s*or\s*[']*|\w+[']*=[']*\w+|union\s+all", form.password) gt 0>
        <script>document.location.href = "/index.cfm?ex=error";</script>
        <cfheader statuscode="400" statustext="Dangerous content found">
        <cfabort>
    </cfif>
    <cfif reFindNoCase('drop\s+(table|view|procedure)', form.password) gt 0>
        <script>document.location.href = "/index.cfm?ex=error";</script>
        <cfheader statuscode="400" statustext="Dangerous content found">
        <cfabort>
    </cfif>
    <cfif reFindNoCase('create\s+(table|view|procedure)', form.password) gt 0>
        <script>document.location.href = "/index.cfm?ex=error";</script>
        <cfheader statuscode="400" statustext="Dangerous content found">
        <cfabort>
    </cfif>
    <cfif reFindNoCase('exec\s+sp_', form.password) gt 0>
        <script>document.location.href = "/index.cfm?ex=error";</script>
        <cfheader statuscode="400" statustext="Dangerous content found">
        <cfabort>
    </cfif>
    <cfif reFindNoCase('%3Cform|\\u\d+|\\x\d+|&##\d+|charset\s*=[\s"]*UTF-7|<base\s+href\s*=\s*"javascript|style\s*=\s*"javascript|<link\s+href\s*=\s*"javascript|list-style-image\s*:\s*url\s*\(\s*"javascript|input\s+type\s*=\s*"image"\s+src\s*=\s*"javascript', form.password) gt 0>
        <script>document.location.href = "/index.cfm?ex=error";</script>
        <cfheader statuscode="400" statustext="Dangerous content found">
        <cfabort>
    </cfif>
</cfif>