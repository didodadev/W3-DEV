<cfquery name="UPD_ASSETP" datasource="#dsn#">
	UPDATE
		ASSET_P
	SET
		DEPARTMENT_ID = #attributes.DEPARTMENT_ID#,
		POSITION_CODE = #attributes.POSITION_CODE#,
		POSITION_CODE2 = <cfif len(attributes.position_code2)>#attributes.position_code2#,<cfelse>null,</cfif>
		ASSETP_CATID = #attributes.ASSETP_CATID#,
		ASSETP_STATUS = #attributes.support_cat#,
		ASSETP = '#attributes.ASSETP#',
		ASSETP_DETAIL = '#attributes.ASSETP_DETAIL#',
		STATUS = <cfif isDefined("attributes.status")>1,<cfelse>0,</cfif>
		UPDATE_DATE = #NOW()#,
		UPDATE_EMP = #SESSION.EP.USERID#,
		UPDATE_IP = '#CGI.REMOTE_ADDR#',
		INVENTORY_NUMBER = '#ATTRIBUTES.inventory_number#' 
	WHERE
		ASSETP_ID = #attributes.ASSETP_ID#
</cfquery>
<cfquery name="ADD_HISTORY" datasource="#DSN#">
	INSERT INTO
		ASSET_P_HISTORY
		(
		  ASSETP_ID,
		  ASSETP_CATID,
		  ASSETP_STATUS,
		  DEPARTMENT_ID,
		  POSITION_CODE,
		  POSITION_CODE2,
		  ASSETP,
		  INVENTORY_NUMBER,
		  UPDATE_DATE,
		  UPDATE_EMP,
		  UPDATE_IP
		)
		VALUES
		(
			#attributes.ASSETP_ID#,
			#attributes.assetp_catid#,
			#attributes.support_cat#,
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
<!--- BK kapatti 20080213 120 gune siline
<cfquery name="UPD_PHYSICAL_ACHINE_INFO" datasource="#dsn#">
	UPDATE
		PHYSICAL_ASSET_INFO
	SET
		STATUS = <cfif isDefined("attributes.status")>1,<cfelse>0,</cfif>
		IS_ACTIVE = <cfif isDefined("attributes.status")>1<cfelse>0</cfif>
	WHERE
		ASSET_ID = #attributes.ASSETP_ID#
</cfquery> --->
<cfif isdefined("attributes.status")>
	<cflocation url="#request.self#?fuseaction=asset.form_upd_assetp&assetp_id=#attributes.assetp_id#" addtoken="no">
<cfelse>
	<cflocation url="#request.self#?fuseaction=asset.list_assetp" addtoken="no">
</cfif>
