<cfquery name="ADD_QUIZ_REL" datasource="#DSN#">
  INSERT INTO
    QUIZ_RELATION
	(
	  QUIZ_ID,
	  QUIZ_HEAD
	  <cfif isdefined("attributes.training_id")>
	  ,TRAINING_ID
	  <cfelseif isdefined("attributes.class_id")>
	  ,CLASS_ID
	  </cfif>
	)
	VALUES
	(
	  #URL.QID#,
	 '#URL.QUIZ_HEAD#'
	  <cfif isdefined("attributes.training_id")>
	  ,#URL.TRAINING_ID#
	  <cfelseif isdefined("attributes.class_id")>
	  ,#URL.CLASS_ID#
	  </cfif>
	)
</cfquery>
