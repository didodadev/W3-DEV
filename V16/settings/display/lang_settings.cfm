<cfparam name="attributes.language" default="">
<cfparam name="attributes.module_name" default="">

<script type="text/javascript">
	function add_new_element(){
		windowopen('<cfoutput>#request.self#?fuseaction=settings.popup_add_module_item&strmodule=#attributes.module_name#</cfoutput>','small');
	}
</script>
<!--- upd_lang_settings
popup_add_module_item
 --->


<cfquery name="GET_MODULES" datasource="#DSN#">
	SELECT
		<cfif attributes.language neq "tr">
			MODULE_NAME AS MODULE_NAME_,
		<cfelse>
			MODULE_NAME_TR AS MODULE_NAME_,
		</cfif>
		MODULE_SHORT_NAME
	 FROM	
		MODULES
	ORDER BY
		MODULE_SHORT_NAME 
</cfquery>
<cfquery   name="get_lang" datasource="#DSN#">
	SELECT 
			* 
	FROM 
		SETUP_LANGUAGE 
	WHERE 
		( LANGUAGE_SHORT NOT LIKE 'TR%' 
	AND 
		LANGUAGE_SHORT	NOT LIKE 'tr%') 
	AND 
		(LANGUAGE_SHORT NOT LIKE 'ENG%' 
	AND 
		LANGUAGE_SHORT NOT LIKE 'eng%')
</cfquery>

<table width="98%" height="35" border="0" align="center" cellpadding="0" cellspacing="0">
  <tr>
    <td class="headbold"><cf_get_lang no='51.Sistem Dil Ayarları'></td>
    <!-- sil -->
    <td align="right" style="text-align:right;">
      <table width="250">
        <cfform action="#request.self#?fuseaction=settings.lang_settings" method="post">
          <tr>
            <td align="right"><cf_get_lang_main no='48.Filtre'>:</td>
            <td align="right">
               <select NAME="language" id="language">
                <cfoutput query="get_lang">
                  <option VALUE="#LANGUAGE_SHORT#" <cfif attributes.language eq LANGUAGE_SHORT>Selected</cfif>> #LANGUAGE_SET#
				  <cfif attributes.language eq LANGUAGE_SHORT>
	                  <cfset attributes.lang_name2=LANGUAGE_SET>
				  </cfif>
                  </option>
                </cfoutput>
              </select>
            </td>
            <td align="right">
              <select NAME="MODULE_NAME" id="MODULE_NAME">
                <option value=""><cf_get_lang_main no='322.Seçiniz'></option>
                <option value="home" <cfif attributes.module_name eq  "home" >Selected</cfif>> Home</option>				
                <option value="public" <cfif attributes.module_name eq  "public" >Selected</cfif>> Public</option>								
                <option value="myhome" <cfif attributes.module_name eq  "myhome" >Selected</cfif>>
					<cfif attributes.language eq "tr"><cf_get_lang_main no ='2157.Genel'><cfelse> Myhome</cfif>
                </option>
			   <option value="main" <cfif attributes.module_name eq  "main" >Selected</cfif>>
					<cfif attributes.language eq "tr"><cf_get_lang no ='778.Temel'><cfelse> Main</cfif>
                </option>
                <cfoutput query="GET_MODULES">
                  <option VALUE="#MODULE_SHORT_NAME#" <cfif attributes.module_name eq MODULE_SHORT_NAME>Selected</cfif> >#MODULE_NAME_#</option>
                </cfoutput>
              </select>
            </td>
            <td align="right"><cf_wrk_search_button></td>
			<td align="right">
				<cfif not listfindnocase(denied_pages,'settings.popup_list_lang_settings')>
					<a  href="javascript://" onClick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=settings.popup_list_lang_settings','medium');"><img src="/images/abc.gif" border="0" alt="Search Word"></a>				  
            	</cfif>
			</td>
          </tr>
        </cfform>
      </table>
    </td>
    <!-- sil -->
  </tr>
</table>
<cfif len(attributes.module_name)>
	<cfform action="#request.self#?fuseaction=settings.upd_lang_settings" method="post" name="add_lang_set">
			<cfquery name="get_lang_set_1" datasource="#DSN#">
				SELECT
					*
				FROM
					SETUP_LANGUAGE_TR
				WHERE
					MODULE_ID='#attributes.module_name#'	
			</cfquery>	
			<table width="98%" height="35" border="0" align="center" cellpadding="0" cellspacing="0">
				<tr class="color-row">
					<td  colspan="2" align="right" style="text-align:right;">
					  <a href="javascript://" onClick="add_new_element();"> <img border="0"  src="/images/plus_square.gif" alt="<cf_get_lang_main no='1729.Kelime Ekle'>"> </a>
					  <input type="hidden" name="module_name" id="module_name" value="<cfoutput>#attributes.module_name#</cfoutput>">
  					  <input type="hidden" name="max_item" id="max_item" value="<cfoutput>#get_lang_set_1.recordcount#</cfoutput>">
					</td>
				</tr>
				<cfoutput query="get_lang_set_1">
				<tr class="color-row">
					<td width="%3"></td>
					<td><input name="ITEM_#currentrow#" id="ITEM_#currentrow#"  type="text" value="#ITEM#" style="width:250;"></td>
				</tr>
				</cfoutput>#ITEM_ID#
				<tr class="color-row">
					<td colspan="2">
					 <cf_workcube_buttons 
						  is_upd='0'
						  is_cancel='0'>
					</td>
				</tr>
			</table>	
	</cfform>
  </cfif>

