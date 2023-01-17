<cfset main_sz_id = listlast(attributes.sales_zone, ',')>
<cfset main_sz_hierarchy = listfirst(attributes.sales_zone, ',')>
<cfif isdefined("attributes.county_id")>
	<cfset attributes.county_id=listdeleteduplicates(attributes.county_id)>
</cfif>
<cfif isdefined("attributes.ims_code")>
	<cfset attributes.ims_code=listdeleteduplicates(attributes.ims_code)>
</cfif>    
<cfset list_company = "">
<cfset list_consumer = "">
<cfif isdefined("attributes.member_cat_type") and len(attributes.member_cat_type)>
	<cfloop from="1" to="#listlen(attributes.member_cat_type,',')#" index="ix">
		<cfset list_getir = listgetat(attributes.member_cat_type,ix,',')>
		<cfif listfirst(list_getir,'-') eq 1 and listlast(list_getir,'-') neq 0>
			<cfset list_company = listappend(list_company,listlast(list_getir,'-'),'-')>
		<cfelseif listfirst(list_getir,'-') eq 2 and listlast(list_getir,'-') neq 0>
			<cfset list_consumer = listappend(list_consumer,listlast(list_getir,'-'),'-')>
		</cfif>
		<cfset list_company = listsort(listdeleteduplicates(replace(list_company,"-",",","all"),','),'numeric','ASC',',')>
		<cfset list_consumer = listsort(listdeleteduplicates(replace(list_consumer,"-",",","all"),','),'numeric','ASC',',')>
	</cfloop>
</cfif>
<cflock name="#CreateUUID()#" timeout="60">
	<cftransaction>
		<cfquery name="ADD_SALES_ZONES_TEAM_DETAIL" datasource="#dsn#" result="MAX_ID">
			INSERT INTO
				SALES_ZONES_TEAM
				(
					RESPONSIBLE_BRANCH_ID,
					TEAM_NAME,
					SALES_ZONES,
					OZEL_KOD,
					LEADER_POSITION_CODE,
					LEADER_POSITION_ROLE_ID,
					COUNTRY_ID,
					CITY_ID,
					<!--- COUNTY_ID,
					DISTRICT_ID, --->
					COMPANY_CAT_IDS,
					CONSUMER_CAT_IDS,
                    UPPER_TEAM_ID,
					RECORD_DATE,
					RECORD_EMP,
					RECORD_IP
				)
			VALUES
				(
					<cfif isDefined("attributes.responsible_branch_id") and len(attributes.responsible_branch_id)>#attributes.responsible_branch_id#<cfelse>0</cfif>,
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.team_name#">,
					#main_sz_id#,
					<cfif isDefined("attributes.ozel_kod") and len(attributes.ozel_kod)><cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.ozel_kod#"><cfelse>NULL</cfif>,
					<cfif len(attributes.leader_position_name) and len(attributes.leader_position_code)>#attributes.leader_position_code#,<cfelse>NULL,</cfif>
					<cfif len(attributes.leader_position_name) and len(attributes.leader_position_code) and len(attributes.leader_position_role_id)>#attributes.leader_position_role_id#<cfelse>NULL</cfif>,
					<cfif isdefined("attributes.country_id") and len(attributes.country_id)>#attributes.country_id#<cfelse>NULL</cfif>,
					<cfif isdefined("attributes.city_id") and len(attributes.city_id)>#attributes.city_id#<cfelse>NULL</cfif>,
					<!--- <cfif isdefined("attributes.county_id") and len(attributes.county_id)><cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.county_id#"><cfelse>NULL</cfif>,
					<cfif isdefined("attributes.district_id") and len(attributes.district_id)><cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.district_id#"><cfelse>NULL</cfif>, --->
					<cfif len(list_company)><cfqueryparam cfsqltype="cf_sql_varchar" value="#list_company#"><cfelse>NULL</cfif>,
					<cfif len(list_consumer)><cfqueryparam cfsqltype="cf_sql_varchar" value="#list_consumer#"><cfelse>NULL</cfif>,
                    <cfif isdefined("attributes.upper_team") and len(attributes.upper_team)>#attributes.upper_team#<cfelse>NULL</cfif>,
					#NOW()#,
					#SESSION.EP.USERID#,
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#CGI.REMOTE_ADDR#">
				)
		</cfquery>
        <cfif isdefined("attributes.upper_team") and len(attributes.upper_team) and attributes.get_upper_info eq 1>
        	<cfquery name="get_upper_info" datasource="#dsn#">
            	SELECT LEADER_POSITION_CODE,LEADER_POSITION_ROLE_ID FROM SALES_ZONES_TEAM WHERE TEAM_ID = #attributes.upper_team#
            </cfquery>
            <cfquery name="get_upper_team_roles" datasource="#dsn#">
            	SELECT ROLE_ID,POSITION_CODE FROM SALES_ZONES_TEAM_ROLES WHERE TEAM_ID = #attributes.upper_team#
            </cfquery>
        	<cfquery name="upd_from_upper" datasource="#dsn#">
            	UPDATE 
                	SALES_ZONES_TEAM
                SET 
                	LEADER_POSITION_CODE = <cfif len(get_upper_info.LEADER_POSITION_CODE)>#get_upper_info.LEADER_POSITION_CODE#<cfelse>NULL</cfif>,
					LEADER_POSITION_ROLE_ID = <cfif len(get_upper_info.LEADER_POSITION_ROLE_ID)>#get_upper_info.LEADER_POSITION_ROLE_ID#<cfelse>NULL</cfif>,
                    UPDATE_EMP=#SESSION.EP.USERID#,
                    UPDATE_DATE=#now()#
                WHERE
                	TEAM_ID = #MAX_ID.IDENTITYCOL#
            </cfquery>
            <cfif get_upper_team_roles.recordcount and (len(get_upper_team_roles.role_id) or len(get_upper_team_roles.position_code))>
            	<cfloop query="get_upper_team_roles">
                	<cfquery name="ADD_SALES_ZONES_ROLES" datasource="#dsn#">
                        INSERT INTO
                            SALES_ZONES_TEAM_ROLES
                            (
                                TEAM_ID,
                                ROLE_ID,
                                POSITION_CODE
                            )
                        VALUES
                            (
                                #MAX_ID.IDENTITYCOL#,
                                <cfif len(get_upper_team_roles.role_id)>#ROLE_ID#<cfelse>NULL</cfif>,
                                <cfif len(get_upper_team_roles.POSITION_CODE)>#POSITION_CODE#<cfelse>NULL</cfif>
                            )
                    </cfquery>
                </cfloop>
            </cfif>
        </cfif> 
		<cfif len(attributes.record_num)>
			<cfloop from="1" to="#attributes.record_num#" index="i">
				<cfif evaluate("attributes.row_kontrol#i#")>
					<cfscript>
						form_position_code = evaluate("attributes.position_code#i#");
						form_employee_name = evaluate("attributes.employee_name#i#");
						form_role_id = evaluate("attributes.role_id#i#");
					</cfscript>
					<cfif len(form_position_code) and len(form_employee_name)>
						<cfquery name="ADD_SALES_ZONES_ROLES" datasource="#dsn#">
							INSERT INTO
								SALES_ZONES_TEAM_ROLES
								(
									TEAM_ID,
									ROLE_ID,
									POSITION_CODE
								)
							VALUES
								(
									#MAX_ID.IDENTITYCOL#,
									<cfif len(form_role_id)>#form_role_id#,<cfelse>NULL,</cfif>
									#form_position_code#
								)
						</cfquery>
					</cfif>
				</cfif>
			</cfloop>
		</cfif>
		<cfif isdefined("attributes.ims_code") and listlen(attributes.ims_code)>
			<cfloop from="1" to="#listlen(attributes.ims_code,',')#" index="i">
				<cfquery name="ADD_IMS_CODE" datasource="#dsn#">
					INSERT INTO
						SALES_ZONES_TEAM_IMS_CODE
						(
							IMS_ID,
							TEAM_ID
						)
					VALUES
						(
							#listgetat(attributes.ims_code, i, ',')#,
							#MAX_ID.IDENTITYCOL#
						)
				</cfquery>
			</cfloop>
		</cfif>
        <cfif isdefined("attributes.county_id") and listlen(attributes.county_id)>
			<cfloop from="1" to="#listlen(attributes.county_id,',')#" index="i">
				<cfquery name="ADD_SALES_ZONES_TEAM_COUNTY" datasource="#dsn#">
					INSERT INTO
						SALES_ZONES_TEAM_COUNTY
						(
							COUNTY_ID,
							TEAM_ID
						)
					VALUES
						(
							#listgetat(attributes.county_id, i, ',')#,
							#MAX_ID.IDENTITYCOL#
						)
				</cfquery>
			</cfloop>
		</cfif>
        <cfif isdefined("attributes.district_id") and listlen(attributes.district_id)>
			<cfloop from="1" to="#listlen(attributes.district_id,',')#" index="i">
				<cfquery name="ADD_SALES_ZONES_TEAM_DISTRICT" datasource="#dsn#">
					INSERT INTO
						SALES_ZONES_TEAM_DISTRICT
						(
							DISTRICT_ID,
							TEAM_ID
						)
					VALUES
						(
							#listgetat(attributes.district_id, i, ',')#,
							#MAX_ID.IDENTITYCOL#
						)
				</cfquery>
			</cfloop>
		</cfif>
		<!--- Hiyerarşiye Ekleme Yapıyor --->
		<cfif main_sz_hierarchy neq 0>
			<cfset search_sz_ids = main_sz_hierarchy>
			<cfloop from="1" to="#listlen(main_sz_hierarchy, '.')#" index="i">
				<cfquery name="GET_SZ_ID" datasource="#dsn#">
					SELECT SZ_ID FROM SALES_ZONES WHERE SZ_HIERARCHY = '#search_sz_ids#'
				</cfquery>
				<cfif get_sz_id.recordcount>
					<cfquery name="ADD_HIERARCHY" datasource="#dsn#">
						INSERT INTO
							SALES_ZONES_TEAM_HIERARCHY
							(
								MAIN_SZ_ID,
								SUB_TEAM_ID
							)
						VALUES
							(
								#get_sz_id.sz_id#,
								#MAX_ID.IDENTITYCOL#
							)
					</cfquery>
				</cfif>
				<cfset search_sz_ids = listdeleteat(search_sz_ids,((listlen(main_sz_hierarchy, '.')+1)-i), '.')>
			</cfloop>
		</cfif>
		<!--- Hiyerarşiye Ekleme Yapıyor --->
	</cftransaction>
</cflock>
<script type="text/javascript">
	window.location='<cfoutput>#request.self#?fuseaction=salesplan.list_sales_team</cfoutput>';
</script>
