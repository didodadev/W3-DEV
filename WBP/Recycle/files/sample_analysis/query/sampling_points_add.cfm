<cfset sampling_points = createObject("component","WBP/Recycle/files/sample_analysis/cfc/sampling_points") />

<cfset addSamplingPoints = sampling_points.addSamplingPoints(
    sampling_points_name: attributes.sampling_points_name
) />

<cfset attributes.actionid = addSamplingPoints.identitycol />