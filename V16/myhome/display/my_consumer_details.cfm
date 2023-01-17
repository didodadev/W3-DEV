<cfif session.ep.our_company_info.sales_zone_followup eq 1>
    <cfquery name="GET_HIERARCHIES" datasource="#DSN#">
        SELECT
            DISTINCT
            SZ_HIERARCHY
        FROM
            SALES_ZONES_ALL_1
        WHERE
            POSITION_CODE = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.position_code#">
    </cfquery>
    <cfset row_block = 500>
</cfif>
<cfquery name="GET_CONS_INFO" datasource="#DSN#">
	SELECT CONSUMER_STATUS FROM CONSUMER WHERE CONSUMER_ID = #attributes.cid#
    <cfif session.ep.our_company_info.sales_zone_followup eq 1>
			<!--- Satis Takimda Ekip Lideri veya Satıs Takiminda Ekipde ise ilgili IMS ler--->
			AND 
			(
				CONSUMER.IMS_CODE_ID IN (
											SELECT 
												DISTINCT IMS_ID
											FROM
												SALES_ZONES_ALL_2
											WHERE
												POSITION_CODE = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.position_code#"> 
												AND (CONSUMER_CAT_IDS IS NULL OR (CONSUMER_CAT_IDS IS NOT NULL AND ','+CONSUMER_CAT_IDS+',' LIKE '%,'+CAST(CONSUMER.CONSUMER_CAT_ID AS NVARCHAR)+',%'))
										)
			<!--- Satis bolgeleri ekibinde veya Satis bolgesinde yonetici ise kendisi ve altindaki IMS ler--->			
	 	  	<cfif get_hierarchies.recordcount>
			OR CONSUMER.IMS_CODE_ID IN (
											SELECT
												DISTINCT IMS_ID
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
															<cfif (add_stock mod row_block) neq 1> OR</cfif> SZ_HIERARCHY+'.' LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="#get_hierarchies.sz_hierarchy[add_stock]#%">
														</cfloop>													
														)<cfif (ceiling(get_hierarchies.recordcount/row_block))-1 neq page_stock> OR</cfif>													
												</cfloop>											
										)
			  </cfif>						
			)
		</cfif>
</cfquery>
<cfif GET_CONS_INFO.recordcount eq 0>
    <script language="javascript">
			alert("<cf_get_lang dictionary_id ='31918.Bu Üyeyi Görmek İçin Yetkiniz Yok'>!");
        history.back();
    </script>
    <cfabort>
</cfif>
<cf_xml_page_edit fuseact="myhome.my_consumer_details">
<cfif session.ep.our_company_info.sales_zone_followup eq 1>
		<cfquery name="GET_HIERARCHIES" datasource="#DSN#">
			SELECT
				DISTINCT
				SZ_HIERARCHY
			FROM
				SALES_ZONES_ALL_1
			WHERE
				POSITION_CODE = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.position_code#">
		</cfquery>
</cfif>
<cfif session.ep.member_view_control>
	<cfquery name="view_control" datasource="#DSN#">
		SELECT
			IS_MASTER
		FROM
			WORKGROUP_EMP_PAR
		WHERE
			CONSUMER_ID = #attributes.cid# AND
			OUR_COMPANY_ID = #session.ep.company_id# AND
			POSITION_CODE = #session.ep.position_code#
	</cfquery>
<cfif not view_control.recordcount>
		<script type="text/javascript">
			alert("<cf_get_lang dictionary_id ='31918.Bu Üyeyi Görmek İçin Yetkiniz Yok'>!");
			history.back();
		</script>
	</cfif>
</cfif>
<!--- CMC Entegrasyonu icin --->
<cfif is_upd_call eq 1 and len(is_upd_call_emp_ids) and listfind(is_upd_call_emp_ids,session.ep.userid)>
	<cfquery name="GET_AGENT_ID" datasource="#DSN#">
		SELECT OZEL_KOD FROM EMPLOYEE_POSITIONS WHERE POSITION_CODE = #session.ep.position_code#
	</cfquery>

	<!--- Bizim liste sayfamizdan giderse --->
	<cfif get_agent_id.recordcount and len(get_agent_id.ozel_kod)>
		<cfif not isdefined("attributes.CallID")>
			<cfquery name="ADD_CALL_ENTEGRASYON" datasource="#DSN#">
				INSERT INTO 
					CALL_ENTEGRASYON
				(
					AGENT_ID,
					CONSUMER_ID,
					RECORD_DATE,
					RECORD_IP
				)
				VALUES
				(
					#get_agent_id.ozel_kod#,
					#attributes.cid#,
					#now()#,
					'#cgi.remote_addr#'
				)
			</cfquery>
		<!--- kendi popupu acarsa 0 kontorlunun nedeni sifre dogrulama ekranında cid 0 ile gelen kayitlarin atilmasina engel olmak--->
		<cfelseif isdefined("attributes.CallID") and attributes.cid gt 0>
			<cfquery name="ADD_CALL_ENTEGRASYON" datasource="#DSN#">
				INSERT INTO 
					CALL_ENTEGRASYON
				(
					AGENT_ID,
					CONSUMER_ID,
					CALL_ID,
					RECORD_DATE,
					RECORD_IP
				)
				VALUES
				(
					#get_agent_id.ozel_kod#,
					#attributes.cid#,
					'#attributes.CallID#',
					#now()#,
					'#cgi.remote_addr#'
				)
			</cfquery>
		</cfif>
	</cfif>
</cfif>
<cfquery name="GET_CONSUMER" datasource="#DSN#">
SELECT CONSUMER_STATUS,CONSUMER_NAME FROM CONSUMER WHERE CONSUMER_ID = #attributes.cid#
</cfquery>
<cfparam name="attributes.page" default=1>
<cfparam name="attributes.maxrows" default='#session.ep.maxrows#'>
<cfset attributes.startrow = ((attributes.page - 1) * attributes.maxrows) + 1>
<cfset index=1>
<!--- Sayfa ana kısım  --->
<cfset pageHead =  #getLang('main',174)# & " : " & #attributes.cid#> 
<cf_catalystHeader>
    <div class="col col-9 col-md-9 col-sm-12 col-xs-12">
    <!---Geniş alan: içerik---> 
        <cfinclude template="my_consumer_details_content.cfm">
    </div>
    <div class="col col-3 col-md-3 col-sm-12 col-xs-12">
        <!--- Yan kısım--->
        <cfinclude template="my_consumer_details_side.cfm">
    </div>
