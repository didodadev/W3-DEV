<cfquery name="getDPLStage" datasource="#dsn#">
	SELECT TOP 1
		PTR.PROCESS_ROW_ID 
	FROM
		PROCESS_TYPE_ROWS PTR,
		PROCESS_TYPE_OUR_COMPANY PTO,
		PROCESS_TYPE PT
	WHERE
		PT.IS_ACTIVE = 1 AND
		PT.PROCESS_ID = PTR.PROCESS_ID AND
		PT.PROCESS_ID = PTO.PROCESS_ID AND
		PTO.OUR_COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.company_id#"> AND
		PT.FACTION LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%product.form_add_drawing_parts%">
	ORDER BY
		PTR.LINE_NUMBER
</cfquery>

<cfquery name="GET_DPL" datasource="#DSN#">
    SELECT 	
        DPL_ID,
        DPL_NO,
        PROJECT_ID,
        MAIN_PRODUCT_ID
    FROM 
        #dsn3_alias#.DRAWING_PART 
    WHERE 
        IS_ACTIVE = 1 AND
        DPL_NO LIKE '#attributes.asset_no# -%'
    ORDER BY 
        DPL_ID DESC 
</cfquery>
<cfset xx = "#attributes.asset_no# - #attributes.revision_no#">

<cfif not isdefined("attributes.asset_id")>
	<cfquery name="GET_MAX_ID" datasource="#DSN#">
		SELECT MAX(ASSET_ID) AS MAX_ID FROM ASSET
	</cfquery>
	<cfset attributes.asset_id = GET_MAX_ID.MAX_ID>
</cfif>
<cfset not_project_id_list ="">
<cfset project_id_list = "">
<cfif (isdefined("attributes.project_id") and len(attributes.project_id)) or (isdefined("attributes.project_multi_id") and len(attributes.project_multi_id))>
<!--- Proje secilmisse Projeler ile ilgili DPL kayitlari olusturuluyor --->
	<cfif isdefined("attributes.project_id") and len(attributes.project_id)>
		<cfloop list="#attributes.project_id#" index="k" delimiters=",">
			<cfif xx neq get_dpl.dpl_no[1] or not find(k,valuelist(get_dpl.project_id)) or attributes.product_id neq get_dpl.main_product_id[1]>
				<cfset project_id_list = listappend(project_id_list,k)>
			</cfif>
		</cfloop>
	<cfelse>
		<cfloop list="#attributes.project_multi_id#" index="k" delimiters=",">
			<cfif xx neq get_dpl.dpl_no[1] or not find(k,valuelist(get_dpl.project_id)) or attributes.product_id neq get_dpl.main_product_id[1]>
				<cfset project_id_list = listappend(project_id_list,k)>
            </cfif>
		</cfloop>
	</cfif>

	<cfset project_id_list = listdeleteduplicates(project_id_list)>
    
    <cfif isdefined("attributes.project_multi_id")>
        <cfloop list="#valuelist(get_dpl.PROJECT_ID)#" index="z" delimiters=",">
            <cfif not find(z,attributes.project_multi_id)>
                <cfset not_project_id_list = listappend(not_project_id_list,z)>
            </cfif>
        </cfloop>
    <cfelseif isdefined("attributes.project_id")>
        <cfloop list="#valuelist(get_dpl.PROJECT_ID)#" index="z" delimiters=",">
            <cfif not find(z,attributes.project_id)>
                <cfset not_project_id_list = listappend(not_project_id_list,z)>
            </cfif>
        </cfloop>
    </cfif>
	<cfif get_dpl.recordcount and xx neq get_dpl.dpl_no[1]>
        <cfquery name="PASSIVE_DPL" datasource="#DSN#">
            UPDATE 
                #dsn3_alias#.DRAWING_PART 
            SET 
                IS_ACTIVE = 0 
            WHERE 
                DPL_ID IN (#valuelist(get_dpl.dpl_id,',')#) AND
                (
					<cfif (attributes.product_id neq get_dpl.main_product_id[1] or (attributes.product_id eq get_dpl.main_product_id[1] and xx neq get_dpl.dpl_no[1])) and isdefined("attributes.live")>
        	              PROJECT_ID IN (#project_id_list#) OR PROJECT_ID IS NULL
                    <cfelseif (attributes.product_id neq get_dpl.main_product_id[1] or (attributes.product_id eq get_dpl.main_product_id[1] and xx neq get_dpl.dpl_no[1])) and not isdefined("attributes.live")>
        	              PROJECT_ID IS NULL                    
					</cfif>
                )
        </cfquery>
    <cfelseif xx eq get_dpl.dpl_no[1] and len(not_project_id_list)>
    	<cfquery name="PASSIVE_DPL" datasource="#DSN#">
            UPDATE 
                #dsn3_alias#.DRAWING_PART 
            SET 
                IS_ACTIVE = 0 
            WHERE 
                DPL_ID IN (#valuelist(get_dpl.dpl_id,',')#)
                AND PROJECT_ID IN (#not_project_id_list#) 
        </cfquery>
    </cfif>
	<cfif (xx neq get_dpl.dpl_no[1] or attributes.product_id neq get_dpl.main_product_id[1]) and isdefined("attributes.live")><!--- Ana rnle iliskili DPL olusturuluyor  --->
		<cfquery name="INSERT_DPL" datasource="#DSN#">
			INSERT INTO
				#dsn3_alias#.DRAWING_PART
				(
					DPL_NO,
					STAGE_ID,
					MAIN_PRODUCT_ID,
					PROJECT_ID,
					ASSET_ID,
					QUANTITY,
					IS_ACTIVE,
					IS_MAIN_DPL,
					IS_YRM,
					RECORD_DATE,
					RECORD_EMP,
					RECORD_IP
				)
			VALUES
				(
					'#attributes.asset_no# - #attributes.revision_no#',
					#getDPLStage.PROCESS_ROW_ID#,
					<cfif isdefined('attributes.product_id') and len(attributes.product_id)>#attributes.product_id#<cfelse>NULL</cfif>,
					NULL,
					<cfif isdefined("attributes.asset_id") and len(attributes.asset_id)>#attributes.asset_id#<cfelse>#get_max_id.max_id#</cfif>,
					1,<!--- quantity --->
					1,
					1,
					<cfif isdefined('attributes.featured')>1<cfelse>0</cfif>,
					#now()#,
					#session.ep.userid#,
					'#cgi.remote_addr#'
				)
		</cfquery>
		<cfif get_dpl.recordcount><!--- Revizyondan geliyorsa Ana rnle iliskili DPL satirlari olusturuluyor --->
			<cfquery name="GET_MAX_DPL" datasource="#DSN#">
				SELECT MAX(DPL_ID) DPL_ID FROM #dsn3_alias#.DRAWING_PART
			</cfquery>
			
			<cfquery name="DUBLICATE_DPL_ROWS" datasource="#DSN#"><!--- Ana rnle iliskili DPL satirlari olusturuluyor --->
				INSERT INTO
					#dsn3_alias#.DRAWING_PART_ROW
				(
					DPL_ID,
					PRODUCT_ID,
					STOCK_ID,
					QUANTITY,
					PBS_ID,
					WORK_ID,
					UNIT,
					UNIT_ID,
					IS_ACTIVE,
					WRK_ROW_ID
				)                
				SELECT
					#get_max_dpl.dpl_id#,
					PRODUCT_ID,
					STOCK_ID,
					QUANTITY,
					PBS_ID,
					NULL,
					UNIT,
					UNIT_ID,
					1,
					WRK_ROW_ID
				FROM
					#dsn3_alias#.DRAWING_PART_ROW
				WHERE
					DPL_ID = #get_dpl.dpl_id[1]#	
			</cfquery>
		</cfif>
    </cfif>
    <cfif len(project_id_list)><!--- Projeler ile ilgili DPL ve DPL_ROW kayitlari olusturuluyor --->
        <cfloop list="#project_id_list#" index="k" delimiters=",">
            <cfif get_dpl.recordcount>
                
                <cfquery name="GET_DPL_ID_" dbtype="query">
                    SELECT * FROM GET_DPL WHERE PROJECT_ID = #k#
                </cfquery>
				<cfif GET_DPL_ID_.recordcount>
                    <cfquery name="DUBLICATE_DPL" datasource="#DSN#"><!--- Projeler ile ilgili DPL kayitlari olusturuluyor --->
                        INSERT INTO
                            #dsn3_alias#.DRAWING_PART 
                            (
                                DPL_NO,
                                STAGE_ID,
                                MAIN_PRODUCT_ID,
                                PROJECT_ID,
                                ASSET_ID,
                                DPL_PRODUCT_ID,
                                QUANTITY,
                                IS_ACTIVE,
                                IS_MAIN_DPL,
                                IS_YRM,
                                RECORD_DATE,
                                RECORD_EMP,
                                RECORD_IP
                            )
                            SELECT 
                                '#attributes.asset_no# - #attributes.revision_no#',
                                STAGE_ID,
                                MAIN_PRODUCT_ID,
                                #k#,
                                <cfif isdefined("attributes.asset_id") and len(attributes.asset_id)>#attributes.asset_id#<cfelse>#get_max_id.max_id#</cfif>,<!--- Asset eklendikten sonra calisan query den geliyor--->
                                DPL_PRODUCT_ID,
                                1,
                                1,
                                IS_MAIN_DPL,
                                IS_YRM,
                                #now()#,
                                #session.ep.userid#,
                                '#CGI.REMOTE_ADDR#'
                            FROM
                                #dsn3_alias#.DRAWING_PART
                            WHERE
                                DPL_ID = #get_dpl_id_.dpl_id#
                    </cfquery>
               <cfelse>
                    <cfquery name="DUBLICATE_DPL" datasource="#DSN#"><!--- Daha nceden ilgili proje den DPL olusturulmamissa --->
                        INSERT INTO
                            #dsn3_alias#.DRAWING_PART 
                            (
                                DPL_NO,
                                STAGE_ID,
                                MAIN_PRODUCT_ID,
                                PROJECT_ID,
                                ASSET_ID,
                                DPL_PRODUCT_ID,
                                QUANTITY,
                                IS_ACTIVE,
                                IS_MAIN_DPL,
                                IS_YRM,
                                RECORD_DATE,
                                RECORD_EMP,
                                RECORD_IP
                            )
                            SELECT 
                                '#attributes.asset_no# - #attributes.revision_no#',
                                STAGE_ID,
                                MAIN_PRODUCT_ID,
                                #k#,
                                <cfif isdefined("attributes.asset_id") and len(attributes.asset_id)>#attributes.asset_id#<cfelse>#get_max_id.max_id#</cfif>,<!--- Asset eklendikten sonra calisan query den geliyor--->
                                DPL_PRODUCT_ID,
                                1,
                                1,
                                IS_MAIN_DPL,
                                IS_YRM,
                                #now()#,
                                #session.ep.userid#,
                                '#CGI.REMOTE_ADDR#'
                            FROM
                                #dsn3_alias#.DRAWING_PART
                            WHERE
                                DPL_ID = #get_dpl.dpl_id[1]#
                    </cfquery>
                </cfif>
				<cfquery name="GET_MAX_DPL" datasource="#DSN#">
					SELECT MAX(DPL_ID) DPL_ID FROM #dsn3_alias#.DRAWING_PART
				</cfquery>

				<cfif attributes.is_copy_dpl eq 1 and len(get_dpl.dpl_id[1]) and GET_DPL_ID_.recordcount>
					<cfquery name="DUBLICATE_DPL_ROWS" datasource="#DSN#">
						INSERT INTO
							#dsn3_alias#.DRAWING_PART_ROW
							(
								DPL_ID,
								PRODUCT_ID,
								STOCK_ID,
								QUANTITY,
								PBS_ID,
								WORK_ID,
								UNIT,
								UNIT_ID,
								IS_ACTIVE,
								WRK_ROW_ID
							)                
						SELECT
							#get_max_dpl.dpl_id#,
							PRODUCT_ID,
							STOCK_ID,
							QUANTITY,
							PBS_ID,
							WORK_ID,
							UNIT,
							UNIT_ID,
							1,
							WRK_ROW_ID
						FROM
							#dsn3_alias#.DRAWING_PART_ROW
						WHERE
							DPL_ID = #GET_DPL_ID_.dpl_id#	
					</cfquery>
					
					<cfquery name="GET_WORK" datasource="#DSN#">
						SELECT 
							INTERNAL_ID,
							PRO_WORKS.WORK_NO
						 FROM 
							#dsn3_alias#.INTERNALDEMAND ID,
							PRO_WORKS
						 WHERE 
							ID.WORK_ID = PRO_WORKS.WORK_ID AND
							PRO_WORKS.WORK_ID IN (SELECT WORK_ID FROM #dsn3_alias#.DRAWING_PART_ROW WHERE DPL_ID = #GET_DPL_ID_.dpl_id#)  AND
							DPL_ID = #get_dpl_id_.dpl_id#
					</cfquery>
					<cfif get_work.recordcount>
						<cfoutput query="get_work">
							<cfquery name="UPD_INT_DEMAND" datasource="#DSN#">
								UPDATE #dsn3_alias#.INTERNALDEMAND SET DPL_ID = #get_max_dpl.dpl_id#, SUBJECT = '#GET_WORK.WORK_NO#-#xx#' WHERE INTERNAL_ID =#GET_WORK.INTERNAL_ID#
							</cfquery>
						</cfoutput>
					</cfif>
				</cfif>
            <cfelse>
				<cfquery name="INSERT_DPL" datasource="#DSN#">
					INSERT INTO
						#dsn3_alias#.DRAWING_PART
						(
							DPL_NO,
							STAGE_ID,
							MAIN_PRODUCT_ID,
							PROJECT_ID,
							ASSET_ID,
							QUANTITY,
							IS_ACTIVE,
							IS_MAIN_DPL,
							IS_YRM,
							RECORD_DATE,
							RECORD_EMP,
							RECORD_IP
						)
					VALUES
						(
							'#attributes.asset_no# - #attributes.revision_no#',
							#getDPLStage.PROCESS_ROW_ID#,
							<cfif isdefined('attributes.product_id') and len(attributes.product_id)>#attributes.product_id#<cfelse>NULL</cfif>,
							#k#,
							<cfif isdefined("attributes.asset_id") and len(attributes.asset_id)>#attributes.asset_id#<cfelse>#get_max_id.max_id#</cfif>,
							1,<!--- quantity --->
							1,
							1,
							<cfif isdefined('attributes.featured')>1<cfelse>0</cfif>,
							#now()#,
							#session.ep.userid#,
							'#cgi.remote_addr#'
						)
				</cfquery>
            </cfif>
        </cfloop>
	</cfif>
<cfelse><!--- Proje his secilmemisse sadece ana urun ile ilgili DPL olusturuluyor --->
	<cfif xx neq get_dpl.dpl_no[1] or attributes.product_id neq get_dpl.main_product_id[1]>
    	<cfif get_dpl.recordcount and xx neq get_dpl.dpl_no[1]>
            <cfquery name="PASSIVE_DPL" datasource="#DSN#">
                UPDATE 
                    #dsn3_alias#.DRAWING_PART 
                SET 
                    IS_ACTIVE = 0 
                WHERE 
                    DPL_ID IN (#valuelist(get_dpl.dpl_id,',')#) AND
                    PROJECT_ID IS NULL
            </cfquery>
	    </cfif>
			<cfif isdefined("attributes.live")>
                    <cfquery name="INSERT_DPL" datasource="#DSN#">
                        INSERT INTO
                            #dsn3_alias#.DRAWING_PART
                            (
                            DPL_NO,
                            STAGE_ID,
                            MAIN_PRODUCT_ID,
                            PROJECT_ID,
                            ASSET_ID,
                            QUANTITY,
                            IS_ACTIVE,
                            IS_MAIN_DPL,
							IS_YRM,
                            RECORD_DATE,
                            RECORD_EMP,
                            RECORD_IP
                            )
                        VALUES
                            (
                            '#attributes.asset_no# - #attributes.revision_no#',
                            #getDPLStage.PROCESS_ROW_ID#,
                            <cfif isdefined('attributes.product_id') and len(attributes.product_id)>#attributes.product_id#<cfelse>NULL</cfif>,
                            NULL,
                            <cfif isdefined("attributes.asset_id") and len(attributes.asset_id)>#attributes.asset_id#<cfelse>#get_max_id.max_id#</cfif>,
                            1,<!--- quantity --->
                            1,
                            1,
							<cfif isdefined('attributes.featured')>1<cfelse>0</cfif>,
                            #now()#,
                            #session.ep.userid#,
                            '#cgi.remote_addr#'
                            )
                    </cfquery>
                    
                    <cfquery name="GET_MAX_DPL" datasource="#DSN#">
                        SELECT MAX(DPL_ID) DPL_ID FROM #dsn3_alias#.DRAWING_PART
                    </cfquery>
                    
                    <cfif attributes.is_copy_dpl eq 1  and len(get_dpl.dpl_id[1])>
                        <cfquery name="DUBLICATE_DPL_ROWS" datasource="#DSN#">
                            INSERT INTO
                                #dsn3_alias#.DRAWING_PART_ROW
                                (
                                    DPL_ID,
                                    PRODUCT_ID,
                                    STOCK_ID,
                                    QUANTITY,
                                    PBS_ID,
                                    WORK_ID,
									UNIT,
									UNIT_ID,
                                    IS_ACTIVE,
                                    WRK_ROW_ID
                                )                
                            SELECT
                                #get_max_dpl.dpl_id#,
                                PRODUCT_ID,
                                STOCK_ID,
                                QUANTITY,
                                PBS_ID,
                                WORK_ID,
								UNIT,
								UNIT_ID,
                                1,
                                WRK_ROW_ID
                            FROM
                                #dsn3_alias#.DRAWING_PART_ROW
                            WHERE
                                DPL_ID = #get_dpl.dpl_id[1]#	
                        </cfquery>
                    </cfif>
                
        </cfif>
    </cfif>
</cfif>
<cfif not isdefined("attributes.is_active") and get_dpl.recordcount><!--- Ilgili dijital varlik aktif degilse ilgili dplleri pasif yapar --->
    <cfquery name="PASSIVE_DPL" datasource="#DSN#">
        UPDATE 
            #dsn3_alias#.DRAWING_PART 
        SET 
            IS_ACTIVE = 0 
        WHERE 
            DPL_ID IN (#valuelist(get_dpl.dpl_id,',')#)
    </cfquery>
</cfif>
<cfif not isdefined("attributes.live") and get_dpl.recordcount><!--- Ilgili dijital varlik aktif degilse ilgili dplleri pasif yapar --->
    <cfquery name="PASSIVE_DPL" datasource="#DSN#">
        UPDATE 
            #dsn3_alias#.DRAWING_PART 
        SET 
            IS_ACTIVE = 0 
        WHERE 
            DPL_ID IN (#valuelist(get_dpl.dpl_id,',')#)
    </cfquery>
</cfif>

<cfif isdefined("attributes.live")>
	<cfquery name="get_asset_active" datasource="#DSN#">
		SELECT ASSET_ID FROM ASSET WHERE LIVE = 1 AND ASSET_NO = '#attributes.asset_no#' AND ASSET_ID <> #attributes.asset_id#
	</cfquery>
	<cfif get_asset_active.recordcount>
		<cfquery name="UPDATE_" datasource="#DSN#">
			UPDATE ASSET SET LIVE = 0 WHERE ASSET_ID IN (#valuelist(get_asset_active.asset_id)#)
		</cfquery>
	</cfif>
</cfif>

