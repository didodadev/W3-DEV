<!--- kurumsal-bireysel-sistem ilişkili kayıt eklemek içindir,3 ü içinde ortak kullanılır,type lara göre kayıtları getirir --->
<cflock name="#CreateUUID()#" timeout="20">
	<cftransaction>
		<!--- ÖNCE SATIRLAR SİLİNİR --->
		<cfif attributes.action_type_info eq 1><!--- kurumsal üyeler --->
			<cfquery name="DEL_ROWS" datasource="#DSN#">
				DELETE FROM COMPANY_PARTNER_RELATION WHERE COMPANY_ID = #attributes.relation_info_id#
			</cfquery>
		<cfelseif attributes.action_type_info eq 2><!--- bireysel üyeler --->
			<cfquery name="DEL_ROWS" datasource="#DSN#">
				DELETE FROM CONSUMER_TO_CONSUMER WHERE CONSUMER_ID = #attributes.relation_info_id#
			</cfquery>
		<cfelseif attributes.action_type_info eq 3><!--- sistemler --->
			<cfquery name="DEL_ROWS" datasource="#DSN3#">
				DELETE FROM SUBSCRIPTION_CONTRACT_RELATIONS WHERE SUBSCRIPTION_ID = #attributes.relation_info_id#
			</cfquery>
		</cfif>
		<cfloop from="1" to="#attributes.record_num#" index="i">
			<cfif isdefined("attributes.row_kontrol#i#") and evaluate("attributes.row_kontrol#i#") eq 1>
				<cfif attributes.action_type_info eq 1><!--- kurumsal üyeler --->
					<cfquery name="add_par_rel" datasource="#DSN#">
						INSERT INTO 
							COMPANY_PARTNER_RELATION 
						(
							COMPANY_ID,
							PARTNER_COMPANY_ID,
							PARTNER_RELATION_ID,
							DETAIL,
							RECORD_EMP,
							RECORD_IP,
							RECORD_DATE
						) 
						VALUES 
						(
							#attributes.relation_info_id#,
							#evaluate("attributes.rel_row_id#i#")#,
							<cfif len(evaluate("attributes.get_rel#i#"))>#evaluate("attributes.get_rel#i#")#,<cfelse>NULL,</cfif>
							<cfif len(evaluate("attributes.detail#i#"))><cfqueryparam value="#wrk_eval('attributes.detail#i#')#" cfsqltype="cf_sql_varchar"><cfelse>NULL</cfif>,
							<cfif len(evaluate("attributes.record_emp#i#"))>#evaluate("attributes.record_emp#i#")#,<cfelse>#session.ep.userid#,</cfif><!--- eski kayıtların bilgisini kybetmemk için,satırlar update edildignde farklı sorunlar yaşanıyordu. --->
							<cfif len(evaluate("attributes.record_ip#i#"))><cfqueryparam cfsqltype="cf_sql_varchar" value="#wrk_eval('attributes.record_ip#i#')#">,<cfelse><cfqueryparam cfsqltype="cf_sql_varchar" value="#cgi.remote_addr#">,</cfif>
							<cfif len(evaluate("attributes.record_date#i#"))>#CreateODBCDateTime(evaluate("attributes.record_date#i#"))#<cfelse>#now()#</cfif>
						)
					</cfquery>
				<cfelseif attributes.action_type_info eq 2><!--- bireysel üyeler --->
					<cfquery name="add_cons_rel" datasource="#dsn#">
						INSERT INTO 
							CONSUMER_TO_CONSUMER
						(
							CONSUMER_ID,
							CONSUMER2_ID,
							RELATION_ID,
							DETAIL,
							VALID_TYPE,
							RECORD_EMP,
							RECORD_IP,
							RECORD_DATE
						)
						VALUES
						(
							#attributes.relation_info_id#,
							#evaluate("attributes.rel_row_id#i#")#,
							<cfif len(evaluate("attributes.get_rel#i#"))>#evaluate("attributes.get_rel#i#")#,<cfelse>NULL,</cfif> 
							<cfif len(evaluate("attributes.detail#i#"))><cfqueryparam cfsqltype="cf_sql_varchar" value="#wrk_eval('attributes.detail#i#')#">,<cfelse>NULL,</cfif>
							1,
							<cfif len(evaluate("attributes.record_emp#i#"))>#evaluate("attributes.record_emp#i#")#,<cfelse>#session.ep.userid#,</cfif><!--- eski kayıtların bilgisini kybetmemk için,satırlar update edildignde farklı sorunlar yaşanıyordu. --->
							<cfif len(evaluate("attributes.record_ip#i#"))><cfqueryparam cfsqltype="cf_sql_varchar" value="#wrk_eval('attributes.record_ip#i#')#">,<cfelse><cfqueryparam cfsqltype="cf_sql_varchar" value="#cgi.remote_addr#">,</cfif>
							<cfif len(evaluate("attributes.record_date#i#"))>#CreateODBCDateTime(evaluate("attributes.record_date#i#"))#<cfelse>#now()#</cfif>
						)
					</cfquery>
				<cfelseif attributes.action_type_info eq 3><!--- sistemler --->
					<cfquery name="add_subs_rel" datasource="#dsn3#">
						INSERT INTO 
						SUBSCRIPTION_CONTRACT_RELATIONS
						(
							SUBSCRIPTION_ID,
							RELATED_SUBSCRIPTION_ID,
							RELATION_TYPE_ID,
							DETAIL,
							RECORD_EMP,
							RECORD_IP,
							RECORD_DATE
						)
						VALUES
						(
							#attributes.relation_info_id#,
							#evaluate("attributes.rel_row_id#i#")#,
							<cfif len(evaluate("attributes.get_rel#i#"))>#evaluate("attributes.get_rel#i#")#,<cfelse>NULL,</cfif> 
							<cfif len(evaluate("attributes.detail#i#"))><cfqueryparam cfsqltype="cf_sql_varchar" value="#wrk_eval('attributes.detail#i#')#">,<cfelse>NULL,</cfif>
							<cfif len(evaluate("attributes.record_emp#i#"))>#evaluate("attributes.record_emp#i#")#,<cfelse>#session.ep.userid#,</cfif><!--- eski kayıtların bilgisini kybetmemk için,satırlar update edildignde farklı sorunlar yaşanıyordu. --->
							<cfif len(evaluate("attributes.record_ip#i#"))><cfqueryparam cfsqltype="cf_sql_varchar" value="#wrk_eval('attributes.record_ip#i#')#">,<cfelse><cfqueryparam cfsqltype="cf_sql_varchar" value="#cgi.remote_addr#">,</cfif>
							<cfif len(evaluate("attributes.record_date#i#"))>#CreateODBCDateTime(evaluate("attributes.record_date#i#"))#<cfelse>#now()#</cfif>
						)
					</cfquery>
				</cfif>
			</cfif>
		</cfloop>
	</cftransaction>
</cflock>
<cfif attributes.action_type_info eq 1>
	<cflocation url="#request.self#?fuseaction=member.form_list_company&event=upd&cpid=#attributes.relation_info_id#" addtoken="no">
<cfelse>
	<cfabort>
</cfif>
