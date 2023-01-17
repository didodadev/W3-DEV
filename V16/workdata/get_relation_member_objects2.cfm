<!---Fatih A 20080919
Autocomplate iin yapildi objects2 tarafinda aranan kritere uygun tm aktif yeleri getirir
--->
<cffunction name="get_relation_member_objects2" access="public" returnType="query" output="no">
	<cfargument name="nickname" required="yes" type="string">
	<cfargument name="maxrows" required="yes" type="string" default="">
	<cfargument name="select_list" required="no" type="string" default="1,2">
	<cfargument name="is_reference" required="no" type="string" default="1">
	<cfargument name="is_potantial" required="no" type="string" default="">
	<cfargument name="is_buyer_seller" required="no" type="string" default="2">
	<cfargument name="member_status" required="no" type="string" default="1">
	<cfargument name="is_ref_order" required="no" type="string" default="0">
	<cfargument name="is_ref_count" required="no" type="string" default="0">
        
        <cfquery name="get_relation_company_partner" datasource="#dsn#">
		<cfif ListFind(arguments.select_list,1,',')>
			SELECT DISTINCT
				'partner' as MEMBER_TYPE,
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
				<cfif isdefined("session.pp")>
				AND 
                	C.COMPANY_ID IN (
								SELECT
									DISTINCT 
									CP.COMPANY_ID COMPANY_ID
								FROM
									COMPANY_PARTNER CP,
									COMPANY C
								WHERE
									CP.COMPANY_ID = C.COMPANY_ID AND		
									(
										CP.COMPANY_ID = #session.pp.company_id# OR
										C.HIERARCHY_ID = #session.pp.company_id# OR
                                        C.COMPANY_ID IN (SELECT WEP.COMPANY_ID FROM WORKGROUP_EMP_PAR WEP WHERE WEP.PARTNER_ID = #session.pp.userid#)
									)
								)
				</cfif>
			</cfif>
			<cfif ListFind(arguments.select_list,1,',') and ListFind(arguments.select_list,2,',')>
			UNION ALL
			</cfif>
			<cfif ListFind(arguments.select_list,2,',')>
				SELECT DISTINCT
					'consumer' as MEMBER_TYPE,
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
					1=1	AND
					C.CONSUMER_STATUS=1
					<cfif isdefined("arguments.is_potantial") and arguments.is_potantial eq 1>
						AND C.ISPOTANTIAL = 1
					</cfif>
					<cfif isdefined('session.ww.userid')>
						<cfif isdefined("arguments.is_reference") and arguments.is_reference eq 1>
                            AND (C.REF_POS_CODE = #session.ww.userid# OR C.CONSUMER_ID =#session.ww.userid#)
                        <cfelseif isdefined("arguments.is_reference") and arguments.is_reference eq 2>
                            AND C.CONSUMER_ID = #session.ww.userid#
                        </cfif>
                        <cfif isdefined("arguments.is_ref_order") and arguments.is_ref_order eq 1>
                            AND (
                                C.CONSUMER_CAT_ID IN(SELECT CONSCAT_ID FROM CONSUMER_CAT WHERE IS_REF_ORDER = 1)
                                <cfif isdefined("session.ww.userid")>
                                    OR 
                                    C.CONSUMER_ID =  #session.ww.userid#
                                </cfif>
                                )
                        </cfif>
                        <cfif isdefined("arguments.is_ref_count") and len(arguments.is_ref_count) and arguments.is_ref_count gt 0 and isdefined("session.ww.userid")>
                            AND 
                            (
                            C.REF_POS_CODE = #session.ww.userid#
                            OR
                            (
                                C.CONSUMER_REFERENCE_CODE IS NOT NULL
                                AND '.'+CONSUMER_REFERENCE_CODE+'.' LIKE '%.#session.ww.userid#.%'
                                AND (LEN(REPLACE(CONSUMER_REFERENCE_CODE,'.','..'))-LEN(CONSUMER_REFERENCE_CODE)+1) < = #arguments.is_ref_count+1#
                            )
                            OR 
                            C.CONSUMER_ID =#session.ww.userid#
                            )
                        <cfelseif isdefined("arguments.is_ref_count") and len(arguments.is_ref_count) and arguments.is_ref_count eq 0 and isdefined("session.ww.userid")>
                            AND C.CONSUMER_ID =#session.ww.userid#
                        </cfif>
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
					<cfif isdefined("session.pp")>
						AND C.CONSUMER_ID IN(
											SELECT
												CONSUMER_ID
											FROM
												CONSUMER
											WHERE	
												HIERARCHY_ID = #session.pp.company_id#
											)
				</cfif>
			</cfif>
			ORDER BY
				MEMBER_NAME
		</cfquery>
	<cfreturn get_relation_company_partner>
</cffunction>
