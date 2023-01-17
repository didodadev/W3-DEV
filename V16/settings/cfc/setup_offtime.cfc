<!---
File: setup_offtime.cfc
Author: Workcube - Esma Uysal <esmauysal@workcube.com>
Description: İzin Kategorileri return json ve query formatı fonksiyonlarını içerir
--->
<cfcomponent>
	<cfset dsn = application.systemParam.systemParam().dsn>
	<cffunction name="get_setupofftime" access="public" returntype="any">
        <cfargument name="upper_offtimecat_id"><!--- Üst kategori ID'si --->
        <cfquery name="get_setupofftime" datasource="#dsn#">
            SELECT 
                OFFTIMECAT_ID,
                #dsn#.Get_Dynamic_Language(SETUP_OFFTIME.OFFTIMECAT_ID,'#session.ep.language#','SETUP_OFFTIME','OFFTIMECAT',NULL,NULL,SETUP_OFFTIME.OFFTIMECAT) AS OFFTIMECAT
            FROM
                SETUP_OFFTIME
            WHERE
                IS_ACTIVE = 1
                <cfif isdefined("arguments.upper_offtimecat_id") and len(arguments.upper_offtimecat_id)>
                    AND UPPER_OFFTIMECAT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.upper_offtimecat_id#">
                <cfelse>
                    AND UPPER_OFFTIMECAT_ID = 0
                </cfif>
        </cfquery>
        <cfreturn get_setupofftime>
    </cffunction>
    <cffunction name="get_sub_setupofftime" access="remote" returntype="string" returnFormat="json">
        <cfargument name="upper_offtimecat_id"><!--- Üst kategori ID'si --->
        <cfargument name="is_myhome" default=""><!--- myhome'da geliyor ise --->
        <cfquery name="get_sub_setupofftime" datasource="#dsn#">
        <cfif arguments.upper_offtimecat_id eq 0>
            SELECT 
            /*
                V16\myhome\form\form_add_offtime.cfm ve V16\myhome\form\form_upd_offtime.cfm dosyalarında, belge zorunluluğu kontrolü için eklenmiştir.
                Değişiklik durumunda diğer dosyalarda da güncelleme yapınız.
            */
                OFFTIMECAT_ID,
                OFFTIMECAT,
                IS_DOCUMENT_REQUIRED
            FROM 
                SETUP_OFFTIME
            WHERE
                UPPER_OFFTIMECAT_ID = 0
        <cfelse>
            SELECT 
                OFFTIMECAT_ID,
                OFFTIMECAT,
                IS_DOCUMENT_REQUIRED
            FROM 
                SETUP_OFFTIME
            WHERE
                UPPER_OFFTIMECAT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.upper_offtimecat_id#">
                <cfif isdefined("arguments.is_myhome") and len(arguments.is_myhome)>
                    AND IS_ACTIVE = 1
                    AND IS_REQUESTED = 1
                </cfif>
        </cfif>
        </cfquery>
        <cfreturn Replace(serializeJSON(get_sub_setupofftime),'//','')>
    </cffunction>
</cfcomponent>