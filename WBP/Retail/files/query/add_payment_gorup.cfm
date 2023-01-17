<cflock name="#CreateUUID()#" timeout="20">
	<cftransaction>
		<cfquery name="Add_" datasource="#dsn_dev#" result="max_id">
			INSERT INTO
				PAYMENT_GROUP
			(
				PAYMENT_GROUP_NAME
			)
			VALUES
			(
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.group_name#">
			)
		</cfquery>
        
        <cfloop from="1" to="#attributes.record_num#" index="i">
            <cfif evaluate("attributes.row_kontrol#i#") eq 1>
            <cfquery name="Add_Row_" datasource="#dsn_dev#">
                INSERT INTO
                    PAYMENT_GROUP_ROW
                    (
                        PAYMENT_GROUP_ID,
                        ALIM_START,
                        ALIM_FINISH,
                        ODEME_START,
                        ODEME_FINISH,
                        ODEME_MONTH
                    )
                    VALUES
                    (
                        #max_id.identitycol#,
                        #attributes.alim_start#,
                        #attributes.alim_finish#,
                        #attributes.odeme_start#,
                        #attributes.odeme_finish#,
                        #attributes.odeme_month#
                    )
            </cfquery>
            </cfif>
		</cfloop>        
	</cftransaction>
</cflock>
<cflocation url="#request.self#?fuseaction=retail.list_payment_group&event=upd&group_id=#max_id.identitycol#" addtoken="no">