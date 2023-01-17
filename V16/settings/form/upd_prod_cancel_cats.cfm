<cfquery name="get_return_cat" datasource="#dsn3#">
	SELECT
		*
	FROM
		SETUP_PROD_CANCEL_CATS
	WHERE
		CANCEL_CAT_ID=#URL.ID#
</cfquery>
<table border="0" cellspacing="0" cellpadding="0" width="98%" align="center" height="35">
  <tr>
    <td  class="headbold"><cf_get_lang no='529.Ürün İade Red Kategorileri'></td>
    <td align="right" style="text-align:right;"><a href="<cfoutput>#request.self#</cfoutput>?fuseaction=settings.form_add_prod_cancel_cats"><img src="/images/plus1.gif" border="0" alt="<cf_get_lang_main no='170.Ekle'>"></a></td>
  </tr>
</table>
  <table border="0" cellspacing="1" cellpadding="2" width="98%" class="color-border" align="center">
	<tr class="color-row" valign="">
	  <td width="200"><cfinclude template="../display/list_prod_cancel_cats.cfm">
	  </td>
	  <td>
		<table border="0">
		  <cfform name="return_cat" method="post" action="#request.self#?fuseaction=settings.emptypopup_upd_prod_cancel_cat">
			<input type="Hidden" name="CANCEL_CAT_ID" id="CANCEL_CAT_ID" value="<cfoutput>#URL.ID#</cfoutput>">
			<tr>
			  <td width="100"><cf_get_lang no='20.Kategori Adı'><font color=black>*</font></td>
			  <td>
				<cfsavecontent variable="message"><cf_get_lang_main no='1143.Kategori Adı girmelisiniz'></cfsavecontent>
				<cfinput type="Text" name="returncat" size="60" value="#get_return_cat.CANCEL_CAT#" maxlength="50" required="Yes" message="#message#" style="width:150px;">
			  </td>
			</tr>
			<tr height="35">
			  <td colspan="2" align="right" style="text-align:right;">
				<cf_workcube_buttons is_upd='1' is_delete='0'>
			  </td>
			</tr>
			<tr>
			  <td colspan="3" align="left"><p><br/>
				<cfoutput>
				<cfif len(get_return_cat.record_emp)>
					<cf_get_lang_main no='71.Kayıt'> : #get_emp_info(get_return_cat.record_emp,0,0)# - #dateformat(get_return_cat.record_date,dateformat_style)#
				</cfif><br/>
				<cfif len(get_return_cat.update_emp)>
					<cf_get_lang_main no='291.Son Güncelleme'> : #get_emp_info(get_return_cat.update_emp,0,0)# - #dateformat(get_return_cat.update_date,dateformat_style)#
				</cfif>
				</cfoutput>
			  </td>
			</tr>
		  </cfform>
		</table>
	  </td>
	</tr>
  </table>
