<!--- amac:gelen department_head parametresine gore DEPARTMENT_NAME,DEPARTMENT_ID,LOCATION_ID bilgisini getirmek
	  kullanim yeri:Depolar ve Lokasyonlar
	  yazan:ST
	  tarih:20081219 --->
<cfcomponent>
	<cfset dsn = application.systemParam.systemParam().dsn>
    <cffunction name="getCompenentFunction">
	<cfargument name="keyword" default="">
	<cfargument name="other_parameters" default="">
	<cfset in_group_control_ = 0>
	<cfset xml_all_depo = 0>
	<cfset parameter_name_list = ''>
	<cfset parameter_value_list = ''>
	<cfif len(arguments.other_parameters)>
		<cfloop list="#arguments.other_parameters#" delimiters="/" index="opind">
			<cfset parameter_name_list = listappend(parameter_name_list,ListGetAt(opind,1,'§'))>
			<cfif listlen(opind,'§') eq 2>
				<cfset parameter_value_list = listappend(parameter_value_list,ListGetAt(opind,2,'§'))>
			<cfelse>
				<cfset parameter_value_list = listappend(parameter_value_list,'*-*')>
			</cfif>
		</cfloop>
	</cfif>
	<cfif listlen(parameter_name_list) and listfindnocase(parameter_name_list,'is_ingroup')>
		<cfset sira_ = listfindnocase(parameter_name_list,'is_ingroup')>
		<cfset deger_ = listgetat(parameter_value_list,sira_)>
			<cfif len(deger_) and deger_ eq 1>
				<cfset in_group_control_ = 1>
			</cfif>
	</cfif>
	<cfif listlen(parameter_name_list) and listfindnocase(parameter_name_list,'xml_all_depo')>
		<cfset sira_ = listfindnocase(parameter_name_list,'xml_all_depo')>
		<cfset deger_ = listgetat(parameter_value_list,sira_)>
			<cfif len(deger_) and deger_ eq 1>
				<cfset xml_all_depo = 1>
			</cfif>
	</cfif>
		<cfquery name="get_department_location" datasource="#DSN#">
            SELECT  
                D.DEPARTMENT_ID,
                B.BRANCH_ID,
                B.COMPANY_ID,
                B.BRANCH_NAME,
                D.DEPARTMENT_HEAD,
                SL.COMMENT,
                SL.LOCATION_ID,
                D.DEPARTMENT_STATUS,
                SL.STATUS,
                D.DEPARTMENT_HEAD + ' - ' + SL.COMMENT AS LOCATION_NAME
				<cfif in_group_control_ eq 1 and listlen(parameter_name_list) and listfindnocase(parameter_name_list,'sistem_company_id')>
					<cfset sira_ = listfindnocase(parameter_name_list,'sistem_company_id')>
					<cfset deger_ = listgetat(parameter_value_list,sira_)>
					<cfif len(deger_)>
				,CP.COMPANY_ADDRESS
				,CP.COMPANY_ID AS GRP_COMP_ID
				,CP.FULLNAME
				,(SELECT TOP 1
					PARTNER_ID
				FROM
					COMPANY_PARTNER
				WHERE 
					COMPANY_PARTNER_STATUS = 1 AND
					COMPANY_ID = CP.COMPANY_ID
				ORDER BY 
					PARTNER_ID
				) AS PARTNER_ID
				,(SELECT TOP 1
					COMPANY_PARTNER_NAME
				FROM
					COMPANY_PARTNER
				WHERE 
					COMPANY_PARTNER_STATUS = 1 AND
					COMPANY_ID = CP.COMPANY_ID
				ORDER BY 
					PARTNER_ID
				) AS COMPANY_PARTNER_NAME
				,(SELECT TOP 1
					COMPANY_PARTNER_SURNAME
				FROM
					COMPANY_PARTNER
				WHERE 
					COMPANY_PARTNER_STATUS = 1 AND 
					COMPANY_ID = CP.COMPANY_ID
				ORDER BY 
					PARTNER_ID
				) AS COMPANY_PARTNER_SURNAME
					</cfif>
			  </cfif>
       		 FROM 
				<cfif in_group_control_ eq 1>
				OUR_COMPANY O,
				COMPANY CP,
				</cfif>              
			    DEPARTMENT D,
                BRANCH B,
                STOCKS_LOCATION SL
        	WHERE 
            	<cfif isDefined('session.ep')>
	                B.COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.company_id#"> AND
				<cfelseif isDefined('session.pp')>
	                B.COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.pp.our_company_id#"> AND                
                </cfif>
				D.IS_STORE <>2 AND
				B.BRANCH_ID = D.BRANCH_ID
				<cfif xml_all_depo eq 0>
					<cfif (listlen(parameter_name_list) and listfindnocase(parameter_name_list,'is_store_module')) or  session.ep.isBranchAuthorization>
						<cfset sira_ = listfindnocase(parameter_name_list,'is_store_module')>
						<cfif sira_ neq 0>
							<cfset deger_ = listgetat(parameter_value_list,sira_)>
						<cfelse>
							<cfset deger_ = 0>
						</cfif>
						<cfif deger_ eq 1 or session.ep.isBranchAuthorization>
							AND B.BRANCH_ID IN (SELECT BRANCH_ID FROM EMPLOYEE_POSITION_BRANCHES WHERE POSITION_CODE = #session.ep.position_code#)
						</cfif>
					</cfif>
				</cfif>
                AND SL.DEPARTMENT_ID=D.DEPARTMENT_ID 
                <cfif listlen(parameter_name_list) and listfindnocase(parameter_name_list,'status')>
					<cfset sira_ = listfindnocase(parameter_name_list,'status')>
					<cfset deger_ = listgetat(parameter_value_list,sira_)>
                    <cfif deger_ eq 1>
                    AND D.DEPARTMENT_STATUS = 1
                    AND SL.STATUS = 1
                   	</cfif>
                </cfif> 
                AND
                (
               	 	D.DEPARTMENT_HEAD LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#arguments.keyword#%"> OR
                    SL.COMMENT LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#arguments.keyword#%">
                )
				<cfif in_group_control_ eq 1 and listlen(parameter_name_list) and listfindnocase(parameter_name_list,'sistem_company_id')>
					<cfset sira_ = listfindnocase(parameter_name_list,'sistem_company_id')>
					<cfset deger_ = listgetat(parameter_value_list,sira_)>
						<cfif len(deger_) and deger_ is not '*-*'>
							AND O.COMP_ID = B.COMPANY_ID
							AND CP.OUR_COMPANY_ID <> #attributes.system_company_id#
							AND CP.OUR_COMPANY_ID = O.COMP_ID
						</cfif>
				</cfif>
				<cfif xml_all_depo eq 0>
					<cfif listlen(parameter_name_list) and listfindnocase(parameter_name_list,'user_level_control')>
						<cfset sira_ = listfindnocase(parameter_name_list,'user_level_control')>
						<cfset deger_ = listgetat(parameter_value_list,sira_)>
							<cfif deger_ eq 1>
								AND
									(
									CAST(D.DEPARTMENT_ID AS NVARCHAR) + '-' + CAST(SL.LOCATION_ID AS NVARCHAR) IN (SELECT LOCATION_CODE FROM EMPLOYEE_POSITION_BRANCHES WHERE POSITION_CODE = #session.ep.position_code#)
									OR
									D.DEPARTMENT_ID IN (SELECT DEPARTMENT_ID FROM EMPLOYEE_POSITION_BRANCHES WHERE POSITION_CODE = #session.ep.position_code# AND LOCATION_ID IS NULL)
									)
							</cfif>
					</cfif>
				</cfif>
				<cfif listlen(parameter_name_list) and listfindnocase(parameter_name_list,'is_delivery')>
					<cfset sira_ = listfindnocase(parameter_name_list,'is_delivery')>
					<cfset deger_ = listgetat(parameter_value_list,sira_)>
						<cfif deger_ eq 1>
							AND SL.DELIVERY = 1
						</cfif>
				</cfif>
				<cfif listlen(parameter_name_list) and listfindnocase(parameter_name_list,'location_type')>
					<cfset sira_ = listfindnocase(parameter_name_list,'location_type')>
					<cfset deger_ = replace(listgetat(parameter_value_list,sira_),';',',')>
						<cfif len(deger_) and deger_ is not '*-*'>
							AND SL.LOCATION_TYPE IN (#deger_#)
						</cfif>
				</cfif>
				<cfif listlen(parameter_name_list) and listfindnocase(parameter_name_list,'sistem_company_id')>
					<cfset sira_ = listfindnocase(parameter_name_list,'sistem_company_id')>
					<cfset deger_ = listgetat(parameter_value_list,sira_)>
						<cfif len(deger_) and deger_ is not '*-*'>
							AND B.COMPANY_ID <> #deger_#
						</cfif>
				</cfif>
                AND B.BRANCH_STATUS = 1
        ORDER BY
                LOCATION_NAME
		</cfquery>
	<cfreturn get_department_location>
	
 </cffunction>
</cfcomponent>
