<cfquery name="get_class" datasource="#dsn#">
	SELECT
		*
	FROM
		TRAINING_CLASS
	WHERE
		CLASS_ID IS NOT NULL AND
		START_DATE > #datediff('d',7,now())# AND
		START_DATE < #DATEADD('d',7,now())#
</cfquery>
<cfquery name="GET_TRAINING_CAT_NAME" datasource="#dsn#">
	SELECT * FROM TRAINING_CAT WHERE TRAINING_CAT_ID = #get_class.training_cat_id#
</cfquery>
<cfquery name="GET_SEC_NAME" datasource="#dsn#">
	SELECT * FROM TRAINING_SEC WHERE TRAINING_SEC_ID = #get_class.TRAINING_SEC_ID#
</cfquery>

<cfquery name="GET_SEC_NAME_ATTENDER" datasource="#dsn#">
	SELECT * FROM TRAINING_CLASS_ATTENDER WHERE CLASS_ID = #get_class.CLASS_ID#
</cfquery>
<table cellspacing="1" cellpadding="2" border="0" height="100%" width="100%" class="color-border">
  <tr class="color-list">
    	<td valign="middle" class="headbold" height="35"><cf_get_lang dictionary_id="57419.Eğitim"></td>
        </tr>
        <tr class="color-row" valign="top">
          <td>
			  <table>
				<cfform name="training_management_form" method="post" action="">
				  <cfoutput>
				  <tr>
					<td width="180" class="txtboldblue"><cf_get_lang dictionary_id="46072.Eğitim Adı">:</td>
					<td>#get_class.class_name#</td>
				  </tr>
				  <tr>
					<td width="180" class="txtboldblue"><cf_get_lang dictionary_id="57480.Konu">:</td>
					<td><cf_get_lang dictionary_id="57419.Eğitim"></td>
				  </tr>
				  <tr>
					<td width="180" class="txtboldblue"><cf_get_lang dictionary_id="33081.Amaç">:</td>
					<td>#get_class.CLASS_TARGET#</td>
				  </tr>
				  <tr>
					<td width="180" class="txtboldblue"><cf_get_lang dictionary_id="57486.Kategori">/<cf_get_lang dictionary_id="57995.Bölüm">:</td>
					<td>#GET_TRAINING_CAT_NAME.TRAINING_CAT#&nbsp;/&nbsp;#GET_SEC_NAME.SECTION_NAME#</td>
				  </tr>
				  <tr>
					<td width="180" class="txtboldblue" nowrap><cf_get_lang dictionary_id="33078.Max Katılımcı Boş Kontenjyan">:</td>
					<td>#get_class.MAX_PARTICIPATION#&nbsp;/&nbsp;#get_class.MAX_PARTICIPATION - GET_SEC_NAME_ATTENDER.recordcount#</td>
				  </tr>
				  <tr>
					<td></td>
					<td colspan="2"><cfinput type="button" value="Katılmak İstiyorum" name=""></td>
				  </tr>
				  <tr>
					<td class="txtboldblue"><a href="javascript://" onClick="display_detay();"><cf_get_lang dictionary_id="33077.Detaylar"> >></a></td>
					<td></td>
				  </tr>
				</cfoutput>
				</cfform>
			  </table>
    </td>
  </tr>
</table>
<script type="text/javascript">
	function display_detay()
		{
			alert('wes');
		}
</script> 
