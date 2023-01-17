<!---TolgaS 20060228 acele doalyısı ile bu sayfa relation_segment tablosnua drek kayıt atıyor ancak bunun yerine customtagle çalışması daha verimli olur--->
<cflock name="#CreateUUID()#" timeout="30">
<cftransaction>
	<cfif isdefined("attributes.all_req_type_ids") and len(attributes.all_req_type_ids)>
		<cfquery name="del_per" datasource="#dsn#">
			DELETE FROM 
				RELATION_SEGMENT 
			WHERE
				RELATION_FIELD_ID IN(#attributes.all_req_type_ids#)
				AND RELATION_TABLE='POSITION_REQ_TYPE'
				AND RELATION_ACTION=<cfif len(attributes.company_id)>1<cfelseif len(attributes.dept_id)>2</cfif>
				AND RELATION_ACTION_ID=<cfif len(attributes.company_id)>#attributes.company_id#<cfelseif len(attributes.dept_id)>#attributes.dept_id#</cfif>
		</cfquery>
	</cfif>
	<cfif isdefined('attributes.req_type_ids') and listlen(attributes.req_type_ids,',')>
		<cfif len(attributes.company_id) or len(attributes.dept_id)>
			
			<cfloop list="#req_type_ids#" index="i" delimiters=",">
				<cfquery name="add_per" datasource="#dsn#">
					INSERT INTO 
						RELATION_SEGMENT
						(
							RELATION_TABLE,
							RELATION_FIELD_ID,
							RELATION_ACTION,
							RELATION_ACTION_ID
						)VALUES
						(
							'POSITION_REQ_TYPE',
							#i#,
							<cfif len(attributes.company_id)>1<cfelseif len(attributes.dept_id)>2</cfif>,
							<cfif len(attributes.company_id)>#attributes.company_id#<cfelseif len(attributes.dept_id)>#attributes.dept_id#</cfif>
						)
				</cfquery>
			</cfloop>
		</cfif>
	</cfif>
	</cftransaction>
</cflock>
<script type="text/javascript">
	wrk_opener_reload();
	window.close();
</script>
