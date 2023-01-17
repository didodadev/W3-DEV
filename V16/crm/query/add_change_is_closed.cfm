<cf_date tarih = "attributes.closed_start_date">
<cf_date tarih = "attributes.closed_finish_date">
<cflock name="#CreateUUID()#" timeout="20">
	<cftransaction>
		<cfquery name="get_history_related" datasource="#dsn#">
			SELECT 
            	RELATED_ID, 
                COMPANY_ID, 
                OUR_COMPANY_ID, 
                BRANCH_ID, 
                IS_SELECT, 
                CARIHESAPKOD, 
                MUSTERIDURUM, 
                DEPOT_KM, 
                DEPOT_DAK, 
                MUHASEBEKOD, 
                DEPO_STATUS, 
                TEL_SALE_PREID, 
                PLASIYER_ID, 
                SALES_DIRECTOR, 
                OPEN_DATE, 
                CLOSE_DATE, 
                RELATION_START, 
                RELATION_STATUS, 
                IS_MERKEZ, 
                IS_CLOSED, 
                CLOSED_START_DATE, 
                CLOSED_FINISH_DATE, 
                IS_CONTRACT_REQUIRED, 
                RECORD_DATE, 
                RECORD_EMP, 
                RECORD_IP, 
                UPDATE_DATE, 
                UPDATE_EMP, 
                UPDATE_IP 
            FROM 
            	COMPANY_BRANCH_RELATED 
            WHERE 
            	RELATED_ID = #attributes.related_id#
		</cfquery>
		<cfoutput query="get_history_related">
			<cfquery name="add_history_closed" datasource="#dsn#">
				INSERT INTO
					COMPANY_BRANCH_CLOSED_HISTORY
				(
					RELATED_ID,
					IS_CLOSED,
					CLOSED_START_DATE,
					CLOSED_FINISH_DATE,
					RECORD_EMP,
					RECORD_DATE,
					RECORD_IP
				)
				VALUES
				(
					#related_id#,
					#is_closed#,
					<cfif len(get_history_related.closed_start_date)>#createodbcdatetime(get_history_related.closed_start_date)#<cfelse>NULL</cfif>,
					<cfif len(get_history_related.closed_finish_date)>#createodbcdatetime(get_history_related.closed_finish_date)#<cfelse>NULL</cfif>,
					#session.ep.userid#,
					#now()#,
					'#cgi.remote_addr#'
				)
			</cfquery>
		</cfoutput>
		<cfquery name="CHANGE_VALUE" datasource="#dsn#">
			UPDATE
				COMPANY_BRANCH_RELATED
			SET
				IS_CLOSED = #attributes.is_closed#,
				<cfif attributes.is_closed eq 1>
					CLOSED_START_DATE = #attributes.closed_start_date#,
					CLOSED_FINISH_DATE = #attributes.closed_finish_date#
				<cfelse>
					CLOSED_START_DATE = NULL,
					CLOSED_FINISH_DATE = NULL
				</cfif>
			WHERE
				RELATED_ID = #attributes.related_id#
		</cfquery>
		
	</cftransaction>
</cflock>
<cfif attributes.is_closed eq 1>
	<script type="text/javascript">
		opener.window.location.reload();
		window.close();
	</script>
<cfelse>
	<cflocation url="#request.self#?fuseaction=crm.popup_upd_consumer_branch&cpid=#attributes.cpid#&iframe=1" addtoken="no">
</cfif>
