<cfset train_group_id = attributes.joined.split(",") >
<cfset k_id = attributes.k_id.split(",") >
<cfset type = attributes.type.split(",") >
<cfif attributes.row_count>
	<cfloop from="1" to="#attributes.row_count#" index="i">
		<cfoutput>
			#train_group_id[i]# - #k_id[i]# - #type[i]# <br>
		</cfoutput>
	</cfloop>
	<cfabort>
		<cfquery name="upd_attender" datasource="#dsn#">
			UPDATE
				TRAINING_CLASS_ATTENDER
			SET
				COMMENT = <cfif len(evaluate('attributes.comment_#i#'))><cfqueryparam cfsqltype="cf_sql_varchar" value="#evaluate('attributes.comment_#i#')#"><cfelse>NULL</cfif>
				<cfif isdefined('attributes.participation_rate_#i#')>,PARTICIPATION_RATE = <cfif len(evaluate('attributes.participation_rate_#i#'))><cfqueryparam cfsqltype="cf_sql_float" value="#evaluate('attributes.participation_rate_#i#')#"><cfelse>NULL</cfif></cfif> 
			WHERE
				CLASS_ATTENDER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#evaluate('attributes.attender_id_#i#')#">
		</cfquery>
</cfif>
<cflocation url="#request.self#?fuseaction=training_management.popup_list_class_attenders&class_id=#class_id#" addtoken="No">
