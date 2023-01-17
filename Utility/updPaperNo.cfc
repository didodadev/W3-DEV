<!-----------------------------------------------------------------------
*************************************************************************
		Copyright Workcube E-Business Inc. www.workcube.com
*************************************************************************
Analys		: Sevda Kurt			Developer	: Sevda Kurt		
Analys Date : 25/05/2016			Dev Date	: 25/05/2016		
Description :
	Bu utility belge numarasını günceller. applicationStart methodunda create edilir.
Patameters :
		columnName	: Number Kolon adı
		paperNumber : Belge Numarası
		paperDsn	: Şirket bilgisi
		değerlerini alır.
		
Used : 	updPaperNo.upd(
			columnName	: columnName,
			paperNumber	: paperNumber,
			paperDsn	: new_dsn3
		);
----------------------------------------------------------------------->
<cfcomponent>
	<cfset dsn = application.systemParam.systemParam().dsn>
    <cfset dsn3 = dsn & '_' & session.ep.company_id>
	<cffunction name="upd" access="public" returntype="boolean">
		<cfargument name="columnName" type="string" default="" required="yes" hint="Kolon Adı">
        <cfargument name="paperNumber" type="string" default="" required="yes" hint="Belge Numarasının Sayı Kısmı">
		<cfargument name="paperDsn" type="string" default="#dsn3#" hint="Datasource Name">
        <cfquery name="updateGeneralPapers" datasource="#arguments.paperDsn#">
            UPDATE 
                GENERAL_PAPERS
            SET
                #arguments.columnName# = #arguments.paperNumber#
            WHERE
                #arguments.columnName# IS NOT NULL
        </cfquery>
		<cfreturn true>
	</cffunction>
</cfcomponent>