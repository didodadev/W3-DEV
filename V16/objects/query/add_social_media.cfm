<!--- Sirkete Ait Social Media Linklerini Ekleme Sayfası --->
<cfquery name="get_social_media" datasource="#dsn#">
	SELECT SMCAT,SMCAT_ID,SMCAT_LINK_TYPE FROM SETUP_SOCIAL_MEDIA_CAT ORDER BY SMCAT
</cfquery>
<cfquery name="check_address" datasource="#dsn#">
	SELECT ACTION_ID FROM SOCIAL_MEDIA WHERE ACTION_ID = #attributes.action_id# AND SMCAT_ID = #attributes.sm_cat_id#
</cfquery>
	<cfquery name="del_social_media_record" datasource="#dsn#">			
			DELETE FROM 
				SOCIAL_MEDIA 
			WHERE 
				ACTION_ID = #attributes.action_id#
		</cfquery>
<cfif len(attributes.record_num) and attributes.record_num neq "">
<cfloop from="1" to="#attributes.record_num#" index="i">
	<cfif isdefined("attributes.row_kontrol#i#") and evaluate("attributes.row_kontrol#i#")>	 		
	<cfset newString = '#get_social_media.SMCAT_LINK_TYPE#' & '#evaluate('attributes.link_#i#')#'>
		<cfif len(evaluate('attributes.link_#i#'))>
		<cfquery name="add_social_media" datasource="#dsn#"> 				
				INSERT INTO
					SOCIAL_MEDIA
				(
					SMCAT_ID,
					ACTION_ID,
					ACTION_TYPE,
					LINK_1,
					LINK_2
				)
				VALUES
				(
					#evaluate("attributes.category_id#i#")#,
					#attributes.action_id#,
					'#attributes.action_type#',
					'#evaluate('attributes.link_#i#')#',
					'#newString#'
				)
			</cfquery>		
		</cfif>
	<cfset newString = ''>
	</cfif>
	</cfloop>
</cfif>
<script type="text/javascript">
	<cfif not (isDefined('attributes.draggable') and len(attributes.draggable))>
		wrk_opener_reload();
	<cfelse>
		closeBoxDraggable( '<cfoutput>#attributes.modal_id#</cfoutput>');
	</cfif>
</script>
