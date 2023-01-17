<cfquery name="get_cons_cat" datasource="#dsn#">
	SELECT * FROM CONSUMER_CAT WHERE IS_PREMIUM = 0 ORDER BY HIERARCHY
</cfquery>
<cfquery name="get_cons_cats" datasource="#dsn#">
	SELECT * FROM CONSUMER_CAT WHERE IS_PREMIUM = 0 ORDER BY HIERARCHY
</cfquery>
<cflock name="#CreateUUID()#" timeout="20">
	<cftransaction>
		<cfif not isdefined("attributes.catalog_segment_id")><!--- Ekleme --->
			<cfoutput query="get_cons_cat">
				<cfset conscat_id_ = get_cons_cat.conscat_id>
				<cfset min_personal_sale = evaluate("attributes.min_personal_sale#currentrow#")>
				<cfset ref_member_count = evaluate("attributes.ref_member_count#currentrow#")>
				<cfset min_ref_member_sale = evaluate("attributes.min_ref_member_sale#currentrow#")>
				<cfif min_personal_sale gt 0 or ref_member_count gt 0 or min_ref_member_sale gt 0 or evaluate("attributes.campaign_count#currentrow#") gt 0>
					<cfquery name="add_segment" datasource="#dsn3#">
						INSERT INTO
							SETUP_CONSCAT_SEGMENTATION
							(
								<cfif isdefined("attributes.campaign_id")>
									CAMPAIGN_ID,
								<cfelseif isdefined("attributes.catalog_id")>
									CATALOG_ID,
								<cfelseif isdefined("attributes.promotion_id")>	
									PROMOTION_ID,
								<cfelseif isdefined("attributes.prom_rel_id")>	
									PROM_REL_ID,
								</cfif>
								CONSCAT_ID,
								MIN_PERSONAL_SALE,
								IS_PERSONAL_PRIM,
								REF_MEMBER_COUNT,
								ACTIVE_MEMBER_CONDITION,
								REF_MEMBER_SALE,
								GROUP_SALE,
								CAMPAIGN_COUNT,
								RECORD_EMP,
								RECORD_IP,
								RECORD_DATE
							)
							VALUES
							(
								<cfif isdefined("attributes.campaign_id")>
									#attributes.campaign_id#,
								<cfelseif isdefined("attributes.catalog_id")>
									#attributes.catalog_id#,
								<cfelseif isdefined("attributes.promotion_id")>	
									#attributes.promotion_id#,
								<cfelseif isdefined("attributes.prom_rel_id")>	
									#attributes.prom_rel_id#,
								</cfif>
								#evaluate("attributes.consumer_catid#currentrow#")#,
								#evaluate("attributes.min_personal_sale#currentrow#")#,
								<cfif isdefined("attributes.is_prim_sale#currentrow#")>1<cfelse>0</cfif>,
								#evaluate("attributes.ref_member_count#currentrow#")#,
								#evaluate("attributes.active_member_condition#currentrow#")#,
								#evaluate("attributes.min_ref_member_sale#currentrow#")#,
								#evaluate("attributes.min_group_sale#currentrow#")#,
								#evaluate("attributes.campaign_count#currentrow#")#,
								#session.ep.userid#,
								'#cgi.remote_addr#',
								#now()#						
							)
					</cfquery>
					<cfquery name="get_max_id" datasource="#dsn3#">
						SELECT MAX(CONSCAT_SEGMENT_ID) AS MAX_ID FROM SETUP_CONSCAT_SEGMENTATION
					</cfquery>
					<cfloop query="get_cons_cats">
						<cfset row_member_count = evaluate("attributes.member_count_row#conscat_id_#_#get_cons_cats.currentrow#")>
						<cfif row_member_count gt 0>
							<cfquery name="add_segment_row" datasource="#dsn3#">
								INSERT INTO
									SETUP_CONSCAT_SEGMENTATION_ROWS
									(
										CONSCAT_SEGMENT_ID,
										CONSCAT_ID,
										ROW_MEMBER_COUNT
									)
									VALUES
									(
										#get_max_id.max_id#,
										#evaluate("attributes.consumer_cat_row_id#conscat_id_#_#get_cons_cats.currentrow#")#,
										#evaluate("attributes.member_count_row#conscat_id_#_#get_cons_cats.currentrow#")#										
									)
							</cfquery>
						</cfif>
					</cfloop>
				</cfif>
			</cfoutput>
		<cfelse><!--- Güncelleme --->
			<cfoutput query="get_cons_cat">
				<cfset conscat_id_ = get_cons_cat.conscat_id>
				<cfif isdefined("attributes.campaign_id")>
					<cfquery name="get_segment" datasource="#dsn3#">
						SELECT * FROM SETUP_CONSCAT_SEGMENTATION WHERE CAMPAIGN_ID = #attributes.campaign_id# AND CONSCAT_ID = #evaluate("attributes.consumer_catid#currentrow#")#
					</cfquery>
				<cfelseif isdefined("attributes.catalog_id")>
					<cfquery name="get_segment" datasource="#dsn3#">
						SELECT * FROM SETUP_CONSCAT_SEGMENTATION WHERE CATALOG_ID = #attributes.catalog_id# AND CONSCAT_ID = #evaluate("attributes.consumer_catid#currentrow#")#
					</cfquery>
				<cfelseif isdefined("attributes.promotion_id")>	
					<cfquery name="get_segment" datasource="#dsn3#">
						SELECT * FROM SETUP_CONSCAT_SEGMENTATION WHERE PROMOTION_ID = #attributes.promotion_id# AND CONSCAT_ID = #evaluate("attributes.consumer_catid#currentrow#")#
					</cfquery>
				<cfelseif isdefined("attributes.prom_rel_id")>	
					<cfquery name="get_segment" datasource="#dsn3#">
						SELECT * FROM SETUP_CONSCAT_SEGMENTATION WHERE PROM_REL_ID = #attributes.prom_rel_id# AND CONSCAT_ID = #evaluate("attributes.consumer_catid#currentrow#")#
					</cfquery>
				</cfif>
				<cfset min_personal_sale = evaluate("attributes.min_personal_sale#currentrow#")>
				<cfset ref_member_count = evaluate("attributes.ref_member_count#currentrow#")>
				<cfset min_ref_member_sale = evaluate("attributes.min_ref_member_sale#currentrow#")>
				<cfif min_personal_sale gt 0 or ref_member_count gt 0 or min_ref_member_sale gt 0 or evaluate("attributes.campaign_count#currentrow#") gt 0>
					<cfif get_segment.recordcount gt 0>
						<cfquery name="upd_segment" datasource="#dsn3#">
							UPDATE
								SETUP_CONSCAT_SEGMENTATION
							SET
								MIN_PERSONAL_SALE = #evaluate("attributes.min_personal_sale#currentrow#")#,
								IS_PERSONAL_PRIM = <cfif isdefined("attributes.is_prim_sale#currentrow#")>1<cfelse>0</cfif>,
								REF_MEMBER_COUNT = #evaluate("attributes.ref_member_count#currentrow#")#,
								ACTIVE_MEMBER_CONDITION = #evaluate("attributes.active_member_condition#currentrow#")#,
								REF_MEMBER_SALE = #evaluate("attributes.min_ref_member_sale#currentrow#")#,
								GROUP_SALE =  #evaluate("attributes.min_group_sale#currentrow#")#,
								CAMPAIGN_COUNT = #evaluate("attributes.campaign_count#currentrow#")#,
								UPDATE_EMP = #session.ep.userid#,
								UPDATE_IP = '#cgi.remote_addr#',
								UPDATE_DATE = #now()#	
							WHERE
								CONSCAT_SEGMENT_ID = #get_segment.conscat_segment_id#
						</cfquery>
						<cfquery name="del_segment_rows" datasource="#dsn3#">
							DELETE FROM SETUP_CONSCAT_SEGMENTATION_ROWS WHERE CONSCAT_SEGMENT_ID = #get_segment.conscat_segment_id#
						</cfquery>
						<cfloop query="get_cons_cats">
							<cfset row_member_count = evaluate("attributes.member_count_row#conscat_id_#_#get_cons_cats.currentrow#")>
							<cfif row_member_count gt 0>
								<cfquery name="add_segment_row" datasource="#dsn3#">
									INSERT INTO
										SETUP_CONSCAT_SEGMENTATION_ROWS
										(
											CONSCAT_SEGMENT_ID,
											CONSCAT_ID,
											ROW_MEMBER_COUNT
										)
										VALUES
										(
											#get_segment.conscat_segment_id#,
											#evaluate("attributes.consumer_cat_row_id#conscat_id_#_#get_cons_cats.currentrow#")#,
											#evaluate("attributes.member_count_row#conscat_id_#_#get_cons_cats.currentrow#")#										
										)
								</cfquery>
							</cfif>
						</cfloop>
					<cfelse>
						<cfquery name="add_segment" datasource="#dsn3#">
							INSERT INTO
								SETUP_CONSCAT_SEGMENTATION
								(
									<cfif isdefined("attributes.campaign_id")>
										CAMPAIGN_ID,
									<cfelseif isdefined("attributes.catalog_id")>
										CATALOG_ID,
									<cfelseif isdefined("attributes.promotion_id")>	
										PROMOTION_ID,
									<cfelseif isdefined("attributes.prom_rel_id")>	
										PROM_REL_ID,
									</cfif>
									CONSCAT_ID,
									MIN_PERSONAL_SALE,
									IS_PERSONAL_PRIM,
									REF_MEMBER_COUNT,
									ACTIVE_MEMBER_CONDITION,
									REF_MEMBER_SALE,
									GROUP_SALE,
									CAMPAIGN_COUNT,
									RECORD_EMP,
									RECORD_IP,
									RECORD_DATE
								)
								VALUES
								(
									<cfif isdefined("attributes.campaign_id")>
										#attributes.campaign_id#,
									<cfelseif isdefined("attributes.catalog_id")>
										#attributes.catalog_id#,
									<cfelseif isdefined("attributes.promotion_id")>	
										#attributes.promotion_id#,
									<cfelseif isdefined("attributes.prom_rel_id")>	
										#attributes.prom_rel_id#,
									</cfif>
									#evaluate("attributes.consumer_catid#currentrow#")#,
									#evaluate("attributes.min_personal_sale#currentrow#")#,
									<cfif isdefined("attributes.is_prim_sale#currentrow#")>1<cfelse>0</cfif>,
									#evaluate("attributes.ref_member_count#currentrow#")#,
									#evaluate("attributes.active_member_condition#currentrow#")#,
									#evaluate("attributes.min_ref_member_sale#currentrow#")#,
									#evaluate("attributes.min_group_sale#currentrow#")#,
									#evaluate("attributes.campaign_count#currentrow#")#,
									#session.ep.userid#,
									'#cgi.remote_addr#',
									#now()#						
								)
						</cfquery>
						<cfquery name="get_max_id" datasource="#dsn3#">
							SELECT MAX(CONSCAT_SEGMENT_ID) AS MAX_ID FROM SETUP_CONSCAT_SEGMENTATION
						</cfquery>
						<cfloop query="get_cons_cats">
							<cfset row_member_count = evaluate("attributes.member_count_row#conscat_id_#_#get_cons_cats.currentrow#")>
							<cfif row_member_count gt 0>
								<cfquery name="add_segment_row" datasource="#dsn3#">
									INSERT INTO
										SETUP_CONSCAT_SEGMENTATION_ROWS
										(
											CONSCAT_SEGMENT_ID,
											CONSCAT_ID,
											ROW_MEMBER_COUNT
										)
										VALUES
										(
											#get_max_id.max_id#,
											#evaluate("attributes.consumer_cat_row_id#conscat_id_#_#get_cons_cats.currentrow#")#,
											#evaluate("attributes.member_count_row#conscat_id_#_#get_cons_cats.currentrow#")#										
										)
								</cfquery>
							</cfif>
						</cfloop>
					</cfif>
				<cfelseif get_segment.recordcount gt 0>
					<cfquery name="del_segment" datasource="#dsn3#">
						DELETE FROM SETUP_CONSCAT_SEGMENTATION WHERE CONSCAT_SEGMENT_ID = #get_segment.conscat_segment_id#
					</cfquery>
					<cfquery name="del_segment_rows" datasource="#dsn3#">
						DELETE FROM SETUP_CONSCAT_SEGMENTATION_ROWS WHERE CONSCAT_SEGMENT_ID = #get_segment.conscat_segment_id#
					</cfquery>
				</cfif>
			</cfoutput>
		</cfif>
	</cftransaction>
</cflock>
<script type="text/javascript">
	wrk_opener_reload();
	window.close();
</script>


