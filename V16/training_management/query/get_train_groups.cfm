<cfquery name="GET_GROUP" datasource="#DSN#">
	SELECT
        TCG.*,
        D.*,
        B.*
	FROM
        TRAINING_CLASS_GROUPS TCG
            INNER JOIN DEPARTMENT D ON D.DEPARTMENT_ID = TCG.DEPARTMENT_ID
            INNER JOIN BRANCH B ON B.BRANCH_ID = TCG.BRANCH_ID
	WHERE
		TCG.TRAIN_GROUP_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.train_group_id#">
</cfquery>

