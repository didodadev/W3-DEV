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
		<cfquery name="upd_prom_rel" datasource="#dsn3#">
			UPDATE
				PROMOTIONS_RELATION
			SET
				PROCESS_STAGE = #attributes.process_stage#,
				PROM_DETAIL = '#attributes.prom_detail#',
				PROM_STATUS = <cfif isdefined("attributes.prom_status")>1<cfelse>0</cfif>,
				UPDATE_DATE = #now()#,
				UPDATE_IP = '#cgi.remote_addr#',
				UPDATE_EMP = #session.ep.userid#
			WHERE
				PROM_RELATION_ID = #attributes.prom_rel_id#
		</cfquery>
		<cfquery name="get_all_row" datasource="#dsn3#">
			SELECT PROM_ID FROM PROMOTIONS WHERE PROM_RELATION_ID = #attributes.prom_rel_id#
		</cfquery>
		<cfset prom_id_list = valuelist(get_all_row.prom_id)>
		<cfloop from="1" to="#attributes.record_num#" index="i">
			<cfif evaluate("attributes.row_kontrol#i#") eq 1 and evaluate("attributes.prom_id#i#") gt 0>
				<cfif not len(attributes.camp_id)>
					<cf_date tarih='attributes.start_date#i#'>
					<cf_date tarih='attributes.finish_date#i#'>
				</cfif>
				<cfquery name="upd_prom" datasource="#dsn3#">
					UPDATE
						PROMOTIONS
					SET
						CAMP_ID = <cfif len(attributes.camp_id) and len(attributes.camp_name)>#attributes.camp_id#<cfelse>NULL</cfif>,
						PROM_STAGE = #attributes.process_stage#,
						PROM_STATUS = <cfif isdefined("attributes.prom_status")>1<cfelse>0</cfif>,
						PROM_DETAIL = '#attributes.prom_detail#',
						STOCK_ID = <cfif len(evaluate("attributes.stock_id#i#")) and len(evaluate("attributes.product_name#i#"))>#evaluate("attributes.stock_id#i#")#<cfelse>NULL</cfif>,
						PROM_HEAD = '#wrk_eval("attributes.prom_head#i#")#',
						PRICE_CATID = #evaluate("attributes.price_cat#i#")#,
						STARTDATE = #evaluate("attributes.start_date#i#")#,
						FINISHDATE = #evaluate("attributes.finish_date#i#")#,
						LIMIT_VALUE = <cfif len(evaluate("attributes.amount#i#"))>#evaluate("attributes.amount#i#")#<cfelse>NULL</cfif>,
						FREE_STOCK_ID = <cfif len(evaluate("attributes.free_stock_id#i#")) and len(evaluate("attributes.free_product_name#i#"))>#evaluate("attributes.free_stock_id#i#")#<cfelse>NULL</cfif>,
						FREE_STOCK_AMOUNT = <cfif len(evaluate("attributes.free_amount#i#"))>#evaluate("attributes.free_amount#i#")#<cfelse>NULL</cfif>,
						FREE_STOCK_PRICE = <cfif len(evaluate("attributes.invoice_value#i#"))>#evaluate("attributes.invoice_value#i#")#<cfelse>NULL</cfif>,
						AMOUNT_1 = <cfif len(evaluate("attributes.cost_value#i#"))>#evaluate("attributes.cost_value#i#")#<cfelse>NULL</cfif>,
						DISCOUNT = <cfif len(evaluate("attributes.percent_discount#i#")) and evaluate("attributes.percent_discount#i#") gt 0>#evaluate("attributes.percent_discount#i#")#,<cfelse>NULL,</cfif>
						AMOUNT_DISCOUNT = <cfif len(evaluate("attributes.value_discount#i#")) and evaluate("attributes.value_discount#i#") gt 0>#evaluate("attributes.value_discount#i#")#,<cfelse>NULL,</cfif>
						UPDATE_DATE = #now()#,
						UPDATE_IP = '#cgi.remote_addr#',
						UPDATE_EMP = #session.ep.userid#
					WHERE 
						PROM_ID = #evaluate("attributes.prom_id#i#")#
				</cfquery>
				<cfquery name="get_last_prom" datasource="#dsn3#">
					SELECT * FROM PROMOTIONS WHERE PROM_ID = #evaluate("attributes.prom_id#i#")#
				</cfquery>
				<cfquery name="ADD_PROM_HISTORY" datasource="#DSN3#">
					INSERT INTO
						PROMOTIONS_HISTORY
					(
						PROM_ID,
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
						UPDATE_EMP,
						UPDATE_DATE,
						UPDATE_IP
					)
					VALUES
					(
						#get_last_prom.PROM_ID#,
						<cfif len(get_last_prom.PROM_RELATION_ID)>#get_last_prom.PROM_RELATION_ID#<cfelse>NULL</cfif>,
						<cfif len(get_last_prom.PROM_STAGE)>#get_last_prom.PROM_STAGE#<cfelse>NULL</cfif>,
						<cfif len(get_last_prom.PROM_STATUS)>#get_last_prom.PROM_STATUS#<cfelse>NULL</cfif>,
						<cfif len(get_last_prom.PROM_DETAIL)>'#get_last_prom.PROM_DETAIL#'<cfelse>NULL</cfif>,
						<cfif len(get_last_prom.PROM_NO)>'#get_last_prom.PROM_NO#'<cfelse>NULL</cfif>,
						<cfif len(get_last_prom.STOCK_ID)>#get_last_prom.STOCK_ID#<cfelse>NULL</cfif>,
						<cfif len(get_last_prom.PROM_HEAD)>'#get_last_prom.PROM_HEAD#'<cfelse>NULL</cfif>,
						<cfif len(get_last_prom.PRICE_CATID)>#get_last_prom.PRICE_CATID#<cfelse>NULL</cfif>,
						#evaluate("attributes.start_date#i#")#,
						#evaluate("attributes.finish_date#i#")#,
						<cfif len(get_last_prom.LIMIT_TYPE)>#get_last_prom.LIMIT_TYPE#<cfelse>NULL</cfif>,
						<cfif len(get_last_prom.LIMIT_VALUE)>#get_last_prom.LIMIT_VALUE#<cfelse>NULL</cfif>,
						<cfif len(get_last_prom.FREE_STOCK_ID)>#get_last_prom.FREE_STOCK_ID#<cfelse>NULL</cfif>,
						<cfif len(get_last_prom.FREE_STOCK_AMOUNT)>#get_last_prom.FREE_STOCK_AMOUNT#<cfelse>NULL</cfif>,
						<cfif len(get_last_prom.FREE_STOCK_PRICE)>#get_last_prom.FREE_STOCK_PRICE#<cfelse>NULL</cfif>,
						<cfif len(get_last_prom.AMOUNT_1)>#get_last_prom.AMOUNT_1#<cfelse>NULL</cfif>,
						<cfif len(get_last_prom.AMOUNT_1_MONEY)>'#get_last_prom.AMOUNT_1_MONEY#'<cfelse>NULL</cfif>,
						<cfif len(get_last_prom.PROM_TYPE)>#get_last_prom.PROM_TYPE#<cfelse>NULL</cfif>,
						<cfif len(get_last_prom.DISCOUNT)>#get_last_prom.DISCOUNT#<cfelse>NULL</cfif>,
						<cfif len(get_last_prom.AMOUNT_DISCOUNT)>#get_last_prom.AMOUNT_DISCOUNT#<cfelse>NULL</cfif>,						
						<cfif len(get_last_prom.UPDATE_EMP)>#get_last_prom.UPDATE_EMP#<cfelse>NULL</cfif>,
						#now()#,
						<cfif len(get_last_prom.UPDATE_IP)>'#get_last_prom.UPDATE_IP#'<cfelse>NULL</cfif>
					)
				</cfquery>
				<cfset prom_id_list = ListDeleteAt(prom_id_list,ListFindNoCase(prom_id_list,evaluate("attributes.prom_id#i#"), ','), ',')>
			<cfelseif evaluate("attributes.row_kontrol#i#") eq 1 and evaluate("attributes.prom_id#i#") eq 0>
				<cf_date tarih='attributes.start_date#i#'>
				<cf_date tarih='attributes.finish_date#i#'>
				<cf_papers paper_type="promotion">
				<cfset system_paper_no=paper_code & '-' & paper_number>
				<cfset system_paper_no_add=paper_number>
				<cfquery name="add_prom" datasource="#dsn3#">
					INSERT INTO
						PROMOTIONS
						(
							PROM_RELATION_ID,
							CAMP_ID,
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
							DISCOUNT,
							AMOUNT_DISCOUNT,
							PROM_TYPE,
							RECORD_EMP,
							RECORD_DATE,
							RECORD_IP
						)
						VALUES
						(
							#attributes.prom_rel_id#,
							<cfif len(attributes.CAMP_ID)>#attributes.CAMP_ID#<cfelse>NULL</cfif>,
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
							<cfif len(evaluate("attributes.free_stock_id#i#"))>#evaluate("attributes.free_stock_id#i#")#<cfelse>NULL</cfif>,
							<cfif len(evaluate("attributes.free_amount#i#"))>#evaluate("attributes.free_amount#i#")#<cfelse>NULL</cfif>,
							<cfif len(evaluate("attributes.invoice_value#i#"))>#evaluate("attributes.invoice_value#i#")#<cfelse>NULL</cfif>,
							<cfif len(evaluate("attributes.cost_value#i#"))>#evaluate("attributes.cost_value#i#")#<cfelse>NULL</cfif>,
							'#session.ep.money#',
							<cfif len(evaluate("attributes.percent_discount#i#")) and evaluate("attributes.percent_discount#i#") gt 0>#evaluate("attributes.percent_discount#i#")#,<cfelse>NULL,</cfif>
							<cfif len(evaluate("attributes.value_discount#i#")) and evaluate("attributes.value_discount#i#") gt 0>#evaluate("attributes.value_discount#i#")#,<cfelse>NULL,</cfif>
							1,
							#SESSION.EP.USERID#,
							#now()#,
							'#CGI.REMOTE_ADDR#'
						)
				</cfquery>
				<cfquery name="upd_gen_paper" datasource="#dsn3#">
					UPDATE 
						GENERAL_PAPERS
					SET
						PROMOTION_NUMBER = #system_paper_no_add#
					WHERE
						PROMOTION_NUMBER IS NOT NULL
				</cfquery>
			</cfif>
		</cfloop>
		<cfif len(prom_id_list)>
			<cfquery name="del_prom" datasource="#dsn3#">
				DELETE FROM PROMOTIONS WHERE PROM_ID IN (#prom_id_list#)
			</cfquery>
			<cfquery name="del_prom_history" datasource="#dsn3#">
				DELETE FROM PROMOTIONS_HISTORY WHERE PROM_ID IN (#prom_id_list#)
			</cfquery>
		</cfif>
		<cf_workcube_process 
			is_upd='1' 
			data_source='#dsn3#' 
			old_process_line='#attributes.old_process_line#'
			process_stage='#attributes.process_stage#' 
			record_member='#session.ep.userid#' 
			record_date='#now()#' 
			action_table='PROMOTIONS'
			action_column='PROM_ID'
			action_id='#attributes.prom_rel_id#'
			action_page='#request.self#?fuseaction=product.list_promotions&event=updCollacted&prom_rel_id=#attributes.prom_rel_id#' 
			warning_description='Toplu Promosyon : #attributes.prom_rel_id#'>
	</cftransaction>
</cflock>
<cfset attributes.actionId = attributes.prom_rel_id >
<script type="text/javascript">
	window.location.href="<cfoutput>#request.self#?fuseaction=product.list_promotions&event=updCollacted&prom_rel_id=#attributes.prom_rel_id#</cfoutput>";
</script>

