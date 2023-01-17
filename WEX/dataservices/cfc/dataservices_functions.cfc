<!---
    File: WEX\dataservices\cfc\data_services.cfc
    Author: Workcube-Esma Uysal <esmauysal@workcube.com>
    Date: 18.03.2021
    Description: WEX'te tanımlı data servis

    Not : Data Service'te kullanılan ortak donksiyonlar
--->
<cfcomponent accessors="true" extends = "cfc.queryJSONConverter">
    
    <cfproperty name="type" type="string" required="false">
    <cfproperty name="tableName" type="string" required="false">
    <cfproperty name="whereColumn" type="string" required="false">
    <cfproperty name="identityColumn" type="string" required="false">
    <cfproperty name="whereColumnParamtype" type="string" required="false">
    <cfproperty name="finishDateColumn" type="string" required="false">
    <cfproperty name="startDateColumn" type="string" required="false">
    <cfproperty name="dsn" type="string" required="false">

    <cfset this_dsn = application.systemParam.systemParam().dsn>

    <cffunction name = "initialize" access = "public">
        <cfargument name="type" type="string" required="false" default="">
        <cfargument name="tableName" type="string" required="false" default="">
        <cfargument name="whereColumn" type="string" required="false" default="">
        <cfargument name="identityColumn" type="string" required="false" default="">
        <cfargument name="whereColumnParamtype" type="string" required="false" default="">
        <cfargument name="finishDateColumn" type="string" required="false" default="">
        <cfargument name="startDateColumn" type="string" required="false" default="">
        <cfargument name="dsn" type="string" required="false" default="#this_dsn#">

        <cfset settype( arguments.type ) />
        <cfset settableName( arguments.tableName ) />
        <cfset setwhereColumn( arguments.whereColumn ) />
        <cfset setidentityColumn( arguments.identityColumn ) />
        <cfset setwhereColumnParamtype( arguments.whereColumnParamtype ) />
        <cfset setfinishDateColumn( arguments.finishDateColumn ) />
        <cfset setstartDateColumn( arguments.startDateColumn ) />
        <cfset setdsn( arguments.dsn ) />

        <cfreturn this>
    </cffunction>

    <!--- Return Json Function --->
    <cffunction  name="return_json" access="public">
        <cfargument  name="data">
        <cfset result = arrayNew(1)>
        <cfloop from="1" to="#data.recordcount#" index="i">
            <cfset arrayAppend(result, queryGetRow(data, i))>
        </cfloop>
        <cfreturn replace(serializeJSON(result), "//", "")>
    </cffunction>

    <cfscript>
        public any function returnResult( boolean status, string dataservices_name = "", string message = "", any errorMessage = "",any data="",string type="") returnformat = "JSON" {
            response = structNew();
            functions_property = structNew();
            data_json = this.return_json(data : data)
            functions_property = {
                type: gettype(),
                tableName: gettableName(),
                whereColumn: getwhereColumn(),
                identityColumn: getidentityColumn(),
                whereColumnParamtype: getwhereColumnParamtype(),
                finishDateColumn: getfinishDateColumn(),
                startDateColumn: getstartDateColumn(),
                dsn: getdsn()
            };

            response = {
                status: status,
                dataservices_name: dataservices_name,
                message: message,
                errorMessage: errorMessage,
                data: data_json,
                functions_property: functions_property
            };

            writeOutput(Replace(SerializeJSON(response),"//",""));
            abort;
        }
    </cfscript>

</cfcomponent>