<cfcomponent>
	<cffunction name="init" returntype="AssetData">
    	<cfargument name="dsn" required="yes" />
        <cfargument name="fileFormat" required="yes" />
        <cfset variables.dsn = dsn />
        <cfset variables.fileFormat = fileFormat />
        <cfreturn this />
    </cffunction>
    
    <cffunction name="GetFileFormatFilter">
		<cfif fileFormat eq 1><!--- photo --->
        	<cfreturn "(ASSET.ASSET_FILE_NAME LIKE '%.PNG' OR 
			ASSET.ASSET_FILE_NAME LIKE '%.JPG' OR
			ASSET.ASSET_FILE_NAME LIKE '%.JPEG' OR
			ASSET.ASSET_FILE_NAME LIKE '%.gif' OR
			ASSET.ASSET_FILE_NAME LIKE '%.GIF')" />
        <cfelseif fileFormat eq 2><!--- video --->
        	<cfreturn "ASSET.ASSET_FILE_NAME LIKE '%.flv'" />
        <cfelse>
        	<cfreturn "1=1" />
        </cfif>
    </cffunction>
    <cffunction name="IncreaseDownloadCount" access="public">
    	<cfargument name="AssetId" type="numeric" required="yes"/>
        <cfset var asset=0 />
		<cfquery name="asset" datasource="#dsn#">
        	UPDATE ASSET SET DOWNLOAD_COUNT = DOWNLOAD_COUNT+1 WHERE ASSET_ID = #arguments.AssetId# AND IS_INTERNET=1
         </cfquery>
    </cffunction>
    <cffunction name="SetRating" access="public">
    	<cfargument name="AssetId" type="numeric" required="yes"/>
        <cfargument name="Rating" type="numeric" required="yes" />
        <cfset var asset=0 />
        <cfset var new_rating=0 />
        <cfset var old_rating=0 />
        <cfset var ratingCount=0/>
        <cfquery name="asset" datasource="#dsn#">
        	SELECT RATING, RATING_COUNT FROM ASSET WHERE ASSET_ID = #arguments.AssetId# AND IS_INTERNET=1
        </cfquery>
        <cfif asset.RATING neq "">
        	<cfset old_rating = asset.RATING />
        </cfif>
        <cfset new_rating=((old_rating*asset.RATING_COUNT)+arguments.Rating) / (asset.RATING_COUNT+1) />
        <cfset ratingCount=asset.RATING_COUNT+1 />
		<cfquery name="asset" datasource="#dsn#">
        	UPDATE ASSET SET RATING_COUNT=#ratingCount#, RATING=#new_rating# WHERE ASSET_ID = #arguments.AssetId# AND IS_INTERNET=1
        </cfquery>
    </cffunction>
    <cffunction name="GetAssetCount" returntype="numeric">
    	<cfargument name="UserType" type="string" required="yes" />
    	<cfargument name="UserId" type="numeric" required="yes" />
        <cfset var videos=0 />
		<cfquery name="videos" datasource="#dsn#">
        SELECT
            COUNT(*) AS VIDEO_COUNT
        FROM
            ASSET
        WHERE
        	#GetFileFormatFilter()#
            AND ASSET.IS_INTERNET=1
            <cfif isdefined('session.ww')>
            AND ASSET.RECORD_PUB=#arguments.UserId#
            <cfelseif isdefined('session.ep')>
            AND ASSET.RECORD_EMP=#arguments.UserId#
            <cfelseif isdefined('session.pp')>
            AND ASSET.RECORD_PAR=#arguments.UserId#
           	</cfif>
        </cfquery>
		<cfreturn videos.VIDEO_COUNT>
    </cffunction>
    <cffunction name="GetAsset" access="public" returntype="query">
		<cfargument name="AssetId" type="numeric" required="yes"/>
        <cfargument name="isLive" type="boolean" required="no" default="0" />
        <cfset var asset=0 />
		<cfquery name="asset" datasource="#dsn#">
        SELECT
            ASSET.MODULE_NAME,
            ASSET.ACTION_SECTION,
            ASSET.ACTION_ID,
            ASSET.ASSET_ID,
            ASSET.ASSET_NAME,
            ASSET.ASSET_FILE_NAME,
			ASSET.ASSET_FILE_PATH_NAME,
            ASSET.ASSET_FILE_SERVER_ID,
            ASSET.ASSET_FILE_SIZE,
            ASSET.RECORD_DATE,
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
        	ASSET.ASSET_ID = #assetId#
        	AND #GetFileFormatFilter()#
            AND ASSET.IS_INTERNET=1
            AND ASSET.IS_LIVE=#isLive#
            AND ASSET.ASSETCAT_ID = ASSET_CAT.ASSETCAT_ID
        </cfquery>
		<cfreturn asset>
	</cffunction>
	<cffunction name="GetProductAssets" access="public" returntype="query">
		<cfargument name="AssetCount" type="numeric" required="yes"/>
        <cfargument name="SortExpression" type="string" required="yes"/>
		<cfargument name="product_id" type="numeric" required="no" />
        <cfset var assets=0 />
		<cfquery name="assets" datasource="#dsn#">
        SELECT
            TOP #arguments.AssetCount# ASSET.ASSET_ID, ASSET.ASSET_NAME, ASSET.DURATION, ASSET.IS_LIVE, ASSET.RATING, ASSET.FEATURED, ASSET.DOWNLOAD_COUNT, ASSET.ASSET_FILE_NAME, ASSET.ASSET_FILE_SERVER_ID, ASSET.DURATION, ASSET.COMMENT_COUNT, ASSET.FAVORITE_COUNT, ASSET.RATING_COUNT, ASSET.RECORD_PUB
        FROM
            ASSET
        WHERE
        	#GetFileFormatFilter()#
        	AND ASSET.ACTION_SECTION = 'PRODUCT_ID'
			AND ASSET.ACTION_ID = #arguments.product_id#
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
		<cfreturn assets>
	</cffunction>
	<cffunction name="GetConsumerAssets" access="public" returntype="query">
		<cfargument name="AssetCount" type="numeric" required="yes"/>
        <cfargument name="SortExpression" type="string" required="yes"/>
        <cfargument name="Category" type="numeric" required="no" />
        <cfset var assets=0 />
		<cfquery name="assets" datasource="#dsn#">
        SELECT
            TOP #arguments.AssetCount# ASSET.ASSET_ID, ASSET.ASSET_NAME, ASSET.DURATION, ASSET.IS_LIVE, ASSET.RATING, ASSET.FEATURED, ASSET.DOWNLOAD_COUNT, ASSET.ASSET_FILE_NAME, ASSET.ASSET_FILE_SERVER_ID, ASSET.DURATION, ASSET.COMMENT_COUNT, ASSET.FAVORITE_COUNT, ASSET.RATING_COUNT, ASSET.RECORD_PUB, CONSUMER.CONSUMER_NAME as USER_NAME, CONSUMER.CONSUMER_SURNAME as USER_SURNAME
        FROM
            ASSET, CONSUMER
        WHERE
        	#GetFileFormatFilter()#
            <cfif isdefined("arguments.Category")>
            AND ASSET.ASSETCAT_ID=#arguments.Category#
            </cfif>
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
		<cfreturn assets>
	</cffunction>
    <cffunction name="GetAssetsByConsumer" access="public" returntype="query">
	    <cfargument name="Consumer" type="numeric" required="yes"/>
        <cfargument name="MaxRows" type="numeric" required="no" default="5"/>
        <cfset var assets=0 />
		<cfquery name="assets" datasource="#dsn#" maxrows="#arguments.MaxRows#">
        SELECT TOP #arguments.MaxRows#
            ASSET.*, CONSUMER.CONSUMER_NAME as USER_NAME, CONSUMER.CONSUMER_SURNAME as USER_SURNAME
        FROM
            ASSET, CONSUMER
        WHERE
        	ASSET.IS_LIVE=0
            AND #GetFileFormatFilter()#
            AND ASSET.IS_INTERNET=1
            AND ASSET.RECORD_PUB=#arguments.Consumer#
            AND ASSET.RECORD_PUB=CONSUMER.CONSUMER_ID
        ORDER BY
            ASSET.RECORD_DATE DESC
        </cfquery>
		<cfreturn assets>
	</cffunction>
    <cffunction name="GetAssetsByEmployee" access="public" returntype="query">
	    <cfargument name="Employee" type="numeric" required="yes"/>
        <cfargument name="MaxRows" type="numeric" required="no" default="5"/>
        <cfset var assets=0 />
		<cfquery name="assets" datasource="#dsn#" maxrows="#arguments.MaxRows#">
        SELECT TOP #arguments.MaxRows#
            ASSET.*, EMPLOYEES.EMPLOYEE_NAME as USER_NAME, EMPLOYEES.EMPLOYEE_SURNAME as USER_SURNAME
        FROM
            ASSET, EMPLOYEES
        WHERE
            ASSET.IS_LIVE=0
            AND #GetFileFormatFilter()#
            AND ASSET.IS_INTERNET=1
            AND ASSET.RECORD_EMP=#arguments.Employee#
            AND ASSET.RECORD_PUB = EMPLOYEES.EMPLOYEE_ID
          ORDER BY
            ASSET.RECORD_DATE DESC
        </cfquery>
		<cfreturn assets>
	</cffunction>
    <cffunction name="GetAssetsByPartner" access="public" returntype="query">
	    <cfargument name="Partner" type="numeric" required="yes"/>
        <cfargument name="MaxRows" type="numeric" required="no" default="5"/>
        <cfset var assets=0 />
		<cfquery name="assets" datasource="#dsn#" maxrows="#arguments.MaxRows#">
        SELECT TOP #arguments.MaxRows#
            ASSET.*, COMPANY_PARTNER.COMPANY_PARTNER_NAME as USER_NAME, COMPANY_PARTNER.COMPANY_PARTNER_SURNAME as USER_SURNAME
        FROM
            ASSET, EMPLOYEES
        WHERE
            ASSET.IS_LIVE=0
            AND #GetFileFormatFilter()#
            AND ASSET.IS_INTERNET=1
            AND ASSET.RECORD_PAR=#arguments.Partner#
            AND ASSET.RECORD_PAR = COMPANY_PARTNER.PARTNER_ID
          ORDER BY
            ASSET.RECORD_DATE DESC
        </cfquery>
		<cfreturn assets>
	</cffunction>
    <cffunction name="GetUserAssetsByCategory" access="public" returntype="query">
    	<cfargument name="UserType" type="string" required="yes"/>
    	<cfargument name="Category" type="numeric" required="yes"/>
        <cfargument name="ExcludeAsset" type="numeric" required="yes" />
        <cfif isdefined('session.ww')>
			<cfreturn GetConsumerAssetsByCategory(arguments.Category, 5, ExcludeAsset) />
        <cfelseif isdefined('session.ep')>
            <cfreturn GetEmployeeAssetsByCategory(arguments.Category, 5, ExcludeAsset) />
        <cfelseif isdefined('session.pp')>
            <cfreturn GetPartnerAssetsByCategory(arguments.Category, 5, ExcludeAsset) />
        </cfif>
    </cffunction>
    <cffunction name="GetConsumerAssetsByCategory" access="public" returntype="query">
	    <cfargument name="Category" type="numeric" required="yes"/>
        <cfargument name="MaxRows" type="numeric" required="no" default="5"/>
        <cfargument name="ExcludeAsset" type="numeric" required="no" />
        <cfset var assets=0 />
		<cfquery name="assets" datasource="#dsn#" maxrows="#arguments.MaxRows#">
        SELECT TOP #arguments.MaxRows#
            ASSET.*, CONSUMER.CONSUMER_ID as USER_ID, CONSUMER.CONSUMER_NAME as USER_NAME, CONSUMER.CONSUMER_SURNAME as USER_SURNAME
        FROM
            ASSET, CONSUMER
        WHERE
            ASSET.IS_LIVE=0
            AND #GetFileFormatFilter()#
            AND ASSET.IS_INTERNET=1
            AND ASSET.ASSETCAT_ID=#arguments.Category#
            AND ASSET.RECORD_PUB = CONSUMER.CONSUMER_ID
            <cfif isdefined("arguments.ExcludeAsset")>
            AND ASSET.ASSET_ID <> #arguments.ExcludeAsset#
            </cfif>
        ORDER BY
           	ASSET.RECORD_DATE DESC
        </cfquery>
		<cfreturn assets>
	</cffunction>
    <cffunction name="GetEmployeeAssetsByCategory" access="public" returntype="query">
	    <cfargument name="Category" type="numeric" required="yes"/>
        <cfargument name="MaxRows" type="numeric" required="no" default="5"/>
        <cfargument name="ExcludeAsset" type="numeric" required="no" />
        <cfset var assets=0 />
		<cfquery name="assets" datasource="#dsn#" maxrows="#arguments.MaxRows#">
        SELECT TOP #arguments.MaxRows#
            ASSET.*, EMPLOYEES.EMPLOYEE_ID as USER_ID, EMPLOYEES.EMPLOYEE_NAME as USER_NAME, EMPLOYEES.EMPLOYEE_SURNAME as USER_SURNAME
        FROM
            ASSET, EMPLOYEES
        WHERE
            ASSET.IS_LIVE=0
            AND #GetFileFormatFilter()#
            AND ASSET.IS_INTERNET=1
            AND ASSET.ASSETCAT_ID=#arguments.Category#
            AND ASSET.RECORD_EMP = EMPLOYEES.EMPLOYEE_ID
            <cfif isdefined("arguments.ExcludeAsset")>
            AND ASSET.ASSET_ID <> #arguments.ExcludeAsset#
            </cfif>
        ORDER BY
           	ASSET.RECORD_DATE DESC
        </cfquery>
		<cfreturn assets>
	</cffunction>
    <cffunction name="GetPartnerAssetsByCategory" access="public" returntype="query">
	    <cfargument name="Category" type="numeric" required="yes"/>
        <cfargument name="MaxRows" type="numeric" required="no" default="5"/>
        <cfargument name="ExcludeAsset" type="numeric" required="no" />
        <cfset var assets=0 />
		<cfquery name="assets" datasource="#dsn#" maxrows="#arguments.MaxRows#">
			SELECT TOP #arguments.MaxRows#
				ASSET.*, COMPANY_PARTNER.PARTNER_ID as USER_ID, COMPANY_PARTNER.COMPANY_PARTNER_NAME as USER_NAME, COMPANY_PARTNER.COMPANY_PARTNER_SURNAME as USER_SURNAME
			FROM
				ASSET, COMPANY_PARTNER
			WHERE
				ASSET.IS_LIVE=0
				AND #GetFileFormatFilter()#
				AND ASSET.IS_INTERNET=1
				AND ASSET.ASSETCAT_ID=#arguments.Category#
				AND ASSET.RECORD_PAR = COMPANY_PARTNER.PARTNER_ID
				<cfif isdefined("arguments.ExcludeAsset")>
				AND ASSET.ASSET_ID <> #arguments.ExcludeAsset#
				</cfif>
			ORDER BY
				ASSET.RECORD_DATE DESC
        </cfquery>
		<cfreturn assets>
	</cffunction>
    <cffunction name="GetFeaturedAssets" access="public" returntype="query">
		<cfargument name="StartDate" type="date" required="yes"/>
        <cfargument name="EndDate" type="date" required="yes"/>
        <cfargument name="SortExpression" type="string" required="yes"/>
        <cfset var assets=0 />
		<cfquery name="assets" datasource="#dsn#">
        SELECT
            ASSET.ASSET_ID, ASSET.ASSET_NAME, ASSET.DURATION, ASSET.IS_LIVE, ASSET.RATING, ASSET.FEATURED, ASSET.DOWNLOAD_COUNT, ASSET.COMMENT_COUNT, ASSET.FAVORITE_COUNT, ASSET.RATING_COUNT, ASSET.CONSUMER_ID, CONSUMER.CONSUMER_NAME
        FROM
            ASSET, <!--- ASSET_RELATION, ---> CONSUMER
        WHERE
            ASSET.IS_LIVE=0
            AND #GetFileFormatFilter()#
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
		<cfreturn assets>
	</cffunction>
    <cffunction name="GetFeaturedAssetsByCategory" access="public" returntype="query">
	    <cfargument name="Category" type="numeric" required="yes"/>
		<cfargument name="StartDate" type="date" required="yes"/>
        <cfargument name="EndDate" type="date" required="yes"/>
        <cfargument name="SortExpression" type="string" required="yes"/>
        <cfset var assets=0 />
		<cfquery name="assets" datasource="#dsn#">
        SELECT
            ASSET.ASSET_ID, ASSET.ASSET_NAME, ASSET.DURATION, ASSET.IS_LIVE, ASSET.RATING, ASSET.FEATURED, ASSET.DOWNLOAD_COUNT, ASSET.COMMENT_COUNT, ASSET.FAVORITE_COUNT, ASSET.RATING_COUNT, ASSET.CONSUMER_ID, CONSUMER.CONSUMER_USERNAME
        FROM
            ASSET, ASSET_RELATION, CONSUMER
        WHERE
            ASSET.IS_LIVE=0
            AND #GetFileFormatFilter()#
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
    <cffunction name="GetAssetsByMember" access="public" returntype="query">
    	<cfargument name="Member" type="numeric" required="yes"/>
		<cfargument name="StartDate" type="date" required="yes"/>
        <cfargument name="EndDate" type="date" required="yes"/>
        <cfargument name="SortExpression" type="string" required="yes"/>
        <cfset var assets=0 />
		<cfquery name="assets" datasource="#dsn#">
        SELECT
            ASSET.ASSET_ID, ASSET.ASSET_NAME, ASSET.DURATION, ASSET.IS_LIVE, ASSET.RATING, ASSET.FEATURED, ASSET.DOWNLOAD_COUNT, ASSET.COMMENT_COUNT, ASSET.FAVORITE_COUNT, ASSET.RATING_COUNT, ASSET.CONSUMER_ID, CONSUMER.CONSUMER_USERNAME
        FROM
            ASSET, <!--- ASSET_RELATION, ---> CONSUMER
        WHERE
            ASSET.IS_LIVE=0
            AND #GetFileFormatFilter()#
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
		<cfreturn assets>
	</cffunction>
    <cffunction name="GetAssets" access="public" returntype="query">
    	<cfargument name="MaxRows" type="numeric" required="no" default="5"/>
        <cfargument name="SortExpression" type="string" required="yes"/>
        <cfset var assets=0 />
		<cfquery name="assets" datasource="#dsn#">
        SELECT
            ASSET.ASSET_ID, ASSET.ASSET_NAME, ASSET.DURATION, ASSET.IS_LIVE, ASSET.RATING, ASSET.FEATURED, ASSET.DOWNLOAD_COUNT, ASSET.COMMENT_COUNT, ASSET.FAVORITE_COUNT, ASSET.RATING_COUNT, ASSET.CONSUMER_ID, CONSUMER.CONSUMER_USERNAME
        FROM
            ASSET, <!--- ASSET_RELATION, ---> CONSUMER
        WHERE
            ASSET.IS_LIVE=0
            AND #GetFileFormatFilter()#
            AND ASSET.IS_INTERNET=1
            <!---AND ASSET.ASSET_FILE_FORMAT = 1  1 = FLV --->
            <!--- AND ASSET.CONSUMER_ID=#arguments.Member# --->
            <!--- AND ASSET.ASSET_ID = ASSET_RELATION.ASSET_ID AND ASSET_RELATION.ASSETCAT_ID=#arguments.Category# --->
            <!--- AND ASSET.FEATURED=1 --->
            AND ASSET.CONSUMER_ID=CONSUMER.CONSUMER_ID
           <!---  AND ASSET.RECORD_DATE BETWEEN #arguments.StartDate# AND #arguments.EndDate# --->
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
		<cfreturn assets>
	</cffunction>
</cfcomponent>
