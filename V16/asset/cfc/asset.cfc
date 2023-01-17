<cfcomponent>
    <cfset uploadFolder = application.systemParam.systemParam().upload_folder>
    <cfset dsn = application.systemParam.systemParam().dsn>
    <cffunction name="sendMail" access="remote" displayName="SEND MAIL" returntype="any">
        <cfargument name="mail_receiver" type="string">
        <cfargument name="mail_receiver_emp_id" type="string">
        <cfargument name="mail_receiver_partner_id" type="string">
        <cfargument name="mail_cc" type="string">
        <cfargument name="mail_cc_emp_id" type="string">
        <cfargument name="mail_cc_partner_id" type="string">
        <cfargument name="asset_id" type="string">
        <cfargument name="user_domain" type="string"> 
        <cfargument name="mail_logo" type="string">
       <cfif (isDefined('arguments.mail_receiver') and len(arguments.mail_receiver)) and ((isDefined('arguments.mail_receiver_emp_id') and len(arguments.mail_receiver_emp_id)) or (isDefined('arguments.mail_receiver_partner_id') and len(arguments.mail_receiver_partner_id)))>
            <cfquery name="GET_RECEIVER_MAIL" datasource="#DSN#">
                <cfif isdefined('arguments.mail_receiver_emp_id') and len(arguments.mail_receiver_emp_id)>
                    SELECT
                        EMPLOYEE_ID,
                        EMPLOYEE_EMAIL
                    FROM
                        EMPLOYEES
                    WHERE
                        EMPLOYEE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.mail_receiver_emp_id#">
                <cfelseif isdefined('arguments.mail_receiver_partner_id') and len(arguments.mail_receiver_partner_id)> 
                    SELECT 
                        PARTNER_ID,
                        COMPANY_PARTNER_EMAIL AS EMPLOYEE_EMAIL
                    FROM    
                        COMPANY_PARTNER 
                    WHERE   
                        PARTNER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.mail_receiver_partner_id#">
                </cfif>
            </cfquery>

            <cfset asset_receiver_email = get_receiver_mail.employee_email>
            <cfif (isDefined('arguments.mail_cc') and len(arguments.mail_cc)) and ((isDefined('arguments.mail_cc_emp_id') and len(arguments.mail_cc_emp_id)) or (isDefined('arguments.mail_cc_partner_id') and len(arguments.mail_cc_partner_id)))>
                <cfquery name="GET_CC_MAIL" datasource="#DSN#">
                    <cfif isdefined('arguments.mail_cc_emp_id') and len(arguments.mail_cc_emp_id)>
                        SELECT
                            EMPLOYEE_ID,
                            EMPLOYEE_EMAIL
                        FROM
                            EMPLOYEES
                        WHERE
                            EMPLOYEE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.mail_cc_emp_id#">
                    <cfelseif isdefined('arguments.mail_cc_partner_id') and len(arguments.mail_cc_partner_id)> 
                        SELECT 
                            PARTNER_ID,
                            COMPANY_PARTNER_EMAIL AS EMPLOYEE_EMAIL
                        FROM    
                            COMPANY_PARTNER 
                        WHERE   
                            PARTNER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.mail_cc_partner_id#">
                    </cfif>
                </cfquery>
                <cfset asset_cc_email = get_cc_mail.employee_email>
            <cfelse>
                <cfset asset_cc_email = "">
            </cfif>
            <cfif len(asset_receiver_email)>
                <cfsavecontent variable="mail_subject"><cfoutput>#application.functions.getlang('asset',191,'Dijital varlık bildirimi')#</cfoutput></cfsavecontent>
                <cfmail
                    to="#asset_receiver_email#"
                    cc="#asset_cc_email#"
                    from="#session.ep.company#<#session.ep.company_email#>"
                    subject="#mail_subject#" 
                    type="HTML">
                    <cfinclude template="../query/send_asset_mail.cfm">
                </cfmail>
            </cfif>
        </cfif>
    </cffunction>​
   
    <cffunction name = "imageSettings" returnType = "struct" access = "remote" description = "settings for thumbnails">
        
        <cfscript>

            imageSettings =	{///thumbnail Settings

                1	:	{
                    folderName	:	"icon",
                    PositionX	:	0,
                    PositionY	:	0,
                    newWidth	:	128,
                    newHeight	:	128
                },
                2	:	{
                    folderName	:	"middle",
                    PositionX	:	0,
                    PositionY	:	0,
                    newWidth	:	1024,
                    newHeight	:	512
                }
            }; 

        </cfscript>

        <cfreturn imageSettings>

    </cffunction>

    <cffunction name="createThumbnailFromImage" access="remote"  displayName="CREATE THUMB NAIL FROM IMAGE" returntype="any">
        <cfargument name="assetInfo" type="struct" required="false" />
        <cfset imageSettings = this.imageSettings() >

        <cftry>
            <cfset fileSystem = CreateObject("component","V16.asset.cfc.file_system") />
            <cfset fileSystem.newFolder("#uploadFolder#","thumbnails") /> <!---upload folder --- /documents klasörü ---->
            <cfset fileSystem.newFolder("#uploadFolder#thumbnails","icon") />
            <cfset fileSystem.newFolder("#uploadFolder#thumbnails","middle") />
            <cfset imageOperations = CreateObject("Component","cfc.image_operations") />
                
                <cfloop from="1" to="#imageSettings.count()#" index="row">
                    <cfset imageOperations.imageCrop(
                                    imagePath : "#assetInfo.uploadFolder##assetInfo.fileFullName#",
                                    imageThumbPath : "#uploadFolder#thumbnails/" & imageSettings[row]["folderName"] &"/#assetInfo.fileFullName#",
                                    imageCropType    :    1, <!--- Orantılı boyutlandır --->
                                    newWidth : #imageSettings[row]["newWidth"]#,
                                    newHeight : #imageSettings[row]["newHeight"]#
                                    ) />
                </cfloop>
            
            <cfcatch type="any"></cfcatch>
        </cftry>
    </cffunction>

</cfcomponent>
