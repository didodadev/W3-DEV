<cfquery name="GET_POSCAT_TRAININGS" datasource="#dsn#">
SELECT 
	TRAIN_ID, TRAIN_POSITION_CATS, TRAIN_HEAD
FROM 
	TRAINING
WHERE 
    TRAIN_POSITION_CATS LIKE '%,#attributes.position_id#,%'
	<!--- AND
	IS_ACTIVE = 1 --->
</cfquery>






