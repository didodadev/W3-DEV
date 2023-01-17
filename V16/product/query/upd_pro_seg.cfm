<cfquery name="del_seg_branch" datasource="#DSN1#">
	DELETE PRODUCT_SEGMENT_BRANCH WHERE PRODUCT_SEGMENT_ID = #attributes.pro_seg_id# 
</cfquery>
<cfif isDefined("FORM.BRANCH_ID")>
	<cfloop list="#FORM.BRANCH_ID#" index="I">
		<cfquery name="ADD_SEGMENT_BRANCH" datasource="#DSN1#">
			INSERT INTO
				PRODUCT_SEGMENT_BRANCH
			(
				PRODUCT_SEGMENT_ID,
				PRODUCT_SEGMENT_BRANCH_ID
			)
			VALUES
			(
				#attributes.pro_seg_id#,
				#I# 
			)
		</cfquery>
	</cfloop>
</cfif>
<script type="text/javascript">
	window.location.replace(document.referrer + '&is_submit=1');
	<cfif not isdefined("attributes.draggable")>window.close();<cfelseif isdefined("attributes.draggable")>closeBoxDraggable( '<cfoutput>#attributes.modal_id#</cfoutput>' );</cfif>
</script>