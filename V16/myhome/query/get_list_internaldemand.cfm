<cfquery name="get_list_internaldemand" datasource="#dsn3#">
	SELECT 
	   INTERNAL_ID,
	   IS_ACTIVE,
	   INTERNALDEMAND_STATUS,
	   INTERNALDEMAND_STAGE,
	   DEMAND_TYPE,
	   TARGET_DATE,
       RECORD_EMP,
	   FROM_POSITION_CODE,
	   SUBJECT
	FROM 
	   INTERNALDEMAND
	WHERE		
		TO_POSITION_CODE = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.position_code#"> AND
		(RECORD_DATE <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#"> OR TARGET_DATE >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#"> )
        AND <!--- teklİF ya da siparise donustuyse gelmesin --->
        (
        	INTERNAL_ID NOT IN(SELECT INTERNALDEMAND_ID FROM OFFER WHERE OFFER.INTERNALDEMAND_ID = INTERNALDEMAND.INTERNAL_ID) 
            AND 
			INTERNALDEMAND.INTERNAL_NUMBER NOT IN(SELECT item FROM ORDERS   OUTER APPLY
                            (
                                SELECT item FROM #dsn#.[fnSplit](ORDERS.REF_NO,',')
                            ) AS XXX where XXX.item = INTERNALDEMAND.INTERNAL_NUMBER)
        )
	ORDER BY
		TARGET_DATE DESC
</cfquery>
