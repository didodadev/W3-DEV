<cfquery name="ADD_CARE_REFERENCE" datasource="#dsn#">
	INSERT INTO 
		ASSET_P_CARE_REFERENCE
    (
        CARE_TYPE_ID,
        BRAND_TYPE_ID,
        MAKE_YEAR,
        START_KM,
        FINISH_KM,
        PERIOD_KM,
        RECORD_EMP,
        RECORD_IP,
        RECORD_DATE
    ) 
    VALUES 
    (
        #attributes.care_type_id#,
        #attributes.brand_type_id#,
        #attributes.make_year#,
        #attributes.start_km#,
        #attributes.finish_km#,
        #attributes.period_km#,
        #session.ep.userid#,
        '#cgi.remote_addr#',
        #now()#
    )
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
