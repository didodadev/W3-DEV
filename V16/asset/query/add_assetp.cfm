<cftransaction>
	<cfquery name="ADD_ASSETP" datasource="#dsn#" result="MAX_ID">
		INSERT INTO 
			ASSET_P
				(
				INVENTORY_NUMBER,
				DEPARTMENT_ID,
				POSITION_CODE,
				POSITION_CODE2,
				ASSETP_CATID,
				ASSETP,
				ASSETP_DETAIL,
				RECORD_DATE,
				RECORD_EMP,
				RECORD_IP,
				STATUS,
				UPDATE_DATE,
				UPDATE_EMP,
				UPDATE_IP
				)
		VALUES
				(
				'#attributes.INVENTORY_NUMBER#',
				#DEPARTMENT_ID#,
				#attributes.POSITION_CODE#,
				<cfif len(attributes.position_code2)>#attributes.position_code2#,<cfelse>null,</cfif>
				#attributes.ASSETP_CATID#,
				'#attributes.ASSETP#',
				'#attributes.ASSETP_DETAIL#',
				#NOW()#,
				#SESSION.EP.USERID#,
				'#CGI.REMOTE_ADDR#',
				1,
				#NOW()#,
				#SESSION.EP.USERID#,
				'#CGI.REMOTE_ADDR#'
				)
	</cfquery>
		<cfquery name="ADD_HISTORY" datasource="#DSN#">
			INSERT INTO
				ASSET_P_HISTORY
				(
				  ASSETP_ID,
				  ASSETP_CATID,
				  STATUS,
				  DEPARTMENT_ID,
				  POSITION_CODE,
				  POSITION_CODE2,
				  ASSETP,
				  INVENTORY_NUMBER,
				  RECORD_DATE,
				  RECORD_EMP,
				  RECORD_IP
				)
				VALUES
				(
					#MAX_ID.IDENTITYCOL#,
					#attributes.assetp_catid#,
					1,
					#attributes.department_id#,
					#attributes.position_code#,
				<cfif len(attributes.position_code2)>
					#attributes.position_code2#,
				<cfelse>
					NULL,
				</cfif> 
					'#attributes.assetp#',
					'#attributes.inventory_number#',
					 #now()#,
					 #session.ep.userid#,
					 '#cgi.remote_addr#'
				)
		</cfquery>
</cftransaction>
<cflocation url="#request.self#?fuseaction=asset.form_upd_assetp&assetp_id=#MAX_ID.IDENTITYCOL#" addtoken="no">
