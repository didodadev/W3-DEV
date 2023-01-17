<cfquery name="inspection_class" datasource="#DSN#">
  UPDATE 
    TRAINING_CLASS_ATTENDER
  SET
    STATUS = #attributes.status#,
    DETAIL = '#attributes.detail#'
  WHERE
     CLASS_ID = #URL.CLASS_ID# AND
	 <cfif isdefined('session.ep')>
		 EMP_ID = #SESSION.EP.USERID#
	<cfelseif isdefined('session.pp')>
		 PAR_ID = #SESSION.PP.USERID#
	<cfelseif isdefined('session.ww.userid')>
		 CONS_ID = #SESSION.WW.USERID#
	</cfif>
</cfquery>
<cflocation url="#request.self#?fuseaction=training.view_class&class_id=#url.class_id#" addtoken="no">

