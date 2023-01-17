<cfparam name="attributes.keyword" default="">
<cfparam name="attributes.maxrows" default='#session.ep.maxrows#'>
<cfparam name="attributes.TRAINING_SEC_ID" default="">
<cfquery name="GET_TRAINING_SEC_NAMES" datasource="#DSN#">
	SELECT 
		TRAIN_ID, 
		TRAIN_HEAD,
		TRAINING_CAT.TRAINING_CAT_ID,
		TRAINING_SEC.TRAINING_SEC_ID,
		TRAINING_SEC.SECTION_NAME,
		TRAINING_CAT.TRAINING_CAT
	FROM 
		TRAINING T,
		TRAINING_SEC,
		TRAINING_CAT
	WHERE
		TRAINING_SEC.TRAINING_CAT_ID = TRAINING_CAT.TRAINING_CAT_ID
	AND
		T.TRAINING_SEC_ID = TRAINING_SEC.TRAINING_SEC_ID
		<cfif len(attributes.keyword)>AND TRAIN_HEAD LIKE '%#attributes.keyword#%'</cfif>
		<cfif len(attributes.TRAINING_SEC_ID)>AND T.TRAINING_SEC_ID = #attributes.TRAINING_SEC_ID#</cfif>
	ORDER BY 
		TRAIN_HEAD
</cfquery>
<table width="100%" cellspacing="0" cellpadding="0" height="100%">
	<tr valign="top">
		<td height="35">
		  <table width="98%" border="0" cellspacing="0" cellpadding="0" align="center">
			<tr> 
			  <td class="headbold"><cf_get_lang no='427.Ders İçeriği'></td>
			  <td height="35" valign="bottom" style="text-align:right;"> 
				<table>
				  <cfform method="post" action="#request.self#?fuseaction=training_management.popup_list_training_sec&class_id=#attributes.class_id#">
					<tr> 
					  <td class="label"><cf_get_lang_main no='48.Filtre'>:</td>
					  <td> 
						<cfinput type="text" name="keyword" value="#attributes.keyword#">
					  </td>
					  <td>
						<cfquery name="get_training_sec" datasource="#dsn#">
							SELECT
								*
							FROM
								TRAINING_SEC
							ORDER BY SECTION_NAME
						</cfquery>
						<cfset train_sec=ValueList(get_training_sec.TRAINING_SEC_ID,',')>
					  	<select name="TRAINING_SEC_ID" id="TRAINING_SEC_ID">
							<option value="" <cfif not len(attributes.TRAINING_SEC_ID)>selected</cfif>><cf_get_lang_main no='322.Seçiniz'></option>
							<cfoutput  query="get_training_sec">             
								<option value="#TRAINING_SEC_ID#" <cfif attributes.TRAINING_SEC_ID eq TRAINING_SEC_ID>selected</cfif> >#SECTION_NAME#</option>
							</cfoutput>
						</select>
					  </td>
					  <td> 
						<cfinput type="text" name="maxrows" maxlength="3" size="2" value="#attributes.maxrows#">
					  </td>
					  <td><cf_wrk_search_button></td> 
					</tr>
				  </cfform>
				</table>
			  </td>
			</tr>
		  </table>		
		</td>
	</tr>
  <tr valign="top">
    <td valign="top"> 
      <table cellSpacing="0" cellpadding="0" border="0" width="98%" align="center">
        <tr class="color-border"> 
          <td> 
            <table cellspacing="1" cellpadding="2" width="100%" border="0">
              <tr class="color-header" height="22"> 
				<td class="form-title"><cf_get_lang no='147.Eğitim Konusu'></td>				
				<td class="form-title"><cf_get_lang no='46.Eğitim Kategori'></td>
              </tr>
				<cfparam name="attributes.page" default=1>
				<cfparam name="attributes.maxrows" default='#session.ep.maxrows#'>
				<cfparam name="attributes.totalrecords" default=#GET_TRAINING_SEC_NAMES.recordcount#>
				<cfset attributes.startrow=((attributes.page-1)*attributes.maxrows)+1>					
				<cfif GET_TRAINING_SEC_NAMES.RecordCount>
				  <cfoutput query="GET_TRAINING_SEC_NAMES" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#"> 
					   <tr height="20" onMouseOver="this.className='color-light';" onMouseOut="this.className='color-row';" class="color-row">
						<td> 
							<a href="javascript://" class="tableyazi" onClick="javascript:add_record('#TRAINING_SEC_ID#','#TRAINING_CAT_ID#','#attributes.CLASS_ID#','#TRAIN_ID#');">#TRAIN_HEAD#</a>
						</td>
						<td><cfif listfind(train_sec,TRAINING_SEC_ID,',')>
								#get_training_sec.SECTION_NAME[listfind(train_sec,TRAINING_SEC_ID,',')]#
							</cfif>
						</td>						
					  </tr>
				  </cfoutput> 
              <cfelse>
				  <tr class="color-row" height="20"> 
					<td colspan="2"><cf_get_lang_main no='72.Kayıt Bulunamadı'>!</td>
				  </tr>
              </cfif>
            </table>
          </td>
        </tr>
      </table>
	<cfif attributes.totalrecords gt attributes.maxrows>
      <table width="97%" border="0" cellspacing="0" cellpadding="0" align="center">
        <tr> 
          <td height="35">
		  <cf_pages 
			  page="#attributes.page#" 
			  maxrows="#attributes.maxrows#" 
			  totalrecords="#attributes.totalrecords#" 
			  startrow="#attributes.startrow#" 
			  adres="training_management.popup_list_training_sec&class_id=#attributes.class_id#&keyword=#attributes.keyword#"> 
          </td>
          <!-- sil --><td style="text-align:right;"><cfoutput><cf_get_lang_main no='128.Toplam Kayıt'>:#attributes.totalrecords#&nbsp;-&nbsp;<cf_get_lang_main no='169.Sayfa'>:#attributes.page#/#lastpage#</cfoutput></td><!-- sil -->
        </tr>
      </table>
	</cfif>
    </td>
  </tr>
</table>
<script type="text/javascript">
	function add_record(sec_id,cat_id,clas,train_id)
	{
		windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=training_management.emptypopup_add_sec_to_train&sec_id=' + sec_id + '&cat_id=' + cat_id + '&class_id=' + clas + '&train_id=' + train_id ,'date');
		wrk_opener_reload();
		window.close();
	}
</script> 
