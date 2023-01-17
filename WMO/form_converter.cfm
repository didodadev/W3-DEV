﻿<!--- genel bir form converter sayfası olacak bu sayade form add,upd action sayfalarının fuseactionları gereksiz olmuş olacak --->
<!--- ajax ile gönderilen json arraya dönüştürülür --->
<cfif isdefined("attributes.delEvent") and attributes.delEvent eq 1>
	<cfset formElements = DeserializeJSON(URLDecode(form.formElements, "utf-8"))>
    <cfloop collection='#formElements#' item='k'>
		<cfset attributes[k] = formElements[k]>
        <cfset form[k] = formElements[k]>
    </cfloop>
<cfelse>
	<cfset formElements = form>
    
    <cfloop collection='#formElements#' item='k'>
		<cfset attributes[k] = formElements[k]>
    </cfloop>
    <cfloop collection="#attributes#" item="k">
    	<cfif k contains 'CKEDITOR_'>
        	<cfset attributes[Replace(k,'CKEDITOR_','')] = attributes[k]>
            <cfset form[Replace(k,'CKEDITOR_','')] = attributes[k]>
        </cfif>
    </cfloop>
</cfif>
    <!--- <cfsavecontent variable="control5">
        <cfdump var="#attributes#">
    </cfsavecontent>
    <cffile action="write" file = "c:\attributes.html" output="#control5#"></cffile> --->
<cfif isdefined("attributes.pageFuseaction") and len(attributes.pageFuseaction)>
	<cfset attributes.fuseaction = attributes.pageFuseaction>
</cfif>

<cftry>
	<cfif isdefined("attributes.moduleForLanguage") and len(moduleForLanguage)>
        <cf_get_lang_set module_name="#attributes.moduleForLanguage#">
    </cfif>

    <cfif isdefined("attributes.delEvent") and attributes.delEvent eq 1>
    	<cfif not isdefined("attributes.pageDelEvent")>
	    	<cfset attributes.event = 'del'>
		<cfelse>
        	<cfset attributes.event = attributes.pageDelEvent>
        </cfif>
    </cfif>  

    <cfset attributes.tabMenuController = 0>
    <cfinclude template="../#attributes.controllerFileName#">
    
    <cfif isdefined("attributes.pageFuseaction")>
    	<cfset attributes.fuseaction = attributes.pageFuseaction>
        <cfset fuseactForStruct = attributes.pageFuseaction>
    <cfelse>
    	<cfset fuseactForStruct = StructKeyList(WOStruct)>
    </cfif>
	<cfif not attributes.event contains 'del' and WOStruct['#fuseactForStruct#']['#attributes.event#']['window'] is 'popup'>
    	<cfset wrk_reload = 1>
	<cfelseif attributes.event contains 'del' and WOStruct['#fuseactForStruct#']['#attributes.event#']['window'] is 'popup'>
    	<cfset wrk_reload = 1>
	<cfelseif attributes.event is 'del' and WOStruct['#fuseactForStruct#']['#attributes.event#']['window'] is 'popup'>
    	<cfset wrk_reload = 1>
    <cfelse>
    	<cfset wrk_reload = 0>
    </cfif>
 <cfset queryPath = structKeyExists( WOStruct['#attributes.fuseaction#']['#attributes.event#'], 'queryPath' ) ? WOStruct['#attributes.fuseaction#']['#attributes.event#']['queryPath']  : "" />
 <cfset nextEvent = structKeyExists( WOStruct['#attributes.fuseaction#']['#attributes.event#'], 'nextEvent' ) ? WOStruct['#attributes.fuseaction#']['#attributes.event#']['nextEvent']  : "" />
    <cfif not isdefined("attributes.actionId")>
        <cfset attributes.actionId = structKeyExists( WOStruct['#attributes.fuseaction#']['#attributes.event#'], 'Identity' ) ? WOStruct['#attributes.fuseaction#']['#attributes.event#']['Identity']  : "" />
    </cfif>
    <!--- daha sonra array elemanları attribute lere atanıyor. --->

    <cfset process_type = ''>
	<cfset process_stage = ''>
    <cfif isdefined("attributes.event") and attributes.event contains 'add'>
        <cfset log_type = 1>
    <cfelseif isdefined("attributes.event") and attributes.event contains 'upd'>
        <cfset log_type = 0>
    <cfelseif isdefined("attributes.event") and attributes.event contains 'del'>
        <cfset log_type = -1>
        <cfif isdefined("attributes.old_process_type")>
            <cfset process_type = attributes.old_process_type>
        </cfif>
    </cfif>
    <cfif isdefined("attributes.event") and attributes.event is 'add' and structKeyExists(WOStruct['#fuseactForStruct#'],'add') and StructKeyExists(WOStruct['#fuseactForStruct#']['add'],'nextEventTarget')>
    	<cfset openerLocation = 1>
    <cfelse>
    	<cfset openerLocation = 0>
    </cfif>
    
    
    <cfif structKeyExists(WOStruct['#fuseactForStruct#'],'systemObject')>
    	<cfif structKeyExists(WOStruct['#fuseactForStruct#']['systemObject'],'paperDate') and WOStruct['#fuseactForStruct#']['systemObject']['paperDate'] is true>
        	<cf_date tarih='attributes.action_date'>
        </cfif>
		<cfif structKeyExists(WOStruct['#fuseactForStruct#']['systemObject'],'paperNumber') and WOStruct['#fuseactForStruct#']['systemObject']['paperNumber'] is true>
			<cf_papers paper_type="#WOStruct['#fuseactForStruct#']['systemObject']['paperType']#">
        </cfif>
		<cfif structKeyExists(WOStruct['#fuseactForStruct#']['systemObject'],'processCat') and WOStruct['#fuseactForStruct#']['systemObject']['processCat'] is true>
        	<cfif isdefined("attributes.process_cat")>
            	<cfset process_type = attributes['ct_process_type_#attributes.process_cat#']>
            </cfif>
        </cfif>
        <cfif structKeyExists(WOStruct['#fuseactForStruct#']['systemObject'],'processStage') and WOStruct['#fuseactForStruct#']['systemObject']['processStage'] is true>
        	<cfif isdefined("attributes.process_stage")>
            	<cfset process_stage = attributes['process_stage']>
            </cfif>
        </cfif>
        <cfif not isdefined("attributes.paper_number")>
            <cfset attributes.paper_number = ''>
        </cfif>
		<cfif structKeyExists(WOStruct['#fuseactForStruct#']['systemObject'],'isTransaction') and WOStruct['#fuseactForStruct#']['systemObject']['isTransaction'] is true>
            <cftransaction>
                <cfif len(queryPath)>
	                <cfinclude template="../../#queryPath#">
                </cfif>
                <cfif not attributes.event is 'del'>
                    <cf_extendedFields dsn="#dsn#" fuseact="#fuseactForStruct#" controllerFileName='#attributes.controllerFileName#' actionId='#attributes.actionId#' sqlOperation="1">
                </cfif>
                <cfif structKeyExists(WOStruct['#fuseactForStruct#']['systemObject'],'processStage') and WOStruct['#fuseactForStruct#']['systemObject']['processStage'] is true and isdefined("attributes.process_stage") and len(attributes.process_stage)>
                    <cf_workcube_process
                        is_upd='1'
                        data_source="#WOStruct['#fuseactForStruct#']['systemObject']['dataSourceName']#"
                        old_process_line='0'
                        process_stage='#attributes.process_stage#'
                        record_member='#session.ep.userid#'
                        record_date='#now()#'
                        action_table="#WOStruct['#fuseactForStruct#']['systemObject']['pageTableName']#"
                        action_column="#WOStruct['#fuseactForStruct#']['systemObject']['pageIdentityColumn']#"
                        action_id='#attributes.actionId#'
                        action_page='#request.self#?fuseaction=#nextEvent##attributes.actionId#'
                        warning_description='#attributes.pageHead#'>
                </cfif>
                <cf_add_log employee_id="#session.ep.userid#" log_type="#log_type#" action_id="#attributes.actionId#" action_name= "#attributes.pageHead#" period_id="#session.ep.period_id#" process_type="#process_type#" process_stage="#process_stage#" data_source="#WOStruct['#fuseactForStruct#']['systemObject']['dataSourceName']#" fuseact="#fuseactForStruct#" paper_no= "#attributes.paper_number#">
            </cftransaction>
		<cfelse>
            <cfif len(queryPath)>
                <cfset extensions = createObject('component','WDO.development.cfc.extensions')>
                <cfset before_extensions = extensions.get_related_components(attributes.fuseaction, 2, 1, isDefined("attributes.event") ? attributes.event : "list")>
                <cfloop query="before_extensions">
                    <cfinclude template="..#before_extensions.COMPONENT_FILE_PATH#">
                </cfloop>
                <cfinclude template="../#queryPath#">
                <cfset after_extensions = extensions.get_related_components(attributes.fuseaction, 2, 2, isDefined("attributes.event") ? attributes.event : "list")>
                <cfloop query="after_extensions">
                    <cfinclude template="../#after_extensions.COMPONENT_FILE_PATH#">
                </cfloop>
            </cfif>
            <!---
            <cfif not attributes.event contains 'del'>
                <cf_extendedFields dsn="#dsn#" fuseact="#fuseactForStruct#" controllerFileName='#attributes.controllerFileName#' actionId='#attributes.actionId#' sqlOperation="1">
            </cfif>
			<cfif structKeyExists(WOStruct['#fuseactForStruct#']['systemObject'],'processStage') and WOStruct['#fuseactForStruct#']['systemObject']['processStage'] is true and isdefined("attributes.process_stage") and len(attributes.process_stage)>
                <cf_workcube_process
                    is_upd='1'
                    data_source="#WOStruct['#fuseactForStruct#']['systemObject']['dataSourceName']#"
                    old_process_line='0'
                    process_stage='#attributes.process_stage#'
                    record_member='#session.ep.userid#'
                    record_date='#now()#'
                    action_table="#WOStruct['#fuseactForStruct#']['systemObject']['pageTableName']#"
                    action_column="#WOStruct['#fuseactForStruct#']['systemObject']['pageIdentityColumn']#"
                    action_id='#attributes.actionId#'
                    action_page='#request.self#?fuseaction=#nextEvent##attributes.actionId#'
                    warning_description='#attributes.pageHead#'>
            </cfif>
            <cf_add_log employee_id="#session.ep.userid#" log_type="#log_type#" action_id="#attributes.actionId#" action_name= "#attributes.pageHead#" period_id="#session.ep.period_id#" process_type="#process_type#" process_stage="#process_stage#" data_source="#WOStruct['#fuseactForStruct#']['systemObject']['dataSourceName']#" fuseact="#fuseactForStruct#" paper_no= "#attributes.paper_number#">
			--->
        </cfif>
    <cfelse>
        <cfif len(queryPath)>
            <cfset extensions = createObject('component','WDO.development.cfc.extensions')>
            <cfset before_extensions = extensions.get_related_components(attributes.fuseaction, 2, 1, isDefined("attributes.event") ? attributes.event : "list")>
            <cfloop query="before_extensions">
                <cfinclude template="..#before_extensions.COMPONENT_FILE_PATH#">
            </cfloop>
            <cfinclude template="../#queryPath#">
            <cfset after_extensions = extensions.get_related_components(attributes.fuseaction, 2, 2, isDefined("attributes.event") ? attributes.event : "list")>
            <cfloop query="after_extensions">
                <cfinclude template="../#after_extensions.COMPONENT_FILE_PATH#">
            </cfloop>
        </cfif>
        <!---
        <cfif isdefined("attributes.controllerFileName") and not attributes.event is 'del'>
            <cf_extendedFields dsn="#dsn#" fuseact="#fuseactForStruct#" controllerFileName='#attributes.controllerFileName#' actionId='#attributes.actionId#' sqlOperation="1">
        </cfif>
		--->
    </cfif>
	<cfif isdefined("attributes.event") and attributes.event contains 'del'>
		<cfset attributes.actionId = ''>
	</cfif>
	<cfif isdefined("attributes.pageMainEvent")>
        <cfset nextEvent = WOStruct['#fuseactForStruct#']['#attributes.pageMainEvent#']['nextEvent']>
    </cfif>
    <script type="text/javascript">
		<cfif not isdefined("attributes.spa")>
			<cfif openerLocation eq 1 and len(attributes.actionId)>
				window.opener.location.href='<cfoutput>#request.self#?fuseaction=#nextEvent##attributes.actionId#</cfoutput>';
				window.close();
			<cfelse>
				<cfif isdefined("attributes.delEvent") and attributes.delEvent eq 1 and wrk_reload eq 1><!--- Silme --->
					wrk_opener_reload();
					window.close();
				<cfelseif wrk_reload eq 1 and (isdefined("attributes.event") and attributes.event contains 'add')>
					<cfif len(nextEvent)  and len(attributes.actionId)><!--- Çoklu işlem yapan bazı sayfalarda eklemenin ardından güncellemeye gidilmiyor. Onun yerine popup kapatılıp arka taraftaki ekran yenileniyor. --->
						window.location.href='<cfoutput>#request.self#?fuseaction=#nextEvent##attributes.actionId#</cfoutput>';
					<cfelse>
						wrk_opener_reload();
						window.close();
					</cfif>
				<cfelseif wrk_reload eq 1 and (isdefined("attributes.event") and attributes.event contains 'upd')>
					window.location.reload();
				<cfelseif len(attributes.actionId)>
					window.location.href='<cfoutput>#request.self#?fuseaction=#nextEvent##attributes.actionId#</cfoutput>';
				</cfif>
			</cfif>
		</cfif>
	</script>
<cfcatch>
	<cftry>
        <cfsavecontent variable="control5">
            <cfdump var="#cfcatch#">
        </cfsavecontent>
        <cffile action="write" file = "c:\cfcatch.html" output="#control5#"></cffile>
		<cfset rtn = StructNew()>
		<cfset rtn.WRK_ERROR_CODE = "1">
		<cfsavecontent variable="msg"><cf_get_lang dictionary_id="52153.Sistem Yoneticisi"></cfsavecontent>
		<cfset rtn.WRK_ERROR_MESSAGE = msg>
		<cfset rtn.ERROR_CODE = cfcatch.ErrorCode>
		<cfset rtn.ERRORMESSAGE = cfcatch.Message>
		<cfset rtn.ERRORFILE = cfcatch.TagContext[1].TEMPLATE>
		<cfset rtn.ERRORLINE = cfcatch.TagContext[1].LINE>
		<cfset rtn.CFCATCH = cfcatch>
    <cfcatch>
		<cfset rtn = StructNew()>
		<cfset rtn.WRK_ERROR_CODE = "1">
		<cfset rtn.WRK_ERROR_MESSAGE="İşlem Başarısız">
	</cfcatch>
    </cftry>
	<cfoutput>#replace(serializeJSON(rtn),"//","","one")#<!---İşlem Hatalı (hata durumunda 0 dönsün ki buna bağlı uyarı verebilelim)---></cfoutput>
</cfcatch>
</cftry>