<cfcomponent>
	<cffunction name="init" returntype="CommentData">
    	<cfargument name="dsn" required="yes" />
        <cfset variables.dsn = dsn />
        <cfreturn this />
    </cffunction>
    <cffunction name="GetComments" access="public" returntype="query">
    	<cfargument name="UserType" type="string" required="yes" />
    	<cfargument name="TypeId" type="numeric" required="yes" />
        <cfargument name="RelationId" type="numeric" required="yes" />
        <cfif arguments.UserType eq "consumer">
			<cfreturn cmp.GetConsumerComments(arguments.TypeId,arguments.RelationId) />
        <cfelseif arguments.UserType eq "employee">
            <cfreturn cmp.GetEmployeeComments(arguments.TypeId,arguments.RelationId) />
        <cfelseif arguments.UserType eq "partner">
            <cfreturn cmp.GetPartnerComments(arguments.TypeId,arguments.RelationId) />
        </cfif>
    </cffunction>
    <cffunction name="GetConsumerComments" access="public" returntype="query">
		<cfargument name="TypeId" type="numeric" required="yes"/>
        <cfargument name="RelationId" type="numeric" required="yes" />
        <cfset var comments=0/>
        <cfquery name="comments" datasource="#variables.dsn#">
        	SELECT COMMENTS.*, CONSUMER.CONSUMER_NAME as USER_NAME, CONSUMER.CONSUMER_SURNAME as USER_SURNAME FROM COMMENTS, CONSUMER WHERE TYPE_ID=#arguments.TypeId# AND RELATION_ID=#arguments.RelationId# AND COMMENTS.RECORD_PUB = CONSUMER.CONSUMER_ID
            ORDER BY COMMENTS.RECORD_DATE DESC
        </cfquery>
        <cfreturn comments />
    </cffunction>
    <cffunction name="GetEmployeeComments" access="public" returntype="query">
		<cfargument name="TypeId" type="numeric" required="yes"/>
        <cfargument name="RelationId" type="numeric" required="yes" />
        <cfset var comments=0/>
        <cfquery name="comments" datasource="#variables.dsn#">
        	SELECT COMMENTS.*, EMPLOYEES.EMPLOYEE_NAME as USER_NAME, EMPLOYEES.EMPLOYEE_SURNAME as USER_SURNAME FROM COMMENTS, EMPLOYEES WHERE TYPE_ID=#arguments.TypeId# AND RELATION_ID=#arguments.RelationId# AND COMMENTS.RECORD_EMP = EMPLOYEES.EMPLOYEE_ID
            ORDER BY COMMENTS.RECORD_DATE DESC
        </cfquery>
        <cfreturn comments />
    </cffunction>
    <cffunction name="GetPartnerComments" access="public" returntype="query">
		<cfargument name="TypeId" type="numeric" required="yes"/>
        <cfargument name="RelationId" type="numeric" required="yes" />
        <cfset var comments=0/>
        <cfquery name="comments" datasource="#variables.dsn#">
        	SELECT COMMENTS.*, COMPANY_PARTNER.COMPANY_PARTNER_NAME as USER_NAME, COMPANY_PARTNER.COMPANY_PARTNER_SURNAME as USER_SURNAME FROM COMMENTS, COMPANY_PARTNER WHERE TYPE_ID=#arguments.TypeId# AND RELATION_ID=#arguments.RelationId# AND COMMENTS.RECORD_PAR = COMPANY_PARTNER.PARTNER_ID
            ORDER BY COMMENTS.RECORD_DATE DESC
        </cfquery>
        <cfreturn comments />
    </cffunction>
    <cffunction name="AddComment" access="public">
    	<cfargument name="TypeId" type="numeric" required="yes" />
        <cfargument name="RelationId" type="numeric" required="yes" />
        <cfargument name="Body" type="string" required="yes" />
        <cfargument name="ResponseOf" type="string" required="yes" />
        <cfset var comment=0/>
        <cfquery name="comment" datasource="#variables.dsn#">
        INSERT INTO COMMENTS (
        	BODY,
            <cfif arguments.ResponseOf neq "">
            RESPONSE_OF,
            </cfif>
            TYPE_ID,
            RELATION_ID,
            RECORD_DATE,
            RECORD_EMP,
            RECORD_PAR,
            RECORD_PUB,
            RECORD_IP
            ) VALUES ('#arguments.Body#',<cfif arguments.ResponseOf neq "">#arguments.ResponseOf#,</cfif>#arguments.TypeId#,#arguments.RelationId#,#NOW()#,<cfif isdefined("SESSION.EP.USERID")>#SESSION.EP.USERID#,<cfelse>NULL,</cfif><cfif isdefined("SESSION.PP.USERID")>#SESSION.PP.USERID#,<cfelse>NULL,</cfif><cfif isdefined("SESSION.WW.USERID")>#SESSION.WW.USERID#,<cfelse>NULL,</cfif>'#CGI.REMOTE_ADDR#')
        </cfquery>
    </cffunction>
    <cffunction name="SetRating" access="public">
    	<cfargument name="CommentId" type="numeric" required="yes"/>
        <cfargument name="Rating" type="numeric" required="yes" />
        <cfset var comment=0 />
        <cfset var new_rating=0 />
        <cfset var old_rating=0 />
        <cfset var ratingCount=0/>
        <cfquery name="comment" datasource="#dsn#">
        	SELECT RATING, RATING_COUNT FROM COMMENTS WHERE COMMENT_ID = #arguments.CommentId#
        </cfquery>
        <cfif comment.RATING neq "">
        	<cfset old_rating = comment.RATING />
        </cfif>
        <cfset new_rating=((old_rating*comment.RATING_COUNT)+arguments.Rating) / (comment.RATING_COUNT+1) />
        <cfset ratingCount=comment.RATING_COUNT+1 />
		<cfquery name="comment" datasource="#dsn#">
        	UPDATE COMMENTS SET RATING_COUNT=#ratingCount#, RATING=#new_rating# WHERE ASSET_ID = #arguments.CommentId#
        </cfquery>
    </cffunction>
</cfcomponent>
