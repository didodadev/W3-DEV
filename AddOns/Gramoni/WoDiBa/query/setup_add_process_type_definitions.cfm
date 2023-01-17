<cfquery name="get_t_code" datasource="#dsn#">
    SELECT
        TRANSACTION_UID
    FROM
        WODIBA_BANK_TRANSACTION_TYPES
    WHERE
        TRANSACTION_CODE = <cfqueryparam CFSQLType="CF_SQL_NVARCHAR" value = "#attributes.selectTCode1#"> AND
        IN_OUT          = <cfqueryparam CFSQLType="CF_SQL_NVARCHAR" value ="#attributes.selectIO#"> AND
        BANK_CODE       = <cfqueryparam CFSQLType="CF_SQL_NVARCHAR" value ="#attributes.bank_code#">
</cfquery>

<cfif get_t_code.recordCount>
    <script>alert('Aynı Kriterler ile Kayıt Mevcut!');</script>
    <cfexit>
</cfif>

<cfquery name="get_max_id" datasource="#dsn#">
    SELECT MAX(TRANSACTION_UID) AS TRANSACTION_UID FROM WODIBA_BANK_TRANSACTION_TYPES
</cfquery>

<cfset transactionUID = get_max_id.TRANSACTION_UID + 1 />

<cfquery datasource="#dsn#">
    INSERT INTO WODIBA_BANK_TRANSACTION_TYPES 
    (
        TRANSACTION_UID,
        BANK_CODE,
        TRANSACTION_CODE,
        TRANSACTION_CODE2,
        PROCESS_TYPE,
        DESCRIPTION_1,
        DESCRIPTION_2,
        IN_OUT,
        REC_USER,
        REC_DATE,
        REC_IP
    )
    VALUES 
    (
        #transactionUID#,
        <cfif len(attributes.bank_code)><cfqueryparam CFSQLType="CF_SQL_NVARCHAR" value ="#attributes.bank_code#"><cfelse>NULL</cfif>,
        <cfif len(attributes.selectTCode1)><cfqueryparam CFSQLType="CF_SQL_NVARCHAR" value = "#attributes.selectTCode1#"><cfelse>NULL</cfif>,
        <cfif len(attributes.selectTCode2)><cfqueryparam CFSQLType="CF_SQL_NVARCHAR" value ="#attributes.selectTCode2#"><cfelse>NULL</cfif>,
        <cfif len(attributes.selectPType)><cfqueryparam CFSQLType="CF_SQL_INTEGER" value =#attributes.selectPType#><cfelse>NULL</cfif>,
        <cfif len(attributes.inputd1)><cfqueryparam CFSQLType="CF_SQL_NVARCHAR" value ="#attributes.inputd1#"><cfelse>NULL</cfif>,
        <cfif len(attributes.inputd2)><cfqueryparam CFSQLType="CF_SQL_NVARCHAR" value ="#attributes.inputd2#"><cfelse>NULL</cfif>,
        <cfif len(attributes.selectIO)><cfqueryparam CFSQLType="CF_SQL_NVARCHAR" value ="#attributes.selectIO#"><cfelse>NULL</cfif>,
		#session.ep.userid#,
        #Now()#,
        '#CGI.REMOTE_ADDR#'
    )
</cfquery>
<cfset attributes.actionId='#transactionUID#' />