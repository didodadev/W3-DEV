<cf_cryptedpassword password="#attributes.new_password#" output="yeni_sifre">
<cfif isdefined('session.pp.userid') or (isdefined('attributes.mt') and attributes.mt eq 2)>
	<cfif isDefined('attributes.partner_id') and len(attributes.partner_id)>
        <cfquery name="UPD_PASSWORD" datasource="#DSN#">
            UPDATE 
                COMPANY_PARTNER 
            SET
                COMPANY_PARTNER_PASSWORD = '#yeni_sifre#'
            WHERE
               PARTNER_ID = <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.partner_id#">
        </cfquery>
	<cfelse>
		<cfset mail_addr = decrypt(attributes.ma,'AERTYASD6G6SA3E7',"CFMX_COMPAT","Hex")>
        <cfquery name="UPD_PASSWORD" datasource="#DSN#">
            UPDATE 
                COMPANY_PARTNER 
            SET
                COMPANY_PARTNER_PASSWORD = '#yeni_sifre#'
            WHERE
                COMPANY_PARTNER_EMAIL = <cfqueryparam cfsqltype="cf_sql_varchar" value="#mail_addr#">
        </cfquery>
	</cfif>
<cfelse>
	<cfset mail_addr = decrypt(attributes.ma,'AERTYASD6G6SA3E7',"CFMX_COMPAT","Hex")>
	<cfquery name="UPD_PASSWORD" datasource="#DSN#">
		DECLARE @RetryCounter INT
        SET @RetryCounter = 1
        RETRY: -- Label RETRY
        BEGIN TRANSACTION
        BEGIN TRY
        
                UPDATE 
                    CONSUMER 
                SET
                    CONSUMER_PASSWORD = '#yeni_sifre#',
                    LAST_PASSWORD_CHANGE = #now()#
                WHERE
                    CONSUMER_EMAIL = <cfqueryparam cfsqltype="cf_sql_varchar" value="#mail_addr#">
        
            COMMIT TRANSACTION
        END TRY
        BEGIN CATCH
            PRINT 'Rollback Transaction'
            ROLLBACK TRANSACTION
            DECLARE @DoRetry bit; -- Whether to Retry transaction or not
            DECLARE @ErrorMessage varchar(500)
            SET @doRetry = 0;
            SET @ErrorMessage = ERROR_MESSAGE()
            IF ERROR_NUMBER() = 1205 -- Deadlock Error Number
            BEGIN
                SET @doRetry = 1; -- Set @doRetry to 1 only for Deadlock
            END
            IF @DoRetry = 1
            BEGIN
                SET @RetryCounter = @RetryCounter + 1 -- Increment Retry Counter By one
                IF (@RetryCounter > 3) -- Check whether Retry Counter reached to 3
                BEGIN
                    RAISERROR(@ErrorMessage, 18, 1) -- Raise Error Message if 
                        -- still deadlock occurred after three retries
                END
                ELSE
                BEGIN
                    WAITFOR DELAY '00:00:00.05' -- Wait for 5 ms
                    GOTO RETRY	-- Go to Label RETRY
                END
            END
            ELSE
            BEGIN
                RAISERROR(@ErrorMessage, 18, 1)
            END
        END CATCH
	</cfquery>
</cfif>

<cflocation url="#request.self#?fuseaction=objects2.welcome" addtoken="no">


