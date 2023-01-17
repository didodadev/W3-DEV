<cflock name="#CreateUUID()#" timeout="20">
	<cftransaction>
		<cfquery name="Add_" datasource="#dsn_dev#" result="max_id">
			INSERT INTO
				PAYMENT_GROUP
			(
				PAYMENT_GROUP_NAME,
                RECORD_DATE,
                RECORD_EMP
			)
			VALUES
			(
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.group_name#">,
                #now()#,
                #session.ep.userid#
			)
		</cfquery>
        
        <cfloop from="1" to="#attributes.record_num1#" index="i">
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
                        #evaluate("attributes.alim_start#i#")#,
                        #evaluate("attributes.alim_finish#i#")#,
                        #evaluate("attributes.odeme_start#i#")#,
                        #evaluate("attributes.odeme_finish#i#")#,
                        #evaluate("attributes.odeme_month#i#")#
                    )
            </cfquery>
            </cfif>
		</cfloop>        
	</cftransaction>
</cflock>
<cflocation url="#request.self#?fuseaction=retail.list_payment_group" addtoken="no">