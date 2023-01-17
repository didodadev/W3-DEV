<cfset url_str = 'training_management.popup_list_related_trainings'>
<cfif isDefined('attributes.training_id') and len(attributes.training_id)>
	<cfset url_str = url_str&'&training_id='&attributes.training_id>
</cfif>

<!--- get_content.cfm --->
<cfquery name="GET_TRAIN" datasource="#dsn#">
	SELECT
		TRAIN_ID,
		TRAIN_HEAD,
		RECORD_DATE,
		RECORD_EMP
	FROM
		TRAINING
	WHERE
		TRAIN_ID IS NOT NULL
		<cfif isDefined("attributes.training_id")>
			AND 
			TRAIN_ID != #attributes.training_id# 
			AND 
			TRAIN_ID NOT IN (SELECT RELATED_TRAINING_ID FROM TRAINING_RELATED WHERE TRAINING_ID = #attributes.training_id# )
		</cfif>
		<cfif isDefined('attributes.keyword') and len(attributes.keyword)>
			AND 
			(
			TRAIN_HEAD LIKE '%#attributes.keyword#%' 
			OR 
			TRAIN_OBJECTIVE LIKE '%#attributes.keyword#%'
			)
		</cfif>
	 ORDER BY TRAIN_HEAD
</cfquery>

<cfparam name="attributes.keyword" default="">
<cfparam name="attributes.page" default=1>
<cfparam name="attributes.maxrows" default='#session.ep.maxrows#'>
<cfparam name="attributes.totalrecords" default=#GET_TRAIN.recordcount#>
<cfset attributes.startrow=((attributes.page-1)*attributes.maxrows)+1>
<table cellpadding="0" cellspacing="0" border="0" width="98%" height="35" align="center">
  <cfform name="content_search" method="post" action="#request.self#?fuseaction=#url_str#">
    <tr>
      <td class="headbold"><cf_get_lang no='416.İlişkili Konu Ekle'></td>
      <td style="text-align:right;">
        <table>
          <tr>
            <td><cf_get_lang_main no='48.Filtre'>:</td>
			<td><cfinput type="text" name="keyword" style="width:100px;" value="#attributes.keyword#" maxlength="255"></td>
            <td>
              <cfsavecontent variable="message"><cf_get_lang_main no='125.Sayi_Hatasi_Mesaj'></cfsavecontent>
              <cfinput type="text" name="maxrows" value="#attributes.maxrows#" required="yes" validate="integer" range="1,999" message="#message#" maxlength="3" style="width:25px;">
            </td>
            <td style="text-align:right;">
              <cf_wrk_search_button>
            </td>
            <td> 
          </tr>
        </table>
      </td>
    </tr>
  </cfform>
</table>
<table cellpadding="0" cellspacing="0" border="0" width="98%" align="center">
  <tr>
    <td class="color-border" valign="top">
      <table width="100%" cellpadding="2" cellspacing="1" border="0">
        <tr class="color-header" height="22">
          <td class="form-title"><cf_get_lang_main no='68.Başlık'></td>
          <td class="form-title" width="125"><cf_get_lang_main no='71.Kayıt'></td>
          <td class="form-title" width="65"><cf_get_lang_main no='215.Kayıt Tarihi'></td>
        </tr>
        <cfif GET_TRAIN.recordcount>
          <cfoutput query="GET_TRAIN" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">
            <tr height="20" onMouseOver="this.className='color-light';" onMouseOut="this.className='color-row';" class="color-row">
              <td><a href="#request.self#?fuseaction=training_management.emtypopup_add_related_train&TRAINING_ID=#attributes.TRAINING_ID#&related_id=#train_id#" class="tableyazi">#train_head#</a> </td>
              <td>#get_emp_info(record_emp,0,1)#</td>
              <td>#dateformat(record_date,dateformat_style)#</td>
            </tr>
          </cfoutput>
          <cfelse>
          <tr class="color-row" height="20">
            <td colspan="4"><cf_get_lang_main no='72.Kayıt Bulunamadı'>!</td>
          </tr>
        </cfif>
      </table>
    </td>
  </tr>
</table>
<cfif attributes.maxrows lt attributes.totalrecords>
  <table cellpadding="0" cellspacing="0" border="0" align="center" width="98%" height="35">
    <tr>
      <td>
        <cfif isDefined('attributes.keyword') and len(attributes.keyword)>
          <cfset url_str = "#url_str#&keyword=#attributes.keyword#">
        </cfif>
        <cf_pages page="#attributes.page#"
		  maxrows="#attributes.maxrows#"
		  totalrecords="#attributes.totalrecords#"
		  startrow="#attributes.startrow#"
		  adres="#url_str#"> </td>
      <!-- sil --><td style="text-align:right;"> 
	  <cf_get_lang_main no='128.Toplam Kayıt'>:<cfoutput>#attributes.totalrecords#</cfoutput>&nbsp;-&nbsp;<cf_get_lang_main no='169.Sayfa'>:<cfoutput>#attributes.page#/#lastpage#</cfoutput> </td><!-- sil -->
    </tr>
  </table>
</cfif>

