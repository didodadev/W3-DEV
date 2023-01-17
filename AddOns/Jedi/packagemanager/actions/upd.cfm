<cfparam name="attributes.package_id" default="">
<cfparam name="attributes.head" default="">
<cfparam name="attributes.is_active" default="">
<cfif not len(attributes.package_id)>
    <script>alert('Hatalı veri';)</script>
    <cfabort>
</cfif>
<cfif not len(attributes.head)>
    <script>alert('Paketinizin bir adı olmalı';)</script>
    <cfabort>
</cfif>

<cfobject name="jedipackage" type="component" component="addons.jedi.models.jedipackage">
<cfobject name="javaziphelper" type="component" component="cfc.javaziphelper">

<cfset jedipackage.updatepackage(attributes.package_id, attributes.head, attributes.is_active)>
<cfset package = jedipackage.getpackage(attributes.package_id)>

<cfset jedipath = package.path>
<cfset root_path = "#getDirectoryFromPath(getCurrentTemplatePath())#\..\..\..\..">
<cfif not directoryExists("#root_path#\documents\jedi")>
    <cfdirectory action="create" directory="#root_path#\documents\jedi">
</cfif>
<cfif not directoryExists("#root_path#\documents\jedi\#session.ep.userid#")>
    <cfdirectory action="create" directory="#root_path#\documents\jedi\#session.ep.userid#">
</cfif>
<cfif not directoryExists("#root_path#\documents\jedi\#session.ep.userid#\#jedipath#")>
    <cfdirectory action="create" directory="#root_path#\documents\jedi\#session.ep.userid#\#jedipath#">
</cfif>
<cfif isDefined("Form.ZIPFILE")>
    <cfset directoryDelete("#root_path#\documents\jedi\#session.ep.userid#\#jedipath#", 1)>
    <cfdirectory action="create" directory="#root_path#\documents\jedi\#session.ep.userid#\#jedipath#">
    <cffile action="upload" destination="#root_path#\documents\jedi\#session.ep.userid#\#jedipath#\package.zip">
    <cfset javaziphelper.ExtractFilesFromPath("#root_path#\documents\jedi\#session.ep.userid#\#jedipath#\package.zip", "#root_path#\documents\jedi\#session.ep.userid#\#jedipath#\")>
    <cffile action="delete" file="#root_path#\documents\jedi\#session.ep.userid#\#jedipath#\package.zip">
</cfif>
<script>document.location.href = '/index.cfm?fuseaction=jedi.package';</script>