<cfparam name="attributes.head" default="">
<cfparam name="attributes.is_active" default="0">
<cfif not len(attributes.head)>
    <script>alert('Paketinizin bir adı olmalı';)</script>
    <cfabort>
</cfif>

<cfobject name="jedipackage" type="component" component="addons.jedi.models.jedipackage">
<cfobject name="javaziphelper" type="component" component="cfc.javaziphelper">
<cfset postfix = createUUID()>
<cfset jedipackage.insertpackage(attributes.head, "#session.ep.userid#-#postfix#", attributes.is_active)>
<cfset root_path = "#getDirectoryFromPath(getCurrentTemplatePath())#\..\..\..\..">
<cfif not directoryExists("#root_path#\documents\jedi")>
    <cfdirectory action="create" directory="#root_path#\documents\jedi">
</cfif>
<cfif not directoryExists("#root_path#\documents\jedi\#session.ep.userid#")>
    <cfdirectory action="create" directory="#root_path#\documents\jedi\#session.ep.userid#">
</cfif>
<cfif not directoryExists("#root_path#\documents\jedi\#session.ep.userid#\#session.ep.userid#-#postfix#")>
    <cfdirectory action="create" directory="#root_path#\documents\jedi\#session.ep.userid#\#session.ep.userid#-#postfix#">
</cfif>
<cfif isDefined("Form.ZIPFILE")>
    <cffile action="upload" destination="#root_path#\documents\jedi\#session.ep.userid#\#session.ep.userid#-#postfix#\package.zip">
    <cfset javaziphelper.ExtractFilesFromPath("#root_path#\documents\jedi\#session.ep.userid#\#session.ep.userid#-#postfix#\package.zip", "#root_path#\documents\jedi\#session.ep.userid#\#session.ep.userid#-#postfix#\")>
    <cffile action="delete" file="#root_path#\documents\jedi\#session.ep.userid#\#session.ep.userid#-#postfix#\package.zip">
</cfif>
<script>document.location.href = '/index.cfm?fuseaction=jedi.package';</script>