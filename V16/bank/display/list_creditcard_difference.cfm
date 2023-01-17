<!--- <cfparam name="attributes.keyword" default="">
<cfparam name="attributes.date_format" default="1">
<cfparam name="attributes.date_1" default="">
<cfparam name="attributes.date_2" default="">
<cfparam name="attributes.branch_ids" default="">
<cfparam name="attributes.credit_payment_type_id" default="">
<cfif len(attributes.date_1)>
  <cf_date tarih='attributes.date_1'>
</cfif>
<cfif len(attributes.date_2)>
  <cf_date tarih='attributes.date_2'>
</cfif>
<cfquery name="GET_BRANCH" datasource="#DSN#">
	SELECT BRANCH_ID, BRANCH_NAME FROM BRANCH ORDER BY BRANCH_NAME
</cfquery>
<cfquery name="GET_CREDIT_PAYMENTS" datasource="#DSN3#">
	SELECT CARD_NO, PAYMENT_TYPE_ID FROM CREDITCARD_PAYMENT_TYPE
</cfquery>
<cfquery name="GET_STORE_REPORT" datasource="#DSN2#">
	SELECT STORE_REPORT_ID FROM STORE_REPORT
</cfquery>
<cfparam name="attributes.page" default=1>
<cfparam name="attributes.maxrows" default='#session.ep.maxrows#'>
<cfparam name="attributes.totalrecords" default=1>
<cfset attributes.startrow = ((attributes.page-1)*attributes.maxrows)+1>
<cfset url_str = "">
<cfif isdefined("attributes.keyword") and len(attributes.keyword)>
  <cfset url_str = "#url_str#&keyword=#attributes.keyword#">
</cfif>
<cfif isdefined("attributes.date_format") and len(attributes.date_format)>
  <cfset url_str = "#url_str#&date_format=#attributes.date_format#">
</cfif>
<cfif isdefined("attributes.date_1") and len(attributes.date_1)>
  <cfset url_str = "#url_str#&date_1=#attributes.date_1#">
</cfif>
<cfif isdefined("attributes.date_2") and len(attributes.date_2)>
  <cfset url_str = "#url_str#&date_2=#attributes.date_2#">
</cfif>
<cfif isdefined("attributes.branch_ids") and len(attributes.branch_ids)>
  <cfset url_str = "#url_str#&branch_ids=#attributes.branch_ids#">
</cfif>
<cfif isdefined("attributes.credit_payment_type_id") and len(attributes.credit_payment_type_id)>
  <cfset url_str = "#url_str#&credit_payment_type_id=#attributes.credit_payment_type_id#">
</cfif>
<table width="98%" border="0" cellspacing="0" cellpadding="0" align="center">
  <tr>
    <td height="35" class="headbold">Kredi Kartı Farkları</td>
    <!-- sil -->
    <td height="35" class="headbold" style="text-align:right;" valign="bottom">
      <!--- Arama --->
      <table>
        <cfform name="search_form" action="#request.self#?fuseaction=bank.list_creditcard_revenue" method="post">
        
        <tr>
          <td style="text-align:right;"><cf_get_lang_main no='48.Filtre'>:</td>
          <td style="text-align:right;"><cfinput type="text" name="keyword" style="width:100px;" value="#attributes.keyword#" maxlength="255">
          </td>
          <td style="text-align:right;"><select name="date_format" style="width:80px;">
              <option value="1" <cfif attributes.date_format eq 1>selected</cfif>>Artan Tarih</option>
              <option value="2" <cfif attributes.date_format eq 2>selected</cfif>>Azalan Tarih</option>
            </select></td>
          <td style="text-align:right;"><select name="branch_ids">
              <option value="">Sube</option>
              <cfoutput query="get_branch">
                <option value="#branch_id#" <cfif attributes.branch_ids eq branch_id>selected</cfif>>#branch_name#</option>
              </cfoutput>
            </select></td>
          <style="text-align:right;"><select name="credit_payment_type_id" style="width:98px;">
              <option value="">Ödeme Yöntemi</option>
              <cfoutput query="get_credit_payments">
                <option value="#payment_type_id#" <cfif attributes.credit_payment_type_id eq payment_type_id>selected</cfif>>#card_no#</option>
              </cfoutput>
            </select></td>
          <style="text-align:right;"><cfsavecontent variable="message"><cf_get_lang_main no='125.Sayi_Hatasi_Mesaj'></cfsavecontent>
            <cfinput type="text" name="maxrows" value="#attributes.maxrows#" required="yes" validate="integer" range="1,999" message="#message#" maxlength="3" style="width:25px;"></td>
          <style="text-align:right;"><input type="image" border="0"  src="/images/ara.gif" onClick="return kontrol();"></td>
          <cf_workcube_file_action pdf='1' mail='1' doc='1' print='1'> </tr>
      </table>
      <!--- Arama --->
    </td>
    <!-- sil -->
  </tr>
</table>
<table cellSpacing="0" cellpadding="0" border="0" width="98%" align="center">
  <tr class="color-border">
    <td>
      <table cellspacing="1" cellpadding="2" width="100%" border="0">
        <tr class="color-list" height="22">
          <td colspan="11" style="text-align:right;">
            <cfif len(attributes.date_1)>
              <cfinput type="text" name="date_1" value="#dateformat(attributes.date_1,dateformat_style)#" maxlength="10" validate="#validate_style#" style="width:65px;" message="Lütfen Tarih Giriniz !">
              <cfelse>
              <cfinput type="text" name="date_1" value="" maxlength="10" validate="#validate_style#" style="width:65px;" message="Lütfen Tarih Giriniz !">
            </cfif>
            <cf_wrk_date_image date_field="date_1">
            <cfif len(attributes.date_2)>
              <cfinput type="text" name="date_2" value="#dateformat(attributes.date_2,dateformat_style)#" maxlength="10" validate="#validate_style#" style="width:65px;" message="Lütfen Tarih Giriniz !">
              <cfelse>
              <cfinput type="text" name="date_2" value="" maxlength="10" validate="#validate_style#" style="width:65px;" message="Lütfen Tarih Giriniz !">
            </cfif>
            <cf_wrk_date_image date_field="date_2"></td>
        </tr>
        </cfform>
		<cfquery name="GET_CREDIT_PAYMENT" datasource="#dsn3#">
			SELECT CREDITCARD_PAYMENT_TYPE.PAYMENT_TYPE_ID, CREDITCARD_PAYMENT_TYPE.CARD_NO, CREDITCARD_PAYMENT_TYPE.GIVEN_POINT_RATE FROM CREDITCARD_PAYMENT_TYPE WHERE IS_ACTIVE = 1 ORDER BY CARD_NO
		</cfquery>        
		<tr class="color-header" height="22">
          <td class="form-title">Ödeme Yöntemi</td>
          <td class="form-title" align="center" colspan="5">Bankalardan Gelen Kredi Kartı Detayı</td>
          <td class="form-title" align="center" colspan="5">Kasa Raporu Kredi Kartı Detayı</td>
          <td class="form-title" align="center">Fark</td>
        </tr>
        <tr class="color-header" height="22">
          <td class="form-title">Ödeme Yöntemi</td>
          <td class="form-title">İşlem Sayısı</td>
          <td class="form-title">Kredili Satış Tutarı</td>
          <td class="form-title">Verilen Puan</td>
          <td class="form-title">Satış Puan</td>
          <td class="form-title">İşlem Sayısı</td>
          <td class="form-title">İşlem Sayısı</td>
          <td class="form-title">Kredili Satış Tutarı</td>
          <td class="form-title">Verilen Puan</td>
          <td class="form-title">Satış Puan</td>
          <td class="form-title">Toplam</td>
          <td class="form-title">Fark</td>
        </tr>
		<cfloop query="GET_STORE_REPORT">
        <cfif get_credit_payment.recordcount>
          <cfscript>
			  topla_1_1_ = 0;
			  topla_2_1_ = 0;
			  topla_3_1_ = 0;
			  topla_4_1_ = 0;
			  topla_5_1_ = 0;
			  topla_6_1_ = 0;
			  topla_7_1_ = 0;
			  topla_8_1_ = 0;
			  topla_1_1__ = 0;
			  topla_2_1__ = 0;
			  topla_3_1__ = 0;
			  topla_4_1__ = 0;
			  topla_5_1__ = 0;
			  topla_6_1__ = 0;
		  </cfscript>
          <cfoutput query="GET_CREDIT_PAYMENT">
            <cfquery name="GET_STORE_POS_BANK_DETAIL" datasource="#DSN2#">
            	SELECT * FROM STORE_POS_BANK_DETAIL WHERE STORE_REPORT_ID = #get_store_report.store_report_id# AND BANK_ID = '#GET_CREDIT_PAYMENT.PAYMENT_TYPE_ID#'
            </cfquery>
            <cfquery name="GET_STORE_POS_BANK" datasource="#DSN2#">
            	SELECT * FROM STORE_POS_BANK WHERE STORE_REPORT_ID = #get_store_report.store_report_id# AND BANK_ID = '#GET_CREDIT_PAYMENT.PAYMENT_TYPE_ID#'
            </cfquery>
            <cfif len(get_store_pos_bank_detail.sales_taksit)>
              <cfset topla_1_1_ = topla_1_1_ + get_store_pos_bank_detail.sales_taksit>
            </cfif>
            <cfif len(get_store_pos_bank_detail.sales_credit)>
              <cfset topla_2_1_ = topla_2_1_ + get_store_pos_bank_detail.sales_credit>
            </cfif>
            <cfif len(get_store_pos_bank_detail.puanli_pesin)>
              <cfset topla_3_1_ = topla_3_1_ + get_store_pos_bank_detail.puanli_pesin>
            </cfif>
            <cfif len(get_store_pos_bank_detail.puanli)>
              <cfset topla_4_1_ = topla_4_1_ + get_store_pos_bank_detail.puanli>
            </cfif>
            <cfif len(get_store_pos_bank_detail.sales_credit)>
              <cfset topla_5_1_ = get_store_pos_bank_detail.sales_credit>
            </cfif>
            <cfif len(get_store_pos_bank_detail.puanli)>
              <cfset topla_5_1_ = topla_5_1_ + get_store_pos_bank_detail.puanli>
            </cfif>
            <cfif len(get_store_pos_bank_detail.puanli_pesin)>
              <cfset topla_5_1_ = topla_5_1_ - get_store_pos_bank_detail.puanli_pesin>
            </cfif>
            <cfset topla_6_1_ = topla_6_1_ + topla_5_1_>
            <cfif len(get_store_pos_bank.sales_taksit)>
              <cfset topla_1_1__ = topla_1_1__ + get_store_pos_bank.sales_taksit>
            </cfif>
            <cfif len(get_store_pos_bank.sales_credit)>
              <cfset topla_2_1__ = topla_2_1__ + get_store_pos_bank.sales_credit>
            </cfif>
            <cfif len(get_store_pos_bank.puanli_pesin)>
              <cfset topla_3_1__ = topla_3_1__ + get_store_pos_bank.puanli_pesin>
            </cfif>
            <cfif len(get_store_pos_bank.puanli)>
              <cfset topla_4_1__ = topla_4_1__ + get_store_pos_bank.puanli>
            </cfif>
            <cfif len(get_store_pos_bank.sales_credit)>
              <cfset topla_5_1__ = get_store_pos_bank.sales_credit>
            </cfif>
            <cfif len(get_store_pos_bank.puanli)>
              <cfset topla_5_1__ = topla_5_1__ + get_store_pos_bank.puanli>
            </cfif>
            <cfif len(get_store_pos_bank.puanli_pesin)>
              <cfset topla_5_1__ = topla_5_1__ - get_store_pos_bank.puanli_pesin>
            </cfif>
            <cfset topla_6_1__ = topla_6_1__ + topla_5_1__>
            <cfset topla_8_1_ = topla_8_1_ + topla_7_1_>
            <cfset topla_7_1_ = topla_5_1__ - topla_5_1_>
            <tr height="20" onMouseOver="this.className='color-light';" onMouseOut="this.className='color-row';" class="color-row">
              <td width="150">#card_no#</td>
              <td>#tlformat(get_store_pos_bank_detail.sales_taksit)#</td>
              <td>#tlformat(get_store_pos_bank_detail.sales_credit)#</td>
              <td>#tlformat(get_store_pos_bank_detail.puanli_pesin)#</td>
              <td>#tlformat(get_store_pos_bank_detail.puanli)#</td>
              <td>#tlformat(topla_5_1_)#</td>
              <td>#tlformat(get_store_pos_bank.sales_taksit)#</td>
              <td>#tlformat(get_store_pos_bank.sales_credit)#</td>
              <td>#tlformat(get_store_pos_bank.puanli_pesin)#</td>
              <td>#tlformat(get_store_pos_bank.puanli)#</td>
              <td>#tlformat(topla_5_1__)#</td>
              <td>#tlformat(topla_7_1_)#</td>
            </tr>
          </cfoutput> <cfoutput>
            <tr class="color-row" height="20">
              <td class="txtboldblue"><cf_get_lang_main no='80.Toplam'></td>
              <td>#tlformat(topla_1_1_)#</td>
              <td>#tlformat(topla_2_1_)#</td>
              <td>#tlformat(topla_3_1_)#</td>
              <td>#tlformat(topla_4_1_)#</td>
              <td>#tlformat(topla_6_1_)#</td>
              <td>#tlformat(topla_1_1__)#</td>
              <td>#tlformat(topla_2_1__)#</td>
              <td>#tlformat(topla_3_1__)#</td>
              <td>#tlformat(topla_4_1__)#</td>
              <td>#tlformat(topla_6_1__)#</td>
              <td>#tlformat(topla_8_1_)#</td>
            </tr>
          </cfoutput>
          <cfelse>
		</cfloop>
          <tr class="color-row">
            <td colspan="5" class="tableyazi">Kayıt Yok</td>
          </tr>
        </cfif>
      </table>
    </td>
  </tr>
</table>
<!--- <cfif (attributes.totalrecords gt attributes.maxrows)>
  <table width="98%" border="0" cellpadding="0" cellspacing="0" align="center" height="35">
    <tr>
      <td><cf_pages 
			  page="#attributes.page#" 
			  maxrows="#attributes.maxrows#" 
			  totalrecords="#attributes.totalrecords#" 
			  startrow="#attributes.startrow#" 
			  adres="bank.list_creditcard_revenue#url_str#"></td>
      <!-- sil -->
      <td height="35" style="text-align:right;"><cfoutput><cf_get_lang_main no='128.Toplam Kayit'>:#attributes.totalrecords# - <cf_get_lang_main no='169.Sayfa'>:#attributes.page#/#lastpage#</cfoutput></td>
      <!-- sil -->
    </tr>
  </table>
  <br/>
</cfif>
 --->
<script type="text/javascript">
	function kontrol()
	{
		if ((search_form.date_1.value.length != 0)&&(search_form.date_2.value.length != 0)&&(search_form.date_1.value > search_form.date_2.value))
			{alert("Baslangiç Tarihi Bitis Tarihinden Büyük !"); return false;}
		else
			search_form.submit();
	}
</script>
 --->
