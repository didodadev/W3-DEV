<cfquery name="GET_MONTHLY_CLASSES" datasource="#dsn#">
	SELECT 
		TRAINING_CLASS.TRAINING_SEC_ID,
		TRAINING_CLASS.TRAINING_ID,
		TRAINING_CLASS.CLASS_ID,
		TRAINING_CLASS.CLASS_NAME,
		TRAINING_CLASS.CLASS_OBJECTIVE,
		TRAINING_CLASS.START_DATE,
		TRAINING_CLASS.FINISH_DATE,
		TRAINING_CLASS.ONLINE,
		TRAINING_CLASS_ATTENDER.CLASS_ID,
		TRAINING_CLASS_ATTENDER.EMP_ID,
		TRAINING_CLASS_ATTENDER.PAR_ID,
		TRAINING_CLASS_ATTENDER.CON_ID,
		TRAINING_CLASS_ATTENDER.GRP_ID
	FROM 
		TRAINING_CLASS ,
		TRAINING_CLASS_ATTENDER 
	WHERE
		 TRAINING_CLASS.CLASS_ID = TRAINING_CLASS_ATTENDER.CLASS_ID
		<cfif isDefined("SESSION.PDA_USERID")>
		<!--- BASKASINDA --->
			<cfif SESSION.PDA_USER_TYPE IS "E">
				AND
			<!--- EMP --->
				TRAINING_CLASS_ATTENDER.EMP_ID = #SESSION.PDA_USERID#
			<cfelseif SESSION.PDA_USER_TYPE IS "P">
				AND
				TRAINING_CLASS_ATTENDER.PAR_ID = #SESSION.PDA_USERID#
			<cfelseif SESSION.PDA_USER_TYPE IS "C">
				AND
				TRAINING_CLASS_ATTENDER.CON_ID = #SESSION.PDA_USERID#
			</cfif>
		<cfelse>
		<!--- KENDINDE --->
				AND
			TRAINING_CLASS_ATTENDER.EMP_ID = #SESSION.PDA.USERID#
		</cfif>
		 AND
		 (
		   (
		      <!---TRAINING_CLASS.START_DATE >= #NOW()#--->
			   TRAINING_CLASS.START_DATE >= #attributes.to_day#
		        AND
		      TRAINING_CLASS.START_DATE < #DATEADD("M",1,attributes.to_day)#
			)
			  OR
			(
			  <!---TRAINING_CLASS.FINISH_DATE >= #NOW()#--->
			  TRAINING_CLASS.FINISH_DATE >= #attributes.to_day#
		  	    AND
			  TRAINING_CLASS.FINISH_DATE < #DATEADD("M",1,attributes.to_day)#
			) 
		 )
	ORDER BY 
		TRAINING_CLASS.START_DATE
</cfquery> 
