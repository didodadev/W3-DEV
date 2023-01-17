<cfif len(attributes.camp_id)>
	<cfquery name="GET_CAMPAIGN" datasource="#DSN3#">
		SELECT CAMP_STARTDATE,CAMP_FINISHDATE FROM CAMPAIGNS WHERE CAMP_ID = #attributes.camp_id#
	</cfquery>
	<cfset camp_start_date=date_add("H",session.ep.time_zone,get_campaign.camp_startdate)>
	<cfset camp_start_hour=datepart("H",camp_start_date)>
	<cfset camp_start_minute=datepart("N",camp_start_date)>
	<cfset camp_finish_date=date_add("H",session.ep.time_zone,get_campaign.camp_finishdate)>
	<cfset camp_finish_hour=datepart("H",camp_finish_date)>
	<cfset camp_finish_minute=datepart("N",camp_finish_date)>
	<cfloop from="1" to="#attributes.record_num#" index="i">
	   <cfif isdefined("attributes.row_kontrol#i#") and evaluate("attributes.row_kontrol#i#")>
			<cf_date tarih='attributes.start_date#i#'>
			<cf_date tarih='attributes.finish_date#i#'>
			<cfset kontrol_start_ = date_add("H",camp_start_hour,evaluate("attributes.start_date#i#"))>
			<cfset kontrol_start_ = date_add("N",camp_start_minute,kontrol_start_)>
			<cfset kontrol_finish_ = date_add("H",camp_finish_hour,evaluate("attributes.finish_date#i#"))>
			<cfset kontrol_finish_ = date_add("N",camp_finish_minute,kontrol_finish_)>
			<cfif (kontrol_start_ lt date_add("H",session.ep.time_zone,get_campaign.camp_startdate)) or (kontrol_finish_ gt date_add("H",session.ep.time_zone,get_campaign.camp_finishdate))>
				<script type="text/javascript">
					alert("<cf_get_lang no ='871.Promosyon Tarihi Kampanya Tarihi ile Uyuşmuyor, Lütfen Geri Dönüp Kontrol Ediniz'> !");
					window.history.go(-1);
				</script>	
				<cfabort>
			</cfif>
		</cfif>
	</cfloop>
</cfif>
<cflock name="#CreateUUID()#" timeout="20">
  <cftransaction>
  	<cfquery name="add_prom_relation" datasource="#dsn3#">
		INSERT INTO
			PROMOTIONS_RELATION
			(
				PROCESS_STAGE,
				PROM_DETAIL,
				PROM_STATUS,
				RECORD_DATE,
				RECORD_IP,
				RECORD_EMP
			)
			VALUES
			(
				#attributes.process_stage#,
				'#attributes.prom_detail#',
				<cfif isdefined("attributes.prom_status")>1<cfelse>0</cfif>,
				#now()#,
				'#cgi.remote_addr#',
				#session.ep.userid#
			)
	</cfquery>
	<cfquery name="get_last_rel" datasource="#dsn3#">
		SELECT MAX(PROM_RELATION_ID) AS MAX_ID FROM PROMOTIONS_RELATION
	</cfquery>
	<!--- Varsa kampanyaya bağlı segmentesyon ve prim bilgileri yazılıyor--->
	<cfif len(attributes.camp_id)>
		<cfquery name="get_segment" datasource="#dsn3#">
			SELECT * FROM SETUP_CONSCAT_SEGMENTATION WHERE CAMPAIGN_ID = #attributes.camp_id#
		</cfquery>
		<cfif get_segment.recordcount>
			<cfquery name="add_segment" datasource="#dsn3#">
				INSERT INTO
					SETUP_CONSCAT_SEGMENTATION
					(
						PROM_REL_ID,
						CONSCAT_ID,
						MIN_PERSONAL_SALE,
						IS_PERSONAL_PRIM,
						REF_MEMBER_COUNT,
						ACTIVE_MEMBER_CONDITION,
						REF_MEMBER_SALE,
						CAMPAIGN_COUNT,
						GROUP_SALE,
						RECORD_EMP,
						RECORD_IP,
						RECORD_DATE
					)
					SELECT
						#get_last_rel.max_id#,
						CONSCAT_ID,
						MIN_PERSONAL_SALE,
						IS_PERSONAL_PRIM,
						REF_MEMBER_COUNT,
						ACTIVE_MEMBER_CONDITION,
						REF_MEMBER_SALE,
						CAMPAIGN_COUNT,
						GROUP_SALE,
						#session.ep.userid#,
						'#cgi.remote_addr#',
						#now()#	
					FROM
						SETUP_CONSCAT_SEGMENTATION
					WHERE
						CAMPAIGN_ID = #attributes.camp_id#	
			</cfquery>
			<cfquery name="get_max_id" datasource="#dsn3#">
				SELECT MAX(CONSCAT_SEGMENT_ID) CONSCAT_SEGMENT_ID FROM SETUP_CONSCAT_SEGMENTATION
			</cfquery>	
			<cfquery name="get_segment_rows" datasource="#dsn3#">
				SELECT * FROM SETUP_CONSCAT_SEGMENTATION_ROWS WHERE CONSCAT_SEGMENT_ID = #get_segment.CONSCAT_SEGMENT_ID#
			</cfquery>	
			<cfif get_segment_rows.recordcount>
				<cfquery name="add_segment_row" datasource="#dsn3#">
					INSERT INTO
						SETUP_CONSCAT_SEGMENTATION_ROWS
						(
							CONSCAT_SEGMENT_ID,
							CONSCAT_ID,
							ROW_MEMBER_COUNT
						)
						SELECT
							#get_max_id.CONSCAT_SEGMENT_ID#,
							CONSCAT_ID,
							ROW_MEMBER_COUNT
						FROM
							SETUP_CONSCAT_SEGMENTATION_ROWS
						WHERE
							CONSCAT_SEGMENT_ID = #get_segment.CONSCAT_SEGMENT_ID#
				</cfquery>	
			</cfif>
		</cfif>
		<cfquery name="get_premium" datasource="#dsn3#">
			SELECT * FROM SETUP_CONSCAT_PREMIUM WHERE CAMPAIGN_ID = #attributes.camp_id#
		</cfquery>
		<cfif get_premium.recordcount>
			<cfquery name="add_premium" datasource="#dsn3#">
				INSERT INTO
					SETUP_CONSCAT_PREMIUM
					(
						PROM_REL_ID,
						CONSCAT_ID,
						REF_MEMBER_COUNT,
						REF_MEMBER_CAT,
						PREMIUM_LEVEL,
						MIN_NET_SALE,
						MAX_NET_SALE,
						PREMIUM_RATIO,
						RECORD_EMP,
						RECORD_IP,
						RECORD_DATE
					)
					SELECT
						#get_last_rel.max_id#,
						CONSCAT_ID,
						REF_MEMBER_COUNT,
						REF_MEMBER_CAT,
						PREMIUM_LEVEL,
						MIN_NET_SALE,
						MAX_NET_SALE,
						PREMIUM_RATIO,
						#session.ep.userid#,
						'#cgi.remote_addr#',
						#now()#						
					FROM
						SETUP_CONSCAT_PREMIUM
					WHERE
						CAMPAIGN_ID = #attributes.camp_id#
			</cfquery>
		</cfif>
	</cfif>	
    <cfloop from="1" to="#attributes.record_num#" index="i">
	   <cfif isdefined("attributes.row_kontrol#i#") and evaluate("attributes.row_kontrol#i#")>
			<cfif not len(attributes.camp_id)>
				<cf_date tarih='attributes.start_date#i#'>
				<cf_date tarih='attributes.finish_date#i#'>
			</cfif>
			<cf_papers paper_type="promotion">
			<cfset system_paper_no=paper_code & '-' & paper_number>
			<cfset system_paper_no_add=paper_number>
			<cfquery name="ADD_PROM" datasource="#DSN3#">
				INSERT INTO
					PROMOTIONS
					(
						CAMP_ID,
						PROM_RELATION_ID,
						PROM_STAGE,
						PROM_STATUS,
						PROM_DETAIL,
						PROM_NO,
						STOCK_ID,
						PROM_HEAD,
						PRICE_CATID,
						STARTDATE,
						FINISHDATE,
						LIMIT_TYPE,
						LIMIT_VALUE,
						FREE_STOCK_ID,
						FREE_STOCK_AMOUNT,
						FREE_STOCK_PRICE,
						AMOUNT_1,
						AMOUNT_1_MONEY,
						PROM_TYPE,
						DISCOUNT,
						AMOUNT_DISCOUNT,
						RECORD_EMP,
						RECORD_DATE,
						RECORD_IP
					)
					VALUES
					(
						<cfif len(attributes.camp_id) and len(attributes.camp_name)>#attributes.camp_id#<cfelse>NULL</cfif>,
						#get_last_rel.max_id#,
						#attributes.process_stage#,
						<cfif isdefined("attributes.prom_status")>1<cfelse>0</cfif>,
						'#attributes.prom_detail#',
						'#system_paper_no#',
						<cfif len(evaluate("attributes.stock_id#i#")) and len(evaluate("attributes.product_name#i#"))>#evaluate("attributes.stock_id#i#")#<cfelse>NULL</cfif>,
						'#wrk_eval("attributes.prom_head#i#")#',
						#evaluate("attributes.price_cat#i#")#,
						#evaluate("attributes.start_date#i#")#,
						#evaluate("attributes.finish_date#i#")#,
						1,
						<cfif len(evaluate("attributes.amount#i#"))>#evaluate("attributes.amount#i#")#<cfelse>NULL</cfif>,
						<cfif len(evaluate("attributes.free_stock_id#i#")) and len(evaluate("attributes.free_product_name#i#"))>#evaluate("attributes.free_stock_id#i#")#<cfelse>NULL</cfif>,
						<cfif len(evaluate("attributes.free_amount#i#"))>#evaluate("attributes.free_amount#i#")#<cfelse>NULL</cfif>,
						<cfif len(evaluate("attributes.invoice_value#i#"))>#evaluate("attributes.invoice_value#i#")#<cfelse>NULL</cfif>,
						<cfif len(evaluate("attributes.cost_value#i#"))>#evaluate("attributes.cost_value#i#")#<cfelse>NULL</cfif>,
						'#session.ep.money#',
						1,
						<cfif len(evaluate("attributes.percent_discount#i#")) and evaluate("attributes.percent_discount#i#") gt 0>
						#evaluate("attributes.percent_discount#i#")#,
						<cfelse>
						NULL,
						</cfif>
						<cfif len(evaluate("attributes.value_discount#i#")) and evaluate("attributes.value_discount#i#") gt 0>
						#evaluate("attributes.value_discount#i#")#,
						<cfelse>
						NULL,
						</cfif>
						#SESSION.EP.USERID#,
						#now()#,
						'#CGI.REMOTE_ADDR#'
					)
			</cfquery>
			<cfquery name="UPD_GEN_PAP" datasource="#DSN3#">
				UPDATE 
					GENERAL_PAPERS
				SET
					PROMOTION_NUMBER = #system_paper_no_add#
				WHERE
					PROMOTION_NUMBER IS NOT NULL
			</cfquery>
		</cfif>
	</cfloop>	
	<cf_workcube_process 
		is_upd='1' 
		data_source='#dsn3#' 
		old_process_line='0'
		process_stage='#attributes.process_stage#' 
		record_member='#session.ep.userid#' 
		record_date='#now()#' 
		action_table='PROMOTIONS'
		action_column='PROM_ID'
		action_id='#get_last_rel.max_id#'
		action_page='#request.self#?fuseaction=product.list_productions&event=updCollacted&prom_rel_id=#get_last_rel.max_id#' 
		warning_description='Toplu Promosyon : #get_last_rel.max_id#'>
	</cftransaction>
</cflock>
<cfset attributes.actionId = get_last_rel.max_id >
<script type="text/javascript">
	window.location.href="<cfoutput>#request.self#?fuseaction=product.list_promotions&event=updCollacted&prom_rel_id=#get_last_rel.max_id#</cfoutput>";
</script>

