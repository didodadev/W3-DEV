<cfquery name="clear_icra" datasource="#dsn#">
	DELETE 
		COMMANDMENT_ROWS 
	WHERE 
		EMPLOYEE_PUANTAJ_ID NOT IN (SELECT EMPLOYEE_PUANTAJ_ID FROM EMPLOYEES_PUANTAJ_ROWS_EXT WHERE RELATED_TABLE = 'COMMANDMENT')
</cfquery>

<cfquery name="upd_" datasource="#dsn#">
	UPDATE
		COMMANDMENT
	SET
		ODENEN = ISNULL((SELECT SUM(CLOSED_AMOUNT) FROM COMMANDMENT_ROWS WHERE COMMANDMENT_ID = COMMANDMENT.COMMANDMENT_ID),0)
	WHERE
		COMMANDMENT_TYPE = 1
</cfquery>


<cfquery name="get_new_rows" datasource="#dsn#">
	SELECT 
		EPRE.AMOUNT_2,
		EPRE.AMOUNT,
		EPR.EMPLOYEE_ID,
		EPR.EMPLOYEE_PUANTAJ_ID,
		EP.SAL_YEAR,
		EP.SAL_MON,
		C.COMMANDMENT_ID,
		C.COMMANDMENT_TYPE
	FROM 
		EMPLOYEES_PUANTAJ_ROWS_EXT EPRE,
		EMPLOYEES_PUANTAJ_ROWS EPR,
		EMPLOYEES_PUANTAJ EP,
		COMMANDMENT C
	WHERE		
		EPRE.RELATED_TABLE = 'COMMANDMENT' AND
		C.COMMANDMENT_ID = EPRE.RELATED_TABLE_ID AND
		EPRE.EMPLOYEE_PUANTAJ_ID = EPR.EMPLOYEE_PUANTAJ_ID AND
		EPR.PUANTAJ_ID = EP.PUANTAJ_ID AND
		EPRE.EMPLOYEE_PUANTAJ_ID NOT IN (SELECT EMPLOYEE_PUANTAJ_ID FROM COMMANDMENT_ROWS)
	ORDER BY
		EPR.EMPLOYEE_ID,
		EP.SAL_YEAR,
		EP.SAL_MON
</cfquery>
<cfset kalan_deger_ = StructNew()>
<cfoutput query="get_new_rows">
	<cfset deger_ = AMOUNT_2>
	<cfset employee_id_ = EMPLOYEE_ID>
	<cfset employee_puantaj_id_ = EMPLOYEE_PUANTAJ_ID>
	<cfset yil_ = SAL_YEAR>
	<cfset ay_ = SAL_MON>
	
	<cfif COMMANDMENT_TYPE eq 1>
		<cfset kalan_deger_["#COMMANDMENT_ID#"] = AMOUNT_2>	
	<cfelse>
		<cfset kalan_deger_["#COMMANDMENT_ID#"] = AMOUNT>
	</cfif>
	<cfquery name="add_" datasource="#DSN#">
		INSERT INTO
			COMMANDMENT_ROWS
			(
			EMPLOYEE_ID,
			SAL_YEAR,
			SAL_MON,
			COMMANDMENT_ID,
			EMPLOYEE_PUANTAJ_ID,
			CLOSED_AMOUNT
			)
			VALUES
			(
			#employee_id_#,
			#yil_#,
			#ay_#,
			#COMMANDMENT_ID#,
			#employee_puantaj_id_#,
			#kalan_deger_["#COMMANDMENT_ID#"]#
			)
	</cfquery>
	
	<cfquery name="upd_" datasource="#dsn#">
		UPDATE
			COMMANDMENT
		SET
			ODENEN = ODENEN + #kalan_deger_["#COMMANDMENT_ID#"]#
		WHERE
			COMMANDMENT_ID = #COMMANDMENT_ID#
	</cfquery>			
</cfoutput>