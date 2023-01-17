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
<cfquery name="del_county" datasource="#dsn#">
    DELETE FROM SALES_ZONES_TEAM_COUNTY WHERE TEAM_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.TEAM_ID#"> 
</cfquery>
<cfif isdefined("attributes.county_id") and len(attributes.county_id)>
    <cfquery name="ADD_SALES_ZONES_TEAM_COUNTY" datasource="#dsn#" result="xx">
        <cfloop from="1" to="#listlen(attributes.county_id,',')#" index="i">
        INSERT INTO
            SALES_ZONES_TEAM_COUNTY
            (
                COUNTY_ID,
                TEAM_ID
            )
        VALUES
            (
                #listgetat(attributes.county_id, i, ',')#,
                #attributes.team_id#
            )
        </cfloop>
	</cfquery>
</cfif>
<cfquery name="del_district" datasource="#dsn#">
   DELETE FROM SALES_ZONES_TEAM_DISTRICT WHERE TEAM_ID =<cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.TEAM_ID#">
</cfquery>
<cfif isdefined("attributes.district_id") and len(attributes.district_id)>
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
                #attributes.team_id#
            )
     </cfquery>
  </cfloop>
</cfif>
<cflock name="#CreateUUID()#" timeout="60">
	<cftransaction>
		<cfquery name="ADD_SALES_ZONES_TEAM_DETAIL" datasource="#dsn#">
			UPDATE
				SALES_ZONES_TEAM
			SET
            RESPONSIBLE_BRANCH_ID = <cfif isDefined('attributes.responsible_branch_id') And len(attributes.responsible_branch_id)>#attributes.responsible_branch_id#,<cfelse>NULL,</cfif>
				TEAM_NAME = <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.team_name#">,
				SALES_ZONES = #main_sz_id#,
				LEADER_POSITION_CODE = <cfif len(attributes.leader_position_name) and len(attributes.leader_position_code)>#attributes.leader_position_code#,<cfelse>NULL,</cfif>
				LEADER_POSITION_ROLE_ID = <cfif len(attributes.leader_position_name) and len(attributes.leader_position_code) and len(attributes.leader_position_role_id)>#attributes.leader_position_role_id#,<cfelse>NULL,</cfif>
				OZEL_KOD = <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.ozel_kod#">,
				COUNTRY_ID = <cfif isdefined("attributes.country_id") and len(attributes.country_id)>#attributes.country_id#<cfelse>NULL</cfif>,
				CITY_ID = <cfif isdefined("attributes.city_id") and len(attributes.city_id)>#attributes.city_id#<cfelse>NULL</cfif>,
				<!--- COUNTY_ID = <cfif isdefined("attributes.county_id") and len(attributes.county_id)><cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.county_id#"><cfelse>NULL</cfif>,
				DISTRICT_ID = <cfif isdefined("attributes.district_id") and len(attributes.district_id)><cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.district_id#"><cfelse>NULL</cfif>, --->
				COMPANY_CAT_IDS=<cfif len(list_company)><cfqueryparam cfsqltype="cf_sql_varchar" value="#list_company#"><cfelse>NULL</cfif>,
				CONSUMER_CAT_IDS=<cfif len(list_consumer)><cfqueryparam cfsqltype="cf_sql_varchar" value="#list_consumer#"><cfelse>NULL</cfif>,
                UPPER_TEAM_ID=<cfif isdefined("attributes.upper_team") and len(attributes.upper_team)>#attributes.upper_team#<cfelse>NULL</cfif>,
				UPDATE_EMP=#SESSION.EP.USERID#,
				UPDATE_DATE=#now()#
			WHERE
				TEAM_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.TEAM_ID#">
		</cfquery>
        <cfif attributes.upd_sub_teams eq 1><!---Alt takımları güncelliyor py--->
            <cfquery name="get_sub_teams" datasource="#dsn#">
                SELECT
                    A.TEAM_ID
                FROM 
                    SALES_ZONES_TEAM A,
                    SALES_ZONES_TEAM B
                WHERE 
                    A.UPPER_TEAM_ID = B.TEAM_ID 
                    AND A.UPPER_TEAM_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.TEAM_ID#">
            </cfquery>
            <cfset sub_team_id = valuelist(get_sub_teams.TEAM_ID)>
            <cfif get_sub_teams.recordcount>
                <cfquery name="upd_sub_teams" datasource="#dsn#">
                    UPDATE
                        SALES_ZONES_TEAM
                    SET
                        LEADER_POSITION_CODE = <cfif len(attributes.leader_position_name) and len(attributes.leader_position_code)>#attributes.leader_position_code#,<cfelse>NULL,</cfif>
                        LEADER_POSITION_ROLE_ID = <cfif len(attributes.leader_position_name) and len(attributes.leader_position_code) and len(attributes.leader_position_role_id)>#attributes.leader_position_role_id#,<cfelse>NULL,</cfif>
                        UPDATE_EMP=#SESSION.EP.USERID#,
                        UPDATE_DATE=#now()#
                    WHERE
                        TEAM_ID IN (#sub_team_id#)
                </cfquery>
            </cfif>
			<cfif get_sub_teams.recordcount>
                <cfquery name="DEL_TEAM" datasource="#dsn#">
                    DELETE FROM SALES_ZONES_TEAM_ROLES WHERE TEAM_ID IN (#sub_team_id#)
                </cfquery>
            </cfif>
        </cfif>
		<cfquery name="DEL_TEAM" datasource="#dsn#">
			DELETE FROM SALES_ZONES_TEAM_ROLES WHERE TEAM_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.TEAM_ID#">
		</cfquery>
		<cfquery name="DEL_TEAM_IMS" datasource="#dsn#">
			DELETE FROM SALES_ZONES_TEAM_IMS_CODE WHERE TEAM_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.TEAM_ID#">
		</cfquery>
        <!---Üst Takımdan DEğerleri Alıyor py --->
        <cfif isdefined("attributes.upper_team") and len(attributes.upper_team) and attributes.get_upper_info eq 1>
        	<cfquery name="get_upper_info" datasource="#dsn#">
            	SELECT LEADER_POSITION_CODE,LEADER_POSITION_ROLE_ID FROM SALES_ZONES_TEAM WHERE TEAM_ID =<cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.upper_team#">
            </cfquery>
            <cfquery name="get_upper_team_roles" datasource="#dsn#">
            	SELECT ROLE_ID,POSITION_CODE FROM SALES_ZONES_TEAM_ROLES WHERE TEAM_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.TEAM_ID#">
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
                	TEAM_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.TEAM_ID#">
            </cfquery>
            <cfif get_upper_team_roles.recordcount>
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
                                #attributes.team_id#,
                                <cfif len(get_upper_team_roles.role_id)>#ROLE_ID#<cfelse>NULL</cfif>,
                                <cfif len(get_upper_team_roles.position_code)>#POSITION_CODE#<cfelse>NULL</cfif>
                            )
                    </cfquery>
                </cfloop>
            </cfif>
        </cfif> 
		<cfif len(attributes.record_num) and attributes.record_num neq "">
			<cfloop from="1" to="#attributes.record_num#" index="i">
				<cfif evaluate("attributes.row_kontrol#i#")>
					<cfscript>
						form_position_code = evaluate("attributes.position_code#i#");
						form_employee_name = evaluate("attributes.employee_name#i#");
						form_role_id = evaluate("attributes.role_id#i#");
					</cfscript>
					<cfif len(form_position_code) and len(form_employee_name) and isdefined("attributes.get_upper_info") and attributes.get_upper_info eq 0>
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
                                #attributes.team_id#,
                                <cfif len(form_role_id)>#form_role_id#,<cfelse>null,</cfif>
                                #form_position_code#
                            )
						</cfquery>
                        <cfif attributes.upd_sub_teams eq 1>
							<cfif get_sub_teams.recordcount>
                                <cfloop list="#sub_team_id#" index="i">
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
                                            #i#,
                                            <cfif len(form_role_id)>#form_role_id#,<cfelse>NULL,</cfif>
                                            #form_position_code#
                                        )
                                    </cfquery>
                                </cfloop>
                            </cfif>
                       </cfif>
					</cfif>
				</cfif>
			</cfloop>
		</cfif>
		<cfif isdefined("attributes.ims_code") and len(attributes.ims_code)>
			<cfif attributes.ims_code neq ' '>
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
                            #attributes.team_id#
                        )
                    </cfquery>
                </cfloop>
            </cfif>
		</cfif>
		<!--- Hiyerarşiye Ekleme Yapıyor --->
		<cfquery name="DEL_HIERARCHY" datasource="#dsn#">
			DELETE FROM SALES_ZONES_TEAM_HIERARCHY WHERE SUB_TEAM_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.TEAM_ID#">
		</cfquery>
		<cfif main_sz_hierarchy neq 0>
			<cfset search_sz_ids = main_sz_hierarchy>
			<cfloop from="1" to="#listlen(main_sz_hierarchy, '.')#" index="i">
				<cfquery name="GET_SZ_ID" datasource="#dsn#">
					SELECT SZ_ID FROM SALES_ZONES WHERE SZ_HIERARCHY = <cfqueryparam cfsqltype="cf_sql_varchar" value="#search_sz_ids#">
				</cfquery>
				<cfif get_sz_id.recordcount>
					<cfquery name="ADD_HIERARCHY" datasource="#dsn#">
						INSERT
						INTO
							SALES_ZONES_TEAM_HIERARCHY
							(
								MAIN_SZ_ID,
								SUB_TEAM_ID
							)
							VALUES
							(
								#get_sz_id.sz_id#,
								#attributes.team_id#
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
	window.location='<cfoutput>#request.self#?fuseaction=salesplan.list_sales_team&event=upd&sz_id=#attributes.sz_id#</cfoutput>'
</script>
