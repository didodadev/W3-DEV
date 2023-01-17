<cfif not isdefined('attributes.medicine_status')>
	<cfset attributes.medicine_status = 0>
</cfif>
<cfset createObject("component","V16.settings.cfc.setupDecisionmedicine").addDecisionmedicine(
		barcode:attributes.barcode,
		decisionmedicine:attributes.decisionmedicine,
		active_ingredient:attributes.active_ingredient,
		is_default:attributes.medicine_status
	) />
<cfif isdefined("attributes.is_popup") and  attributes.is_popup eq 1>
	<script type="text/javascript">
		window.close();
	</script>
<cfelse>
	<cfquery name="get_last_id" datasource="#dsn#">
		SELECT MAX(DECISION_MEDICINE_ID) AS LAST_ID FROM SETUP_DECISIONMEDICINE
	</cfquery>
	<cflocation addtoken="no" url="#request.self#?fuseaction=settings.form_upd_decisionmedicine&decision_medicine_id=#get_last_id.LAST_ID#">
</cfif>

