<cfset createObject("component","V16.settings.cfc.setupInspectionTypes").addInspectionType(
		inspection_type:attributes.inspection_type
	) />
<cflocation addtoken="no" url="#request.self#?fuseaction=settings.form_add_inspection_type">
