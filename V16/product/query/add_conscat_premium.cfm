<cfquery name="get_cons_cat" datasource="#dsn#">
	SELECT * FROM CONSUMER_CAT WHERE IS_PREMIUM = 0 ORDER BY HIERARCHY
</cfquery>
<cfif isdefined("attributes.campaign_id")>
	<cfquery name="del_rows" datasource="#dsn3#">
		DELETE FROM SETUP_CONSCAT_PREMIUM WHERE CAMPAIGN_ID = #attributes.campaign_id#
	</cfquery>
<cfelseif isdefined("attributes.catalog_id")>
	<cfquery name="del_rows" datasource="#dsn3#">
		DELETE FROM SETUP_CONSCAT_PREMIUM WHERE CATALOG_ID = #attributes.catalog_id#
	</cfquery>
<cfelseif isdefined("attributes.promotion_id")>	
	<cfquery name="del_rows" datasource="#dsn3#">
		DELETE FROM SETUP_CONSCAT_PREMIUM WHERE PROMOTION_ID = #attributes.promotion_id#
	</cfquery>
<cfelseif isdefined("attributes.prom_rel_id")>	
	<cfquery name="del_rows" datasource="#dsn3#">
		DELETE FROM SETUP_CONSCAT_PREMIUM WHERE PROM_REL_ID = #attributes.prom_rel_id#
	</cfquery>
</cfif>
<cflock name="#CreateUUID()#" timeout="20">
	<cftransaction>
		<cfoutput query="get_cons_cat">
			<cfset record_num = evaluate("attributes.record_num_#get_cons_cat.conscat_id#")>
			<cfloop from="1" to="#record_num#" index="kk">
				<cfif isdefined("attributes.premium_level_#get_cons_cat.conscat_id#_#kk#") and evaluate("attributes.row_kontrol_#get_cons_cat.conscat_id#_#kk#") eq 1>
					<cfquery name="add_segment" datasource="#dsn3#">
						INSERT INTO
							SETUP_CONSCAT_PREMIUM
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
								PREMIUM_LEVEL,
								MIN_NET_SALE,
								MAX_NET_SALE,
								REF_MEMBER_CAT,
								REF_MEMBER_COUNT,
								PREMIUM_RATIO,
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
								#get_cons_cat.conscat_id#,
								#evaluate("attributes.premium_level_#get_cons_cat.conscat_id#_#kk#")#,
								#evaluate("attributes.min_member_sale_#get_cons_cat.conscat_id#_#kk#")#,
								#evaluate("attributes.max_member_sale_#get_cons_cat.conscat_id#_#kk#")#,
								<cfif len(evaluate("attributes.ref_member_cat_#get_cons_cat.conscat_id#_#kk#"))>#evaluate("attributes.ref_member_cat_#get_cons_cat.conscat_id#_#kk#")#<cfelse>NULL</cfif>,
								<cfif len(evaluate("attributes.ref_member_count_#get_cons_cat.conscat_id#_#kk#"))>#evaluate("attributes.ref_member_count_#get_cons_cat.conscat_id#_#kk#")#<cfelse>0</cfif>,
								#evaluate("attributes.premium_ratio_#get_cons_cat.conscat_id#_#kk#")#,
								#session.ep.userid#,
								'#cgi.remote_addr#',
								#now()#						
							)
					</cfquery>
				</cfif>
			</cfloop>
		</cfoutput>
	</cftransaction>
</cflock>
<script type="text/javascript">
	wrk_opener_reload();
	window.close();
</script>


