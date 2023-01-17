<cfset createObject("component","V16.settings.cfc.setupInspectionTypes").updInspectionType(
		inspection_type_id:attributes.inspection_type_id,
		inspection_type:attributes.inspection_type
	) />
<cflocation addtoken="no" url="#request.self#?fuseaction=settings.form_add_inspection_type">
