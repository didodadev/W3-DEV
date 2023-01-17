<cfset sampling_points = createObject("component","WBP/Recycle/files/sample_analysis/cfc/sampling_points") />

<cfset updSamplingPoints = sampling_points.updSamplingPoints(
    sampling_id: attributes.sampling_id,
    sampling_points_name: attributes.sampling_points_name
) />

<cfset attributes.actionid = attributes.sampling_id />