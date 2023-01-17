<cfquery name="CHECK_TARGET" datasource="#dsn#">
	SELECT 
		TARGET_HEAD 
	FROM 
		TARGET
	WHERE
		TARGET_ID IS NOT NULL
	<cfif isDefined("FORM.TARGET_HEAD") and len(FORM.TARGET_HEAD)>
		AND TARGET_HEAD = '#FORM.TARGET_HEAD#'
	</cfif>
	<cfif isDefined("FORM.PARTNER_ID")>
		AND PARTNER_ID = #FORM.PARTNER_ID#
	<cfelseif isDefined("FORM.BRANCH_ID")>
		AND BRANCH_ID = #FORM.BRANCH_ID#
	<cfelseif isDefined("FORM.COMPANY_ID")>
		AND COMPANY_ID = #FORM.COMPANY_ID#
	</cfif>
</cfquery>

<cfif check_target.recordcount>
	<script type="text/javascript">
	history.go(-1);
	alert("<cf_get_lang no='19.Aynı Hedef Başlığı Kullanamazsınız !'>");
	</script>
	<cfabort>
</cfif>
<cfquery name="TARGET" datasource="#dsn#">
	INSERT INTO
		TARGET
	(
		<cfif isDefined("attributes.branch_id")>BRANCH_ID,</cfif>
		<cfif isDefined("attributes.PARTNER_ID")>PARTNER_ID,</cfif>
		<cfif isDefined("attributes.company_id")>COMPANY_ID,</cfif>
		STARTDATE,
		FINISHDATE,
		TARGETCAT_ID,
		TARGET_HEAD,
		TARGET_NUMBER,
		TARGET_DETAIL
	)
	VALUES
	(
		<cfif isDefined("attributes.branch_id")>#attributes.BRANCH_ID#,</cfif>
		<cfif isDefined("attributes.PARTNER_ID")>#attributes.PARTNER_ID#,</cfif>
		<cfif isDefined("attributes.company_id")>#attributes.COMPANY_ID#,</cfif>
		<cfif isDefined("attributes.STARTDATE")>#attributes.STARTDATE#,</cfif>
		<cfif isDefined("attributes.FINISHDATE")>#attributes.FINISHDATE#,</cfif>
		<cfif isDefined("attributes.TARGETCAT_ID")>#attributes.TARGETCAT_ID#,</cfif>
		<cfif isDefined("attributes.TARGET_HEAD")>
		'#attributes.TARGET_HEAD#',
		</cfif>
		<cfif isDefined("attributes.TARGET_NUMBER")>
		#attributes.TARGET_NUMBER#,
		</cfif>
		<cfif isDefined("attributes.TARGET_DETAIL")>
		'#attributes.TARGET_DETAIL#'
		</cfif>
	)
</cfquery>
<script type="text/javascript">
	wrk_opener_reload();
	window.close();
</script>
