<cflock name="#CreateUUID()#" timeout="60">
	<cftransaction>
		<cfquery name="Upd_" datasource="#dsn_dev#" result="max_id">
			UPDATE
                PAYMENT_GROUP
            SET
                PAYMENT_GROUP_NAME = <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.group_name#">,
                UPDATE_DATE = #now()#,
                UPDATE_EMP = #session.ep.userid#
			WHERE                
                PAYMENT_GROUP_ID = #attributes.group_id#
		</cfquery>
        <cfquery name="Del_Row_" datasource="#dsn_dev#">
            DELETE FROM PAYMENT_GROUP_ROW WHERE PAYMENT_GROUP_ID = #attributes.group_id#
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
							#attributes.group_id#,
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
<cflocation url="#request.self#?fuseaction=retail.upd_payment_group&group_id=#attributes.group_id#" addtoken="no">