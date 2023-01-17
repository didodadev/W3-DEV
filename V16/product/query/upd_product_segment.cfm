<cfquery name="upd_pro_seg" datasource="#dsn1#">
	UPDATE  
		PRODUCT_SEGMENT
	SET		
		PRODUCT_SEGMENT = <cfqueryparam cfsqltype="cf_sql_varchar" value="#PRO_SEG#">,
		PRODUCT_SEGMENT_DETAIL = <cfqueryparam cfsqltype="cf_sql_varchar" value="#DETAIL#">,
		MIN_POINT_1 = <cfif len(attributes.min_point_1)>#attributes.min_point_1#<cfelse>NULL</cfif>,
		MAX_POINT_1 = <cfif len(attributes.max_point_1)>#attributes.max_point_1#<cfelse>NULL</cfif>,
		MIN_POINT_2 = <cfif len(attributes.min_point_2)>#attributes.min_point_2#<cfelse>NULL</cfif>,
		MAX_POINT_2 = <cfif len(attributes.max_point_2)>#attributes.max_point_2#<cfelse>NULL</cfif>,
		MIN_POINT_3 = <cfif len(attributes.min_point_3)>#attributes.min_point_3#<cfelse>NULL</cfif>,
		MAX_POINT_3 = <cfif len(attributes.max_point_3)>#attributes.max_point_3#<cfelse>NULL</cfif>,
		UPDATE_DATE = #NOW()#,
		UPDATE_EMP = #SESSION.EP.USERID#,
		UPDATE_IP = <cfqueryparam cfsqltype="cf_sql_varchar" value="#CGI.REMOTE_ADDR#">
	WHERE 
		PRODUCT_SEGMENT_ID = #product_segment_id#
</cfquery>
<script type="text/javascript">
	window.location.replace(document.referrer + '&is_submit=1');
	<cfif not isdefined("attributes.draggable")>window.close();<cfelseif isdefined("attributes.draggable")>closeBoxDraggable( '<cfoutput>#attributes.modal_id#</cfoutput>' );</cfif>
</script>
