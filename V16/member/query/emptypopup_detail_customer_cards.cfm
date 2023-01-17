<cfif Len(attributes.card_startdate)><cf_date tarih='attributes.card_startdate'></cfif>
<cfif not isDefined("attributes.card_status")><cfset attributes.card_status = 0></cfif>
<cfif isDefined('attributes.card_id') and Len(attributes.card_id)>
	<cfquery name="Get_Related_Cards" datasource="#dsn#">
		SELECT CARD_ID,ACTION_TYPE_ID,ACTION_ID FROM CUSTOMER_CARDS WHERE CARD_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.card_id#">
	</cfquery>
	<cfif attributes.card_status eq 1>
		<cfquery name="Upd_Old_Cards_Status" datasource="#dsn#"><!--- Eski Kart Numaralari Pasif Hale Getirilerek Son Girilen Aktif Kart Numarası Kalir --->
			UPDATE
				CUSTOMER_CARDS
			SET
				CARD_STATUS = 0
			WHERE
				CARD_ID <> <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.card_id#"> AND
				ACTION_TYPE_ID = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Get_Related_Cards.Action_Type_Id#"> AND
				ACTION_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#Get_Related_Cards.Action_Id#">
		</cfquery>
	</cfif>
	<cfquery name="Upd_Customer_Cards" datasource="#dsn#">
		UPDATE
			CUSTOMER_CARDS
		SET
			CARD_NO = <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.card_no#" null="#not Len(attributes.card_no)#">,
			CARD_STARTDATE = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.card_startdate#" null="#not Len(attributes.card_startdate)#">,
			CARD_FINISHDATE = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.card_finishdate#" null="#not Len(attributes.card_finishdate)#">,
			CARD_STATUS = <cfqueryparam cfsqltype="cf_sql_smallint" value="#attributes.card_status#">,
			CARD_DETAIL = <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.card_detail#" null="#not Len(attributes.card_detail)#">,
			CHANGE_TYPE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.change_type_id#" null="#not Len(attributes.change_type_id)#">,
			UPDATE_EMP = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.userid#">,
			UPDATE_DATE = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">,
			UPDATE_IP = <cfqueryparam cfsqltype="cf_sql_varchar" value="#cgi.remote_addr#">,
			CARD_LIMIT = <cfqueryparam cfsqltype="cf_sql_float" value="#attributes.card_limit#" null="#not Len(attributes.card_limit)#">,
			CARD_LIMIT_MONEY = <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.card_limit_money#" null="#not Len(attributes.card_limit_money)#">

		WHERE
			CARD_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.card_id#">
	</cfquery>
<cfelseif isDefined("attributes.action_id") and Len(attributes.action_id)>
	<cfquery name="Upd_Old_Cards_Status" datasource="#dsn#"><!--- Eski Kart Numaralari Pasif Hale Getirilerek Son Girilen Aktif Kart Numarası Kalir --->
		UPDATE
			CUSTOMER_CARDS
		SET
			CARD_STATUS = 0
		WHERE
			ACTION_TYPE_ID = <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.action_type_id#"> AND
			ACTION_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.action_id#">
	</cfquery>
	<cfquery name="Add_Customer_Cards" datasource="#dsn#">
		INSERT INTO
			CUSTOMER_CARDS
		(
			ACTION_TYPE_ID,
			ACTION_ID,
			CARD_NO,
			CARD_STARTDATE,
			CARD_FINISHDATE,
			CARD_STATUS,
			CARD_DETAIL,
			CHANGE_TYPE_ID,
			RECORD_EMP,
			RECORD_DATE,
			RECORD_IP,
			CARD_LIMIT,
			CARD_LIMIT_MONEY
		)
		VALUES
		(
			<cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.action_type_id#">,
			<cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.action_id#">,
			<cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.card_no#" null="#not Len(attributes.card_no)#">,
			<cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.card_startdate#" null="#not Len(attributes.card_startdate)#">,
			<cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.card_finishdate#" null="#not Len(attributes.card_finishdate)#">,
			<cfqueryparam cfsqltype="cf_sql_smallint" value="#attributes.card_status#">,
			<cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.card_detail#" null="#not Len(attributes.card_detail)#">,
			<cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.change_type_id#" null="#not Len(attributes.change_type_id)#">,
			<cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.userid#">,
			<cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">,
			<cfqueryparam cfsqltype="cf_sql_varchar" value="#cgi.remote_addr#">,
			<cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.card_limit#" null="#not Len(attributes.card_limit)#">,
			<cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.card_limit_money#" null="#not Len(attributes.card_no)#">
		)
	</cfquery>
</cfif>
<script type="text/javascript">
	<cfif not isdefined("attributes.draggable")>
		wrk_opener_reload();	
		window.close();
	<cfelse>
		closeBoxDraggable( '<cfoutput>#attributes.modal_id#</cfoutput>','unique_box_card_no' );
	</cfif>
</script>
