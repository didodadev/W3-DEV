<cfprocessingdirective suppresswhitespace="yes"> 
<cfsetting showdebugoutput="no">
<cfsetting enablecfoutputonly="yes">
<cfif isDefined('form.icerik')>
    <cfset cont = form.icerik>
    <cfset cont = Replace(cont,'/documents','Http://#cgi.http_host#/documents','all')>
    <cfif isdefined("form.module") and form.module is 'report_saved_div'><!--- Kayitli raporlarda sorun cikartiyordu. Eski kayitlarin hepsini guncelleyemeyecegim icin buraya ekledim. EY30101013 --->
    	<cfif cont contains '<!-- sil --><!-- sil -->'>
        	<cfset cont = Replace(cont,'<!-- sil --><!-- sil -->','<!-- sil -->','all')>
        </cfif>
  </cfif>
  <cfset cont = wrk_content_clear(cont)>
	<cfif not len(trim(attributes.name))>
		<cfset filename = "#createuuid()#">
	<cfelse>
		<cfset filename = "#attributes.name#">	
	</cfif>
	<cfheader name="Expires" value="#Now()#">
	<cfif attributes.extension eq "xls">
		<cfcontent type="application/vnd.ms-excel; charset=utf-16">
	<cfelseif attributes.extension eq "sxc">
		<cfcontent type="application/vnd.msexcel;charset=utf-16">
	<cfelseif attributes.extension eq "doc">
		<cfcontent type="application/vnd.ms-word;charset=utf-16">
	<cfelse>
		<cfcontent type="text/plain;charset=utf-8">
	</cfif>

<cfif attributes.extension eq "xls">
        <cfheader name="Content-Disposition" value="attachment; filename=#filename#.#attributes.extension#" charset="utf-8">
		<head>
            <meta http-equiv="Content-Type" content="text/html; charset=utf-16">
            <style type="text/css">
                table{font-size:11px;font-family:Geneva, tahoma, arial,  Helvetica, sans-serif;color : #333333;}
                .formbold {font-family:Geneva, Verdana, Arial, sans-serif; font-size : 11px; font-weight: bold;color: #000000;}
                .form-title	{font-family:Geneva, tahoma, arial,  sans-serif;color:white;font-weight : bold; padding-left: 3px;}
                .color-list	{background-color: #E6E6FF;}
                .color-header {background-color: #a7caed;}
                .color-border {background-color:#f1f0ff;}
                .color-row {background-color: #f1f0ff;}
                .headbold {font-family:  Geneva, Verdana, Arial, sans-serif; font-size: 14px; font-weight: bold; padding-right: 2px; padding-left: 2px}
                .txtboldblue {font-weight: bold; font-family:  Geneva, Verdana, Arial, sans-serif; font-size: 10px; color: #6699CC; padding-right: 1px; padding-left: 1px}
                .txtbold {font-weight:bold; font-size:11px; color:#000000}
            </style> 
        </head>
        <body>
        	<cfoutput>#cont#</cfoutput>
        </body>
    <cfelse>
        <cfheader name="Content-Disposition" value="attachment; filename=#filename#.#attributes.extension#">
        <meta http-equiv="content-type" content="text/plain; charset=utf-16">
        <style type="text/css">
            table{font-size:11px;font-family:Geneva, tahoma, arial,  Helvetica, sans-serif;color : #333333;}
            .formbold {font-family:Geneva, Verdana, Arial, sans-serif; font-size : 11px; font-weight: bold;color: #000000;}
            .form-title	{font-family:Geneva, tahoma, arial,  sans-serif;color:white;font-weight : bold; padding-left: 3px;}
            .color-list	{background-color: #E6E6FF;}
            .color-header {background-color: #a7caed;}
            .color-border {background-color:#f1f0ff;}
            .color-row {background-color: #f1f0ff;}
            .headbold {font-family:  Geneva, Verdana, Arial, sans-serif; font-size: 14px; font-weight: bold; padding-right: 2px; padding-left: 2px}
            .txtboldblue {font-weight: bold; font-family:  Geneva, Verdana, Arial, sans-serif; font-size: 10px; color: #6699CC; padding-right: 1px; padding-left: 1px}
            .txtbold {font-weight:bold; font-size:11px; color:#000000}
        </style>
		<cfoutput>#cont#</cfoutput> 
    </cfif>
</cfif>
<cfsetting enablecfoutputonly="no">
</cfprocessingdirective>
