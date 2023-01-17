<!--- custom tag --->
<cfif thisTag.executionMode eq "start">
    <cfparam name="attributes.name" />
    <cfparam name="attributes.action" default="display" /><!--- display | validate --->
    <cfparam name="attributes.refresh" default="0" />
    <cfparam name="attributes.refresh_func" default="" />
    <cfif attributes.refresh_func contains '<cfoutput>' or attributes.refresh_func contains '</cfoutput>'>
    	<cfset attributes.refresh_func = Replace(Replace(attributes.refresh_func,'<cfoutput>','','all'),'</cfoutput>','','all')>
    </cfif>
    <cfif NOT StructKeyExists(application, "captcha")>
        <cfset application.captcha = CreateObject("component","cfc.captchaService").init(configFile="/cfc/captcha.xml")>
        <cfset application.captcha.setup() />
    </cfif>
    <!--- Güvenlik resmindeki metni yazın ---> 
    <cfif attributes.action eq "display">
        <cfset variables.hashReference = application.captcha.createHashReference()>
        <cfoutput>
        <img src="/web_services/displayCaptcha.cfm?hashReference=#variables.hashReference.hash#"  alt="Captcha"/><cfif attributes.refresh eq 1>&nbsp;&nbsp;<cfif len(attributes.refresh_func)><a href="javascript://" onclick="#attributes.refresh_func#"><img src="../images/refresh.png" title="#caller.getLang('main',2240)#" width="24" /></a></cfif></cfif><br />
        <input name="#attributes.name#_HashReference" id="#attributes.name#_HashReference" type="hidden" value="#variables.hashReference.hash#" />
        <input name="#attributes.name#_HashError" id="#attributes.name#_HashError" type="hidden" value="0" />
        <div style="clear:both; height:2px;"></div>
        <input name="#attributes.name#_HashText" id="#attributes.name#_HashText" type="text" value="" / style="width:150px;">
        <div style="clear:both; height:2px;"></div>
        #caller.getLang('main',778)#
        <div id="#attributes.name#_Hashdiv"></div>
        </cfoutput>
        <cfset caller[attributes.name] = structNew() />
        <cfset caller[attributes.name]["validationResult"] = false />
    <cfelseif attributes.action eq "validate">
        <cfset caller[attributes.name] = structNew() />
        <cfset caller[attributes.name]["validationResult"] = application.captcha.validateCaptcha(form["#attributes.name#_HashReference"],form["#attributes.name#_HashText"])>
    </cfif>
</cfif>
