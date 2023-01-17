<cfcomponent>
	<cffunction name="init" returntype="VideoData">
    	<cfargument name="dsn" required="yes" />
        <cfset variables.dsn = dsn />
        <cfreturn this />
    </cffunction>
    
    <cffunction name="IncreaseDownloadCount" access="public">
    	<cfargument name="VideoId" type="numeric" required="yes"/>
        <cfset var video=0 />
		<cfquery name="video" datasource="#dsn#">
        	UPDATE ASSET SET DOWNLOAD_COUNT=DOWNLOAD_COUNT+1 WHERE ASSET_ID = #arguments.VideoId# AND IS_INTERNET=1
         </cfquery>
    </cffunction>
    <cffunction name="SetRating" access="public">
    	<cfargument name="VideoId" type="numeric" required="yes"/>
        <cfargument name="Rating" type="numeric" required="yes" />
        <cfset var video=0 />
        <cfset var new_rating=0 />
        <cfset var old_rating=0 />
        <cfset var ratingCount=0/>
        <cfquery name="video" datasource="#dsn#">
        	SELECT RATING, RATING_COUNT FROM ASSET WHERE ASSET_ID = #arguments.VideoId# AND IS_INTERNET=1
        </cfquery>
        <cfif video.RATING neq "">
        	<cfset old_rating = video.RATING />
        </cfif>
        <cfset new_rating=((old_rating*video.RATING_COUNT)+arguments.Rating) / (video.RATING_COUNT+1) />
        <cfset ratingCount=video.RATING_COUNT+1 />
		<cfquery name="video" datasource="#dsn#">
        	UPDATE ASSET SET RATING_COUNT=#ratingCount#, RATING=#new_rating# WHERE ASSET_ID = #arguments.VideoId# AND IS_INTERNET=1
        </cfquery>
    </cffunction>
    <cffunction name="GetVideoCount" returntype="numeric">
    	<cfargument name="UserType" type="string" required="yes" />
    	<cfargument name="UserId" type="numeric" required="yes" />
        <cfset var videos=0 />
		<cfquery name="videos" datasource="#dsn#">
        SELECT
            COUNT(*) AS VIDEO_COUNT
        FROM
            ASSET
        WHERE
        	ASSET.ASSET_FILE_NAME LIKE '%.flv'
            AND ASSET.IS_INTERNET=1
            <cfif arguments.UserType eq "consumer">
            AND ASSET.RECORD_PUB=#arguments.UserId#
            <cfelseif arguments.UserType eq "employee">
            AND ASSET.RECORD_EMP=#arguments.UserId#
            <cfelseif arguments.UserType eq "partner">
            AND ASSET.RECORD_PAR=#arguments.UserId#
           	</cfif>
        </cfquery>
		<cfreturn videos.VIDEO_COUNT>
    </cffunction>
    <cffunction name="GetVideo" access="public" returntype="query">
		<cfargument name="VideoId" type="numeric" required="yes"/>
        <cfargument name="isLive" type="boolean" required="no" />
        <cfset var video=0 />
		<cfquery name="video" datasource="#dsn#">
        SELECT
            ASSET.MODULE_NAME,
            ASSET.ACTION_SECTION,
            ASSET.ACTION_ID,
            ASSET.ASSET_ID,
            ASSET.ASSET_NAME,
            ASSET.ASSET_FILE_NAME,
            ASSET.ASSET_FILE_SERVER_ID,
            ASSET.ASSET_FILE_SIZE,
            ASSET.RECORD_PUB,
            ASSET.RECORD_EMP,
            ASSET.RECORD_PAR,
            ASSET.UPDATE_DATE,
            ASSET.UPDATE_EMP,
            ASSET.UPDATE_PAR,
            ASSET_CAT.ASSETCAT,
            ASSET_CAT.ASSETCAT_PATH,
			ASSET.ASSET_DETAIL,
            ASSET.ASSET_DESCRIPTION,
            ASSET.ASSETCAT_ID,
            ASSET.PROPERTY_ID,
            ASSET.DURATION, ASSET.IS_LIVE, ASSET.RATING, ASSET.FEATURED, ASSET.DOWNLOAD_COUNT, ASSET.COMMENT_COUNT, ASSET.FAVORITE_COUNT, ASSET.RATING_COUNT, ASSET.CONSUMER_ID
        FROM
            ASSET, ASSET_CAT
        WHERE
        	ASSET.ASSET_ID=#arguments.videoId#
            AND ASSET.ASSET_FILE_NAME LIKE '%.flv'
            AND ASSET.IS_INTERNET=1
            <cfif isdefined("arguments.isLive")>
            AND IS_LIVE=#arguments.isLive#
            </cfif>
            AND ASSET.ASSETCAT_ID = ASSET_CAT.ASSETCAT_ID
        </cfquery>
		<cfreturn video>
	</cffunction>
	<cffunction name="GetConsumerVideos" access="public" returntype="query">
		<cfargument name="VideoCount" type="numeric" required="yes"/>
        <cfargument name="SortExpression" type="string" required="yes"/>
        <cfset var videos=0 />
		<cfquery name="videos" datasource="#dsn#">
        SELECT
            TOP #arguments.VideoCount# ASSET.ASSET_ID, ASSET.ASSET_NAME, ASSET.DURATION, ASSET.IS_LIVE, ASSET.RATING, ASSET.FEATURED, ASSET.DOWNLOAD_COUNT, ASSET.ASSET_FILE_NAME, ASSET.ASSET_FILE_SERVER_ID, ASSET.DURATION, ASSET.COMMENT_COUNT, ASSET.FAVORITE_COUNT, ASSET.RATING_COUNT, ASSET.CONSUMER_ID, CONSUMER.CONSUMER_NAME as USER_NAME, CONSUMER.CONSUMER_SURNAME as USER_SURNAME
        FROM
            ASSET, CONSUMER
        WHERE
        	ASSET.ASSET_FILE_NAME LIKE '%.flv'
        	AND ASSET.RECORD_PUB=CONSUMER.CONSUMER_ID
            AND ASSET.IS_LIVE=0
            AND ASSET.IS_INTERNET=1
          ORDER BY
        	<cfif arguments.SortExpression eq "Newest">
            	ASSET.RECORD_DATE DESC
            <cfelseif arguments.SortExpression eq "MostViewed">
            	ASSET.DOWNLOAD_COUNT DESC, ASSET.RECORD_DATE DESC
            <cfelseif arguments.SortExpression eq "MostDiscussed">
            	ASSET.COMMENT_COUNT DESC, ASSET.RECORD_DATE DESC
            <cfelseif arguments.SortExpression eq "MostFavorites">
            	ASSET.FAVORITE_COUNT DESC, ASSET.RECORD_DATE DESC
            <cfelseif arguments.SortExpression eq "MostRated">
            	ASSET.RATING_COUNT DESC, ASSET.RECORD_DATE DESC
            </cfif>
        </cfquery>
		<cfreturn videos>
	</cffunction>
    <cffunction name="GetVideosByConsumer" access="public" returntype="query">
	    <cfargument name="Consumer" type="numeric" required="yes"/>
        <cfargument name="MaxRows" type="numeric" required="no" default="5"/>
        <cfset var videos=0 />
		<cfquery name="videos" datasource="#dsn#" maxrows="#arguments.MaxRows#">
        SELECT TOP #arguments.MaxRows#
            ASSET.*, CONSUMER.CONSUMER_NAME as USER_NAME, CONSUMER.CONSUMER_SURNAME as USER_SURNAME
        FROM
            ASSET, CONSUMER
        WHERE
        	ASSET.IS_LIVE=0
            AND ASSET.ASSET_FILE_NAME LIKE '%.flv'
            AND ASSET.IS_INTERNET=1
            AND ASSET.RECORD_PUB=#arguments.Consumer#
            AND ASSET.RECORD_PUB=CONSUMER.CONSUMER_ID
        ORDER BY
            ASSET.RECORD_DATE DESC
        </cfquery>
		<cfreturn videos>
	</cffunction>
    <cffunction name="GetVideosByEmployee" access="public" returntype="query">
	    <cfargument name="Employee" type="numeric" required="yes"/>
        <cfargument name="MaxRows" type="numeric" required="no" default="5"/>
        <cfset var videos=0 />
		<cfquery name="videos" datasource="#dsn#" maxrows="#arguments.MaxRows#">
        SELECT TOP #arguments.MaxRows#
            ASSET.*, EMPLOYEES.EMPLOYEE_NAME as USER_NAME, EMPLOYEES.EMPLOYEE_SURNAME as USER_SURNAME
        FROM
            ASSET, EMPLOYEES
        WHERE
            ASSET.IS_LIVE=0
            AND ASSET.ASSET_FILE_NAME LIKE '%.flv'
            AND ASSET.IS_INTERNET=1
            AND ASSET.RECORD_EMP=#arguments.Employee#
            AND ASSET.RECORD_PUB = EMPLOYEES.EMPLOYEE_ID
          ORDER BY
            ASSET.RECORD_DATE DESC
        </cfquery>
		<cfreturn videos>
	</cffunction>
    <cffunction name="GetVideosByPartner" access="public" returntype="query">
	    <cfargument name="Partner" type="numeric" required="yes"/>
        <cfargument name="MaxRows" type="numeric" required="no" default="5"/>
        <cfset var videos=0 />
		<cfquery name="videos" datasource="#dsn#" maxrows="#arguments.MaxRows#">
        SELECT TOP #arguments.MaxRows#
            ASSET.*, COMPANY_PARTNER.COMPANY_PARTNER_NAME as USER_NAME, COMPANY_PARTNER.COMPANY_PARTNER_SURNAME as USER_SURNAME
        FROM
            ASSET, EMPLOYEES
        WHERE
            ASSET.IS_LIVE=0
            AND ASSET.ASSET_FILE_NAME LIKE '%.flv'
            AND ASSET.IS_INTERNET=1
            AND ASSET.RECORD_PAR=#arguments.Partner#
            AND ASSET.RECORD_PAR = COMPANY_PARTNER.PARTNER_ID
          ORDER BY
            ASSET.RECORD_DATE DESC
        </cfquery>
		<cfreturn videos>
	</cffunction>
    <cffunction name="GetUserVideosByCategory" access="public" returntype="query">
    	<cfargument name="UserType" type="string" required="yes"/>
    	<cfargument name="Category" type="numeric" required="yes"/>
        <cfif arguments.UserType eq "consumer">
			<cfreturn GetConsumerVideosByCategory(arguments.Category) />
        <cfelseif arguments.UserType eq "employee">
            <cfreturn GetEmployeeVideosByCategory(arguments.Category) />
        <cfelseif arguments.UserType eq "partner">
            <cfreturn GetPartnerVideosByCategory(arguments.Category) />
        </cfif>
    </cffunction>
    <cffunction name="GetConsumerVideosByCategory" access="public" returntype="query">
	    <cfargument name="Category" type="numeric" required="yes"/>
        <cfargument name="MaxRows" type="numeric" required="no" default="5"/>
        <cfset var videos=0 />
		<cfquery name="videos" datasource="#dsn#" maxrows="#arguments.MaxRows#">
        SELECT TOP #arguments.MaxRows#
            ASSET.*, CONSUMER.CONSUMER_ID as USER_ID, CONSUMER.CONSUMER_NAME as USER_NAME, CONSUMER.CONSUMER_SURNAME as USER_SURNAME
        FROM
            ASSET, CONSUMER
        WHERE
            ASSET.IS_LIVE=0
            AND ASSET.ASSET_FILE_NAME LIKE '%.flv'
            AND ASSET.IS_INTERNET=1
            AND ASSET.ASSETCAT_ID=#arguments.Category#
            AND ASSET.RECORD_PUB = CONSUMER.CONSUMER_ID
        ORDER BY
           	ASSET.RECORD_DATE DESC
        </cfquery>
		<cfreturn videos>
	</cffunction>
    <cffunction name="GetEmployeeVideosByCategory" access="public" returntype="query">
	    <cfargument name="Category" type="numeric" required="yes"/>
        <cfargument name="MaxRows" type="numeric" required="no" default="5"/>
        <cfset var videos=0 />
		<cfquery name="videos" datasource="#dsn#" maxrows="#arguments.MaxRows#">
        SELECT TOP #arguments.MaxRows#
            ASSET.*, EMPLOYEES.EMPLOYEE_ID as USER_ID, EMPLOYEES.EMPLOYEE_NAME as USER_NAME, EMPLOYEES.EMPLOYEE_SURNAME as USER_SURNAME
        FROM
            ASSET, EMPLOYEES
        WHERE
            ASSET.IS_LIVE=0
            AND ASSET.ASSET_FILE_NAME LIKE '%.flv'
            AND ASSET.IS_INTERNET=1
            AND ASSET.ASSETCAT_ID=#arguments.Category#
            AND ASSET.RECORD_EMP = EMPLOYEES.EMPLOYEE_ID
        ORDER BY
           	ASSET.RECORD_DATE DESC
        </cfquery>
		<cfreturn videos>
	</cffunction>
    <cffunction name="GetPartnerVideosByCategory" access="public" returntype="query">
	    <cfargument name="Category" type="numeric" required="yes"/>
        <cfargument name="MaxRows" type="numeric" required="no" default="5"/>
        <cfset var videos=0 />
		<cfquery name="videos" datasource="#dsn#" maxrows="#arguments.MaxRows#">
        SELECT TOP #arguments.MaxRows#
            ASSET.*, COMPANY_PARTNER.PARTNER_ID as USER_ID, COMPANY_PARTNER.COMPANY_PARTNER_NAME as USER_NAME, COMPANY_PARTNER.COMPANY_PARTNER_SURNAME as USER_SURNAME
        FROM
            ASSET, COMPANY_PARTNER
        WHERE
            ASSET.IS_LIVE=0
            AND ASSET.ASSET_FILE_NAME LIKE '%.flv'
            AND ASSET.IS_INTERNET=1
            AND ASSET.ASSETCAT_ID=#arguments.Category#
            AND ASSET.RECORD_PAR = COMPANY_PARTNER.PARTNER_ID
        ORDER BY
           	ASSET.RECORD_DATE DESC
        </cfquery>
		<cfreturn videos>
	</cffunction>
    <cffunction name="GetFeaturedVideos" access="public" returntype="query">
		<cfargument name="StartDate" type="date" required="yes"/>
        <cfargument name="EndDate" type="date" required="yes"/>
        <cfargument name="SortExpression" type="string" required="yes"/>
        <cfset var videos=0 />
		<cfquery name="videos" datasource="#dsn#">
        SELECT
            ASSET.ASSET_ID, ASSET.ASSET_NAME, ASSET.DURATION, ASSET.IS_LIVE, ASSET.RATING, ASSET.FEATURED, ASSET.DOWNLOAD_COUNT, ASSET.COMMENT_COUNT, ASSET.FAVORITE_COUNT, ASSET.RATING_COUNT, ASSET.CONSUMER_ID, CONSUMER.CONSUMER_NAME
        FROM
            ASSET, <!--- ASSET_RELATION, ---> CONSUMER
        WHERE
            ASSET.IS_LIVE=0
            AND ASSET.ASSET_FILE_NAME LIKE '%.flv'
            AND ASSET.IS_INTERNET=1
            <!---AND ASSET.ASSET_FILE_FORMAT = 1  1 = FLV --->
           <!---  AND ASSET.CONSUMER_ID=#arguments.Member# --->
           <!---  AND ASSET.ASSET_ID = ASSET_RELATION.ASSET_ID AND ASSET_RELATION.ASSETCAT_ID=#arguments.Category# --->
            AND ASSET.FEATURED=1
            AND ASSET.CONSUMER_ID=CONSUMER.CONSUMER_ID
            AND ASSET.RECORD_DATE BETWEEN #arguments.StartDate# AND #arguments.EndDate#
          ORDER BY
        	<cfif arguments.SortExpression eq "Newest">
            	ASSET.RECORD_DATE DESC
            <cfelseif arguments.SortExpression eq "MostViewed">
            	ASSET.DOWNLOAD_COUNT DESC, ASSET.RECORD_DATE DESC
            <cfelseif arguments.SortExpression eq "MostDiscussed">
            	ASSET.COMMENT_COUNT DESC, ASSET.RECORD_DATE DESC
            <cfelseif arguments.SortExpression eq "MostFavorites">
            	ASSET.FAVORITE_COUNT DESC, ASSET.RECORD_DATE DESC
            <cfelseif arguments.SortExpression eq "MostRated">
            	ASSET.RATING_COUNT DESC, ASSET.RECORD_DATE DESC
            </cfif>
        </cfquery>
		<cfreturn videos>
	</cffunction>
    <cffunction name="GetFeaturedVideosByCategory" access="public" returntype="query">
	    <cfargument name="Category" type="numeric" required="yes"/>
		<cfargument name="StartDate" type="date" required="yes"/>
        <cfargument name="EndDate" type="date" required="yes"/>
        <cfargument name="SortExpression" type="string" required="yes"/>
        <cfset var videos=0 />
		<cfquery name="videos" datasource="#dsn#">
        SELECT
            ASSET.ASSET_ID, ASSET.ASSET_NAME, ASSET.DURATION, ASSET.IS_LIVE, ASSET.RATING, ASSET.FEATURED, ASSET.DOWNLOAD_COUNT, ASSET.COMMENT_COUNT, ASSET.FAVORITE_COUNT, ASSET.RATING_COUNT, ASSET.CONSUMER_ID, CONSUMER.CONSUMER_USERNAME
        FROM
            ASSET, ASSET_RELATION, CONSUMER
        WHERE
            ASSET.IS_LIVE=0
            AND ASSET.ASSET_FILE_NAME LIKE '%.flv'
            AND ASSET.IS_INTERNET=1
            <!---AND ASSET.ASSET_FILE_FORMAT = 1  1 = FLV --->
            <!--- AND ASSET.CONSUMER_ID=#arguments.Member# --->
            AND ASSET.ASSET_ID = ASSET_RELATION.ASSET_ID AND ASSET_RELATION.ASSETCAT_ID=#arguments.Category#
            AND ASSET.FEATURED=1
            AND ASSET.CONSUMER_ID=CONSUMER.CONSUMER_ID
            AND ASSET.RECORD_DATE BETWEEN #arguments.StartDate# AND #arguments.EndDate#
          ORDER BY
        	<cfif arguments.SortExpression eq "Newest">
            	ASSET.RECORD_DATE DESC
            <cfelseif arguments.SortExpression eq "MostViewed">
            	ASSET.DOWNLOAD_COUNT DESC, ASSET.RECORD_DATE DESC
            <cfelseif arguments.SortExpression eq "MostDiscussed">
            	ASSET.COMMENT_COUNT DESC, ASSET.RECORD_DATE DESC
            <cfelseif arguments.SortExpression eq "MostFavorites">
            	ASSET.FAVORITE_COUNT DESC, ASSET.RECORD_DATE DESC
            <cfelseif arguments.SortExpression eq "MostRated">
            	ASSET.RATING_COUNT DESC, ASSET.RECORD_DATE DESC
            </cfif>
        </cfquery>
		<cfreturn videos>
	</cffunction>
    <cffunction name="GetVideosByMember" access="public" returntype="query">
    	<cfargument name="Member" type="numeric" required="yes"/>
		<cfargument name="StartDate" type="date" required="yes"/>
        <cfargument name="EndDate" type="date" required="yes"/>
        <cfargument name="SortExpression" type="string" required="yes"/>
        <cfset var videos=0 />
		<cfquery name="videos" datasource="#dsn#">
        SELECT
            ASSET.ASSET_ID, ASSET.ASSET_NAME, ASSET.DURATION, ASSET.IS_LIVE, ASSET.RATING, ASSET.FEATURED, ASSET.DOWNLOAD_COUNT, ASSET.COMMENT_COUNT, ASSET.FAVORITE_COUNT, ASSET.RATING_COUNT, ASSET.CONSUMER_ID, CONSUMER.CONSUMER_USERNAME
        FROM
            ASSET, <!--- ASSET_RELATION, ---> CONSUMER
        WHERE
            ASSET.IS_LIVE=0
            AND ASSET.ASSET_FILE_NAME LIKE '%.flv'
            AND ASSET.IS_INTERNET=1
            <!---AND ASSET.ASSET_FILE_FORMAT = 1  1 = FLV --->
            AND ASSET.CONSUMER_ID=#arguments.Member#
            <!--- AND ASSET.ASSET_ID = ASSET_RELATION.ASSET_ID AND ASSET_RELATION.ASSETCAT_ID=#arguments.Category# --->
            <!--- AND ASSET.FEATURED=1 --->
            AND ASSET.CONSUMER_ID=CONSUMER.CONSUMER_ID
            AND ASSET.RECORD_DATE BETWEEN #arguments.StartDate# AND #arguments.EndDate#
          ORDER BY
        	<cfif arguments.SortExpression eq "Newest">
            	ASSET.RECORD_DATE DESC
            <cfelseif arguments.SortExpression eq "MostViewed">
            	ASSET.DOWNLOAD_COUNT DESC, ASSET.RECORD_DATE DESC
            <cfelseif arguments.SortExpression eq "MostDiscussed">
            	ASSET.COMMENT_COUNT DESC, ASSET.RECORD_DATE DESC
            <cfelseif arguments.SortExpression eq "MostFavorites">
            	ASSET.FAVORITE_COUNT DESC, ASSET.RECORD_DATE DESC
            <cfelseif arguments.SortExpression eq "MostRated">
            	ASSET.RATING_COUNT DESC, ASSET.RECORD_DATE DESC
            </cfif>
        </cfquery>
		<cfreturn videos>
	</cffunction>
</cfcomponent>
