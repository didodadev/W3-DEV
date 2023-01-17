
<cfquery name="MARKETPLACE_CATS" datasource="#dsn#">
	SELECT * FROM MARKET_PLACE_CATS
	WHERE 
		MP_ID = 1 	
</cfquery>
<cfquery name="MP_SETTS" datasource="#dsn#">
	SELECT
		MARKET_PLACE,
		API_KEY,
		SECRET_KEY,
		ROLE_NAME,
		ROLE_PASS
	FROM
		MARKET_PLACE_SETTINGS
	WHERE 
	    MARKET_PLACE_ID = 1 
</cfquery>

<cfhttp
		url="http://dev.gittigidiyor.com:8080/listingapi/rlws/anonymous/category?method=getCategories&outputCT=xml&startOffSet=0&rowCount=3&withSpecs=true&withDeepest=true&withCatalog=true&lang=tr"
		method="get"
		port="8080"
		username="javascope"
		password="AdFDhTX2hhvzZ7x6Szfh2ryVUPaxaxTR"
		result="catRes">
</cfhttp>

<cfscript>

	ggCatDoc = xmlParse(catRes.Filecontent); //Gittigidiyor Category Doc

	catCount = ggCatDoc.return.categoryCount.xmlText;
	
</cfscript>

<cfif MARKETPLACE_CATS.Recordcount eq 0>

	<cfset catCounter = 0>
	<cfloop condition = "catCounter lt catCount"> 
		<cfhttp
			url="http://dev.gittigidiyor.com:8080/listingapi/rlws/anonymous/category?method=getCategories&outputCT=xml&startOffSet=#catCounter#&rowCount=100&withSpecs=true&withDeepest=true&withCatalog=true&lang=tr"
			method="get"
			port="8080"
			username="javascope"
			password="AdFDhTX2hhvzZ7x6Szfh2ryVUPaxaxTR"
			result="catRes">
		</cfhttp>
		
		<cfset ggCatDoc = xmlParse(catRes.Filecontent)>
		
		<cfif not isDefined('ggCatDoc.return.categories')>
			<cfoutput>--#catCounter#--</cfoutput><br>
		<cfelse>
			<cfscript>
		
				catRoot = ggCatDoc.return;

				catQuery = QueryNew("catCode, catName, specs"); 
				queryAddRow(catQuery, arraylen(catRoot.categories.category));
				
				for (i = 1; i lte arraylen(catRoot.categories.category); i++){
					cat = catRoot.categories.category[i];
					QuerySetCell(catQuery, "catCode", isDefined('cat.categorycode') ? cat.categorycode.xmlText : '-1', i);
					QuerySetCell(catQuery, "catName", isDefined('cat.categoryname') ? cat.categoryname.xmlText : '-1', i);
					QuerySetCell(catQuery, "specs", isDefined('cat.specs') ? cat.specs : '-1', i);
				}
				
			</cfscript>
			<cfoutput>----#catQuery.Recordcount#----</cfoutput><br>
			<cfquery name="insertData" datasource="#dsn#"> 
				INSERT INTO MARKET_PLACE_CATS 
					(MP_ID, MP_CODE, MP_CATNAME)
				VALUES
				<cfloop from="1" to="#catQuery.Recordcount#" index="u"> 
					<cfif u NEQ 1>,</cfif>
					(
					1,
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#catQuery.catCode[u]#">,
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#catQuery.catName[u]#">
					)
				</cfloop>
			</cfquery>
		</cfif>
		
		<cfset catCounter = catCounter + 100>
	</cfloop>

</cfif>

<cfquery name="ALL_GGMP_CATS" datasource="#dsn#"> 
	SELECT * FROM MARKET_PLACE_CATS WHERE MP_ID = 1
</cfquery>

<script type="text/javascript" src="/V16/add_options/b2b2c/protein/assets/js/typeahead.bundle.js"></script>
<script type="text/javascript">
	var catNames = [];
	<cfoutput query="ALL_GGMP_CATS">catNames.push({catCode:'#MP_CODE#',catName:'#replace(MP_CATNAME,"'"," ","all")#'});</cfoutput>
	console.log(catNames);
	var substringMatcher = function(strs) {
	  return function findMatches(q, cb) {
		var matches, substringRegex;

		// an array that will be populated with substring matches
		matches = [];

		// regex used to determine if a string contains the substring `q`
		substrRegex = new RegExp(q, 'i');

		// iterate through the pool of strings and for any string that
		// contains the substring `q`, add it to the `matches` array
		$.each(strs, function(i, str) {
		  if (substrRegex.test(str.catName)) {
			matches.push(str.catName);
		  }
		});
		//console.log('------> ', matches);
		cb(matches);
	  };
	};

	$('#gittigidiyor_product_cat').typeahead({
	  hint: true,
	  highlight: true,
	  minLength: 3
	},
	{
	  name: 'names',
	  source: substringMatcher(catNames)
	});
	$('.typeahead').bind('typeahead:select', function(ev, suggestion) {
		//console.log('Selection: ' + suggestion);
		var selCode = '';
		$.each(catNames, function(i, cat) {
		  if (cat.catName == suggestion) {
			selCode = cat.catCode;
			//console.log('Sel Code: ' + selCode);
			$("#gittigidiyor_hierarchy").val(selCode);
		  }
		});
	});

</script>