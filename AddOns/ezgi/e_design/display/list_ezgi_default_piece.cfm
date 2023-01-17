<cfset fuseaction_ = ListGetAt(attributes.fuseaction,2,'.')>
<cfparam name="attributes.is_submitted" default="">
<cfparam name="attributes.status" default="1">
<cfparam name="attributes.oby" default="0">
<cfparam name="attributes.keyword" default="">
<cfif isdefined("attributes.is_submitted") and len(attributes.is_submitted)>
	<cfquery name="get_pieces" datasource="#dsn3#">
    	SELECT        
        	*
		FROM            
        	EZGI_DESIGN_PIECE_DEFAULTS
      	WHERE 
        	1=1
            <cfif len(attributes.keyword)>
            	AND 
                (
                	PIECE_DEFAULT_NAME LIKE '%#attributes.keyword#%' OR
                    PIECE_DEFAULT_CODE LIKE '%#attributes.keyword#%'
                )
            </cfif>
            <cfif attributes.status eq 2>
            	AND STATUS = 1
            <cfelseif attributes.status eq 3>
            	AND STATUS = 0
            </cfif>
      	ORDER BY
        	<cfif attributes.oby eq 1>
        		PIECE_DEFAULT_CODE
            <cfelseif attributes.oby eq 2>
            	PIECE_DEFAULT_NAME
            <cfelse>
            	PIECE_DEFAULT_ID desc
            </cfif>
    </cfquery>
	<cfparam name="attributes.totalrecords" default='#get_pieces.recordcount#'>
<cfelse>
	<cfset get_pieces.recordcount = 0>
	<cfparam name="attributes.totalrecords" default='0'>
</cfif>
<cfparam name="attributes.page" default=1>
<cfparam name="attributes.maxrows" default='#session.ep.maxrows#'>
<cfset attributes.startrow=((attributes.page-1)*attributes.maxrows)+1>
<cfscript>wrkUrlStrings('url_str','status','production_stage','is_submitted','keyword');</cfscript>
<cfset url_str = ''>
<cfif isDefined('attributes.oby') and len(attributes.oby)>
	<cfset url_str = "#url_str#&oby=#attributes.oby#">
</cfif>
<cfset url_str = ''>
<cfif isDefined('attributes.keyword') and len(attributes.keyword)>
	<cfset url_str = "#url_str#&keyword=#attributes.keyword#">
</cfif>
<cfif isDefined('attributes.is_submitted') and len(attributes.is_submitted)>
	<cfset url_str = "#url_str#&is_submitted=#attributes.is_submitted#">
</cfif>
<cfif isDefined('attributes.status') and len(attributes.status)>
	<cfset url_str = "#url_str#&status=#attributes.status#">
</cfif>
<cfsavecontent variable="header_">
	<cfoutput>#getLang('settings',1133)# #getLang('main',2848)# #getLang('product',92)#</cfoutput>
</cfsavecontent>
<cfform name="search_list" action="#request.self#?fuseaction=prod.list_ezgi_default_piece" method="post">
    <input type="hidden" name="is_submitted" id="is_submitted" value="1">
    <input type="hidden" name="is_excel" id="is_excel" value="0">
    <cf_big_list_search title="#header_#">
        <cf_big_list_search_area>
            <cf_object_main_table>
                <cf_object_table column_width_list="60,80">
                    <cfsavecontent variable="header_"><cf_get_lang_main no='48.Filtre'></cfsavecontent>
                    <cf_object_tr id="form_ul_keyword" title="#header_#">
                        <cf_object_td type="text"><cf_get_lang_main no='48.Filtre'></cf_object_td>
                        <cf_object_td>
                     		<cfsavecontent variable="key_title"><cf_get_lang_main no='2912.Default Adı ve Kodu Alanlarında Arama Yapabilirsiniz'>!</cfsavecontent>
                            <cfinput type="text" name="keyword" id="keyword" title="#key_title#" value="#attributes.keyword#" style="width:80px;">
                        </cf_object_td>
                    </cf_object_tr>
                </cf_object_table>
                <cf_object_table column_width_list="100">
                    <cf_object_tr id="form_ul_oby" title="#getLang('main',1512)#">
                        <cf_object_td>
                            <select name="oby" id="oby" style="width:100px;">
                            	<option value="0" <cfif attributes.oby eq 0>selected</cfif>><cf_get_lang_main no ='1512.Sıralama'></option>
                                <option value="1" <cfif attributes.oby eq 1>selected</cfif>><cf_get_lang_main no ='1173.Kod'></option>
                                <option value="2" <cfif attributes.oby eq 2>selected</cfif>><cf_get_lang_main no ='485.Adı'></option>
                            </select>
                        </cf_object_td>
                    </cf_object_tr>
                </cf_object_table>
                <cf_object_table column_width_list="65">
                    <cf_object_tr id="form_ul_status" title="#getLang('main',344)#">
                        <cf_object_td>
                            <select name="status" id="status" style="width:65px;">
                                <option value="1" <cfif attributes.status eq 1>selected</cfif>><cf_get_lang_main no='296.Tümü'></option>
                                <option value="2" <cfif attributes.status eq 2>selected</cfif>><cf_get_lang_main no='81.Aktif'></option>
                                <option value="3" <cfif attributes.status eq 3>selected</cfif>><cf_get_lang_main no='82.Pasif'></option>
                            </select>
                        </cf_object_td>
                    </cf_object_tr>
                </cf_object_table>
                <cf_object_table column_width_list="80">
                    <cf_object_tr id="">
                        <cf_object_td>
                            <cfsavecontent variable="message"><cf_get_lang_main no='125.Sayi_Hatasi_Mesaj'></cfsavecontent>
                            <cfinput type="text" name="maxrows" value="#attributes.maxrows#" required="yes" validate="integer" range="1,999" message="#message#" maxlength="3" style="width:25px;">
                            <cf_wrk_search_button>
                            <cf_workcube_file_action pdf='1' mail='1' doc='1' print='1'>
                        </cf_object_td>
                    </cf_object_tr>
                </cf_object_table>
            </cf_object_main_table>
        </cf_big_list_search_area>
    </cf_big_list_search>
</cfform>
<cf_big_list>
    <thead>
        <tr>
            <th style="width:25px;"><cf_get_lang_main no='1165.Sıra'></th>
            <th style="width:60px;"><cf_get_lang_main no='2848.Parça'> ID</th>
            <th style="width:90px;"><cfoutput>#getLang('main',2848)# #getLang('objects',256)#</cfoutput></th>
           	<th><cfoutput>#getLang('settings',1133)# #getLang('main',2848)# #getLang('main',485)#</cfoutput></th>
      		<th style="width:120px;"><cf_get_lang_main no='487.Kaydeden'></th>
            <th style="width:70px;"><cf_get_lang_main no='215.Kayıt Tarihi'></th>
            <!-- sil -->
            <th style="text-align:center;width:10px;">
             	<cfoutput>
                   	<a href="#request.self#?fuseaction=prod.add_ezgi_default_piece">
                		<img src="/images/plus_list.gif" style="text-align:center" title="<cf_get_lang_main no='2830.Default Parça Ekle'>">
               		</a>
              	</cfoutput>
            </th>
            <!-- sil -->
        </tr>
    </thead>
    <tbody>
        <cfif len(attributes.is_submitted)>
            <cfif get_pieces.recordcount>
                    <cfoutput query="get_pieces" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">
                        <tr>
                        	<td style="text-align:right">#currentrow#</td>
                            <td style="text-align:center">#PIECE_DEFAULT_ID#</td>
                            <td style="text-align:center">
                            	<a href="#request.self#?fuseaction=prod.upd_ezgi_default_piece&piece_id=#PIECE_DEFAULT_ID#" class="tableyazi">
                					#PIECE_DEFAULT_CODE#
               					</a>
                            </td>
                            <td>#PIECE_DEFAULT_NAME#</td>
                            <td>#get_emp_info(RECORD_EMP,0,0)# </td>
                            <td style="text-align:center">#DateFormat(RECORD_DATE,'DD/MM/YYYY')#</td>
                            <!-- sil -->
                            <td style="text-align:center;">
                            	<a href="#request.self#?fuseaction=prod.upd_ezgi_default_piece&piece_id=#PIECE_DEFAULT_ID#">
                					<img src="/images/update_list.gif" title="#getLang('main',52)#">
               					</a>
                            </td>
                            <!-- sil -->
                        </tr>
                    </cfoutput>
            </tbody>
            <!-- sil -->
        	<tfoot>
                <tr height="40" class="nohover">
                    <td colspan="15" align="right" style="text-align:right;">
                        <!---<input type="button" value="Buton" onclick="demand_convert_to_production(3);">--->
                    </td>
                </tr>
                <!-- sil -->
            </tfoot>
    		<tbody>
        </form>
        <cfelse>
            <tr>
                <td colspan="15"><cf_get_lang_main no='72.Kayıt Bulunamadı'>!</td>
            </tr>
        </cfif>
    <cfelse>
        <tr>
            <td colspan="15"><cf_get_lang_main no ='289.Filtre Ediniz'> !</td>
        </tr>
    </cfif>
    </tbody>
</cf_big_list>
<cfif attributes.totalrecords gt attributes.maxrows>
<!-- sil -->
	<table width="98%" align="center" cellpadding="0" cellspacing="0" border="0" height="35">
		<tr>
			<td>
				<cf_pages 
					page="#attributes.page#" 
					maxrows="#attributes.maxrows#" 
					totalrecords="#get_pieces.recordcount#" 
					startrow="#attributes.startrow#" 
					adres="prod.#fuseaction_##url_str#">
			</td>
			<td align="right" style="text-align:right;"><cfoutput><cf_get_lang_main no='128.Toplam Kayıt'>:#attributes.totalrecords# &nbsp;-&nbsp;<cf_get_lang_main no='169.Sayfa'>:#attributes.page#/#lastpage#</cfoutput></td>
		</tr>
	</table>
<!-- sil -->
</cfif>
<script type="text/javascript">
	document.getElementById('keyword').focus();
</script>