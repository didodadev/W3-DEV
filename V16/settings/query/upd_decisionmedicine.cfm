<cfif not isdefined('attributes.medicine_status')>
	<cfset attributes.medicine_status = 0>
</cfif>
<cfset createObject("component","V16.settings.cfc.setupDecisionmedicine").updDecisionmedicine(
		decision_medicine_id:attributes.decision_medicine_id,
		barcode:attributes.barcode,
		decision_medicine:attributes.decision_medicine,
		active_ingredient:attributes.active_ingredient,
		is_default:attributes.medicine_status
	) />
<cflocation addtoken="no" url="#request.self#?fuseaction=settings.form_upd_decisionmedicine&decision_medicine_id=#attributes.decision_medicine_id#">
