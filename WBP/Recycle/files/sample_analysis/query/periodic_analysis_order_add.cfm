<cfset periodic_analysis_order = createObject("component","WBP/Recycle/files/sample_analysis/cfc/periodic_analysis_order") />

<cfif len( attributes.sample_points_date_entry )>
    <cf_date tarih="attributes.sample_points_date_entry">
    <cfif len( attributes.sample_points_date_entry_hour )><cfset attributes.sample_points_date_entry = date_add("h", attributes.sample_points_date_entry_hour, attributes.sample_points_date_entry)></cfif>
    <cfif len( attributes.sample_points_date_entry_minute )><cfset attributes.sample_points_date_entry = date_add("n", attributes.sample_points_date_entry_minute, attributes.sample_points_date_entry)></cfif>
</cfif>

<cfset addPeriodicAnalysisOrder = periodic_analysis_order.addPeriodicAnalysisOrder(
    sampling_id: attributes.sampling_id,
    sample_points_date_entry: attributes.sample_points_date_entry,
    period: attributes.period,
    sample_points_reason: attributes.sample_points_reason
) />

<cfset attributes.actionid = addPeriodicAnalysisOrder.identitycol />