<!--- 
Description :
	Sayfa Meta Tanımlarını oluşturur, meta lara eklenen makro ları çalıştırır
Syntax : 
	<cf_protein_meta_maker> 
Parameters :
Created :   SA20201117
 --->
<cfparam  name="url.param_2" default="">
<cfset meta_source_id = url.param_2>

<cfif len(caller.PAGE_DATA.META_DESCRIPTION)>
	<cfset meta_description_ = caller.PAGE_DATA.META_DESCRIPTION>
<cfelse>
	<cfset meta_description_ = caller.PRIMARY_DATA.DETAIL>
</cfif>

<cfif len(caller.PAGE_DATA.META_KEYWORD)>
	<cfset meta_keyword_ = caller.PAGE_DATA.META_KEYWORD>
<cfelse>
	<cfset meta_keyword_ = caller.PRIMARY_DATA.META_KEYWORD>
</cfif>

<cfif find('[content_desc]',meta_description_)>
	<!--- TODO 1:  meta_source_id ye göre içeriğin meta desc çek--->
	<cfset meta_description_ = replace(meta_description_, "[content_desc]", " içerik açıklama metası ")>
</cfif>
<cfif find('[product_desc]',meta_description_)>
	<!--- TODO 2:  meta_source_id ye göre ürünün meta desc çek--->
	<cfset meta_description_ = replace(meta_description_, "[product_desc]", " ürün açıklama metası ")>
</cfif>

<cfif find('[content_keyword]',meta_keyword_)>
	<!--- TODO 3:  meta_source_id ye göre içeriğin meta keyword çek--->
	<cfset meta_keyword_ = replace(meta_keyword_, "[content_keyword]", " içerik key meta ")>
</cfif>
<cfif find('[product_keyword]',meta_description_)>
	<!--- TODO 4:  meta_source_id ye göre ürüne meta keyword çek--->
	<cfset meta_keyword_ = replace(meta_keyword_, "[product_keyword]", " ürün metası ")>
</cfif>
<cfoutput>
	<meta name="description" content="#meta_description_#" >
	<meta name="keywords" content="#meta_description_#" >
	#caller.PRIMARY_DATA.APPENDIX_META#
	<!--- TODO 5: Ürün ve İçeriğin Başlığını Title a yaz --->
	<title>#caller.GET_PAGE.TITLE# | #caller.PRIMARY_DATA.TITLE#</title>
</cfoutput>