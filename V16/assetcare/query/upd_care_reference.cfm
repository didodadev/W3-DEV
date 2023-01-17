<cfquery name="UPD_CARE_REFERENCE" datasource="#dsn#">
	UPDATE 
		ASSET_P_CARE_REFERENCE
	SET
		CARE_TYPE_ID = #attributes.care_type_id#,
		BRAND_TYPE_ID = #attributes.brand_type_id#,
		MAKE_YEAR = #attributes.make_year#,
		START_KM = #attributes.start_km#,
		FINISH_KM = #attributes.finish_km#,
		PERIOD_KM = #attributes.period_km#,
		UPDATE_EMP =#session.ep.userid#,
		UPDATE_IP = '#cgi.remote_addr#',
		UPDATE_DATE = #now()#
	WHERE
		CARE_REFERENCE_ID = #attributes.care_reference_id#
</cfquery>

<cfif isdefined("attributes.is_detail")>
<script type="text/javascript">
	window.parent.frame_care_reference_list.location.reload();
	window.parent.frame_care_reference.location.href='<cfoutput>#request.self#?fuseaction=assetcare.popup_add_care_reference</cfoutput>&iframe=1';
</script>
<cfelse>
<script type="text/javascript">
	wrk_opener_reload();
	self.close();
</script>
</cfif>
