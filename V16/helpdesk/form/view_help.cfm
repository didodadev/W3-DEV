<cfsetting showdebugoutput="no">
<cfif isdefined("attributes.help_id") and len(attributes.help_id) and isnumeric(attributes.help_id)>
  <cfinclude template="../query/get_help.cfm">
<cfelse>
	<cfset get_help.recordcount = 0>
</cfif>
<cfif not get_help.recordcount>
	<cfset hata  = 11>
	<cfsavecontent variable="message"><cf_get_lang_main no='585.Şube Yetkiniz Uygun Değil'> <cf_get_lang_main no='586.Veya'>  <cf_get_lang_main no='1531.Böyle Bir Kayıt Bulunmamaktadır'> !</cfsavecontent>
	<cfset hata_mesaj  = message>
	<cfinclude template="../../dsp_hata.cfm">
<cfelse>
	<cfparam name="attributes.keyword" default="">
	<cfparam name="attributes.help" default="">
	<cfquery name="get_modules" datasource="#DSN#">
		SELECT MODULE_ID, MODULE_NAME_TR, MODULE_SHORT_NAME FROM MODULES ORDER BY MODULE_ID ASC
	</cfquery>
	<cfset modul_list = valuelist(GET_MODULES.MODULE_SHORT_NAME)>
	<cfquery name="get_other_helps" datasource="#dsn#">
		SELECT
			HELP_ID,
			HELP_HEAD,
            RECORD_DATE,
			UPDATE_DATE,
			RECORD_MEMBER,
			UPDATE_MEMBER
		FROM
			HELP_DESK
		WHERE
			HELP_CIRCUIT LIKE '#get_help.help_circuit#%'
			AND HELP_LANGUAGE = <cfqueryparam cfsqltype="cf_sql_varchar" value="#get_help.help_language#">
			AND HELP_ID <> #get_help.help_id#
		ORDER BY 
			HELP_HEAD
	</cfquery>
	<cfquery name="get_help_language" datasource="#dsn#">
		SELECT LANGUAGE_SHORT,LANGUAGE_SET FROM SETUP_LANGUAGE ORDER BY LANGUAGE_SET
	</cfquery>
	<cfif isDefined('session.ep.maxrows')>
		<cfparam name="attributes.maxrows" default='#session.ep.maxrows#'>
	<cfelseif isDefined('session.pp.maxrows')>
		<cfparam name="attributes.maxrows" default='#session.pp.maxrows#'>
	</cfif>
<!---- Search   ---->
<cfquery name="GET_MODULES" datasource="#DSN#">
	SELECT MODULE_ID, MODULE_NAME_TR, MODULE_SHORT_NAME FROM MODULES WHERE MODULE_SHORT_NAME IS NOT NULL ORDER BY MODULE_ID ASC
</cfquery>
<cfquery name="GET_HELP_LANGUAGE" datasource="#DSN#">
	SELECT LANGUAGE_SHORT,LANGUAGE_SET FROM SETUP_LANGUAGE ORDER BY LANGUAGE_SET
</cfquery>
<cfset modul_list = valuelist(get_modules.module_short_name)> 
<cfset modul_list = listappend(modul_list,"myhome,objects2")>
<cfset modul_id_list = valuelist(get_modules.module_id)> 
<cfset modul_id_list = listappend(modul_id_list,"53,54")>
<cfparam name="attributes.help" default="">
<cfparam name="attributes.keyword" default="">
<cfparam name="attributes.is_faq" default="">
<cfparam name="attributes.isfaq" default="">
<cfparam name="attributes.is_internet" default="">
<cfparam name="attributes.is_order_by" default="0">
<cfparam name="attributes.module_id" default="">
<cfparam name="attributes.c_module_id" default="">
<cfparam name="attributes.search_key" default="">
<cfparam name="attributes.help_language" default="#session.ep.language#">
<cfinclude template="../query/get_help.cfm">
<cfif isDefined('session.ep.maxrows')>
	<cfparam name="attributes.maxrows" default='#session.ep.maxrows#'>
<cfelseif isDefined('session.pp.maxrows')>
	<cfparam name="attributes.maxrows" default='#session.pp.maxrows#'>
</cfif>
<cfparam name="attributes.totalrecords" default='#get_help.recordcount#'>
<!---- Search END ---->
<cfform name="help_search" action="#request.self#?fuseaction=help.popup_list_helpdesk" method="post">
        <input type="hidden" name="is_form_submitted" id="is_form_submitted" value="1" />            
        <cfif isdefined("session.ep.userid")>
            <cfif isDefined("attributes.help") and Len(attributes.help)>			
                <cfquery name="GET_FACTION" datasource="#DSN#">
                    SELECT 
                        WRK_OBJECTS_ID
                    FROM 
                        WRK_OBJECTS
                    WHERE
                        FUSEACTION = <cfqueryparam cfsqltype="cf_sql_varchar" value="#ListGetAt(attributes.help,2,".")#"> AND
                        MODUL_SHORT_NAME = <cfqueryparam cfsqltype="cf_sql_varchar" value="#ListGetAt(attributes.help,1,".")#">	 
                </cfquery>
            </cfif>
        </cfif>
        <div class="row">
            <div class="col col-12 uniqueRow">                
                <div class="from-group">
                    <div class="col col-12 text-center">
                        <div class="searchGroupContainer">                        
                            <div class="input-group searchInput">
                            <cfoutput>
                                <cfinput type="text" name="keyword" id="keyword" maxlength="100" value="#attributes.keyword#" placeholder="#getLang('main',48)#">
                                <span class="input-group-addon bold btn grey-cararra" onclick="searchDetailContentButton(this);"><i class="icons8-angle-down margin-0"></i></span>
                                <span class="input-group-addon bold btn blue" onclick="ajaxSubmit();"><i class="icons8-search margin-0"></i></span>
                                <span class="input-group-addon btn yellow-gold" onclick="goTo('#request.self#?fuseaction=help.popup_add_help&help=#attributes.help#','626Content-poppage');" ><i class=" icons8-create-new margin-0"></i>&nbsp; <cf_get_lang dictionary_id="35036.Yeni içerik oluştur">.</span>
                            </cfoutput>
                            </div>
                            <div class="searchDetailContent">
                                <div class="row">
                                    <div class="col col-12 col-xs-12">
                                        <div class="form-group">
                                            <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id="33110.Modüller"></label>
                                            <div class="col col-4 col-xs-12">
                                                <select name="c_module_id" id="c_module_id" style="width:125px;">
                                                    <option value=""><cfoutput>#getLang('main',322)#</cfoutput></option>
                                                    <cfoutput query="get_modules">
                                                        <option value="#module_id#" <cfif isdefined('attributes.c_module_id') and attributes.c_module_id eq module_id> selected</cfif>>#module_name_tr#</option>
                                                    </cfoutput>	
                                                    <option value="53" <cfif 53 eq attributes.c_module_id> selected</cfif>> Myhome</option>
                                                    <option value="54" <cfif 54 eq attributes.c_module_id> selected</cfif>> Objects2</option>					   
                                                </select>
                                            </div>
                                            <div class="col col-4 col-xs-12">
                                                <select name="is_faq" id="is_faq" style="width:55px;">
                                                    <option value=""> Tümü</option>
                                                    <option value="0" <cfif 0 eq attributes.is_faq> selected</cfif>> <cf_get_lang dictionary_id="29954.Genel"></option>
                                                    <option value="1" <cfif 1 eq attributes.is_faq> selected</cfif>> <cf_get_lang dictionary_id="46926.SSS"></option>					   
                                                </select>
                                            </div>
                                        </div>
                                        <div class="form-group">
                                            <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id="58996.Dil"></label>
                                            <div class="col col-8 col-xs-12">
                                                <select name="help_language" id="help_language" style="width:75px;">
                                                    <option value=""><cfoutput>#getLang('main',322)#</cfoutput></option>
                                                    <cfoutput query="get_help_language">
                                                        <option value="#language_short#" <cfif get_help_language.language_short eq attributes.help_language>selected</cfif>>#language_set#</option>
                                                    </cfoutput>
                                                </select>
                                            </div>
                                        </div>
                                        <div class="form-group">
                                            <label class="col col-4 col-xs-12">internet</label>
                                            <div class="col col-8 col-xs-12">
                                                <select name="is_internet" id="is_internet">
                                                    <option value=""><cfoutput>#getLang('main',322)#</cfoutput></option>
                                                    <option value="1" <cfif attributes.is_internet eq 1>selected</cfif>><cf_get_lang no ='11.Yayınlananlar'></option>
                                                    <option value="0" <cfif attributes.is_internet eq 0>selected</cfif>><cf_get_lang no ='12.Yayınlanmayanlar'></option>
                                                </select>
                                            </div>
                                        </div>
                                        <div class="form-group">
                                            <label class="col col-4 col-xs-12">Sıralama</label>
                                            <div class="col col-8 col-xs-12">
                                                <select name="is_order_by" id="is_order_by" style="width:165px;">
                                                    <option value="0" <cfif 0 eq attributes.is_order_by> selected</cfif>> <cf_get_lang dictionary_id="49203.Konu Başlığına Göre Alfabetik"></option>
                                                    <option value="1" <cfif 1 eq attributes.is_order_by> selected</cfif>> <cf_get_lang dictionary_id="38328.Güncellemeye Göre Azalan"></option>
                                                </select>                                    
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
</cfform>

    <cfif Len(get_help.record_id) and get_help.record_member eq 'e'>
        <cfquery name="GET_EMPLOYEE" datasource="#DSN#">
            SELECT EMPLOYEE_NAME + ' ' + EMPLOYEE_SURNAME AS MEMBER_NAME, EMPLOYEE_ID FROM EMPLOYEES WHERE EMPLOYEE_ID IN (#get_help.record_id#) ORDER BY EMPLOYEE_ID
        </cfquery> 
    <cfelseif len(get_help.get_helprecord_id) and get_help.record_member eq 'p'>
        <cfquery name="GET_PARTNER" datasource="#DSN#">
            SELECT EMPLOYEE_NAME + ' ' + EMPLOYEE_SURNAME AS MEMBER_NAME, EMPLOYEE_ID FROM EMPLOYEES WHERE EMPLOYEE_ID IN (#get_help.get_helprecord_idt#) ORDER BY EMPLOYEE_ID
        </cfquery> 
    </cfif> 
	<div class="row margin-bottom-20">
		<div class="col col-12 padding-top-20">
			<cfoutput>
                <ul class="standartList viewHelp padding-0">
                    <li>
                        <p class="font-blue font-lg">#get_help.help_head#</p>
                        <p class="font-sm thin ">#get_help.help_topic#</p>
                        <p class="font-green-jungle font-xs">
                            #dateformat(get_help.record_date,dateformat_style)# -
                        <cfif Len(get_help.record_id) and get_help.record_member eq 'e'>
                            #get_employee.member_name#
                        <cfelseif len(get_help.get_helprecord_id) and get_help.record_member eq 'p'>
                            #get_partner.member_name#
                        </cfif> 
                        </p>
                        <p class="font-xs thin padding-top-10"><span class="font-blue"><cf_get_lang dictionary_id="33573.İlişkili Sayfa"> :</span>#employee_domain##request.self#?fuseaction=#get_help.help_circuit#.#get_help.help_fuseaction#<p>
                    </li>
                <ul>			         
			</cfoutput> 
		</div>
	</div>
	<cfif get_other_helps.RecordCount neq 0>
		<div class="row"><!--- İlişkili Konular --->
			<div class="col col-12">
				<p class="font-sm helpPageHead"><cf_get_lang no="7.İlişkili Konular"></p>			
				<ul class="standartList padding-0">                                       
					<cfoutput query="get_other_helps">                
						<li class="padding-left-10">
                            <p class="font-blue font-md btnPointer" onclick="goTo('#request.self#?fuseaction=help.popup_view_help&help_id=#get_help.help_id#','626Content-poppage');"><i class="catalyst-arrow-right margin-right-5 "></i> #help_head#</p>                                        
                            <p class="font-sm thin padding-left-23 ">#help_head#...</p>    
                        </li>
					</cfoutput>
				</ul>
			</div>
		</div>
	</cfif>
</cfif>
