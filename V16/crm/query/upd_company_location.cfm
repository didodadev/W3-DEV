<cflock name="#createUUID()#" timeout="100">
<cftransaction>
<cfquery name="upd_locs" datasource="#dsn#">
	UPDATE 
		COMPANY
		SET
		STOCK_AMOUNT = <cfif len(attributes.stock_amount)>#attributes.stock_amount#,<cfelse>NULL,</cfif>
		DUTY_PERIOD  = <cfif len(attributes.duty_period)>#attributes.duty_period#<cfelse>NULL</cfif>
		WHERE 
		COMPANY_ID = #attributes.cpid#
</cfquery>
<cfquery name="del_postion" datasource="#dsn#">
	DELETE FROM COMPANY_POSITION WHERE COMPANY_ID = #attributes.cpid# 
</cfquery>
<cfif isDefined('attributes.customer_position')>
<cfloop list="#attributes.customer_position#" index="i">
<cfquery name="ins_position" datasource="#dsn#">
	INSERT INTO 
		COMPANY_POSITION 
		(
			POSITION_ID,
			COMPANY_ID
		)
	VALUES
		(
			#i#,
			#attributes.cpid#
		)
</cfquery>
</cfloop>
</cfif>
<cfquery name="del_distance" datasource="#dsn#">
DELETE FROM COMPANY_DEPOT_DISTANCE WHERE COMPANY_ID = #attributes.cpid# 
</cfquery>
<cfoutput>
	<cfloop index="i" from="1" to="#attributes.record#">
		<cfscript>
		attributes_km = evaluate("attributes.depot_km#i#");
		attributes_minute = evaluate("attributes.depot_minute#i#");
		attributes_depot_id = evaluate("attributes.depot_id#i#");
		</cfscript>
		<cfquery name="ins_distance" datasource="#dsn#">
			INSERT INTO 
				COMPANY_DEPOT_DISTANCE
				(
					DEPOT_ID,
					COMPANY_ID,
					DEPOT_KM,
					DEPOT_MINUTE
				)
			VALUES
				(
					#attributes_depot_id#,
					#attributes.cpid#,
					<cfif len(attributes_km)>#attributes_km#,<cfelse>NULL,</cfif>
					<cfif len(attributes_minute)>#attributes_minute#<cfelse>NULL</cfif>
				)
		</cfquery>
	</cfloop>
</cfoutput>
</cftransaction>
</cflock>
<cflocation url="#request.self#?fuseaction=crm.popup_company_location_info&cpid=#attributes.cpid#&iframe=1" addtoken="no">
