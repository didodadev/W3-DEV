<!-----------------------------------------------------------------------
*************************************************************************
		Copyright Workcube E-Business Inc. www.workcube.com
*************************************************************************
Analys		: Sevda Kurt			Developer	: Sevda Kurt		
Analys Date : 07/10/2015			Dev Date	: 07/10/2015		
Description :
	Bu utility gelen belge numaralarından daha önce kaydedilmiş olanların listesini döndürür. Toplu işlemlerde belge numarası ve işlem id parametreleri liste yapılıp fonksiyona gönderilmelidir. applicationStart methodunda create edilir.
Patameters :
		tableName,paperNoColumn,paperNo,actionTypeColumn,actionTypes,actionDb
		değerlerini alır.
Used :  control_paper_no = controlPaperNo.control(
			tableName = 'BANK_ACTIONS',
			paperNoColumn = 'PAPER_NO',
			paperNo = paper_list,
			actionTypeColumn = 'ACTION_TYPE_ID',
			actionTypes = '23,230',
			actionDb = dsn2
----------------------------------------------------------------------->
<cfcomponent>
	<cfset dsn = application.systemParam.systemParam().dsn>
    <cfset dsn2 = dsn & '_' & session.ep.period_year & '_' & session.ep.company_id>
    <cfset dsn3 = dsn & '_' & session.ep.company_id>
    <cffunction name="control" access="remote" returntype="any" returnformat="plain">
        <cfargument name="tableName" type="string" required="yes" hint="İşlemin Yapıldığı Tablo">
        <cfargument name="paperNoColumn" type="string" required="yes" hint="İşlem Tablosundaki Belge Numarası Kolonu">
        <cfargument name="paperNo" type="string" required="yes" hint="Belge Numarası/Numaraları">
        <cfargument name="actionTypeColumn" type="string" required="no" hint="İşlem Tipi Kolonu">
        <cfargument name="actionTypes" type="any" required="no" hint="İşlem Tipi/Tipleri">
        <cfargument name="actionIdColumn" type="string" required="no" hint="İşlem ID nin Tutulduğu Kolon">
        <cfargument name="actionId" type="any" required="no" hint="İşlem Id">
        <cfargument name="actionDb" type="string" required="yes" hint="Datasource">
        <cfargument name="isVirman" default="0" type="numeric" required="no" hint="Virman İşlemi mi?">
        <cfset paperNoList = ''>
        <cfset virmanList = ''>
        <cfif isdefined("arguments.actionId") and len(arguments.actionId) and isdefined("arguments.isVirman") and arguments.isVirman eq 1>
            <cfloop from="1" to="#listLen(arguments.actionId,',')#" index="i">
                <cfset virmanList = listAppend(virmanList,listGetAt(arguments.actionId,i,',') + 1,',')>
            </cfloop>
            <cfset arguments.actionId = arguments.actionId & ',' & virmanList>
        </cfif>
        <cfquery name="PAPER_NO_FROM_ACTION_TABLE" datasource="#arguments.actionDb#">
            SELECT
                #arguments.paperNoColumn#
            FROM
                #arguments.tableName#
            WHERE
                #arguments.paperNoColumn# IN (#preserveSingleQuotes(arguments.paperNo)#)
                <cfif isdefined("arguments.actionTypeColumn") and len(arguments.actionTypeColumn) and isdefined("arguments.actionTypes") and len(arguments.actionTypes)>
                    AND #arguments.actionTypeColumn# IN (#arguments.actionTypes#)
                </cfif>
                <cfif isdefined("arguments.actionIdColumn") and len(arguments.actionIdColumn) and isdefined("arguments.actionId") and len(arguments.actionId)>
                    AND #arguments.actionIdColumn# NOT IN (#preserveSingleQuotes(arguments.actionId)#)
                </cfif>
        </cfquery>
        <cfoutput query="PAPER_NO_FROM_ACTION_TABLE">
            <cfset paperNoList = ListAppend(paperNoList,evaluate(#arguments.paperNoColumn#),',')>
        </cfoutput>
        <cfreturn paperNoList>
    </cffunction> 
    <cffunction name="getFromGeneralPapers" access="remote" returntype="any" returnformat="plain">
    	<cfargument name="noColumn">
        <cfargument name="numberColumn">
        <cfset dsn3 = '#dsn#_#session.ep.company_id#'>
        <cfif arguments.numberColumn is "REVENUE_RECEIPT_NUMBER">
			<cfquery name="getColumns" datasource="#dsn3#">
				SELECT
                    #arguments.noColumn#,
                    #arguments.numberColumn#
                FROM
                	PAPERS_NO
                WHERE
                	EMPLOYEE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.userid#">
                ORDER BY
                	PAPER_ID DESC 
			</cfquery>
            <cfif not (len(evaluate('getColumns.#arguments.noColumn#')) and len(evaluate('getColumns.#arguments.numberColumn#')))>
				<cfquery name="getColumns" datasource="#dsn3#">
                    SELECT
                        #arguments.noColumn#,
                        #arguments.numberColumn#
					FROM
						PAPERS_NO PN,
						#dsn#.dbo.SETUP_PRINTER_USERS SPU
					WHERE
						PN.PRINTER_ID = SPU.PRINTER_ID AND
						SPU.PRINTER_EMP_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.userid#">
					ORDER BY
						PAPER_ID DESC 
				</cfquery>
            </cfif>
        <cfelse>
       		<cfquery name="getColumns" datasource="#dsn3#">
                SELECT
                    #arguments.noColumn#,
                    #arguments.numberColumn#
                FROM
                    GENERAL_PAPERS
                WHERE
                    #arguments.numberColumn# IS NOT NULL
            </cfquery>
        </cfif>
        <cfoutput>
        	<cfset columns = Evaluate("getColumns.#arguments.noColumn#") & '-' & Evaluate("getColumns.#arguments.numberColumn#")>
        </cfoutput>
        <cfreturn columns>
    </cffunction>
</cfcomponent>