<cfsetting showdebugoutput="no">
<cfquery name="get_training_groups" datasource="#dsn#">
	SELECT
		TCG.GROUP_HEAD,
        TCGC.CLASS_GROUP_ID,
        TCGC.TRAIN_GROUP_ID
	FROM
		TRAINING_CLASS_GROUPS TCG 
		LEFT JOIN TRAINING_CLASS_GROUP_CLASSES TCGC ON TCG.TRAIN_GROUP_ID = TCGC.TRAIN_GROUP_ID
		LEFT JOIN TRAINING_CLASS TC ON TC.CLASS_ID=TCGC.CLASS_ID
	WHERE
		TC.CLASS_ID = #attributes.class_id# 
</cfquery>
<cf_ajax_list>
	<cfif (get_training_groups.recordcount neq 0) or (get_training_groups.recordcount neq 0)>
	<cfif (get_training_groups.recordcount)>
		<cfoutput query="get_training_groups">
			<tr>
				<td><a href="#request.self#?fuseaction=training_management.list_training_groups&event=upd&train_group_id=#train_group_id#" target="_blank">#GROUP_HEAD#</a></td>
				<td width="15" align="right"><a href="javascript://" onClick="windowopen('#request.self#?fuseaction=training_management.emptypopup_del_class_from_group&reason=Gerekçesiz&class_id=#attributes.class_id#&class_group_id=#class_group_id#&train_group_id=#train_group_id#','date');"><img src="images/delete_list.gif" border="0"></a></td>
			</tr>
		</cfoutput>
	</cfif>
	<cfelseif (get_training_groups.recordcount EQ 0)>
		<tr><td><cfoutput>#getlang('main',72,'kayit yok')#</cfoutput> !</td></tr>
	</cfif>
</cf_ajax_list>
