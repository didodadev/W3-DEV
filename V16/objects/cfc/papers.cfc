<cfcomponent>
	<cfset dsn = application.systemParam.systemParam().dsn>
	<!--- Query tarafında yapılacak belge numarası kontrolü. Aynı anda yapılan kayıtlarda javascript kontrolünden geçiyorsa, query tarafında transaction içinde kullanılmalıdır. SK20151007 --->
    <cffunction name="controlPaperNo" access="remote" returntype="any" returnformat="plain">
        <!--- Gelen belge numaralarından daha önce kaydedilmiş olanların listesini döndürür. --->
        <!---
            FONKSİYON ÇAĞIRILMADAN ÖNCE, İŞLEM ID LERİN LİSTESİ OLUŞTURULMALIDIR.
            control_paper_no = controlPaperNo(
                    tableName = 'BANK_ACTIONS', İŞLEM TABLOSU
                    paperNoColumn = 'PAPER_NO', İŞLEM TABLOSUNDAKİ BELGE NO KOLON ADI
                    paperNo = paper_list, FORMDAKİ BELGE NUMARALARININ LİSTESİ
                    actionTypeColumn = 'ACTION_TYPE_ID', İŞLEM TABLOSUNDAKİ İŞLEM TİPİ KOLONU
                    actionTypes = '23,230', İŞLEM TİPİ ID
                    actionDb = dsn2 İŞLEM TABLOSU DATASOURCE
            FONKSİYON ÇAĞIRILDIKTAN SONRA BELGE NUMARASI LİSTESİ OLUŞMUŞSA UYARI VERİLİR.
         --->
        <cfargument name="tableName">
        <cfargument name="paperNoColumn">
        <cfargument name="paperNo">
        <cfargument name="actionTypeColumn">
        <cfargument name="actionTypes">
        <cfargument name="actionIdColumn">
        <cfargument name="actionId">
        <cfargument name="actionDb">
        <cfargument name="isVirman" default="0">
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
						#dsn#.SETUP_PRINTER_USERS SPU
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
