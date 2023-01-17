<!--- Sayfa kendi icerisinde hem popup hem ajax ile cagrilmaktadir, dikkate aliniz FBS 20120308 --->
<cfsetting showdebugoutput="no">
<!--- <cfif isDefined("attributes.help") and len(attributes.help)> --->
<cfif fusebox.fuseaction contains 'ajax'>
<cfif isDefined("attributes.help_id") and Len(attributes.help_id)>
	<cfparam name="attributes.relation_help_id" default="#attributes.help_id#">
	<cfinclude template="../query/get_help.cfm">
</cfif>
</cfif>
<cfquery name="get_help_language" datasource="#dsn#">
	SELECT LANGUAGE_SHORT,LANGUAGE_SET FROM SETUP_LANGUAGE <cfif isDefined("attributes.help_id")>WHERE LANGUAGE_SHORT NOT IN (#ListQualify(ValueList(get_help.help_language),"'",",")#)</cfif> ORDER BY LANGUAGE_SET
</cfquery>
<cfif isDefined("attributes.help") and ListLen(attributes.help) eq 2>
	<cfset circuit_ = listgetat(attributes.help,1,'.')>
	<cfset fuseaction_ = listgetat(attributes.help,2,'.')>
<cfelse>
	<cfset circuit_ = "">
	<cfset fuseaction_ = "">	
</cfif>

<cfparam name="attributes.help_language" default="#session.ep.language#">
<cfform name="add_help" action="#request.self#?fuseaction=help.emptypopup_add_help" method="post">
    <cfoutput>
    <input type="hidden" name="circuit_" id="circuit_" value="#circuit_#">
    <input type="hidden" name="fuseaction_" id="fuseaction_" value="#fuseaction_#">
    <input type="hidden" name="relation_help_id" id="relation_help_id" value="<cfif isDefined("attributes.help_id") and Len(attributes.help_id)>#attributes.help_id#</cfif>">
    <div class="row">
        <div class="col col-12">
            <h4 class="workdevPageHead">#getLang('help',3)#</h4>
        </div>
    </div>
    <div class="row">
        <div class="col col-12">
            <div class="row">
                <div class="col col-12 form-inline">
                    <div class="form-group">
                        <div class="input-group">
                            <select name="help_language" id="help_language" style="width:90px;">
                                <cfloop query="get_help_language">
                                    <option value="#language_short#" <cfif get_help_language.language_short is attributes.help_language>selected</cfif>>#language_set#</option>
                                </cfloop>
                            </select>
                        </div>
                    </div>
                    <div class="form-group">
                        <div class="input-group">
                            <cfinput type="text" name="modul_name" id="modul_name" value="#circuit_#" placeholder="#getLang('main',169)#">
                        </div>
                    </div>
                    <div class="form-group">
                        <div class="input-group">
                            <cfinput type="text" name="faction" id="faction" value="#fuseaction_#" style="width:150px;">
                            <input type="hidden" name="faction_id" id="faction_id" value="">
                            <cfif not listfindnocase(denied_pages,'settings.popup_faction_list')>	
                                <span class="input-group-addon icon-ellipsis btnPointer" onClick="windowopen('<cfoutput>#request.self#?fuseaction=settings.popup_faction_list&field_faction_id=add_help.faction_id&field_faction=add_help.faction&field_modul=add_help.modul_name&module_name=#circuit_#</cfoutput>','medium');"></span>
                            </cfif>
                        </div>
                    </div>
                    <cfif get_module_power_user(45)>
                        <div class="form-group">
                            <label>
                                <input type="checkbox" name="is_internet" id="is_internet" value="1"><cf_get_lang_main no='1682.Yayın'>
                            </label>
                        </div>
                    </cfif>
                    <div class="form-group">
                        <label><input type="checkbox" name="is_faq" id="is_faq" value="1"><cf_get_lang no='2.SSS'></label>
                    </div>
                </div>
            </div>
            <div class="form-group">
                <div class="col col-12 padding-left-5">
                    <cfsavecontent variable="message"><cf_get_lang no='8.Yardım Başlığı Girmediniz !'></cfsavecontent>
                    <cfinput type="text" name="help_head" id="help_head" value="" required="Yes" message="#message#" maxlength="250" placeholder="#getLang('main',68)#">
                </div>
            </div>
            <cfif isDefined('attributes.chid') and len(attributes.chid)>
                <cfquery name="GET_HELP" datasource="#DSN#">
                    SELECT SOLUTION_DETAIL FROM CUSTOMER_HELP WHERE CUS_HELP_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.chid#"> ORDER BY CUS_HELP_ID DESC
                </cfquery>
                <cfmodule
                    template="/fckeditor/fckeditor.cfm"
                    toolbarSet="WRKContent"
                    basePath="/fckeditor/"
                    instanceName="HELP_TOPIC"
                    valign="top"
                    value="#get_help.solution_detail#"
                    width="735"
                    height="360">
            <cfelse>
                    <cfmodule
                    template="/fckeditor/fckeditor.cfm"
                    toolbarSet="WRKContent"
                    basePath="/fckeditor/"
                    instanceName="HELP_TOPIC"
                    valign="top"
                    value=""
                    width="735"
                    height="360">                   
            
            </cfif>          
        </div>
    </div>
    <div class="row formContentFooter">
        <div class="col col-12 text-right">
            <cf_workcube_buttons type_format="1" is_upd='0' add_function='OnFormSubmit()'>
        </div>
    </div>
    </cfoutput>
</cfform>

	<script language="javascript">
		function OnFormSubmit()
		{
			if(document.getElementById("help_language").value == "")
			{
				alert("<cf_get_lang_main no='782.Zorunlu Alan'>: <cf_get_lang_main no='1584.Dil'>");
				return false;
			}
			if(document.getElementById("modul_name").value == "" || document.getElementById("faction").value == "")
			{
				alert("<cf_get_lang dictionary_id='43438.Sayfa Seçmelisiniz'>!");
				return false;
			}
			return true;
		}
	</script>
<!--- <cfelse>
	<table width="100%" cellpadding="2" cellspacing="1" border="0">
		<tr class="color-row">
			<td valign="top"><cf_get_lang no='6.Destek Eklenecek Bölüm ve Fonksiyon Tanımlı Değil !'></td>
		</tr>
	</table>
</cfif> --->
