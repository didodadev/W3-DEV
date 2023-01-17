<!--- 
	Amaç : Şirket akış parametrelerinde Şube Bazında Proje Kontrolü Yapılsın mı? seçeneği kontrol ediliyor.
	Kullanım: Projeler
	Yazan: SÇ
	Tarih: 20181213 
--->
<cfcomponent>
	<cfset dsn = application.systemParam.systemParam().dsn>
	<cffunction name="get_control_branch_project_info_fnc" access="public" returnType="numeric" output="no">
        <cfset is_control_branch_project = 0>
		<cfif isDefined('session.ep.company_id')>
			<cfquery name="get_ourcomp_info" datasource="#dsn#">
				SELECT ISNULL(IS_CONTROL_BRANCH_PROJECT,0) IS_CONTROL_BRANCH_PROJECT FROM OUR_COMPANY_INFO WHERE COMP_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.company_id#">
			</cfquery>
			<cfif get_ourcomp_info.recordcount>
				<cfset is_control_branch_project = get_ourcomp_info.IS_CONTROL_BRANCH_PROJECT>
			</cfif>
		</cfif>
		<cfreturn is_control_branch_project>
    </cffunction>
</cfcomponent>