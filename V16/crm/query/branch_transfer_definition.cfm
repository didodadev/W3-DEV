<cfif attributes.record_num neq 0>
	<cflock timeout="60">
		<cftransaction>
			<cfloop from="1" to="#attributes.record_num#" index="i">
				<cfscript>
					form_row_kontrol = evaluate("attributes.row_kontrol#i#");
					form_definition_id = evaluate("attributes.definition_id#i#");
					form_branch_id = evaluate("attributes.branch_id#i#");
					form_branch_name = evaluate("attributes.branch_name#i#");
					form_table_name = evaluate("attributes.table_name#i#");
				</cfscript>		
				<cfif form_row_kontrol>
					<!--- Yeni kayit --->
					<cfif not len(form_definition_id)>
						<cfquery name="ADD_BRANCH_TRANSFER_DEFINITION" datasource="#DSN#">
							INSERT INTO
								BRANCH_TRANSFER_DEFINITION
							(
								BRANCH_ID,
								BRANCH_NAME,
								TABLE_NAME,
								RECORD_DATE,
								RECORD_EMP,
								RECORD_IP						
							)
							VALUES
							(
								#form_branch_id#,
								'#form_branch_name#',
								'#form_table_name#',						
								#now()#,
								#session.ep.userid#,
								'#cgi.remote_addr#'
							)
						</cfquery>
					<cfelse>
						<!--- eski kayit --->
						<cfquery name="UPD_BRANCH_TRANSFER_DEFINITION" datasource="#DSN#">
							UPDATE
								BRANCH_TRANSFER_DEFINITION
							SET					
								BRANCH_ID = #form_branch_id#,
								BRANCH_NAME = '#form_branch_name#',
								TABLE_NAME = '#form_table_name#',
								RECORD_DATE = #now()#,
								RECORD_EMP = #session.ep.userid#,
								RECORD_IP = '#cgi.remote_addr#'						
							WHERE
								DEFINITION_ID = #form_definition_id#
						</cfquery>
					</cfif>
				<cfelse>
					<cfif len(form_definition_id)>
						<!--- Kayıt silme --->
						<cfquery name="DEL_BRANCH_TRANSFER_DEFINITION" datasource="#DSN#">
							DELETE 
								BRANCH_TRANSFER_DEFINITION 
							WHERE 
								DEFINITION_ID = #form_definition_id#
						</cfquery>
					</cfif>
				</cfif>
			</cfloop>
		</cftransaction>
	</cflock>
</cfif>
<cflocation url="#cgi.http_referer#" addtoken="no">
