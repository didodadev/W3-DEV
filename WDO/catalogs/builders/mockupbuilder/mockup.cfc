<!---
    File :          mockup.cfc
    Author :        Halit Yurttaş <halityurttas@gmail.com>
    Date :          10.11.2018
    Description :   Nocode Widgetleri abstract bileşenidir.
    Notes :         Tüm dom elementleri üretici sınıfları (fabrika vs hariç) bu sınıftan türer
--->
<cfcomponent>
    <cfproperty name="data" type="any">
    <cfproperty name="domain" type="any">
    <cfproperty name="eventtype" type="string">
    <cfproperty name="identcount" type="numeric">
    <cfproperty name="preattr" type="any">
    <cfproperty name="index" type="any">
    <cfproperty name="elementgroup" type="string">
    <cfproperty name="hasoutputtag" type="numeric">
    <cfproperty name="emp_url" type="string">

    <cffunction name="init" access="public" returntype="any">
        <cfargument name="data" type="any">
        <cfargument name="domain" type="any">
        <cfargument name="eventtype" type="string">
        <cfargument name="identcount" type="numeric" default="1">
        <cfargument name="preattr" type="any" default="#[]#">
        <cfargument name="index" type="any" default="">
        <cfargument name="elementgroup" type="string" default="formelements">
        <cfargument name="hasoutputtag" type="numeric" default="1">
        <cfset this.data = arguments.data>
        <cfset this.domain = arguments.domain>
        <cfset this.eventtype = arguments.eventtype>
        <cfset this.identcount = arguments.identcount>
        <cfset this.preattr = arguments.preattr>
        <cfset this.index = arguments.index>
        <cfset this.elementgroup = arguments.elementgroup>
        <cfset this.hasoutputtag = arguments.hasoutputtag>
        <cfset this.emp_url = application.systemParam.systemParam().fusebox.server_machine_list>
        <cfreturn this>
    </cffunction>

    <cffunction name="generate" access="public" returntype="string">
        <cfreturn "">
    </cffunction>

    <!--- helpers --->
    <cffunction name="stringFormat" access="public" returntype="string">
        <cfargument name="format" type="string">
        <cfargument name="values" type="array">
        <cfscript>
            jString = createObject("java", "java.lang.String");
            return jString.format(format, values);
        </cfscript>
    </cffunction>
    <cffunction name="stringFormatDump" access="public" returntype="string">
        <cfargument name="format" type="string">
        <cfargument name="values" type="array">
        <cfscript>
            jString = createObject("java", "java.lang.String");
            return jString.format(format, values);
            writeDump([format, values]);abort;
        </cfscript>
    </cffunction>
    <cffunction name="crlf" access="public" returntype="string">
        <cfreturn CreateObject("java", "java.lang.System").getProperty("line.separator")>
    </cffunction>
    <cffunction name="ident" access="public" returntype="string">
        <cfargument name="count" type="numeric" default="#this.identcount#">
        <cfreturn repeatString("     ", arguments.count)>
    </cffunction>
    <cffunction name="stringIsNullOrEmpty" access="public" returntype="boolean">
        <cfargument name="value">
        <cfif isDefined("arguments.value") and arguments.value neq "">
            <cfreturn 0>
        <cfelse>
            <cfreturn 1>
        </cfif>
    </cffunction>
    <cffunction name="emptyAsNull" access="public">
        <cfargument name="value">
        <cfif isDefined("arguments.value") and arguments.value neq "">
            <cfreturn arguments.value>
        </cfif>
    </cffunction>
</cfcomponent>