<cfsavecontent variable="icerik">
<?xml version="1.0" encoding="UTF-8"?>
<urlset xmlns="http://www.sitemaps.org/schemas/sitemap/0.9">
<cfquery name="GET_SITEMAP_PRODUCTS" datasource="#DSN3#">
	SELECT
		DISTINCT 
			STOCKS.STOCK_ID,
			STOCKS.PROPERTY,
			STOCKS.BARCOD,
			STOCKS.STOCK_CODE,
			STOCKS.PRODUCT_UNIT_ID,
			PRODUCT.PRODUCT_ID,
			PRODUCT.PRODUCT_NAME,
			PRODUCT.TAX,
			PRODUCT.IS_ZERO_STOCK,
			PRODUCT.BRAND_ID,
			PRODUCT.USER_FRIENDLY_URL,
			PRODUCT.PRODUCT_CODE,
			PRODUCT.PRODUCT_DETAIL,
			PRODUCT.PRODUCT_CATID,
			PRODUCT.RECORD_DATE,
			PRODUCT.IS_PRODUCTION,
			PRODUCT.SEGMENT_ID,
			PRICE_STANDART.PRICE PRICE,
			PRICE_STANDART.MONEY MONEY,
			PRICE_STANDART.IS_KDV IS_KDV,
			PRICE_STANDART.PRICE_KDV PRICE_KDV,
			PRODUCT.PRODUCT_DETAIL2,
			PRODUCT.PRODUCT_CODE_2,
			PRODUCT_CAT.PRODUCT_CAT
		FROM
			PRODUCT,
			PRODUCT_CAT,
			#dsn1_alias#.PRODUCT_CAT_OUR_COMPANY AS PRODUCT_CAT_OUR_COMPANY,
			STOCKS,
			PRICE_STANDART,
			PRODUCT_UNIT
		WHERE
			STOCKS.STOCK_STATUS = 1 AND
			PRODUCT_CAT.PRODUCT_CATID = PRODUCT_CAT_OUR_COMPANY.PRODUCT_CATID AND
			PRODUCT_CAT_OUR_COMPANY.OUR_COMPANY_ID = <cfqueryparam value="#session_base.our_company_id#" cfsqltype="cf_sql_integer"> AND
			PRODUCT.PRODUCT_ID = STOCKS.PRODUCT_ID AND
			PRODUCT_UNIT.PRODUCT_ID = STOCKS.PRODUCT_ID AND
			STOCKS.PRODUCT_UNIT_ID = PRODUCT_UNIT.PRODUCT_UNIT_ID AND
			PRODUCT_CAT.PRODUCT_CATID = PRODUCT.PRODUCT_CATID AND
			PRODUCT_UNIT.IS_MAIN = 1 AND			
			<cfif isdefined("session.pp")>
                PRODUCT.IS_EXTRANET = <cfqueryparam value="1" cfsqltype="cf_sql_smallint"> AND
            <cfelse>
                PRODUCT.IS_INTERNET = <cfqueryparam value="1" cfsqltype="cf_sql_smallint"> AND
            </cfif>
			PRICE_STANDART.PRICE ><cfqueryparam value="0" cfsqltype="cf_sql_float"> AND
			PRICE_STANDART.PRICESTANDART_STATUS = 1	AND
			PRICE_STANDART.PURCHASESALES = 1 AND
			PRODUCT_UNIT.PRODUCT_UNIT_ID = PRICE_STANDART.UNIT_ID AND
			PRODUCT.PRODUCT_STATUS = 1		
			<cfif isdefined("session.pp")>
				<cfif isdefined("attributes.price_first_value") and len(attributes.price_first_value) and isdefined("attributes.price_last_value") and len(attributes.price_last_value)>
					AND PRICE_STANDART.PRICE/SETUP_MONEY.RATE1*SETUP_MONEY.RATEPP2 BETWEEN <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.price_first_value#"> AND <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.price_last_value#">
				<cfelseif isdefined("attributes.price_first_value") and len(attributes.price_first_value)>
					AND PRICE_STANDART.PRICE/SETUP_MONEY.RATE1*SETUP_MONEY.RATEPP2 >= <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.price_first_value#"> 
				<cfelseif isdefined("attributes.price_last_value") and len(attributes.price_last_value)>
					AND PRICE_STANDART.PRICE/SETUP_MONEY.RATE1*SETUP_MONEY.RATEPP2 <= <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.price_last_value#"> 
				</cfif>
			<cfelseif isdefined("session.ww")>
				<cfif isdefined("attributes.price_first_value") and len(attributes.price_first_value) and isdefined("attributes.price_last_value") and len(attributes.price_last_value)>
					AND PRICE_STANDART.PRICE/SETUP_MONEY.RATE1*SETUP_MONEY.RATEWW2 BETWEEN <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.price_first_value#"> AND <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.price_last_value#">
				<cfelseif isdefined("attributes.price_first_value") and len(attributes.price_first_value)>
					AND PRICE_STANDART.PRICE/SETUP_MONEY.RATE1*SETUP_MONEY.RATEWW2 >= <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.price_first_value#"> 
				<cfelseif isdefined("attributes.price_last_value") and len(attributes.price_last_value)>
					AND PRICE_STANDART.PRICE/SETUP_MONEY.RATE1*SETUP_MONEY.RATEWW2 <= <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.price_last_value#"> 
				</cfif>
			</cfif>
		ORDER BY
			PRODUCT_CAT.PRODUCT_CAT
</cfquery>

<cfquery name="GET_CONTENTS" datasource="#DSN#">
	SELECT 
		C.CONTENT_ID,
		C.CONT_HEAD,
		C.CONT_BODY,
		C.USER_FRIENDLY_URL,
		C.CONT_SUMMARY,
		C.PRIORITY,
		C.UPDATE_DATE,
		C.RECORD_DATE,
		C.CONTENT_PROPERTY_ID,
		CCAT.CONTENTCAT,
		CC.CHAPTER,
		CCAT.CONTENTCAT_ID
	FROM 
		CONTENT AS C, 
		CONTENT_CHAPTER AS CC,
		CONTENT_CAT AS CCAT
	WHERE 
    	C.CONTENT_PROPERTY_ID IS NOT NULL AND
		C.STAGE_ID = -2 AND	 
		C.CONTENT_STATUS = 1 AND
		C.CHAPTER_ID = CC.CHAPTER_ID AND 
		CCAT.CONTENTCAT_ID = CC.CONTENTCAT_ID AND
		C.SPOT <> 1 AND
		CCAT.IS_RULE <> 1 AND
		<cfif isdefined("session.pp.company_category")>
            C.COMPANY_CAT  LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%,#session.pp.company_category#,%"> AND
            CCAT.CONTENTCAT_ID IN (SELECT CONTENTCAT_ID FROM CONTENT_CAT_COMPANY WHERE COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.pp.our_company_id#">) AND
            C.LANGUAGE_ID = <cfqueryparam cfsqltype="cf_sql_varchar" value="#session.pp.language#">
        <cfelseif isdefined("session.ww.consumer_category")>
            C.CONSUMER_CAT  LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%,#session.ww.consumer_category#,%"> AND
            CCAT.CONTENTCAT_ID IN (SELECT CONTENTCAT_ID FROM CONTENT_CAT_COMPANY WHERE COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ww.our_company_id#">) AND
            C.LANGUAGE_ID =  <cfqueryparam cfsqltype="cf_sql_varchar" value="#session.ww.language#">
        <cfelseif isdefined("session.cp")>
            C.CAREER_VIEW = 1 AND
            CCAT.CONTENTCAT_ID IN (SELECT CONTENTCAT_ID FROM CONTENT_CAT_COMPANY WHERE COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.cp.our_company_id#">) AND
            C.LANGUAGE_ID = <cfqueryparam cfsqltype="cf_sql_varchar" value="#session.cp.language#">
        <cfelse>
            INTERNET_VIEW = 1 AND
            C.LANGUAGE_ID = <cfqueryparam cfsqltype="cf_sql_varchar" value="#session.ww.language#"> AND
            CCAT.CONTENTCAT_ID IN (SELECT CONTENTCAT_ID FROM CONTENT_CAT_COMPANY WHERE COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session_base.our_company_id#">)
        </cfif>
	ORDER BY 
		CCAT.CONTENTCAT,
		CC.CHAPTER,
		C.CONT_HEAD	
</cfquery>
<cfquery name="GET_LINKS" datasource="#DSN#">
	SELECT 
		LINK_NAME,
        LINK_NAME_TYPE,
        SELECTED_LINK,
        LINK_TYPE 
	FROM 
		MAIN_MENU_SELECTS 
	WHERE 
		MENU_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_my_.menu_id#"> AND 
		(IS_SESSION = 0 OR IS_SESSION IS NULL) AND
		LINK_TYPE NOT IN (-3,-4,-5,-6,-7,-8,-9,-12,-13,-14)
	ORDER BY
		ORDER_NO
</cfquery>
<cfoutput query="get_links">
	<cfif len(link_name_type) and link_name_type eq 1 and isnumeric(link_name)>
		<cfsavecontent variable="this_link_name_"><cf_get_lang_main no='#link_name#.Link'></cfsavecontent>
	<cfelseif len(link_name_type) and link_name_type eq 2 and isnumeric(link_name)>
		<cfsavecontent variable="this_link_name_"><cf_get_lang no='#link_name#.Link'></cfsavecontent>
	<cfelse>
		<cfset this_link_name_ = link_name>
	</cfif>
	<cfset this_link_ = "#selected_link#">
	<cfif listlen(this_link_,'.') eq 2>
		<cfif link_type eq -11>
			<cfset this_link_ = "https://#cgi.HTTP_HOST#/#request.self#?fuseaction=#selected_link#">
		<cfelseif link_type eq -10>
			<cfset this_link_ = "https://#cgi.HTTP_HOST#/#request.self#?fuseaction=#selected_link#">
		<cfelseif listFindNoCase('-1,-2',link_type,',')>
			<cfset this_link_ = "http://#cgi.HTTP_HOST#/#request.self#?fuseaction=#selected_link#">
		</cfif>
	<cfelse>
		<cfif link_type eq -11>
			<cfset this_link_ = "https://#cgi.HTTP_HOST#/#selected_link#">
		<cfelseif listFindNoCase('-3,-4,-5,-6,-7,-8,-9',link_type,',')>
			<cfset this_link_ = "http://#cgi.HTTP_HOST#/#selected_link#">
		<cfelseif link_type eq -10>
			<cfset this_link_ = "https://#cgi.HTTP_HOST#/#selected_link#">
		<cfelseif listFindNoCase('-1,-2',link_type,',')>
			<cfset this_link_ = "http://#cgi.HTTP_HOST#/#selected_link#">
		</cfif>
	</cfif>
	<cfif len(this_link_name_)>
        <url>
          	<loc>#this_link_#</loc>
          	<lastmod>#dateformat(now(),'yyyy-mm-dd')#</lastmod>
          	<changefreq>weekly</changefreq>
          	<priority>0.5</priority>
        </url>
    </cfif>
</cfoutput>
<cfquery name="GET_LAYERS" datasource="#DSN#">
	SELECT 
		MMLS.LINK_NAME,
		MMLS.LINK_NAME_TYPE,
		MMLS.LINK_TYPE,
		MMLS.SELECTED_LINK,
		MMS.LINK_NAME AS UST_GROUP
	FROM 
		MAIN_MENU_LAYER_SELECTS MMLS,
		MAIN_MENU_SELECTS MMS
	WHERE 
		MMS.SELECTED_ID = MMLS.SELECTED_ID AND
		MMLS.MENU_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_my_.menu_id#"> AND
		MMLS.LINK_TYPE NOT IN (-3,-4,-5,-6,-7,-8,-9,-12,-13,-14) AND
		(MMLS.IS_SESSION = 0 OR MMLS.IS_SESSION IS NULL)
	ORDER BY
		MMS.ORDER_NO,
		MMLS.ORDER_NO
</cfquery>
<cfoutput query="get_layers">
	<cfif len(link_name_type) and link_name_type eq 1 and isnumeric(link_name)>
        <cfsavecontent variable="this_link_name_"><cf_get_lang_main no='#link_name#.Link'></cfsavecontent>
    <cfelseif len(link_name_type) and link_name_type eq 2 and isnumeric(link_name)>
        <cfsavecontent variable="this_link_name_"><cf_get_lang no='#link_name#.Link'></cfsavecontent>
    <cfelse>
        <cfset this_link_name_ = link_name>
    </cfif>
    <cfset this_link_ = "#selected_link#">
    <cfif listlen(this_link_,'.') eq 2>
        <cfif link_type eq -11>
            <cfset this_link_ = "https://#cgi.HTTP_HOST#/#request.self#?fuseaction=#selected_link#">
        <cfelseif link_type eq -10>
            <cfset this_link_ = "https://#cgi.HTTP_HOST#/#request.self#?fuseaction=#selected_link#">
        <cfelseif listFindNoCase('-1,-2',link_type,',')>
            <cfset this_link_ = "http://#cgi.HTTP_HOST#/#request.self#?fuseaction=#selected_link#">
        </cfif>
    <cfelse>
        <cfif link_type eq -11>
            <cfset this_link_ = "https://#cgi.HTTP_HOST#/#selected_link#">
        <cfelseif listFindNoCase('-3,-4,-5,-6,-7,-8,-9',link_type,',')>
            <cfset this_link_ = "http://#cgi.HTTP_HOST#/#selected_link#">
        <cfelseif link_type eq -10>
            <cfset this_link_ = "https://#cgi.HTTP_HOST#/#selected_link#">
        <cfelseif listFindNoCase('-1,-2',link_type,',')>
            <cfset this_link_ = "http://#cgi.HTTP_HOST#/#selected_link#">
        </cfif>
    </cfif>
	<cfif len(this_link_name_)>
		<url>
		  	<loc>#this_link_#</loc>
		  	<lastmod>#dateformat(now(),'yyyy-mm-dd')#</lastmod>
		  	<changefreq>weekly</changefreq>
		  	<priority>0.5</priority>
		</url>
	</cfif>
</cfoutput>
<cfoutput query="get_contents">
	<url>
	  	<loc>http://#cgi.HTTP_HOST#/#url_friendly_request('objects2.detail_content&cid=#content_id#','#user_friendly_url#')#</loc>
	  	<lastmod>#dateformat(now(),'yyyy-mm-dd')#</lastmod>
	  	<changefreq>weekly</changefreq>
	  	<priority>0.5</priority>
	</url>
</cfoutput>
<cfoutput query="get_sitemap_products">
	<url>
	  	<cfif len(user_friendly_url)>
			<loc>http://#cgi.HTTP_HOST#/#user_friendly_url#</loc>
		<cfelse>
			<loc>http://#cgi.HTTP_HOST#/index.cfm?fuseaction=objects2.detail_product&stock_id=#stock_id#&product_id=#product_id#</loc>
	 	</cfif>
	 	<lastmod>#dateformat(now(),'yyyy-mm-dd')#</lastmod>
	  	<changefreq>weekly</changefreq>
	  	<priority>0.5</priority>
	</url>
</cfoutput>
</urlset>
</cfsavecontent>
<cfset icerik = replace(trim(icerik),'&','&amp;','all')>
<cffile action="write" file="#upload_folder#sitemap_#session_base.our_company_id#.xml" output="#toString(icerik)#" charset="utf-8">


<h1>Bağlantılar</h1>
<cfoutput query="get_links">
	<cfif len(link_name_type) and link_name_type eq 1 and isnumeric(link_name)>
		<cfsavecontent variable="this_link_name_"><cf_get_lang_main no='#link_name#.Link'></cfsavecontent>
	<cfelseif len(link_name_type) and link_name_type eq 2 and isnumeric(link_name)>
		<cfsavecontent variable="this_link_name_"><cf_get_lang no='#link_name#.Link'></cfsavecontent>
	<cfelse>
		<cfset this_link_name_ = link_name>
	</cfif>
	<cfset this_link_ = "#selected_link#">
	<cfif listlen(this_link_,'.') eq 2>
		<cfif link_type eq -11>
			<cfset this_link_ = "https://#cgi.HTTP_HOST#/#request.self#?fuseaction=#selected_link#">
		<cfelseif link_type eq -10>
			<cfset this_link_ = "https://#cgi.HTTP_HOST#/#request.self#?fuseaction=#selected_link#">
		<cfelseif listFindNoCase('-1,-2',link_type,',')>
			<cfset this_link_ = "http://#cgi.HTTP_HOST#/#request.self#?fuseaction=#selected_link#">
		</cfif>
	<cfelse>
		<cfif link_type eq -11>
			<cfset this_link_ = "https://#cgi.HTTP_HOST#/#selected_link#">
		<cfelseif listFindNoCase('-3,-4,-5,-6,-7,-8,-9',link_type,',')>
			<cfset this_link_ = "http://#cgi.HTTP_HOST#/#selected_link#">
		<cfelseif link_type eq -10>
			<cfset this_link_ = "https://#cgi.HTTP_HOST#/#selected_link#">
		<cfelseif listFindNoCase('-1,-2',link_type,',')>
			<cfset this_link_ = "http://#cgi.HTTP_HOST#/#selected_link#">
		</cfif>
	</cfif>
	<cfif len(this_link_name_)>
        <li><a href="#this_link_#">#this_link_name_#</a></li>
    </cfif>
</cfoutput>
<br/><br/>
<h1>Alt Bağlantılar</h1>
<cfoutput query="get_layers">
	<cfif len(link_name_type) and link_name_type eq 1 and isnumeric(link_name)>
		<cfsavecontent variable="this_link_name_"><cf_get_lang_main no='#link_name#.Link'></cfsavecontent>
	<cfelseif len(link_name_type) and link_name_type eq 2 and isnumeric(link_name)>
		<cfsavecontent variable="this_link_name_"><cf_get_lang no='#link_name#.Link'></cfsavecontent>
	<cfelse>
		<cfset this_link_name_ = link_name>
	</cfif>
	<cfset this_link_ = "#selected_link#">
	<cfif listlen(this_link_,'.') eq 2>
		<cfif link_type eq -11>
			<cfset this_link_ = "https://#cgi.HTTP_HOST#/#request.self#?fuseaction=#selected_link#">
		<cfelseif link_type eq -10>
			<cfset this_link_ = "https://#cgi.HTTP_HOST#/#request.self#?fuseaction=#selected_link#">
		<cfelseif listFindNoCase('-1,-2',link_type,',')>
			<cfset this_link_ = "http://#cgi.HTTP_HOST#/#request.self#?fuseaction=#selected_link#">
		</cfif>
	<cfelse>
		<cfif link_type eq -11>
			<cfset this_link_ = "https://#cgi.HTTP_HOST#/#selected_link#">
		<cfelseif listFindNoCase('-3,-4,-5,-6,-7,-8,-9',link_type,',')>
			<cfset this_link_ = "http://#cgi.HTTP_HOST#/#selected_link#">
		<cfelseif link_type eq -10>
			<cfset this_link_ = "https://#cgi.HTTP_HOST#/#selected_link#">
		<cfelseif listFindNoCase('-1,-2',link_type,',')>
			<cfset this_link_ = "http://#cgi.HTTP_HOST#/#selected_link#">
		</cfif>
	</cfif>
	<cfif len(this_link_name_)>
        <li><a href="#this_link_#">#this_link_name_#</a></li>
    </cfif>
</cfoutput>
<br/><br/>
<h1 class="sitemap_h1">Ürünler</h1>
<cfoutput query="get_sitemap_products" group="PRODUCT_CAT">
  	<h2 class="sitemap_h2">#product_cat#</h2>
  	<cfoutput>
		<cfif len(user_friendly_url)>
            &nbsp;&nbsp;<h3 class="sitemap_h3"><a href="http://#cgi.HTTP_HOST#/#user_friendly_url#">#product_name# #property#</a></h3>
        <cfelse>
            &nbsp;&nbsp;<h3 class="sitemap_h3"><a href="http://#cgi.HTTP_HOST#/index.cfm?fuseaction=objects2.detail_product&stock_id=#stock_id#&product_id=#product_id#">#product_name# #property#</a></h3>
        </cfif>
  	</cfoutput>
</cfoutput>
<br/><br/>
<h1>İçerikler</h1>
<cfoutput query="get_contents" group="contentcat">
    <br/>
    <span class="formbold">#contentcat#</span>
    <cfoutput>
      	<li><a href="http://#cgi.HTTP_HOST#/#url_friendly_request('objects2.detail_content&cid=#content_id#','#user_friendly_url#')#">#cont_head#</a></li><br/>
    </cfoutput>
</cfoutput>

<cfsavecontent variable="icerik">
<?xml version="1.0" encoding="UTF-8"?>
<rss version="2.0" 
	xmlns:wfw="http://wellformedweb.org/CommentAPI/"
	xmlns:dc="http://purl.org/dc/elements/1.1/"
	xmlns:itunes="http://www.itunes.com/dtds/podcast-1.0.dtd"
	xmlns:content="http://purl.org/rss/1.0/modules/content/"
	xmlns:cnettv="http://cnettv.com/mrss/"
	xmlns:creativeCommons="http://backend.userland.com/creativeCommonsRssModule"
	xmlns:media="http://search.yahoo.com/mrss/"
	xmlns:atom="http://www.w3.org/2005/Atom"
	xmlns:amp="http://www.adobe.com/amp/1.0">
	<channel>
	<title>Workcube</title>
	<link>http://ww.workcube/</link>
	<description>Workcube</description>
	<cfoutput><lastBuildDate>#dateformat(now(),'yyyy-mm-dd')#</lastBuildDate></cfoutput>
	<generator>Workcube</generator>
	<language>tr</language>
	<cfoutput query="get_contents">
        <item>
            <title>#cont_head#</title>
            <link>http://#cgi.HTTP_HOST#/#url_friendly_request('objects2.detail_content&cid=#content_id#','#user_friendly_url#')#</link>
            <pubDate>#RECORD_DATE#</pubDate>
            <dc:creator>Workcube</dc:creator>
            <guid isPermaLink="true">http://#cgi.HTTP_HOST#/#url_friendly_request('objects2.detail_content&cid=#content_id#','#user_friendly_url#')#</guid>
            <description><![CDATA[#trim(CONT_SUMMARY)#]]></description>
        </item>
    </cfoutput>
</channel>
</rss>
</cfsavecontent>
<cfset icerik = replace(trim(icerik),'&','&amp;','all')>
<cffile action="write" file="#upload_folder#RSS_#session_base.our_company_id#.xml" output="#toString(icerik)#" charset="utf-8">

