<cfsetting showdebugoutput="no">
<cfset createObject("component","worknet.objects.worknet_objects").addRemoveFavorite(
		action_id:attributes.action_id,
		action_type:attributes.action_type,
		add:attributes.add
) />
<cfabort> 
