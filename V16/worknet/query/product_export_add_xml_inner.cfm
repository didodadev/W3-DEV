<cfset cmp = createObject("component","V16.worknet.cfc.watalogyProductExport")>
<cfparam name="attributes.price_catid" default="">
<cfset GET_PRODUCT_PRICE = cmp.GET_PRODUCT_PRICE_F(
	dsn1:DSN1,
	dsn_alias:dsn_alias,
	dsn3_alias:dsn3_alias,
	dsn1_alias:dsn1_alias,
	dsn2_alias:dsn2_alias,
	period_id:attributes.period_id,
	price_catid:attributes.price_catid
)>
<cfset mainJson = structNew()>
<cfset cnt = 1>
<cfxml variable="product_list">
	<?xml version="1.0" encoding="UTF-8"?>
	<cfoutput><#attributes.root#></cfoutput>
		<cfoutput query="GET_PRODUCT_PRICE">
			<cfset structJson = structNew()>
			<#attributes.item#>
			<cfloop from="1" to="#listlen(text_name_list,'*')#" index="i">
				<cfset text_id = trim(listgetat(id_list,i,'*'))>
				<cfif isdefined("attributes.#text_id#")>
					<cfset get_product_images = cmp.get_product_images_f(
						dsn1_alias:dsn1_alias,
						PRODUCT_ID:PRODUCT_ID
					)>
					<cfset text_name = evaluate("attributes.#text_id#_text")>					
					<cfif text_id eq 'stockcode' OR (text_id eq 'label') OR (text_id eq 'brand') OR (text_id eq 'mainCategory') OR (text_id eq 'category') OR (text_id eq 'subcategory') OR (text_id eq 'currencyAbbr') OR (text_id eq 'details') OR (text_id eq 'Aciklama')>
						<cfset veri = trim(evaluate('#text_id#'))>
						<cfset structJson[#text_name#] = "#veri#">
						<cfset veri = "<![CDATA[#veri#]]>">
						<cfif text_id is 'currencyAbbr' and attributes.money_type eq 2>
							<cfset veri = replacelist(veri,'USD','Dolar')>
							<cfset structJson[#text_name#] = "#veri#">
						</cfif>
					<cfelseif text_id eq 'picture1Path' OR (text_id eq 'picture2Path') OR (text_id eq 'picture3Path') OR (text_id eq 'picture4Path') OR (text_id eq 'picture5Path') OR (text_id eq 'picture6Path')>
						<cfloop query="get_product_images">
						<cfif (text_id eq 'picture1Path' and get_product_images.recordcount gte 1)>
							<cfset veri = trim(get_product_images.PATH[1])>
							<cfif not len(veri)>
								<cfset structJson[#text_name#] = "#veri#">
								<cfset veri = "<![CDATA[#veri#]]>">
							<cfelse>
								<cfset veri = replace(veri,"documents/wex_files/","")>
								<cfset structJson[#text_name#] = "#veri#">
								<cfset veri = "<![CDATA[http://catalyst.atombilisim.com.tr/documents/wex_files/#veri#]]>">	
							</cfif>
						<cfelseif (text_id eq 'picture2Path' and get_product_images.recordcount gte 2)>
							<cfset veri = trim(get_product_images.PATH[2])>
							<cfif not len(veri)>
								<cfset structJson[#text_name#] = "#veri#">
								<cfset veri = "<![CDATA[#veri#]]>">
							<cfelse>
								<cfset veri = replace(veri,"documents/wex_files/","")>
								<cfset structJson[#text_name#] = "#veri#">
								<cfset veri = "<![CDATA[http://catalyst.atombilisim.com.tr/documents/wex_files/#veri#]]>">	
							</cfif>
						<cfelseif (text_id eq 'picture3Path' and get_product_images.recordcount gte 3)>
							<cfset veri = trim(get_product_images.PATH[3])>
							<cfif not len(veri)>
								<cfset structJson[#text_name#] = "#veri#">
								<cfset veri = "<![CDATA[#veri#]]>">
							<cfelse>
								<cfset veri = replace(veri,"documents/wex_files/","")>
								<cfset structJson[#text_name#] = "#veri#">
								<cfset veri = "<![CDATA[http://catalyst.atombilisim.com.tr/documents/wex_files/#veri#]]>">	
							</cfif>
						<cfelseif (text_id eq 'picture4Path' and get_product_images.recordcount gte 4)>
							<cfset veri = trim(get_product_images.PATH[4])>
								<cfset structJson[#text_name#] = "#veri#">
								<cfset veri = "<![CDATA[http://catalyst.atombilisim.com.tr/documents/wex_files/#veri#]]>">	
							
						<cfelseif (text_id eq 'picture5Path' and get_product_images.recordcount gte 5)>
							<cfset veri = trim(get_product_images.PATH[5])>
							<cfif not len(veri)>
								<cfset structJson[#text_name#] = "#veri#">
								<cfset veri = "<![CDATA[#veri#]]>">
							<cfelse>
								<cfset veri = replace(veri,"documents/wex_files/","")>
								<cfset structJson[#text_name#] = "#veri#">
								<cfset veri = "<![CDATA[http://catalyst.atombilisim.com.tr/documents/wex_files/#veri#]]>">	
							</cfif>
						<cfelseif (text_id eq 'picture6Path' and get_product_images.recordcount gte 6)>
							<cfset veri = trim(get_product_images.PATH[6])>
							<cfif not len(veri)>
								<cfset structJson[#text_name#] = "#veri#">
								<cfset veri = "<![CDATA[#veri#]]>">
							<cfelse>
								<cfset veri = replace(veri,"documents/wex_files/","")>
								<cfset structJson[#text_name#] = "#veri#">
								<cfset veri = "<![CDATA[http://catalyst.atombilisim.com.tr/documents/wex_files/#veri#]]>">
							</cfif>
						</cfif>
						</cfloop>
					<cfelse>
						<cfset veri = trim(evaluate('#text_id#'))>
						<cfset structJson[#text_name#] = "#veri#">
						<cfset veri = "<![CDATA[#veri#]]>">
					</cfif>
				
					<#text_name#>#veri#</#text_name#>
					<cfset veri = "">
				</cfif>
			</cfloop>
			<cfset cnt = cnt + 1>
			<cfset mainJson[attributes.item]["product_#cnt#"] = "#structJson#"> 
			</#attributes.item#>
		</cfoutput>
<!--- 		<cfscript>
			writeDump(replace(serializeJSON(mainJson),"//",""));
			abort;
		</cfscript> --->
	<cfoutput></#attributes.root#></cfoutput>
</cfxml>