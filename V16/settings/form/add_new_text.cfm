<cfquery name="get_new_item" datasource="#DSN#">
	SELECT * FROM SETUP_LANGUAGE
</cfquery>
<cfparam name="attributes.language" default="tr">
<cfinclude template="../query/get_lang_modules.cfm">  


<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
	<cf_box title="#getLang('','Sözlük',57932)# - #getLang('','Kelime',55052)#" scroll="1" collapsable="1" resize="0" popup_box="#iif(isdefined("attributes.draggable"),1,0)#">
        <cfform name="add_sub_name" action="#request.self#?fuseaction=settings.emptypopup_add_module_new_item_act" method="post">
            <cf_box_elements>
                <div class="col col-12 col-md-12 col-sm-12 col-xs-12" type="column" index="1" sort="true">
                    <div class="form-group col col-3 col-md-3 col-sm-6 col-xs-12">
                        <label class="col col-12 col-md-12 col-sm-12 col-xs-12"><cf_get_lang dictionary_id='62046.Seçildiğinde Upgrade den Etkilenmez'>
                        <input type="checkbox" name="is_special" id="is_special" value="1">
                        </label>
                    </div>
                    <div class="form-group col col-3 col-md-3 col-sm-6 col-xs-12">
                        <label class="col col-12 col-md-12 col-sm-12 col-xs-12"><cf_get_lang dictionary_id='45812.Kuruma Özel Sözlüğe Kaydet'>
                        <input type="checkbox" name="is_corporate" id="is_corporate" value="1"></label>
                    </div>
                </div>
                <div class="col col-6 col-xs-12">
                    <div class="form-group">
                        <label class="col col-4"><cf_get_lang dictionary_id='42178.Modül'></label>
                        <div class="col col-8">
                            <select name="module_name" id="module_name">
                                <option value="main">Main</option>
                                <cfoutput query="get_modules">
                                    <cfif len(module_short_name)>
                                        <option value="#module_short_name#">#module_name_#</option>
                                    </cfif>
                                </cfoutput>
                                <option value="home">Home</option>				
                                <option value="myhome">Myhome</option>
                                <option value="objects2">Objects2</option>									   
                            </select>
                        </div>
                    </div>
                    <cfif DATABASE_TYPE IS "MSSQL">
                        <cfquery name="GET_LANGUAGE_DB" datasource="#DSN#">
                            SELECT * FROM 	sysobjects 
                            WHERE id = object_id(N'[SETUP_LANGUAGE_TR]') and OBJECTPROPERTY(id, N'IsUserTable') = 1
                        </cfquery>
                    <cfelseif DATABASE_TYPE IS "DB2">
                        <cfquery name="GET_LANGUAGE_DB" datasource="#DSN#">
                            SELECT TBNAME FROM SYSIBM.SYSCOLUMNS WHERE TBNAME='SETUP_LANGUAGE_TR'
                        </cfquery>
                    </cfif>
                    <div class="form-group">
                        <label class="col col-4"><cfoutput>#get_new_item.language_set[2]#*</cfoutput></label>
                        <input type="hidden" name="kolon_isimleri" id="kolon_isimleri"  value="<cfoutput>#ucase('eng')#</cfoutput>">
                        <div class="col col-8">
                            <cfsavecontent variable="message"><cfoutput>#get_new_item.language_set[2]#</cfoutput> <cf_get_lang dictionary_id='42707.Kelime Ekle girmelisiniz'></cfsavecontent>
                            <cfinput type="text" required="yes" name="item_name_eng" message="#message#" maxlength="500" value="?">
                        </div>
                    </div>
                    <cfloop from="1" to="#get_new_item.recordcount#" index="i">		   
                        <cfif get_language_db.recordcount>
                            <cfif get_new_item.language_short[i] neq 'eng'>
                                <div class="form-group">
                                    <label class="col col-4"><cfoutput>#get_new_item.language_set[i]#*</cfoutput></label>
                                    <input type="hidden" name="kolon_isimleri" id="kolon_isimleri"  value="<cfoutput>#ucase(get_new_item.language_short[i])#</cfoutput>">
                                    <div class="col col-8">
                                        <cfsavecontent variable="message"><cfoutput>#get_new_item.language_set[i]#</cfoutput><cf_get_lang dictionary_id='42707.Kelime Ekle girmelisiniz'></cfsavecontent>
                                        <cfinput type="text" required="yes" name="item_name_#get_new_item.language_short[i]#" message="#message#" style="width:280px;" maxlength="500" value="?">
                                    </div>
                                </div>
                            </cfif>
                        </cfif>
                    </cfloop>
                </div>
            </cf_box_elements>
            <cf_box_footer>
                <cf_workcube_buttons is_upd='0' add_function="#iif(isdefined("attributes.draggable"),DE("loadPopupBox('add_sub_name' , #attributes.modal_id#)"),DE(""))#">
            </cf_box_footer>
            <!--- <table>
                
                <tr>
                    <td width="70"><cf_get_lang dictionary_id='195.Modül'></td>
                    <td>
                    <select name="module_name" id="module_name" style="width:280px;">
                        <option value="main">Main</option>
                    <cfoutput query="get_modules">
                        <cfif len(module_short_name)>
                        <option value="#module_short_name#">#module_name_#</option>
                        </cfif>
                    </cfoutput>
                        <option value="home">Home</option>				
                        <option value="myhome">Myhome</option>
                        <option value="objects2">Objects2</option>									   
                    </select>
                    </td>
                </tr>
                <cfif DATABASE_TYPE IS "MSSQL">
                    <cfquery name="GET_LANGUAGE_DB" datasource="#DSN#">
                        SELECT * FROM 	sysobjects 
                        WHERE id = object_id(N'[SETUP_LANGUAGE_TR]') and OBJECTPROPERTY(id, N'IsUserTable') = 1
                    </cfquery>
                <cfelseif DATABASE_TYPE IS "DB2">
                    <cfquery name="GET_LANGUAGE_DB" datasource="#DSN#">
                        SELECT TBNAME FROM SYSIBM.SYSCOLUMNS WHERE TBNAME='SETUP_LANGUAGE_TR'
                    </cfquery>
                </cfif>
                <tr>
                    <td>
                        <cfoutput>#get_new_item.language_set[2]#*</cfoutput>
                        <input type="hidden" name="kolon_isimleri" id="kolon_isimleri"  value="<cfoutput>#ucase('eng')#</cfoutput>">
                    </td>
                    <td>
                    <cfsavecontent variable="message"><cfoutput>#get_new_item.language_set[2]#</cfoutput> <cf_get_lang dictionary_id='724.Kelime Ekle girmelisiniz'></cfsavecontent>
                    <cfinput type="text" required="yes" name="item_name_eng" message="#message#" style="width:280px;" maxlength="500"></td>
                </tr>		
                <cfloop from="1" to="#get_new_item.recordcount#" index="i">		   
                    <cfif get_language_db.recordcount>
                        <cfif get_new_item.language_short[i] neq 'eng'>
                            <tr>
                                <td>
                                    <cfoutput>#get_new_item.language_set[i]#*</cfoutput>
                                    <input type="hidden" name="kolon_isimleri" id="kolon_isimleri"  value="<cfoutput>#ucase(get_new_item.language_short[i])#</cfoutput>">
                                </td>
                                <td>
                                <cfsavecontent variable="message"><cfoutput>#get_new_item.language_set[i]#</cfoutput><cf_get_lang dictionary_id='724.Kelime Ekle girmelisiniz'></cfsavecontent>
                                <cfinput type="text" required="yes" name="item_name_#get_new_item.language_short[i]#" message="#message#" style="width:280px;" maxlength="500"></td>
                            </tr>
                        </cfif>
                    </cfif>
                </cfloop>
            </table> --->
        </cfform>
    </cf_box>
</div>