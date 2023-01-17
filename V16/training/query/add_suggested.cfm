<cfquery name="add_suggest" datasource="#dsn#">
	INSERT INTO
		TRAINING_RECOMMENDATIONS
		(
			USER_ID,
			USER_TYPE,
			DETAIL,
			CLASS_ID,
			RECORD_DATE,
			RECORDED_ID,
			RECORDED_TYPE,
			IS_READ
		)
	VALUES
	   (
			<cfif len(attributes.emp_id)>#attributes.emp_id#,<cfelseif len(attributes.par_id)>#attributes.par_id#,<cfelseif len(attributes.cons_id)>#attributes.cons_id#,</cfif>
			<cfif len(attributes.emp_id)>0,<cfelseif len(attributes.par_id)>1,<cfelseif len(attributes.cons_id)>2,</cfif>
			<cfif len('attributes.detail')>'#left(attributes.detail,200)#',<cfelse>NULL,</cfif>
			#attributes.class_id#,
			#now()#,
			<cfif isdefined('session.ep.userid')>
			#session.ep.userid#,
			<cfelseif isdefined('session.pp.userid')>
			#session.pp.userid#,
			<cfelseif isdefined('session.ww.userid')>
			#session.ww.userid#,
			</cfif>
			<cfif isdefined('session.ep.userid')>0<cfelseif isdefined('session.pp.userid')>1<cfelseif isdefined('session.ww.userid')>2</cfif>,
			0
	   )
</cfquery>
<script type="text/javascript">
	<cfif isdefined("attributes.draggable")>
		closeBoxDraggable( '<cfoutput>#attributes.modal_id#</cfoutput>' );
	<cfelse>
		wrk_opener_reload();
		window.close();
	</cfif>
</script>