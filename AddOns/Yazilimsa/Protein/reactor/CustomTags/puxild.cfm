
<!---
    File :          AddOns\Yazilimsa\Protein\reactor\CustomTags\puxild.cfm
    
	Author :        Semih Akartuna <semihakartuna@yazilimsa.com>
   
	Date :          07.06.2021
    
	Description :   Protein Syafalarında Schema.org yapısını oluştutmak için kullanılır. ld+json oluşturur
					örnek yapı ve detaylı bilgş https://developers.google.com/search/docs/data-types/product#json-ld

					product | event | article | FAQPage +++ https://schema.org/docs/schemas.html
    
					Notes :         her widget için set edilen typeları bir struct altında gruplar ve ld+json  oluşturur.
					schema typları widget detaylarında (protein page designer da widdget çark ikonu) seçilir.

					<cf_puxild type="name" content=#reviewer_name#">

					https://wiki.workcube.com/help/11199
	
	~Params:			
					*type		: brand.name *Hiyerarşik olarak json yapısındaki değişkenin ismi kırılımlı olarak verilir
					
					*content	: value

					*list		: satırlı değerlerde liste key'i , default: null  *çok satırlı verilerde kullanılır 
								 ?örnek: aşağıdaki yapıyı oluşturmak için
								 <cf_puxild list="review" row="#satir_no" type="@type" content="Review"> 
								 <cf_puxild list="review" row="#satir_no" type="author" content="John Doe">
								 <cf_puxild list="review" row="#satir_no" type="datePublished" content="2006-05-04"> 
								 <cf_puxild list="review" row="#satir_no" type="name" content="A masterpiece of literature">
								 <cf_puxild list="review" row="#satir_no" type="reviewBody" content="I really enjoyed this book.">
								 <cf_puxild list="review" row="#satir_no" type="reviewRating.@type" content="Rating">
								 <cf_puxild list="review" row="#satir_no" type="reviewRating.ratingValue" content="5">

								 "review": [
									{
										"@type": "Review",
										"author": "John Doe",
										"datePublished": "2006-05-04",
										"name": "A masterpiece of literature",
										"reviewBody": "I really enjoyed this book.",
										"reviewRating": {
										"@type": "Rating",
										"ratingValue": "5"
									}
									},
									{
										"@type": "Review",
										"author": "Bob Smith",
										"datePublished": "2006-06-15",
										"name": "A good read.",
										"reviewBody": "Catcher in the Rye is a fun book. It's a good book to read.",
										"reviewRating": "4"
									}
								]

					*output		: true | false , default: true *kullanıldığı yerde contentin çıktısını verir tagi contenti cfoutput içine almadan çıktı verir. istenmiyorsa false yapın
--->
<cfparam name="attributes.type" default="">
<cfparam name="attributes.content" default="">
<cfparam name="attributes.list" default="">
<cfparam name="attributes.row" default="">
<cfparam name="attributes.output" default="true">



<cfset SCHEMA_TYPE = caller.SCHEMA_TYPE><!--- WİDGET DETAYINDAN GELİR --->

<cfif len(attributes.list)>
	<cfif not isDefined("CALLER.SCHEMA_ORG.#SCHEMA_TYPE#.#attributes.list#")>
		<cfset "CALLER.SCHEMA_ORG.#SCHEMA_TYPE#.#attributes.list#"= []>
		<cfset content = (len(attributes.type))?{}:attributes.content>
		<cfscript>
			ArraySet(Evaluate("CALLER.SCHEMA_ORG.#SCHEMA_TYPE#.#attributes.list#"), attributes.row,attributes.row, content)
		</cfscript>
	<cfelse>
		<cfset list_ = evaluate("CALLER.SCHEMA_ORG.#SCHEMA_TYPE#.#attributes.list#")>
		<cfif arrayLen(list_) neq attributes.row>
			<cfset content = (len(attributes.type))?{}:attributes.content>
			<cfscript>
				ArraySet(Evaluate("CALLER.SCHEMA_ORG.#SCHEMA_TYPE#.#attributes.list#"), attributes.row,attributes.row, content)
			</cfscript>
		</cfif>	
	</cfif>	
</cfif>

<cfif StructKeyExists(evaluate("CALLER.SCHEMA_ORG"), SCHEMA_TYPE) EQ 'NO'>
    <cfset "CALLER.SCHEMA_ORG.#SCHEMA_TYPE#" = {}>
</cfif>

<cfif StructKeyExists(evaluate("CALLER.SCHEMA_ORG.#SCHEMA_TYPE#"), "type") EQ 'NO'>
    <cfset main_type = { '@type' : SCHEMA_TYPE, '@context': 'https://schema.org/'}>
	<cfscript>
		StructAppend(evaluate("CALLER.SCHEMA_ORG.#SCHEMA_TYPE#"),main_type,true);
	</cfscript>
</cfif>


<cfif len(attributes.type) AND len(attributes.content) AND len(SCHEMA_TYPE)>
	<cfif len(attributes.list)>			
		<cfset row = Evaluate("CALLER.SCHEMA_ORG.#SCHEMA_TYPE#.#attributes.list#")[attributes.row]>
		<cfif Find("@",attributes.type)>
			<cfset x = "{">
			<cfset y = 1>
			<cfloop array="#listToArray(attributes.type,".")#" item="item">	
				<cfset x &= '"#item#":' & (y neq arrayLen(listToArray(attributes.type,"."))? '{': '"#attributes.content#"')>
				<cfset y += 1>
			</cfloop>
			<cfloop array="#listToArray(attributes.type,".")#" item="item">	
				<cfset x &= "}">
			</cfloop>
			<cfset rowx = deserializeJSON(x)>
			<cfscript>
				StructAppend(row,rowx,true);
				ArraySet(Evaluate("CALLER.SCHEMA_ORG.#SCHEMA_TYPE#.#attributes.list#"), attributes.row,attributes.row, row)
			</cfscript>
		<cfelse>
			<cfset "row.#attributes.type#" = attributes.content>
		</cfif>	
		
		
	<cfelse>
		<cfif Find("@",attributes.type)>
			<cfset x = "{">
			<cfset y = 1>
			<cfloop array="#listToArray(attributes.type,".")#" item="item">	
				<cfset x &= '"#item#":' & (y neq arrayLen(listToArray(attributes.type,"."))? '{': '"#attributes.content#"')>
				<cfset y += 1>
			</cfloop>
			<cfloop array="#listToArray(attributes.type,".")#" item="item">	
				<cfset x &= "}">
			</cfloop>
			<cfscript>
				StructAppend(evaluate("CALLER.SCHEMA_ORG.#SCHEMA_TYPE#"),deserializeJSON(x),true);
			</cfscript>
		<cfelse>
			<cfset "CALLER.SCHEMA_ORG.#SCHEMA_TYPE#.#attributes.type#" = attributes.content>
		</cfif>	
	</cfif>	
		
</cfif>

<cfoutput>#((attributes.output eq true)?attributes.content:"")#</cfoutput>