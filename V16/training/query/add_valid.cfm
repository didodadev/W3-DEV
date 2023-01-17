<cfloop from="1" to="#listlen(attributes.row_id,',')#" index="i">
	<cfif isdefined(evaluate('attributes.isvalid#listgetat(attributes.row_id,i,',')#'))>
		<cfoutput>#evaluate('attributes.isvalid#listgetat(attributes.row_id,i,',')#')#</cfoutput><br/>
	</cfif>
</cfloop>
<cflocation url="#request.self#?fuseaction=training.form_add_training_bossvalid" addtoken="no">
