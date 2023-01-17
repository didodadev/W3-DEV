<cfscript>
	import_comp = createObject("component","V16.settings.cfc.subscriptionPaymentPlanImportType");
	type_file = "";
</cfscript>
<cfif isdefined("attributes.file_del") and attributes.file_del eq 1>
	<cfscript>
			type = import_comp.get_byid(import_type_id:attributes.import_type_id);
			type_file = type.cfc_file;
	</cfscript>
	<cfif len(type_file) and FileExists("#upload_folder##dir_seperator#sales#dir_seperator#import_type#dir_seperator##type_file#.cfc")>
		<cffile action="delete" file="#upload_folder##dir_seperator#sales#dir_seperator#import_type#dir_seperator##type_file#.cfc">
	</cfif>
</cfif>

<cfset file_name="">
<cfif isDefined("attributes.cfc_file") and len(attributes.cfc_file)>
	<cftry>
	<cfif not directoryExists("#upload_folder##dir_seperator#sales#dir_seperator#import_type")>
		<cfdirectory action="create" directory="#upload_folder##dir_seperator#sales#dir_seperator#import_type">
	</cfif>
	<cfset upload_folder = "#upload_folder##dir_seperator#sales#dir_seperator#import_type#dir_seperator#">
	<cffile action="UPLOAD" filefield="cfc_file" destination="#upload_folder#" mode="777" nameconflict="MAKEUNIQUE" accept=".cfc" STRICT="false">

	<cfset file_name = createUUID()>
	<cfset file_name=replace(file_name,'-','_','all')><!--- cfc componet oluşturulurken hata oluşabiliyor bundan - ler _ yapıldı --->
	<cffile action="rename" source="#upload_folder##cffile.serverfile#" destination="#upload_folder##file_name#.#cffile.serverfileext#">
	
	<cfset assetTypeName = listlast(cffile.serverfile,'.')>
	<cfset whiteList = 'cfc'>
	<cfif not listfind(whiteList,assetTypeName,',')>
		<cffile action="delete" file="#upload_folder##file_name#.#cffile.serverfileext#">
		<script type="text/javascript">
			alert("Dosya Formatı cfc olmalıdır!!");
			//history.back();
		</script>
		<cfabort>
	</cfif>		
		
	<cfset attributes.uploaded_file = '#file_name#.#cffile.serverfileext#'>
	
	<cfcatch type="Any">
		<script type="text/javascript">
			alert("<cf_get_lang_main no ='43.Dosyanız upload edilemedi ! Dosyanızı kontrol ediniz'> !");
			//history.back();
		</script>
		<cfabort>
	</cfcatch>  
</cftry>
</cfif>
<cfscript>
	if(isDefined("attributes.form_submitted") and len(attributes.form_submitted)){	
		if(not len(attributes.import_type_id)){
			if(import_comp.ADD(
				IMPORT_TYPE_NAME: '#attributes.IMPORT_TYPE_NAME#',
				SUBSCRIPTION_TYPE_ID: '#attributes.SUBSCRIPTION_TYPE_ID#',
				IMPORT_TYPE:'#attributes.IMPORT_TYPE#',
				PAYMETHOD_ID: iif(len(attributes.payment_type) and len(attributes.PAYMETHOD_ID),attributes.PAYMETHOD_ID,0),
				IS_PAYMENT_DATE: iif(isDefined("attributes.IS_PAYMENT_DATE"),true,false),
				PRODUCT_ID: iif(len(attributes.PRODUCT_ID),attributes.PRODUCT_ID,0),
				STOCK_ID: iif(len(attributes.STOCK_ID),attributes.STOCK_ID,0),
				DETAIL: iif(len(attributes.DETAIL), DE('#attributes.DETAIL#'),''),
				USE_PRODUCT_PRICE: iif(isDefined("attributes.USE_PRODUCT_PRICE"),true,false),
				USE_PRODUCT_REASON_CODE: iif(isDefined("attributes.USE_PRODUCT_REASON_CODE"),true,false),
				USE_PRODUCT_PAYMETHOD: iif(isDefined("attributes.USE_PRODUCT_PAYMETHOD"),true,false),
				USE_PRODUCT_TAX: iif(isDefined("attributes.USE_PRODUCT_TAX"),true,false),
				IS_COLLECTED_INVOICE: iif(isDefined("attributes.IS_COLLECTED_INVOICE"),true,false),
				IS_GROUP_INVOICE: iif(isDefined("attributes.IS_GROUP_INVOICE"),true,false),
				IS_ROW_DESCRIPTION:  iif(isDefined("attributes.IS_ROW_DESCRIPTION"),true,false),
				IS_ALLOW_ZERO_PRICE: iif(isDefined("attributes.IS_ALLOW_ZERO_PRICE"),true,false),
				CFC_FILE: "#file_name#",
				TYPE_DESCRIPTION: "#attributes.TYPE_DESCRIPTION#"
				)
			){ 
				attributes.actionid = import_comp.get_maxId();
			}
			else {
				
				writeOutput("<script>alert('Hata Oluştu');</script>");
			}
		}else{
			attributes.actionid = attributes.import_type_id;
			if(len(file_name)){
				if(NOT import_comp.UPDATE(
					IMPORT_TYPE_ID: attributes.import_type_id,
					IMPORT_TYPE_NAME: '#attributes.IMPORT_TYPE_NAME#',
					SUBSCRIPTION_TYPE_ID: '#attributes.SUBSCRIPTION_TYPE_ID#',
					IMPORT_TYPE:'#attributes.IMPORT_TYPE#',
					PAYMETHOD_ID: iif(len(attributes.payment_type) and len(attributes.PAYMETHOD_ID),attributes.PAYMETHOD_ID,0),
					IS_PAYMENT_DATE: iif(isDefined("attributes.IS_PAYMENT_DATE"),true,false),
					PRODUCT_ID: iif(len(attributes.PRODUCT_ID),attributes.PRODUCT_ID,0),
					STOCK_ID: iif(len(attributes.STOCK_ID),attributes.STOCK_ID,0),
					DETAIL: iif(len(attributes.DETAIL), DE('#attributes.DETAIL#'),''),
					USE_PRODUCT_PRICE: iif(isDefined("attributes.USE_PRODUCT_PRICE"),true,false),
					USE_PRODUCT_REASON_CODE: iif(isDefined("attributes.USE_PRODUCT_REASON_CODE"),true,false),
					USE_PRODUCT_PAYMETHOD: iif(isDefined("attributes.USE_PRODUCT_PAYMETHOD"),true,false),
					USE_PRODUCT_TAX: iif(isDefined("attributes.USE_PRODUCT_TAX"),true,false),
					IS_COLLECTED_INVOICE: iif(isDefined("attributes.IS_COLLECTED_INVOICE"),true,false),
					IS_GROUP_INVOICE: iif(isDefined("attributes.IS_GROUP_INVOICE"),true,false),
					IS_ROW_DESCRIPTION:  iif(isDefined("attributes.IS_ROW_DESCRIPTION"),true,false),
					IS_ALLOW_ZERO_PRICE: iif(isDefined("attributes.IS_ALLOW_ZERO_PRICE"),true,false),
					CFC_FILE: "#file_name#",
					TYPE_DESCRIPTION: "#attributes.TYPE_DESCRIPTION#"
					)){
						writeOutput("<script>alert('Hata Oluştu');</script>");
					}
			}else{
				if(NOT import_comp.UPDATE(
					IMPORT_TYPE_ID: attributes.import_type_id,
					IMPORT_TYPE_NAME: '#attributes.IMPORT_TYPE_NAME#',
					SUBSCRIPTION_TYPE_ID: '#attributes.SUBSCRIPTION_TYPE_ID#',
					IMPORT_TYPE:'#attributes.IMPORT_TYPE#',
					PAYMETHOD_ID: iif(len(attributes.payment_type) and len(attributes.PAYMETHOD_ID),attributes.PAYMETHOD_ID,0),
					IS_PAYMENT_DATE: iif(isDefined("attributes.IS_PAYMENT_DATE"),true,false),
					PRODUCT_ID: iif(len(attributes.PRODUCT_ID),attributes.PRODUCT_ID,0),
					STOCK_ID: iif(len(attributes.STOCK_ID),attributes.STOCK_ID,0),
					DETAIL: iif(len(attributes.DETAIL), DE('#attributes.DETAIL#'),''),
					USE_PRODUCT_PRICE: iif(isDefined("attributes.USE_PRODUCT_PRICE"),true,false),
					USE_PRODUCT_REASON_CODE: iif(isDefined("attributes.USE_PRODUCT_REASON_CODE"),true,false),
					USE_PRODUCT_PAYMETHOD: iif(isDefined("attributes.USE_PRODUCT_PAYMETHOD"),true,false),
					USE_PRODUCT_TAX: iif(isDefined("attributes.USE_PRODUCT_TAX"),true,false),
					IS_COLLECTED_INVOICE: iif(isDefined("attributes.IS_COLLECTED_INVOICE"),true,false),
					IS_GROUP_INVOICE: iif(isDefined("attributes.IS_GROUP_INVOICE"),true,false),
					IS_ROW_DESCRIPTION:  iif(isDefined("attributes.IS_ROW_DESCRIPTION"),true,false),
					IS_ALLOW_ZERO_PRICE: iif(isDefined("attributes.IS_ALLOW_ZERO_PRICE"),true,false),
					TYPE_DESCRIPTION: "#attributes.TYPE_DESCRIPTION#"
					)){
						writeOutput("<script>alert('Hata Oluştu');</script>");
					}
			}
		}
	}
</cfscript>