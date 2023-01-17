<cfsetting showdebugoutput="no">
<cfif isdefined("attributes.cat_id") and len(attributes.cat_id)>
	<cf_wrk_selectlang
	 name="training_sec_id"
	 style="width:250px;"
	 option_name="SECTION_NAME"
	 option_value="TRAINING_SEC_ID"
	 table_name="TRAINING_SEC"
	 condition="TRAINING_CAT_ID = #attributes.cat_id#">
</cfif>
