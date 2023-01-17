<cfif listlen(attributes.stock_id_list)>
	<cfquery name="get_max" datasource="#dsn2#">
		SELECT ISNULL(MAX(CONTROL_ID),0) MAX FROM SHIP_PACKAGE_LIST_HISTORY
	</cfquery>
	<cfset control_id = get_max.MAX+1>
	<cfloop list="#attributes.stock_id_list#" index="sid">
	<cfquery name="ADD_PACKAGE_LIST_HISTORY" datasource="#dsn2#">
		INSERT INTO 
		SHIP_PACKAGE_LIST_HISTORY
		(
			CONTROL_ID,
			SHIP_ID,
			STOCK_ID,
			AMOUNT,
			CONTROL_AMOUNT,
			RECORD_EMP,
			RECORD_IP,
			RECORD_DATE
		)
		VALUES
		(
			#control_id#,
			#attributes.SHIP_ID#,
			#sid#,
			#Evaluate('attributes.amount#sid#')#,
			#Evaluate('attributes.control_amount#sid#')#,
			<cfif isdefined('session.ep')>#session.ep.userid#<cfelse>#session.pda.userid#</cfif>,
			'#CGI.REMOTE_ADDR#',
			#now()#
		)
	</cfquery>
	</cfloop>
	<cfquery name="DELETE_PACKAGE_LIST" datasource="#DSN2#">
		DELETE SHIP_PACKAGE_LIST WHERE SHIP_ID = #attributes.SHIP_ID#
	</cfquery>
	<cfloop list="#attributes.stock_id_list#" index="sid">
		<cfquery name="ADD_PACKAGE_LIST" datasource="#dsn2#">
			INSERT INTO 
			SHIP_PACKAGE_LIST
			(
				SHIP_ID,
				STOCK_ID,
				AMOUNT,
				CONTROL_AMOUNT
			)
			VALUES
			(
				#attributes.SHIP_ID#,
				#sid#,
				#Evaluate('attributes.amount#sid#')#,
				#Evaluate('attributes.control_amount#sid#')#
			)
		</cfquery>
	</cfloop>
</cfif>
<cfif isdefined('session.ep')>
	<script type="text/javascript">
		window.close();
    </script>
<cfelse>
	<cflocation url="#request.self#?fuseaction=pda.package_control_list" addtoken="no">  
</cfif>
