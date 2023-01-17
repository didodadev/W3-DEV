<cfquery name="GET_PRIZE_TYPE" datasource="#DSN#">
  SELECT 
    IS_ACTIVE,
    PRIZE_TYPE_ID,
    #dsn#.Get_Dynamic_Language(PRIZE_TYPE_ID,'#session.ep.language#','SETUP_PRIZE_TYPE','PRIZE_TYPE',NULL,NULL,PRIZE_TYPE) AS PRIZE_TYPE
  FROM 
    SETUP_PRIZE_TYPE
  WHERE
  	PRIZE_TYPE LIKE '%#ATTRIBUTES.KEYWORD#%' COLLATE SQL_Latin1_General_CP1_CI_AI
</cfquery>
