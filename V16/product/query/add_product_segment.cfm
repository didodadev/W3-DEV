<cfquery name="ADD_SEGMENT" datasource="#dsn1#">
	INSERT INTO 
		PRODUCT_SEGMENT 
		(
			PRODUCT_SEGMENT,
			PRODUCT_SEGMENT_DETAIL,
			MIN_POINT_1,
			MAX_POINT_1,
			MIN_POINT_2,
			MAX_POINT_2,
			MIN_POINT_3,
			MAX_POINT_3,
			RECORD_EMP,
			RECORD_DATE,
			RECORD_IP
		)
	VALUES	
		(
			<cfqueryparam cfsqltype="cf_sql_varchar" value="#PRO_SEG#">,
			<cfqueryparam cfsqltype="cf_sql_varchar" value="#DETAIL#">,
			<cfif len(attributes.min_point_1)>#attributes.min_point_1#<cfelse>NULL</cfif>,
			<cfif len(attributes.max_point_1)>#attributes.max_point_1#<cfelse>NULL</cfif>,
			<cfif len(attributes.min_point_2)>#attributes.min_point_2#<cfelse>NULL</cfif>,
			<cfif len(attributes.max_point_2)>#attributes.max_point_2#<cfelse>NULL</cfif>,
			<cfif len(attributes.min_point_3)>#attributes.min_point_3#<cfelse>NULL</cfif>,
			<cfif len(attributes.max_point_3)>#attributes.max_point_3#<cfelse>NULL</cfif>,
			#session.ep.userid#, 
			#now()#,
			<cfqueryparam cfsqltype="cf_sql_varchar" value="#REMOTE_ADDR#">
		)
</cfquery>
<script type="text/javascript">
	window.location.replace(document.referrer + '&is_submit=1');
	<cfif not isdefined("attributes.draggable")>window.close();<cfelseif isdefined("attributes.draggable")>closeBoxDraggable( '<cfoutput>#attributes.modal_id#</cfoutput>' );</cfif>
</script>