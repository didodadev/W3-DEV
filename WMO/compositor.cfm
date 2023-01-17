<!--- Bu dosyadan önce yüklenen controller'a göre sayfanın yapısını oluşturan değişkenler başlığı, tab'ları, eklenen yeni alanları, ilgili dosyası burada set edilir. --->
<cfscript>
	if(isdefined('attributes.event'))
		filePath = WOStruct['#attributes.fuseaction#']['#attributes.event#'].filePath;
	else
		filePath = WOStruct['#attributes.fuseaction#']["#WOStruct['#attributes.fuseaction#']['default']#"].filePath;
	
	if(not isdefined("attributes.event"))
		attributes.event = '#WOStruct['#attributes.fuseaction#']['default']#';

	if (StructKeyExists(WOStruct['#attributes.fuseaction#'],'add'))
	{
		addPage = '#request.self#?fuseaction=#WOStruct['#attributes.fuseaction#']["#WOStruct['#attributes.fuseaction#']['default']#"].fuseaction#&event=add';
		if(WOStruct['#attributes.fuseaction#']['add'].window is 'popup')
			addPage = '#attributes.fuseaction#.add&window=#WOStruct['#attributes.fuseaction#']['add'].window#';
	}
	if (StructKeyExists(WOStruct['#attributes.fuseaction#'],'upd'))
	{
		updPage = '#request.self#?fuseaction=#WOStruct['#attributes.fuseaction#']["#WOStruct['#attributes.fuseaction#']['default']#"].fuseaction#&event=upd';
		if(StructKeyExists(WOStruct['#attributes.fuseaction#']['upd'],'parameters'))
			updPage = '#updPage#&#WOStruct['#attributes.fuseaction#']['upd']['parameters']#';
		if(WOStruct['#attributes.fuseaction#']['upd'].window is 'popup')
			updPage = '#attributes.fuseaction#.upd&window=#WOStruct['#attributes.fuseaction#']['upd'].window#';
	}
	if (StructKeyExists(WOStruct['#attributes.fuseaction#'],'list'))
		listPage = "#request.self#?fuseaction=#WOStruct['#attributes.fuseaction#']['list']['fuseaction']#";
	
	if(len('#pageDictionaryId#'))
	{
		pageHead = '#getLang(pageDictionaryId)#';
		
		if(isdefined("attributes.event") and len(attributes.event) and StructKeyExists(WOStruct["#attributes.fuseaction#"]["#attributes.event#"],'Identity') and len(evaluate(de('#WOStruct["#attributes.fuseaction#"]["#attributes.event#"]["Identity"]#'))))
			pageHead = '#pageHead# : #evaluate(de('#WOStruct["#attributes.fuseaction#"]["#attributes.event#"]["Identity"]#'))#';
        else if(isdefined('attributes.event') and attributes.event is 'add')
			pageHead = '#pageHead# : #getLang('main',2352)#';
		else
			pageHead = '#pageHead#';
	}
	else
	{
		pageHead = '#get_fuseactions.HEAD#';
	}
	
	/*if(attributes.event is 'list')
		pageHead = '';
	*/
	
	if(StructKeyExists(WoStruct,'#attributes.fuseaction#'))
	{
		if(structKeyExists(WoStruct['#attributes.fuseaction#'],'systemObject') and structKeyExists(WoStruct['#attributes.fuseaction#']['systemObject'],'extendedForm') and WoStruct['#attributes.fuseaction#']['systemObject']['extendedForm'] is true)
		{
			controllerEventList = WoStruct['#attributes.fuseaction#']['systemObject']['pageExtendedEventList'];
			if(structKeyExists(WoStruct['#attributes.fuseaction#']['systemObject'],'pageSettings'))
				controllerSettings = WoStruct['#attributes.fuseaction#']['systemObject']['pageSettings'];
			else
				controllerSettings = '';
		}	
		else
		{
			controllerEventList = '#attributes.event#';
			controllerSettings = '';
		}
	}
</cfscript>

<!--- İlgili formda alan ekleme mevcutsa kontrolleri burada yapılıyor. Bu sayfadaki query'ler taşınacak. Çalışma devam ettiği için bekletiliyor. --->
<cfquery name="GET_MODIFIED_TABLE_EMPLOYEE" datasource="#dsn#">
    SELECT
    	DISTINCT
        MP.JSON_DATA
    FROM 
        MODIFIED_PAGE AS MP
    WHERE
        MP.COMPANY_ID = #session.ep.company_id# AND
        MP.PERIOD_ID = #session.ep.period_id# AND
        MP.CONTROLLER_NAME = <cfqueryparam cfsqltype="cf_sql_varchar" value="#pageControllerName#"> AND
        ','+MP.EVENT_LIST+',' LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%,#attributes.event#,%"> AND
        MP.POSITION_CODE <> -1 AND
        MP.POSITION_CODE <> 0
</cfquery>
<cfquery name="GET_USER_SESSION_POSITION_CAT_ID" datasource="#dsn#">
    SELECT
    	POSITION_CAT_ID
    FROM 
        EMPLOYEE_POSITIONS EP
    WHERE
        EP.EMPLOYEE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.userid#">
</cfquery>

<cfset employeeData = valuelist(GET_MODIFIED_TABLE_EMPLOYEE.JSON_DATA)>

<cfquery name="GET_LIST_OPTION" datasource="#dsn#">
    SELECT
        JSON_DATA
    FROM 
        MODIFIED_PAGE AS MP
    WHERE
        MP.CONTROLLER_NAME = <cfqueryparam cfsqltype="cf_sql_varchar" value="#pageControllerName#">
        AND JSON_TYPE = 5
        AND POSITION_CODE = -1
</cfquery>
<cfset attributes.js_hidden_list = ''>
<cfset attributes.js_mhidden_list = ''>
<cfif GET_LIST_OPTION.recordcount>
    <cfset sortList = deSerializeJSON(GET_LIST_OPTION.JSON_DATA)>
    <cfset string = '{'>
    <cfloop index="sortIndex" from="0" to="#StructCount(sortList)-1#">
        <cfset idmhidden = ( structKeyExists(sortList[sortIndex], "id") )  ? sortList[sortIndex]["id"] : sortList[sortIndex]["mhidden"]>
        <cfset string = string & '"' & idmhidden & '":' & sortIndex & ','>
		<cfif structKeyExists(sortList[sortIndex], "id") and sortList[sortIndex]['hidden'] eq 0>
        	<cfset attributes.js_hidden_list = listAppend(attributes.js_hidden_list,Replace(sortList[sortIndex]["id"],'th_',''),',')>
        </cfif>
        <cfif structKeyExists(sortList[sortIndex], 'mhidden') and sortList[sortIndex]['mhidden'] eq 1>
            <cfset attributes.js_mhidden_list = listAppend(attributes.js_mhidden_list,Replace(sortList[sortIndex]['mhidden'],'th_',''),',')>
        </cfif>
    </cfloop>
    <cfset string = string & '"}'>
    <cfset attributes.js_column_order = Replace(string,',"}','}')>
</cfif>

<cfquery name="GET_MODIFIED_TABLE_ALL" datasource="#dsn#">
    SELECT
        MP.JSON_DATA,
        MP.RECORD_DATE AS RECORD_DATE,
        E.EMPLOYEE_NAME + ' ' + E.EMPLOYEE_SURNAME AS RECORD_EMP
    FROM 
        MODIFIED_PAGE AS MP
        LEFT JOIN EMPLOYEES AS E ON MP.RECORD_EMP = E.EMPLOYEE_ID
    WHERE
        MP.COMPANY_ID = #session.ep.company_id# AND
        <!---MP.PERIOD_ID = #session.ep.period_id# AND--->
        MP.CONTROLLER_NAME = <cfqueryparam cfsqltype="cf_sql_varchar" value="#pageControllerName#"> AND
        MP.EVENT_LIST = <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.event#"> AND
        MP.EVENT_LIST <> <cfqueryparam cfsqltype="cf_sql_varchar" value="detSort"> AND
        MP.POSITION_CODE = 0
</cfquery>

<cfquery name="GET_MODIFIED_TABLE_COLUMNS" datasource="#dsn#">
    SELECT
        MP.JSON_DATA
    FROM 
        MODIFIED_PAGE AS MP
    WHERE
        MP.COMPANY_ID = #session.ep.company_id# AND
        <!---MP.PERIOD_ID = #session.ep.period_id# AND--->
        MP.CONTROLLER_NAME = <cfqueryparam cfsqltype="cf_sql_varchar" value="#pageControllerName#"> AND
        ','+MP.EVENT_LIST+',' LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%,#attributes.event#,%"> AND
        MP.POSITION_CODE = -1
</cfquery>

<cfquery name="GET_MODIFIED_DET_EVENTS" datasource="#dsn#"><!--- Det event'larında sayfaların yerleşimleri düzenleniyor --->
    SELECT
        MP.JSON_DATA
    FROM 
        MODIFIED_PAGE AS MP
    WHERE
        MP.COMPANY_ID = #session.ep.company_id# AND
        <!---MP.PERIOD_ID = #session.ep.period_id# AND--->
        MP.CONTROLLER_NAME = <cfqueryparam cfsqltype="cf_sql_varchar" value="#pageControllerName#"> AND
        MP.EVENT_LIST = <cfqueryparam cfsqltype="cf_sql_varchar" value="detSort"> AND
        MP.POSITION_CODE = -1
</cfquery>
<cfquery name="GET_MODIFIED_DET_EVENTS_ROW" datasource="#dsn#"><!--- Det event'larında sayfaların yerleşimleri düzenleniyor --->
    SELECT
        MP.JSON_DATA
    FROM 
        MODIFIED_PAGE AS MP
    WHERE
        MP.COMPANY_ID = #session.ep.company_id# AND
        <!---MP.PERIOD_ID = #session.ep.period_id# AND--->
        MP.CONTROLLER_NAME = <cfqueryparam cfsqltype="cf_sql_varchar" value="#pageControllerName#"> AND
        MP.EVENT_LIST = <cfqueryparam cfsqltype="cf_sql_varchar" value="detSort"> AND
        MP.POSITION_CODE = 0
</cfquery>

<script type="text/javascript">
    var language = {
        
            diger			: "<cf_get_lang_main no="744.diğer">",
            gundem			: "<cf_get_lang_main no="1.gündem">",
            kolon			: "<cfoutput>#getLang('report',30)#</cfoutput>",            
            aktif			: "<cf_get_lang_main no="81.aktif">",            
            sadeceOkunur	: "<cfoutput>#getLang('settings',1750)#</cfoutput>",           
            zorunlu			: "<cfoutput>#getLang('settings',3073)#</cfoutput>",            
            kaydedildi		: "<cf_get_lang_main no="1478.Kaydedildi">",
            workcube_hata	: "<cf_get_lang_main no="779.WorkCube Hata">",
            kaydediliyor    : "<cf_get_lang_main no="1477.Kaydediliyor">",
            BuKolonDuzenlenemez : "<cfoutput>#getLang('settings',1751)#</cfoutput>",            
            tabMenu				: "<cfoutput>#getLang('settings',1752)#</cfoutput>",            
            belge_numarası      : "<cfoutput>#getLang('sales',156)#</cfoutput>"
        }
	var settings = [
	
		'a[href="javascript:;"]',
		'a[href="javascript:void(0)"]',
		'a[href="javascript://"]',
		'a[href="#"]'		
			
	];// settings

    <cfif GET_MODIFIED_TABLE_ALL.recordcount>

    <cfset serializedData = deSerializeJSON( GET_MODIFIED_TABLE_COLUMNS.JSON_DATA ) />
    <cfif isStruct( serializedData )>
        <cfset jsonData = GET_MODIFIED_TABLE_COLUMNS.JSON_DATA>
    <cfelse>
        <cfset pageDesignerModel = structNew() />
        <cfset pageDesignerModel["pageType"] = "" />
        <cfset pageDesignerModel["pageDesign"] = serializedData />
        <cfset jsonData = Replace(serializeJson( pageDesignerModel ),"//", "")/>
    </cfif>

    var positionJson = '{"positions":<cfif GET_MODIFIED_TABLE_EMPLOYEE.recordcount><cfoutput>[#employeeData#]</cfoutput><cfelse>[]</cfif>,"all":<cfoutput>#GET_MODIFIED_TABLE_ALL.JSON_DATA#</cfoutput>,"column":<cfoutput>#jsonData#</cfoutput>}';
    var returnDefaultParam = 1;
    <cfelse>
    var positionJson = '{"positions":[],"all":[],"column":{"pageType":"","pageDesign":[]}}';
    var returnDefaultParam = 0;
    </cfif>

    var positionId = '<cfoutput>#GET_USER_SESSION_POSITION_CAT_ID.POSITION_CAT_ID#</cfoutput>';
    function ActionPDesigner(screenType = ''){
        
        var settings = <cfif len(controllerSettings)><cfoutput>#controllerSettings#</cfoutput><cfelse>[]</cfif>;
        
        setTimeout(function() {
            shiftElement( positionId, settings, '<cfoutput>#GET_USER_SESSION_POSITION_CAT_ID.POSITION_CAT_ID#</cfoutput>',screenType ); //position Id
        
            <cfif isdefined("attributes.event")>
                sortElement("<cfoutput>#pageControllerName#</cfoutput>","<cfoutput>#attributes.event#</cfoutput>",settings,returnDefaultParam<cfif len(GET_MODIFIED_TABLE_ALL.RECORD_EMP)>,'<cfoutput>#GET_MODIFIED_TABLE_ALL.RECORD_EMP#</cfoutput>','<cfoutput>#dateFormat(GET_MODIFIED_TABLE_ALL.RECORD_DATE,"dd/mm/yyyy")#-#TimeFormat(GET_MODIFIED_TABLE_ALL.RECORD_DATE,"HH:mm")#</cfoutput>'</cfif>);
            <cfelse>
                sortElement("<cfoutput>#pageControllerName#</cfoutput>","<cfoutput>#controllerEventList#</cfoutput>",settings,returnDefaultParam<cfif len(GET_MODIFIED_TABLE_ALL.RECORD_EMP)>,'<cfoutput>#GET_MODIFIED_TABLE_ALL.RECORD_EMP#</cfoutput>','<cfoutput>#dateFormat(GET_MODIFIED_TABLE_ALL.RECORD_DATE,"dd/mm/yyyy")#-#TimeFormat(GET_MODIFIED_TABLE_ALL.RECORD_DATE,"HH:mm")#</cfoutput>'</cfif>);
            </cfif>
        }, 1);

    }

    $(function(){
       
        if ( positionJson != null ){
            $( "section[class*='pageBody']" ).addClass('hide');
            
            positionJsonParse ( positionJson );

            ActionPDesigner();

            <cfif GET_MODIFIED_DET_EVENTS.recordcount>
                sortDetElement('<cfoutput>#GET_MODIFIED_DET_EVENTS.JSON_DATA#</cfoutput>','<cfoutput>#GET_MODIFIED_DET_EVENTS_ROW.JSON_DATA#</cfoutput>',"<cfoutput>#pageControllerName#</cfoutput>");
            <cfelse>
                sortDetPage("<cfoutput>#pageControllerName#</cfoutput>",0);
            </cfif>

            $( "section[class*='pageBody']" ).removeClass('hide').show( "slow" );
        }// if 
        <cfif isdefined("client.openModal") and client.openmodal eq 1>
            myPopup('formPanel');
        </cfif>

    });//reday

	pageTitle("<cfoutput>#pageHead#</cfoutput>");
</script>
<cfset client.openModal = 0>

<!--- Single Page Application'a göre yazılmış sayfalar için başlığın değişimini gerçekleştiriyor. --->
<script type="text/javascript">
	<cfif isdefined("URL.spa") and URL.spa eq 1>
		var pageHeadForSpa = '<cfoutput>#pageHead#</cfoutput>';
	<cfelse>
		var pageHeadForSpa = '';
	</cfif>
</script>
<cfset pageProcessControl = false>
<input type="hidden" name="controllerEvents" id="controllerEvents" value="<cfoutput>#attributes.event#</cfoutput>"/>
<cfoutput>
    <cfif isdefined("session.ep.lang_change_action") and session.ep.lang_change_action eq 1>
        <cfset ArrayClear(request.pagelangList)>
    </cfif>
	<cfif StructKeyExists(WOStruct['#attributes.fuseaction#'], isDefined("attributes.event") ? attributes.event : "list")>
        <cfif structKeyExists(application.objects['#URL.fuseaction#'], 'DATA_CFC') and len(application.objects['#URL.fuseaction#']['DATA_CFC']) and attributes.event eq "upd">
            <cfobject name="instance_#listlast(application.objects['#URL.fuseaction#']['DATA_CFC'], ".")#" type="component" component="#application.objects['#URL.fuseaction#']['DATA_CFC']#">
            <cfif structKeyExists( evaluate("instance_" & listlast(application.objects['#URL.fuseaction#']['DATA_CFC'], ".")),'get')>
                <cfset variables["data_#listlast(application.objects['#URL.fuseaction#']['DATA_CFC'], ".")#"] = evaluate("instance_" & listlast(application.objects['#URL.fuseaction#']['DATA_CFC'], ".")).get(argumentCollection = attributes)>
            </cfif>
        </cfif>
        <div class="pageMainLayout">
            <cfset extensions = createObject('component','WDO.development.cfc.extensions')>
            <cfset before_extensions = extensions.get_related_components(attributes.fuseaction, 1, 1, isDefined("attributes.event") ? attributes.event : "list")>
            <cfloop query="before_extensions">
                <cfinclude template="..#before_extensions.COMPONENT_FILE_PATH#">
            </cfloop>
            <cfinclude template="../#filePath#">
            <cfset after_extensions = extensions.get_related_components(attributes.fuseaction, 1, 2, isDefined("attributes.event") ? attributes.event : "list")>
            <cfloop query="after_extensions">
                <cfinclude template="../#after_extensions.COMPONENT_FILE_PATH#">
            </cfloop>
        </div>
    </cfif>
</cfoutput>
<!--- Kaydetme güncelleme fonksiyonunda tabMenu'ye oge ekleniyor. O yüzden asagi tasindi --->