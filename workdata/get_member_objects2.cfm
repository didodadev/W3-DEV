<!---Fatih A 20080919 Autocomplate için yapildi objects2 tarafinda aranan kritere uygun tüm aktif üyeleri getirir--->
<cffunction name="get_member_objects2" access="public" returntype="query" output="no">
	<cfargument name="nickname" required="yes" type="string">
	<cfargument name="maxrows" required="yes" type="string" default="">
	<cfargument name="select_list" required="no" type="string" default="1,2">
	<cfargument name="is_reference" required="no" type="string" default="1">
	<cfargument name="is_potantial" required="no" type="string" default="">
	<cfargument name="is_buyer_seller" required="no" type="string" default="2">
	<cfargument name="member_status" required="no" type="string" default="1">
	<cfargument name="is_ref_order" required="no" type="string" default="0">
	<cfargument name="is_ref_count" required="no" type="string" default="0">
	<cfargument name="is_ref_record" required="no" type="string" default="0">
	<cfargument name="company_id" required="no" type="numeric" default="#session_base.company_id#">
    
	<!--- Detayini Gokhan biliyor <cfargument name="is_company_cat" required="no" type="string" default=""> --->
	<cfif isdefined("session.ep") and session.ep.our_company_info.sales_zone_followup eq 1>
		<!--- Dore de bölge yetkisine göre getirmesi için eklendi kaldırmayınız --->
		<cfquery name="GET_HIERARCHIES" datasource="#DSN#">
			SELECT
				DISTINCT
				SZ_HIERARCHY
			FROM
				SALES_ZONES_ALL_1
			WHERE
				POSITION_CODE = #session.ep.position_code#
		</cfquery>
		<cfset row_block = 500>
	</cfif>
	<cfquery name="get_company_partner" datasource="#dsn#">
		<cfif ListFind(arguments.select_list,1,',')>
			SELECT DISTINCT
				'partner' AS MEMBER_TYPE,
				0 AUTOCOMPLETE_TYPE,
				NULL CONSUMER_ID,
				C.COMPANY_ID,
				C.NICKNAME,
				C.FULLNAME AS MEMBER_NAME,
				C.MEMBER_CODE AS MEMBER_CODE,
				CP.PARTNER_ID,
				<cfif database_type is 'MSSQL'>
				CP.COMPANY_PARTNER_NAME + ' ' + CP.COMPANY_PARTNER_SURNAME AS MEMBER_PARTNER_NAME
				<cfelseif database_type is 'DB2'>
				CP.COMPANY_PARTNER_NAME || ' ' || CP.COMPANY_PARTNER_SURNAME AS MEMBER_PARTNER_NAME
				</cfif>,
				'' CONSUMER_REFERENCE_CODE
			FROM 
				COMPANY C,
				COMPANY_PARTNER CP
			WHERE 
				C.COMPANY_ID = CP.COMPANY_ID
			<!--- session olmadıgi zaman kayit gelmemeli kaldirma BK 20110210 --->
			<cfif isdefined("arguments.company_id") and len(arguments.company_id)>
                AND C.COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.company_id#">
            </cfif>
			<cfif not isdefined("session_base.userid")>
				AND 1=0
			</cfif>                
			<cfif isdefined("arguments.member_status") and arguments.member_status eq 1>
                AND C.COMPANY_STATUS = 1
                AND CP.COMPANY_PARTNER_STATUS = 1
            </cfif>
            <cfif isdefined("arguments.is_potantial") and len(arguments.is_potantial)>
                AND C.ISPOTANTIAL = #arguments.is_potantial#
            </cfif>
			<cfif isDefined("arguments.is_buyer_seller") and arguments.is_buyer_seller eq 0>
                AND	C.IS_BUYER = 1
            <cfelseif isDefined("arguments.is_buyer_seller") and arguments.is_buyer_seller eq 1>
                AND	C.IS_SELLER = 1
            </cfif>
			<cfif len(arguments.nickname)>
            AND
            (
                C.FULLNAME LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.nickname#%"> OR
                C.NICKNAME LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.nickname#%"> OR
                C.MEMBER_CODE LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.nickname#%"> OR
                <cfif database_type is 'MSSQL'>
                CP.COMPANY_PARTNER_NAME + ' ' + CP.COMPANY_PARTNER_SURNAME LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.nickname#%">
                <cfelseif database_type is 'DB2'>
                CP.COMPANY_PARTNER_NAME || ' ' || CP.COMPANY_PARTNER_SURNAME LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.nickname#%">
                </cfif>
            )
            </cfif>
			<!--- <cfif len(arguments.is_company_cat)>
				AND C.COMPANYCAT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.is_company_cat#">
			</cfif> --->
		<cfif isdefined("session.ep") and session.ep.our_company_info.sales_zone_followup eq 1>
            <!--- Satis Takimda Ekip Lideri veya Satıs Takiminda Ekipde ise ilgili IMS ler--->
            AND 
            (
                C.IMS_CODE_ID IN (
                                    SELECT
                                        IMS_ID
                                    FROM
                                        SALES_ZONES_ALL_2
                                    WHERE
                                        POSITION_CODE = #session.ep.position_code# 
                                 )
            <!--- Satis bolgeleri ekibinde veya Satis bolgesinde yonetici ise kendisi ve altindaki IMS ler--->			
            <cfif get_hierarchies.recordcount>
            OR C.IMS_CODE_ID IN (
                                    SELECT
                                        IMS_ID
                                    FROM
                                        SALES_ZONES_ALL_1
                                    WHERE											
                                        <cfloop index="page_stock" from="0" to="#(ceiling(get_hierarchies.recordcount/row_block))-1#">
                                            <cfset start_row=(page_stock*row_block)+1>	
                                            <cfset end_row=start_row+(row_block-1)>
                                            <cfif (end_row) gte get_hierarchies.recordcount>
                                                <cfset end_row=get_hierarchies.recordcount>
                                            </cfif>
                                                (
                                                <cfloop index="add_stock" from="#start_row#" to="#end_row#">
                                                    <cfif (add_stock mod row_block) neq 1> OR</cfif> SZ_HIERARCHY LIKE '#get_hierarchies.sz_hierarchy[add_stock]#%'
                                                </cfloop>
                                                
                                                )<cfif (ceiling(get_hierarchies.recordcount/row_block))-1 neq page_stock> OR</cfif>													
                                        </cfloop>											
                                )
              </cfif>						
            )
        </cfif>
		</cfif>
		<cfif ListFind(arguments.select_list,1,',') and ListFind(arguments.select_list,2,',')>
			UNION ALL
		</cfif>
		<cfif ListFind(arguments.select_list,2,',')>
            SELECT DISTINCT
                'consumer' AS MEMBER_TYPE,
                1 AUTOCOMPLETE_TYPE,
                C.CONSUMER_ID,
                NULL COMPANY_ID,
                ' '  NICKNAME,
                 <cfif database_type is 'MSSQL'>
                C.CONSUMER_NAME + ' ' + C.CONSUMER_SURNAME AS MEMBER_NAME,
                <cfelseif database_type is 'DB2'>
                C.CONSUMER_NAME || ' ' || C.CONSUMER_SURNAME AS MEMBER_NAME,
                </cfif>
                C.MEMBER_CODE,
                NULL PARTNER_ID,
                ''  MEMBER_PARTNER_NAME,
                C.CONSUMER_REFERENCE_CODE
            FROM 
                CONSUMER C
            WHERE
                C.CONSUMER_STATUS = 1
            <!--- session olmadıgi zaman kayit gelmemeli kaldirma BK 20110210 --->
            <cfif not isdefined("session_base.userid")>
                AND 1=0
            </cfif>             
			<cfif isdefined("arguments.is_potantial") and arguments.is_potantial eq 1>
                AND C.ISPOTANTIAL = 1
            </cfif>
            <cfif isdefined("arguments.is_reference") and arguments.is_reference eq 1>
                AND (C.REF_POS_CODE = #session.ww.userid# OR C.CONSUMER_ID =#session.ww.userid#)
            <cfelseif isdefined("arguments.is_reference") and arguments.is_reference eq 2>
                AND C.CONSUMER_ID = #session.ww.userid#
            </cfif>
            <cfif isdefined("arguments.is_ref_order") and arguments.is_ref_order eq 1>
                AND (
                    C.CONSUMER_CAT_ID IN(SELECT CONSCAT_ID FROM CONSUMER_CAT WHERE IS_REF_ORDER = 1)
                    <cfif isdefined("session.ww.userid")>
                        OR C.CONSUMER_ID = #session.ww.userid#
                    </cfif>
                    )
            </cfif>
			<cfif isdefined("arguments.is_ref_record") and arguments.is_ref_record eq 1>
                AND (
                    C.CONSUMER_CAT_ID IN(SELECT CONSCAT_ID FROM CONSUMER_CAT WHERE IS_REF_RECORD = 1)
                    <cfif isdefined("session.ww.userid")>
                        OR C.CONSUMER_ID = #session.ww.userid#
                    </cfif>
                    )
            </cfif>	            
			<cfif isdefined("arguments.is_ref_count") and len(arguments.is_ref_count) and arguments.is_ref_count gt 0 and isdefined("session.ww.userid")>
                AND 
                (
                C.REF_POS_CODE = #session.ww.userid# OR
                (
                    C.CONSUMER_REFERENCE_CODE IS NOT NULL AND 
                    '.'+CONSUMER_REFERENCE_CODE+'.' LIKE '%.#session.ww.userid#.%' AND 
                    (LEN(REPLACE(CONSUMER_REFERENCE_CODE,'.','..'))-LEN(CONSUMER_REFERENCE_CODE)+1) < = #arguments.is_ref_count+1#
                ) OR 
                C.CONSUMER_ID = #session.ww.userid#
                )
            <cfelseif isdefined("arguments.is_ref_count") and len(arguments.is_ref_count) and arguments.is_ref_count eq 0 and isdefined("session.ww.userid")>
                AND C.CONSUMER_ID = #session.ww.userid#
            </cfif>
			<cfif len(arguments.nickname)>
            AND
            (
                C.MEMBER_CODE LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.nickname#%"> OR
                <cfif database_type is 'MSSQL'>
                C.CONSUMER_NAME + ' ' + C.CONSUMER_SURNAME LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.nickname#%">
                <cfelseif database_type is 'DB2'>
                C.CONSUMER_NAME || ' ' || C.CONSUMER_SURNAME LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.nickname#%">
                </cfif>
            )
            </cfif>
		<cfif isdefined("session.ep") and session.ep.our_company_info.sales_zone_followup eq 1>
            <!--- Satis Takimda Ekip Lideri veya Satıs Takiminda Ekipde ise ilgili IMS ler--->
            AND 
            (
                C.IMS_CODE_ID IN (
                                    SELECT
                                        IMS_ID
                                    FROM
                                        SALES_ZONES_ALL_2
                                    WHERE
                                        POSITION_CODE = #session.ep.position_code# 
                                 )
            <!--- Satis bolgeleri ekibinde veya Satis bolgesinde yonetici ise kendisi ve altindaki IMS ler--->			
            <cfif get_hierarchies.recordcount>
            OR C.IMS_CODE_ID IN (
                                    SELECT
                                        IMS_ID
                                    FROM
                                        SALES_ZONES_ALL_1
                                    WHERE											
                                        <cfloop index="page_stock" from="0" to="#(ceiling(get_hierarchies.recordcount/row_block))-1#">
                                            <cfset start_row=(page_stock*row_block)+1>	
                                            <cfset end_row=start_row+(row_block-1)>
                                            <cfif (end_row) gte get_hierarchies.recordcount>
                                                <cfset end_row=get_hierarchies.recordcount>
                                            </cfif>
                                                (
                                                <cfloop index="add_stock" from="#start_row#" to="#end_row#">
                                                    <cfif (add_stock mod row_block) neq 1> OR</cfif> SZ_HIERARCHY LIKE '#get_hierarchies.sz_hierarchy[add_stock]#%'
                                                </cfloop>
                                                
                                                )<cfif (ceiling(get_hierarchies.recordcount/row_block))-1 neq page_stock> OR</cfif>													
                                        </cfloop>											
                                )
              </cfif>						
            )
        </cfif>
        </cfif>
			ORDER BY
				MEMBER_NAME
		</cfquery>
	<cfreturn get_company_partner>
</cffunction>
